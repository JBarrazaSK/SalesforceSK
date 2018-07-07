/**
 * Description: Opportunity sObject trigger methods.
 * Author: Jorge Terán
 * Company: LYNX9
 * Email: sf@lynx9.com
 * Created date: 10/03/2016
 **/
public class PedidoItemTriggerGINSA {
    
    public static void sumarizaInformacionDePedidoItemDeProspecto(Map<Id, OpportunityLineItem> pedidoItemMap) {
        Set<Id> leadIdSet = new Set<Id>();
        for(OpportunityLineItem pedidoItem : [
            SELECT Opportunity.Prospecto__c
            FROM OpportunityLineItem
            WHERE Opportunity.Prospecto__c != null
                AND Id IN :pedidoItemMap.keySet()
        ]) {
            leadIdSet.add(pedidoItem.Opportunity.Prospecto__c);
        }
        if(!leadIdSet.isEmpty()) {
            Map<Id, Lead> leadMap = new Map<Id, Lead>();
            Map<Id, List<Opportunity>> pedidoListXleadIdMap = new Map<Id, List<Opportunity>>();
            Map<Id, Map<Id, OpportunityLineItem>> pedidoItemMapXpedidoIdMap = new Map<Id, Map<Id, OpportunityLineItem>>();
            for(OpportunityLineItem pedidoItem : [
                SELECT Kilos_Conf__c,
                    Opportunity.Prospecto__c,
                    OpportunityLineItem.Product2.Name
                FROM OpportunityLineItem
                WHERE Opportunity.Prospecto__c != null
                    AND Opportunity.Prospecto__r.IsConverted = false
                    AND OpportunityLineItem.Product2.ProductCode != null
                    AND Opportunity.Prospecto__c IN :leadIdSet
            ]) {
                if(!leadMap.containsKey(pedidoItem.Opportunity.Prospecto__c)) {
                    leadMap.put(pedidoItem.Opportunity.Prospecto__c, new Lead(
                        Id = pedidoItem.Opportunity.Prospecto__c,
                        Kg_de_Ventas__c = 0,
                        Numero_de_Ventas_Prospecto__c = 0,
                        Productos_Vendidos__c = ''
                    ));
                }
                if(!pedidoListXleadIdMap.containsKey(pedidoItem.Opportunity.Prospecto__c)) {
                    pedidoListXleadIdMap.put(pedidoItem.Opportunity.Prospecto__c, new List<Opportunity>());
                }
                pedidoListXleadIdMap.get(pedidoItem.Opportunity.Prospecto__c).add(pedidoItem.Opportunity);
                if(!pedidoItemMapXpedidoIdMap.containsKey(pedidoItem.OpportunityId)) {
                    pedidoItemMapXpedidoIdMap.put(pedidoItem.OpportunityId, new Map<Id, OpportunityLineItem>());
                }
                pedidoItemMapXpedidoIdMap.get(pedidoItem.OpportunityId).put(pedidoItem.Id, pedidoItem);
            }
            for(Lead lead : leadMap.values()) {
                lead.Numero_de_Ventas_Prospecto__c = pedidoListXleadIdMap.get(lead.Id).size();
                for(Opportunity pedido : pedidoListXleadIdMap.get(lead.Id)) {
                    for(OpportunityLineItem pedidoItem : pedidoItemMapXpedidoIdMap.get(pedido.Id).values()) {
                        if(!lead.Productos_Vendidos__c.contains(pedidoItem.Product2.Name)) {
                            lead.Productos_Vendidos__c += pedidoItem.Product2.Name+'/';
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