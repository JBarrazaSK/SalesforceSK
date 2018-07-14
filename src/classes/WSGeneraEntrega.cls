//Generated by wsdl2apex

public class WSGeneraEntrega {
    public class GeneraEntregaResponse_element {
        public PedidosGeneraEntrega_SF_to_SF.DT_SE_PedidosGeneraEntrega_Resp GeneraEntregaResult;
        private String[] GeneraEntregaResult_type_info = new String[]{'GeneraEntregaResult','http://sukarne.com/sap/PedidosMayoreoLegados',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sukarne.com/sap/PedidosMayoreoLegados','true','false'};
        private String[] field_order_type_info = new String[]{'GeneraEntregaResult'};
    }
    public class SI_OS_SE_to_ECC_PedidosGeneraEntregaRequest {
        public WSGeneraEntrega.ArrayOfString MT_SE_PedidosGeneraEntrega_Req;
        private String[] MT_SE_PedidosGeneraEntrega_Req_type_info = new String[]{'MT_SE_PedidosGeneraEntrega_Req','http://sukarne.com/sap/PedidosMayoreoLegados',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sukarne.com/sap/PedidosMayoreoLegados','true','false'};
        private String[] field_order_type_info = new String[]{'MT_SE_PedidosGeneraEntrega_Req'};
    }
    public class GeneraEntrega_element {
        public WSGeneraEntrega.SI_OS_SE_to_ECC_PedidosGeneraEntregaRequest Folios;
        private String[] Folios_type_info = new String[]{'Folios','http://sukarne.com/sap/PedidosMayoreoLegados',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sukarne.com/sap/PedidosMayoreoLegados','true','false'};
        private String[] field_order_type_info = new String[]{'Folios'};
    }
    public class ArrayOfString {
        public String[] Pedido;
        private String[] Pedido_type_info = new String[]{'Pedido','',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://sukarne.com/sap/PedidosMayoreoLegados','true','false'};
        private String[] field_order_type_info = new String[]{'Pedido'};
    }
    public class GeneraEntregaSF_a_SAPSoap {
        public String endpoint_x = 'http://localhost:64620/SalesForce/GeneraEntregaSF_a_SAP.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://sukarne.com/sap/PedidosMayoreoLegados', 'WSGeneraEntrega', 'http://SuKarne.com/pi/SE/PedidosGeneraEntrega_SF_to_ECC', 'http://sukarne.com/sap/PedidosMayoreoLegados'};
        public GeneraEntregaSF_a_SAPSoap()
        {
        	 endpoints__c ep = endpoints__c.getInstance();
             this.endpoint_x = ep.GrabarPedidosLegados__c;
        }
        public PedidosGeneraEntrega_SF_to_SF.DT_SE_PedidosGeneraEntrega_Resp GeneraEntrega(WSGeneraEntrega.SI_OS_SE_to_ECC_PedidosGeneraEntregaRequest Folios) {
            WSGeneraEntrega.GeneraEntrega_element request_x = new WSGeneraEntrega.GeneraEntrega_element();
            request_x.Folios = Folios;
            WSGeneraEntrega.GeneraEntregaResponse_element response_x;
            Map<String, WSGeneraEntrega.GeneraEntregaResponse_element> response_map_x = new Map<String, WSGeneraEntrega.GeneraEntregaResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{'https://hookb.in/vLNNODzN',//endpoint_x,
              'http://sukarne.com/sap/PedidosMayoreoLegados/GeneraEntrega',
              'http://sukarne.com/sap/PedidosMayoreoLegados',
              'GeneraEntrega',
              'http://sukarne.com/sap/PedidosMayoreoLegados',
              'GeneraEntregaResponse',
              'WSGeneraEntrega.GeneraEntregaResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GeneraEntregaResult;
        }
    }
}