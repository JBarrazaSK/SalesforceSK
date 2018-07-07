@isTest
public class TestNewRedencionController {
    
    public static testMethod void testMyController() {
        
        Account account = new Account();
        account.Name = 'Cliente Test';
        account.RFC__c = 'XXXXXXXXXXXX';
        account.Telefono__c = '1234567890';
        
        insert account;
        
        Tarjeta__c tarjeta = new Tarjeta__c();
        tarjeta.Account__c = account.Id;
        tarjeta.Puntos__c = 100;
        
        insert tarjeta;
        
        Recompensa__c recompensa = new Recompensa__c();
        recompensa.Descripcion__c = 'Recompensa Test';
        recompensa.Puntos_para_redimir__c = 100;
        
        insert recompensa;
        
        Entrada__c entrada = new Entrada__c();
        entrada.Recompensa__c = recompensa.Id;
        entrada.Cantidad__c = 2;
        
        insert entrada;
        
        PageReference pageRef = new PageReference('/apex/NewRedencion?retURL=%2Fa07%2Fo&save_new=1&sfdc.override=1&setPuntosIndex=0');
        Test.setCurrentPage(pageRef);
        
        NewRedencionController controller = new NewRedencionController(new ApexPages.StandardController(new Redencion__c()));
        
        controller.redencion.Cliente__c = account.Id;
        controller.setTarjetas();
        controller.redencion.Tarjeta__c = tarjeta.id;
        controller.setPuntos();
        /*controller.redencion.Calle__c = 'Calle Test';
        controller.redencion.Ciudad__c = 'Ciudad Test';
        controller.redencion.Codigo_Postal__c = '1234';
        controller.redencion.Estado__c = 'Estado Test';*/
        controller.redencion.Recompensa__c = recompensa.Id;
        controller.redencion.Cantidad_de_recompensas__c = 1;
        controller.rewardPointsValidation();
        System.assertEquals('', controller.errorMessage);
        controller.redencion.Detalles_de_la_redencion__c='Detalles Test';
        
        //controller.guarda();
        //controller.cancela();
        
        controller = new NewRedencionController(new ApexPages.StandardController(controller.redencion));

        controller.guarda();
        controller.cancela();
        
        controller = new NewRedencionController(new ApexPages.StandardController(new Redencion__c()));
        
        controller.redencion.Cliente__c = account.Id;
        controller.setTarjetas();
        controller.redencion.Tarjeta__c = tarjeta.id;
        controller.setPuntos();
        controller.redencion.Recompensa__c = recompensa.Id;
        controller.redencion.Cantidad_de_recompensas__c = 4;
        controller.rewardPointsValidation();
        System.assertEquals('QUEDAN DISPONIBLES 2 ARTICULOS DE DICHA RECOMPENSA', controller.errorMessage);
        
        controller.redencion.Cantidad_de_recompensas__c = 2;
        controller.rewardPointsValidation();
        System.assertEquals('NO TIENE PUNTOS DISPONIBLES PARA DICHA CANTIDAD', controller.errorMessage);

        Account account2 = new Account();
        account2.Name = 'Cliente Test 2';
        account2.RFC__c = 'XXXXXXXXXXXY';
        account2.Telefono__c = '1234567890';
        
        insert account2;
        
        pageRef = new PageReference('/apex/NewRedencion?retURL=%2Fa07%2Fo&save_new=1&sfdc.override=1&setPuntosIndex=0');
        Test.setCurrentPage(pageRef);
        
        controller = new NewRedencionController(new ApexPages.StandardController(new Redencion__c()));
        
        controller.redencion.Cliente__c = account2.Id;
        controller.setTarjetas();
        System.assertEquals('NO ESTA ASOCIADO A NINGUN PROGRAMA DE LEALTAD', controller.errorMessage);
        System.debug(controller.errorMessage);
        
        Tarjeta__c tarjeta2 = new Tarjeta__c();
        tarjeta2.Account__c = account2.Id;
        tarjeta2.Puntos__c = 0;
        
        insert tarjeta2;
        
        controller.redencion.Cliente__c = account2.Id;
        controller.setTarjetas();
        System.assertEquals('NO TIENE PUNTOS DISPONIBLES PARA REDIMIR', controller.errorMessage);
      
    }

}