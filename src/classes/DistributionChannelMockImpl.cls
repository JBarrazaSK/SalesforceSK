/*    
    @Purpose      : Mock response class for Outsurance webservice
    @Author       : Poonam
    @Created Date : 24/06/2016
*/

global class DistributionChannelMockImpl implements WebServiceMock {
    global void doInvoke(Object stub,
                         Object request,
                         Map<String, Object> response,
                         String endpoint,
                         String soapAction,
                         String requestName,
                         String responseNS,
                         String responseName,
                         String responseType) {
        
        if(request instanceof wwwSukarneComWsSalesforce.RegresaDisponibilidadGlobal_element ){
            
            // Typecast the request element
            wwwSukarneComWsSalesforce.RegresaDisponibilidadGlobal_element requestElement = (wwwSukarneComWsSalesforce.RegresaDisponibilidadGlobal_element)request;
            
            // Create response instance
            wwwSukarneComWsSalesforce.RegresaDisponibilidadGlobalResponse_element responseElement = 
                new wwwSukarneComWsSalesforce.RegresaDisponibilidadGlobalResponse_element();
            
            // Check for valid channel
            if(requestElement.canal == 2){                
                
                // Create response data
                wwwSukarneComWsSalesforce.ArrayOfInventarioGlobal datos = new wwwSukarneComWsSalesforce.ArrayOfInventarioGlobal();
                List<wwwSukarneComWsSalesforce.InventarioGlobal> inventarioList = new List<wwwSukarneComWsSalesforce.InventarioGlobal>();
                
                wwwSukarneComWsSalesforce.InventarioGlobal product1 = new wwwSukarneComWsSalesforce.InventarioGlobal();
                product1.Producto  = 1;            
                inventarioList.add(product1);
                
                wwwSukarneComWsSalesforce.InventarioGlobal product2 = new wwwSukarneComWsSalesforce.InventarioGlobal();
                product2.Producto  = 11;
                inventarioList.add(product2);
                
                wwwSukarneComWsSalesforce.InventarioGlobal product3 = new wwwSukarneComWsSalesforce.InventarioGlobal();
                product3.Producto  = 111;
                inventarioList.add(product3);
                
                datos.InventarioGlobal = inventarioList;
                
                wwwSukarneComWsSalesforce.RespuestaOfListOfInventarioGlobal listOfDatos = new wwwSukarneComWsSalesforce.RespuestaOfListOfInventarioGlobal();
                listOfDatos.Datos = datos;
                
                responseElement.RegresaDisponibilidadGlobalResult = listOfDatos;
            }
            
            response.put('response_x', responseElement);
        }
    }
}