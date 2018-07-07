/**
 * Description: DuplicateLeadFinder.page controller class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 05/02/2015
 **/
public without sharing class DuplicateLeadFinderController {
    
    public Account account { get; set; }
    public Lead lead { get; set; }
    public transient List<List<SObject>> accountList { get; set; }
    public transient List<List<SObject>> leadList { get; set; }
    public transient Integer accountListSize { get; set; }
    public transient Integer leadListSize { get; set; }
    public transient Integer maxSize { get; set; }
    public String accountSortField { get; set; }
    public String accountSortOrder { get; set; }
    public String leadSortField { get; set; }
    public String leadSortOrder { get; set; }
    
    private String accountQuery = 'SELECT Apellido_Materno__c, Apellido_Paterno__c, Apellidos__c, Calle__c, CreatedDate, Estatus_Cliente__c, Name, Nombres__c, Nombre_completo__c, Numero_Cliente_SAP__c, Numero_exterior__c, Plaza__c, RFC__c, Telefono_Adicional_Contacto__c, Telefono_Adicional__c, Telefono_Contacto__c, Telefono__c, Celular__c, Fax__c, Colonia__r.Codigo_Postal__c, Colonia__r.Descripcion_Colonia__c, Colonia__r.Estado__r.Name, Colonia__r.Localidad_Ciudad__r.Name, Colonia__r.Municipio_Delegacion__r.Name, Colonia__r.Pais__r.Name, Apellidos_Gpo_Clientes__c FROM Account ';
    private String leadQuery = 'SELECT Apellido_Materno__c, Apellidos__c, Calle__c, CreatedDate, FirstName, Grupo_de_clientes_Finder__c, Grupo_de_Clientes__c, Id_Prospecto__c, LastName, Name, Nombre_completo__c, No_Exterior__c, RFC__c, Status, Telefono_Adicional__c, Telefono_Contacto__c, Telefono__c, Colonia__r.Codigo_Postal__c, Colonia__r.Descripcion_Colonia__c, Colonia__r.Estado__r.Name, Colonia__r.Localidad_Ciudad__r.Name, Colonia__r.Municipio_Delegacion__r.Name, Colonia__r.Pais__r.Name, Apellidos_Gpo_Clientes__c, Celular__c FROM Lead ';
    private String previousCriteria;
    
    private String getLastQuerySubSentence(String sortField, String sortOrder) {
        return 'ORDER BY '+sortField+' '+sortOrder+' NULLS '+(sortOrder == 'ASC' ? 'FIRST' : 'LAST')+(sortField != 'CreatedDate' ? ', CreatedDate DESC' : '')+' LIMIT '+maxSize;
    }
    
    public DuplicateLeadFinderController() {
        account = new Account();
        lead = new Lead();
        accountList = new List<List<SObject>> { new List<SObject>() };
        leadList = new List<List<SObject>> { new List<SObject>() };
    }
    
    public void execute() {
        System.debug('execute');
        System.debug('leadSortField: ' + leadSortField);
        System.debug('leadSortOrder: ' + leadSortOrder);
        accountList = new List<List<SObject>> { new List<SObject>() };
        leadList = new List<List<SObject>> { new List<SObject>() };
        try {
            if(lead.LastName == 'null') lead.addError('Debe seleccionar un criterio.');
            else if(lead.LastName == 'queryDuplicateNames') queryDuplicatesByField('Nombre_completo__c');
            else if(lead.LastName == 'queryDuplicateLastNames') queryDuplicatesByField('Apellidos_Gpo_Clientes__c');
            else if(lead.LastName == 'queryDuplicateRFCs') queryDuplicatesByField('RFC__c');
            else if(lead.LastName == 'queryDuplicatePhones') queryDuplicatePhones();
            previousCriteria = lead.LastName;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Los resultados que la búsqueda devuelve sobrepasa los límites. Por favor, refine la búsqueda y reintente. Mensaje: '+e.getMessage()));
        }
    }
    
    private void queryDuplicatesByField(String field) {
        maxSize = 2000;
        /*if(previousCriteria != lead.LastName) {
            accountSortField = leadSortField = field;
            accountSortOrder = leadSortOrder = 'ASC';
        }*/
        System.debug('leadSortField: ' + leadSortField);
        System.debug('leadSortOrder: ' + leadSortOrder);
        System.debug('VALUE :: ' + field);
        if(accountSortField == null)
            accountSortField = field;
        if(accountSortOrder == null)
            accountSortOrder = 'ASC';
        if(leadSortField == null)
            leadSortField = field;
        if(leadSortOrder == null)
            leadSortOrder = 'ASC';
        
        Set<String> leadIdSet = new Set<String>();
        Set<String> valueSet = new Set<String>();
        Set<String> duplicateValueSet = new Set<String>();
        for(Lead lead : getLeadList()) {
            String value = (String)lead.get(field);
            if(String.isNotBlank(value)) {
                leadIdSet.add(lead.Id);
                value = value.toLowerCase();
                if(valueSet.contains(value)) {
                    duplicateValueSet.add(value);
                } else {
                    valueSet.add(value);
                }
            }
        }
        if(!valueSet.isEmpty()) {
            List<SObject> accountResultList = Database.query(
                accountQuery+
                'WHERE '+field+' != null AND '+field+' IN :valueSet '+
                getLastQuerySubSentence(accountSortField, accountSortOrder)
            );
            accountListSize = accountResultList.size();
            for(Integer i=0; i<accountListSize; i++) {
                duplicateValueSet.add(((String)accountResultList[i].get(field)).toLowerCase());
                if(Math.mod(i+1, 1000) == 0) {
                    accountList.add(new List<SObject>());
                }
                accountList[accountList.size()-1].add(accountResultList[i]);
            }
            if(!duplicateValueSet.isEmpty()) {
                for(SObject lead : Database.query(
                    'SELECT Apellido_Materno__c, Apellidos__c, LastName, Nombre_completo__c, RFC__c, Apellidos_Gpo_Clientes__c '+
                    'FROM Lead '+
                    'WHERE IsConverted = false AND '+field+' != null AND Id NOT IN :leadIdSet AND '+field+' IN :valueSet '+
                (account.FechaUltimaLlamada__c != null ? 'AND DAY_ONLY(CreatedDate) >= '+((Datetime)account.FechaUltimaLlamada__c).formatGMT('yyyy-MM-dd')+' ' : '')+
                (account.Fecha_de_Registro__c != null ? 'AND DAY_ONLY(CreatedDate) <= '+((Datetime)account.Fecha_de_Registro__c).formatGMT('yyyy-MM-dd')+' ' : '')+
                    getLastQuerySubSentence(leadSortField, leadSortOrder)
                )) {
                    duplicateValueSet.add((String)lead.get(field));
                }
                System.debug('leadSortField: ' + leadSortField);
                System.debug('leadSortOrder: ' + leadSortOrder);
                List<SObject> leadResultList = Database.query(
                    leadQuery+
                    'WHERE IsConverted = false AND '+field+' != null AND '+field+' IN :duplicateValueSet '+
                (account.FechaUltimaLlamada__c != null ? 'AND DAY_ONLY(CreatedDate) >= '+((Datetime)account.FechaUltimaLlamada__c).formatGMT('yyyy-MM-dd')+' ' : '')+
                (account.Fecha_de_Registro__c != null ? 'AND DAY_ONLY(CreatedDate) <= '+((Datetime)account.Fecha_de_Registro__c).formatGMT('yyyy-MM-dd')+' ' : '')+
                    getLastQuerySubSentence(leadSortField, leadSortOrder)
                );
                System.debug('leadResultList: ' + leadResultList);
                leadListSize = leadResultList.size();
                for(Integer i=0; i<leadListSize; i++) {
                    if(Math.mod(i+1, 1000) == 0) {
                        leadList.add(new List<SObject>());
                    }
                    leadList[leadList.size()-1].add(leadResultList[i]);
                }
            }
        }
    }
    
    private void queryDuplicatePhones() {
        maxSize = 1000;
        /*if(previousCriteria != lead.LastName) {
            accountSortField = leadSortField = 'Telefono__c';
            accountSortOrder = leadSortOrder = 'ASC';
        }*/
        if(accountSortField == null)
            accountSortField = 'Telefono__c';
        if(accountSortOrder == null)
            accountSortOrder = 'ASC';
        if(leadSortField == null)
            leadSortField = 'Telefono__c';
        if(leadSortOrder == null)
            leadSortOrder = 'ASC';
        
        Set<String> leadIdSet = new Set<String>();
        Set<String> telefonoSet = new Set<String>();
        Set<String> duplicateTelefonoSet = new Set<String>();
        Set<String> fieldSet = new Set<String> {'Telefono__c', 'Telefono_Contacto__c', 'Telefono_Adicional__c', 'Celular__c'};
        Set<String> fieldSetAcc = new Set<String> {'Telefono__c', 'Celular__c', 'Fax__c', 'Telefono_Adicional__c'};
        for(Lead lead : getLeadList()) {
            leadIdSet.add(lead.Id);
            Set<String> currentLeadTelefonoSet = new Set<String>();
            for(String field : fieldSet) {
                String telefono = (String)lead.get(field);
                if(String.isNotBlank(telefono)) {
                    currentLeadTelefonoSet.add(telefono);
                }
            }
            for(String telefono : currentLeadTelefonoSet) {
                if(telefonoSet.contains(telefono)) {
                    duplicateTelefonoSet.add(telefono);
                } else {
                    telefonoSet.add(telefono);
                }
            }
        }
        if(!telefonoSet.isEmpty()) {
            accountList[0] = Database.query(
                accountQuery+
                //'WHERE (Telefono_Adicional_Contacto__c IN :telefonoSet OR Telefono_Adicional__c IN :telefonoSet OR Telefono_Contacto__c IN :telefonoSet OR Telefono__c IN :telefonoSet ) '+
                'WHERE (Telefono__c IN :telefonoSet OR Celular__c IN :telefonoSet OR Fax__c IN :telefonoSet OR Telefono_Adicional__c IN :telefonoSet ) '+
                getLastQuerySubSentence(accountSortField, accountSortOrder)
            );
            accountListSize = accountList[0].size();
            //fieldSet.add('Telefono_Adicional_Contacto__c');
            for(SObject account : accountList[0]) {
                //for(String field : fieldSet) {
                for(String field : fieldSetAcc) {
                    String telefono = (String)account.get(field);
                    if(String.isNotBlank(telefono)) {
                        duplicateTelefonoSet.add(telefono);
                    }
                }
            }
            //fieldSet.remove('Telefono_Adicional_Contacto__c');
            if(!duplicateTelefonoSet.isEmpty()) {
                for(SObject lead : Database.query(
                    'SELECT Telefono_Adicional__c, Telefono_Contacto__c, Telefono__c '+
                    'FROM Lead '+
                    'WHERE IsConverted = false AND Id NOT IN :leadIdSet AND (Telefono_Adicional__c IN :telefonoSet OR Telefono_Contacto__c IN :telefonoSet OR Telefono__c IN :telefonoSet OR Celular__c IN :telefonoSet) '+
                (account.FechaUltimaLlamada__c != null ? 'AND DAY_ONLY(CreatedDate) >= '+((Datetime)account.FechaUltimaLlamada__c).formatGMT('yyyy-MM-dd')+' ' : '')+
                (account.Fecha_de_Registro__c != null ? 'AND DAY_ONLY(CreatedDate) <= '+((Datetime)account.Fecha_de_Registro__c).formatGMT('yyyy-MM-dd')+' ' : '')+
                    getLastQuerySubSentence(leadSortField, leadSortOrder)
                )) {
                    for(String field : fieldSet) {
                        duplicateTelefonoSet.add((String)lead.get(field));
                    }
                }
                leadList[0] = Database.query(
                    leadQuery+
                    'WHERE IsConverted = false AND (Telefono_Adicional__c IN :duplicateTelefonoSet OR Telefono_Contacto__c IN :duplicateTelefonoSet OR Telefono__c IN :duplicateTelefonoSet OR Celular__c IN :duplicateTelefonoSet) '+
                (account.FechaUltimaLlamada__c != null ? 'AND DAY_ONLY(CreatedDate) >= '+((Datetime)account.FechaUltimaLlamada__c).formatGMT('yyyy-MM-dd')+' ' : '')+
                (account.Fecha_de_Registro__c != null ? 'AND DAY_ONLY(CreatedDate) <= '+((Datetime)account.Fecha_de_Registro__c).formatGMT('yyyy-MM-dd')+' ' : '')+
                    getLastQuerySubSentence(leadSortField, leadSortOrder)
                );
                leadListSize = leadList[0].size();
            }
        }
    }
    
    private List<Lead> getLeadList() {
        return (List<Lead>)Database.query(
            'SELECT Apellido_Materno__c, Apellidos__c, LastName, Nombre_completo__c, RFC__c, ' +
            ' Telefono_Adicional__c, Telefono_Contacto__c, Telefono__c, Apellidos_Gpo_Clientes__c, ' +
            ' Celular__c '+
            'FROM Lead '+
            'WHERE IsConverted = false '+
                (account.FechaUltimaLlamada__c != null ? 'AND DAY_ONLY(CreatedDate) >= '+((Datetime)account.FechaUltimaLlamada__c).formatGMT('yyyy-MM-dd')+' ' : '')+
                (account.Fecha_de_Registro__c != null ? 'AND DAY_ONLY(CreatedDate) <= '+((Datetime)account.Fecha_de_Registro__c).formatGMT('yyyy-MM-dd')+' ' : '')+
                //(lead.Organizacion_de_Ventas_Finder__c != null ? 'AND Organizacion_de_Ventas__c = \''+lead.Organizacion_de_Ventas__c + '\' ' : '') +
               	(lead.Zona_de_Ventas_Finder__c != null ? 'AND Zona_de_ventas__c = \''+lead.Zona_de_Ventas__c+'\' ' : '')+
               	(lead.Grupo_de_clientes_Finder__c != null ? 'AND Grupo_de_clientes__c = \''+lead.Grupo_de_clientes__c+'\' ' : '')+
            'ORDER BY CreatedDate DESC '+
            'LIMIT 1000'
        );
    }
    
    public void eliminarProspectos() {
        
        String param = ApexPages.currentPage().getParameters().get('prospectosIds');
        
        if (param != null){
            List<Id> prospectosIds = param.split(',');
            List<Lead> leadList = [SELECT Id FROM Lead WHERE Id in :prospectosIds];
            delete leadList;
        }
        
        execute();
        
    }
    
    /*@RemoteAction
    public static void eliminarProspectos(List<Id> prospectosIds) {
        List<Lead> leadList = [SELECT Id FROM Lead WHERE Id in :prospectosIds];
        delete leadList;
    }*/
    
    public void descartarProspectos() {
        
        String motivo = '';
        
        if(lead.LastName == 'queryDuplicateNames') 
            motivo = 'Prospectos duplicados';
        else if(lead.LastName == 'queryDuplicateLastNames') 
            motivo = 'Apellidos iguales';
        else if(lead.LastName == 'queryDuplicateRFCs')
            motivo = 'RFC iguales';
        else if(lead.LastName == 'queryDuplicatePhones') 
            motivo = 'Teléfonos iguales';
        
        String param = ApexPages.currentPage().getParameters().get('prospectosIds');
        
        if (param != null){
            List<Id> prospectosIds = param.split(',');
            List<Lead> leadList = [SELECT Id FROM Lead WHERE Id in :prospectosIds];
            
            for(Lead lead: leadList){
                lead.Status = 'Descartado';
                lead.Motivo_de_rechazo__c = motivo;
            }     
            
            List<ProcessInstanceWorkitem> workers = [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId in :prospectosIds];
        
            for(ProcessInstanceWorkitem worker: workers){
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Descartado - ' + motivo);
                req.setAction('Reject');
                req.setWorkitemId(worker.Id);
                Approval.ProcessResult result =  Approval.process(req);
            }
            update leadList;
        }
        
        /*List<ProcessInstance> procesos = [select id from ProcessInstance where TargetObjectId in :prospectosIds];
        
        for(ProcessInstance proceso: procesos){
            proceso.Status = 'Rejected';
        }*/
        
        
        
        execute();
    }
    
    /*@RemoteAction
    public static void descartarProspectos(List<Id> prospectosIds) {
        List<Lead> leadList = [SELECT Id FROM Lead WHERE Id in :prospectosIds];
        
        for(Lead lead: leadList){
            lead.Status = 'Descartado';
        }
        
        update leadList;
    }*/
}