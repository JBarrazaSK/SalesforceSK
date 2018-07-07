/**
 * Description: Test methods of the DatosMaestrosNewTaskController class.
 * Author: Marco Tacú
 * Company: SK
 * Email: marco.tacu@sukarne.com
 * Created date: 06/07/2016
 **/
@isTest
private class DatosMaestrosNewTaskControllerTest {
    
    static testMethod void myUnitTest() {
        Test.startTest();
        
        new DatosMaestrosNewTaskController(new ApexPages.StandardController(new Task()));
        
        Test.stopTest();
    }
}