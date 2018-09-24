@isTest
public class BatchAperturaCanalSapTest 
{
    static testmethod void cobertura()
    {
    	
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
       String jobId = System.schedule('testScheduledApex', CRON_EXP, new ReaperturaCanalSchedulable() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        BatchAperturaCanalSap batch = new BatchAperturaCanalSap();
       
       System.assertEquals(CRON_EXP, ct.CronExpression); 
       System.assertEquals(0, ct.TimesTriggered);
       System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
    }

}