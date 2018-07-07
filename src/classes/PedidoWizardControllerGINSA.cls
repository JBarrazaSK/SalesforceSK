/**
 * Description: PedidoWizardGINSA.component controller class working with Opportunities.
 * Author: Jorge Terán
 * Company: LYNX9
 * Email: sf@lynx9.com
 * Created date: 
 **/
public class PedidoWizardControllerGINSA {
	
    public static final String standarPriceBook = getStandarPriceBook();
    
    public PedidoUtilsGINSA.PedidoWrapper pedidoWrapper { get; set; }
    public PedidoUtilsGINSA.AccountWrapper accountWrapper { get; set; }
    public PedidoUtilsGINSA.ExternalSources externalSources { get; set; }
    
    public PedidoWizardControllerGINSA() {
        Map<String, String> parameterMap = ApexPages.currentPage().getParameters();
        pedidoWrapper = new PedidoUtilsGINSA.PedidoWrapper( standarPriceBook );
        accountWrapper = new PedidoUtilsGINSA.AccountWrapper();
        if(parameterMap.containsKey('id')) {
            String recordId = parameterMap.get('id');
            String recordIdPrefix = recordId.left(3);
            if(recordIdPrefix == SObjectType.Account.getKeyPrefix()) {
                pedidoWrapper.pedido.AccountId = recordId;
                queryAccount();
                System.debug('TIPO SURTIDO: ' + accountWrapper.tipoSurtido);
                if( accountWrapper.tipoSurtido != null ) {
                    pedidoWrapper.pedido.Tipo_Surtido__c = accountWrapper.account.Tipo_Surtido__c;
                    pedidoWrapper.tipoSurtido = accountWrapper.tipoSurtido;
                }
                accountWrapper.isSelectable = false;
            } else if(recordIdPrefix == SObjectType.Lead.getKeyPrefix()) {
                pedidoWrapper.pedido.Prospecto__c = recordId;
            } else if(recordIdPrefix == SOBjectType.Opportunity.getKeyPrefix()) {
                pedidowrapper.queryPedido(recordId);
                queryAccount();
                stepForth();
            }
        } else if(parameterMap.containsKey('CF00N500000030Mvx_lkid')) {
            pedidoWrapper.pedido.Prospecto__c = parameterMap.get('CF00N500000030Mvx_lkid');
        }
    }
    
    public void queryAccount() {
        accountWrapper.queryAccount(pedidoWrapper.pedido.AccountId);
        pedidoWrapper.pedido.AccountId = accountWrapper.account.Id;
        if(pedidoWrapper.pedido.Id == null) {
            pedidoWrapper.pedido.Tipo_Surtido__c = accountWrapper.account.RecordType.Name == 'Sucursal' && accountWrapper.account.DiasEntrega__c != null && accountWrapper.account.Canal_de_Distribucion_NSC__r.Id != null ? '3 - RUTA' : '4 - LOCAL';
            System.debug('TIPO SURTIDO: ' + accountWrapper.tipoSurtido);
            if( accountWrapper.tipoSurtido != null ) {
                pedidoWrapper.pedido.Tipo_Surtido__c = accountWrapper.account.Tipo_Surtido__c;
                pedidoWrapper.tipoSurtido = accountWrapper.tipoSurtido;
            }
        }
    }
    
    public void stepForth() {
        String tipoSurtido = pedidoWrapper.pedido.Tipo_Surtido__c;
        System.debug('Tipo Surtido'+ tipoSurtido);
        String oficinaVentasName = accountWrapper.oficinaVentasName;
        System.debug('OficinaVentasName'+ oficinaVentasName);
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
            }*/
        }
        pedidoWrapper.tipoSurtido = Integer.valueOf(pedidoWrapper.pedido.Tipo_Surtido__c.left(1));
        pedidoWrapper.fecDoc = String.valueOf(pedidoWrapper.pedido.Fecha_Registro__c).left(10).replaceAll('-', '');
        externalSources = new PedidoUtilsGINSA.ExternalSources();
        if(
            externalSources.setIsClosedPlaza(accountWrapper.cliente, accountWrapper.sucursal, accountWrapper.canal, pedidoWrapper.pedido.OficinaVentas__r!=null ? Integer.valueOf(pedidoWrapper.pedido.OficinaVentas__r.Codigo__c):null) &&
            externalSources.setInventarioXProductCodeMap(accountWrapper.cliente, accountWrapper.sucursal, pedidoWrapper.tipoSurtido, pedidoWrapper.pedido.OficinaVentas__r != null ? Integer.valueOf(pedidoWrapper.pedido.OficinaVentas__r.Codigo__c) : accountWrapper.canal, pedidoWrapper.pedido.Orden_de_Compra__c) &&
            externalSources.setPrecioListXProductCodeMap(accountWrapper.clienteSAP, accountWrapper.gpoVendedores, accountWrapper.ofiVentas, accountWrapper.orgVentas, accountWrapper.canalSAP, accountWrapper.sucursal, accountWrapper.cluster, accountWrapper.cadena, pedidoWrapper.fecDoc)
        ) {
            pedidoWrapper.queryPedidoParameters();
            if(pedidoWrapper.pedido.Id == null) {
                pedidoWrapper.setPedidoDefaults(accountWrapper.account, externalSources.IsClosedPlaza);
                pedidoWrapper.instanceNewPedidoItemList();
            } else {
                pedidoWrapper.addCurrentAmountsToInventory(externalSources.inventarioXProductCodeMap);
            }
        } else {
            externalSources.precioListXProductCodeMap = null;
        }
    }
    
    public void submit() {
        pedidoWrapper.setPedidoData();
        PedidoInsertNSCWS.PedidoRespuesta response = externalSources.syncPedido(pedidoWrapper, accountWrapper);
        if(response != null) {
            pedidoWrapper.assignWebServiceResponseData(response);
            pedidoWrapper.save();
        }
    }
    
    public Map<String, PriceBookEntry> product2XproductCodeMap {
        get {
            if(product2XproductCodeMap == null) {
                List<String> productCodeList = new List<String>(externalSources.inventarioXProductCodeMap.keySet());
                pedidoWrapper.product2Map = new Map<Id, PriceBookEntry>([
                    SELECT p.Id, p.Product2.Id, p.Product2.Description, p.Product2.Ficha_comercial__c, p.Product2.Name, p.Product2.Peso_Promedio__c, p.Product2.ProductCode, p.ProductCode
                    FROM PriceBookEntry p
                    WHERE p.Product2.ProductCode IN :productCodeList AND p.Pricebook2.Id =: standarPriceBook
                ]);
                product2XproductCodeMap = new Map<String, PriceBookEntry>();
                System.debug('Product2Map: '+pedidoWrapper.product2Map.values());
                for(PricebookEntry product2 : pedidoWrapper.product2Map.values()) {
                    product2XproductCodeMap.put(product2.ProductCode, product2);
                }
            }
            return product2XproductCodeMap;
        }
        set;
    }

    public class CustomException extends Exception {}

    public static String getStandarPriceBook(){
       return [SELECT p.IsStandard, p.Id From Pricebook2 p
            WHERE isStandard = true AND isActive = true LIMIT 1].Id;
    }
}