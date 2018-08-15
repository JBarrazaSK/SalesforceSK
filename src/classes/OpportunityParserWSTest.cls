/*******************************************************************************
Copyright © 2015 Lynx9. All rights reserved. 
Author: Aranzazu Sereno
Email: sf@lynx9.com
Description: Unit test para la clase de OpportunityParserWS
********************************************************************************/
@isTest
private class OpportunityParserWSTest {

    static testmethod void cover() {
        
        OpportunityParserWS.ActualizaNSC =  false;
        OpportunityParserWS.ActualizaSAP =  false;
        OpportunityParserWS.KG_LB =  2.20462;
        /*
         * Mayoreo
         * cliente=22758, gpoVendedores=212, ofiVentas=64, orgVentas=SK01, canal=MY, destinatario=803613, cluster=37, cadena=, fecDoc=20161215, prod=1, prod=12
         */
      
        Opportunity pedido =  crearPedido();  
        
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
        
        system.debug('PEDIDO=> '+ pedido.Cliente__r.Grupo_de_Vendedores__r.Codigo__c);
        Account cuenta = pedido.Cliente__r;               
        List<Opportunity> pedidos = new List<Opportunity>();
        pedidos.add(pedido);
          
        Map<String, List<OpportunityLineItem>> productos = new Map<String, List<OpportunityLineItem>>();
        List<OpportunityLineItem> lista = prodsJSON();
        productos.put('1',lista);
        productos.put('10',lista);
        productos.put('12',lista);
        

        OpportunityParserWS.dateToDateTime(Date.today());
        OpportunityParserWS.dateToString(Date.today());
        PedidosMayoreoWS.PedidoMayoreo pedidoMayoreo =  new  PedidosMayoreoWS.PedidoMayoreo();
        
        List<String> ListaSucursalesFrontera = new List<String>();
        ListaSucursalesFrontera.addAll('1_Calexico - 803284; 2_Laredo - 803287; 5 Manzanillo - 803287; 9 Miami - 807187; 8_Houston  807186'.split(';'));
        OpportunityParserWS.getPedidoMayoreo(pedido, 'E', 1000, 11, false, lista, cuenta);
        OpportunityParserWS.getPedidoMayoreo(pedido, 'E', 1000, 11, true, lista, cuenta);
        OpportunityParserWS.getProdsXCodigo(lista);        
        OpportunityParserWS.getPedidoMayoreoDetalle(10, 1, lista, pedido);
        OpportunityParserWS.fakeMethod();

        PedidosOtrosCanalesUtils ext = new PedidosOtrosCanalesUtils();
       /* Opportunity pedido2 = crearPedido(pedido.Canal_Factura__r.Id);
        PedidosOtrosCanalesUtils.producto producto = CrearProducto();
        producto.item = CrearOpportunityLineItem(pedido2,crearListaPrecios());
        producto.item.Origen_Surtido__c =  pedido2.Canal_Factura__c;       
        list<PedidosOtrosCanalesUtils.producto> lista2 = new list<PedidosOtrosCanalesUtils.producto> ();
        lista2.add(producto);        
        pedido2.Canal_Factura__r = PedidosOtrosCanalesUtils.retrieveCanalFacturaInfo( pedido.Canal_Factura__c );
        pedido2.Cliente__r = PedidosOtrosCanalesUtils.retrieveCteInfo(pedido.Cliente__c);
		pedidos.add(pedido2);
*/
       
        Test.setMock(WebServiceMock.class, new WsPedidosMayoreoLegadosMock());
        Test.setMock(WebServiceMock.class, new ListaPreciosWSMockImpl());
        /*Test.setMock(WebServiceMock.class, new PedidosMayoreoWSMockImpl());
        
        Test.setMock(HttpCalloutMock.class, new WsActualizaPSVPedidosHttpMock());
        */
        Test.startTest();
            Map<String, Map<String, List<ListaPreciosWS.Precios>>> mapaPrecios = OpportunityParserWS.validarPreciosMayoristas(pedidos, productos, false);
       
        //OpportunityParserWS.guardarPedidos(pedidos, productos, false);  
       // OpportunityParserWS.guardarPedidoslegados(pedidos, productos);    
        Test.stopTest();     

        /*
		 * Exportación
		 * cliente=103625, gpoVendedores=420, ofiVentas=740, orgVentas=3031, canal=EX, destinatario=103625, cluster=00, cadena=, fecDoc=20161215, prod=5, prod=42
		 */ 
        
    }
    public static  Opportunity crearPedido()
    {
        //Oficina de ventas
        Oficina_de_Venta__c ofiVentas =  crearOficinaVenta();
        Account sucursal = new Account();
        Account cliente = crearCliente(ofiVentas.Id);
        
        Opportunity pedido = new Opportunity();
        pedido.Fecha_de_Embarque__c = System.today();
        pedido.Folio_Temporal__c = '1';
        pedido.Id_Externo__c = '000001246177480';
        pedido.Fecha_de_Embarque__c =  date.today();
        pedido.Folio_Pedido_SDL__c = 'P62177';
        pedido.Numero_de_Pedido_NSC__c = '137437';
        pedido.Numero_Pedido_SAP__c = '90000303';
        pedido.Name = 'RANCHO PR3';
        pedido.StageName = 'En Proceso';
        pedido.CloseDate =  date.today();
        pedido.CreatedDate =  date.today(); 
        pedido.Fecha_de_Entrega__c =  Date.today();
        pedido.Frontera__c = '1-CALEXICO'; 
        pedido.Canal_Factura__r = ofiVentas;
        pedido.Cliente__c = cliente.id;
        pedido.Cliente__r =  cliente;
        pedido.AccountId = cliente.Id;     
       
        
        return pedido;
        
    }
    public static Oficina_de_Venta__c crearOficinaVenta()
    {
        Oficina_de_Venta__c ofiv= new Oficina_de_Venta__c();
        ofiv.Codigo__c = '64';
        ofiv.IdPlanta__c= '3';
        ofiv.Hora_de_cierre__c = '10:00';
        ofiv.Descripcion__c = 'TSK LOS ANGELES';
        ofiv.Valida_Disponibilidad__c = false;

		insert ofiv;        
        return ofiv;
    }
    static List<OpportunityLineItem> prodsJSON(){
        String jsonText = '['+
            '{"key":"1",'+
            '"value":['+
            '{"Cantidad__c":"9","Origen_Surtido__c":"959","ProductCode":"1","Quantity":"10","Volumen__c":"300","Unidad__c":"CJ","UnitPrice":"85.0000","Tipo_de_Precio__c":"PK","Importe__c":"25500","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul","Kilos__c":"100","Pallets__c":"10","Piezas__c":"10"},'+
            '{"Cantidad__c":"9","Origen_Surtido__c":"959","ProductCode":"10","Quantity":"10","Volumen__c":"300","Unidad__c":"CJ","UnitPrice":"85.0000","Tipo_de_Precio__c":"PK","Importe__c":"25500","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul","Kilos__c":"100","Pallets__c":"10","Piezas__c":"10"},'+
            '{"Cantidad__c":"9","Origen_Surtido__c":"959","ProductCode":"000000000000000012","Quantity":"9","Volumen__c":"270","Unidad__c":"CJ","UnitPrice":"85.5000","Tipo_de_Precio__c":"PK","Importe__c":"23085","Tipo_de_Inventario__c":"1","Observaciones__c":"Tarima Azul","Kilos__c":"100","Pallets__c":"10","Piezas__c":"10"}]}]';
        
        List<OpportunityParserWSTest.OpportunityToLineItems> records = (List<OpportunityParserWSTest.OpportunityToLineItems>)JSON.deserialize(jsonText, List<OpportunityParserWSTest.OpportunityToLineItems>.class);
        
        return records.get(0).value;
    }
    
