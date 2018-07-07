/*******************************************************************************
Copyright © 2016 Lynx9. All rights reserved. 
Author: jose barraza
Email: jose.barraza@sukarne.com
Description: Schedulable to Factura__c daily deletion.
********************************************************************************/
global without sharing class schdDeleteFacturas implements Schedulable {
    
    global void execute(SchedulableContext sc){
        ctrlDeleteFacturas delBatch = new ctrlDeleteFacturas();
            delBatch.deleteAllFacturas();
    }

}