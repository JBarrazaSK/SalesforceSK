/*******************************************************************************
Copyright © 2016 Lynx9. All rights reserved. 
Author: Jorge Teran
Email: sf@lynx9.com
Description: Factura__c daily deletion.
********************************************************************************/
public class ctrlDeleteFacturas { 
    
    public void deleteAllFacturas() {

        String resultado = '';
        Integer b = 0;
        AccountTrigger.InactivarTrigger = true;
        PedidoParameters__c parametros = PedidoParameters__c.getInstance();

        LIST<Factura__c> facs = [SELECT Id FROM Factura__c WHERE Cliente_SAP__c != '' LIMIT : Integer.ValueOf(parametros.Limite_Registros__c)];
        try{
        		if( facs == null )
                	delete facs;
               
            }
            catch( DmlException de ) {
                System.debug('ERROR: ' + de.getMessage());
                
            }
            
        delete facs;
        AccountTrigger.InactivarTrigger = false;
        
        /*for( LIST<Factura__c> facs: [SELECT Id FROM Factura__c WHERE Cliente_SAP__c != '' LIMIT 5000] ) {
            if( facs == null ) { break; }
            
            try{
                delete facs;
                resultado = resultado + 'Bloque: ' + String.valueOf(b) + ' Resultado: Exitoso \n';
            }
            catch( DmlException de ) {
                System.debug('ERROR: ' + de.getMessage());
                resultado = resultado + 'Bloque: ' + String.valueOf(b) + ' Resultado: Falló \n';
            }
            b++;
        }
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'sf@lynx9.com'};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Borrado de Facturas!! ');
        mail.setPlainTextBody
            ('Resumen de Operación: \n' + resultado);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
    }
}