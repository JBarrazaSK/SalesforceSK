/*Christian Mora
*/



global without sharing class OficinaDistributionChannel {
    
    public Account containerAccount{get;set;}  
    public List<wwwSukarneComWsSalesforce.InventarioGlobal> inventarioGlobalList {get;set;}
    public List<wwwSukarneComWsSalesforce.InventarioGlobal> inventarioGlobalListTEMP {get;set;}
    public Boolean isValidResult {get;set;}
    
    // Constructor
    public OficinaDistributionChannel(){
        containerAccount = new Account();
        inventarioGlobalList = new List<wwwSukarneComWsSalesforce.InventarioGlobal>();
        inventarioGlobalListTEMP = new List<wwwSukarneComWsSalesforce.InventarioGlobal>();
        isValidResult = false;
    }
    
    /* 
@Purpose :  Call the webservice with Canal value of selected distribution channel
*/
    public void performCallout(){
        
        // Clear previous results
        inventarioGlobalList.clear();
        inventarioGlobalListTEMP.clear();
        // Get the selected distribution channel value from page
        Oficina_de_Venta__c distributionChannel = new Oficina_de_Venta__c();
        
        try{
            distributionChannel = [SELECT Codigo__c,Opera_en_SAP__c FROM Oficina_de_Venta__c 
                                   WHERE Id =: containerAccount.Oficina_de_Ventas__c];
        }
        catch(Exception e){
            System.debug('Excepción en el canal de distribución ir a buscar : ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
        }
        
        // Check if Codigo__c field is not null
        if(distributionChannel != null && distributionChannel.Codigo__c != null){
            wwwSukarneComWsSalesforce.DisponibilidadInventarioSoap controller = new wwwSukarneComWsSalesforce.DisponibilidadInventarioSoap();
            DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp responseSAP;
            wwwSukarneComWsSalesforce.RespuestaOfListOfInventarioGlobal response; 
              
            try{
               
		            if(distributionChannel.Opera_en_SAP__c)
		            {
		            	responseSAP = 	retrieveInventarioSap(Integer.valueOf(distributionChannel.Codigo__c));
		            	system.debug('response: -------------------> '+ responseSAP);
		            	if(responseSAP != null && responseSAP.TipoMensaje =='S') 
		            	{
		            		set<string> setProductos = new set<string>();
		            		ProductoInventarioQueryNSCWS.Inventario invt = null;
			                for(DisponibilidadInventarioSAP.Informacion_element inventarioSAP : responseSAP.Informacion) {
			                    if(inventarioSAP.NumeroProducto != null) {
			                    	setProductos.add(inventarioSAP.NumeroProducto);
			                    	wwwSukarneComWsSalesforce.InventarioGlobal inventerio = new wwwSukarneComWsSalesforce.InventarioGlobal();
			                    	system.debug('inventarioSAP: '+inventarioSAP);
			                    	inventerio.Producto = Integer.ValueOf(inventarioSAP.NumeroProducto.trim());
			                    	inventerio.InvActual = inventarioSAP.InventarioActual == null?0:Double.ValueOf(inventarioSAP.InventarioActual);
			                    	inventerio.ProductoDesc = '0';
			                    	inventerio.CompAlmHoy = inventarioSAP.ComprometidoAlmacenHoy == null?0:Double.ValueOf(inventarioSAP.ComprometidoAlmacenHoy);
			                    	inventerio.CompAlmMan = inventarioSAP.ComprometidoAlmacenManana == null?0:Double.ValueOf(inventarioSAP.ComprometidoAlmacenManana);
			                    	inventerio.DispAlm = inventarioSAP.DisponibilidadAlmacen == null?0:Double.ValueOf(inventarioSAP.DisponibilidadAlmacen);
			                    	inventerio.InvConf = inventarioSAP.InventarioConfigurado == null?0:Double.ValueOf(inventarioSAP.InventarioConfigurado);
			                    	inventerio.CompConfMan = inventarioSAP.ComprasConfigManana == null?0:Double.ValueOf(inventarioSAP.ComprasConfigManana);
			                    	inventerio.DispConf = Integer.ValueOf(inventarioSAP.NumeroProducto.trim());
			                    	inventerio.ResAlm = inventarioSAP.ResAlm == null?0:Double.ValueOf(inventarioSAP.ResAlm);
			                    	inventerio.ResConf = inventarioSAP.ResConf == null?0:Double.ValueOf(inventarioSAP.ResConf);
			 
				                    inventarioGlobalListTEMP.add(inventerio);
				                    isValidResult = true;
			                    }
			                }
			                if(setProductos != null && setProductos.size() > 0)
			                {
			                	map<string,string> mapDescripcionProducto = ObtenerDescripcionProducto(setProductos);
			                	for(wwwSukarneComWsSalesforce.InventarioGlobal inv : inventarioGlobalListTEMP)
			                	{
			                		if(mapDescripcionProducto.containsKey(string.ValueOf(inv.Producto)))
			                		{
					                	inv.ProductoDesc = mapDescripcionProducto.get(string.ValueOf(inv.Producto));
				                		inventarioGlobalList.add(inv);
			                		}
			                	}
			                }
			                
			            }
			            else 
			            {
			            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, PedidoUtils.INVENTARIO_WEB_SERVICE_NO_DATA_ERROR));
			            }	
		            }else
		            {
		            	 response = controller.RegresaDisponibilidadGlobal(Integer.valueOf(distributionChannel.Codigo__c));
		            }
            }
            catch(Exception e){
  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Excepción en la llamada de servicio web!'));
                isValidResult = false;
            }
            
            if(response != null && response.Datos != null){
                for(wwwSukarneComWsSalesforce.InventarioGlobal inventerio : response.Datos.InventarioGlobal){
                    inventarioGlobalList.add(inventerio);
                    isValidResult = true;
                }
            }
           /* else if(response != null && response.Datos != null || responseSAP != null){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Por favor, seleccione el canal de distribución válida!'));
                isValidResult = false;
            }*/
        }
        else{
            // Add message 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,
                                                       'Codigo__c campo está en blanco para el canal de distribución seleccionada!' +
                                                       'Por favor, seleccione el canal de distribución válida.'));  
            isValidResult = false;                                           
            
        }
    }
    public  map<string,string> ObtenerDescripcionProducto(set<string> setProductos)
    {
    	map<string,string> mapDescripcionProducto = new map<string,string>();
    	for(product2 p : [select ProductCode,Description from product2 where ProductCode IN : setProductos])
    	{
    		mapDescripcionProducto.put(p.ProductCode,p.Description);
    	}
    	return mapDescripcionProducto;
    }
    private DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Resp retrieveInventarioSap(Integer canal) {
            
            WSDisponibilidadInventarioSAP.DisponibilidadInventarioSAPSoap servicio = new WSDisponibilidadInventarioSAP.DisponibilidadInventarioSAPSoap();
            DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Req request = new DisponibilidadInventarioSAP.DT_SE_DisponibilidadInventario_Req();
       		//r7equest.NumeroClienteSap =  String.ValueOf(cliente);
	        //7request.SucursalSap = String.ValueOf(sucursal);
	        //request.TipoSurtido = String.ValueOf(tipoSurtido);
            //request.OrdenCompra = ordenCompra;
	        request.Canal = String.ValueOf(canal);
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
}