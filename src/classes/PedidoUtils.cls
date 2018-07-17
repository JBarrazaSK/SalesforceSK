/**
 * Description: PedidoWizard.component controller class. Balanceo de productos
 * Modifying by: Jose barraza
 * Created date: 07/04/2018
 **/ 
public with sharing class PedidoUtils { 
 
    public static final Integer DEFAULT_PEDIDOITEMWRAPPERLIST_SIZE = 10;
    public static final Integer MAX_CALLOUT_RETRIES = 3;
    public static final Integer WEB_SERVICE_TIMEOUT = 25000;
    public static final Decimal CONVERSION_KILO_POUND = 2.2046;
    public static final String WRONG_VALUE_ERROR = '. Dato incorrecto.';
    public static final String ACCOUNT_REQUIRED_WARNING = 'Debe seleccionar una cuenta.';
    public static final String MULTIPLE_ACCOUNT_QUERY_RESULTS_FOUND_WARNING = 'Múltiples coincidencias encontradas. Por favor, refine la búsqueda.';
    public static final String ACCOUNT_NOT_FOUND_WARNING = 'La sucursal solicitada no se encuentra en la base de datos o no es una sucursal válida.';
    public static final String ACCOUNT_MISSING_FIELDS_ERROR = 'Faltan datos de la sucursal: ';
    public static final String PRODUCT_NO_LONGER_IN_INVENTORY_WARNING = 'El producto ya no se encuentra en la lista de inventario, lo que ocasiona inconsistencia de datos. Comuníquese con el administrador.';
    public static final String CIERREPLAZA_WEB_SERVICE_ERROR = 'Error al obtener el cierre de plaza. Por favor, reintente. Mensaje: ';
    public static final String CIERREPLAZA_WEB_SERVICE_NO_DATA_ERROR = 'El servicio web de consulta de cierre de plaza no ha devuelto datos.';
    public static final String INVENTARIO_WEB_SERVICE_ERROR = 'Error al obtener el inventario de productos. Por favor, reintente. Mensaje: ';
    public static final String INVENTARIO_WEB_SERVICE_NO_DATA_ERROR = 'El servicio web de consulta de inventario de productos no ha devuelto datos. Comuníquese con el administrador.';
    public static final String LISTAPRECIOS_WEB_SERVICE_ERROR = 'Error al obtener la lista de precios. Por favor, reintente. Mensaje: ';
    public static final String LISTAPRECIOS_WEB_SERVICE_NO_DATA_ERROR = 'El servicio web de consulta de lista de precios no ha devuelto datos. Comuníquese con el administrador de precios.';
    public static final String PEDIDO_WEB_SERVICE_ERROR = 'Error al enviar el pedido. Por favor, reintente. Mensaje: ';
    public static final String PEDIDO_WEB_SERVICE_NO_DATA_ERROR = 'El servicio web de inserción del pedido, no ha devuelto datos.';
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


    public Map<String, Product2> product2XproductCodeMap {
        get {
            if(product2XproductCodeMap == null) {
                List<String> productCodeList;
                if(setProductos==null){
                    productCodeList = new List<String>(externalSources.inventarioXProductCodeMap.keySet());
                }else{
                    productCodeList = new List<String>(setProductos);
                }
                if(pedidoWrapper.product2Map==null){
                    pedidoWrapper.product2Map = new Map<Id, Product2>([
                        SELECT Description, Ficha_comercial__c, Name, Peso_Promedio__c, ProductCode,Unidad_de_medida_base__c
                        FROM Product2 
                        WHERE ProductCode IN :productCodeList
                    ]);
                }
                product2XproductCodeMap = new Map<String, Product2>();
                for(Product2 product2 : pedidoWrapper.product2Map.values()) {
                    product2XproductCodeMap.put(product2.ProductCode, product2);
                }
            }
            return product2XproductCodeMap;
        }
        set;
    }

    public PedidoUtils(String recordId){
        this(recordId,false);
    }

    public PedidoUtils(String recordId, Boolean pedidoMultiple){
        this(recordId,pedidoMultiple,false);
    }

    public PedidoUtils(String recordId, Boolean pedidoMultiple,Boolean cierrePlazas){
        this(recordId,pedidoMultiple,cierrePlazas,null);
    }

    public PedidoUtils(String recordId, Boolean pedidoMultiple, Boolean cierrePlazas, Map<Integer,BalanceoNSCWS.BalanceoProductos> inventario){
        this(recordId,pedidoMultiple,cierrePlazas,inventario,null);
    }

    public PedidoUtils(String recordId, Boolean pedidoMultiple, Boolean cierrePlazas, Map<Integer,BalanceoNSCWS.BalanceoProductos> inventario, Map<String,String> productos){
        this(recordId,pedidoMultiple,cierrePlazas,inventario,productos,null,null,null,null,null);
    }
    
    public PedidoUtils(String recordId, Boolean pedidoMultiple, Boolean cierrePlazas, Map<Integer,BalanceoNSCWS.BalanceoProductos> inventario, Map<String,String> productos, Pedido__c pedidoRef, Account accRef, ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios lPrecios, Map<String,List<Gpo_Vendedores_Oficina_de_Ventas__c>> gruposVendedores,Map<Id, Product2> product2General){
    	this(recordId, pedidoMultiple, cierrePlazas,inventario,null, productos, pedidoRef, accRef, lPrecios, gruposVendedores,product2General);
    }

    public PedidoUtils(String recordId, Boolean pedidoMultiple, Boolean cierrePlazas, Map<Integer,BalanceoNSCWS.BalanceoProductos> inventario,Map<Integer,InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element> inventarioSAP, Map<String,String> productos, Pedido__c pedidoRef, Account accRef, ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios lPrecios, Map<String,List<Gpo_Vendedores_Oficina_de_Ventas__c>> gruposVendedores,Map<Id, Product2> product2General){
        pedidoWrapper = new PedidoWrapper();
        accountWrapper = new PedidoUtils.AccountWrapper(gruposVendedores);
        String recordIdPrefix = recordId.left(3);

        pedidoWrapper.product2Map = product2General;

        if(recordIdPrefix == SObjectType.Account.getKeyPrefix()) {
            pedidoWrapper.pedido.Cuenta__c = recordId;
            queryAccount();
            accountWrapper.isSelectable = false;
        } else if(recordIdPrefix == SObjectType.Lead.getKeyPrefix()) {
            pedidoWrapper.pedido.Prospecto__c = recordId;
        } else if(recordIdPrefix == SOBjectType.Pedido__c.getKeyPrefix()) {
            if(pedidoRef==null){
                pedidowrapper.queryPedido(recordId);
            }else{
                pedidowrapper.asignaPedido(pedidoRef);
            }

            if(accRef==null){
                queryAccount();
            }else{
                queryAccount(accRef);
            }				
            stepForth(pedidoMultiple,cierrePlazas,inventario,inventarioSAP,productos,accRef,lPrecios);
        }
    }

    public void queryAccount() {
        accountWrapper.queryAccount(pedidoWrapper.pedido.Cuenta__c);
        setQueryAccount();
    }

    public void queryAccount(Account acc) {
        accountWrapper.validateQueryAccount(new List<Account>{acc});
        setQueryAccount();
    }

    private void setQueryAccount(){
        pedidoWrapper.pedido.Cuenta__c = accountWrapper.account.Id;
        if(pedidoWrapper.pedido.Id == null) {
            pedidoWrapper.pedido.TipoSurtido__c = accountWrapper.account.RecordType.Name == 'Sucursal' && accountWrapper.account.DiasEntrega__c != null && accountWrapper.account.Canal_de_Distribucion_NSC__r.Id != null ? '3 - RUTA' : '4 - LOCAL';
        }
    }

    public void stepForth(Boolean pedidoMultiple, Boolean cierrePlazas,Map<Integer,BalanceoNSCWS.BalanceoProductos>  inventario, Map<String,String> productos) {
        stepForth(pedidoMultiple, cierrePlazas, inventario, productos, null, null);
    }
    
    public void stepForth(Boolean pedidoMultiple, Boolean cierrePlazas,Map<Integer,BalanceoNSCWS.BalanceoProductos>  inventario, Map<String,String> productos, Account accRef, ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios lPrecios) {
    	stepForth(pedidoMultiple, cierrePlazas,inventario,null,productos, accRef, lPrecios);
    }
    
    public void stepForth(Boolean pedidoMultiple, Boolean cierrePlazas,Map<Integer,BalanceoNSCWS.BalanceoProductos>  inventario,Map<Integer,InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element>  inventarioSAP, Map<String,String> productos, Account accRef, ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios lPrecios) {
        String tipoSurtido = accountWrapper.account.Tipo_Surtido__c.left(1);
        String oficinaVentasName = accountWrapper.oficinaVentasName;
        if(accRef==null){
            queryAccount();
        }else{
            //queryAccount(accRef);
        }
        pedidoWrapper.pedido.TipoSurtido__c = tipoSurtido;
        system.debug('stepForth');
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
        }
        pedidoWrapper.tipoSurtido = Integer.valueOf(accountWrapper.account.Tipo_Surtido__c.left(1));
        pedidoWrapper.fecDoc = String.valueOf(pedidoWrapper.pedido.FechaSurtidoProgramada__c).left(10).replaceAll('-', '');
        System.debug('fecha documentos: '+pedidoWrapper.fecDoc);
        externalSources = new ExternalSources();

        boolean valContinuarPrecios = false;
        if(pedidoMultiple){
            setProductos = new Set<String>(productos.values());
            product2XproductCodeMap.size();
            System.debug(product2XproductCodeMap);
            externalSources.inventarioXProductCodeMap = new Map<String, ProductoInventarioQueryNSCWS.Inventario>();
			if(inventario != null){
	            for(BalanceoNSCWS.BalanceoProductos bp : inventario.values()){
	                //setProductos.add(String.valueOf(bp.Producto));
	                externalSources.inventarioXProductCodeMap.put(String.valueOf(bp.Producto),parseInventario(bp));
	            }
			}else if(inventarioSAP != null){
	            for(InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element bp : inventarioSAP.values())
	                externalSources.inventarioXProductCodeMap.put(String.valueOf(bp.Producto),parseInventario(bp));
            }
            valContinuarPrecios = !cierrePlazas &&
                externalSources.setPrecioListXProductCodeMap(accountWrapper.clienteSAP, accountWrapper.gpoVendedores, accountWrapper.ofiVentas, accountWrapper.orgVentas, accountWrapper.canalSAP, accountWrapper.sucursal, accountWrapper.cluster, accountWrapper.cadena, pedidoWrapper.fecDoc,lPrecios);
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
    
    public ProductoInventarioQueryNSCWS.Inventario parseInventario(InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element bp){
        ProductoInventarioQueryNSCWS.Inventario inv = new ProductoInventarioQueryNSCWS.Inventario();
        inv.Producto = Integer.ValueOf(bp.Producto.trim());
        inv.InvActual = bp.Disponible;
        inv.TipoManejoInventario = 0;//bp.TipoManejoInventario;
        inv.Contenido = 0;//Integer.valueOf(bp.Contenido);
       //inv.EsPesoEstandar = bp.EsPesoEstandar;
        inv.CompAlmHoy = 1;
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

    public static Map<Id,Pedido__c> queryPedidos(Set<String> pedidosId) {
        return new Map<Id,Pedido__c>([
            SELECT Id, Canal__c, Costo_de_Flete__c, CreatedDate, Cuenta__c, DepartamentoOrdenCompra__c, EstatusPedido__c, Factura__c, Factura_No_Fiscal__c, Fecha_de_Entrega__c, Fecha_Registro__c, FechaSurtidoProgramada__c, Forma_Pago__c, MotivoAutorizacion__c,
            Muestra__c, Name, Numero_de_Pedido_NSC__c, Observacion__c, Orden_de_Compra__c, Pedido_Cancelado__c, Pedido_Cliente__c, PedidoAceptado__c, PedidoCanceladoPorElSistema__c, PedidoRechazado__c, Prospecto__c, RequiereAutorizacion__c, TipoAutorizacionRemota__c,
            TipoSurtido__c, CreatedBy.Username, Organizacion_de_Ventas__c, OficinaVentas__r.Codigo__c, OficinaVentas__r.Name,Numero_Pedido_SAP__c,Prospecto__r.Id_prospecto_sap__c,IdExterno__c,OficinaVentas__r.Opera_en_SAP__c,
            (
             SELECT Cajas__c, Cajas_Conf__c,
             CantidadConfirmadaUnidadMovimiento__c, CantidadPedidaUnidadMovimiento__c,
             Kilos__c, Kilos_Conf__c,
             Piezas__c, Piezas_Conf__c,
             Cantidad_Balanceada_Unidad_de_Movimiento__c, Cajas_Balanceadas__c, Piezas_Balanceadas__c,Kilos_Balanceados__c,TipoPrecio__c,
             Importe__c, Moneda__c, Pedido__c, PrecioListaPrecios__c, PrecioUnitarioOriginal__c, PrecioUnitarioOtorgado__c, Producto__c, TipoCambio__c, Unidad__c, Precio_Requiere_Aprobacion__c, Precio_Aprobado_Supervisor__c, Precio_Aprobado_Pr__c,
             Producto__r.Description, Producto__r.Peso_Promedio__c, Producto__r.ProductCode,Tipo_Precio__c
             FROM Productos_del_pedido__r
             ORDER BY Id ASC
            ) 
            FROM Pedido__c
            WHERE Id IN :pedidosId
        ]);
    }

    public static Map<Id,Account> queryAccountSet(Set<String> accountsId) {
        return new Map<Id,Account>([
            SELECT Id, Cadena__c, Canal_Distribucion__c, Canal_Padre__c, Correo_Electronico__c,
                DiasEntrega__c, Name, Numero_Cliente_SAP__c, Organizacion_de_Ventas__c,
                Ramo__c, RFC_Generico__c, Territorio__c,
                Canal_de_Distribucion_NSC__r.Codigo__c, Canal_de_Distribucion_NSC__r.Name,
                Parent.Numero_Cliente_SAP__c, Parent.Tipo_de_Credito__c, Parent.RFC__c,
                Parent.RFC_Generico__c,
            	Oficina_de_Ventas__r.Codigo__c,
                Tipo_Surtido__c,
                RecordType.Name,Sector__c
            FROM Account
            WHERE Estatus_Cliente__c = 'Activo'
                AND RecordType.Name = 'Sucursal'
                AND Id IN :accountsId ]
        );
    }



    public class CustomException extends Exception {}

    public class PedidoWrapper {
        public Pedido__c pedido { get; set; }
        public List<PedidoItem__c> pedidoItemList { get; set; }
        public PedidoParameters__c pedidoParameters { get; set; }
        public Decimal importe { get; set; }
        public Integer tipoSurtido { get; set; }
        public Integer indexToRemove { get; set; }
        public Boolean isCancelacion { get; set; }
        public String preId { get; set; }
        public String fecDoc;

        public Map<Id, Product2> product2Map;

        public PedidoWrapper() {
            preId = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(UserInfo.getUserId()+UserInfo.getSessionId()+System.now()+EncodingUtil.convertToHex(Crypto.generateAesKey(256)))));
            pedido = new Pedido__c(
                Fecha_Registro__c = System.today(),
                Orden_de_Compra__c = '0'
            );
        }

        public void queryPedido(String pedidoId) {
            Map<Id,Pedido__c> queryPedidos = PedidoUtils.queryPedidos(new Set<String>{pedidoId});
            asignaPedido(queryPedidos.values().get(0));
        }

        public void asignaPedido(Pedido__c pedidoRef) {
            pedido = pedidoRef;
            pedidoItemList = pedido.Productos_del_pedido__r;
        }

        public PedidoItem__c queryPedidoItem(String idPedidoItem){
            return [SELECT Cajas__c, Cajas_Conf__c, CantidadConfirmadaUnidadMovimiento__c, CantidadPedidaUnidadMovimiento__c, Importe__c, Kilos__c, Kilos_Conf__c, Moneda__c, Pedido__c, Piezas__c, Piezas_Conf__c, PrecioListaPrecios__c, PrecioUnitarioOriginal__c, PrecioUnitarioOtorgado__c, Producto__c, TipoCambio__c, Unidad__c, Precio_Requiere_Aprobacion__c, Precio_Aprobado_Supervisor__c, Precio_Aprobado_Pr__c,
                        Producto__r.Description, Producto__r.Peso_Promedio__c, Producto__r.ProductCode,Tipo_Precio__c 
                    FROM PedidoItem__c Where Id=:idPedidoItem];
        }

        public void instanceNewPedidoItemList() {
            pedidoItemList = new List<PedidoItem__c>();
            for(Integer i=0; i<PedidoUtils.DEFAULT_PEDIDOITEMWRAPPERLIST_SIZE; i++) {
                pedidoItemList.add(new PedidoItem__c()); 
            }
        }

        public void queryPedidoParameters() {
            pedidoParameters = PedidoParameters__c.getInstance();
        }

        public void setPedidoDefaults(Account account, Boolean isClosedPlaza) {
            pedido.Cuenta__c = account.Id;
            pedido.Factura__c = account.Parent.Tipo_de_Credito__c == 'Revolvente - 2' || account.Parent.Tipo_de_Credito__c == 'Crédito - 3' || (account.Parent.Tipo_de_Credito__c == 'Contado - 1' && (account.Parent.RFC__c != null || account.Parent.RFC_Generico__c != null));
            pedido.FechaSurtidoProgramada__c = pedido.FechaSurtidoProgramada__c != null?pedido.FechaSurtidoProgramada__c:getNextWorkingDatetime(isClosedPlaza);
            pedido.Forma_Pago__c = account.Parent.Tipo_de_Credito__c == 'Revolvente - 2' || account.Parent.Tipo_de_Credito__c == 'Crédito - 3' ? '2 - Crédito' : account.Parent.Tipo_de_Credito__c == 'Contado - 1' && (account.Parent.RFC__c != null || account.RFC_Generico__c != null) ? '1 - Contado' : null;
            pedido.Correo_electronico_del_cliente__c = account.Correo_Electronico__c;
        }

        public void setPedidoData() {
            tipoSurtido = Integer.valueOf(pedido.TipoSurtido__c.left(1));
            pedido.Fecha_de_Entrega__c = pedido.FechaSurtidoProgramada__c.date();
            pedido.Importe__c = importe;
            if(String.isNotBlank(pedido.Prospecto__c)) {
                for(Lead lead : [
                    SELECT Id_Prospecto__c,Id_prospecto_sap__c 
                    FROM Lead
                    WHERE Id = :pedido.Prospecto__c
                ]) {
                    pedido.Prospecto__r = lead;
                }
            }
            for(Integer i=0; i<pedidoItemList.size(); i++) {
                if(String.isBlank(pedidoItemList[i].Producto__c)) {
                    pedidoItemList.remove(i--);
                }
            }
            setProduct2Data();
        }

        public boolean requiereAutorizacionPrecio(){

            for(PedidoItem__c pi : this.pedidoItemList){
                if(pi.Precio_Requiere_Aprobacion__c){
                    if(!pi.Precio_Aprobado_Supervisor__c){
                        return true;
                    }
                }
            }

            return false;
        }

        public void setProduct2Data() {
            for(PedidoItem__c pedidoItem : pedidoItemList) {
                pedidoItem.Producto__r = product2Map.get(pedidoItem.Producto__c);
                pedidoItem.TipoCambio__c = pedidoItem.Moneda__c == 'D' ? pedidoParameters.TipoCambioDolarPeso__c : 1;
            }
       system.debug('PedidoITEM'+ pedidoItemList);
        }

        public void addPedidoItem() {
            setProduct2Data();
            pedidoItemList.add(new PedidoItem__c());
        }

        public void clearPedidoItemList() {
            pedidoItemList.clear();
        }

        public void removePedidoItem() {
            system.debug('removePedidoItem antes' + pedidoItemList);
            if(indexToRemove < pedidoItemList.size()) {
                pedidoItemList.remove(indexToRemove);
               system.debug('removePedidoItem despues' + pedidoItemList);
               
            }
           setProduct2Data();            
        }

        public void addCurrentAmountsToInventory(Map<String, ProductoInventarioQueryNSCWS.Inventario> inventarioXProductCodeMap) {
            for(PedidoItem__c pedidoItem : pedidoItemList) {
                String codeP = pedidoItem.Producto__r.ProductCode;
                if(inventarioXProductCodeMap.containsKey(codeP)) {
                    inventarioXProductCodeMap.get(codeP).DispAlm += inventarioXProductCodeMap.get(codeP).TipoManejoInventario == 2 ? pedidoItem.Kilos_Conf__c : pedidoItem.Cajas_Conf__c;
                } else {
                    System.debug(codeP);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, pedidoItem.Producto__r.ProductCode+': '+PedidoUtils.PRODUCT_NO_LONGER_IN_INVENTORY_WARNING));
                }
            }
        }

        public void assignWebServiceResponseData(PedidoInsertNSCWS.PedidoRespuesta response) {
            pedido.Canal__c = leftPad0(response.Canal, 5);
            pedido.EstatusPedido__c = response.Estatus == 0 ? '0 - Rechazado' : response.Estatus == 1 ? '1 - Pedido Colocado' : null;
            pedido.MotivoAutorizacion__c = response.MotivoAutorizacion;
            pedido.Numero_de_Pedido_NSC__c = leftPad0(response.NumeroPedido, 10);
            pedido.PedidoRechazado__c = response.PedidoRechazado;
            pedido.RequiereAutorizacion__c = response.RequiereAutorizacion;
            pedido.TipoAutorizacionRemota__c = response.TipoAutorizacionRemota;
            pedido.IdExterno__c = pedido.Canal__c+pedido.Numero_de_Pedido_NSC__c;
        }
        
        public void assignWebServiceResponseData(ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido response) {
           
            if(response.Estatus != null)
            {
            	pedido.EstatusPedido__c =  '1 - Pedido Colocado';
             	pedido.RequiereAutorizacion__c = response.Estatus == 'B' ? true : false;
            }
            else
            	 pedido.EstatusPedido__c = '1 - Pedido Colocado';
            	 
            pedido.Numero_Pedido_SAP__c = response.FolioPedidoSAP;
            pedido.IdExterno__c = response.FolioPedidoSalesforce;
        }

        public void save() {
            if(isCancelacion == true) {
                pedido.Pedido_Cancelado__c = true;
            }
            Savepoint savepoint = Database.setSavepoint();
            try {
                upsert pedido;
                Set<Id> pedidoItemIdSet = new Set<Id>();
                for(PedidoItem__c pedidoItem : pedidoItemList) {
                    pedidoItem.Id_externo_Producto_Pedido__c = leftPad0(pedidoItem.Producto__r.ProductCode, 10)+pedido.IdExterno__c;
                    if(pedidoItem.Pedido__c == null) {
                        pedidoItem.Pedido__c = pedido.Id;
                    }
                    if(pedidoItem.Id != null) {
                        pedidoItemIdSet.add(pedidoItem.Id);
                    }
                    pedidoItem.Cajas_Balanceadas__c = null;
                    pedidoItem.Cantidad_Balanceada_Unidad_de_Movimiento__c = null;
                    pedidoItem.Kilos_Balanceados__c = null;
                    pedidoItem.Piezas_Balanceadas__c = null;
                }
                delete [
                    SELECT Id
                    FROM PedidoItem__c
                    WHERE Pedido__c = :pedido.Id
                        AND Id NOT IN :pedidoItemIdSet
                ];
                upsert pedidoItemList;
                queryPedido(pedido.Id);
                if(!pedido.Pedido_Cancelado__c) {
                	if( pedido.Numero_Pedido_SAP__c != null)
                	{
                		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, PedidoUtils.PEDIDO_INSERT_CONFIRM+'Folio SAP: '+pedido.Numero_Pedido_SAP__c+'.'));
                	}
                	else{ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, PedidoUtils.PEDIDO_INSERT_CONFIRM+'Folio NSC: '+pedido.Numero_de_Pedido_NSC__c+'.'));}
                    
                    
                   if(pedido.RequiereAutorizacion__c && pedido.Numero_Pedido_SAP__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidoUtils.PEDIDO_AUTHORIZATION_REQUIRED_WARNING+(pedido.TipoAutorizacionRemota__c ? 'remota' : 'local')+'. '+pedido.MotivoAutorizacion__c));
                    }
                   
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, PedidoUtils.PEDIDO_CANCEL_CONFIRM));
                }
            } catch(Exception e) {
                Database.rollback(savepoint);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PedidoUtils.PEDIDO_INSERT_ERROR+e.getMessage()));
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

        //Variable para Balanceo
        private Map<String,List<Gpo_Vendedores_Oficina_de_Ventas__c>> gpoVendedoresOV;

        public AccountWrapper() {
            this.account = new Account();
            this.isSelectable = true;
        }
        public AccountWrapper(Map<String,List<Gpo_Vendedores_Oficina_de_Ventas__c>> gpoVendedoresOV) {
            this();
            this.gpoVendedoresOV = gpoVendedoresOV;
        }

        public void queryAccount(String accountId) {
            if(String.isNotBlank(accountId) || String.isNotBlank(sucursal)) {
                List<Account> accountList = (List<Account>)Database.query(
                    'SELECT Id, Cadena__c, Canal_Distribucion__c, Canal_Padre__c, Correo_Electronico__c, ' +
                        'DiasEntrega__c, Name, Numero_Cliente_SAP__c, Organizacion_de_Ventas__c, ' +
                        'Ramo__c, RFC_Generico__c, Territorio__c, '+
                        'Canal_de_Distribucion_NSC__r.Codigo__c, Canal_de_Distribucion_NSC__r.Name, '+
                        'Parent.Numero_Cliente_SAP__c, Parent.Tipo_de_Credito__c, Parent.RFC__c, ' +
                        'Parent.RFC_Generico__c, '+
                        'Tipo_Surtido__c,Sector__c, '+
                    	'Oficina_de_Ventas__r.Codigo__c, '+ 
                        'RecordType.Name '+
                    'FROM Account '+
                    'WHERE Estatus_Cliente__c = \'Activo\' '+
                        'AND RecordType.Name = \'Sucursal\' '+
                        //'AND Numero_Cliente_SAP__c LIKE \'%'+accountId+'%\' '+
                        (String.isNotBlank(accountId) ? 'AND Id = :accountId ' : String.isNotBlank(sucursal) ? 'AND Numero_Cliente_SAP__c LIKE \'%'+sucursal+'%\' ' : '')+
                    'LIMIT 2'
                );
                this.validateQueryAccount(accountList);
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ACCOUNT_REQUIRED_WARNING));
            }
        }

        public void validateQueryAccount(List<Account> accountList){
            account.Id = null;
            if(!accountList.isEmpty()) {
                if(accountList.size() == 1) {
                    account = accountList.get(0);
                    if(isValidAccountWrapper()) {
                        queryOficinaVentas();
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, MULTIPLE_ACCOUNT_QUERY_RESULTS_FOUND_WARNING));
                }
            } else {
            	system.debug('stepForth1');
                isValidAccount();
            }
        }

        public void queryOficinaVentas() {
            oficinaVentasName = account.Canal_Padre__c; // Oficina de ventas
            oficinaVentasSelectOptionList = new List<SelectOption>();
            if(String.isNotBlank(gpoVendedores)) {
                List<Gpo_Vendedores_Oficina_de_Ventas__c> gpoTemp;
                if(gpoVendedoresOV!=null){
                    gpoTemp = gpoVendedoresOV.get(gpoVendedores);
                }else{
                    gpoTemp = [
                        SELECT Oficina_de_Venta__r.Name
                        FROM Gpo_Vendedores_Oficina_de_Ventas__c
                        WHERE Grupo_de_Vendedores__r.Codigo__c = :gpoVendedores
                        ORDER BY Name
                    ];
                }

                for(Gpo_Vendedores_Oficina_de_Ventas__c gpoVendedoresOficinaVentas : gpoTemp) {
                    oficinaVentasSelectOptionList.add(new SelectOption(gpoVendedoresOficinaVentas.Oficina_de_Venta__r.Name, gpoVendedoresOficinaVentas.Oficina_de_Venta__r.Name));
                }

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
        	system.debug('stepForth2 '+ account);
            if(account.Id != null) {
                List<String> missingFields = new List<String>();
                if(account.Canal_de_Distribucion_NSC__r.Id != null) {
                    if(String.isNotBlank(account.Canal_de_Distribucion_NSC__r.Codigo__c)) {
                        if(!account.Canal_de_Distribucion_NSC__r.Codigo__c.isNumeric()) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, SObjectType.Account.Fields.Canal_de_Distribucion_NSC__c.getLabel()+': '+SObjectType.Canal_de_Distribucion_NSC__c.Fields.Codigo__c.getLabel()+PedidoUtils.WRONG_VALUE_ERROR));
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
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, SObjectType.Account.Fields.ParentId.getLabel()+': '+SObjectType.Account.Fields.Numero_Cliente_SAP__c.getLabel()+PedidoUtils.WRONG_VALUE_ERROR));
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
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PedidoUtils.ACCOUNT_MISSING_FIELDS_ERROR+String.join(missingFields, ', ')+'.'));
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, PedidoUtils.ACCOUNT_NOT_FOUND_WARNING));
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
        	
        	system.debug('sucursal -------------> '+sucursal);
        	system.debug('canal -------------> '+canalDestino);
            isClosedPlaza = false;
			if(OficinaVentaCierre(canalDestino) && OperaEnSap(canalDestino))
			{
				isClosedPlaza = true; 
			}
	        else if(!OperaEnSap(canalDestino))
	        {
	        	CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierre response = retrieveCierrePlaza(cliente, sucursal, canal, canalDestino);
	            if(response != null) {
	                isClosedPlaza = response.Datos.Cierre[0].cerrado == 1;
	            }
	        }
            	
            
            return isClosedPlaza != null;
        }
        public Boolean OperaEnSap(Integer OficinaVentas)
        {
        	 Boolean valor = false;
			 Oficina_de_Venta__c[] ofv =  [select id,Cerrado__c,Opera_en_SAP__c,Reaperturado__c,Nueva_Hora_Cierre_DT__c,Extension__c from Oficina_de_Venta__c where codigo__c =: String.ValueOf(OficinaVentas) and Opera_en_SAP__c = true limit 1];
			  if (ofv.size() > 0)
			 {
			 	valor = true;
			 }
			 return valor;
        }
		public Boolean OficinaVentaCierre(Integer OficinaVentas)
		{
			System.debug('OficinaVentaCierre:::: ');
			 Boolean valor = false;
			 Oficina_de_Venta__c[] ofv =  [select id,Cerrado__c,Opera_en_SAP__c,Reaperturado__c,Nueva_Hora_Cierre_DT__c,Extension__c from Oficina_de_Venta__c where codigo__c =: String.ValueOf(OficinaVentas) and Opera_en_SAP__c = true limit 1];
			 if (ofv != null && ofv.size() > 0)
			 {
			 	if(!ofv[0].Cerrado__c)
			 	{
			 		valor = ValidarCierreCanal(ofv[0].Nueva_Hora_Cierre_DT__c);
		 			
			 	}
			 	else
			 	{
			 		valor = ofv[0].Cerrado__c;
			 	}
			 	
			 }
			 return valor;
		}
		public  Boolean ValidarCierreCanal(string HoraCierreDT)
		  { 
		       Time HoraActual = Time.newInstance(Datetime.now().hour(), Datetime.now().minute(), 0, 0);
		       Time HoraCierre = null;
		       string[] arregloHoracierre = null;
		       System.debug('HoraCierreDT= '+HoraCierreDT + ' HoraCierre= '+ HoraCierre);
		       if(!string.isBlank(HoraCierreDT))
		       		arregloHoracierre = HoraCierreDT.split(':'); 
		      System.debug('arregloHoracierre= '+arregloHoracierre );
		       if(arregloHoracierre != null && arregloHoracierre.size() > 1)
		       {
		       		HoraCierre = Time.newInstance(Integer.valueOf(arregloHoracierre[0]), Integer.valueOf(arregloHoracierre[1]), 0, 0);
		       		System.debug('HoraCierreDT= '+HoraCierreDT + ' HoraCierre= '+ HoraCierre);
		       		if(HoraActual >= HoraCierre)
		       		{
		       			return true;
		       		}
		       }	
		       return false;
		  }
		public Map<Integer,Boolean> OficinaVentaOperaSapMasivo(Set<Integer> canales)
		{
			 Boolean valor = true;
			 list<Oficina_de_Venta__c> listaAguardar = new list<Oficina_de_Venta__c>();
			 Map<Integer,Boolean> mapClosePlazas = new Map<Integer,Boolean>();
			 Set<String> Oficinas = new Set<String>();
			 for(Integer c : canales)
			 {
			 	Oficinas.add(String.ValueOf(c));
			 }
			 Oficina_de_Venta__c[] ofv =  [select id,Cerrado__c,codigo__c,Opera_en_SAP__c,Reaperturado__c,Nueva_Hora_Cierre_DT__c,Extension__c from Oficina_de_Venta__c where codigo__c IN: Oficinas and Opera_en_SAP__c = true];
			 if (ofv.size() > 0)
			 {
			 	for(Oficina_de_Venta__c of1 : ofv)
			 	{
			 		if(!of1.Cerrado__c)
			 		{
			 			valor = ValidarCierreCanal(of1.Nueva_Hora_Cierre_DT__c);
			 			if(valor)
			 			{
			 				of1.Cerrado__c = valor;
				 			of1.Reaperturado__c = false;
				 			of1.Extension__c = false;
				 			listaAguardar.add(of1);
			 			}
			 				
			 		}
		
		 		 	mapClosePlazas.put(Integer.ValueOf(of1.codigo__c),valor);
			 	}
			 }
			 if(listaAguardar.size() > 0)
			 	update listaAguardar;
			 
			 return mapClosePlazas;
		}
		public set<Integer> ValidarCanales(Set<Integer> canales,Map<Integer,Boolean> mapClosePlazas)
		{
			 set<Integer> sucursalesARevisar = new set<Integer>();
			 if(mapClosePlazas == null)
			 {
			 
			 }
			 for(Integer c : canales)
			 {
			 	if(!mapClosePlazas.containsKey(c))
			 		sucursalesARevisar.add(c);
			 }
			 return sucursalesARevisar;
		}
        public Map<Integer,Boolean> setIsClosedPlazas(Set<Integer> canales,Integer canalPadre) {
            Map<Integer,Boolean> mapClosePlazas = new Map<Integer,Boolean>();
            set<Integer> sucursalesARevisar = new set<Integer>();
            mapClosePlazas = OficinaVentaOperaSapMasivo(canales);
            sucursalesARevisar = mapClosePlazas == null? new Set<Integer>():ValidarCanales(canales,mapClosePlazas);
            if(sucursalesARevisar.size() > 0)
            {
            	CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierreMasivo response = retrieveCierrePlaza(canales,canalPadre);
	            if(response!=null && response.Datos!= null && response.Datos.CierreMasivo!=null ){
	                for (CierrePlazaPedidoQueryNSCWS.CierreMasivo cierre : response.Datos.CierreMasivo){
	                    mapClosePlazas.put(cierre.canal,cierre.cerrado == 1);
	                }
	            }else{
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PedidoUtils.CIERREPLAZA_WEB_SERVICE_ERROR));
	                mapClosePlazas = null;
	            }
            }
            
            return mapClosePlazas;
        }

        public Boolean setInventarioXProductCodeMap(Integer cliente, String sucursal, Integer tipoSurtido, Integer canal, String ordenCompra) {
            inventarioXProductCodeMap = new Map<String, ProductoInventarioQueryNSCWS.Inventario>();
            
            if(OperaEnSap(canal))
            {
            	system.debug('sucursal: -------------------> '+ sucursal.leftPad(10, ''));
            	DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp response = 	retrieveInventarioSap(cliente,sucursal,tipoSurtido,canal,ordenCompra);
            	system.debug('response: -------------------> '+ response);
            	if(response != null && response.TipoMensaje =='S') {
            		ProductoInventarioQueryNSCWS.Inventario invt = null;
	                for(DisponibilidadInventarioSAP.Informacion_element inventario : response.Informacion) {
	                    if(inventario.NumeroProducto != null) {
                             inventario.TipoManejoInventario = '3';
	                    	 invt = CrearElementoInventario(inventario);
	                    	 inventarioXProductCodeMap.put(String.valueOf(invt.Producto), invt);
	                    }
	                }
	                if(inventarioXProductCodeMap.isEmpty()) {
	                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PedidoUtils.INVENTARIO_WEB_SERVICE_NO_DATA_ERROR));
	                }
	            }
	            else
	            {
	            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PedidoUtils.INVENTARIO_WEB_SERVICE_NO_DATA_ERROR));
	            }	
            }
            else
            {
	            ProductoInventarioQueryNSCWS.RespuestaOfListOfInventario response = retrieveInventario(cliente, sucursal, tipoSurtido, canal, ordenCompra);
	            if(response != null) {
	                for(ProductoInventarioQueryNSCWS.Inventario inventario : response.Datos.Inventario) {
	                    if(inventario.Producto != null) {
                            system.debug('ProductoInventario1 '+String.valueOf(inventario.Producto));
	                        inventarioXProductCodeMap.put(String.valueOf(inventario.Producto), inventario);
	                    }
	                }
	                if(inventarioXProductCodeMap.isEmpty()) {
	                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PedidoUtils.INVENTARIO_WEB_SERVICE_NO_DATA_ERROR));
	                }
	            }
            }
            return !inventarioXProductCodeMap.isEmpty();
        }

        public Boolean setPrecioListXProductCodeMap(String cliente, String gpoVendedores, String ofiVentas, String orgVentas, String canal, String destinatario, String cluster, String cadena, String fecDoc) {
            return setPrecioListXProductCodeMap(cliente, gpoVendedores, ofiVentas, orgVentas, canal, destinatario, cluster, cadena, fecDoc,null);
        }

        public Boolean setPrecioListXProductCodeMap(String cliente, String gpoVendedores, String ofiVentas, String orgVentas, String canal, String destinatario, String cluster, String cadena, String fecDoc, ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios response) {
            precioListXProductCodeMap = new Map<String, List<ListaPreciosQueryNSCWS.Precios>>();
            if(response==null){
                response = retrieveListaPrecios(cliente, gpoVendedores, ofiVentas, orgVentas, canal, destinatario, cluster, cadena, fecDoc);
            }
            
            
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
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PedidoUtils.LISTAPRECIOS_WEB_SERVICE_NO_DATA_ERROR));
                }
            }
            return !precioListXProductCodeMap.isEmpty();
        }

        public Map<String,ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios> getListaPreciosMasivo(ListaPreciosQueryNSCWS.ArrayOfPreciosXCliente clientes){
            return parseMapListaPreciosMasivo(retrieveListaPreciosMasivo(clientes));
        }
        
        public ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista setPedidoSAPWS(PedidoUtils.PedidoWrapper pedidoWrapper, PedidoUtils.AccountWrapper accountWrapper, boolean Balanceo) {
        	ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista result = new ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista();

        	result.SALES_HEADER_IN = new ABCPedidos_SF_to_ECC.SALES_HEADER_IN_element();
        	//result.SALES_HEADER_IN.TipoPedido;
        	if(!String.isBlank(pedidoWrapper.pedido.Numero_Pedido_SAP__c))
        		result.SALES_HEADER_IN.FolioPedidoSAP 		= pedidoWrapper.pedido.Numero_Pedido_SAP__c;
        	result.SALES_HEADER_IN.FolioPedidoSalesForce	= generateIdPedidoSF();
        	result.SALES_HEADER_IN.OrganizacionVentas 		= accountWrapper.account.Organizacion_de_Ventas__c.right(4);
        	result.SALES_HEADER_IN.OficinaVentas			= pedidoWrapper.pedido.OficinaVentas__r.Codigo__c;	
        	result.SALES_HEADER_IN.CanalDistribucion		= 'DT';//pedidoWrapper.pedido.Canal__c;
        	result.SALES_HEADER_IN.Sector					= accountWrapper.account.Sector__c.right(2);
        	result.SALES_HEADER_IN.FechaSurtido 			= pedidoWrapper.pedido.FechaSurtidoProgramada__c.format('yyyyMMdd');
        	result.SALES_HEADER_IN.OrdenCompraCliente		= pedidoWrapper.pedido.Orden_de_Compra__c;
        	result.SALES_HEADER_IN.NumeroPedidoSalesForce 	= pedidoWrapper.pedido.Name;
        	result.SALES_HEADER_IN.Estatus = (!String.isBlank(pedidoWrapper.pedido.Numero_Pedido_SAP__c))?'U':'I';
        	//result.SALES_HEADER_IN.DOC_TYPE = 'ZORC';ubtwf

        	result.SALES_ITEMS_IN 		= new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaITEMS_Linea();
        	result.SALES_PARTNERS 		= new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaPARTNERS_Linea();
        	result.SALES_CONDITIONS_IN 	= new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaCONDITIONS_Linea();
        	result.SALES_TEXT 			= new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaTEXT_Linea();
        	result.SALES_SCHEDULES_IN 	= new ABCPedidos_SF_to_ECC.ArrayOfDT_SE_ABCPedidos_ReqListaSCHEDULES_Linea();
        	
        	result.SALES_ITEMS_IN.ITEMS_Linea 			= new list<ABCPedidos_SF_to_ECC.ITEMS_Linea_element>();
        	result.SALES_PARTNERS.PARTNERS_Linea 		= new list<ABCPedidos_SF_to_ECC.PARTNERS_Linea_element>();
        	result.SALES_CONDITIONS_IN.CONDITIONS_Linea = new list<ABCPedidos_SF_to_ECC.CONDITIONS_Linea_element>();
        	result.SALES_TEXT.TEXT_Linea 				= new list<ABCPedidos_SF_to_ECC.TEXT_Linea_element>();
        	result.SALES_SCHEDULES_IN.SCHEDULES_Linea 	= new list<ABCPedidos_SF_to_ECC.SCHEDULES_Linea_element>();
        	//MAPAS
        	map< String ,String> mapaMoneda = new map< String ,String>{'D'=>'USD','P'=>'MXN'};
			map<string,string> mapaUnidadMedida = new map<string,string>{'C'=>'CS','K'=>'KG','L'=>'LB','P'=>'PI'};
			ABCPedidos_SF_to_ECC.TEXT_Linea_element 		elem4 = new ABCPedidos_SF_to_ECC.TEXT_Linea_element();
			elem4.Comentarios 			= pedidoWrapper.pedido.Observacion__c;
			result.SALES_TEXT.TEXT_Linea.add(elem4);       		
        	
        	for(Integer i=0; i<pedidoWrapper.pedidoItemList.size(); i++) {
        		ABCPedidos_SF_to_ECC.ITEMS_Linea_element 		elem1 = new ABCPedidos_SF_to_ECC.ITEMS_Linea_element();
        		ABCPedidos_SF_to_ECC.PARTNERS_Linea_element 	elem2 = new ABCPedidos_SF_to_ECC.PARTNERS_Linea_element();
        		ABCPedidos_SF_to_ECC.CONDITIONS_Linea_element 	elem3 = new ABCPedidos_SF_to_ECC.CONDITIONS_Linea_element();
        		
        		ABCPedidos_SF_to_ECC.SCHEDULES_Linea_element 	elem5 = new ABCPedidos_SF_to_ECC.SCHEDULES_Linea_element();
        		elem1.Producto 				= pedidoWrapper.pedidoItemList[i].Producto__r.ProductCode;
        		
        		if(pedidoWrapper.pedidoItemList[i].Cajas__c != null)
        			elem1.Cajas 			= String.valueOf(pedidoWrapper.pedidoItemList[i].Cajas__c);
        		
        		if(mapaUnidadMedida.containsKey(pedidoWrapper.pedidoItemList[i].Unidad__c) && mapaUnidadMedida.get(pedidoWrapper.pedidoItemList[i].Unidad__c) == 'PI')
        			elem1.Cajas = String.valueOf(pedidoWrapper.pedidoItemList[i].Piezas__c);
        		
        		if(mapaUnidadMedida.containsKey(pedidoWrapper.pedidoItemList[i].Unidad__c))
        			elem1.TipoSurtido 	= mapaUnidadMedida.get(pedidoWrapper.pedidoItemList[i].Unidad__c);	
        		//elem1.TipoSurtido 			= pedidoWrapper.pedido.TipoSurtido__c.left(1);
        		
        		
        		if(pedidoWrapper.isCancelacion != null && pedidoWrapper.isCancelacion)
        			result.SALES_HEADER_IN.Estatus = 'D';
        		
        		result.SALES_ITEMS_IN.ITEMS_Linea.add(elem1);
        		
        		elem2.TipoCliente 			= 'WE';
        		elem2.Cliente 				= pedidoWrapper.pedido.Prospecto__c != null ? pedidoWrapper.pedido.Prospecto__r.Id_prospecto_sap__c :accountWrapper.account.Numero_Cliente_SAP__c.right(10);
        		result.SALES_PARTNERS.PARTNERS_Linea.add(elem2);
        		elem2 = new ABCPedidos_SF_to_ECC.PARTNERS_Linea_element();
        		elem2.TipoCliente 			= 'AG';
        		elem2.Cliente 				= accountWrapper.clienteSAP;
        		result.SALES_PARTNERS.PARTNERS_Linea.add(elem2);
        		if(!pedidoWrapper.pedido.Factura_No_Fiscal__c && pedidoWrapper.pedido.Prospecto__c != null)
        		{
        			elem2 = new ABCPedidos_SF_to_ECC.PARTNERS_Linea_element();
        			elem2.TipoCliente 			= 'RE';
	        		elem2.Cliente 				= pedidoWrapper.pedido.Prospecto__c != null ? pedidoWrapper.pedido.Prospecto__r.Id_prospecto_sap__c :accountWrapper.account.Numero_Cliente_SAP__c.right(10);
	        		result.SALES_PARTNERS.PARTNERS_Linea.add(elem2);
        		}
        		system.debug('TIPOPRECIO: ' + pedidoWrapper.pedidoItemList[i].TipoPrecio__c);
        		elem3.TipoPrecio	=  String.valueOf(pedidoWrapper.pedidoItemList[i].TipoPrecio__c);
        		elem3.Precio		=  String.valueOf(pedidoWrapper.pedidoItemList[i].PrecioUnitarioOriginal__c);
        		if(mapaMoneda.containsKey(pedidoWrapper.pedidoItemList[i].Moneda__c))
        			elem3.Moneda 	= mapaMoneda.get(pedidoWrapper.pedidoItemList[i].Moneda__c);
        		if(mapaUnidadMedida.containsKey(pedidoWrapper.pedidoItemList[i].Unidad__c))
        			elem3.Unidad 	= mapaUnidadMedida.get(pedidoWrapper.pedidoItemList[i].TipoPrecio__c);
        		result.SALES_CONDITIONS_IN.CONDITIONS_Linea.add(elem3);        		
        		
        		system.debug('UNIDNAD__C: ' + elem3.Unidad);
        		
        		/*if(pedidoWrapper.pedidoItemList[i].Cajas_Balanceadas__c != null)
        			elem5.CantidadBalanceada= String.valueOf(pedidoWrapper.pedidoItemList[i].Cajas_Balanceadas__c);*/
        			
        			
        		if(pedidoWrapper.pedidoItemList[i].Cajas_Conf__c != null)
        			elem5.CantidadBalanceada= String.valueOf(pedidoWrapper.pedidoItemList[i].Cajas_Conf__c);	
        		// Si es  pedido nuevo o modificacion y es diferente de Piezas  se mandas las cajas confirmadas 
        		if((result.SALES_HEADER_IN.Estatus == 'I' || result.SALES_HEADER_IN.Estatus == 'U') && mapaUnidadMedida.get(pedidoWrapper.pedidoItemList[i].Unidad__c) != 'PI' )
        		{
        			elem5.CantidadBalanceada= String.valueOf(pedidoWrapper.pedidoItemList[i].Cajas_Conf__c);        				
        		}
        		else
        		{
        			elem5.CantidadBalanceada= String.valueOf(pedidoWrapper.pedidoItemList[i].piezas_Conf__c);
        		}
        		if(Balanceo && mapaUnidadMedida.get(pedidoWrapper.pedidoItemList[i].Unidad__c) == 'PI' )
        		{
        			//elem1.TipoSurtido 	= 'CJ';
        			result.SALES_HEADER_IN.Estatus = 'C';
        			Decimal piezasXcaja = [select Piezas_por_caja__c from product2 where id =: pedidoWrapper.pedidoItemList[i].producto__c].Piezas_por_caja__c;
        			elem5.CantidadBalanceada= String.valueOf(piezasXcaja * pedidoWrapper.pedidoItemList[i].Cajas_Conf__c);
        			
        		}
        		else if(Balanceo){
        			elem5.CantidadBalanceada= String.valueOf(pedidoWrapper.pedidoItemList[i].Cajas_Conf__c);
        			
        		}
        		
        		elem5.FechaCarga 			= pedidoWrapper.pedido.FechaSurtidoProgramada__c.format('yyyyMMdd');
        		elem5.FechaSurtido 			= pedidoWrapper.pedido.FechaSurtidoProgramada__c.format('yyyyMMdd');
        		result.SALES_SCHEDULES_IN.SCHEDULES_Linea.add(elem5);
        	}
        	return result;
        }
        
        public String generateIdPedidoSF() {
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
        
        public String dateToString(Date dFecha, String format){
        	String sFecha= null;
        	if(dFecha != null){
          		DateTime fechaHora = datetime.newInstance(dFecha.year(), dFecha.month(), dFecha.day());
          		System.debug('Fecha original:' + dFecha + ', DateTime:' + fechaHora);
          		sFecha = fechaHora.format(format);
          		System.debug('Fecha:' + sFecha);
        	}
        	return sFecha;
    	}

        public PedidoInsertNSCWS.Pedido setPedidoWS(PedidoUtils.PedidoWrapper pedidoWrapper, PedidoUtils.AccountWrapper accountWrapper) {
            return setPedidoWS(pedidoWrapper,accountWrapper,true);
        }

        public PedidoInsertNSCWS.Pedido setPedidoWS(PedidoUtils.PedidoWrapper pedidoWrapper, PedidoUtils.AccountWrapper accountWrapper, Boolean limpiaBalanceo) {
            List<Monedas__c> monedas 	= Monedas__c.getAll().values();
    		List<Unidades__c> unidades 	= Unidades__c.getAll().values();
            Datetime now = System.now();
            String formaPago = pedidoWrapper.pedido.Forma_Pago__c.substring(0, pedidoWrapper.pedido.Forma_Pago__c.indexOf(' - '));
            PedidoInsertNSCWS.Pedido pedidoWS = new PedidoInsertNSCWS.Pedido();
            pedidoWS.nCanalConexion = pedidoWrapper.pedido.OficinaVentas__r != null ? Integer.valueOf(pedidoWrapper.pedido.OficinaVentas__r.Codigo__c) : accountWrapper.canal;

            pedidoWS.nCanalDistribucionVenta = Integer.valueOf(accountWrapper.canal);
            if(String.isNotBlank(pedidoWrapper.pedido.Numero_de_Pedido_NSC__c) && pedidoWrapper.pedido.Numero_de_Pedido_NSC__c.isNumeric()){
                    pedidoWS.nPedidoCliente = Integer.valueOf(pedidoWrapper.pedido.Numero_de_Pedido_NSC__c);
            }
            pedidoWS.Original_nPedidoCliente = pedidoWS.nPedidoCliente;
            pedidoWS.nSucursalCliente = Integer.valueOf(accountWrapper.sucursal);
            pedidoWS.nCliente = accountWrapper.cliente;
            pedidoWS.cOrganizacionVenta = accountWrapper.orgVentas;
            pedidoWS.nTipoSurtido = Integer.valueOf(pedidoWrapper.pedido.TipoSurtido__c.left(1));
            pedidoWS.dFecha = pedidoWrapper.pedido.Fecha_Registro__c;
            pedidoWS.dFechaSurtidoProgramada = pedidoWrapper.pedido.FechaSurtidoProgramada__c.date();
            pedidoWS.dHoraEntregaProgramadaInicio = pedidoWrapper.pedido.FechaSurtidoProgramada__c;
            pedidoWS.dHoraEntregaProgramadaFin = pedidoWrapper.pedido.FechaSurtidoProgramada__c;
            if(formaPago.isNumeric()) pedidoWS.nFormaPago = Integer.valueOf(formaPago);
            pedidoWS.nEjecutivo = 0;
            pedidoWS.cObservacion = pedidoWrapper.pedido.Observacion__c==null?'':pedidoWrapper.pedido.Observacion__c;
            pedidoWS.bPedidoAceptado = pedidoWrapper.pedido.PedidoAceptado__c;
            pedidoWS.bPedidoSurtido = false;
            pedidoWS.bRequiereAutorizacion = false;
            pedidoWS.bTipoAutorizacionRemota = pedidoWrapper.pedido.TipoAutorizacionRemota__c;
            pedidoWS.cMotivoAutorizacion = '0';
            pedidoWS.bPedidoAutorizado = false;
            pedidoWS.bPedidoRechazado = pedidoWrapper.pedido.PedidoRechazado__c;
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
            pedidoWS.bPedidoCanceladoPorElSistema = pedidoWrapper.pedido.PedidoCanceladoPorElSistema__c;
            pedidoWS.bPedidoTransmitido = false;
            if(pedidoWrapper.isCancelacion != true) pedidoWS.bActivo = true;
            pedidoWS.bAplicado = false;
            pedidoWS.bIntegrado = false;
            pedidoWS.cUsuario_Registro = String.isNotBlank(pedidoWrapper.pedido.CreatedBy.Username) ? pedidoWrapper.pedido.CreatedBy.Username.substring(0, pedidoWrapper.pedido.CreatedBy.Username.lastIndexOf('@')) : UserInfo.getUserName().substring(0, UserInfo.getUserName().lastIndexOf('@'));
            pedidoWS.dFecha_Registro = pedidoWrapper.pedido.CreatedDate != null ? pedidoWrapper.pedido.CreatedDate : now;
            pedidoWS.cMaquina_Registro = 'Host_SalesForce';
            pedidoWS.cUsuario_UltimaModificacion = UserInfo.getUserName().substring(0, UserInfo.getUserName().lastIndexOf('@'));
            pedidoWS.dFecha_UltimaModificacion = now;
            pedidoWS.cMaquina_UltimaModificacion = null;
            if(pedidoWrapper.isCancelacion == true) pedidoWS.cUsuario_Eliminacion = UserInfo.getUserName().substring(0, UserInfo.getUserName().lastIndexOf('@'));
            if(pedidoWrapper.isCancelacion == true) pedidoWS.dFecha_Eliminacion = now.date();
            if(pedidoWrapper.isCancelacion == true) pedidoWS.cMaquina_Eliminacion = 'Host_SalesForce';
            pedidoWS.bSolicitudAutorizacionRemotaEnviada = false;
            pedidoWS.nPedidoPadre = 0;
            pedidoWS.bFactura = pedidoWrapper.pedido.Factura__c;
            pedidoWS.cOrdenCompra = pedidoWrapper.pedido.Orden_de_Compra__c;
            pedidoWS.cDepartamentoOrdenCompra = pedidoWrapper.pedido.DepartamentoOrdenCompra__c;
            pedidoWS.bDisponibleLiberado = false;
            pedidoWS.nCanalRN = 0;
            pedidoWS.nOrdenRN = 0;
            pedidoWS.bEnviadoEBS = false;
            pedidoWS.bEnviadoCorporativo = false;
            pedidoWS.dFechaActualizacion = now;
            if(pedidoWrapper.pedido.Prospecto__r != null && String.isNotBlank(pedidoWrapper.pedido.Prospecto__r.Id_Prospecto__c)) pedidoWS.nProspecto = Integer.valueOf(pedidoWrapper.pedido.Prospecto__r.Id_Prospecto__c);
            pedidoWS.nAutorizaEspecial = 0;
            pedidoWS.dFechaEntrega = pedidoWrapper.pedido.Fecha_de_Entrega__c;
            if(pedidoWrapper.pedido.Costo_de_Flete__c != null) pedidoWS.nCostoFlete = pedidoWrapper.pedido.Costo_de_Flete__c;
            pedidoWS.cAutorizaEliminarPedido = null;
            pedidoWS.cAutorizaActualizarPedido = null;
            pedidoWS.bFacturaNoFiscal = pedidoWrapper.pedido.Factura_No_Fiscal__c;
            pedidoWS.nClienteSap = accountWrapper.cliente;
            pedidoWS.cSucursalSAP = accountWrapper.sucursal;
            pedidoWS.EsTicket = false;
            pedidoWS.IdSalesforce = pedidoWrapper.preId;
            pedidoWS.Detalle = new PedidoInsertNSCWS.ArrayOfPedidoDetalle();
            pedidoWS.Detalle.PedidoDetalle = new List<PedidoInsertNSCWS.PedidoDetalle>();
            for(Integer i=0; i<pedidoWrapper.pedidoItemList.size(); i++) {
                PedidoInsertNSCWS.PedidoDetalle pedidoDetalleWS = new PedidoInsertNSCWS.PedidoDetalle();
                //pedidoDetalleWS.nCanalDistribucion = pedidoWrapper.pedido.OficinaVentas__r != null ? Integer.valueOf(accountWrapper.ofiVentas) : accountWrapper.canal;
                if(String.isNotBlank(pedidoWrapper.pedido.Numero_de_Pedido_NSC__c) && pedidoWrapper.pedido.Numero_de_Pedido_NSC__c.isNumeric()) pedidoDetalleWS.nPedidoCliente = Integer.valueOf(pedidoWrapper.pedido.Numero_de_Pedido_NSC__c);
                pedidoDetalleWS.nRenglon = i+1;
                pedidoDetalleWS.nProducto = Integer.valueOf(pedidoWrapper.pedidoItemList[i].Producto__r.ProductCode);
                pedidoDetalleWS.nMarca = 0;
                if( unidades == null ) {
                	
                	pedidoDetalleWS.nUnidad = pedidoWrapper.pedidoItemList[i].Unidad__c == 'P' ? 1 : pedidoWrapper.pedidoItemList[i].Unidad__c == 'C' ? 3 : pedidoWrapper.pedidoItemList[i].Unidad__c == 'K' ? 4 : 5;
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
                pedidoDetalleWS.nCantidadPedidaUnidadMovimiento = pedidoWrapper.pedidoItemList[i].CantidadPedidaUnidadMovimiento__c;
                pedidoDetalleWS.nCantidadPedida = pedidoWrapper.pedidoItemList[i].Kilos__c;
                if(pedidoWrapper.pedidoItemList[i].Cajas__c != null){
                    pedidoDetalleWS.nPiezasPedidas = Integer.valueOf(pedidoWrapper.pedidoItemList[i].Cajas__c);
                }
                pedidoDetalleWS.nCantidadConfirmadaUnidadMovimiento = pedidoWrapper.pedidoItemList[i].CantidadConfirmadaUnidadMovimiento__c;
                pedidoDetalleWS.nCantidadConfirmada = pedidoWrapper.pedidoItemList[i].Kilos_Conf__c;
                
                System.debug('CAJAS--> '+ Integer.valueOf(pedidoWrapper.pedidoItemList[i].Cajas_Conf__c));
                if(pedidoWrapper.pedidoItemList[i].Cajas_Conf__c != null){
                    pedidoDetalleWS.nPiezasConfirmadas = Integer.valueOf(pedidoWrapper.pedidoItemList[i].Cajas_Conf__c);// Validar por que se envia Cajas en lugar de piezas
                }
                if(limpiaBalanceo){
                    pedidoDetalleWS.nCantidadBalanceadaUnidadMovimiento = 0;
                    pedidoDetalleWS.nCantidadBalanceada = 0;
                    pedidoDetalleWS.nPiezasBalanceadas = 0;
                }else{
                    pedidoDetalleWS.nCantidadBalanceadaUnidadMovimiento = pedidoWrapper.pedidoItemList[i].Cantidad_Balanceada_Unidad_de_Movimiento__c;
                    pedidoDetalleWS.nCantidadBalanceada = pedidoWrapper.pedidoItemList[i].Kilos_Balanceados__c;
                    pedidoDetalleWS.nPiezasBalanceadas = Integer.valueOf(pedidoWrapper.pedidoItemList[i].Cajas_Balanceadas__c);// Validar por que se envia Cajas en lugar de piezas
                }
                //Validacion para quitar nulos
                pedidoDetalleWS.nCantidadBalanceadaUnidadMovimiento = pedidoDetalleWS.nCantidadBalanceadaUnidadMovimiento==null?0:pedidoDetalleWS.nCantidadBalanceadaUnidadMovimiento;
                pedidoDetalleWS.nCantidadBalanceada = pedidoDetalleWS.nCantidadBalanceada==null?0:pedidoDetalleWS.nCantidadBalanceada;
                pedidoDetalleWS.nPiezasBalanceadas = pedidoDetalleWS.nPiezasBalanceadas==null?0:pedidoDetalleWS.nPiezasBalanceadas;

                pedidoDetalleWS.nCantidadSurtida = 0;
                pedidoDetalleWS.nPiezasSurtidas = 0;
                pedidoDetalleWS.nCantidadSurtidaEnUnidadBase = 0;
                pedidoDetalleWS.nPesoPromedio = pedidoWrapper.pedidoItemList[i].Unidad__c == 'L' ? pedidoWrapper.pedidoItemList[i].Producto__r.Peso_Promedio__c*PedidoUtils.CONVERSION_KILO_POUND : pedidoWrapper.pedidoItemList[i].Producto__r.Peso_Promedio__c;
                pedidoDetalleWS.nFactorConversionAUnidadBase = pedidoWrapper.pedidoItemList[i].Unidad__c == 'K' && precioListXProductCodeMap.get(pedidoWrapper.pedidoItemList[i].Producto__r.ProductCode)[0].pve_tipprec.substring(1) == 'L' ? PedidoUtils.CONVERSION_KILO_POUND : pedidoWrapper.pedidoItemList[i].Unidad__c == 'L' && precioListXProductCodeMap.get(pedidoWrapper.pedidoItemList[i].Producto__r.ProductCode)[0].pve_tipprec.substring(1) == 'K' ? (1/PedidoUtils.CONVERSION_KILO_POUND).setScale(4) : 1;
                pedidoDetalleWS.bPedidoEnUnidadDePeso = false;
                pedidoDetalleWS.bSurtido = false;
                pedidoDetalleWS.nTipoLista = 0;
                if(pedidoWrapper.pedidoItemList[i].PrecioListaPrecios__c != null) pedidoDetalleWS.Precio_nListaPrecios = Integer.valueOf(pedidoWrapper.pedidoItemList[i].PrecioListaPrecios__c);
                pedidoDetalleWS.Precio_nRenglon = 0;
                pedidoDetalleWS.Precio_nFolioOferta = 0;
                pedidoDetalleWS.nPrecioUnitarioOriginal = pedidoWrapper.pedidoItemList[i].PrecioUnitarioOriginal__c;
                pedidoDetalleWS.nPrecioUnitarioOtorgado = pedidoWrapper.pedidoItemList[i].PrecioUnitarioOtorgado__c;
                pedidoDetalleWS.nImporte = pedidoWrapper.pedidoItemList[i].Importe__c;
                if( monedas == null ) {
                	pedidoDetalleWS.nMoneda = pedidoWrapper.pedidoItemList[i].Moneda__c == 'P' ? 1 : 2;
                }
                else {
                    for( Monedas__c m: monedas ) {
                        if( m == null ) { continue; }
                        if( m.Name == pedidoWrapper.pedidoItemList[i].Moneda__c ) {
                         	pedidoDetalleWS.nMoneda = Integer.valueOf( m.ID_Moneda__c );
                        }
                    }
                }
                pedidoDetalleWS.nTipoCambio = pedidoWrapper.pedidoItemList[i].TipoCambio__c;
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
                pedidoDetalleWS.ProductoSAP = pedidoWrapper.pedidoItemList[i].Producto__r.ProductCode;

                pedidoWS.Detalle.PedidoDetalle.add(pedidoDetalleWS);
            }
            System.debug(JSON.serialize(pedidoWS));
            return pedidoWS;
        }
        
        public BalanceoSAPWS.Pedido setPedidoWSSAP(PedidoUtils.PedidoWrapper pedidoWrapper, PedidoUtils.AccountWrapper accountWrapper, Boolean limpiaBalanceo) {
            List<Monedas__c> monedas 	= Monedas__c.getAll().values();
    		List<Unidades__c> unidades 	= Unidades__c.getAll().values();
            Datetime now = System.now();
            String formaPago = pedidoWrapper.pedido.Forma_Pago__c.substring(0, pedidoWrapper.pedido.Forma_Pago__c.indexOf(' - '));
            BalanceoSAPWS.Pedido pedidoWS = new BalanceoSAPWS.Pedido();
            pedidoWS.nCanalConexion = pedidoWrapper.pedido.OficinaVentas__r != null ? Integer.valueOf(pedidoWrapper.pedido.OficinaVentas__r.Codigo__c) : accountWrapper.canal;

            pedidoWS.nCanalDistribucionVenta = Integer.valueOf(accountWrapper.canal);
            if(String.isNotBlank(pedidoWrapper.pedido.Numero_de_Pedido_NSC__c) && pedidoWrapper.pedido.Numero_de_Pedido_NSC__c.isNumeric()){
                    pedidoWS.nPedidoCliente = Integer.valueOf(pedidoWrapper.pedido.Numero_de_Pedido_NSC__c);
            }
            pedidoWS.Original_nPedidoCliente = pedidoWS.nPedidoCliente;
            pedidoWS.nSucursalCliente = Integer.valueOf(accountWrapper.sucursal);
            pedidoWS.nCliente = accountWrapper.cliente;
            pedidoWS.cOrganizacionVenta = accountWrapper.orgVentas;
            pedidoWS.nTipoSurtido = Integer.valueOf(pedidoWrapper.pedido.TipoSurtido__c.left(1));
            pedidoWS.dFecha = pedidoWrapper.pedido.Fecha_Registro__c;
            pedidoWS.dFechaSurtidoProgramada = pedidoWrapper.pedido.FechaSurtidoProgramada__c.date();
            pedidoWS.dHoraEntregaProgramadaInicio = pedidoWrapper.pedido.FechaSurtidoProgramada__c;
            pedidoWS.dHoraEntregaProgramadaFin = pedidoWrapper.pedido.FechaSurtidoProgramada__c;
            if(formaPago.isNumeric()) pedidoWS.nFormaPago = Integer.valueOf(formaPago);
            pedidoWS.nEjecutivo = 0;
            pedidoWS.cObservacion = pedidoWrapper.pedido.Observacion__c==null?'':pedidoWrapper.pedido.Observacion__c;
            pedidoWS.bPedidoAceptado = pedidoWrapper.pedido.PedidoAceptado__c;
            pedidoWS.bPedidoSurtido = false;
            pedidoWS.bRequiereAutorizacion = false;
            pedidoWS.bTipoAutorizacionRemota = pedidoWrapper.pedido.TipoAutorizacionRemota__c;
            pedidoWS.cMotivoAutorizacion = '0';
            pedidoWS.bPedidoAutorizado = false;
            pedidoWS.bPedidoRechazado = pedidoWrapper.pedido.PedidoRechazado__c;
            pedidoWS.nImporte = pedidoWrapper.importe;
            pedidoWS.cSupervisor = '';
            pedidoWS.cObservacionSupervisor = null;
            pedidoWS.nOrigenPedido = 0;
            pedidoWS.nEstatusPedido = 1;
            pedidoWS.nCausaCancelacion = null;
            pedidoWS.cMotivoCancelacion = null;
            pedidoWS.bCapturadoDespuesDeCierre = false;
            pedidoWS.cSupervisorEmbarque = '';
           // pedidoWS.cObservacionIncumplimientoCampania = '';
            pedidoWS.bPedidoCanceladoPorElSistema = pedidoWrapper.pedido.PedidoCanceladoPorElSistema__c;
            pedidoWS.bPedidoTransmitido = false;
            if(pedidoWrapper.isCancelacion != true) pedidoWS.bActivo = true;
            pedidoWS.bAplicado = false;
            pedidoWS.bIntegrado = false;
            pedidoWS.cUsuario_Registro = String.isNotBlank(pedidoWrapper.pedido.CreatedBy.Username) ? pedidoWrapper.pedido.CreatedBy.Username.substring(0, pedidoWrapper.pedido.CreatedBy.Username.lastIndexOf('@')) : UserInfo.getUserName().substring(0, UserInfo.getUserName().lastIndexOf('@'));
            pedidoWS.dFecha_Registro = pedidoWrapper.pedido.CreatedDate != null ? pedidoWrapper.pedido.CreatedDate : now;
            pedidoWS.cMaquina_Registro = 'Host_SalesForce';
            pedidoWS.cUsuario_UltimaModificacion = UserInfo.getUserName().substring(0, UserInfo.getUserName().lastIndexOf('@'));
            pedidoWS.dFecha_UltimaModificacion = now;
            pedidoWS.cMaquina_UltimaModificacion = null;
            if(pedidoWrapper.isCancelacion == true) pedidoWS.cUsuario_Eliminacion = UserInfo.getUserName().substring(0, UserInfo.getUserName().lastIndexOf('@'));
            if(pedidoWrapper.isCancelacion == true) pedidoWS.dFecha_Eliminacion = now.date();
            if(pedidoWrapper.isCancelacion == true) pedidoWS.cMaquina_Eliminacion = 'Host_SalesForce';
            pedidoWS.bSolicitudAutorizacionRemotaEnviada = false;
            pedidoWS.nPedidoPadre = 0;
            pedidoWS.bFactura = pedidoWrapper.pedido.Factura__c;
            pedidoWS.cOrdenCompra = pedidoWrapper.pedido.Orden_de_Compra__c;
            pedidoWS.cDepartamentoOrdenCompra = pedidoWrapper.pedido.DepartamentoOrdenCompra__c;
            pedidoWS.bDisponibleLiberado = false;
            pedidoWS.nCanalRN = 0;
            pedidoWS.nOrdenRN = 0;
            pedidoWS.bEnviadoEBS = false;
            pedidoWS.bEnviadoCorporativo = false;
            pedidoWS.dFechaActualizacion = now;
            if(pedidoWrapper.pedido.Prospecto__r != null && String.isNotBlank(pedidoWrapper.pedido.Prospecto__r.Id_Prospecto__c)) pedidoWS.nProspecto = Integer.valueOf(pedidoWrapper.pedido.Prospecto__r.Id_Prospecto__c);
            pedidoWS.nAutorizaEspecial = 0;
            pedidoWS.dFechaEntrega = pedidoWrapper.pedido.Fecha_de_Entrega__c;
            if(pedidoWrapper.pedido.Costo_de_Flete__c != null) pedidoWS.nCostoFlete = pedidoWrapper.pedido.Costo_de_Flete__c;
            pedidoWS.cAutorizaEliminarPedido = null;
            pedidoWS.cAutorizaActualizarPedido = null;
            pedidoWS.bFacturaNoFiscal = pedidoWrapper.pedido.Factura_No_Fiscal__c;
            pedidoWS.nClienteSap = accountWrapper.cliente;
            pedidoWS.cSucursalSAP = accountWrapper.sucursal;
            pedidoWS.EsTicket = false;
            
            pedidoWS.IdSalesforce = pedidoWrapper.preId;
            pedidoWS.Detalle = new BalanceoSAPWS.ArrayOfPedidoDetalle();
            pedidoWS.Detalle.PedidoDetalle = new List<BalanceoSAPWS.PedidoDetalle>();
            for(Integer i=0; i<pedidoWrapper.pedidoItemList.size(); i++) {
                BalanceoSAPWS.PedidoDetalle pedidoDetalleWS = new BalanceoSAPWS.PedidoDetalle();
                //pedidoDetalleWS.nCanalDistribucion = pedidoWrapper.pedido.OficinaVentas__r != null ? Integer.valueOf(accountWrapper.ofiVentas) : accountWrapper.canal;
                if(String.isNotBlank(pedidoWrapper.pedido.Numero_de_Pedido_NSC__c) && pedidoWrapper.pedido.Numero_de_Pedido_NSC__c.isNumeric()) pedidoDetalleWS.nPedidoCliente = Integer.valueOf(pedidoWrapper.pedido.Numero_de_Pedido_NSC__c);
                pedidoDetalleWS.nRenglon = i+1;
                pedidoDetalleWS.nProducto = Integer.valueOf(pedidoWrapper.pedidoItemList[i].Producto__r.ProductCode);
                pedidoDetalleWS.nMarca = 0;
               
                if( unidades == null ) {
                	pedidoDetalleWS.nUnidad = pedidoWrapper.pedidoItemList[i].Unidad__c == 'P' ? 1 : pedidoWrapper.pedidoItemList[i].Unidad__c == 'C' ? 3 : pedidoWrapper.pedidoItemList[i].Unidad__c == 'K' ? 4 : 5;
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
                pedidoDetalleWS.nCantidadPedidaUnidadMovimiento = pedidoWrapper.pedidoItemList[i].CantidadPedidaUnidadMovimiento__c;
                pedidoDetalleWS.nCantidadPedida = pedidoWrapper.pedidoItemList[i].Kilos__c;
                if(pedidoWrapper.pedidoItemList[i].Cajas__c != null){
                    pedidoDetalleWS.nPiezasPedidas = Integer.valueOf(pedidoWrapper.pedidoItemList[i].Cajas__c);
                }
                pedidoDetalleWS.nCantidadConfirmadaUnidadMovimiento = pedidoWrapper.pedidoItemList[i].CantidadConfirmadaUnidadMovimiento__c;
                pedidoDetalleWS.nCantidadConfirmada = pedidoWrapper.pedidoItemList[i].Kilos_Conf__c;
                if(pedidoWrapper.pedidoItemList[i].Cajas_Conf__c != null){
                    pedidoDetalleWS.nPiezasConfirmadas = Integer.valueOf(pedidoWrapper.pedidoItemList[i].Cajas_Conf__c);// Validar por que se envia Cajas en lugar de piezas
                }
                if(limpiaBalanceo){
                    pedidoDetalleWS.nCantidadBalanceadaUnidadMovimiento = 0;
                    pedidoDetalleWS.nCantidadBalanceada = 0;
                    pedidoDetalleWS.nPiezasBalanceadas = 0;
                }else{
                    pedidoDetalleWS.nCantidadBalanceadaUnidadMovimiento = pedidoWrapper.pedidoItemList[i].Cantidad_Balanceada_Unidad_de_Movimiento__c;
                    pedidoDetalleWS.nCantidadBalanceada = pedidoWrapper.pedidoItemList[i].Kilos_Balanceados__c;
                    pedidoDetalleWS.nPiezasBalanceadas = Integer.valueOf(pedidoWrapper.pedidoItemList[i].Cajas_Balanceadas__c);// Validar por que se envia Cajas en lugar de piezas
                }
                //Validacion para quitar nulos
                pedidoDetalleWS.nCantidadBalanceadaUnidadMovimiento = pedidoDetalleWS.nCantidadBalanceadaUnidadMovimiento==null?0:pedidoDetalleWS.nCantidadBalanceadaUnidadMovimiento;
                pedidoDetalleWS.nCantidadBalanceada = pedidoDetalleWS.nCantidadBalanceada==null?0:pedidoDetalleWS.nCantidadBalanceada;
                pedidoDetalleWS.nPiezasBalanceadas = pedidoDetalleWS.nPiezasBalanceadas==null?0:pedidoDetalleWS.nPiezasBalanceadas;

                pedidoDetalleWS.nCantidadSurtida = 0;
                pedidoDetalleWS.nPiezasSurtidas = 0;
                pedidoDetalleWS.nCantidadSurtidaEnUnidadBase = 0;
                pedidoDetalleWS.nPesoPromedio = pedidoWrapper.pedidoItemList[i].Unidad__c == 'L' ? pedidoWrapper.pedidoItemList[i].Producto__r.Peso_Promedio__c*PedidoUtils.CONVERSION_KILO_POUND : pedidoWrapper.pedidoItemList[i].Producto__r.Peso_Promedio__c;
                pedidoDetalleWS.nFactorConversionAUnidadBase = pedidoWrapper.pedidoItemList[i].Unidad__c == 'K' && precioListXProductCodeMap.get(pedidoWrapper.pedidoItemList[i].Producto__r.ProductCode)[0].pve_tipprec.substring(1) == 'L' ? PedidoUtils.CONVERSION_KILO_POUND : pedidoWrapper.pedidoItemList[i].Unidad__c == 'L' && precioListXProductCodeMap.get(pedidoWrapper.pedidoItemList[i].Producto__r.ProductCode)[0].pve_tipprec.substring(1) == 'K' ? (1/PedidoUtils.CONVERSION_KILO_POUND).setScale(4) : 1;
                pedidoDetalleWS.bPedidoEnUnidadDePeso = false;
                pedidoDetalleWS.bSurtido = false;
                pedidoDetalleWS.nTipoLista = 0;
                if(pedidoWrapper.pedidoItemList[i].PrecioListaPrecios__c != null) pedidoDetalleWS.Precio_nListaPrecios = Integer.valueOf(pedidoWrapper.pedidoItemList[i].PrecioListaPrecios__c);
                pedidoDetalleWS.Precio_nRenglon = 0;
                pedidoDetalleWS.Precio_nFolioOferta = 0;
                pedidoDetalleWS.nPrecioUnitarioOriginal = pedidoWrapper.pedidoItemList[i].PrecioUnitarioOriginal__c;
                pedidoDetalleWS.nPrecioUnitarioOtorgado = pedidoWrapper.pedidoItemList[i].PrecioUnitarioOtorgado__c;
                pedidoDetalleWS.nImporte = pedidoWrapper.pedidoItemList[i].Importe__c;
                if( monedas == null ) {
                	pedidoDetalleWS.nMoneda = pedidoWrapper.pedidoItemList[i].Moneda__c == 'P' ? 1 : 2;
                }
                else {
                    for( Monedas__c m: monedas ) {
                        if( m == null ) { continue; }
                        if( m.Name == pedidoWrapper.pedidoItemList[i].Moneda__c ) {
                         	pedidoDetalleWS.nMoneda = Integer.valueOf( m.ID_Moneda__c );
                        }
                    }
                }
                pedidoDetalleWS.nTipoCambio = pedidoWrapper.pedidoItemList[i].TipoCambio__c;
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
                pedidoDetalleWS.ProductoSAP = pedidoWrapper.pedidoItemList[i].Producto__r.ProductCode;

                pedidoWS.Detalle.PedidoDetalle.add(pedidoDetalleWS);
            }
            System.debug(JSON.serialize(pedidoWS));
            return pedidoWS;
        }

        public PedidoInsertNSCWS.PedidoRespuesta syncPedido(PedidoUtils.PedidoWrapper pedidoWrapper, PedidoUtils.AccountWrapper accountWrapper) {
        	 if(pedidoWrapper.pedido.Prospecto__c != null && pedidoWrapper.pedido.Prospecto__r.Id_prospecto_sap__c == null)
              { 
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'El prospecto no cuenta con numero de destinatario sap');
            	  ApexPages.addMessage(myMsg);
                  return null;
              }
            system.debug('PEDIDO WRAPER: '+pedidoWrapper);
            system.debug('ACCOUNT WRAPER: '+accountWrapper);
            PedidoInsertNSCWS.Pedido pedidoWS = setPedidoWS(pedidoWrapper,accountWrapper);
            PedidoInsertNSCWS.RespuestaOfPedidoRespuesta response = sendPedido(pedidoWS);
            if(response != null) {
                return response.Datos;
            }
            return null;
        }
        
        public WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido syncPedidoSAP(PedidoUtils.PedidoWrapper pedidoWrapper, PedidoUtils.AccountWrapper accountWrapper,Boolean balanceo) {
         
           if(pedidoWrapper.pedido.Prospecto__c != null && pedidoWrapper.pedido.Prospecto__r.Id_prospecto_sap__c == null)
              { 
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'El prospecto no cuenta con numero de destinatario sap');
            	  ApexPages.addMessage(myMsg);
                  return null;
              }
            ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista pedidoWS = setPedidoSAPWS(pedidoWrapper,accountWrapper,balanceo);
            WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido response = sendPedido(pedidoWS);
            if(response != null) {
                return response;
            }
            return null;
        }
		public WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido syncPedidoSAP(WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_ReqLista pedidosSAPWS) {
           
            WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido response = sendPedido(pedidosSAPWS);
           
            if(response != null) {
                return response;
            }
            return null;
        }
        
        public BalanceoNSCWS.RespuestaOfString syncPedido(BalanceoNSCWS.ArrayOfPedido pedidosWS, Integer canal) {
            BalanceoNSCWS.RespuestaOfString response = sendPedidos(pedidosWS,canal);
            if(response != null) {
                return response;
            }
            return null;
        }
        
   /*     public BalanceoSAPWS.RespuestaOfString syncPedido(BalanceoSAPWS.ArrayOfPedido pedidosWS, Integer canal) {
            BalanceoSAPWS.RespuestaOfString response = sendPedidos(pedidosWS,canal);
            if(response != null) {
                return response;
            }
            return null;
        }*/

        public PedidoItem__c calculaEnBaseACajasConf(PedidoItem__c pi){
            if(inventarioXProductCodeMap==null){
               inventarioXProductCodeMap = new Map<String, ProductoInventarioQueryNSCWS.Inventario>();
            }
            ProductoInventarioQueryNSCWS.Inventario inv = inventarioXProductCodeMap.get(pi.Producto__r.ProductCode);
            if(inv==null){
                throw new CustomException(pi.Producto__r.ProductCode + ': No se encontro el producto en el inventario');
            }
            inv.Contenido = inv.Contenido == null ? 0 : inv.Contenido;
            inv.EsPesoEstandar = inv.EsPesoEstandar == null ? true : inv.EsPesoEstandar;

            if(inv.Contenido > 0 && inv.EsPesoEstandar) {
                pi.Piezas_Conf__c = pi.Cajas_Conf__c * inv.Contenido;
            }
            pi.Kilos_Conf__c = pi.Cajas_Conf__c * pi.Producto__r.Peso_Promedio__c;
            pi.CantidadConfirmadaUnidadMovimiento__c = pi.Unidad__c == 'L' ? pi.Kilos_Conf__c * PedidoUtils.CONVERSION_KILO_POUND : pi.Kilos_Conf__c;

            return pi;
        }
        

        public PedidoItem__c calculaImporte(PedidoItem__c pedidoItemValues, Boolean isPreset) {
            String property = '';
            ProductoInventarioQueryNSCWS.Inventario inv = inventarioXProductCodeMap.get(pedidoItemValues.Producto__r.ProductCode);
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
                pedidoItemValues.Importe__c = pedidoItemValues.Cajas_Conf__c * pedidoItemValues.PrecioUnitarioOtorgado__c;
            } else if(pedidoItemValues.Unidad__c == 'P') {
                pedidoItemValues.Importe__c = pedidoItemValues.Piezas_Conf__c * pedidoItemValues.PrecioUnitarioOtorgado__c;
            } else if(!(inv.TipoManejoInventario == 1 || (inv.Contenido > 0 && inv.EsPesoEstandar))) {
                pedidoItemValues.Importe__c = pedidoItemValues.Kilos_Conf__c * pedidoItemValues.PrecioUnitarioOtorgado__c;
            } else {
                pedidoItemValues.Importe__c = pedidoItemValues.Producto__r.Peso_Promedio__c * pedidoItemValues.Cajas_Conf__c * pedidoItemValues.PrecioUnitarioOtorgado__c;
            }
            pedidoItemValues.Importe__c = pedidoItemValues.Importe__c.setScale(2);
            return pedidoItemValues;
        }

        public PedidoItem__c asignaPrecioEnBaseARango(PedidoItem__c pedidoItemValues, String property) {
            List<ListaPreciosQueryNSCWS.Precios> lprecios = precioListXProductCodeMap.get(pedidoItemValues.Producto__r.ProductCode);
            if(lprecios==null || lprecios.size()==0){
                throw new PedidoUtils.CustomException(PedidoUtils.LISTAPRECIOS_WEB_SERVICE_NO_DATA_ERROR + 'Producto '+ pedidoItemValues.Producto__r.ProductCode);
            }
            for(ListaPreciosQueryNSCWS.Precios precio : lPrecios){
                if(precio.pve_volini <= (Double)pedidoItemValues.get(property)) {
                    pedidoItemValues.PrecioListaPrecios__c = precio.pve_folgral;
                    Decimal precioUnitarioOriginalPesos = pedidoItemValues.PrecioUnitarioOtorgado__c = precio.pve_tipprec.substring(0, 1) == 'D' ? precio.precio * pedidoParameters.TipoCambioDolarPeso__c : precio.precio;
                    pedidoItemValues.PrecioUnitarioOriginal__c = pedidoItemValues.PrecioUnitarioOtorgado__c = pedidoItemValues.Moneda__c == 'D' ? precioUnitarioOriginalPesos/pedidoParameters.TipoCambioDolarPeso__c : precioUnitarioOriginalPesos;
                } else {
                    break;
                }
            }
            return pedidoItemValues;
        }

        private CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierre retrieveCierrePlaza(Integer cliente, String sucursal, Integer canal, Integer canalDestino) {
            CierrePlazaPedidoQueryNSCWS.CierrePedidosSoap request = new CierrePlazaPedidoQueryNSCWS.CierrePedidosSoap();
            request.timeout_x = PedidoUtils.WEB_SERVICE_TIMEOUT;
            for(Integer i=1; i<=MAX_CALLOUT_RETRIES; i++) {
                try {
                    return validateCierrePlazaResponse(request.ValidaCierrePedidos(cliente, sucursal, canal, canalDestino));
                } catch(Exception e) {
                    if(i == PedidoUtils.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtils.CIERREPLAZA_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }

        private ProductoInventarioQueryNSCWS.RespuestaOfListOfInventario retrieveInventario(Integer cliente, String sucursal, Integer tipoSurtido, Integer canal, String ordenCompra) {
            ProductoInventarioQueryNSCWS.DisponibilidadInventarioSoap request = new ProductoInventarioQueryNSCWS.DisponibilidadInventarioSoap();
            request.timeout_x = PedidoUtils.WEB_SERVICE_TIMEOUT;
            for(Integer i=1; i<=PedidoUtils.MAX_CALLOUT_RETRIES; i++) {
                try {
                    return validateInventarioResponse(request.RegresaDisponibilidad(cliente, sucursal, tipoSurtido, canal, ordenCompra));
                } catch(Exception e) {
                    if(i == PedidoUtils.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtils.INVENTARIO_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }

        private ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios retrieveListaPrecios(String cliente, String gpoVendedores, String ofiVentas, String orgVentas, String canal, String destinatario, String cluster, String cadena, String fecDoc) {
            ListaPreciosQueryNSCWS.ListaPreciosSoap request = new ListaPreciosQueryNSCWS.ListaPreciosSoap();
            request.timeout_x = PedidoUtils.WEB_SERVICE_TIMEOUT;
            for(Integer i=1; i<=PedidoUtils.MAX_CALLOUT_RETRIES; i++) {
                try {
                    return validateListaPreciosResponse(request.RegresaListaPrecios(cliente, gpoVendedores, ofiVentas, orgVentas, canal, destinatario, cluster, cadena, fecDoc));
                } catch(Exception e) {
                    if(i == PedidoUtils.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtils.LISTAPRECIOS_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }

        private ListaPreciosQueryNSCWS.RespuestaOfListOfPrecioClienteSF retrieveListaPreciosMasivo(ListaPreciosQueryNSCWS.ArrayOfPreciosXCliente clientes) {
            ListaPreciosQueryNSCWS.ListaPreciosSoap request = new ListaPreciosQueryNSCWS.ListaPreciosSoap();
            request.timeout_x = PedidoUtils.WEB_SERVICE_TIMEOUT;
            for(Integer i=1; i<=PedidoUtils.MAX_CALLOUT_RETRIES; i++) {
                try {
                	system.debug('clientes ----> '+clientes);
                    return validateListaPreciosMasivoResponse(request.RegresaListaPreciosMasivo(clientes));
                } catch(Exception e) {
                    if(i == PedidoUtils.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtils.LISTAPRECIOS_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }

        public Map<Integer,BalanceoNSCWS.BalanceoProductos> retrieveTipoManejoInventario(Set<Integer> productos, Integer canal) {
            BalanceoNSCWS.BalanceoSoap request = new BalanceoNSCWS.BalanceoSoap();
            request.timeout_x = PedidoUtils.WEB_SERVICE_TIMEOUT;

            BalanceoNSCWS.ArrayOfInt producto = new BalanceoNSCWS.ArrayOfInt();
            producto.int_x = new Integer[]{};
            for(Integer p : productos){
                producto.int_x.add(p);
            }

            Map<Integer,BalanceoNSCWS.BalanceoProductos> responseData;
            for(Integer i=1; i<=PedidoUtils.MAX_CALLOUT_RETRIES; i++) {
                try {
                    responseData = new Map<Integer,BalanceoNSCWS.BalanceoProductos>();
                    BalanceoNSCWS.RespuestaOfListOfBalanceoProductos response = validateRespuestaInventario(request.RegresaInventarioPorProducto(producto, canal));
                    for(BalanceoNSCWS.BalanceoProductos balanceoProducto:response.Datos.BalanceoProductos){
                        responseData.put(balanceoProducto.Producto, balanceoProducto);
                    }
                    return responseData;
                } catch(Exception e) {
                    System.debug(e.getStackTraceString());
                    if(i == PedidoUtils.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtils.BALANCEO_WEB_SERVICE_ERROR_INVENTARIO+e.getMessage()));
                    }
                }
            }
            return null;
        }
        
        public Map<Integer,InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element> retrieveTipoManejoInventarioSAP(Set<Integer> productos, Integer canal) {
            BalanceoSAPWS.BalanceoSoap request = new BalanceoSAPWS.BalanceoSoap();
            request.timeout_x = PedidoUtils.WEB_SERVICE_TIMEOUT;
			
			system.debug('productos' + productos);
            InventarioBalanceoPedidos_SF_to_ECC.DT_SE_InventarioBalanceoPedidos_Req Listaproducto = new InventarioBalanceoPedidos_SF_to_ECC.DT_SE_InventarioBalanceoPedidos_Req();
           	Listaproducto.Canal = canal;
           	Listaproducto.Productos = new InventarioBalanceoPedidos_SF_to_ECC.ArrayOfInteger();
          	InventarioBalanceoPedidos_SF_to_ECC.ArrayOfInteger Producto = null;
          	Producto = new InventarioBalanceoPedidos_SF_to_ECC.ArrayOfInteger();
     		Producto.producto =  new list<Integer>();
            
            for(Integer p : productos){
     			Producto.producto.add(p);
            }
			Listaproducto.Productos = Producto;
            Map<Integer,InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element> responseData;
           for(Integer i=1; i<=PedidoUtils.MAX_CALLOUT_RETRIES; i++) {
                try {
                    	responseData = new Map<Integer,InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element>();
                        InventarioBalanceoPedidos_SF_to_ECC.DT_SE_InventarioBalanceoPedidos_Resp response = validateRespuestaInventarioSAP(request.ObtenerInventarioBalanceoPedidosSAP(Listaproducto));
                  		for(InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element balanceoProducto : response.Datos.BalanceoProductos){
                       		 responseData.put(Integer.ValueOf(balanceoProducto.Producto), balanceoProducto);
                    	}
                    return responseData;
                } catch(Exception e) {
                    System.debug(e.getStackTraceString());
                    if(i == PedidoUtils.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtils.BALANCEO_WEB_SERVICE_ERROR_INVENTARIO+e.getMessage()));
                    }
                }
            }
            return null;
        }
        

        public CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierreMasivo retrieveCierrePlaza(Set<Integer> canales,Integer canalPadre) {
            CierrePlazaPedidoQueryNSCWS.CierrePedidosSoap request = new CierrePlazaPedidoQueryNSCWS.CierrePedidosSoap();
            request.timeout_x = PedidoUtils.WEB_SERVICE_TIMEOUT;

            CierrePlazaPedidoQueryNSCWS.ArrayOfInt ArrayCanales = new CierrePlazaPedidoQueryNSCWS.ArrayOfInt();
            ArrayCanales.int_x = new Integer[]{};
            for(Integer canal: canales){
                ArrayCanales.int_x.add(canal);
            }
            for(Integer i=1; i<=PedidoUtils.MAX_CALLOUT_RETRIES; i++) {
                try {
                    return validateCierrePlazaMasivoResponse(request.ValidaCierrePedidosMasivoPorCliente(ArrayCanales, canalPadre));
                } catch(Exception e) {
                    System.debug(e.getStackTraceString());
                    if(i == PedidoUtils.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtils.CIERREPLAZA_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }

        private PedidoInsertNSCWS.RespuestaOfPedidoRespuesta sendPedido(PedidoInsertNSCWS.Pedido pedidoWS) {
            PedidoInsertNSCWS.PedidosSoap request = new PedidoInsertNSCWS.PedidosSoap();
            request.timeout_x = 50000;
            for(Integer i=1; i<=PedidoUtils.MAX_CALLOUT_RETRIES; i++) {
                try {
                    return validatePedidoResponse(request.RegistrarPedido(pedidoWS));
                } catch(Exception e) {
                    if(i == PedidoUtils.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtils.PEDIDO_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }
        
        private WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido sendPedido(ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista pedidoWS) {
           
           system.debug('WsABCPeidosSFSAP------- > Entro');
           	WsABCPeidosSFSAP.ABCPedidosSF_SAPSoap request = new WsABCPeidosSFSAP.ABCPedidosSF_SAPSoap();
           	WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_ReqLista pedidoWSArray = new WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_ReqLista();
           	pedidoWSArray.DT_SE_ABCPedidos_ReqLista = new list<ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista>{pedidoWS};
           	
            request.timeout_x = 50000;
            for(Integer i=1; i<=PedidoUtils.MAX_CALLOUT_RETRIES; i++) {
                try {
                    return request.EnviarInformacionASap(pedidoWSArray);
                } catch(Exception e) {
                    if(i == PedidoUtils.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtils.PEDIDO_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        } 
		private WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido sendPedido(WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_ReqLista pedidoWSArray) {
           	WsABCPeidosSFSAP.ABCPedidosSF_SAPSoap request = new WsABCPeidosSFSAP.ABCPedidosSF_SAPSoap();
           	//WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_ReqLista pedidoWSArray = new WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_ReqLista();
           	//pedidoWSArray.DT_SE_ABCPedidos_ReqLista = new list<ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista>{pedidoWS};
           	
            request.timeout_x = 50000;
            for(Integer i=1; i<=PedidoUtils.MAX_CALLOUT_RETRIES; i++) {
                try {
                    return validatePedidoResponse(request.EnviarInformacionASap(pedidoWSArray));
                } catch(Exception e) {
                    if(i == PedidoUtils.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtils.PEDIDO_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }
        private BalanceoNSCWS.RespuestaOfString sendPedidos(BalanceoNSCWS.ArrayOfPedido pedidosWS, Integer canal) {
            BalanceoNSCWS.BalanceoSoap request = new BalanceoNSCWS.BalanceoSoap();
            request.timeout_x = 50000;
            for(Integer i=1; i<=PedidoUtils.MAX_CALLOUT_RETRIES; i++) {
                try {
                    return validatePedidoResponse(request.GuardarPedidos(pedidosWS, canal));
                } catch(Exception e) {
                    if(i == PedidoUtils.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtils.PEDIDO_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }
        
      /*  private BalanceoSAPWS.RespuestaOfString sendPedidos(BalanceoSAPWS.ArrayOfPedido pedidosWS, Integer canal) {
            BalanceoSAPWS.BalanceoSoap request = new BalanceoSAPWS.BalanceoSoap();
            request.timeout_x = 50000;
            for(Integer i=1; i<=PedidoUtils.MAX_CALLOUT_RETRIES; i++) {
                try {
                    return validatePedidoResponse(request.GuardarPedidos(pedidosWS, canal));
                } catch(Exception e) {
                    if(i == PedidoUtils.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtils.PEDIDO_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }*/

        private CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierre validateCierrePlazaResponse(CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierre response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtils.CustomException(PedidoUtils.CIERREPLAZA_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error')) {
                throw new PedidoUtils.CustomException(response.Mensaje);
            } else if(response.Datos == null || response.Datos.Cierre == null || response.Datos.Cierre.isEmpty() || response.Datos.Cierre[0].cerrado == null) {
                throw new PedidoUtils.CustomException(PedidoUtils.CIERREPLAZA_WEB_SERVICE_NO_DATA_ERROR);
            }
            return response;
        }

        private CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierreMasivo validateCierrePlazaMasivoResponse(CierrePlazaPedidoQueryNSCWS.RespuestaOfListOfCierreMasivo response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtils.CustomException(PedidoUtils.CIERREPLAZA_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error')) {
                throw new PedidoUtils.CustomException(response.Mensaje);
            } else if(response.Datos == null || response.Datos.CierreMasivo == null || response.Datos.CierreMasivo.isEmpty()) {
                throw new PedidoUtils.CustomException(PedidoUtils.CIERREPLAZA_WEB_SERVICE_NO_DATA_ERROR);
            }
            return response;
        }

        private ProductoInventarioQueryNSCWS.RespuestaOfListOfInventario validateInventarioResponse(ProductoInventarioQueryNSCWS.RespuestaOfListOfInventario response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtils.CustomException(PedidoUtils.INVENTARIO_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error')) {
                throw new PedidoUtils.CustomException(response.Mensaje);
            } else if(response.Datos == null || response.Datos.Inventario == null || response.Datos.Inventario.isEmpty()) {
                throw new PedidoUtils.CustomException(PedidoUtils.INVENTARIO_WEB_SERVICE_NO_DATA_ERROR);
            }
            return response;
        }

        private ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios validateListaPreciosResponse(ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtils.CustomException(PedidoUtils.LISTAPRECIOS_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error')) {
                throw new PedidoUtils.CustomException(response.Mensaje);
            } else if(response.Datos == null || response.Datos.Precios == null || response.Datos.Precios.isEmpty()) {
                throw new PedidoUtils.CustomException(PedidoUtils.LISTAPRECIOS_WEB_SERVICE_NO_DATA_ERROR);
            }
            system.debug('response.tipo '+response.Tipo);
             system.debug('response.Datos '+response.Datos);
            return response;
        }

        private ListaPreciosQueryNSCWS.RespuestaOfListOfPrecioClienteSF validateListaPreciosMasivoResponse(ListaPreciosQueryNSCWS.RespuestaOfListOfPrecioClienteSF response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtils.CustomException(PedidoUtils.LISTAPRECIOS_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error')) {
                throw new PedidoUtils.CustomException(response.Mensaje);
            } else if(response.Datos == null || response.Datos.PrecioClienteSF == null || response.Datos.PrecioClienteSF.isEmpty()) {
                throw new PedidoUtils.CustomException(PedidoUtils.LISTAPRECIOS_WEB_SERVICE_NO_DATA_ERROR);
            }
            return response;
        }

        private Map<String,ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios> parseMapListaPreciosMasivo(ListaPreciosQueryNSCWS.RespuestaOfListOfPrecioClienteSF rolopc){
            Map<String,ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios> resp = new Map<String,ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios>();
            
            if(rolopc!=null && rolopc.Datos!=null && rolopc.Datos.PrecioClienteSF!=null && rolopc.Datos.PrecioClienteSF.size()>0){
            
                for(ListaPreciosQueryNSCWS.PrecioClienteSF cliente : rolopc.Datos.PrecioClienteSF){
                    
                    if(cliente!=null && cliente.numerocliente!=null && cliente.numerocliente!='' && cliente.precios!=null
                        && cliente.precios.PreciosSF!=null && cliente.precios.PreciosSF.size()>0){
                        ListaPreciosQueryNSCWS.ArrayOfPrecios datos = new ListaPreciosQueryNSCWS.ArrayOfPrecios();
                        datos.Precios = new List<ListaPreciosQueryNSCWS.Precios>();
                        datos.Precios.addAll(cliente.precios.PreciosSF);

                        ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios precios = new ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios();
                        precios.Tipo = rolopc.Tipo;
                        precios.Mensaje = rolopc.Mensaje;
                        precios.Datos = datos;
                        resp.put(String.valueOf(Integer.valueOf(cliente.numerocliente)),precios);
                    }else{
                        throw new PedidoUtils.CustomException(PedidoUtils.LISTAPRECIOS_WEB_SERVICE_NO_DATA_ERROR);
                    }
                }
            }else{
                throw new PedidoUtils.CustomException(PedidoUtils.LISTAPRECIOS_WEB_SERVICE_NO_DATA_ERROR);
            }

            return resp;
        }
        
        private WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido validatePedidoResponse(WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido response) {
            
            system.debug('response Servicio SAP: '+response);
            if(response == null || response.DT_SE_ABCPedidos_RespPedido == null || response.DT_SE_ABCPedidos_RespPedido.isEmpty())
            	throw new PedidoUtils.CustomException(PedidoUtils.PEDIDO_WEB_SERVICE_NO_DATA_ERROR);
            for(ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido detRESP: response.DT_SE_ABCPedidos_RespPedido){
	            if(detRESP == null || String.isBlank(detRESP.TipoMensaje)) {
	                throw new PedidoUtils.CustomException(PedidoUtils.PEDIDO_WEB_SERVICE_NO_DATA_ERROR);
	            } else if(detRESP.TipoMensaje.toLowerCase().contains('error') || detRESP.TipoMensaje.toLowerCase().contains('reintento')) {
	                throw new PedidoUtils.CustomException(detRESP.Mensaje);
	            } else if(detRESP.FolioPedidoSAP == null) {
	                throw new PedidoUtils.CustomException(PedidoUtils.PEDIDO_WEB_SERVICE_NO_DATA_ERROR);
	            }
            }
            return response;
        }

        private PedidoInsertNSCWS.RespuestaOfPedidoRespuesta validatePedidoResponse(PedidoInsertNSCWS.RespuestaOfPedidoRespuesta response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtils.CustomException(PedidoUtils.PEDIDO_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error') || response.Tipo.toLowerCase().contains('reintento')) {
                throw new PedidoUtils.CustomException(response.Mensaje);
            } else if(response.Datos == null || response.Datos.Canal == null || response.Datos.NumeroPedido == null) {
                throw new PedidoUtils.CustomException(PedidoUtils.PEDIDO_WEB_SERVICE_NO_DATA_ERROR);
            }
            return response;
        }

        private BalanceoNSCWS.RespuestaOfString validatePedidoResponse(BalanceoNSCWS.RespuestaOfString response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtils.CustomException(PedidoUtils.PEDIDO_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error') || response.Tipo.toLowerCase().contains('reintento')) {
                throw new PedidoUtils.CustomException(response.Mensaje);
            } else if(response.Datos == null) {
                throw new PedidoUtils.CustomException(PedidoUtils.PEDIDO_WEB_SERVICE_NO_DATA_ERROR);
            }
            return response;
        }
        
        private BalanceoSAPWS.RespuestaOfString validatePedidoResponse(BalanceoSAPWS.RespuestaOfString response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtils.CustomException(PedidoUtils.PEDIDO_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error') || response.Tipo.toLowerCase().contains('reintento')) {
                throw new PedidoUtils.CustomException(response.Mensaje);
            } else if(response.Datos == null) {
                throw new PedidoUtils.CustomException(PedidoUtils.PEDIDO_WEB_SERVICE_NO_DATA_ERROR);
            }
            return response;
        }

        private BalanceoNSCWS.RespuestaOfListOfBalanceoProductos validateRespuestaInventario(BalanceoNSCWS.RespuestaOfListOfBalanceoProductos response) {
            if(response == null || String.isBlank(response.Tipo)) {
                throw new PedidoUtils.CustomException(PedidoUtils.BALANCEO_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.Tipo.toLowerCase().contains('error')) {
                throw new PedidoUtils.CustomException(response.Mensaje);
            } else if(response.Datos == null || response.Datos.BalanceoProductos == null) {
                throw new PedidoUtils.CustomException(PedidoUtils.BALANCEO_WEB_SERVICE_NO_DATA_ERROR);
            }
            return response;
        }
        
        private InventarioBalanceoPedidos_SF_to_ECC.DT_SE_InventarioBalanceoPedidos_Resp validateRespuestaInventarioSAP(InventarioBalanceoPedidos_SF_to_ECC.DT_SE_InventarioBalanceoPedidos_Resp response) {
            
            system.debug('response ---> '+response);
            if(response == null || String.isBlank(response.TipoMensaje)) {
                throw new PedidoUtils.CustomException(PedidoUtils.BALANCEO_WEB_SERVICE_NO_DATA_ERROR);
            } else if(response.TipoMensaje.toLowerCase().contains('error')) {
                throw new PedidoUtils.CustomException(response.Mensaje);
            } else if(response.Datos == null || response.Datos.BalanceoProductos == null) {
                throw new PedidoUtils.CustomException(PedidoUtils.BALANCEO_WEB_SERVICE_NO_DATA_ERROR);
            }
           return response;
         
        }
         private DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp retrieveInventarioSap(Integer cliente, string sucursal, Integer tipoSurtido, Integer canal, String ordenCompra) {
            
            WSDisponibilidadInventarioSAP.DisponibilidadInventarioSAPSoap servicio = new WSDisponibilidadInventarioSAP.DisponibilidadInventarioSAPSoap();
            DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Req request = new DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Req();
       		request.NumeroClienteSap =  String.ValueOf(cliente);
	        request.SucursalSap = String.ValueOf(sucursal);
	        request.TipoSurtido = String.ValueOf(tipoSurtido);
             
	        request.Canal = String.ValueOf(canal);
	        request.OrdenCompra = ordenCompra;
            servicio.timeout_x = PedidoUtils.WEB_SERVICE_TIMEOUT;
      
            for(Integer i=1; i < = PedidoUtils.MAX_CALLOUT_RETRIES; i++) {
                try {
                    return servicio.ConsultarDisponibilidadSAP(request);
                } catch(Exception e) {
                    if(i == PedidoUtils.MAX_CALLOUT_RETRIES) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, PedidoUtils.INVENTARIO_WEB_SERVICE_ERROR+e.getMessage()));
                    }
                }
            }
            return null;
        }
        
		private ProductoInventarioQueryNSCWS.Inventario CrearElementoInventario(DisponibilidadInventarioSAP.Informacion_element inventario)
		{
			 ProductoInventarioQueryNSCWS.Inventario inv = new ProductoInventarioQueryNSCWS.Inventario();
			 inv.Producto = Integer.ValueOf(inventario.NumeroProducto.trim());
			 inv.InvActual = inventario.InventarioActual == null?0:Double.ValueOf(inventario.InventarioActual);
			 inv.CompAlmHoy = inventario.ComprometidoAlmacenHoy == null?0:Double.ValueOf(inventario.ComprometidoAlmacenHoy);
			 inv.CompAlmMan = inventario.ComprometidoAlmacenManana == null?0:Double.ValueOf(inventario.ComprometidoAlmacenManana);
			 inv.DispAlm = inventario.DisponibilidadAlmacen == null?0:Double.ValueOf(inventario.DisponibilidadAlmacen);
			 inv.InvConf = inventario.InventarioConfigurado == null?0:Double.ValueOf(inventario.InventarioConfigurado);
			 inv.CompConfMan = inventario.ComprasConfigManana == null?0:Double.ValueOf(inventario.ComprasConfigManana);
			 inv.ResAlm = inventario.ResAlm == null?0:Double.ValueOf(inventario.ResAlm);
			 inv.ResConf = inventario.ResConf == null?0:Double.ValueOf(inventario.ResConf);
			 inv.PermiteApartarSinexistencias = inventario.PermiteApartarSinExistencias == null?false:Boolean.ValueOf(inventario.PermiteApartarSinExistencias);
			 inv.TipoInventario = inventario.TipoInventario == null?0:Integer.ValueOf(inventario.TipoInventario);
			 inv.TipoManejoInventario = inventario.TipoManejoInventario == null?0:Integer.ValueOf(inventario.TipoManejoInventario);
			 inv.EsPesoEstandar = inventario.EsPesoEstandar == '?'?false : Boolean.ValueOf(inventario.EsPesoEstandar);
			 system.debug('INVENTARIO :' + inventario.Contenido);
			 inv.Contenido = inventario.Contenido == null ? 0 : Double.ValueOf(inventario.Contenido);
			
	        return inv;
		}
    }
}