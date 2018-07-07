/*
 * @developer   : Rene Carpazo
 * @company     : Evolusoftware
 * @created     : 2017-07-05
 * @description : This class is a controller extension to vfpAjusteDispo VF page.
 */
public with sharing class ctrlAjusteDispo {
    private ctrlAjusteDispoDAO DBA;
    private list<Product2> lsProductos;
    private map<String,Producto> mpTabla;
    public boolean elementosGuardados {get;set;}
    public list<Producto> resTabla{get;set;}
    public AjusteDisponiblidadPlanta__c filtroObj {get;set;}
    public AjusteDisponiblidadPlanta__c filtroObj2 {get;set;} //solo para la segunda fecha
    public String codigoOficina {get;set;}
    public String codigoProducto {get;set;}
    
    public ctrlAjusteDispo(){
        init();
    }
    
    public void init(){
        filtroObj = new AjusteDisponiblidadPlanta__c();
        filtroObj2 = new AjusteDisponiblidadPlanta__c();
        resTabla = new list<Producto>();
        mpTabla = new map<String,Producto>();
        DBA = new ctrlAjusteDispoDAO();
        lsProductos = new list<Product2>();
        codigoOficina = null;
        codigoProducto = null;
        elementosGuardados = false;
        Usuario0 = null;
        Password = null;
    }
    
    public void obtenerOficina(){
        filtroObj.Oficina_Venta__c = DBA.obtenerOficina(codigoOficina);
    }
    
    public void obtenerCodigoOficina(){
        codigoOficina = DBA.obtenerCodigoOficina(filtroObj.Oficina_Venta__c);
    }
    
    //FILTROS PRODUCTO
    public void obtenerProducto(){
        filtroObj.Producto__c = DBA.obtenerProducto(codigoProducto);
    }
    
    public void obtenerCodigoProducto(){
        codigoProducto = DBA.obtenerCodigoProducto(filtroObj.Producto__c);
    }
    
    public void aniadirProducto(){
        if(filtroObj.Producto__c != null && DBA.ProductoValido(filtroObj.Producto__c)){
            lsProductos.add(new Product2(Id=filtroObj.Producto__c));
            lsProductos = DBA.obtenerProductos(lsProductos);
        }else if(filtroObj.Producto__c != null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Producto seleccionado no válida'));
        filtroObj.Producto__c = null;
        codigoProducto = null;
    }
    
    public list<SelectOption> getopProductos(){
        List<SelectOption> result = new List<SelectOption>();
        Integer contador = 0;
        for(Product2 P:lsProductos)
            result.add(new SelectOption('' + contador++ ,P.Name));
        return result;
    }
    
    public String productoSelec{get;set;}
    public void removerProducto(){
        if(productoSelec != null && productoSelec.isNumeric() && Integer.valueOf(productoSelec) < lsProductos.size())
            lsProductos.remove(Integer.valueOf(productoSelec));
        productoSelec = null;
    }
    //Termina filtro productos
    //filtro Responsable
    public String Usuario0{get;set;}
    public String Password{get;set;}
    
    public List<SelectOption> getExternalUsuarios() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Seleccione--'));
        list<String> lsNAMES = new list<String>();
        for(ValidExternalUsers__c V: ValidExternalUsers__c.getall().values())
            lsNAMES.add(V.Name);
        lsNames.sort();
        for(String S:lsNames)
            options.add(new SelectOption(S,S));
        return options;
    }
    
    //termina filtro Responsable
    public void consultaDispo(){
        Oficina_de_Venta__c PlantaInfo = DBA.obtenerPlanta(filtroObj.Oficina_Venta__c);
        if(lsProductos.isEmpty())
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Se requiere ingresar por lo menos un producto'));
        else if(PlantaInfo == null){
            filtroObj.Oficina_Venta__c = null;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Se requiere ingresar una planta válida'));
        }else if(filtroObj.Fecha_Embarque__c == null)
            filtroObj.Fecha_Embarque__c.addError('Se requiere ingresar una fecha');
        else if(filtroObj2.Fecha_Embarque__c == null)
            filtroObj2.Fecha_Embarque__c.addError('Se requiere ingresar una fecha');
        else if(filtroObj.Fecha_Embarque__c > filtroObj2.Fecha_Embarque__c)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Se requiere que la fecha inicial sea menor a la fecha final'));
        else{
            try{
                elementosGuardados = false;
                construirEstructura(PlantaInfo);
                DBA.obtenerDatosWS(PlantaInfo,lsProductos,filtroObj.Fecha_Embarque__c,filtroObj2.Fecha_Embarque__c,mpTabla);
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            }
        }
    }
    
    public void guardar(){
        list<AjusteDisponiblidadPlanta__c> ajustesPlanta = (elementosGuardados == true)?null:obtenerAjustesValidos();
        ValidExternalUsers__c conf = (Usuario0 == null)?null:ValidExternalUsers__c.getValues(Usuario0);
        if(elementosGuardados == true)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Se requiere hacer una nueva consulta para generar nuevos registros'));
        else if(conf == null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Debe seleccionar un usuario y contraseña validas'));
        else if(conf.password__c != Password)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Debe seleccionar un usuario y contraseña validas'));
        else if(resTabla.isEmpty())
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Se requieren elementos a editar'));
        else if(ajustesPlanta.isEmpty())
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Se requieren editar cambios por lo menos en un registro'));
        else if(validaNegativos(ajustesPlanta) || validaDecimales(ajustesPlanta))
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Favor de verificar los errores'));
        else{
            try{
                String Mensaje = DBA.enviaNuevoAjuse(ajustesPlanta,Usuario0); //UserInfo.getUserName());
                if(Mensaje == null){
                    ActualizaAjustesPlanta(ajustesPlanta,Usuario0);
                    DBA.guardarAjustes(ajustesPlanta);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Ajuste guardado correctamente'));
                    elementosGuardados = true;
                }else
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error externo: ' + Mensaje));
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            }   
        }   
    }
    
    private boolean validaNegativos(list<AjusteDisponiblidadPlanta__c> ajustesPlanta){
        boolean result = false;
        for(AjusteDisponiblidadPlanta__c A: ajustesPlanta){
            if(A.Nueva_Disponiblidad__c < 0){
                A.Ajuste_Cajas__c.addError('Resultado negativo al realizar el ajuste');
                result = true;
            }
        }
        return result;
    }
    
    private boolean validaDecimales(list<AjusteDisponiblidadPlanta__c> ajustesPlanta){
        boolean result = false;
        for(AjusteDisponiblidadPlanta__c A: ajustesPlanta){
            if(A.Nueva_Disponiblidad__c.round() != A.Nueva_Disponiblidad__c){
                A.Ajuste_Cajas__c.addError('solo se permite capturar números entero');
                result = true;
            }
        }
        return result;
    }
    
    private list<AjusteDisponiblidadPlanta__c> obtenerAjustesValidos(){
        list<AjusteDisponiblidadPlanta__c> result = new list<AjusteDisponiblidadPlanta__c>();
        for(Producto p: resTabla){
            for(Disponibilidad d: p.DispXFecha){
                AjusteDisponiblidadPlanta__c TEMP = d.ajusteDispo;
                if(d.ajusteDispo.Disponibilidad_Actual__c != d.ajusteDispo.Nueva_Disponiblidad__c)
                    result.add(TEMP);
            }
        }
        
        return result;
    }
    
    private void construirEstructura(Oficina_de_Venta__c Planta){
        resTabla = new list<Producto>();
        mpTabla = new map<String,Producto>();
        for(Product2 Producto: lsProductos){
            Producto tmpProd = new Producto(Planta,Producto,filtroObj.Fecha_Embarque__c,filtroObj2.Fecha_Embarque__c);
            resTabla.add(tmpProd);
            mpTabla.put(Producto.ProductCode,tmpProd);
        }
    }
    
    private void ActualizaAjustesPlanta(list<AjusteDisponiblidadPlanta__c> ajustesDisp,String Usuario){
        for(AjusteDisponiblidadPlanta__c A: ajustesDisp)
            A.Usuario_Responsable__c = usuario;
    }
    
    public class Producto{
        public Product2 Producto {get;set;}
        public list<Disponibilidad> DispXFecha {get;set;}
        public Integer getTamanio(){return DispXFecha.size();}
        private map<Date,Disponibilidad> mpDispXFecha;
        
        public Producto(Oficina_de_Venta__c Planta,Product2 Producto,Date FechaI,Date FechaF){
            this.Producto = Producto;
            this.DispXFecha = new list<Disponibilidad>();
            this.mpDispXFecha = new map<Date,Disponibilidad>();
            Date fecha = fechaI;
            do{
                Disponibilidad tDisponibilidad = new Disponibilidad(fecha,Planta,Producto);
                this.DispXFecha.add(tDisponibilidad);
                this.mpDispXFecha.put(fecha,tDisponibilidad);
                fecha = fecha.addDays(1);
            }while(fecha.daysBetween(FechaF) >= 0);
        }
        
        public void insertaDisponibilidad(Date Fecha,Integer dispo){
            if(mpDispXFecha.containsKey(Fecha))
                mpDispXFecha.get(Fecha).insertaDisponibilidad(dispo);
        }
    }
    
    class Disponibilidad{
        public AjusteDisponiblidadPlanta__c ajusteDispo {
            get{
                if(ajusteDispo != null)
                    ajusteDispo.Nueva_Disponiblidad__c = (ajusteDispo.Ajuste_Cajas__c != null && ajusteDispo.Disponibilidad_Actual__c != null)?(ajusteDispo.Disponibilidad_Actual__c + ajusteDispo.Ajuste_Cajas__c):((ajusteDispo.Ajuste_Cajas__c != null && ajusteDispo.Disponibilidad_Actual__c == null)?ajusteDispo.Ajuste_Cajas__c:ajusteDispo.Disponibilidad_Actual__c);
                return ajusteDispo;
            }
            set;
        }
        public Disponibilidad(Date fecha,Oficina_de_Venta__c Planta,Product2 Producto){
            this.ajusteDispo = new AjusteDisponiblidadPlanta__c(Fecha_Embarque__c = fecha,Oficina_Venta__c = Planta.Id,Producto__c = Producto.Id, Usuario_Registro__c = UserInfo.getUserId());
            this.ajusteDispo.Oficina_Venta__r = Planta; //OBJETO
            this.ajusteDispo.Producto__r = Producto; // OBJETO
        }
        
        public void insertaDisponibilidad(Integer dispo){
            this.ajusteDispo.Disponibilidad_Actual__c = dispo;
            this.ajusteDispo.Nueva_Disponiblidad__c = dispo;
        }
    }
}