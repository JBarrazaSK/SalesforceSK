public with sharing class WsEntregas {
     
     public class GeneraEntregaResponse_element {
        public PedidosGeneraEntrega_SF_to_ECCC.DT_SE_PedidosGeneraEntrega_Resp GeneraEntregaResult;
        private String[] GeneraEntregaResult_type_info = new String[]{'GeneraEntregaResult','http://www.sukarne.com/GeneraEntregaSF_a_SF',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/GeneraEntregaSF_a_SF','true','false'};
        private String[] field_order_type_info = new String[]{'GeneraEntregaResult'};
    }
    public class GeneraEntrega_element {
        public WsEntregas.ArrayOfString Folios;
        private String[] Folios_type_info = new String[]{'Folios','http://www.sukarne.com/GeneraEntregaSF_a_SF',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/GeneraEntregaSF_a_SF','true','false'};
        private String[] field_order_type_info = new String[]{'Folios'};
    }
    public class ArrayOfString {
        public String[] string_x;
        private String[] string_x_type_info = new String[]{'string','http://www.sukarne.com/GeneraEntregaSF_a_SF',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/GeneraEntregaSF_a_SF','true','false'};
        private String[] field_order_type_info = new String[]{'string_x'};
    }
    public class GeneraEntregaSF_a_SAPSoap {
        public String endpoint_x = 'http://salesforce1.apps.sukarne.com:2562/SKServiciosExternos/SalesForce/GeneraEntregaSF_a_SAP.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.sukarne.com/GeneraEntregaSF_a_SF', 'WsEntregas', 'http://SuKarne.com/pi/SE/PedidosGeneraEntrega_SF_to_ECC', 'PedidosGeneraEntrega_SF_to_ECCC'};
        public PedidosGeneraEntrega_SF_to_ECCC.DT_SE_PedidosGeneraEntrega_Resp GeneraEntrega(WsEntregas.ArrayOfString Folios) {
            WsEntregas.GeneraEntrega_element request_x = new WsEntregas.GeneraEntrega_element();
            request_x.Folios = Folios;
            WsEntregas.GeneraEntregaResponse_element response_x;
            Map<String, WsEntregas.GeneraEntregaResponse_element> response_map_x = new Map<String, WsEntregas.GeneraEntregaResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.sukarne.com/GeneraEntregaSF_a_SF/GeneraEntrega',
              'http://www.sukarne.com/GeneraEntregaSF_a_SF',
              'GeneraEntrega',
              'http://www.sukarne.com/GeneraEntregaSF_a_SF',
              'GeneraEntregaResponse',
              'WsEntregas.GeneraEntregaResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GeneraEntregaResult;
        }
    }
}