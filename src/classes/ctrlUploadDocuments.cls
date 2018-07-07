/*******************************************************************************
Copyright © 2015 Lynx9. All rights reserved. 
Author: Jorge Terán
Email: sf@lynx9.com
Description: Manual upload evidence
********************************************************************************/
public without sharing class ctrlUploadDocuments{
    
    public String idCase {get; set;}
    //public String ownerId {get; set;}
    public Attachment attachment {get; set;}
    public Attachment attachment1 {get; set;}
    public Attachment attachment2 {get; set;}
    public Attachment attachment3 {get; set;}
    public Attachment attachment4 {get; set;}
    public Attachment attachment5 {get; set;}
    public Attachment attachment6 {get; set;}
    public Attachment attachment7 {get; set;}
    public Attachment attachment8 {get; set;}
    public Attachment attachment9 {get; set;}

    public List<Attachment> attachs {get; set;}
    
	
    public ctrlUploadDocuments() {
        idCase = (String)ApexPages.currentPage().getParameters().get('idCase');
        this.init();
    }
    
    private void init() {
        attachment = new Attachment();
        attachment1 = new Attachment();
        attachment2 = new Attachment();
        attachment3 = new Attachment();
        attachment4 = new Attachment();
        attachment5 = new Attachment();
        attachment6 = new Attachment();
        attachment7 = new Attachment();
        attachment8 = new Attachment();
        attachment9 = new Attachment();
        attachs = new List<Attachment>();
    }
    /*
    private void retrieveOwnerId() {
        ownerId = [SELECT CreatedById FROM Case WHERE Id =: idCase].Owner.Id;
    }
    */
    public PageReference upload() {
        if( String.isBlank( idCase ) ) {
            ApexPages.addMessage( new ApexPages.message(ApexPages.severity.ERROR, 'No se encontró identificador del caso! Por favor póngase en contacto con su Administrador.' ) );
            return null;
        }
        
        if( !String.isBlank(attachment.Name) ) {
            //String content1 = this.setContentType( this.isValidAttachment( attachment ) );
            //if( !String.isBlank( content1 ) ) {
            //    attachment.ContentType = content1;
            //}
            attachment.ParentId = idCase; 
            attachment.IsPrivate = false;
            attachs.add(attachment);
        }
        if( !String.isBlank(attachment1.Name) ) {
            attachment1.ParentId = idCase; 
            attachment1.IsPrivate = false;
            attachs.add(attachment1);
        }
        if( !String.isBlank(attachment2.Name) ) {
            attachment2.ParentId = idCase; 
            attachment2.IsPrivate = false;
            attachs.add(attachment2);
        }
        if( !String.isBlank(attachment3.Name) ) {
            attachment3.ParentId = idCase; 
            attachment3.IsPrivate = false;
            attachs.add(attachment3);
        }
        if( !String.isBlank(attachment4.Name) ) {
            attachment4.ParentId = idCase; 
            attachment4.IsPrivate = false;
            attachs.add(attachment4);
        }
        if( !String.isBlank(attachment5.Name) ) {
            attachment5.ParentId = idCase; 
            attachment5.IsPrivate = false;
            attachs.add(attachment5);
        }
        if( !String.isBlank(attachment6.Name) ) {
            attachment6.ParentId = idCase; 
            attachment6.IsPrivate = false;
            attachs.add(attachment6);
        }
        if( !String.isBlank(attachment7.Name) ) {
            attachment7.ParentId = idCase; 
            attachment7.IsPrivate = false;
            attachs.add(attachment7);
        }
        if( !String.isBlank(attachment8.Name) ) {
            attachment8.ParentId = idCase; 
            attachment8.IsPrivate = false;
            attachs.add(attachment8);
        }
        if( !String.isBlank(attachment9.Name) ) {
            attachment9.ParentId = idCase; 
            attachment9.IsPrivate = false;
            attachs.add(attachment9);
        }
        
        if( attachs.size() > 0 ) {
            try {
                insert attachs;
                System.debug('Archivo Anexado!');
            } catch ( DMLException e ) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Hubo un error al anexar su archivo! Vuelva a intentarlo por favor. ' + e.getMessage()));
                return null;
            } 
            catch ( Exception e ) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Hubo un error al anexar su archivo! Vuelva a intentarlo por favor. ' + e.getMessage()));
                return null;
            }
            finally {
                init();
            }
        }
        else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Seleccione al menos un archivo para anexar!'));
            return null;
        }
        
        System.debug('Redireccionando!');
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Su(s) archivo(s) se anexaron correctamente a su caso!'));
        //PageReference pref = new PageReference('./vfpFilesUploaded');
        //	pref.setRedirect(true);
        return null;
    }
    /*
    private String setContentType( String extension ) {
        if( String.isBlank( extension ) ) { return null; }
        
        if( extension.toUpperCase() == 'PDF' ) {
            return 'application/pdf';
        }
        else if( extension.toUpperCase() == 'DOC' || extension.toUpperCase() == 'DOCX' ) {
            return 'application/msword';
        }
        else if( extension.toUpperCase() == 'XLS' || extension.toUpperCase() == 'XLSM' || extension.toUpperCase() == 'XLSX' ) {
            return 'application/vnd.ms-excel';
        }
        else if( extension.toUpperCase() == 'PPT' || extension.toUpperCase() == 'PPSM' || extension.toUpperCase() == 'PPTX' ) {
            return 'application/vnd.ms-powerpoint';
        }
        else if( extension.toUpperCase() == 'XML' ) {
            return 'application/xml';
        }
        else if( extension.toUpperCase() == 'TXT' ) {
            return 'text/plain';
        }
        
        return null;
    }
    
    private String isValidAttachment( Attachment attach ) {
        String extension = '';
        
        if( attach == null ) { return extension; }
        if( attach.Name == null ) { return extension; }
        if( attach.Body == null ) { return extension; }
       
        if( attach.Body.size() == 0 ) { return extension; }
        
        String[] attachNameParts = attach.Name.split('\\.');
        if( attachNameParts.size() < 2 ) { return extension; }
        extension = attachNameParts[1];
        
        System.debug('File Extension: ' + extension);
        return extension;
    }*/
}