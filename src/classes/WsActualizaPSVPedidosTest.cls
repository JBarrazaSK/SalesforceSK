@isTest
private class WsActualizaPSVPedidosTest {

    @isTest static void coverGeneratedCodeTypes() {
        WsActualizaPSVPedidos.PedidosPSV pedido = new WsActualizaPSVPedidos.PedidosPSV();
        WsActualizaPSVPedidos.ActualizaPSVPedidosResponse_element clase = new WsActualizaPSVPedidos.ActualizaPSVPedidosResponse_element();
        WsActualizaPSVPedidos.RespuestaOfBoolean clase2 = new WsActualizaPSVPedidos.RespuestaOfBoolean();
        WsActualizaPSVPedidos.ActualizaPSVPedidos_element clase3 = new WsActualizaPSVPedidos.ActualizaPSVPedidos_element();
        pedido.Folio = '123445';
        pedido.Folio_SC = '123545667'; // folioSap o NSC
        pedido.Fecha = datetime.now().format('yyyy-MM-dd HH:mm:ss'); 
        pedido.FolioSDL = '123545667'; 
        pedido.Tipo_Prod = 'A';
        pedido.FechaEnvio = datetime.now().format('yyyy-MM-dd HH:mm:ss'); 
        pedido.ActualizaSAP = true;
        pedido.Error = false;
        pedido.MensajeError = '';
        endpoints__c ep = new endpoints__c();
        ep.GrabarPedidosLegados__c = 'http://192.168.217.29:2562/SKServiciosExternos/SAP/PedidosMayoreoLegados.asmx';
        upsert ep;
        WsActualizaPSVPedidos servicesActualiza = new WsActualizaPSVPedidos();
        test.setMock(HttpCalloutMock.class,new WsActualizaPSVPedidosHttpMock());
        Test.startTest();
        WsActualizaPSVPedidos.fakeMethod();
            HttpResponse res = WsActualizaPSVPedidosCallout.ActualizaPSVPedidos();
          servicesActualiza.ActualizaPSVPedidos(pedido);
        Test.stopTest();
    }
}