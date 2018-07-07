public class ExtCaseDEvNote {
    private final Case Caso;
    public boolean Show {get;set;}
    public string NumCaso {get;set;}   
    public Factura factura{get;set;}   
   
  public ExtCaseDEvNote(ApexPages.StandardController stdController) {
  		RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' and name = 'SK-Queja'];
        this.Caso = (Case)stdController.getRecord();
        this.Caso.RecordType = rt;
        this.show  = true;
        if(this.caso.Id == null)
        {
        	Group Grupo = [select Id from Group where Type = 'Queue' and Name = 'SK-Quejas Portal Interno'];
        	this.caso.OwnerId = grupo.Id;
        	this.caso.Origin ='Portal Interno';
        	this.caso.Status = 'Nuevo';
        }
    }  
  
 
public void ConsultarFactura()
{
	WsDevolucionesSAP.DevolucionesSapSoap services  = new WsDevolucionesSAP.DevolucionesSapSoap();
	EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Req requestFactura = new EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Req();
	requestFactura.NumeroFactura = String.ValueOf(this.caso.No_Factura__c);
	EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Resp response = null;
	try
	{
		response = services.DetalleFactura(requestFactura);
		system.debug('Response: '+response);
		if(response != null)
		{
			if(response.TipoMensaje == 'S')
			{
				LlenarEntidadFactura(response.Datos);
			}
			else
			{
				showPageMessage('WARNING',response.Mensaje);
				return;
			}
		}
		else
		{
			showPageMessage('ERROR','Ocurrio un error al consultar la información');
			return;
		}
	}
	catch(Exception ex)
	{
		showPageMessage('ERROR',ex.getMessage());
		return;
	}
} 
public void GuardarCasoDevolucion()
{
	EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Req request = GenerarRequestDevoluciones('H');
	EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Resp Response = new EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Resp();
	WsDevolucionesSAP.DevolucionesSapSoap services  = new WsDevolucionesSAP.DevolucionesSapSoap();
	try
	{
		if(request == null)
			return;
			
		response = services.DevolucionSAP(request);
		
		if(response != null)
		{
			if(response.TipoMensaje == 'OK')
			{
				insert this.caso;
				NumCaso =  this.caso.CaseNumber;
				showPageMessage('CONFIRM',response.Mensaje);
			}
			else
			{
				showPageMessage('WARNING','(SAP) '+response.Mensaje);
				return;
			}
		}
		else
		{
			showPageMessage('ERROR','Ocurrio un error al consultar la información');
			return;
		} 
	}
	catch(Exception ex)
	{
		showPageMessage('ERROR',ex.getMessage());
		return;
	}
   
}
public EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Req GenerarRequestDevoluciones(String Tipo)
{
	EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Req request = new EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Req();
	EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element elementoDetalle = new EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element();
	request.NumeroFactura = string.ValueOf(this.caso.No_Factura__c);
	request.TipoMov = Tipo; //H para devolución / K para Nota de crédito
    request.MotivoPedido = 'Z01';//this.caso.SK_Escenario__c;
    request.Detalle = new list<EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element>();
    for(DetalleFactura dt : factura.ListaProductos )
    {
    	if(dt.Cantidad_Dev  != null  && dt.Cantidad_Dev > 0)
    	{
    		if(dt.Cantidad_Dev <= Integer.Valueof(dt.Cantidad.trim()))
    		{
	    		elementoDetalle = new EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element();
	    		elementoDetalle.Producto = Integer.Valueof(dt.CodigoProducto.trim());
	    		elementoDetalle.Cantidad = dt.Cantidad_Dev;
	    		elementoDetalle.Importe =  dt.Importe;
	    		elementoDetalle.UnidadMedida = dt.MedidaUnidad;
	    		request.Detalle.add(elementoDetalle);
    		}
    		else
    		{
    			showPageMessage('WARNING','Favor de capturar una cantidad valida');
				return null;
    		}
    	}
    }
    return request;
}
public void LlenarEntidadFactura(EntityConsultaFactura_SF_to_ECC.Datos_element[] Datos)
{
		factura = new Factura(); 
  		factura.CodigoCliente = String.ValueOf(Datos[0].Cabecero.CodigoCliente).leftpad(10,'0');
  		this.caso.AccountId = TraerCuenta(String.ValueOf(Datos[0].Cabecero.CodigoCliente)).id;
  		this.Caso.ContactId = TraerContacto(this.caso.AccountId).Id;
  		factura.NombreCliente = String.ValueOf(Datos[0].Cabecero.CodigoCliente)+' - '+Datos[0].Cabecero.DescripcionCliente;
  		factura.OficinaVentas = Datos[0].Cabecero.OficinaVentas;
  		setPicklist(Datos[0].Cabecero.OficinaVentas);
  		factura.Sucursal = Datos[0].Cabecero.Sucursal;
  		factura.CanalDistribucion = Datos[0].Cabecero.CanalDistribucion;
  		factura.GrupoVendedores = Datos[0].Cabecero.GrupoVendedores;
  		factura.ImporteFactura = String.ValueOf(Datos[0].Cabecero.ImporteFactura);
  		factura.Abonos = String.ValueOf(Datos[0].Cabecero.Abonos);
  		factura.Saldo = String.ValueOf(Datos[0].Cabecero.Saldo);
  		factura.Moneda = Datos[0].Cabecero.Moneda;
  		factura.FechaFactura = Datos[0].Cabecero.FechaFactura;
  		
  		factura.ListaProductos = new list<DetalleFactura>();
  		for(EntityConsultaFactura_SF_to_ECC.Detalle_element dt :Datos[0].Detalle)
  		{
  				DetalleFactura df = new DetalleFactura(); 
		  		df.CodigoProducto = dt.CodigoProducto;
		  		df.Descripcion = dt.Descripcion;
		  		df.MedidaUnidad = dt.MedidaUnidad;
		  		df.Cantidad = dt.Cantidad;
		  		df.SubFamilia = dt.SubFamilia;
		  		df.Volumen = dt.Volumen;
		  		df.Precio = dt.Precio;
		  		df.Importe = dt.Importe;
		  		factura.ListaProductos.add(df);
  		}
}
public void setPicklist(string OficinaVentas)
{
		Schema.DescribeFieldResult fieldResult = case.Oficina_de_Ventas__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		string value;
		string[] Arreglo = null;
		for( Schema.PicklistEntry pickListVal : ple){
			value = pickListVal.getLabel();
			if(value != 'NA')
			{
				Arreglo = value.split('-');
				if(Arreglo[0] == OficinaVentas)	
					this.caso.Oficina_de_Ventas__c = value;
			}
		} 
}
 public void showPageMessage(string level,string message) {

      if(level == 'WARNING') {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, message));
      }
       if(level == 'CONFIRM') {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, message));
      }
      if(level == 'ERROR') {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
      }
  }

