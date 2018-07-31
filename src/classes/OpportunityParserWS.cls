/*******************************************************************************
Copyright © 2015 Lynx9. All rights reserved.
Author: Aranzazu Sereno
Email: sf@lynx9.com
Description: Logica para ejecutar los webservices de la carga masiva
********************************************************************************/
public class OpportunityParserWS {

public static Boolean ActualizaNSC {get;set;}
public static Boolean ActualizaSAP {get;set;}
public static Boolean ActualizaPSV {get;set;}

    public static Double KG_LB = 2.20462;

    public static Map<String, Map<String, List<ListaPreciosWS.Precios>>> validarPreciosMayoristas(List<Opportunity> pedidos, Map<String, List<OpportunityLineItem>> productos, Boolean isViz ) {

        Map<String, Account> clientesInterCompania = new Map<String, Account>();
        if(isViz){
            List<String> clientesViz = new List<String>();
            for(Opportunity pedido:pedidos){
                Oficina_de_Venta__c canal = pedido.Canal_Factura__r;
                String clienteViz = canal.IdClienteViz__c;
                clienteViz = clienteViz.leftPad(10, '0');
                clientesViz.add(clienteViz);
            }
            clientesInterCompania = OpportunityParserDAO.buscarSucViz(clientesViz);
        }

        List<ListaPreciosWS.PreciosXCliente> clientes = new List<ListaPreciosWS.PreciosXCliente>();
        for(Opportunity pedido:pedidos){
            if(pedido==null){continue;}
            String reqPrecios = '';
            String folio = pedido.Folio_Temporal__c;
            List<OpportunityLineItem> items = productos.get(folio);
            if(items==null){continue;}

            ListaPreciosWS.PreciosXCliente precioCte = new ListaPreciosWS.PreciosXCliente();
            Account cliente = pedido.Cliente__r;
            Account sucursal = pedido.Account;

            if(isViz) {
                Oficina_de_Venta__c canal = pedido.Canal_Factura__r;
                String idClienteViz = String.valueOf(Integer.valueOf(canal.IdClienteViz__c ));
                Account clienteViz = clientesInterCompania.get(idClienteViz);
                if( clienteViz == null ) {
                    throw new ParserWSException('La sucursal viz: ' + idClienteViz + ' no existe');
                }

                precioCte.cliente = idClienteViz;
                if(String.isNotBlank(pedido.Canal_Factura__r.SucursalesViz__c))
                {

                    List<String> ListaSucursalesFrontera = new List<String>();
                    ListaSucursalesFrontera.addAll(pedido.Canal_Factura__r.SucursalesViz__c.split(';'));
                    precioCte.destinatario =  ValidarSucursalViz(ListaSucursalesFrontera,pedido.frontera__c);
                    system.debug('precioCte.destinatario: '+precioCte.destinatario);
                    //precioCte.destinatario = String.valueOf( pedido.Canal_Factura__r.Sucursal_Viz__c );//'103574';
                }


                precioCte.gpoVendedores = clienteViz.Grupo_de_Vendedores__r.Codigo__c;//'404';
                precioCte.ofiVentas = clienteViz.Oficina_de_Ventas__r.Codigo__c;//'441';
                precioCte.orgVentas = clienteViz.Organizacion_de_Ventas__c.right(4);//'3031';
                precioCte.canal = clienteViz.Canal_Distribucion__c.right(2);//'EX';
                precioCte.cadena = '';

                try{
                    precioCte.cluster = clienteViz.Ramo__c.right(2);
                }catch(Exception e){
                    System.debug('Ramo del cliente esta vacio');
                    precioCte.cluster = '';
                }
            	System.debug('Cluster:' + precioCte.cluster);

            }else{
                precioCte.cliente = String.valueOf(Integer.valueOf( cliente.Numero_Cliente_SAP__c ));
                precioCte.gpoVendedores = sucursal.Grupo_de_Vendedores__r.Codigo__c;
                precioCte.ofiVentas = sucursal.Oficina_de_Ventas__r.Codigo__c;
                precioCte.orgVentas = cliente.Organizacion_de_Ventas__c.right(4);
                precioCte.canal = cliente.Canal_Distribucion__c.right(2);
                String sucursalSAP = sucursal.Numero_Cliente_SAP__c;
                sucursalSAP = sucursalSAP.replace('SUC - ', '');
                precioCte.destinatario = String.valueOf(Integer.valueOf( sucursalSAP ));
                try{
                    precioCte.cluster = cliente.Ramo__c.right(2);
                }catch(Exception e){
                    System.debug('Ramo del cliente esta vacio');
                    precioCte.cluster = '';
                }

                try{
                    String[] cadenaArray = sucursal.Cadena__c.split(' - ');
                    precioCte.cadena = cadenaArray[1];
                }catch(Exception e){
                    precioCte.cadena = '';
                }
            }

            precioCte.fecDoc = dateToString(pedido.Fecha_de_Embarque__c);

            reqPrecios = 'cliente=' + precioCte.cliente;
            reqPrecios += ', gpoVendedores=' + precioCte.gpoVendedores;
            reqPrecios += ', ofiVentas=' + precioCte.ofiVentas;
            reqPrecios += ', orgVentas=' + precioCte.orgVentas;
            reqPrecios += ', canal=' + precioCte.canal;
            reqPrecios += ', destinatario=' + precioCte.destinatario;
            reqPrecios += ', cluster=' + precioCte.cluster;
            reqPrecios += ', cadena=' + precioCte.cadena;
            reqPrecios += ', fecDoc=' + precioCte.fecDoc;

            List<ListaPreciosWS.producto> prodsWS = new List<ListaPreciosWS.producto>();
            for( OpportunityLineItem item:items) {
                if( item == null ) { continue; }
                if(String.isBlank(item.ProductCode )){ continue;}
                ListaPreciosWS.producto prodWS = new ListaPreciosWS.producto();
                prodWS.codigo = item.ProductCode;
                prodsWS.add( prodWS );
                reqPrecios += ', prod=' + prodWS.codigo;
            }
            ListaPreciosWS.ArrayOfProducto productosWS = new ListaPreciosWS.ArrayOfProducto();
            productosWS.producto = prodsWS;
            precioCte.producto = productosWS;
            clientes.add( precioCte );

            System.debug('Request precios=' + reqPrecios);
        }

        ListaPreciosWS.RespuestaOfListOfPrecioClienteSF response;
        System.debug('Clientes: '+clientes);
        try {
            ListaPreciosWS.ArrayOfPreciosXCliente request = new ListaPreciosWS.ArrayOfPreciosXCliente();
            request.PreciosXCliente = clientes;
            ListaPreciosWS.ListaPreciosSoap stub = new ListaPreciosWS.ListaPreciosSoap();
           /* stub.maxReceivedMessageSize = '2147483647';
            stub.maxBufferSize = '2147483647';
            stub.maxBufferPoolSize ='2147483647';*/
            stub.timeout_x = PedidosOtrosCanalesUtils.WEB_SERVICE_TIMEOUT;
            System.debug('Lista precios request:' + request);
            response = stub.RegresaListaPreciosMayoristas( request );
        } catch( Exception e ) {
            System.debug('ERROR:: Consultando precios: '+e.getMessage());
            throw new ParserWSException(PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE + '.' + e.getMessage());
        }
        System.debug('Lista de Precios: ' + response);
        if( response == null ) {
            throw new ParserWSException(PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE);
        }

        ListaPreciosWS.ArrayOfPrecioClienteSF datos = response.Datos;
        if( datos == null ) {
            throw new ParserWSException(PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE);
        }

        List<ListaPreciosWS.PrecioClienteSF> preciosCliente = datos.PrecioClienteSF;
        if( preciosCliente == null ) {
            throw new ParserWSException(PedidosOtrosCanalesUtils.NO_PRICES_AVAILABLE);
        }

        Map<String, Map<String, List<ListaPreciosWS.Precios>>> mapaPreciosPorCliente = new Map<String, Map<String, List<ListaPreciosWS.Precios>>>();
        for( ListaPreciosWS.PrecioClienteSF psf: preciosCliente ) {
            if( psf == null ) { continue; }
            ListaPreciosWS.ArrayOfPreciosSF arrayPrecios = psf.precios;
            if( psf.numerocliente == null || arrayPrecios == null ) {continue;}
            List<ListaPreciosWS.Precios> precios = arrayPrecios.PreciosSF;
            if( precios == null ) { continue; }

            Map<String, List<ListaPreciosWS.Precios>> mapaPreciosPorProducto = new Map<String, List<ListaPreciosWS.Precios>>();
            for( ListaPreciosWS.Precios p: precios ) {
                if( p == null ) { continue; }
                if( String.isBlank( p.pve_cveprod )) { continue; }
                List<ListaPreciosWS.Precios> listaPrecios = mapaPreciosPorProducto.get(p.pve_cveprod);
                if(listaPrecios==null){
                    listaPrecios = new List<ListaPreciosWS.Precios>();
                    mapaPreciosPorProducto.put(p.pve_cveprod, listaPrecios);
                }
                listaPrecios.add(p);
            }
            String numCte = psf.numerocliente;
            System.debug('NumCte: '+Integer.valueOf(numCte));
            mapaPreciosPorCliente.put(psf.numerocliente, mapaPreciosPorProducto);
        }

        return mapaPreciosPorCliente;

    }

