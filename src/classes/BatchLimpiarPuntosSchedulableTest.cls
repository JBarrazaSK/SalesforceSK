@isTest
private class BatchLimpiarPuntosSchedulableTest {

    static testMethod void myUnitTest() {
      Test.StartTest();
			BatchLimpiarPuntosSchedulable sh1 = new BatchLimpiarPuntosSchedulable();
			String sch = '0 0 23 * * ?';
			system.schedule('Test Territory Check', sch, sh1); 
	  Test.stopTest();
        
    }
}