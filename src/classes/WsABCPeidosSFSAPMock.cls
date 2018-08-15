@isTest
global with sharing class WsABCPeidosSFSAPMock implements WebServiceMock {

   public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        responseMap = responseMap == null? new Map<String, Object>():responseMap;
    
        
         if( request instanceOf WsABCPeidosSFSAP.EnviarInformacionASap_element) {
            
            WsABCPeidosSFSAP.EnviarInformacionASapResponse_element response = new  WsABCPeidosSFSAP.EnviarInformacionASapResponse_element();
            response.EnviarInformacionASapResult = new WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido();
            response.EnviarInformacionASapResult.DT_SE_ABCPedidos_RespPedido = new list<ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido>();
            ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido respPedido = new ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido();
            respPedido.TipoMensaje = 'S';
            respPedido.Mensaje='ok';
            respPedido.FolioPedidoSAP ='12345678';
            respPedido.FolioPedidoSalesforce ='P129876';
            respPedido.Estatus= 'A';
            response.EnviarInformacionASapResult.DT_SE_ABCPedidos_RespPedido.add(respPedido);
            
            responseMap.put('response_x', response);
        }
      
        
    }
}