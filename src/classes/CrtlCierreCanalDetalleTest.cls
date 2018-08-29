@isTest
public class CrtlCierreCanalDetalleTest 
{
    static testMethod void test()
    {        
        CrtlCierreCanalDetalle  cierre = new CrtlCierreCanalDetalle();                  
        cierre.listaAMostrar = new list<CrtlCierreCanalDetalle.oficinaCierre>();  
        Motivos_Reapertura__c motivos = motivos();       
        List<SelectOption> moti =  new LIST<SelectOption>();       
        moti.add(new SelectOption('1','Reapertura')); 
        cierre.oficina =  crearOficinaVenta(); 
        cierre.buscarSAP();
        cierre.consultar();
        cierre.Motivo = 'false-1';
        cierre.DescripcionPadre	= '';        
        cierre.ValorBoton  = '';  
        cierre.Motivos = moti; 
        cierre.listaAMostrar[0].Seleccionado =  true;  
        cierre.listaAMostrar[0].oficina.cerrado__c = false;
        cierre.ExtensionCanal(); 
        cierre.CalcularHoraCierre('2:00', 15);
        cierre.LlenaCodigo();
        cierre.getMotivosReapertura();       

    }
        static testMethod void testFalse()
    {        
        CrtlCierreCanalDetalle  cierre = new CrtlCierreCanalDetalle();                  
        cierre.listaAMostrar = new list<CrtlCierreCanalDetalle.oficinaCierre>();  
        Motivos_Reapertura__c motivos = motivos();       
        List<SelectOption> moti =  new LIST<SelectOption>();       
        moti.add(new SelectOption('1','Reapertura')); 
        cierre.oficina =  crearOficinaVenta2(); 
        cierre.buscarSAP();
        cierre.consultar();
        cierre.DescripcionPadre	= '';        
        cierre.ValorBoton  = '';  
        cierre.Motivos = moti; 

        cierre.Motivo = 'true-1';
        cierre.listaAMostrar[0].Seleccionado =  true;  
        cierre.listaAMostrar[0].oficina.Extension__c =  true;  
        cierre.ExtensionCanal(); 
        
        cierre.listaAMostrar[0].Seleccionado =  true;  
        cierre.listaAMostrar[0].oficina.Extension__c =  false;
        cierre.listaAMostrar[0].oficina.Reaperturado__c =  true;  
        cierre.ExtensionCanal(); 

       	cierre.listaAMostrar[0].Seleccionado =  true;  
        cierre.listaAMostrar[0].oficina.Extension__c =  false;
        cierre.listaAMostrar[0].oficina.Reaperturado__c =  false; 
        cierre.listaAMostrar[0].oficina.Cerrado__c =  true;  
        cierre.ExtensionCanal(); 


    }
    static testmethod void aperturarCanalFalse()
    { 
        CrtlCierreCanalDetalle  cierre = new CrtlCierreCanalDetalle();      
        cierre.listaAMostrar = new list<CrtlCierreCanalDetalle.oficinaCierre>();  
        Motivos_Reapertura__c motivos = motivos();       
        List<SelectOption> moti =  new LIST<SelectOption>();       
        moti.add(new SelectOption('1','Reapertura'));                   
        cierre.oficina =  crearOficinaVenta();  
        cierre.buscarSAP();
        cierre.consultar();
        cierre.Motivo = 'false-1';
        cierre.DescripcionPadre	= '';        
        cierre.ValorBoton  = '';  
        cierre.Motivos = moti; 
        test.setMock(WebServiceMock.class, new WSCierrereaperturaCanalSapMock());
        test.startTest();          
        cierre.listaAMostrar[0].Seleccionado =  true;  
        cierre.AperturarCanal();
        test.stopTest();        
    }
    static testmethod void aperturarCanal()
    { 
        CrtlCierreCanalDetalle  cierre = new CrtlCierreCanalDetalle();      
        cierre.listaAMostrar = new list<CrtlCierreCanalDetalle.oficinaCierre>();  
        Motivos_Reapertura__c motivos = motivos();       
        List<SelectOption> moti =  new LIST<SelectOption>();       
        moti.add(new SelectOption('1','Reapertura'));                   
        cierre.oficina =  crearOficinaVenta();  
        cierre.buscarSAP();
        cierre.consultar();
        cierre.Motivo = 'true-1';
        cierre.DescripcionPadre	= '';        
        cierre.ValorBoton  = '';  
        cierre.Motivos = moti; 
        test.setMock(WebServiceMock.class, new WSCierrereaperturaCanalSapMock());
        test.startTest();          
        cierre.listaAMostrar[0].Seleccionado =  true;  
        cierre.AperturarCanal();
        test.stopTest();        
    }
    static testmethod void aperturarCanalFail()
    { 
        CrtlCierreCanalDetalle  cierre = new CrtlCierreCanalDetalle();      
        cierre.listaAMostrar = new list<CrtlCierreCanalDetalle.oficinaCierre>();  
        Motivos_Reapertura__c motivos = motivos();       
        List<SelectOption> moti =  new LIST<SelectOption>();       
        moti.add(new SelectOption('1','Reapertura'));                   
        cierre.oficina =  crearOficinaVenta();  
        cierre.buscarSAP();
        cierre.consultar();
        cierre.Motivo = '';
        cierre.DescripcionPadre	= '';        
        cierre.ValorBoton  = '';  
        cierre.Motivos = moti; 
        test.setMock(WebServiceMock.class, new WSCierrereaperturaCanalSapMock.WSCierrereaperturaCanalSapMocKFail());
        test.startTest();  
      	cierre.listaAMostrar[0].Seleccionado =  true;  
        cierre.listaAMostrar[0].oficina.Reaperturado__c =  true;  
        cierre.AperturarCanal();        
        
        cierre.Motivo = 'true-1';
        cierre.listaAMostrar[0].Seleccionado =  true;  
        cierre.listaAMostrar[0].oficina.Reaperturado__c =  true;  
        cierre.AperturarCanal();
        
        cierre.listaAMostrar[0].Seleccionado =  true;  
        cierre.listaAMostrar[0].oficina.Reaperturado__c =  false;  
        cierre.listaAMostrar[0].oficina.Cerrado__c =  false;  
        cierre.AperturarCanal();
        
        cierre.listaAMostrar[0].Seleccionado =  true;  
        cierre.listaAMostrar[0].oficina.Reaperturado__c =  false;  
        cierre.listaAMostrar[0].oficina.Cerrado__c =  true;  
        cierre.listaAMostrar[0].oficina.Extension__c =  true;  
        cierre.AperturarCanal();
        test.stopTest();        
    }
   static testmethod void cierreCanal()
    {  
        CrtlCierreCanalDetalle  cierre = new CrtlCierreCanalDetalle();      
        cierre.listaAMostrar = new list<CrtlCierreCanalDetalle.oficinaCierre>();  
        cierre.oficina =  crearOficinaVenta(); 
        cierre.buscarSAP();
        cierre.consultar();
        test.setMock(WebServiceMock.class, new WSCierrereaperturaCanalSapMock());
        test.startTest();       
            cierre.listaAMostrar[0].Seleccionado =  true;  
            cierre.listaAMostrar[0].oficina.cerrado__c = false;
            cierre.CerrarCanal();        
        test.stopTest();
     
    }
     static testmethod void cierreCanalFail()
    {  
        CrtlCierreCanalDetalle  cierre = new CrtlCierreCanalDetalle();      
        cierre.listaAMostrar = new list<CrtlCierreCanalDetalle.oficinaCierre>();  
        cierre.oficina =  crearOficinaVenta(); 
        cierre.buscarSAP();
        cierre.consultar();
        test.setMock(WebServiceMock.class, new WSCierrereaperturaCanalSapMock.WSCierrereaperturaCanalSapMocKFail());
        test.startTest();       
        cierre.listaAMostrar[0].Seleccionado =  true;  
        cierre.listaAMostrar[0].oficina.cerrado__c = true;
        	cierre.CerrarCanal(); 
        test.stopTest();
    }
    public static Oficina_de_Venta__c crearOficinaVenta()
    {        
        Oficina_de_Venta__c ofi = new Oficina_de_Venta__c();
        ofi.Opera_en_SAP__c =  true;
        ofi.Descripcion__c = 'Vis';
        ofi.Codigo__c = '105';
        ofi.Cerrado__c =  true;
        ofi.OrganizacionesText__c = 'VIZ';
        ofi.Reaperturado__c =  false;
        insert ofi;
        return ofi;
    }
       
    public static Oficina_de_Venta__c crearOficinaVenta2()
    {        
        Oficina_de_Venta__c ofi = new Oficina_de_Venta__c();
        ofi.Opera_en_SAP__c =  true;
        ofi.Descripcion__c = 'Vis';
        ofi.Codigo__c = '105';
        ofi.Cerrado__c =  true;
        ofi.OrganizacionesText__c = 'VIZ';
        ofi.Reaperturado__c =  false;
        ofi.CEDIS__c = 'a0k2C000000Hpyu';
        insert ofi;
        return ofi;
    }
    
    public static Motivos_Reapertura__c motivos(){
        Motivos_Reapertura__c motivos = new Motivos_Reapertura__c();
        motivos.Minutos__c = 10.00;
        motivos.label__c = 'Reapertura';
        motivos.Name = 'MOTIVO 1';
        
        insert motivos;
        return motivos;
    }
   	
}