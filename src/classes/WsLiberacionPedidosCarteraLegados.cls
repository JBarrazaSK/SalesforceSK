//Generated by wsdl2apex

public class WsLiberacionPedidosCarteraLegados {
    public class LiberarPedidoCartera_element {
        public WsLiberacionPedidosCarteraLegados.DatosLiberacionPedido DatosLiberacion;
        private String[] DatosLiberacion_type_info = new String[]{'DatosLiberacion','http://sukarne.com/ServiciosExternos/LiberacionPedidos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sukarne.com/ServiciosExternos/LiberacionPedidos','true','false'};
        private String[] field_order_type_info = new String[]{'DatosLiberacion'};
    }
    public class LiberarPedidoCarteraResponse_element {
        public WsLiberacionPedidosCarteraLegados.RespuestaBase LiberarPedidoCarteraResult;
        private String[] LiberarPedidoCarteraResult_type_info = new String[]{'LiberarPedidoCarteraResult','http://sukarne.com/ServiciosExternos/LiberacionPedidos',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sukarne.com/ServiciosExternos/LiberacionPedidos','true','false'};
        private String[] field_order_type_info = new String[]{'LiberarPedidoCarteraResult'};
    }
    public class DatosLiberacionPedido {
        public String FolioPSV;
        public String FolioNSC;
        public Integer CanalDistribucion;
        public String Tipo;
        public String Usuario;
        private String[] FolioPSV_type_info = new String[]{'FolioPSV','',null,'0','1','false'};
        private String[] FolioNSC_type_info = new String[]{'FolioNSC','',null,'0','1','false'};
        private String[] CanalDistribucion_type_info = new String[]{'CanalDistribucion','',null,'1','1','false'};
        private String[] Tipo_type_info = new String[]{'Tipo','',null,'0','1','false'};
        private String[] Usuario_type_info = new String[]{'Usuario','',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sukarne.com/ServiciosExternos/LiberacionPedidos','true','false'};
        private String[] field_order_type_info = new String[]{'FolioPSV','FolioNSC','CanalDistribucion','Tipo','Usuario'};
    }
    public class RespuestaBase {
        public String Mensaje;
        public String Tipo;
        private String[] Mensaje_type_info = new String[]{'Mensaje','http://sukarne.com/ServiciosExternos/LiberacionPedidos',null,'0','1','false'};
        private String[] Tipo_type_info = new String[]{'Tipo','http://sukarne.com/ServiciosExternos/LiberacionPedidos',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sukarne.com/ServiciosExternos/LiberacionPedidos','true','false'};
        private String[] field_order_type_info = new String[]{'Mensaje','Tipo'};
    }
    public class LiberacionPedidosCarteraPSVSoap {
    	
    	
        public String endpoint_x = 'http://192.168.216.11:2562/SKServiciosExternos/SalesForce/LiberacionPedidosCarteraPSV.asmx';
        public LiberacionPedidosCarteraPSVSoap()
       {
           endpoints__c ep = endpoints__c.getInstance();
           this.endpoint_x = ep.LiberacionPedidosCarteraPSV__c;
           this.timeout_x = 120000;
       }
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://sukarne.com/ServiciosExternos/LiberacionPedidos', 'WsLiberacionPedidosCarteraLegados'};
        public WsLiberacionPedidosCarteraLegados.RespuestaBase LiberarPedidoCartera(WsLiberacionPedidosCarteraLegados.DatosLiberacionPedido DatosLiberacion) {
            WsLiberacionPedidosCarteraLegados.LiberarPedidoCartera_element request_x = new WsLiberacionPedidosCarteraLegados.LiberarPedidoCartera_element();
            request_x.DatosLiberacion = DatosLiberacion;
            WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element response_x;
            Map<String, WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element> response_map_x = new Map<String, WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://sukarne.com/ServiciosExternos/LiberacionPedidos/LiberarPedidoCartera',
              'http://sukarne.com/ServiciosExternos/LiberacionPedidos',
              'LiberarPedidoCartera',
              'http://sukarne.com/ServiciosExternos/LiberacionPedidos',
              'LiberarPedidoCarteraResponse',
              'WsLiberacionPedidosCarteraLegados.LiberarPedidoCarteraResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.LiberarPedidoCarteraResult;
        }
    }
}