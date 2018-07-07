@isTest
private class SurveyManagerControllerTest {

    static testMethod void myUnitTest() {
        user usuario = new user();
        ApexPages.StandardController sc = new ApexPages.StandardController(usuario);
        SurveyManagerController controller = new SurveyManagerController(sc);
        controller.getEditCSS();
        
    }
}