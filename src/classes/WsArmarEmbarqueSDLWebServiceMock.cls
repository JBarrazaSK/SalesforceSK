/**
 * Description: WsArmarEmbarqueSDL.cls test methods.
 * Author: Ruben Barraza
 * Company: Sk
 * Email:jose.barraza@sukarne.com
 * Created date: 29/12/2016
 **/
@isTest
global class WsArmarEmbarqueSDLWebServiceMock implements WebServiceMock {

   public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        responseMap = responseMap == null? new Map<String, Object>():responseMap;
        if( request instanceOf WsArmarEmbarqueSDL.ArmarEmbarque_element ) {
        	
        	WsArmarEmbarqueSDL.ArmarEmbarqueResponse_element response = new WsArmarEmbarqueSDL.ArmarEmbarqueResponse_element();
	    	response.ArmarEmbarqueResult = new WsArmarEmbarqueSDL.RespuestaArmadoSDL();
	      	response.ArmarEmbarqueResult.FolioEmbarqueSDL = '100001';
	        response.ArmarEmbarqueResult.Estatus = true;
	        response.ArmarEmbarqueResult.Mensaje = 'OK';
            responseMap.put('response_x', response);
        }
    }
     global class WsArmarEmbarqueSDLWebServiceMockFail implements WebServiceMock {
     	 public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
	        responseMap = responseMap == null? new Map<String, Object>():responseMap;
	        if( request instanceOf WsArmarEmbarqueSDL.ArmarEmbarque_element ) {
	        	
	        	WsArmarEmbarqueSDL.ArmarEmbarqueResponse_element response = new WsArmarEmbarqueSDL.ArmarEmbarqueResponse_element();
		    	response.ArmarEmbarqueResult = new WsArmarEmbarqueSDL.RespuestaArmadoSDL();
		      	response.ArmarEmbarqueResult.FolioEmbarqueSDL = '';
		        response.ArmarEmbarqueResult.Estatus = false;
		        response.ArmarEmbarqueResult.Mensaje = 'Error';
	            responseMap.put('response_x', response);
	        }
    	}
     }
     @TestVisible global class UnauthorizedEndpointResponse implements WebServiceMock {
     	 public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
	        responseMap = responseMap == null? new Map<String, Object>():responseMap;
	        if( request instanceOf WsArmarEmbarqueSDL.ArmarEmbarque_element ) {
	        	
	        	CalloutException e = (CalloutException)CalloutException.class.newInstance();
				e.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
				throw e;
	        }
    	}
			
	}
     
}