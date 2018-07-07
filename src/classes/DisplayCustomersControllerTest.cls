@isTest
global class DisplayCustomersControllerTest {
	
    @testSetup
    public static void setupRecords(){
        
        Account Acc = new Account( Name = 'TestAcc',Numero_Cliente_SAP__c = '34248');
        insert Acc;
        
        Estado_de_cuenta__c setting = new Estado_de_cuenta__c();
        setting.Endpoint_Facturas__c = 'http://187.216.127.15:2562/SKServiciosExternos/SalesForce/HistoricoDeFacturacion.asmx';
        setting.Endpoint_Saldos__c = 'http://187.216.127.15:2562/SKServiciosExternos/SalesForce/EstadoDeCuentaCliente.asmx';
        insert setting;        
    }
    
    @isTest
    public static void testCustomers(){
        
        Account testAcc = [SELECT Id FROM Account LIMIT 1];        
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.standardController( testAcc );
        DisplayCustomersController controller = new DisplayCustomersController( sc );
        Test.setMock( HttpCalloutMock.class, new CustomerStatementMockResponse());
        /*Date d1 = controller.startDate;
        d1 = controller.endDate;
        d1 = controller.endDate;
        Boolean displaypopup = controller.displayPopUp;
        displaypopup = controller.displayPopUp;
        controller.startDate = Date.newInstance(2015, 06, 01);
        controller.startDate = Date.newInstance(2015, 06, 01);*/
		controller.showCustomerDetails();
        

        controller.closePopup();
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void testFalseResponse(){
        
        Account testAcc = [SELECT Id FROM Account LIMIT 1];        
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.standardController( testAcc );
        DisplayCustomersController controller = new DisplayCustomersController( sc );
        Test.setMock( HttpCalloutMock.class, new CustomerStatementMockFalseResponse());
        /*Date d1 = controller.startDate;
        d1 = controller.endDate;
        d1 = controller.endDate;
        controller.startDate = Date.newInstance(2015, 06, 01);
        controller.startDate = Date.newInstance(2015, 06, 01);*/
		controller.showCustomerDetails();
        
        Boolean displaypopup = controller.displayPopUp;
        displaypopup = controller.displayPopUp;
        controller.closePopup();
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void testNullAccount(){
        
        Account Acc = new Account( Name = 'TestAcc');
        ApexPages.StandardController sc = new ApexPages.standardController( Acc );
        DisplayCustomersController controller = new DisplayCustomersController( sc );
        
    }
	
    @isTest
    public static void testNullCustomerNumber(){
        
        Account Acc = new Account( Name = 'TestAcc');
        insert Acc;
        
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController( Acc );
        DisplayCustomersController controller = new DisplayCustomersController( sc );
        controller.showCustomerDetails();
        test.stopTest();
    }

    
	global class CustomerStatementMockResponse implements HttpCalloutMock {
	
        global HttpResponse respond(HttpRequest req){
            System.assertEquals('http://187.216.127.15:2562/SKServiciosExternos/SalesForce/EstadoDeCuentaCliente.asmx', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            res.setBody('<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ConsultarSaldosResponse xmlns="http://www.sukarne.com/ws/salesforce"><ConsultarSaldosResult><Datos><EstadoDeCuenta><Folio>A-214064</Folio><Fecha>04/01/2014</Fecha><Concepto>FACTURA</Concepto><Referencia>A-214064</Referencia><FechaVencimiento>19/01/2014</FechaVencimiento><Cargos>57655.13</Cargos><Abonos>0</Abonos><Saldo>0</Saldo><NumeroPoliza>214064</NumeroPoliza></EstadoDeCuenta></Datos><Mensaje/><Tipo>TerminadoConExito</Tipo></ConsultarSaldosResult></ConsultarSaldosResponse></soap:Body></soap:Envelope>');
            res.setStatusCode(200);
            return res;
        }
    
	}
	
    global class CustomerStatementMockFalseResponse implements HttpCalloutMock {
	
        global HttpResponse respond(HttpRequest req){
            System.assertEquals('http://187.216.127.15:2562/SKServiciosExternos/SalesForce/EstadoDeCuentaCliente.asmx', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            res.setBody('<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><ConsultarSaldosResponse xmlns="http://www.sukarne.com/ws/salesforce"><ConsultarSaldosResult><Datos></Datos><Mensaje/><Tipo>TerminadoConExito</Tipo></ConsultarSaldosResult></ConsultarSaldosResponse></soap:Body></soap:Envelope>');
            res.setStatusCode(200);
            return res;
        }
    
	}
    
}