/**
 * Description: ExVizcattleNewOpportunity.page controller class.
 * Author: Marco Tacú
 * Company: SK
 * Email: marco.tacu@sukarne.com
 * Created date: 06/07/2016
 **/
public with sharing class ExVizcattleNewOpportunityController{
    
    public ExVizcattleNewOpportunityController(ApexPages.StandardController controller) {
        Map<String, String> parameterMap = ApexPages.currentPage().getParameters();
        Opportunity opportunity = (Opportunity)controller.getRecord();
        /**opportunity.StageName = 'En Proceso';**/
        opportunity.AccountId= parameterMap.get('What_Id');
        opportunity.RecordTypeId = parameterMap.get('Type_Id');
    }
}