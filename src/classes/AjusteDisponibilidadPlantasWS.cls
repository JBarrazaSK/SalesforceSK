//Generated by wsdl2apex

public class AjusteDisponibilidadPlantasWS {
    public class AjusteDispo {
        public Integer OficinaVta;
        public Integer TipoInventario;
        public String FechaEmb;
        public String UsuarioRegistro;
        public String FechaRegistro;
        public Integer Producto;
        public Integer CantCajasAjusto;
        private String[] OficinaVta_type_info = new String[]{'OficinaVta','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] TipoInventario_type_info = new String[]{'TipoInventario','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] FechaEmb_type_info = new String[]{'FechaEmb','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] UsuarioRegistro_type_info = new String[]{'UsuarioRegistro','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] FechaRegistro_type_info = new String[]{'FechaRegistro','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Producto_type_info = new String[]{'Producto','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] CantCajasAjusto_type_info = new String[]{'CantCajasAjusto','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'OficinaVta','TipoInventario','FechaEmb','UsuarioRegistro','FechaRegistro','Producto','CantCajasAjusto'};
    }
    public class ArrayOfAjusteDispo {
        public AjusteDisponibilidadPlantasWS.AjusteDispo[] AjusteDispo;
        private String[] AjusteDispo_type_info = new String[]{'AjusteDispo','http://www.sukarne.com/ws/salesforce',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'AjusteDispo'};
    }
    public class AjusteDisponibilidad_element {
        public AjusteDisponibilidadPlantasWS.AjusteDisponibilidad ajusteDisponibilidad;
        private String[] ajusteDisponibilidad_type_info = new String[]{'ajusteDisponibilidad','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'ajusteDisponibilidad'};
    }
    public class AjusteDisponibilidadResponse_element {
        public AjusteDisponibilidadPlantasWS.RespuestaOfInt32 AjusteDisponibilidadResult;
        private String[] AjusteDisponibilidadResult_type_info = new String[]{'AjusteDisponibilidadResult','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'AjusteDisponibilidadResult'};
    }
    public class RespuestaOfInt32 {
        public Integer Datos;
        public String Mensaje;
        public String Tipo;
        private String[] Datos_type_info = new String[]{'Datos','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] Mensaje_type_info = new String[]{'Mensaje','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] Tipo_type_info = new String[]{'Tipo','http://www.sukarne.com/ws/salesforce',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'Datos','Mensaje','Tipo'};
    }
    public class AjusteDisponibilidad {
        public AjusteDisponibilidadPlantasWS.ArrayOfAjusteDispo ajustesDisponibilidad;
        private String[] ajustesDisponibilidad_type_info = new String[]{'ajustesDisponibilidad','http://www.sukarne.com/ws/salesforce',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.sukarne.com/ws/salesforce','true','false'};
        private String[] field_order_type_info = new String[]{'ajustesDisponibilidad'};
    }

    public class AjusteDisponibilidadPlantasSoap {
        public String endpoint_x = '';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.sukarne.com/ws/salesforce', 'AjusteDisponibilidadPlantasWS'};
        public AjusteDisponibilidadPlantasSoap()
        {
          endpoints__c ep = endpoints__c.getInstance();
            this.endpoint_x = ep.Ajuste_de_planta__c;
        }
        public AjusteDisponibilidadPlantasWS.RespuestaOfInt32 AjusteDisponibilidad(AjusteDisponibilidadPlantasWS.AjusteDisponibilidad ajusteDisponibilidad) {
            AjusteDisponibilidadPlantasWS.AjusteDisponibilidad_element request_x = new AjusteDisponibilidadPlantasWS.AjusteDisponibilidad_element();
            request_x.ajusteDisponibilidad = ajusteDisponibilidad;
            AjusteDisponibilidadPlantasWS.AjusteDisponibilidadResponse_element response_x;
            Map<String, AjusteDisponibilidadPlantasWS.AjusteDisponibilidadResponse_element> response_map_x = new Map<String, AjusteDisponibilidadPlantasWS.AjusteDisponibilidadResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.sukarne.com/ws/salesforce/AjusteDisponibilidad',
              'http://www.sukarne.com/ws/salesforce',
              'AjusteDisponibilidad',
              'http://www.sukarne.com/ws/salesforce',
              'AjusteDisponibilidadResponse',
              'AjusteDisponibilidadPlantasWS.AjusteDisponibilidadResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.AjusteDisponibilidadResult;
        }
    }
}