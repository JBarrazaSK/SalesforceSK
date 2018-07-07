@isTest
private class BalanceoSAPWSTest {
    
     static testMethod void inicial(){
         new BalanceoSAPWS.RespuestaOfString();
         new BalanceoSAPWS.GuardarPedidosResponse_element();
         new BalanceoSAPWS.ObtenerInventarioBalanceoPedidosSAP_element();
         new BalanceoSAPWS.Pedido();
         new BalanceoSAPWS.RegresaInventarioPorProducto_element();
         new BalanceoSAPWS.ArrayOfPedido();
         new BalanceoSAPWS.GuardarPedidos_element(); 
         new BalanceoSAPWS.ObtenerInventarioBalanceoPedidosSAPResponse_element();
         new BalanceoSAPWS.RegresaInventarioPorProductoResponse_element();
         new BalanceoSAPWS.ArrayOfInt();
         new BalanceoSAPWS.RespuestaOfListOfBalanceoProductos();
         new BalanceoSAPWS.ArrayOfBalanceoProductos();
         new BalanceoSAPWS.BalanceoProductos();
         new BalanceoSAPWS.PedidoDetalle();
         new BalanceoSAPWS.ArrayOfPedidoDetalle();
         
         BalanceoSAPWS.BalanceoSoap bsoap = new BalanceoSAPWS.BalanceoSoap();
         try{bsoap.RegresaInventarioPorProducto(null,null);}catch(Exception e){}
         try{bsoap.ObtenerInventarioBalanceoPedidosSAP(null);}catch(Exception e){}
         try{bsoap.GuardarPedidos(null,null);}catch(Exception e){}
     }
     
     static testMethod void pedi(){
         new BalanceoSAPWSPedi.DT_SE_InventarioBalanceoPedidos_Req();
         new BalanceoSAPWSPedi.BalanceoProductos_element();
         new BalanceoSAPWSPedi.BalanceoProductos_element();
         new BalanceoSAPWSPedi.ArrayOfInteger();
         new BalanceoSAPWSPedi.DT_SE_InventarioBalanceoPedidos_Resp();
         new BalanceoSAPWSPedi.ArrayOfDT_SE_InventarioBalanceoPedidos_RespBalanceoProductos();
     }


}