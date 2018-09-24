/**
 * Description: CarteraCliente.page controller class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 11/08/2014
 **/
public with sharing class CarteraClienteController {
    
    public CarteraClienteQueryNSCWS.Cartera cartera { get; set; }
    public Account account { get; set; }
    
    private static final Integer MAX_CALLOUT_RETRIES = 3;
    private static final Integer WEB_SERVICE_TIMEOUT = 20000;
    private static final String CARTERACLIENTE_WEB_SERVICE_ERROR = 'Error al obtener el inventario de productos. Mensaje: ';
    private static final String CARTERACLIENTE_WEB_SERVICE_NO_DATA_ERROR = 'El servicio web de consulta de cartera de cliente no ha devuelto datos.';
    
    private class CustomException extends Exception {}
    
    public CarteraClienteController(ApexPages.StandardController controller) {
        queryAccount(controller.getId());
        if(isValidAccount()) {
            String orgVenta = account.Organizacion_de_Ventas__c.trim();
            orgVenta = orgVenta.right(4);
            system.debug('PARAMETROS=> ' +Integer.valueOf(account.Parent.Numero_Cliente_SAP__c)+' - '+Integer.valueOf(account.Parent.Canal_de_Distribucion_NSC__r.Codigo__c)+' - '+orgVenta );
            cartera = account.ParentId == null ? retrieveCarteraCliente(Integer.valueOf(account.Numero_Cliente_SAP__c), Integer.valueOf(account.Canal_de_Distribucion_NSC__r.Codigo__c), orgVenta) : retrieveCarteraCliente(Integer.valueOf(account.Parent.Numero_Cliente_SAP__c), Integer.valueOf(account.Parent.Canal_de_Distribucion_NSC__r.Codigo__c), orgVenta);
            system.debug('Cartera: '+ cartera);
            account.Pagare__c = cartera.PagoCheque;
        }
    }
    
    private void queryAccount(Id accountId) {
        account = [
            SELECT Numero_Cliente_SAP__c,
                Organizacion_de_Ventas__c,
                Canal_de_Distribucion_NSC__r.Codigo__c,
                Parent.Numero_Cliente_SAP__c,
                Parent.Canal_de_Distribucion_NSC__r.Codigo__c
            FROM Account
            WHERE Id = :accountId
        ];
        account.Pagare__c = false;
    }
    
    private Boolean isValidAccount() {
        String numeroClienteSAPLabel = SObjectType.Account.Fields.Numero_Cliente_SAP__c.getLabel();
        String canalDeDistribucionNSCLabel = SObjectType.Account.Fields.Canal_de_Distribucion_NSC__c.getLabel();
        String canalDeDistribucionNSCCodigoLabel = canalDeDistribucionNSCLabel+': '+SObjectType.Canal_de_Distribucion_NSC__c.Fields.Codigo__c.getLabel();
        String parentIdLabel = SObjectType.Account.Fields.ParentId.getLabel();
        List<String> missingFieldList = new List<String>();
        if(account.Parent == null) {
            if(String.isBlank(account.Numero_Cliente_SAP__c)) missingFieldList.add(numeroClienteSAPLabel);
            if(String.isBlank(account.Canal_de_Distribucion_NSC__c)) missingFieldList.add(canalDeDistribucionNSCLabel);
            else if(String.isBlank(account.Canal_de_Distribucion_NSC__r.Codigo__c)) missingFieldList.add(canalDeDistribucionNSCCodigoLabel);
        } else {
            if(String.isBlank(account.Parent.Numero_Cliente_SAP__c)) missingFieldList.add(parentIdLabel+': '+numeroClienteSAPLabel);
            if(String.isBlank(account.Parent.Canal_de_Distribucion_NSC__c)) missingFieldList.add(parentIdLabel+': '+canalDeDistribucionNSCLabel);
            else if(String.isBlank(account.Parent.Canal_de_Distribucion_NSC__r.Codigo__c)) missingFieldList.add(parentIdLabel+': '+canalDeDistribucionNSCCodigoLabel);
        }
        if(!missingFieldList.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Faltan datos de la cuenta para obtener la información de cartera ('+String.join(missingFieldList, ', ')+')'));
        }
        return !ApexPages.hasMessages();
    }
    
    private CarteraClienteQueryNSCWS.Cartera retrieveCarteraCliente(Integer cliente, Integer canal, String orgVenta) {
        CarteraClienteQueryNSCWS.CarteraClientesSoap request = new CarteraClienteQueryNSCWS.CarteraClientesSoap();
        request.timeout_x = WEB_SERVICE_TIMEOUT;
        for(Integer i=1; i<=MAX_CALLOUT_RETRIES; i++) {
            try {
                return validateCarteraClienteResponse(request.RegresaCartera(cliente, canal, orgVenta)).Datos.Cartera[0];
            } catch(Exception e) {
                if(i == MAX_CALLOUT_RETRIES) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, CARTERACLIENTE_WEB_SERVICE_ERROR+e.getMessage()));
                }
            }
        }
        return new CarteraClienteQueryNSCWS.Cartera();
    }
    
    private CarteraClienteQueryNSCWS.RespuestaOfListOfCartera validateCarteraClienteResponse(CarteraClienteQueryNSCWS.RespuestaOfListOfCartera response) {
        if(response == null || String.isBlank(response.Tipo)) {
            throw new PedidoWizardController.CustomException(CARTERACLIENTE_WEB_SERVICE_NO_DATA_ERROR);
        } else if(response.Tipo.toLowerCase().contains('error')) {
            throw new PedidoWizardController.CustomException(response.Mensaje);
        } else if(response.Datos == null || response.Datos.Cartera == null || response.Datos.Cartera.isEmpty()) {
            throw new PedidoWizardController.CustomException(CARTERACLIENTE_WEB_SERVICE_NO_DATA_ERROR);
        }
        return response;
    }
}