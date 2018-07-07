/**
 * Author: Ruben Barraza
 * Company: Sk
 * Email:jose.barraza@sukarne.com
 * Created date: 17/04/2017
 **/
@isTest
global class WsActualizaDatosGenerales_NSC_SDLMock implements WebServiceMock {

   public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        responseMap = responseMap == null? new Map<String, Object>():responseMap;
        if( request instanceOf WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element ) {

        	WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGeneralesResponse_element response = new WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGeneralesResponse_element();
	    	response.ActualizarDatosGeneralesResult = new WsActualizaDatosGenerales_NSC_SDL.RespuestaModificacionPedidos();
        response.ActualizarDatosGeneralesResult.FolioPedidoSDL = 'P20160136';
        response.ActualizarDatosGeneralesResult.EstatusPedido = 1;
        response.ActualizarDatosGeneralesResult.Mensaje = 'OK';
            responseMap.put('response_x', response);
        }
    }
      global class WsConfigCalendarioDiasInhabilesMockImplFail implements WebServiceMock {
     	 public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
	        responseMap = responseMap == null? new Map<String, Object>():responseMap;
	        if( request instanceOf WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element ) {

        	WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGeneralesResponse_element response = new WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGeneralesResponse_element();
	    	  response.ActualizarDatosGeneralesResult = new WsActualizaDatosGenerales_NSC_SDL.RespuestaModificacionPedidos();
	      	response.ActualizarDatosGeneralesResult.FolioPedidoSDL = '100001';
	        response.ActualizarDatosGeneralesResult.EstatusPedido = 1;
	        response.ActualizarDatosGeneralesResult.Mensaje = 'OK';
            responseMap.put('response_x', response);
       	 }
    	}
     }
      @TestVisible global class UnauthorizedEndpointResponse implements WebServiceMock {
     	 public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
	        responseMap = responseMap == null? new Map<String, Object>():responseMap;
	        if( request instanceOf WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element) {

	        	CalloutException e = (CalloutException)CalloutException.class.newInstance();
				e.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
				throw e;
	        }
    	}

	}
}