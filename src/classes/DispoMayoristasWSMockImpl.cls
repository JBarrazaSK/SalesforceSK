/**
  * @Description : Mock Implementation Class in order to validate DisponibilidadMayoristar WS Response
  * @Created Date: 29 September 2016
  * @Author: Jorge Terán - jorge.teran@lynx9.com
  * @Company: LYNX9 Soluciones
 */
@isTest
global class DispoMayoristasWSMockImpl implements WebServiceMock {
    
    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        
        if( request instanceOf ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidad_element ) {
        	ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadResponse_element response = new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadResponse_element();
            //ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas ConsultaDisponibilidadResult = new ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas();
            response.ConsultaDisponibilidadResult = new ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas();
            //ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas Datos = new ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas();
            response.ConsultaDisponibilidadResult.Datos = new ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas();
            response.ConsultaDisponibilidadResult.Tipo = 'TerminadoConExito';
            
            List<ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas> dispos = new List<ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas>();
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo0 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo0.canal = 0;
                    dispo0.origen = 64;
                    dispo0.producto = '12 - GOOSENECK/PULPA GUSANO';
                    dispo0.pesoPromedio = 28.84;
                    dispo0.tipoInventario = 'IMPORTADO';
                    dispo0.fecha = '20-02-2017';
                    dispo0.contenido = 800;
            	dispos.add( dispo0 );
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo1 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo1.canal = 0;
                    dispo1.origen = 64;
                    dispo1.producto = '12 - GOOSENECK/PULPA GUSANO';
                    dispo1.pesoPromedio = 28.84;
                    dispo1.tipoInventario = 'IMPORTADO';
                    dispo1.fecha = '23-02-2017';
                    dispo1.contenido = 800;
            	dispos.add( dispo1 );
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo2 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo2.canal = 0;
                    dispo2.origen = 64;
                    dispo2.producto = '12 - GOOSENECK/PULPA GUSANO';
                    dispo2.pesoPromedio = 28.84;
                    dispo2.tipoInventario = 'IMPORTADO';
                    dispo2.fecha = '25-02-2017';
                    dispo2.contenido = 800;
            	dispos.add( dispo2 );
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo3 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo3.canal = 0;
                    dispo3.origen = 64;
                    dispo3.producto = '12 - GOOSENECK/PULPA GUSANO';
                    dispo3.pesoPromedio = 28.84;
                    dispo3.tipoInventario = 'IMPORTADO';
                    dispo3.fecha = '01-03-2017';
                    dispo3.contenido = 800;
            	dispos.add( dispo3 );
            	/**** 13 ***/
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo4 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo4.canal = 0;
                    dispo4.origen = 64;
                    dispo4.producto = '13 - GOOSENECK/PULPA GUSANO';
                    dispo4.pesoPromedio = 28.84;
                    dispo4.tipoInventario = 'IMPORTADO';
                    dispo4.fecha = '20-02-2017';
                    dispo4.contenido = 800;
            	dispos.add( dispo4 );
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo5 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo5.canal = 0;
                    dispo5.origen = 64;
                    dispo5.producto = '13 - GOOSENECK/PULPA GUSANO';
                    dispo5.pesoPromedio = 28.84;
                    dispo5.tipoInventario = 'IMPORTADO';
                    dispo5.fecha = '23-02-2017';
                    dispo5.contenido = 800;
            	dispos.add( dispo5 );
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo6 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo6.canal = 0;
                    dispo6.origen = 64;
                    dispo6.producto = '13 - GOOSENECK/PULPA GUSANO';
                    dispo6.pesoPromedio = 28.84;
                    dispo6.tipoInventario = 'IMPORTADO';
                    dispo6.fecha = '25-02-2017';
                    dispo6.contenido = 800;
            	dispos.add( dispo6 );
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo7 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo7.canal = 0;
                    dispo7.origen = 64;
                    dispo7.producto = '13 - GOOSENECK/PULPA GUSANO';
                    dispo7.pesoPromedio = 28.84;
                    dispo7.tipoInventario = 'IMPORTADO';
                    dispo7.fecha = '28-02-2017';
                    dispo7.contenido = 800;
            	dispos.add( dispo7 );
            /*** 2145 ***/
				ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo8 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo8.canal = 0;
                    dispo8.origen = 64;
                    dispo8.producto = '2145 - RIBEYE LIP ON 11UP/RIB EYE';
                    dispo8.pesoPromedio = 28.84;
                    dispo8.tipoInventario = 'IMPORTADO';
                    dispo8.fecha = '20-02-2017';
                    dispo8.contenido = 800;
            	dispos.add( dispo8 );
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo9 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo9.canal = 0;
                    dispo9.origen = 64;
                    dispo9.producto = '2145 - RIBEYE LIP ON 11UP/RIB EYE';
                    dispo9.pesoPromedio = 28.84;
                    dispo9.tipoInventario = 'IMPORTADO';
                    dispo9.fecha = '25-02-2017';
                    dispo9.contenido = 800;
            	dispos.add( dispo9 );
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo10 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo10.canal = 0;
                    dispo10.origen = 64;
                    dispo10.producto = '2145 - RIBEYE LIP ON 11UP/RIB EYE';
                    dispo10.pesoPromedio = 28.84;
                    dispo10.tipoInventario = 'IMPORTADO';
                    dispo10.fecha = '28-02-2017';
                    dispo10.contenido = 800;
            	dispos.add( dispo10 );
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo11 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo11.canal = 0;
                    dispo11.origen = 64;
                    dispo11.producto = '2145 - RIBEYE LIP ON 11UP/RIB EYE';
                    dispo11.pesoPromedio = 28.84;
                    dispo11.tipoInventario = 'IMPORTADO';
                    dispo11.fecha = '01-03-2017';
                    dispo11.contenido = 800;
            	dispos.add( dispo11 );   
            /*** 5 ***/
				ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo12 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo12.canal = 0;
                    dispo12.origen = 64;
                    dispo12.producto = '5 - FULL PEELED KNUCKLE/PULPA BOLA LIMPIA';
                    dispo12.pesoPromedio = 28.84;
                    dispo12.tipoInventario = 'IMPORTADO';
                    dispo12.fecha = '20-02-2017';
                    dispo12.contenido = 800;
            	dispos.add( dispo12 );
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo13 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo13.canal = 0;
                    dispo13.origen = 64;
                    dispo13.producto = '5 - FULL PEELED KNUCKLE/PULPA BOLA LIMPIA';
                    dispo13.pesoPromedio = 28.84;
                    dispo13.tipoInventario = 'IMPORTADO';
                    dispo13.fecha = '25-02-2017';
                    dispo13.contenido = 800;
            	dispos.add( dispo13 );
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo14 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo14.canal = 0;
                    dispo14.origen = 64;
                    dispo14.producto = '5 - FULL PEELED KNUCKLE/PULPA BOLA LIMPIA';
                    dispo14.pesoPromedio = 28.84;
                    dispo14.tipoInventario = 'IMPORTADO';
                    dispo14.fecha = '26-02-2017';
                    dispo14.contenido = 800;
            	dispos.add( dispo14 );
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo15 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo15.canal = 0;
                    dispo15.origen = 64;
                    dispo15.producto = '5 - FULL PEELED KNUCKLE/PULPA BOLA LIMPIA';
                    dispo15.pesoPromedio = 28.84;
                    dispo15.tipoInventario = 'IMPORTADO';
                    dispo15.fecha = '28-02-2017';
                    dispo15.contenido = 800;
            	dispos.add( dispo15 );
            	ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispo16 = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
            		dispo16.canal = 0;
                    dispo16.origen = 64;
                    dispo16.producto = '10251714 - FZN LIP ON RIB EYE 11 DN';
                    dispo16.pesoPromedio = 28.84;
                    dispo16.tipoInventario = 'IMPORTADO';
                    dispo16.fecha = '01-03-2017';
                    dispo16.contenido = 800;
            	dispos.add( dispo15 );
            
            response.ConsultaDisponibilidadResult.Datos.DisponibilidadMayoristas = dispos;
            responseMap.put('response_x', response);
        }
    }
    
    global class WSDispoNoRespMockImpl implements WebServiceMock {
    
        public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            
            if( request instanceOf ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidad_element ) {
                ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadResponse_element response = new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadResponse_element();
                response.ConsultaDisponibilidadResult = new ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas();
                response.ConsultaDisponibilidadResult.Datos = new ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas();
                response.ConsultaDisponibilidadResult.Tipo = 'TerminadoConExito';
                response.ConsultaDisponibilidadResult.Datos.DisponibilidadMayoristas = null;
                responseMap.put('response_x', response);
            }
        }
    }
     global class WSDispoNoRespMockImplConError implements WebServiceMock {
    
        public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            
            if( request instanceOf ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidad_element ) {
                ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadResponse_element response = new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadResponse_element();
                response.ConsultaDisponibilidadResult = new ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas();
                response.ConsultaDisponibilidadResult.Datos = new ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas();
                response.ConsultaDisponibilidadResult.Tipo = 'TerminadoConErrores';
                response.ConsultaDisponibilidadResult.Datos.DisponibilidadMayoristas = null;
                responseMap.put('response_x', response);
            }
        }
    }
    global class WSDispoNoRespMockImplConErrorNull implements WebServiceMock {
    
        public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            
            if( request instanceOf ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidad_element ) {
                ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadResponse_element response = new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadResponse_element();
                response.ConsultaDisponibilidadResult = new ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas();
                response.ConsultaDisponibilidadResult.Datos = new ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas();
                response.ConsultaDisponibilidadResult.Tipo = 'TerminadoConErrores';
                response.ConsultaDisponibilidadResult.Datos.DisponibilidadMayoristas = null;
                responseMap.put('response_x', null);
            }
        }
    }
    global class WSDispoNoRespMockImplConErrorCallOut implements WebServiceMock {
    
        public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            
            if( request instanceOf ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidad_element ) {
                ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadResponse_element response = new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadResponse_element();
                response.ConsultaDisponibilidadResult = new ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas();
                response.ConsultaDisponibilidadResult.Datos = new ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas();
                response.ConsultaDisponibilidadResult.Tipo = 'TerminadoConErrores';
                response.ConsultaDisponibilidadResult.Datos.DisponibilidadMayoristas = null;
                responseMap.put('response_x2', null);
            }
        }
    }
}