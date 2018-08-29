/**
 * Description: WsArmarEmbarqueSDL.cls test methods.
 * Author: Ramon atondo
 * Company: Sk
 * Email:
 * Created date: 22/08/2018
 **/
@istest
global class  WSDisponibilidadInventarioSAPMock implements WebServiceMock {
     public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {       
            if( request instanceOf WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAP_element ) 
            {
                WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAPResponse_element response = new WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAPResponse_element();
                response.ConsultarDisponibilidadSAPResult = new DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp();
              	DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp respuesta = new DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp();
                respuesta.TipoMensaje = 'S';
                respuesta.Mensaje = 'Mensaje';
            
                response.ConsultarDisponibilidadSAPResult =  respuesta;
                system.debug('RESPESTAMOCK=> ' + response);
                responseMap.put('response_x', response);
            }
        }
        global class  WSDisponibilidadInventarioSAFailPMock implements WebServiceMock {
            public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {       
                if( request instanceOf WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAP_element ) 
                {
                    WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAPResponse_element response = new WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAPResponse_element();
                    response.ConsultarDisponibilidadSAPResult = new DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp();
                    DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp respuesta = new DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp();
                    respuesta.TipoMensaje = 'E';
                    respuesta.Mensaje = 'Mensaje';
                    
                    response.ConsultarDisponibilidadSAPResult =  respuesta;
                    system.debug('RESPESTAMOCK=> ' + response);
                    responseMap.put('response_x', response);
                }
            }
        }
}