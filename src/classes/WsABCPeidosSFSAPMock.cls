global class WsABCPeidosSFSAPMock implements WebServiceMock {
		public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {                           
            system.debug('ABCPEDIDOS::=>');
            responseMap = responseMap == null? new Map<String, Object>():responseMap;
            WsABCPeidosSFSAP.EnviarInformacionASapResponse_element response = new  WsABCPeidosSFSAP.EnviarInformacionASapResponse_element();
            response.EnviarInformacionASapResult = new WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido();
            response.EnviarInformacionASapResult.DT_SE_ABCPedidos_RespPedido = new list<ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido>();
            ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido respPedido = new ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido();
            respPedido.TipoMensaje = 'S';
            respPedido.Mensaje='OK';
            respPedido.FolioPedidoSAP ='12345678';
            respPedido.FolioPedidoSalesforce ='P129876';
            respPedido.Estatus= 'A';
            response.EnviarInformacionASapResult.DT_SE_ABCPedidos_RespPedido.add(respPedido);
            system.debug('RESPNSE_WS=> '+ response);
            responseMap.put('response_x', response);  
        
    }
    global class WsABCPeidosSFSAPFAILMock implements WebServiceMock {
    
		public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {                  
         if( request instanceOf WsABCPeidosSFSAP.EnviarInformacionASap_element) {
            system.debug('ABCPEDIDOS::=>');
            WsABCPeidosSFSAP.EnviarInformacionASapResponse_element response = new  WsABCPeidosSFSAP.EnviarInformacionASapResponse_element();
            response.EnviarInformacionASapResult = new WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido();
            response.EnviarInformacionASapResult.DT_SE_ABCPedidos_RespPedido = new list<ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido>();
            ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido respPedido = new ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido();
            system.debug('ABC=> ');
            respPedido.TipoMensaje = 'E';
            respPedido.Mensaje='OK';
            respPedido.FolioPedidoSAP ='12345678';
            respPedido.FolioPedidoSalesforce ='P129876';
            respPedido.Estatus= 'A';
              system.debug('RESPNSE_WS=> '+ respPedido);
            response.EnviarInformacionASapResult.DT_SE_ABCPedidos_RespPedido.add(respPedido);
            system.debug('RESPNSE_WS=> '+ response);
            responseMap.put('response_x', response);
        }     
        
    }
}
}