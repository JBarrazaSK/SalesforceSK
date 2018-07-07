/**
  * @Description : Controller class for Otros Canales VF page
  * @Created Date: 14 Dic 2016
  * @Author: Aranzazu Sereno - sf@lynx9.com
  * @Company: LYNX9 Soluciones
 */
@isTest
public class PedidoMayoreoWSTest {

    @IsTest
    private static void coverTypes()
    {
        new PedidosMayoreoWS.ArrayOfPedidoMayoreo();
        new PedidosMayoreoWS.PedidoMayoreo();
        new PedidosMayoreoWS.ArrayOfPedidoMayoreoInventario();
        new PedidosMayoreoWS.SF_GuardaPedidoEMA_element();
        new PedidosMayoreoWS.SF_GuardaPedidoEMAResponse_element();
        new PedidosMayoreoWS.ArrayOfPedidosMayoreoRespuesta();
        new PedidosMayoreoWS.PedidoMayoreoInventario();
        new PedidosMayoreoWS.PedidosMayoreoRespuesta();
        new PedidosMayoreoWS.ArrayOfPedidoMayoreoDetalle();
        new PedidosMayoreoWS.PedidoMayoreoDetalle();
    }
    
    @IsTest
    private static void coverMethods()
    {
        System.Test.setMock(WebServiceMock.class, new PedidosMayoreoWSMockImpl());
        
        PedidosMayoreoWS.ArrayOfPedidoMayoreo request = new PedidosMayoreoWS.ArrayOfPedidoMayoreo();
        //List<PedidosMayoreoWS.PedidoMayoreo> pedidos = new List<PedidosMayoreoWS.PedidoMayoreo>();
        //PedidosMayoreoWS.PedidoMayoreo
        //request.PedidoMayoreo = pedidos;
        
        PedidosMayoreoWS.PedidosMayoreoSoap stub = new PedidosMayoreoWS.PedidosMayoreoSoap();
        PedidosMayoreoWS.ArrayOfPedidosMayoreoRespuesta response = stub.SF_GuardaPedidoEMA(request);
    }
}