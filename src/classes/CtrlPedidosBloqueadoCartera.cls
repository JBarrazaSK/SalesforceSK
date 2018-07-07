public with sharing class CtrlPedidosBloqueadoCartera {
 public opportunity opp{get;set;}
 public opportunity opp2{get;set;}
public list<PedidosWrapper> listaPedidos{get;set;}

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
 public CtrlPedidosBloqueadoCartera()
 {
 	opp = new opportunity();
  opp2 = new opportunity();
	listaPedidos = new list<PedidosWrapper>();
 }
  public void ObtenerPedidosRetenidos()
  {
	  if(opp.Fecha_de_Embarque__c != null)
	  {
	  	listaPedidos = CtrlPedidosBloqueadoCarteraDAO.ObtenerPedidosRetenidos(opp.Fecha_de_Embarque__c,opp.Cliente__c,opp.Folio_Pedido_SDL__c,Opp.Canal_Factura__c,Opp.OwnerId,opp2.Fecha_de_Embarque__c);
	  	if(listaPedidos == null)
	  	{
	  		listaPedidos = new list<PedidosWrapper>();
	  		return;
	  	}

	  	if(listaPedidos.size() == 0)
	  	{
	  		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'No se encontraron pedidos con los criterios seleccionados'));
	  	}
	  }
	  else
	  	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Favor de capturar la fecha de embarque'));

  }
  public void RecharzarPedido()
  {
    if(CtrlPedidosBloqueadoCarteraDAO.IsLocked(listaPedidos))
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El pedido se encuentra en un proceso de aprobación no se puede Rechazar.'));
        return;
    }
   else if(!CtrlPedidosBloqueadoCarteraDAO.RecharzarPedidos(listaPedidos))
   {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Debe de seleccionar el pedido a validar'));
   }

  }
  public void ValidarCartera()
  {
      if(CtrlPedidosBloqueadoCarteraDAO.IsLocked(listaPedidos))
      {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'El pedido se encuentra en un proceso de aprobación no se puede Liberar.'));
          return;
      }
  	 else if(!CtrlPedidosBloqueadoCarteraDAO.ValidarCarteraWs(listaPedidos))
  	   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Debe de seleccionar el pedido a validar'));
  }
}