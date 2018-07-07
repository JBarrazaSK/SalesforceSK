@isTest
global class ctrlCabeceroFacturas_UT {
	@TestSetup
    public static void testData(){
        
        Account parentAccnt = new Account(Name = 'TestParentAcc',
                                          Numero_Cliente_SAP__c = '34248');
        insert parentAccnt;
                
        Account testAccnt = new Account(Name = 'TestAcc',
                                        ParentId = parentAccnt.Id);
        insert testAccnt;
        
        Estado_de_cuenta__c setting = new Estado_de_cuenta__c();
        setting.Endpoint_Facturas__c = 'http://187.216.127.15:2562/SKServiciosExternos/SalesForce/HistoricoDeFacturacion.asmx';
        setting.Endpoint_Saldos__c = 'http://187.216.127.15:2562/SKServiciosExternos/SalesForce/EstadoDeCuentaCliente.asmx';
        insert setting;
    } 
    
    @isTest
    public static void TestInvoicesByInvoiceNumber(){
        
        Account testAcc = [SELECT Id FROM Account WHERE Name = 'TestAcc'];        
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.standardController( testAcc );
        ctrlCabeceroFacturas controller = new ctrlCabeceroFacturas( sc );
        Test.setMock( HttpCalloutMock.class, new BillingHistoryMockResponse());
        
        //Call controller methods
        ctrlCabeceroFacturas.displayInvoices(testAcc.Id,
                                                  '',
                                                  '',
                                                  '',
                                                  '');    
        //DisplayInvoicesController.displayPageMessages('FATAL', 'Exception');
        Test.stopTest();
        
    }
    
    @isTest
    public static void testNullAccount(){
        
        Account Acc = new Account( Name = 'TestAcc');
        ApexPages.StandardController sc = new ApexPages.standardController( Acc );
        ctrlCabeceroFacturas controller = new ctrlCabeceroFacturas( sc );
        
    }
    
    @isTest
    public static void TestInvoicesNullReponse(){
        
        Account testAcc = [SELECT Id FROM Account WHERE Name = 'TestAcc'];       
        
        Account parentAccntNoCutomerNo = new Account(Name = 'TestParentAcc');
        insert parentAccntNoCutomerNo;
        
        testAcc.ParentId = parentAccntNoCutomerNo.Id;
        update testAcc;
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.standardController( testAcc );
        ctrlCabeceroFacturas controller = new ctrlCabeceroFacturas( sc );
        Test.setMock( HttpCalloutMock.class, new BillingHistoryMockFalseResponse());
        
        //Boolean displaypopup = controller.displayPopUp;
        ctrlCabeceroFacturas.displayInvoices(testAcc.Id, 
                                                  String.valueOf(Date.newInstance(2015, 06, 01)), 
                                                  String.valueOf(Date.newInstance(2015, 06, 01)),
                                                  '',
                                                  '');       
        
        Test.stopTest();
        
    }
    
    //Mock Classes Http Callout classes
    
    /*
    @description : Http callout mock for proper data response 
    */
    global class BillingHistoryMockResponse implements HttpCalloutMock {
        
        global HttpResponse respond(HttpRequest req){
            System.assertEquals('http://187.216.127.15:2562/SKServiciosExternos/SalesForce/HistoricoDeFacturacion.asmx', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ConsultarFacturasResponse xmlns="http://www.sukarne.com/ws/salesforce"><ConsultarFacturasResult><Datos><FacturaCabecero><Pedido>000640000026680</Pedido><CanalDistribucionDescripcion>PLANTA CADIS CULIACAN</CanalDistribucionDescripcion><Factura>A-217048</Factura><Cliente>34248</Cliente><ClienteDescripcion>CASA LEY SA DE CV </ClienteDescripcion><Sucursal>BOD CLN</Sucursal><CanalDistribucionVenta>152</CanalDistribucionVenta><CanalVentaDescripcion>AUTOSERVICIOS MEX-CULIACA</CanalVentaDescripcion><Fecha>2015-06-01T00:00:00</Fecha><FechaVencimiento>2014-07-16T00:00:00</FechaVencimiento><DiasVencidos>0</DiasVencidos><Importe>654329.63</Importe><Saldo>0.00</Saldo><Moneda>MXN</Moneda><TipoCambio>1.0000</TipoCambio><TipoSurtido>RUTA</TipoSurtido><PedidoCanalDistribucion>64</PedidoCanalDistribucion><PedidoCliente>64</PedidoCliente><Credito>true</Credito><Activo>false</Activo><Prospecto>0</Prospecto><FacturaNoFiscal>0</FacturaNoFiscal><Devolucion>0</Devolucion><Bonificacion>1</Bonificacion><DetalleProductos><FacturaDetalleProducto><Pedido>000640000026680</Pedido><Producto>6</Producto><ProductoDescripcion>FULL PEELED KNUCKLE/PULPA BOLA LIMPIA</ProductoDescripcion><CantidadEnUnidadMovimiento>1422.670</CantidadEnUnidadMovimiento><Piezas>50</Piezas><FactorConversionAUnidadBase>1.0000</FactorConversionAUnidadBase><CantidadEnUnidadBase>1422.670</CantidadEnUnidadBase><ImporteVentaConImpuesto>112675.46</ImporteVentaConImpuesto><ImpuestoVenta>0.00</ImpuestoVenta><PrecioFacturado>79.2000</PrecioFacturado><ImporteVentaConImpuestoEnMonedaBase>112675.46</ImporteVentaConImpuestoEnMonedaBase><ImpuestoVentaEnMonedaBase>0.00</ImpuestoVentaEnMonedaBase><TipoPrecioNormal>PK</TipoPrecioNormal><DevolucionCantidadEnUnidadMovimiento>0.000</DevolucionCantidadEnUnidadMovimiento><DevolucionPiezas>0</DevolucionPiezas><DevolucionCantidadEnUnidadBase>0.000</DevolucionCantidadEnUnidadBase><DevolucionImporteBase>0.00</DevolucionImporteBase><BonificacionFolio>AAAA-5147</BonificacionFolio><BonificacionImporte>6309.83</BonificacionImporte><BonificacionTipoBonif>BONIF V.A. PUBLICIDAD</BonificacionTipoBonif><BonificacionAutomatica>true</BonificacionAutomatica><DetalleCodigoBarras><FacturaDetalleCodigoBarras><Pedido>000640000026680</Pedido><Producto>6</Producto><CodigoBarra>21000000060025300011406241900710</CodigoBarra><Devuelto>false</Devuelto></FacturaDetalleCodigoBarras></DetalleCodigoBarras></FacturaDetalleProducto></DetalleProductos></FacturaCabecero></Datos><Mensaje /><Tipo>TerminadoConErrores</Tipo></ConsultarFacturasResult></ConsultarFacturasResponse></soap:Body></soap:Envelope>');
            res.setStatusCode(200);
            return res;
        }
        
    }
    
    /*
    @description : Http callout mock for null data response 
    */
    global class BillingHistoryMockFalseResponse implements HttpCalloutMock {
        
        global HttpResponse respond(HttpRequest req){
            System.assertEquals('http://187.216.127.15:2562/SKServiciosExternos/SalesForce/HistoricoDeFacturacion.asmx', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            HttpResponse res = new HttpResponse();
            //res.setHeader('Content-Type', 'application/json');
            //res.setBody('<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ConsultarFacturasResponse xmlns="http://www.sukarne.com/ws/salesforce"><ConsultarFacturasResult><Datos></Datos><Mensaje /><Tipo>TerminadoConErrores</Tipo></ConsultarFacturasResult></ConsultarFacturasResponse></soap:Body></soap:Envelope>');
            res.setStatusCode(400);
            return res;
        }
        
    }   
}