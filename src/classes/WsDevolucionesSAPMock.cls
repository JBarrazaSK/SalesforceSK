global class WsDevolucionesSAPMock implements WebServiceMock {    
    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {        
           if( request instanceOf WsDevolucionesSAP.DevolucionSAP_element) {
               system.debug('ENTRODEVOLUCION=>');
               WsDevolucionesSAP.DevolucionSAPResponse_element Response = new WsDevolucionesSAP.DevolucionSAPResponse_element();  
               Response.DevolucionSAPResult  =  new EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Resp();
               EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Resp respuesta = new EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Resp();    
               respuesta.TipoMensaje= 'OK';
               respuesta.Mensaje = 'Success';
               Response.DevolucionSAPResult =  respuesta;
               system.debug('RESPONSEDEVOLUCION=> '+ Response);
       		responseMap.put('response_x', Response);
        }
    } 
    global class WsDevolucionesSAPFailMock implements WebServiceMock {    
    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {        
           if( request instanceOf WsDevolucionesSAP.DevolucionSAP_element) {
               system.debug('ENTRODEVOLUCION=>');
               WsDevolucionesSAP.DevolucionSAPResponse_element Response = new WsDevolucionesSAP.DevolucionSAPResponse_element();  
               Response.DevolucionSAPResult  =  new EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Resp();
               EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Resp respuesta = new EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Resp();    
               respuesta.TipoMensaje= 'ERROR';
               respuesta.Mensaje = 'Success';
               Response.DevolucionSAPResult =  respuesta;
               system.debug('RESPONSEDEVOLUCION=> '+ Response);
       		responseMap.put('response_x', Response);
        }
    } 
    }
   global class WsConsultaFacturaSAPMock implements WebServiceMock {    
        public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {        
               if( request instanceOf WsDevolucionesSAP.DetalleFactura_element) {
                   
                   system.debug('ENTRO A WsConsultaFacturaSAPMock=> ');
                   
                   WsDevolucionesSAP.DetalleFacturaResponse_element Response = new  WsDevolucionesSAP.DetalleFacturaResponse_element(); 
                   Response.DetalleFacturaResult = new EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Resp();
                   EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Resp respuesta = new EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Resp();    
                   respuesta.Datos = new list<EntityConsultaFactura_SF_to_ECC.Datos_element>();
                   EntityConsultaFactura_SF_to_ECC.Cabecero_element Cabecero = new EntityConsultaFactura_SF_to_ECC.Cabecero_element();
                   EntityConsultaFactura_SF_to_ECC.Detalle_element Detalle = new EntityConsultaFactura_SF_to_ECC.Detalle_element();
                   
                   
                   Cabecero.CanalDistribucion  = '';
                   Cabecero.CodigoCliente = 114;
                   cabecero.FechaFactura = String.valueOf(date.today());
                   Cabecero.Sucursal = '';
                   Cabecero.OficinaVentas = '';                   
                   Cabecero.GrupoVendedores = '';
                   Cabecero.ImporteFactura = 100.00;
                   Cabecero.Abonos = 123.20;
                   Cabecero.Saldo = 32.023;
                   Cabecero.Moneda = 'MXN';
                   Cabecero.DescripcionCliente ='Cliente';

                   detalle.SubFamilia = '';
                   detalle.CodigoProducto  = '12';
                   detalle.Volumen = '106';
                   detalle.Cantidad = '100';
                   detalle.Descripcion = '';
                   detalle.MedidaUnidad = '';
                   detalle.Importe = 100;
                   detalle.Precio= 100;

                   EntityConsultaFactura_SF_to_ECC.Datos_element datos = new  EntityConsultaFactura_SF_to_ECC.Datos_element();
                   datos.Detalle  =  new List<EntityConsultaFactura_SF_to_ECC.Detalle_element>();
                   datos.Cabecero  = Cabecero;
                   datos.Detalle.add(detalle);
                   system.debug('DATOS=> '+ datos);
                   respuesta.Datos.add(datos);
                   
                   system.debug('RESPUESTADATOS=> ' + respuesta.Datos);
                   
                   respuesta.TipoMensaje = 'S';
                   respuesta.Mensaje = 'OK';
                   system.debug('RESPONSE=> '+ respuesta);
                   Response.DetalleFacturaResult = respuesta; 
                responseMap.put('response_x', Response);
            }
        } 
   }
      global class WsConsultaFacturaSAPFailMock implements WebServiceMock {    
        public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {        
               if( request instanceOf WsDevolucionesSAP.DetalleFactura_element) {
                   
                   system.debug('ENTRO A WsConsultaFacturaSAPMock=> ');
                   
                   WsDevolucionesSAP.DetalleFacturaResponse_element Response = new  WsDevolucionesSAP.DetalleFacturaResponse_element(); 
                   Response.DetalleFacturaResult = new EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Resp();
                   EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Resp respuesta = new EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Resp();    
                   
                   respuesta.TipoMensaje = 'E';
                   respuesta.Mensaje = 'OK';
                   system.debug('RESPONSE=> '+ respuesta);
                   Response.DetalleFacturaResult = respuesta; 
                responseMap.put('response_x', Response);
            }
        } 
   }
}