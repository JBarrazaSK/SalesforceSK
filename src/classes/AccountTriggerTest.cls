/**
 * Description: Test methods of the AccountTrigger class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 12/08/2014
 **/
@isTest (SeeAllData = true)
private class AccountTriggerTest {
    
    static testmethod void test(){
         crearGrupo();
        
    }
    static testMethod void syncAccount() {
        Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '0'
        );
        insert colonia;
        Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c( Codigo__c = '453', Descripcion__c = 'BNM MANAGUA' );
        insert ofiVta;
        
       
        
        Account accountSucursal = new Account(
            Name = 'TEST',
            RFC_Generico__c = true,
            RFC__c = 'XXXXXXXXXXX99',
            Telefono__c = '1234567890',
            Organizacion_de_Ventas__c = 'SUKARNE - SK01'
        );
        
        Test.setMock(WebServiceMock.class, new ClienteInsertSAPPIWSTest.ClienteInsertSAPPIWSTestFail());
        
        Test.startTest();
        accountSucursal.ParentId = null;
        accountSucursal.Estatus_Call_Center__c = 'Activo';
        insert accountSucursal;
       
        
        Test.stopTest();
    }
    static testMethod void myUnitTest() {
        Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '0'
        );
        insert colonia;
        
        Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c( Codigo__c = '453', Descripcion__c = 'BNM MANAGUA' );
        insert ofiVta;
        
        
        Account account = new Account(
            Colonia__c = colonia.Id,
            Estatus_Call_Center__c = 'Aprobado NM',
            Name = 'TEST',
            RFC__c = 'XXXXXXXXXXX98',
            Telefono__c = '1234567890',
            Organizacion_de_Ventas__c = 'SUKARNE - SK01',
            Oficina_de_ventas__c = ofiVta.Id,
            Grupo_de_Vendedores__c = obtenerGpo().Id
        );
        Account accountSucursal = new Account(
            Name = 'TEST',
            RFC_Generico__c = true,
            RFC__c = 'XXXXXXXXXXX97',
            Telefono__c = '1234567890',
            Organizacion_de_Ventas__c = 'SUKARNE - SK01'
        );
        Account account2 = new Account(
            Name = 'TEST',
            RFC__c = 'XAXX010101000',
            Telefono__c = '1234567890',
            Organizacion_de_Ventas__c = 'GINSA - 2071'
        );
        Test.setMock(WebServiceMock.class, new ClienteInsertSAPPIWSTest());
        
        Test.startTest();
        
        insert account;
        insert new Contact(
            AccountId = account.Id,
            LastName = 'TEST'
        );
        accountSucursal.ParentId = account.Id;
        insert accountSucursal;
        account.Cadena__c = '30';
        account.Estatus_Call_Center__c = 'Activo';
        update account;
        insert account2;

        account2.Estatus_Call_Center__c = 'Activo';
        account.Ya_pago__c = true; 
        update account;
        update account2;
        
        String rtTId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tareas de Cobranza').getRecordTypeId();
        Task t = new Task(Priority='Normal',Status='En Proceso',WhatId=account.Id,RecordTypeId=rtTId);
        insert t;
        account.Ya_pago__c = true; 
        update account;
        
        Test.stopTest();
    }

