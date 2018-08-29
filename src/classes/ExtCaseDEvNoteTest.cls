@isTest
public class ExtCaseDEvNoteTest {
    
    static testmethod void Cover()
    {
        
        ExtCaseDEvNote note =  new ExtCaseDEvNote();
        note.Show =  true;
        note.NumCaso = '101';
         crearCuenta();
        crearContacto();
        crearCaso();
        crearGrupo('QUEUE-Jefe-Distribucion');
        crearGrupo('QUEUE-Despacho-En-Linea');
        crearGrupo('QUEUE-Ejecutivo-Solucionador');
        note.showPageMessage('WARNING', '');
        note.showPageMessage('CONFIRM', '');
        note.showPageMessage('ERROR', '');
        
       
        test.setMock(WebServiceMock.class, new WsDevolucionesSAPMock.WsConsultaFacturaSAPMock());
        test.startTest();
        note.ConsultarFactura();
        test.setMock(WebServiceMock.class, new WsDevolucionesSAPMock.WsConsultaFacturaSAPFailMock());
        note.ConsultarFactura();
        test.setMock(WebServiceMock.class, new WsDevolucionesSAPMock());
        note.Factura.ListaProductos[0].Cantidad_Dev = 1;
        note.GuardarCasoDevolucion();        
        test.setMock(WebServiceMock.class, new WsDevolucionesSAPMock.WsDevolucionesSAPFailMock());
        note.GuardarCasoDevolucion();
        test.stopTest();
    }
     public static case crearCaso()
    {
        case caso = new case();    
        caso.No_Factura__c = 101;
        caso.RecordTypeId =  [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' and name = 'SK-Queja'].Id;
        system.debug('RECORD=> ' +caso );
        caso.Grupo_de_Clientes_Manual__c = 'CELAYA - 05';
        caso.ContactId = obtenerContacto().Id;
        caso.AccountId = obtenerCliente().Id;
        insert caso;
        return caso;
    }
    public static void crearCuenta(){        
        Account cuenta = new Account();
        cuenta.Name = 'CLIENTE 1';
        cuenta.Numero_Cliente_SAP__c = 'SUC - 0000000114';
        cuenta.RecordTypeId =  [SELECT Id FROM RecordType WHERE SobjectType='Account' and name = 'Sucursal'].Id;
        insert cuenta;      
    }
       public static void crearContacto(){
        
        Contact contac = new Contact();
     	contac.AccountId = obtenerCliente().Id;
          contac.LastName = 'LAST';
        insert contac;   
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