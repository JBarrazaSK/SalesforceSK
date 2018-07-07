/*
 * @developer   : Rene Carpazo
 * @company     : Evolusoftware
 * @created     : 2017-07-06
 * @description : This class is a database accesto vfpDispDiaraPlanta VF page.
 */
public with sharing class ctrlDispDiaraPlantaDAO {

    /*public Id obtenerPlanta(String Key){
        list<Oficina_de_Venta__c> result = [SELECT Id FROM Oficina_de_Venta__c WHERE Codigo__c =:Key AND IdPlanta__c != null];
        return (!result.isEmpty())?result[0].Id:null;
    }
    
    public String obtenerCodigoPlanta(Id recordId){
        list<Oficina_de_Venta__c> result = [SELECT Id,Codigo__c FROM Oficina_de_Venta__c WHERE Id=:recordId];
        return (!result.isEmpty())?result[0].Codigo__c:null;
    }
    
    public boolean plantaValida(Id recordId){
        list<Oficina_de_Venta__c> result = [SELECT Id FROM Oficina_de_Venta__c WHERE Id=:recordId AND IdPlanta__c != null];
        return (!result.isEmpty())?true:false;
    }
    
    public list<Oficina_de_Venta__c> obtenerPlantas(list<Oficina_de_Venta__c> lsPlantas){
        return [SELECT Id,Name,Codigo__c,IdPlanta__c FROM Oficina_de_Venta__c WHERE Id=:lsPlantas AND IdPlanta__c != null ORDER BY Name];
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
    
    public list<Product2> obtenerProductos(list<Product2> lsproductos){
        return [SELECT Id,Name,ProductCode,Codigo_Id_Externo__c FROM Product2 WHERE Id=:lsproductos AND IsActive = true ORDER BY Name];
    }*/
    
    public list<Oficina_de_Venta__c> obtenerPlantas(set<Id> stIdSelecc){
    	return [SELECT Id,Name,Codigo__c,IdPlanta__c FROM Oficina_de_Venta__c WHERE Id IN: stIdSelecc AND IdPlanta__c != null order BY Name];
    }
    
    public list<Product2> obtenerProductos(set<Id> stIdSelecc){
        return [SELECT Id,Name,ProductCode,Codigo_Id_Externo__c FROM Product2 WHERE Producto_Master__c IN:stIdSelecc AND IsActive = true ORDER BY Name];
    }
    
    public list<Producto_Master__c> obtenerMasterDisp(set<Id> stIdSelecc){
    	return [SELECT Id,Name,MasterID__c FROM Producto_Master__c WHERE Id NOT In: stIdSelecc AND MasterID__c != null ORDER BY Name];
    }
    
    public list<Producto_Master__c> obtenerMasterSel(set<Id> stIdSelecc){
    	return [SELECT Id,Name,MasterID__c FROM Producto_Master__c WHERE Id In: stIdSelecc AND MasterID__c != null ORDER BY Name];
    }
    
    public list<Oficina_de_Venta__c> obtenerPlantasDisp(set<Id> stIdSelecc){
    	return [SELECT Id,Name FROM Oficina_de_Venta__c WHERE Id NOT In:stIdSelecc AND IdPlanta__c != null order by Name];
    }
    
    public list<Oficina_de_Venta__c> obtenerPlantasSel(set<Id> stIdSelecc){
    	return [SELECT Id,Name FROM Oficina_de_Venta__c WHERE Id In:stIdSelecc AND IdPlanta__c != null order by Name];
    }
    
    public void obtenerDatosWS(list<Oficina_de_Venta__c> lsPlantas,list<Product2> lsProductos,Date FechaI,Date FechaF,map<String,ctrlDispDiaraPlanta.Master>mpTabla){
        //contenedor de consulta
        ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud dispoWS = generaSolicitud(lsPlantas,lsProductos,FechaI,FechaF);
        
        ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap request = new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap();
        request.timeout_x = PedidosOtrosCanalesUtils.WEB_SERVICE_TIMEOUT;
        ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas response = (Test.isRunningTest())?llenadoTest():request.ConsultaDisponibilidad(dispoWS);
        System.debug(response.Tipo);
        System.debug(response.Mensaje);
        //llena informacion
        llenarFechas(response.Datos,mpTabla);
    }
    
    private void llenarFechas(ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas Datos,map<String,ctrlDispDiaraPlanta.Master>mpTabla){
        if(Datos != null && Datos.DisponibilidadMayoristas != null){
            for(ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas disp: Datos.DisponibilidadMayoristas){
                String codProd = obtenerCodigoProd(disp.producto);
                if(mpTabla.containsKey(codProd))
                    mpTabla.get(codProd).insertaDisponibilidad(disp.origen,stringToDate(disp.fecha),decimal.valueOf(disp.contenido));
            }
        }
    }
    
    private ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud generaSolicitud(list<Oficina_de_Venta__c> lsPlantas,list<Product2> lsProductos,Date FechaI,Date FechaF){
        ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud result = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud();
        result.Canal = 0; //0; //Canal: EX, MY...
        result.almacenes = new ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesConsulta();
        result.almacenes.AlmacenesConsulta = new list<ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta>();
        for(Oficina_de_Venta__c OV: lsPlantas){
            ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta alm = new ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta();
            alm.almacen = Integer.valueOf(OV.Codigo__c);
            result.almacenes.AlmacenesConsulta.add(alm);
        }
        
        result.almacenesDestino = new ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesDestinoConsulta();
        result.almacenesDestino.AlmacenesDestinoConsulta = new list<ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta>();
        for(Oficina_de_Venta__c OV: lsPlantas){
            ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta alm = new ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta();
            alm.almacenDestino = Integer.valueOf(OV.Codigo__c);
            result.almacenesDestino.AlmacenesDestinoConsulta.add(alm);
        }
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
        for(Integer I = 0;I<3;I++){
            for(Integer J = 0;J<3;J++){
                Date fecha = Date.today();
                for(Integer K = 1;K<=Date.daysInMonth(fecha.year(),fecha.month());K++){
                    ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dispM = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas();
                    dispM.canal = 0;
                    dispM.origen = (new list<Integer>{64,892,105})[I];
                    dispM.producto = (new list<String>{'1 - NOMBRE NO DISP','1013 - NOMBRE NO DISP','1014 - NOMBRE NO DISP'})[j];
                    dispM.pesoPromedio = 0;
                    dispM.tipoInventario = '5';
                    dispM.fecha = ('00' + K).right(2) + '-' + ('00' + fecha.month()).right(2) + '-' + fecha.year();
                    dispM.contenido = (Integer)(((I + J + K)*10)/5);
                    if(dispM.contenido > 0)
                        response.Datos.DisponibilidadMayoristas.add(dispM);
                }
            }
        }
        return response;
    }
}