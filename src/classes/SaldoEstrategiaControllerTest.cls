/**
 * Description: SaldoEstrategiaController.cls test methods.
 * Author: Ruben Barraza
 * Company: Sk
 * Email:jose.barraza@sukarne.com
 * Created date: 28/12/2016
 **/
 
@isTest 
private class SaldoEstrategiaControllerTest {

    static testMethod void ejecutarPruebas() {
    	Product2 prod = CrearProducto(); 
    	CrearSemana();
    	CrearProductoMaster();
    	SaldoEstrategiaController Sec = new SaldoEstrategiaController();
    	Sec.level = 'WARNING';
    	Sec.message = 'Prueba';
        Sec.showPageMessage();
        Sec.level = 'ERROR';
        Sec.showPageMessage();
        Sec.level = 'CONFIRM';
        Sec.showPageMessage();
        string columnas = sec.column;
        Map<String, Product2> mapa = Sec.product2XproductCodeMap;
        Map<String, Producto_Master__c> MasterXproductCodeMap = Sec.MasterXproductCodeMap;
        Map<String, semana_viz__c> MapAnios = Sec.MapAnios;
        Map<String, semana_viz__c> MapSemanas = Sec.MapSemanas;
        
        Map<String, String> AdmonEstraCom = new Map<String, String>();
        AdmonEstraCom.put('Id',null);
        AdmonEstraCom.put('Name','Prueba');
        AdmonEstraCom.put('Anio__c','2016');
        AdmonEstraCom.put('Fecha_Final__c','2017-01-01');
        AdmonEstraCom.put('Fecha_Inicial__c','2017-12-26');
        AdmonEstraCom.put('IdProducto',prod.Id);
        AdmonEstraCom.put('IdMaster',null);
        AdmonEstraCom.put('SF_Auto','10');
        AdmonEstraCom.put('SF_Ex','10');
        AdmonEstraCom.put('SF_My','10');
        AdmonEstraCom.put('SI_Auto','10');
        AdmonEstraCom.put('SI_Ex','10');
        AdmonEstraCom.put('SI_My','10');
        string  Respuesta = SaldoEstrategiaController.AddAdmonEstrategyComercial(AdmonEstraCom,'48','52');
        
        AdmonEstraCom = new Map<String, String>();
        AdmonEstraCom.put('Id',null);
        AdmonEstraCom.put('Name','Prueba');
        AdmonEstraCom.put('Anio__c','2016');
        AdmonEstraCom.put('Fecha_Final__c','01/01/2017');
        AdmonEstraCom.put('Fecha_Inicial__c','26/12/2016');
        AdmonEstraCom.put('IdProducto',prod.Id);
        AdmonEstraCom.put('IdMaster',null);
        AdmonEstraCom.put('SF_Auto','10');
        AdmonEstraCom.put('SF_Ex','10');
        AdmonEstraCom.put('SF_My','10');
        AdmonEstraCom.put('SI_Auto','10');
        AdmonEstraCom.put('SI_Ex','10');
        AdmonEstraCom.put('SI_My','10');
        string  Respuesta2 = SaldoEstrategiaController.AddAdmonEstrategyComercial(AdmonEstraCom,'48','52');
        SaldoEstrategiaController.DeleteEstrategy(null);
        AdminSaldosEstrategias__c AdminSaldo = [SELECT Id FROM AdminSaldosEstrategias__c WHERE Folio__c =:Respuesta2];
        SaldoEstrategiaController.DeleteEstrategy(AdminSaldo.Id);
       
    }
    
     static testMethod Product2 CrearProducto()
     {
     	Product2 prod = new Product2();
     	prod.Name = 'Costilla Cargada12';
     	prod.Codigo_Id_Externo__c = '99999996533';
     	prod.IsActive = true;
     	
     	upsert prod;
     	return prod;
     }
      static testMethod semana_viz__c CrearSemana()
     {
     	semana_viz__c semana = new semana_viz__c();
     	semana.Name = '52';
     	semana.Anio__c = '2016';
     	semana.Fecha_Final__c  = date.newinstance(2017,1,1);
     	semana.Fecha_Inicial__c = date.newinstance(2016,12,21);
     	
     	upsert semana;
     	return semana;
     }
     static testMethod Producto_Master__c CrearProductoMaster()
     {
     	Producto_Master__c ProdM = new Producto_Master__c();
     	ProdM.Name = 'Costilla';
     	ProdM.MasterID__c = '0001';
     	
     	upsert ProdM;
     	return ProdM;
     }
}