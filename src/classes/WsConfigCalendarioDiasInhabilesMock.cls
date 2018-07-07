/**
 * Description: WsArmarEmbarqueSDL.cls test methods.
 * Author: Ruben Barraza
 * Company: Sk
 * Email:jose.barraza@sukarne.com
 * Created date: 11/04/2017
 **/
@isTest 
global class WsConfigCalendarioDiasInhabilesMock implements WebServiceMock 
 {

     public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        responseMap = responseMap == null? new Map<String, Object>():responseMap;
        if( request instanceOf WsArmarEmbarqueSDL.ArmarEmbarque_element ) {
        	
        	WsConfigCalendarioDiasInhabiles.GuardarDiasInhabilesResponse_element response = new WsConfigCalendarioDiasInhabiles.GuardarDiasInhabilesResponse_element();
	    	response.GuardarDiasInhabilesResult = new WsConfigCalendarioDiasInhabiles.RespuestaOfBoolean();
	      	response.GuardarDiasInhabilesResult.Tipo = '1';
	        response.GuardarDiasInhabilesResult.Datos = true;
	        response.GuardarDiasInhabilesResult.Mensaje = 'OK';
            responseMap.put('response_x', response);
        }
    } 
}