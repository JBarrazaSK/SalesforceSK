/**
 * Description: Test methods of the ClienteInsertSAPPIWS class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 08/09/2014
 **/
@isTest
global class ClienteInsertSAPPIWSTest implements WebServiceMock {
    
    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        ClienteInsertSAPPIWS.SI_OS_SalesForce_CreacionClientes_2Response_element response = new ClienteInsertSAPPIWS.SI_OS_SalesForce_CreacionClientes_2Response_element();
        response.SI_OS_SalesForce_CreacionClientes_2Result = new ClienteInsertSAPPIWS.DT_SF_CreacionClientes_return();
        responseMap.put('response_x', response);
    }
    
    global class ClienteInsertSAPPIWSTestFail implements WebServiceMock {
     	  
     	  public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
	        if( request instanceOf WSCreacionprospectos.SI_OS_SalesForce_CreacionClientesEnSAP_2_element ) {
	        	
	        	  ClienteInsertSAPPIWS.SI_OS_SalesForce_CreacionClientes_2Response_element response = new ClienteInsertSAPPIWS.SI_OS_SalesForce_CreacionClientes_2Response_element();
        		  response.SI_OS_SalesForce_CreacionClientes_2Result = new ClienteInsertSAPPIWS.DT_SF_CreacionClientes_return();
        		  response.SI_OS_SalesForce_CreacionClientes_2Result.Msg_1 = 'Error';
        		  response.SI_OS_SalesForce_CreacionClientes_2Result.Msg_1 = 'Error';
	              responseMap.put('response_x', response);
	        }
	    }
     }
}