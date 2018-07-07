/**
 * Description: Test methods for the PedidoUtilGINS class.
 * Author: Jorge Terán
 * Company: LYNX9
 * Email: sf@lynx9.com
 * Created date: 01/04/2015
 **/
@isTest
public class PedidoUtilsGINSATest implements WebServiceMock {
	
	public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        if(stub instanceOf CierrePlazaPedidoQueryNSCWS.CierrePedidosSoap) {
            new CierrePlazaPedidoQueryNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf ProductoInventarioQueryNSCWS.DisponibilidadInventarioSoap) {
            new ProductoInventarioQueryNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf ListaPreciosQueryNSCWS.ListaPreciosSoap) {
            new ListaPreciosQueryNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf PedidoInsertNSCWS.PedidosSoap) {
            new PedidoInsertNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        }/* else if(request instanceOf BalanceoNSCWS.GuardarPedidos_element) {
            new BalanceoNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        }*/
    }

    static testMethod void Test() {

    	Test.setMock(WebServiceMock.class, new PedidoUtilsginsaTest());
        Test.startTest();
        //Se prueba mediante ProductosBalanceoControllerTest y PedidoWizardTest
        Test.stopTest();

    }
}