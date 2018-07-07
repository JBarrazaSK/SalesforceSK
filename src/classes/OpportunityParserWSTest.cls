/*******************************************************************************
Copyright © 2015 Lynx9. All rights reserved. 
Author: Aranzazu Sereno
Email: sf@lynx9.com
Description: Unit test para la clase de OpportunityParserWS
********************************************************************************/
@isTest
private class OpportunityParserWSTest {

    static testmethod void cover() {
        /*
         * Mayoreo
         * cliente=22758, gpoVendedores=212, ofiVentas=64, orgVentas=SK01, canal=MY, destinatario=803613, cluster=37, cadena=, fecDoc=20161215, prod=1, prod=12
         */
        List<Opportunity> pedidos = new List<Opportunity>();
        Opportunity pedido = new Opportunity();
        pedido.Fecha_de_Embarque__c = System.today();
        pedido.Folio_Temporal__c = '1';
        
        Account cliente = new Account();
        cliente.Numero_Cliente_SAP__c = '0000022758';
        cliente.Organizacion_de_Ventas__c = 'SuKarne - SK01';
        cliente.Canal_Distribucion__c = 'Mayoreo - MY';
        cliente.Ramo__c = 'MAYORISTAS - 137';
        pedido.Cliente__r = cliente;
        
        Account sucursal = new Account();
        sucursal.Numero_Cliente_SAP__c = 'SUC - 0000803613';
        //Grupo de vendedores
        Grupo_de_Vendedores__c vendedores = new Grupo_de_Vendedores__c ();
        vendedores.Codigo__c = '212';
        sucursal.Grupo_de_Vendedores__r = vendedores;
        //Oficina de ventas
        Oficina_de_Venta__c ofiVentas = new Oficina_de_Venta__c ();
        ofiVentas.Codigo__c = '64';
        sucursal.Oficina_de_Ventas__r = ofiVentas;
        pedido.Account = sucursal;
        
        //Oficina_de_Venta__c canal = Oficina_de_Venta__c();
        //pedido.Canal_Factura__r = canal;
        
        pedidos.add(pedido);
        
        Map<String, List<OpportunityLineItem>> productos = new Map<String, List<OpportunityLineItem>>();
        List<OpportunityLineItem> lista = prodsJSON();
        productos.put('1',lista);
        
        Test.setMock(WebServiceMock.class, new ListaPreciosWSMockImpl());
        Test.startTest();
        Map<String, Map<String, List<ListaPreciosWS.Precios>>> mapaPrecios = OpportunityParserWS.validarPreciosMayoristas(pedidos, productos, false);
        Test.stopTest();
        //Oficina_de_Venta__c canal = pedido.Canal_Factura__r;
        //String clienteViz = canal.IdClienteViz__c;

        /*
		 * Exportación
		 * cliente=103625, gpoVendedores=420, ofiVentas=740, orgVentas=3031, canal=EX, destinatario=103625, cluster=00, cadena=, fecDoc=20161215, prod=5, prod=42
		 */ 
        
    }
    
    static List<OpportunityLineItem> prodsJSON(){
        String jsonText = '['+
            '{"key":"1",'+
            '"value":['+
            '{"Origen_Surtido__c":"959","ProductCode":"1","Quantity":"10","Volumen__c":"300","Unidad__c":"CJ","UnitPrice":"85.0000","Tipo_de_Precio__c":"PK","Importe__c":"25500","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"},'+
            '{"Origen_Surtido__c":"959","ProductCode":"12","Quantity":"9","Volumen__c":"270","Unidad__c":"CJ","UnitPrice":"85.5000","Tipo_de_Precio__c":"PK","Importe__c":"23085","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul"}]}]';
        
        List<OpportunityParserWSTest.OpportunityToLineItems> records = (List<OpportunityParserWSTest.OpportunityToLineItems>)JSON.deserialize(jsonText, List<OpportunityParserWSTest.OpportunityToLineItems>.class);
        
        return records.get(0).value;
    }
    
    class OpportunityToLineItems {
        String key;
        List<OpportunityLineItem> value;
    }

}