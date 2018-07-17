/**
 * Description: PedidoWizard.component controller class.
 * Author:  V-1.0 & V-3.0 (JavaScript version) by Oscar Becerra
 *          Last Version: Jorge Terán
 * Company: gAin
 *          LYNX9
 * Email:   obecerra@grupoassa.com
 *          sf@lynx9.com
 * Created date: 03/12/2014
 * Modified date: 03/03/2016
 **/
public with sharing class PedidoWizardController {

    public PedidoUtils.PedidoWrapper pedidoWrapper { get; set; }
    public PedidoUtils.AccountWrapper accountWrapper { get; set; }
    public PedidoUtils.ExternalSources externalSources { get; set; }
    public integer Dias { get; set; }
    public Boolean OperaSap {get;set;}

    public PedidoWizardController() {
        Map<String, String> parameterMap = ApexPages.currentPage().getParameters();
        pedidoWrapper = new PedidoUtils.PedidoWrapper();
        accountWrapper = new PedidoUtils.AccountWrapper();
        externalSources = new PedidoUtils.ExternalSources();
        Dias = 1;
        OperaSap = false;
        if(parameterMap.containsKey('id')) {
            String recordId = parameterMap.get('id');
            String recordIdPrefix = recordId.left(3);
            if(recordIdPrefix == SObjectType.Account.getKeyPrefix()) {
                pedidoWrapper.pedido.Cuenta__c = recordId;
                queryAccount();
              
                System.debug('TIPO SURTIDO: ' + accountWrapper.tipoSurtido);
                if( accountWrapper.tipoSurtido != null ) {
                    pedidoWrapper.pedido.TipoSurtido__c = accountWrapper.account.Tipo_Surtido__c;
                    pedidoWrapper.tipoSurtido = accountWrapper.tipoSurtido;
                }
                accountWrapper.isSelectable = false;
            } else if(recordIdPrefix == SObjectType.Lead.getKeyPrefix()) {
                pedidoWrapper.pedido.Prospecto__c = recordId;
            } else if(recordIdPrefix == SOBjectType.Pedido__c.getKeyPrefix()) {
                pedidowrapper.queryPedido(recordId);
                queryAccount();
                stepForth();
            }
        } else if(parameterMap.containsKey('CF00N500000030Mvx_lkid')) {
            pedidoWrapper.pedido.Prospecto__c = parameterMap.get('CF00N500000030Mvx_lkid');
        }         
       if(accountWrapper != null && accountWrapper.ofiventas != null)
       {	           
             if(externalSources.OperaEnSap(Integer.valueOf(accountWrapper.ofiventas)))
            {                             
                OperaSap = true;
            } 
        }        
    } 

    public void queryAccount() {
        accountWrapper.queryAccount(pedidoWrapper.pedido.Cuenta__c);
        if(pedidoWrapper.pedido.Id == null) {
            pedidoWrapper.pedido.Cuenta__c = accountWrapper.account.Id;
            pedidoWrapper.pedido.TipoSurtido__c = accountWrapper.account.RecordType.Name == 'Sucursal' && accountWrapper.account.DiasEntrega__c != null && accountWrapper.account.Canal_de_Distribucion_NSC__r.Id != null ? '3 - RUTA' : '4 - LOCAL';
            if( accountWrapper.tipoSurtido != null ) {
                System.debug('TIPO SURTIDO: ' + accountWrapper.tipoSurtido);
                pedidoWrapper.pedido.TipoSurtido__c = accountWrapper.account.Tipo_Surtido__c;
                pedidoWrapper.tipoSurtido = accountWrapper.tipoSurtido;
            }
        }
        
    }

    public void stepForth() {
        String tipoSurtido = pedidoWrapper.pedido.TipoSurtido__c;
        System.debug('Tipo Surtido'+ tipoSurtido);
        String oficinaVentasName = accountWrapper.oficinaVentasName;
        System.debug('OficinaVentasName'+ oficinaVentasName);
        Date fechaSurtido = null;
        queryAccount();
        pedidoWrapper.pedido.TipoSurtido__c = tipoSurtido;
        if(ApexPages.hasMessages() || !accountWrapper.isValidAccountWrapper()) {
            accountWrapper.oficinaVentasName = oficinaVentasName;
            return;
        }
        list<Case> ListaCasos = [SELECT Id FROM Case where status ='EN PROCESO' AND SK_SubCategoria_Tipo__c  ='Labor de Colocación' and OwnerId =:UserInfo.getUserId()];

       if(ListaCasos != null && ListaCasos.size() > 0)
       {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Favor de revisar, tiene casos de labor de colocación pendientes');
            ApexPages.addMessage(myMsg);
            return;
       }
        if(pedidoWrapper.pedido.Id == null) {
            accountWrapper.oficinaVentasName = oficinaVentasName;
            accountWrapper.ofiventas = accountWrapper.getSAPCode(accountWrapper.oficinaVentasName);
            pedidoWrapper.pedido.OficinaVentas__r = new Oficina_de_Venta__c(
                Codigo__c = accountWrapper.ofiventas
            );
             
                if(accountWrapper != null && accountWrapper.oficinaVentasName != null){
                    String SapCode = accountWrapper.getSAPCode(accountWrapper.oficinaVentasName);
                   
                         if(externalSources.OperaEnSap(Integer.valueOf(accountWrapper.ofiventas)))
                         {                             
                             OperaSap = true;
                         } 
                }
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
        pedidoWrapper.tipoSurtido = Integer.valueOf(pedidoWrapper.pedido.TipoSurtido__c.left(1));
        System.debug('Entro:'+pedidoWrapper.pedido.FechaSurtidoProgramada__c);
        if(pedidoWrapper.pedido.FechaSurtidoProgramada__c != null)
        {
          System.debug('Entro:');
          if(pedidoWrapper.pedido.FechaSurtidoProgramada__c.format('EEEE') == 'Saturday') pedidoWrapper.pedido.FechaSurtidoProgramada__c = pedidoWrapper.pedido.FechaSurtidoProgramada__c.addDays(1);
          if(pedidoWrapper.pedido.FechaSurtidoProgramada__c.format('EEEE') == 'Sunday') pedidoWrapper.pedido.FechaSurtidoProgramada__c = pedidoWrapper.pedido.FechaSurtidoProgramada__c.addDays(1);

              Date dt = date.newinstance(pedidoWrapper.pedido.FechaSurtidoProgramada__c.year(), pedidoWrapper.pedido.FechaSurtidoProgramada__c.month(), pedidoWrapper.pedido.FechaSurtidoProgramada__c.day());
              pedidoWrapper.fecDoc =  String.valueOf(dt).left(10).replaceAll('-', '');
        }
        else{pedidoWrapper.fecDoc = String.valueOf(pedidoWrapper.pedido.Fecha_Registro__c.addDays(Dias)).left(10).replaceAll('-', '');}

        externalSources = new PedidoUtils.ExternalSources();
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
    	system.debug('SUBMIT():'); 
        pedidoWrapper.setPedidoData();
        PedidoInsertNSCWS.PedidoRespuesta response = null;
        ApexPages.Message myMsg =  null;   
        WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido responseSAP = null; 
        if(externalSources.OperaEnSap(Integer.valueOf(accountWrapper.ofiventas)))
        	responseSAP = externalSources.syncPedidoSAP(pedidoWrapper, accountWrapper,false);
        else
        	response = externalSources.syncPedido(pedidoWrapper, accountWrapper);                

		//NSC
        if(response != null)
        {
        	pedidoWrapper.assignWebServiceResponseData(response);
            pedidoWrapper.save();
        }
        else if(responseSAP != null)
        {    
        	if (responseSAP.DT_SE_ABCPedidos_RespPedido != null)
        	{  
        		for(Integer i = 0; i<responseSAP.DT_SE_ABCPedidos_RespPedido.size();i++ )
        		{      			
	        		  	 
					if((responseSAP.DT_SE_ABCPedidos_RespPedido[i].Estatus != null && responseSAP.DT_SE_ABCPedidos_RespPedido[i].Estatus != 'C') 
		        			&& (responseSAP.DT_SE_ABCPedidos_RespPedido[i].TipoMensaje == 'S')) 
		        	{
		        		pedidoWrapper.assignWebServiceResponseData(responseSAP.DT_SE_ABCPedidos_RespPedido[i]);
		        		pedidoWrapper.save();
		        	}	        	
		        	if(responseSAP.DT_SE_ABCPedidos_RespPedido[i].TipoMensaje == 'E' )
		        	{
		        		 myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,responseSAP.DT_SE_ABCPedidos_RespPedido[i].Mensaje);
		        		 ApexPages.addMessage(myMsg);
		        	}
		        	else if(responseSAP.DT_SE_ABCPedidos_RespPedido[i].TipoMensaje == 'W' )
		        	{
		        		 myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,responseSAP.DT_SE_ABCPedidos_RespPedido[i].Mensaje);
		        		 ApexPages.addMessage(myMsg);
		        	}		            
	            }   
        	}
        }
        	
    }

    public Map<String, Product2> product2XproductCodeMap {
        get {
            if(product2XproductCodeMap == null) {
                List<String> productCodeList = new List<String>(externalSources.inventarioXProductCodeMap.keySet());
                pedidoWrapper.product2Map = new Map<Id, Product2>([
                    SELECT Description, Ficha_comercial__c, Name, Peso_Promedio__c, ProductCode,Unidad_de_medida_base__c
                    FROM Product2
                    WHERE ProductCode IN :productCodeList
                ]);
                product2XproductCodeMap = new Map<String, Product2>();
                for(Product2 product2 : pedidoWrapper.product2Map.values()) {
                    product2XproductCodeMap.put(product2.ProductCode, product2);
                }
            }
            return product2XproductCodeMap;
        }
        set;
    }

    public class CustomException extends Exception {}


}