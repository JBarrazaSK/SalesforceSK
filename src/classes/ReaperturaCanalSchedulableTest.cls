@isTest
public class ReaperturaCanalSchedulableTest {
    
        static testmethod void test() {

		endpoints__c ep = endpoints__c.getInstance();
        ep.WSCierrereaperturaCanalSap__c = 'http://salesforce1.apps.sukarne.com:2562/SKServiciosExternos/SalesForce/PedidosMayoreo.asmx';
        insert ep;
        crearOficina();   
		Test.startTest();
		Test.setMock(WebServiceMock.Class,new WSCierrereaperturaCanalSapMocK());
		 BatchAperturaCanalSap b = new BatchAperturaCanalSap(); 
        database.executebatch(b);
       Test.stopTest();

    }
    static testmethod void ExecuteWs() {
		
		endpoints__c ep = endpoints__c.getInstance();
        ep.WSCierrereaperturaCanalSap__c = 'http://salesforce1.apps.sukarne.com:2562/SKServiciosExternos/SalesForce/PedidosMayoreo.asmx';
        insert ep;
        crearOficina();   
		Test.startTest();
		Test.setMock(WebServiceMock.Class,new WSCierrereaperturaCanalSapMock());
		 BatchAperturaCanalSap b = new BatchAperturaCanalSap(); 
        database.executebatch(b);
       Test.stopTest();

    }
    static testmethod void ExecuteWsFail() {
		
		endpoints__c ep = endpoints__c.getInstance();
        ep.WSCierrereaperturaCanalSap__c = 'http://salesforce1.apps.sukarne.com:2562/SKServiciosExternos/SalesForce/PedidosMayoreo.asmx';
        insert ep;
        crearOficina();   
		Test.startTest();
		Test.setMock(WebServiceMock.Class,new WSCierrereaperturaCanalSapMock.WSCierrereaperturaCanalSapMocKFail());
		 BatchAperturaCanalSap b = new BatchAperturaCanalSap(); 
        database.executebatch(b);
       Test.stopTest();

    }
    static testmethod void ExecuteWsNull(){
		endpoints__c ep = endpoints__c.getInstance();
        ep.WSCierrereaperturaCanalSap__c = 'http://salesforce1.apps.sukarne.com:2562/SKServiciosExternos/SalesForce/PedidosMayoreo.asmx';
        insert ep;
        crearOficina2(); 
		Test.startTest();
		Test.setMock(WebServiceMock.Class,new WSCierrereaperturaCanalSapMock());
		 BatchAperturaCanalSap b = new BatchAperturaCanalSap(); 
        database.executebatch(b);
       Test.stopTest();

    }
     static testmethod void ExecuteWsNullResponse() {
		
		endpoints__c ep = endpoints__c.getInstance();
        ep.WSCierrereaperturaCanalSap__c = 'http://salesforce1.apps.sukarne.com:2562/SKServiciosExternos/SalesForce/PedidosMayoreo.asmx';
        insert ep;
        crearOficina();   
        
		Test.startTest();
		Test.setMock(WebServiceMock.Class,new WSCierrereaperturaCanalSapMocK.WSCierrereaperturaCanalSapMocKFailNull());
		 BatchAperturaCanalSap b = new BatchAperturaCanalSap(); 
        database.executebatch(b);
       Test.stopTest();

    }
       public static Oficina_de_Venta__c crearOficina(){
        Oficina_de_Venta__c ofi =  new Oficina_de_Venta__c();
        ofi.Name = 'Bodega Calexico';
        ofi.Codigo__c = '740';
        ofi.Descripcion__c = 'VIZ';
        ofi.Reaperturado__c = false;
        ofi.Hora_Cierre_dt__c ='07:00';
        ofi.Nueva_Hora_Cierre_DT__c='07:00';
        ofi.OrganizacionesText__c= 'SK01';
        ofi.Cerrado__c= true;
        ofi.Opera_en_SAP__c = true;      
        insert ofi;
        return ofi;
        
    }
    public static Oficina_de_Venta__c crearOficina2(){
        Oficina_de_Venta__c ofi =  new Oficina_de_Venta__c();
        ofi.Name = 'Bodega Calexico';
        ofi.Codigo__c = '64';
        ofi.Descripcion__c = 'VIZ';
        ofi.Reaperturado__c = false;
        ofi.Hora_Cierre_dt__c ='21:00';
        ofi.Nueva_Hora_Cierre_DT__c='21:00';
        ofi.OrganizacionesText__c= null ;
        ofi.Cerrado__c= true;
        ofi.Opera_en_SAP__c = true;      
        insert ofi;
        return ofi;
        
    }

}