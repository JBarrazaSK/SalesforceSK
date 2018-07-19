//Generated by wsdl2apex

public class AsyncWsLiberacionPedidosCarteraLegados {
    public class LiberarPedidoCarteraResponse_elementFuture extends System.WebServiceCalloutFuture {
        public WsLiberacionPedidosCarteraLegados.RespuestaBase getValue() {
            WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element response = (WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.LiberarPedidoCarteraResult;
        }
    }
    public class AsyncLiberacionPedidosCarteraPSVSoap {
        public String endpoint_x = 'http://192.168.216.11:2562/SKServiciosExternos/SalesForce/LiberacionPedidosCarteraPSV.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://sukarne.com/ServiciosExternos/LiberacionPedidos', 'WsLiberacionPedidosCarteraLegados'};
        public AsyncWsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_elementFuture beginLiberarPedidoCartera(System.Continuation continuation,WsLiberacionPedidosCarteraLegados.DatosLiberacionPedido DatosLiberacion) {
            WsLiberacionPedidosCarteraLegados.LiberarPedidoCartera_element request_x = new WsLiberacionPedidosCarteraLegados.LiberarPedidoCartera_element();
            request_x.DatosLiberacion = DatosLiberacion;
            return (AsyncWsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncWsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://sukarne.com/ServiciosExternos/LiberacionPedidos/LiberarPedidoCartera',
              'http://sukarne.com/ServiciosExternos/LiberacionPedidos',
              'LiberarPedidoCartera',
              'http://sukarne.com/ServiciosExternos/LiberacionPedidos',
              'LiberarPedidoCarteraResponse',
              'WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element'}
            );
        }
    }
}