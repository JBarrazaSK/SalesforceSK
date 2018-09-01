public with sharing class  ctrlMigrarPedidos {

	public pedido__c pedido {get; set;}
	public String CodigoAlmacen {get; set;}
    public String NombreAlmacen {get; set;}
    public Id AlmacenId {get; set;}
    public String Display{get; set;}
    public list<pedido__c> Listapedidos {get; set;}
    public Map<String, Oficina_de_Venta__c> MapAlmacenes {
        get {
            if(MapAlmacenes == null) {

                MapAlmacenes = CtrlArmarEmbarqueDAO.getOficinaVentas();
             }
            return MapAlmacenes;
        }
        set;
    }
    
    public void getPedidos()
    {
    	listapedidos = [select id,name,Fecha_de_Entrega__c,ClienteSap__c,Pedido_Cliente__c,Cuenta__c,Cuenta__r.name,Numero_de_Pedido_NSC__c,Numero_Pedido_SAP__c,OficinaVentas__r.name from pedido__c 
						where 
						Pedido_Cancelado__c = false
						and PedidoRechazado__c = false
						and OficinaVentas__c =: AlmacenId
						and Fecha_de_Entrega__c >= today
						and Fecha_de_Entrega__c  <= NEXT_N_DAYS: 5];
    }
}