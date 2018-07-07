/**
 * Description: Test methods of the PedidoInsertNSCWS class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 18/09/2014
 **/
@isTest
public class PedidoInsertNSCWSTest implements WebServiceMock {
    
    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        PedidoInsertNSCWS.RegistrarPedidoResponse_element response = new PedidoInsertNSCWS.RegistrarPedidoResponse_element();
        response.RegistrarPedidoResult = new PedidoInsertNSCWS.RespuestaOfPedidoRespuesta();
        response.RegistrarPedidoResult.Datos = new PedidoInsertNSCWS.PedidoRespuesta();
        response.RegistrarPedidoResult.Datos.Canal = '0';
        response.RegistrarPedidoResult.Datos.NumeroPedido = '0';
        response.RegistrarPedidoResult.Datos.RequiereAutorizacion = false;
        response.RegistrarPedidoResult.Datos.TipoAutorizacionRemota = false;
        response.RegistrarPedidoResult.Datos.PedidoRechazado = false;
        response.RegistrarPedidoResult.Tipo = 'TerminadoConExito';
        responseMap.put('response_x', response);
    }
    
    static testMethod void myUnitTest() {
        Test.setMock(WebServiceMock.class, new PedidoInsertNSCWSTest());
        
        Test.startTest();
        
        PedidoInsertNSCWS.Pedido pedido = new PedidoInsertNSCWS.Pedido();
        pedido.Detalle = new PedidoInsertNSCWS.ArrayOfPedidoDetalle();
        pedido.Detalle.PedidoDetalle = new List<PedidoInsertNSCWS.PedidoDetalle> {
            new PedidoInsertNSCWS.PedidoDetalle()
        };
        PedidoInsertNSCWS.PedidosSoap pedidoSoap = new PedidoInsertNSCWS.PedidosSoap();
        pedidoSoap.RegistrarPedido(pedido);
        
        Test.stopTest();
    }
}