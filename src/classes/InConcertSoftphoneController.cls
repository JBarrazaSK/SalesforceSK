/**
 * Description: InConcertSoftphone.page controller class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 04/08/2014
 **/
public with sharing class InConcertSoftphoneController {
    
    public Account account { get; set; }
    public String userProfId { get; set; }
    public boolean isInbound { get; set; }
    public boolean isOutbound { get; set; }
    
    public List<Profile> profilesInbound = this.getProfileId('Inbound');
    
    private String idLlamadaInConcert;
    
    public InConcertSoftphoneController() {
        account = new Account();
        
        userProfId = System.UserInfo.getProfileId();
        System.debug('ProfileId: ' + userProfId);
        isInbound = this.validateProfile();
        IsOutbound = this.validateOutbound();
    }
    
    public void setPhones() {
        String accountId = ApexPages.currentPage().getParameters().get('accountId');
        if(String.isNotBlank(accountId)) {
            List<String> accountFieldNameList = new List<String>();
            for(FieldSetMember fieldSetMember : SObjectType.Account.FieldSets.InConcertSoftphone.getFields()) {
                if(fieldSetMember.getFieldPath() != 'Name') {
                    accountFieldNameList.add(fieldSetMember.getFieldPath());
                }
            }
            account = (Account)Database.query(
                'SELECT Name'+(!accountFieldNameList.isEmpty() ? ', '+String.join(accountFieldNameList, ', ') : '')+' '+
                'FROM Account '+
                'WHERE Id = :accountId'
            );
            List<String> whereClauseList = new List<String>();
            for(String accountFieldName : accountFieldNameList) {
                String telefono = String.valueOf(account.get(accountFieldName));
                if(String.isNotBlank(telefono) && telefono.length() > 6) {
                    whereClauseList.add('(((NIR__c = '+telefono.left(2)+' AND Serie__c = '+telefono.substring(2, 6)+') OR (NIR__c = '+telefono.left(3)+' AND Serie__c = '+telefono.substring(3, 6)+')) AND Numeracion_inicial__c < '+telefono.right(4)+' AND Numeracion_final__c > '+telefono.right(4)+')');
                }
            }
            if(!whereClauseList.isEmpty()) {
                Map<String, String> tipoDeRedXNIRSerieMap = new Map<String, String>();
                for(Cofetel__c cofetel : (List<Cofetel__c>)Database.query(
                    'SELECT NIR__c, Serie__c, Tipo_de_red__c '+
                    'FROM Cofetel__c '+
                    'WHERE '+String.join(whereClauseList, ' OR ')
                )) {
                    tipoDeRedXNIRSerieMap.put(String.valueOf(cofetel.NIR__c)+String.valueOf(cofetel.Serie__c), cofetel.Tipo_de_red__c.toLowerCase());
                }
                for(String accountFieldName : accountFieldNameList) {
                    String telefono = String.valueOf(account.get(accountFieldName));
                    if(String.isNotBlank(telefono) && tipoDeRedXNIRSerieMap.containsKey(telefono.left(6))) {
                        String tipoDeRed = tipoDeRedXNIRSerieMap.get(telefono.left(6));
                        account.put(accountFieldName, telefono.substring(0, 3) == '667' ? (tipoDeRed == 'fijo' ? telefono.right(7) : '044'+telefono) : (tipoDeRed == 'fijo' ? '01'+telefono : '045'+telefono));
                    }
                }
            }
        } else {
            account = new Account();
        }
    }
    
    private boolean validateProfile() {
        boolean showConsole = false; 
        System.debug('Validating profile...');
        if( profilesInbound != null ) {
            for(Profile p: profilesInbound)  {
                if( p == null ) { continue; }
                if( p.Id == userProfId ) {
                    showConsole = true;
                    break;
                }
            }
        }
        System.debug('ShowNewCase: ' + showConsole);
        return showConsole;
    }

    private boolean validateOutbound() {
        boolean showConsole = true; 
        System.debug('Validating outbound...');
        if( profilesInbound != null ) {
            for(Profile p: profilesInbound)  {
                if( p == null ) { continue; }
                if( p.Id == userProfId ) {
                    showConsole = false;
                    break;
                }
            }
        }
        System.debug('ShowPhones: ' + showConsole);
        return showConsole;
    }
    
    private List<Profile> getProfileId(String pName){
        List<Profile> profileIds = new List<Profile>();

        try {
            String name = '%'+pName+'%';
            profileIds = [Select Id From Profile Where Name Like :name];
        } catch( Exception e ) {
            System.debug('HUBO UN ERROR AL BUSCAR EL ID DEL PERFIL. ' + e.getMessage());
            return null;
        }
        
        return profileIds;
    }
}