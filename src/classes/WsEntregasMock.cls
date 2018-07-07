@isTest
global with sharing class WsEntregasMock implements WebServiceMock {
 
 public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        responseMap = responseMap == null? new Map<String, Object>():responseMap;
        if( request instanceOf WsEntregas.GeneraEntrega_element ) {
        	
        	WsEntregas.GeneraEntregaResponse_element response = new WsEntregas.GeneraEntregaResponse_element();
	    	response.GeneraEntregaResult = new PedidosGeneraEntrega_SF_to_ECCC.DT_SE_PedidosGeneraEntrega_Resp();
	      	response.GeneraEntregaResult.Datos =new PedidosGeneraEntrega_SF_to_ECCC.ArrayOfDT_SE_PedidosGeneraEntrega_RespDetalle();
	      	response.GeneraEntregaResult.Datos.Detalle = new list<PedidosGeneraEntrega_SF_to_ECCC.Detalle_element>();
	      	PedidosGeneraEntrega_SF_to_ECCC.Detalle_element detalle = new PedidosGeneraEntrega_SF_to_ECCC.Detalle_element();
	      	detalle.pedido = '0000136271';
	      	detalle.FolioEntrega = '0000136271';	
	      	response.GeneraEntregaResult.Datos.Detalle.add(detalle);      	
	        response.GeneraEntregaResult.TipoMensaje = 'S';
	        response.GeneraEntregaResult.Mensaje = 'OK';
            responseMap.put('response_x', response);
        }
    }
    
}