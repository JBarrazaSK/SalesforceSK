@isTest
private class BatchLealtadSchedulableTest {

    static testMethod void myUnitTest() {
         Test.StartTest();
			BatchLealtadSchedulable sh1 = new BatchLealtadSchedulable();
			String sch = '0 0 23 * * ?';
			system.schedule('Test Territory Check', sch, sh1); 
	 	 Test.stopTest();
        
    }
}