@isTest
public class ExtCaseBonificacionesTest {
    
    static testmethod void testBonificacion(){
        ExtCaseBonificaciones ext =  new ExtCaseBonificaciones();
        //ext.Caso =  crearCaso();
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
        
        Test.startTest();
        Test.setMock(WebServiceMock.Class, new WsDevolucionesSAPMock.WsConsultaFacturaSAPFailNullMock());     
        ext.ConsultarFactura();
        Test.setMock(WebServiceMock.Class, new WsDevolucionesSAPMock.WsConsultaFacturaSAPFailMock());
        ext.ConsultarFactura();
        Test.setMock(WebServiceMock.Class, new WsDevolucionesSAPMock.WsConsultaFacturaSAPMock());
        ext.ConsultarFactura();

        ext.factura = new ExtCaseBonificaciones.Factura();
        ExtCaseBonificaciones.DetalleFactura detalle =  new ExtCaseBonificaciones.DetalleFactura();
        ext.factura.Abonos='123.20';
        ext.factura.CodigoCliente='114';
        ext.factura.FechaFactura='2018-09-24';
        ext.factura.ImporteBonificar=1;
        ext.factura.ImporteFactura='100.00';        
        ext.factura.Moneda='MXN';
        ext.factura.NombreCliente='114 - Cliente';
        ext.factura.Saldo='32.023';
        detalle.Cantidad='100';
        detalle.CodigoProducto='12';
        detalle.Descripcion='Producto1';
        detalle.Importe=100;
        detalle.Precio=100;
        detalle.Seleccionado=true;
        detalle.Volumen='106';
        ext.Factura.ListaProductos =  new list<ExtCaseBonificaciones.DetalleFactura>();
        ext.Factura.ListaProductos.add(detalle);
        EntityConsultaFactura_SF_to_ECC.Datos_element[] Datos = new list<EntityConsultaFactura_SF_to_ECC.Datos_element>();
        EntityConsultaFactura_SF_to_ECC.Datos_element d = new EntityConsultaFactura_SF_to_ECC.Datos_element();
        EntityConsultaFactura_SF_to_ECC.Cabecero_element Cabecero = new EntityConsultaFactura_SF_to_ECC.Cabecero_element();
        EntityConsultaFactura_SF_to_ECC.Detalle_element det = new EntityConsultaFactura_SF_to_ECC.Detalle_element();
        Cabecero.CodigoCliente = 114;
        Cabecero.DescripcionCliente = 'Producto1';
        Cabecero.Sucursal  = '';
        Cabecero.CanalDistribucion= '';
        Cabecero.GrupoVendedores = '';
        Cabecero.ImporteFactura = 1000;
        Cabecero.Abonos = 123.20;
        Cabecero.Saldo = 32.023;
        Cabecero.Moneda = 'MXN';
        Cabecero.FechaFactura = '2018-01-01';
        d.cabecero =  Cabecero;
        det.CodigoProducto 	= '101';
        det.Descripcion 	= 'desc';
        det.MedidaUnidad 	= 'PI';
        det.Cantidad 		= '10';
        det.SubFamilia 		= '1';
        det.Volumen 		= '10';
        det.Precio 			= 11;
        det.Importe 		= 111;  
         d.Detalle =  new List<EntityConsultaFactura_SF_to_ECC.Detalle_element>();
        d.Detalle.add(det);
        Datos.add(d);
        ext.LlenarEntidadFactura(Datos);
        
        Test.setMock(WebServiceMock.Class, new WsDevolucionesSAPMock.WsDevolucionesSAPFailNullMock());
        ext.factura.ImporteBonificar = 1; 
        ext.GuardarCasoDevolucion(); 
        Test.setMock(WebServiceMock.Class, new WsDevolucionesSAPMock.WsDevolucionesSAPFailMock());
        ext.factura.ImporteBonificar = 1; 
        ext.GuardarCasoDevolucion(); 
        
  	  Test.setMock(WebServiceMock.Class, new WsDevolucionesSAPMock());

        ext.factura.ImporteBonificar = 0; 
        ext.GuardarCasoDevolucion(); 
        ext.factura.ImporteBonificar = 35; 
        ext.GuardarCasoDevolucion();              
        ext.factura.ImporteBonificar = 1; 
        ext.TipoAplicacion = 'PESO'; 
        ext.GuardarCasoDevolucion(); 
        ext.Factura.ListaProductos[0].PrecioReal = 10;
        ext.Factura.ListaProductos[0].VolumenReal = 10;
        ext.TipoAplicacion = 'PRECIO';
		ext.GuardarCasoDevolucion();  
        ext.Factura.ListaProductos[0].PrecioReal = 0;
        ext.Factura.ListaProductos[0].VolumenReal = 0; 
        ext.factura.ImporteBonificar = 1; 
        ext.GuardarCasoDevolucion();
        ext.Factura.ListaProductos[0].PrecioReal = 0;
        ext.Factura.ListaProductos[0].VolumenReal = 0; 
        ext.factura.ImporteBonificar = 1; 
        ext.TipoAplicacion = 'PESO';
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
        caso.Status = 'EN PROCESO';
        upsert caso;
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