/*
 * @developer   : Jorge Terán
 * @company     : LYNX9 Soluciones
 * @created     : 16/08/2015
 * @description : This class is a controller extension to DisplayInvoices VF page. It displays the Invoices related to the account.
 */
public class ctrlCabeceroFacturas {

    public ctrlCabeceroFacturas(ApexPages.StandardController controller) {}

    /*
     @description : This method is used to display the Invoice records details from Webservice
     */
    @RemoteAction
    public Static String displayInvoices(String accntId,
                                         String strStartDate,
                                         String strEndDate,
                                         String strSerie,
                                         String strFolio) {
        Transient String strXMLdata;
        Account accntRecord;


        System.debug('accntId ::: ' + accntId);

        String strCustomerNumber;


        if(String.isBlank(strStartDate))    strStartDate = '';
        if(String.isBlank(strEndDate))      strEndDate = '';
        if(String.isBlank(strSerie))        strSerie = '';
        if(String.isBlank(strFolio))        strFolio = '';


        if(accntId != null) {

            try {
                accntRecord = [SELECT Id, Numero_Cliente_SAP__c, ParentId, Parent.Numero_Cliente_SAP__c
                , Organizacion_de_Ventas__c
                FROM Account Where Id = : accntId LIMIT 1];
                System.debug('\n Controller record:' + accntRecord);

                if(accntRecord.ParentId != NULL && accntRecord.Parent.Numero_Cliente_SAP__c != NULL){
                    strCustomerNumber = accntRecord.Parent.Numero_Cliente_SAP__c;
                }
                else{
                    strCustomerNumber = accntRecord.Numero_Cliente_SAP__c;
                }

                System.debug('strCustomerNumber ::: ' + strCustomerNumber);

                if( String.isBlank( strCustomerNumber )){
                    displayPageMessages( 'ERROR', 'Customer Number not found for current Account!');
                }

                else{
                    strXMLdata = sendRequestForInvoices( strCustomerNumber, accntRecord.Organizacion_de_Ventas__c ); //accntRecord.Organizacion_de_Ventas__c );
                    System.debug('strXMLdata ::: ' + strXMLdata);
                }
            } catch (Exception e) {
                system.debug('Account Query Exception ::: ' + e);
                displayPageMessages('ERROR', e.getMessage());
            }
        }

        return strXMLdata;
    }

    private Static String sendRequestForInvoices(String strCustomerNumber, String organizacionVenta){

        //WebService Callout to get FacturaCabecero list as response

        if( String.isNotBlank(organizacionVenta) ) {
            organizacionVenta = (organizacionVenta.trim());
            organizacionVenta = organizacionVenta.right(4);
        }
        else {
            organizacionVenta = 'SK01';
        }

        Estado_de_cuenta__c settings = Estado_de_cuenta__c.getOrgDefaults();

        HttpRequest hreq = new HttpRequest();
        //hreq.setEndPoint('http://187.216.127.15:2562/SKServiciosExternos/SalesForce/HistoricoDeFacturacion.asmx');
        hreq.setEndpoint(settings.Endpoint_Facturas__c);
        hreq.setMethod('POST');
		 system.debug('endpoint ' + settings.Endpoint_Facturas__c);
        String strBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sal="http://www.sukarne.com/ws/salesforce"><soapenv:Header/><soapenv:Body><sal:ConsultarFacturas><sal:cliente>' + strCustomerNumber + '</sal:cliente><sal:serie>' + '' + '</sal:serie><sal:folio>' + '' + '</sal:folio><sal:fechaInicio>' + '' + '</sal:fechaInicio><sal:fechaFinal>' + '' + '</sal:fechaFinal><sal:ObtenerResumen>1</sal:ObtenerResumen><sal:organizacionVenta>'+organizacionVenta+'</sal:organizacionVenta></sal:ConsultarFacturas></soapenv:Body></soapenv:Envelope>';
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

    private Static void displayPageMessages(String severity, String message) {

        ApexPages.Severity msgSeverity;

        // Set severity of message
        if (severity.toUpperCase() == 'INFO')           msgSeverity = ApexPages.Severity.INFO;
        else if (severity.toUpperCase() == 'ERROR') msgSeverity = ApexPages.Severity.ERROR;
        else if (severity.toUpperCase() == 'FATAL') msgSeverity = ApexPages.Severity.FATAL;

        ApexPages.addMessage(new ApexPages.Message(msgSeverity, message));
    }
}