    class OpportunityToLineItems {
        String key;
        List<OpportunityLineItem> value;
    }
public static PricebookEntry crearListaPrecios() 
{   
    Product2 prod = new Product2(Name = 'Laptop X200', 
            Family = 'Hardware',Codigo_Id_Externo__c='0000000001');
        insert prod;
     Id pricebookId = Test.getStandardPricebookId();
     PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        return standardPrice; 
}
static PedidosOtrosCanalesUtils.producto CrearProducto()
{
     PedidosOtrosCanalesUtils.producto productos = new PedidosOtrosCanalesUtils.producto();
     productos.isPrecio =true;
     productos.PrecioUnitarioAnterior = 0.0;
     productos.FleteAnterior = 0.0;
     productos.index ='000000000000000012';
     productos.codigo ='10';
     productos.prodName='El producto';
     productos.cajasXPallet= 3;
     productos.contenido= 3;
     productos.precioSAP= 5.23;
     productos.pesoProm=3.15;
     productos.pzasXCaja=4;
     productos.distinctPrice=true;
     productos.inventarioAnt='';
     productos.DiasConsolidacion=3;
     productos.PrecioUnitario=3.00;
     productos.kgs=23.00;
     productos.lbs=46.00;
     productos.cjs=1;
     productos.pzas =1;
     productos.showDelete=false;
     productos.DisabledProd=false;
     productos.peso  =true;
     productos.cantidad=false;
     productos.fisico=false;
     productos.devolucion  =0;
     productos.item = new OpportunityLineItem();
     productos.pbe =new PriceBookEntry();
     productos.ProductoMaster ='';
     productos.HabilitaCantidad=true;
     productos.HabilitaVolumen=false; 
     productos.precioConFlete=3.00;
     return productos;

 }
  public  static OpportunityLineItem CrearOpportunityLineItem(Opportunity pedido,PricebookEntry pbEntry)
    {
        OpportunityLineItem temp = new OpportunityLineItem();
        temp.OpportunityId = pedido.Id;
        temp.PricebookEntryId = pbEntry.Id;
        temp.Quantity = 10;
        temp.Cajas_x_Pallet__c = 25;
        temp.PrecioSAP__c = 1200;
        temp.TotalPrice  =10000;
        temp.Kilos__c = 20;
        temp.Importe__c = 1000;
        temp.Pallets__c = 1;
        temp.Volumen__c = 1000;
        temp.Cajas__C=10;
        temp.Cantidad__c = 10;
        temp.Tipo_de_Inventario__c = '5-PLANEACION';
        temp.Tipo_de_Precio__c  = 'PK';
        upsert temp;
        return temp;
    }
    public static Oficina_de_Venta__c crearOficina(){
        Oficina_de_Venta__c  ofiv = new Oficina_de_Venta__c();
            ofiv.IdPlanta__c = '3';
            ofiv.Codigo__c = '105';   
            ofiv.IdClienteViz__c = '90000303';
            ofiv.Valida_Disponibilidad__c = true;
            ofiv.Descripcion__c = 'TSK LOS ANGELES';
            upsert ofiv;
        return ofiv;
    }
    
