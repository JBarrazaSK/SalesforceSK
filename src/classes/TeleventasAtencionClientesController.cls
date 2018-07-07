/**
 * Description: TeleventasAtencionClientes.page controller class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 07/08/2014
 **/
public with sharing class TeleventasAtencionClientesController {
    
    public String telefonoLlamadaInConcert { get; set; }
    public List<Account> accountList { get; set; }
    public String accountId { get; set; }
    public String userProfId { get; set; }
    public boolean isInbound { get; set; }
    public boolean isOutbound { get; set; }
    
    public List<Profile> profilesInbound = this.getProfileId('Inbound');
    
    private String idLlamadaInConcert;
    
    public TeleventasAtencionClientesController() {
        String inConcertPopUpParameters = ApexPages.currentPage().getParameters().get('inConcertPopUpParameters');

        if(String.isNotBlank(inConcertPopUpParameters) && inConcertPopUpParameters.contains('phone') && inConcertPopUpParameters.indexOf('phone') > 0 && inConcertPopUpParameters.indexOf('phone') < inConcertPopUpParameters.length()-5) {
            String[] inConcertPopUpParameterArray = inConcertPopUpParameters.split('phone', 2);
            idLlamadaInConcert = inConcertPopUpParameterArray[0];
            telefonoLlamadaInConcert = inConcertPopUpParameterArray[1];
            List<String> accountFieldNameList = new List<String>();
            for(FieldSetMember fieldSetMember : SObjectType.Account.FieldSets.TeleventasAtencionClientes.getFields()) {
                accountFieldNameList.add(fieldSetMember.getFieldPath());
            }
            accountList = String.isNotBlank(telefonoLlamadaInConcert) && !accountFieldNameList.isEmpty() ? (List<Account>)Database.query(
                'SELECT '+String.join(accountFieldNameList, ', ')+' '+
                'FROM Account '+
                'WHERE '+String.join(accountFieldNameList, ' LIKE \'%'+telefonoLlamadaInConcert+'%\' OR ')+' LIKE \'%'+telefonoLlamadaInConcert+'%\''
            ) : new List<Account>();
        }
        
        userProfId = System.UserInfo.getProfileId();
        isInbound = this.validateProfile();
        isOutbound = !isInbound;
    }
    
    public PageReference redirectToNewCase() {
        return new PageReference('/setup/ui/recordtypeselect.jsp?ent=Case&retURL=%2Fapex%2FTeleventasAtencionClientes%3FinConcertPopUpParameters%3D'+idLlamadaInConcert+'phone'+telefonoLlamadaInConcert+'&save_new_url=%2F500%2Fe%3FretURL%3D%252Fapex%2FTeleventasAtencionClientes%3FinConcertPopUpParameters%3D'+idLlamadaInConcert+'phone'+telefonoLlamadaInConcert+'%26def_account_id%3D'+accountId+'%26'+Label.CasoIdLlamadaInConcertFieldId+'%3D'+idLlamadaInConcert+'%26'+Label.CasoTelefonoLlamadaInConcertFieldId+'%3D'+telefonoLlamadaInConcert);
    }
    
    private boolean validateProfile() {
        boolean showConsole = false; 
        
        if( profilesInbound != null ) {
            for(Profile p: profilesInbound)  {
                if( p == null ) { continue; }
                if( p.Id == userProfId ) {
                    showConsole = true;
                    break;
                }
            }
        }
        
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