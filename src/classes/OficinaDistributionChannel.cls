/*Christian Mora
*/



global without sharing class OficinaDistributionChannel {
    
    public Account containerAccount{get;set;}
    public List<wwwSukarneComWsSalesforce.InventarioGlobal> inventarioGlobalList {get;set;}
    public Boolean isValidResult {get;set;}
    
    // Constructor
    public OficinaDistributionChannel(){
        containerAccount = new Account();
        inventarioGlobalList = new List<wwwSukarneComWsSalesforce.InventarioGlobal>();
        isValidResult = false;
    }
    
    /* 
@Purpose :  Call the webservice with Canal value of selected distribution channel
*/
    public void performCallout(){
        
        // Clear previous results
        inventarioGlobalList.clear();
        
        // Get the selected distribution channel value from page
        Oficina_de_Venta__c distributionChannel = new Oficina_de_Venta__c();
        
        try{
            distributionChannel = [SELECT Codigo__c FROM Oficina_de_Venta__c 
                                   WHERE Id =: containerAccount.Oficina_de_Ventas__c];
        }
        catch(Exception e){
            System.debug('Excepción en el canal de distribución ir a buscar : ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
        }
        
        // Check if Codigo__c field is not null
        if(distributionChannel != null && distributionChannel.Codigo__c != null){
            wwwSukarneComWsSalesforce.DisponibilidadInventarioSoap controller = new wwwSukarneComWsSalesforce.DisponibilidadInventarioSoap();
            
            wwwSukarneComWsSalesforce.RespuestaOfListOfInventarioGlobal response;
            
            try{
                response = controller.RegresaDisponibilidadGlobal(Integer.valueOf(distributionChannel.Codigo__c));
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
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Por favor, seleccione el canal de distribución válida!'));
                isValidResult = false;
            }
        }
        else{
            // Add message 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,
                                                       'Codigo__c campo está en blanco para el canal de distribución seleccionada!' +
                                                       'Por favor, seleccione el canal de distribución válida.'));  
            isValidResult = false;                                           
            
        }
    }
}