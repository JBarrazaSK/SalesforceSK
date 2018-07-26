public class OpportunityParserUtils {

    public static list<PedidosOtrosCanalesUtils.Producto> GenerarListaProductos(list<OpportunityLineItem> items)
    {
    	list<PedidosOtrosCanalesUtils.Producto> productos = new list<PedidosOtrosCanalesUtils.Producto>();
    	for(Integer index=0;index<items.size();index++){
            if( items.get(index).Cantidad__c == null || items.get(index).Cantidad__c == 0 ) {  items.get(index).Cantidad__c = items.get(index).Cajas__c; }
            productos.add(new PedidosOtrosCanalesUtils.Producto(index, items.get(index)));
        }
        return productos;
    }
    public static list<WsPedidosMayoreoLegados.ResultadoPedidoMayoreoLegados> EnviarPedidoLegados(list<WsPedidosMayoreoLegados.DatosPedidoLegado> listaPedidos,map<string, Opportunity> mapPedidos)
    {
    	WsPedidosMayoreoLegados.PedidosMayoreoLegadosSoap services = new WsPedidosMayoreoLegados.PedidosMayoreoLegadosSoap();
    	list<WsPedidosMayoreoLegados.ResultadoPedidoMayoreoLegados> lista = new list<WsPedidosMayoreoLegados.ResultadoPedidoMayoreoLegados>();
    	list<WsActualizaPSVPedidos.PedidosPSV> listaActualizaPedidos = new list<WsActualizaPSVPedidos.PedidosPSV>();
    	WsActualizaPSVPedidos servicesActualiza = new WsActualizaPSVPedidos();
	    WsActualizaPSVPedidos.RespuestaOfBoolean ResponseActualiza; 
	    WsActualizaPSVPedidos.PedidosPSV actualizaPedido = new WsActualizaPSVPedidos.PedidosPSV();
	    
    	for(WsPedidosMayoreoLegados.DatosPedidoLegado DatosPedidos :listaPedidos)
    	{
     		
    		WsPedidosMayoreoLegados.ResultadoPedidoMayoreoLegados Response = services.GenerarPedidoMayoreo(DatosPedidos);
    		if(Response != null && Response.Resultado =='TerminadoConExito')
	        {
	        	Opportunity pedido  = mapPedidos.get(String.ValueOf(Response.SdlIdPedidoSalesForce).leftPad(15, '0'));
	        	string Fecha = PedidosOtrosCanalesUtils.dateToString(pedido.Fecha_de_Embarque__c,'yyyyMMdd'); 
	        	 if(PedidosOtrosCanalesUtils.IsVizcatle(pedido) &&  pedido.StageName != '11 - Bloqueado Cierre')
				    {
				    	actualizaPedido = PedidosOtrosCanalesUtils.CrearPedidoPsvActualiza(Response.SapShip_To,pedido.Id_Externo__c,'E', true,Response.SdlFolioPedidoSDL,Fecha);
				    	listaActualizaPedidos.add(actualizaPedido);
				    	actualizaPedido = new WsActualizaPSVPedidos.PedidosPSV();
				    	Fecha = PedidosOtrosCanalesUtils.dateToString(pedido.Fecha_Embarque_Bodega__c,'yyyyMMdd'); 
				    	actualizaPedido = PedidosOtrosCanalesUtils.CrearPedidoPsvActualiza(string.ValueOf(integer.ValueOf(Response.NscNumeroPedido)),pedido.Id_Externo__c,'V', false,Response.SdlFolioPedidoSDL,Fecha);
				    	listaActualizaPedidos.add(actualizaPedido);  
				      			  
				    }
				    else if(pedido.StageName != '11 - Bloqueado Cierre')
				    {
				    	listaActualizaPedidos.add(ActualizaPedidos(Response,pedido));
				    }
				    
	        }
	       	lista.add( Response);	
    	}
		for(WsActualizaPSVPedidos.PedidosPSV psv : listaActualizaPedidos)
	    {
	    	servicesActualiza = new WsActualizaPSVPedidos();
	    	ResponseActualiza = new WsActualizaPSVPedidos.RespuestaOfBoolean();
	    	ResponseActualiza = servicesActualiza.ActualizaPSVPedidos(psv);
	       	if(ResponseActualiza != null)
		    {
		    	system.debug('Respuesta: '+ResponseActualiza.Mensaje);
		        			
		    }
	        			
	   }

       	return lista;
    }
    public static WsActualizaPSVPedidos.PedidosPSV ActualizaPedidos(WsPedidosMayoreoLegados.ResultadoPedidoMayoreoLegados Response, opportunity pedido)
    {
    	string Fecha = PedidosOtrosCanalesUtils.dateToString(pedido.Fecha_de_Embarque__c,'yyyyMMdd'); 
    	Boolean ActualizaSap = false;
    	
    	if(Response.SapShip_To != null)
    		ActualizaSap = true;
	    	
	    string pedidoAct = Response.NscNumeroPedido != null ? Response.NscNumeroPedido : Response.SapShip_To;
	    return PedidosOtrosCanalesUtils.CrearPedidoPsvActualiza(pedidoAct,pedido.Id_Externo__c,PedidosOtrosCanalesUtils.ObtenerCanalVenta(pedido), ActualizaSap,Response.SdlFolioPedidoSDL,Fecha);
		
    }
}