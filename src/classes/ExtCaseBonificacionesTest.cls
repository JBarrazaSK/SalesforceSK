@isTest
public class ExtCaseBonificacionesTest {
    
    static testmethod void testBonificacion(){
        ExtCaseBonificaciones ext =  new ExtCaseBonificaciones();
        ext.Caso =  crearCaso();
        ext.Show =  true;
        ext.NumCaso = '';
        ext.Motivo = 'false-1';
        ext.DisabledImporte=  true;
        ext.DisabledPrecio =  true;
        ext.DisabledVolumen = true;
        ext.NumeroFactura =101;
        crearGrupo('QUEUE-Jefe-Distribucion');
        crearGrupo('QUEUE-Despacho-En-Linea');
        crearGrupo('QUEUE-Ejecutivo-Solucionador');
        crearConf();
        ext.TipoAplicacion = 'PESO';        
        ext.SelectedAplicacion();
        ext.TipoAplicacion = 'PRECIO';
        ext.SelectedAplicacion();
        ext.TipoAplicacion = '';
        ext.SelectedAplicacion();      
        ext.FillAplicacionOptions();
        crearMotivosBonificacion();    
        
        Test.setMock(WebServiceMock.Class, new WsDevolucionesSAPMock.WsConsultaFacturaSAPMock());
        Test.startTest();	
        ext.ConsultarFactura();
        ext.Factura.ListaProductos[0].PrecioReal = 10;
        ext.Factura.ListaProductos[0].VolumenReal = 10;
        	
        Test.setMock(WebServiceMock.Class, new WsDevolucionesSAPMock());
         	ext.factura.ImporteBonificar = 0; 
            ext.GuardarCasoDevolucion(); 
        	ext.factura.ImporteBonificar = 35; 
            ext.GuardarCasoDevolucion();  
            
        	ext.factura.ImporteBonificar = 1; 
        	ext.TipoAplicacion = 'PESO'; 
            ext.GuardarCasoDevolucion(); 
        	ext.TipoAplicacion = 'PRECIO';
            ext.GuardarCasoDevolucion();  
        	 ext.TipoAplicacion = ''; 
        	ext.GuardarCasoDevolucion(); 
        Test.stopTest();
    }
    public static case crearCaso()
    {
        case caso = new case();    
        caso.No_Factura__c = 101;
        caso.RecordTypeId =  [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' and name = 'SK-Queja'].Id;
        system.debug('RECORD=> ' +caso );
        caso.Grupo_de_Clientes_Manual__c = 'CELAYA - 05';
        insert caso;
        return caso;
    }
    public static void crearGrupo(string name){
        group gr =  new group();
        gr.Name = name;
        gr.Type = 'Queue';
        insert gr;
        
    }
    
    public static void crearConf(){
        
        Configuracion_Aplicacion__c conf = new Configuracion_Aplicacion__c();
        conf.Name = 'Configuracion1';
        conf.Descripcion__c = 'Descripcion2';
        conf.Tipo_Motivo__c = 'false-1';

        insert conf;
    }
    public static void crearMotivosBonificacion(){
		Motivos_Bonificacion__c mo = new Motivos_Bonificacion__c();
        mo.Descripcion__c = 'DEscripcion1';
        mo.Name = 'NAME';
        mo.Value__c = 'Valor';
        insert mo;        
    }
}