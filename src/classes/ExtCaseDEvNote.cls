public class ExtCaseDEvNote {
    public Case Caso;
    public boolean Show {get;set;}
    public boolean isVisbleGuardar {get;set;}
    public string NumCaso {get;set;}   
    public Factura factura{get;set;}   
    public string idCaso {get;set;}   
    public string Numfactura {get;set;}   
    public string nombreContacto {get;set;}
    public ExtCaseDEvNote(){}
 
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
            this.caso.SK_Categoria__c =  'Devolución';
        	this.Caso.Repartidor__c =  new Contact().Id;
        }

    }  
    public void limpiar()
    {
     
         //this.caso =  new Case();   
        factura = new Factura(); 
        NumCaso = '';
    } 
    
    public void ConsultarFactura()
    {
        limpiar();
        isVisbleGuardar = true;
        WsDevolucionesSAP.DevolucionesSapSoap services  = new WsDevolucionesSAP.DevolucionesSapSoap();
        EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Req requestFactura = new EntityConsultaFactura_SF_to_ECC.DT_SE_ConsultaFactura_Req();
        requestFactura.NumeroFactura = String.ValueOf(Numfactura);
        //this.caso.No_Factura__c = decimal.ValueOf(Numfactura);   
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
                    RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' and name = 'SK-Queja'];
                    system.debug('rt '+ rt);
                    list<case> ListaCasos = [select id,CaseNumber,No_Factura__c,Folio_DocumentoSAP__c,ContactId,AccountId,SK_Categoria__c,Oficina_de_Ventas__c,SK_SubCategoria_Tipo__c,Nivel_Centro__c,SK_Escenario__c,Origen__c,SK_Descripcion_de_Caso_Causa__c,Repartidor__c,TIF__c,Description from case where recordTypeId =: rt.Id and No_Factura__c =: this.caso.No_Factura__c];		
                    if(ListaCasos != null && ListaCasos.size() > 0)
                    {
                        idCaso =  ListaCasos[0].id;
                        NumCaso = ListaCasos[0].CaseNumber;	
                    }
                    
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
            isVisbleGuardar = false;
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
		system.debug('RESPONSE_GUARDARDEVOLUCION=> '+ response);
		if(response != null)
		{
			if(response.TipoMensaje == 'OK')
			{
                system.debug('CASO=> '+  THIS.CASO);
                this.caso.Folio_DocumentoSAP__c = String.isBlank(this.caso.Folio_DocumentoSAP__c) ? response.Datos.NumeroMov:this.caso.Folio_DocumentoSAP__c+','+response.Datos.NumeroMov;
                this.caso.id = string.isNotBlank(idCaso)?idCaso:null;
                this.caso.No_Factura__c = decimal.valueOf(Numfactura);
				upsert this.caso;
				list<case> ListaCasos = [select id,CaseNumber,No_Factura__c,Folio_DocumentoSAP__c,ContactId,AccountId,SK_Categoria__c,Oficina_de_Ventas__c,SK_SubCategoria_Tipo__c,Nivel_Centro__c,SK_Escenario__c,Origen__c,SK_Descripcion_de_Caso_Causa__c,Repartidor__c,TIF__c,Description from case where id =: this.caso.id];
				NumCaso = ListaCasos[0].CaseNumber;
				isVisbleGuardar = false;
                 factura.ListaProductos =  null;
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
        system.debug('ERROR=> '+ex.getMessage());
		showPageMessage('ERROR',ex.getMessage());
		return;
	}
   
}
public EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Req GenerarRequestDevoluciones(String Tipo)
{
	EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Req request = new EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Req();
	EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element elementoDetalle = new EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element();
	request.NumeroFactura = string.ValueOf(Numfactura);
	request.TipoMov = Tipo; //H para devolución / K para Nota de crédito
    request.MotivoPedido = 'Z01';//this.caso.SK_Escenario__c;
    request.Detalle = new list<EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element>();
    integer contador = 0;
    for(DetalleFactura dt : factura.ListaProductos )
    {       
        if(dt.Cantidad_Dev == 0) contador++; 
    }
    if(contador == factura.ListaProductos.size())
    {
        showPageMessage('WARNING','Favor de capturar una cantidad valida.');
        return null;    
    }
    else
    {
        for(DetalleFactura dt : factura.ListaProductos )
        {
            system.debug('DETALLE=>>'+dt.Cantidad_Dev +' CANTIDAD=> '+dt.Cantidad.trim());
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
    }
    return request;
}
public void LlenarEntidadFactura(EntityConsultaFactura_SF_to_ECC.Datos_element[] Datos)
{
		factura = new Factura();
  		factura.CodigoCliente = String.ValueOf(Datos[0].Cabecero.CodigoCliente).leftpad(10,'0');
  		system.debug('CLIENTE=> '+ factura.CodigoCliente +' CodigoCliente=> '+ String.ValueOf(Datos[0].Cabecero.CodigoCliente));
  		//this.caso.AccountId = TraerCuenta(String.ValueOf(Datos[0].Cabecero.CodigoCliente)).Id;
  		system.debug('CUENTA=> '+ this.caso.AccountId);  
    	String cuentaId = TraerCuenta(String.ValueOf(Datos[0].Cabecero.CodigoCliente)).Id;
    	if(cuentaId == null)
		{
	  		showPageMessage('WARNING','Cliente no cuenta con una sucursal configurada.');
	  		return;
	  	}
  		Contact contacto = TraerContacto(cuentaId);		
  		/*if(contacto == null)
		{
	  		showPageMessage('WARNING','No se encuentro un contacto asociado a la cuenta.');
	  		return;
	  	}*/
    	nombreContacto =  contacto.Name;
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
    this.Caso.ContactId = contacto.Id; 
    this.caso.AccountId = cuentaId; 
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
    system.debug('TRAERCUENTA=> '+ NumeroCliente);
	RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Account' and name = 'Sucursal'];
    system.debug('RECORD=> '+ rt);
    Account cuenta = new Account();
    try{
        cuenta = [select id,Name from Account where Numero_Cliente_SAP__c =: 'SUC - '+NumeroCliente.leftpad(10,'0') and recordTypeID =:rt.Id ];
        system.debug('CUENTA=> '+ cuenta);
    }catch(Exception e)
	{
		
	}
	return cuenta;
} 
public Contact TraerContacto (string IdCuenta)
{
    system.debug('cuentaid=> '+ IdCuenta);
	Contact contacto = new Contact();
	try{
		contacto = [SELECT id,Name  FROM Contact WHERE AccountId =: IdCuenta Limit 1];
	}
	catch(Exception e)
	{
		
	}
	system.debug('CONTACTO=> '+ contacto);
	return contacto;
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
	 public Decimal ImporteBonificar            {get;set;}
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
	 public integer Cantidad_Dev    {get;set;}
	 public string SubFamilia       {get;set;}
	 public string Volumen          {get;set;}
	 public Decimal Precio          {get;set;}
	 public Decimal PrecioReal      {get;set;}
	 public Decimal VolumenReal     {get;set;}
}     

}