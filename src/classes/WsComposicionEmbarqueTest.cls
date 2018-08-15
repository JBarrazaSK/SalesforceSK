@isTest
public class WsComposicionEmbarqueTest {
    
    @isTest static void CoverturaClasesTipos() {

        WsComposicionEmbarque.SI_OS_SDL_ComEmbaRequest Embarques = new WsComposicionEmbarque.SI_OS_SDL_ComEmbaRequest();
        DOM.Document doc = new DOM.Document();
        new WsComposicionEmbarque.ComposicionEmbarques_element();
		new WsComposicionEmbarque.ComposicionEmbarquesResponse_element();      
        new WsComposicionEmbarque.ArrayOfDT_SDL_ComEmbaReqZLE_COMPOSICION();
        new WsComposicionEmbarque.ArrayOfDT_SDL_ComEmbaRespZLE_COMPOSICION();
        new WsComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION();
        new WsComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION();
        insert new endpoints__c(GrabarPedidosLegados__c='http://localhost/tests');
	    Test.setMock(HttpCalloutMock.class, new WsComposicionEmbarqueMockHttp());
	    test.startTest();
	    	WsComposicionEmbarque serviceSAP = new WsComposicionEmbarque();
	    	WsComposicionEmbarqueCallout.ComposicionEmbarques();
            serviceSAP.ComposicionEmbarques(new WsComposicionEmbarque.SI_OS_SDL_ComEmbaRequest());
        WsComposicionEmbarque.fakeMethod();
	    test.stopTest();
    } 
        
}