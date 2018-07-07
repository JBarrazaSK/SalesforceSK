public class WsDevolucionesSAP {
    public class DevolucionSAPResponse_element {
        public EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Resp DevolucionSAPResult;
        private String[] DevolucionSAPResult_type_info = new String[]{'DevolucionSAPResult','http://www.sukarne.com/ws/salesforce/DevolucionesSAP/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce/DevolucionesSAP/','true','false'};
        private String[] field_order_type_info = new String[]{'DevolucionSAPResult'};
    }
    public class DevolucionSAP_element {
        public EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Req devolucionSAP;
        private String[] devolucionSAP_type_info = new String[]{'devolucionSAP','http://www.sukarne.com/ws/salesforce/DevolucionesSAP/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce/DevolucionesSAP/','true','false'};
        private String[] field_order_type_info = new String[]{'devolucionSAP'};
    }
    public class DetalleFacturaResponse_element {
        public EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Resp DetalleFacturaResult;
        private String[] DetalleFacturaResult_type_info = new String[]{'DetalleFacturaResult','http://www.sukarne.com/ws/salesforce/DevolucionesSAP/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce/DevolucionesSAP/','true','false'};
        private String[] field_order_type_info = new String[]{'DetalleFacturaResult'};
    }
    public class DetalleFactura_element {
        public EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Req numeroFactura;
        private String[] numeroFactura_type_info = new String[]{'numeroFactura','',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce/DevolucionesSAP/','true','false'};
        private String[] field_order_type_info = new String[]{'numeroFactura'};
    }
    public class DevolucionesSapSoap {
        public String endpoint_x = 'http://192.168.217.29:2562/SKServiciosExternos/SalesForce/DevolucionesSap.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://SuKarne.com/pi/SE/DevolucionNotaCredito_SF_to_ECC', 'EntityDevolucionNotaCredito_SF_to_ECC', 'http://www.sukarne.com/ws/salesforce/DevolucionesSAP/', 'WsDevolucionesSAP', 'http://SuKarne.com/pi/SE/ConsultaFactura_SF_to_ECC', 'EntityConsultaFactura_SF_to_ECC'};
        
        public DevolucionesSapSoap()
        {
        	endpoints__c ep = endpoints__c.getInstance();
            this.endpoint_x = ep.WsDevolucionesSAP__c;
        } 
        
        public EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Resp DetalleFactura(EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Req numeroFactura) {
            WsDevolucionesSAP.DetalleFactura_element request_x = new WsDevolucionesSAP.DetalleFactura_element();
            request_x.numeroFactura = numeroFactura;
            WsDevolucionesSAP.DetalleFacturaResponse_element response_x;
            Map<String, WsDevolucionesSAP.DetalleFacturaResponse_element> response_map_x = new Map<String, WsDevolucionesSAP.DetalleFacturaResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.sukarne.com/ws/salesforce/DevolucionesSAP/DetalleFactura',
              'http://www.sukarne.com/ws/salesforce/DevolucionesSAP/',
              'DetalleFactura',
              'http://www.sukarne.com/ws/salesforce/DevolucionesSAP/',
              'DetalleFacturaResponse',
              'WsDevolucionesSAP.DetalleFacturaResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.DetalleFacturaResult;
        }
        public EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Resp DevolucionSAP(EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Req devolucionSAP) {
            WsDevolucionesSAP.DevolucionSAP_element request_x = new WsDevolucionesSAP.DevolucionSAP_element();
            request_x.devolucionSAP = devolucionSAP;
            WsDevolucionesSAP.DevolucionSAPResponse_element response_x;
            Map<String, WsDevolucionesSAP.DevolucionSAPResponse_element> response_map_x = new Map<String, WsDevolucionesSAP.DevolucionSAPResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.sukarne.com/ws/salesforce/DevolucionesSAP/DevolucionSAP',
              'http://www.sukarne.com/ws/salesforce/DevolucionesSAP/',
              'DevolucionSAP',
              'http://www.sukarne.com/ws/salesforce/DevolucionesSAP/',
              'DevolucionSAPResponse',
              'WsDevolucionesSAP.DevolucionSAPResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.DevolucionSAPResult;
        }
    }
}