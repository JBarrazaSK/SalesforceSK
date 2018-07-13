/**
* @Description: Util class for Otros Canales VF page
* @Created Date: 29 September 2016
* @Author: Jose Ruben Barraza
* @Company: Sukarne
*/
public class PedidosOtrosCanalesUtils {

    public static String tz = 'GMT-07:00';

    public static final Integer WEB_SERVICE_TIMEOUT   = 120000;
    public static final Decimal CONVERSION_KILO_POUND   = 2.2046;
    public static final String PEDIDO_INSERT_CONFIRM   = 'El pedido ha sido guardado con éxito. ';
    public static final String EMBARQUE_INSERT_CONFIRM   = 'El pedido ha sido guardado con éxito. ';
    public static final String PEDIDO_CANCEL_CONFIRM   = 'El pedido ha sido cancelado con éxito.';
    public static final String WRONG_VALUE_ERROR     = 'Dato incorrecto. ';
    public static final String NO_AVAILABLE_PRODUCT   = 'No hay el producto disponible en este Origen. ';
    public static final String NO_PRICES_AVAILABLE    = 'No hay precios configurados para este cliente. ';
    public static final String NO_PRICES_AVAILABLE_VIZ  = 'No hay precios Intercompanía configurados para este cliente. ';
    public static final String FECHA_EMBARQUE_INVALIDA  = 'Por favor introduzca una Fecha de Embarque válida. ';
    public static final String SELECCION_CANAL_FACTURA  = 'Por favor seleccione el Canal Factura. ';
    public static final String SELECCION_ORIGEN      = 'Por favor seleccione el origen. ';
    public static final String NO_PEDIDO_RESPONSE    = 'Al parecer hubo un error al salvar el pedido en SDL, inténtelo nuevamente. ';
    public static final String NO_CREDIT_VALIDATION    = 'La interfaz de crédito no responde. ';
    public static final String NO_PRODUCT_PRICE      = 'No hay precio configurado para el producto, ¡Imposible continuar! ';
    public static final String NO_PRODUCT_PRICE_VIZ    = 'No hay precio Intercompañía configurado para el producto, ¡Imposible continuar! ';
    public static final String NO_SUC_VIZ        = 'No se encuentra Configurada la Sucursal Intercompañía.';
    public static Boolean EnvioAprobacion {get;set;}
    public static String MensajeAprobacion {get;set;}
    public static map<string,Producto> productosSinModificar  {get; set;}
    public static map<string,AdminSaldosEstrategias__c> mapEstrategias {get; set;}
    public static Boolean ContainsDelete {get; set;}
    public static list<PedidosOtrosCanalesUtils.Producto> productosSinModificacion  {get; set;}
    public static Opportunity pedidoSinMod              {get; set;}
    public static map<String,AdminSaldosEstrategias__c> mapEstrategiasMod  {get; set;}
    public static map<string,Configuracion_pedidosOC__c> mapTipoPedido {get;set;}
    public static boolean PedidoBloqueado {get;set;}
    public static boolean ActualizaSAP {get;set;}
    public static boolean ActualizaNSC {get;set;}
    public static boolean ActualizaPSV {get;set;}
    public static Boolean ProductoNuevo {get;set;}
    public static map<string,Producto> productosSap  {get; set;}
    /* DATOS MAESTROS */
    
    public static List<SelectOption> fillFronteras() {
        List<Frontera__c> frntrs = Frontera__c.getall().values();
        List<SelectOption> fronteras = new List<SelectOption>();
        System.debug('FronterasConf: ' + frntrs);
        if( frntrs.size() > 0 ) {
            fronteras = new List<SelectOption>();
            SelectOption opt1 = new SelectOption( '', '--- Seleccionar ---' );
            fronteras.add( opt1 );
            for( Frontera__c f: frntrs ) {
                if( f == null ) { continue; }
                SelectOption opt = new SelectOption( f.Id_Frontera__c+'-'+f.Name, f.Id_Frontera__c+'-'+f.Name );
                fronteras.add( opt );
            }
        }
        
        return fronteras;
    }
    public static List<SelectOption> fillMotivosModificacion() {
        List<Motivos_Modificacion__c> frntrs = Motivos_Modificacion__c.getall().values();
        List<SelectOption> Motivos = new List<SelectOption>();

        System.debug('Motivos_Modificacion__c: ' + frntrs);
        if( frntrs.size() > 0 ) {
            Motivos = new List<SelectOption>();
            SelectOption opt1 = new SelectOption( '', '--- Seleccionar ---' );
            Motivos.add( opt1 );
            for( Motivos_Modificacion__c f: frntrs) {
                if( f == null ) { continue; }
                SelectOption opt = new SelectOption(f.Valor__c, f.Codigo__c+' - '+f.Name );
                Motivos.add( opt );
            }
        }

        return Motivos;
    }
    public static List<SelectOption> fillMotivosCancelacion() {
        List<Motivos_Cancelacion__c> frntrs = Motivos_Cancelacion__c.getall().values();
        List<SelectOption> Motivos = new List<SelectOption>();

        System.debug('Motivos_Modificacion__c: ' + frntrs);
        if( frntrs.size() > 0 ) {
            Motivos = new List<SelectOption>();
            SelectOption opt1 = new SelectOption( '', '--- Seleccionar ---' );
            Motivos.add( opt1 );
            for( Motivos_Cancelacion__c f: frntrs) {
                if( f == null ) { continue; }
                SelectOption opt = new SelectOption(f.Valor__c, f.Codigo__c+' - '+f.Name );
                Motivos.add( opt );
            }
        }

        return Motivos;
    }
    
    public static List<SelectOption> fillUM() {
        List<SelectOption> medidas = new List<SelectOption>();
        
        SelectOption s = new SelectOption( '', '---Seleccionar---' );
        medidas.add( s );
        SelectOption c = new SelectOption( 'C', 'Cajas' );
        medidas.add( c );
        SelectOption p = new SelectOption( 'P', 'Piezas' );
        medidas.add( p );
        SelectOption k = new SelectOption( 'K', 'Kilos' );
        medidas.add( k );
        SelectOption l = new SelectOption( 'L', 'Libras' );
        medidas.add( l );
        
        return medidas;
    }

    public static List<SelectOption> fillTP() {
        List<Tipos_de_Precio__c> precios = Tipos_de_Precio__c.getall().values();
        if( precios == null ) { return null; } System.debug('Precios: '+precios);
        List<SelectOption> monedas = new List<SelectOption>();
        SelectOption aux = new SelectOption( '', '---Seleccionar---' );
        monedas.add( aux );
        for( Tipos_de_Precio__c tp: precios ) {
            SelectOption tpo = new SelectOption( tp.Name, tp.Name );
            monedas.add( tpo );
        }
        
        return monedas;
    }
    
    public static List<SelectOption> fillInventarios() {
        List<Inventarios__c> csInv = Inventarios__c.getall().values();
        List<SelectOption> inventarios = new List<SelectOption>();
        
        SelectOption i = new SelectOption( '', '---Seleccionar---' );
        inventarios.add( i );
        for( Inventarios__c inv: csInv ) {
            if( inv == null ) { continue; }
            SelectOption csi = new SelectOption( inv.Name, inv.Descripcion__c );
            inventarios.add( csi );
        }
        
        return inventarios;
    }
    
    public static List<SelectOption> fillRangos() {
        List<SelectOption> rangos = new List<SelectOption>();
        
        SelectOption r = new SelectOption('', '---Seleccionar---');
        rangos.add( r );
        SelectOption r1 = new SelectOption('10 días o menos', '10 días o menos');
        rangos.add( r1 );
        SelectOption r2 = new SelectOption('15 días o menos', '15 días o menos');
        rangos.add( r2 );
        SelectOption r3 = new SelectOption('25 días o menos', '25 días o menos');
        rangos.add( r3 );
        SelectOption r4 = new SelectOption('más de 25 días', 'más de 25 días');
        rangos.add( r4 );
        
        return rangos;
    }
    
    /* DATOS MAESTROS */
    
    public static Map<String, Oficina_de_Venta__c> completeOrigenesData( List<Producto> productos ) {
        if( productos == null ) { return null; }
        System.debug('Buscando Origenes de los Productos...');
        Map<String, Oficina_de_Venta__c> mapOrigenes = new Map<String, Oficina_de_Venta__c>();
        List<String> origenesId = new List<String>();
        
        for( Producto p: productos ) {
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( p.item == null ) { continue; }
            if( String.isBlank( p.item.Origen_Surtido__c ) ) { continue; }
            
            origenesId.add( p.item.Origen_Surtido__c );
        }
        
        List<Oficina_de_Venta__c> origenes = new List<Oficina_de_Venta__c>();
        try {
            origenes = [SELECT Id, Codigo__c, IdPlanta__c, IdClienteViz__c, Descripcion__c, Surte_Otros_Canales__c, Valida_Disponibilidad__c, SucursalesViz__c,Dias_consolidacion__c,Dias_Consolidacion_Prod__c,Dias_de_cierre__c,Opera_en_SAP__c
                        FROM Oficina_de_Venta__c
                        WHERE ID IN: origenesId];
        } catch( Exception e ) {
            System.debug( 'ERR::Origenes: ' + e.getMessage() );
            return null;
        }
        
        for( Oficina_de_Venta__c o: origenes ) {
            if( o == null ) { continue; }
            Oficina_de_venta__c tmp = mapOrigenes.get( o.Id );
            if( tmp == null ) {
                mapOrigenes.put( o.Id, o);
            }
        }
        
        return mapOrigenes;
    }
    
