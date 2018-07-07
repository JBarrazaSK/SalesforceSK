public class utilOtrosCanales {
    
    public static final Integer WEB_SERVICE_TIMEOUT = 23000;
    
    public static final String WRONG_VALUE_ERROR 		= '. Dato incorrecto.';
    public static final String NO_AVAILABLE_PRODUCT 	= '. No hay el producto disponible en este Origen.';
    public static final String NO_PRICES_AVAILABLE	 	= '. No hay precios configurados para este cliente.';

    public PedidoOC pedidoOC {get; set;}
    
    /* DATOS MAESTROS */
    
    public static List<SelectOption> fillFronteras() {
        List<Frontera__c> frntrs = Frontera__c.getall().values();
        List<SelectOption> fronteras = new List<SelectOption>();
        System.debug('FronterasConf: ' + frntrs);
        if( frntrs.size() > 0 ) {
            fronteras = new List<SelectOption>();
            for( Frontera__c f: frntrs ) {
                if( f == null ) { continue; }
                SelectOption opt = new SelectOption( f.Id_Frontera__c+'-'+f.Name, f.Id_Frontera__c+'-'+f.Name );
                fronteras.add( opt );
            }
        }
        
        return fronteras;
    }
    
    public static List<SelectOption> fillOrigenes() {
        List<Oficina_de_Venta__c> oficinasO = retrieveOrigenes();
        if( oficinasO == null ) { return null; }
        
        List<SelectOption> prodOrigen = new List<SelectOption>();
        for( Oficina_de_Venta__c ofi: oficinasO ) {
            if( ofi == null ) { continue; }
            SelectOption opt = new SelectOption( ofi.IdPlanta__c + '-' + ofi.Descripcion__c, ofi.Id );
            prodOrigen.add( opt );
        }

        return prodOrigen;
    }
    
    public static List<SelectOption> fillUM() {
		List<SelectOption> medidas = new List<SelectOption>();
		
        SelectOption c = new SelectOption( 'Cajas', 'C' );
        	medidas.add( c );
        SelectOption p = new SelectOption( 'Pallets', 'P' );
        	medidas.add( p );
        SelectOption k = new SelectOption( 'Kilos', 'K' );
        	medidas.add( k );
        SelectOption l = new SelectOption( 'Libras', 'L' );
        	medidas.add( l );
        
        return medidas;
    }
	
    public static List<SelectOption> fillTP() {
        List<Tipos_de_Precio__c> precios = Tipos_de_Precio__c.getall().values();
        if( precios == null ) { return null; }
        List<SelectOption> monedas = new List<SelectOption>();
        for( Tipos_de_Precio__c tp: precios ) {
            String moneda;
            if( tp.Name.startsWithIgnoreCase('P') ) {
                moneda = 'MXN';
            }
            else if( tp.Name.startsWithIgnoreCase('D') ) {
                moneda = 'USD';
            }
            else if( tp.Name.startsWithIgnoreCase('Y') ) {
                moneda = 'YEN';
            }
            SelectOption tpo = new SelectOption( tp.Descripcion__c, moneda);
        	monedas.add( tpo );
        }
        
        return monedas;
    }
    
    public static List<SelectOption> fillInventarios() {
        List<SelectOption> inventarios = new List<SelectOption>();
        
        SelectOption i1 = new SelectOption( '1-Inv Fisico', '1-Inv Fisico' );
        	inventarios.add( i1 );
        SelectOption i2 = new SelectOption( '2-No Name', '2-No Name' );
        	inventarios.add( i2 );
        SelectOption i3 = new SelectOption( '3-Tto Mexico', '3-Tto Mexico' );
        	inventarios.add( i3 );
        SelectOption i4 = new SelectOption( '4-Tto Nicaragua', '4-Tto Nicaragua' );
        	inventarios.add( i4 );
        SelectOption i5 = new SelectOption( '5-Planeado', '5-Planeado' );
        	inventarios.add( i5 );
        
        return inventarios;
    }
    
    public static List<SelectOption> fillRangos() {
        List<SelectOption> rangos = new List<SelectOption>();
        
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
    
    private static List<Oficina_de_Venta__c> retrieveOrigenes() {
        List<Oficina_de_Venta__c> origenes = new List<Oficina_de_Venta__c>();
        try{
            origenes = [SELECT Id, Name, Descripcion__c, IdPlanta__c, Codigo__c, Surte_Otros_Canales__c, IdClienteViz__c
                        FROM Oficina_de_Venta__c
                        WHERE IdPlanta__c != '' OR Surte_Otros_Canales__c = true];
        } catch( Exception e ) {
            System.debug('There was an error trying to retrieve Sucursales: ' + e.getMessage());
            return null;
        }
        
        return origenes;
    }
    /* DATOS MAESTROS */
    
    /* DISPONIBILIDAD */
        
    public static Map<String, ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud> createDispoRequest( PedidoOC pedidoOC ) {
        if( pedidoOC == null ) { return null; }
        if( pedidoOC.productos == null ) { return null; }
        
        Date fechaEmbarque = pedidoOC.pedido.Fecha_de_Embarque__c;
        Date fechaInicio = fechaEmbarque.addDays( -6 );
        Date fechaFin = fechaEmbarque.addDays( 6 );
        String dateFormat = 'yyyyMMdd';
        String fInicio = ''+ fechaInicio.year() + completeDate( fechaInicio.month() ) + completeDate( fechaInicio.day() );
        String fFin = '' + fechaFin.year() + completeDate( fechaFin.month() ) + completeDate( fechaFin.day() );
        
        Map<String, ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud> mapDispoO = new Map<String, ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud>();
        for( Producto op: pedidoOC.productos ) {
            if( op == null ) { continue; }
            if( String.isBlank( op.productCode ) ) { continue; }
            if( String.isBlank( op.origenCode ) ) { continue; }
            
            ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud temp = mapDispoO.get( op.origenCode );
            if( temp == null ) {
                temp = fillSolicitudDispo( 0, Integer.valueOf(op.origenCode), Integer.valueOf(pedidoOC.pedido.Canal_Factura__r.IdPlanta__c), fInicio, fFin, 0 );
                mapDispoO.put( op.origenCOde, temp );
            }
            
            ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta arrayProds = temp.productos;
            if( arrayProds == null ) {
                arrayProds = new ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta();
                List<ConsultaDisponibilidadMayoristasWS.ProductosConsulta> listProdWS = new List<ConsultaDisponibilidadMayoristasWS.ProductosConsulta>();
                ConsultaDisponibilidadMayoristasWS.ProductosConsulta prod = new ConsultaDisponibilidadMayoristasWS.ProductosConsulta();
        			prod.producto = Integer.valueOf( op.productCode );
                listProdWS.add(prod);
                arrayProds.ProductosConsulta = listProdWS;
                temp.productos = arrayProds;
            }
            else {
                List<ConsultaDisponibilidadMayoristasWS.ProductosConsulta> listProdWS = arrayProds.ProductosConsulta;
                boolean exist = false;
                for( ConsultaDisponibilidadMayoristasWS.ProductosConsulta p: listProdWS ) {
                    if( p == null ) { continue; }
                    if( p.producto == Integer.valueOf( op.productCode ) ) {
                        exist = true;
                    }
                    if( exist ) { break; }
                }
                
                if( !exist ) {
                    ConsultaDisponibilidadMayoristasWS.ProductosConsulta prod = new ConsultaDisponibilidadMayoristasWS.ProductosConsulta();
        			prod.producto = Integer.valueOf( op.productCode );
                    	listProdWS.add( prod );
                    arrayProds.ProductosConsulta = listProdWS;
                    temp.productos = arrayProds;
                }
            }
        }
        
        return mapDispoO;
    }
    
    private static String completeDate(Integer md) {
        if( md == null ) { return null; }
        String fixDate = '';
        if( String.valueOf(md).length() < 2 ) {
            fixDate = '0'+String.valueOf(md);
        }
        return fixDate;
    }
    
    public static ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud fillSolicitudDispo( Integer canal, Integer almacen, Integer almacenDestino, String fechaInicio, String fechaFin, Integer area ) {
        ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud dispoWS = new ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristasSolicitud();
        	dispoWS.Canal = canal; //0; //Canal: EX, MY...
        	dispoWS.almacen = almacen; //959; //Origen
        	dispoWS.almacenDestino = almacenDestino; //740;
        	dispoWS.fechaInicio = fechaInicio; //'20161024';
        	dispoWS.fechaFin = fechaFin; //'20161102';
        	dispoWS.area = area; //0;
        /*	
        List<ConsultaDisponibilidadMayoristasWS.ProductosConsulta> listProdWS = new List<ConsultaDisponibilidadMayoristasWS.ProductosConsulta>();
        for( Producto p: productos ) { //OpportunityLineItems
            if( p == null ) { continue; }
            if( Integer.valueOf( p.origenCode ) != almacen ) { continue; }
            
            ConsultaDisponibilidadMayoristasWS.ProductosConsulta prod = new ConsultaDisponibilidadMayoristasWS.ProductosConsulta();
            prod.producto = Integer.valueOf( p.productCode );    
            listProdWS.add(prod);		
        }
        
        ConsultaDisponibilidadMayoristasWS.ProductosConsulta[] prodWS = listProdWS;
        ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta prodConWS = new ConsultaDisponibilidadMayoristasWS.ArrayOfProductosConsulta();
        prodConWS.ProductosConsulta = prodWS;
        
        dispoWS.productos = prodConWS; 
		*/
        return dispoWS;
    }
    
    public static Map<String, List<utilOtrosCanales.DispoMayoristas>> retrieveDisponibilidad( ConsultaDisponibilidadMayoristasWS.RespuestaOfListOfDisponibilidadMayoristas response ) {
        
        if( response == null ) { return null; }        
        ConsultaDisponibilidadMayoristasWS.ArrayOfDisponibilidadMayoristas dispoDatos = response.Datos;
        
        if( dispoDatos == null ) { return null; }
        List<ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas> dispoMayoristas = dispoDatos.DisponibilidadMayoristas;
        
        if( dispoMayoristas == null ) { return null; }
        if( dispoMayoristas.size() == 0 ) { return null; }
        List<utilOtrosCanales.DispoMayoristas> dispo = new List<utilOtrosCanales.DispoMayoristas>();
        Map<String, List<utilOtrosCanales.DispoMayoristas>> mapDispo = new Map<String, List<utilOtrosCanales.DispoMayoristas>>();
        
        for( ConsultaDisponibilidadMayoristasWS.DisponibilidadMayoristas dm: dispoMayoristas ) {
            if( dm == null ) { continue; }
            utilOtrosCanales.DispoMayoristas dms = new utilOtrosCanales.DispoMayoristas();
            	dms.canal = dm.canal;
            	dms.origen = dm.origen;
            	dms.producto = dm.producto;
            	dms.pesoPromedio = dm.pesoPromedio;
            	dms.tipoInventario = dm.tipoInventario;
            	dms.fecha = dm.fecha;
            	dms.contenido = dm.contenido;
            
            List<utilOtrosCanales.DispoMayoristas> temp = mapDispo.get( dm.producto+'-'+dm.tipoInventario );
            if( temp == null ) {
                temp = new List<utilOtrosCanales.DispoMayoristas>();
            } 
            temp.add(dms);
            mapDispo.put( dm.producto+'-'+dm.tipoInventario, temp );
        }
		
        return mapDispo;
    }
    
    public class DispoMayoristas {
        public Integer canal			{get; set;}
        public Integer origen			{get; set;}
        public String producto			{get; set;}
        public Decimal pesoPromedio		{get; set;}
        public String tipoInventario	{get; set;}
        public String fecha				{get; set;}
        public Integer contenido		{get; set;}
        
        public DispoMayoristas() {}
    }
    
    /* DISPONIBILIDAD */
    
    /* PRECIOS */
    
    public static Map<String, Precio> getPrices( ListaPreciosWS.RespuestaOfListOfPrecioClienteSF response ) {
		ListaPreciosWS.ArrayOfPrecioClienteSF listaMay = response.Datos;
        if( listaMay == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, utilOtrosCanales.NO_PRICES_AVAILABLE));
            return null;
        }
        
        List<ListaPreciosWS.PrecioClienteSF> precios = listaMay.PrecioClienteSF;
        if( precios == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, utilOtrosCanales.NO_PRICES_AVAILABLE));
            return null;
        }

		Map<String, Precio> mapPrecios = new Map<String, Precio>();        
        for( ListaPreciosWS.PrecioClienteSF psf: precios ) {
            if( psf == null ) { continue; }
            if( psf.precios == null ) { continue; }
            
            ListaPreciosWS.ArrayOfPreciosSF arrayP = psf.precios;
            if( arrayP == null ) { continue; }
            
            List<ListaPreciosWS.Precios> preciosSF = arrayP.PreciosSF;
            if( preciosSF == null ) { continue; }
            for( ListaPreciosWS.Precios p: preciosSF ) {
                if( p == null ) { continue; }
                if( String.isBlank( p.pve_cveprod ) ) { continue; }
                if( p.precio == 0 ) { continue; }
                
                Precio aux = mapPrecios.get( p.pve_cveprod );
                if( aux == null ) {
                	aux = new Precio(); 
                    aux.precio = p.precio; 
                    aux.pve_folio = p.pve_folio;
                    aux.pve_folgral = p.pve_folgral;
					aux.pve_cr = p.pve_cr;
                    aux.pve_cliente = p.pve_cliente;
                    aux.pve_cveprod = p.pve_cveprod;
                    aux.pve_volini = p.pve_volini;
                    aux.pve_volfin = p.pve_volfin; 
                    aux.pve_tipprec = p.pve_tipprec; 
                    aux.pve_volofer = p.pve_volofer;
                    aux.pve_folofer = p.pve_folofer;
                }
                mapPrecios.put( p.pve_cveprod, aux );
            }
        }
        
        return mapPrecios;
    }
    
    /* PRECIOS */ 
    
    
    /* PEDIDO/PRDOUCTOS */
    public class PedidoOC {
        
        public Opportunity pedido 					{get; set;}
        public Account cliente 						{get; set;}
    	public Account sucursal 					{get; set;}
        
        public List<Producto> productos 			{get; set;}
        public Map<String, Producto> mapProductos	{get; set;}
        
        public PedidoOC() {
            pedido 		= new Opportunity(); 
            cliente 	= new Account();
            sucursal 	= new Account();
            
            productos = new List<Producto>();
            for( Integer i=0; i<10; i++ ) {
                Producto p = new Producto();
                productos.add( p );
            }
        }
        
        public void mapProdsSelected() {
            if( productos == null ) { return; }
            mapProductos = new Map<String, Producto>();
            
            for( Producto p: productos ) {
                if( p == null ) { continue; }
                if( String.isBlank( p.productCode ) || String.isBlank( p.origenCode ) ) { continue; }
                
                Producto tmp = mapProductos.get( p.productCode+'-'+p.origenCode );
                if( tmp == null ) {
                    mapProductos.put( p.productCode+'-'+p.origenCode, p );
                }
            }
        }
        
        public void validatePrices( Map<String, Precio> prices ) {
            if( productos == null ) { return; }
            if( prices == null ) { return; }
            
            for( Producto p: productos ) {
                if( p == null ) { continue; }
                if( String.isBlank( p.productCode ) || String.isBlank( p.origenCode ) ) { continue; }
                
                Precio tmp = prices.get( p.productCode );
                if( tmp != null ) {
                    if( p.precio != tmp.precio ) {
                        p.distinctPrice = true;
                    }
                }
            }
        }
    }
    
    public class Producto {
        
        public Integer index			{get; set;}
        public String productCode 		{get; set;}
        public String descripcion 		{get; set;}
        public String origenCode 		{get; set;}
        public Integer pesoPromedio 	{get; set;}
        public Integer csXPallet		{get; set;}
        public Integer saldoInventario 	{get; set;}
        public String um				{get; set;}
        public Integer cantidad			{get; set;}
        public Integer volumen			{get; set;}
        public Integer pallets 			{get; set;}
        public Double precio			{get; set;}
        public String tipoPrecio		{get; set;}
        public Integer importe			{get; set;}
        public String tipoInventario	{get; set;}
        public String rangoSurtido		{get; set;}
        public String observaciones		{get; set;}
        
        public boolean distinctPrice	{get; set;} 
        
        public Producto() {
            distinctPrice = false;
        }
    }
    
    /* PEDIDO/PRDOUCTOS */
    
    /* PRECIOS */
    public class Precio {
        
        public Double pve_folio 		{ get; set; }
        public Double pve_folgral 		{ get; set; }
        public Double pve_cr			{ get; set; }
        public Double pve_cliente		{ get; set; }
        public String pve_cveprod 		{ get; set; }
        public Double precio 			{ get; set; }
        public Double pve_volini 		{ get; set; }
        public Double pve_volfin 		{ get; set; }
        public String pve_tipprec 		{ get; set; }
        public Double pve_volofer		{ get; set; }
        public Double pve_folofer		{ get; set; }
        
        public Precio() {}
    
    }
    /* PRECIOS */

}