    public static String dateToString(Date dFecha){
        DateTime fechaHora = datetime.newInstance(dFecha.year(), dFecha.month(), dFecha.day());
        System.debug('Fecha original:' + dFecha + ', DateTime:' + fechaHora);
        //String sFecha = fechaHora.format('yyyyMMdd', tz);
        String sFecha = fechaHora.format('yyyyMMdd');
        System.debug('Fecha:' + sFecha);
        return sFecha;
    }

    public static DateTime dateToDateTime(Date dFecha){
        return datetime.newInstance(dFecha.year(), dFecha.month(), dFecha.day());
    }
	public static list<WsPedidosMayoreoLegados.ResultadoPedidoMayoreoLegados> guardarPedidoslegados(List<Opportunity> pedidos, Map<String, List<OpportunityLineItem>> OpportunityLineItems)
	{
		list<WsPedidosMayoreoLegados.DatosPedidoLegado> listaPedidos = new list<WsPedidosMayoreoLegados.DatosPedidoLegado>(); 
		WsPedidosMayoreoLegados.DatosPedidoLegado DatosPedidos;
		map<string, Opportunity> mapPedidos = new map<string, Opportunity>();
		String obs = '';
		for(Opportunity pedido : pedidos)
		{
			
	        if(pedido.Canal__c=='A'){
	            obs = 'Carga masiva autoservicio';
	        }else if(pedido.Canal__c=='M'){
	            obs = 'Carga masiva mayoreo';
	        }else if(pedido.Canal__c=='E'){
	            obs = 'Carga masiva exportación';
	        }
	        if(string.isBlank(obs))
	        {
	        	 obs = 'Carga masiva '+pedido.Canal__c ;
	        }
	        system.debug('Observaciones: -----> '+ obs);
	        pedido.Description = obs;
			list<PedidosOtrosCanalesUtils.Producto> productos =  OpportunityParserUtils.GenerarListaProductos(OpportunityLineItems.get(pedido.Folio_Temporal__c)); 
			DatosPedidos = new WsPedidosMayoreoLegados.DatosPedidoLegado();
			ObtenerActalizaLegados(pedido);
        	DatosPedidos.ActualizaPSV = ActualizaPSV;
        	DatosPedidos.ActualizaSAP = ActualizaSAP;
        	DatosPedidos.ActualizaNSC = ActualizaNSC;
        	DatosPedidos.IdTransaccion = pedido.id_externo__c;
        	
        	if(DatosPedidos.ActualizaPSV)
        	{
        		DatosPedidos.DatosPedidoPSV = PedidosOtrosCanalesUtils.CrearPedidoMayoreoLegados(pedido,productos,false); 
        	}
        	if(DatosPedidos.ActualizaNSC)
        	{
        		DatosPedidos.DatosPedidoNSC = PedidosOtrosCanalesUtils.CrearPedidoNSC(pedido,productos,false); 
		    }
		    if(DatosPedidos.ActualizaSAP)
        	{
        		DatosPedidos.DatosSAP = PedidosOtrosCanalesUtils.CrearPedidoSap(pedido,productos,false);
		    }
		    if(pedido.StageName == '11 - Bloqueado Cierre')
    		{
    			DatosPedidos.ActualizaSAP = false;
        		DatosPedidos.ActualizaNSC = false;
    		}
		    mapPedidos.put(pedido.Id_Externo__c,pedido);
		    listaPedidos.add(DatosPedidos);
		}
		return OpportunityParserUtils.EnviarPedidoLegados(listaPedidos,mapPedidos);
	}
	
	
    public static List<PedidosMayoreoWS.PedidosMayoreoRespuesta> guardarPedidos( List<Opportunity> pedidos, Map<String, List<OpportunityLineItem>> productos, Boolean cancelar ) {

        Map<String, Account> clientesInterCompania = new Map<String, Account>();
        List<String> clientesViz = new List<String>();
        for(Opportunity pedido:pedidos){
            Account cliente = pedido.Cliente__r;
            Oficina_de_Venta__c canal = pedido.Canal_Factura__r;
            if(cliente.Canal_Distribucion__c!=null && canal!=null){
                if(String.isNotBlank(canal.IdClienteViz__c)){
                    if( cliente.Canal_Distribucion__c.right(2) == 'EX' && String.isNotBlank( canal.IdPlanta__c ) ) {
                        String clienteViz = canal.IdClienteViz__c;
                        clienteViz = clienteViz.leftPad(10, '0');
                        clientesViz.add(clienteViz);
                    }
                }
            }
        }
        if(clientesViz.size()>0){
            clientesInterCompania = OpportunityParserDAO.buscarSucViz(clientesViz);
        }

        User u = retrieveUserInfo(System.UserInfo.getUserId());

        Integer pedidoCte = 4;
        Integer pedidoViz = 1;

        List<PedidosMayoreoWS.PedidoMayoreo> listPedidos = new List<PedidosMayoreoWS.PedidoMayoreo>();
        for(Opportunity pedido:pedidos){
            Account cliente = pedido.Cliente__r;
            Account sucursal = pedido.Account;
			Oficina_de_Venta__c canal = pedido.Canal_Factura__r;

            String idPlanta = canal.IdPlanta__c;
            String areaResp = 'E';
            if( cliente.Canal_Distribucion__c.right(2) == 'AS' ) { areaResp = 'A'; pedidoCte = 3; }
            else if( cliente.Canal_Distribucion__c.right(2) == 'MY' ) {
                areaResp = 'N'; pedidoCte = 4; pedidoViz = 1;
                if( String.isNotBlank(idPlanta) ) {
                    areaResp = 'M';
                }
            }
            else if( cliente.Canal_Distribucion__c.right(2) == 'EX' ) {
                areaResp = 'B'; pedidoCte = 2;
                if( String.isNotBlank(idPlanta) ) {
                    areaResp = 'E';
                }
            }
            List<OpportunityLineItem> items = productos.get(pedido.Folio_Temporal__c);
            System.debug('Inicia armado de requerimiento para guardar en SDL:..');
            Account clienteViz = null;
            if(cliente.Canal_Distribucion__c!=null && canal!=null){
                if(String.isNotBlank(canal.IdClienteViz__c)){
                    if( cliente.Canal_Distribucion__c.right(2) == 'EX' && String.isNotBlank( canal.IdPlanta__c ) ) {
                        String idClienteViz = canal.IdClienteViz__c;
                        clienteViz = clientesInterCompania.get(idClienteViz);
                    }
                }
            }

            PedidosMayoreoWS.PedidoMayoreo pedidoWS = getPedidoMayoreo(pedido, areaResp, pedidoCte, pedidoViz, cancelar, items, clienteViz);

            System.debug('Haciendo mapa de productos...');
            Double flete = 0.0;
            if(pedido.Flete__c!=null){
                flete = pedido.Flete__c;
            }
            Map<String, List<OpportunityLineItem>> mapProductos = getProdsXCodigo( items );
            List<PedidosMayoreoWS.PedidoMayoreoDetalle> productosWS = new List<PedidosMayoreoWS.PedidoMayoreoDetalle>();
            for( String codigo: mapProductos.keySet() ) {
                List<OpportunityLineItem> prodsAux = mapProductos.get(codigo);
                Integer pCodigo = Integer.valueOf(codigo);
                PedidosMayoreoWS.PedidoMayoreoDetalle detalleWS = getPedidoMayoreoDetalle(flete, pCodigo, prodsAux,pedido);
                if(detalleWS == null)
                {

                 	return null;
                }
                productosWS.add(detalleWS);
            }

            PedidosMayoreoWS.ArrayOfPedidoMayoreoDetalle detalles = new PedidosMayoreoWS.ArrayOfPedidoMayoreoDetalle();
            detalles.PedidoMayoreoDetalle = productosWS;
            pedidoWS.Detalle = detalles;

            System.debug('PedidoOpp: '+pedido);
            System.debug('Folio ' + pedido.Folio_Temporal__c + ' : ' + debugPedido(pedidoWS));

            listPedidos.add( pedidoWS );
        }

        PedidosMayoreoWS.ArrayOfPedidoMayoreo request = new PedidosMayoreoWS.ArrayOfPedidoMayoreo();
        request.PedidoMayoreo = listPedidos;
        PedidosMayoreoWS.PedidosMayoreoSoap stub = new PedidosMayoreoWS.PedidosMayoreoSoap();
        stub.timeout_x = PedidosOtrosCanalesUtils.WEB_SERVICE_TIMEOUT;
        PedidosMayoreoWS.ArrayOfPedidosMayoreoRespuesta response = stub.SF_GuardaPedidoEMA( request );
        system.debug('responsePedidosMayoreo: '+response );
        if( response != null ){
            return response.PedidosMayoreoRespuesta;
        }
		
        return null;
    }

