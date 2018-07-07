/**
 * Description: AccountListConsole.page controller class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 31/07/2014
 **/
public with sharing class AccountListConsoleController {
    
    public Integer accountListSize { get; set; }
    public Boolean isAdmin { get; set; }
    
    private Map<String, String> parameterMap;
    private List<String> territorioList;
    private String profileName;
    private Map<String, String> diasMap = new Map<String, String> {
        'Monday' => 'Martes',
        'Tueday' => 'Miércoles',
        'Wednesday'=> 'Jueves',
        'Thursday'=> 'Viernes',
        'Friday' => 'Sábado',
        'Saturday' => 'Lunes'
    };
    
    public AccountListConsoleController(ApexPages.StandardSetController controller) {
        parameterMap = ApexPages.currentPage().getParameters().clone();
        for(User user : [
            SELECT Territorio__c,
                Profile.Name
            FROM User
            WHERE Id = :UserInfo.getUserId()
        ]) {
            profileName = user.Profile.Name;
            isAdmin = profileName == 'Administrador del sistema';
            territorioList = String.isNotBlank(user.Territorio__c) ? user.Territorio__c.split(',') : new List<String>();
        }
        queryAccountListSize();
    }
    
    public PageReference init() {
        if(parameterMap.containsKey('sfdcIFrameOrigin')) {
            return null;
        }
        parameterMap.remove('sfdc.override');
        parameterMap.put('nooverride', '1');
        PageReference pageReference = new PageReference('/'+Account.SObjectType.getDescribe().getKeyPrefix());
        pageReference.getParameters().putAll(parameterMap);
        return pageReference;
    }
    
    public void queryAccountListSize() {
        String dayOfWeek = !Test.isRunningTest() ? Datetime.now().format('EEEE') : 'Monday';
        if(diasMap.containsKey(dayOfWeek)) {
            accountListSize = !isAdmin ? Database.countQuery(
                'SELECT Count() '+
                'FROM Account '+
                'WHERE DiasEntrega__c INCLUDES (\''+diasMap.get(dayOfWeek)+'\') '+
                    'AND Estatus_Call_Center__c = \''+(profileName == 'TV NM' ? 'Maduración TNM' : 'TLV Titular Detalle')+'\' '+
                    'AND Estatus_Cliente__c = \'Activo\' '+
                    'AND FechaUltimaLlamada__c != '+String.valueOf(Date.today()).left(10)+' '+
                    'AND RecordType.Name = \'Sucursal\' '+
                    'AND Territorio__c IN :territorioList'
            ) : null;
        }
    }
}