@isTest
private class WsPedidosMayoreoLegadosTest {

    static testMethod void myUnitTest() {
        WsPedidosMayoreoLegados.SALES_HEADER_IN  clase = new WsPedidosMayoreoLegados.SALES_HEADER_IN();
        WsPedidosMayoreoLegados.SALES_SCHEDULES_IN clase2 = new WsPedidosMayoreoLegados.SALES_SCHEDULES_IN();
        WsPedidosMayoreoLegados.PedidosPSV pedidopsv = new WsPedidosMayoreoLegados.PedidosPSV();
        WsPedidosMayoreoLegados.DT_SDL_ResItem clase3 = new WsPedidosMayoreoLegados.DT_SDL_ResItem();
        WsPedidosMayoreoLegados.PedidoMayoreoInventario  inventario = new   WsPedidosMayoreoLegados.PedidoMayoreoInventario();
        WsPedidosMayoreoLegados.SALES_PARTNERS sp = new  WsPedidosMayoreoLegados.SALES_PARTNERS(); 
        WsPedidosMayoreoLegados.ActualizaFolioEntrega_element actualizafolio = new WsPedidosMayoreoLegados.ActualizaFolioEntrega_element();
        WsPedidosMayoreoLegados.PedidoMayoreoDetalle pedidodetalle = new WsPedidosMayoreoLegados.PedidoMayoreoDetalle();
        WsPedidosMayoreoLegados.EnvioEmbarqueSAP envioEmbarque = new  WsPedidosMayoreoLegados.EnvioEmbarqueSAP();
        WsPedidosMayoreoLegados.Pedido pedido = new WsPedidosMayoreoLegados.Pedido();
        WsPedidosMayoreoLegados.SALES_CONDITIONS_IN sc = new WsPedidosMayoreoLegados.SALES_CONDITIONS_IN();
        WsPedidosMayoreoLegados.RespuestaOfBoolean respuesta = new WsPedidosMayoreoLegados.RespuestaOfBoolean();
        WsPedidosMayoreoLegados.SALES_ITEMS_IN sii = new WsPedidosMayoreoLegados.SALES_ITEMS_IN ();
        WsPedidosMayoreoLegados.DatosPedidoLegado dpl = new WsPedidosMayoreoLegados.DatosPedidoLegado();
        WsPedidosMayoreoLegados.PedidoMayoreo pm = new WsPedidosMayoreoLegados.PedidoMayoreo();
        WsPedidosMayoreoLegados.DT_SDL_ResItem1 dsr = new WsPedidosMayoreoLegados.DT_SDL_ResItem1();
        WsPedidosMayoreoLegados.ArrayOfString aos = new  WsPedidosMayoreoLegados.ArrayOfString();
        WsPedidosMayoreoLegados.SALES_TEXT st = new WsPedidosMayoreoLegados.SALES_TEXT();
        sukarneComPiSePedidosgeneraentregaS.Detalle_element claseEntregas = new sukarneComPiSePedidosgeneraentregaS.Detalle_element();
        sukarneComPiSePedidosgeneraentregaS.ArrayOfDT_SE_PedidosGeneraEntrega_RespDetalle rp = new sukarneComPiSePedidosgeneraentregaS.ArrayOfDT_SE_PedidosGeneraEntrega_RespDetalle();
        sukarneComPiSePedidosgeneraentregaS.DT_SE_PedidosGeneraEntrega_Resp DSP = new sukarneComPiSePedidosgeneraentregaS.DT_SE_PedidosGeneraEntrega_Resp();
        ComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION comp = new ComposicionEmbarque.DT_SDL_ComEmbaRespZLE_COMPOSICION();
        ComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION comp2 = new ComposicionEmbarque.DT_SDL_ComEmbaReqZLE_COMPOSICION(); 
        sukarneComPiSdlComposicionembarque.DT_SDL_ComEmbaRespZLE_COMPOSICION comp3 = new sukarneComPiSdlComposicionembarque.DT_SDL_ComEmbaRespZLE_COMPOSICION();
        sukarneComPiSdlComposicionembarque.DT_SDL_ComEmbaReqZLE_COMPOSICION comp4 = new sukarneComPiSdlComposicionembarque.DT_SDL_ComEmbaReqZLE_COMPOSICION();
        new WsPedidosMayoreoLegados.ArrayOfSALES_PARTNERS();
        new WsPedidosMayoreoLegados.ArrayOfPedidoMayoreoDetalle();
        new WsPedidosMayoreoLegados.ArrayOfDT_SDL_ComEmbaReqZLE_COMPOSICION();
        new WsPedidosMayoreoLegados.ArrayOfPedidoMayoreoInventario();
        new WsPedidosMayoreoLegados.ArrayOfDT_SDL_ComEmbaRespZLE_COMPOSICION();
        new WsPedidosMayoreoLegados.ArrayOfPedidoDetalle();
        new WsPedidosMayoreoLegados.ArrayOfSALES_TEXT();
        new WsPedidosMayoreoLegados.ComposicionEmbarquesResponse_element();
        new WsPedidosMayoreoLegados.ArrayOfDT_SDL_ResItem();
        new WsPedidosMayoreoLegados.PIPedidoVenta();
        new WsPedidosMayoreoLegados.ArrayOfSALES_ITEMS_IN(); 
        new WsPedidosMayoreoLegados.ArrayOfSALES_CONDITIONS_IN();
         new WsPedidosMayoreoLegados.ComposicionEmbarques_element();
		 new WsPedidosMayoreoLegados.ArrayOfDT_SDL_ResItem1();
		 new WsPedidosMayoreoLegados.ArrayOfSALES_SCHEDULES_IN();
		 new WsPedidosMayoreoLegados.SI_OS_SDL_ComEmbaRequest();
		 new WsPedidosMayoreoLegados.PedidoDetalle(); 
         
         insert new endpoints__c(GrabarPedidosLegados__c='http://localhost/tests');
         Test.setMock(WebServiceMock.class, new WsPedidosMayoreoLegadosMock());
          Test.startTest();
           WsPedidosMayoreoLegados.PedidosMayoreoLegadosSoap services = new WsPedidosMayoreoLegados.PedidosMayoreoLegadosSoap();
           services.ActualizaFolioEntrega('122345','122345');   
           services.GenerarPedidoMayoreo(new WsPedidosMayoreoLegados.DatosPedidoLegado());
           services.ActualizaPSVPedidos(new WsPedidosMayoreoLegados.PedidosPSV());
           services.GeneraEntrega(new WsPedidosMayoreoLegados.SI_OS_SE_to_ECC_PedidosGeneraEntregaRequest());
           services.GuardaFolioEmbarque(new WsPedidosMayoreoLegados.EnvioEmbarqueSAP());
        Test.stopTest();
    }
}