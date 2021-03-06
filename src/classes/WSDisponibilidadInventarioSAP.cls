//Generated by wsdl2apex

public class WSDisponibilidadInventarioSAP {
    public class ConsultarDisponibilidadSAP_element {
        public DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Req request;
        private String[] request_type_info = new String[]{'request','',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce/ConsultaDisponibilidadInventarioSAP','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class ConsultarDisponibilidadSAPResponse_element {
        public DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp ConsultarDisponibilidadSAPResult;
        private String[] ConsultarDisponibilidadSAPResult_type_info = new String[]{'ConsultarDisponibilidadSAPResult','http://www.sukarne.com/ws/salesforce/ConsultaDisponibilidadInventarioSAP',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce/ConsultaDisponibilidadInventarioSAP','true','false'};
        private String[] field_order_type_info = new String[]{'ConsultarDisponibilidadSAPResult'};
    }
    public class DisponibilidadInventarioSAPSoap {
        public String endpoint_x = 'http://187.216.127.15:2562/SKServiciosExternos/SalesForce/DisponibilidadInventarioSAP.asmx';
      	//public String endpoint_x ='https://hookb.in/KxQQzpG0';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.sukarne.com/ws/salesforce/ConsultaDisponibilidadInventarioSAP', 'WSDisponibilidadInventarioSAP', 'http://SuKarne.com/pi/SE/DisponibilidadInventario_SF_to_ECC', 'DisponibilidadInventarioSAP'};
       public DisponibilidadInventarioSAPSoap()
       {	
       		endpoints__c ep = endpoints__c.getInstance();
            this.endpoint_x = ep.WSDisponibilidadInventarioSAP__c;
            this.timeout_x =120000;
       }
        public DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp ConsultarDisponibilidadSAP(DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Req request) {
           
            WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAP_element request_x = new WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAP_element();
            request_x.request = request;
            WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAPResponse_element response_x;
            Map<String, WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAPResponse_element> response_map_x = new Map<String, WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAPResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.sukarne.com/ws/salesforce/ConsultaDisponibilidadInventarioSAP/ConsultarDisponibilidadSAP',
              'http://www.sukarne.com/ws/salesforce/ConsultaDisponibilidadInventarioSAP',
              'ConsultarDisponibilidadSAP',
              'http://www.sukarne.com/ws/salesforce/ConsultaDisponibilidadInventarioSAP',
              'ConsultarDisponibilidadSAPResponse',
              'WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAPResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.ConsultarDisponibilidadSAPResult;
        }
    }
}