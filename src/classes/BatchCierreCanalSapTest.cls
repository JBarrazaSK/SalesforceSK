@isTest
public class BatchCierreCanalSapTest 
{ 
   static testmethod void cobertura()
    {     
        
    	Test.setMock(WebServiceMock.Class, new WSCierrereaperturaCanalSapMocK());
        Test.startTest();       
        
    	BatchCierreCanalSap batch = new BatchCierreCanalSap();
    	Database.BatchableContext BC = null;
        Oficina_de_Venta__c oficina =  crearOficina();
        List<Oficina_de_Venta__c> scope =  new  List<Oficina_de_Venta__c>();
        scope.add(oficina);
    	batch.start(BC);
        batch.execute(BC, scope);
        oficina.Nueva_Hora_Cierre_DT__c ='16:00';
        oficina.OrganizacionesText__c= 'SK01';
        scope.add(oficina);
        batch.execute(BC, scope);
        scope =  new  List<Oficina_de_Venta__c>();
       
        batch.execute(BC, scope);
        batch.finish(BC);
        Test.stopTest();
    }
    static testmethod void cober2(){
        BatchCierreCanalSap batch = new BatchCierreCanalSap();
        Database.BatchableContext BC = null;
        List<Oficina_de_Venta__c> scope =  new  List<Oficina_de_Venta__c>();
        Oficina_de_Venta__c oficina =  crearOficina();
     
        oficina.OrganizacionesText__c= null;
        scope.add(oficina);
        batch.execute(BC, scope);
        
        
    }
    
    public static Oficina_de_Venta__c crearOficina(){
        Oficina_de_Venta__c ofi =  new Oficina_de_Venta__c();
        ofi.Name = '';
        ofi.Codigo__c = '105';
        ofi.Descripcion__c = 'VIZ';
        ofi.Nueva_Hora_Cierre_DT__c ='09:00';
        ofi.OrganizacionesText__c= 'SK01';
              
        insert ofi;
        return ofi;
        
    }

}