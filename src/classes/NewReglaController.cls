public with sharing class NewReglaController {
    
    public ReglaNew__c regla { get; set; }

    public List<SelectOption> familiaList { get; private set; }
    
    public NewReglaController(ApexPages.StandardController controller) {
        
        Id reglaId = controller.getId();
        if(reglaId != null) {
            regla = [
                SELECT Name,Descripcion__c,Programa_de_Lealtad__c,Puntos_a_Otorgar__c,Importe__c,Producto__c,Familia_de_Producto__c
                FROM ReglaNew__c
                WHERE Id = :reglaId
            ];
        } else {
            regla = new ReglaNew__c();
        }
        
        familiaList = new List<SelectOption>();
        familiaList.add(new SelectOption('None', '--None--'));
        for(AggregateResult prod : [SELECT Family FROM Product2 GROUP BY ROLLUP (Family) ORDER BY Family]) {
            String family = (String)prod.get('Family');
            if (family != null){
                familiaList .add(new SelectOption(family, family));
            }
        }
    }
    
    public PageReference guarda() {
        
        if (regla.Familia_de_Producto__c == 'None') {
            regla.Familia_de_Producto__c = null;
        }

        Savepoint sp = Database.setSavepoint();
        try {
            upsert regla;
            return new PageReference('/'+regla.Id);
        } catch(Exception e) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        
        return null;
    }
    
    public PageReference cancela() {
        return new PageReference('/' + ReglaNew__c.SObjectType.getDescribe().getKeyPrefix() + '/o');
    }
}