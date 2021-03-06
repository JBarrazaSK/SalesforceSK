//Generated by wsdl2apex

public class AsyncWsConfigCalendarioDiasInhabiles {
    public class GuardarDiasInhabilesResponse_elementFuture extends System.WebServiceCalloutFuture {
        public WsConfigCalendarioDiasInhabiles.RespuestaOfBoolean getValue() {
            WsConfigCalendarioDiasInhabiles.GuardarDiasInhabilesResponse_element response = (WsConfigCalendarioDiasInhabiles.GuardarDiasInhabilesResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.GuardarDiasInhabilesResult;
        }
    }
    public class AsyncConfigCalendarioDiasInhabilesSoap {
        public String endpoint_x = 'http://web1test:8082/SalesForce/ConfigCalendarioDiasInhabiles.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.sukarne.com/ws/salesforce', 'WsConfigCalendarioDiasInhabiles'};
        public AsyncWsConfigCalendarioDiasInhabiles.GuardarDiasInhabilesResponse_elementFuture beginGuardarDiasInhabiles(System.Continuation continuation,WsConfigCalendarioDiasInhabiles.ConfigDiasInhabiles configuracion) {
            WsConfigCalendarioDiasInhabiles.GuardarDiasInhabiles_element request_x = new WsConfigCalendarioDiasInhabiles.GuardarDiasInhabiles_element();
            request_x.configuracion = configuracion;
            return (AsyncWsConfigCalendarioDiasInhabiles.GuardarDiasInhabilesResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncWsConfigCalendarioDiasInhabiles.GuardarDiasInhabilesResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://www.sukarne.com/ws/salesforce/GuardarDiasInhabiles',
              'http://www.sukarne.com/ws/salesforce',
              'GuardarDiasInhabiles',
              'http://www.sukarne.com/ws/salesforce',
              'GuardarDiasInhabilesResponse',
              'WsConfigCalendarioDiasInhabiles.GuardarDiasInhabilesResponse_element'}
            );
        }
    }
}