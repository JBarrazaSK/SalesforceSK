@isTest
global with sharing class WsPedidosMayoreoLegadosMock implements WebServiceMock {
	
	public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        responseMap = responseMap == null? new Map<String, Object>():responseMap;
    
        if( request instanceOf WsPedidosMayoreoLegados.GuardaFolioEmbarque_element ) {
        	
        	WsPedidosMayoreoLegados.GuardaFolioEmbarqueResponse_element response = new  WsPedidosMayoreoLegados.GuardaFolioEmbarqueResponse_element();
	    	response.GuardaFolioEmbarqueResult = new WsPedidosMayoreoLegados.RespuestaOfBoolean();
	      	response.GuardaFolioEmbarqueResult.Datos = true;
	      	response.GuardaFolioEmbarqueResult.Mensaje = 'OK';
	      	response.GuardaFolioEmbarqueResult.Tipo = 'TerminadoConExito';
	      	responseMap.put('response_x', response);
        }
         if( request instanceOf WsPedidosMayoreoLegados.ActualizaFolioEntrega_element) {
        	
        	WsPedidosMayoreoLegados.ActualizaFolioEntregaResponse_element response = new  WsPedidosMayoreoLegados.ActualizaFolioEntregaResponse_element();
	    	response.ActualizaFolioEntregaResult = new WsPedidosMayoreoLegados.RespuestaOfBoolean();
	      	response.ActualizaFolioEntregaResult.Datos = true;
	      	response.ActualizaFolioEntregaResult.Mensaje = 'OK';
	      	response.ActualizaFolioEntregaResult.Tipo = 'TerminadoConExito';
	      	responseMap.put('response_x', response);
        }
        
    }
    global with sharing class WsPedidosMayoreoLegadosMockFail implements WebServiceMock 
    {
	
		public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
	        responseMap = responseMap == null? new Map<String, Object>():responseMap;
	    
	        if( request instanceOf WsPedidosMayoreoLegados.GuardaFolioEmbarque_element ) {
	        	
	        	WsPedidosMayoreoLegados.GuardaFolioEmbarqueResponse_element response = new  WsPedidosMayoreoLegados.GuardaFolioEmbarqueResponse_element();
		    	response.GuardaFolioEmbarqueResult = new WsPedidosMayoreoLegados.RespuestaOfBoolean();
		      	response.GuardaFolioEmbarqueResult.Datos = true;
		      	response.GuardaFolioEmbarqueResult.Mensaje = 'EROR';
		      	response.GuardaFolioEmbarqueResult.Tipo = 'TerminadoConError';
		      	responseMap.put('response_x', response);
	        }
	         if( request instanceOf WsPedidosMayoreoLegados.ActualizaFolioEntrega_element) {
	        	
	        	WsPedidosMayoreoLegados.ActualizaFolioEntregaResponse_element response = new  WsPedidosMayoreoLegados.ActualizaFolioEntregaResponse_element();
		    	response.ActualizaFolioEntregaResult = new WsPedidosMayoreoLegados.RespuestaOfBoolean();
		      	response.ActualizaFolioEntregaResult.Datos = true;
		      	response.ActualizaFolioEntregaResult.Mensaje = 'OK';
		      	response.ActualizaFolioEntregaResult.Tipo = 'TerminadoConError';
		      	responseMap.put('response_x', response);
	        }
	        
	    }
    
	}
    
}