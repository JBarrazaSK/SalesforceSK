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
    	system.debug('CONSULTANDODISPONIBILIDAD=>=>');  
         if( request instanceOf WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAP_element ) 
            {
                 
                
                WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAPResponse_element response = new WSDisponibilidadInventarioSAP.ConsultarDisponibilidadSAPResponse_element();
                response.ConsultarDisponibilidadSAPResult = new DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp();
              	DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp respuesta = new DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp();
                DisponibilidadInventarioSAP.Informacion_element informacion = new DisponibilidadInventarioSAP.Informacion_element();
                respuesta.TipoMensaje = 'S';
                respuesta.Mensaje = 'Mensaje';                                
                informacion.NumeroProducto='';
                informacion.InventarioActual='';
                informacion.ComprometidoAlmacenHoy='';
                informacion.ComprometidoAlmacenManana='';
                informacion.DisponibilidadAlmacen='';
                informacion.InventarioConfigurado='';
                informacion.ComprasConfigManana='';
                informacion.ResAlm='';
                informacion.ResConf='';
                informacion.PermiteApartarSinExistencias='';
                informacion.TipoInventario='';
                informacion.TipoManejoInventario='';
                informacion.EsPesoEstandar='';
                informacion.Contenido='';
                informacion.NumeroProducto='';
                informacion.InventarioActual='';
                informacion.ComprometidoAlmacenHoy='';
                informacion.ComprometidoAlmacenManana='';
                informacion.DisponibilidadAlmacen='';
                informacion.InventarioConfigurado='';
                informacion.ComprasConfigManana='';
                informacion.ResAlm='';
                informacion.ResConf='';
                informacion.PermiteApartarSinExistencias='';
                informacion.TipoInventario='';
                informacion.TipoManejoInventario='';
                informacion.EsPesoEstandar='';
                informacion.Contenido='';
                system.debug('RESPUESTAMOCK=> ' + respuesta);
                respuesta.Informacion.add(informacion);            
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