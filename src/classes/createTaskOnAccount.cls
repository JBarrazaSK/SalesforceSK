public class createTaskOnAccount {
    
    public Account cliente  {get; set;}
    public Task cobranza    {get; set;}

    public createTaskOnAccount( ApexPages.StandardController controller ) {
        cliente = (Account) controller.getRecord();
        if( cliente != null ) {
            cobranza = new Task();
                cobranza.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tareas de Cobranza').getRecordTypeId();
            	cobranza.OwnerId = System.UserInfo.getUserId();
                cobranza.Status = 'En Progreso';
                cobranza.Priority = 'Normal';
            if( cliente.Id != null ) {
            	this.completeAccountInfo();
                
                cobranza.WhatId = cliente.Id;
            	cobranza.Telefono_1__c = cliente.Telefono__c;
            	cobranza.Telefono_2__c = cliente.Celular__c;
            	cobranza.Telefono_3__c = cliente.Fax__c;
            	cobranza.Telefono_4__c = cliente.Telefono_Adicional__c;
        	}
        }
    }
    
    public PageReference createTask() {
        
        try {
            insert cobranza;
        }
        catch( DmlException e ) {
            System.debug('ERROR: ' +e.getMessage());
            return null;
        }
        
        try {
            //if( cobranza.Conexion__c == 'Contacto' ) {
                Account acc = new Account(Id=cobranza.WhatId, Monto_Compromiso_de_Pago__c=cobranza.Monto_Compromiso_de_Pago__c, Fecha_Compromiso_de_Pago__c=cobranza.ActivityDate, Ultimo_dia_de_gestion__c=System.today());
                update acc;
            //}
        }
        catch(Exception e) {
            System.debug('ERROR: ' +e.getMessage());
        }
        
        PageReference pref = new PageReference('/apex/vfpCreateTaskOnAccount');
            pref.setRedirect(true);
        return pref;
    }
    
    private void completeAccountInfo() {
        cliente = [SELECT Id, Telefono__c, Telefono_Adicional__c, Telefono_Adicional_Contacto__c, Telefono_Contacto__c, Celular__c, Fax__c 
                   FROM Account WHERE Id =: cliente.Id];
    }
}