    public static PedidosMayoreoWS.PedidoMayoreo getPedidoMayoreo(Opportunity pedido, String areaResp, Integer pedidoCte, Integer pedidoViz, Boolean cancelar, List<OpportunityLineItem> items, Account clienteViz){

        Double total = 0.0;
        Integer totalKGS = 0;
        for(OpportunityLineItem item:items){
            total += item.Importe__c;
            totalKGS += Integer.valueOf(item.Kilos__c);
        }

        PedidosMayoreoWS.PedidoMayoreo pedidoWS = new PedidosMayoreoWS.PedidoMayoreo();
        pedidoWS.importeTotalPedido = total;
        String obs = '';
        if(pedido.Canal__c=='A'){
            obs = 'Carga masiva autoservicio';
        }else if(pedido.Canal__c=='M'){
            obs = 'Carga masiva mayoreo';
        }else if(pedido.Canal__c=='E'){
            obs = 'Carga masiva exportación';
        }
        if(string.isBlank(obs))
        {
        	 obs = 'Carga masiva '+pedido.Canal__c ;
        }
        system.debug('Observaciones: -----> '+ obs);
        pedidoWS.observacionGralPedido = obs;
        pedidoWS.cantidadKGSTotalPedido = totalKGS;

        String atendio = '';
        try{
            atendio = System.UserInfo.getFirstName().left(1).capitalize() + System.UserInfo.getLastName().capitalize();
        }catch(Exception e){
            System.debug('El usuario actual no trae nombre o apellido');
            atendio = '';
        }

        Datetime fechaRegistro = System.now();
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
        pedidoWS.idPedidoSF = Integer.valueOf(pedido.Id_Externo__c);
        if(cancelar){
            pedidoWS.motivoCancelacion = 'Error en guardado en Salesforce.com';
            pedidoWS.estatusPedido = 8;
            pedidoWS.folioPedidoSDL = pedido.Folio_Pedido_SDL__c;
            if(String.isNotBlank(pedido.Folio_Embarque__c)){
                pedidoWS.folioEmbarqueSDL = pedido.Folio_Embarque__c;
            }
            // DATOS PARA ESPECIFICAR LA CANCELACIÓN/ELIMINACIÓN
            pedidoWS.vendedorElimino = atendio;
            pedidoWS.fechaElimino = fechaRegistro.format('yyyyMMdd');
            pedidoWS.horaElimino = fechaRegistro.format('HH:mm:ss');

        }else{
            pedidoWS.atendido = atendio;
            pedidoWS.motivoCancelacion = '';
            pedidoWS.folioPedidoSDL = '';
            pedidoWS.folioEmbarqueSDL =  '';
            pedidoWS.estatusPedido = 1; //8-Cancelación

            pedidoWS.fechaRegistro = fechaRegistro.format('yyyyMMdd');
            pedidoWS.horaRegistro = fechaRegistro.format('HH:mm:ss');

            pedidoWS.vendedorElimino = '';
            pedidoWS.fechaElimino = '';
            pedidoWS.horaElimino = '';

        }

        pedidoWS.vendedorModifico = '';
        pedidoWS.fechaModifico = '';
        pedidoWS.horaModifico = '';

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
        if(pedido.Flete__c==null){
            pedidoWS.fleteLibra = 0;
        }else{
            pedidoWS.fleteLibra = pedido.Flete__c;
        }

        pedidoWS.tipoSurtido = 3;
        pedidoWS.tipoVenta = 1;

        String sociedad = '';
        try{
            System.debug('Sociedad:' + pedido.Account.Sociedad__c.right(3));
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

        if(canalDistribucion=='EX'){
            pedidoWS.tipoEntrega = 1; //1-DD; 2-BP Sólo Exportación
            pedidoWS.tipoEmbarque = 1; //1-Directo; 2-LTL
        } else  {
            pedidoWS.tipoEntrega = 0;
            pedidoWS.tipoEmbarque = 0;
        }

        /*
         * CANAL FACTURA
         */
        String idPlanta = '';
        Integer idPlantaFactura = 0;
        Integer codigoPlanta = 0;
        if(pedido.Canal_Factura__r!=null){
            idPlanta = pedido.Canal_Factura__r.IdPlanta__c;
            if( String.isNotBlank( idPlanta ) ) {
                try{
                    pedidoWS.planta = Integer.valueOf(idPlanta);
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
        if(pedidoWS.planta==null){
            pedidoWS.planta = 0;
        }

        pedidoWS.canalSurteCte = codigoPlanta;

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

        // sap
        Integer sapSucursal = null;
        try{
            sapSucursal = Integer.valueOf(pedido.Account.Numero_Cliente_SAP__c.replace('SUC - ',''));
        }catch(Exception e){
            System.debug('Error en conversión de sucursal SAP');
            sapSucursal = 0;
        }
        pedidoWS.destinatario = sapSucursal;

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


        // FRONTERA
        Integer frontera = null;
        try{
            frontera = Integer.valueOf(pedido.Frontera__c.left(2).trim());
        }catch(Exception e){
            System.debug('Error en conversión de frontera');
        }
        if( String.isNotBlank( idPlanta ) ) {
           pedidoWS.fronteraCte = frontera;
        }else{
           pedidoWS.fronteraCte = 0;
        }

        // FECHA EMBARQUE
        String sFechaEmbarque = dateToString(pedido.Fecha_de_Embarque__c);
        DateTime fechaHoraEmbarque = dateToDateTime(pedido.Fecha_de_Embarque__c);
        pedidoWS.fechaEmbarque = sFechaEmbarque;
        Integer semana = Integer.valueOf(fechaHoraEmbarque.format('w'));
        Integer dof = Integer.valueOf(getDOF(fechaHoraEmbarque));
        Integer anio = pedido.Fecha_de_Embarque__c.year();
        if( dof == 7 ) {
            if( semana == 1 ) { semana = 52; anio = anio - 1; }
            else { semana = semana - 1; }
        }
        pedidoWS.semana     = String.valueOf( semana ); //fechaHoraEmbarque.format('w');
        pedidoWS.diaSemana  = String.valueOf( dof);
        pedidoWS.anio       = String.valueOf( anio );
        /*
        pedidoWS.semana = String.valueOf(Integer.valueOf(fechaHoraEmbarque.format('w'))-1);
        pedidoWS.diaSemana = getDOF( pedido.Fecha_de_Embarque__c );
        pedidoWS.anio = String.valueOf(fechaHoraEmbarque.year());
        */

        // FECHA ENTREGA
        String sFechaEntrega = dateToString(pedido.Fecha_de_Entrega__c);
        pedidoWS.fechaEntrega = sFechaEntrega;
        pedidoWS.fechaCita = sFechaEntrega;

        // FECHA INSPECCION
        if(pedido.Fecha_de_Inspeccion__c!=null){
            pedidoWS.fechaInspeccion = dateToString(pedido.Fecha_de_Inspeccion__c);
        } else {
            pedidoWS.fechaInspeccion = ' ';
        }

        // FECHA EMBARQUE BODEGA
        if(pedido.Fecha_Embarque_Bodega__c!=null){
            pedidoWS.fechaEmbBodega = dateToString(pedido.Fecha_Embarque_Bodega__c);
        } else {
            pedidoWS.fechaEmbBodega = ' ';
        }

        /*
         * INTERCOMPAÑIA
         */
        Integer destinatarioViz = null;
        try{
        	if(String.isNotBlank(pedido.Canal_Factura__r.SucursalesViz__c))
        	{
        		List<String> ListaSucursalesFrontera = new List<String>();
        		ListaSucursalesFrontera.addAll(pedido.Canal_Factura__r.SucursalesViz__c.split(';'));
        		destinatarioViz =Integer.valueOf( ValidarSucursalViz(ListaSucursalesFrontera,pedido.frontera__c));
        		System.debug('destinatarioViz -------> '+destinatarioViz);
        	}
            //destinatarioViz = Integer.valueOf( pedido.Canal_Factura__r.Sucursal_Viz__c );
        }catch(Exception e){
            System.debug('Error en conversión de id planta de la oficina de ventas de la sucursal');
            destinatarioViz = 0;
        }
		Integer codigoVizCDSucursal = null;
        try{
            //codigoVizCDSucursal = Integer.valueOf( clienteViz.Canal_de_Distribucion_NSC__r.Codigo__c );
            if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' && String.isNotBlank( pedido.Canal_Factura__r.IdPlanta__c ) && pedido.Cliente__r.Sociedad__c.right(3) == '303' )
	        {
	            string suc = 'SUC - ';
	            List<String> ListaSucursalesFrontera = new List<String>();
	            ListaSucursalesFrontera.addAll(pedido.Canal_Factura__r.SucursalesViz__c.split(';'));
	            System.debug('ListaSucursalesFrontera: '+ListaSucursalesFrontera);
	            System.debug('pedido.frontera__c: '+pedido.frontera__c);
	            String ClienteVizNew = PedidosOtrosCanalesUtils.ValidarSucursalViz(ListaSucursalesFrontera,pedido.frontera__c);
	            System.debug('ClienteViz: '+ClienteVizNew);
	            if(String.isNotBlank(ClienteVizNew))
	            {
	                string codigo  ='0';
	                Account sucVizNew = PedidosOtrosCanalesUtils.buscarSucViz(suc+ClienteVizNew.leftPad(10, '0'));
	                if(sucVizNew != null && sucVizNew .Canal_de_Distribucion_NSC__c != null)
	                {
	                    codigo = sucVizNew .Canal_de_Distribucion_NSC__r.Codigo__c;
	                     codigoVizCDSucursal = Integer.valueOf(codigo);
	                     
	                }
	            }
	        }
        }catch(Exception e){
            System.debug('Error en conversión del codigo viz del canal de distribución de la sucursal');
        }
		
        pedidoWS.tipoPedidoViz = 0;
        pedidoWS.areaRespViz = '';
        pedidoWS.clienteInterViz = 0;
        pedidoWS.destinatarioViz = 0;
        pedidoWS.canalDistViz = 0;

        if(canalDistribucion=='EX'){
            if( sociedad == '303') {
                pedidoWS.destinatarioViz = destinatarioViz;
                pedidoWS.tipoPedidoViz = 1;// if(EX) 1
            }
            if(String.isNotBlank(idPlanta)){
                pedidoWS.canalDistViz = codigoVizCDSucursal;
                if(sociedad == '303'){
                    pedidoWS.areaRespViz = 'V';
                    pedidoWS.clienteInterViz = canalSucursal;
                }
            }
        }
        if(!PedidosOtrosCanalesUtils.ValidarCierre(pedido,Integer.valueOf(pedido.Canal_Factura__r.Dias_de_cierre__c), pedido.Canal_Factura__r.Hora_de_cierre__c))
        {
            pedidoWS.estatusPedido = 11; //10-Bloqueado
            pedido.StageName = '11 - Bloqueado Cierre';
        }
        return pedidoWS;
    }

    public static PedidosMayoreoWS.PedidoMayoreoDetalle getPedidoMayoreoDetalle(Double flete, Integer pCodigo, List<OpportunityLineItem> prodsAux,opportunity pedido){
        OpportunityLineItem primerItem = prodsAux.get(0);

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
             string ValorDiasConsolidacion = OpportunityParserDAO.ValidarDiasConsolidacion(ListaDiasConsolidacionProducto, string.ValueOf(pCodigo));
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
            //  DIAS CONSOLIDACION
        }
        else
        {
        	 ParametrosOtrosCanales__c ep = ParametrosOtrosCanales__c.getInstance();
             P.diasConsolidacion =Integer.ValueOf(ep.Dias_Embarque__c);
        }
        p.autorizaPrecio = 'S';
        p.productoRelacion = 'P';
       // p.diasConsolidacion=1;
        p.marca = 1;
        p.producto = pCodigo;
        p.precioSAPCte = primerItem.UnitPrice; //+ flete;
        p.tipoPrecioSAP = primerItem.Tipo_de_Precio__c;
        p.cjXPallets = Integer.valueOf(primerItem.Cajas_x_Pallet__c);

        if( primerItem.Precio_Unitario_Viz__c != null ) {
            p.precioSAPViz = primerItem.Precio_Unitario_Viz__c;
        } else {
            p.precioSAPViz = 0;
        }

        Integer folioPrecioSAP = 0;
        try{
            folioPrecioSAP = Integer.valueOf( primerItem.FolioPrecioSAP__c );
        }catch(Exception e){
            folioPrecioSAP = 0;
        }
        p.folioPrecioSAPCte = folioPrecioSAP;

        Integer folioPrecioSAPViz = 0;
        try{
            folioPrecioSAPViz = Integer.valueOf( primerItem.FolioPrecioSAPViz__c );
        }catch(Exception e){
            folioPrecioSAPViz = 0;
            System.debug('Folio precio SAP no es valido');
        }
        p.folioPrecioSAPViz = folioPrecioSAPViz;

        Integer utipoPeso = 0; // 'C'
        if( primerItem.Unidad__c == 'K' ) { utipoPeso = 1; }
        else if( primerItem.Unidad__c == 'P' )  { utipoPeso = 2; }
        else if( primerItem.Unidad__c == 'L' ) { utipoPeso = 3; }
        p.unidadPeso = utipoPeso;
        p.tipoPeso = String.valueOf(utipoPeso);//UM 0,1,2

        Integer pallets = 0;
        Integer cjs = 0;
        Integer piezas = 0;
        Integer kgs = 0;
        Double volumen = 0.0;
        Decimal librasPeso = 0;
        Decimal importeTxP = 0.0;
        Decimal importeTxPV = 0.0;

        System.debug('Armando Inventario...');
        List<PedidosMayoreoWS.PedidoMayoreoInventario> listInventario = new List<PedidosMayoreoWS.PedidoMayoreoInventario>();
        for( OpportunityLineItem item: prodsAux ) {
            if( item == null ) { continue; }
            PedidosMayoreoWS.PedidoMayoreoInventario inventario = new PedidosMayoreoWS.PedidoMayoreoInventario();
            inventario.producto = pCodigo;

            //ORIGEN SURTIDO
            try{
                inventario.origenSurtido = Integer.valueOf(item.Origen_Surtido__r.Codigo__c);
            }catch(Exception e){
                inventario.origenSurtido = 0;
                System.debug('Error en conversión del codigo del origen surtido');
            }

            // ACTIVA
            inventario.dispoActiva = 0;
            try{
                if(item.Origen_Surtido__r.Valida_Disponibilidad__c){
                    inventario.dispoActiva = 1;
                }
            }catch(Exception e){
                inventario.dispoActiva = 0;
                System.debug('Error en valida disponibilidad del origen surtido');
            }

            //TIPO INVENTARIO
            inventario.tipoInventario = 0;
            try{
                inventario.tipoInventario = Integer.valueOf(item.Tipo_de_Inventario__c.left(1));
            }catch(Exception e){
                inventario.tipoInventario = 0;
                System.debug('Error en conversion de tipo de inventario');
            }

            //ACUMULADO
           	pallets += Integer.valueOf(item.Pallets__c);
            cjs += Integer.valueOf(item.Quantity);
            kgs += Integer.valueOf(item.Kilos__c);
            piezas += Integer.valueOf( item.Piezas__c );
            librasPeso += (item.Kilos__c * KG_LB);
            volumen += item.Volumen__c;

            importeTxP += item.Importe__c;
            if(item.Precio_Unitario_Viz__c!=null){
                importeTxPV += item.Importe_Total_Viz__c;
            }

            //CANTIDAD CAJAS
            inventario.cantidadCajas = Integer.valueOf(item.Quantity);
            listInventario.add( inventario );
        }

        System.debug('INVENTARIO::'+listInventario);

        PedidosMayoreoWS.ArrayOfPedidoMayoreoInventario inventarioWS = new PedidosMayoreoWS.ArrayOfPedidoMayoreoInventario();
        inventarioWS.PedidoMayoreoInventario = listInventario;
        p.inventario = inventarioWS;

        //if( primerItem.Unidad__c == 'P' ) {
            p.piezas = piezas;
        //}else{
        //    p.piezas = 0;
        //}

        p.pallets = pallets;
        p.cajas = cjs;
        p.cantidadKGS = kgs;
        p.librasPeso = librasPeso.setScale(0);
        p.importeTotXProducto = importeTxP.setScale(4);
        p.importeTotXProductoViz = importeTxPV.setScale(4);
        p.observacionesxProducto = primerItem.Observaciones__c;

        return p;

    }

    public static String debugPedido(PedidosMayoreoWS.PedidoMayoreo pedidoWS){
        String pedido = ' PEDIDO: ';

        pedido += ' planta=' + pedidoWS.planta + ', ';
        pedido += ' areaRespCte=' + pedidoWS.areaRespCte + ', ';
        pedido += ' areaRespViz=' + pedidoWS.areaRespViz + ', ';
        pedido += ' cliente=' + pedidoWS.cliente + ', ';
        pedido += ' clienteInterViz=' + pedidoWS.clienteInterViz + ', ';
        pedido += ' destinatario=' + pedidoWS.destinatario + ', ';
        pedido += ' destinatarioViz=' + pedidoWS.destinatarioViz + ', ';
        pedido += ' canalSurteCte=' + pedidoWS.canalSurteCte + ', ';
        pedido += ' fronteraCte=' + pedidoWS.fronteraCte + ', ';
        pedido += ' canalDistCte=' + pedidoWS.canalDistCte + ', ';
        pedido += ' canalDistViz=' + pedidoWS.canalDistViz + ', ';
        pedido += ' occProveedor=' + pedidoWS.occProveedor + ', ';
        pedido += ' poCliente=' + pedidoWS.poCliente + ', ';
        pedido += ' fechaEmbarque=' + pedidoWS.fechaEmbarque + ', ';
        pedido += ' semana=' + pedidoWS.semana + ', ';
        pedido += ' anio=' + pedidoWS.anio + ', ';
        pedido += ' diaSemana=' + pedidoWS.diaSemana + ', ';
        pedido += ' fechaInspeccion=' + pedidoWS.fechaInspeccion + ', ';
        pedido += ' fechaEmbBodega=' + pedidoWS.fechaEmbBodega + ', ';
        pedido += ' fechaEntrega=' + pedidoWS.fechaEntrega + ', ';
        pedido += ' tipoSurtido=' + pedidoWS.tipoSurtido + ', ';
        pedido += ' tipoVenta=' + pedidoWS.tipoVenta + ', ';
        pedido += ' tipoPedidoCte=' + pedidoWS.tipoPedidoCte + ', ';
        pedido += ' tipoPedidoViz=' + pedidoWS.tipoPedidoViz + ', ';
        pedido += ' tipoEntrega=' + pedidoWS.tipoEntrega + ', ';
        pedido += ' tipoEmbarque=' + pedidoWS.tipoEmbarque + ', ';
        pedido += ' fechaCita=' + pedidoWS.fechaCita + ', ';
        pedido += ' autorizado=' + pedidoWS.autorizado + ', ';
        pedido += ' liberado=' + pedidoWS.liberado + ', ';
        pedido += ' motivoRechazoCartera=' + pedidoWS.motivoRechazoCartera + ', ';
        pedido += ' fleteLibra=' + pedidoWS.fleteLibra + ', ';
        pedido += ' importeTotalPedido=' + pedidoWS.importeTotalPedido + ', ';
        pedido += ' cantidadKGSTotalPedido=' + pedidoWS.cantidadKGSTotalPedido + ', ';
        pedido += ' observacionGralPedido=' + pedidoWS.observacionGralPedido + ', ';
        pedido += ' motivoCancelacion=' + pedidoWS.motivoCancelacion + ', ';
        pedido += ' atendido=' + pedidoWS.atendido + ', ';
        pedido += ' fechaRegistro=' + pedidoWS.fechaRegistro + ', ';
        pedido += ' horaRegistro=' + pedidoWS.horaRegistro + ', ';
        pedido += ' vendedorModifico=' + pedidoWS.vendedorModifico + ', ';
        pedido += ' fechaModifico=' + pedidoWS.fechaModifico + ', ';
        pedido += ' horaModifico=' + pedidoWS.horaModifico + ', ';
        pedido += ' vendedorElimino=' + pedidoWS.vendedorElimino + ', ';
        pedido += ' fechaElimino=' + pedidoWS.fechaElimino + ', ';
        pedido += ' horaElimino=' + pedidoWS.horaElimino + ', ';
        pedido += ' estatusPedido=' + pedidoWS.estatusPedido + ', ';
        pedido += ' idPedidoSF=' + pedidoWS.idPedidoSF + ', ';
        pedido += ' folioPedidoSDL=' + pedidoWS.folioPedidoSDL + ', ';
        pedido += ' folioEmbarqueSDL=' + pedidoWS.folioEmbarqueSDL + ', ';

        PedidosMayoreoWS.ArrayOfPedidoMayoreoDetalle detalle = pedidoWS.Detalle;
        PedidosMayoreoWS.PedidoMayoreoDetalle[] arrayProductos = detalle.PedidoMayoreoDetalle;
        String productos = ' Productos: ';
        for(PedidosMayoreoWS.PedidoMayoreoDetalle prod:arrayProductos){
            productos += ' producto=' + prod.producto + ', ';
            productos += ' marca=' + prod.marca + ', ';
            productos += ' pallets=' + prod.pallets + ', ';
            productos += ' cjXPallets=' + prod.cjXPallets + ', ';
            productos += ' piezas=' + prod.piezas + ', ';
            productos += ' cajas=' + prod.cajas + ', ';
            productos += ' cantidadKGS=' + prod.cantidadKGS + ', ';
            productos += ' autorizaPrecio=' + prod.autorizaPrecio + ', ';
            productos += ' precioSAPCte=' + prod.precioSAPCte + ', ';
            productos += ' tipoPrecioSAP=' + prod.tipoPrecioSAP + ', ';
            productos += ' folioPrecioSAPCte=' + prod.folioPrecioSAPCte + ', ';
            productos += ' precioSAPViz=' + prod.precioSAPViz + ', ';
            productos += ' folioPrecioSAPViz=' + prod.folioPrecioSAPViz + ', ';
            productos += ' unidadPeso=' + prod.unidadPeso + ', ';
            productos += ' tipoPeso=' + prod.tipoPeso + ', ';
            productos += ' librasPeso=' + prod.librasPeso + ', ';
            productos += ' productoRelacion=' + prod.productoRelacion + ', ';
            productos += ' importeTotXProducto=' + prod.importeTotXProducto + ', ';
            productos += ' importeTotXProductoViz=' + prod.importeTotXProductoViz + ', ';
            productos += ' observacionesxProducto=' + prod.observacionesxProducto + ', ';

            PedidosMayoreoWS.ArrayOfPedidoMayoreoInventario inventario = prod.inventario;
            PedidosMayoreoWS.PedidoMayoreoInventario[] disponibilidad = inventario.PedidoMayoreoInventario;
            String disp = ' Inventario:';
            for(PedidosMayoreoWS.PedidoMayoreoInventario inv:disponibilidad){
                disp += ' origenSurtido=' + inv.origenSurtido + ', ';
                disp += ' producto=' + inv.producto + ', ';
                disp += ' dispoActiva=' + inv.dispoActiva + ', ';
                disp += ' tipoInventario=' + inv.tipoInventario + ', ';
                disp += ' cantidadCajas=' + inv.cantidadCajas + ', ';
            }
            productos += disp;
        }

        pedido += productos;

        return pedido;
    }

    public static Map<String, List<OpportunityLineItem>> getProdsXCodigo( List<OpportunityLineItem> items ) {
        if( items == null ) { return null; }

        Map<String, List<OpportunityLineItem>> mapPCode = new Map<String, List<OpportunityLineItem>>();

        for( OpportunityLineItem item: items ) {
            if( item == null ) { continue; }
            if( String.isBlank( item.ProductCode ) ) { continue; }
            if( String.isBlank( item.Tipo_de_Inventario__c ) ) { continue; }

            System.debug('codigo de producto:' + item.ProductCode);
            List<OpportunityLineItem> temp = mapPCode.get( item.ProductCode );
            if( temp == null ) {
                temp = new List<OpportunityLineItem>();
                mapPcode.put( item.ProductCode, temp );
            }
            temp.add( item );
        }

        return mapPCode;
    }

    private static User retrieveUserInfo( String userId ) {
        User u = new User();
        u.Id = userId;
        try {
            u = [SELECT Id, FirstName, LastName, Username, UserRole.Name
                 FROM User
                 WHERE Id =: userId LIMIT 1];
        }
        catch( Exception e ) {
            System.debug('Hubo un problema al buscar al usuario! ' + e.getMessage());
            return u;
        }

        return u;
    }

    private static String getDOF( Datetime fe ) {
        String dof = '0';
        if( fe == null ) { return dof; }
        String day = fe.format('EEEE').toUpperCase();

        if( day.equalsIgnoreCase('LUNES') || day.equalsIgnoreCase('MONDAY') ) { System.debug('DOF: '+day);
            dof = '1';
        }
        else if( day.equalsIgnoreCase('MARTES') || day.equalsIgnoreCase('TUESDAY') ) { System.debug('DOF: '+day);
            dof = '2';
        }
        else if( day.equalsIgnoreCase('MIÉRCOLES') || day.equalsIgnoreCase('MIERCOLES') || day.equalsIgnoreCase('WEDNESDAY') ) { System.debug('DOF: '+day);
            dof = '3';
        }
        else if( day.equalsIgnoreCase('JUEVES') || day.equalsIgnoreCase('THURSDAY') ) { System.debug('DOF: '+day);
            dof = '4';
        }
        else if( day.equalsIgnoreCase('VIERNES') || day.equalsIgnoreCase('FRIDAY') ) { System.debug('DOF: '+day);
            dof = '5';
        }
        else if( day.equalsIgnoreCase('SÁBADO') || day.equalsIgnoreCase('SABADO') || day.equalsIgnoreCase('SATURDAY') ) { System.debug('DOF: '+day);
            dof = '6';
        }
        else if( day.equalsIgnoreCase('DOMINGO') || day.equalsIgnoreCase('SUNDAY') ) { System.debug('DOF: '+day);
            dof = '7';
        }

        return dof;
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
    
    /// cambios cedis y agencias
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
	        areaResp = PedidosOtrosCanalesUtils.ObtenerCanalVenta(pedido);
	        system.debug('areaResp:  '+areaResp);
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
	         		system.debug('pedido.Canal_Factura__r.Opera_en_SAP__c:  '+pedido.Canal_Factura__r.Opera_en_SAP__c);
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
		     if(pedido.StageName == '10 - Pedido Bloqueado')
		     {
		     	 ActualizaNSC= false;
		     	 ActualizaSAP= false;
		     }
	        
     
    }  
    
    public class ParserWSException extends Exception {}
}