static testMethod void CuentaContacto() {
        Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '0'
        );
        insert colonia;
        
        Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c( Codigo__c = '453', Descripcion__c = 'BNM MANAGUA' );
        insert ofiVta;
        
        
        Account account = new Account(
            Colonia__c = colonia.Id,
            Estatus_Call_Center__c = 'Aprobado NM',
            Name = 'TEST',
            RFC__c = 'XXXXXXXXXXX98',
            Telefono__c = '1234567890',
            Organizacion_de_Ventas__c = 'SUKARNE - SK01',
            Oficina_de_ventas__c = ofiVta.Id,
            Grupo_de_Vendedores__c = obtenerGpo().Id
        );
        
        Account accountSucursal = new Account(
            Name = 'TEST',
            RFC_Generico__c = true,
            //RFC__c = 'XXXXXXXXXXX97',
            Telefono__c = '1234567890',
            Organizacion_de_Ventas__c = 'SUKARNE - SK01'

        );

        Account account2 = new Account(
            Name = 'TEST',
            RFC__c = 'XAXX010101000',
            Telefono__c = '1234567890',
            Organizacion_de_Ventas__c = 'GINSA - 2071'
        );
		insert account;
        insert new Contact(
            AccountId = account.Id,
            LastName = 'TEST'
        );
      
        
        Test.setMock(WebServiceMock.class, new ClienteInsertSAPPIWSTest());
        Test.startTest();
        
          accountSucursal.ParentId = account.Id;
        insert accountSucursal;
        account.Cadena__c = '30';
        account.Estatus_Call_Center__c = 'Activo';
        update account;
       insert account2;

        account2.Estatus_Call_Center__c = 'Activo';
        account.Ya_pago__c = true; 
        update account;
        update account2;
        
        String rtTId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tareas de Cobranza').getRecordTypeId();
        Task t = new Task(Priority='Normal',Status='En Proceso',WhatId=account.Id,RecordTypeId=rtTId);
        insert t;
        account.Ya_pago__c = true; 
        update account;
       
        update accountSucursal;
        Test.stopTest();
    }
    static testMethod void ActualizarCampos()
    {
    	Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '0'
        );
        insert colonia;
        
        Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c( Codigo__c = '453', Descripcion__c = 'BNM MANAGUA' );
        insert ofiVta;
       
    	 Account account = new Account(
            Colonia__c = colonia.Id,
            Estatus_Call_Center__c = 'Aprobado NM',
            Name = 'TEST',
            RFC__c = 'XXXXXXXXXXX98',
            Telefono__c = '1234567890',
            Organizacion_de_Ventas__c = 'SUKARNE - SK01',
            Oficina_de_ventas__c = ofiVta.Id,
            Grupo_de_Vendedores__c = obtenerGpo().Id
        );
        insert account;
        
         contact contacto = new contact(
         	LastName = 'castr0',
        	Account = account
        );
         insert contacto;
    	Account accountSucursal = new Account(
            Name = 'TEST',
            RFC_Generico__c = true,
            Telefono__c = '1234567890',
            Organizacion_de_Ventas__c = 'SUKARNE - SK01'
        );
        accountSucursal.ParentId = account.Id;
        insert accountSucursal;
		accountSucursal.Estatus_Call_Center__c = 'Activo';
		update accountSucursal;
        List<Account> lista = new List<Account> ();
        lista.add(accountSucursal);
    	AccountTrigger c = new AccountTrigger();
    	AccountTrigger.asignaCamposChildAccounts(lista);
    }
        public static void crearGrupo(){
        system.debug('ENTROGUARDARGRUPO');
            Grupo_de_Vendedores__c gpoVendedores = new Grupo_de_Vendedores__c();            
            gpoVendedores.Codigo__c = '105';
            gpoVendedores.Descripcion__c = 'T2 MANAGUA';
            gpoVendedores.TipoSurtido__c = '2 - Directo';
            gpoVendedores.Name = 'GPO Vendedores 1';
            upsert gpoVendedores;  
    }
    public static Grupo_de_Vendedores__c obtenerGpo(){
        
        return [SELECT Id FROM Grupo_de_Vendedores__c limit 1];
    }
    static testMethod void PruebasEntidadesWS() {
        Test.setMock(WebServiceMock.class, new ClienteInsertSAPPIWSTest());
        
        Test.startTest();
        AccountTrigger c = new AccountTrigger(); 
        AccountTrigger.formatDate(date.today());
        AccountTrigger.getItinerario('Lunes','Lunes','120000');
        ClienteInsertSAPPIWS clienteInsertSAPPIWS = new ClienteInsertSAPPIWS();
        clienteInsertSAPPIWS.DT_SF_CreacionClientes_2 dT_SF_CreacionClientes_2 = new clienteInsertSAPPIWS.DT_SF_CreacionClientes_2();
        dT_SF_CreacionClientes_2.Cliente = new clienteInsertSAPPIWS.Cliente_element();
        dT_SF_CreacionClientes_2.Cliente.KNA1 = new clienteInsertSAPPIWS.KNA1_element();
        dT_SF_CreacionClientes_2.Cliente.KNB1 = new clienteInsertSAPPIWS.KNB1_element();
        dT_SF_CreacionClientes_2.Cliente.KNBK = new List<clienteInsertSAPPIWS.KNBK_element> { new clienteInsertSAPPIWS.KNBK_element() };
        dT_SF_CreacionClientes_2.Cliente.KNVA = new clienteInsertSAPPIWS.ArrayOfString();
        dT_SF_CreacionClientes_2.Cliente.KNVI = new List<clienteInsertSAPPIWS.KNVI_element> { new clienteInsertSAPPIWS.KNVI_element() };
        dT_SF_CreacionClientes_2.Cliente.KNVK = new List<clienteInsertSAPPIWS.KNVK_element> { new clienteInsertSAPPIWS.KNVK_element() };
        dT_SF_CreacionClientes_2.Cliente.KNVP = new List<clienteInsertSAPPIWS.KNVP_element> { new clienteInsertSAPPIWS.KNVP_element() };
        dT_SF_CreacionClientes_2.Cliente.KNVV = new clienteInsertSAPPIWS.KNVV_element();
        dT_SF_CreacionClientes_2.Cliente.Z = new clienteInsertSAPPIWS.Z_element();
        clienteInsertSAPPIWS.Clientes2Soap clientes2Soap = new clienteInsertSAPPIWS.Clientes2Soap();
        clienteInsertSAPPIWS.DT_SF_CreacionClientes_return dT_SF_CreacionClientes_return = clientes2Soap.SI_OS_SalesForce_CreacionClientes_2(dT_SF_CreacionClientes_2);
        
        Test.stopTest();
    }
}