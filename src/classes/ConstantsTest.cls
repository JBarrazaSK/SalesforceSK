/**
 * Description: Test methods of the Constants class.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 03/11/2014
 **/
@isTest
private class ConstantsTest {
    
    static testMethod void myUnitTest() {
        Test.startTest();
        
        Map<String, Map<String, Id>> recordTypeMap = Constants.recordTypeMap;
        Map<String, Id> profileMap = Constants.profileMap;
        
        Test.stopTest();
    }
}