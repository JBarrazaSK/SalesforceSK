/**
 * Description: Test methods for the TaskTrigger class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 11/08/2014
 **/
@isTest
private class TaskTriggerTest {
    
    static testMethod void myUnitTest() {
        Account account = new Account(
            Name = 'TEST',
            RFC__c = 'XXXXXXXXXXXX',
            Telefono__c = '1234567890'
        );
        insert account;
        Task task = new Task(
            Gestion__c = 'Venta',
            Subject = 'Llamada',
            TelefonoLlamadaInConcert__c = '1234567890',
            WhatId = account.Id
        );
        
        Test.startTest();
        
        insert task;
        insert task.clone(false, true);
        
        Test.stopTest();
    }
}