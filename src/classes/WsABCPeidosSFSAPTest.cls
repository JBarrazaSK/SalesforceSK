@isTest
public class WsABCPeidosSFSAPTest implements WebServiceMock {
   
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
    
     static testMethod void inicial(){
         new ABCPedidos_SF_to_ECC.TEXT_Linea_element();
         new ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista();
         new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaITEMS_Linea();
         new ABCPedidos_SF_to_ECC.ITEMS_Linea_element();
         new ABCPedidos_SF_to_ECC.CONDITIONS_Linea_element();
         new ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido();
         new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaTEXT_Linea();
         new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaSCHEDULES_Linea();
         new ABCPedidos_SF_to_ECC.PARTNERS_Linea_element();
         new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaPARTNERS_Linea();
         new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaCONDITIONS_Linea();
         new ABCPedidos_SF_to_ECC.SCHEDULES_Linea_element();
         new ABCPedidos_SF_to_ECC.SALES_HEADER_IN_element();
         
         new WsABCPeidosSFSAP.EnviarInformacionASapResponse_element();
         new WsABCPeidosSFSAP.EnviarInformacionASap_element();
         new WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido();
         new WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_ReqLista();
                  
         insert new endpoints__c(ABCPedidosSF__c='http://localhost/tests');
         WsABCPeidosSFSAP.ABCPedidosSF_SAPSoap sp = new WsABCPeidosSFSAP.ABCPedidosSF_SAPSoap();
         try{sp.EnviarInformacionASap(null);}catch(Exception e){}
     }
     
}