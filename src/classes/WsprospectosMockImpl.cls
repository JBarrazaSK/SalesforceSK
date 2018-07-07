@isTest
global class WsprospectosMockImpl implements WebServiceMock{

	 public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        if( request instanceOf WSCreacionprospectos.SI_OS_SalesForce_CreacionClientesEnSAP_2_element ) {
        	 WSCreacionprospectos.SI_OS_SalesForce_CreacionClientesEnSAP_2Response_element response = new WSCreacionprospectos.SI_OS_SalesForce_CreacionClientesEnSAP_2Response_element();
            
            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result = new wsCreacionProspectos.DT_SF_CreacionProspectos_RespMensaje_respuesta();
            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result.Tipo_mensaje = 'S';
            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result.Msg_1 = '8012345';
            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result.Msg_2 = 'Grabado con éxito';
            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result.Texto_Msg = '8012345';
            responseMap.put('response_x', response);
        }
    }
    
     global class WsprospectosWebServiceMockFail implements WebServiceMock {
     	  public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
	        if( request instanceOf WSCreacionprospectos.SI_OS_SalesForce_CreacionClientesEnSAP_2_element ) {
	        	 WSCreacionprospectos.SI_OS_SalesForce_CreacionClientesEnSAP_2Response_element response = new WSCreacionprospectos.SI_OS_SalesForce_CreacionClientesEnSAP_2Response_element();
	            
	            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result = new wsCreacionProspectos.DT_SF_CreacionProspectos_RespMensaje_respuesta();
	            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result.Tipo_mensaje = 'E';
	            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result.Msg_1 = '8012345';
	            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result.Msg_2 = 'Grabado con éxito';
	            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result.Texto_Msg = '8012345';
	            responseMap.put('response_x', response);
	        }
	    }
     }

     global class WsprospectosWebServiceMockFail2 implements WebServiceMock {
     	  public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
	        if( request instanceOf WSCreacionprospectos.SI_OS_SalesForce_CreacionClientesEnSAP_2_element ) {
	        	 WSCreacionprospectos.SI_OS_SalesForce_CreacionClientesEnSAP_2Response_element response = new WSCreacionprospectos.SI_OS_SalesForce_CreacionClientesEnSAP_2Response_element();
	            
	            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result = new wsCreacionProspectos.DT_SF_CreacionProspectos_RespMensaje_respuesta();
	            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result.Tipo_mensaje = 'E';
	            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result.Msg_1 = '8012345';
	            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result.Msg_2 = 'Grabado con éxito';
	            response.SI_OS_SalesForce_CreacionClientesEnSAP_2Result.Texto_Msg = 'Falso';
	            responseMap.put('response_x', response);
	        }
	    }
     }
}