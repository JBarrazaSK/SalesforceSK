/**
  * @Description : Mock Implementation class for ValidarCredito WS
  * @Created Date: 29 September 2016
  * @Author: Jorge Terán - jorge.teran@lynx9.com
  * @Company: LYNX9 Soluciones
 */
@isTest
global class WSValidarLimiteCreditoMockImpl implements WebServiceMock {

    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        if( request instanceOf WSValidarLimiteCredito.ValidarLimiteCredito_element ) {
        	WSValidarLimiteCredito.ValidarLimiteCreditoResponse_element response = new WSValidarLimiteCredito.ValidarLimiteCreditoResponse_element();
            response.ValidarLimiteCreditoResult = new WSValidarLimiteCredito.ResultadoValidacionLimiteCredito();
            response.ValidarLimiteCreditoResult.Mensaje = 'Aprobado';
            response.ValidarLimiteCreditoResult.Resultado = '1';
            
            responseMap.put('response_x', response);
        }
    }
    
    global class WSValidaCreditoRechazoMockImpl implements WebServiceMock {
        
        public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        
            if( request instanceOf WSValidarLimiteCredito.ValidarLimiteCredito_element ) {
                WSValidarLimiteCredito.ValidarLimiteCreditoResponse_element response = new WSValidarLimiteCredito.ValidarLimiteCreditoResponse_element();
                response.ValidarLimiteCreditoResult = new WSValidarLimiteCredito.ResultadoValidacionLimiteCredito();
                response.ValidarLimiteCreditoResult.Mensaje = 'El cliente alcanzo el limite de credito.';
                response.ValidarLimiteCreditoResult.Resultado = '0';
                
                responseMap.put('response_x', response);
            }
        }
    }
    
    global class WSValidaCreditoNoRespMockImpl implements WebServiceMock {
        
        public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        
            if( request instanceOf WSValidarLimiteCredito.ValidarLimiteCredito_element ) {
                WSValidarLimiteCredito.ValidarLimiteCreditoResponse_element response = new WSValidarLimiteCredito.ValidarLimiteCreditoResponse_element();
                responseMap.put('response_x', response);
            }
        }
    }
}