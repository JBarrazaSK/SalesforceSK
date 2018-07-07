/*******************************************************************************
Copyright © 2015 Lynx9. All rights reserved. 
Author: Jorge Terán
Email: sf@lynx9.com
Description: Unit Test for controller to upload manually document
********************************************************************************/
@isTest(seeAllData=true)
private class ctrlUploadDocuments_UT {

    static Account acc;
    static Contact contactC;
    static Case caseSC;
    
    static final String RTYPE_Queja = getRecordType('Case', 'SK-Queja');
    static final String RTYPE_Acc = getRecordType('Account', 'Sucursal');
    
    static testMethod void successTest() {
        Test.startTest();
		
        createAcc();
        createContact();
        createCaseSC();
        
        PageReference pageRefQ = Page.vfpUploadDocuments;
        Test.setCurrentPage( pageRefQ );
        ApexPages.currentPage().getParameters().put('idCase', caseSC.Id );
        
        ctrlUploadDocuments ctrl = new ctrlUploadDocuments();
        ApexPages.Pagereference error = ctrl.upload();
        //System.assert(error==null);
        ctrl.attachment = createAttach();
        ctrl.attachment1 = createAttach();
        ctrl.attachment2 = createAttach();
        ctrl.attachment3 = createAttach();
        ctrl.attachment4 = createAttach();
        ctrl.attachment5 = createAttach();
        ctrl.attachment6 = createAttach();
        ctrl.attachment7 = createAttach();
        ctrl.attachment8 = createAttach();
        ctrl.attachment9 = createAttach();
        error = ctrl.upload();
        //System.assert(error==null);
        ApexPages.Pagereference success = ctrl.upload();
        //System.assert(success!=null);
        
        PageReference pageRefQE = Page.vfpUploadDocuments;
        Test.setCurrentPage( pageRefQE );
        ApexPages.currentPage().getParameters().put('idCase', '' );
        
        ApexPages.Pagereference error1 = ctrl.upload();
        System.assert(error1==null);
        ctrl.attachment = createWAttach();
        error1 = ctrl.upload();
        
        Test.stopTest();
    }
    
    static Attachment createAttach(){
        Attachment attachment = new Attachment();
            attachment.body = Blob.valueOf( 'this is an attachment test' );
            attachment.name = 'fake attachment';
            attachment.parentId = caseSC.id;
        return attachment;
    }
    
    static Attachment createWAttach(){
        Attachment attachment = new Attachment();
            attachment.body = Blob.valueOf( 'this is an attachment test' );
            //attachment.name = 'fake attachment';
            attachment.parentId = caseSC.id;
        return attachment;
    }
    
    static void createCaseSC() {
        caseSC = new Case(); 
        	caseSC.RecordTypeId = RTYPE_Queja;
        	caseSC.SK_Categoria__c = 'Cartera';
        	caseSC.AccountId = acc.Id;
        insert caseSC;
    }
    
    static void createContact() {
        contactC = new Contact();
        	contactC.AccountId = acc.Id;
        	contactC.LastName = 'Test';
        	contactC.Email = 'sf@lynx9.com';
        	contactC.Phone = '667667667';
        insert contactC;
    }
    
    static void createAcc() {
        acc = new Account(); 
        	acc.RecordTypeId = RTYPE_Acc;
        	acc.Name = 'Test';
		insert acc;
    }
    
    static String getRecordType(String obj, String rtName){
        return [Select Id From RecordType Where SobjectType = :obj and Name=:rtName LIMIT 1].Id;
    }
}