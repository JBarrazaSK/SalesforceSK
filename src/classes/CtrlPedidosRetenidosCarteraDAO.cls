public with sharing class CtrlPedidosRetenidosCarteraDAO {
	private static final Integer MAX_CALLOUT_RETRIES = 3;
    private static final Integer WEB_SERVICE_TIMEOUT = 20000;
    private static final String CARTERACLIENTE_WEB_SERVICE_ERROR = 'Error al obtener el inventario de productos. Mensaje: ';
    private static final String CARTERACLIENTE_WEB_SERVICE_NO_DATA_ERROR = 'El servicio web de consulta de cartera de cliente no ha devuelto datos.';
    private static AggregateResult[] ImporteClientes {get; set;}

    public  static list<CtrlPedidosRetenidosCartera.PedidosWrapper> ObtenerPedidosRetenidos(Date fecha,Id cliente, Date fechaFinal,Id canalFactura,string pedido, id usuario)
    {
		    String fieldName = ',Name,Folio_Pedido_SDL__c,Fecha_de_Embarque__c,Cliente__r.Name,Cliente__r.Numero_Cliente_SAP__c,Canal__c,Fecha_de_Entrega__c,';
		    fieldName +='Motivo_Rechazo_Cartera__c,Cliente__r.Organizacion_de_Ventas__c,Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c,';
		    fieldName +='Cliente__r.Sociedad__c,Cliente__r.Canal_Distribucion__c,Cliente__r.Moneda_Cliente__c,Id_Externo__c,Canal_Factura__r.IdPlanta__c,Account.Name, Numero_Pedido_SAP__c';
				String bloqueado = 'N';
			 	String fechaInicial = String.valueOf(fecha);
				String fechaEmbFinal   = String.valueOf(fechaFinal);
			 	String dynQuery = 'select Id ' + fieldName + ' From Opportunity ';
				dynQuery +='WHERE '	;
				dynQuery += ' Liberado__c =\'' + bloqueado+ '\' ';
				dynQuery += ' and Cancelado_en_SAP__c = false';
				if(fechaFinal == null)
						dynQuery += ' and Fecha_de_Embarque__c >= ' +fechaInicial;
				else
				{
					dynQuery += ' and Fecha_de_Embarque__c >= ' +fechaInicial;
					dynQuery += ' and Fecha_de_Embarque__c <= ' +fechaEmbFinal;
				}
				if(pedido != null)
						dynQuery += ' And Folio_Pedido_SDL__c = \'' +  pedido + '\' ';

				if(cliente != null)
						dynQuery += ' And Cliente__c = \'' +  cliente + '\' ';
				if(usuario != null)
				{
						dynQuery += '  And Cliente__r.OwnerId = \'' +  usuario + '\' ';
				}
				if(canalFactura != null)
						dynQuery += '  And Canal_Factura__c = \'' +  canalFactura + '\' ';

						dynQuery += ' and Numero_de_Pedido_NSC__c = null';

		set<Id> setOpp = new set<Id>();
		set<Id> setClienteId = new set<Id>();
		system.debug('QUERY=> '+ dynQuery);
		list<opportunity> listaOportunidades = Database.query(dynQuery);
		for(Opportunity opp :listaOportunidades)
		{
			setOpp.add(opp.Id);
			setClienteId.add(opp.Cliente__c);
		}
		AggregateResult[] ImportePedidos = CalcularImportes(setOpp);
	  ImporteClientes = ObtenerClientes(setClienteId);

		return llenarListaPedidos(listaOportunidades,ImportePedidos);
    }
    private static list<CtrlPedidosRetenidosCartera.PedidosWrapper> llenarListaPedidos(list<opportunity> listaOportunidades,AggregateResult[] ImportePedidos)
    {
    	CtrlPedidosRetenidosCartera.PedidosWrapper wp;
    	list<CtrlPedidosRetenidosCartera.PedidosWrapper> listaPedidos = new list<CtrlPedidosRetenidosCartera.PedidosWrapper>();
    	map<Id,list<CtrlPedidosRetenidosCartera.PedidosWrapper>> mapClientImport = new map<Id,list<CtrlPedidosRetenidosCartera.PedidosWrapper>>();
			double importeSF=0;
    	for(Opportunity opp :listaOportunidades)
    	{
    			wp = new CtrlPedidosRetenidosCartera.PedidosWrapper();
    			wp.Seleccionado = false;
    			wp.Pedido = opp;

    			for(AggregateResult ar :ImportePedidos)
    			{
    				if(ar.get('OpportunityId') == opp.Id)
    				{
    					wp.Importe = (Decimal)ar.get('expr0');
    				}

    			}
    			importeSF  = 0;
    			for(AggregateResult ar2 :ImporteClientes)
    			{
    				if(ar2.get('Cliente__c') == opp.Cliente__c)
    				{
    					importeSF += (Decimal)ar2.get('expr0');
    				}
    			}
    			wp.SaldoSF = importeSF;

    		if(opp.Cliente__r.Canal_de_Distribucion_NSC__c == null ||opp.Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c == null)
    		{
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'El cliente no cuenta con canal de distribucion'));
    			return null;
    		}
    		if(opp.Cliente__r.Organizacion_de_Ventas__c == null)
    		{
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'El cliente no cuenta con organizacion de ventas'));
    			return null;
    		}

    		 String orgVenta = opp.Cliente__r.Organizacion_de_Ventas__c.trim();
             orgVenta = orgVenta.right(4);

             CarteraClienteQueryNSCWS.Cartera cartera  = retrieveCarteraCliente(Integer.valueOf(opp.Cliente__r.Numero_Cliente_SAP__c), Integer.valueOf(opp.Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c), orgVenta);
             if(cartera != null)
             {
             	wp.SaldoActual = cartera.SaldoActual;
             	wp.SaldoVencido = cartera.SaldoVencido;
             	wp.DocumentosVencidos = cartera.DocumentosVencidos;
             	wp.LimiteDeCredito = cartera.LimiteDeCredito;
             	wp.CreditoDisponible = cartera.SaldoActual;
             	wp.SaldoPedidos = cartera.SaldoPedidos;
             }
			listaPedidos.add(wp);
    	}

    	return listaPedidos;
    }
    private static CarteraClienteQueryNSCWS.Cartera retrieveCarteraCliente(Integer cliente, Integer canal, String orgVenta) {
        CarteraClienteQueryNSCWS.CarteraClientesSoap request = new CarteraClienteQueryNSCWS.CarteraClientesSoap();
        request.timeout_x = WEB_SERVICE_TIMEOUT;
        for(Integer i=1; i<=MAX_CALLOUT_RETRIES; i++) {
            try {
                return request.RegresaCartera(cliente, canal, orgVenta).Datos.Cartera[0];
            } catch(Exception e) {
                if(i == MAX_CALLOUT_RETRIES) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, CARTERACLIENTE_WEB_SERVICE_ERROR+e.getMessage()));
                }
            }
        }
        return new CarteraClienteQueryNSCWS.Cartera();
    }

    public static AggregateResult[] CalcularImportes(set<Id>setOpp )
    {
    	return [select opportunityId,sum(Importe__c) FROM OpportunityLineItem where opportunityId in : setOpp GROUP BY opportunityId];
    }
    public static AggregateResult[] CalcularImportesClientes(set<Id>setOpp )
    {
    	return [select Opportunity.Cliente__c,sum(Importe__c) FROM OpportunityLineItem where opportunityId in : setOpp GROUP BY Opportunity.Cliente__c];
    }
    public static AggregateResult[] ObtenerClientes(set<Id>setClienteId)
    {
    	String fieldName = ',Name,Folio_Pedido_SDL__c,Fecha_de_Embarque__c,Cliente__r.Name,Cliente__r.Numero_Cliente_SAP__c,Canal__c,Fecha_de_Entrega__c,';
    	fieldName +='Motivo_Rechazo_Cartera__c,Cliente__r.Organizacion_de_Ventas__c,Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c,';
    	fieldName +='Cliente__r.Sociedad__c,Cliente__r.Canal_Distribucion__c,Cliente__r.Moneda_Cliente__c,Id_Externo__c,Canal_Factura__r.IdPlanta__c,Account.Name ';

		Configuracion_Cartera__c Configuracion_Cartera = Configuracion_Cartera__c.getInstance();
		Decimal Dias = Configuracion_Cartera.Dias_Saldo__c;

		String bloqueado = 'N';
		date FechaActual = Date.today();
		date fechaFutura = FechaActual.addDays(integer.valueOf(Dias));
		System.debug('Dias:: '+ Dias);
		System.debug('fechaFutura:: '+ fechaFutura);
		System.debug('fecha Actual:: '+ Date.today());
	 	String fechaConsulta = String.valueOf(Date.today());
		String fechaConsulta2 = String.valueOf(fechaFutura);
	 	String dynQuery = 'select Id ' + fieldName + ' From Opportunity ';
		dynQuery +='WHERE '	;
		dynQuery += ' Cancelado_en_SAP__c = false';
		dynQuery += ' and Numero_de_Pedido_NSC__c = null';
		dynQuery += ' and Fecha_de_Embarque__c >= ' +fechaConsulta;
		dynQuery += ' and Fecha_de_Embarque__c <= ' +fechaConsulta2;
		dynQuery += ' and Cliente__c in : XXX';

		set<Id> setOpp = new set<Id>();
		system.debug('dynQuery:: '+dynQuery);
		list<opportunity> listaOportunidades = Database.query(dynQuery.replace('XXX','setClienteId'));
		for(Opportunity opp :listaOportunidades)
		{
			setOpp.add(opp.Id);

		}
			System.debug('setClienteId:: '+setClienteId);
			System.debug('setOpp:: '+setOpp);
			AggregateResult[] ImportePedidos = CalcularImportesClientes(setOpp);
			return ImportePedidos;
    }
    public static Boolean ValidarCarteraWs(list<CtrlPedidosRetenidosCartera.PedidosWrapper> listaPedidos)
    {
    	Boolean Valido = false;
    	PedidosOtrosCanalesUtils.ValidacionCredito esvalido;
    	map<string,opportunity> mapValidos = new map<string,opportunity>();
    	for(CtrlPedidosRetenidosCartera.PedidosWrapper wp :listaPedidos )
    	{
    		if(wp.Seleccionado)
    		{
    			Valido = true;
    			String Moneda = wp.Pedido.Cliente__r.Moneda_Cliente__c.trim();
    			String Sociedad = wp.pedido.Cliente__r.Sociedad__c.trim();
    			Sociedad = Sociedad.right(3);
            	Moneda = Moneda.right(4).Trim();
            	string Canal = wp.Pedido.Cliente__r.Canal_Distribucion__c.trim();
            	Canal = Canal.right(2);
							if(wp.SaldoSF == null || wp.SaldoSF == 0)
							{
									wp.SaldoSF = wp.importe;
							}
    			esvalido = PedidosOtrosCanalesUtils.validarCredito(String.valueOf(Integer.valueOf( wp.pedido.Cliente__r.Numero_Cliente_SAP__c )),
    																				'',
    																				Double.valueOf(wp.SaldoSF),
    																				Moneda,
    																				Sociedad,
    																				Integer.valueOf(wp.Pedido.Id_Externo__c),
    																				Canal);
   				system.debug('esvalido ----------> '+esvalido);
    			if(esvalido != null)
    			{
    				wp.Liberado = esvalido.aprobado;
    				if(wp.Liberado)
    					mapValidos.put(wp.Pedido.Id,wp.Pedido);
    				else
	    			{
	    				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, esvalido.Mensaje));
	    				return Valido;
	    			}
    			}

    		}
    	}
    	
    	//WsLiberacionPedidosCarteraPSV.LiberacionPedidosCarteraPSVSoap Services = new WsLiberacionPedidosCarteraPSV.LiberacionPedidosCarteraPSVSoap();
    	WsLiberacionPedidosCarteraLegados.LiberacionPedidosCarteraPSVSoap Services = new WsLiberacionPedidosCarteraLegados.LiberacionPedidosCarteraPSVSoap();
    	list<opportunity> listaOpp = new list<opportunity>();
    	String mensaje ='';
    	String canal ='';
    	Boolean isBodega = false;
    	WsABCPeidosSFSAP.ABCPedidosSF_SAPSoap request = new WsABCPeidosSFSAP.ABCPedidosSF_SAPSoap();
    	ApexPages.Message myMsg =  null;    
    	for(opportunity opp : mapValidos.values())
    	{   		
    		ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista result = new ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista();
   			WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_ReqLista pedidoWSArray = new WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_ReqLista();
    			
        	result.SALES_HEADER_IN = new ABCPedidos_SF_to_ECC.SALES_HEADER_IN_element();        
        	result.SALES_HEADER_IN.FolioPedidoSAP 			= opp.Numero_Pedido_SAP__c;
        	result.SALES_HEADER_IN.FolioPedidoSalesForce	= 'FL'+opp.Id_Externo__c;
        	result.SALES_HEADER_IN.Estatus 					= 'R';
        	
    		pedidoWSArray.DT_SE_ABCPedidos_ReqLista = new list<ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista>{result};
			WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido  respuesta = request.EnviarInformacionASap(pedidoWSArray);
			
			// Si responde  != null y mensaje sea S y el estatus sea Dif de B. Es Liberado.
			
			if (respuesta.DT_SE_ABCPedidos_RespPedido != null)
        	{ 
    			if(respuesta.DT_SE_ABCPedidos_RespPedido[0].TipoMensaje == 'S' 
    						&& respuesta.DT_SE_ABCPedidos_RespPedido[0].Estatus != 'B')
    			{
					if(opp.Canal_Factura__r.IdPlanta__c == null)
		    		{
		    			isBodega = true;
		    		}
	    			canal = opp.Canal__c;
	    			if(canal != 'A')
					{
						if(Canal == 'E' && isBodega)
						{
							canal = 'B';
						}
						else if(isBodega)
						{
							canal = 'N';
						}
					}
		
		    		opp.fecha_aprov_recha__c = Datetime.Now().Date();		    		
		    		if(opp.Cliente__r.Canal_de_Distribucion_NSC__c == null ||opp.Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c == null)
		    		{
		    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'El cliente no cuenta con canal de distribucion'));
		    			return null;
		    		}else{
			    		WsLiberacionPedidosCarteraLegados.DatosLiberacionPedido DatosLiberacionPedido = new WsLiberacionPedidosCarteraLegados.DatosLiberacionPedido();
			    		DatosLiberacionPedido.FolioPSV = opp.Folio_Pedido_SDL__c;
			    		DatosLiberacionPedido.FolioNSC = opp.Numero_de_Pedido_NSC__c;
			    		DatosLiberacionPedido.CanalDistribucion = Integer.valueOf(opp.Cliente__r.Canal_Distribucion__c);
			    		DatosLiberacionPedido.Tipo =  canal;
			    		DatosLiberacionPedido.Usuario = ObtenerUsuario();
			    				    		
			    		System.debug('DatosLiberacionPedido:=> ' + DatosLiberacionPedido);
			    		WsLiberacionPedidosCarteraLegados.RespuestaBase Response = Services.LiberarPedidoCartera(DatosLiberacionPedido);
		    		
			    		if(Response == null || Response.Tipo !='TerminadoConExito')
			    		{
			    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Response.Mensaje));
			    			return Valido;
			    		}
			    		else
			    		{
			    			mensaje = Response.Mensaje;
			    			opp.Liberado__c = 'S';
			    			listaOpp.add(opp);
			    		}
		    		}
    				
    			}else{
    				 myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,respuesta.DT_SE_ABCPedidos_RespPedido[0].Mensaje);
    			
    			}
    			ApexPages.addMessage(myMsg);
        	}
    	}
    	if(listaOpp.size() > 0)
    	{
    		upsert listaOpp;
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, mensaje));
    	}

    	 return Valido;

    }
    public static string ObtenerUsuario()
	{
		String usuario = '';
		if(UserInfo.getFirstName() != null)
		{
			usuario += UserInfo.getFirstName().split(' ')[0].left(1);
		}
		if(UserInfo.getLastName() != null)
		{
			usuario += UserInfo.getLastName().split(' ')[0];

		}
		system.debug('Generar usuario -------------> '+usuario);
		return  usuario;
	}
}