    /*public static Opportunity crearPedido(id oficina){
         
        Opportunity pedido =  new Opportunity();
         // Se crean datos de pruebas
        // Oficina_de_Venta__c ofv = crearOficina();
         account cliente = crearCliente(oficina);
            pedido.Canal_Factura__c = oficina; 
            pedido.Id_Externo__c = '000001246177480';
            pedido.Fecha_de_Embarque__c =  date.today();
            pedido.Folio_Pedido_SDL__c = 'P62177';
            pedido.Numero_de_Pedido_NSC__c = '137437';
            pedido.Numero_Pedido_SAP__c = '90000303';
            pedido.Cliente__c = cliente.id;
            pedido.AccountId = cliente.Id;
            pedido.Name = 'RANCHO PR3';
            pedido.StageName = 'En Proceso';
            pedido.CloseDate =  date.today();
            pedido.CreatedDate =  date.today(); 
            pedido.Folio_Temporal__c = '1';
        upsert pedido;

    return pedido;      
    }
*/
   /*   public static Account crearClienteLegados(id oficinaID,Account cuenta){
        Grupo_de_Vendedores__c gv = new Grupo_de_Vendedores__c();
        gv.Name = 'AS REGION MTY - 212';
        gv.Codigo__c = '212';
        gv.Descripcion__c = 'AS REGION MTY';
        gv.TipoSurtido__c = '3 - RUTA';
        insert gv;
        cuenta.Name ='SUC - JON CINA';
        cuenta.Numero_Cliente_SAP__c ='0000408916';
        cuenta.Organizacion_de_Ventas__c='VIZCATTLE CORPORATIO - 3031';
        cuenta.Ramo__c ='AUTOSERVICIO - 22';
        cuenta.Canal_Distribucion__c ='Autoservicio - AS';
        cuenta.Grupo_de_Vendedores__c = gv.Id;
        cuenta.Oficina_de_Ventas__c = oficinaID;
        cuenta.Canal_de_Distribucion_NSC__c =  CrearCanalDistribucion().Id;
        cuenta.Sociedad__c ='VIZCATTLE - 303';
        cuenta.cadena__c ='';
        cuenta.Moneda_Cliente__c = 'Dolares Americanos - USD';
        cuenta.Sector__c ='Comun - 00';
        cuenta.Tipo_de_Credito__c ='Contado - 1';  
        cuenta.Telefono__c = '6671234567'; 
        upsert cuenta;
        return cuenta;
        
    }*/
    public static Account crearCliente(id oficinaID){
        Account cuenta = new Account();
        Grupo_de_Vendedores__c gv = new Grupo_de_Vendedores__c();
        gv.Name = 'AS REGION MTY - 212';
        gv.Codigo__c = '212';
        gv.Descripcion__c = 'AS REGION MTY';
        gv.TipoSurtido__c = '3 - RUTA';
        insert gv;
        
        cuenta.Name ='SUC - JON CINA';
        cuenta.Numero_Cliente_SAP__c ='104184';
        cuenta.Organizacion_de_Ventas__c='VIZCATTLE CORPORATIO - 3031';
        cuenta.Ramo__c ='AUTOSERVICIO - 22';
        cuenta.Canal_Distribucion__c ='Autoservicio - AS';
        cuenta.Grupo_de_Vendedores__c = gv.Id;
        cuenta.Oficina_de_Ventas__c = oficinaID;
        cuenta.Canal_de_Distribucion_NSC__c =  CrearCanalDistribucion().Id;
        cuenta.Sociedad__c ='VIZCATTLE - 303';
        cuenta.cadena__c ='';
        cuenta.Moneda_Cliente__c = 'Dolares Americanos - USD';
        cuenta.Sector__c ='Comun - 00';
        cuenta.Tipo_de_Credito__c ='Contado - 1';  
        cuenta.Telefono__c = '6671234567'; 
        upsert cuenta;
        return cuenta;
        
    }
  public  static Canal_de_Distribucion_NSC__c CrearCanalDistribucion()
  {
      Canal_de_Distribucion_NSC__c     canal = new Canal_de_Distribucion_NSC__c   ();
      canal.Codigo__c = '740';
      canal.Descripcion__c = 'BODEGA CALEXICO';            
      upsert canal;
    return canal;
  }  
}