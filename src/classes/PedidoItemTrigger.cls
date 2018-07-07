/**
 * Description: PedidoItem sObject trigger methods.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 10/12/2014
 **/
public class PedidoItemTrigger {
    
    public static void sumarizaInformacionDePedidoItemDeProspecto(Map<Id, PedidoItem__c> pedidoItemMap) {
        Set<Id> leadIdSet = new Set<Id>();
        for(PedidoItem__c pedidoItem : [
            SELECT Pedido__r.Prospecto__c
            FROM PedidoItem__c
            WHERE Pedido__r.Prospecto__c != null
                AND Id IN :pedidoItemMap.keySet()
        ]) {
            leadIdSet.add(pedidoItem.Pedido__r.Prospecto__c);
        }
        if(!leadIdSet.isEmpty()) {
            Map<Id, Lead> leadMap = new Map<Id, Lead>();
            Map<Id, List<Pedido__c>> pedidoListXleadIdMap = new Map<Id, List<Pedido__c>>();
            Map<Id, Map<Id, PedidoItem__c>> pedidoItemMapXpedidoIdMap = new Map<Id, Map<Id, PedidoItem__c>>();
            for(PedidoItem__c pedidoItem : [
                SELECT Kilos_Conf__c,
                    Pedido__r.Prospecto__c,
                    Producto__r.Name
                FROM PedidoItem__c
                WHERE Pedido__r.Prospecto__c != null
                    AND Pedido__r.Prospecto__r.IsConverted = false
                    AND Producto__c != null
                    AND Pedido__r.Prospecto__c IN :leadIdSet
            ]) {
                if(!leadMap.containsKey(pedidoItem.Pedido__r.Prospecto__c)) {
                    leadMap.put(pedidoItem.Pedido__r.Prospecto__c, new Lead(
                        Id = pedidoItem.Pedido__r.Prospecto__c,
                        Kg_de_Ventas__c = 0,
                        Numero_de_Ventas_Prospecto__c = 0,
                        Productos_Vendidos__c = ''
                    ));
                }
                if(!pedidoListXleadIdMap.containsKey(pedidoItem.Pedido__r.Prospecto__c)) {
                    pedidoListXleadIdMap.put(pedidoItem.Pedido__r.Prospecto__c, new List<Pedido__c>());
                }
                pedidoListXleadIdMap.get(pedidoItem.Pedido__r.Prospecto__c).add(pedidoItem.Pedido__r);
                if(!pedidoItemMapXpedidoIdMap.containsKey(pedidoItem.Pedido__c)) {
                    pedidoItemMapXpedidoIdMap.put(pedidoItem.Pedido__c, new Map<Id, PedidoItem__c>());
                }
                pedidoItemMapXpedidoIdMap.get(pedidoItem.Pedido__c).put(pedidoItem.Id, pedidoItem);
            }
            for(Lead lead : leadMap.values()) {
                lead.Numero_de_Ventas_Prospecto__c = pedidoListXleadIdMap.get(lead.Id).size();
                for(Pedido__c pedido : pedidoListXleadIdMap.get(lead.Id)) {
                    for(PedidoItem__c pedidoItem : pedidoItemMapXpedidoIdMap.get(pedido.Id).values()) {
                        if(!lead.Productos_Vendidos__c.contains(pedidoItem.Producto__r.Name)) {
                            lead.Productos_Vendidos__c += pedidoItem.Producto__r.Name+'/';
                            if(pedidoItem.Kilos_Conf__c != null) {
                                lead.Kg_de_Ventas__c += pedidoItem.Kilos_Conf__c;
                            }
                        }
                    }
                }
                if(lead.Productos_Vendidos__c.length() > 0) {
                    lead.Productos_Vendidos__c = lead.Productos_Vendidos__c.left(lead.Productos_Vendidos__c.length()-1);
                }
            }
            Database.update(leadMap.values(), false);
        }
    }
}