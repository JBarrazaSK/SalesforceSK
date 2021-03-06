//Generated by wsdl2apex

public class AsyncWS {
    public class RegresaInventarioPorProductoResponse_elementFuture extends System.WebServiceCalloutFuture {
        public WS.RespuestaOfListOfBalanceoProductos getValue() {
            WS.RegresaInventarioPorProductoResponse_element response = (WS.RegresaInventarioPorProductoResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.RegresaInventarioPorProductoResult;
        }
    }
    public class ObtenerInventarioBalanceoPedidosSAPResponse_elementFuture extends System.WebServiceCalloutFuture {
        public InventarioBalanceoPedidos_SF_to_ECC.DT_SE_InventarioBalanceoPedidos_Resp getValue() {
            WS.ObtenerInventarioBalanceoPedidosSAPResponse_element response = (WS.ObtenerInventarioBalanceoPedidosSAPResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.ObtenerInventarioBalanceoPedidosSAPResult;
        }
    }
    public class GuardarPedidosResponse_elementFuture extends System.WebServiceCalloutFuture {
        public WS.RespuestaOfString getValue() {
            WS.GuardarPedidosResponse_element response = (WS.GuardarPedidosResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.GuardarPedidosResult;
        }
    }
    public class AsyncBalanceoSoap {
        public String endpoint_x = 'http://192.168.216.11:2562/SKServiciosExternos/SalesForce/Balanceo.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://SuKarne.com/pi/SE/InventarioBalanceoPedidos_SF_to_ECC', 'InventarioBalanceoPedidos_SF_to_ECC', 'http://www.sukarne.com/ws/salesforce', 'WS'};
        public AsyncWS.RegresaInventarioPorProductoResponse_elementFuture beginRegresaInventarioPorProducto(System.Continuation continuation,WS.ArrayOfInt producto,Integer canal) {
            WS.RegresaInventarioPorProducto_element request_x = new WS.RegresaInventarioPorProducto_element();
            request_x.producto = producto;
            request_x.canal = canal;
            return (AsyncWS.RegresaInventarioPorProductoResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncWS.RegresaInventarioPorProductoResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://www.sukarne.com/ws/salesforce/RegresaInventarioPorProducto',
              'http://www.sukarne.com/ws/salesforce',
              'RegresaInventarioPorProducto',
              'http://www.sukarne.com/ws/salesforce',
              'RegresaInventarioPorProductoResponse',
              'WS.RegresaInventarioPorProductoResponse_element'}
            );
        }
        public AsyncWS.ObtenerInventarioBalanceoPedidosSAPResponse_elementFuture beginObtenerInventarioBalanceoPedidosSAP(System.Continuation continuation,InventarioBalanceoPedidos_SF_to_ECC.DT_SE_InventarioBalanceoPedidos_Req Productos) {
            WS.ObtenerInventarioBalanceoPedidosSAP_element request_x = new WS.ObtenerInventarioBalanceoPedidosSAP_element();
            request_x.Productos = Productos;
            return (AsyncWS.ObtenerInventarioBalanceoPedidosSAPResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncWS.ObtenerInventarioBalanceoPedidosSAPResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://www.sukarne.com/ws/salesforce/ObtenerInventarioBalanceoPedidosSAP',
              'http://www.sukarne.com/ws/salesforce',
              'ObtenerInventarioBalanceoPedidosSAP',
              'http://www.sukarne.com/ws/salesforce',
              'ObtenerInventarioBalanceoPedidosSAPResponse',
              'WS.ObtenerInventarioBalanceoPedidosSAPResponse_element'}
            );
        }
        public AsyncWS.GuardarPedidosResponse_elementFuture beginGuardarPedidos(System.Continuation continuation,WS.ArrayOfPedido pedido,Integer canal) {
            WS.GuardarPedidos_element request_x = new WS.GuardarPedidos_element();
            request_x.pedido = pedido;
            request_x.canal = canal;
            return (AsyncWS.GuardarPedidosResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncWS.GuardarPedidosResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://www.sukarne.com/ws/salesforce/GuardarPedidos',
              'http://www.sukarne.com/ws/salesforce',
              'GuardarPedidos',
              'http://www.sukarne.com/ws/salesforce',
              'GuardarPedidosResponse',
              'WS.GuardarPedidosResponse_element'}
            );
        }
    }
}