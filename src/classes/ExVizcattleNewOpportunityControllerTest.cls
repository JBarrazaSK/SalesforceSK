/**
 * Description:  Test methods of the ExVizcattleNewOpportunityController class.
 * Author: Marco Tacú
 * Company: SK
 * Email: marco.tacu@sukarne.com
 * Created date: 06/07/2016
 **/

@isTest
private class ExVizcattleNewOpportunityControllerTest {
    
    static testMethod void myUnitTest() {
        Test.startTest();
        
        new ExVizcattleNewOpportunityController(new ApexPages.StandardController(new Opportunity()));
        
        Test.stopTest();
    }
}