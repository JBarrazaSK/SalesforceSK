/**
 * Author: Ruben Barraza
 * Company: Sk
 * Email:jose.barraza@sukarne.com
 * Created date: 17/04/2017
 **/
@isTest
global class WsConfigCalendarioDiasInhabilesMockImpl implements WebServiceMock{
       
       public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        responseMap = responseMap == null? new Map<String, Object>():responseMap;
        if( request instanceOf WsConfigCalendarioDiasInhabiles.GuardarDiasInhabiles_element ) {
        	
        	WsConfigCalendarioDiasInhabiles.GuardarDiasInhabilesResponse_element response = new WsConfigCalendarioDiasInhabiles.GuardarDiasInhabilesResponse_element();
	    	response.GuardarDiasInhabilesResult = new WsConfigCalendarioDiasInhabiles.RespuestaOfBoolean();
	      	response.GuardarDiasInhabilesResult.Tipo = '100001';
	        response.GuardarDiasInhabilesResult.Datos = true;
	        response.GuardarDiasInhabilesResult.Mensaje = 'OK';
            responseMap.put('response_x', response);
        }
    }
    global class WsConfigCalendarioDiasInhabilesMockImplFail implements WebServiceMock {
     	 public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
	        responseMap = responseMap == null? new Map<String, Object>():responseMap;
	        if( request instanceOf WsConfigCalendarioDiasInhabiles.GuardarDiasInhabiles_element ) {
        	
	        	WsConfigCalendarioDiasInhabiles.GuardarDiasInhabilesResponse_element response = new WsConfigCalendarioDiasInhabiles.GuardarDiasInhabilesResponse_element();
		    	response.GuardarDiasInhabilesResult = new WsConfigCalendarioDiasInhabiles.RespuestaOfBoolean();
		      	response.GuardarDiasInhabilesResult.Tipo = '100001';
		        response.GuardarDiasInhabilesResult.Datos = false;
		        response.GuardarDiasInhabilesResult.Mensaje = 'ERROR';
	            responseMap.put('response_x', response);
        	}
    	} 
     }
      @TestVisible global class UnauthorizedEndpointResponse implements WebServiceMock {
     	 public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
	        responseMap = responseMap == null? new Map<String, Object>():responseMap;
	        if( request instanceOf WsConfigCalendarioDiasInhabiles.GuardarDiasInhabiles_element ) {
	        	
	        	CalloutException e = (CalloutException)CalloutException.class.newInstance();
				e.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
				throw e;
	        }
    	}
			
	}
}