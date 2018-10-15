/*
 * @developer   : Aditya
 * @created     : 23/06/2015
 * @description : This class is a controller extension to DisplayCustomers VF page. It displays the Customer records related to the
                  account where Fecha_creacion_Cliente__c lies between Start Date and End Date fields displayed on the VF page.
 */
public with sharing class DisplayCustomersController {
    
    //Display Customer table and hide time frame on True
    public Boolean isShowTable{ get; set; }
             
    public Transient List< EstadoDeCuenta > listEstadoDeCuenta { get; set; }
    
    public Boolean displayPopUp {
        get{
        
            //Initialize displayPopUp to False
            if( displayPopUp == null )        
                return False;
            return displayPopUp;
        }
        set;
    }
    
    Account Acc;
    
    //Set start date value to 2 months back from todays date
    public String strStartDate{
         get {
            //Set End Date value to todays date
            if (strStartDate == null) {                
                
                String month = String.valueOf(Date.today().month());
                String year = String.valueOf(Date.today().year());
                String day = String.valueOf(Date.today().day());
                
                if(String.isNotBlank(month) && month.length() == 1){
                    month = '0' + month;
                }
                
                if(String.isNotBlank(day) && day.length() == 1){
                    day = '0' + day;
                }
                
                return (year + month + day);
            }
            return strStartDate;
        }
        set;      
    }
    
    //Set End Date value to todays date
    public String strEndDate{
         get {
            //Set End Date value to todays date
            if (strEndDate == null) {
                
                String month = String.valueOf(Date.today().month());
                String year = String.valueOf(Date.today().year());
                String day = String.valueOf(Date.today().day());
                
                if(String.isNotBlank(month) && month.length() == 1){
                    month = '0' + month;
                }
                
                if(String.isNotBlank(day) && day.length() == 1){
                    day = '0' + day;
                }
                
                return (year + month + day);
            }
            return strEndDate;
        }
        set;     
    }
    
    public DisplayCustomersController(ApexPages.StandardController controller) {
        
        //Do not display Customer records table on page load
        isShowTable = False;                       
         
        Acc = ( Account )controller.getRecord();
        system.debug('Account Record : ' + Acc);
        
        //Check for Id of Account and accordingly fetch data or display error
        if( Acc.Id != null ){
        
            try{
                Acc = [SELECT Id, Numero_Cliente_SAP__c, ParentId, Parent.Numero_Cliente_SAP__c, Organizacion_de_Ventas__c,
                Oficina_de_Ventas__c,Oficina_de_Ventas__r.Opera_en_SAP__c 
                FROM Account Where Id =: Acc.Id LIMIT 1];
                //startDate = String.valueOf(Date.valueOf('2014-01-01')).ReplaceAll('-','/');
                //endDate = String.valueOf(Date.valueOf('2014-02-01')).ReplaceAll('-','/');
            }
            catch(DMLException e){
                system.debug('Account Query Exception ::: ' + e);
                displayPageMessages('ERROR', e.getMessage());
            }
        }
        //If Account Id not found, display error message
        else{
            displayPageMessages('INFO', 'Account Id Not Found!\n Please specify Id in the url.');
        }
    }

     /*
     @description : This method is used to display the Account records details from Webservice 
     */
    public void showCustomerDetails(){
        
        String strCustomerNumber;
        String organizacionVenta;
        if(Acc.ParentId != NULL && Acc.Parent.Numero_Cliente_SAP__c != NULL){
            strCustomerNumber = Acc.Parent.Numero_Cliente_SAP__c;
        }
        else{
            strCustomerNumber = Acc.Numero_Cliente_SAP__c;
        }
        
        //System.debug('Organización de Ventas ::: ' + Acc.Organizacion_de_Ventas__c);
        if( String.isNotBlank(Acc.Organizacion_de_Ventas__c) ) {
            organizacionVenta = (Acc.Organizacion_de_Ventas__c.trim());
            organizacionVenta = organizacionVenta.right(4);
        }
        else {
            organizacionVenta = 'SK01';
        }
        
        System.debug('strCustomerNumber ::: ' + strCustomerNumber);
        
        if( String.isBlank( strCustomerNumber )){
            displayPageMessages( 'ERROR', 'Customer Number not found for current Account!');
        }
        
        else{
            
            //Convert Date values to string in required form for web service
            strStartDate = strStartDate.ReplaceAll('-','');    //Testing purposes value 20140101
            strEndDate = strEndDate.ReplaceAll('-','');        //Testing purposes value 20140201
            
            System.debug('Customer Number :'+strCustomerNumber );
            System.debug('SD :'+ strStartDate +'. ED :'+ strEndDate);

            Estado_de_cuenta__c settings = Estado_de_cuenta__c.getOrgDefaults();
            HttpRequest hreq = new HttpRequest();
            //hreq.setEndPoint('http://187.216.127.15:2562/SKServiciosExternos/SalesForce/EstadoDeCuentaCliente.asmx');
            hreq.setEndPoint(settings.Endpoint_Saldos__c);
            hreq.setMethod('POST');
            String strBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sal="http://www.sukarne.com/ws/salesforce"><soapenv:Header/><soapenv:Body><sal:ConsultarSaldos><sal:cliente>'+strCustomerNumber+'</sal:cliente><sal:fechaInicio>'+ strStartDate +'</sal:fechaInicio><sal:fechaFinal>'+ strEndDate +'</sal:fechaFinal><sal:organizacionVenta>'+organizacionVenta+'</sal:organizacionVenta><sal:consultarSAP>'+Acc.Oficina_de_Ventas__r.Opera_en_SAP__c+'</sal:consultarSAP></sal:ConsultarSaldos></soapenv:Body></soapenv:Envelope>';
            hreq.setHeader('SOAPAction','http://www.sukarne.com/ws/salesforce/ConsultarSaldos');
            hreq.setHeader('Content-Type','text/xml');
            hreq.setBody(strBody);               
            Http http = new Http();
            HttpResponse hres;
            
            try{
                hres = http.send(hreq);
            }
            catch(System.CalloutException e){
                System.debug('CALLOUT EXCEPTION ::: '+ e);
                displayPageMessages( 'ERROR', e.getMessage());
            }
            
            //If Response is not null than call method to parse the response string
            if( hres != null ){
                system.debug('Response ' + hres.getBody());
                
                try{
                    parseXMLResponse( hres.getBody() );
                }
                catch(Exception e){
                    System.debug('EXCEPTION IN PARSING XML::: '+ e);
                    displayPageMessages( 'ERROR', e.getMessage());
                }
            }
        }
    }
    
    /*
     @description - This method is used to parse the XML response obtained from
                    webservice and create result list of elements of DTO class 
                    EstadoDeCuenta.
     @parameters  - Result Xml (string) from webservice  
     */
    void parseXMLResponse( String response ){
        
        //Re-initialize list before adding elements
        listEstadoDeCuenta = new List<EstadoDeCuenta>();
        
        Dom.document doc = new Dom.Document();
        doc.load( response );
        Dom.XmlNode envelope = doc.getRootElement();
        system.debug('Root '+ envelope.getName());
        
        EstadoDeCuenta objEstadoDeCuenta;
        
        if( envelope != null ){
            
            //Get the root element ie envelope from xml string 
            List<Dom.XmlNode> listBodyNodes = envelope.getChildElements();
            
            //Get the first element ie Body from envelope
            if( listBodyNodes != null &&
                    !listBodyNodes.isEmpty() &&
                            listBodyNodes[0].getName().equalsIgnoreCase('Body') ){
                   
                system.debug('Envelope first child :'+ listBodyNodes[0].getName());
                
                //Get child elements from Body
                List<Dom.XmlNode> listConSalRes = listBodyNodes[0].getChildElements();
                
                //Get first child element ConsultarSaldosResponse from body
                if(listConSalRes != null &&
                        !listConSalRes.isEmpty() && 
                                listConSalRes[0].getName().equalsIgnoreCase('ConsultarSaldosResponse') ){
                    
                    system.debug('Body first child :'+ listConSalRes[0].getName());
                    
                    //Get child elements from ConsultarSaldosResponse
                    List<Dom.XmlNode> listConSalResult = listConSalRes[0].getChildElements();
                    
                    //Get first child element ConsultarSaldosResult from ConsultarSaldosResponse
                    if( listConSalResult != null &&
                                !listConSalResult.isEmpty() &&
                                        listConSalResult[0].getName().equalsIgnoreCase('ConsultarSaldosResult')){
                        
                        //Get child elements from ConsultarSaldosResult
                        List<Dom.XmlNode> listDataNodes = listConSalResult[0].getChildElements();
                        
                        //Get Datos from ConsultarSaldosResult
                        if( listDataNodes != null &&
                                !listDataNodes.isEmpty() &&
                                        listDataNodes[0].getName().equalsIgnoreCase('Datos') ){
                            
                            //Get all EstadoDeCuenta nodes from Datos
                            for( Dom.XmlNode nodeStatement : listDataNodes[0].getChildElements()){
                                
                                if( nodeStatement.getName().equalsIgnoreCase('EstadoDeCuenta') ){
                                    
                                    //Create object of class EstadoDeCuenta and assign values from node
                                    objEstadoDeCuenta = new EstadoDeCuenta();
                                    
                                    for( Dom.XmlNode nodeStatAttr : nodeStatement.getChildElements()){
                                        
                                        if( nodeStatAttr.getName().equalsIgnoreCase('Folio')){
                                            objEstadoDeCuenta.Folio = nodeStatAttr.getText();
                                        }
                                        if( nodeStatAttr.getName().equalsIgnoreCase('Fecha')){
                                            objEstadoDeCuenta.Fecha = nodeStatAttr.getText();
                                        }
                                        if( nodeStatAttr.getName().equalsIgnoreCase('Concepto')){
                                            objEstadoDeCuenta.Concepto = nodeStatAttr.getText();
                                        }
                                        if( nodeStatAttr.getName().equalsIgnoreCase('Referencia')){
                                            objEstadoDeCuenta.Referencia = nodeStatAttr.getText();
                                        }
                                        if( nodeStatAttr.getName().equalsIgnoreCase('FechaVencimiento')){
                                            objEstadoDeCuenta.FechaVencimiento = nodeStatAttr.getText();
                                        }
                                        if( nodeStatAttr.getName().equalsIgnoreCase('Cargos')){
                                            objEstadoDeCuenta.Cargos = nodeStatAttr.getText();
                                        }
                                        if( nodeStatAttr.getName().equalsIgnoreCase('Abonos')){
                                            objEstadoDeCuenta.Abonos = nodeStatAttr.getText();
                                        }
                                        if( nodeStatAttr.getName().equalsIgnoreCase('Saldo')){
                                            objEstadoDeCuenta.Saldo = nodeStatAttr.getText();
                                        }
                                        if( nodeStatAttr.getName().equalsIgnoreCase('NumeroPoliza')){
                                            objEstadoDeCuenta.NumeroPoliza = nodeStatAttr.getText();
                                        }
                                        system.debug( nodeStatAttr.getName() + ' : ' + nodeStatAttr.getText());
                                    }
                                    
                                    //Add EstadoDeCuenta object to List
                                    listEstadoDeCuenta.add( objEstadoDeCuenta );
                                } 
                            }
                        }                
                    }
                }
            }    
        }
        
        if( listEstadoDeCuenta != null && !listEstadoDeCuenta.isEmpty() ){
            displayPopUp = True;
        }
        else{
            displayPopUp = False;
            displayPageMessages('INFO','No records found for entered Customer Number ! ');
        }
    }
    
    /*
     @description : EstadoDeCuenta is DTO class to parse xml response from the webservice.
    */
    public class EstadoDeCuenta{
        
        public String Folio{get;set;}
        public String Fecha{get;set;}
        public String Concepto{get;set;}
        public String Referencia{get;set;}
        public String FechaVencimiento{get;set;}
        public String Cargos{get;set;}
        public String Abonos{get;set;}
        public String Saldo{get;set;}
        public String NumeroPoliza{get;set;}
        
    }

    /*
     @description : Hides the popup by changing displayPopUp value to False and rerendering the block 
    */  
    public PageReference closePopup() {
        displayPopUp = False;
        system.debug('Close Popup');
        return null;
    }
    
    /*
     @description : This method is used to display page messages
     @parameters  : 1) Severity : String containing Apex message severity
                    2) Message  : String message to be displayed on the page
     */
    void displayPageMessages( String severity, String message ) {
        
        ApexPages.Severity msgSeverity;
        
        // Set severity of message
        if( severity.toUpperCase() == 'INFO' )
            msgSeverity = ApexPages.Severity.INFO;
        else if( severity.toUpperCase() == 'ERROR' ) 
            msgSeverity = ApexPages.Severity.ERROR;                      
  
        ApexPages.addMessage(new ApexPages.Message(msgSeverity, message));
    }
}