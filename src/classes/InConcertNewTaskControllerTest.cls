/**
 * Description: Test methods of the InConcertNewTaskController class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 13/10/2014
 **/
@isTest
private class InConcertNewTaskControllerTest {
    
    static testMethod void myUnitTest() {
        Test.startTest();
        
        new InConcertNewTaskController(new ApexPages.StandardController(new Task()));
        
        Test.stopTest();
    }
}