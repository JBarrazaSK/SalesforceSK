@isTest( SeeAllData=true )
public class ctrlCxCCompletarTareas_UT {

    static testMethod void myUnitTest() {
        Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '0'
        );
        insert colonia;
        
        Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c( Codigo__c = '453', Descripcion__c = 'BNM MANAGUA' );
        insert ofiVta;
        
        Grupo_de_Vendedores__c gpoVendedores = new Grupo_de_Vendedores__c( Codigo__c = '696', Descripcion__c = 'T2 MANAGUA', TipoSurtido__c = '2 - Directo' );
        insert gpoVendedores;
        
        Account account = new Account(
            Colonia__c = colonia.Id,
            Estatus_Call_Center__c = 'Aprobado NM',
            Name = 'TEST',
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '1234567890',
            Organizacion_de_Ventas__c = 'SUKARNE - SK01',
            Oficina_de_ventas__c = ofiVta.Id,
            Grupo_de_Vendedores__c = gpoVendedores.Id
        );

        Test.startTest();
        insert account;
        	account.Name = 'Test 1';
        update account;
        
        account.Ya_pago__c = true; 
        update account;
        
        String rtTId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tareas de Cobranza').getRecordTypeId();
        Task t = new Task(Priority='Normal',Status='En Proceso',WhatId=account.Id,RecordTypeId=rtTId);
        insert t;
        account.Ya_pago__c = true; 
        update account;
        
        Test.stopTest();
    }
    
}