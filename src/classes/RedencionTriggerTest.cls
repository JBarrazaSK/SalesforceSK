/**
 * Description: Redencion trigger test methods.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 06/10/2014
 **/
@isTest
private class RedencionTriggerTest {
    
    static testmethod void test() {
        Account account = new Account(
            Name = 'TEST',
            RFC__c = 'XXXXXXXXXXXX',
            Telefono__c = '1234567890'
        );
        insert account;
        Tarjeta__c tarjeta = new Tarjeta__c(
            Puntos__c = 200
        );
        insert tarjeta;
        Recompensa__c recompensa = new Recompensa__c(
            Puntos_para_redimir__c = 1
        );
        insert recompensa;
        Redencion__c redencion = new Redencion__c(
            Numero_de_puntos__c = 200,
            Recompensa__c = recompensa.Id,
            Tarjeta__c = tarjeta.Id
        );
        
        Test.startTest();
        insert redencion;
        Test.stopTest();
    }
}