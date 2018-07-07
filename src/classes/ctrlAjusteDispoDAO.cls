/*
 * @developer   : Rene Carpazo
 * @company     : Evolusoftware
 * @created     : 2017-07-05
 * @description : This class is a database access to vfpAjusteDispo VF page.
 */
public with sharing class ctrlAjusteDispoDAO {
    
    private final boolean ISTEST = false;

    public Id obtenerOficina(String Key){
        list<Oficina_de_Venta__c> result = [SELECT Id FROM Oficina_de_Venta__c WHERE Codigo__c =:Key];
        return (!result.isEmpty())?result[0].Id:null;
    }
    
    public String obtenerCodigoOficina(Id recordId){
        list<Oficina_de_Venta__c> result = [SELECT Id,Codigo__c FROM Oficina_de_Venta__c WHERE Id=:recordId];
        return (!result.isEmpty())?result[0].Codigo__c:null;
    }
    
    public Oficina_de_Venta__c obtenerPlanta(Id idplanta){
        list<Oficina_de_Venta__c> result = [SELECT Id,Name,Codigo__c,IdPlanta__c FROM Oficina_de_Venta__c WHERE Id=:idplanta AND IdPlanta__c != null];
        return (result.isEmpty())?null:result[0];
    }
    
    public Id obtenerProducto(String Key){
        list<Product2> result = [SELECT Id FROM Product2 WHERE Codigo_Id_Externo__c =:Key AND IsActive = true];
        return (!result.isEmpty())?result[0].Id:null;
    }

    public String obtenerCodigoProducto(Id recordId){
        list<Product2> result = [SELECT Id,Codigo_Id_Externo__c FROM Product2 WHERE Id=:recordId];
        return (!result.isEmpty())?result[0].Codigo_Id_Externo__c:null;
    }
    
    public boolean ProductoValido(Id recordId){
        list<Product2> result = [SELECT Id FROM Product2 WHERE Id=:recordId AND IsActive = true];
        return (!result.isEmpty())?true:false;
    }
    
    public void guardarAjustes(list<AjusteDisponiblidadPlanta__c> ajustesPlanta){
        insert ajustesPlanta;
        
    }
    
    public list<Product2> obtenerProductos(list<Product2> lsproductos){
        return [SELECT Id,Name,ProductCode,Codigo_Id_Externo__c FROM Product2 WHERE Id=:lsproductos AND IsActive = true ORDER BY Name];
    }
    
    /* LLAMADO A WS */
    public void obtenerDatosWS(Oficina_de_Venta__c Planta,list<Product2> lsProductos,Date FechaI,Date FechaF,map<String,ctrlAjusteDispo.Producto>mpTabla){
        //contenedor de consulta
        ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud dispoWS = generaSolicitud(Planta,lsProductos,FechaI,FechaF);
        
        ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap request = new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap();
        request.timeout_x = PedidosOtrosCanalesUtils.WEB_SERVICE_TIMEOUT;
        ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas response = (ISTEST || Test.isRunningTest())?llenadoTest():request.ConsultaDisponibilidad(dispoWS);
        System.debug(response.Tipo);
        System.debug(response.Mensaje);
        //llena informacion
        llenarFechas(response.Datos,mpTabla,Planta);
    }
    
    private void llenarFechas(ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas Datos,map<String,ctrlAjusteDispo.Producto>mpTabla,Oficina_de_Venta__c Planta){
        Integer codigoPlanta = Integer.valueOf(Planta.Codigo__c);
        if(Datos != null && Datos.DisponibilidadMayoristas != null){
            for(ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas disp: Datos.DisponibilidadMayoristas){
                String cveProd = obtenerCodigoProd(disp.producto);
                if(codigoPlanta == disp.origen && mpTabla.containsKey(cveProd))
                    mpTabla.get(cveProd).insertaDisponibilidad(stringToDate(disp.fecha),Integer.valueOf(disp.contenido));
            }
        }
    }
    
    private ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud generaSolicitud(Oficina_de_Venta__c Planta,list<Product2> lsProductos,Date FechaI,Date FechaF){
        ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud result = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud();
        result.Canal = 0; //0; //Canal: EX, MY...
        result.almacenes = new ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesConsulta();
        result.almacenes.AlmacenesConsulta = new list<ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta>();
        ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta alm = new ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta();
        alm.almacen = Integer.valueOf(Planta.Codigo__c);
        result.almacenes.AlmacenesConsulta.add(alm);
        
        result.almacenesDestino = new ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesDestinoConsulta();
        result.almacenesDestino.AlmacenesDestinoConsulta = new list<ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta>();
        ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta almD = new ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta();
        almD.almacenDestino = Integer.valueOf(Planta.Codigo__c);
        result.almacenesDestino.AlmacenesDestinoConsulta.add(almD);
        
        result.fechaInicio = dateToString(FechaI,'yyyyMMdd'); //'20161024';
        result.fechaFin = dateToString(FechaF,'yyyyMMdd');//'20161102';
        result.area = 0; //0;
        result.tipoInventario = 5;
        result.productos = new ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta();
        result.productos.ProductosConsulta = new list<ConsultaDisponibilidadMayoristasWS.ProductosConsulta>();
        for(Product2 P: lsProductos){
            ConsultaDisponibilidadMayoristasWS.ProductosConsulta pc = new ConsultaDisponibilidadMayoristasWS.ProductosConsulta();
            pc.producto = Integer.valueOf(p.ProductCode);
            result.productos.ProductosConsulta.add(pc);
        }
        return result;
    }
    
    public static String dateToString(Date dFecha, String format){
        DateTime fechaHora = datetime.newInstance(dFecha.year(), dFecha.month(), dFecha.day());
        String sFecha = fechaHora.format(format);
        return sFecha;
    }

    public static Date stringToDate(String sFecha){
        Integer Anio = Integer.valueOf(sFecha.substring(6));
        Integer mes = Integer.valueOf(sFecha.substring(3,5)); 
        Integer dia = Integer.valueOf(sFecha.substring(0,2));   
        return Date.newInstance(Anio,mes,dia);
    }
    
    public static string obtenerCodigoProd(String producto){
        list<String> lsProducto = producto.split('-');
        return (lsProducto.isEmpty())?null:lsProducto[0].trim();
    }
    
    //prueba de llenado
    public ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas llenadoTest(){
        ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas response = new ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas();
        response.Tipo = 'TEST';
        response.Mensaje = 'TEST';
        response.Datos = new ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas();
        response.Datos.DisponibilidadMayoristas = new list<ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas>();
        for(Integer J = 0;J<3;J++){
            Date fecha = Date.today();
            for(Integer K = 1;K<=Date.daysInMonth(fecha.year(),fecha.month());K++){
                ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispM = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
                dispM.canal = 0;
                dispM.origen = 64;
                dispM.producto = (new list<String>{'1 - NOMBRE NO DISP','1013 - NOMBRE NO DISP','1014 - NOMBRE NO DISP'})[j];
                dispM.pesoPromedio = 0;
                dispM.tipoInventario = '5';
                dispM.fecha = ('00' + K).right(2) + '-' + ('00' + fecha.month()).right(2) + '-' + fecha.year();
                dispM.contenido = (Integer)(((J + K)*10)/5);
                if(dispM.contenido > 0)
                    response.Datos.DisponibilidadMayoristas.add(dispM);
            }
        }
        return response;
    }
    /* ENVIA NUEVO AJUSTE */
    public String enviaNuevoAjuse(list<AjusteDisponiblidadPlanta__c> ajustesPlanta,String usuarioREG){
        AjusteDisponibilidadPlantasWS.AjusteDisponibilidad solWS = new AjusteDisponibilidadPlantasWS.AjusteDisponibilidad();
        solWS.ajustesDisponibilidad = new AjusteDisponibilidadPlantasWS.ArrayOfAjusteDispo();
        solWS.ajustesDisponibilidad.AjusteDispo = generaElementos(ajustesPlanta,usuarioREG);
        
        AjusteDisponibilidadPlantasWS.AjusteDisponibilidadPlantasSoap request = new AjusteDisponibilidadPlantasWS.AjusteDisponibilidadPlantasSoap();
        request.timeout_x = PedidosOtrosCanalesUtils.WEB_SERVICE_TIMEOUT;
        AjusteDisponibilidadPlantasWS.RespuestaOfInt32 response = (ISTEST || Test.isRunningTest())?llenadoTest2():request.AjusteDisponibilidad(solWS);
        System.debug('Datos: ' + ((response == null)?null:response.Datos));
        System.debug('Mensaje: ' + ((response == null)?null:response.Mensaje));
        System.debug('Tipo: ' + ((response == null)?null:response.Tipo));
        
        return (response == null || response.Tipo == null)?'SIN RESPUESTA DEL SERVICIO':((response.Tipo.equalsIgnoreCase('TerminadoConExito'))?null:((response.Mensaje == null)?'SIN RESPUESTA DEL SERVICIO':response.Mensaje));
    }
    
    private list<AjusteDisponibilidadPlantasWS.AjusteDispo> generaElementos(list<AjusteDisponiblidadPlanta__c> ajustesPlanta,String usuarioREG){
        list<AjusteDisponibilidadPlantasWS.AjusteDispo> response = new list<AjusteDisponibilidadPlantasWS.AjusteDispo>();
        String FECHAREG = dateToString(Date.Today(),'yyyyMMdd'); 
        for(AjusteDisponiblidadPlanta__c A: ajustesPlanta){
            AjusteDisponibilidadPlantasWS.AjusteDispo TEMP = new AjusteDisponibilidadPlantasWS.AjusteDispo();
            TEMP.OficinaVta = Integer.valueOf(A.Oficina_Venta__r.Codigo__c);
            TEMP.TipoInventario = 5;
            TEMP.FechaEmb = dateToString(A.Fecha_Embarque__c,'yyyyMMdd');
            TEMP.UsuarioRegistro = usuarioREG;
            TEMP.FechaRegistro = FECHAREG;
            TEMP.Producto = Integer.valueOf(A.Producto__r.ProductCode);
            TEMP.CantCajasAjusto = (Integer)A.Ajuste_Cajas__c;
            System.debug('OF:' + TEMP.OficinaVta + ', TI:'+ TEMP.TipoInventario + ', FE:' + TEMP.FechaEmb + ', UR:' + TEMP.UsuarioRegistro + ', FR:' + TEMP.FechaRegistro + ', PR:' + TEMP.Producto + ',CC:' + TEMP.CantCajasAjusto);
            response.add(TEMP);
        }
        return response;
    }
    
    private AjusteDisponibilidadPlantasWS.RespuestaOfInt32 llenadoTest2(){
        AjusteDisponibilidadPlantasWS.RespuestaOfInt32 response = new AjusteDisponibilidadPlantasWS.RespuestaOfInt32();
        response.Datos = 0;
        response.Mensaje = '¡Configuración de ajuste disponibilidad realizada con exito!';
        response.Tipo = 'TerminadoConExito';
        return response;
    }
}