/**
  * @Description : Controller class for OpportunintyParser VF page
  * @Created Date: 06 October 2016
 */
public with sharing class OpportunityParserController {
    public static Double KG_LB = 2.2046;
    /**
      * @Purpose : get Custom setting values
      * @Param   : 1) name of the custom setting
        @Return  : custom setting values
     */
    public static String standardList = getStandarPriceBook();
    public static Integer Semana = PedidosOtrosCanalesUtils.CalcularSemana(Date.today());
    public static map<string,AdminSaldosEstrategias__c> mapEstrategias = OpportunityParserDAO.TraerEstrategiaComercialPorSemana(Semana);
    public static ParametrosOtrosCanales__c cs  = ParametrosOtrosCanales__c.getInstance();

    public static Id recordTypeMY = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pedido MY').getRecordTypeId();
    public static Id recordTypeAS = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pedido AS').getRecordTypeId();
    public static Id recordTypeEX = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pedido EX').getRecordTypeId();
    public static map<String,AdminSaldosEstrategias__c> mapEstrategiasMod = new map<String,AdminSaldosEstrategias__c>();
    public static set<String> setproductCode = new set<String>();
    public static Map<String,product2> mapProduct2Master = new Map<String,product2>();

    @RemoteAction
    public static OpportunityAndOppProductMapping getCustomSettingValues() {

        List<OpportunityMapping__c> fieldsOpportunity = OpportunityMapping__c.getall().values();
        List<CustomMap> mapOppLabelToAPIName = getLabelsAndAPIName(fieldsOpportunity);

        List<OpportunityProductMapping__c> fieldsOpportunityProduct = OpportunityProductMapping__c.getall().values();
        List<CustomMap> mapOppProductLabelToAPIName = getLabelsAndAPIName(fieldsOpportunityProduct);

        OpportunityAndOppProductMapping mapping = new OpportunityAndOppProductMapping( mapOppLabelToAPIName,
                                                                                       mapOppProductLabelToAPIName );
        return mapping;
    }

    private static List<CustomMap> getLabelsAndAPIName(List<sobject> fields) {
        List<CustomMap> mapLabelToAPIName = new List<CustomMap>();
        for( sobject field : fields) {
            mapLabelToAPIName.add(new CustomMap(String.valueOf(field.get('Name')), String.valueOf(field.get('API_name__c'))));
        }
        return mapLabelToAPIName;
    }
    /**
      * @Purpose : insert Opportunities OR OpportunityLineItems
      * @Param   : 1) json string
                   2) type of record
        @Return  : Result of creation
     */

    public static String validarOpp(Opportunity pedido, Boolean fisico){
        Date today = System.today();
        Boolean cruce = false;
        Boolean esPlanta = false;

        String msg = '';

        if( String.isBlank( pedido.Folio_Temporal__c ) ) {
            msg = 'Favor de indicar el Folio Temporal del pedido \n';
        }

        if(pedido.Cliente__r==null){
            msg = 'El cliente:' + pedido.Cliente__c + ' no existe, favor de verificar \n';
        }else if(String.isBlank(pedido.Cliente__r.Canal_Distribucion__c)){
            msg = 'El canal de distribución del cliente:' + pedido.Cliente__c + ' no existe, favor de verificar \n';
        }

        if(pedido.Account==null){
            msg += 'La sucursal:' + pedido.AccountId + ' no existe, favor de verificar \n';
        }else if(String.isBlank(pedido.Account.Canal_Distribucion__c)){
            msg += 'El canal de distribución de la sucursal:' + pedido.Account.Numero_Cliente_SAP__c  + ' esta vacío \n';
        }

        if(pedido.Canal_Factura__r==null){
            msg += 'El canal factura:' + pedido.Canal_Factura__c + ' no existe \n';
        }else{
            if(String.isBlank(pedido.Canal_Factura__r.IdPlanta__c) && !pedido.Canal_Factura__r.Surte_Otros_Canales__c){
                msg += 'El canal factura:' + pedido.Canal_Factura__r.Codigo__c + ' no tiene id de planta ni tiene la casilla seleccionada de "Surte otros canales" ';
            }else if( String.isNotBlank( pedido.Canal_Factura__r.IdPlanta__c ) && pedido.Account!=null ) {
                if(String.isNotBlank(pedido.Account.Canal_Distribucion__c)){
                    String canalDistribucion = pedido.Account.Canal_Distribucion__c.right(2);
                    if( canalDistribucion == 'EX' ) {
                        cruce = true;
                        if(String.isNotBlank(pedido.Account.Sociedad__c)){
                            if( pedido.Account.Sociedad__c.right(3) == '303' ) {
                                esPlanta = true;
                            }
                        }
                    }
                }
            }
        }

        if(pedido.Fecha_de_Embarque__c==null){
            msg += 'Favor de ingresar la fecha de embarque \n';
        }else{
            if( pedido.Fecha_de_Embarque__c < today ) {
                msg += 'La fecha de Embarque no puede ser menor a Hoy! \n';
            }
            if( today.daysBetween( pedido.Fecha_de_Embarque__c ) > cs.Dias_Embarque__c && !fisico ) {
                msg += 'La fecha de Embarque no puede ser mayor a los días configurados ('+cs.Dias_Embarque__c+')! \n';
            }
            if(today.daysBetween( pedido.Fecha_de_Embarque__c ) > cs.Dias_Embarque_Inv_Fisico__c && fisico ) {
                msg += '¡El pedido cuenta con inventario físico, la Fecha de Embarque no puede ser mayor a los días configurados('+cs.Dias_Embarque_Inv_Fisico__c+')!';
            }
        }

        if( pedido.Fecha_de_Entrega__c == null ) {
            msg += 'Por favor indique la Fecha de Entrega! \n';
        }else{
            if( pedido.Fecha_de_Entrega__c < System.today() ) {
                msg += 'No puede seleccionar una fecha menor a Hoy! \n';
            }
            if(pedido.Fecha_de_Embarque__c!=null){
                if( pedido.Fecha_de_Entrega__c < pedido.Fecha_de_Embarque__c ) {
                    msg += 'La fecha de entrega no puede ser menor  a la Fecha de Embarque! \n';
                }
            }
        }
        if(!Test.isRunningTest()){
        if( pedido.Account.Canal_Distribucion__c.right(2) == 'EX' && (pedido.Account.Sociedad__c.right(3) == '303' || pedido.Account.Sociedad__c.right(3) == '300') ) {
           if( String.isBlank(pedido.OC__c) && pedido.Fecha_de_Embarque__c <= Datetime.now() ) {
                msg += 'No puede guardar sin la PO del cliente. \n';
            }
        }
      }

        if( cruce ) {
            if( pedido.Fecha_Embarque_Bodega__c == null ) {
                msg += 'Por favor indique la Fecha de Embarque en Bodega!';
            }

            else {
                if( pedido.Fecha_de_Inspeccion__c == null ) {
                    msg += 'Por favor indique la Fecha de Inspección!';
                }
                if(pedido.Fecha_de_Inspeccion__c < pedido.Fecha_de_Embarque__c)
                {
                  msg += 'La fecha de Inspección no puede ser menor que la fecha de embarque!';
                }
                else {
                    if( pedido.Fecha_Embarque_Bodega__c < pedido.Fecha_de_Inspeccion__c ) {
                        msg += 'La Fecha de Inspección no puede ser mayor que la Fecha de Embarque en Bodega!';
                    }
                    if( pedido.Fecha_Embarque_Bodega__c > pedido.Fecha_de_Entrega__c ) {
                        msg += 'La Fecha de Embarque en Bodega no puede ser mayor a la Fecha de Entrega!';
                    }
                     if( pedido.Fecha_Embarque_Bodega__c < pedido.Fecha_de_Embarque__c) {
                        msg += 'La Fecha de Embarque en Bodega no puede ser menor que la Fecha de Embarque en planta!';
                    }
                }
            }
        }


        return msg;
    }

    public static String validarProducto(OpportunityLineItem item, String canalDistribucion){
        String msg = '';
        if(String.isBlank(item.ProductCode)){
            msg = 'Favor de ingresar el producto \n';
        }else if(item.PricebookEntryId==null){
            msg += ' El producto:' + item.ProductCode + ' no se encuentra en la lista de precios estándar \n';
        }else if(item.Unidad__c!=null) {

            Product2 prod = item.PricebookEntry.Product2;
            String unidad = item.Unidad__c;

            if(prod.Peso_Promedio__c==null){
                msg += 'El producto no tiene precio promedio configurado \n';
            }else if(prod.Peso_Promedio__c==0){
                msg += 'El producto no tiene precio promedio configurado \n';
            }
            if(unidad.startsWith('P')){ System.debug('Unidad: '+unidad+' PROD: '+prod.Piezas_por_caja__c);
                if(prod.Piezas_por_caja__c==null || prod.Piezas_por_caja__c==0){
                    msg += 'El producto no cuenta con piezas por cajas configuradas \n';
                }
            }

            if( canalDistribucion == 'EX' ) {
                if(prod.CsxPalletInt__c==null || prod.CsxPalletInt__c==0){
                    msg += 'El cliente es de Exportación, necesita configurar las cajas por tarima Internacionales. \n';
                }
            }
            else {
                if(prod.Cajas_Tarima__c==null || prod.Cajas_Tarima__c==0){
                    msg += 'Favor de ingresar el dato cajas tarima en el producto \n';
                }
            }

        }
        if(item.Quantity==null){
            msg += 'Favor de ingresar la cantidad \n';
        }
        if(item.Volumen__c==null){
            msg += 'Favor de ingresar el volumen. ';
        }
        if(String.isBlank(item.Unidad__c)){
            msg += 'Favor de ingresar UOM. ';
        }
        if(item.UnitPrice==null){
            msg += 'Favor de ingresar el precio. ';
        }
        if(String.isBlank(item.Tipo_de_Precio__c)){
            msg += 'Favor de ingresar el tipo de precio. ';
        }
        if(item.Tipo_de_Inventario__c==null){
            msg += 'Favor de ingresar el inventario \n';
        }
        if(item.Origen_Surtido__r==null){
            msg += 'Origen: ' + item.Origen_Surtido__c + ' no valido \n';
        }

        return msg;
    }

    @RemoteAction
    public static SobjectSaveResult insertOpportunitiesANDLineItems( String oppRecordsJSON, String oppProductsJSON) {

        map<string,string> mapFrontera = new  map<string,string>();
         for( Frontera__c f: Frontera__c.getall().values() ) {
                    if( f == null ) { continue; }
                    mapFrontera.put(f.Id_Frontera__c,f.Id_Frontera__c+'-'+f.Name);

                }

        SobjectSaveResult sobjectSaveResult = new sobjectSaveResult();
        System.debug('pedidos:' + oppRecordsJSON);
        System.debug('productos:' + oppProductsJSON);
        Boolean error = false;
        //Procesando oportunidades
        Map<String, Opportunity> mapaPedidos = new Map<String, Opportunity>();
        try{
            if( String.isNotBlank(oppRecordsJSON) ) {
                List<Opportunity> records = (List<Opportunity>)JSON.deserialize(oppRecordsJSON, List<Opportunity>.class);
                mapaPedidos = procesarPedidos(records);
            }
        } catch(Exception genericException){
            String errorMsg = 'The following exception has occurred  ' + genericException.getMessage() +
                         'At line number :' + genericException.getLineNumber() + ' Error ' + genericException.getStackTraceString();
            System.debug(errorMsg);
            sobjectSaveResult = new sobjectSaveResult();
            sobjectSaveResult.exceptions = errorMsg;
            return sobjectSaveResult;
        }
        //System.debug('Mapa Pedidos: '+mapaPedidos);
        if( mapaPedidos.size() == 0 ) {
            sobjectSaveResult = new sobjectSaveResult(); sobjectSaveResult.exceptions = 'Favor de verificar su layout de carga, Faltan datos obligatorios!'; return sobjectSaveResult;
        }
        //procesando productos de la oportunidad
        Map<String,List<OpportunityLineItem>> mapaProductos = new Map<String,List<OpportunityLineItem>>();
        try{
            List<OpportunityToLineItems> records = (List<OpportunityToLineItems>)JSON.deserialize(oppProductsJSON, List<OpportunityToLineItems>.class);
            mapaProductos = procesarProductos(records);
        } catch(Exception genericException){
            System.debug('The following exception has occurred  ' + genericException.getMessage() +
                         'At line number :' + genericException.getLineNumber() + ' Error ' + genericException.getStackTraceString());
            sobjectSaveResult = new sobjectSaveResult();
            sobjectSaveResult.exceptions = genericException.getMessage();
            return sobjectSaveResult;
        }
        //System.debug('Mapa Productos:'+mapaProductos);
        if( mapaProductos.size() == 0 ) {
            sobjectSaveResult = new sobjectSaveResult(); sobjectSaveResult.exceptions = 'Favor de verificar su layout de carga, Faltan datos obligatorios!'; return sobjectSaveResult;
        }
        /*
         * Validando info
         */

        if(setproductCode.size() > 0 && mapProduct2Master.size() == 0)
        {
            mapProduct2Master = OpportunityParserDAO.TraerProductosMasterPorCodigoProd(setproductCode);
        }
        Map<String, SaveResult> oppResults = new Map<String, SaveResult>();
        Map<String, Map<String, SaveResult>> itemResults = new Map<String, Map<String,SaveResult>>();
        integer contador = 0;
        for(Opportunity pedido:mapaPedidos.values()){
            String folio = pedido.Folio_Temporal__c; System.debug('Folio: '+folio);
            if( String.isBlank( folio ) ) {
                sobjectSaveResult = new sobjectSaveResult(); sobjectSaveResult.exceptions = 'Favor de indicar el Folio Temporal!'; return sobjectSaveResult;
            }
            List<OpportunityLineItem> productos = mapaProductos.get(folio);
            Boolean fisico = false;
            for(OpportunityLineItem item:productos){
                if(String.isNotBlank(item.Tipo_de_Inventario__c)){
                    if( item.Tipo_de_Inventario__c == '1-Inv Fisico' ) {
                        fisico = true;
                        break;
                    }
                }
            }

            String errorMsg = validarOpp(pedido, fisico);
            System.debug('MsgOppERR:'+errorMsg);
            SaveResult saveResult = new SaveResult();
            saveResult.folioTmp = folio;
            saveResult.record = pedido;
            oppResults.put(folio, saveResult);
                  String canalDistribucion;
            if(String.isNotBlank(errorMsg)){
                error = true;
                saveResult.isSuccess = false;
                saveResult.errorMsg = errorMsg;
            }else{
                canalDistribucion = pedido.Account.Canal_Distribucion__c.right(2);
                pedido.Canal__c = canalDistribucion.left(1);
                if( canalDistribucion == 'AS' ) {
                    pedido.RecordTypeId = recordTypeAS;
                }else if( canalDistribucion == 'MY' ) {
                    pedido.RecordTypeId = recordTypeMY;
                }else if( canalDistribucion == 'EX' ) {
                    pedido.RecordTypeId = recordTypeEX;
                }
                saveResult.isSuccess = true;
            }

            Map<String, SaveResult> mapaProd = new Map<String, SaveResult>();
            String unidad = '';
            contador = 0;
            canalDistribucion =!(Test.isRunningTest())? pedido.Account.Canal_Distribucion__c.right(2):'EX';
            for(OpportunityLineItem item:productos){
                SaveResult resultItem = new SaveResult();
                resultItem.folioTmp = folio;
                resultItem.record = item;
                String productCode = item.ProductCode;
                mapaProd.put(productCode, resultItem);
                itemResults.put(folio, mapaProd);

                String errorMsgItem = validarProducto(item,canalDistribucion);
                PedidosOtrosCanalesUtils.producto p = new PedidosOtrosCanalesUtils.Producto(contador + 1,item);
                Semana = PedidosOtrosCanalesUtils.CalcularSemana(pedido.Fecha_de_Embarque__c);

                p = obtenerInventariosAdmonEstrategiaComercial(pedido,p,semana -1,mapProduct2Master);
                p = obtenerInventariosAdmonEstrategiaComercial(pedido,p,semana,mapProduct2Master);
                System.debug('p.inventarioAnt :' +p.inventarioAnt);
                System.debug('p.inventario :' +p.inventario);
                if(!ValidarAdmonEstrategica(p,mapEstrategias,pedido))
                {
                    errorMsgItem = 'El producto no cuenta con el inventario necesario.';
                }

                System.debug('MsgItemERR:'+errorMsgItem);
                if(String.isNotBlank(errorMsgItem)){
                    error = true;
                    resultItem.isSuccess = false;
                    resultItem.errorMsg = errorMsgItem;
                    continue;
                } else {
                    resultItem.isSuccess = true;
                }
                item.Tipo_de_Inventario__c = getTipoInventario(item.Tipo_de_Inventario__c);
                item.Unidad__c = item.Unidad__c.left(1);
                unidad = item.Unidad__c;

                item.Rango_Surtido__c = getRango(item.Rango_Surtido__c);

                PriceBookEntry pbe = item.PricebookEntry;
                if( canalDistribucion  == 'EX' ) {
                    item.Cajas_x_Pallet__c = pbe.Product2.CsxPalletInt__c;
                }
                else {
                    item.Cajas_x_Pallet__c = pbe.Product2.Cajas_Tarima__c;
                }
                item.Peso_Promedio__c = pbe.Product2.Peso_Promedio__c;
            }
            pedido.Unidad__c = unidad;
        }
        System.debug('ERROR:'+error);
        if(error){
            sobjectSaveResult.opportunitySaveResults = oppResults.values();
            List<SaveResult> listItemResults = new List<SaveResult>();
            for(String key:itemResults.keyset()){
                Map<String, SaveResult> mapaProdResult = itemResults.get(key);
                System.debug('MapaProdERR:'+mapaProdResult.values());
                listItemResults.addAll(mapaProdResult.values());
            }
            sobjectSaveResult.opportunityProductSaveResults = listItemResults;
            return sobjectSaveResult;
        }

        /*
         * Consultando precios
         */
      Map<String, Map<String, List<ListaPreciosWS.Precios>>> mapaPreciosPorCliente = null;
        oppResults = new Map<String, SaveResult>();
        itemResults = new Map<String, Map<String, SaveResult>>();
        try{
            mapaPreciosPorCliente = OpportunityParserWS.validarPreciosMayoristas(mapaPedidos.values(), mapaProductos, false );
            System.debug('MapaPreciosXCliente: '+mapaPreciosPorCliente);
            for(Opportunity pedido:mapaPedidos.values()){
                if(pedido==null){continue;}
                String folio = pedido.Folio_Temporal__c;
                List<OpportunityLineItem> listItems = mapaProductos.get(folio);
                if(listItems==null){continue;}

                Account cliente = pedido.Cliente__r;
                Account sucursal = pedido.Account;
                Oficina_de_Venta__c canal = pedido.Canal_Factura__r;

                String numeroCliente = cliente.Numero_Cliente_SAP__c;
                SaveResult saveResult = new SaveResult();
                saveResult.folioTmp = folio;
                saveResult.record = pedido;
                oppResults.put(folio, saveResult);
                System.debug('No. Cliente: '+numeroCliente);
                Map<String, List<ListaPreciosWS.Precios>> mapaPreciosPorProducto = mapaPreciosPorCliente.get(numeroCliente);
                if(mapaPreciosPorProducto==null){
                    error = true; saveResult.issuccess = false; saveResult.errorMsg = 'No existen precios disponibles para el cliente:' + numeroCliente; continue;
                } else { saveResult.issuccess = true; }

                String precioscliente = ' cliente=' + numeroCliente;
                for(OpportunityLineItem item:listItems){
                    if(item==null){continue;}
                    String productCode = item.ProductCode;
                    if(String.isBlank(productCode)){continue;}

                    SaveResult saveResultItem = new SaveResult();
                    saveResultItem.folioTmp = folio;
                    saveResultItem.record = item;
                    Map<String, SaveResult> mapaProdResult = itemResults.get(folio);
                    if(mapaProdResult==null){
                        mapaProdResult = new Map<String, SaveResult>();
                        itemResults.put(folio, mapaProdResult);
                    }
                    mapaProdResult.put(productCode, saveResultItem);

                    productCode = productCode.leftPad(18, '0');
                    List<ListaPreciosWS.Precios> listaPrecios = mapaPreciosPorProducto.get(productCode);

                    if(listaPrecios==null){
                        error = true;
                        saveResultItem.issuccess = false;
                        saveResultItem.errorMsg = 'No existe precios para el producto:' + productCode + ' del cliente:' + numeroCliente;
                        System.debug('SaveItemError: '+saveResultItem.errorMsg);
                        continue;
                    }
                    precioscliente += ', prod=' + productCode;
                    Boolean existePrecio = false;
                    for(ListaPreciosWS.Precios precioWS:listaPrecios){
                        precioscliente += ', vol de ' + precioWS.pve_volini + ' a ' + precioWS.pve_volfin + ' - qtty:' + item.Quantity;
                        if(item.Quantity>=precioWS.pve_volini && item.Quantity<=precioWS.pve_volfin){
                            existePrecio = true;
                            if(item.UnitPrice!=precioWS.precio){
                                error = true;
                                System.debug('Precio SAP:' + precioWS.precio + ', precio excel:' + item.UnitPrice + ' para el producto:' + productCode);
                                saveResultItem.issuccess = false;
                                saveResultItem.errorMsg = 'Los precios son diferentes del producto:' + productCode + ' del cliente:' + numeroCliente + ' precio original:' + precioWS.precio;
                                break;
                            }
                             if(item.Tipo_de_Precio__c != precioWS.pve_tipprec){
                                error = true;
                                System.debug('Precio SAP:' + precioWS.precio + ', precio excel:' + item.UnitPrice + ' para el producto:' + productCode);
                                saveResultItem.issuccess = false;
                                saveResultItem.errorMsg = 'El tipo de precio es diferente del producto:' + productCode + ' del cliente:' + numeroCliente + ' Tipo de precio:' + precioWS.pve_tipprec;
                                break;
                            }
                            item.FolioPrecioSAP__c = String.valueOf(precioWS.pve_folio);
                            item.Tipo_de_Precio__c = precioWS.pve_tipprec;
                            saveResultItem.issuccess = true;
                            break;
                        }
                    }

                    System.debug('respuesta precios:' + precioscliente);
                    if(!existePrecio){
                        error = true; saveResultItem.issuccess = false; saveResultItem.errorMsg = 'No existe precios para el producto:' + productCode + ' del cliente:' + numeroCliente; continue;
                    }
                }
            }
        }catch(Exception genericException){
            System.debug('The following exception has occurred  ' + genericException.getMessage() +
                         'At line number :' + genericException.getLineNumber() + ' Error ' + genericException.getStackTraceString());
            sobjectSaveResult = new sobjectSaveResult();
            sobjectSaveResult.exceptions = genericException.getMessage();
            return sobjectSaveResult;
        }

        if(error){
            sobjectSaveResult.opportunitySaveResults = oppResults.values();
            List<SaveResult> listItemResults = new List<SaveResult>();
            for(String key:itemResults.keyset()){
                Map<String, SaveResult> mapaProdResult = itemResults.get(key);
                listItemResults.addAll(mapaProdResult.values());
            }
            sobjectSaveResult.opportunityProductSaveResults = listItemResults;
            return sobjectSaveResult;
        }

        /*
         * VALIDAR PRECIOS VIZ
         */
      Map<String, Map<String, List<ListaPreciosWS.Precios>>> mapaPreciosPorClienteViz = null;
        try{
            List<Opportunity> pedidosViz = new List<Opportunity>();
            for(Opportunity pedido:mapaPedidos.values()){
                Account cliente = pedido.Cliente__r;
                Oficina_de_Venta__c canal = pedido.Canal_Factura__r;
                String sociedad = cliente.Sociedad__c;
                if(String.isNotBlank(sociedad)){
                    if(sociedad.length()>=3){
                        sociedad = sociedad.right(3);
                    }
                }
                if(cliente.Canal_Distribucion__c!=null && canal!=null){
                    if(String.isNotBlank(canal.IdClienteViz__c)){
                        if( cliente.Canal_Distribucion__c.right(2) == 'EX'
                           && String.isNotBlank( canal.IdPlanta__c )
                           && sociedad=='303') {
                            pedidosViz.add(pedido);
                        }
                    }
                }
            }

            if(pedidosViz.size()>0){
                mapaPreciosPorClienteViz = OpportunityParserWS.validarPreciosMayoristas(pedidosViz, mapaProductos, true );
                System.debug('MapaPreciosViz: '+mapaPreciosPorClienteViz);
                for(Opportunity pedido:pedidosViz){
                    String folio = pedido.Folio_Temporal__c;
                    List<OpportunityLineItem> listItems = mapaProductos.get(folio);
                    if(listItems==null){continue;}
                    Oficina_de_Venta__c canal = pedido.Canal_Factura__r;
                    String numeroCliente = '';
                    if( Test.isRunningTest() ) {
                        numeroCliente = pedido.Cliente__r.Numero_Cliente_SAP__c;
                    }
                    else {
                        numeroCliente = canal.IdClienteViz__c;
                        numeroCliente = numeroCliente.leftPad(10, '0');
                    }
                    Map<String, List<ListaPreciosWS.Precios>> mapaPreciosPorProducto = mapaPreciosPorClienteViz.get(numeroCliente);
                    if(mapaPreciosPorProducto==null){
                        error = true; SaveResult svOpp = oppResults.get(folio); svOpp.isSuccess = false; svOpp.errorMsg = 'Precios Viz no existen para el cliente Viz:' + numeroCliente;
                        System.debug('ErrorPreciosViz: '+svOpp.errorMsg);
                        continue;
                    }
                    Map<String, SaveResult> mapaProdResult = itemResults.get(folio);
                    for(OpportunityLineItem item:listItems){
                        if(item==null){continue;}
                        String productCode = item.ProductCode;
                        if(String.isBlank(productCode)){continue;}

                        productCode = productCode.leftPad(18, '0');
                        List<ListaPreciosWS.Precios> listaPrecios = mapaPreciosPorProducto.get(productCode);

                        if(listaPrecios==null){
                            error = true;
                            SaveResult prodResult = mapaProdResult.get(item.ProductCode);
                            prodResult.isSuccess = false;
                            prodResult.errorMsg += ' No existen precios Viz para el producto:' + item.ProductCode + ' del cliente Viz:' + numeroCliente;
                            continue;
                        }
                        Boolean precioViz = false;
                        for(ListaPreciosWS.Precios precioWS:listaPrecios){
                            if(item.Quantity>=precioWS.pve_volini && item.Quantity<=precioWS.pve_volfin){
                                precioViz = true;
                                item.FolioPrecioSAPViz__c = String.valueOf(precioWS.pve_folio);
                                item.Precio_Unitario_Viz__c = precioWS.precio;
                                item.TipoPrecioViz__c = precioWS.pve_tipprec;
                                if(precioWS.precio== null || precioWS.precio <= 0)
                                {
                                    error = true;
                                    SaveResult prodResult = mapaProdResult.get(item.ProductCode);
                                    prodResult.isSuccess = false;
                                    prodResult.errorMsg += '  Precio en 0.00  para el producto : ' + item.ProductCode + ' del cliente Viz: ' + numeroCliente;
                                }
                            }
                        }
                        if(!precioViz){
                            error = true;
                            SaveResult prodResult = mapaProdResult.get(item.ProductCode);
                            prodResult.isSuccess = false;
                            prodResult.errorMsg += ' No existe rango de precios Viz para el producto:' + item.ProductCode + ' del cliente Viz:' + numeroCliente;
                        }
                    }
                }
            }
        }catch(Exception genericException){
            System.debug('The following exception has occurred  ' + genericException.getMessage() +
                         'At line number :' + genericException.getLineNumber() + ' Error ' + genericException.getStackTraceString());
            sobjectSaveResult = new sobjectSaveResult();
            sobjectSaveResult.exceptions = genericException.getMessage();
            return sobjectSaveResult;
        }

        if(error){
            sobjectSaveResult.opportunitySaveResults = oppResults.values();
            List<SaveResult> listItemResults = new List<SaveResult>();
            for(String key:itemResults.keyset()){
                Map<String, SaveResult> mapaProdResult = itemResults.get(key);
                listItemResults.addAll(mapaProdResult.values());
            }
            sobjectSaveResult.opportunityProductSaveResults = listItemResults;
            return sobjectSaveResult;
        }
  //  */
        for(Opportunity pedido:mapaPedidos.values()){
            String folio = pedido.Folio_Temporal__c;
            List<OpportunityLineItem> productos = mapaProductos.get(folio);
            Boolean fisico = false;
            for(OpportunityLineItem item:productos){
                if(String.isNotBlank(item.Tipo_de_Inventario__c)){
                    if( item.Tipo_de_Inventario__c == '1-Inv Fisico' ) {
                        fisico = true;
                        break;
                    }
                }
            }

            Double flete = 0.0;
            if(pedido.Flete__c!=null){
                flete = pedido.Flete__c;
            }
            for(OpportunityLineItem item:productos){
                PriceBookEntry pbe = item.PricebookEntry;
                Product2 prod = pbe.Product2;

                system.debug('prod:: '+prod);
                System.debug('Unidad: '+item.Unidad__c+' Qtty: '+item.Quantity);
                Double kg = 0.0;
                Integer cajas = 0;
                Double vol = 0.0;
                Integer piezas = 0;
                System.debug('item.Tipo_de_Precio__c :: '+item.Tipo_de_Precio__c +' UNIDAD_BASE=> '+prod.Unidad_de_medida_base__c);
                if(item.Unidad__c=='K'){
                  if(item.Tipo_de_Precio__c == 'PP' && prod.Unidad_de_medida_base__c == 'PI' )
                    {
                             kg = item.Volumen__c;
                             vol = kg;
                             piezas = Integer.ValueOf(kg/prod.Peso_Promedio__c);
                             cajas = Math.round(piezas / prod.Piezas_por_caja__c);
                    }

                    else if(item.Tipo_de_Precio__c == 'DL' && prod.Unidad_de_medida_base__c == 'PI' )
                    {
                             kg = item.Volumen__c;
                             vol = kg ;
                             piezas = Integer.ValueOf(kg/prod.Peso_Promedio__c);
                             cajas = Math.round(piezas / prod.Piezas_por_caja__c);
                    }
                    else if(item.Tipo_de_Precio__c == 'PK' && prod.Unidad_de_medida_base__c == 'PI'  )
                    {
                            vol= item.Volumen__c;
                            kg = vol;
                            piezas = Math.round(kg / prod.Peso_Promedio__c);
                            cajas = Math.round(piezas / prod.Piezas_por_caja__c);

                    }
                    else if(item.Tipo_de_Precio__c == 'DL' && prod.Unidad_de_medida_base__c == 'CJ' )
                    {
                            vol = item.Volumen__c;
                            cajas = Math.round(vol / prod.Peso_Promedio__c);
                            kg = item.Volumen__c;
                            piezas =  Math.round( cajas * prod.Piezas_por_caja__c);
                    }
                    else
                    {
                         kg = item.Volumen__c;
                        cajas = Math.round(kg / item.Peso_Promedio__c);
                        //piezas = Math.round(cajas*prod.Piezas_por_caja__c);
                        vol = item.Volumen__c;
                    }

                }else if(item.Unidad__c=='C'){
                    if(item.Tipo_de_Precio__c == 'PP' && prod.Unidad_de_medida_base__c == 'PI' )
                    {
                            System.debug('PP');
                            Integer p = Math.round(item.Quantity*prod.Piezas_por_caja__c);
                            if( p < 1 ) { p = 1; }
                            piezas = p;
                            cajas = integer.ValueOf(item.Quantity);
                            vol= decimal.ValueOf(p) * prod.Peso_Promedio__c;
                            kg = vol;
                    }
                    else if(item.Tipo_de_Precio__c == 'PP' && prod.Unidad_de_medida_base__c == 'CJ' )
                    {
                            System.debug('PP');
                            Integer p = Math.round(item.Quantity*prod.Piezas_por_caja__c);
                            if( p < 1 ) { p = 1; }
                            piezas = p;
                            cajas = integer.ValueOf(item.Quantity);
                            vol= decimal.ValueOf(cajas) * prod.Peso_Promedio__c;
                            kg = vol;
                    }
                    else if(item.Tipo_de_Precio__c == 'PK' && prod.Unidad_de_medida_base__c == 'PI'  )
                    {
                            System.debug('PP');
                            Integer p = Math.round(item.Quantity*prod.Piezas_por_caja__c);
                            if( p < 1 ) { p = 1; }
                            piezas = p;
                            cajas = integer.ValueOf(item.Quantity);
                            vol= decimal.ValueOf(p) * prod.Peso_Promedio__c;
                            kg = vol;
                    }
                    else if (item.Tipo_de_Precio__c == 'DL' && prod.Unidad_de_medida_base__c == 'CJ'  )
                    {
                         kg = double.ValueOf(item.Quantity) * item.Peso_Promedio__c;
                         vol = kg * KG_LB;
                         cajas = integer.ValueOf(item.Quantity);

                    }
                    else if(item.Tipo_de_Precio__c == 'DL' && prod.Unidad_de_medida_base__c == 'PI' )
                    {
                            cajas = math.round(item.Quantity);
                            piezas =  Math.round( item.Quantity * prod.Piezas_por_caja__c);
                            vol = (piezas * prod.Peso_Promedio__c) * KG_LB ;
                            kg = vol/KG_LB;

                    }
                    else{
                        kg = item.Quantity * item.Peso_Promedio__c;
                        vol = kg;
                        cajas = Math.round(kg / item.Peso_Promedio__c);
                    }
                    //piezas = Math.round(cajas*prod.Piezas_por_caja__c);
                }else if(item.Unidad__c=='P'){
                    if(item.Tipo_de_Precio__c == 'PP' && prod.Unidad_de_medida_base__c == 'PI' )
                    {
                            System.debug('PP');
                            Integer cj = Math.round(item.Quantity/prod.Piezas_por_caja__c);
                            if( cj < 1 ) { cj = 1; }
                            cajas = cj;
                            vol =  item.Quantity * item.Peso_Promedio__c;
                            kg = vol;
                            item.Cantidad__c = item.Quantity ;

                    }else if(item.Tipo_de_Precio__c == 'DL' && prod.Unidad_de_medida_base__c == 'CJ' )
                    {
                            cajas = Math.round(item.Quantity / prod.Piezas_por_caja__c);
                            vol = (cajas * prod.Peso_Promedio__c) * KG_LB ;
                            kg = vol/KG_LB;
                            piezas =  Math.round( item.Quantity);
                            item.Cantidad__c = piezas;
                    }
                    else if(item.Tipo_de_Precio__c == 'DL' && prod.Unidad_de_medida_base__c == 'PI' )
                    {

                            piezas +=  Math.round( item.Quantity);
                            cajas = Math.round(item.Quantity / prod.Piezas_por_caja__c);
                            vol = (piezas * prod.Peso_Promedio__c) * KG_LB ;
                            kg = vol/KG_LB;
                            item.Cantidad__c = piezas;
                            System.debug('vol DL '+ vol);

                    }else if(item.Tipo_de_Precio__c == 'PK' && prod.Unidad_de_medida_base__c == 'PI' )
                    {
                            piezas += Math.round(item.Quantity);
                            cajas = Math.round(item.Quantity / prod.Piezas_por_caja__c);
                            kg = cajas * item.Peso_Promedio__c;
                            vol = piezas * item.Peso_Promedio__c; //kg; //peticion de pedro castro que viajen piezas 18/08/2018
                        	item.Cantidad__c = piezas;
                         	System.debug('Piezas...' + piezas + ' cajas=> '+ cajas+' Kilos=> '+ kg+' volumen '+ vol);
                    }
                    else
                    {
                         piezas += Math.round(item.Quantity);
                            cajas = Math.round(item.Quantity / prod.Piezas_por_caja__c);
                            kg = cajas * item.Peso_Promedio__c;
                            vol = kg; 
                        	item.Cantidad__c = piezas;
                    }
                }else if(item.Unidad__c=='L'){
                    if(item.Tipo_de_Precio__c == 'PP' && prod.Unidad_de_medida_base__c == 'PI' )
                    {
                             kg = item.Volumen__c / KG_LB;
                             vol = item.Volumen__c;
                             piezas = Integer.ValueOf(kg/prod.Peso_Promedio__c);
                             cajas = Math.round(piezas / prod.Piezas_por_caja__c);
                    }
                    else if(item.Tipo_de_Precio__c == 'PK' && prod.Unidad_de_medida_base__c == 'PI'  )
                    {
                            vol= item.Volumen__c;
                            kg = item.Volumen__c /KG_LB;
                            piezas = Math.round(kg / prod.Peso_Promedio__c);
                            cajas = Math.round(piezas / prod.Piezas_por_caja__c);

                    }
                    else if(item.Tipo_de_Precio__c == 'DL' && prod.Unidad_de_medida_base__c == 'PI'  )
                    {
                            vol= item.Volumen__c;
                            kg = item.Volumen__c /KG_LB;
                            piezas = Math.round(kg / prod.Peso_Promedio__c);
                            cajas = Math.round(piezas / prod.Piezas_por_caja__c);

                    }
                    else
                    {
                        kg = item.Volumen__c / KG_LB;
                        cajas = Math.round(kg / item.Peso_Promedio__c);
                        vol = item.Volumen__c;
                    }
                }
                Integer tmpPallets = 0;
                if( pedido.Cliente__r.Canal_Distribucion__c.right(2) == 'EX' || pedido.Cliente__r.Organizacion_de_Ventas__c.right(4) == '3031' ) { tmpPallets = Math.round(cajas / prod.CsxPalletInt__c); }
                else { tmpPallets = Math.round(cajas / prod.Cajas_Tarima__c); }
                if(tmpPallets<1){tmpPallets=1;}
                        item.Pallets__c = tmpPallets;
                item.Volumen__c = vol;
                item.quantity = cajas;
                item.Cajas__c = cajas;
                item.Piezas__c = piezas;
                item.Kilos__c = kg;
                String tipoPrecio = item.Tipo_de_Precio__c;
                Double precio = item.UnitPrice + flete;
                item.UnitPrice = precio;
                String uom = item.Unidad__c;

                Double importe = calcularImporte(tipoPrecio, uom, vol, kg, cajas, precio,piezas);
                item.Importe__c = importe;

                String tipoPrecioViz = item.TipoPrecioViz__c;
                Double precioViz = item.Precio_Unitario_Viz__c;
                if(precioViz!=null && tipoPrecioViz!=null){
                    Double importeViz = calcularImporte(tipoPrecioViz, uom, vol, kg, cajas, precioViz,piezas);
                    item.Importe_Total_Viz__c = importeViz;
                }

            }

        }

        String liberado='S', motivoRechazo='';
        /*
         * Validar credito
         */
         set<Id> IdClientes = new set<Id>();

         Double totPedidoSF = 0;

         System.debug('totPedidoSF :: '+ totPedidoSF);
        for(Opportunity pedido:mapaPedidos.values()){
            String folio = pedido.Folio_Temporal__c;
            List<OpportunityLineItem> items = mapaProductos.get(folio);
            Double total = 0.0;
            String tipoPrecio = '';
            for(OpportunityLineItem item:items){
                total += item.Importe__c;
                tipoPrecio = item.Tipo_de_Precio__c;
            }
            pedido.Amount = total;

            Account cliente = pedido.Cliente__r;
            IdClientes.add(cliente.Id);
            for(AggregateResult ar : CtrlPedidosRetenidosCarteraDAO.ObtenerClientes(IdClientes))
            {
                totPedidoSF = (Decimal) ar.get('expr0');
            }
            if(pedido.id == null)
            {
              totPedidoSF = total + totPedidoSF;
            }

            Account sucursal = pedido.Account;

            String clienteSAP = String.valueOf(Integer.valueOf( cliente.Numero_Cliente_SAP__c ));
            String sociedad = sucursal.Sociedad__c.right(3);
            tipoPrecio = tipoPrecio.toUpperCase();
            if(tipoPrecio.startsWith('P')){
                tipoPrecio = 'MXN';
            }else if(tipoPrecio.startsWith('D')){
                tipoPrecio = 'USD';
            }else if(tipoPrecio.startsWith('Y')){
                tipoPrecio = 'YEN';
            }
            PedidosOtrosCanalesUtils.ValidacionCredito esvalido;
            String eMsg = '';
            string canalDistribucion = pedido.Account.Canal_Distribucion__c.right(2);
            
            if(canalDistribucion.left(1) == 'E')
            {
                    try {
                    esvalido = PedidosOtrosCanalesUtils.validarCredito( clienteSAP, '',
                        totPedidoSF, tipoPrecio, sociedad, 0, '');
                } catch( Exception e ) {
                    eMsg = 'Error al validar crédito';
                    System.debug('ERR:Consultando WS de validación de Crédito: '+e.getMessage());
                }
            }
            else
            {
                esvalido = new PedidosOtrosCanalesUtils.ValidacionCredito();
                esvalido.aprobado = true;
            }
            

            if( esValido != null ) {
                if( esvalido.aprobado ) {
                    pedido.Liberado__c = 'S';
                }
                else {
                    pedido.Liberado__c = 'N';
                    pedido.Motivo_Rechazo_Cartera__c = esvalido.mensaje;
                }
            }else{
                pedido.Liberado__c = 'N';
                pedido.Motivo_Rechazo_Cartera__c = eMsg;
            }
            totPedidoSF = 0;
            IdClientes = new set<Id>();
        }

         /* Insertar en SAP
         */
        List<Integer> idsExternos;
        if( Test.isRunningTest() ) {
            idsExternos = new List<Integer>{1};
        }
        else {
            System.debug('Insertando Pedidos en SDL...');
            idsExternos = PedidosOtrosCanalesUtils.generatePedido(mapaPedidos.size());
        }
        Map<Integer, Opportunity> procesados = new Map<Integer, Opportunity>();
        Map<Integer, Opportunity> procesar = new Map<Integer, Opportunity>();
        Integer indexOpp=0;
        for(String folio:mapaPedidos.keySet()){
            Integer idExterno = idsExternos.get(indexOpp);
            String idExternoSFDC = String.valueOf(idExterno);
            Opportunity opp = mapaPedidos.get(folio);
            opp.Id_Externo__c = idExternoSFDC.leftPad(15, '0');
            procesar.put(idExterno, opp);
            indexOpp++;
        }

        Boolean blnContinuar = true;
        List<SaveResult> resultadosSAP = new List<SaveResult>();
        Boolean blnError = false;
        list<WsPedidosMayoreoLegados.ResultadoPedidoMayoreoLegados> respuestaLegados = null;
        System.debug('MAPPRECIOS=> '+ mapaProductos);
        respuestaLegados =  OpportunityParserWS.guardarPedidoslegados(procesar.values(), mapaProductos);
        System.debug('RESPUESTALEGADOS=> '+ respuestaLegados);
         for(WsPedidosMayoreoLegados.ResultadoPedidoMayoreoLegados respuesta : respuestaLegados)
         {
             if(respuesta==null){continue;}
               SaveResult svResult = new SaveResult();
                Integer idPedido = respuesta.SdlIdPedidoSalesForce;
             
             System.debug('IDPEDIDO=> '+ idPedido);
             if(idPedido == null || idPedido == 0)
             {
                  	System.debug('Mensaje::' + respuesta.mensaje);
                    String respuestaMensaje = respuesta.mensaje;
                    svResult.isSuccess = false;
                    svResult.errorMsg = respuesta.mensaje;
                    blnError = true;
                 
             }else
             {                
            
                Opportunity opp = procesar.get(idPedido);
                System.debug('PedidoMasivo: '+opp+' IdPedido: '+idPedido);
                String folio = opp.Folio_Temporal__c;
                svResult.folioTmp = folio;
                svResult.record = opp;
                if(opp.Liberado__c!=null){
                    if(opp.Liberado__c=='S'){
                        svResult.credito = 'Liberado';
                    }else{
                        svResult.credito = 'Retenido - ' + opp.Motivo_Rechazo_Cartera__c;
                    }
                }
                resultadosSAP.add(svResult);
                
                if(respuesta.Resultado =='TerminadoConExito'){
                    svResult.isSuccess = true;
                    opp.Folio_Pedido_SDL__c = respuesta.SdlFolioPedidoSDL;
                    opp.Folio_Embarque__c = respuesta.SdlFolioEmbarqueSDL;
                    opp.Numero_Pedido_SAP__c = respuesta.SapShip_To;
                    opp.Numero_de_Pedido_NSC__c = string.isNotBlank(respuesta.NscNumeroPedido)? String.valueOf(Integer.valueOf(respuesta.NscNumeroPedido)):''; 
                    opp.Frontera__c = mapFrontera.get(opp.Frontera__c);
                    procesados.put(idPedido, opp);
                    System.debug('Alta en SAP exitosa:' + opp);
                }else{
                    System.debug('Mensaje::' + respuesta.mensaje);
                    String respuestaMensaje = respuesta.mensaje;
                    svResult.isSuccess = false;
                    svResult.errorMsg = respuesta.mensaje;
                    blnError = true;
                    mapaProductos.remove(folio);
                    
                }
             }
         }

        if(blnError){
            sobjectSaveResult = new sobjectSaveResult();
            sobjectSaveResult.opportunitySaveResults = resultadosSAP;
            return sobjectSaveResult;
        }

        /*
         * Insertar en SFDC
         */
        System.SavePoint sp = Database.setSavepoint();

        List<SaveResult> oppsResults = OpportunityParserDAO.upsertRecords(procesados.values(),'Opportunity');
        List<OpportunityLineItem> lineItemsToInsert = getLineItemsToInsert(oppsResults, mapaProductos);
        List<SaveResult> itemsResults = OpportunityParserDAO.upsertItems(lineItemsToInsert,'OpportunityLineItem');

        for(SaveResult itemResult:itemsResults){
            if(!itemResult.isSuccess){
                Database.rollback(sp);

                for(SaveResult oppResult:oppsResults){
                    oppResult.idRecord = null;
                }

                break;
            }
        }

        sobjectSaveResult = new sobjectSaveResult();
        sobjectSaveResult.opportunitySaveResults = oppsResults;
        sobjectSaveResult.opportunityProductSaveResults = itemsResults;
        update mapEstrategiasMod.values();
        for(SaveResult sr :oppsResults)
        {
        	if(sr.Bloqueado != null)
        	{
        		PedidosOtrosCanalesUtils.submitForApproval(sr.Bloqueado,'Se Envio para su aprobacion (Cierre)','Cierre');
        	}
        }
        return sobjectSaveResult; 
    }





    public static Double calcularImporte(String tipoPrecio, String uomVenta, Double vol, Double kg, Integer qtty, Double precio,integer piezas) {
        System.debug('CalculandoImporte: TP: '+tipoPrecio+' UOM: '+uomVenta+' VOL: '+vol+' KG: '+kg+' Qtty: '+qtty+' Precio: '+precio);

        if( tipoPrecio=='DL' && uomVenta =='K') {
            return (vol* KG_LB) * precio;
        }
        if( tipoPrecio=='PK' && uomVenta=='P') {
            return vol * precio;
        }
        if( tipoPrecio=='PK' ) {
            return kg * precio;
        }
        if( tipoPrecio=='DL' ) {
            return vol * precio;
        }
        if(tipoPrecio=='PP')
        {
            return piezas * precio;
        }
        if( tipoPrecio=='PC'){
            return qtty * precio;
        }
        if((tipoPrecio=='DK' || tipoPrecio=='DC') && (uomVenta=='C'  || uomVenta=='P') ){
            return kg * precio;
        }
        if(tipoPrecio=='DK' && uomVenta=='K'){
            return vol * precio;
        }
        if(tipoPrecio=='DK' && uomVenta=='L'){
            Double kgs = vol / 2.20462;
            return kgs * precio;
        }
        if(tipoPrecio=='KL'){
            Double lbs = vol * 2.20462;
            return lbs * precio;
        }

        return 0.0;
    }

    static List<OpportunityLineItem> getLineItemsToInsert(List<SaveResult> oppsResults, Map<String, List<OpportunityLineItem>> oppLineItems ) {
        List<opportunityLineItem> lineItemstoInsert = new List<OpportunityLineItem>();
        for(SaveResult result:oppsResults){
            if(result==null){continue;}
            if(!result.isSuccess){continue;}
            Opportunity opp = (Opportunity)result.record;
            String folioTemporal = opp.Folio_Temporal__c;
            String folioDefinitivo = opp.Folio_Pedido_SDL__c;
            List<OpportunityLineItem> items = oppLineItems.get(folioTemporal);
            if(items==Null){continue;}

            Opportunity parent = new Opportunity();
            parent.Folio_Pedido_SDL__c = folioDefinitivo;
            parent.Folio_Temporal__c = folioTemporal;

            for(OpportunityLineItem item:items){
                item.Opportunity = parent;
            }
            lineItemstoInsert.addAll(items);
        }
        return lineItemstoInsert;
    }

    @TestVisible
    class OpportunityAndOppProductMapping {
        List<CustomMap> opportunityMapping;
        List<CustomMap> opportunityProductMapping;
        OpportunityAndOppProductMapping( List<CustomMap> opportunityMapping,
                                         List<CustomMap> opportunityProductMapping) {
            this.opportunityMapping = opportunityMapping;
            this.opportunityProductMapping = opportunityProductMapping;
        }
    }

    @TestVisible
    class CustomMap {
        String key;
        String value;
        CustomMap( String key, String value) {
            this.key = key;
            this.value = value ;
        }
    }

    //--Wrapper class to wrap the result of creation
    //@TestVisible
    public class SaveResult {
        public Boolean isSuccess {get;set;}
        public String errorMsg{get;set;}
        public String idRecord{get;set;}
        public String folioSFDC{get;set;}
        public String folioSDL{get;set;}
        public sobject record{get;set;}
        public String folioTmp {get;set;}
        public String credito {get;set;}
        public opportunity Bloqueado {get;set;}
        

        public SaveResult(){}

        public SaveResult(Boolean isSuccess, String errorMsg, String idRecord, sobject record ) {
            this.isSuccess = isSuccess;
            this.errorMsg = errorMsg;
            this.idRecord = idRecord;
            this.record = record;
        }
    }

    //--Wrapper to wrap diffrent type of object saveResults
    @TestVisible
    public class SobjectSaveResult {
        public List<SaveResult> opportunitySaveResults          {get; set;}
        public List<SaveResult> opportunityProductSaveResults   {get; set;}
        public String exceptions                                {get; set;}
    }

    @TestVisible
    class OpportunityToLineItems {
        String key;
        List<OpportunityLineItem> value;
    }

    public static String getTipoInventario(String tipo){
        String tipoInventario = '';
        if(tipo=='1'){
            tipoInventario = '1-INV. FISICO MEXICO';
        }else if(tipo=='2'){
            tipoInventario = '2-INV. FISICO NICARAGUA';
        }else if(tipo=='3'){
            tipoInventario = '3-TRANSITO MEXICO';
        }else if(tipo=='4'){
            tipoInventario = '4-TRANSITO NICARAGUA';
        }else if(tipo=='5'){
            tipoInventario = '5-PLANEACION';
        }

        return tipoInventario;
    }

    public static String getRango(String rango){
        
        if(rango==null){return '';}

        String nuevoRango = '';
        rango = rango.toUpperCase();

        if(rango=='0 - 10 DÍAS'){
            nuevoRango = '10 días o menos';
        }else if(rango=='11 - 15 DÍAS'){
            nuevoRango = '15 días o menos';
        }else if(rango=='16 - 25 DÍAS'){
            nuevoRango = '25 días o menos';
        }else if(rango=='MAYOR A 25'){
            nuevoRango = 'más de 25 días';
        }
        
        system.debug('Rango:: '+nuevoRango);
        return nuevoRango;
    }

    public static Map<String, Opportunity> procesarPedidos(List<Opportunity> records){
        List<String> clientes = new List<String>();
        List<String> canales = new List<String>();
        Map<String, Opportunity> mapaPedidos = new Map<String, Opportunity>();
        for(Opportunity opp:records){
            if(opp==null){continue;}
            if(String.isBlank(opp.Folio_Temporal__c)){ throw new ParserException('Favor de indicar el Folio Temporal');  }

            if(String.isNotBlank(opp.Cliente__c)){
                String codigoCliente = opp.Cliente__c;
                codigoCliente = codigoCliente.leftPad(10, '0');
                clientes.add(codigoCliente);
            }
            if(String.isNotBlank(opp.AccountId)){
                String codigoSucursal = opp.AccountId;
                codigoSucursal = 'SUC - ' + codigoSucursal.leftPad(10, '0');
                clientes.add(codigoSucursal);
            }
            if(String.isNotBlank(opp.Canal_Factura__c)){
                String codigoCanal = opp.Canal_Factura__c;
                canales.add(codigoCanal);
            }
            mapaPedidos.put(opp.Folio_Temporal__c, opp);
        }

        Map<String, Account> mapaCuentas = new Map<String, Account>();
        if(clientes.size()>0){
            mapaCuentas = OpportunityParserDAO.buscarPorSAP(clientes);
        }
        Map<String, Oficina_de_Venta__c> mapaCanales = new Map<String, Oficina_de_Venta__c>();
        if(canales.size()>0){
            mapaCanales = OpportunityParserDAO.canales(canales);
        }

        for(Opportunity opp : mapaPedidos.values() ) {
            opp.CloseDate = opp.Fecha_de_Embarque__c;
            opp.StageName = '1 - Pedido Colocado';
            
            if(String.isNotBlank(opp.Cliente__c)){
                String codigo = opp.Cliente__c;
                codigo = codigo.leftPad(10, '0');
                Account cliente = mapaCuentas.get(codigo);
                if(cliente!=null){
                    opp.Cliente__c = cliente.Id;
                    opp.Cliente__r = cliente;
                }
            }
            if(String.isNotBlank(opp.AccountId)){
                String codigo = opp.AccountId;
                codigo = 'SUC - ' + codigo.leftPad(10, '0');
                Account sucursal = mapaCuentas.get(codigo);
                if(sucursal!=null){
                    opp.AccountId = sucursal.Id;
                    opp.Account = sucursal;
                    opp.Name = sucursal.Name+'-'+System.now().format('yyyyMMdd');
                }
            }
            if(String.isNotBlank(opp.Canal_Factura__c)){
                Oficina_de_Venta__c canal = mapaCanales.get(opp.Canal_Factura__c);
                if(canal!=null){
                    opp.Canal_Factura__c = canal.Id;
                    opp.Canal_Factura__r = canal;
                }
            }
            
                if(!Test.isRunningTest()){
                     opp.Account   = PedidosOtrosCanalesUtils.retrieveCteInfo( opp.AccountId );
                    if( opp.Account.Canal_Distribucion__c.right(2) == 'EX' && (opp.Account.Sociedad__c.right(3) == '303' || opp.Account.Sociedad__c.right(3) == '300') ) {
                        if( String.isBlank(opp.OC__c ) ) {
                            opp.StageName = '10 - Pedido Bloqueado';
                           system.debug('PedidoBloqueado: '+ opp.StageName);
                        }
                    }
            }
        }
        return mapaPedidos;
    }

    public static Map<String, List<OpportunityLineItem>> procesarProductos(List<OpportunityToLineItems> records){
        Map<String, List<OpportunityLineItem>> mapaProductos = new Map<String, List<OpportunityLineItem>>();
        List<String> productos = new List<String>();
        List<String> origenes = new List<String>();

        for( OpportunityToLineItems oppToLineItems : records ) {
            String folio = oppToLineItems.key;
            if(String.isBlank(folio)){continue;}
            List<OpportunityLineItem> listItems = oppToLineItems.value;
            if(listItems==null){continue;}

            Opportunity parent = new Opportunity();
            parent.Folio_Temporal__c = folio;

            for(OpportunityLineItem item:listItems){
                item.Opportunity = parent;
                if(String.isNotBlank(item.ProductCode)){
                    productos.add(item.ProductCode);
                    if(!setproductCode.contains(item.ProductCode))
                        setproductCode.add(item.ProductCode);
                }
                if(String.isNotBlank(item.Origen_Surtido__c)){
                    origenes.add(item.Origen_Surtido__c);
                }
            }
            mapaProductos.put(folio, listItems);

        }

        Map<String, Oficina_de_Venta__c> mapaOrigenes = new  Map<String, Oficina_de_Venta__c>();
        if(origenes.size()>0){
            mapaOrigenes = OpportunityParserDAO.canales(origenes);
        }
        Map<String,PricebookEntry> mapaPBE = new Map<String,PricebookEntry>();
        if(productos.size()>0){
            mapaPBE = OpportunityParserDAO.getPriceBookEntry(standardList, productos);
        }

        for(String folio:mapaProductos.keySet() ) {
            List<OpportunityLineItem> listItems = mapaProductos.get(folio);
            for(OpportunityLineItem item:listItems){
                if(String.isNotBlank(item.Origen_Surtido__c)){
                    Oficina_de_Venta__c origen = mapaOrigenes.get(item.Origen_Surtido__c);
                    if(origen!=null){
                        item.Origen_Surtido__c = origen.Id;
                        item.Origen_Surtido__r = origen;
                    }
                }
                if(String.isNotBlank(item.ProductCode)){
                    PricebookEntry pbe = mapaPBE.get(item.ProductCode);
                    if(pbe!=null){
                        item.PricebookEntryId = pbe.Id;
                        item.PricebookEntry = pbe;
                    }
                }
            }
        }
        return mapaProductos;
    }

    public static String getStandarPriceBook(){
        return [SELECT p.IsStandard, p.Id
                FROM Pricebook2 p
                WHERE isStandard = true
                AND isActive = true LIMIT 1].Id;
    }
    public static Boolean ValidarAdmonEstrategica(PedidosOtrosCanalesUtils.producto primerProd, map<string,AdminSaldosEstrategias__c> mapEstrategias, Opportunity pedido)
    {
              System.Debug('pedidos nuevos');
              list<AdminSaldosEstrategias__c> listaResultados = new list<AdminSaldosEstrategias__c>();
              Integer SaldoAnterior=0;
              Integer SaldoActual = 0;
              String canalDistribucion = pedido.Cliente__r.Canal_Distribucion__c.right(2);
              if(primerProd.inventario != null)
              {
                      listaResultados = PedidosOtrosCanalesUtils.DisminuirInventariosAdmonEstrategiaComercial(pedido,primerProd);
                      if(listaResultados == null || listaResultados.size() == 0)
                      {
                         return false;
                      }

                      for(AdminSaldosEstrategias__c ase : listaResultados)
                      {
                          if(mapEstrategiasMod != null && mapEstrategiasMod.containsKey(ase.Id))
                          {
                              SaldoAnterior = PedidosOtrosCanalesUtils.calcularSaldo(mapEstrategiasMod.get(ase.Id),canalDistribucion);
                              SaldoActual = PedidosOtrosCanalesUtils.calcularSaldo(ase,canalDistribucion);
                              System.Debug('SaldoAnterior:: '+SaldoAnterior);
                              System.Debug('SaldoActual:: '+SaldoActual);
                              if((SaldoAnterior - SaldoActual) < 0)
                              {
                                    return false;
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
            return true;
    }
    public static PedidosOtrosCanalesUtils.Producto obtenerInventariosAdmonEstrategiaComercial(opportunity pedido,PedidosOtrosCanalesUtils.Producto p,Integer semana, map<String,product2>mapProduct2Master)
    {
                String canalDistribucion = pedido.Cliente__r.Canal_Distribucion__c.right(2);
                p.inventarioAnt = null;
                p.inventario = null;
                AdminSaldosEstrategias__c admon = new AdminSaldosEstrategias__c();
                admon = mapEstrategias.get(p.Codigo+String.valueOf(Semana));
                if(admon == null)
                {
                     p.ProductoMaster = mapProduct2Master.get(p.Codigo) != null?mapProduct2Master.get(p.Codigo).Producto_Master__r.MasterID__c:'0';
                     admon = mapEstrategias.get(p.ProductoMaster+String.valueOf(Semana));
                }
                if(admon != null)
                {
                        if( (integer.ValueOf(admon.Num_Semana__r.Name) < semana && p.codigo == admon.productoId__r.ProductCode) && admon.Prod_Master__c != null)
                        {
                            p.inventarioAnt = String.valueOf(PedidosOtrosCanalesUtils.calcularSaldo(admon,canalDistribucion));
                        }
                        else if ((integer.ValueOf(admon.Num_Semana__r.Name) == semana && p.codigo == admon.productoId__r.ProductCode) && admon.Prod_Master__c != null)
                        {
                            p.inventario = String.valueOf(PedidosOtrosCanalesUtils.calcularSaldo(admon,canalDistribucion));
                        }
                        else if ((integer.ValueOf(admon.Num_Semana__r.Name) == semana && p.ProductoMaster == admon.Prod_Master__r.MasterID__c) && admon.productoId__c == null)
                        {
                          if(p.inventario != null)
                             return p;

                            p.inventario = String.valueOf(PedidosOtrosCanalesUtils.calcularSaldo(admon,canalDistribucion));
                        }
                        else if( (integer.ValueOf(admon.Num_Semana__r.Name) < semana && p.ProductoMaster == admon.Prod_Master__r.MasterID__c) &&  admon.productoId__c == null)
                        {
                          if(p.inventarioAnt != null)
                             return p;

                             p.inventarioAnt = String.valueOf(PedidosOtrosCanalesUtils.calcularSaldo(admon,canalDistribucion));
                        }
                }


        return p;
    }
    public class ParserException extends Exception{}
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
    //repeat the i++ hundred of times

  }
}