public class PedidoController {

    private final Pedido__c pedido;
    
    public Boolean isMayoreo { get; private set; }
    
    public PedidoController(ApexPages.StandardController stdController) {
        this.pedido = (Pedido__c)stdController.getRecord();
        
        String tabId = ApexPages.currentPage().getParameters().get('sfdc.tabName');

        isMayoreo = false;
        for(Schema.DescribeTabSetResult dtsr : Schema.describeTabs()) {
            if(dtsr.isSelected()) {
               isMayoreo = dtsr.label.equalsIgnoreCase('Ventas');
               break;   
            }
        }
    }

}