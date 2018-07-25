@isTest
public class WsABCPeidosSFSAPTest {
    
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