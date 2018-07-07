@isTest( SeeAllData = TRUE )
public class ctrlRetrieveSolutions_UT {

    static testMethod void test() {
        Test.startTest();
     
        PageReference pageRef = Page.vfpReOpenCase;
        Test.setCurrentPage( pageRef );
        ApexPages.currentPage().getParameters().put('subject', 'Devolución' );
        ctrlRetrieveSolutions ext = new ctrlRetrieveSolutions();
        
        PageReference pageRefN = Page.vfpReOpenCase;
        Test.setCurrentPage( pageRefN );

        ext = new ctrlRetrieveSolutions();
        
        Test.stopTest();
    }
    
}