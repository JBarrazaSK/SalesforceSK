/*
 * @developer   : Rene Carpazo
 * @company     : Evolusoftware
 * @created     : 2017-07-15
 * @description : This class is a test method for AjusteDispo
 */
@isTest
private class ctrlAjusteDispoTest {

    static testMethod void inicial(){
        dataTest.obtenerPlantas(new list<String>{'64'});
        dataTest.obtenerProductos(new list<String>{'1'});
        insert new ValidExternalUsers__c(Name='USR1',password__c ='USR1');
        Test.startTest();
        ctrlAjusteDispo obj = new ctrlAjusteDispo();
        obj.codigoOficina = '64';
        obj.obtenerOficina();
        obj.obtenerCodigoOficina();
        obj.codigoProducto = '1';
        obj.obtenerProducto();
        obj.obtenerCodigoProducto();
        obj.aniadirProducto();
        obj.filtroObj.Producto__c = 'a0k2C000000gCnF'; //ID INEXISTENTE
        obj.aniadirProducto(); //se prueba el no encontrar un registro
        obj.getopProductos();
        obj.productoSelec = '0';
        obj.removerProducto();
        obj.getExternalUsuarios();
        Test.stopTest();
    }
    
    static testMethod void consultaXfiltros(){
        list<Oficina_de_Venta__c> plantas = dataTest.obtenerPlantas(new list<String>{'64'});
        list<Product2> prods = dataTest.obtenerProductos(new list<String>{'1'});
        ctrlAjusteDispo obj = new ctrlAjusteDispo();
        Date Fecha = Date.today();
        Test.startTest();
        obj.consultaDispo();
        obj.filtroObj.Producto__c = prods[0].Id;
        obj.aniadirProducto();
        obj.consultaDispo();
        obj.filtroObj.Oficina_Venta__c = plantas[0].Id;
        obj.consultaDispo();
        obj.filtroObj.Fecha_Embarque__c = Date.newInstance(Fecha.year(),Fecha.month(),10);
        obj.consultaDispo();
        obj.filtroObj2.Fecha_Embarque__c = Date.newInstance(Fecha.year(),Fecha.month(),9);
        obj.consultaDispo();
        obj.filtroObj2.Fecha_Embarque__c = Date.newInstance(Fecha.year(),Fecha.month(),15);
        obj.consultaDispo();
        Test.stopTest();
    }
    
    static testMethod void actualizaDispo(){
        list<Oficina_de_Venta__c> plantas = dataTest.obtenerPlantas(new list<String>{'64'});
        list<Product2> prods = dataTest.obtenerProductos(new list<String>{'1'});
        ctrlAjusteDispo obj = new ctrlAjusteDispo();
        Date Fecha = Date.today();
        obj.filtroObj.Producto__c = prods[0].Id;
        obj.aniadirProducto();
        obj.filtroObj.Oficina_Venta__c = plantas[0].Id;
        obj.filtroObj.Fecha_Embarque__c = Date.newInstance(Fecha.year(),Fecha.month(),10);
        obj.filtroObj2.Fecha_Embarque__c = Date.newInstance(Fecha.year(),Fecha.month(),15);
        obj.consultaDispo();
        insert new ValidExternalUsers__c(Name='USR1',password__c ='USR1');
        Test.startTest();
        obj.guardar();
        obj.Usuario0 = 'USR1';
        obj.Password = 'USR1';
        obj.resTabla[0].DispXFecha[0].ajusteDispo.Ajuste_Cajas__c = -200;
        obj.guardar();
        obj.resTabla[0].DispXFecha[0].ajusteDispo.Ajuste_Cajas__c = 20;
        obj.guardar();
        obj.guardar();
        obj.init();
        obj.guardar();
        Test.stopTest();
    }
    
    static testMethod void validaWS(){
        Test.startTest();
        AjusteDisponibilidadPlantasWS.AjusteDisponibilidadPlantasSoap obj = new AjusteDisponibilidadPlantasWS.AjusteDisponibilidadPlantasSoap();
        new AjusteDisponibilidadPlantasWS.AjusteDisponibilidadResponse_element();
        try{obj.AjusteDisponibilidad(null);}catch(Exception e){}
        Test.stopTest();
    }
    
    
}