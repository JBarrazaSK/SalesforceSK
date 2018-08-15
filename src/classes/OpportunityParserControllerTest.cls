/**
  * @Description : Controller class for Otros Canales VF page
  * @Created Date: 14 Dic 2016
  * @Author: sf@lynx9.com
  * @Company: LYNX9 Soluciones
 */
@isTest (seeAllData=true) 
private class OpportunityParserControllerTest implements WebServiceMock {
    
    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        if(stub instanceOf ListaPreciosWS.ListaPreciosSoap) {
            new ListaPreciosWSMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf ConsultaDisponibilidadMayoristasWS.ConsultaDisponibilidadMayoristasSoap) {
            new DispoMayoristasWSMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf WSValidarLimiteCredito.ValidaLimiteCreditoSoap) {
            new WSValidarLimiteCreditoMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf PedidosMayoreoWS.PedidosMayoreoSoap) {
            new PedidosMayoreoWSMockImpl().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        }
    }
    
    static testMethod void coverTypes(){
        //new OpportunityParserController.OpportunityAndOppProductMapping(null,null);
        //new OpportunityParserController.CustomMap();
        new OpportunityParserController.SaveResult();
        new OpportunityParserController.SobjectSaveResult();
        new OpportunityParserController.OpportunityToLineItems();
    }
  
    static testMethod void coverCustomSettings()
    {
        OpportunityParserController.OpportunityAndOppProductMapping mapping = OpportunityParserController.getCustomSettingValues();
        System.assert(mapping!=null);
    }
    
    static testMethod void coverInsertWithError(){
        //Sin Datos
        OpportunityParserController.SobjectSaveResult result1 = OpportunityParserController.insertOpportunitiesANDLineItems('', '');
        //Columnas vacías
        String oppRecordsJSON = oppJSONVacios();
        OpportunityParserController.SobjectSaveResult result2 = OpportunityParserController.insertOpportunitiesANDLineItems(oppRecordsJSON, '');
        //Pedidos OK - Prods Columnas Vacías
        oppRecordsJSON = oppJSON();
        String oppProductsJSON = prodsJSONVacios();
        OpportunityParserController.SobjectSaveResult result3 = OpportunityParserController.insertOpportunitiesANDLineItems(oppRecordsJSON, oppProductsJSON);

        //Datos No Existentes
        oppRecordsJSON = oppJSONNoExistente();
        oppProductsJSON = prodsJSONNoExistente();
        OpportunityParserController.SobjectSaveResult result4 = OpportunityParserController.insertOpportunitiesANDLineItems(oppRecordsJSON, oppProductsJSON);
    }
      
    static testMethod void coverInsert(){
        String oppRecordsJSON = oppJSON();
        String oppProductsJSON = prodsJSON();
        Test.startTest();
        Test.setMock(WebServiceMock.class, new OpportunityParserControllerTest());
        OpportunityParserController.SobjectSaveResult result = OpportunityParserController.insertOpportunitiesANDLineItems(oppRecordsJSON, oppProductsJSON);
       
        List<OpportunityParserController.SaveResult> oppResults = null;
        List<OpportunityParserController.SaveResult> prodResults = null;
        String exceptions = null;
        if(result!=null){
            oppResults = result.opportunitySaveResults;
            prodResults = result.opportunityProductSaveResults;
            exceptions = result.exceptions;
        }else{
            System.debug('Favor de verificar el proceso de inserción en SDL');
        }
        
        if(oppResults!=null){
            for(OpportunityParserController.SaveResult oppResult:oppResults){
                if(oppResult==null){continue;}
            }
        }
    
        Test.stopTest();
    }
    
    static testMethod void testValidarOpp() {
        Date today = System.today();
        Opportunity opp = new Opportunity();
        OpportunityLineItem item = new OpportunityLineItem();
        OpportunityParserController.validarOpp( opp, false );
        OpportunityParserController.validarProducto( item, '' );
        OpportunityParserController.validarProducto( item, 'AS' );
        OpportunityParserController.validarProducto( item, 'EX' );
        Oficina_de_Venta__c ofi = new Oficina_de_Venta__c();
            opp.Fecha_de_Embarque__c = today.addDays(-1);
            opp.Fecha_de_Entrega__c = today.addDays( -1 );
            opp.Canal_Factura__r = ofi; 
            opp.Account = new Account();
            opp.Cliente__r = new Account();
    OpportunityParserController.validarOpp( opp, false );   
            opp.Fecha_de_Embarque__c = today.addDays(35);
            opp.Fecha_de_Entrega__c = today.addDays(33);
        OpportunityParserController.validarOpp( opp, false ); 
        OpportunityParserController.validarOpp( opp, true ); 
          ofi.IdPlanta__c = '1';
        Account acc = new Account();
          acc.Canal_Distribucion__c = 'Exportacion - EX';
          acc.Sociedad__c = 'Vizcattle - 303';
            opp.Canal_Factura__r = ofi;
            opp.Account = acc;
        OpportunityParserController.validarOpp( opp, true ); 
            opp.Fecha_Embarque_Bodega__c = today.addDays(20);
            opp.Fecha_de_Inspeccion__c = today.addDays(21);
            opp.Fecha_de_Entrega__c = today.addDays(19);
        OpportunityParserController.validarOpp( opp, true ); 
    }
    
    static testMethod void testCalcularImportes() {
        
        try {
            OpportunityParserController.calcularImporte('DL','C',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
            OpportunityParserController.calcularImporte('PK','C',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
            OpportunityParserController.calcularImporte('PC','K',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
            OpportunityParserController.calcularImporte('DK','K',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
            OpportunityParserController.calcularImporte('DK','C',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
            OpportunityParserController.calcularImporte('DK','L',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
            OpportunityParserController.calcularImporte('KL','C',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
            OpportunityParserController.calcularImporte('HJ','M',Double.valueOf(100.0),Double.valueOf(100.0),10,Double.valueOf(12.5),10);
        } catch( Exception e ) {}
        
    }
    
    static testMethod void testRango() {
        OpportunityParserController.getRango('');
        OpportunityParserController.getRango('0 - 10 DÍAS');
        OpportunityParserController.getRango('11 - 15 DÍAS');
        OpportunityParserController.getRango('16 - 25 DÍAS');
        OpportunityParserController.getRango('MAYOR A 25');
        OpportunityParserController.fakeMethod();
    }
    
    static testMethod void testCompleteDAO() {
        OpportunityParserDAO.buscarSucViz( new List<String>{'0000104184'} );
        OpportunityParserDAO.buscarPorSAP( new List<String>{'0000104184'} );
        OpportunityParserDAO.cuentasDatosGenerales( new List<String>{'0000104184'} );
        OpportunityParserDAO.fakeMethod();
        try{ OpportunityParserDAO.upsertRecords(new List<SObject>{new Opportunity()}, 'Opportunity'); } catch( Exception e ) {}
    }
    
    static String oppJSON(){
        String tz = 'GMT-07:00';
        DateTime fechaEmbarque = System.now();
        String sFechaEmbarque = fechaEmbarque.format('yyyy-MM-dd', tz);
        DateTime fechaEntrega = fechaEmbarque.addDays(6);
        String sFechaEntrega = fechaEntrega.format('yyyy-MM-dd',tz);
        DateTime fechaEntrega2 = fechaEmbarque.addDays(6);
        String sFechaEntrega2 = fechaEntrega2.format('yyyy-MM-dd',tz);
        DateTime fechaCruce = fechaEmbarque.addDays(3);
        String sFechaCruce = fechaCruce.format('yyyy-MM-dd',tz);
        DateTime fechaInsp = fechaEmbarque.addDays(4);
        String sFechaInsp = fechaInsp.format('yyyy-MM-dd',tz);
        DateTime fechaEmbBodega = fechaEmbarque.addDays(5);
        String sFechaEmbBod = fechaEmbBodega.format('yyyy-MM-dd',tz);
        
        String json = '['+
        '{"Folio_Temporal__c":"1","Cliente__c":"104184","AccountId":"104184","Fecha_de_Embarque__c":"'+sFechaEmbarque+'","Fecha_de_Entrega__c":"'+sFechaEntrega+
            '","Fecha_de_Cruce__c":"'+sFechaCruce+'","Fecha_de_Inspeccion__c":"'+sFechaInsp+'","Fecha_Embarque_Bodega__c":"'+sFechaEmbBod+'","Canal_Factura__c":"64"}]';
        
        /*
        '{"Folio_Temporal__c":"2","Cliente__c":"34248","AccountId":"34248","Orden_de_Compra__c":"LEY 5","Fecha_de_Embarque__c":"'+sFechaEmbarque+'","Fecha_de_Entrega__c":"'+sFechaEntrega+'","Canal_Factura__c":"959"},'+
        '{"Folio_Temporal__c":"3","Cliente__c":"41716","AccountId":"803968","Fecha_de_Embarque__c":"'+sFechaEmbarque+'","Fecha_de_Entrega__c":"'+sFechaEntrega+'","Canal_Factura__c":"64"},'+
        '{"Folio_Temporal__c":"4","Cliente__c":"41716","AccountId":"803968","Fecha_de_Embarque__c":"'+sFechaEmbarque+'","Fecha_de_Entrega__c":"'+sFechaEntrega+'","Canal_Factura__c":"959"},'+
        '{"Folio_Temporal__c":"5","Cliente__c":"41716","AccountId":"803968","Fecha_de_Embarque__c":"'+sFechaEmbarque+'","Fecha_de_Entrega__c":"'+sFechaEntrega2+'","Canal_Factura__c":"64"},'+
        '{"Folio_Temporal__c":"6","Cliente__c":"12064","AccountId":"803194","Fecha_de_Embarque__c":"'+sFechaEmbarque+'","Fecha_de_Entrega__c":"'+sFechaEntrega2+'","Canal_Factura__c":"64"}]';
    */
        return json;
    }
    
    static String prodsJSON(){
        String json = '['+
            '{"key":"1",'+
              '"value":['+
                '{"Origen_Surtido__c":"64","ProductCode":"13","Quantity":"10","Volumen__c":"300","Unidad__c":"CJ","UnitPrice":"85.0000","Tipo_de_Precio__c":"PK","Importe__c":"25500","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"},'+
                '{"Origen_Surtido__c":"959","ProductCode":"12","Quantity":"9","Volumen__c":"270","Unidad__c":"CJ","UnitPrice":"85.5000","Tipo_de_Precio__c":"PK","Importe__c":"23085","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"}]}]';
          /*
            '{"key":"2",'+
              '"value":['+
                '{"Origen_Surtido__c":"959","ProductCode":"1148","Quantity":"8","Volumen__c":"240","Unidad__c":"CJ","UnitPrice":"168.5000","Tipo_de_Precio__c":"PK","Importe__c":"40440","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"},'+
                '{"Origen_Surtido__c":"959","ProductCode":"1149","Quantity":"7","Volumen__c":"210","Unidad__c":"CJ","UnitPrice":"168.5000","Tipo_de_Precio__c":"PK","Importe__c":"35385","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"}]},'+
            '{"key":"3","value":[{"Origen_Surtido__c":"64","ProductCode":"1","Quantity":"6","Volumen__c":"180","Unidad__c":"CJ","UnitPrice":"99.0000","Tipo_de_Precio__c":"PK","Importe__c":"17820","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"}]},'+
            '{"key":"4","value":[{"Origen_Surtido__c":"959","ProductCode":"12","Quantity":"8","Volumen__c":"240","Unidad__c":"CJ","UnitPrice":"103.4000","Tipo_de_Precio__c":"PK","Importe__c":"24816","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"}]},'+
            '{"key":"5","value":[{"Origen_Surtido__c":"64","ProductCode":"13","Quantity":"7","Volumen__c":"210","Unidad__c":"CJ","UnitPrice":"103.4000","Tipo_de_Precio__c":"PK","Importe__c":"21714","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"},'+
                '{"Origen_Surtido__c":"64","ProductCode":"1148","Quantity":"6","Volumen__c":"180","Unidad__c":"CJ","UnitPrice":"156.9500","Tipo_de_Precio__c":"PK","Importe__c":"28251","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"},'+
                '{"Origen_Surtido__c":"64","ProductCode":"1149","Quantity":"8","Volumen__c":"240","Unidad__c":"CJ","UnitPrice":"156.9500","Tipo_de_Precio__c":"PK","Importe__c":"37668","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"}]},'+
            '{"key":"6","value":[{"Origen_Surtido__c":"64","ProductCode":"1","Quantity":"10","Volumen__c":"300","Unidad__c":"CJ","UnitPrice":"68.5000","Tipo_de_Precio__c":"PK","Importe__c":"20550","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"},'+
                '{"Origen_Surtido__c":"64","ProductCode":"5","Quantity":"9","Volumen__c":"270","Unidad__c":"CJ","UnitPrice":"103.2000","Tipo_de_Precio__c":"PK","Importe__c":"27864","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"},'+
                '{"Origen_Surtido__c":"64","ProductCode":"12","Quantity":"8","Volumen__c":"240","Unidad__c":"CJ","UnitPrice":"90.1000","Tipo_de_Precio__c":"PK","Importe__c":"21624","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"},'+
                '{"Origen_Surtido__c":"64","ProductCode":"13","Quantity":"5","Volumen__c":"150","Unidad__c":"CJ","UnitPrice":"91.4000","Tipo_de_Precio__c":"PK","Importe__c":"13710","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"},'+
                '{"Origen_Surtido__c":"64","ProductCode":"40","Quantity":"3","Volumen__c":"90","Unidad__c":"CJ","UnitPrice":"80.0000","Tipo_de_Precio__c":"PK","Importe__c":"7200","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"},'+
                '{"Origen_Surtido__c":"64","ProductCode":"42","Quantity":"4","Volumen__c":"120","Unidad__c":"CJ","UnitPrice":"101.2000","Tipo_de_Precio__c":"PK","Importe__c":"12144","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"},'+
                '{"Origen_Surtido__c":"64","ProductCode":"410","Quantity":"7","Volumen__c":"210","Unidad__c":"CJ","UnitPrice":"99.5000","Tipo_de_Precio__c":"PK","Importe__c":"20895","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"},'+
                '{"Origen_Surtido__c":"64","ProductCode":"811","Quantity":"8","Volumen__c":"240","Unidad__c":"CJ","UnitPrice":"97.6000","Tipo_de_Precio__c":"PK","Importe__c":"23424","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"},'+
                '{"Origen_Surtido__c":"64","ProductCode":"2145","Quantity":"9","Volumen__c":"270","Unidad__c":"CJ","UnitPrice":"105.4400","Tipo_de_Precio__c":"PK","Importe__c":"28468.8","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"}]}]';
      */
        return json;
    }

    static String oppJSONVacios(){
        String json = '['+
          '{"Folio_Temporal__c":"1","Cliente__c":"","AccountId":"","Fecha_de_Embarque__c":"","Fecha_de_Entrega__c":"","Canal_Factura__c":""}]';        
        return json;
    }
    
    static String prodsJSONVacios(){
        String json = '['+
            '{"key":"1",'+
              '"value":['+
                '{"Origen_Surtido__c":"","ProductCode":"13","Quantity":"","Volumen__c":"","Unidad__c":"","UnitPrice":"","Tipo_de_Precio__c":"","Importe__c":"","Tipo_de_Inventario__c":"","Observaciones__c":""},'+
                '{"Origen_Surtido__c":"","ProductCode":"12","Quantity":"","Volumen__c":"","Unidad__c":"","UnitPrice":"","Tipo_de_Precio__c":"","Importe__c":"","Tipo_de_Inventario__c":"","Observaciones__c":""}]}]';
        return json;
    }

    static String oppJSONNoExistente(){
        String json = '['+
            '{"Folio_Temporal__c":"1","Cliente__c":"00000","AccountId":"000000","Fecha_de_Embarque__c":"","Fecha_de_Entrega__c":"","Canal_Factura__c":"000"}]';
        
        return json;
    }
    
    static String prodsJSONNoExistente(){
        String json = '['+
            '{"key":"1",'+
            '"value":['+
            '{"Origen_Surtido__c":"000","ProductCode":"0","Quantity":"0","Volumen__c":"0","Unidad__c":"XX","UnitPrice":"0.0000","Tipo_de_Precio__c":"XX","Importe__c":"00000","Tipo_de_Inventario__c":"0"},'+
            '{"Origen_Surtido__c":"000","ProductCode":"-1","Quantity":"0","Volumen__c":"0","Unidad__c":"XX","UnitPrice":"0.5000","Tipo_de_Precio__c":"XX","Importe__c":"00000","Tipo_de_Inventario__c":"0"}]}]';
        return json;
    }

}