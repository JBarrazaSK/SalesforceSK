/*
 * @developer   : Rene Carpazo
 * @company     : Evolusoftware
 * @created     : 2017-07-15
 * @description : This class is a test method for AjusteDispo
 */
@isTest
private class ctrlDispDiaraPlantaTest {
	
	static testMethod void inicial(){
		list<Producto_Master__c> lsMaster = dataTest.obtenerMaster(new list<String>{'10'});
		list<Oficina_de_Venta__c> plantas = dataTest.obtenerPlantas(new list<String>{'64'});
		//list<Product2> prods = dataTest.obtenerProductos(new list<String>{'1'});
		
		Test.startTest();
		ctrlDispDiaraPlanta obj = new ctrlDispDiaraPlanta();
		obj.getMasterDispo();
		obj.opcAddMaster.add(lsMaster[0].Id);
		obj.aniadeMaster();
		obj.getMasterSelect();
		obj.opcRemMaster.add(lsMaster[0].Id);
		obj.removeMaster();
		
		obj.getPlantasDispo();
		obj.opcAddPlantas.add(plantas[0].Id);
		obj.aniadePlantas();
		obj.getPlantasSelect();
		obj.opcRemPlantas.add(plantas[0].Id);
		obj.removePlantas();
		Test.stopTest();
	}
	
	static testMethod void consultaXfiltros(){
		list<Oficina_de_Venta__c> plantas = dataTest.obtenerPlantas(new list<String>{'64'});
		list<Producto_Master__c> lsMaster = dataTest.obtenerMaster(new list<String>{'10'});
		list<Product2> prods = dataTest.obtenerProductos(new list<String>{'1'});
		prods[0].Producto_Master__c = lsMaster[0].Id;
		update prods;
		ctrlDispDiaraPlanta obj = new ctrlDispDiaraPlanta();
		Date Fecha = Date.today();
		Test.startTest();
		obj.consultaDispo();
		obj.opcAddMaster.add(lsMaster[0].Id);
		obj.aniadeMaster();
		obj.consultaDispo();
		obj.opcAddPlantas.add(plantas[0].Id);
		obj.aniadePlantas();
		obj.consultaDispo();
		obj.filtroObj.Fecha_Embarque__c = Date.newInstance(Fecha.year(),Fecha.month(),10);
		obj.consultaDispo();
		obj.filtroObj2.Fecha_Embarque__c = Date.newInstance(Fecha.year(),Fecha.month(),9);
		obj.consultaDispo();
		obj.filtroObj2.Fecha_Embarque__c = Date.newInstance(Fecha.year(),Fecha.month(),27);
		obj.consultaDispo();
		Test.stopTest();
	}
	
	static testMethod void validaWS(){
		Test.startTest();
		ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap obj = new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap();
		new ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadResponse_element();
		try{obj.ConsultaDisponibilidad(null);}catch(Exception e){}
		Test.stopTest();
	}
}