/**
 * Description: ProductosBalanceo.page controller class. Balanceo de productos 
 * Author: V-1.0 & V-2.0 by Leonardo Cortes
 * Company: gA
 * Email: lcortes@grupoassa.com
 * Modifying by: Leonardo Cortes / lcortes@grupoassa.com / 20/06/2016
 * Created date: 01/05/2015
 **/
public with sharing class BalanceoController {
	public Pedido__c pedidoForm {get; set;}
	public List<SelectOption> productSelectionList {
		get{
		    productSelectionList = new List<SelectOption>();
		    productSelectionList.add(new SelectOption('T', 'Todos los productos'));
		    productSelectionList.add(new SelectOption('S', 'Sin disponible'));
		    productSelectionList.add(new SelectOption('P', 'Por producto'));
		    return productSelectionList;
		} 
		set;}

	public BalanceoController(){
		pedidoForm = new Pedido__c(Fecha_Registro__c = Date.today().addDays(1));
	}


    @RemoteAction  
    public static List<ProductoWrapper> buscarRemoto(String fechaRegistro, String oficinaVentas) {
        List<Pedido__c> pedidosList;
        System.debug(fechaRegistro);
        System.debug(Date.valueOf(fechaRegistro));
        List<ProductoWrapper> productoWrapperList = new List<ProductoWrapper>();
        //PedidoUtils.ExternalSources externalSources = new PedidoUtils.ExternalSources();
        Date fechahoy = Date.today();   
        Pedido__c pedidoForm = new Pedido__c(OficinaVentas__c=oficinaVentas, Fecha_Registro__c=Date.valueOf(fechaRegistro));
        
        Date fechaSurtido = pedidoForm.Fecha_Registro__c;
        if(fechaSurtido < fechahoy){
            throw new BalanceoException(PedidoUtils.BALANCEO_ERROR_DATE_PREV);
        }
        
        Set<Id> oficinasIds = new Set<Id>();
        oficinasIds.add(pedidoForm.OficinaVentas__c);
        for(Oficina_de_Venta__c ov : [SELECT Id FROM Oficina_de_Venta__c WHERE CEDIS__c =: pedidoForm.OficinaVentas__c]){
            oficinasIds.add(ov.Id);
        }

		pedidosList = [SELECT Id, Name, Canal__c, OficinaVentas__c, OficinaVentas__r.Id, OficinaVentas__r.Codigo__c, Cuenta__c, ClienteSap__c  
                        FROM Pedido__c 
                        WHERE DAY_IN_YEAR(convertTimezone(FechaSurtidoProgramada__c)) =: fechaSurtido.dayOfYear() and
                                  OficinaVentas__c IN: oficinasIds and 
                                  PedidoRechazado__c = false and 
                                  Pedido_Cancelado__c = false and
                                  PedidoCanceladoPorElSistema__c = false and
                                  EstatusPedido__c = '1 - Pedido Colocado'];
        Set<Id> pedidosIds = new Set<Id>();
        Map<Id,Pedido__c> pedidosMap = new Map<Id,Pedido__c>();
        if(pedidosList.size()==0){
            throw new BalanceoException(PedidoUtils.BALANCEO_ERROR_PEDIDO_CERO);
        }

        pedidoForm.OficinaVentas__r = [select Codigo__c, Id,Opera_en_SAP__c from Oficina_de_Venta__c Where Id=:oficinaVentas];

        for(Pedido__c ped : pedidosList){
            //pedidoForm.OficinaVentas__r = ped.OficinaVentas__r;
            pedidosIds.add(ped.Id);
            pedidosMap.put(ped.Id, ped);
        }

        //----------------------selects campo "Anterior" -----------------------------------------------

        List<Pedido__c> pedidosAnterioresList = [SELECT Id
                        FROM Pedido__c 
                        WHERE DAY_IN_YEAR(convertTimezone(FechaSurtidoProgramada__c)) <: fechaSurtido.dayOfYear() and 
                                DAY_IN_YEAR(convertTimezone(FechaSurtidoProgramada__c)) >=: fechahoy.dayOfYear() and 
                                OficinaVentas__c IN: oficinasIds and
                                  PedidoRechazado__c = false and 
                                  Pedido_Cancelado__c = false and
                                  PedidoCanceladoPorElSistema__c = false and
                                  EstatusPedido__c = '1 - Pedido Colocado'];

        
        Set<Id> pedidosAnterioresIds = new Set<Id>();
        for(Pedido__c ped2 : pedidosAnterioresList){
            pedidosAnterioresIds.add(ped2.Id);
        }
        
        //-----------------------select campo "Posterior"------------------------------------------------
        List<Pedido__c> pedidosPosterioresList = [SELECT Id
                        FROM Pedido__c 
                        WHERE DAY_IN_YEAR(convertTimezone(FechaSurtidoProgramada__c)) >: fechaSurtido.dayOfYear() and 
                                OficinaVentas__c IN: oficinasIds and
                                  PedidoRechazado__c = false and 
                                  Pedido_Cancelado__c = false and
                                  PedidoCanceladoPorElSistema__c = false and
                                  EstatusPedido__c = '1 - Pedido Colocado'];

        
        Set<Id> pedidosPosterioresIds = new Set<Id>();
        for(Pedido__c ped2 : pedidosPosterioresList){
            pedidosPosterioresIds.add(ped2.Id);
        }
        
        
        //------------------------------------------------------------------------------
        
        List<PedidoItem__c> itemsList = new List<PedidoItem__c>();
        List<PedidoItem__c> itemsAnterioresList2 = new List<PedidoItem__c>();
        List<PedidoItem__c> itemsPosterioresList = new List<PedidoItem__c>();
        
        Set<Integer> productosIdExts = new Set<Integer>();
        
    	System.debug(pedidosIds);
        if(pedidosIds.size()>0){
            itemsList = BalanceoController.getItemsList(pedidosIds);
        }

        if(pedidosAnterioresIds.size()>0){
            itemsAnterioresList2 = [SELECT Id, Producto__c,Cajas_Conf__c
                                    FROM PedidoItem__c WHERE Pedido__c IN :pedidosAnterioresIds];
        }
                                
        if(pedidosPosterioresIds.size()>0){                  
            itemsPosterioresList = [SELECT Id, Producto__c,Cajas_Conf__c
                                    FROM PedidoItem__c WHERE Pedido__c IN :pedidosPosterioresIds];
        }
        System.debug(pedidosIds);
        Set<Id> productosIds = new Set<Id>();
        productosIdExts = new Set<Integer>();
        Map <Id, Map<Id, PedidoItem__c>> itemsXPedidoxProducto = new Map <Id, Map<Id, PedidoItem__c>>();
        Map <Id, List<Pedido__c>> pedidosXProducto = new Map <Id, List<Pedido__c>>();
        Map <Id, Decimal> solicitadoXProducto = new Map <Id, Decimal>();
        Map <Id, Decimal> confirmadoXProducto = new Map <Id, Decimal>();
        Map <Id, Decimal> balanceadoXProducto = new Map <Id, Decimal>();
        
        Map<String,String> productos = new Map<String,String>();
        Map<Id,Set<String>> productosPorCliente = new Map<Id,Set<String>>();
        Map<Id,Decimal> mapPedidoItems = new Map<Id,Decimal>();
        Map<Id,String> mapUnidades = new Map<Id,String>();
        System.debug(itemsList);
       
        for(PedidoItem__c item : itemsList){
            
            productos.put(String.valueOf(item.Producto__c),item.Producto__r.Codigo_Id_Externo__c);
            if(!productosPorCliente.containsKey(item.Pedido__r.Cuenta__c)){
                productosPorCliente.put(item.Pedido__r.Cuenta__c,new Set<String>());
            }
            productosPorCliente.get(item.Pedido__r.Cuenta__c).add(item.Producto__r.Codigo_Id_Externo__c);

            productosIds.add(item.Producto__c);
            productosIdExts.add(Integer.valueOf(item.Producto__r.Codigo_Id_Externo__c));
            mapPedidoItems.put(item.Id,item.Cajas_Conf__c);
            
            Map<Id, PedidoItem__c> mp;
            if(itemsXPedidoxProducto.containsKey(item.Producto__c)){
                mp = itemsXPedidoxProducto.get(item.Producto__c);
            } else {
                mp = new Map<Id, PedidoItem__c>();
                itemsXPedidoxProducto.put(item.Producto__c, mp);
            }
            mp.put(item.Pedido__c, item);  
            
            //mapUnidades.put(item.Producto__c,item.Unidad__c);
            
            List<Pedido__c> pp;
            if(pedidosXProducto.containsKey(item.Producto__c)){
                pp = pedidosXProducto.get(item.Producto__c);
            } else {
                pp = new List<Pedido__c>();
                pedidosXProducto.put(item.Producto__c, pp);
            }
            pp.add(pedidosMap.get(item.Pedido__c));
            
            Decimal sp = 0;
            if(solicitadoXProducto.containsKey(item.Producto__c)){
                sp = solicitadoXProducto.get(item.Producto__c);
            }
            sp += item.Cajas__c == null? 0: item.Cajas__c;
            solicitadoXProducto.put(item.Producto__c, sp);
            
            Decimal cp = 0;
            if(confirmadoXProducto.containsKey(item.Producto__c)){
                cp = confirmadoXProducto.get(item.Producto__c);
            }
            cp += item.Cajas_Conf__c == null? 0: item.Cajas_Conf__c;
            confirmadoXProducto.put(item.Producto__c, cp);
            
            Decimal bp = 0;
            if(balanceadoXProducto.containsKey(item.Producto__c)){
                bp = balanceadoXProducto.get(item.Producto__c);
            }
            if(item.Cajas_Balanceadas__c == null){
                item.Cajas_Balanceadas__c = item.Cajas_Conf__c;
            }
            bp += item.Cajas_Balanceadas__c;
            balanceadoXProducto.put(item.Producto__c, bp);
        }
        
        Map <Id, Decimal> anteriorXProducto   = new Map <Id, Decimal>();
        for(PedidoItem__c item2 : itemsAnterioresList2){
            Decimal ap = 0;
            if(anteriorXProducto.containsKey(item2.Producto__c)){
                ap = anteriorXProducto.get(item2.Producto__c);
            }
            ap += item2.Cajas_Conf__c == null? 0: item2.Cajas_Conf__c;
            anteriorXProducto.put(item2.Producto__c, ap);
        }
        
        Map <Id, Decimal> posteriorXProducto   = new Map <Id, Decimal>();
        for(PedidoItem__c item3 : itemsPosterioresList){
            
            Decimal ps = 0;
            if(posteriorXProducto.containsKey(item3.Producto__c)){
                ps = posteriorXProducto.get(item3.Producto__c);
            }
            ps += item3.Cajas_Conf__c == null? 0: item3.Cajas_Conf__c;
            posteriorXProducto.put(item3.Producto__c, ps);
        }

        System.debug(productosIdExts);
        System.debug(Integer.valueOf(pedidoForm.OficinaVentas__r.Codigo__c));
        Map<Integer,BalanceoNSCWS.BalanceoProductos> inventario = new Map<Integer,BalanceoNSCWS.BalanceoProductos>();
        Map<Integer,InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element> inventarioSAP = new Map<Integer,InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element>();
        if(pedidoForm.OficinaVentas__r.Opera_en_SAP__c == true)
        	inventarioSAP = BalanceoController.getInventarioSAP(productosIdExts, Integer.valueOf(pedidoForm.OficinaVentas__r.Codigo__c));
        else
        	inventario = BalanceoController.getInventario(productosIdExts, Integer.valueOf(pedidoForm.OficinaVentas__r.Codigo__c));
        
        System.debug(inventario);
        if(inventario == null && inventarioSAP == null){
            throw new BalanceoException(PedidoUtils.BALANCEO_WEB_SERVICE_ERROR_INVENTARIO);
        }
        Map<Id,Product2> productMap = new Map<Id,Product2>( [SELECT Id, Description,Codigo_Id_Externo__c,Sub_Familia__c,Piezas_por_caja__c FROM Product2 Where Id In:productosIds ORDER BY Codigo_Id_Externo__c]);
        for (Id prodId : productosIds){
            ProductoWrapper pw = new ProductoWrapper();
            pw.producto = productMap.get(prodId);
            pw.pedidos = pedidosXProducto.get(prodId);
            pw.itemXPedido = itemsXPedidoxProducto.get(prodId);
            pw.solicitado = solicitadoXProducto.get(prodId);
            pw.confirmado = confirmadoXProducto.get(prodId);
            pw.balanceado = balanceadoXProducto.get(prodId);
            pw.anterior   = anteriorXProducto.get(prodId);
            pw.posterior  = posteriorXProducto.get(prodId);
			
            //pw.balanceado = pw.balanceado==0?pw.confirmado:pw.balanceado;

            BalanceoNSCWS.BalanceoProductos invItem = inventario.get(Integer.valueOf(pw.producto.Codigo_Id_Externo__c));
            InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element invItemSAP = inventarioSAP.get(Integer.valueOf(pw.producto.Codigo_Id_Externo__c));
            if(invItem!=null || invItemSAP != null){
                pw.disponible = ((invItem != null)? invItem.Disponible:invItemSAP.Disponible.intValue()) + pw.confirmado.intValue();
                pw.tipoManejoInventario = (invItem != null)?invItem.TipoManejoInventario:invItemSAP.TipoManejoInventario;
            }else{
                System.debug('No se encontro el producto '+Integer.valueOf(pw.producto.Codigo_Id_Externo__c));
            }
            pw.diferencia = pw.disponible - pw.confirmado;// Valore volteados para comprencion del usuario 

            productoWrapperList.add(pw);               
        }
        return productoWrapperList;

    }

    public static Map<Integer,BalanceoNSCWS.BalanceoProductos> getInventario(Set<Integer> productosIdExts , Integer codigoOficinaVentas){
    	PedidoUtils.ExternalSources externalSources = new PedidoUtils.ExternalSources();
    	Map<Integer,BalanceoNSCWS.BalanceoProductos> inventario = externalSources.retrieveTipoManejoInventario(productosIdExts, codigoOficinaVentas);
        System.debug(inventario);
        if(inventario == null){
            throw new BalanceoException(PedidoUtils.BALANCEO_WEB_SERVICE_ERROR_INVENTARIO);
        }
        return inventario;
    }
    
    public static Map<Integer,InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element> getInventarioSAP(Set<Integer> productosIdExts , Integer codigoOficinaVentas){
    	PedidoUtils.ExternalSources externalSources = new PedidoUtils.ExternalSources();
    	Map<Integer,InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element> inventario = externalSources.retrieveTipoManejoInventarioSAP(productosIdExts, codigoOficinaVentas);
        System.debug('INVENTARIO --->' +inventario);
        if(inventario == null){
            throw new BalanceoException(PedidoUtils.BALANCEO_WEB_SERVICE_ERROR_INVENTARIO);
        }
        return inventario;
    }

    public static List<PedidoItem__c> getItemsList(Set<Id> pedidosIds){
    	return [SELECT Id,
                                Pedido__c,
                                CreatedBy.Name,
                                Id_externo_Producto_Pedido__c,
                                
                                Producto__c,
                                Producto__r.Codigo_Id_Externo__c, 
                                Producto__r.ProductCode,
                                
                                CantidadConfirmada__c, //Borrar
                                Cantidad_Balanceada__c,  //Borrar
                                CantidadPedida__c, //Borrar
                                
                                Cajas__c,
                                Cajas_Conf__c, 
                                Cajas_Balanceadas__c,
                                
                                Kilos__c, 
                                Kilos_Conf__c,
                                Kilos_Balanceados__c,
                                
                                Piezas__c, 
                                Piezas_Conf__c, 
                                Piezas_Balanceadas__c,
                                PiezasPedidas__c, //Borrar
                                PiezasConfirmadas__c, //Borrar
                                
                                Pedido__r.IdExterno__c,
                                Pedido__r.EstatusPedido__c,
                                Pedido__r.Canal__c, 
                                Pedido__r.ClienteSap__c,
                                Pedido__r.Cuenta__r.Name, 
                                Pedido__r.RequiereAutorizacion__c,

                                Pedido__r.OficinaVentas__r.Codigo__c,
                                Pedido__r.OficinaVentas__r.Opera_en_SAP__c,
                                Pedido__r.OficinaVentas__r.Name,

                                Pedido__r.Numero_de_Pedido_NSC__c,
                                Pedido__r.Numero_Pedido_SAP__c,
                                Pedido__r.Cuenta__c,
                                Pedido__r.Cuenta__r.Canal_de_Distribucion_NSC__r.Name
                                
                     FROM PedidoItem__c WHERE Pedido__c IN :pedidosIds ORDER BY Producto__r.Codigo_Id_Externo__c, Pedido__r.OficinaVentas__r.Name];
    }

    @RemoteAction
    public static Map<Integer,Boolean> validaCierrePlaza(List<String> canales, Integer canalPadre){
    	PedidoUtils.ExternalSources externalSources = new PedidoUtils.ExternalSources();
    	Set<Integer> setCanales = new Set<Integer>();
    	for(String v : canales){
    		setCanales.add(Integer.valueOf(v));
    	}
    	return externalSources.setIsClosedPlazas(setCanales,canalPadre);
    }

    @RemoteAction
    public static String guardaBalanceRemoto(List<String> pedidosIdsText, List<String> nuevosValores){
    	String respuesta = 'Error';
    	 //Envio de pedidos
                BalanceoNSCWS.RespuestaOfString resp;
                WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_RespPedido resp2;
    	PedidoUtils.ExternalSources externalSources = new PedidoUtils.ExternalSources();
        String estatuspedido='';
        String pedidoExternoExecutado = '';
        Map<Id,Decimal> mapPedidoItems = new Map<Id,Decimal>();
        //Savepoint savepoint = Database.setSavepoint();
        try{
        	Integer codigoOficinaVenta = 0;
        	boolean operaEnSap  = false;
            Set<Id> pedidos2Send = new Set<Id>();
            Set<String> accountsIds = new Set<String>();

            Map<Id,Set<String>> productosPorCliente = new Map<Id,Set<String>>();
            Set<Integer> productosIdExts = new Set<Integer>();
            Map<String,String> productos = new Map<String,String>();

            Decimal totalBalanceado = 0;
            Map<Id,Decimal> mapItemBalanceo = new Map<Id,Decimal>();

            Set<Id> pedidosIds = new Set<Id>();
            System.debug(pedidosIdsText);
            for(String v : pedidosIdsText){
            	System.debug(v);
            	pedidosIds.add(v);
            }
            Map<Id,Decimal> mapNuevos = new Map<Id,Decimal>();
            System.debug(nuevosValores);
            for(String v : nuevosValores){
            	System.debug('Valores javascript: '+v);
            	String[] item = v.split('@');
            	if(item[1] == 'NaN'){
            		return respuesta ='Favor de capturar una cantidad valida.';
            		
            	}
            	
            	mapNuevos.put(Id.valueOf(item[0]), Decimal.valueOf(item[1]));
            }

            List<PedidoItem__c> itemsList = BalanceoController.getItemsList(pedidosIds);

            for (PedidoItem__c item: itemsList){
            	codigoOficinaVenta = Integer.valueOf(item.Pedido__r.OficinaVentas__r.Codigo__c);
            	
            	operaEnSap = (item.Pedido__r.OficinaVentas__r.Opera_en_SAP__c == true);
				if(!productosPorCliente.containsKey(item.Pedido__r.Cuenta__c)){
					productosPorCliente.put(item.Pedido__r.Cuenta__c,new Set<String>());
				}
				productosPorCliente.get(item.Pedido__r.Cuenta__c).add(item.Producto__r.Codigo_Id_Externo__c);
				productosIdExts.add(Integer.valueOf(item.Producto__r.Codigo_Id_Externo__c));
				productos.put(String.valueOf(item.Producto__c),item.Producto__r.Codigo_Id_Externo__c);
				if(mapNuevos.containsKey(item.Id)){
	            	mapPedidoItems.put(item.Id,item.Cajas_Balanceadas__c==null?item.Cajas_Conf__c:item.Cajas_Balanceadas__c);
	            	System.debug('Item: '+item);
	            	item.Cajas_Conf__c = mapNuevos.containsKey(item.Id)?mapNuevos.get(item.Id):item.Cajas_Conf__c;
	            	System.debug(item);
	                Decimal cantidadbalanceada   = item.Cajas_Conf__c;
	               
	                Decimal valBalOld = mapPedidoItems.get(item.Id);
	                estatuspedido = item.Pedido__r.EstatusPedido__c;
	                totalBalanceado += cantidadbalanceada;
	                if (cantidadbalanceada > valBalOld){//item.Cajas_Balanceadas__c)// {//item.Cajas__c) {//
	                    item.Cajas_Conf__c = valBalOld;
	                    item.Cajas_Conf__c.addError(PedidoUtils.BALANCEO_ERROR_BALANCEO_MAYOR_PEDIDO);
	                    throw new BalanceoException(PedidoUtils.BALANCEO_ERROR_BALANCEO_MAYOR_PEDIDO);
	                }else if (cantidadbalanceada < 0) {
	                    item.Cajas_Conf__c.addError(PedidoUtils.BALANCEO_ERROR_BALANCEO_NEGATIVO);
	                    item.Cajas_Conf__c = valBalOld;
	                    throw new BalanceoException(PedidoUtils.BALANCEO_ERROR_BALANCEO_NEGATIVO);
	                }else if (estatuspedido== '5 - Pedido Facturado'){
	                    item.Cajas_Conf__c.addError(PedidoUtils.BALANCEO_ERROR_PEDIDO_FACTURADO);
	                    item.Cajas_Conf__c = valBalOld;
	                    throw new BalanceoException(PedidoUtils.BALANCEO_ERROR_PEDIDO_FACTURADO);
	                }else{
	                    if (cantidadbalanceada <= valBalOld ) {
	                        pedidos2Send.add(item.Pedido__c);
	                        accountsIds.add(item.Pedido__r.Cuenta__c);
	                        mapItemBalanceo.put(item.Id, cantidadbalanceada);
	                    }
	                }
	            }
            }

            if(pedidos2Send.size()>0){

				Map<Id,PedidoUtils> pwcMap = new Map<Id,PedidoUtils>();
				Map<Integer,BalanceoNSCWS.BalanceoProductos> inventario;
				Map<Integer,InventarioBalanceoPedidos_SF_to_ECC.BalanceoProductos_element> inventarioSAP;
				if(!operaEnSap)
					inventario = BalanceoController.getInventario(productosIdExts, codigoOficinaVenta);
				else
					inventarioSAP = BalanceoController.getInventarioSAP(productosIdExts, codigoOficinaVenta);	         
                //Crea Instancias con listas de precios
               
                PedidoUtils.ExternalSources extSources = new PedidoUtils.ExternalSources();
                Set<String> setStringPedidos = new Set<String>();
                for(Id v : pedidos2Send){
                	setStringPedidos.add(v);
                }
                Map<Id,Pedido__c> mapPedidos = PedidoUtils.queryPedidos(setStringPedidos);
                Map<Id, Account> mapAccounts = PedidoUtils.queryAccountSet(accountsIds);
                System.debug(mapAccounts);
                ListaPreciosQueryNSCWS.ArrayOfPreciosXCliente listClientesLPRef = listClientesLP(productosPorCliente, mapPedidos.values(),mapAccounts);
                System.debug(listClientesLPRef);
                Map<String,ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios> mapLP = extSources.getListaPreciosMasivo(listClientesLPRef);

                Map<String,List<Gpo_Vendedores_Oficina_de_Ventas__c>> gruposVendedores = getGruposVendedoresPedidosBySet(getGruposVendedoresPedidos(listClientesLPRef));
                Map<Id, Product2> product2General = getProduct2General(productos.values());
                for(Pedido__c p : mapPedidos.values()){
                    Account accRef = mapAccounts.get(p.Cuenta__c);
                    String codigoCliente = String.valueOf(Integer.valueOf(accRef.Parent.Numero_Cliente_SAP__c));
                    ListaPreciosQueryNSCWS.RespuestaOfListOfPrecios listaPreciosCliente = mapLP.get(codigoCliente);
                    PedidoUtils pu = new PedidoUtils(p.Id,true,false, inventario,inventarioSAP, productos,mapPedidos.get(p.Id),accRef,listaPreciosCliente,gruposVendedores,product2General);
                    if(pu.externalSources.precioListXProductCodeMap == null ){
                        throw new BalanceoException(PedidoUtils.LISTAPRECIOS_WEB_SERVICE_ERROR);
                    }else{
                        pwcMap.put(p.Id, pu);
                    }
                }


                //throw new BalanceoException('Prueba guardar throw');
                BalanceoNSCWS.ArrayOfPedido pedidosWS = new BalanceoNSCWS.ArrayOfPedido();
                WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_ReqLista pedidosSAPWS = new WsABCPeidosSFSAP.ArrayOfDT_SE_ABCPedidos_ReqLista();
                
               
                pedidosWS.pedido = new List<PedidoInsertNSCWS.Pedido>();
                pedidosSAPWS.DT_SE_ABCPedidos_ReqLista = new List<ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista>();
               
                for(Id idP : pedidos2Send){
                    PedidoUtils pu = pwcMap.get(idP);
                    Decimal importe = 0; 

                    for(Integer i=0; i < pu.pedidoWrapper.pedidoItemList.size(); i++) {
                        pedidoExternoExecutado = pu.pedidoWrapper.pedido.Numero_de_Pedido_NSC__c;
                        PedidoItem__c valItem = pu.pedidoWrapper.pedidoItemList[i];
                        if(mapItemBalanceo.containsKey(valItem.Id)){
                        	if(valItem.Cajas_Balanceadas__c==null){
	                            valItem.Cantidad_Balanceada_Unidad_de_Movimiento__c = valItem.CantidadConfirmadaUnidadMovimiento__c;
	                            valItem.Cajas_Balanceadas__c = valItem.Cajas_Conf__c;
	                            valItem.Piezas_Balanceadas__c = valItem.Piezas__c;
	                            valItem.Kilos_Balanceados__c = valItem.Kilos_Conf__c;// Sin relaciones
	                        }
                            //Nuevo valor capturado
                            valItem.Cajas_Conf__c = mapItemBalanceo.get(valItem.Id);
                            
                            valItem = pu.externalSources.calculaEnBaseACajasConf(valItem);
                            valItem = pu.externalSources.calculaImporte(valItem,true);
                            pu.pedidoWrapper.pedidoItemList[i] = valItem;
                        }
                        importe+= valItem.Importe__c;
                    }
                    pu.pedidoWrapper.importe = importe;
                    pu.pedidoWrapper.setPedidoData();
                    System.debug(pu.pedidoWrapper);
                    System.debug(pu.accountWrapper);
                    
                    PedidoInsertNSCWS.Pedido pedido = pu.externalSources.setPedidoWS(pu.pedidoWrapper,pu.accountWrapper,false);
                    pedidosWS.pedido.add(pedido);
                   
                    ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_ReqLista pedidoSAP = pu.externalSources.setPedidoSAPWS(pu.pedidoWrapper,pu.accountWrapper,true);
                    pedidosSAPWS.DT_SE_ABCPedidos_ReqLista.add(pedidoSAP);
                }
               
                
                if(!operaEnSap)
                	resp = externalSources.syncPedido(pedidosWS, codigoOficinaVenta); 
                else
                {
                	
                	resp2 = externalSources.syncPedidoSAP(pedidosSAPWS);  
                }
              
                if(resp !=null || (resp2 != null ) ){
                    //Parse Resp
                    //Guardar Cambios
                     List<Pedido__c> updPedidos = new List<Pedido__c>();
	                 List<PedidoItem__c> updPedidoItems = new List<PedidoItem__c>();
                    if(!operaEnSap){
	                   
	                    for(PedidoUtils pu : pwcMap.values()){
	                        updPedidos.add(pu.pedidoWrapper.pedido);
	                        for(PedidoItem__c pi : pu.pedidoWrapper.pedidoItemList){
	                            if(mapItemBalanceo.containsKey(pi.Id)){
	                                updPedidoItems.add(pi);
	                            }
	                        }
	                    }
                    }
                    else{
                    	
                    	Map<string,PedidoUtils> pedidosAGrabar = new Map<string,PedidoUtils>();
	                    for(PedidoUtils pu : pwcMap.values()){
	                    	pedidosAGrabar.put(pu.pedidoWrapper.pedido.Numero_Pedido_SAP__c,pu);
	                    }
	                    //system.debug('respuesta '+ resp2.DT_SE_ABCPedidos_RespPedido);
	                    for( ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido r : resp2.DT_SE_ABCPedidos_RespPedido)
	                 	{
	                 		if(r.TipoMensaje == 'S')
	                 		 {
                 		 	
	                 		 	updPedidos.add(pedidosAGrabar.get(r.FolioPedidoSAP).pedidoWrapper.Pedido);
		                        for(PedidoItem__c pi : pedidosAGrabar.get(r.FolioPedidoSAP).pedidoWrapper.pedidoItemList){
		                            if(mapItemBalanceo.containsKey(pi.Id)){
		                                updPedidoItems.add(pi);
		                            }
		                        }
	                 		 }
	                 		 else{
	                 		 	   //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, r.mensaje));
	                 		 	   return respuesta = r.mensaje;
	                 		 	   
	                 		 }
	                 	}
	                 		
	                     
                    }
                    Savepoint savepoint = Database.setSavepoint();
                    try{
                    	if(updPedidos.size() > 0){
	                        update updPedidos;
	                        update updPedidoItems;
	                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Se guardo el balanceo'));
	                        respuesta = 'ok';
                    	}
                    }catch(Exception e){
                        System.debug(e.getStackTraceString());
                        respuesta = 'No se guardo el balanceo, Message: '+ e.getMessage();
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, respuesta));
                        Database.rollback(savepoint);
                    }
                }
                 else{ 
	                 	 if(operaEnSap){
	                 		for( ABCPedidos_SF_to_ECC.DT_SE_ABCPedidos_RespPedido r : resp2.DT_SE_ABCPedidos_RespPedido)
	                 		{
	                 			 respuesta += r.Mensaje+' ';
	                 		}
	                 		 system.debug('tizoc resp2 --------------------> '+ respuesta);
	                 	 }
                     }
            }
            else{
            	// ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, respuesta));
            	 system.debug('tizoc resp2 --------------------> '+ resp2);
            	 respuesta = 'No se guardo el balanceo, Message: ' + resp !=null ?resp.Mensaje : resp2.DT_SE_ABCPedidos_RespPedido[0].Mensaje;
                //throw new BalanceoException('No se balanceo ningun pedido');
            }
        }catch(BalanceoException e){
            //Database.rollback(savepoint);
            System.debug(e.getStackTraceString());
            if(pedidoExternoExecutado != null || pedidoExternoExecutado != '')
            {
            	respuesta = e.getMessage()+ ' Pedido ' + pedidoExternoExecutado;
            }else
            	respuesta = e.getMessage();//+ ' Pedido ' + pedidoExternoExecutado;
            	
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,respuesta));
        }catch(Exception e){
            //Database.rollback(savepoint);
            System.debug(e.getStackTraceString());
            respuesta = PedidoUtils.PEDIDO_WEB_SERVICE_ERROR+e.getMessage()+ ' Pedido ' + pedidoExternoExecutado;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,respuesta));
        }
          system.debug('tizoc --------------------> '+ respuesta);
        return respuesta;
    }

    public static ListaPreciosQueryNSCWS.ArrayOfPreciosXCliente listClientesLP(Map<Id,Set<String>> mapProdCliente, List<Pedido__c> pl, Map<Id, Account> mapCuentas){
        ListaPreciosQueryNSCWS.ArrayOfPreciosXCliente req = new ListaPreciosQueryNSCWS.ArrayOfPreciosXCliente();
        ListaPreciosQueryNSCWS.PreciosXCliente[] preciosCliente = new List<ListaPreciosQueryNSCWS.PreciosXCliente>();
        for(Pedido__c p : pl){
            ListaPreciosQueryNSCWS.PreciosXCliente item = setCuentaPXC(mapCuentas.get(p.Cuenta__c));
            item.fecDoc = String.valueOf(p.Fecha_Registro__c).left(10).replaceAll('-', '');
            item.producto = generaProductosPorCliente(mapProdCliente.get(p.Cuenta__c));
            preciosCliente.add(item);
        }
        req.PreciosXCliente = preciosCliente;
        return req;
    }

    public static Map<Id, Product2> getProduct2General(List<String> productCodeList){
        return new Map<Id, Product2>([
                SELECT Description, Ficha_comercial__c, Name, Peso_Promedio__c, ProductCode
                FROM Product2
                WHERE ProductCode IN :productCodeList
            ]);
    }

    public static ListaPreciosQueryNSCWS.ArrayOfProducto generaProductosPorCliente(Set<String> proCodes){
        ListaPreciosQueryNSCWS.ArrayOfProducto producto = new ListaPreciosQueryNSCWS.ArrayOfProducto();
        producto.producto = new List<ListaPreciosQueryNSCWS.producto>();

        for(String item : proCodes){
            ListaPreciosQueryNSCWS.producto p = new ListaPreciosQueryNSCWS.producto();
            p.codigo = item;
            producto.producto.add(p);
        }
        return producto;
    }

    public static  Set<String> getGruposVendedoresPedidos(ListaPreciosQueryNSCWS.ArrayOfPreciosXCliente listClientesLPRef){
        Set<String> setGrupos = new Set<String>();
        if(listClientesLPRef.PreciosXCliente!=null){
            for(ListaPreciosQueryNSCWS.PreciosXCliente itemCliente : listClientesLPRef.PreciosXCliente){
                if(itemCliente.gpoVendedores!=null && itemCliente.gpoVendedores!=''){
                    setGrupos.add(itemCliente.gpoVendedores);
                }
            }
        }
        return setGrupos;
    }

    public static Map<String,List<Gpo_Vendedores_Oficina_de_Ventas__c>> getGruposVendedoresPedidosBySet(Set<String> grupos){
        Map<String,List<Gpo_Vendedores_Oficina_de_Ventas__c>> resp = new Map<String,List<Gpo_Vendedores_Oficina_de_Ventas__c>>();
        for(Gpo_Vendedores_Oficina_de_Ventas__c item :[
                SELECT Oficina_de_Venta__r.Name, Grupo_de_Vendedores__r.Codigo__c
                FROM Gpo_Vendedores_Oficina_de_Ventas__c
                WHERE Grupo_de_Vendedores__r.Codigo__c IN :grupos
                ORDER BY Name
            ]){
            if(!resp.containsKey(item.Grupo_de_Vendedores__r.Codigo__c)){
                resp.put(item.Grupo_de_Vendedores__r.Codigo__c, new List<Gpo_Vendedores_Oficina_de_Ventas__c>());
            }
            resp.get(item.Grupo_de_Vendedores__r.Codigo__c).add(item);
        }
        for(String item : grupos){
            if(!resp.containsKey(item)){
                resp.put(item, new List<Gpo_Vendedores_Oficina_de_Ventas__c>());
            }
        }
        return resp;
    }

    public static ListaPreciosQueryNSCWS.PreciosXCliente setCuentaPXC(Account account) { //Validar cambios en setExtensionVariables en PedidoUtils
        ListaPreciosQueryNSCWS.PreciosXCliente item = new ListaPreciosQueryNSCWS.PreciosXCliente();
        System.debug(account);
        System.debug(account.Parent);
        item.cliente = String.valueOf(Integer.valueOf(account.Parent.Numero_Cliente_SAP__c));
        item.gpoVendedores = getSAPCode(account.Territorio__c);
        item.ofiVentas = getSAPCode(account.Canal_Padre__c);
        item.orgVentas = getSAPCode(account.Organizacion_de_Ventas__c);
        item.canal = getSAPCode(account.Canal_Distribucion__c);
        item.destinatario = account.Numero_Cliente_SAP__c.replace('SUC - ', '');
        item.cluster = getSAPCode(account.Ramo__c);
        item.cadena = getSAPCode(account.Cadena__c);
        return item;
    }

    public static String getSAPCode(String picklistValue) {
        return String.isNotBlank(picklistValue) ? (picklistValue.contains(' - ') ? picklistValue.substring(picklistValue.indexOf(' - ')+3, picklistValue.length()) : picklistValue) : null;
    }

    public class ProductoWrapper {
        public Product2 producto {get;set;}
        public List<Pedido__c> pedidos {get;set;}
        public Map<Id, PedidoItem__c> itemXPedido {get;set;}
        public Decimal solicitado {get;set;}
        public Decimal confirmado {get;set;}
        public Decimal balanceado {get;set;}
        public Double disponible {get;set;}
        public Decimal diferencia {get;set;}
        public Decimal anterior   {get;set;}
        public Decimal posterior  {get;set;}
        public Integer tipoManejoInventario  {get;set;}
        
        public ProductoWrapper() {
            pedidos = new List<Pedido__c>();
            itemXPedido = new Map<Id, PedidoItem__c>();
            solicitado = 0;
            confirmado = 0;
            balanceado = 0;
            disponible = 0;
            diferencia = 0;
            anterior   = 0;
            posterior  = 0;
            tipoManejoInventario = 0;
        }

        public Set<String> getPedidosIds(){
            Set<String> setIds = new Set<String>();
            if(pedidos!=null){
                for(Pedido__c p : pedidos){
                    setIds.add(p.Id);
                }
            }
            return setIds;
        }

        public Set<String> getAccountsIds(){
            Set<String> setIds = new Set<String>();
            if(pedidos!=null){
                for(Pedido__c p : pedidos){
                    if(p.Cuenta__c!=null){
                        setIds.add(p.Cuenta__c);
                    }
                }
            }
            return setIds;
        }
    }
 
    public class BalanceoException extends Exception {}
}