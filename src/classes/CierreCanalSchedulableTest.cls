//@isTest(SeeAllData = true)
@isTest
public class CierreCanalSchedulableTest {
    
    static testmethod void test() {

		PedidoParameters__c parametros = PedidoParameters__c.getInstance();
        parametros.Limite_Registros__c = 1000;
        parametros.TipoCambioDolarPeso__c = 17.50;
		parametros.DiasPreventaMaximos__c = 2;
        parametros.EndpointPedidos__c='http://salesforce1.apps.sukarne.com:2562/SKServiciosExternos/SalesForce/PedidosMayoreo.asmx';
        parametros.PrecioUnitarioDecrementoMaximo__c = 10;
        parametros.PrecioUnitarioIncrementoMaximo__c =20;
        upsert parametros;
       Test.startTest();
       String CRON_EXP = '0 0 0 1 1 ? 2025';  
       String jobId = System.schedule('testScheduledApex', CRON_EXP, new CierreCanalSchedulable() );
       
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
        
       CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
       
       System.assertEquals(CRON_EXP, ct.CronExpression); 
       System.assertEquals(0, ct.TimesTriggered);
       System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
       
       Test.stopTest();

    }
      public static Oficina_de_Venta__c crearOficina(){
        Oficina_de_Venta__c ofi =  new Oficina_de_Venta__c();
        ofi.Name = '';
        ofi.Codigo__c = '105';
        ofi.Descripcion__c = 'VIZ';
        ofi.Nueva_Hora_Cierre_DT__c ='20:00';
        ofi.OrganizacionesText__c= 'SK01';
              
        insert ofi;
        return ofi;
        
    }
}