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

    }
  static testMethod void ExecuteWS() 
        {
            Map<String, Object> responseMap;
            Test.setMock(WebServiceMock.class, new WsprospectosMockImpl());
            Test.startTest();
                WsComposicionEmbarque.ComposicionEmbarquesResponse_element response = new WsComposicionEmbarque.ComposicionEmbarquesResponse_element();
                    response.ComposicionEmbarquesResult = new WsComposicionEmbarque.ArrayOfDT_SDL_ComEmbaRespZLE_COMPOSICION();
                    response.ComposicionEmbarquesResult.DT_SDL_ComEmbaRespZLE_COMPOSICION = new list<WsComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION>();
                    WsComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION elemento = new WsComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION();
                    elemento.DocumentoDeTransporte = '00001';
                    elemento.Status = 'OK';
                    response.ComposicionEmbarquesResult.DT_SDL_ComEmbaRespZLE_COMPOSICION.add(elemento);
                    responseMap.put('response_x', response);
            Test.stopTest();
        }           
}