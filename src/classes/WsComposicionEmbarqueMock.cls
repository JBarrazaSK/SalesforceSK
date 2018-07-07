@isTest
global with sharing class WsComposicionEmbarqueMock implements WebServiceMock {
 
 public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        responseMap = responseMap == null? new Map<String, Object>():responseMap;
    
        if( request instanceOf WsComposicionEmbarque.ComposicionEmbarques_element ) {
        	
        	WsComposicionEmbarque.ComposicionEmbarquesResponse_element response = new WsComposicionEmbarque.ComposicionEmbarquesResponse_element();
	    	response.ComposicionEmbarquesResult = new WsComposicionEmbarque.ArrayOfDT_SDL_ComEmbaRespZLE_COMPOSICION();
	      	response.ComposicionEmbarquesResult.DT_SDL_ComEmbaRespZLE_COMPOSICION = new list<WsComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION>();
	      	WsComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION elemento = new WsComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION();
	      	elemento.DocumentoDeTransporte = '00001';
	      	elemento.Status = 'OK';
	        response.ComposicionEmbarquesResult.DT_SDL_ComEmbaRespZLE_COMPOSICION.add(elemento);
	        responseMap.put('response_x', response);
        }
    }
}