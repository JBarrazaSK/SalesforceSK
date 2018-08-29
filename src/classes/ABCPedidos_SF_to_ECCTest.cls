@isTest
public class ABCPedidos_SF_to_ECCTest implements WebServiceMock 
{
        public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) 
        {        

            if(request instanceOf ABCPedidos_SF_to_ECC.TEXT_Linea_element) {
            ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido response = new ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido();
                response.TipoMensaje = 'S';
                response.Mensaje = 'OK';
                response.FolioPedidoSAP = '1000';
                response.FolioPedidoSalesforce = '098675';
                response.Estatus = 'A';            
            responseMap.put( 'response_x', response);
        } 
    }
    
    static testMethod void myUnitTest() {
        
        Test.setMock(WebServiceMock.class, new ABCPedidos_SF_to_ECCTest());        
        Test.startTest();
        
        ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido request = new ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido();       
        Test.stopTest();
    }

}