public Account TraerCuenta(string NumeroCliente)
{
	RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Account' and name = 'Sucursal'];
	return [select id,Name from Account where Numero_Cliente_SAP__c =: 'SUC - '+NumeroCliente.leftpad(10,'0') and recordTypeID =:rt.Id ];
} 
public Contact TraerContacto (string IdCuenta)
{
	return [select id,Name  from Contact where AccountId =: IdCuenta]; 
}
public class Factura
{
	 public String CodigoCliente 			    {get;set;}
	 public String NombreCliente 				{get;set;}
	 public String OficinaVentas 				{get;set;}
	 public String Sucursal 				    {get;set;}
	 public String CanalDistribucion 			{get;set;}
	 public String GrupoVendedores 				{get;set;}
	 public String FechaFactura 				{get;set;}
	 public String ImporteFactura 				{get;set;}
	 public String Abonos 				        {get;set;}
	 public String Saldo 				        {get;set;}
	 public String Moneda 				        {get;set;}
	 public Decimal ImporteBonificar   {get;set;}
	 public list<DetalleFactura> ListaProductos {get;set;}
}
public class DetalleFactura
{
	 public Boolean Seleccionado    {get;set;}
	 public String CodigoProducto   {get;set;}
	 public String Descripcion      {get;set;}
	 public String MedidaUnidad     {get;set;}
	 public String Cantidad         {get;set;}
	 public Decimal Importe         {get;set;}
	 public Integer Cantidad_Dev    {get;set;}
	 public string SubFamilia       {get;set;}
	 public string Volumen          {get;set;}
	 public Decimal Precio          {get;set;}
	 public Decimal PrecioReal      {get;set;}
	 public Decimal VolumenReal          {get;set;}
}     

}