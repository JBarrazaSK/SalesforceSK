@isTest
public class TestBatchNoVenta {
    
    static testmethod void test() {
        
        No_Venta__c nv = new No_Venta__c();
        nv.Tiempo1__c = 30;
        nv.Tiempo2__c = 60;
        
        insert nv;
        
        User user = new User();
        user.Email = 'test@sukarne.com';
        user.Username = 'test@sukarne.com.sandbox';
        user.LastName = 'Test';
        user.Alias = 'test';
        user.CommunityNickname = 'test';
        user.TimeZoneSidKey = 'America/Mexico_City';
        user.LocaleSidKey = 'es_MX';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = '00e50000000spvTAAQ';
        user.LanguageLocaleKey = 'es';
        
        insert user;
        
        // Creo las cuentas
        List<Account> accountList = new List<Account>();
            
        for (Integer i=0;i<1;i++) {
            Account a = new Account();
            a.Name = 'Cliente Test' + i;
            a.Numero_cliente_SAP__c = 'A'+i;
            a.Fecha_de_Ultima_Venta__c = Date.today().addDays(-30);
            a.OwnerID = user.Id;
            a.RFC__c = ('1XXXXXXXXXXX'+i).right(12);
            a.Telefono__c = '1234567890';
            accountList.add(a);
        }
        
        for (Integer i=100;i<101;i++) {
            Account a = new Account();
            a.Name = 'Cliente Test' + i;
            a.Numero_cliente_SAP__c = 'A'+i;
            a.Fecha_de_Ultima_Venta__c = Date.today().addDays(-60);
            a.OwnerID = user.Id;
            a.RFC__c = ('2XXXXXXXXXXX'+i).right(12);
            a.Telefono__c = '1234567890';
            accountList.add(a);
        }
        
        insert accountList;
        
        // START TEST
        Test.startTest();
       	BatchNoVenta b = new BatchNoVenta();
       	Database.executeBatch(b);
        Test.stopTest();
        
    }

}