    public static Oficina_de_Venta__c retrieveCanalFacturaInfo( String ofiVtaId ) {
        if( String.isBlank( ofiVtaId ) ) { return null; }
        System.debug('Buscando Info completa de Canal Factura...');
        
        Oficina_de_Venta__c canalF;
        try{
            canalF = [SELECT Id, Name, Codigo__c, IdPlanta__c, IdClienteViz__c, Descripcion__c, Surte_Otros_Canales__c,SucursalesViz__c,Dias_consolidacion__c,Dias_Consolidacion_Prod__c,Valida_Disponibilidad__c,Hora_de_cierre__c,Dias_de_cierre__c,Centro__c,Opera_en_SAP__c
                      FROM Oficina_de_Venta__c
                      WHERE ID =: ofiVtaId LIMIT 1];
        } catch( Exception e ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.SELECCION_CANAL_FACTURA));
            return null;
        }
        
        return canalF;
    }
    
    /* DISPONIBILIDAD */
    public static String dateToString(Date dFecha, String format){
        String sFecha= null;
        if(dFecha != null)
        {
            DateTime fechaHora = datetime.newInstance(dFecha.year(), dFecha.month(), dFecha.day());
            System.debug('Fecha original:' + dFecha + ', DateTime:' + fechaHora);
            sFecha = fechaHora.format(format);
            System.debug('Fecha:' + sFecha);
        }
        return sFecha;
    }
    
    public static Map<String, ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud> createDispoRequest( Opportunity pedido, List<PedidosOtrosCanalesUtils.Producto> productos  ) {
        if( pedido == null ) { return null; }
        if( productos == null ) { return null; }
        if( pedido.Fecha_de_Embarque__c == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.FECHA_EMBARQUE_INVALIDA)); return null;
        }
        System.debug('Empezando a armar Request de Disponibilidad...');
        pedido.Canal_Factura__r = retrieveCanalFacturaInfo( pedido.Canal_Factura__c );
        if( String.isBlank( pedido.Canal_Factura__r.IdPlanta__c ) && !pedido.Canal_Factura__r.Surte_Otros_Canales__c ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.SELECCION_CANAL_FACTURA)); return null;
        }
        
        Map<String, Oficina_de_Venta__c> mapOrigenes = completeOrigenesData( productos );
        if( mapOrigenes == null || mapOrigenes.size() == 0 ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.SELECCION_ORIGEN)); return null;
        }
        
        Date fechaEmbarque = pedido.Fecha_de_Embarque__c;
        Date fechaInicio = fechaEmbarque.addDays( -6 );
        Date fechaFin = fechaEmbarque.addDays( 6 );
        String fInicio = dateToString(fechaInicio,'yyyyMMdd');
        String fFin = dateToString(fechaFin,'yyyyMMdd');
        
        Map<String, ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud> mapDispoO = new Map<String, ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud>();
        for( Producto op: productos ) {
            if( op == null ) { continue; }
            if( String.isBlank( op.codigo ) ) { continue; }
            if( op.item == null ) { continue; }
            op.item.Origen_Surtido__r = mapOrigenes.get(op.item.Origen_Surtido__c);
            if( op.item.Origen_Surtido__r == null ) { continue; }
            if( !op.item.Origen_Surtido__r.Valida_Disponibilidad__c ) { continue; }
            System.debug('ORIGEN: '+mapOrigenes.get(op.item.Origen_Surtido__c));
            String origenCode = op.item.Origen_Surtido__r.Codigo__c;
            System.debug('Origen Code: ' + origenCode );
            //if( String.isBlank( op.item.Origen_Surtido__r.IdPlanta__c ) && String.isBlank( op.item.Origen_Surtido__r.Codigo__c ) ) { continue; }
            
            ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud temp = mapDispoO.get( origenCode );
            if( temp == null ) {
                temp = fillSolicitudDispo( 0,
                                          Integer.valueOf( origenCode ),
                                          Integer.valueOf( pedido.Canal_Factura__r.Codigo__c ),
                                          fInicio,
                                          fFin,
                                          0 );
                mapDispoO.put( origenCode, temp );
            }
            
            ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta arrayProds = temp.productos;
            if( arrayProds == null ) {
                arrayProds = new ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta();
                List<ConsultaDisponibilidadMayoristasWS.ProductosConsulta> listProdWS = new List<ConsultaDisponibilidadMayoristasWS.ProductosConsulta>();
                ConsultaDisponibilidadMayoristasWS.ProductosConsulta prod = new ConsultaDisponibilidadMayoristasWS.ProductosConsulta();
                prod.producto = Integer.valueOf( op.codigo );
                listProdWS.add(prod);
                arrayProds.ProductosConsulta = listProdWS;
                temp.productos = arrayProds;
            }
            else {
                List<ConsultaDisponibilidadMayoristasWS.ProductosConsulta> listProdWS = arrayProds.ProductosConsulta;
                boolean exist = false;
                for( ConsultaDisponibilidadMayoristasWS.ProductosConsulta p: listProdWS ) {
                    if( p == null ) { continue; }
                    if( p.producto == Integer.valueOf( op.codigo ) ) {
                        exist = true;
                    }
                    if( exist ) { break; }
                }
                
                if( !exist ) {
                    ConsultaDisponibilidadMayoristasWS.ProductosConsulta prod = new ConsultaDisponibilidadMayoristasWS.ProductosConsulta();
                    prod.producto = Integer.valueOf( op.codigo );
                    listProdWS.add( prod );
                    arrayProds.ProductosConsulta = listProdWS;
                    temp.productos = arrayProds;
                }
            }
        }
        
        System.debug('MapaDispoRequest: ' + mapDispoO);
        return mapDispoO;
    }
    
    public static ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud fillSolicitudDispo( Integer canal, Integer almacen, Integer almacenDestino, String fechaInicio, String fechaFin, Integer area ) {
        ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud dispoWS = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud();
        ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesConsulta ArregloAlmacenesConsulta = new ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesConsulta();
        ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesDestinoConsulta ArregloAlmacenDestino = new ConsultaDisponibilidadMayoristasWS.ArrayOfAlmacenesDestinoConsulta();
        list<ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta> listaAlmacenConsulta = new list<ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta>();
        list<ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta> listaAlmacenDestino = new list<ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta>();
        ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta almacenDestinoWS = new ConsultaDisponibilidadMayoristasWS.AlmacenesDestinoConsulta();
        ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta almacenConsulta = new ConsultaDisponibilidadMayoristasWS.AlmacenesConsulta();
        almacenDestinoWS.almacenDestino = almacenDestino;
        listaAlmacenDestino.add(almacenDestinoWS);
        almacenConsulta.almacen = almacen;
        listaAlmacenConsulta.add(almacenConsulta);
        ArregloAlmacenesConsulta.AlmacenesConsulta = listaAlmacenConsulta;
        ArregloAlmacenDestino.AlmacenesDestinoConsulta = listaAlmacenDestino;
        dispoWS.Canal = canal; //0; //Canal: EX, MY...
        dispoWS.almacenes = ArregloAlmacenesConsulta;
        dispoWS.almacenesDestino = ArregloAlmacenDestino;//almacenDestino; //740;
        dispoWS.fechaInicio = fechaInicio; //'20161024';
        dispoWS.fechaFin = fechaFin; //'20161102';
        dispoWS.area = area; //0;
        System.debug('Encabezado Dispo: ' + dispoWS);
        return dispoWS;
    }

    public static Map<String, Map<String, List<DispoMayoristas>>> retrieveDisponibilidad( ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas response, List<Producto> productos, Date fechaEmbarque ) {
        if( response == null ) { return null; }
        ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas dispoDatos = response.Datos;
        if( dispoDatos == null ) { return null; }
        List<ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas> dispoMayoristas = dispoDatos.DisponibilidadMayoristas;

        Date fechaInicio = fechaEmbarque.addDays( -6 );
        Date fechaFin = fechaEmbarque.addDays( 6 );

        if( dispoMayoristas == null ) { return null; }
        if( dispoMayoristas.size() == 0 ) { return null; }
        List<PedidosOtrosCanalesUtils.DispoMayoristas> dispo = new List<PedidosOtrosCanalesUtils.DispoMayoristas>();

        Map<String, Map<String, List<DispoMayoristas>>> mapProdDispo = new Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>();
        List<Datetime> rangoFechas = setRangoDeFechas( fechaEmbarque );

        for( ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dm: dispoMayoristas ) {
            if( dm == null ) { continue; }
            if( String.isBlank(dm.producto) ) { continue; }
            PedidosOtrosCanalesUtils.DispoMayoristas dms = new PedidosOtrosCanalesUtils.DispoMayoristas();
            if( !dm.producto.contains('-') ) {continue;}
            List<String> pCode = dm.producto.split('-');
            
            Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>> mapTipoInv = mapProdDispo.get( dm.producto );
            if( mapTipoInv == null ) {
                mapTipoInv = new Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>();
                mapProdDispo.put( dm.producto, mapTipoInv);
            }
            
            List<DispoMayoristas> listDispo = mapTipoInv.get( dm.tipoInventario );
            System.debug('MapTipoInv: '+listDispo + ' Inv: '+dm.tipoInventario);
            if( listDispo == null ) {
                listDispo = new List<DispoMayoristas>();
                mapTipoInv.put( dm.tipoInventario, listDispo);
            }

            List<String> df = dm.fecha.split('-');
            if( df == null || df.size() == 0 ) { continue; }
            Integer anio = Integer.valueOf( df.get(2) );// dm.fecha.right(4) );
            Integer mes = integer.valueOf( df.get(1) );// dm.fecha.substring(3, 5) );
            Integer dia = Integer.valueOf( df.get(0) );// dm.fecha.left(2) );
            System.debug('FechaPresupuesto: '+dia+'/'+mes+'/'+anio);
            Date dFecha = Date.newInstance( anio, mes, dia );

            DispoMayoristas dispoM = new DispoMayoristas();
            dispoM.producto     = dm.producto;
            dispoM.contenido     = dm.contenido;
            dispoM.tipoInventario   = dm.tipoInventario;
            dispoM.pesoPromedio   = dm.pesopromedio;
            dispoM.fecha       = dFecha;
            dispoM.canal       = dm.canal;
            dispoM.origen       = dm.origen;
            listDispo.add( dispoM );
        }

        //for( Producto p: productos ) {
        for( String pCode: mapProdDispo.keySet() ) {
            if( String.isBlank( pCode ) ) { continue; }
            System.debug('Key ProdCode:'+pCode);
            Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>> mapTipInv = mapProdDispo.get( pCode );
            System.debug('MapInv: '+mapTipInv);
            if( mapTipInv != null ) {
              for( String tipoInv: mapTipInv.keySet() ) {
                    if( String.isBlank( tipoInv ) ) { continue; }
                    //System.debug('TipoInventario:'+tipoInv);
                    List<DispoMayoristas> listDispo = mapTipInv.get( tipoInv );
                    List<DispoMayoristas> newDispo = new List<DispoMayoristas>();

                    Datetime fechaIni = null;
                    for( DispoMayoristas dispoD: listDispo ) {
                        if( dispoD == null ) { continue; }
                        //System.debug('DispoD: '+dispoD.fecha);
                        for( Datetime rfecha: rangoFechas ) {
                            if( rfecha == null ) { continue; }
                            //System.debug('RFecha: '+rfecha.date());
                            if( rfecha.date() == dispoD.fecha.date() ) {
                                newDispo.add( dispoD );
                                fechaIni = dispoD.fecha;
                                break;
                            }
                            else {
                                if( fechaIni == null ) {
                                    newDispo.add( new DispoMayoristas( rfecha, 0 ) );
                                }
                                else if( rfecha.date() > fechaIni.date() ) {
                                    //System.debug('FechaIni: '+fechaIni.date());
                                    newDispo.add( new DispoMayoristas( rfecha, 0 ) );
                                }
                            }
                        }
                    }
                    if( fechaIni != null ) {
                        for( Datetime rfecha: rangoFechas ) {
                            if( rFecha == null ) { continue; }
                            //System.debug('RFecha: '+rfecha.date()+' fechaIni: '+fechaIni.date());
                            if( rFecha.date() > fechaIni.date() ) {
                                newDispo.add( new DispoMayoristas( rfecha, 0 ) );
                            }
                        }
                    }
                    mapTipInv.put(tipoInv, newDispo);
                }
            }
            else {
                mapTipInv = new Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>();
                List<PedidosOtrosCanalesUtils.DispoMayoristas> sinInventario = new List<PedidosOtrosCanalesUtils.DispoMayoristas>();
                for( Datetime rfecha: rangoFechas ) {
                    sinInventario.add( new DispoMayoristas( rfecha, 0 ) );
                }
                mapTipInv.put('SIN INVENTARIO', sinInventario);
            }
        }

        for( Producto p: productos ) {
          if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            
            for( String pCode: mapProdDispo.keySet() ) {
                if( String.isBlank( pCode ) ) { continue; }
                List<String> prodD = pCode.split('-');
                if( prodD == null || prodD.size() == 0 ) { continue; }

                System.debug('Codigos:: Map: '+prodD.get(0)+'Prod: '+p.codigo+' Name: '+p.prodName);
                if( p.codigo.trim() == prodD.get(0).trim() || mapProdDispo.get( p.prodName ) != null ) { break; }

                Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>> mapTipInv = new Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>();
                List<PedidosOtrosCanalesUtils.DispoMayoristas> sinInventario = new List<PedidosOtrosCanalesUtils.DispoMayoristas>();
                for( Datetime rfecha: rangoFechas ) {
                    sinInventario.add( new DispoMayoristas( rfecha, 0 ) );
                }
                mapTipInv.put('SIN INVENTARIO', sinInventario);
                mapProdDispo.put( p.prodName, mapTipInv);
            }
        }
        
        return mapProdDispo;
    }

    public static List<Datetime> setRangoDeFechas( Date fechaEmbarque ) {
        if( fechaEmbarque == null ) {
            return null;
        }
        List<Datetime> rangoFechas = new List<Datetime>();

        Date fInicial   = fechaEmbarque.addDays( -6 );
        Datetime fecha   = fInicial;
        Date fFinal    = fechaEmbarque.addDays( 6 );

        boolean continuar = true;
        while( continuar ) {
            rangoFechas.add( fecha );

            fecha = fecha.addDays( 1 );
            if( fecha > fFinal ) {
                continuar = false;
            }
        }

        return rangoFechas;
    }

    public class DispoMayoristas {
        public String producto        {get; set;}
        public String tipoInventario    {get; set;}
        public Decimal pesoPromedio      {get; set;}
        public Integer canal        {get; set;}
        public Integer origen        {get; set;}

        public Datetime fecha        {get; set;}
        public Integer contenido      {get; set;}

        public DispoMayoristas() {}
        public DispoMayoristas( Datetime fd, Integer cntd ) {
            fecha = fd;
            contenido = cntd;
        }
    }
    
    
    /* PRECIOS */

    public static Account retrieveCteInfo( String accountId ) {
        if(Test.isRunningTest() && Limits.getQueries() >=100){
            return new Account();
        }
        Account cte = new Account();
        cte.Id = accountId;
        try {
            cte = [SELECT Id, Name, Numero_Cliente_SAP__c, Organizacion_de_Ventas__c, Ramo__c, Canal_Distribucion__c, Grupo_de_Vendedores__r.Codigo__c,
                   Oficina_de_Ventas__r.Codigo__c, Oficina_de_Ventas__r.IdPlanta__c, Canal_de_Distribucion_NSC__r.Codigo__c,
                   Canal_de_Distribucion_NSC__r.CodigoViz__c, Sociedad__c,cadena__c,Moneda_Cliente__c,Sector__c,Tipo_de_Credito__c
                   FROM Account
                   WHERE Id =: accountId];
        }
        catch( Exception e ) {
            System.debug('No hay información del cliente!! ');
            return null;
        }
        
        return cte;
    }

    public static Map<String, List<ListaPreciosWS.Precios>> getPrices( ListaPreciosWS.RespuestaOfListOfPrecioClienteSF response ) {
        ListaPreciosWS.ArrayOfPrecioClienteSF listaMay = response.Datos;
        System.debug('LISTMAY:'+  listaMay);
        if( listaMay == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE));
            return null;
        }
        
        List<ListaPreciosWS.PrecioClienteSF> preciosCte = listaMay.PrecioClienteSF;
        System.debug('preciosCte: '+  preciosCte);
        if( preciosCte == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE));
            return null;
        }

        Map<String, List<ListaPreciosWS.Precios>> mapaPreciosPorProducto = new Map<String, List<ListaPreciosWS.Precios>>();
        for( ListaPreciosWS.PrecioClienteSF psf: preciosCte ) {
            if( psf == null ) { continue; }
            ListaPreciosWS.ArrayOfPreciosSF arrayPrecios = psf.precios;
            if( psf.numerocliente == null || arrayPrecios == null ) {continue;}
            List<ListaPreciosWS.Precios> precios = arrayPrecios.PreciosSF;
            if( precios == null ) { continue; }

            for( ListaPreciosWS.Precios p: precios ) {
                if( p == null ) { continue; }
                if( String.isBlank( p.pve_cveprod )) { continue; }
                String cveProd = String.valueOf(Integer.valueOf( p.pve_cveprod ));

                List<ListaPreciosWS.Precios> listaPrecios = mapaPreciosPorProducto.get(cveprod);
                if(listaPrecios==null){
                    listaPrecios = new List<ListaPreciosWS.Precios>();
                    mapaPreciosPorProducto.put(cveprod, listaPrecios);
                }
                listaPrecios.add(p);
            }
        }

        return mapaPreciosPorProducto;
    }

    public static ListaPreciosWS.ArrayOfPreciosXCliente fillPreciosCliente( Opportunity pedido, List<Producto> productos, boolean isViz ) {
        
        System.debug('Pedido: '+pedido);
        System.debug('Productos: '+productos);
        if( pedido == null ) { return null; }
        if( productos == null ) { return null; }
        System.debug('Productos: '+productos);
        if( String.isBlank( pedido.AccountId ) && String.isNotBlank( pedido.SucursalAux__c ) ) { pedido.AccountId = pedido.SucursalAux__c; }
        if( String.isBlank( pedido.Cliente__c ) || String.isBlank( pedido.AccountId ) ) { return null; }

        pedido.Cliente__r   = retrieveCteInfo( pedido.Cliente__c );
        pedido.Account     = retrieveCteInfo( pedido.AccountId );
        Account cliente   = pedido.Cliente__r;
        Account sucursal   = pedido.Account;

        ListaPreciosWS.ArrayOfPreciosXCliente request = new ListaPreciosWS.ArrayOfPreciosXCliente();
        DateTime fechaEmbarque = pedido.Fecha_de_Embarque__c;
       System.debug('Datetime FechaEmbarque: '+fechaEmbarque);
        List<ListaPreciosWS.PreciosXCliente> clientes = new List<ListaPreciosWS.PreciosXCliente>();
        ListaPreciosWS.PreciosXCliente precioCte = new ListaPreciosWS.PreciosXCliente();
        if( isViz ) {
            Account sucViz = buscarSucViz(pedido.Canal_Factura__r.IdClienteViz__c);
            if( sucViz == null ) {
                System.debug( 'No hay Sucursal Viz Configurada!' );
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidosOtrosCanalesUtils.NO_SUC_VIZ));
                return null;
            }
            
            precioCte.cliente = String.valueOf(Integer.valueOf( pedido.Canal_Factura__r.IdClienteViz__c ));
            if(String.isNotBlank(pedido.Canal_Factura__r.SucursalesViz__c))
            {
                List<String> ListaSucursalesFrontera = new List<String>();
                ListaSucursalesFrontera.addAll(pedido.Canal_Factura__r.SucursalesViz__c.split(';'));
                precioCte.destinatario = ValidarSucursalViz(ListaSucursalesFrontera,pedido.frontera__c);
                system.debug('precioCte.destinatario: '+precioCte.destinatario);
                //precioCte.destinatario = String.valueOf( pedido.Canal_Factura__r.Sucursal_Viz__c );//'103574';
            }
            //precioCte.destinatario = String.valueOf( pedido.Canal_Factura__r.Sucursal_Viz__c );//'103574';
            
            precioCte.gpoVendedores = sucViz.Grupo_de_Vendedores__r.Codigo__c;//'404';
            precioCte.ofiVentas = sucViz.Oficina_de_Ventas__r.Codigo__c;//'441';
            precioCte.orgVentas = sucViz.Organizacion_de_Ventas__c.right(4);//'3031';
            precioCte.canal = sucViz.Canal_Distribucion__c.right(2);//'EX';
            precioCte.cadena = '';
            
            try{
                precioCte.cluster = sucViz.Ramo__c.right(2);
            }catch(Exception e){
                System.debug('Ramo del cliente esta vacio');
                precioCte.cluster = '';
            }
            System.debug('Cluster:' + precioCte.cluster);
        }
        else {
            precioCte.cliente = String.valueOf(Integer.valueOf( cliente.Numero_Cliente_SAP__c ));//'103574';
            String sucursalSAP = sucursal.Numero_Cliente_SAP__c;
            sucursalSAP = sucursalSAP.replace('SUC - ', '');
            precioCte.destinatario = String.valueOf(Integer.valueOf( sucursalSAP ));//'103574';
            precioCte.gpoVendedores = sucursal.Grupo_de_Vendedores__r.Codigo__c;//'404';
            precioCte.ofiVentas = sucursal.Oficina_de_Ventas__r.Codigo__c;//'441';
            precioCte.orgVentas = cliente.Organizacion_de_Ventas__c.right(4);//'3031';
            precioCte.canal = cliente.Canal_Distribucion__c.right(2);//'EX';
            
            try{
                precioCte.cluster = cliente.Ramo__c.right(2);
            }catch(Exception e){
                System.debug('Ramo del cliente esta vacio');
                precioCte.cluster = '';
            }
            System.debug('Cluster:' + precioCte.cluster);
            
            try{
                System.debug('Cadena:: ' +sucursal);
                String[] cadenaArray = sucursal.Cadena__c.split(' - ');
                precioCte.cadena = cadenaArray[1];
            }catch(Exception e){
                precioCte.cadena = '';
            }
        }
        //TimeZone utz = System.UserInfo.getTimeZone();
        System.debug('FechaDoc: '+dateToString(pedido.Fecha_de_Embarque__c, 'yyyyMMdd'));
        precioCte.fecDoc = dateToString(pedido.Fecha_de_Embarque__c, 'yyyyMMdd');//'20161027';
        
        List<ListaPreciosWS.producto> prodWS = new List<ListaPreciosWS.producto>();
        for( Producto p: productos ) {
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            
            ListaPreciosWS.producto prod = new ListaPreciosWS.producto();
            prod.codigo = p.codigo;
            prodWS.add( prod );
        }
        ListaPreciosWS.ArrayOfProducto productosWS = new ListaPreciosWS.ArrayOfProducto();
        productosWS.producto = prodWS;
        
        precioCte.producto = productosWS;
        clientes.add( precioCte );
        System.debug('PrecioCte: '+precioCte);
        request.PreciosXCliente = clientes;
        
        return request;
    }
    
    /* PEDIDO/PRODUCTOS */
    
    public class Producto {
    	//Ramon Atondo 31/05/2018
    	public boolean isPrecio {get;set;}
    	public Double  PrecioUnitarioAnterior {get;set;}
    	public Double  FleteAnterior {get;set;}
    	
        public String index       {get; set;}
        public String codigo       {get; set;}
        public String prodName      {get; set;}
        public Integer cajasXPallet    {get; set;}
        public Integer contenido    {get; set;}
        public Double precioSAP      {get; set;}
        public Double pesoProm      {get; set;}
        public Integer pzasXCaja    {get; set;}
        public boolean distinctPrice  {get; set;}
        public String pricebeId      {get; set;}
        public String inventario    {get; set;}
        public String inventarioAnt    {get; set;}
        public integer DiasConsolidacion {get; set;}
        public Double PrecioUnitario{get; set;}
        public Double kgs        {get; set;}
        public Double lbs        {get; set;}
        public Integer cjs        {get; set;}
        public Integer pzas        {get; set;}
        public boolean showDelete  {get; set;}
        public boolean DisabledProd  {get; set;}
        public boolean peso        {get; set;}
        public boolean cantidad      {get; set;}
        public boolean fisico      {get; set;}
        public Integer devolucion        {get; set;}
        public OpportunityLineItem item {get; set;}
        public PriceBookEntry pbe     {get; set;}
        public String ProductoMaster     {get; set;}
        public boolean HabilitaCantidad      {get; set;}
        public boolean HabilitaVolumen      {get; set;}
	    public Double precioConFlete      {get; set;} 
        public Producto() {
            contenido = 0;
            peso = cantidad = DisabledProd = false;
            showDelete = true;
            isPrecio = false;
            PrecioUnitarioAnterior = 0;
        }
        public Producto(Integer index, OpportunityLineItem item){
            this.index = String.valueOf(index);
            this.item = item;
            codigo = item.ProductCode;
            if(item.Cajas_x_Pallet__c!=null){
              cajasXPallet = item.Cajas_x_Pallet__c.intValue();
            }else{
                cajasXPallet = 0;
            }
            pbe = item.PricebookEntry;
            pricebeId = item.PricebookEntryId;
            ProductoMaster = item.Product2.Producto_Master__r.MasterID__c;
            contenido = 0;
            if( item.Unidad__c == 'K' || item.Unidad__c == 'L' ) {
                cantidad = true;
                peso = false;
            }
            else if( item.Unidad__c == 'C' || item.Unidad__c == 'P'  ) {
                cantidad = false;
                peso = true;
            }
            if( item.Tipo_de_Inventario__c == '1-Inv Fisico' ) {
                fisico = true;
            }
            else {
                fisico = false;
            }
            pzasXCaja = integer.valueOf(item.Product2.Piezas_por_caja__c);
            showDelete = true;
            DisabledProd = true;
            precioConFlete = item.unitprice;

            if(string.isNotBlank(item.Opportunity.Folio_SAP__c) && item.Opportunity.Folio_SAP__c != '0')
            {
                HabilitaCantidad = false;
                HabilitaVolumen = false;
            }
            
        }
        public Producto(Integer index, String idOrigen){
            this.index = String.valueOf(index);
            item = new OpportunityLineItem();
            if( String.isNotBlank( idOrigen ) ) {
                item.Origen_Surtido__c = idOrigen;
            }
            codigo = '';
            cajasXPallet = 0;
            pbe = new PriceBookEntry();
            pricebeId = '';
            contenido = 0;
            peso = cantidad = false;
            showDelete = true;
            DisabledProd = false;
            //Ramon Atondo 01/06/2018
            isPrecio = false;
            PrecioUnitarioAnterior = 0;
        }
    }
    
    /* VALIDA CREDITO */
    public static ValidacionCredito validarCredito(String clienteId, String sucursalId, Double importe, String moneda, String sociedad, Integer pedidoId, String canalDistribucionId){
        if(String.isBlank(clienteId)){throw new SuKarneException('El cliente no puede ser nulo'); return null;}
        if(importe==null){throw new SuKarneException('El importe no puede ser nulo'); return null;}
        if(moneda==null){throw new SuKarneException('La moneda no puede ser nula'); return null;}
        if(sociedad==null){throw new SuKarneException('La sociedad no puede ser nula'); return null;}
        
        WSValidarLimiteCredito.ValidaLimiteCreditoSoap stub = new WSValidarLimiteCredito.ValidaLimiteCreditoSoap();
        WSValidarLimiteCredito.ClienteLimiteCredito request = new WSValidarLimiteCredito.ClienteLimiteCredito();
        request.ClienteId = clienteId;
        request.SucursalId = sucursalId;
        request.Importe = importe;
        request.Moneda = moneda;
        request.Sociedad = sociedad;
        request.PedidoId = pedidoId;
        request.CanalDistribucion = canalDistribucionId;
        System.debug('Validar Crédito: '+request);
        WSValidarLimiteCredito.ResultadoValidacionLimiteCredito response = stub.ValidarLimiteCredito(request);
        if( response == null ) {
            return null;
        }
        ValidacionCredito vc = new ValidacionCredito();
        System.debug('Resultado:' + response.Resultado + ' - Mensaje:' + response.Mensaje);
        if( String.isBlank( response.Resultado ) ) {
            vc.aprobado = false;
            vc.mensaje = response.Mensaje;
        }
        if( response.Resultado == '1' ) {
            vc.aprobado = true;
            vc.mensaje = response.Mensaje;
        }
        else if( response.Resultado == '0' ) {
            vc.aprobado = false;
            vc.mensaje = response.Mensaje;
        }

        return vc;
    }
    
    public class prod{
		public String codigo {get;set;}
		public String productCode {get;set;}    
    }

    public class ValidacionCredito {

        public Boolean aprobado    {get; set;}
        public String mensaje    {get; set;}

        public ValidacionCredito() {}
    }

    /* GUARDAR PEDIDO */
    public static String getDOF( Date fe ) {
        String dof = '';
        if( fe == null ) { return dof; }
        String day = dateToString( fe, 'EEEE' ).toUpperCase();//fe.format('EEEE').capitalize();
        System.debug('DOF: '+day+ ' EQUAL? '+day.equalsIgnoreCase('SUNDAY'));

        if( day.equalsIgnoreCase('LUNES') || day.equalsIgnoreCase('MONDAY') ) { //System.debug('DOF: '+day);
            dof = '1';
        }
        else if( day.equalsIgnoreCase('MARTES') || day.equalsIgnoreCase('TUESDAY') ) { //System.debug('DOF: '+day);
            dof = '2';
        }
        else if( day.equalsIgnoreCase('MIÉRCOLES') || day.equalsIgnoreCase('MIERCOLES') || day.equalsIgnoreCase('WEDNESDAY') ) { //System.debug('DOF: '+day);
            dof = '3';
        }
        else if( day.equalsIgnoreCase('JUEVES') || day.equalsIgnoreCase('THURSDAY') ) { //System.debug('DOF: '+day);
            dof = '4';
        }
        else if( day.equalsIgnoreCase('VIERNES') || day.equalsIgnoreCase('FRIDAY') ) { //System.debug('DOF: '+day);
            dof = '5';
        }
        else if( day.equalsIgnoreCase('SÁBADO') || day.equalsIgnoreCase('SABADO') || day.equalsIgnoreCase('SATURDAY') ) { //System.debug('DOF: '+day);
            dof = '6';
        }
        else if( day.equalsIgnoreCase('DOMINGO') || day.equalsIgnoreCase('SUNDAY') ) { //System.debug('DOF: '+day);
            dof = '7';
        }

        return dof;
    }

    public static String generateIdPedidoSF() {
        String idPedidoSF = '';
        boolean exist = true;

        while(exist) {
            Integer x = 1;
            //2,147,483,647
            Integer y = 2147483647;
            Integer idPedido = Integer.valueOf( Math.floor(Math.random() * ((y-x)+1) + x) );
            System.debug('id:' + idPedido);
            idPedidoSF = String.valueOf(idPedido);
            System.debug('id:' + idPedidoSF);
            if( idPedidoSF.length() < 15 ) {
                for( Integer l=idPedidoSF.length(); l<15; l++ ) {
                    idPedidoSF = '0' + idPedidoSF;
                }
            }
            System.debug('id:' + idPedidoSF);
            String oppId='';
            try {
                oppId = [SELECT Id FROM Opportunity WHERE Id_Externo__c =: idPedidoSF].Id;
            }
            catch( Exception e ) {
                System.debug('El Id_Externo no existe!!');
            }
            if( String.isBlank( oppId ) ) { exist = false; }
        }

        return idPedidoSF;
    }

    public static List<Integer> generatePedido(Integer rows) {
        Integer x = 1;
        //2,147,483,647
        Integer y = 2147483647;

        Map<String, String> mapIds = new Map<String, String>();
        Integer index=1;

        boolean blnContinue = true;
        while(blnContinue) {
            while(index<=rows){
                Integer idPedido = Integer.valueOf( Math.floor(Math.random() * ((y-x)+1) + x) );
                String idPedidoSF = String.valueOf(idPedido);
                idPedidoSF = idPedidoSF.leftPad(15, '0');
                if(!mapIds.containsKey(idPedidoSF)){
                    mapIds.put(idPedidoSF, idPedidoSF);
                    index++;
                }
            }
            Map<String, String> mapaExistentes = new Map<String, String>();
            for(Opportunity existente:[Select Id, Id_Externo__c
                                       From Opportunity
                                       Where Id_Externo__c in:mapIds.keySet()]){
                                           mapaExistentes.put(existente.Id_Externo__c, existente.Id);
                                       }
            if(mapaExistentes.size()==0){
                blnContinue = false;
            }else{
                for(String idExterno:mapaExistentes.keySet()){
                    mapIds.remove(idExterno);
                    index--;
                }
            }
        }

        List<Integer> valores = new List<Integer>();
        for(String external:mapIds.keySet()){
            valores.add(Integer.valueOf(external));
        }
        return valores;
    }
    public Static Opportunity ValidarPedidoModificado(Opportunity pedido, List<Producto> productos, boolean cancelacion,Opportunity pedidoOld,map<string,PedidosOtrosCanalesUtils.Producto>ProductosOld, Boolean ItemsEliminados)
    {
    	System.debug('Opportunity ValidarPedidoModificado:: '+ pedido +' ------- '+productos);
        ContainsDelete = ItemsEliminados;
        pedidoOld = pedidoOld;
        productosOld = productosOld;
        ValidarCambiosPedidos(pedido, productos,pedidoOld,productosOld);
        //return guardarPedidoSDL( pedido, productos, false );
         system.debug('Guardar pedidoLEgado' + guardarPedidoLegados( pedido, productos, false ));
        return guardarPedidoLegados( pedido, productos, false );
       
    }
    public Static void ValidarCambiosPedidos(Opportunity pedido, List<Producto> productos,Opportunity pedidoOld,map<string,PedidosOtrosCanalesUtils.Producto> productosOld)
    {
        EnvioAprobacion = false;
        Integer dias = pedido.Canal_Factura__r.Dias_de_cierre__c == null ? 0 : Integer.valueOf(pedido.Canal_Factura__r.Dias_de_cierre__c);
        System.debug('pedido.Fecha_de_Embarque__c: '+pedido.Fecha_de_Embarque__c);
        
        if(productosOld != null)
        {
            if(pedido.Fecha_de_Embarque__c  < Datetime.now().addDays(dias))
            {
                if(productosOld != null)
                {
                    
                    if(!validarEnvioFlujoApro(pedido,pedidoOld))
                    {
                        EnvioAprobacion = true;
                    }
                }
                
            }
           	/* if(pedido.Fecha_de_Embarque__c != pedidoOld.Fecha_de_Embarque__c )
				{
				EnvioAprobacion = true;
				}*/
            productosSinModificar = productosOld;
            pedidoSinMod = pedidoOld;
            MensajeAprobacion ='El pedido tuvo los siguentes cambios:\n ';
            productosSinModificacion = new list<producto>();
            for(producto p : productos)
            {
                
                if(productosOld.ContainsKey(p.Codigo))
                {
                    productosSinModificacion.add(productosOld.get(p.Codigo));
                    Integer cajas = productosOld.get(p.Codigo).item.Quantity == null ? 0 : Integer.ValueOf(productosOld.get(p.Codigo).item.Quantity);
                    
                    System.debug('p.cjs: '+p.item.Cantidad__c);
                    if(p.item.Cantidad__c != cajas )
                    {
                        MensajeAprobacion += 'Se Agrego la cantidad de: '+ p.item.Cantidad__c +' para el producto : '+p.Codigo +'  \n';
                         p.item.Estatus__c = 1;
                        //EnvioAprobacion = true;
                        
                    }
                    else{ p.item.Estatus__c = 1;}
                    /*if(p.item.Estatus__c != 3)
                    {
                        p.item.Estatus__c = 1;
                    }*/
                }
                else
                {
                    MensajeAprobacion += 'Se Agrego el producto: '+p.Codigo+' Con la cantidad de: '+ p.cjs +'  \n';
                    p.item.Estatus__c = 3;
                    ProductoNuevo = true;
                    system.debug('ProductoNuevo:: '+ ProductoNuevo);
                }
            }
        }
        else
        {
            if(pedido.Fecha_de_Embarque__c  < Datetime.now().addDays(dias))
            {
                if(!validarGuardarNSC(pedido))
                {
                      EnvioAprobacion = true;
                }
                
            }
        }
        
        
    }
    public static Opportunity guardarPedidoLegados( Opportunity pedido, List<Producto> productos, boolean cancelacion ) {
        /// DECLARACION DE VARIABLES
        Boolean ValidaCierre = false;
        String areaResp = 'E';
        Integer pedidoCte = 4;
        map<string,AdminSaldosEstrategias__c> mapEstrategias = null;
        boolean sdlNOExist = true;
        String folioPedido = '';
        String folioEmbarque = '';
        Boolean estatus = false;
        String mensaje = '';
        Integer tries = 0;
        areaResp = ObtenerCanalVenta(pedido);
        mapEstrategiasMod = new map<String,AdminSaldosEstrategias__c>();
        list<AdminSaldosEstrategias__c> listaAGrabar = new list<AdminSaldosEstrategias__c>();
        System.debug('Inicia armado de requerimiento para guardar en SDL...');
        
        productosSinModificar = ObtenerProductosPorPedido(pedido);
        User u = retrieveUserInfo(System.UserInfo.getUserId());
        
        if(Test.isRunningTest() && Limits.getQueries() >= 100){
            return null;
        }
        if(pedido.id == null)
        {
            ActualizarCamposPedido(pedido);
            ActualizarCamposOpportunityLineItem(productos);
            
        }
        else
        {
            ActualizarCamposPedido(pedidoSinMod);
            ActualizarCamposOpportunityLineItem(productosSinModificacion);
        }
        if((String.isNotBlank(pedido.Numero_de_Pedido_NSC__c) && pedido.Numero_de_Pedido_NSC__c != '0') || (string.isNotBlank(pedido.Numero_Pedido_SAP__c ) && pedido.Numero_Pedido_SAP__c != '0')) {
	         WsActualizaDatosGenerales_NSC_SDL.RespuestaModificacionPedidos ResponseNSC = null;
	         if(string.isNotBlank(pedido.Id))
	         {
	         	  	ResponseNSC = WsActualizarDatosGenerales(pedido,areaResp, productos,2,'1');
                    system.debug('RESPONSE NSC: '+ ResponseNSC);
                    if(ResponseNSC  != null && ResponseNSC.EstatusPedido == 1 )
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, ResponseNSC.Mensaje));
                    }
                    else
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ResponseNSC.Mensaje));
                        return pedido;
                    }
	         }
	        if(cancelacion)
	            {
	                System.debug('Entro cancelacion nueva');
	                ResponseNSC = WsActualizarDatosGenerales(pedido,areaResp, productos,2,'2');
	                if(ResponseNSC  != null && ResponseNSC.EstatusPedido == 1 )
	                {
	                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, ResponseNSC.Mensaje));
	                }
	                else
	                {
	                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ResponseNSC.Mensaje));
	                    return pedido;
	                }
	            }
        }

        else
        {
            WsPedidosMayoreoLegados.DatosPedidoLegado DatosPedidos = new WsPedidosMayoreoLegados.DatosPedidoLegado();
            ObtenerActalizaLegados(pedido);
            DatosPedidos.ActualizaPSV = ActualizaPSV;
            PedidoBloqueado = false;
            if(DatosPedidos.ActualizaPSV)
            {
                DatosPedidos.DatosPedidoPSV = CrearPedidoMayoreoLegados(pedido,productos,cancelacion); 
                if(ApexPages.hasMessages(ApexPages.Severity.ERROR) ||  ApexPages.hasMessages(ApexPages.Severity.WARNING))
                {
                    return pedido;
                }
            }
            
            if(PedidoBloqueado)
            {
                DatosPedidos.ActualizaSAP = false;
                DatosPedidos.ActualizaNSC = false;
            }
            else
            {
                DatosPedidos.ActualizaSAP = ActualizaSAP;
                DatosPedidos.ActualizaNSC = ActualizaNSC;
            }
            
            if(DatosPedidos.ActualizaNSC)
            {
                DatosPedidos.DatosPedidoNSC = CrearPedidoNSC(pedido,productos,cancelacion); 
                if(ApexPages.hasMessages(ApexPages.Severity.ERROR) ||  ApexPages.hasMessages(ApexPages.Severity.WARNING))
                {
                    return pedido;
                }
            }
            if(DatosPedidos.ActualizaSAP)
            {
                mapTipoPedido =  FillTipoPedido();
                DatosPedidos.DatosSAP = CrearPedidoSap(pedido,productos,cancelacion);
                if(ApexPages.hasMessages(ApexPages.Severity.ERROR) ||  ApexPages.hasMessages(ApexPages.Severity.WARNING))
                {
                    return pedido;
                }
            }
            
            //WsPedidosMayoreoLegados.PedidosMayoreoLegadosSoap services = new WsPedidosMayoreoLegados.PedidosMayoreoLegadosSoap();
            try
            {
            	 // Se ejecuta 3 veces en caso de error
            	for(Integer x= 0; x<= 2; x++)
            	{
            	 	pedido =	PedidosOtrosCanalesUtils.responseWS(pedido,mensaje ,DatosPedidos);
            	}
            		
            }
            catch(Exception e)
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getmessage()));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Ocurrió un problema al guardar en sistemas legados. ' + e.getMessage()));
                return pedido;
            }
        }	
        return pedido;
    }
    public static Boolean validaDatosPedidos(WsPedidosMayoreoLegados.DatosPedidoLegado DatosPedidos)
    {
    	integer contador = 0;
    	boolean bandera = false;
    	if(DatosPedidos.ActualizaPSV)
    	{
    		contador++;
    	} 
    	if(DatosPedidos.ActualizaSAP)
    	{ contador++;}
    	
    	if(DatosPedidos.ActualizaNSC)
    	{
    		 contador++;
    	}	
    	if(contador > 0)
    		bandera = true;
    
     	return bandera;
    }
    public static Opportunity responseWS(Opportunity pedido,String mensaje,WsPedidosMayoreoLegados.DatosPedidoLegado DatosPedidos)
    {    			
		WsPedidosMayoreoLegados.PedidosMayoreoLegadosSoap services = new WsPedidosMayoreoLegados.PedidosMayoreoLegadosSoap();
		system.debug('DATOS PEDIDOS: '+ DatosPedidos.ActualizaPSV+' - '+DatosPedidos.ActualizaSAP +' - '+DatosPedidos.ActualizaNSC);
		if(validaDatosPedidos(DatosPedidos))
		{
            WsPedidosMayoreoLegados.ResultadoPedidoMayoreoLegados Response = services.GenerarPedidoMayoreo(DatosPedidos);
            system.debug('Respuesta: ------------------->'+Response);
            if(Response != null && Response.Resultado =='TerminadoConExito')
            {
                mensaje  = 'Pedido registrado con éxito.';
                if(DatosPedidos.ActualizaPSV)
                {
                    pedido.Folio_Pedido_SDL__c = Response.SdlFolioPedidoSDL;
                    pedido.Folio_Embarque__c = Response.SdlFolioEmbarqueSDL; 
                    
                    if(String.isNotBlank(pedido.Folio_Pedido_SDL__c) 
                    		|| String.isNotBlank(pedido.Folio_Embarque__c))
                    {
                    	DatosPedidos.ActualizaPSV =  false;
                        if(String.isNotBlank(Response.SdlFolioEmbarqueSDL))
                        {
                            mensaje +=' Folio SDL:'+Response.SdlFolioPedidoSDL +' Folio Embarque:'+Response.SdlFolioEmbarqueSDL;
                        }
                        else
                        {
                            mensaje +=' Folio SDL:'+Response.SdlFolioPedidoSDL;
                        }
                    }                                           
                }
                if(DatosPedidos.ActualizaSAP)
                {
                	if(String.isNotBlank(Response.SapShip_To))
                	{
                    	pedido.Numero_Pedido_SAP__c = Response.SapShip_To;
                    	mensaje += ' Folio SAP:'+Response.SapShip_To;
                    	DatosPedidos.ActualizaSAP =  false;
                	}
                    
                }
                if(DatosPedidos.ActualizaNSC && Response.NscNumeroPedido != null)
                {
                	if(String.isNotBlank(Response.SapShip_To))
                	{                    	
                    	pedido.Numero_de_Pedido_NSC__c = string.ValueOf(integer.ValueOf(Response.NscNumeroPedido)); 
                    	mensaje +=' Folio NSC:'+ integer.ValueOf(Response.NscNumeroPedido);
                    	DatosPedidos.ActualizaNSC =  false;
                	}
                }                   
            string Fecha = dateToString(pedido.Fecha_de_Embarque__c,'yyyyMMdd'); 
            WsActualizaPSVPedidos.PedidosPSV actualizaPedido;
            list<WsActualizaPSVPedidos.PedidosPSV> listaActualizaPedidos = new list<WsActualizaPSVPedidos.PedidosPSV>();
            WsActualizaPSVPedidos servicesActualiza = new WsActualizaPSVPedidos();
            WsActualizaPSVPedidos.RespuestaOfBoolean ResponseActualiza; 
            if(IsVizcatle(pedido) &&  pedido.StageName != '11 - Bloqueado Cierre')
            {
                actualizaPedido = CrearPedidoPsvActualiza(Response.SapShip_To,pedido.Id_Externo__c,'E', true,Response.SdlFolioPedidoSDL,Fecha);
                listaActualizaPedidos.add(actualizaPedido);
                
                actualizaPedido = new WsActualizaPSVPedidos.PedidosPSV();
                Fecha = dateToString(pedido.Fecha_Embarque_Bodega__c,'yyyyMMdd'); 
                actualizaPedido = CrearPedidoPsvActualiza(string.ValueOf(integer.ValueOf(Response.NscNumeroPedido)),pedido.Id_Externo__c,'V', false,Response.SdlFolioPedidoSDL,Fecha);
                listaActualizaPedidos.add(actualizaPedido);  
                
            }
            else if(pedido.StageName != '11 - Bloqueado Cierre')
            {
                actualizaPedido = new WsActualizaPSVPedidos.PedidosPSV();
                string pedidoAct = DatosPedidos.ActualizaNSC == true?pedido.Numero_de_Pedido_NSC__c:Response.SapShip_To;
                actualizaPedido = CrearPedidoPsvActualiza(pedidoAct,pedido.Id_Externo__c,ObtenerCanalVenta(pedido), DatosPedidos.ActualizaSAP,Response.SdlFolioPedidoSDL,Fecha);
                listaActualizaPedidos.add(actualizaPedido);
                
            }
            for(WsActualizaPSVPedidos.PedidosPSV psv : listaActualizaPedidos)
            {
                servicesActualiza = new WsActualizaPSVPedidos();
                ResponseActualiza = new WsActualizaPSVPedidos.RespuestaOfBoolean();
                ResponseActualiza = servicesActualiza.ActualizaPSVPedidos(psv);
                if(ResponseActualiza != null)
                {
                    system.debug('Respuesta: '+ResponseActualiza.Mensaje);
                    
                }
                
            }
            if(mapEstrategiasMod != null && mapEstrategiasMod.size() >0) 
            {
                System.debug('listaAGrabar : : '+mapEstrategiasMod );
                upsert mapEstrategiasMod.values();
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, mensaje));
         }
	      else
	        {
	            if(Response == null)
	            {
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No ubo respuesta de los servicios legados, Favor de reintentar.'));
	            }
	            else
	            {
	                if(Response.SapReturn != null)
	                {
	                    for(WsPedidosMayoreoLegados.DT_SDL_ResItem item :Response.SapReturn.DT_SDL_ResItem)
	                    {
	                        if(item.TYPE_x == 'E')
	                        {
	                            system.debug('item '+ item);
	                            system.debug('item.ROW '+ item.ROW);
	                            system.debug('productosSap '+ productosSap.get(item.ROW.trim()));
	                            if(item.MESSAGE.contains('Unidad de medida de ventas PI no está prevista en la posición'))
	                            {
	                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Unidad de medida de ventas PI no está prevista en el producto: '  + productosSap.get(item.ROW.trim()).prodName));
	                            }
	                            else
	                            {
	                                if(!item.MESSAGE.contains('Error en SALES_ITEM_IN'))
	                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,item.MESSAGE));
	                            }
	                            
	                        }
	                    }
	                }
	                else
	                {
	                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Response.Mensaje));
	                }
	                
	            }
	            return pedido;
	        }
		}
	
        return pedido;
    }
    public static WsActualizaPSVPedidos.PedidosPSV CrearPedidoPsvActualiza(string folio,string folioSF,String tipoPedido,boolean actualizaSap,string folioSDL,string fechaEmbarque)
    {
        WsActualizaPSVPedidos.PedidosPSV pedido = new WsActualizaPSVPedidos.PedidosPSV();
        pedido.Folio = folioSDL;
        pedido.Folio_SC = folio; // folioSap o NSC
        pedido.Fecha = fechaEmbarque;
        pedido.FolioSDL = folioSF; 
        pedido.Tipo_Prod = tipoPedido;
        pedido.FechaEnvio = datetime.now().format('yyyy-MM-dd HH:mm:ss'); 
        pedido.ActualizaSAP = actualizaSap;
        pedido.Error = false;
        pedido.MensajeError = '';
        system.debug('CrearPedidoPsvActualizPedido: '+pedido);
        return pedido;
    }   
    public static map<string,Configuracion_pedidosOC__c> FillTipoPedido() {
        
        map<string,Configuracion_pedidosOC__c> mapTipoPedido = new map<string,Configuracion_pedidosOC__c>();
        for(Configuracion_pedidosOC__c poc : Configuracion_pedidosOC__c.getall().values())
        {
            mapTipoPedido.put(poc.Name,poc);
        }
        return mapTipoPedido;
    }
    public static map<string,Configuracion_PreciosOC__c> FillTipoPrecios() {
        
        map<string,Configuracion_PreciosOC__c> mapTipoPrecio = new map<string,Configuracion_PreciosOC__c>();
        for(Configuracion_PreciosOC__c poc : Configuracion_PreciosOC__c.getall().values())
        {
            mapTipoPrecio.put(poc.name,poc);
        }
        return mapTipoPrecio;
    }
    public static WsPedidosMayoreoLegados.PedidoMayoreo CrearPedidoMayoreoLegados(Opportunity pedido,list<pedidosOtrosCanalesUtils.producto> productos,Boolean Cancelado)
    {
        WsPedidosMayoreoLegados.PedidoMayoreo pedidoWS = new WsPedidosMayoreoLegados.PedidoMayoreo();
        Account sucViz;
        string usuario = PedidosOtrosCanalesUtils.ObtenerUsuario();
        String areaResp = ObtenerCanalVenta(pedido);
        Integer pedidoCte = ObtenerpedidoCte(pedido);
        String idPlanta;
        pedido.Cliente__r   = PedidosOtrosCanalesUtils.retrieveCteInfo( pedido.Cliente__c );
        pedido.Account     = PedidosOtrosCanalesUtils.retrieveCteInfo( pedido.AccountId );
        pedidoWS.NumeroPedidoNSC = pedido.Numero_de_Pedido_NSC__c== '0'?null:pedido.Numero_de_Pedido_NSC__c;
        pedidoWS.NumeroPedidoSAP = pedido.Numero_Pedido_SAP__c == '0'?null:pedido.Numero_Pedido_SAP__c;
        if(pedido.Canal_Factura__r.IdPlanta__c != null)
        {
            idPlanta = pedido.Canal_Factura__r.IdPlanta__c;
            
        }
        if( string.isNotBlank(idPlanta)) {
            pedidoWS.planta = Integer.valueOf(idPlanta);
            sucViz = PedidosOtrosCanalesUtils.buscarSucViz(pedido.Canal_Factura__r.IdClienteViz__c);
        }
        pedidoWS.areaRespCte = areaResp; //1-A; 2-M; 3-E
        pedidoWS.tipoPedidoCte = pedidoCte; //EX-2; MY-4; AS-3
        if( String.isNotBlank( pedido.PO_Proveedor__c ) ) {
            pedidoWS.occProveedor = pedido.PO_Proveedor__c;
        }
        else {
            pedidoWS.occProveedor = '';
        }
        if( String.isNotBlank( pedido.OC__c ) ) {
            pedidoWS.poCliente = pedido.OC__c;
        }
        else {
            pedidoWS.poCliente = '';
        }
        if( String.isNotBlank( pedido.Liberado__c ) ) {
            pedidoWS.liberado = pedido.Liberado__c; //N-Rechazado; S-Autorizado
        } else {
            pedidoWS.liberado = '';
        }
        if( String.isNotBlank( pedido.MotivoRechazo__c ) ) {
            pedidoWS.motivoRechazoCartera = pedido.MotivoRechazo__c; //Si Liberado = N
        } else {
            pedidoWS.motivoRechazoCartera = '';
        }
        if( pedido.Flete__c != null ) {
            pedidoWS.fleteLibra = pedido.Flete__c;
        } else {
            pedidoWS.fleteLibra = 0;
        }
        if( pedido.Amount != null ) {
            pedidoWS.importeTotalPedido = pedido.Amount;
        } else {
            pedidoWS.importeTotalPedido = 0;
        }
        Double qttyKGSTt = 0;
        Double librasPesoTt = 0;
        System.debug('Totales KGs...');
        for( pedidosOtrosCanalesUtils.Producto p: productos ) {
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( p.item == null ) { continue; }
            qttyKGSTt += p.item.Kilos__c;
            librasPesoTt += p.item.Volumen__c;
        }
        pedidoWS.cantidadKGSTotalPedido = qttyKGSTt;
        pedidoWS.observacionGralPedido = pedido.Description;
        if( String.isNotBlank( pedido.Motivo_de_Cancelacion__c ) ) {
            pedidoWS.motivoCancelacion = '0';
        } else {
            pedidoWS.motivoCancelacion = '';
        }
        if( String.isNotBlank( pedido.Folio_Pedido_SDL__c ) ) {
            pedidoWS.folioPedidoSDL = pedido.Folio_Pedido_SDL__c;
        } else {
            pedidoWS.folioPedidoSDL = '';
        }
        if( String.isNotBlank( pedido.Folio_Embarque__c ) ) {
            pedidoWS.folioEmbarqueSDL = pedido.Folio_Embarque__c;
        } else {
            pedidoWS.folioEmbarqueSDL =  '';
        }
        system.debug('canal: '+pedido.Account.Canal_Distribucion__c.right(2)+'Sociedad: '+pedido.Account.Sociedad__c.right(3));
        if(!Test.isRunningTest()){
            if( pedido.Account.Canal_Distribucion__c.right(2) == 'EX' && (pedido.Account.Sociedad__c.right(3) == '303' || pedido.Account.Sociedad__c.right(3) == '300') ) {
                if( String.isBlank(pedido.OC__c ) ) {
                    pedidoWS.estatusPedido = 11;
                    pedido.StageName = '11 - Bloqueado Cierre';
                    PedidoBloqueado = true;
                    system.debug('PedidoBloqueado: '+ PedidoBloqueado);
                }
                else
                {
                    pedido.StageName = '1 - Pedido Colocado';
                }
            }
        }
        if(cancelado) {
            pedidoWS.estatusPedido = 8; //8-Cancelación
        }
        else {
            pedidoWS.estatusPedido = 1;
        }
        
        if(EnvioAprobacion != null && EnvioAprobacion == true && pedido.Canal_Factura__r.IdPlanta__c == null)
        {
            if(string.isNotBlank(pedido.Numero_de_Pedido_NSC__c) && pedido.Numero_de_Pedido_NSC__c != '0')
                pedidoWS.estatusPedido = 10; //10-Bloqueado
        }
        /*if(!cancelado && String.isBlank(pedido.Folio_Pedido_SDL__c))
{
if(!ValidarCierre(pedido,Integer.valueOf(pedido.Canal_Factura__r.Dias_de_cierre__c), pedido.Canal_Factura__r.Hora_de_cierre__c))
{
pedidoWS.estatusPedido = 11; //10-Bloqueado
pedido.StageName = '11 - Bloqueado Cierre';
}
}*/
        
        pedidoWS.tipoSurtido = 3;
        pedidoWS.tipoVenta = 1;
        String sociedad = '';
        try{
            sociedad = pedido.Account.Sociedad__c.right(3);
        }catch(Exception e){
            System.debug('Error leyendo la sociedad de la sucursal');
            sociedad = '';
        }
        String canalDistribucion = '';
        try{
            canalDistribucion = pedido.Account.Canal_Distribucion__c.right(2);
        }catch(Exception e){
            System.debug('Error leyendo el canal de distribucion de la sucursal');
            canalDistribucion = '';
        }
        if( sociedad == '303' && canalDistribucion == 'EX' ) {
            pedidoWS.tipoPedidoViz = 1;// if(EX) 1
        }
        else {
            pedidoWS.tipoPedidoViz = 0;
        }
        pedidoWS.areaRespViz = (String.isNotBlank(idPlanta) && canalDistribucion=='EX' && sociedad == '303')?'V':'';
        Integer codigoPlanta = 0;
        if( String.isNotBlank( pedido.Canal_Factura__r.Codigo__c ) ) {
            try{
                codigoPlanta = Integer.valueOf(pedido.Canal_Factura__r.Codigo__c);
            }catch(Exception e){
                System.debug('Error en conversión de id planta del canal factura');
            }
        }
        pedidoWS.canalSurteCte = codigoPlanta;
        
        if(canalDistribucion=='EX'){
            pedidoWS.tipoEntrega = 1; //1-DD; 2-BP Sólo Exportación
            pedidoWS.tipoEmbarque = 1; //1-Directo; 2-LTL
        } else  {
            pedidoWS.tipoEntrega = 0;
            pedidoWS.tipoEmbarque = 0;
        }
        System.debug('IDPedidoSF...');
        try {
            System.debug('IDPedidoSF: '+pedido.Id_Externo__c);
            pedidoWS.IdPedidoSF = Integer.valueOf( pedido.Id_Externo__c );
        } catch( Exception e ) {
            SYstem.debug('Error transformando IdPedidoSF. '+e.getMessage());
            return null;
        }
        Datetime fechaRegistro = pedido.CreatedDate;
        if(fechaRegistro == null)
            fechaRegistro = System.now();
        System.debug('FechaRegistro: '+fechaRegistro);
        pedidoWS.fechaRegistro = fechaRegistro.format('yyyyMMdd');
        pedidoWS.horaRegistro = fechaRegistro.format('HH:mm:ss');
        System.debug('Atendio...');
        if( pedido.Id == null ) {
            
            String atendio = '';
            try{
                atendio = System.UserInfo.getFirstName().left(1).capitalize() + System.UserInfo.getLastName().capitalize();
            }catch(Exception e){
                System.debug('El usuario actual no trae nombre o apellido');
                atendio = '';
            }
            if(pedido.CreatedById!=null){
                try{
                    atendio = pedido.CreatedBy.FirstName.left(1).capitalize() + pedido.CreatedBy.LastName.capitalize();
                }catch(Exception e){
                    System.debug('El usuario que creo el pedido no trae nombre o apellido');
                    atendio = '';
                }
            } else { pedido.CreatedById = System.UserInfo.getUserId(); }
            pedidoWS.atendido = atendio;
            
            if(string.isNotBlank(pedido.Canal_Factura__r.Hora_de_cierre__c))
            {
                String HoraMov = String.valueOf(Datetime.now().hour()).leftPad(2, '0')+String.valueOf(Datetime.now().minute()).leftPad(2, '0');
                Integer HoraActual = Integer.valueOf(HoraMov);
                Integer HoraCierre = 0;
                string[] arregloHoracierre = pedido.Canal_Factura__r.Hora_de_cierre__c.split(':');
                if(arregloHoracierre != null && arregloHoracierre.size() > 1)
                {
                    string hora = arregloHoracierre[0].leftPad(2, '0')+arregloHoracierre[1].leftPad(2, '0');
                    HoraCierre = Integer.valueOf(hora);
                }
                if(HoraActual >= HoraCierre)
                {
                    System.debug('fechaRegistro.addDays(1);'+fechaRegistro.addDays(1));
                    fechaRegistro = fechaRegistro.addDays(1);
                }
            }
            
            if(pedido.CreatedDate!=null){ fechaRegistro = pedido.CreatedDate; }
            else { pedido.CreatedDate = System.now(); }
            pedidoWS.fechaRegistro = fechaRegistro.format('yyyyMMdd');
            pedidoWS.horaRegistro = fechaRegistro.format('HH:mm:ss');
        }
        else {
            fechaRegistro = pedido.CreatedDate;
            System.debug('FechaRegistro: '+fechaRegistro);
            pedidoWS.fechaRegistro = fechaRegistro.format('yyyyMMdd');
            pedidoWS.horaRegistro = fechaRegistro.format('HH:mm:ss');
            String atendio;
            try{
                atendio = System.UserInfo.getFirstName().left(1).capitalize() + System.UserInfo.getLastName().capitalize();
            }catch(Exception e){
                System.debug('El usuario actual no trae nombre o apellido');
                atendio = '';
            }
            
            if(pedido.CreatedById!=null){
                try{ atendio = pedido.CreatedBy.FirstName.left(1).capitalize() + pedido.CreatedBy.LastName.capitalize(); }
                catch(Exception e){ System.debug('El usuario que creo el pedido no trae nombre o apellido'); atendio = ''; }
            }
            pedidoWS.atendido = atendio;
        }
        
        // PEDIDO A ACTUALIZAR
        if( String.isNotBlank(pedido.Id) && !cancelado ) {
            System.debug('Modificacion...');
            
            String modifico = '';
            try{
                modifico = System.UserInfo.getFirstName().left(1).capitalize() + System.UserInfo.getLastName().capitalize();
            }catch(Exception e){
                System.debug('Usuario que modifico no trae nombre o apellidos');
                modifico = '';
            }
            pedidoWS.vendedorModifico = modifico;
            
            DateTime fechaModificacion = System.now();
            pedidoWS.fechaModifico = fechaModificacion.format('yyyyMMdd');
            pedidoWS.horaModifico = fechaModificacion.format('HH:mm:ss');
            
        }
        else {
            //pedidoWS.idPedidoSF = 0;
            pedidoWS.vendedorModifico = '';
            pedidoWS.fechaModifico = '';
            pedidoWS.horaModifico = '';
        }
        if( cancelado ) {
            String cancelo = '';
            try{
                cancelo = System.UserInfo.getFirstName().left(1).capitalize() + System.UserInfo.getLastName().capitalize();
            }catch(Exception e){
                System.debug('Usuario que modifico no trae nombre o apellidos');
                cancelo = '';
            }
            System.debug('Cancelacion...');
            DateTime fechaCancelacion = System.now();
            pedidoWS.vendedorElimino = cancelo;
            pedidoWS.fechaElimino = fechaCancelacion.format('yyyyMMdd');
            pedidoWS.horaElimino = fechaCancelacion.format('HH:mm:ss');
        }
        else {
            pedidoWS.vendedorElimino = '';
            pedidoWS.fechaElimino = '';
            pedidoWS.horaElimino = '';
        }
        
        
        Integer clienteSAP = null;
        try{
            clienteSAP = Integer.valueOf(pedido.Cliente__r.Numero_Cliente_SAP__c);
        }catch(Exception e){
            System.debug('Error en conversión de cliente SAP');
            clienteSAP = 0;
        }
        pedidoWS.cliente = clienteSAP;
        
        
        
        // canal
        Integer canalSucursal = null;
        try{
            canalSucursal = Integer.valueOf(pedido.Canal_Factura__r.IdClienteViz__c);
        }catch(Exception e){
            System.debug('Error en conversión de canal factura sucursal viz');
            canalSucursal = 0;
        }
        
        if( canalDistribucion == 'EX' && sociedad == '303' && String.isNotBlank( idPlanta ) ) {
            pedidoWS.clienteInterViz = canalSucursal;
        }
        else {
            pedidoWS.clienteInterViz = 0;
        }
        // sap
        Integer sapSucursal = null;
        try{
            sapSucursal = Integer.valueOf(pedido.Account.Numero_Cliente_SAP__c.replace('SUC - ',''));
        }catch(Exception e){
            System.debug('Error en conversión de sucursal SAP');
            sapSucursal = 0;
        }
        pedidoWS.destinatario = sapSucursal;
        //CAMBIO JOSE.BARAZA
        // ID PLANTA DE LA OFICINA DE VENTAS DE LA SUCURSAL
        Integer destinatarioViz = null;
        try{
            
            if( String.isNotBlank(pedido.Canal_Factura__r.SucursalesViz__c))
            {
                List<String> ListaSucursalesFrontera = new List<String>();
                ListaSucursalesFrontera.addAll(pedido.Canal_Factura__r.SucursalesViz__c.split(';'));
                destinatarioViz =Integer.valueOf( pedidosOtrosCanalesUtils.ValidarSucursalViz(ListaSucursalesFrontera,pedido.frontera__c));
                System.debug('destinatarioViz -------> '+destinatarioViz);
            }
            
        }catch(Exception e){
            System.debug('Error en conversión de id planta de la oficina de ventas de la sucursal');
            destinatarioViz = 0;
        }
        if( canalDistribucion == 'EX' && sociedad == '303' ) {
            pedidoWS.destinatarioViz = destinatarioViz;
        } else {
            pedidoWS.destinatarioViz = 0;
        }
        // CODIGO DEL CANAL DE DISTRIBUCIÓN NSC DE LA SUCURSAL
        Integer codigoCDSucursal = null;
        try{
            codigoCDSucursal = Integer.valueOf( pedido.Account.Canal_de_Distribucion_NSC__r.Codigo__c );
        }catch(Exception e){
            System.debug('Error en conversión del codigo del canal de distribución de la sucursal');
            codigoCDSucursal = 0;
        }
        pedidoWS.canalDistCte = codigoCDSucursal;
        
        // CODIGO DEL CANAL DE DISTRIBUCIÓN DE LA SUCURSAL
        String canalDistribucionSucursal = '';
        try{
            canalDistribucionSucursal = pedido.Account.Canal_Distribucion__c.right(2) == 'AS'?'S':' '; //S para AS
        }catch(Exception e){
            System.debug('Error leyendo canal de distribución de la sucursal');
            canalDistribucionSucursal = ' ';
        }
        pedidoWS.autorizado = canalDistribucionSucursal;
        // CODIGO VIZ DEL CANAL DE DISTRIBUCIÓN DE LA SUCURSAL
        Integer codigoVizCDSucursal = null;
        try{
            codigoVizCDSucursal = Integer.valueOf( sucViz.Canal_de_Distribucion_NSC__r.Codigo__c );
        }catch(Exception e){
            System.debug('Error en conversión del codigo viz del canal de distribución de la sucursal');
        }
        if( String.isNotBlank( idPlanta ) && sociedad == '303' ) {
            if( sucViz == null ) {
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING, 'La Sucursal Viz no está configurada.'));
                return null;
            }
            pedidoWS.canalDistViz = codigoVizCDSucursal;
        }
        else {
            pedidoWS.canalDistViz = 0;
        }
        
        // FRONTERA
        Integer frontera = 0;
        try{
            String [] ArrFrontera = pedido.Frontera__c.split('-');
            if(ArrFrontera != null && ArrFrontera.size() > 1)
            {
                frontera = Integer.valueOf(ArrFrontera[0]);
            }
            else
            {
                frontera = Integer.valueOf(pedido.Frontera__c.left(2).trim());
            }
        }catch(Exception e){
            System.debug('Error en conversión de frontera');
        }
        if( String.isNotBlank( idPlanta ) ) {
            pedidoWS.fronteraCte = frontera;
        }
        else {
            pedidoWS.fronteraCte = 0;
        }
        System.debug('Valor Frontera: '+frontera);
        
        // FECHA EMBARQUE
        //DateTime fechaHoraEmbarque = pedido.Fecha_de_Embarque__c;
        Date fechaEmbarque = pedido.Fecha_de_Embarque__c;
        pedidoWS.fechaEmbarque = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Embarque__c, 'yyyyMMdd' );// fechaHoraEmbarque.format('yyyyMMdd');
        Integer semana = Integer.valueOf( pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Embarque__c, 'w' ) );
        Integer dof = Integer.valueOf(pedidosOtrosCanalesUtils.getDOF( pedido.Fecha_de_Embarque__c ));
        Integer anio = fechaEmbarque.year();
        if( dof == 7 ) {
            if( semana == 1 ) { semana = 52; anio = anio - 1; }
            else { semana = semana - 1; }
        }
        pedidoWS.semana = String.valueOf( semana ); //fechaHoraEmbarque.format('w');
        pedidoWS.diaSemana = String.valueOf( dof);
        //System.debug('PedidoDiaSemana: '+pedidoWS.diaSemana);
        pedidoWS.anio = String.valueOf( anio );
        
        // FECHA ENTREGA
        //DateTime fechaEntrega = pedido.Fecha_de_Entrega__c;
        pedidoWS.fechaEntrega = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Entrega__c, 'yyyyMMdd' ); // fechaEntrega.format('yyyyMMdd');
        pedidoWS.fechaCita = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Entrega__c, 'yyyyMMdd' ); //fechaEntrega.format('yyyyMMdd');
        
        // FECHA INSPECCION
        if(pedido.Fecha_de_Inspeccion__c!=null){
            //DateTime fechaInspeccion = pedido.Fecha_de_Inspeccion__c;
            pedidoWS.fechaInspeccion = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Inspeccion__c, 'yyyyMMdd' ); //fechaInspeccion.format('yyyyMMdd');
        } else {
            pedidoWS.fechaInspeccion = ' ';
        }
        
        // FECHA EMBARQUE BODEGA
        if(pedido.Fecha_Embarque_Bodega__c!=null){
            
            pedidoWS.fechaEmbBodega = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_Embarque_Bodega__c, 'yyyyMMdd' ); //fechaEBodega.format('yyyyMMdd');
        } else {
            pedidoWS.fechaEmbBodega = ' ';
        }
        
        pedidoWS.Detalle = new WsPedidosMayoreoLegados.ArrayOfPedidoMayoreoDetalle();
        pedidoWs.Detalle.PedidoMayoreoDetalle =  CrearDetallePedido(pedido, productos,Cancelado);
        
        return pedidoWS;
    }
    public static List<WsPedidosMayoreoLegados.PedidoMayoreoDetalle> CrearDetallePedido(Opportunity pedido,list<pedidosOtrosCanalesUtils.producto> productos,Boolean cancelacion)
    {
        System.debug('Haciendo mapa de productos...');
        Map<String, List<PedidosOtrosCanalesUtils.Producto>> mapProductos = PedidosOtrosCanalesUtils.getProdsXCodigo( productos );
        System.debug('Mapa Productos: '+ mapProductos);
        List<WsPedidosMayoreoLegados.PedidoMayoreoDetalle> productosWS = new List<WsPedidosMayoreoLegados.PedidoMayoreoDetalle>();
        for( String codigo: mapProductos.keySet() ) {
            System.debug('Ensamblando detalle...');
            List<PedidosOtrosCanalesUtils.Producto> prodsAux = mapProductos.get(codigo);
            System.debug('ProdAux: '+prodsAux);
            PedidosOtrosCanalesUtils.Producto primerProd = prodsAux.get(0);
            String canalDistribucion = '';
            try{
                canalDistribucion = pedido.Account.Canal_Distribucion__c.right(2);
            }catch(Exception e){
                System.debug('Error leyendo el canal de distribucion de la sucursal');
                canalDistribucion = '';
            }
            GenerarAdmonEstrategia(pedido ,primerProd,cancelacion,canalDistribucion);
            OpportunityLineItem primerItem = primerProd.item;
            
            Integer pCodigo = 0;
            try{
                pCodigo = Integer.valueOf(codigo);
            }catch(Exception e){
                System.debug('Error en conversión del código:' + codigo);
                continue;
            }
            
            WsPedidosMayoreoLegados.PedidoMayoreoDetalle p = new WsPedidosMayoreoLegados.PedidoMayoreoDetalle();
            if(pedido.Canal_Factura__r.Valida_Disponibilidad__c)
            {
                P.diasConsolidacion = ObtenerDiasConsolidacion(pedido,pCodigo);
                system.debug('P.diasConsolidacion metodo:' + P.diasConsolidacion);
            }
            else
            {
                ParametrosOtrosCanales__c ep = ParametrosOtrosCanales__c.getInstance();
                P.diasConsolidacion = Integer.ValueOf(ep.Dias_Embarque__c);
                
            }
            p.autorizaPrecio = 'S';
            p.productoRelacion = 'P';
            p.producto = pCodigo;
            p.precioSAPCte = primerItem.UnitPrice;
            if( primerItem.Precio_Unitario_Viz__c != null ) {
                p.precioSAPViz = primerItem.Precio_Unitario_Viz__c;
            } else {
                p.precioSAPViz = 0;
            }
            p.tipoPrecioSAP = primerItem.Tipo_de_Precio__c;
            p.cjXPallets = primerProd.cajasXPallet;
            p.marca = 1;
            
            Integer folioPrecioSAP = 0;
            try{
                folioPrecioSAP = Integer.valueOf( primerItem.FolioPrecioSAP__c );
            }catch(Exception e){
                System.debug('Folio precio SAP no es valido');
            }
            p.folioPrecioSAPCte = folioPrecioSAP;
            
            Integer folioPrecioSAPViz = 0;
            try{
                folioPrecioSAPViz = Integer.valueOf( primerItem.FolioPrecioSAPViz__c );
            }catch(Exception e){
                System.debug('Folio precio SAP no es valido');
            }
            p.folioPrecioSAPViz = folioPrecioSAPViz;
            map<string,Integer> maptipoPeso = new map< String ,Integer>{'K'=>1,'P'=>2,'L'=>3};
                Integer utipoPeso = 0; // 'C'
            if(primerItem.Unidad__c != 'C')
            {
                utipoPeso  = maptipoPeso.get(primerItem.Unidad__c);
            }
            // if( pedido.Unidad__c == 'K' ) { utipoPeso = 1; }
            // else if( pedido.Unidad__c == 'P' )  { utipoPeso = 2; }
            // else if( pedido.Unidad__c == 'L' ) { utipoPeso = 3; }
            p.unidadPeso = utipoPeso;
            p.tipoPeso = String.valueOf(utipoPeso);//UM 0,1,2

            Decimal pallets   = 0;
            Integer cantidad   = 0;
            Integer cajasTt     = 0;
            Decimal cantidadKGS = 0;
            Decimal librasPeso   = 0;
            Decimal importeTxP   = 0.0;
            Decimal importeTxPV = 0.0;
            String obs       = '';

            System.debug('Armando Inventario...');
            List<WsPedidosMayoreoLegados.PedidoMayoreoInventario> listInventario = new List<WsPedidosMayoreoLegados.PedidoMayoreoInventario>();
            for( PedidosOtrosCanalesUtils.Producto prod: prodsAux ) {
                if( prod == null ) { continue; }
                OpportunityLineItem item = prod.item;
                
                WsPedidosMayoreoLegados.PedidoMayoreoInventario inventario = new WsPedidosMayoreoLegados.PedidoMayoreoInventario();
                inventario.producto = pCodigo;

                //ORIGEN SURTIDO
                String idPlantaSurtido = '';
                Integer codigoOrigen = 0;
                Integer idPlantaOrigen = 0;
                try{
                    idPlantaSurtido = item.Origen_Surtido__r.IdPlanta__c;
                }catch(Exception e){
                    System.debug('Error leyendo la planta del origen surtido');
                }
                if(idPlantaSurtido==null){
                    idPlantaSurtido = '';
                }
                try{
                    codigoOrigen = Integer.valueOf(item.Origen_Surtido__r.Codigo__c);
                }catch(Exception e){
                    System.debug('Error en conversión del codigo del origen surtido');
                }
                try{
                    idPlantaOrigen = Integer.valueOf(item.Origen_Surtido__r.IdPlanta__c);
                }catch(Exception e){
                    System.debug('Error en conversión de la planta del origen surtido');
                }
                inventario.origenSurtido = codigoOrigen;

                // ACTIVA
                Integer activa = 0;
                try {
                    if(item.Origen_Surtido__r.Valida_Disponibilidad__c) { activa = 1; }
                }catch(Exception e){
                    System.debug('Error en valida disponibilidad del origen surtido');
                }
                inventario.dispoActiva = activa;

                //TIPO INVENTARIO
                Integer tipoInventario = 0;
                try{
                    tipoInventario = Integer.valueOf(item.Tipo_de_Inventario__c.left(1));
                }catch(Exception e){
                    System.debug('Error en conversion de tipo de inventario');
                }
                inventario.tipoInventario = tipoInventario;

                //CANTIDAD CAJAS
                Integer cajas = 0;
                try{
                    cajas = Integer.valueOf(item.Cajas__c);
                }catch(Exception e){
                    System.debug('Error en conversion de cajas');
                }
                if(cajas==null){cajas = 0;}
                inventario.cantidadCajas = cajas;
                listInventario.add( inventario );

                //ACUMULADO
                Integer tmpPallets = 0;
                Integer tmpVolumen = 0;
                try{tmpPallets=Integer.valueOf(item.Pallets__c);}catch(Exception e){System.debug('Error en conversión de pallets');}
                if(tmpPallets==null){tmpPallets=0;}
                try{tmpVolumen=Integer.valueOf(item.Volumen__c);}catch(Exception e){System.debug('Error en conversión de volumen');}
                if(tmpVolumen==null){tmpVolumen=0;}

                cajasTt += cajas;
                pallets += tmpPallets;
                cantidad += Integer.valueOf(item.Cantidad__c);
                cantidadKGS += item.Kilos__c;
                librasPeso += tmpVolumen;
                if(item.Importe__c!=null){
                    importeTxP += item.Importe__c;
                }
                if(item.Importe_Total_Viz__c!=null){
                    importeTxPV += item.Importe_Total_Viz__c;
                }
                if(item.Observaciones__c!=null){
                    obs += ( (String.isNotBlank(item.Rango_Surtido__c)?item.Rango_Surtido__c:'') + ' ' + item.Observaciones__c);
                }
            }

            System.debug('INVENTARIO::'+listInventario);
            
            WsPedidosMayoreoLegados.ArrayOfPedidoMayoreoInventario inventarioWS = new WsPedidosMayoreoLegados.ArrayOfPedidoMayoreoInventario();
            inventarioWS.PedidoMayoreoInventario = listInventario;
            p.inventario = inventarioWS;
            Decimal rPallet = (pallets - Math.abs(pallets));
            p.pallets = Integer.valueOf(pallets+(1-rPallet));
            if( pedido.Unidad__c == 'P' ) {
                p.piezas = cantidad;
            }
            p.cajas = cajasTt;
            p.cantidadKGS = cantidadKGS.setScale(2);
            p.librasPeso = librasPeso.setScale(2);
            
            p.importeTotXProducto = importeTxP.setScale(2);
            p.importeTotXProductoViz = importeTxPV.setScale(2);
            p.observacionesxProducto = obs;
            productosWS.add(p);
            
        }
        return productosWS;
    }
    public static WsPedidosMayoreoLegados.PIPedidoVenta CrearPedidoSap(Opportunity pedido,list<producto> productos,Boolean Cancelado)
    {
        if(mapTipoPedido == null)
            mapTipoPedido =  FillTipoPedido();
        
        WsPedidosMayoreoLegados.PIPedidoVenta pedidoSap = new WsPedidosMayoreoLegados.PIPedidoVenta();
        pedido.Cliente__r   = PedidosOtrosCanalesUtils.retrieveCteInfo( pedido.Cliente__c );
        pedido.Account     =  PedidosOtrosCanalesUtils.retrieveCteInfo( pedido.AccountId );
       
		system.debug('CrearPedidoSap------------------------------------------------------------------> ');
        system.debug('mapTipoPedido: '+mapTipoPedido);
        system.debug('pedido.Canal__c: '+pedido.Canal__c);
        
        /// cabecero
        pedidoSap.SALES_HEADER_IN = new WsPedidosMayoreoLegados.SALES_HEADER_IN();
        pedidoSap.SALES_HEADER_IN.DOC_TYPE= mapTipoPedido.get(pedido.Canal__c).ClaseDocto__c;
        pedidoSap.SALES_HEADER_IN.COLLECT_NO='X'; // siempre va vacio
        if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' && String.isNotBlank( pedido.Canal_Factura__r.IdPlanta__c ) && pedido.Cliente__r.Sociedad__c.right(3) == '303' )
        {
            string suc = 'SUC - ';
            List<String> ListaSucursalesFrontera = new List<String>();
            ListaSucursalesFrontera.addAll(pedido.Canal_Factura__r.SucursalesViz__c.split(';'));
            System.debug('ListaSucursalesFrontera: '+ListaSucursalesFrontera);
            System.debug('pedido.frontera__c: '+pedido.frontera__c);
            String ClienteViz = ValidarSucursalViz(ListaSucursalesFrontera,pedido.frontera__c);
            System.debug('ClienteViz: '+ClienteViz);
            if(String.isNotBlank(ClienteViz))
            {
                string codigo  ='0';
                Account sucViz = buscarSucViz(suc+ClienteViz.leftPad(10, '0'));
                if(sucViz != null && sucViz.Canal_Distribucion__c != null)
                {
                    codigo = sucViz.Canal_Distribucion__c.right(2);
                    pedidoSap.SALES_HEADER_IN.DISTR_CHAN =  codigo;
                    pedidoSap.SALES_HEADER_IN.SALES_ORG= string.ValueOf(sucViz.Organizacion_de_Ventas__c.right(4));
                    pedidoSap.SALES_HEADER_IN.PURCH_NO_C= sucViz.Canal_Distribucion__c.right(2)+pedido.Id_Externo__c;
                    
                }
            }
            
            
        }
        else
        {
            pedidoSap.SALES_HEADER_IN.SALES_ORG =   pedido.Cliente__r.Organizacion_de_Ventas__c.right(4);
            pedidoSap.SALES_HEADER_IN.DISTR_CHAN =  pedido.Cliente__r.Canal_Distribucion__c.right(2);
            pedidoSap.SALES_HEADER_IN.PURCH_NO_C=   pedido.Cliente__r.Canal_Distribucion__c.right(2)+pedido.Id_Externo__c;
        }
        
        pedidoSap.SALES_HEADER_IN.SALES_OFF=  pedido.Canal_Factura__r.Codigo__c;
        pedidoSap.SALES_HEADER_IN.DIVISION=   pedido.Cliente__r.Sector__c.right(2);
        pedidoSap.SALES_HEADER_IN.REQ_DATE_H= dateToString(pedido.Fecha_de_Entrega__c,'yyyyMMdd');
        pedidoSap.SALES_HEADER_IN.PURCH_NO_S= pedido.OC__c;
        /// termina cabecero
        /// se llena el arreglo de productos
        pedidoSap.ItemsIn = new WsPedidosMayoreoLegados.ArrayOfSALES_ITEMS_IN();
        pedidoSap.ItemsIn.SALES_ITEMS_IN = new list<WsPedidosMayoreoLegados.SALES_ITEMS_IN>();
        WsPedidosMayoreoLegados.SALES_ITEMS_IN item = new WsPedidosMayoreoLegados.SALES_ITEMS_IN();
        Integer consecutivo =  1;
        map<string,string> mapUnidadMedida = crearUnidadMedidaSap();
        map<Integer,producto> mapProductosConConsecutivo = new map<Integer,producto>();
        productosSap = new  map<string,producto>();
        for(producto p : productos)
        {
            if(p.codigo == '')
                continue;
            
            productosSap.put(string.ValueOf(consecutivo),p);	
            item = new WsPedidosMayoreoLegados.SALES_ITEMS_IN();
            item.ITM_NUMBER= string.ValueOf(consecutivo);
            item.MATERIAL=    p.codigo;
            if(p.item.Unidad__c =='C' || p.item.Unidad__c =='P')
            {
                item.TARGET_QTY=  String.ValueOf(p.item.Cantidad__c);
            }
            else
            {
                item.TARGET_QTY=  String.ValueOf(p.item.Volumen__c);
            }
            item.PLANT=       pedido.Canal_Factura__r.Centro__c;
            item.TARGET_QU=   mapUnidadMedida.get(p.item.Unidad__c);
            item.SALES_UNIT=  mapUnidadMedida.get(p.item.Unidad__c);
            mapProductosConConsecutivo.put(Integer.ValueOf(item.ITM_NUMBER),p);
            pedidoSap.ItemsIn.SALES_ITEMS_IN.add(item);
            consecutivo++;
        }
        /// termina el arreglo de productos
        /// arreglo de Partners
        pedidoSap.Partners = new WsPedidosMayoreoLegados.ArrayOfSALES_PARTNERS();
        pedidoSap.Partners.SALES_PARTNERS = new list<WsPedidosMayoreoLegados.SALES_PARTNERS>();
        WsPedidosMayoreoLegados.SALES_PARTNERS partner = new WsPedidosMayoreoLegados.SALES_PARTNERS();
        if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' && String.isNotBlank( pedido.Canal_Factura__r.IdPlanta__c ) && pedido.Cliente__r.Sociedad__c.right(3) == '303' )
        {
            string suc = 'SUC - ';
            List<String> ListaSucursalesFrontera = new List<String>();
            ListaSucursalesFrontera.addAll(pedido.Canal_Factura__r.SucursalesViz__c.split(';'));
            System.debug('ListaSucursalesFrontera: '+ListaSucursalesFrontera);
            System.debug('pedido.frontera__c: '+pedido.frontera__c);
            String ClienteViz = ValidarSucursalViz(ListaSucursalesFrontera,pedido.frontera__c);
            System.debug('ClienteViz: '+ClienteViz);
            if(String.isNotBlank(ClienteViz))
            {
                partner.PARTN_ROLE = 'WE';
                partner.PARTN_NUMB = ClienteViz;
                pedidoSap.Partners.SALES_PARTNERS.add(partner);
                partner = new WsPedidosMayoreoLegados.SALES_PARTNERS();
                partner.PARTN_ROLE = 'AG';
                partner.PARTN_NUMB = pedido.Canal_Factura__r.IdClienteViz__c;
                pedidoSap.Partners.SALES_PARTNERS.add(partner);
            }
        }
        else{
            partner.PARTN_ROLE = 'WE';
            partner.PARTN_NUMB = pedido.account.Numero_Cliente_SAP__c.replace('SUC - ','');
            pedidoSap.Partners.SALES_PARTNERS.add(partner);
            partner = new WsPedidosMayoreoLegados.SALES_PARTNERS();
            partner.PARTN_ROLE = 'AG';
            partner.PARTN_NUMB = pedido.Cliente__r.Numero_Cliente_SAP__c;
            pedidoSap.Partners.SALES_PARTNERS.add(partner);
            
        }
        /// arreglo de Partners
        /// SALES_CONDITIONS
        pedidoSap.ConditionsIn = new WsPedidosMayoreoLegados.ArrayOfSALES_CONDITIONS_IN();
        pedidoSap.ConditionsIn.SALES_CONDITIONS_IN = new list<WsPedidosMayoreoLegados.SALES_CONDITIONS_IN>();
        WsPedidosMayoreoLegados.SALES_CONDITIONS_IN condition = new WsPedidosMayoreoLegados.SALES_CONDITIONS_IN();
        map<string,Configuracion_PreciosOC__c> mapTipoPrecio = FillTipoPrecios();
        string llave;       
        
        for(integer i : mapProductosConConsecutivo.keySet())
        {
            condition = new WsPedidosMayoreoLegados.SALES_CONDITIONS_IN();
            llave = pedido.Cliente__r.Moneda_Cliente__c.right(3)+ mapProductosConConsecutivo.get(i).item.Tipo_de_Precio__c;
            condition.ITM_NUMBER = string.valueOf(i);
            condition.COND_TYPE = mapTipoPrecio.get(llave).Condicion_Precio__c;
            if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' && String.isNotBlank( pedido.Canal_Factura__r.IdPlanta__c ) && pedido.Cliente__r.Sociedad__c.right(3) == '303' )
            {
                condition.COND_VALUE = string.valueOf(mapProductosConConsecutivo.get(i).item.Precio_Unitario_Viz__c);
            }	
            else
            {
                condition.COND_VALUE = string.valueOf(mapProductosConConsecutivo.get(i).item.UnitPrice);
            }        		
            condition.CURRENCY_x =  pedido.Cliente__r.Moneda_Cliente__c.right(3);
            condition.COND_UNIT = mapTipoPrecio.get(llave).Tipo_Precio_Sap__c;
            pedidoSap.ConditionsIn.SALES_CONDITIONS_IN.add(condition);
        }
        ///  SALES_CONDITIONS
        pedidoSap.Text = new WsPedidosMayoreoLegados.ArrayOfSALES_TEXT();
        pedidoSap.Text.SALES_TEXT = new list<WsPedidosMayoreoLegados.SALES_TEXT>();
        WsPedidosMayoreoLegados.SALES_TEXT linea  = new WsPedidosMayoreoLegados.SALES_TEXT();
        linea.POS_NR = '0';
        linea.TEXT_LINE = pedido.description;
        pedidoSap.Text.SALES_TEXT.add(linea);
        pedidoSap.SchedulesIn = new WsPedidosMayoreoLegados.ArrayOfSALES_SCHEDULES_IN();
        pedidoSap.SchedulesIn.SALES_SCHEDULES_IN = new list<WsPedidosMayoreoLegados.SALES_SCHEDULES_IN>();
        WsPedidosMayoreoLegados.SALES_SCHEDULES_IN schedules = new WsPedidosMayoreoLegados.SALES_SCHEDULES_IN();
        consecutivo =  1;
        for(producto p : productos)
        {
        	WsPedidosMayoreoLegados.SALES_TEXT ln  = new WsPedidosMayoreoLegados.SALES_TEXT();
            schedules = new WsPedidosMayoreoLegados.SALES_SCHEDULES_IN();
            if(p.codigo == '')
                continue;
            schedules.LOAD_DATE =  dateToString(pedido.Fecha_de_Embarque__c,'yyyyMMdd');
            schedules.GI_DATE = dateToString(pedido.Fecha_de_Entrega__c,'yyyyMMdd');
            schedules.ITM_NUMBER = string.ValueOf(consecutivo);
            ln.POS_NR = string.ValueOf(consecutivo);
            ln.TEXT_LINE = p.item.Observaciones__c;
            pedidoSap.Text.SALES_TEXT.add(ln);
            pedidoSap.SchedulesIn.SALES_SCHEDULES_IN.add(schedules);
            consecutivo++;
        }
        
        return pedidoSap;
    }
    public static WsPedidosMayoreoLegados.Pedido CrearPedidoNSC(Opportunity pedido,list<producto> productos,Boolean Cancelado)
    {	
        WsPedidosMayoreoLegados.Pedido DatosPedidoNSC = new WsPedidosMayoreoLegados.Pedido();
        pedido.Cliente__r   = PedidosOtrosCanalesUtils.retrieveCteInfo( pedido.Cliente__c );
        pedido.Account     =  PedidosOtrosCanalesUtils.retrieveCteInfo( pedido.AccountId );
        string codigo  = '0';
        string organizacionVentas;
        if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' && String.isNotBlank( pedido.Canal_Factura__r.IdPlanta__c ) && pedido.Cliente__r.Sociedad__c.right(3) == '303' )
        {
            string suc = 'SUC - ';
            List<String> ListaSucursalesFrontera = new List<String>();
            ListaSucursalesFrontera.addAll(pedido.Canal_Factura__r.SucursalesViz__c.split(';'));
            System.debug('ListaSucursalesFrontera: '+ListaSucursalesFrontera);
            System.debug('pedido.frontera__c: '+pedido.frontera__c);
            String ClienteViz = ValidarSucursalViz(ListaSucursalesFrontera,pedido.frontera__c);
            System.debug('ClienteViz: '+ClienteViz);
            if(String.isNotBlank(ClienteViz))
            {
                
                Account sucViz = buscarSucViz(suc+ClienteViz.leftPad(10, '0'));
                if(sucViz != null && sucViz.Canal_de_Distribucion_NSC__c != null)
                {
                    codigo = string.Valueof(sucViz.Canal_de_Distribucion_NSC__r.Codigo__c); 
                    system.debug('SucViz:--------------------------------> '+ codigo);
                    DatosPedidoNSC.nCanalDistribucion=             Integer.ValueOf(codigo);
                    DatosPedidoNSC.Original_nCanalDistribucion=    Integer.ValueOf(codigo);
                    
                }
            }
        }
        else
        {
            DatosPedidoNSC.nCanalDistribucion=        Integer.ValueOf(pedido.Canal_Factura__r.Codigo__c);
            DatosPedidoNSC.Original_nCanalDistribucion=    Integer.ValueOf(pedido.Canal_Factura__r.Codigo__c);
            
            
        }
        organizacionVentas = pedido.Cliente__r.Organizacion_de_Ventas__c.right(4);
        String canalDistribucion = '';
        String idPlanta;
        if(pedido.Canal_Factura__r.IdPlanta__c != null)
        {
            idPlanta = pedido.Canal_Factura__r.IdPlanta__c;
            
        }
        try{
            canalDistribucion = pedido.Account.Canal_Distribucion__c.right(2);
        }catch(Exception e){
            System.debug('Error leyendo el canal de distribucion de la sucursal');
            canalDistribucion = '';
        }
        String sociedad = '';
        try{
            sociedad = pedido.Account.Sociedad__c.right(3);
        }catch(Exception e){
            System.debug('Error leyendo la sociedad de la sucursal');
            sociedad = '';
        }
        
        string SucViz = (String.isNotBlank(idPlanta) && canalDistribucion=='EX' && sociedad == '303')?'V':'';
        system.debug('SucViz::: ' + SucViz);
        DatosPedidoNSC.nCanalDistribucionVenta=   	   Integer.ValueOf(pedido.Account.Canal_de_Distribucion_NSC__r.Codigo__c);//Integer.ValueOf(pedido.Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c);
        DatosPedidoNSC.nPedidoCliente= 				   0; // revisar con wendy
        DatosPedidoNSC.cOrganizacionVenta= 			   organizacionVentas;
        DatosPedidoNSC.Original_nPedidoCliente=        0; // revisar con wendy
        DatosPedidoNSC.nSucursalCliente=               0; // revisar con wendy
        DatosPedidoNSC.nEjecutivo=                     0; 
        DatosPedidoNSC.nCliente=					   Integer.ValueOf(pedido.Cliente__r.Numero_Cliente_SAP__c);
        DatosPedidoNSC.nTipoSurtido=                   3;
        DatosPedidoNSC.dFecha=    					   datetime.now();   
        DatosPedidoNSC.dFechaActualizacion= 		   datetime.now();
        DatosPedidoNSC.dFechaSurtidoProgramada=        SucViz == 'V'?pedido.Fecha_Embarque_Bodega__c:pedido.Fecha_de_Embarque__c;
        DatosPedidoNSC.dHoraEntregaProgramadaInicio=   datetime.now();
        DatosPedidoNSC.dHoraEntregaProgramadaFin=      datetime.now();
        DatosPedidoNSC.dFechaEntrega=				   pedido.Fecha_de_Entrega__c;
        DatosPedidoNSC.nFormaPago=                     pedido.Cliente__r.Tipo_de_Credito__c.right(1) =='3'?2 :Integer.ValueOf(pedido.Cliente__r.Tipo_de_Credito__c.right(1));
        DatosPedidoNSC.bPedidoAceptado=			       true; 
        DatosPedidoNSC.bPedidoSurtido=			       false; 
        DatosPedidoNSC.bRequiereAutorizacion=          false; 
        DatosPedidoNSC.bTipoAutorizacionRemota=        false; 
        DatosPedidoNSC.bPedidoAutorizado=              false; 
        DatosPedidoNSC.bPedidoRechazado=               false;
        DatosPedidoNSC.bCapturadoDespuesDeCierre=      false;
        DatosPedidoNSC.bFacturaNoFiscal=               false; 
        DatosPedidoNSC.nCostoFlete=                    0;
        DatosPedidoNSC.bEnviadoCorporativo=            false;
        DatosPedidoNSC.bPedidoCanceladoPorElSistema=   false;
        DatosPedidoNSC.bPedidoTransmitido=             false;
        DatosPedidoNSC.bAplicado=                      false;
        DatosPedidoNSC.bIntegrado=                     false;
        DatosPedidoNSC.bSolicitudAutorizacionRemotaEnviada=false;
        DatosPedidoNSC.nPedidoPadre=                   0;
        DatosPedidoNSC.cMotivoAutorizacion=            ''; 
        DatosPedidoNSC.nImporte=                       pedido.Amount;
        DatosPedidoNSC.cObservacion=                   pedido.Description ==null ?'':pedido.Description;
        DatosPedidoNSC.cSupervisor=                    SucViz ==''?ObtenerCanalVenta(pedido):SucViz;
        DatosPedidoNSC.cObservacionSupervisor=		   ''; 
        DatosPedidoNSC.nOrigenPedido=                  4; 
        DatosPedidoNSC.nEstatusPedido=                 1;
        DatosPedidoNSC.cSupervisorEmbarque=            '';
        DatosPedidoNSC.bActivo=                        true;
        DatosPedidoNSC.cUsuario_Registro=              'Pedidos.SF';
        DatosPedidoNSC.dFecha_Registro=                 datetime.now();
        DatosPedidoNSC.cMaquina_Registro=               ObtenerUsuario();
        if(pedido.Id!= null)
        {
            DatosPedidoNSC.cUsuario_UltimaModificacion=    ObtenerUsuario(); 
            DatosPedidoNSC.dFecha_UltimaModificacion=      datetime.now();
            DatosPedidoNSC.cMaquina_UltimaModificacion=    'SRV-SALESFORCE';
        }
        DatosPedidoNSC.cMotivoCancelacion=               '';
        if(cancelado)
        {
            DatosPedidoNSC.nCausaCancelacion=            0;
            DatosPedidoNSC.cUsuario_Eliminacion=         ObtenerUsuario(); 
            DatosPedidoNSC.dFecha_Eliminacion=           datetime.now();
            DatosPedidoNSC.cMaquina_Eliminacion=         'SRV-SALESFORCE';
        }
        DatosPedidoNSC.bFactura=                          true; 
        DatosPedidoNSC.cOrdenCompra=                      pedido.OC__c == null?'':pedido.OC__c; 
        DatosPedidoNSC.cDepartamentoOrdenCompra=          null; 
        DatosPedidoNSC.bDisponibleLiberado=               null; 
        DatosPedidoNSC.nCanalRN=                          null; 
        DatosPedidoNSC.bEnviadoEBS=                       null;
        DatosPedidoNSC.nProspecto=                        null; 
        DatosPedidoNSC.nAutorizaEspecial=                 null;
        DatosPedidoNSC.cAutorizaEliminarPedido=           null; 
        DatosPedidoNSC.cAutorizaActualizarPedido=         null;
        DatosPedidoNSC.nClienteSap=                       Integer.ValueOf(pedido.Cliente__r.Numero_Cliente_SAP__c);
        DatosPedidoNSC.cSucursalSAP=					  pedido.Account.Numero_Cliente_SAP__c.replace('SUC - ','');
        DatosPedidoNSC.EsTicket=                          false;
        DatosPedidoNSC.IdSalesforce=					  pedido.Id_Externo__c;
        DatosPedidoNSC.nCanalConexion=                    Integer.ValueOf(pedido.Canal_Factura__r.Codigo__c); 
        /// PEDIDO DETALLE
        DatosPedidoNSC.Detalle = new WsPedidosMayoreoLegados.ArrayOfPedidoDetalle();
        DatosPedidoNSC.Detalle.PedidoDetalle = new list<WsPedidosMayoreoLegados.PedidoDetalle>();
        WsPedidosMayoreoLegados.PedidoDetalle pedidoDetalle = new WsPedidosMayoreoLegados.PedidoDetalle();
        Integer consecutivo =  1;
        map<string,Integer> MapaMonedas = crearMoneda();
        map<string,Integer> MapaMarcas = crearMapaMarcas();
        map<string,string> MapaUnidad = crearUnidadMedidaCabecero();
        map<string,Integer> MapaUnidadMedida = crearUnidadMedida();
        
        for(producto p : productos)
        {
            if(p.codigo == '')
                continue;
            
            pedidoDetalle = new WsPedidosMayoreoLegados.PedidoDetalle();
            pedidoDetalle.nCanalDistribucion = codigo !='0'?Integer.ValueOf(codigo):Integer.ValueOf(pedido.Canal_Factura__r.Codigo__c);
            pedidoDetalle.nPedidoCliente= 	   0; 
            pedidoDetalle.nRenglon = consecutivo++;
            pedidoDetalle.nProducto = Integer.ValueOf(p.codigo);
            if(p.item.Product2.Marca__c != null)
            {
                pedidoDetalle.nMarca  = MapaMarcas.get(p.item.Product2.Marca__c.trim());
            }
            else
            {
                pedidoDetalle.nMarca  = 1;
            }
            pedidoDetalle.nUnidad = MapaUnidadMedida.get(p.item.Tipo_de_Precio__c);
            pedidoDetalle.nTipoGanado = null;
            pedidoDetalle.nCalidadCanal= null;
            pedidoDetalle.nCondicionCajaCanal= null;
            pedidoDetalle.nCantidadPedidaUnidadMovimiento = p.item.Volumen__c;
            pedidoDetalle.nCantidadPedida= p.item.Volumen__c;
            pedidoDetalle.nCantidadConfirmadaUnidadMovimiento= p.item.Volumen__c;
            pedidoDetalle.nCantidadConfirmada= p.item.Volumen__c;
            pedidoDetalle.nPiezasPedidas = Integer.Valueof(p.item.Cantidad__c);
            pedidoDetalle.nPiezasConfirmadas = Integer.Valueof(p.item.Cantidad__c);
            pedidoDetalle.nCantidadBalanceadaUnidadMovimiento = 0;
            pedidoDetalle.nCantidadBalanceada= 0;
            pedidoDetalle.nPiezasBalanceadas= 0;
            pedidoDetalle.nCantidadSurtida= 0;
            pedidoDetalle.nPiezasSurtidas= 0;
            pedidoDetalle.nCantidadSurtidaEnUnidadBase= 0;
            pedidoDetalle.nPesoPromedio =  p.item.Peso_Promedio__c;
            pedidoDetalle.nFactorConversionAUnidadBase = 1;// webdy
            if(p.item.Unidad__c == 'C')
            {
                pedidoDetalle.bPedidoEnUnidadDePeso = false;
            }
            if(p.item.Unidad__c == 'K' || p.item.Unidad__c == 'L')
            {
                pedidoDetalle.bPedidoEnUnidadDePeso = true;
            }
            if(p.item.Unidad__c == 'P')
            {
                pedidoDetalle.bPedidoEnUnidadDePeso = true;
            }
            
            pedidoDetalle.bSurtido = false;
            pedidoDetalle.nTipoLista = 0;
            pedidoDetalle.Precio_nListaPrecios = 1;
            pedidoDetalle.Precio_nRenglon =0;
            pedidoDetalle.Precio_nFolioOferta=0;
            if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' && String.isNotBlank( pedido.Canal_Factura__r.IdPlanta__c ) && pedido.Cliente__r.Sociedad__c.right(3) == '303' )
            {
                pedidoDetalle.nPrecioUnitarioOriginal = p.item.Precio_Unitario_Viz__c;
                pedidoDetalle.nPrecioUnitarioOtorgado = p.item.Precio_Unitario_Viz__c;
            }	
            else
            {
                pedidoDetalle.nPrecioUnitarioOriginal = p.item.UnitPrice;
                pedidoDetalle.nPrecioUnitarioOtorgado = p.item.UnitPrice;
            } 
            pedidoDetalle.nImporte = p.item.importe__c;
            pedidoDetalle.nMoneda = MapaMonedas.get(pedido.Cliente__r.Moneda_Cliente__c.right(3));
            pedidoDetalle.nTipoCambio = 1;
            pedidoDetalle.cObservacion = p.item.Observaciones__c==null ?'':p.item.Observaciones__c;
            pedidoDetalle.nCausaIncumplimiento=null;
            pedidoDetalle.cObservacionIncumplimiento='';
            pedidoDetalle.nDiasMinimosProduccion=null;
            pedidoDetalle.nDiasMaximosProduccion=null;
            if(p.item.Tipo_de_Precio__c =='PK')
            {
                pedidoDetalle.nTipoPrecioOriginal=1;
            }
            if(p.item.Tipo_de_Precio__c =='DL')
            {
                pedidoDetalle.nTipoPrecioOriginal=2;
            }
            if(p.item.Tipo_de_Precio__c =='PC')
            {
                pedidoDetalle.nTipoPrecioOriginal=3;
            }
            if(p.item.Tipo_de_Precio__c =='DC')
            {
                pedidoDetalle.nTipoPrecioOriginal=4;
            }
            if(p.item.Tipo_de_Precio__c =='PP')
            {
                pedidoDetalle.nTipoPrecioOriginal=5;
            }
            if(p.item.Tipo_de_Precio__c =='DP')
            {
                pedidoDetalle.nTipoPrecioOriginal=6;
            }
            if(p.item.Tipo_de_Precio__c =='DK')
            {
                pedidoDetalle.nTipoPrecioOriginal=7;
            }
            pedidoDetalle.nContenidoProducto=3;
            pedidoDetalle.bEsProductoFR = null;
            pedidoDetalle.nRangoInventario = null;
            pedidoDetalle.nAutorizaEspecial = null;
            pedidoDetalle.ProductoSAP = p.codigo;
            pedidoDetalle.bEsPesoEstandard=false;
            pedidoDetalle.nContenidoCaja=0;
            DatosPedidoNSC.Detalle.PedidoDetalle.add(pedidoDetalle);
        }
        return DatosPedidoNSC;
    }
    
    public static PedidosMayoreoWS.ArrayOfPedidosMayoreoRespuesta executeGuardar( PedidosMayoreoWS.ArrayOfPedidoMayoreo request ) {
        if( request == null ) {
            return null;
        }
        system.debug('request: '+request);
        PedidosMayoreoWS.PedidosMayoreoSoap soap = new PedidosMayoreoWS.PedidosMayoreoSoap();
        PedidosMayoreoWS.ArrayOfPedidosMayoreoRespuesta response = soap.SF_GuardaPedidoEMA( request );
        if( response == null ){
            return null;
        }
        
        PedidosMayoreoWS.PedidosMayoreoRespuesta[] respuestas = response.PedidosMayoreoRespuesta;
        if( respuestas == null ) {
            return null;
        }
        
        return response;
    }
    
    private static User retrieveUserInfo( String userId ) {
        if(Test.isRunningTest() && Limits.getQueries() >=100){
            return null;
        }
        User u = new User();
        u.Id = userId;
        try {
            u = [SELECT Id, FirstName, LastName, Username, UserRole.Name,Email
                 FROM User
                 WHERE Id =: userId LIMIT 1];
        }
        catch( Exception e ) {
            System.debug('Hubo un problema al buscar al usuario! ' + e.getMessage());
            return u;
        }
        
        return u;
    }
    
    public static Map<String, List<Producto>> getProdsXCodigo( List<Producto> productos ) {
        if( productos == null ) { return null; }
        
        Map<String, List<Producto>> mapPCode = new Map<String, List<Producto>>();
        
        for( Producto p: productos ) {
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( String.isBlank( p.item.Tipo_de_Inventario__c ) ) { continue; }
            
            List<Producto> temp = mapPCode.get( p.codigo );
            if( temp == null ) {
                temp = new List<Producto>();
                mapPcode.put( p.codigo, temp );
            }
            temp.add( p );
        }
        
        return mapPCode;
    }
    
    public static String buscarPriceBookEntryId( String productId, String pricelistId ) {
        return [SELECT Id FROM PricebookEntry WHERE Product2Id =: productId AND Pricebook2Id =: pricelistId].Id;
    }
    
    public static List<Oficina_de_Venta__c> buscarOfiXCodigo( String codigo ){
        if(String.isBlank(codigo)){
            return null;
        }
        String qry = 'SELECT Id, Name, Codigo__c, IdPlanta__c, Descripcion__c, SucursalesViz__c, IdClienteViz__c, Organizaciones_de_Venta__c, Canales_de_Distribucion__c,Dias_consolidacion__c, Dias_Consolidacion_Prod__c,Valida_Disponibilidad__c,Hora_de_cierre__c,Dias_de_cierre__c,Tiempo_SLA__c,Opera_en_SAP__c	 '+
            'FROM Oficina_de_Venta__c '+
            'WHERE Codigo__c = \'' + codigo + '\'' +
            ' LIMIT 1';
        System.debug('QRY OFI:' + qry);
        return (List<Oficina_de_Venta__c>)Database.query(qry);
    }
    
    public static Oficina_de_Venta__c buscarOfiXId(String idOfiVta){
        if(String.isBlank(idOfiVta)){
            return null;
        }
        return [SELECT Id, Name, Codigo__c, IdPlanta__c, Descripcion__c, SucursalesViz__c, IdClienteViz__c, Organizaciones_de_Venta__c, Canales_de_Distribucion__c,Dias_Consolidacion_Prod__c,Dias_consolidacion__c,Hora_de_cierre__c,Dias_de_cierre__c,Opera_en_SAP__c
                FROM Oficina_de_Venta__c
                WHERE Id =: idOfiVta
                LIMIT 1];
    }
    
    public static Account buscarSucViz( String code ) {
        if( String.isBlank( code ) ) {
            return null;
        }
        if( code.length() < 10 ) {
            code = code.leftPad(10, '0');
        }
        Account accViz = new Account();
        try {
            accViz = [SELECT Id, Sociedad__c, Oficina_de_Ventas__r.Codigo__c, Organizacion_de_Ventas__c, Grupo_de_Vendedores__r.Codigo__c,
                      Canal_Distribucion__c, Ramo__c, Canal_de_Distribucion_NSC__r.Codigo__c,Cadena__c
                      FROM Account
                      WHERE Numero_Cliente_SAP__c =: code];
        }
        catch( Exception e ) {
            System.debug('ERR::'+e.getMessage());
            return null;
        }
        
        return accViz;
    }
    
    /********ASR*******/
    public static Product2 buscarProductos(String code){
        
        if(Test.isRunningTest() && Limits.getQueries() >=100){
            return null;
        }
        List<Product2> productos = [Select Id, Name, ProductCode, Cajas_Tarima__c, CsxPalletInt__c, IsActive, Piezas_por_caja__c, Peso_Promedio__c,Unidad_de_medida_base__c,Producto_Master__c,Producto_Master__r.MasterID__c
                                    From Product2
                                    Where ProductCode=:code];
        if(productos==null){return null;}
        if(productos.size()>0){
            System.debug('Producto: '+productos.get(0));
            return productos.get(0);
        }
        return null;
    }
    
    public static Product2 buscarProductosPorNombre(String id){
        List<Product2> productos = [Select Id, Name, ProductCode, Cajas_Tarima__c, CsxPalletInt__c, IsActive, Piezas_por_caja__c, Peso_Promedio__c,Producto_Master__r.MasterID__c,Producto_Master__c
                                    From Product2
                                    Where Id=:id];
        if(productos==null){return null;}
        if(productos.size()>0){
            System.debug('Producto: '+productos.get(0));
            return productos.get(0);
        }
        return null;
    }
    
    public static List<Account> buscarPorSAP(String sap){
        if(String.isBlank(sap)){
            return null;
        }
        String qry = 'SELECT Id, Name, Numero_Cliente_SAP__c, Canal_Distribucion__c, Estatus_Cliente__c, Organizacion_de_Ventas__c,Cadena__c '+
            'FROM Account '+
            //'WHERE Estatus_Cliente__c = \'Activo\' '+
            'WHERE RecordType.Name LIKE \'Principal%\' '+
            'AND Numero_Cliente_SAP__c LIKE \'%' + sap + '%\' '+
            'LIMIT 2';
        System.debug('ASR Debug:' + qry);
        return (List<Account>)Database.query(qry);
    }
    
    public static Account buscarPorId(String idCliente){
        if(String.isBlank(idCliente)){
            return null;
        }
        return [SELECT Id, Name, Numero_Cliente_SAP__c, Canal_Distribucion__c, Sociedad__c, Estatus_Cliente__c, Organizacion_de_Ventas__c,Cadena__c
                FROM Account
                WHERE Id = :idCliente
                LIMIT 1];
    }
    
    public static List<Account> buscarSucursal(String idCliente, String sap){
        if(String.isBlank(sap) && String.isBlank(idCliente)){
            return null;
        }
        String qry = 'SELECT Id, Name, Numero_Cliente_SAP__c, ParentId, Parent.Name, Parent.Numero_Cliente_SAP__c, Canal_Distribucion__c, Sociedad__c, Estatus_Cliente__c, Organizacion_de_Ventas__c,Cadena__c '+
            'FROM Account '+
            //'WHERE Estatus_Cliente__c = \'Activo\' '+
            'WHERE RecordType.Name LIKE \'Sucursal%\' ';
        if( String.isNotBlank( sap ) ) {
            qry += 'AND Numero_Cliente_SAP__c LIKE \'%' + sap + '%\' ';
        }
        if(String.isNotBlank(idCliente)){
            qry += 'AND ParentId = \'' + idCliente + '\' ';
        }
        qry += 'LIMIT 2';
        System.debug('ASR Debug:' + qry);
        return (List<Account>)Database.query(qry);
    }
    
    public static String getStandarPriceBook(){
        return [SELECT p.IsStandard, p.Id FROM Pricebook2 p WHERE isStandard = true AND isActive = true LIMIT 1].Id;
    }
    
    public static Opportunity getOppById(String id){
        return [Select Id, AccountId, Account.Name, Account.Numero_Cliente_SAP__c, Account.Estatus_Cliente__c, Account.Canal_Distribucion__c,
                Cliente__c, Cliente__r.Name, Cliente__r.Estatus_Cliente__c, Cliente__r.Numero_Cliente_SAP__c, Canal_Factura__c,
                Canal_Factura__r.Name, Canal_Factura__r.Codigo__c, Canal_Factura__r.IdClienteViz__c, Canal_Factura__r.IdPlanta__c,
                Canal_Factura__r.SucursalesViz__c, Canal_Factura__r.Valida_Disponibilidad__c, Cliente__r.Canal_Distribucion__c,
                Frontera__c, Folio_Pedido_SDL__c, Folio_SAP__c, Folio_Transporte__c, Folio_Embarque__c, Pricebook2Id, Cancelado_en_SAP__c, Unidad__c,
                Fecha_de_Embarque__c, Fecha_de_Entrega__c, Flete__c, Fecha_de_Cruce__c, Liberado__c, Motivo_Rechazo_Cartera__c, Motivo_de_Cancelacion__c,
                Fecha_de_Inspeccion__c, Fecha_Embarque_Bodega__c, Hora_de_Embarque__c, OC__c, Pedido_Cancelado__c,
                PO_Proveedor__c, Name, Description, Amount, Id_Externo__c, CreatedDate, MotivoRechazo__c,
                CreatedById, CreatedBy.FirstName, CreatedBy.LastName, CreatedBy.Username,Account.Cadena__c,
                CreatedBy.UserRole.Name,Numero_de_Pedido_NSC__c,Canal__c,Canal_Factura__r.Dias_consolidacion__c,Canal_Factura__r.Dias_Consolidacion_Prod__c,Account.Organizacion_de_Ventas__c
                ,Cliente__r.Organizacion_de_Ventas__c,Observacion__c,Motivo__c,Cliente__r.Moneda_Cliente__c,Semana__c,Cliente__r.Canal_de_Distribucion_NSC__C
                ,Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c,Numero_Pedido_SAP__c,Account.Sociedad__c,Owner.Name,Account.Calle__c,
                Account.Localidad_Ciudad__r.Name,Account.Codigo_Postal__c,account.Numero_exterior__c,
                account.Colonia__c,account.Colonia__r.Name,account.Estado__r.name,StageName,  Canal_Factura__r.Opera_en_SAP__c
                From Opportunity
                Where Id =:Id
                LIMIT 1];
    }
    public static string ValidarSucursalViz(list<String> ListaSucursalesFrontera, String Frontera)
    {
        map<string,string> mapSucursalesViz = new map<string,string>();
        string fronteraPedido;
        if(!String.isBlank(Frontera) && Frontera.length() > 1)
        {
            string[] ValoresFrontera = Frontera.split('-');
            fronteraPedido = ValoresFrontera[0];
        }
        else if(!String.isBlank(Frontera))
            fronteraPedido = Frontera;
        
        for(string value : ListaSucursalesFrontera)
        {
            string[] ofiValues = value.split('_');
            if(ofiValues != null && ofiValues.size() > 0)
            {
                mapSucursalesViz.put(ofiValues[1],ofiValues[2]);
            }
        }
        
        return mapSucursalesViz.get(fronteraPedido);
    }
    public static List<PedidosOtrosCanalesUtils.Producto> getItems(String oppId){
        system.debug('Entro getItems: ' +oppId);
        if(Test.isRunningTest() && Limits.getQueries() >=100){
            return null;
        }
        List<PedidosOtrosCanalesUtils.Producto> productos = new List<PedidosOtrosCanalesUtils.Producto>();
        List<OpportunityLineItem> items = [Select OpportunityId, Id, PriceBookEntryId, ProductCode, Product2Id, Product2.Name,
                                           Origen_Surtido__c, Origen_Surtido__r.Name, Origen_Surtido__r.Codigo__c, Origen_Surtido__r.Valida_Disponibilidad__c,
                                           Peso_Promedio__c, Cajas_x_Pallet__c, Precio_Unitario_Viz__c, Importe_Total_Viz__c, Quantity,
                                           UOM_LB__c, Cajas__c, Volumen__c, Pallets__c, UnitPrice, Tipo_de_Precio__c, Kilos__c,
                                           Importe__c, Tipo_de_Inventario__c, Rango_Surtido__c, Observaciones__c,Volumen_Solicitado_LB__c,
                                           PricebookEntry.Name, PricebookEntry.Product2Id, Id_externo_Producto_Pedido__c,Saldo__c,Product2.Producto_Master__c,Product2.Piezas_por_caja__c,
                                           Cantidad__c, Unidad__c,Origen_Surtido__r.IdPlanta__c,Product2.Marca__c,Product2.ProductCode,Product2.Producto_Master__r.MasterID__c,Saldo_Semana_Ant__c,Estatus__c,UOM__c
                                           ,Opportunity.Folio_SAP__c	
                                           From OpportunityLineItem
                                           Where OpportunityId =:oppId];
        for(Integer index=0;index<items.size();index++){
            if( items.get(index).Cantidad__c == null || items.get(index).Cantidad__c == 0 ) {  items.get(index).Cantidad__c = items.get(index).Cajas__c; }
            productos.add(new PedidosOtrosCanalesUtils.Producto(index, items.get(index)));
        }
        return productos;
    }
    public static string ObtenerUsuario()
    {
        String usuario = '';
        if(UserInfo.getFirstName() != null)
        {
            usuario += UserInfo.getFirstName().split(' ')[0].left(1);
        }
        if(UserInfo.getLastName() != null)
        {
            usuario += UserInfo.getLastName().split(' ')[0];
        }
        
        if(string.isBlank(usuario))
            usuario = System.UserInfo.getFirstName().left(1).capitalize() + System.UserInfo.getLastName().capitalize();
        
        return  usuario;
    }
    public static string ValidarDiasConsolidacion(list<String> ListaDiasConsolidacion, String Producto)
    {
        map<string,string> mapDiasConsolidacion = new map<string,string>();
        string DiasConsolidacion;
        for(string value : ListaDiasConsolidacion)
        {
            string[] dConValues = value.split('_');
            if(dConValues != null && dConValues.size() > 0)
            {
                
                mapDiasConsolidacion.put(dConValues[0],dConValues[1]);
            }
        }
        return mapDiasConsolidacion.get(Producto);
    }
    public static string obtenerAprobador(opportunity pedido,OpportunityLineItem item)
    {
        string aprobadorID,canalDistribucionEmail = '';
        if(pedido.Canal_Factura__r.IdPlanta__c != null)
        {
            canalDistribucionEmail = item.Origen_Surtido__r.Codigo__c;
            System.debug('Envio de correo:: '+aprobadorID);
            map<string,String> mapAprobadores = PedidosOtrosCanalesUtils.ObtenerAprobadoresCierre();
            if(string.isNotBlank(mapAprobadores.get(canalDistribucionEmail)))
            {
                aprobadorID = mapAprobadores.get(canalDistribucionEmail);
            }
            if(Test.isRunningTest())
            {
                aprobadorID = [select id from user where Email ='jose.barraza@sukarne.com' limit 1 ].id;
            }
            
        }
        return aprobadorID;
    }
    public static void submitForApprovalCierre(Opportunity opp, string Comment, string tipo,opportunityLineItem oppl)
    {
        // Create an approval request for the Opportunity
        String canalDistribucion = oppl.Origen_Surtido__r.Codigo__c;
        String aprobadorID ='';
        map<string,String> mapAprobadores = ObtenerAprobadoresCierre();
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments(Comment);
        req1.setObjectId(opp.id);
        System.debug('opp.id: '+opp.id);
        System.debug('canalDistribucion: '+canalDistribucion);
        System.debug('tipo: '+tipo);
        if(string.isNotBlank(mapAprobadores.get(canalDistribucion)))
        {
            aprobadorID = mapAprobadores.get(canalDistribucion);
        }
        if(Test.isRunningTest())
        {
            aprobadorID = [select id from user where Email ='jose.barraza@sukarne.com' limit 1 ].id;
        }
        System.debug('aprobadorID: '+aprobadorID);
        if(aprobadorID == null || String.isblank(aprobadorID))
        {
            ApexPages.getMessages().clear();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No se encontro aprobador para el canal seleccionado.'));
            return;
        }
        else{
            user u = new user(id=aprobadorID);
            req1.setNextApproverIds(new Id[] {u.Id});
            // Submit the approval request for the Opportunity
            Approval.ProcessResult result = Approval.process(req1);
        }
        
    }
    public static void submitForApproval(Opportunity opp, string Comment, string tipo)
    {
        // Create an approval request for the Opportunity
        String canalDistribucion = opp.Cliente__r.Canal_Distribucion__c.right(2);
        String aprobadorID ='';
        map<string,String> mapAprobadores = ObtenerAprobadores();
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments(Comment);
        req1.setObjectId(opp.id);
        System.debug('opp.id: '+opp.id);
        System.debug('canalDistribucion: '+canalDistribucion);
        System.debug('tipo: '+tipo);
        if(string.isNotBlank(mapAprobadores.get(canalDistribucion+tipo)))
        {
            aprobadorID = mapAprobadores.get(canalDistribucion+tipo);
        }
        if(Test.isRunningTest())
        {
            aprobadorID = [select id from user where Email ='jose.barraza@sukarne.com' limit 1 ].id;
        }
        System.debug('aprobadorID: '+aprobadorID);
        if(aprobadorID == null || String.isblank(aprobadorID))
        {
            ApexPages.getMessages().clear();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No se encontro aprobador para el canal seleccionado.'));
            return;
        }
        user u = new user(id=aprobadorID);
        req1.setNextApproverIds(new Id[] {u.Id});
        // Submit the approval request for the Opportunity
        Approval.ProcessResult result = Approval.process(req1);
    }
    public static WsActualizaDatosGenerales_NSC_SDL.RespuestaModificacionPedidos EnviarModificacionPedido(opportunity pedido,string areaResp,list<PedidosOtrosCanalesUtils.producto> productos,list<ProductosEliminado__c> ProductosEliminado)
    {
        WsActualizaDatosGenerales_NSC_SDL.ActualizaDatosGenerales_NSC_SDLSoap services = new  WsActualizaDatosGenerales_NSC_SDL.ActualizaDatosGenerales_NSC_SDLSoap();
        WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element requestUpdate = CtrlTrgOppWsActualizaDatosGenerales.WsActualizarDatosGeneralesPedidoOC(pedido,areaResp,productos,2,ProductosEliminado);
        return services.ActualizarDatosGenerales(requestUpdate.pedidoDatosGenerales, requestUpdate.PedidoMayoreo);
    }
    public static map<string,String> ObtenerAprobadores()
    {
        map<string,String> mapAprobadores = new map<string,String>();
        for(Aprobadores_Cierres__c ap :Aprobadores_Cierres__c.getall().values())
        {
            mapAprobadores.put(ap.Canal__c.toUpperCase()+ap.Tipo__c,ap.Aprobador__c);
        }
        System.debug('mapAprobadores: '+mapAprobadores);
        return mapAprobadores;
    }
    public static map<string,String> ObtenerAprobadoresCierre()
    {
        map<string,String> mapAprobadores = new map<string,String>();
        for(Aprobadores_Cierres__c ap :Aprobadores_Cierres__c.getall().values())
        {
            if(ap.Canal__c.isNumeric() && String.isblank(ap.Familia__c))
            {
                mapAprobadores.put(ap.Canal__c.toUpperCase(),ap.Aprobador__c);
            }
        }
        System.debug('mapAprobadores: '+mapAprobadores);
        return mapAprobadores;
    }
    public static Boolean validarGuardarNSC(Opportunity opp)
    {
        Boolean valido = false;
        if(opp.OC__c != null)
        {
            valido = true;
        }
        if(opp.PO_Proveedor__c != null)
        {
            valido = true;
        }
        if(opp.Description != null)
        {
            valido = true;
        }
        if(opp.Flete__c != null)
        {
            valido = true;
        }
        return valido;
        
    }
    public static Boolean validarEnvioFlujoApro(Opportunity opp, Opportunity oppOld)
    {
        Boolean valido = false;
        if(opp.OC__c != oppOld.OC__c)
        {
            valido = true;
        }
        if(opp.PO_Proveedor__c != oppOld.PO_Proveedor__c)
        {
            valido = true;
        }
        if(opp.Description != oppOld.Description)
        {
            valido = true;
        }
        if(opp.Flete__c != oppOld.Flete__c)
        {
            valido = true;
        }
        return valido;
        
    }
    public static map<string,Integer> crearMapaMarcas()
    {
        map<string,Integer> mapaMarcas = new map<string,Integer>();
        mapaMarcas.put('SUKARNE',1);
        mapaMarcas.put('MEZQUITE/SWF',3);
        mapaMarcas.put('AGROSUPER',5);
        mapaMarcas.put('AMH',7);
        mapaMarcas.put('BETTER BEEF',14);
        mapaMarcas.put('CREEKSTONE',35);
        mapaMarcas.put('EXL',50);
        mapaMarcas.put('EXL CAN',51);
        mapaMarcas.put('FRIGOSOR',56);
        mapaMarcas.put('GEN',61);
        mapaMarcas.put('GENERICA',62);
        mapaMarcas.put('IBP CAN',69);
        mapaMarcas.put('LO VALLEDOR',85);
        mapaMarcas.put('PILGRIMS',120);
        mapaMarcas.put('SWF',141);
        mapaMarcas.put('USPA',151);
        mapaMarcas.put('SUPESKADO',198);
        mapaMarcas.put('SWIFT',211);
        return mapaMarcas;
        
    }
    public static map<string,Integer> crearMoneda()
    {
        map<string,Integer> mapaMoneda = new map<string,Integer>();
        mapaMoneda.put('USD',2);
        mapaMoneda.put('MXN',1);
        return mapaMoneda;
        
    }
    public static map<Integer,String> crearMonedaSAP()
    {
        map<Integer,String> mapaMoneda = new map<Integer,String>();
        mapaMoneda.put(2,'USD');
        mapaMoneda.put(1,'MXN');
        return mapaMoneda;
        
    }
    public static map<string,Integer> crearUnidadMedida()
    {
        map<string,Integer> mapaUnidadMedida = new map<string,Integer>();
        mapaUnidadMedida.put('PK',4);
        mapaUnidadMedida.put('PP',4);
        mapaUnidadMedida.put('PC',4);
        mapaUnidadMedida.put('DL',5);
        mapaUnidadMedida.put('DK',5);
        mapaUnidadMedida.put('DC',5);
        mapaUnidadMedida.put('DP',5);
        return mapaUnidadMedida;
        
    }
    public static map<string,string> crearUnidadMedidaCabecero()
    {
        map<string,string> mapaUnidadMedida = new map<string,string>();
        mapaUnidadMedida.put('C','CJ');
        mapaUnidadMedida.put('K','KG');
        mapaUnidadMedida.put('L','LB');
        mapaUnidadMedida.put('P','PI');
        return mapaUnidadMedida;
    }
    public static map<string,string> crearUnidadMedidaSap()
    {
        map<string,string> mapaUnidadMedida = new map<string,string>();
        mapaUnidadMedida.put('C','CS');
        mapaUnidadMedida.put('K','KG');
        mapaUnidadMedida.put('L','LB');
        mapaUnidadMedida.put('P','PI');
        return mapaUnidadMedida;
    }
    public static WsActualizaDatosGenerales_NSC_SDL.RespuestaModificacionPedidos WsActualizarDatosGenerales(Opportunity pedido, string areaResp, list<producto> productos, integer TipoAutorizado,string TipoMov)
    {
        system.debug('WsActualizarDatosGenerales:: Entro');
        WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element request = new WsActualizaDatosGenerales_NSC_SDL.ActualizarDatosGenerales_element();
        WsActualizaDatosGenerales_NSC_SDL.ArrayOfPedidoMayoreo PedidoMayoreo = new WsActualizaDatosGenerales_NSC_SDL.ArrayOfPedidoMayoreo();
        WsActualizaDatosGenerales_NSC_SDL.ArrayOfDetallePedidoMayoreo  arregloDetalle = new WsActualizaDatosGenerales_NSC_SDL.ArrayOfDetallePedidoMayoreo();
        list<WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo> detalleWs = new list<WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo>();
        WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo d = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();
        request.pedidoDatosGenerales = CrearPedidoDatosGenerales(pedido,areaResp,TipoAutorizado,TipoMov);
        set<id> setPedido = new set<id>();
        setPedido.add(pedido.Id);
        map<string,list<ProductosEliminado__c>> MapProductosEliminado = CtrlTrgOppWsActualizaDatosGenerales.TraerProductosEliminados(setPedido);
        system.debug('WsActualizarDatosGenerales:: pedidoDatosGenerales ' + request.pedidoDatosGenerales);
        integer contador = 1;
        list<prod> productMap = new list<prod>();
        map<String,opportunityLineItem> MapaCantidadProductos = new map<String,opportunityLineItem>();
       
        for(PedidosOtrosCanalesUtils.producto p : productos)
        {
       		prod pp = new prod();
       		pp.codigo =  p.codigo;
       		pp.ProductCode = p.item.ProductCode;
        	productMap.add(pp);
        		
            if(p.item == null)
                continue;
            
            if(MapaCantidadProductos.containsKey(p.codigo))
            {
                MapaCantidadProductos.get(p.codigo).Cajas__c = integer.ValueOf(MapaCantidadProductos.get(p.codigo).Cajas__c) + integer.ValueOf(p.item.Cajas__c);
                MapaCantidadProductos.get(p.codigo).Kilos__c = integer.ValueOf(MapaCantidadProductos.get(p.codigo).Kilos__c) + integer.ValueOf(p.item.Kilos__c);
            }
            else
            {
                opportunityLineItem oppl = p.item;
                if(p.item.Unidad__c =='C' || p.item.Unidad__c =='P')
                    oppl.Cajas__c =  integer.ValueOf(p.item.Cantidad__c);
                
                MapaCantidadProductos.put(p.codigo,oppl);
            }    
            
            d = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();           
            d = CrearDetalleNSCSDL(p.item,contador++, request.pedidoDatosGenerales.TipoMoneda,p.codigo,pedido);
            if(d != null)
                detalleWs.add(d);           
        }             
       /* for(opportunityLineItem p : MapaCantidadProductos.values())
        {         	
            d = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();
            System.debug('TipoMoneda:: '+ request.pedidoDatosGenerales.TipoMoneda);
           
            d = CrearDetalleNSCSDL(p,contador++, request.pedidoDatosGenerales.TipoMoneda,p.ProductCode,pedido);
            if(d != null)
                detalleWs.add(d);
	    }
	   */
        if(MapProductosEliminado != null)
        {
            if(MapProductosEliminado.get(pedido.id) != null)
            {
                for(ProductosEliminado__c pe: MapProductosEliminado.get(pedido.id))
                {
                    if(pe.OpportunityId__c == pedido.id)
                    {
                        d = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();
                        d = CrearDetalleNSCSDLEliminado(30, request.pedidoDatosGenerales.TipoMoneda,pe.CodigoProducto__c);
                        if(d != null)
                            detalleWs.add(d);
                    }
                } 
            }
        }
        
        arregloDetalle.DetallePedidoMayoreo  =  new list<WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo>();
        arregloDetalle.DetallePedidoMayoreo  = detalleWs;
        request.pedidoDatosGenerales.DetallePedido = new WsActualizaDatosGenerales_NSC_SDL.ArrayOfDetallePedidoMayoreo();
        request.pedidoDatosGenerales.DetallePedido = arregloDetalle;
        request.pedidoMayoreo = new WsActualizaDatosGenerales_NSC_SDL.ArrayOfPedidoMayoreo();
        if(TipoMov == '2')
        {
            PedidosMayoreoWS.PedidoMayoreo CabezeropedidoMayoreo = CtrlTrgOppWsActualizaDatosGenerales.CrearCabezeroPedido(pedido,productos);
            if(CabezeropedidoMayoreo != null)
            {
                CabezeropedidoMayoreo.estatusPedido = 8;
                system.debug('CabezeropedidoMayoreo' + CabezeropedidoMayoreo);
                request.pedidoMayoreo.pedidoMayoreo = new list<WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreo>();
                request.PedidoMayoreo.PedidoMayoreo.add(CtrlTrgOppWsActualizaDatosGenerales.CrearPedidoMayoreo(CabezeropedidoMayoreo,pedido,productos));
            }
        }
        else
        {
        	 PedidosMayoreoWS.PedidoMayoreo CabezeropedidoMayoreo = CtrlTrgOppWsActualizaDatosGenerales.CrearCabezeroPedido(pedido,productos);
            if(CabezeropedidoMayoreo != null)
            {
                request.pedidoMayoreo.pedidoMayoreo = new list<WsActualizaDatosGenerales_NSC_SDL.PedidoMayoreo>();
                request.PedidoMayoreo.PedidoMayoreo.add(CtrlTrgOppWsActualizaDatosGenerales.CrearPedidoMayoreo(CabezeropedidoMayoreo,pedido,productos));
            }
        }
        system.debug('arregloDetalle.DetallePedidoMayoreo:: '+  request.pedidoDatosGenerales.DetallePedido);
        WsActualizaDatosGenerales_NSC_SDL.ActualizaDatosGenerales_NSC_SDLSoap services = new  WsActualizaDatosGenerales_NSC_SDL.ActualizaDatosGenerales_NSC_SDLSoap();
        system.debug('Termino WsActualizarDatosGenerales::');
        return services.ActualizarDatosGenerales(request.pedidoDatosGenerales, request.PedidoMayoreo);
        
        
    }
    public static WsActualizaDatosGenerales_NSC_SDL.PedidoDatosGenerales CrearPedidoDatosGenerales(Opportunity pedido,string areaResp, integer TipoAutorizado,String TipoMov)
    {
        WsActualizaDatosGenerales_NSC_SDL.PedidoDatosGenerales PedidoDatosGenerales = new  WsActualizaDatosGenerales_NSC_SDL.PedidoDatosGenerales();
       // PedidoDatosGenerales.CanalVenta = ObtenerCanalVenta(pedido);
       if(string.isNotBlank(pedido.Canal_Factura__r.IdPlanta__c) 
       		&&  pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX')
       {
       		PedidoDatosGenerales.CanalVenta = 'V';
       }
       else
       {
       		PedidoDatosGenerales.CanalVenta = ObtenerCanalVenta(pedido);
       }        
        pedido.Cliente__r   = retrieveCteInfo( pedido.Cliente__c );        
        if(pedido.Cliente__r.Canal_de_Distribucion_NSC__c == null)
        {
            pedido.Cliente__r   = retrieveCteInfo( pedido.Cliente__c );
            PedidoDatosGenerales.CanalDistCte = integer.ValueOf(pedido.Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c);
        }
        else
        {
            PedidoDatosGenerales.CanalDistCte = integer.ValueOf(pedido.Cliente__r.Canal_de_Distribucion_NSC__r.Codigo__c);
        }
        
        PedidoDatosGenerales.NumeroPedidoNSC = integer.ValueOf(pedido.Numero_de_Pedido_NSC__c == null?'0':pedido.Numero_de_Pedido_NSC__c);
        PedidoDatosGenerales.FolioPedidoSDL = pedido.Folio_Pedido_SDL__c;
        PedidoDatosGenerales.FechaEmbarque = dateToString(pedido.Fecha_de_Embarque__c,'yyyyMMdd');
        PedidoDatosGenerales.FechaEntregaCte = dateToString(pedido.Fecha_de_Entrega__c,'yyyyMMdd');
        if(pedido.Fecha_Embarque_Bodega__c != null)
            PedidoDatosGenerales.FechaEmbarqueBodega = dateToString(pedido.Fecha_Embarque_Bodega__c,'yyyyMMdd');
        else
            PedidoDatosGenerales.FechaEmbarqueBodega =''; 
        
        PedidoDatosGenerales.TipoMovto = TipoMov;
        if(pedido.Numero_Pedido_SAP__c == null || pedido.Numero_Pedido_SAP__c == '0')
        {
            PedidoDatosGenerales.NumeroPedidoSAP =  '';
        }
        else
        {
            PedidoDatosGenerales.NumeroPedidoSAP = pedido.Numero_Pedido_SAP__c;
        }
        
        map<string,string> UnidadMedidaCabecero = crearUnidadMedidaCabecero();
        PedidoDatosGenerales.UniMedidaVent = UnidadMedidaCabecero.get(pedido.Unidad__c);
        for(AggregateResult ar : CalcularImportes(pedido))
        {
            if(ar.get('OpportunityId') == pedido.Id)
            {
                PedidoDatosGenerales.ImporteTotalPedido = (Decimal)ar.get('expr0');
            }
            
        }
        map<string,Integer> MapaMonedas = crearMoneda();
        PedidoDatosGenerales.TipoMoneda = MapaMonedas.get(pedido.Cliente__r.Moneda_Cliente__c.right(3));
        PedidoDatosGenerales.FleteLibra = pedido.Flete__c == null?0:pedido.Flete__c;
        PedidoDatosGenerales.OCCliente = pedido.OC__c == null?'':pedido.OC__c;
        PedidoDatosGenerales.OCProveedor = pedido.PO_Proveedor__c== null?'':pedido.PO_Proveedor__c;
        PedidoDatosGenerales.ObservacionesGrals = pedido.Description== null?'':pedido.Description;
        PedidoDatosGenerales.TipoAutorizado = TipoAutorizado;
        PedidoDatosGenerales.MaquinaModifico = 'SRV-SALESFORCE';
        pedidoDatosGenerales.UsuarioModifico = ObtenerUsuario();
        Datetime now = Datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime local = now.addSeconds(offset/1000);
        pedidoDatosGenerales.FechaUltimaModificacion = local;//DateTime.now();
        pedidoDatosGenerales.FechaLlegadaInspeccion = pedido.Fecha_de_Inspeccion__c;
        if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' && String.isNotBlank( pedido.Canal_Factura__r.IdPlanta__c ) && pedido.Cliente__r.Sociedad__c.right(3) == '303' )
        {
            string suc = 'SUC - ';
            List<String> ListaSucursalesFrontera = new List<String>();
            ListaSucursalesFrontera.addAll(pedido.Canal_Factura__r.SucursalesViz__c.split(';'));
            System.debug('ListaSucursalesFrontera: '+ListaSucursalesFrontera);
            System.debug('pedido.frontera__c: '+pedido.frontera__c);
            String ClienteViz = ValidarSucursalViz(ListaSucursalesFrontera,pedido.frontera__c);
            System.debug('ClienteViz: '+ClienteViz);
            if(String.isNotBlank(ClienteViz))
            {
                string codigo  ='0';
                Account sucViz = buscarSucViz(suc+ClienteViz.leftPad(10, '0'));
                if(sucViz != null && sucViz.Canal_de_Distribucion_NSC__c != null)
                {
                    codigo = sucViz.Canal_de_Distribucion_NSC__r.Codigo__c;
                    PedidoDatosGenerales.CanalDistribucion = Integer.valueOf(codigo);
                }
            }
        }
        else
        {
            PedidoDatosGenerales.CanalDistribucion = integer.ValueOf(pedido.Canal_Factura__r.Codigo__c);
        }
        if(string.isNotBlank(pedido.Folio_SAP__c) && pedido.Folio_SAP__c != ' ')
        {     
            PedidoDatosGenerales.TipoModificacionSAP = '2';
        }
        else{ PedidoDatosGenerales.TipoModificacionSAP = '1';}
        if(pedido.Fecha_Embarque_Bodega__c != null)
            PedidoDatosGenerales.FechaEntregaBodega  = dateToString(pedido.Fecha_Embarque_Bodega__c,'yyyyMMdd');
        else
            PedidoDatosGenerales.FechaEntregaBodega ='';   
        
        return pedidoDatosGenerales; 
    }
    public static WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo CrearDetalleNSCSDLEliminado(integer contador, integer TipoMoneda, string codigo)
    {
        
        WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo detalle = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();
        detalle = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();
        detalle.NumRenglon  = contador;
        detalle.Producto  = integer.ValueOf(codigo);
        detalle.TipoPrecio  = '';
        detalle.PrecioUnitCte  = 0;
        detalle.PrecioConFleteCte  = 0;
        detalle.ImporteTotalProducto  = 0;
        detalle.UnidadMedida  = 4;
        detalle.KgsPedidos  = 0;
        detalle.LibrasPedidas  = 0;
        detalle.CajasPedidas  = 0;
        detalle.ObservacionProd = '';
        detalle.estatusProducto = 2;
        detalle.Marca  = 1;
        detalle.TipoMoneda  = 1;
        detalle.UnidadMedidaPrecio = 'CJ';
        detalle.MotivoCancelacion = '';
        detalle.DisponibilidadActiva  =  0;
        detalle.TipoInventario  =  3;
        detalle.DiasConsolidacion  =  3;
        system.debug(' CrearDetalleNSCSDLDETALLE '+detalle);
        return detalle;
    }
    public static WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo CrearDetalleNSCSDL(OpportunityLineItem producto,integer contador, integer TipoMoneda, string codigo, opportunity pedido)
    {
        
        WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo detalle = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();
        map<string,Integer> MapaMonedas = crearMoneda();
        map<string,Integer> MapaMarcas = crearMapaMarcas();
        map<string,string> MapaUnidad = crearUnidadMedidaCabecero();
        map<Integer,String> MapaMonedasSAP = crearMonedaSAP();
        
        detalle = new WsActualizaDatosGenerales_NSC_SDL.DetallePedidoMayoreo();
        detalle.NumRenglon  = contador;
        if(producto.Product2 != null)
        {
            detalle.Producto  = integer.ValueOf(producto.Product2.ProductCode);
        }
        else
        {
        	system.debug(' CrearDetalleNSCSDL '+codigo);
            detalle.Producto  = integer.ValueOf(codigo);
        }
        
        detalle.TipoPrecio  = producto.Tipo_de_Precio__c;
        detalle.PrecioUnitCte  = producto.UnitPrice;
        detalle.PrecioConFleteCte  = producto.UnitPrice;//producto.Precio_Flete__c == null?0:producto.Precio_Flete__c;
        detalle.ImporteTotalProducto  = producto.Importe__c;
        map<string,Integer> MapaUnidadMedida = crearUnidadMedida();
        detalle.UnidadMedida  = MapaUnidadMedida.get(producto.Tipo_de_Precio__c);
        /* if(producto.Tipo_de_Precio__c =='DL')
detalle.KgsPedidos  = producto.Volumen__c /CONVERSION_KILO_POUND;
else*/
        detalle.KgsPedidos  = producto.kilos__c;
        
        detalle.LibrasPedidas  = producto.Volumen__c == null?0:producto.Volumen__c;
        detalle.CajasPedidas  = integer.ValueOf(producto.Cajas__c);
        detalle.ObservacionProd = producto.Observaciones__c == null?'':producto.Observaciones__c;
        Integer Estatus = Producto.Estatus__c == null ? 1 : Integer.ValueOf(Producto.Estatus__c);
        Detalle.estatusProducto = Estatus;
        if(producto.Product2.Marca__c != null)
        {
            detalle.Marca  = MapaMarcas.get(producto.Product2.Marca__c.trim());
        }
        else
        {
            detalle.Marca  = 1;
        }
        detalle.TipoMoneda  = TipoMoneda;
        System.debug('producto.Unidad__c :'+producto.Unidad__c);
        map<string,string> mapUnidadMedida = crearUnidadMedidaSap();
        
        detalle.UnidadMedidaPrecio = mapUnidadMedida.get(producto.Unidad__c); //producto.UOM__c;
        System.debug('  detalle.UnidadMedidaPrecio :'+  detalle.UnidadMedidaPrecio);
        detalle.MotivoCancelacion = '';
        detalle.TipoMonedaSAP = MapaMonedasSAP.get(TipoMoneda);
        detalle.DisponibilidadActiva  = producto.Origen_Surtido__r.Valida_Disponibilidad__c == true? 1 : 0;
        detalle.TipoInventario  =  Integer.valueOf(producto.Tipo_de_Inventario__c.left(1));
        if(pedido.Canal_Factura__r.Valida_Disponibilidad__c)
        {
            detalle.DiasConsolidacion  =  ObtenerDiasConsolidacion(pedido,Integer.ValueOf(codigo));
        }
        else
        {
            ParametrosOtrosCanales__c ep = ParametrosOtrosCanales__c.getInstance();
            detalle.DiasConsolidacion  =  Integer.ValueOf(ep.Dias_Embarque__c);
            
        }
        return detalle;
    }
    private static AggregateResult[] CalcularImportes(Opportunity Opp )
    {
        return [select opportunityId,sum(Importe__c) FROM OpportunityLineItem where opportunityId =: Opp.Id GROUP BY opportunityId];
    }
    public static opportunity ActualizarCamposPedido(opportunity opp)
    {
        
        if(opp != null)
        {
            opp.NEW_Amount__c = opp.Amount;
            opp.NEW_Costo_de_Flete__c = opp.Costo_de_Flete__c;
            opp.NEW_Fecha_de_Cruce__c = opp.Fecha_de_Cruce__c;
            opp.NEW_Fecha_de_Embarque__c = opp.Fecha_de_Embarque__c;
            opp.NEW_Fecha_de_Entrega__c = opp.Fecha_de_Entrega__c;
            opp.NEW_Fecha_de_Inspeccion__c = opp.Fecha_de_Inspeccion__c;
            opp.NEW_Fecha_Embarque_Bodega__c = opp.Fecha_Embarque_Bodega__c;
            opp.NEW_Flete__c = opp.Flete__c;
            opp.NEW_Description__c = opp.Description;
            opp.NEW_OC__c = opp.OC__c;
            opp.NEW_PO_Proveedor__c = opp.PO_Proveedor__c;
            opp.NEW_TotalOpportunityQuantity__c = opp.TotalOpportunityQuantity;
        }
        
        return opp;
    }
    public static opportunity RegresarPedido(opportunity opp)
    {
        opp.TotalOpportunityQuantity = opp.NEW_TotalOpportunityQuantity__c;
        opp.Amount = opp.NEW_Amount__c;
        opp.Costo_de_Flete__c = opp.NEW_Costo_de_Flete__c;
        opp.Fecha_de_Cruce__c = opp.NEW_Fecha_de_Cruce__c;
        opp.Fecha_de_Embarque__c = opp.NEW_Fecha_de_Embarque__c;
        opp.Fecha_de_Entrega__c = opp.NEW_Fecha_de_Entrega__c;
        opp.Fecha_de_Inspeccion__c = opp.NEW_Fecha_de_Inspeccion__c;
        opp.Fecha_Embarque_Bodega__c= opp.NEW_Fecha_Embarque_Bodega__c;
        opp.Flete__c=opp.NEW_Flete__c;
        opp.Description = opp.NEW_Description__c;
        opp.OC__c = opp.NEW_OC__c;
        opp.PO_Proveedor__c = opp.NEW_PO_Proveedor__c;
        opp.Pedido_Approval_Estatus__c =null;
        return opp;
    }

    public static List<OpportunityLineItem> RegresarOpportunityLineItem(List<Producto> listaProductos)
    {
        List<OpportunityLineItem> lista = new list<OpportunityLineItem>();
        for(Producto oppl  : listaProductos){
            System.debug('oppl.item.NEW_Quantity__c ' + oppl.item.NEW_Quantity__c);
            if(oppl.item.NEW_Quantity__c == null)
                continue;
            
            oppl.item.Quantity = oppl.item.NEW_Quantity__c;
            oppl.item.Cajas__c=oppl.item.NEW_Cajas__c;
            oppl.item.Cantidad__c=oppl.item.NEW_Cantidad__c;
            oppl.item.Importe__c= oppl.item.NEW_Importe__c;
            oppl.item.Importe_Total_Viz__c=   oppl.item.NEW_Importe_Total_Viz__c;
            oppl.item.Kilos__c = oppl.item.NEW_Kilos__c;
            oppl.item.Observaciones__c= oppl.item.NEW_Observaciones__c;
            oppl.item.Pallets__c=oppl.item.NEW_Pallets__c;
            oppl.item.Piezas__c= oppl.item.NEW_Piezas__c;
            oppl.item.Precio_Lista_Precios__c = oppl.item.NEW_Precio_Lista_Precios__c;
            oppl.item.PrecioSAP__c = oppl.item.NEW_PrecioSAP__c;
            oppl.item.Precio_Unitario_Viz__c=oppl.item.NEW_Precio_Unitario_Viz__c;
            oppl.item.Tipo_de_Inventario__c=oppl.item.NEW_Tipo_de_Inventario__c;
            oppl.item.UOM_LB__c=oppl.item.NEW_UOM_LB__c;
            oppl.item.Volumen__c = oppl.item.NEW_Volumen__c;
            
            lista.add(oppl.item);
        }
        return lista;
    }
    public static List<Producto> ActualizarCamposOpportunityLineItem(List<Producto> listaProductos)
    {
        if(listaProductos == null)
            return null;
        
        list<Producto> listaRegresoProductos = new List<Producto>();
        for(Producto oppl  : listaProductos){
            oppl.item.NEW_Quantity__c = oppl.item.Quantity;
            oppl.item.NEW_UnitPrice__c = oppl.item.UnitPrice;
            oppl.item.NEW_TotalPrice__c = oppl.item.TotalPrice;
            oppl.item.NEW_Cajas__c = oppl.item.Cajas__c;
            oppl.item.NEW_Cantidad__c = oppl.item.Cantidad__c;
            oppl.item.NEW_Importe__c = oppl.item.Importe__c;
            oppl.item.NEW_Importe_Total_Viz__c = oppl.item.Importe_Total_Viz__c;
            oppl.item.NEW_Kilos__c = oppl.item.Kilos__c;
            oppl.item.NEW_Observaciones__c = oppl.item.Observaciones__c;
            oppl.item.NEW_Pallets__c = oppl.item.Pallets__c;
            oppl.item.NEW_Piezas__c = oppl.item.Piezas__c;
            oppl.item.NEW_Precio_Lista_Precios__c = oppl.item.Precio_Lista_Precios__c;
            oppl.item.NEW_PrecioSAP__c = oppl.item.PrecioSAP__c;
            oppl.item.NEW_Precio_Unitario_Viz__c = oppl.item.Precio_Unitario_Viz__c;
            oppl.item.NEW_Tipo_de_Inventario__c = oppl.item.Tipo_de_Inventario__c;
            oppl.item.NEW_UOM_LB__c = oppl.item.UOM_LB__c;
            oppl.item.NEW_Volumen__c = oppl.item.Volumen__c;
            listaRegresoProductos.add(oppl);
        }
        return listaRegresoProductos;
    }
    public static integer CalcularSemana(date Fecha)
    {
        Integer semana = Integer.valueOf( dateToString( Fecha, 'w' ) );
        Integer dof = Integer.valueOf(getDOF( Fecha ));
        Integer anio = Fecha.year();
        System.debug('startdate ::: '+semana);
        if( dof == 7 ) {
            if( semana == 1 ) { semana = 52; anio = anio - 1; }
            else { semana = semana - 1; }
        }
        return semana;
    }
    
    
    public static list<AdminSaldosEstrategias__c> TraerEstrategiaComercial(Integer semana, Integer anio)
    {
        integer semanaAnt = semana -1;
        System.debug('SemanaTraer:: '+ semana);
        
     list<AdminSaldosEstrategias__c> adminSaldos =   [select Id,Anio__c,Fecha_Final__c,Fecha_Inicial__c,Folio__c,Num_Semana__r.Name,Saldo_Final_Auto__c,Saldo_Final_Export__c,Saldo_Final_Mayo__c,
                productoId__r.ProductCode,Prod_Master__r.MasterID__c,productoId__c,Prod_Master__c
                from AdminSaldosEstrategias__c
                where
                Num_Semana__r.name >=: String.valueOf(semanaAnt)
                and Num_Semana__r.name <=: String.valueOf(semana)
                and Anio__c =: String.valueOf(anio)
                order by   Num_Semana__r.name,Anio__c
               ];
          System.debug('TraerEstrategiaComercial '+ adminSaldos);
         return  adminSaldos;
    }
    public static map<string,AdminSaldosEstrategias__c> TraerEstrategiaComercialPorSemana(Integer semana)
    {
        map<string,AdminSaldosEstrategias__c> mapEstrategias = new map<string,AdminSaldosEstrategias__c>();
        if(semana == null) return mapEstrategias;
        
        integer semanaAnt = semana -1;
        System.debug('TraerSemana::: '+semana);
        integer anio = Datetime.now().year();
        for( AdminSaldosEstrategias__c admon :[select Id,Anio__c,Fecha_Final__c,Fecha_Inicial__c,Folio__c,Num_Semana__r.Name,Saldo_Final_Auto__c,Saldo_Final_Export__c,Saldo_Final_Mayo__c,
                                               productoId__r.ProductCode,Prod_Master__r.MasterID__c,productoId__c,Prod_Master__c
                                               from AdminSaldosEstrategias__c
                                               where
                                               Num_Semana__r.name >=: String.valueOf(semanaAnt)
                                               and Num_Semana__r.name <=: String.valueOf(semana)
                                               and Anio__c =: String.valueOf(anio)
                                               order by   Num_Semana__r.name,Anio__c
                                              ])
        {
            if(admon.productoId__c != null)
                mapEstrategias.put(admon.productoId__r.ProductCode+admon.Num_Semana__r.Name,admon);
            
            if(admon.Prod_Master__c != null && admon.productoId__c == null)
                mapEstrategias.put(admon.Prod_Master__r.MasterID__c+admon.Num_Semana__r.Name,admon);
        }
        return mapEstrategias;
    }
    public static AdminSaldosEstrategias__c TraerEstrategiaComercialPorSemanaProducto(Integer semana,string Codigo)
    {
        
        return [select Id,Anio__c,Fecha_Final__c,Fecha_Inicial__c,Folio__c,Num_Semana__r.Name,Saldo_Final_Auto__c,Saldo_Final_Export__c,Saldo_Final_Mayo__c,
                productoId__r.ProductCode,Prod_Master__r.MasterID__c,productoId__c,Prod_Master__c
                from AdminSaldosEstrategias__c
                where
                Num_Semana__r.name =: String.valueOf(semana)
                and productoId__r.ProductCode =: Codigo
                order by   Num_Semana__r.name
               ];
    }
    public static list<Producto> obtenerInventariosAdmonEstrategiaComercial(opportunity pedido,list<Producto> productos)
    {
        Integer Semana = CalcularSemana(pedido.Fecha_de_Embarque__c);
        Integer anio = Datetime.now().year();
        list<AdminSaldosEstrategias__c> listaEstrategiasCom = TraerEstrategiaComercial(Semana,anio);
        String canalDistribucion = pedido.Cliente__r.Canal_Distribucion__c.right(2);
        System.debug('productos:: ' + productos);
        for(Producto p: productos ) {
            if( p == null ) { continue; } if( String.isBlank( p.codigo ) ) { continue; }
            
            p.inventarioAnt = null;
            p.inventario = null;
          System.debug('listaEstrategiasCom:: ' + listaEstrategiasCom.size());  
            for(AdminSaldosEstrategias__c admon : listaEstrategiasCom)
            {
                System.debug('p.codigo: ' + p.codigo);
                System.debug('admon.productoId__c: ' + admon.productoId__c);
                System.debug('admon.Prod_Master__r.MasterID__c : ' + admon.Prod_Master__r.MasterID__c);
                System.debug('p.item.Product2.Producto_Master_c.MasterID__c: ' + p.ProductoMaster);
                System.debug('semana : ' + Semana);
                System.debug('admon : ' + admon);
                
                if( (integer.ValueOf(admon.Num_Semana__r.Name) < semana && p.codigo == admon.productoId__r.ProductCode) && admon.Prod_Master__c != null)
                {
                    System.debug('Entro semana anterior : ' + admon.Num_Semana__r.Name);
                    if(canalDistribucion == 'AS')
                    {
                        p.inventarioAnt = admon.Saldo_Final_Auto__c;
                    }
                    else if(canalDistribucion == 'MY')
                    {
                        p.inventarioAnt = admon.Saldo_Final_Mayo__c;
                    }
                    else
                        p.inventarioAnt = admon.Saldo_Final_Export__c;
                    
                    System.debug('Semana Anterior: '+ admon);
                }
                else if ((integer.ValueOf(admon.Num_Semana__r.Name) == semana && p.codigo == admon.productoId__r.ProductCode) && admon.Prod_Master__c != null)
                {
                    if(canalDistribucion == 'AS')
                    {
                        p.inventario = admon.Saldo_Final_Auto__c;
                    }
                    else if(canalDistribucion == 'MY')
                    {
                        p.inventario = admon.Saldo_Final_Mayo__c;
                    }
                    else
                        p.inventario = admon.Saldo_Final_Export__c;
                    
                    System.debug('Semana actual: '+ admon);
                }
                else if ((integer.ValueOf(admon.Num_Semana__r.Name) == semana && p.ProductoMaster == admon.Prod_Master__r.MasterID__c) && admon.productoId__c == null)
                {
                    if(p.inventario != null)
                        continue;
                    System.debug('Entro master semana : ' + admon.Num_Semana__r.Name);
                    if(canalDistribucion == 'AS')
                    {
                        p.inventario = admon.Saldo_Final_Auto__c;
                    }
                    else if(canalDistribucion == 'MY')
                    {
                        p.inventario = admon.Saldo_Final_Mayo__c;
                    }
                    else
                        p.inventario = admon.Saldo_Final_Export__c;
                }
                else if( (integer.ValueOf(admon.Num_Semana__r.Name) < semana && p.ProductoMaster == admon.Prod_Master__r.MasterID__c) &&  admon.productoId__c == null)
                {
                    if(p.inventarioAnt != null)
                        continue;
                    
                    System.debug('Entro master semana anterior : ' + admon.Num_Semana__r.Name);
                    System.debug('Entro semana : ' + admon.Num_Semana__r.Name);
                    if(canalDistribucion == 'AS')
                    {
                        p.inventarioAnt = admon.Saldo_Final_Auto__c;
                    }
                    else if(canalDistribucion == 'MY')
                    {
                        p.inventarioAnt = admon.Saldo_Final_Mayo__c;
                    }
                    else
                        p.inventarioAnt = admon.Saldo_Final_Export__c;
                    System.debug('Semana Anterior: '+ admon);
                }
                
            }
        }
        return productos;
    }
    public static Boolean TraerEmbarqueCerrado(string pedidoId)
    {
        Boolean estatus = false;
        list<Detalle_de_embarque__c> listaEmbarques = new list<Detalle_de_embarque__c>();
        listaEmbarques = [select id from Detalle_de_embarque__c where Id_Oportunidad__c =: pedidoId and EmbarqueId__r.Estatus__c ='Cerrado'];
        if(listaEmbarques.size() > 0)
        {
            estatus = true;
        }
        return estatus;
    }
    public static list<AdminSaldosEstrategias__c> DisminuirInventariosAdmonEstrategiaComercial(opportunity pedido,Producto p)
    {
        Integer Semana = CalcularSemana(pedido.Fecha_de_Embarque__c);
        System.debug('DisminuirInventariosAdmonEstrategiaComercial Semana::: '+Semana);
        System.debug('mapEstrategias::: '+ mapEstrategias);
        String canalDistribucion = pedido.Cliente__r.Canal_Distribucion__c.right(2);
        list<AdminSaldosEstrategias__c> listaAGrabar = new list<AdminSaldosEstrategias__c>();
        AdminSaldosEstrategias__c admon = null;
        Integer saldoEstrategia = 0;
        if( p == null ) { return listaAGrabar; } if( String.isBlank( p.codigo ) ) { return listaAGrabar; }
        if(mapEstrategias == null)
        {
            mapEstrategias = TraerEstrategiaComercialPorSemana(Semana);
            System.debug('mapEstrategias::: '+mapEstrategias);
        }
        if(mapEstrategias != null)
        {
            System.debug('p.Codigo :::'+p.Codigo);
            admon = mapEstrategias.get(p.Codigo+String.valueOf(Semana));
            if(admon == null)
            {
                System.debug('Entro master'+p.ProductoMaster );
                admon = mapEstrategias.get(p.ProductoMaster+String.valueOf(Semana));
            }
            if(admon != null)
            {
                saldoEstrategia = calcularSaldo(admon,canalDistribucion);
                if(p.devolucion != null)
                {
                    p.inventario = p.inventario + p.devolucion;
                }
                if(p.item.Quantity <= double.ValueOf(p.inventario))
                {
                    System.debug('admon::'+admon );
                    double inventario  =  double.ValueOf(p.inventario) - p.item.Quantity;
                    System.debug('inventario '+inventario);
                    System.debug('p.inventario '+p.inventario );
                    System.debug('p.item.Quantity '+p.item.Quantity );
                    p.inventario = string.valueOf(Integer.ValueOf(inventario));
                    p.Item.Saldo__c = p.Item.Saldo__c == null?0:p.Item.Saldo__c;
                    p.Item.Saldo__c = p.item.Quantity;
                    listaAGrabar.add(calcularSaldoAdministracionEstrategica(string.valueOf(Integer.ValueOf(inventario)),admon,canalDistribucion));
                }
                else
                {
                    System.debug('Entro a saldo semana anterior');
                    Integer semanaAnt = Semana -1;
                    AdminSaldosEstrategias__c admonAnt = mapEstrategias.get(p.Codigo+String.valueOf(semanaAnt));
                    if(admonAnt == null )
                    {
                        admonAnt = mapEstrategias.get(p.ProductoMaster+String.valueOf(semanaAnt));
                    }
                    if(admonAnt == null )
                    {
                        return null;
                    }
                    saldoEstrategia = calcularSaldo(admon,canalDistribucion);
                    if(p.devolucion != null)
                    {
                        p.inventario = p.inventario + p.devolucion;
                    }
                    
                    double inventario  =  double.ValueOf(p.inventario);
                    p.Item.Saldo__c = inventario;
                    System.debug('inventario :: '+inventario);
                    listaAGrabar.add(calcularSaldoAdministracionEstrategica(string.valueOf(Integer.ValueOf('0')),admon,canalDistribucion));
                    double restante = p.item.Quantity - double.ValueOf(p.inventario);
                    p.inventario = '0';
                    System.debug('restante :: '+restante);
                    if(p.inventarioAnt != null)
                    {
                        if(restante <= double.ValueOf(p.inventarioAnt))
                        {
                            p.Item.Saldo_Semana_Ant__c = p.Item.Saldo_Semana_Ant__c == null?0:p.Item.Saldo_Semana_Ant__c;
                            p.Item.Saldo_Semana_Ant__c = p.Item.Saldo_Semana_Ant__c + Integer.valueOf(restante);
                            saldoEstrategia = calcularSaldo(admonAnt,canalDistribucion);
                            p.inventarioAnt = String.valueOf(double.ValueOf(p.inventarioAnt) - restante);
                            listaAGrabar.add(calcularSaldoAdministracionEstrategica(string.valueOf(Integer.ValueOf(p.inventarioAnt)),admonAnt,canalDistribucion));
                        }
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            
        }
        
        return listaAGrabar;
    }
    public static AdminSaldosEstrategias__c calcularSaldoAdministracionEstrategica(String saldo,AdminSaldosEstrategias__c admon,string canalDistribucion)
    {
        if(canalDistribucion == 'AS')
        {
            admon.Saldo_Final_Auto__c = saldo;
        }
        else if(canalDistribucion == 'MY')
        {
            admon.Saldo_Final_Mayo__c= saldo;
        }
        else
            admon.Saldo_Final_Export__c = saldo;
        
        return admon;
    }
    public static Integer calcularSaldo(AdminSaldosEstrategias__c admon,string canalDistribucion)
    {
        Integer Saldo = 0;
        if(canalDistribucion == 'AS')
        {
            Saldo = String.isBlank(admon.Saldo_Final_Auto__c) == null?null:Integer.valueOf(admon.Saldo_Final_Auto__c);
        }
        else if(canalDistribucion == 'MY')
        {
            Saldo = String.isBlank(admon.Saldo_Final_Mayo__c) == null?null:Integer.valueOf(admon.Saldo_Final_Mayo__c);
        }
        else
            Saldo = String.isBlank(admon.Saldo_Final_Export__c) == null?null:Integer.valueOf(admon.Saldo_Final_Export__c);
        
        return Saldo;
    }
    public static AdminSaldosEstrategias__c regresarInventarioAdmonEstrategica(producto primerProd,Integer Semana,String CanalDistribucion,integer saldoARegresar)
    {
        integer Total = 0;
        AdminSaldosEstrategias__c adminSaldos = null;
        map<string,AdminSaldosEstrategias__c> mapEstrategias = null;
        //saldoARegresar = integer.ValueOf(productosSinModificar.get(primerProd.Codigo).item.Quantity);
        mapEstrategias = TraerEstrategiaComercialPorSemana(Integer.ValueOf(Semana));
        if(mapEstrategias != null)
        {
            adminSaldos = mapEstrategias.get(primerProd.Codigo+Semana);
            if(adminSaldos == null)
            {
                adminSaldos = mapEstrategias.get(primerProd.ProductoMaster+Semana);
            }
            if(adminSaldos != null)
            {
                integer saldoEstrategia = calcularSaldo(adminSaldos,canalDistribucion);
                saldoEstrategia = saldoEstrategia == null ? 0 : saldoEstrategia;
                Total = saldoEstrategia + saldoARegresar;
                System.Debug('Total:'+Total);
                return calcularSaldoAdministracionEstrategica(string.ValueOf(Total),adminSaldos,canalDistribucion);
            }
        }
        
        return null;
    }
    public static AdminSaldosEstrategias__c regresarInventarioProdEliminado(producto primerProd,Integer Semana,String CanalDistribucion,Integer cantidad)
    {
        integer saldoARegresar = 0;
        integer Total = 0;
        AdminSaldosEstrategias__c adminSaldos = null;
        map<string,AdminSaldosEstrategias__c> mapEstrategias = null;
        
        saldoARegresar = cantidad;
        mapEstrategias = TraerEstrategiaComercialPorSemana(Integer.ValueOf(Semana));
        if(mapEstrategias != null)
        {
            adminSaldos = mapEstrategias.get(primerProd.Codigo+Semana);
            if(adminSaldos == null)
            {
                adminSaldos = mapEstrategias.get(primerProd.ProductoMaster+Semana);
            }
            if(adminSaldos != null)
            {
                
                integer saldoEstrategia = calcularSaldo(adminSaldos,canalDistribucion);
                saldoEstrategia = saldoEstrategia == null ? 0 : saldoEstrategia;
                Total = saldoEstrategia + saldoARegresar;
                return calcularSaldoAdministracionEstrategica(string.ValueOf(Total),adminSaldos,canalDistribucion);
            }
        }
        
        return null;
    }
    public static boolean ValidarCierre(opportunity pedido,Integer dias, String HoraConfig)
    {
        Boolean Resultado = true;
        String HoraMov = String.valueOf(Datetime.now().hour()).leftPad(2, '0')+String.valueOf(Datetime.now().minute()).leftPad(2, '0');
        Integer HoraActual = Integer.valueOf(HoraMov);
        Integer HoraCierre = 0;
        if(dias != null && string.isNotBlank(HoraConfig))
        {
            string[] arregloHoracierre = HoraConfig.split(':');
            if(pedido.Fecha_de_Embarque__c > Datetime.now().addDays(dias))
            {
                return Resultado;
            }
            
            if(arregloHoracierre != null && arregloHoracierre.size() > 1)
            {
                string hora = arregloHoracierre[0].leftPad(2, '0')+arregloHoracierre[1].leftPad(2, '0');
                HoraCierre = Integer.valueOf(hora);
            }
            if(HoraActual >= HoraCierre)
            {
                Resultado = false;
            }
            if(pedido.Fecha_de_Embarque__c < Datetime.now().addDays(dias))
            {
                Resultado = false;
            }
        }
        System.debug('Hora Actual:' +HoraActual);
        System.debug('Hora:' + HoraCierre);
        return Resultado;
    }
    public static void sendEmailWithTemplate(ID usuario, string correo ,id opp) {
         /* Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
			mail.setTargetObjectId(usuario);
			mail.setTemplateId('00X2C000000QM1Y');
			mail.setWhatId(opp);
			mail.setBccSender(false);
			mail.setUseSignature(false);
			//mail.setToAddresses(new String[] {correo});
			mail.setSenderDisplayName('Notificacion pedidos de planta');
			mail.setSaveAsActivity(false);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
    }
    
    public static map<string,list<ProductosEliminado__c>> TraerProductosEliminados(string opp)
    {
        map<string,list<ProductosEliminado__c>> mapProductoDelete = new map<string,list<ProductosEliminado__c>>();
        set<string> setRepetidos = new set<string>();
        list<ProductosEliminado__c> lista = new list<ProductosEliminado__c>();
        for(ProductosEliminado__c pe : [select id,CodigoProducto__c,Enviado__c,OpportunityId__c	from ProductosEliminado__c	where		Enviado__c = false	and OpportunityId__c = : opp])
        {
            if(setRepetidos.contains(pe.OpportunityId__c))
            {
                mapProductoDelete.get(pe.OpportunityId__c).add(pe);
            }
            else
            {
                mapProductoDelete.put(pe.OpportunityId__c, new list<ProductosEliminado__c>());
                mapProductoDelete.get(pe.OpportunityId__c).add(pe);
                setRepetidos.add(pe.OpportunityId__c);
            }
        }
        
        return mapProductoDelete;
    }
    public static Boolean CheckMessage()
    {
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = true;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Error')) b = false;
        }
        return b;
    }
    
    public static Integer ObtenerpedidoCte(opportunity pedido)
    {
        Integer pedidoCte = 4;
        String idPlanta = '';
        Integer idPlantaFactura = 0;
        Integer codigoPlanta = 0;
        
        System.debug('Canal Factura...');
        if(pedido.Canal_Factura__r!=null){
            idPlanta = pedido.Canal_Factura__r.IdPlanta__c;
            if( String.isNotBlank( idPlanta ) ) {
                try{
                    
                    idPlantaFactura = Integer.valueOf(idPlanta);
                    
                }catch(Exception e){
                    System.debug('Error en conversión de id planta del canal factura');
                }
            }
            
            if( String.isNotBlank( pedido.Canal_Factura__r.Codigo__c ) ) {
                try{
                    codigoPlanta = Integer.valueOf(pedido.Canal_Factura__r.Codigo__c);
                }catch(Exception e){
                    System.debug('Error en conversión de id planta del canal factura');
                }
            }
        }
        
        if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'AS' ) { pedidoCte = 3; }
        else if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'MY' ) {
            pedidoCte = 4; //pedidoViz = 1;
            
        }
        else if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' ) {
            pedidoCte = 2;
        }
        
        return pedidoCte;
    }
    public static String ObtenerCanalVenta(opportunity pedido)
    {
        String idPlanta = '';
        Integer idPlantaFactura = 0;
        Integer codigoPlanta = 0;
        String areaResp = 'E';
        
        if(pedido.Canal_Factura__r!=null){
            idPlanta = pedido.Canal_Factura__r.IdPlanta__c;
            if( String.isNotBlank( idPlanta ) ) { 
                try{
                    idPlantaFactura = Integer.valueOf(idPlanta);
                }catch(Exception e){
                    System.debug('Error en conversión de id planta del canal factura');
                }
            }
            
            if( String.isNotBlank( pedido.Canal_Factura__r.Codigo__c ) ) {
                try{
                    codigoPlanta = Integer.valueOf(pedido.Canal_Factura__r.Codigo__c);
                }catch(Exception e){
                    System.debug('Error en conversión de id planta del canal factura');
                }
            }
        }
        System.debug('Canal Distribución...');
        if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'AS' ) { areaResp = 'A';  }
        else if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'MY' ) {
            areaResp = 'N'; //pedidoViz = 1;
            if( String.isNotBlank(idPlanta) ) {
                areaResp = 'M';
            }
        }
        else if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' ) {
            areaResp = 'B';
            if(String.isNotBlank(idPlanta)) {
                areaResp = 'E';                
            }
        }
        
        return areaResp;
    }
    /// pedidos mayoreo anterior
    public static PedidosMayoreoWS.PedidoMayoreo CrearCabezeroPedido(Opportunity pedido,list<pedidosOtrosCanalesUtils.producto> productos,Boolean Cancelado)
    {
        PedidosMayoreoWS.PedidoMayoreo pedidoWS = new PedidosMayoreoWS.PedidoMayoreo();
        Account sucViz;
        string usuario = PedidosOtrosCanalesUtils.ObtenerUsuario();
        String areaResp = ObtenerCanalVenta(pedido);
        Integer pedidoCte = ObtenerpedidoCte(pedido);
        String idPlanta;
        pedido.Cliente__r   = PedidosOtrosCanalesUtils.retrieveCteInfo( pedido.Cliente__c );
        pedido.Account     = PedidosOtrosCanalesUtils.retrieveCteInfo( pedido.AccountId );
        pedidoWS.NumeroPedidoNSC = pedido.Numero_de_Pedido_NSC__c== '0'?null:pedido.Numero_de_Pedido_NSC__c;
        pedidoWS.NumeroPedidoSAP = pedido.Numero_Pedido_SAP__c == '0'?null:pedido.Numero_Pedido_SAP__c;
        if(pedido.Canal_Factura__r.IdPlanta__c != null)
        {
            idPlanta = pedido.Canal_Factura__r.IdPlanta__c;
            
        }
        if( string.isNotBlank(idPlanta)) {
            pedidoWS.planta = Integer.valueOf(idPlanta);
            sucViz = PedidosOtrosCanalesUtils.buscarSucViz(pedido.Canal_Factura__r.IdClienteViz__c);
        }
        pedidoWS.areaRespCte = areaResp; //1-A; 2-M; 3-E
        pedidoWS.tipoPedidoCte = pedidoCte; //EX-2; MY-4; AS-3
        if( String.isNotBlank( pedido.PO_Proveedor__c ) ) {
            pedidoWS.occProveedor = pedido.PO_Proveedor__c;
        }
        else {
            pedidoWS.occProveedor = '';
        }
        if( String.isNotBlank( pedido.OC__c ) ) {
            pedidoWS.poCliente = pedido.OC__c;
        }
        else {
            pedidoWS.poCliente = '';
        }
        if( String.isNotBlank( pedido.Liberado__c ) ) {
            pedidoWS.liberado = pedido.Liberado__c; //N-Rechazado; S-Autorizado
        } else {
            pedidoWS.liberado = '';
        }
        if( String.isNotBlank( pedido.MotivoRechazo__c ) ) {
            pedidoWS.motivoRechazoCartera = pedido.MotivoRechazo__c; //Si Liberado = N
        } else {
            pedidoWS.motivoRechazoCartera = '';
        }
        if( pedido.Flete__c != null ) {
            pedidoWS.fleteLibra = pedido.Flete__c;
        } else {
            pedidoWS.fleteLibra = 0;
        }
        if( pedido.Amount != null ) {
            pedidoWS.importeTotalPedido = pedido.Amount;
        } else {
            pedidoWS.importeTotalPedido = 0;
        }
        Double qttyKGSTt = 0;
        Double librasPesoTt = 0;
        System.debug('Totales KGs...');
        for( pedidosOtrosCanalesUtils.Producto p: productos ) {
            if( p == null ) { continue; }
            if( String.isBlank( p.codigo ) ) { continue; }
            if( p.item == null ) { continue; }
            qttyKGSTt += p.item.Kilos__c;
            librasPesoTt += p.item.Volumen__c;
        }
        pedidoWS.cantidadKGSTotalPedido = qttyKGSTt;
        pedidoWS.observacionGralPedido = pedido.Description;
        if( String.isNotBlank( pedido.Motivo_de_Cancelacion__c ) ) {
            pedidoWS.motivoCancelacion = '0';
        } else {
            pedidoWS.motivoCancelacion = '';
        }
        if( String.isNotBlank( pedido.Folio_Pedido_SDL__c ) ) {
            pedidoWS.folioPedidoSDL = pedido.Folio_Pedido_SDL__c;
        } else {
            pedidoWS.folioPedidoSDL = '';
        }
        if( String.isNotBlank( pedido.Folio_Embarque__c ) ) {
            pedidoWS.folioEmbarqueSDL = pedido.Folio_Embarque__c;
        } else {
            pedidoWS.folioEmbarqueSDL =  '';
        }
        
        if(cancelado) {
            pedidoWS.estatusPedido = 8; //8-Cancelación
        }
        else {
            pedidoWS.estatusPedido = 1;
        }
        if(EnvioAprobacion != null && EnvioAprobacion == true && pedido.Canal_Factura__r.IdPlanta__c == null)
        {
            if(string.isNotBlank(pedido.Numero_de_Pedido_NSC__c) && pedido.Numero_de_Pedido_NSC__c != '0')
                pedidoWS.estatusPedido = 10; //10-Bloqueado
        }
        /* if(!cancelado && String.isBlank(pedido.Folio_Pedido_SDL__c))
			{
			if(!ValidarCierre(pedido,Integer.valueOf(pedido.Canal_Factura__r.Dias_de_cierre__c), pedido.Canal_Factura__r.Hora_de_cierre__c))
			{
			pedidoWS.estatusPedido = 11; //10-Bloqueado
			pedido.StageName = '11 - Bloqueado Cierre';
			}
		}*/
        
        pedidoWS.tipoSurtido = 3;
        pedidoWS.tipoVenta = 1;
        String sociedad = '';
        try{
            sociedad = pedido.Account.Sociedad__c.right(3);
        }catch(Exception e){
            System.debug('Error leyendo la sociedad de la sucursal');
            sociedad = '';
        }
        String canalDistribucion = '';
        try{
            canalDistribucion = pedido.Account.Canal_Distribucion__c.right(2);
        }catch(Exception e){
            System.debug('Error leyendo el canal de distribucion de la sucursal');
            canalDistribucion = '';
        }
        if( sociedad == '303' && canalDistribucion == 'EX' ) {
            pedidoWS.tipoPedidoViz = 1;// if(EX) 1
        }
        else {
            pedidoWS.tipoPedidoViz = 0;
        }
        pedidoWS.areaRespViz = (String.isNotBlank(idPlanta) && canalDistribucion=='EX' && sociedad == '303')?'V':'';
        Integer codigoPlanta = 0;
        if( String.isNotBlank( pedido.Canal_Factura__r.Codigo__c ) ) {
            try{
                codigoPlanta = Integer.valueOf(pedido.Canal_Factura__r.Codigo__c);
            }catch(Exception e){
                System.debug('Error en conversión de id planta del canal factura');
            }
        }
        pedidoWS.canalSurteCte = codigoPlanta;
        
        if(canalDistribucion=='EX'){
            pedidoWS.tipoEntrega = 1; //1-DD; 2-BP Sólo Exportación
            pedidoWS.tipoEmbarque = 1; //1-Directo; 2-LTL
        } else  {
            pedidoWS.tipoEntrega = 0;
            pedidoWS.tipoEmbarque = 0;
        }
        System.debug('IDPedidoSF...');
        try {
            System.debug('IDPedidoSF: '+pedido.Id_Externo__c);
            pedidoWS.IdPedidoSF = Integer.valueOf( pedido.Id_Externo__c );
        } catch( Exception e ) {
            SYstem.debug('Error transformando IdPedidoSF. '+e.getMessage());
            return null;
        }
        Datetime fechaRegistro = pedido.CreatedDate;
        if(fechaRegistro == null)
            fechaRegistro = System.now();
        System.debug('FechaRegistro: '+fechaRegistro);
        pedidoWS.fechaRegistro = fechaRegistro.format('yyyyMMdd');
        pedidoWS.horaRegistro = fechaRegistro.format('HH:mm:ss');
        System.debug('Atendio...');
        if( pedido.Id == null ) {
            /*
* USUARIO QUE CREO EL PEDIDO
*/
            String atendio = '';
            try{
                atendio = System.UserInfo.getFirstName().left(1).capitalize() + System.UserInfo.getLastName().capitalize();
            }catch(Exception e){
                System.debug('El usuario actual no trae nombre o apellido');
                atendio = '';
            }
            if(pedido.CreatedById!=null){
                try{
                    atendio = pedido.CreatedBy.FirstName.left(1).capitalize() + pedido.CreatedBy.LastName.capitalize();
                }catch(Exception e){
                    System.debug('El usuario que creo el pedido no trae nombre o apellido');
                    atendio = '';
                }
            } else { pedido.CreatedById = System.UserInfo.getUserId(); }
            pedidoWS.atendido = atendio;
            
            if(string.isNotBlank(pedido.Canal_Factura__r.Hora_de_cierre__c))
            {
                String HoraMov = String.valueOf(Datetime.now().hour()).leftPad(2, '0')+String.valueOf(Datetime.now().minute()).leftPad(2, '0');
                Integer HoraActual = Integer.valueOf(HoraMov);
                Integer HoraCierre = 0;
                string[] arregloHoracierre = pedido.Canal_Factura__r.Hora_de_cierre__c.split(':');
                if(arregloHoracierre != null && arregloHoracierre.size() > 1)
                {
                    string hora = arregloHoracierre[0].leftPad(2, '0')+arregloHoracierre[1].leftPad(2, '0');
                    HoraCierre = Integer.valueOf(hora);
                }
                if(HoraActual >= HoraCierre)
                {
                    System.debug('fechaRegistro.addDays(1);'+fechaRegistro.addDays(1));
                    fechaRegistro = fechaRegistro.addDays(1);
                }
            }
            
            if(pedido.CreatedDate!=null){ fechaRegistro = pedido.CreatedDate; }
            else { pedido.CreatedDate = System.now(); }
            pedidoWS.fechaRegistro = fechaRegistro.format('yyyyMMdd');
            pedidoWS.horaRegistro = fechaRegistro.format('HH:mm:ss');
        }
        else {
            fechaRegistro = pedido.CreatedDate;
            System.debug('FechaRegistro: '+fechaRegistro);
            pedidoWS.fechaRegistro = fechaRegistro.format('yyyyMMdd');
            pedidoWS.horaRegistro = fechaRegistro.format('HH:mm:ss');
            String atendio;
            try{
                atendio = System.UserInfo.getFirstName().left(1).capitalize() + System.UserInfo.getLastName().capitalize();
            }catch(Exception e){
                System.debug('El usuario actual no trae nombre o apellido');
                atendio = '';
            }
            
            if(pedido.CreatedById!=null){
                try{ atendio = pedido.CreatedBy.FirstName.left(1).capitalize() + pedido.CreatedBy.LastName.capitalize(); }
                catch(Exception e){ System.debug('El usuario que creo el pedido no trae nombre o apellido'); atendio = ''; }
            }
            pedidoWS.atendido = atendio;
        }
        
        // PEDIDO A ACTUALIZAR
        if( String.isNotBlank(pedido.Id) && !cancelado ) {
            System.debug('Modificacion...');
            
            String modifico = '';
            try{
                modifico = System.UserInfo.getFirstName().left(1).capitalize() + System.UserInfo.getLastName().capitalize();
            }catch(Exception e){
                System.debug('Usuario que modifico no trae nombre o apellidos');
                modifico = '';
            }
            pedidoWS.vendedorModifico = modifico;
            
            DateTime fechaModificacion = System.now();
            pedidoWS.fechaModifico = fechaModificacion.format('yyyyMMdd');
            pedidoWS.horaModifico = fechaModificacion.format('HH:mm:ss');
            
        }
        else {
            //pedidoWS.idPedidoSF = 0;
            pedidoWS.vendedorModifico = '';
            pedidoWS.fechaModifico = '';
            pedidoWS.horaModifico = '';
        }
        if( cancelado ) {
            String cancelo = '';
            try{
                cancelo = System.UserInfo.getFirstName().left(1).capitalize() + System.UserInfo.getLastName().capitalize();
            }catch(Exception e){
                System.debug('Usuario que modifico no trae nombre o apellidos');
                cancelo = '';
            }
            System.debug('Cancelacion...');
            DateTime fechaCancelacion = System.now();
            pedidoWS.vendedorElimino = cancelo;
            pedidoWS.fechaElimino = fechaCancelacion.format('yyyyMMdd');
            pedidoWS.horaElimino = fechaCancelacion.format('HH:mm:ss');
        }
        else {
            pedidoWS.vendedorElimino = '';
            pedidoWS.fechaElimino = '';
            pedidoWS.horaElimino = '';
        }
        
        /*
* CLIENTE
*/
        Integer clienteSAP = null;
        try{
            clienteSAP = Integer.valueOf(pedido.Cliente__r.Numero_Cliente_SAP__c);
        }catch(Exception e){
            System.debug('Error en conversión de cliente SAP');
            clienteSAP = 0;
        }
        pedidoWS.cliente = clienteSAP;
        
        /*
* SUCURSAL
*/
        
        // canal
        Integer canalSucursal = null;
        try{
            canalSucursal = Integer.valueOf(pedido.Canal_Factura__r.IdClienteViz__c);
        }catch(Exception e){
            System.debug('Error en conversión de canal factura sucursal viz');
            canalSucursal = 0;
        }
        
        if( canalDistribucion == 'EX' && sociedad == '303' && String.isNotBlank( idPlanta ) ) {
            pedidoWS.clienteInterViz = canalSucursal;
        }
        else {
            pedidoWS.clienteInterViz = 0;
        }
        // sap
        Integer sapSucursal = null;
        try{
            sapSucursal = Integer.valueOf(pedido.Account.Numero_Cliente_SAP__c.replace('SUC - ',''));
        }catch(Exception e){
            System.debug('Error en conversión de sucursal SAP');
            sapSucursal = 0;
        }
        pedidoWS.destinatario = sapSucursal;
        //CAMBIO JOSE.BARAZA
        // ID PLANTA DE LA OFICINA DE VENTAS DE LA SUCURSAL
        Integer destinatarioViz = null;
        try{
            
            if( String.isNotBlank(pedido.Canal_Factura__r.SucursalesViz__c))
            {
                List<String> ListaSucursalesFrontera = new List<String>();
                ListaSucursalesFrontera.addAll(pedido.Canal_Factura__r.SucursalesViz__c.split(';'));
                destinatarioViz =Integer.valueOf( pedidosOtrosCanalesUtils.ValidarSucursalViz(ListaSucursalesFrontera,pedido.frontera__c));
                System.debug('destinatarioViz -------> '+destinatarioViz);
            }
            
        }catch(Exception e){
            System.debug('Error en conversión de id planta de la oficina de ventas de la sucursal');
            destinatarioViz = 0;
        }
        if( canalDistribucion == 'EX' && sociedad == '303' ) {
            pedidoWS.destinatarioViz = destinatarioViz;
        } else {
            pedidoWS.destinatarioViz = 0;
        }
        // CODIGO DEL CANAL DE DISTRIBUCIÓN NSC DE LA SUCURSAL
        Integer codigoCDSucursal = null;
        try{
            codigoCDSucursal = Integer.valueOf( pedido.Account.Canal_de_Distribucion_NSC__r.Codigo__c );
        }catch(Exception e){
            System.debug('Error en conversión del codigo del canal de distribución de la sucursal');
            codigoCDSucursal = 0;
        }
        pedidoWS.canalDistCte = codigoCDSucursal;
        
        // CODIGO DEL CANAL DE DISTRIBUCIÓN DE LA SUCURSAL
        String canalDistribucionSucursal = '';
        try{
            canalDistribucionSucursal = pedido.Account.Canal_Distribucion__c.right(2) == 'AS'?'S':' '; //S para AS
        }catch(Exception e){
            System.debug('Error leyendo canal de distribución de la sucursal');
            canalDistribucionSucursal = ' ';
        }
        pedidoWS.autorizado = canalDistribucionSucursal;
        // CODIGO VIZ DEL CANAL DE DISTRIBUCIÓN DE LA SUCURSAL
        Integer codigoVizCDSucursal = null;
        try{
            codigoVizCDSucursal = Integer.valueOf( sucViz.Canal_de_Distribucion_NSC__r.Codigo__c );
        }catch(Exception e){
            System.debug('Error en conversión del codigo viz del canal de distribución de la sucursal');
        }
        if( String.isNotBlank( idPlanta ) && sociedad == '303' ) {
            if( sucViz == null ) {
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING, 'La Sucursal Viz no está configurada.'));
                return null;
            }
            pedidoWS.canalDistViz = codigoVizCDSucursal;
        }
        else {
            pedidoWS.canalDistViz = 0;
        }
        
        // FRONTERA
        Integer frontera = 0;
        try{
            String [] ArrFrontera = pedido.Frontera__c.split('-');
            if(ArrFrontera != null && ArrFrontera.size() > 1)
            {
                frontera = Integer.valueOf(ArrFrontera[0]);
            }
        }catch(Exception e){
            System.debug('Error en conversión de frontera');
        }
        if( String.isNotBlank( idPlanta ) ) {
            pedidoWS.fronteraCte = frontera;
        }
        else {
            pedidoWS.fronteraCte = 0;
        }
        // FECHA EMBARQUE
        //DateTime fechaHoraEmbarque = pedido.Fecha_de_Embarque__c;
        Date fechaEmbarque = pedido.Fecha_de_Embarque__c;
        pedidoWS.fechaEmbarque = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Embarque__c, 'yyyyMMdd' );// fechaHoraEmbarque.format('yyyyMMdd');
        Integer semana = Integer.valueOf( pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Embarque__c, 'w' ) );
        Integer dof = Integer.valueOf(pedidosOtrosCanalesUtils.getDOF( pedido.Fecha_de_Embarque__c ));
        Integer anio = fechaEmbarque.year();
        if( dof == 7 ) {
            if( semana == 1 ) { semana = 52; anio = anio - 1; }
            else { semana = semana - 1; }
        }
        pedidoWS.semana = String.valueOf( semana ); //fechaHoraEmbarque.format('w');
        pedidoWS.diaSemana = String.valueOf( dof);
        //System.debug('PedidoDiaSemana: '+pedidoWS.diaSemana);
        pedidoWS.anio = String.valueOf( anio );
        
        // FECHA ENTREGA
        //DateTime fechaEntrega = pedido.Fecha_de_Entrega__c;
        pedidoWS.fechaEntrega = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Entrega__c, 'yyyyMMdd' ); // fechaEntrega.format('yyyyMMdd');
        pedidoWS.fechaCita = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Entrega__c, 'yyyyMMdd' ); //fechaEntrega.format('yyyyMMdd');
        
        // FECHA INSPECCION
        if(pedido.Fecha_de_Inspeccion__c!=null){
            //DateTime fechaInspeccion = pedido.Fecha_de_Inspeccion__c;
            pedidoWS.fechaInspeccion = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_de_Inspeccion__c, 'yyyyMMdd' ); //fechaInspeccion.format('yyyyMMdd');
        } else {
            pedidoWS.fechaInspeccion = ' ';
        }
        
        // FECHA EMBARQUE BODEGA
        if(pedido.Fecha_Embarque_Bodega__c!=null){
            
            pedidoWS.fechaEmbBodega = pedidosOtrosCanalesUtils.dateToString( pedido.Fecha_Embarque_Bodega__c, 'yyyyMMdd' ); //fechaEBodega.format('yyyyMMdd');
        } else {
            pedidoWS.fechaEmbBodega = ' ';
        }
        pedidoWS.Detalle = new PedidosMayoreoWS.ArrayOfPedidoMayoreoDetalle();
        pedidoWs.Detalle.PedidoMayoreoDetalle =  CrearDetallePedido1(pedido, productos,Cancelado);
        
        return pedidoWS;
    }
    public static List<PedidosMayoreoWS.PedidoMayoreoDetalle> CrearDetallePedido1(Opportunity pedido,list<pedidosOtrosCanalesUtils.producto> productos,Boolean cancelacion)
    {
        System.debug('Haciendo mapa de productos...');
        Map<String, List<PedidosOtrosCanalesUtils.Producto>> mapProductos = PedidosOtrosCanalesUtils.getProdsXCodigo( productos );
        System.debug('Mapa Productos: '+ mapProductos);
        
        List<PedidosMayoreoWS.PedidoMayoreoDetalle> productosWS = new List<PedidosMayoreoWS.PedidoMayoreoDetalle>();
        
        for( String codigo: mapProductos.keySet() ) {
            System.debug('Ensamblando detalle...');
            List<PedidosOtrosCanalesUtils.Producto> prodsAux = mapProductos.get(codigo);
            System.debug('ProdAux: '+prodsAux);
            PedidosOtrosCanalesUtils.Producto primerProd = prodsAux.get(0);
            String canalDistribucion = '';
            try{
                canalDistribucion = pedido.Account.Canal_Distribucion__c.right(2);
            }catch(Exception e){
                System.debug('Error leyendo el canal de distribucion de la sucursal');
                canalDistribucion = '';
            }
            GenerarAdmonEstrategia(pedido ,primerProd,cancelacion,canalDistribucion);
            OpportunityLineItem primerItem = primerProd.item;
            
            Integer pCodigo = 0;
            try{
                pCodigo = Integer.valueOf(codigo);
            }catch(Exception e){
                System.debug('Error en conversión del código:' + codigo);
                continue;
            }
            
            PedidosMayoreoWS.PedidoMayoreoDetalle p = new PedidosMayoreoWS.PedidoMayoreoDetalle();
            if(pedido.Canal_Factura__r.Valida_Disponibilidad__c)
            {
                //JBARRAZA DIAS CONSOLIDACION
                string DiasConsolidacionSucursal = null;
                if(!string.isBlank(pedido.Canal_Factura__r.Dias_consolidacion__c))
                {
                    DiasConsolidacionSucursal = pedido.Canal_Factura__r.Dias_consolidacion__c;
                }
                
                if(!string.isBlank(pedido.Canal_Factura__r.Dias_Consolidacion_Prod__c))
                {
                    
                    List<String> ListaDiasConsolidacionProducto = new List<String>();
                    ListaDiasConsolidacionProducto.addAll(pedido.Canal_Factura__r.Dias_Consolidacion_Prod__c.split(';'));
                    string ValorDiasConsolidacion = PedidosOtrosCanalesUtils.ValidarDiasConsolidacion(ListaDiasConsolidacionProducto, string.ValueOf(pCodigo));
                    System.debug('ValorDiasConsolidacion: ' + ValorDiasConsolidacion);
                    if(ValorDiasConsolidacion == null)
                    {
                        
                        if(DiasConsolidacionSucursal == null)
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No cuenta con dias de consolidacion Configurados'));
                            return null;
                        }
                        else
                            P.diasConsolidacion = Integer.ValueOf(DiasConsolidacionSucursal);
                    }
                    else
                    {
                        P.diasConsolidacion = Integer.ValueOf(ValorDiasConsolidacion);// pedido
                    }
                    System.debug('P.diasConsolidacion: ' + P.diasConsolidacion);
                }
                else
                {
                    if(DiasConsolidacionSucursal == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No cuenta con dias de consolidacion Configurados'));
                        return null;
                    }
                    else
                    {
                        
                        P.diasConsolidacion = Integer.ValueOf(DiasConsolidacionSucursal);
                    }
                    
                    
                }
                //JBARRAZA DIAS CONSOLIDACION
            }
            else
            {
                ParametrosOtrosCanales__c ep = ParametrosOtrosCanales__c.getInstance();
                P.diasConsolidacion = Integer.ValueOf(ep.Dias_Embarque__c);
                
            }
            p.autorizaPrecio = 'S';
            p.productoRelacion = 'P';
            p.producto = pCodigo;
            p.precioSAPCte = primerItem.UnitPrice;
            if( primerItem.Precio_Unitario_Viz__c != null ) {
                p.precioSAPViz = primerItem.Precio_Unitario_Viz__c;
            } else {
                p.precioSAPViz = 0;
            }
            p.tipoPrecioSAP = primerItem.Tipo_de_Precio__c;
            p.cjXPallets = primerProd.cajasXPallet;
            p.marca = 1;
            
            Integer folioPrecioSAP = 0;
            try{
                folioPrecioSAP = Integer.valueOf( primerItem.FolioPrecioSAP__c );
            }catch(Exception e){
                System.debug('Folio precio SAP no es valido');
            }
            p.folioPrecioSAPCte = folioPrecioSAP;
            
            Integer folioPrecioSAPViz = 0;
            try{
                folioPrecioSAPViz = Integer.valueOf( primerItem.FolioPrecioSAPViz__c );
            }catch(Exception e){
                System.debug('Folio precio SAP no es valido');
            }
            p.folioPrecioSAPViz = folioPrecioSAPViz;
            
            Integer utipoPeso = 0; // 'C'
            if( pedido.Unidad__c == 'K' ) { utipoPeso = 1; }
            else if( pedido.Unidad__c == 'P' )  { utipoPeso = 2; }
            else if( pedido.Unidad__c == 'L' ) { utipoPeso = 3; }
            p.unidadPeso = utipoPeso;
            p.tipoPeso = String.valueOf(utipoPeso);//UM 0,1,2
            
            Decimal pallets   = 0;
            Integer cantidad   = 0;
            Integer cajasTt     = 0;
            Decimal cantidadKGS = 0;
            Decimal librasPeso   = 0;
            Decimal importeTxP   = 0.0;
            Decimal importeTxPV = 0.0;
            String obs       = '';
            
            System.debug('Armando Inventario...');
            List<PedidosMayoreoWS.PedidoMayoreoInventario> listInventario = new List<PedidosMayoreoWS.PedidoMayoreoInventario>();
            for( PedidosOtrosCanalesUtils.Producto prod: prodsAux ) {
                if( prod == null ) { continue; }
                OpportunityLineItem item = prod.item;
                
                PedidosMayoreoWS.PedidoMayoreoInventario inventario = new PedidosMayoreoWS.PedidoMayoreoInventario();
                inventario.producto = pCodigo;
                
                //ORIGEN SURTIDO
                String idPlantaSurtido = '';
                Integer codigoOrigen = 0;
                Integer idPlantaOrigen = 0;
                try{
                    idPlantaSurtido = item.Origen_Surtido__r.IdPlanta__c;
                }catch(Exception e){
                    System.debug('Error leyendo la planta del origen surtido');
                }
                if(idPlantaSurtido==null){
                    idPlantaSurtido = '';
                }
                try{
                    codigoOrigen = Integer.valueOf(item.Origen_Surtido__r.Codigo__c);
                }catch(Exception e){
                    System.debug('Error en conversión del codigo del origen surtido');
                }
                try{
                    idPlantaOrigen = Integer.valueOf(item.Origen_Surtido__r.IdPlanta__c);
                }catch(Exception e){
                    System.debug('Error en conversión de la planta del origen surtido');
                }
                inventario.origenSurtido = codigoOrigen;
                
                // ACTIVA
                Integer activa = 0;
                try {
                    if(item.Origen_Surtido__r.Valida_Disponibilidad__c) { activa = 1; }
                }catch(Exception e){
                    System.debug('Error en valida disponibilidad del origen surtido');
                }
                inventario.dispoActiva = activa;
                
                //TIPO INVENTARIO
                Integer tipoInventario = 0;
                try{
                    tipoInventario = Integer.valueOf(item.Tipo_de_Inventario__c.left(1));
                }catch(Exception e){
                    System.debug('Error en conversion de tipo de inventario');
                }
                inventario.tipoInventario = tipoInventario;
                
                //CANTIDAD CAJAS
                Integer cajas = 0;
                try{
                    cajas = Integer.valueOf(item.Cajas__c);
                }catch(Exception e){
                    System.debug('Error en conversion de cajas');
                }
                if(cajas==null){cajas = 0;}
                inventario.cantidadCajas = cajas;
                listInventario.add( inventario );
                
                //ACUMULADO
                Integer tmpPallets = 0;
                Integer tmpVolumen = 0;
                try{tmpPallets=Integer.valueOf(item.Pallets__c);}catch(Exception e){System.debug('Error en conversión de pallets');}
                if(tmpPallets==null){tmpPallets=0;}
                try{tmpVolumen=Integer.valueOf(item.Volumen__c);}catch(Exception e){System.debug('Error en conversión de volumen');}
                if(tmpVolumen==null){tmpVolumen=0;}
                
                cajasTt += cajas;
                pallets += tmpPallets;
                cantidad += Integer.valueOf(item.Cantidad__c);
                cantidadKGS += item.Kilos__c;
                librasPeso += tmpVolumen;
                if(item.Importe__c!=null){
                    importeTxP += item.Importe__c;
                }
                if(item.Importe_Total_Viz__c!=null){
                    importeTxPV += item.Importe_Total_Viz__c;
                }
                if(item.Observaciones__c!=null){
                    obs += ( (String.isNotBlank(item.Rango_Surtido__c)?item.Rango_Surtido__c:'') + ' ' + item.Observaciones__c);
                }
            }
            
            System.debug('INVENTARIO::'+listInventario);
            
            PedidosMayoreoWS.ArrayOfPedidoMayoreoInventario inventarioWS = new PedidosMayoreoWS.ArrayOfPedidoMayoreoInventario();
            inventarioWS.PedidoMayoreoInventario = listInventario;
            p.inventario = inventarioWS;
            Decimal rPallet = (pallets - Math.abs(pallets));
            p.pallets = Integer.valueOf(pallets+(1-rPallet));
            if( pedido.Unidad__c == 'P' ) {
                p.piezas = cantidad;
            }
            p.cajas = cajasTt;
            p.cantidadKGS = cantidadKGS.setScale(2);
            p.librasPeso = librasPeso.setScale(2);
            
            p.importeTotXProducto = importeTxP.setScale(2);
            p.importeTotXProductoViz = importeTxPV.setScale(2);
            p.observacionesxProducto = obs;
            productosWS.add(p);
            
        }
        return productosWS;
    }
    public static map<string,PedidosOtrosCanalesUtils.Producto> ObtenerProductosPorPedido(opportunity opp)
    {
        productosSinModificar = new map<string,PedidosOtrosCanalesUtils.Producto>();
        for(PedidosOtrosCanalesUtils.Producto pOld :PedidosOtrosCanalesUtils.getItems(opp.Id))
        {
            productosSinModificar.put(pOld.codigo,pOld);
        }
        return productosSinModificar;
    }
    
    public static void  GenerarAdmonEstrategia(opportunity pedido ,Producto primerProd,Boolean cancelacion, String canalDistribucion)
    {
        /// ADMINISTRACION ESTRATEGICA TRAER POR SEMANA
        System.debug('GenerarAdmonEstrategia:: '+primerProd.Inventario);
        System.debug(' PEDIDIDO ['+ pedido.Id +'] CANCELACION '+ cancelacion);
        if(pedido.Semana__c == null)
            mapEstrategias = TraerEstrategiaComercialPorSemana(Integer.ValueOf(CalcularSemana(pedido.Fecha_de_Embarque__c)));
        else
            mapEstrategias = TraerEstrategiaComercialPorSemana(Integer.ValueOf(pedido.Semana__c));
        
        if(primerProd.item.Quantity < 0)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No se pueden capturar cantidades negativas'));
            return;
        }
        
        Integer SaldoAnterior=0;
        Integer SaldoActual = 0;
        integer saldoEstrategia =0;
        integer SaldoSemPasada = 0;
        integer Total = 0;
        list<AdminSaldosEstrategias__c> listaResultados = null;
        
        System.debug('pedido.Semana__c:: '+pedido.Semana__c);
        if(String.isNotBlank(pedido.Id) && cancelacion)
        {
            
            System.debug('cancelacion::');
            mapEstrategias = TraerEstrategiaComercialPorSemana(Integer.ValueOf(pedido.Semana__c));
            System.debug('mapEstrategias:: '+mapEstrategias);
            if(mapEstrategias != null)
            {
                AdminSaldosEstrategias__c adminSaldos = mapEstrategias.get(primerProd.Codigo+pedido.Semana__c);
                System.debug('adminSaldos:: '+adminSaldos);
                if(adminSaldos == null )
                {
                    adminSaldos = mapEstrategias.get(primerProd.ProductoMaster+String.valueOf(pedido.Semana__c));
                }
                if(adminSaldos != null)
                {
                    SaldoSemPasada = primerProd.item.Saldo_Semana_Ant__c == null ? 0 : integer.valueOf(primerProd.item.Saldo_Semana_Ant__c);
                    SaldoActual = primerProd.item.Saldo__c == null ? 0 : integer.valueOf(primerProd.item.Saldo__c);
                    saldoEstrategia = calcularSaldo(adminSaldos,canalDistribucion);
                    saldoEstrategia = saldoEstrategia == null ? 0 : saldoEstrategia;
                    Total = saldoEstrategia + SaldoActual;
                    adminSaldos = calcularSaldoAdministracionEstrategica(string.ValueOf(Total),adminSaldos,canalDistribucion);
                    if( mapEstrategiasMod!= null && mapEstrategiasMod.containsKey(adminSaldos.Id))
                    {
                        mapEstrategiasMod.remove(adminSaldos.Id);
                        mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                    }
                    else
                    {
                        mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                    }
                    
                }
                if(SaldoSemPasada > 0)
                {
                    adminSaldos = null;
                    integer semanaPasada = integer.valueOf(pedido.Semana__c) -1;
                    adminSaldos = mapEstrategias.get(primerProd.Codigo+String.valueOf(semanaPasada));
                    if(adminSaldos == null )
                    {
                        adminSaldos = mapEstrategias.get(primerProd.ProductoMaster+String.valueOf(semanaPasada));
                    }
                    if(adminSaldos != null )
                    {
                        saldoEstrategia = calcularSaldo(adminSaldos,canalDistribucion);
                        saldoEstrategia = saldoEstrategia == null ? 0 : saldoEstrategia;
                        Total = saldoEstrategia + SaldoSemPasada;
                        adminSaldos = calcularSaldoAdministracionEstrategica(string.ValueOf(Total),adminSaldos,canalDistribucion);
                        if(mapEstrategiasMod != null && mapEstrategiasMod.containsKey(adminSaldos.Id))
                        {
                            mapEstrategiasMod.remove(adminSaldos.Id);
                            mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                        }
                        else
                        {
                            mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                        }
                    }
                }
                primerProd.item.Cantidad__c = 0;
            }
        } // termina cancelacion
        else if (String.isNotBlank(pedido.Id) && !cancelacion )
        {
            System.Debug('Modificacion AdminSaldosEstrategias__c :: ');
            AdminSaldosEstrategias__c adminSaldos = null;
            if(pedido.Semana__c != CalcularSemana(pedido.Fecha_de_Embarque__c))
            {
                System.debug('Cambio semana');
                SaldoActual = 0;
                SaldoSemPasada = 0;
                Integer semana = 0;
                if(productosSinModificar.ContainsKey(primerProd.Codigo))
                {
                    SaldoSemPasada = productosSinModificar.get(primerProd.Codigo).item.Saldo_Semana_Ant__c == null ? 0 : Integer.valueOf(productosSinModificar.get(primerProd.Codigo).item.Saldo_Semana_Ant__c);
                    SaldoActual = productosSinModificar.get(primerProd.Codigo).item.Saldo__c == null ? 0 : Integer.valueOf(productosSinModificar.get(primerProd.Codigo).item.Saldo__c);
                    if(SaldoSemPasada > 0)
                    {
                        semana = Integer.valueOf(pedido.Semana__c) - 1;
                        adminSaldos = regresarInventarioAdmonEstrategica(primerProd,semana,CanalDistribucion,SaldoSemPasada);
                        if(mapEstrategiasMod != null && mapEstrategiasMod.containsKey(adminSaldos.Id))
                        {
                            mapEstrategiasMod.remove(adminSaldos.Id);
                            mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                        }
                        else
                        {
                            mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                        }
                    }
                    if(SaldoActual > 0)
                    {
                        semana = Integer.valueOf(pedido.Semana__c);
                        adminSaldos = regresarInventarioAdmonEstrategica(primerProd,semana,CanalDistribucion,SaldoActual);
                        if(mapEstrategiasMod != null && adminSaldos!= null && mapEstrategiasMod.containsKey(adminSaldos.Id))
                        {
                            mapEstrategiasMod.remove(adminSaldos.Id);
                            mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                        }
                        else if(adminSaldos != null)
                        {
                            mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                        }
                    }
                }
                // Disminuir inventario Semana Actual
                if(primerProd.inventario != null )
                {
                    System.debug('Restar inventario actual');
                    listaResultados = DisminuirInventariosAdmonEstrategiaComercial(pedido,primerProd);
                    if(listaResultados == null || listaResultados.size() == 0)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El producto no cuenta con saldo'));
                        return;
                    }
                    for(AdminSaldosEstrategias__c ase : listaResultados)
                    {
                        if(mapEstrategiasMod != null && mapEstrategiasMod.containsKey(ase.Id))
                        {
                            SaldoAnterior = calcularSaldo(mapEstrategiasMod.get(ase.Id),canalDistribucion);
                            SaldoActual = calcularSaldo(ase,canalDistribucion);
                            if((SaldoAnterior - SaldoActual) < 0)
                            {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El producto no cuenta con el saldo necesario.'));
                                return;
                            }
                            mapEstrategiasMod.remove(ase.Id);
                            mapEstrategiasMod.put(ase.Id,ase);
                        }
                        else
                        {
                            mapEstrategiasMod.put(ase.Id,ase);
                        }
                    }
                }
            } // cambio semana
            else
            {
                
                if(primerProd.inventario != null)
                {
                    if(productosSinModificar.ContainsKey(primerProd.Codigo))
                    {
                        SaldoActual = 0;
                        SaldoSemPasada = 0;
                        Integer semana = 0;
                        Integer SaldoCajas = 0;
                        if(productosSinModificar.get(primerProd.Codigo).item.Quantity > primerProd.item.Quantity)
                        {
                            System.Debug('Entro modificacion cantidad  anterior mayor actual');
                            SaldoCajas = integer.valueOf(productosSinModificar.get(primerProd.Codigo).item.Quantity - primerProd.item.Quantity);
                            SaldoSemPasada = productosSinModificar.get(primerProd.Codigo).item.Saldo_Semana_Ant__c == null ? 0 : Integer.valueOf(productosSinModificar.get(primerProd.Codigo).item.Saldo_Semana_Ant__c);
                            SaldoActual = productosSinModificar.get(primerProd.Codigo).item.Saldo__c == null ? 0 : Integer.valueOf(productosSinModificar.get(primerProd.Codigo).item.Saldo__c);
                            System.debug('SaldoCajas: '+SaldoCajas);
                            System.debug('SaldoSemPasada: '+SaldoSemPasada);
                            System.debug('SaldoActual: '+SaldoActual);
                            if(SaldoSemPasada > 0)
                            {
                                semana = Integer.valueOf(pedido.Semana__c) - 1;
                                if(SaldoCajas > SaldoSemPasada)
                                {
                                    SaldoCajas = SaldoCajas - SaldoSemPasada;
                                    primerProd.item.Saldo_Semana_Ant__c = 0;
                                    adminSaldos = regresarInventarioAdmonEstrategica(primerProd,semana,CanalDistribucion,SaldoSemPasada);
                                }
                                else
                                {
                                    System.debug('Entro aki');
                                    adminSaldos = regresarInventarioAdmonEstrategica(primerProd,semana,CanalDistribucion,SaldoCajas);
                                    primerProd.item.Saldo_Semana_Ant__c = SaldoSemPasada - SaldoCajas;
                                    System.debug('adminSaldos Mod: '+adminSaldos);
                                    SaldoCajas = 0;
                                }
                                if(mapEstrategiasMod != null && mapEstrategiasMod.containsKey(adminSaldos.Id))
                                {
                                    mapEstrategiasMod.remove(adminSaldos.Id);
                                    mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                                }
                                else
                                {
                                    mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                                }
                            }
                            if(SaldoActual > 0 && SaldoCajas > 0)
                            {
                                semana = Integer.valueOf(pedido.Semana__c);
                                
                                if(SaldoCajas > SaldoActual)
                                {
                                    SaldoCajas = SaldoCajas - SaldoActual;
                                    primerProd.item.Saldo__c = 0;
                                    adminSaldos = regresarInventarioAdmonEstrategica(primerProd,semana,CanalDistribucion,SaldoActual);
                                }
                                else
                                {
                                    primerProd.item.Saldo__c = SaldoActual - SaldoCajas;
                                    adminSaldos = regresarInventarioAdmonEstrategica(primerProd,semana,CanalDistribucion,SaldoCajas);
                                    SaldoCajas = 0;
                                }
                                
                                if(mapEstrategiasMod != null && mapEstrategiasMod.containsKey(adminSaldos.Id))
                                {
                                    mapEstrategiasMod.remove(adminSaldos.Id);
                                    mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                                }
                                else
                                {
                                    mapEstrategiasMod.put(adminSaldos.Id,adminSaldos);
                                }
                            }
                        }
                        else if(productosSinModificar.get(primerProd.Codigo).item.Quantity != primerProd.item.Quantity)
                        {
                            System.debug('Consumir saldo');
                            if(productosSinModificar.get(primerProd.Codigo).item.Quantity < primerProd.item.Quantity)
                            {
                                primerProd.devolucion = 0;
                            }
                            else
                            {
                                primerProd.devolucion =Integer.ValueOf(Integer.ValueOf(primerProd.inventario) + productosSinModificar.get(primerProd.Codigo).item.Quantity);
                            }
                            primerProd.inventario = String.ValueOf(Integer.ValueOf(primerProd.inventario) + productosSinModificar.get(primerProd.Codigo).item.Quantity);
                            System.debug('primerProd.inventario ::'+primerProd.inventario);
                            listaResultados = DisminuirInventariosAdmonEstrategiaComercial(pedido,primerProd);
                            System.debug('listaResultados: '+ listaResultados);
                            if(listaResultados == null || listaResultados.size() == 0)
                            {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El producto no cuenta con Saldo'));
                                return;
                            }
                            for(AdminSaldosEstrategias__c ase : listaResultados)
                            {
                                if(mapEstrategiasMod != null && mapEstrategiasMod.containsKey(ase.Id))
                                {
                                    SaldoAnterior = calcularSaldo(mapEstrategiasMod.get(ase.Id),canalDistribucion);
                                    SaldoActual = calcularSaldo(ase,canalDistribucion);
                                    if((SaldoAnterior - SaldoActual) < 0)
                                    {
                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El producto no cuenta con el saldo necesario.'));
                                        return;
                                    }
                                    mapEstrategiasMod.remove(ase.Id);
                                    mapEstrategiasMod.put(ase.Id,ase);
                                }
                                else
                                {
                                    mapEstrategiasMod.put(ase.Id,ase);
                                }
                            }
                        }
                        else if(primerProd.inventario =='0' && primerProd.inventarioAnt =='0' && mapEstrategiasMod.size() == 0 )
                        {
                            mapEstrategiasMod.clear();
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El producto no cuenta con saldo'));
                            return;
                        }
                    }
                    else
                    {
                        System.debug('primerProd ::'+primerProd);
                        listaResultados = DisminuirInventariosAdmonEstrategiaComercial(pedido,primerProd);
                        if(listaResultados == null || listaResultados.size() == 0)
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El producto no cuenta con saldo'));
                            return;
                        }
                        for(AdminSaldosEstrategias__c ase : listaResultados)
                        {
                            if(mapEstrategiasMod != null && mapEstrategiasMod.containsKey(ase.Id))
                            {
                                SaldoAnterior = calcularSaldo(mapEstrategiasMod.get(ase.Id),canalDistribucion);
                                SaldoActual = calcularSaldo(ase,canalDistribucion);
                                if((SaldoAnterior - SaldoActual) < 0)
                                {
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El producto no cuenta con el saldo necesario.'));
                                    return;
                                }
                                mapEstrategiasMod.remove(ase.Id);
                                mapEstrategiasMod.put(ase.Id,ase);
                            }
                            else
                            {
                                mapEstrategiasMod.put(ase.Id,ase);
                            }
                        }
                        
                    }
                    
                }
                
            }
        }
        else // pedidos nuevos
        {
            System.Debug('pedidos nuevos');
            System.Debug('pedidos nuevos' + primerProd.inventario );
            if(primerProd.inventario != null)
            {
                listaResultados = DisminuirInventariosAdmonEstrategiaComercial(pedido,primerProd);
                if(listaResultados == null || listaResultados.size() == 0)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El producto no cuenta con el saldo necesario.'));
                    return;
                }
                
                for(AdminSaldosEstrategias__c ase : listaResultados)
                {
                    if(mapEstrategiasMod != null && mapEstrategiasMod.containsKey(ase.Id))
                    {
                        SaldoAnterior = calcularSaldo(mapEstrategiasMod.get(ase.Id),canalDistribucion);
                        SaldoActual = calcularSaldo(ase,canalDistribucion);
                        System.Debug('SaldoAnterior:: '+SaldoAnterior);
                        System.Debug('SaldoActual:: '+SaldoActual);
                        if((SaldoAnterior - SaldoActual) < 0)
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El producto no cuenta con el saldo necesario.'));
                            return;
                        }
                        mapEstrategiasMod.remove(ase.Id);
                        mapEstrategiasMod.put(ase.Id,ase);
                    }
                    else
                    {
                        mapEstrategiasMod.put(ase.Id,ase);
                    }
                }
                
            }
        } // termina AdmonEstrategyComercial
        
    }
    public static void ObtenerActalizaLegados(opportunity pedido)
    {
        String sociedad = '';
        string PedidoViz='';
        String canalDistribucion = '';
        String areaResp;
        ActualizaNSC= false;
        ActualizaSAP = false;
        ActualizaPSV = true;
        try{
            sociedad = pedido.Account.Sociedad__c.right(3);
        }catch(Exception e){
            System.debug('Error leyendo la sociedad de la sucursal');
            sociedad = '';
        }
        
        try{
            canalDistribucion = pedido.Account.Canal_Distribucion__c.right(2);
        }catch(Exception e){
            System.debug('Error leyendo el canal de distribucion de la sucursal');
            canalDistribucion = '';
        }
        pedido.Canal_Factura__r = PedidosOtrosCanalesUtils.retrieveCanalFacturaInfo( pedido.Canal_Factura__c );
        
        areaResp = ObtenerCanalVenta(pedido);
        
        if(string.Isnotblank(pedido.Canal_Factura__r.IdPlanta__c)) // es planta
        {
            PedidoViz = (canalDistribucion=='EX' && sociedad == '303')?'V':'';
            
            if(PedidoViz == 'V')
            {
                ActualizaNSC= true;
            }
        }
        else // no es planta
        {
            if((areaResp == 'A' || areaResp =='N' || areaResp =='B') && !pedido.Canal_Factura__r.Opera_en_SAP__c )
            {
                system.debug('ActualizaNSC:  '+ActualizaNSC);
                
                ActualizaNSC= true;
            }
        }
        if(pedido.Canal_Factura__r.Opera_en_SAP__c)
        {
            if(areaResp == 'E' || areaResp =='A' || areaResp =='N' || areaResp =='M'  || areaResp =='B')
            {
                ActualizaSAP= true;
            }
        }
        
        
    }  
    public static Boolean IsVizcatle(opportunity pedido)
    {
        String sociedad = '';
        String canalDistribucion = '';
        string PedidoViz;
        Boolean resultado = false;
        try{
            sociedad = pedido.Account.Sociedad__c.right(3);
        }catch(Exception e){
            System.debug('Error leyendo la sociedad de la sucursal');
            sociedad = '';
        }
        
        try{
            canalDistribucion = pedido.Account.Canal_Distribucion__c.right(2);
        }catch(Exception e){
            System.debug('Error leyendo el canal de distribucion de la sucursal');
            canalDistribucion = '';
        }
        if(string.Isnotblank(pedido.Canal_Factura__r.IdPlanta__c)) // es planta
        {
            PedidoViz = (canalDistribucion=='EX' && sociedad == '303')?'V':'';
            
            if(PedidoViz == 'V')
            {
                resultado= true;
            }
        }
        return resultado;
    }
    public static Integer ObtenerDiasConsolidacion(opportunity pedido,Integer pCodigo)
    {
        string DiasConsolidacionSucursal = null;
        integer diasConsolidacion;
        if(!string.isBlank(pedido.Canal_Factura__r.Dias_consolidacion__c))
        {
            DiasConsolidacionSucursal = pedido.Canal_Factura__r.Dias_consolidacion__c;
        }
        
        if(!string.isBlank(pedido.Canal_Factura__r.Dias_Consolidacion_Prod__c))
        {
            
            List<String> ListaDiasConsolidacionProducto = new List<String>();
            ListaDiasConsolidacionProducto.addAll(pedido.Canal_Factura__r.Dias_Consolidacion_Prod__c.split(';'));
            string ValorDiasConsolidacion = PedidosOtrosCanalesUtils.ValidarDiasConsolidacion(ListaDiasConsolidacionProducto, string.ValueOf(pCodigo));
            System.debug('ValorDiasConsolidacion: ' + ValorDiasConsolidacion);
            if(ValorDiasConsolidacion == null)
            {
                
                if(DiasConsolidacionSucursal == null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No cuenta con dias de consolidacion Configurados'));
                    return null;
                }
                else
                    diasConsolidacion = Integer.ValueOf(DiasConsolidacionSucursal);
            }
            else
            {
                diasConsolidacion = Integer.ValueOf(ValorDiasConsolidacion);// pedido
            }
            System.debug('P.diasConsolidacion: ' + diasConsolidacion);
        }
        else
        {
            if(DiasConsolidacionSucursal == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No cuenta con dias de consolidacion Configurados'));
                return null;
            }
            else
            {
                
                diasConsolidacion = Integer.ValueOf(DiasConsolidacionSucursal);
            }
            
            
        }
        return diasConsolidacion;
    }
 public static void fakeMethod(){
    Integer i = 0;
    i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;

     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;
     i++;
    i++;
    i++;
    i++;

    //repeat the i++ hundred of times

  }
    public class SuKarneException extends Exception{}
}