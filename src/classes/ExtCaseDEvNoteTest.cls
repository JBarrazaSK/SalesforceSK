@isTest
public class ExtCaseDEvNoteTest {
    
    static testmethod void Cover()
    {
        
        ApexPages.StandardController stdController;
        
        ExtCaseDEvNote note =  new ExtCaseDEvNote();
        note.Show =  true;
        note.Numfactura ='90176940';
        note.NumCaso = '101';        
       	Account cuenta=  crearCuenta();
        Contact contacto =  crearContacto();
 		//note.Caso =  crearCaso(); 
        crearGrupo('Jefe-Distribucion');
        crearGrupo('QUEUE-Despacho-En-Linea');
        crearGrupo('QUEUE-Ejecutivo-Solucionador');
        note.showPageMessage('WARNING', '');
        note.showPageMessage('CONFIRM', '');
        note.showPageMessage('ERROR', '');
        
        
        test.setMock(WebServiceMock.class, new WsDevolucionesSAPMock.WsConsultaFacturaSAPFailNullMock());
        test.startTest();
        note.ConsultarFactura();
        test.setMock(WebServiceMock.class, new WsDevolucionesSAPMock.WsConsultaFacturaSAPFailMock());    
        note.ConsultarFactura();
        test.setMock(WebServiceMock.class, new WsDevolucionesSAPMock.WsConsultaFacturaSAPMock());      
        note.ConsultarFactura();
        
        test.setMock(WebServiceMock.class, new WsDevolucionesSAPMock.WsDevolucionesSAPFailNullMock());
        note.Factura.ListaProductos[0].Cantidad_Dev = 0;
        note.GuardarCasoDevolucion();
        note.Factura.ListaProductos[0].Cantidad_Dev = 200;
        note.GuardarCasoDevolucion();
        note.Factura.ListaProductos[0].Cantidad_Dev = 1;
        note.GuardarCasoDevolucion();
        test.setMock(WebServiceMock.class, new WsDevolucionesSAPMock.WsDevolucionesSAPFailMock());
        //note.Factura.ListaProductos[0].Cantidad_Dev = 0;
        note.GuardarCasoDevolucion();
        test.setMock(WebServiceMock.class, new WsDevolucionesSAPMock());
        note.Factura.ListaProductos[0].Cantidad_Dev = 1;
        note.GuardarCasoDevolucion();  
        test.stopTest();

    }
     public static case crearCaso()
    {
        case caso = new case();    
        caso.No_Factura__c = 101;
        caso.RecordTypeId =  [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' and name = 'SK-Queja' limit 1].Id;       
        caso.ContactId = obtenerContacto().Id;
        caso.AccountId = obtenerCliente().Id;
       	caso.Grupo_de_Clientes_Manual__c = 'CELAYA - 05';
        CASO.Folio_DocumentoSAP__c = '';
        insert caso;
        return caso;
    }
    public static Account crearCuenta(){        
        Account cuenta = new Account();
        cuenta.Name = 'CLIENTE 1';
        cuenta.Numero_Cliente_SAP__c = 'SUC - 0000000114';
        cuenta.RecordTypeId =  [SELECT Id FROM RecordType WHERE SobjectType='Account' and name = 'Sucursal'].Id;
        insert cuenta; 
        return cuenta;
    }
       public static Contact crearContacto()
       {        
           Contact contac = new Contact();
           contac.AccountId = obtenerCliente().Id;
           contac.LastName = 'LAST';
           insert contac; 
           return contac;
    }
       public static void crearGrupo(string name){
        group gr =  new group();
        gr.Name = name;
        gr.Type = 'Queue';
        insert gr;
        
    }

    public static Account obtenerCliente(){
        
        return [SELECT Id FROM Account limit 1];
    }
       public static Contact obtenerContacto(){
        
        return [SELECT Id FROM Contact limit 1];
    }
}