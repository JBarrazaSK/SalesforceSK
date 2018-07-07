@isTest
public class TestBatchLealtad {

    static testmethod void test() {
        
        // Creo el programa de Lealtad
        Programa_Lealtad__c programaLealtad = new Programa_Lealtad__c();
        programaLealtad.Name = 'Programa Test';
        programaLealtad.Activo__c = true;
        
        insert programaLealtad;
        
        // Creo un producto
        Product2 producto = new Product2();
        producto.Name = 'Produto Test';
        producto.Family = 'Familia 1';
        producto.ProductCode = '444';
        producto.Codigo_Id_Externo__c = '444';
        producto.Description = 'Producto Test';
        
        insert producto;
        
        // Creo una regla para el programa de lealtad
        ReglaNew__c regla = new ReglaNew__c();
        regla.Producto__c = producto.Id;
        regla.Familia_de_Producto__c = producto.Family;
        regla.Importe__c = 500;
        regla.Puntos_a_Otorgar__c = 1;
        regla.Programa_de_Lealtad__c = programaLealtad.Id;
        regla.Descripcion__c = 'Regla Test';
        
        insert regla;
        
        // Creo las cuentas
        List<Account> accountList = new List<Account>();
            
        for (Integer i=0;i<1;i++) {
            Account a = new Account();
            a.Name = 'Cliente Test' + i;
            a.Numero_cliente_SAP__c = 'A'+i;
            a.RFC__c = ('1XXXXXXXXXX'+i).right(12);
            a.Telefono__c = '1234567890';
            accountList.add(a);
        }
        
        insert accountList;
        
        // Creo las tarjetas
        List<Tarjeta__c> tarjetaList = new List<Tarjeta__c>();
        
        for (Account account: accountList){
            Tarjeta__c tarjeta = new Tarjeta__c();
            tarjeta.Account__c = account.Id;
            tarjetaList.add(tarjeta);
        }
        
        insert tarjetaList;
        
        // Asocio las tarjetas al programa de lealtad
        List<AsociacionTarjetaProgramaDeLealtad__c> asociacionList = new List<AsociacionTarjetaProgramaDeLealtad__c>();
        
        for (Tarjeta__c tarjeta : tarjetaList){
            AsociacionTarjetaProgramaDeLealtad__c asociacion = new AsociacionTarjetaProgramaDeLealtad__c();
            asociacion.Tarjeta__c = tarjeta.Id;
            asociacion.Programa_de_Lealtad__c = programaLealtad.Id;
            asociacionList.add(asociacion);
        }
        
        insert asociacionList;
        
        // Creo las ventas
        List<Venta__c> ventaList = new List<Venta__c>();
        
        Date ventaDate = Date.today();
        if (ventaDate.month() == 1){
            ventaDate = Date.newInstance(ventaDate.year()-1, 12, 1);
        } else {
            ventaDate = Date.newInstance(ventaDate.year(), ventaDate.month()-1, 1);
        }
        
        for (Account account: accountList){
            Venta__c venta = new Venta__c();
            venta.Cliente__c = account.Id;
            venta.Fecha__c = ventaDate;
            venta.Importe__c = 500;
            venta.Procesada__c = false;
            venta.Producto__c = producto.Id;
            ventaList.add(venta);
        }
        
        insert ventaList;
        
        // Datos para test de limpieza de puntos
        
        // Creo las cuentas
        List<Account> accountVencidoList = new List<Account>();
            
        for (Integer i=0;i<1;i++) {
            Account a = new Account();
            a.Name = 'Cliente Vencido Test' + i;
            a.Fecha_de_Ultima_Venta__c = Date.newInstance(2013, 1, 1);
            a.RFC__c = ('2XXXXXXXXXX'+i).right(12);
            a.Telefono__c = '1234567890';
            accountVencidoList.add(a);
        }
        
        insert accountVencidoList;
        
        // Creo las tarjetas
        List<Tarjeta__c> tarjetaVencidaList = new List<Tarjeta__c>();
        
        for (Account account: accountVencidoList){
            Tarjeta__c tarjeta = new Tarjeta__c();
            tarjeta.Account__c = account.Id;
            tarjeta.Puntos__c = 200;
            tarjetaVencidaList.add(tarjeta);
        }
        
        insert tarjetaVencidaList;
        
        // START TEST

        Test.startTest();
        BatchLealtad b = new BatchLealtad();
        Database.executeBatch(b);
        Test.stopTest();
        
        List<Tarjeta__c> tarjetas = [SELECT Puntos__c FROM Tarjeta__c WHERE Id IN :tarjetaList];
        
        for(Tarjeta__c tarjeta : tarjetas){
            System.assertEquals(1,tarjeta.Puntos__c);
        }

        List<Tarjeta__c> tarjetasVencidas = [SELECT Puntos__c FROM Tarjeta__c WHERE Id IN :tarjetaVencidaList];
        
        for(Tarjeta__c tarjeta : tarjetasVencidas){
            System.assertEquals(0,tarjeta.Puntos__c);
        }
        
    }
        
}