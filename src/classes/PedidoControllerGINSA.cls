public class PedidoControllerGINSA {
    
    private final Opportunity pedido;
    
    public Boolean isMayoreo { get; private set; }
    
    public PedidoControllerGINSA(ApexPages.StandardController stdController) {
        this.pedido = (Opportunity)stdController.getRecord();
        
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