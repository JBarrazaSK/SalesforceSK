/*
 * @developer   : Rene Carpazo
 * @company     : Evolusoftware
 * @created     : 2017-07-15
 * @description : This class generates dummy records for use in other test methods */
@isTest
public class dataTest {
	
	public static list<Producto_Master__c> obtenerMaster(list<String> codigos){
		list<Producto_Master__c> result = new list<Producto_Master__c>();
		for(String C: codigos)
			result.add(new Producto_Master__c(Name='MASTER ' + C,MasterID__c=C));
		insert result;
		return result;
	}
	
	public static list<Product2> obtenerProductos(list<String> codigos){
		list<Product2> result = new list<Product2>();
		for(String C: codigos)
			result.add(new Product2(Name='PRODUCTO ' + C,Codigo_Id_Externo__c=C,ProductCode=C,IsActive = true));
		insert result;
		return result;
	}
	
	public static list<Oficina_de_Venta__c> obtenerPlantas(list<String> codigos){
		list<Oficina_de_Venta__c> result = new list<Oficina_de_Venta__c>();
		for(String C: codigos)
			result.add(new Oficina_de_Venta__c(Name='PLANTA ' + C,Descripcion__c='PLANTA ' + C,Codigo__c=C,IdPlanta__c = C));
		insert result;
		return result;
	}
	
}