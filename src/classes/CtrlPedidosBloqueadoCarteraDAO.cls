public with sharing class CtrlPedidosBloqueadoCarteraDAO {
    private static final Integer MAX_CALLOUT_RETRIES = 3;
    private static final Integer WEB_SERVICE_TIMEOUT = 20000;
    private static final String CARTERACLIENTE_WEB_SERVICE_ERROR = 'Error al obtener el inventario de productos. Mensaje: ';
    private static final String CARTERACLIENTE_WEB_SERVICE_NO_DATA_ERROR = 'El servicio web de consulta de cartera de cliente no ha devuelto datos.';
	Private static AggregateResult[] ImporteClientes {get; set;}
    public  static list<CtrlPedidosBloqueadoCartera.PedidosWrapper> ObtenerPedidosRetenidos(Date fecha,Id cliente, string pedido,Id canalFactura, id usuario, date FechaFinal)
    {
    	System.debug('CANALFACTURA:=> '+canalFactura);
      String fieldName = ' ,Name,Folio_Pedido_SDL__c,Fecha_de_Embarque__c,Cliente__r.Name,Cliente__r.Numero_Cliente_SAP__c,Canal__c,Fecha_de_Entrega__c,';
      fieldName +='Account.Name,Motivo_Rechazo_Cartera__c,Cliente__r.Organizacion_de_Ventas__c,Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c,';
      fieldName +='Cliente__r.Sociedad__c,Cliente__r.Canal_Distribucion__c,Cliente__r.Moneda_Cliente__c,Id_Externo__c,Canal_Factura__r.IdPlanta__c,motiv_aprov_recha__c,Numero_de_Pedido_NSC__c,Canal_Factura__r.Codigo__c,Canal_Factura__r.SucursalesViz__c,frontera__c ';
  		String bloqueado = 'N';
  	 	String fechaConsulta = String.valueOf(fecha);
  	 	String dynQuery = 'select Id ' + fieldName + ' From Opportunity ';
  		dynQuery +='WHERE '	;
  		dynQuery += ' Liberado__c =\'' + bloqueado+ '\' ';
      dynQuery += ' and Cancelado_en_SAP__c = false';
      if(FechaFinal == null)
  		{
        dynQuery += ' and Fecha_de_Embarque__c >= ' +fechaConsulta;
      }
      else
      {
        String fechaConsulta2 = String.valueOf(FechaFinal);
        dynQuery += ' and Fecha_de_Embarque__c >= ' +fechaConsulta;
        dynQuery += ' and Fecha_de_Embarque__c <= ' +fechaConsulta2;
      }
      if(cliente != null)
  		{
  			dynQuery += ' And Cliente__c = \'' +  cliente + '\' ';
  		}
  		if(pedido != null)
  		{
  			dynQuery += ' And Folio_Pedido_SDL__c = \'' +  pedido + '\' ';
  		}
  		if(canalFactura != null)
  		{
  			dynQuery += '  And Canal_Factura__c = \'' +  canalFactura + '\' ';
  		}
      if(usuario != null)
  		{
  			dynQuery += '  And Cliente__r.OwnerId = \'' +  usuario + '\' ';
  		}

  		set<Id> setOpp = new set<Id>();
  		set<Id> setClienteId = new set<Id>();
      System.debug('dynQuery :: '+dynQuery);
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
   private static list<CtrlPedidosBloqueadoCartera.PedidosWrapper> llenarListaPedidos(list<opportunity> listaOportunidades,AggregateResult[] ImportePedidos)
    {
    	CtrlPedidosBloqueadoCartera.PedidosWrapper wp;
    	list<CtrlPedidosBloqueadoCartera.PedidosWrapper> listaPedidos = new list<CtrlPedidosBloqueadoCartera.PedidosWrapper>();
    	map<Id,list<CtrlPedidosBloqueadoCartera.PedidosWrapper>> mapClientImport = new map<Id,list<CtrlPedidosBloqueadoCartera.PedidosWrapper>>();
    	double importeSF=0;
    	for(Opportunity opp :listaOportunidades)
    	{

    			wp = new CtrlPedidosBloqueadoCartera.PedidosWrapper();
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
    			/*if(mapClientImport.containsKey(opp.Cliente__c) && wp.Importe != null)
    				{
    					system.debug('opp.Id:: '+ opp.Id);
    					mapClientImport.get(opp.Cliente__c).add(wp);
    				}
    				else
    				{

    					mapClientImport.put(opp.Cliente__c,new list<CtrlPedidosBloqueadoCartera.PedidosWrapper>());
    					mapClientImport.get(opp.Cliente__c).add(wp);

   				    }
    			 */
    		if(opp.Cliente__r.Canal_de_Distribucion_NSC__c == null || opp.Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c == null)
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

    	double importeOpp = 0;
    	for(CtrlPedidosBloqueadoCartera.PedidosWrapper wr : listaPedidos)
    	{
    		if(mapClientImport.containsKey(wr.pedido.Cliente__c))
    		{
    			importeOpp = 0;
	    		for(CtrlPedidosBloqueadoCartera.PedidosWrapper pwr : mapClientImport.get(wr.pedido.Cliente__c))
	    		{
	    			importeOpp += pwr.importe;
	    		}
    			wr.SaldoSF = importeOpp;
    		}
    	}
    	return listaPedidos;
    }
    private static AggregateResult[] CalcularImportes(set<Id>setOpp )
    {
    	return [select opportunityId,sum(Importe__c) FROM OpportunityLineItem where opportunityId in : setOpp GROUP BY opportunityId];
    }
   private static AggregateResult[] CalcularImportesClientes(set<Id>setOpp )
    {
    	return [select Opportunity.Cliente__c,sum(Importe__c) FROM OpportunityLineItem where opportunityId in : setOpp GROUP BY Opportunity.Cliente__c];
    }
    private static AggregateResult[] ObtenerClientes(set<Id>setClienteId)
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
    public static CarteraClienteQueryNSCWS.Cartera retrieveCarteraCliente(Integer cliente, Integer canal, String orgVenta) {
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
   Public static Boolean RecharzarPedidos(list<CtrlPedidosBloqueadoCartera.PedidosWrapper> listaPedidos)
   {
   		Boolean Valido = false;
   		map<string,opportunity> mapValidos = new map<string,opportunity>();
    	for(CtrlPedidosBloqueadoCartera.PedidosWrapper wp :listaPedidos )
    	{
    		if(wp.Seleccionado)
    		{
    			if(wp.Pedido.motiv_aprov_recha__c != '')
    			{
    				system.debug('wp.Pedido.motiv_aprov_recha__c:: '+ wp.Pedido.motiv_aprov_recha__c);
	    			wp.Pedido.fecha_aprov_recha__c = Datetime.Now().Date();
	    			mapValidos.put(wp.Pedido.Id,wp.Pedido);
	    			Valido = true;
    			}
    			else
    			{
    				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Favor de capturar el motivo de rechazo/aprobación'));
    				return true;
    			}
    		}
     	}
     	if(mapValidos.size() > 0)
     	{
     		update mapValidos.values();
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Se rechazo con éxito el pedido'));
     	}
     	return Valido;
   }

   public static Boolean IsLocked(list<CtrlPedidosBloqueadoCartera.PedidosWrapper> listaPedidos)
   {
        Boolean Valido = false;
       for(CtrlPedidosBloqueadoCartera.PedidosWrapper wp :listaPedidos )
       {
         if(wp.Seleccionado)
         {
             if(Approval.isLocked(wp.Pedido.Id))
             {
                 Valido = true;
             }

         }
       }
       return valido;
   }
    public static Boolean ValidarCarteraWs(list<CtrlPedidosBloqueadoCartera.PedidosWrapper> listaPedidos)
    {
   		 Boolean Valido = false;
 	try	{
	    	PedidosOtrosCanalesUtils.ValidacionCredito esvalido;
	    	map<string,opportunity> mapValidos = new map<string,opportunity>();
	    	for(CtrlPedidosBloqueadoCartera.PedidosWrapper wp :listaPedidos )
	    	{
	    		if(wp.Seleccionado)
	    		{
	    			mapValidos.put(wp.Pedido.Id,wp.Pedido);	
	    		}
	     	}
	    	WsLiberacionPedidosCarteraLegados.LiberacionPedidosCarteraPSVSoap Services = new WsLiberacionPedidosCarteraLegados.LiberacionPedidosCarteraPSVSoap();
	    	list<opportunity> listaOpp = new list<opportunity>();
	    	String mensaje ='';
	    	String canal ='';
	    	Boolean isBodega = false;
	    	
	    	for(opportunity opp : mapValidos.values())
	    	{
	    		system.debug('opp.Canal_Factura__r.IdPlanta__c ----------------------------> '+opp.Canal_Factura__r.IdPlanta__c);
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
	    		WsLiberacionPedidosCarteraLegados.DatosLiberacionPedido DatosLiberacionPedido = new WsLiberacionPedidosCarteraLegados.DatosLiberacionPedido();
	    		
		    		if(opp.Canal_Factura__r.IdPlanta__c  !=null)
	        		{
		    			// se obtiene el canal de distribucion si es frontera o no.
					    	string suc = 'SUC - ';
				            List<String> ListaSucursalesFrontera = new List<String>();
				            ListaSucursalesFrontera.addAll(opp.Canal_Factura__r.SucursalesViz__c.split(';'));
				            System.debug('ListaSucursalesFrontera: '+ListaSucursalesFrontera);
				            String ClienteViz = PedidosOtrosCanalesUtils.ValidarSucursalViz(ListaSucursalesFrontera,opp.frontera__c);
				            System.debug('ClienteViz: '+ClienteViz);
				            if(String.isNotBlank(ClienteViz))
				            {
				                
				                Account sucViz = PedidosOtrosCanalesUtils.buscarSucViz(suc+ClienteViz.leftPad(10, '0'));
				                if(sucViz != null && sucViz.Canal_de_Distribucion_NSC__c != null)
				                {
				                    DatosLiberacionPedido.CanalDistribucion = Integer.ValueOf(sucViz.Canal_de_Distribucion_NSC__r.Codigo__c);
				                    
				                }
				            }
				        }else
				        {
				          DatosLiberacionPedido.CanalDistribucion = Integer.ValueOf(opp.Canal_Factura__r.Codigo__c);
				        }
				        
			    if(DatosLiberacionPedido.CanalDistribucion == null || DatosLiberacionPedido.CanalDistribucion == 0)
	    		{
	    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'El cliente no cuenta con canal de distribucion'));
	    			return null;
	    		}else
	    		{	    			
	    			
	    			    			
	    			System.debug('DatosLiberacionPedido:=> Canal_Distribucion__c: ' + DatosLiberacionPedido.CanalDistribucion  + ' opp.Folio_Pedido_SDL__c ' + opp.Folio_Pedido_SDL__c +' opp.Numero_de_Pedido_NSC__c '+opp.Numero_de_Pedido_NSC__c);		
		    		DatosLiberacionPedido.FolioPSV = opp.Folio_Pedido_SDL__c;
		    		DatosLiberacionPedido.FolioNSC = opp.Numero_de_Pedido_NSC__c == null ? '0' :opp.Numero_de_Pedido_NSC__c;
		    		DatosLiberacionPedido.Tipo =  canal;
		    		DatosLiberacionPedido.Usuario = ObtenerUsuario();
		    		System.debug('DatosLiberacionPedido:=> ' + DatosLiberacionPedido);		    		
		    		WsLiberacionPedidosCarteraLegados.RespuestaBase Response = Services.LiberarPedidoCartera(DatosLiberacionPedido);
		    		system.debug('Response ----------------------------> '+Response);
		    		if(Response == null || Response.Tipo !='TerminadoConExito')
		    		{
		    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Response.Mensaje));
		    			return Valido;
		    		}
		    		else
		    		{
		    			for(CtrlPedidosBloqueadoCartera.PedidosWrapper wp: listaPedidos)
		    			{
		    				if(wp.seleccionado)
		    				{
		    					wp.liberado = true;
		    				}
		    			}
		    			Valido = true;
		    			mensaje = 'Se liberó con éxito el pedido.';
		    			opp.Liberado__c = 'S';
		    			listaOpp.add(opp);
		    		}    			 
	    		}		    
	    	}
	    	if(listaOpp.size() > 0)
	    	{
	    		upsert listaOpp;
	    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, mensaje));
	    	}

    	}catch(Exception e) 
		{                
		   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Ocurrió un problema al liberar el pedido. Favor de intentar de nuevo.'));                
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