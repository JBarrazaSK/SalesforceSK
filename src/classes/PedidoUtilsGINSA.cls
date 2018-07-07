/**
 * Description: PedidoWizardGINSA.component controller class. 
 * Author: Jorge Terán
 * Company: LYNX9
 * Email: sf@lynx9.com
 * Created date: 
 * Modified description: Adding new sales structure
 **/
public with sharing class PedidoUtilsGINSA {

    public static final Integer DEFAULT_PEDIDOITEMWRAPPERLIST_SIZE = 10;
    public static final Integer MAX_CALLOUT_RETRIES = 3;
    public static final Integer WEB_SERVICE_TIMEOUT = 23000;
    public static final Decimal CONVERSION_KILO_POUND = 2.2046;
    public static final String standarPriceBook = getStandarPriceBook();
    
    public static final String WRONG_VALUE_ERROR = '. Dato incorrecto.';
    public static final String ACCOUNT_REQUIRED_WARNING = 'Debe seleccionar una cuenta.';
    public static final String MULTIPLE_ACCOUNT_QUERY_RESULTS_FOUND_WARNING = 'Múltiples coincidencias encontradas. Por favor, refine la búsqueda.';
    public static final String ACCOUNT_NOT_FOUND_WARNING = 'La sucursal solicitada no se encuentra en la base de datos o no es una sucursal válida.';
    public static final String ACCOUNT_MISSING_FIELDS_ERROR = 'Faltan datos de la sucursal: ';
    public static final String PRODUCT_NO_LONGER_IN_INVENTORY_WARNING = 'El producto ya no se encuentra en la lista de inventario, lo que ocasiona inconsistencia de datos. Comuníquese con el administrador de NSC.';
    public static final String CIERREPLAZA_WEB_SERVICE_ERROR = 'Error al obtener el cierre de plaza. Por favor, reintente. Mensaje: ';
    public static final String CIERREPLAZA_WEB_SERVICE_NO_DATA_ERROR = 'El servicio web de consulta de cierre de plaza no ha devuelto datos.';
    public static final String INVENTARIO_WEB_SERVICE_ERROR = 'Error al obtener el inventario de productos. Por favor, reintente. Mensaje: ';
    public static final String INVENTARIO_WEB_SERVICE_NO_DATA_ERROR = 'El servicio web de consulta de inventario de productos no ha devuelto datos. Comuníquese con el administrador de NSC.';
    public static final String LISTAPRECIOS_WEB_SERVICE_ERROR = 'Error al obtener la lista de precios. Por favor, reintente. Mensaje: ';
    public static final String LISTAPRECIOS_WEB_SERVICE_NO_DATA_ERROR = 'El servicio web de consulta de lista de precios no ha devuelto datos. Comuníquese con el administrador de precios de SAP/NSC.';
    public static final String PEDIDO_WEB_SERVICE_ERROR = 'Error al enviar el pedido. Por favor, reintente. Mensaje: ';
    public static final String PEDIDO_WEB_SERVICE_NO_DATA_ERROR = 'El servicio web de inserción del pedido en NSC no ha devuelto datos.';
    public static final String PEDIDO_INSERT_CONFIRM = 'El pedido ha sido guardado con éxito. ';
    public static final String PEDIDO_CANCEL_CONFIRM = 'El pedido ha sido cancelado con éxito.';
    public static final String PEDIDO_INSERT_ERROR = 'Ha ocurrido un error al guardar el pedido en Salesforce: ';
    public static final String PEDIDO_REJECTION_WARNING = 'El pedido fue rechazado por políticas de crédito: ';
    public static final String PEDIDO_AUTHORIZATION_REQUIRED_WARNING = 'El pedido requiere autorización ';

    public static final String BALANCEO_WEB_SERVICE_ERROR_INVENTARIO = 'Error al obtener inventario de productos. Por favor, reintente. Mensaje: ';
    public static final String BALANCEO_WEB_SERVICE_NO_DATA_ERROR = 'El servicio web de consulta de inventario de productos no ha devuelto datos.';
    public static final String CIERREPLAZA_PLAZA_CERRADA = 'No se puede afectar el balanceo en pedidos cuya plaza está cerrada';

    public static final String BALANCEO_ERROR_BALANCEO_MAYOR_PEDIDO = 'La cantidad balanceada no puede ser mayor a la CONFIRMADA';
    public static final String BALANCEO_ERROR_BALANCEO_MAYOR_DISPONIBLE = 'La cantidad balanceada no puede ser mayor a lo Disponible';
    public static final String BALANCEO_ERROR_BALANCEO_NEGATIVO = 'La cantidad balanceada no puede ser negativa';
    public static final String BALANCEO_ERROR_PEDIDO_FACTURADO = 'No se pueden balancear pedidos facturados';
    public static final String BALANCEO_ERROR_PEDIDO_CERO = 'No se encontraron pedidos';
    public static final String BALANCEO_ERROR_DATE_PREV = 'No se puede balancear pedidos anteriores a hoy';

    public PedidoWrapper pedidoWrapper { get; set; }
    public AccountWrapper accountWrapper { get; set; }
    public ExternalSources externalSources { get; set; }
    public Set<String> setProductos;

    public static String getStandarPriceBook(){
       return [SELECT p.IsStandard, p.Id From Pricebook2 p
            WHERE isStandard = true AND isActive = true LIMIT 1].Id;
    }
    
    public Map<String, PricebookEntry> product2XproductCodeMap {
        get {
            if(product2XproductCodeMap == null) {
                List<String> productCodeList;

                System.debug(setProductos);
                if(setProductos==null){
                    productCodeList = new List<String>(externalSources.inventarioXProductCodeMap.keySet());
                }else{
                    productCodeList = new List<String>(setProductos);
                }
                System.debug('ProductCodeList'+productCodeList);
                
                pedidoWrapper.product2Map = new Map<Id, PricebookEntry>([
                    Select p.UnitPrice, p.ProductCode, p.Product2.Ficha_comercial__c, 
                        p.Product2.Peso_Promedio__c, p.Product2.Description, 
                        p.Product2.ProductCode, p.Product2.Name, p.Product2.Id, 
                        p.Product2Id, p.Name, p.Id 
                    From PricebookEntry p
                    Where p.Pricebook2Id = :standarPriceBook
                ]);
                
                product2XproductCodeMap = new Map<String, PricebookEntry>();
                for(PricebookEntry pbe : pedidoWrapper.product2Map.values()) {
                    System.debug('Producto: ' + pbe.Product2);
                    Product2 product2 = pbe.Product2;
                    product2XproductCodeMap.put(product2.ProductCode, pbe);
                }
                System.debug(pedidoWrapper.product2Map);
            }
            return product2XproductCodeMap;
        }
        set;
    }
	/*
    public PedidoUtilsGINSA(String recordId){
        this(recordId,false);
    }

    public PedidoUtilsGINSA(String recordId, Boolean pedidoMultiple){
        this(recordId,pedidoMultiple,false);
    }

    public PedidoUtilsGINSA(String recordId, Boolean pedidoMultiple,Boolean cierrePlazas){
        this(recordId,pedidoMultiple,cierrePlazas,null);
    }

    public PedidoUtilsGINSA(String recordId, Boolean pedidoMultiple, Boolean cierrePlazas, Map<Integer,BalanceoNSCWS.BalanceoProductos> inventario){
        this(recordId,pedidoMultiple,cierrePlazas,inventario,null);
    }

    public PedidoUtilsGINSA(String recordId, Boolean pedidoMultiple, Boolean cierrePlazas, 
                            Map<Integer,BalanceoNSCWS.BalanceoProductos> inventario, 
                            Map<String,String> productos){
        pedidoWrapper = new PedidoWrapper(standarPriceBook);
        accountWrapper = new PedidoUtilsGINSA.AccountWrapper();
        String recordIdPrefix = recordId.left(3);
        if(recordIdPrefix == SObjectType.Account.getKeyPrefix()) {
            pedidoWrapper.pedido.AccountId = recordId;
            queryAccount();
            accountWrapper.isSelectable = false;
        } else if(recordIdPrefix == SObjectType.Lead.getKeyPrefix()) {
            pedidoWrapper.pedido.Prospecto__c = recordId;
        } else if(recordIdPrefix == SOBjectType.Pedido__c.getKeyPrefix()) {
            pedidowrapper.queryPedido(recordId);
            queryAccount();

            stepForth(pedidoMultiple,cierrePlazas,inventario,productos);
        }
    }
    */
    
    public void queryAccount() {
        accountWrapper.queryAccount(pedidoWrapper.pedido.AccountId);
        pedidoWrapper.pedido.AccountId = accountWrapper.account.Id;
        if(pedidoWrapper.pedido.Id == null) {
            pedidoWrapper.pedido.Tipo_Surtido__c = accountWrapper.account.RecordType.Name == 'Sucursal' && accountWrapper.account.DiasEntrega__c != null && accountWrapper.account.Canal_de_Distribucion_NSC__r.Id != null ? '3 - RUTA' : '4 - LOCAL';
        }
    }
	/*
    public void stepForth(Boolean pedidoMultiple, Boolean cierrePlazas,Map<Integer,BalanceoNSCWS.BalanceoProductos>  inventario, Map<String,String> productos) {
        String tipoSurtido = pedidoWrapper.pedido.Tipo_Surtido__c;
        String oficinaVentasName = accountWrapper.oficinaVentasName;
        queryAccount();
        pedidoWrapper.pedido.Tipo_Surtido__c = tipoSurtido;
        if(ApexPages.hasMessages() || !accountWrapper.isValidAccountWrapper()) {
            accountWrapper.oficinaVentasName = oficinaVentasName;
            return;
        }
        if(pedidoWrapper.pedido.Id == null) {
            accountWrapper.oficinaVentasName = oficinaVentasName;
            accountWrapper.ofiventas = accountWrapper.getSAPCode(accountWrapper.oficinaVentasName);
            pedidoWrapper.pedido.OficinaVentas__r = new Oficina_de_Venta__c(
                Codigo__c = accountWrapper.ofiventas
            );
            /*
            if(accountWrapper.oficinaVentasSelectOptionList != null && accountWrapper.oficinaVentasSelectOptionList.size() > 1 && accountWrapper.oficinaVentasName != null) {
                accountWrapper.ofiventas = accountWrapper.getSAPCode(accountWrapper.oficinaVentasName);
                pedidoWrapper.pedido.OficinaVentas__r = new Oficina_de_Venta__c(
                    Codigo__c = accountWrapper.ofiventas
                );
            } else {
                pedidoWrapper.pedido.OficinaVentas__r = null;
            }

        }
        pedidoWrapper.tipoSurtido = Integer.valueOf(pedidoWrapper.pedido.Tipo_Surtido__c.left(1));
        pedidoWrapper.fecDoc = String.valueOf(pedidoWrapper.pedido.Fecha_Registro__c).left(10).replaceAll('-', '');
        externalSources = new ExternalSources();
        
        boolean valContinuarPrecios = false;
        if(pedidoMultiple){
            System.debug(productos);
            System.debug(productos.values());
            System.debug(inventario.keySet());
            setProductos = new Set<String>(productos.values());
            product2XproductCodeMap.size();
            System.debug(product2XproductCodeMap);
            externalSources.inventarioXProductCodeMap = new Map<String, ProductoInventarioQueryNSCWS.Inventario>();

            for(BalanceoNSCWS.BalanceoProductos bp : inventario.values()){
                setProductos.add(String.valueOf(bp.Producto));
                externalSources.inventarioXProductCodeMap.put(String.valueOf(bp.Producto),parseInventario(bp));
            }
            valContinuarPrecios = !cierrePlazas &&
                externalSources.setPrecioListXProductCodeMap(accountWrapper.clienteSAP, accountWrapper.gpoVendedores, accountWrapper.ofiVentas, accountWrapper.orgVentas, accountWrapper.canalSAP, accountWrapper.sucursal, accountWrapper.cluster, accountWrapper.cadena, pedidoWrapper.fecDoc);
        }else{
            valContinuarPrecios = externalSources.setIsClosedPlaza(accountWrapper.cliente, accountWrapper.sucursal, accountWrapper.canal, pedidoWrapper.pedido.OficinaVentas__r!=null ? Integer.valueOf(pedidoWrapper.pedido.OficinaVentas__r.Codigo__c):null) &&
                externalSources.setInventarioXProductCodeMap(accountWrapper.cliente, accountWrapper.sucursal, pedidoWrapper.tipoSurtido, pedidoWrapper.pedido.OficinaVentas__r != null ? Integer.valueOf(pedidoWrapper.pedido.OficinaVentas__r.Codigo__c) : accountWrapper.canal, pedidoWrapper.pedido.Orden_de_Compra__c) &&
                externalSources.setPrecioListXProductCodeMap(accountWrapper.clienteSAP, accountWrapper.gpoVendedores, accountWrapper.ofiVentas, accountWrapper.orgVentas, accountWrapper.canalSAP, accountWrapper.sucursal, accountWrapper.cluster, accountWrapper.cadena, pedidoWrapper.fecDoc);
        }


        if(valContinuarPrecios){
            pedidoWrapper.queryPedidoParameters();
            if(pedidoWrapper.pedido.Id == null) {
                pedidoWrapper.setPedidoDefaults(accountWrapper.account, externalSources.isClosedPlaza);
                pedidoWrapper.instanceNewPedidoItemList();
            } else {
                pedidoWrapper.addCurrentAmountsToInventory(externalSources.inventarioXProductCodeMap);
            }
        } else {
            externalSources.precioListXProductCodeMap = null;
        }
    }

    public ProductoInventarioQueryNSCWS.Inventario parseInventario(BalanceoNSCWS.BalanceoProductos bp){
        ProductoInventarioQueryNSCWS.Inventario inv = new ProductoInventarioQueryNSCWS.Inventario();
        inv.Producto = bp.Producto;
        inv.InvActual = bp.Disponible;
        inv.TipoManejoInventario = bp.TipoManejoInventario;
        inv.Contenido = Integer.valueOf(bp.Contenido);
        inv.EsPesoEstandar = bp.EsPesoEstandar;
        inv.CompAlmHoy = 0;
        inv.CompAlmMan = 0;
        inv.DispAlm = 0;
        inv.InvConf = 0;
        inv.CompConfMan = 0;
        inv.DispConf = 0;
        inv.ResAlm = 0;
        inv.ResConf = 0;
        inv.PermiteApartarSinexistencias = true;
        inv.TipoInventario = 0;

        return inv;
    }
	*/
    public class CustomException extends Exception {}
    
    public class PedidoWrapper {
        public Opportunity pedido { get; set; }
        public List<OpportunityLineItem> pedidoItemList { get; set; }
        public PedidoParameters__c pedidoParameters { get; set; }
        public Decimal importe { get; set; }
        public Integer tipoSurtido { get; set; }
        public Integer indexToRemove { get; set; }
        public Boolean isCancelacion { get; set; }
        public String preId { get; set; }
        public String fecDoc;
        
        public String RTPedidoId = getRecordType('Opportunity','Pedido');
        
        public Map<Id, PricebookEntry> product2Map;
        
        public PedidoWrapper(String standarPriceBookId) {
            preId = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(UserInfo.getUserId()+UserInfo.getSessionId()+System.now()+EncodingUtil.convertToHex(Crypto.generateAesKey(256)))));
            pedido = new Opportunity( Fecha_Registro__c = System.today(), Orden_de_Compra__c = '0', PriceBook2Id=standarPriceBookId );
        }
        
        public void queryPedido(String pedidoId) {
            pedido = [
                SELECT Id, Canal__c, Costo_de_Flete__c, CreatedDate, AccountId, 
                    DepartamentoOrdenCompra__c, StageName, Account.Name,
                    Forma_Pago__c,  Motivo_Autorizacion__c, Muestra__c, 
                    Numero_de_Pedido_NSC__c, Observacion__c, Fecha_Surtido_Programada__c,
                    Pedido_Cancelado__c, Pedido_Cliente__c, Pedido_Aceptado__c,
                    Factura__c, Factura_No_Fiscal__c, Fecha_de_Entrega__c, Fecha_Registro__c, 
                    Name, Orden_de_Compra__c, Organizacion_de_Ventas__c,
                    Pedido_Cancelado_Por_El_Sistema__c, Pedido_Rechazado__c, Prospecto__c, 
                    Requiere_Autorizacion__c, Tipo_Autorizacion_Remota__c, Tipo_Surtido__c,
                    CreatedBy.Username, OficinaVentas__r.Codigo__c, OficinaVentas__r.Name, 
                    (
                        SELECT Cajas__c, Cajas_Conf__c, 
                            Cantidad_Confirmada_Unidad_Movimiento__c, 
                            Cantidad_Pedida_Unidad_Movimiento__c, 
                            Kilos__c, Kilos_Conf__c,
                            Piezas__c, Piezas_Conf__c, 
                            Cajas_Balanceadas__c, PricebookEntryId,
                            TotalPrice, Moneda__c, OpportunityId, ListPrice, 
                            UnitPrice, Product2Id, Precio_Unitario_Otorgado__c,
                            Tipo_Cambio__c, Unidad__c, Precio_Requiere_Aprobacion__c, 
                            Precio_Aprobado_Supervisor__c, Precio_Aprobado_Pr__c,
                            Product2.Description, Product2.Peso_Promedio__c, 
                            Product2.ProductCode, Importe__c, Precio_Lista_Precios__c,
                        	PricebookEntry.Id, Precio_Unitario_Original__c, ProductCode
                        FROM OpportunityLineItems
                        ORDER BY Id ASC
                    )
                FROM Opportunity
                WHERE Id = :pedidoId
            ];
            pedidoItemList = pedido.OpportunityLineItems;
        }

        public OpportunityLineItem queryPedidoItem(String idPedidoItem){
            return [SELECT Cajas__c, Cajas_Conf__c, 
                        Cantidad_Confirmada_Unidad_Movimiento__c, 
                        Cantidad_Pedida_Unidad_Movimiento__c, TotalPrice, Kilos__c, Kilos_Conf__c, 
                        Moneda__c, OpportunityId, Piezas__c, Piezas_Conf__c, ListPrice, 
                        UnitPrice , Product2Id, PricebookEntryId, Precio_Unitario_Otorgado__c,
                        Tipo_Cambio__c, Unidad__c, Precio_Requiere_Aprobacion__c, 
                        Precio_Aprobado_Supervisor__c, Precio_Aprobado_Pr__c,
                        Product2.Description, Product2.Peso_Promedio__c, 
                        Product2.ProductCode, Importe__c, Precio_Lista_Precios__c, 
                    	Precio_Unitario_Original__c, ProductCode
                    FROM OpportunityLineItem Where Id=:idPedidoItem];
        }
        
        public void instanceNewPedidoItemList() {
            pedidoItemList = new List<OpportunityLineItem>();
            for(Integer i=0; i<PedidoUtilsGINSA.DEFAULT_PEDIDOITEMWRAPPERLIST_SIZE; i++) {
                pedidoItemList.add(new OpportunityLineItem());
            }
        }
        
        public void queryPedidoParameters() {
            pedidoParameters = PedidoParameters__c.getInstance();
        }
        
        public void setPedidoDefaults(Account account, Boolean isClosedPlaza) {
            pedido.AccountId = account.Id;
            //OPP Name
            pedido.Name = account.Numero_Cliente_SAP__c+'-'+System.today();
            pedido.CloseDate = System.today();
            pedido.Factura__c = account.Parent.Tipo_de_Credito__c == 'Revolvente - 2' || account.Parent.Tipo_de_Credito__c == 'Crédito - 3' || (account.Parent.Tipo_de_Credito__c == 'Contado - 1' && (account.Parent.RFC__c != null || account.Parent.RFC_Generico__c != null));
            pedido.Fecha_Surtido_Programada__c = getNextWorkingDatetime(isClosedPlaza);
            pedido.Forma_Pago__c = account.Parent.Tipo_de_Credito__c == 'Revolvente - 2' || account.Parent.Tipo_de_Credito__c == 'Crédito - 3' ? '2 - Crédito' : account.Parent.Tipo_de_Credito__c == 'Contado - 1' && (account.Parent.RFC__c != null || account.RFC_Generico__c != null) ? '1 - Contado' : null;
            pedido.Correo_electronico_del_cliente__c = account.Correo_Electronico__c;
        }
        
        public void setPedidoData() {
            System.debug('setPedidoData...');
            tipoSurtido = Integer.valueOf(pedido.Tipo_Surtido__c.left(1));
            pedido.Fecha_de_Entrega__c = pedido.Fecha_Surtido_Programada__c.date();
            pedido.Amount = importe;
            if(String.isNotBlank(pedido.Prospecto__c)) {
                for(Lead lead : [
                    SELECT Id_Prospecto__c
                    FROM Lead
                    WHERE Id = :pedido.Prospecto__c
                ]) {
                    pedido.Prospecto__r = lead;
                }
            }
            for(Integer i=0; i<pedidoItemList.size(); i++) {
                System.debug('PedidoItem: ' + pedidoItemList[i]);
                if(String.isBlank(pedidoItemList[i].PriceBookEntryId)) {
                    pedidoItemList.remove(i--);
                }
            }
            setProduct2Data();
        }
        
        public boolean requiereAutorizacionPrecio(){
            
            for(OpportunityLineItem pi : this.pedidoItemList){
                if(pi.Precio_Requiere_Aprobacion__c){
                    if(!pi.Precio_Aprobado_Supervisor__c){
                        return true;
                    }
                }
            }
            
            return false;
        }
        
        public void setProduct2Data() {
            System.debug('setProduct2Data...');
            for(OpportunityLineItem pedidoItem : pedidoItemList) {
                pedidoItem.PriceBookEntry = product2Map.get(pedidoItem.PriceBookEntryId);
                //System.debug('PricebookEntry: '+pedidoItem.PricebookEntry);
                pedidoItem.Tipo_Cambio__c = pedidoItem.Moneda__c == 'D' ? pedidoParameters.TipoCambioDolarPeso__c : 1;
            }
        }
        
        public void addPedidoItem() {
            setProduct2Data();
            pedidoItemList.add(new OpportunityLineItem());
        }
        
        public void clearPedidoItemList() {
            pedidoItemList.clear();
        }
        
        public void removePedidoItem() {
            if(indexToRemove < pedidoItemList.size()) {
                pedidoItemList.remove(indexToRemove);
            }
            setProduct2Data();
        }
        
        public void addCurrentAmountsToInventory(Map<String, ProductoInventarioQueryNSCWS.Inventario> inventarioXProductCodeMap) {
            for(OpportunityLineItem pedidoItem : pedidoItemList) {
                String productCode = pedidoItem.Product2.ProductCode;
                System.debug(productCode);
                System.debug(inventarioXProductCodeMap);
                if(inventarioXProductCodeMap.containsKey(productCode)) {
                    inventarioXProductCodeMap.get(productCode).DispAlm += inventarioXProductCodeMap.get(productCode).TipoManejoInventario == 2 ? pedidoItem.Kilos_Conf__c : pedidoItem.Cajas_Conf__c;
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, productCode+': '+PedidoUtilsGINSA.PRODUCT_NO_LONGER_IN_INVENTORY_WARNING));
                }
            }
        }
        
        public void assignWebServiceResponseData(PedidoInsertNSCWS.PedidoRespuesta response) {
            pedido.Canal__c = leftPad0(response.Canal, 5);
            pedido.StageName = response.Estatus == 0 ? '0 - Rechazado' : response.Estatus == 1 ? '1 - Pedido Colocado' : null;
            pedido.Motivo_Autorizacion__c = response.MotivoAutorizacion;
            pedido.Numero_de_Pedido_NSC__c = leftPad0(response.NumeroPedido, 10);
            pedido.Pedido_Rechazado__c = response.PedidoRechazado;
            pedido.Requiere_Autorizacion__c = response.RequiereAutorizacion;
            pedido.Tipo_Autorizacion_Remota__c = response.TipoAutorizacionRemota;
            pedido.Id_Externo__c = pedido.Canal__c+pedido.Numero_de_Pedido_NSC__c;
        }
        
        public void save() {
            if(isCancelacion == true) {
                pedido.Pedido_Cancelado__c = true;
                pedido.StageName = 'Pedido Cancelado';
            }
            System.debug('Savepoint!!');
            Savepoint savepoint = Database.setSavepoint();
            try {
                pedido.RecordTypeId = RTPedidoId;
                upsert pedido;
                Set<Id> pedidoItemIdSet = new Set<Id>();
                System.debug('Inserting Products: ' + pedidoItemList.size());
                for(OpportunityLineItem pedidoItem : pedidoItemList) {
                    String productCode = pedidoItem.PricebookEntry.Product2.ProductCode;
                    System.debug('Product Code: ' + productCode);
                    pedidoItem.Id_externo_Producto_Pedido__c = leftPad0(productCode, 10)+pedido.Numero_de_Pedido_NSC__c;
                    if(pedidoItem.OpportunityId == null) {
                        pedidoItem.OpportunityId = pedido.Id;
                    }
                    if(pedidoItem.Id != null) {
                        pedidoItemIdSet.add(pedidoItem.Id);
                    }
                    pedidoItem.Cajas_Balanceadas__c = null;
                    pedidoItem.Cantidad_Balanceada_Unidad_de_Movimiento__c = null;
                    pedidoItem.Kilos_Balanceados__c = null;
                    pedidoItem.Piezas_Balanceadas__c = null;
                    pedidoItem.Quantity = pedidoItem.Cajas__c;
                }
                delete [
                    SELECT Id
                    FROM OpportunityLineItem
                    WHERE OpportunityId = :pedido.Id
                        AND Id NOT IN :pedidoItemIdSet
                ];
                upsert pedidoItemList;
                queryPedido(pedido.Id);
                if(!pedido.Pedido_Cancelado__c) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, PedidoUtilsGINSA.PEDIDO_INSERT_CONFIRM+'Folio NSC: '+pedido.Numero_de_Pedido_NSC__c+'.'));
                    if(pedido.Pedido_Rechazado__c) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidoUtilsGINSA.PEDIDO_REJECTION_WARNING+pedido.Motivo_Autorizacion__c));
                    } else if(pedido.Requiere_Autorizacion__c) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidoUtilsGINSA.PEDIDO_AUTHORIZATION_REQUIRED_WARNING+(pedido.Tipo_Autorizacion_Remota__c ? 'remota' : 'local')+'. '+pedido.Motivo_Autorizacion__c));
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, PedidoUtilsGINSA.PEDIDO_CANCEL_CONFIRM));
                }
            } catch(Exception e) {
                Database.rollback(savepoint);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PedidoUtilsGINSA.PEDIDO_INSERT_ERROR+e.getMessage()));
            }
        }
        
        private Datetime getNextWorkingDatetime(Boolean isClosedPlaza) {
            Datetime nextWorkingDatetime = System.now();
            if(nextWorkingDatetime.format('EEEE') == 'Saturday') nextWorkingDatetime = nextWorkingDatetime.addDays(1);
            if(isClosedPlaza) nextWorkingDatetime = nextWorkingDatetime.addDays(1);
            nextWorkingDatetime = nextWorkingDatetime.addDays(1);
            if(nextWorkingDatetime.format('EEEE') == 'Sunday') nextWorkingDatetime = nextWorkingDatetime.addDays(1);
            return nextWorkingDatetime;
        }
        
        private String leftPad0(String value, Integer size) {
            return value.leftPad(size).replaceAll(' ', '0');
        }
        
        public String getRecordType(String obj, String rtName){
            return [Select Id From RecordType Where SobjectType = :obj and Name=:rtName LIMIT 1].Id;
        }
    }
    
    public class AccountWrapper {
        public Account account { get; set; }
        public Boolean isSelectable { get; set; }
        public String sucursal { get; set; }
        public String oficinaVentasName { get; set; }
        public List<SelectOption> oficinaVentasSelectOptionList { get; set; }
        public Integer canal;
        public Integer cliente;
        public String cadena;
        public String canalSAP;
        public String clienteSAP;
        public String cluster;
        public String gpoVendedores;
        public String ofiVentas;
        public String orgVentas;
        public Integer tipoSurtido;
        
        public AccountWrapper() {
            account = new Account();
            isSelectable = true;
        }
        
        public void queryAccount(String accountId) {
            account.Id = null;
            if(String.isNotBlank(accountId) || String.isNotBlank(sucursal)) {
                List<Account> accountList = (List<Account>)Database.query(
                    'SELECT Cadena__c, Canal_Distribucion__c, Canal_Padre__c, Correo_Electronico__c, DiasEntrega__c, Name, Numero_Cliente_SAP__c, Organizacion_de_Ventas__c, Ramo__c, RFC_Generico__c, Territorio__c, '+
                        'Canal_de_Distribucion_NSC__r.Codigo__c, Canal_de_Distribucion_NSC__r.Name, '+
                        'Parent.Numero_Cliente_SAP__c, Parent.Tipo_de_Credito__c, Parent.RFC__c, Parent.RFC_Generico__c, '+
                        'RecordType.Name, Tipo_Surtido__c '+
                    'FROM Account '+
                    'WHERE Estatus_Cliente__c = \'Activo\' '+
                        'AND RecordType.Name = \'Sucursal\' '+
                        (String.isNotBlank(accountId) ? 'AND Id = :accountId ' : String.isNotBlank(sucursal) ? 'AND Numero_Cliente_SAP__c LIKE \'%'+sucursal+'%\' ' : '')+
                    'LIMIT 2'
                );
                if(!accountList.isEmpty()) {
                    if(accountList.size() == 1) {
                        this.account = accountList[0];
                        if(isValidAccountWrapper()) {
                            queryOficinaVentas();
                        }
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, MULTIPLE_ACCOUNT_QUERY_RESULTS_FOUND_WARNING));
                    }
                } else {
                    isValidAccount();
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ACCOUNT_REQUIRED_WARNING));
            }
        }
        
        public void queryOficinaVentas() {
            oficinaVentasName = account.Canal_Padre__c;
            oficinaVentasSelectOptionList = new List<SelectOption>();
            if(String.isNotBlank(gpoVendedores)) {

                for(Gpo_Vendedores_Oficina_de_Ventas__c gpoVendedoresOficinaVentas : [
                    SELECT Oficina_de_Venta__r.Name
                    FROM Gpo_Vendedores_Oficina_de_Ventas__c
                    WHERE Grupo_de_Vendedores__r.Codigo__c = :gpoVendedores
                    ORDER BY Name
                ]) {
                    oficinaVentasSelectOptionList.add(new SelectOption(gpoVendedoresOficinaVentas.Oficina_de_Venta__r.Name, gpoVendedoresOficinaVentas.Oficina_de_Venta__r.Name));
                }
                
                /*
                for(AggregateResult result : [
                    Select Oficina_de_venta__c ofivta
                    From Grupo_de_Vendedores__c
                    Where Codigo__c = :gpoVendedores
                    group by Oficina_de_venta__c
                    ORDER BY Oficina_de_venta__c
                ]) {
                    String name = (String)result.get('ofivta');
                    oficinaVentasSelectOptionList.add(new SelectOption(name, name));
                }
*/
            }
        }
        
        public Boolean isValidAccountWrapper() {
            Boolean hasError = !isValidAccount();
            if(!hasError) {
                setExtensionVariables();
            }
            return !hasError;
        }
        
        private Boolean isValidAccount() {
            if(account.Id != null) {
                List<String> missingFields = new List<String>();            
                if(account.Canal_de_Distribucion_NSC__r.Id != null) {
                    if(String.isNotBlank(account.Canal_de_Distribucion_NSC__r.Codigo__c)) {
                        if(!account.Canal_de_Distribucion_NSC__r.Codigo__c.isNumeric()) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, SObjectType.Account.Fields.Canal_de_Distribucion_NSC__c.getLabel()+': '+SObjectType.Canal_de_Distribucion_NSC__c.Fields.Codigo__c.getLabel()+PedidoUtilsGINSA.WRONG_VALUE_ERROR));
                        }
                    } else {
                        missingFields.add(SObjectType.Account.Fields.Canal_de_Distribucion_NSC__c.getLabel()+': '+SObjectType.Canal_de_Distribucion_NSC__c.Fields.Codigo__c.getLabel());
                    }
                } else {
                    missingFields.add(SObjectType.Account.Fields.Canal_de_Distribucion_NSC__c.getLabel());
                }
                if(account.Parent.Id != null) {
                    if(String.isNotBlank(account.Parent.Numero_Cliente_SAP__c)) {
                        if(!account.Parent.Numero_Cliente_SAP__c.isNumeric()) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, SObjectType.Account.Fields.ParentId.getLabel()+': '+SObjectType.Account.Fields.Numero_Cliente_SAP__c.getLabel()+PedidoUtilsGINSA.WRONG_VALUE_ERROR));
                        }
                    } else {
                        missingFields.add(SObjectType.Account.Fields.ParentId.getLabel()+': '+SObjectType.Account.Fields.Numero_Cliente_SAP__c.getLabel());
                    }
                } else {
                    missingFields.add(SObjectType.Account.Fields.ParentId.getLabel());
                }
                if(String.isBlank(account.Numero_Cliente_SAP__c)) missingFields.add(SObjectType.Account.Fields.Numero_Cliente_SAP__c.getLabel());
                if(String.isBlank(account.Canal_Distribucion__c)) missingFields.add(SObjectType.Account.Fields.Canal_Distribucion__c.getLabel());
                if(String.isBlank(account.Ramo__c)) missingFields.add(SObjectType.Account.Fields.Ramo__c.getLabel());
                if(String.isBlank(account.Territorio__c)) missingFields.add(SObjectType.Account.Fields.Territorio__c.getLabel());
                if(String.isBlank(account.Canal_Padre__c)) missingFields.add(SObjectType.Account.Fields.Canal_Padre__c.getLabel());
                if(String.isBlank(account.Organizacion_de_Ventas__c)) missingFields.add(SObjectType.Account.Fields.Organizacion_de_Ventas__c.getLabel());
                if(!missingFields.isEmpty()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PedidoUtilsGINSA.ACCOUNT_MISSING_FIELDS_ERROR+String.join(missingFields, ', ')+'.'));
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidoUtilsGINSA.ACCOUNT_NOT_FOUND_WARNING));
            }
            return !(ApexPages.hasMessages(ApexPages.Severity.WARNING) || ApexPages.hasMessages(ApexPages.Severity.ERROR));
        }
        
        private void setExtensionVariables() {
            canal = Integer.valueOf(account.Canal_de_Distribucion_NSC__r.Codigo__c);
            cliente = Integer.valueOf(account.Parent.Numero_Cliente_SAP__c);
            sucursal = account.Numero_Cliente_SAP__c.replace('SUC - ', '');
            cadena = getSAPCode(account.Cadena__c);
            canalSAP = getSAPCode(account.Canal_Distribucion__c);
            clienteSAP = String.valueOf(cliente);
            cluster = getSAPCode(account.Ramo__c);
            gpoVendedores = getSAPCode(account.Territorio__c);
            ofiVentas = getSAPCode(account.Canal_Padre__c);
            orgVentas = getSAPCode(account.Organizacion_de_Ventas__c);
            tipoSurtido = Integer.valueOf(account.Tipo_Surtido__c.left(1));
        }
        
        public String getSAPCode(String picklistValue) {
            return String.isNotBlank(picklistValue) ? (picklistValue.contains(' - ') ? picklistValue.substring(picklistValue.indexOf(' - ')+3, picklistValue.length()) : picklistValue) : null;
        }
    }
    
    public class ExternalSources {
        public Boolean isClosedPlaza { get; set; }
        public Map<String, ProductoInventarioQueryNSCWS.Inventario> inventarioXProductCodeMap { get; set; }
        public Map<String, List<ListaPreciosQueryNSCWS.Precios>> precioListXProductCodeMap { get; set; }
        public PedidoParameters__c pedidoParameters = PedidoParameters__c.getInstance();

        public Boolean setIsClosedPlaza(Integer cliente, String sucursal, Integer canal, Integer canalDestino) {
            isClosedPlaza = null;
            CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierre response = retrieveCierrePlaza(cliente, sucursal, canal, canalDestino);
            if(response != null) {
                isClosedPlaza = response.Datos.Cierre[0].cerrado == 1;
            }
            return isClosedPlaza != null;
        }

        public Boolean setIsClosedPlazas(Set<Integer> canales,Integer canalPadre) {
            isClosedPlaza = false;
            CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierre response = retrieveCierrePlaza(canales,canalPadre);
            if(response!=null && response.Datos!= null && response.Datos.Cierre!=null ){
                for (CierrePlazaPedidoQueryNSCWS.Cierre cierre : response.Datos.Cierre){
                    if(cierre.cerrado == 1){
                        isClosedPlaza = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, CIERREPLAZA_PLAZA_CERRADA));
                        break;
                    }
                }
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PedidoUtilsGINSA.CIERREPLAZA_WEB_SERVICE_ERROR));
                isClosedPlaza = true;
            }
            return isClosedPlaza;
        }
        
        public Boolean setInventarioXProductCodeMap(Integer cliente, String sucursal, Integer tipoSurtido, Integer canal, String ordenCompra) {
            inventarioXProductCodeMap = new Map<String, ProductoInventarioQueryNSCWS.Inventario>();
            ProductoInventarioQueryNSCWS.RespuestaOfListOfInventario response = retrieveInventario(cliente, sucursal, tipoSurtido, canal, ordenCompra);
            if(response != null) {
                for(ProductoInventarioQueryNSCWS.Inventario inventario : response.Datos.Inventario) {
                    if(inventario.Producto != null) {
                        inventarioXProductCodeMap.put(String.valueOf(inventario.Producto), inventario);
                    }
                }
                if(inventarioXProductCodeMap.isEmpty()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PedidoUtilsGINSA.INVENTARIO_WEB_SERVICE_NO_DATA_ERROR));
                }
            }
            return !inventarioXProductCodeMap.isEmpty();
        }
        
        public Boolean setPrecioListXProductCodeMap(String cliente, String gpoVendedores, String ofiVentas, String orgVentas, String canal, String destinatario, String cluster, String cadena, String fecDoc) {
            precioListXProductCodeMap = new Map<String, List<ListaPreciosQueryNSCWS.Precios>>();
            ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios response = retrieveListaPrecios(cliente, gpoVendedores, ofiVentas, orgVentas, canal, destinatario, cluster, cadena, fecDoc);
            if(response != null) {
                for(ListaPreciosQueryNSCWS.Precios precio : response.Datos.Precios) {
                    if(String.isNotBlank(precio.pve_cveprod) && precio.pve_cveprod.isNumeric()) {
                        String productCode = String.valueOf(Integer.valueOf(precio.pve_cveprod));
                        if(inventarioXProductCodeMap.containsKey(productCode)) {
                            if(!precioListXProductCodeMap.containsKey(productCode)) {
                                precioListXProductCodeMap.put(productCode, new List<ListaPreciosQueryNSCWS.Precios> { precio });
                            } else if(cluster != '36') {
                                precioListXProductCodeMap.get(productCode).add(precio);
                            }
                        }
                    }
                }
                if(precioListXProductCodeMap.isEmpty()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PedidoUtilsGINSA.LISTAPRECIOS_WEB_SERVICE_NO_DATA_ERROR));
                }
            }
            return !precioListXProductCodeMap.isEmpty();
        }

        public PedidoInsertNSCWS.Pedido setPedidoWS(PedidoUtilsGINSA.PedidoWrapper pedidoWrapper, PedidoUtilsGINSA.AccountWrapper accountWrapper) {
            return setPedidoWS(pedidoWrapper,accountWrapper,true);
        }
        
        public PedidoInsertNSCWS.Pedido setPedidoWS(PedidoUtilsGINSA.PedidoWrapper pedidoWrapper, PedidoUtilsGINSA.AccountWrapper accountWrapper, Boolean limpiaBalanceo) {
            List<Monedas__c> monedas 	= Monedas__c.getAll().values();
    		List<Unidades__c> unidades 	= Unidades__c.getAll().values();
            Datetime now = System.now();
            Opportunity pedido = pedidoWrapper.pedido;
            List<OpportunityLineItem> items = pedidoWrapper.pedidoItemList;
            
            String formaPago = pedidoWrapper.pedido.Forma_Pago__c.substring(0, pedidoWrapper.pedido.Forma_Pago__c.indexOf(' - '));
            
            PedidoInsertNSCWS.Pedido pedidoWS = new PedidoInsertNSCWS.Pedido();
            System.debug(pedido);
            System.debug('Items : '+items);
            //if(pedidoWrapper.pedido.Id==null){
                pedidoWS.nCanalConexion = pedido.OficinaVentas__r != null ? Integer.valueOf(pedido.OficinaVentas__r.Codigo__c) : accountWrapper.canal;
            //}else{
            //    pedidoWS.nCanalConexion = pedidoWrapper.pedido.OficinaVentas__r != null ? Integer.valueOf(pedidoWrapper.pedido.OficinaVentas__r.Codigo__c) : accountWrapper.canal;
            //}
            pedidoWS.nCanalDistribucionVenta = Integer.valueOf(accountWrapper.canal);//pedidoWrapper.pedido.OficinaVentas__r != null ? Integer.valueOf(accountWrapper.ofiVentas) : accountWrapper.canal;//accountWrapper.canal;
            //pedidoWS.nCanalDistribucion = pedidoWrapper.pedido.OficinaVentas__r != null ? Integer.valueOf(accountWrapper.ofiVentas) : accountWrapper.canal;//accountWrapper.canal;
            //pedidoWS.Original_nCanalDistribucion = pedidoWrapper.pedido.OficinaVentas__r != null ? Integer.valueOf(accountWrapper.ofiVentas) : accountWrapper.canal;
            
            if(String.isNotBlank(pedido.Numero_de_Pedido_NSC__c) && pedido.Numero_de_Pedido_NSC__c.isNumeric()){ 
                pedidoWS.nPedidoCliente = Integer.valueOf(pedido.Numero_de_Pedido_NSC__c);
            }
            pedidoWS.Original_nPedidoCliente = pedidoWS.nPedidoCliente;
            pedidoWS.nSucursalCliente = Integer.valueOf(accountWrapper.sucursal);
            pedidoWS.nCliente = accountWrapper.cliente;
            pedidoWS.cOrganizacionVenta = accountWrapper.orgVentas;
            pedidoWS.nTipoSurtido = pedidoWrapper.tipoSurtido;
            pedidoWS.dFecha = pedido.Fecha_Registro__c;
            pedidoWS.dFechaSurtidoProgramada = pedido.Fecha_Surtido_Programada__c.date();
            pedidoWS.dHoraEntregaProgramadaInicio = pedido.Fecha_Surtido_Programada__c;
            pedidoWS.dHoraEntregaProgramadaFin = pedido.Fecha_Surtido_Programada__c;
            if(formaPago.isNumeric()) pedidoWS.nFormaPago = Integer.valueOf(formaPago);
            pedidoWS.nEjecutivo = 0;
            pedidoWS.cObservacion = pedido.Observacion__c;
            pedidoWS.bPedidoAceptado = pedido.Pedido_Aceptado__c;
            pedidoWS.bPedidoSurtido = false;
            pedidoWS.bRequiereAutorizacion = false;
            pedidoWS.bTipoAutorizacionRemota = pedido.Tipo_Autorizacion_Remota__c;
            pedidoWS.cMotivoAutorizacion = '0';
            pedidoWS.bPedidoAutorizado = false;
            pedidoWS.bPedidoRechazado = pedido.Pedido_Rechazado__c;
            pedidoWS.nImporte = pedidoWrapper.importe;
            pedidoWS.cSupervisor = '';
            pedidoWS.cObservacionSupervisor = null;
            pedidoWS.nOrigenPedido = 0;
            pedidoWS.nEstatusPedido = 1;
            pedidoWS.nCausaCancelacion = null;
            pedidoWS.cMotivoCancelacion = null;
            pedidoWS.bCapturadoDespuesDeCierre = false;
            pedidoWS.cSupervisorEmbarque = '';
            pedidoWS.cObservacionIncumplimientoCampana = '';
            pedidoWS.bPedidoCanceladoPorElSistema = pedido.Pedido_Cancelado_Por_El_Sistema__c;
            pedidoWS.bPedidoTransmitido = false;
            if(pedidoWrapper.isCancelacion != true) pedidoWS.bActivo = true;
            pedidoWS.bAplicado = false;
            pedidoWS.bIntegrado = false;
            pedidoWS.cUsuario_Registro = String.isNotBlank(pedido.CreatedBy.Username) ? pedido.CreatedBy.Username.substring(0, pedido.CreatedBy.Username.lastIndexOf('@')) : UserInfo.getUserName().substring(0, UserInfo.getUserName().lastIndexOf('@'));
            pedidoWS.dFecha_Registro = pedido.CreatedDate != null ? pedido.CreatedDate : now;
            pedidoWS.cMaquina_Registro = 'Host_SalesForce';
            pedidoWS.cUsuario_UltimaModificacion = UserInfo.getUserName().substring(0, UserInfo.getUserName().lastIndexOf('@'));
            pedidoWS.dFecha_UltimaModificacion = now;
            pedidoWS.cMaquina_UltimaModificacion = null;
            if(pedidoWrapper.isCancelacion == true) pedidoWS.cUsuario_Eliminacion = UserInfo.getUserName().substring(0, UserInfo.getUserName().lastIndexOf('@'));
            if(pedidoWrapper.isCancelacion == true) pedidoWS.dFecha_Eliminacion = now.date();
            if(pedidoWrapper.isCancelacion == true) pedidoWS.cMaquina_Eliminacion = 'Host_SalesForce';
            pedidoWS.bSolicitudAutorizacionRemotaEnviada = false;
            pedidoWS.nPedidoPadre = 0;
            pedidoWS.bFactura = pedido.Factura__c;
            pedidoWS.cOrdenCompra = pedido.Orden_de_Compra__c;
            pedidoWS.cDepartamentoOrdenCompra = pedido.DepartamentoOrdenCompra__c;
            pedidoWS.bDisponibleLiberado = false;
            pedidoWS.nCanalRN = 0;
            pedidoWS.nOrdenRN = 0;
            pedidoWS.bEnviadoEBS = false;
            pedidoWS.bEnviadoCorporativo = false;
            pedidoWS.dFechaActualizacion = now;
            if(pedido.Prospecto__r != null && String.isNotBlank(pedido.Prospecto__r.Id_Prospecto__c)) 
                pedidoWS.nProspecto = Integer.valueOf(pedido.Prospecto__r.Id_Prospecto__c);
            pedidoWS.nAutorizaEspecial = 0;
            pedidoWS.dFechaEntrega = pedido.Fecha_de_Entrega__c;
            if(pedido.Costo_de_Flete__c != null) 
                pedidoWS.nCostoFlete = pedido.Costo_de_Flete__c;
            pedidoWS.cAutorizaEliminarPedido = null;
            pedidoWS.cAutorizaActualizarPedido = null;
            pedidoWS.bFacturaNoFiscal = pedido.Factura_No_Fiscal__c;
            pedidoWS.nClienteSap = accountWrapper.cliente;
            pedidoWS.cSucursalSAP = accountWrapper.sucursal;
            pedidoWS.EsTicket = false;
            pedidoWS.IdSalesforce = pedidoWrapper.preId;
            pedidoWS.Detalle = new PedidoInsertNSCWS.ArrayOfPedidoDetalle();
            pedidoWS.Detalle.PedidoDetalle = new List<PedidoInsertNSCWS.PedidoDetalle>();
            for(Integer i=0; i<pedidoWrapper.pedidoItemList.size(); i++) {
                OpportunityLineItem item = pedidoWrapper.pedidoItemList[i];
                String productCode = item.PricebookEntry.Product2.ProductCode;
                Product2 product = item.PricebookEntry.Product2;
                System.debug('Product2 :: ' + product);
                PedidoInsertNSCWS.PedidoDetalle pedidoDetalleWS = new PedidoInsertNSCWS.PedidoDetalle();
                //pedidoDetalleWS.nCanalDistribucion = pedidoWrapper.pedido.OficinaVentas__r != null ? Integer.valueOf(accountWrapper.ofiVentas) : accountWrapper.canal;
                if(String.isNotBlank(pedido.Numero_de_Pedido_NSC__c) && pedido.Numero_de_Pedido_NSC__c.isNumeric()) 
                    pedidoDetalleWS.nPedidoCliente = Integer.valueOf(pedido.Numero_de_Pedido_NSC__c);
                pedidoDetalleWS.nRenglon = i+1;
                pedidoDetalleWS.nProducto = Integer.valueOf(productCode);
                pedidoDetalleWS.nMarca = 0;
                if( unidades == null ) { 
                	pedidoDetalleWS.nUnidad = item.Unidad__c == 'P' ? 1 : item.Unidad__c == 'C' ? 3 : item.Unidad__c == 'K' ? 4 : 5;
                }
                else {
                    for( Unidades__c u: unidades ) {
                        if( u == null ) {continue;}
                        if( u.Name == pedidoWrapper.pedidoItemList[i].Unidad__c ) {
                            pedidoDetalleWS.nUnidad = Integer.valueOf( u.ID_Unidad__c );
                        }
                    }
                }
                pedidoDetalleWS.nTipoGanado = 0;
                pedidoDetalleWS.nCalidadCanal = 0;
                pedidoDetalleWS.nCondicionCajaCanal = 0;
                pedidoDetalleWS.nCantidadPedidaUnidadMovimiento = item.Cantidad_Pedida_Unidad_Movimiento__c;
                pedidoDetalleWS.nCantidadPedida = item.Kilos__c;
                if(item.Cajas__c != null) 
                    pedidoDetalleWS.nPiezasPedidas = Integer.valueOf(item.Cajas__c);
                pedidoDetalleWS.nCantidadConfirmadaUnidadMovimiento = item.Cantidad_Confirmada_Unidad_Movimiento__c;
                pedidoDetalleWS.nCantidadConfirmada = item.Kilos_Conf__c;
                if(item.Cajas_Conf__c != null) 
                    pedidoDetalleWS.nPiezasConfirmadas = Integer.valueOf(item.Cajas_Conf__c);
                if(limpiaBalanceo){
                    pedidoDetalleWS.nCantidadBalanceadaUnidadMovimiento = 0;
                    pedidoDetalleWS.nCantidadBalanceada = 0;
                    pedidoDetalleWS.nPiezasBalanceadas = 0;
                }else{
                    System.debug('Balanceo de producto');
                    System.debug(item);
                    pedidoDetalleWS.nCantidadBalanceadaUnidadMovimiento = item.Cantidad_Balanceada_Unidad_de_Movimiento__c==null ? 0 : item.Cantidad_Balanceada_Unidad_de_Movimiento__c;
                    pedidoDetalleWS.nCantidadBalanceada = item.Cajas_Balanceadas__c == null ? 0 : item.Cajas_Balanceadas__c;
                    pedidoDetalleWS.nPiezasBalanceadas = item.Piezas_Balanceadas__c==null ? 0 : Integer.valueOf(item.Piezas_Balanceadas__c);
                }
                pedidoDetalleWS.nCantidadSurtida = 0;
                pedidoDetalleWS.nPiezasSurtidas = 0;
                pedidoDetalleWS.nCantidadSurtidaEnUnidadBase = 0;
                pedidoDetalleWS.nPesoPromedio = item.Unidad__c == 'L' ? product.Peso_Promedio__c * PedidoUtilsGINSA.CONVERSION_KILO_POUND : product.Peso_Promedio__c;
                
                String tipoPrecio = precioListXProductCodeMap.get(productCode)[0].pve_tipprec.substring(1);
                pedidoDetalleWS.nFactorConversionAUnidadBase = 
                    item.Unidad__c == 'K' && tipoPrecio == 'L' ? 
                    PedidoUtilsGINSA.CONVERSION_KILO_POUND : item.Unidad__c == 'L' && tipoPrecio == 'K' ? 
                        (1/PedidoUtilsGINSA.CONVERSION_KILO_POUND).setScale(4) : 1;
                pedidoDetalleWS.bPedidoEnUnidadDePeso = false;
                pedidoDetalleWS.bSurtido = false;
                pedidoDetalleWS.nTipoLista = 0;
                if(item.Precio_Lista_Precios__c != null) 
                    pedidoDetalleWS.Precio_nListaPrecios = Integer.valueOf(item.Precio_Lista_Precios__c);
                pedidoDetalleWS.Precio_nRenglon = 0;
                pedidoDetalleWS.Precio_nFolioOferta = 0;
                pedidoDetalleWS.nPrecioUnitarioOriginal = item.Precio_Unitario_Original__c;
                pedidoDetalleWS.nPrecioUnitarioOtorgado = item.Precio_Unitario_Otorgado__c; //PrecioUnitarioOtorgado__c;
                pedidoDetalleWS.nImporte = item.TotalPrice;
                if( monedas == null ) {
                	pedidoDetalleWS.nMoneda = item.Moneda__c == 'P' ? 1 : 2;
                }
                else {
                    for( Monedas__c m: monedas ) {
                        if( m == null ) { continue; }
                        if( m.Name == pedidoWrapper.pedidoItemList[i].Moneda__c ) {
                         	pedidoDetalleWS.nMoneda = Integer.valueOf( m.ID_Moneda__c );
                        }
                    }
                }
                pedidoDetalleWS.nTipoCambio = item.Tipo_Cambio__c;
                pedidoDetalleWS.cObservacion = '';
                pedidoDetalleWS.nCausaIncumplimiento = 0;
                pedidoDetalleWS.cObservacionIncumplimiento = '';
                pedidoDetalleWS.nDiasMinimosProduccion = 0;
                pedidoDetalleWS.nDiasMaximosProduccion = 0;
                pedidoDetalleWS.nTipoPrecioOriginal = 0;
                pedidoDetalleWS.nContenidoProducto = 0;
                pedidoDetalleWS.bEsProductoFR = false;
                pedidoDetalleWS.nRangoInventario = 0;
                pedidoDetalleWS.nAutorizaEspecial = 0;
                pedidoDetalleWS.ProductoSAP = productCode;
                System.debug('PedidoDetalleWS :: ' + pedidoDetalleWS);
                pedidoWS.Detalle.PedidoDetalle.add(pedidoDetalleWS);
            }
            SYstem.debug('Pedido :: ' + pedidoWS);
            return pedidoWS;
        }
        
        public PedidoInsertNSCWS.PedidoRespuesta syncPedido(PedidoUtilsGINSA.PedidoWrapper pedidoWrapper, PedidoUtilsGINSA.AccountWrapper accountWrapper) {
            PedidoInsertNSCWS.Pedido pedidoWS = setPedidoWS(pedidoWrapper,accountWrapper);
            PedidoInsertNSCWS.RespuestaOfPedidoRespuesta response = sendPedido(pedidoWS);
            if(response != null) {
                return response.Datos;
            }
            return null;
        }
        /*
        public BalanceoNSCWS.RespuestaOfString syncPedido(BalanceoNSCWS.ArrayOfPedido pedidosWS, Integer canal) {
            //PedidoInsertNSCWS.RespuestaOfPedidoRespuesta test = sendPedido(pedidosWS.Pedido[0]);
            //System.debug(test);
            BalanceoNSCWS.RespuestaOfString response = sendPedidos(pedidosWS,canal);
            if(response != null) {
                return response;
            }
            return null;
        }
		*/
        public OpportunityLineItem calculaEnBaseACajasConf(OpportunityLineItem pi){
            System.debug('InventarioXProductCodeMap: '+inventarioXProductCodeMap);
            String productCode = pi.PricebookEntry.Product2.ProductCode;
            System.debug(productCode);
            if(inventarioXProductCodeMap==null){
               inventarioXProductCodeMap = new Map<String, ProductoInventarioQueryNSCWS.Inventario>();
            }
            ProductoInventarioQueryNSCWS.Inventario inv = inventarioXProductCodeMap.get(productCode);
            System.debug(inv);
            if(inv==null){
                throw new CustomException(productCode + ': No se encontro el producto en el inventario');
            }
            inv.Contenido = inv.Contenido == null ? 0 : inv.Contenido;
            inv.EsPesoEstandar = inv.EsPesoEstandar == null ? true : inv.EsPesoEstandar;

            if(inv.Contenido > 0 && inv.EsPesoEstandar) {
                pi.Piezas_Conf__c = pi.Cajas_Conf__c * inv.Contenido;
            }
            pi.Kilos_Conf__c = pi.Cajas_Conf__c * pi.PricebookEntry.Product2.Peso_Promedio__c;
            pi.Cantidad_Confirmada_Unidad_Movimiento__c = pi.Unidad__c == 'L' ? pi.Kilos_Conf__c * PedidoUtilsGINSA.CONVERSION_KILO_POUND : pi.Kilos_Conf__c;

            return pi;
        }

        public OpportunityLineItem calculaImporte(OpportunityLineItem pedidoItemValues, Boolean isPreset) {
            String property = '';
            String productCode = pedidoItemValues.PricebookEntry.Product2.ProductCode;
            ProductoInventarioQueryNSCWS.Inventario inv = inventarioXProductCodeMap.get(productCode);
            if(!(inv.TipoManejoInventario == 2)) {
                property = 'Cajas_Conf__c';
            } else if(!(inv.TipoManejoInventario == 2 || !(inv.Contenido > 0 && inv.EsPesoEstandar))) {
                property = 'Piezas_Conf__c';
            } else if(!(inv.TipoManejoInventario == 1 || (inv.Contenido > 0 && inv.EsPesoEstandar))) {
                property = 'Kilos_Conf__c';
            } else {
                property = 'Cajas_Conf__c';
            }
            if(isPreset) {
                pedidoItemValues = asignaPrecioEnBaseARango(pedidoItemValues, property);
            }
            if(pedidoItemValues.Unidad__c == 'C') {
                pedidoItemValues.TotalPrice = pedidoItemValues.Cajas_Conf__c * pedidoItemValues.Precio_Unitario_Otorgado__c;
            } else if(pedidoItemValues.Unidad__c == 'P') {
                pedidoItemValues.TotalPrice = pedidoItemValues.Piezas_Conf__c * pedidoItemValues.Precio_Unitario_Otorgado__c;
            } else if(!(inv.TipoManejoInventario == 1 || (inv.Contenido > 0 && inv.EsPesoEstandar))) {
                pedidoItemValues.TotalPrice = pedidoItemValues.Kilos_Conf__c * pedidoItemValues.Precio_Unitario_Otorgado__c;
            } else {
                pedidoItemValues.TotalPrice = pedidoItemValues.PricebookEntry.Product2.Peso_Promedio__c * pedidoItemValues.Cajas_Conf__c * pedidoItemValues.Precio_Unitario_Otorgado__c;
            }
            return pedidoItemValues;
        }

        public OpportunityLineItem asignaPrecioEnBaseARango(OpportunityLineItem pedidoItemValues, String property) {
            //System.debug('PecioListXProductCode'+precioListXProductCodeMap);
            //System.debug('PedidoItemValues'+pedidoItemValues);
            //System.debug('Property'+property);
            String productCode = pedidoItemValues.PricebookEntry.Product2.ProductCode;
            for(ListaPreciosQueryNSCWS.Precios precio : precioListXProductCodeMap.get(productCode)){
                System.debug(precio);
                if(precio.pve_volini <= (Double)pedidoItemValues.get(property)) {
                    pedidoItemValues.ListPrice_Original__c = precio.pve_folgral;
                    Decimal precioUnitarioOriginalPesos = pedidoItemValues.Precio_Unitario_Otorgado__c = precio.pve_tipprec.substring(0, 1) == 'D' ? precio.precio * pedidoParameters.TipoCambioDolarPeso__c : precio.precio;
                    pedidoItemValues.Precio_Unitario_Original__c = pedidoItemValues.Precio_Unitario_Otorgado__c = pedidoItemValues.Moneda__c == 'D' ? precioUnitarioOriginalPesos/pedidoParameters.TipoCambioDolarPeso__c : precioUnitarioOriginalPesos;
                } else {
                    break;
                }
            }
            return pedidoItemValues;
        }
        
        private CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierre retrieveCierrePlaza(Integer cliente, String sucursal, Integer canal, Integer canalDestino) {
            CierrePlazaPedidoQueryNSCWS.CierrePedidosSoap request = new CierrePlazaPedidoQueryNSCWS.CierrePedidosSoap();
            request.timeout_x = PedidoUtilsGINSA.WEB_SERVICE_TIMEOUT;
            for(Integer i=1; i<=MAX_CALLOUT_RETRIES; i++) {
                try {
                    return validateCierrePlazaResponse(request.ValidaCierrePedidos(cliente, sucursal, canal, canalDestino));
                } catch(Exception e) {
                    if(i == PedidoUtilsGINSA.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtilsGINSA.CIERREPLAZA_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }
        
        private ProductoInventarioQueryNSCWS.RespuestaOfListOfInventario retrieveInventario(Integer cliente, String sucursal, Integer tipoSurtido, Integer canal, String ordenCompra) {
            ProductoInventarioQueryNSCWS.DisponibilidadInventarioSoap request = new ProductoInventarioQueryNSCWS.DisponibilidadInventarioSoap();
            request.timeout_x = PedidoUtilsGINSA.WEB_SERVICE_TIMEOUT;
            for(Integer i=1; i<=PedidoUtilsGINSA.MAX_CALLOUT_RETRIES; i++) {
                try {
                    return validateInventarioResponse(request.RegresaDisponibilidad(cliente, sucursal, tipoSurtido, canal, ordenCompra));
                } catch(Exception e) {
                    if(i == PedidoUtilsGINSA.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtilsGINSA.INVENTARIO_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }
        
        private ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios retrieveListaPrecios(String cliente, String gpoVendedores, String ofiVentas, String orgVentas, String canal, String destinatario, String cluster, String cadena, String fecDoc) {
            ListaPreciosQueryNSCWS.ListaPreciosSoap request = new ListaPreciosQueryNSCWS.ListaPreciosSoap();
            request.timeout_x = PedidoUtilsGINSA.WEB_SERVICE_TIMEOUT;
            for(Integer i=1; i<=PedidoUtilsGINSA.MAX_CALLOUT_RETRIES; i++) {
                try {
                    return validateListaPreciosResponse(request.RegresaListaPrecios(cliente, gpoVendedores, ofiVentas, orgVentas, canal, destinatario, cluster, cadena, fecDoc));
                } catch(Exception e) {
                    if(i == PedidoUtilsGINSA.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtilsGINSA.LISTAPRECIOS_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }
		/*
        public Map<Integer,BalanceoNSCWS.BalanceoProductos> retrieveTipoManejoInventario(Set<Integer> productos, Integer canal) {
            BalanceoNSCWS.BalanceoSoap request = new BalanceoNSCWS.BalanceoSoap();
            request.timeout_x = PedidoUtilsGINSA.WEB_SERVICE_TIMEOUT;
            
            BalanceoNSCWS.ArrayOfInt producto = new BalanceoNSCWS.ArrayOfInt();
            producto.int_x = new Integer[]{};
            for(Integer p : productos){
                producto.int_x.add(p);
            }

            Map<Integer,BalanceoNSCWS.BalanceoProductos> responseData;
            for(Integer i=1; i<=PedidoUtilsGINSA.MAX_CALLOUT_RETRIES; i++) {
                try {
                    responseData = new Map<Integer,BalanceoNSCWS.BalanceoProductos>();
                    BalanceoNSCWS.RespuestaOfListOfBalanceoProductos response = validateRespuestaInventario(request.RegresaInventarioPorProducto(producto, canal));
                    for(BalanceoNSCWS.BalanceoProductos balanceoProducto:response.Datos.BalanceoProductos){
                        responseData.put(balanceoProducto.Producto, balanceoProducto);
                    }
                } catch(Exception e) {
                    System.debug(e.getStackTraceString());
                    if(i == PedidoUtilsGINSA.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtilsGINSA.BALANCEO_WEB_SERVICE_ERROR_INVENTARIO+e.getMessage()));
                    }
                }
            }
            return responseData;
        }
		*/
        public CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierre retrieveCierrePlaza(Set<Integer> canales,Integer canalPadre) {
            CierrePlazaPedidoQueryNSCWS.CierrePedidosSoap request = new CierrePlazaPedidoQueryNSCWS.CierrePedidosSoap();
            request.timeout_x = PedidoUtilsGINSA.WEB_SERVICE_TIMEOUT;

            CierrePlazaPedidoQueryNSCWS.ArrayOfInt ArrayCanales = new CierrePlazaPedidoQueryNSCWS.ArrayOfInt();
            ArrayCanales.int_x = new Integer[]{};
            for(Integer canal: canales){
                ArrayCanales.int_x.add(canal);
            }
            for(Integer i=1; i<=PedidoUtilsGINSA.MAX_CALLOUT_RETRIES; i++) {
                try {
                    return validateCierrePlazaResponse(request.ValidaCierrePedidosMasivo(ArrayCanales, canalPadre));
                } catch(Exception e) {
                    System.debug(e.getStackTraceString());
                    if(i == PedidoUtilsGINSA.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtilsGINSA.CIERREPLAZA_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }
        
        private PedidoInsertNSCWS.RespuestaOfPedidoRespuesta sendPedido(PedidoInsertNSCWS.Pedido pedidoWS) {
            PedidoInsertNSCWS.PedidosSoap request = new PedidoInsertNSCWS.PedidosSoap();
            request.timeout_x = 50000;
            System.debug('Enviando pedido... '+pedidoWS);
            for(Integer i=1; i<=PedidoUtilsGINSA.MAX_CALLOUT_RETRIES; i++) {
                try {
                    return validatePedidoResponse(request.RegistrarPedido(pedidoWS));
                } catch(Exception e) {
                    if(i == PedidoUtilsGINSA.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtilsGINSA.PEDIDO_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }
        /*
        private BalanceoNSCWS.RespuestaOfString sendPedidos(BalanceoNSCWS.ArrayOfPedido pedidosWS, Integer canal) {
            BalanceoNSCWS.BalanceoSoap request = new BalanceoNSCWS.BalanceoSoap();
            request.timeout_x = 50000;
            for(Integer i=1; i<=PedidoUtilsGINSA.MAX_CALLOUT_RETRIES; i++) {
                try {
                    return validatePedidoResponse(request.GuardarPedidos(pedidosWS, canal));
                } catch(Exception e) {
                    if(i == PedidoUtilsGINSA.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtilsGINSA.PEDIDO_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }
        */
        private CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierre validateCierrePlazaResponse(CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierre response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtilsGINSA.CustomException(PedidoUtilsGINSA.CIERREPLAZA_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error')) {
                throw new PedidoUtilsGINSA.CustomException(response.Mensaje);
            } else if(response.Datos == null || response.Datos.Cierre == null || response.Datos.Cierre.isEmpty() || response.Datos.Cierre[0].cerrado == null) {
                throw new PedidoUtilsGINSA.CustomException(PedidoUtilsGINSA.CIERREPLAZA_WEB_SERVICE_NO_DATA_ERROR);
            }
            return response;
        }
        
        private ProductoInventarioQueryNSCWS.RespuestaOfListOfInventario validateInventarioResponse(ProductoInventarioQueryNSCWS.RespuestaOfListOfInventario response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtilsGINSA.CustomException(PedidoUtilsGINSA.INVENTARIO_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error')) {
                throw new PedidoUtilsGINSA.CustomException(response.Mensaje);
            } else if(response.Datos == null || response.Datos.Inventario == null || response.Datos.Inventario.isEmpty()) {
                throw new PedidoUtilsGINSA.CustomException(PedidoUtilsGINSA.INVENTARIO_WEB_SERVICE_NO_DATA_ERROR);
            }
            return response;
        }
        
        private ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios validateListaPreciosResponse(ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtilsGINSA.CustomException(PedidoUtilsGINSA.LISTAPRECIOS_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error')) {
                throw new PedidoUtilsGINSA.CustomException(response.Mensaje);
            } else if(response.Datos == null || response.Datos.Precios == null || response.Datos.Precios.isEmpty()) {
                throw new PedidoUtilsGINSA.CustomException(PedidoUtilsGINSA.LISTAPRECIOS_WEB_SERVICE_NO_DATA_ERROR);
            }
            return response;
        }
        
        private PedidoInsertNSCWS.RespuestaOfPedidoRespuesta validatePedidoResponse(PedidoInsertNSCWS.RespuestaOfPedidoRespuesta response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtilsGINSA.CustomException(PedidoUtilsGINSA.PEDIDO_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error') || response.Tipo.toLowerCase().contains('reintento')) {
                throw new PedidoUtilsGINSA.CustomException(response.Mensaje);
            } else if(response.Datos == null || response.Datos.Canal == null || response.Datos.NumeroPedido == null) {
                throw new PedidoUtilsGINSA.CustomException(PedidoUtilsGINSA.PEDIDO_WEB_SERVICE_NO_DATA_ERROR);
            }
            return response;
        }
        /*
        private BalanceoNSCWS.RespuestaOfString validatePedidoResponse(BalanceoNSCWS.RespuestaOfString response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtilsGINSA.CustomException(PedidoUtilsGINSA.PEDIDO_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error') || response.Tipo.toLowerCase().contains('reintento')) {
                throw new PedidoUtilsGINSA.CustomException(response.Mensaje);
            } else if(response.Datos == null) {
                throw new PedidoUtilsGINSA.CustomException(PedidoUtilsGINSA.PEDIDO_WEB_SERVICE_NO_DATA_ERROR);
            }
            return response;
        }
		        
        private BalanceoNSCWS.RespuestaOfListOfBalanceoProductos validateRespuestaInventario(BalanceoNSCWS.RespuestaOfListOfBalanceoProductos response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtilsGINSA.CustomException(PedidoUtilsGINSA.BALANCEO_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error')) {
                throw new PedidoUtilsGINSA.CustomException(response.Mensaje);
            } else if(response.Datos == null || response.Datos.BalanceoProductos == null) {
                throw new PedidoUtilsGINSA.CustomException(PedidoUtilsGINSA.BALANCEO_WEB_SERVICE_NO_DATA_ERROR);
            }
            return response;
        }
		*/
    }

}