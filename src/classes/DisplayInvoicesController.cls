/*
 * @developer   : Shaikh Saquib
 * @created     : 22/06/2015
 * @description : This class is a controller extension to DisplayInvoices VF page. It displays the Invoices related to the
                  account where Fecha_de_Factura__c lies between Start Date and End Date fields displayed on the VF page.
 */
public class DisplayInvoicesController {


    public DisplayInvoicesController(ApexPages.StandardController controller) {}

    /*
     @description : This method is used to display the Invoice records details from Webservice 
     */
    @RemoteAction
    public Static String displayInvoices(String accntId, 
                                         String strStartDate, 
                                         String strEndDate,
                                         String strSerie, 
                                         String strFolio,
                                         String orgVentas) {    
        Transient String strXMLdata;
        Account accntRecord;
           
        
        System.debug('accntId ::: ' + accntId);
        
        String strCustomerNumber;
        
        
        if(String.isBlank(strStartDate))    strStartDate = '';
        if(String.isBlank(strEndDate))      strEndDate = '';
        if(String.isBlank(strSerie))        strSerie = '';
        if(String.isBlank(strFolio))        strFolio = '';
        if(String.isBlank(orgVentas))       orgVentas = '';                                     
        
        
        if(accntId != null) {
        
            try {
                accntRecord = [SELECT Id, Numero_Cliente_SAP__c, Organizacion_de_Ventas__c, 
                ParentId, Parent.Numero_Cliente_SAP__c,
                Oficina_de_Ventas__c,Oficina_de_Ventas__r.Opera_en_SAP__c FROM Account Where Id = : accntId LIMIT 1];     
                System.debug('\n Controller record:' + accntRecord);
                
                if(accntRecord.ParentId != NULL && accntRecord.Parent.Numero_Cliente_SAP__c != NULL){
                    strCustomerNumber = accntRecord.Parent.Numero_Cliente_SAP__c;
                }
                else{
                    strCustomerNumber = accntRecord.Numero_Cliente_SAP__c;
                }
                
                System.debug('Organización de Ventas ::: ' + orgVentas);
                if( String.isBlank( orgVentas )){
                    displayPageMessages( 'ERROR', 'Organización de Ventas no proporcionada!');
                }
                else {
                    orgVentas = (orgVentas.trim());
                    orgVentas = orgVentas.right(4);
                }
                
                System.debug('strCustomerNumber ::: ' + strCustomerNumber);
                if( String.isBlank( strCustomerNumber )){
                    displayPageMessages( 'ERROR', 'Customer Number not found for current Account!');
                }
                else{
                	//accntRecord
                    strXMLdata = sendRequestForInvoices(strCustomerNumber , strSerie, strFolio, strStartDate, strEndDate, orgVentas,accntRecord.Oficina_de_Ventas__r.Opera_en_SAP__c);
                    System.debug('strXMLdata ::: ' + strXMLdata);
                }
            } catch (Exception e) {
                system.debug('Account Query Exception ::: ' + e);
                displayPageMessages('ERROR', e.getMessage());
            }
        }

        return strXMLdata;
    }    
      
    private Static String sendRequestForInvoices(String strCustomerNumber,
                                                 String strSerie,
                                                 String strFolio,
                                                 String strStartDate,
                                                 String strEndDate,
                                                 String orgVentas, boolean operaSap){
                                    
        //WebService Callout to get FacturaCabecero list as response

        Estado_de_cuenta__c settings = Estado_de_cuenta__c.getOrgDefaults();
                                                     
        HttpRequest hreq = new HttpRequest();
        //hreq.setEndPoint('http://187.216.127.15:2562/SKServiciosExternos/SalesForce/HistoricoDeFacturacion.asmx');
        hreq.setEndpoint(settings.Endpoint_Facturas__c);
        hreq.setMethod('POST');

        String strBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sal="http://www.sukarne.com/ws/salesforce"><soapenv:Header/><soapenv:Body><sal:ConsultarFacturas><sal:cliente>' + strCustomerNumber + '</sal:cliente><sal:serie>' + strSerie + '</sal:serie><sal:folio>' + strFolio + '</sal:folio><sal:fechaInicio>' + strStartDate + '</sal:fechaInicio><sal:fechaFinal>' + strEndDate + '</sal:fechaFinal><sal:organizacionVenta>'+ orgVentas +'</sal:organizacionVenta><sal:ObtenerResumen>0</sal:ObtenerResumen><sal:ConsultaSAP>' + operaSap + '</sal:ConsultaSAP></sal:ConsultarFacturas></soapenv:Body></soapenv:Envelope>';
        System.debug('strBody ::: ' + strBody);
        
        hreq.setHeader('SOAPAction', 'http://www.sukarne.com/ws/salesforce/ConsultarFacturas');
        hreq.setHeader('Content-Type', 'text/xml');
        hreq.setBody(strBody);

        Http http = new Http();
        HttpResponse hres;

        try {
            hres = http.send(hreq);

            System.debug('Response :' + hres);

            //If HttpResponse is not null, then parse the xml response
            if (hres != null) {
                return hres.getBody();
            }
        } catch (System.CalloutException e) {
            system.debug('CALLOUT EXCEPTION ::: ' + e);
            displayPageMessages('FATAL', e.getMessage());
        } 
        
        return null;       
    }

    /*
     @description : This method is used to display page messages
     */

    private Static void displayPageMessages(String severity, String message) {

        ApexPages.Severity msgSeverity;

        // Set severity of message
        if (severity.toUpperCase() == 'INFO')           msgSeverity = ApexPages.Severity.INFO;
        else if (severity.toUpperCase() == 'ERROR') msgSeverity = ApexPages.Severity.ERROR;
        else if (severity.toUpperCase() == 'FATAL') msgSeverity = ApexPages.Severity.FATAL;

        ApexPages.addMessage(new ApexPages.Message(msgSeverity, message));
    }
}