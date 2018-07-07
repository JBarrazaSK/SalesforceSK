trigger trigCaseCommentbyEmail on EmailMessage (after insert) {

    if( Trigger.isAfter ) {
        if( Trigger.isInsert ) {
            handlerCaseCommentbyEmail ext = new handlerCaseCommentbyEmail();
            	ext.updateCustomerResponse();
        }
    }
}