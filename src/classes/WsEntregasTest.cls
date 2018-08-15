@isTest
public class WsEntregasTest {
    static testMethod void inicial(){
        new WsEntregas.GeneraEntregaResponse_element();
        new WsEntregas.GeneraEntrega_element();
        new WsEntregas.ArrayOfString();
        new WsEntregas.GeneraEntregaSF_a_SAPSoap();
        new PedidosGeneraEntrega_SF_to_ECCC.Detalle_element();
        new PedidosGeneraEntrega_SF_to_ECCC.ArrayOfDT_SE_PedidosGeneraEntrega_RespDetalle();
        new PedidosGeneraEntrega_SF_to_ECCC.DT_SE_PedidosGeneraEntrega_Resp();
        new PedidosGeneraEntrega_SF_to_ECCC.Detalle_element();
        new PedidosGeneraEntrega_SF_to_ECCC.Detalle_element();
        new PedidosGeneraEntrega_SF_to_ECCC.Detalle_element();
        new PedidosGeneraEntrega_SF_to_ECCC.Detalle_element();
		Test.setMock(WebServiceMock.class, new WsEntregasMock());
        test.startTest();
        WsEntregas.GeneraEntregaSF_a_SAPSoap service =  new WsEntregas.GeneraEntregaSF_a_SAPSoap();
        service.GeneraEntrega(new WsEntregas.ArrayOfString());
        test.stopTest();
    }
}