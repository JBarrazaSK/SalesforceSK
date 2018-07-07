/***************************************
Copyright © 2015 Lynx9. All rights reserved. 
Author: Jorge Terán
Email: sf@lynx9.com
Description: *Controlador para traer todas las soluciones cargadas
***************************************/
public class ctrlRetrieveSolutions {
    
    public String subject {get; set;} 
    public List<Solution> solutions {get; set;}
    
    public ctrlRetrieveSolutions() {
    	subject = ApexPages.currentPage().getParameters().get('subject'); 
        if( subject == null ) {
            subject = '';
        }

        try {
        	this.retrieveSolutions( subject );
        } 
        catch( Exception e ) {
            System.debug('There was an error consulting Solutions: ' + e.getMessage());
            solutions = new List<Solution>();
        }
    }
    
    private void retrieveSolutions( String subject ) {
        String ls = '%'+subject+'%';
        solutions = [SELECT SolutionNumber, Status, SolutionName, SolutionNote 
                     FROM Solution
                     WHERE Status = 'Reviewed' 
                     AND SolutionName LIKE :ls
                    ];
    }
}