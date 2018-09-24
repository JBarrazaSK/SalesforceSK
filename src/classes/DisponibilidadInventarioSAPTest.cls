@isTest
public class DisponibilidadInventarioSAPTest implements WebServiceMock {
    
     public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        if(request instanceOf DisponibilidadInventarioSAP.Informacion_element) {
            DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp response = new DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp();
            response.TipoMensaje = 'OK';
            response.Mensaje = 'SUCCCES';
            responseMap.put( 'response_x', response);
            }
            
        }
    
    static testmethod void myTest(){
        
        new DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Req();
        new DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp();
        new DisponibilidadInventarioSAP.Informacion_element();
    }
}