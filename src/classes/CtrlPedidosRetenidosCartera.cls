public with sharing class CtrlPedidosRetenidosCartera {
public opportunity opp{get;set;}
public opportunity opp2{get;set;}
public list<PedidosWrapper> listaPedidos{get;set;}
private String MsgDate = 'Favor de capturar la fecha de embarque';
private String MsgNotFound = 'No se encontraron pedidos con los criterios seleccionados';
private string MsgNotSelected = 'Debe de seleccionar el pedido a validar';
private string MsgValidDate = 'la fecha de embarque final no puede ser menor a la inicial.';
  public class PedidosWrapper {
        public Boolean Seleccionado {get;set;}
        public opportunity Pedido {get;set;}
        public Decimal Importe {get;set;}
        public Decimal SaldoActual {get;set;}
        public Decimal SaldoVencido {get;set;}
        public Integer DocumentosVencidos{get;set;}
        public Decimal LimiteDeCredito {get;set;}
        public Decimal CreditoDisponible {get;set;}
        public Decimal SaldoPedidos {get;set;}
        public Boolean Liberado {get;set;}
      	public Decimal SaldoSF {get;set;}
        public PedidosWrapper() {

        }
    }
  public  CtrlPedidosRetenidosCartera()
  {
  		opp = new opportunity();
      opp2 = new opportunity();
  		listaPedidos = new list<PedidosWrapper>();
  }
  public void ObtenerPedidosRetenidos()
  {
	  if(opp.Fecha_de_Embarque__c != null)
	  {
      if(opp2.Fecha_de_Embarque__c != null)
      {
          if(opp2.Fecha_de_Embarque__c < opp.Fecha_de_Embarque__c)
          {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,MsgValidDate));
              return;
          }
      }
	  	listaPedidos = CtrlPedidosRetenidosCarteraDAO.ObtenerPedidosRetenidos(opp.Fecha_de_Embarque__c,opp.Cliente__c,opp2.Fecha_de_Embarque__c,Opp.Canal_Factura__c,opp.Folio_Pedido_SDL__c,Opp.OwnerId);
	  	if(listaPedidos == null)
	  	{
	  		listaPedidos = new list<PedidosWrapper>();
	  		return;
	  	}
	  	if(listaPedidos.size() == 0)
	  	{
	  		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,MsgNotFound));
	  	}
	  }
	  else
	  	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,MsgDate));

  }
  public void ValidarCartera()
  {
  	  if(!CtrlPedidosRetenidosCarteraDAO.ValidarCarteraWs(listaPedidos))
  	   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,MsgNotSelected));
  }
}