public with sharing class  ctrlMigrarPedidos {

	public pedido__c pedido {get; set;}
	public String CodigoAlmacen {get; set;}
    public String NombreAlmacen {get; set;}
    public Id AlmacenId {get; set;}
    public String Display{get; set;}
    public list<pedido__c> Lpedidos {get; set;}
    public list<pedidoWrapper> Listapedidos {get; set;}
    public set<string> setPedidos {get; set;}
    public set<string> setAccount {get; set;}
    public Map<String, Oficina_de_Venta__c> MapAlmacenes {
        get {
            if(MapAlmacenes == null) {

                MapAlmacenes = CtrlArmarEmbarqueDAO.getOficinaVentas();
             }
            return MapAlmacenes;
        }
        set;
    }
    
    public void getPedidos()
    {
    	Lpedidos = [select Id, Canal__c, Costo_de_Flete__c, CreatedDate, Cuenta__c, DepartamentoOrdenCompra__c, EstatusPedido__c, Factura__c, Factura_No_Fiscal__c, Fecha_de_Entrega__c, Fecha_Registro__c, FechaSurtidoProgramada__c, Forma_Pago__c, MotivoAutorizacion__c,
            Muestra__c, Name, Numero_de_Pedido_NSC__c, Observacion__c, Orden_de_Compra__c, Pedido_Cancelado__c, Pedido_Cliente__c, PedidoAceptado__c, PedidoCanceladoPorElSistema__c, PedidoRechazado__c, Prospecto__c, RequiereAutorizacion__c, TipoAutorizacionRemota__c,
            TipoSurtido__c, CreatedBy.Username, Organizacion_de_Ventas__c, OficinaVentas__r.Codigo__c,
            OficinaVentas__r.Name,Numero_Pedido_SAP__c,Prospecto__r.Id_prospecto_sap__c,IdExterno__c,Cuenta__r.name,
            OficinaVentas__r.Opera_en_SAP__c,Forma_Pago_Original__c from pedido__c 
						where 
						Pedido_Cancelado__c = false
						and PedidoRechazado__c = false
						and OficinaVentas__c =: AlmacenId
						and Fecha_de_Entrega__c >= today
						and Numero_Pedido_SAP__c = null
						and Fecha_de_Entrega__c  <= NEXT_N_DAYS: 5 ];
		
		setPedidos = new set<string>();
		setAccount = new set<string>();
		pedidoWrapper pw = new pedidoWrapper(); 
		Listapedidos = new list<pedidoWrapper>();
		for(pedido__c p : Lpedidos)
		{
			setPedidos.add(p.Id);
			setAccount.add(p.Cuenta__c);
			pw = new pedidoWrapper(); 
			pw.pedido = p;
			Listapedidos.add(pw);
		}
    }
    public void GuardarPedido()
    {
    	map<string,Account> mapClientes = TraerClientes(setAccount);
    	map<string,list<PedidoItem__c>> mapDetalle = TraerDetallePedido(setPedidos);
    	PedidoUtils clase = new PedidoUtils();
    	ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista pedidoWS = null; 
        WsABCPeidosSFSAP.ABCPedidosSF_SAPSoap request = new WsABCPeidosSFSAP.ABCPedidosSF_SAPSoap();
        WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_ReqLista pedidoWSArray = new WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_ReqLista();
        list<pedido__c> listaAGuardar = new list<pedido__c> ();
    	
    	for(pedidoWrapper p : listapedidos)
    	{
    		pedidoWS = SetPedido(p.pedido,mapDetalle.get(p.pedido.id), mapClientes.get(p.pedido.cuenta__c));
    		pedidoWSArray.DT_SE_ABCPedidos_ReqLista = new list<ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista>{pedidoWS}; 
    		system.debug('pedidoWSArray: '+ pedidoWSArray );
    		WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido response = request.EnviarInformacionASap(pedidoWSArray);
    		if (response.DT_SE_ABCPedidos_RespPedido != null)
        	{  
        		for(Integer i = 0; i<response.DT_SE_ABCPedidos_RespPedido.size();i++ )
        		{     			
					if((response.DT_SE_ABCPedidos_RespPedido[i].Estatus != null 
							&& response.DT_SE_ABCPedidos_RespPedido[i].Estatus != 'C') 
		        			&& (response.DT_SE_ABCPedidos_RespPedido[i].TipoMensaje == 'S') 
		        				|| (response.DT_SE_ABCPedidos_RespPedido[i].TipoMensaje == 'W' // Ocurrio un problema de credito en SAP pero el pedido se ha creado,
		        						&& response.DT_SE_ABCPedidos_RespPedido[i].Estatus == 'A')) // por lo tanto el salesforce tambien se crea.
		        	{
		        			 if(response.DT_SE_ABCPedidos_RespPedido[i].Estatus != null)
					            {
					            	p.pedido.EstatusPedido__c =  '1 - Pedido Colocado';
					             	p.pedido.RequiereAutorizacion__c = response.DT_SE_ABCPedidos_RespPedido[i].Estatus == 'B' ? true : false;
					            }
					            else
					            	 p.pedido.EstatusPedido__c = '1 - Pedido Colocado';
					            	 
					            p.pedido.Numero_Pedido_SAP__c = response.DT_SE_ABCPedidos_RespPedido[i].FolioPedidoSAP;
					            p.pedido.IdExterno__c = response.DT_SE_ABCPedidos_RespPedido[i].FolioPedidoSalesforce;
					            p.Mensaje = response.DT_SE_ABCPedidos_RespPedido[i].Mensaje;
					            p.Folio = response.DT_SE_ABCPedidos_RespPedido[i].FolioPedidoSAP;
					            listaAGuardar.add(p.pedido);
		        	}	        	
		        	if(response.DT_SE_ABCPedidos_RespPedido[i].TipoMensaje == 'E' )
		        	{
		        		  p.Mensaje = response.DT_SE_ABCPedidos_RespPedido[i].Mensaje;
		        	}
		        	else if(response.DT_SE_ABCPedidos_RespPedido[i].TipoMensaje == 'W' )
		        	{	        		
		        		  p.Mensaje = response.DT_SE_ABCPedidos_RespPedido[i].Mensaje;
		        	}		        	     
	            } 	         
        	}
        	
    	}
    	
    	if(listaAGuardar.size() > 0)
    	{
    		upsert listaAGuardar;
    	}
    	
    	
    }
    public map<string,Account> TraerClientes(set<string> setAccount)
    {
    	map<string,Account> mapDetalle = new map<string,Account>();
    	
    	for(account a : [select Id, Cadena__c, Canal_Distribucion__c, Canal_Padre__c, Correo_Electronico__c,
                DiasEntrega__c, Name, Numero_Cliente_SAP__c, Organizacion_de_Ventas__c,
                Ramo__c, RFC_Generico__c, Territorio__c,
                Canal_de_Distribucion_NSC__r.Codigo__c, Canal_de_Distribucion_NSC__r.Name,
                Parent.Numero_Cliente_SAP__c, Parent.Tipo_de_Credito__c, Parent.RFC__c,
                Parent.RFC_Generico__c,
            	Oficina_de_Ventas__r.Codigo__c,
                Tipo_Surtido__c,
                RecordType.Name,Sector__c from account where id in : setAccount])
    	{
    		mapDetalle.put(a.id,a);
    	}
    	return mapDetalle;
    }
    public map<string,list<PedidoItem__c>> TraerDetallePedido(set<string> setPedidos)
    {
    	list<PedidoItem__c> listaDetalle = new list<PedidoItem__c>();
    	list<PedidoItem__c> listaD = new list<PedidoItem__c>();
    	map<string,list<PedidoItem__c>> mapDetalle = new map<string,list<PedidoItem__c>>();
    	
    	listaDetalle = [select Cajas__c, Cajas_Conf__c,
             CantidadConfirmadaUnidadMovimiento__c, CantidadPedidaUnidadMovimiento__c,
             Kilos__c, Kilos_Conf__c,
             Piezas__c, Piezas_Conf__c,
             Cantidad_Balanceada_Unidad_de_Movimiento__c, Cajas_Balanceadas__c, Piezas_Balanceadas__c,Kilos_Balanceados__c,TipoPrecio__c,
             Importe__c, Moneda__c, Pedido__c, PrecioListaPrecios__c, PrecioUnitarioOriginal__c, PrecioUnitarioOtorgado__c, Producto__c, TipoCambio__c, Unidad__c, Precio_Requiere_Aprobacion__c, Precio_Aprobado_Supervisor__c, Precio_Aprobado_Pr__c,
             Producto__r.Description, Producto__r.Peso_Promedio__c, Producto__r.ProductCode,Tipo_Precio__c
    					from PedidoItem__c where Pedido__c IN : setPedidos];
    					
    	set<string> setContains = new set<string>();
    	for(string pedido : setPedidos)
    	{
    		listaD = new list<PedidoItem__c>();
    		for(PedidoItem__c pd : listaDetalle)
    		{
    			if(!setContains.contains(pd.Pedido__c))
    			{
    				if(pd.Pedido__c == pedido)
    				{
    					listaD.add(pd);
    				}
    			}
    		}
    		mapDetalle.put(pedido,listaD);
    		setContains.add(pedido);
    	}	
    	return 	mapDetalle;		
    }
    public ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista  SetPedido(pedido__c pedido, list<PedidoItem__c> listaProductos, account cuenta)
    {
    		boolean Balanceo = false;
    	
    	    ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista result = new ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista();

        	result.SALES_HEADER_IN = new ABCPedidos_SF_to_ECC.SALES_HEADER_IN_element();        	
        	if(!String.isBlank(pedido.Numero_Pedido_SAP__c))
        		result.SALES_HEADER_IN.FolioPedidoSAP 		= pedido.Numero_Pedido_SAP__c;
        	result.SALES_HEADER_IN.FolioPedidoSalesForce	= generateIdPedidoSF();
        	result.SALES_HEADER_IN.OrganizacionVentas 		= cuenta.Organizacion_de_Ventas__c.right(4);
        	result.SALES_HEADER_IN.OficinaVentas			= pedido.OficinaVentas__r.Codigo__c;	
        	result.SALES_HEADER_IN.CanalDistribucion		= 'DT';//pedidoWrapper.pedido.Canal__c;
        	result.SALES_HEADER_IN.Sector					= cuenta.Sector__c.right(2);
        	result.SALES_HEADER_IN.FechaSurtido 			= pedido.FechaSurtidoProgramada__c.format('yyyyMMdd');
        	result.SALES_HEADER_IN.OrdenCompraCliente		= pedido.Orden_de_Compra__c;
        	result.SALES_HEADER_IN.NumeroPedidoSalesForce 	= pedido.Name;
        	result.SALES_HEADER_IN.Estatus 					= (!String.isBlank(pedido.Numero_Pedido_SAP__c))?'U':'I';
        	
        	result.SALES_HEADER_IN.TipoPago = ''; 
        	if(pedido.Forma_Pago_Original__c == '2 - Crédito')
        	{
        		if(pedido.Forma_Pago_Original__c != pedido.Forma_Pago__c)
        		{
        			result.SALES_HEADER_IN.TipoPago = 'D000';
        		}
        	}
        	system.debug('FORMA DE PAGO=> '+ result.SALES_HEADER_IN.tipoPedido );
            
            result.SALES_HEADER_IN.tipoPedido =  pedido.TipoSurtido__c.left(1);
        	
        	//result.SALES_HEADER_IN.DOC_TYPE = 'ZORC';ubtwf

        	result.SALES_ITEMS_IN 		= new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaITEMS_Linea();
        	result.SALES_PARTNERS 		= new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaPARTNERS_Linea();
        	result.SALES_CONDITIONS_IN 	= new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaCONDITIONS_Linea();
        	result.SALES_TEXT 			= new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaTEXT_Linea();
        	result.SALES_SCHEDULES_IN 	= new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaSCHEDULES_Linea();
        	
        	result.SALES_ITEMS_IN.ITEMS_Linea 			= new list<ABCPedidos_SF_to_ECC.ITEMS_Linea_element>();
        	result.SALES_PARTNERS.PARTNERS_Linea 		= new list<ABCPedidos_SF_to_ECC.PARTNERS_Linea_element>();
        	result.SALES_CONDITIONS_IN.CONDITIONS_Linea = new list<ABCPedidos_SF_to_ECC.CONDITIONS_Linea_element>();
        	result.SALES_TEXT.TEXT_Linea 				= new list<ABCPedidos_SF_to_ECC.TEXT_Linea_element>();
        	result.SALES_SCHEDULES_IN.SCHEDULES_Linea 	= new list<ABCPedidos_SF_to_ECC.SCHEDULES_Linea_element>();
        	//MAPAS
        	map< String ,String> mapaMoneda = new map< String ,String>{'D'=>'USD','P'=>'MXN'};
			map<string,string> mapaUnidadMedida = new map<string,string>{'C'=>'CS','K'=>'KG','L'=>'LB','P'=>'PI'};
			ABCPedidos_SF_to_ECC.TEXT_Linea_element 		elem4 = new ABCPedidos_SF_to_ECC.TEXT_Linea_element();
			elem4.Comentarios 			= pedido.Observacion__c;
			result.SALES_TEXT.TEXT_Linea.add(elem4);       		
        	
        	for(PedidoItem__c pi : listaProductos) {
        		
        		ABCPedidos_SF_to_ECC.ITEMS_Linea_element 		elem1 = new ABCPedidos_SF_to_ECC.ITEMS_Linea_element();
        		ABCPedidos_SF_to_ECC.PARTNERS_Linea_element 	elem2 = new ABCPedidos_SF_to_ECC.PARTNERS_Linea_element();
        		ABCPedidos_SF_to_ECC.CONDITIONS_Linea_element 	elem3 = new ABCPedidos_SF_to_ECC.CONDITIONS_Linea_element();
        		
        		ABCPedidos_SF_to_ECC.SCHEDULES_Linea_element 	elem5 = new ABCPedidos_SF_to_ECC.SCHEDULES_Linea_element();
        		elem1.Producto 				= pi.Producto__r.ProductCode;
        		
        		System.debug('DEBUGUNIDAD__C=> '+String.valueOf(pi.Cajas__c)+' -- '+ mapaUnidadMedida.get(pi.Unidad__c));
        		
        		if(pi.Cajas__c != null && mapaUnidadMedida.get(pi.Unidad__c) == 'CS')
        			elem1.Cajas 			= String.valueOf(pi.Cajas__c);
        		
        		if(mapaUnidadMedida.containsKey(pi.Unidad__c) && mapaUnidadMedida.get(pi.Unidad__c) == 'PI')
        			elem1.Cajas = String.valueOf(pi.Piezas__c);
        		else if(mapaUnidadMedida.get(pi.Unidad__c) == 'KG')
        			elem1.Cajas = String.valueOf(pi.Kilos__c);
        			
        		
        		if(mapaUnidadMedida.containsKey(pi.Unidad__c))
        			elem1.TipoSurtido 	= mapaUnidadMedida.get(pi.Unidad__c);	
        		//elem1.TipoSurtido 			= pedidoWrapper.pedido.TipoSurtido__c.left(1);
        		
        		
        		/*if(pedidoWrapper.isCancelacion != null && pedidoWrapper.isCancelacion)
        			result.SALES_HEADER_IN.Estatus = 'D';*/
        		
        		result.SALES_ITEMS_IN.ITEMS_Linea.add(elem1);
        		
        		elem2.TipoCliente 			= 'WE';
                System.debug('PROSPECTO=> '+ pedido.Prospecto__c +' ID '+pedido.Prospecto__r.Id_prospecto_sap__c);
        		elem2.Cliente 				= pedido.Prospecto__c != null ? pedido.Prospecto__r.Id_prospecto_sap__c : cuenta.Numero_Cliente_SAP__c.right(10);
        		result.SALES_PARTNERS.PARTNERS_Linea.add(elem2);
        		elem2 = new ABCPedidos_SF_to_ECC.PARTNERS_Linea_element();
        		elem2.TipoCliente 			= 'AG';
        		elem2.Cliente 				= cuenta.parent.Numero_Cliente_SAP__c;
        		result.SALES_PARTNERS.PARTNERS_Linea.add(elem2);
        		if(pedido.Factura_No_Fiscal__c)
        		{
        			elem2 = new ABCPedidos_SF_to_ECC.PARTNERS_Linea_element();
        			elem2.TipoCliente 			= 'RE';
	        		elem2.Cliente 				= pedido.Prospecto__c != null ? pedido.Prospecto__r.Id_prospecto_sap__c : cuenta.Numero_Cliente_SAP__c.right(10);
	        		result.SALES_PARTNERS.PARTNERS_Linea.add(elem2);
        		}
        		system.debug('TIPOPRECIO: ' + pi.TipoPrecio__c);
        		elem3.TipoPrecio	=  String.valueOf(pi.TipoPrecio__c);
        		elem3.Precio		=  String.valueOf(pi.PrecioUnitarioOriginal__c);
        		if(mapaMoneda.containsKey(pi.Moneda__c))
        			elem3.Moneda 	= mapaMoneda.get(pi.Moneda__c);
        		if(mapaUnidadMedida.containsKey(pi.Unidad__c))
        			elem3.Unidad 	= mapaUnidadMedida.get(pi.TipoPrecio__c);
        		result.SALES_CONDITIONS_IN.CONDITIONS_Linea.add(elem3);        		
        		        		
        		/*if(pedidoWrapper.pedidoItemList[i].Cajas_Balanceadas__c != null)
        			elem5.CantidadBalanceada= String.valueOf(pedidoWrapper.pedidoItemList[i].Cajas_Balanceadas__c);*/
        			
        		if(pi.Cajas_Conf__c != null)
        			elem5.CantidadBalanceada= String.valueOf(pi.Cajas_Conf__c);	
        		// Si es  pedido nuevo o modificacion y es diferente de Piezas  se mandas las cajas confirmadas 
        		if((result.SALES_HEADER_IN.Estatus == 'I' || result.SALES_HEADER_IN.Estatus == 'U') 
        				&& mapaUnidadMedida.get(pi.Unidad__c) == 'CS' )
        		{
        			elem5.CantidadBalanceada= String.valueOf(pi.Cajas_Conf__c);        				
        		}
        		else if((result.SALES_HEADER_IN.Estatus == 'I' || result.SALES_HEADER_IN.Estatus == 'U') 
        				&& mapaUnidadMedida.get(pi.Unidad__c) == 'KG' )
        		{
        			elem5.CantidadBalanceada= String.valueOf(pi.Kilos_Conf__c);        				
        		}
        		else
        		{
        			elem5.CantidadBalanceada = String.valueOf(pi.piezas_Conf__c);
        		}
        		if(Balanceo && mapaUnidadMedida.get(pi.Unidad__c) == 'PI' )
        		{
        			//system.debug('BALANCEO=> '+ mapaUnidadMedida.get(pedidoWrapper.pedidoItemList[i].Unidad__c));
        			result.SALES_HEADER_IN.Estatus = 'C';
        			Decimal piezasXcaja = [select Piezas_por_caja__c from product2 where id =: pi.producto__c].Piezas_por_caja__c;
        			elem5.CantidadBalanceada= String.valueOf(piezasXcaja== null ?0:piezasXcaja * pi.Cajas_Conf__c);
        			
        		}
        		else if(Balanceo){
        			result.SALES_HEADER_IN.Estatus = 'C';
        			elem5.CantidadBalanceada= String.valueOf(pi.Cajas_Conf__c);
        			
        		}
        		
        		elem5.FechaCarga 			= pedido.FechaSurtidoProgramada__c.format('yyyyMMdd');
        		elem5.FechaSurtido 			= pedido.FechaSurtidoProgramada__c.format('yyyyMMdd');
        		result.SALES_SCHEDULES_IN.SCHEDULES_Linea.add(elem5);
        	}
        	system.debug('ELEMENTO5=> ' + result);
        	return result;
    }
    public String generateIdPedidoSF() {
        	String idPedidoSF = '';
        	boolean exist = true;

		        while(exist) {
		            Integer x = 1;
		                 //2,147,483,647
		            Integer y = 2147483647;
		            Integer idPedido = Integer.valueOf( Math.floor(Math.random() * ((y-x)+1) + x) );
		            System.debug('id:' + idPedido);
		            idPedidoSF = String.valueOf(idPedido);
		            System.debug('id:' + idPedidoSF);
		            if( idPedidoSF.length() < 15 ) {
		                for( Integer l=idPedidoSF.length(); l<15; l++ ) {
		                    idPedidoSF = '0' + idPedidoSF;
		                }
		            }
		            System.debug('id:' + idPedidoSF);
		            String oppId='';
		            try {
		                oppId = [SELECT Id FROM Opportunity WHERE Id_Externo__c =: idPedidoSF].Id;
		            }
		            catch( Exception e ) {
		                System.debug('El Id_Externo no existe!!');
		            }
		            if( String.isBlank( oppId ) ) { exist = false; }
		        }
        	return idPedidoSF;
    	}
      public class pedidoWrapper
      {	
      		public Pedido__c pedido { get; set; }
      		public String Mensaje   { get; set; }
      		public String folio     { get; set; }
      }  
}