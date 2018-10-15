public without sharing class ExtCaseBonificaciones {
 	public Case Caso                          {get; set;}
    public Case CasoConsultado                {get; set;}
    public boolean Show                       {get; set;}
    public string NumCaso                     {get; set;}    
    public Factura factura                    {get; set;} 
    public List<SelectOption> Motivos         {get; set;}
    public List<SelectOption> Aplicacion      {get; set;}
    public string Motivo                      {get; set;}
    public String TipoAplicacion              {get; set;}
    public Boolean DisabledImporte            {get; set;}
    public Boolean DisabledVolumen            {get; set;}
    public Boolean DisabledPrecio             {get; set;}
    public Integer NumeroFactura 			  {get; set;}
    public boolean DisableGuardar 			  {get; set;}
    public boolean DisableAceptar 				{get;set;}
    public Integer CountList 			  	{get; set;}   
    public decimal importe 			  		{get; set;}  
    public boolean clickCancelar {get;set;}
    public EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Req request;
    
/* public ExtCaseBonificaciones(ApexPages.StandardController stdController) {
  		RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' and name = 'SK-Queja'];
        this.Caso = (Case)stdController.getRecord();
        this.Caso.RecordType = rt;
        this.show  = true;
       
    }  */
    
 public ExtCaseBonificaciones(){
     Caso = new case();
     DisableAceptar =  false;
     importe = 0;
     clickCancelar  =  false;
 }
 public void ConsultarFactura()
{
    DisableGuardar =  true; 
    clickCancelar  =  false;
    fillMotivos();
    importe = 0;
	RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' and name = 'SK-Queja'];
	system.debug('rt '+ rt);
	list<case> ListaCasos = [select id,CaseNumber,No_Factura__c,Folio_DocumentoSAP__c from case where recordTypeId =: rt.Id and No_Factura__c =: NumeroFactura AND Status='EN PROCESO'];
	
	system.debug('ListaCasos '+ ListaCasos +'NumeroFactua=> '+ NumeroFactura);
	
	if(ListaCasos != null && ListaCasos.size() > 0)
	{
		Caso = ListaCasos[0];
		NumCaso = ListaCasos[0].CaseNumber;
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
					Motivos = fillMotivos();
					DisabledImporte  = true;     
    				DisabledVolumen  = true; 
    				DisabledPrecio   = true; 
					
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
             DisableGuardar =  false;
			showPageMessage('ERROR',ex.getMessage());
			return;
            
		}
	}
	else
	{
		showPageMessage('WARNING','La factura no se encuentra ligada a un caso de queja.');
	}
} 
public void GuardarCasoDevolucion()
{
	
	/*EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Req request = GenerarRequestDevoluciones('K');
	system.debug('REQUEST '+ request);
	if(request == null)
		return;
	*/	
	EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Resp Response = new EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Resp();
	WsDevolucionesSAP.DevolucionesSapSoap services  = new WsDevolucionesSAP.DevolucionesSapSoap();
	try
	{
		response = services.DevolucionSAP(request);	
		system.debug('response ---> '+ response);
		
		if(response != null)
		{
			if(response.TipoMensaje == 'OK')
			{
               	this.caso.Folio_DocumentoSAP__c = String.isBlank(this.caso.Folio_DocumentoSAP__c) ? response.Datos.NumeroMov: this.caso.Folio_DocumentoSAP__c +','+response.Datos.NumeroMov;
				update this.caso;
				showPageMessage('CONFIRM',response.Mensaje);
                DisableGuardar =  false;
                DisableAceptar =  false;
                factura.ListaProductos =  null;
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
public EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Req GenerarRequestDevoluciones(String Tipo)
{
	EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Req request = new EntityDevolucionNotaCredito_SF_to_ECC.DT_SE_DevolucionNotaCredito_Req();
	EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element elementoDetalle = new EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element();
	request.NumeroFactura = string.ValueOf(this.caso.No_Factura__c);
	request.TipoMov = Tipo; //H para devolución / K para Nota de crédito
    request.MotivoPedido = this.Motivo;
    request.Detalle = new list<EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element>();
    if(TipoAplicacion == 'IMPORTE GENERAL')
    {
        if(factura.ImporteBonificar  == 0)
        {
            showPageMessage('ERROR','No puede capturar un importe igual a 0.');
            return null;
        }
        if(factura.ImporteBonificar > Decimal.ValueOf(factura.Saldo))
        {
            showPageMessage('ERROR','No puede capturar un importe mayor al saldo de la factura.');
            return null;
        }
    }
    integer contador = 0;
    for(DetalleFactura dt : factura.ListaProductos ){
        if(TipoAplicacion == 'PRECIO' && dt.PrecioReal == 0){
             contador++; 
        }else if(TipoAplicacion == 'PESO' && dt.VolumenReal == 0 ){
            contador++; 
        }               
    }
   
    if(contador== factura.ListaProductos.size()){
         if(TipoAplicacion == 'PRECIO')
             showPageMessage('ERROR','Favor de capturar un precio valido.');
         else if(TipoAplicacion == 'PESO')
             showPageMessage('ERROR','Favor de capturar un volumen valido.');     
        
		return null;
    }else
    {
        for(DetalleFactura dt : factura.ListaProductos )
        {  
            EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element generaDetalle = GenerarDetalle(dt,factura);       
            if(generaDetalle== null)
            {
                request = null;
                breaK;            
            }else
            {
                if(TipoAplicacion == 'PRECIO' && dt.PrecioReal > 0 
                   || TipoAplicacion == 'PESO' && dt.VolumenReal > 0
                    || TipoAplicacion == 'IMPORTE GENERAL' 
                    ){
                        request.Detalle.add(generaDetalle);
                }
            }
        }
    }
    return request;
}
public EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element GenerarDetalle(DetalleFactura dt, factura factura)
{	
	EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element elementoDetalle = new EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element();
    try
    {
        if(TipoAplicacion == 'PRECIO' && dt.PrecioReal > 0)
        { 
            if(dt.precio <= dt.PrecioReal)
            {
                showPageMessage('WARNING','No puede capturar un precio real mayor al precio del material. Favor de validar.');
                return null;
            }
            system.debug('VOLUMENT=> '+ Decimal.ValueOf(dt.Volumen.trim())+' -- '+dt.PrecioReal+' -- '+dt.precio);
            elementoDetalle.Producto = Integer.Valueof(dt.CodigoProducto.trim());
            elementoDetalle.Cantidad = Integer.Valueof(dt.Cantidad.trim());
            elementoDetalle.Importe =  Decimal.ValueOf(dt.Volumen.trim()) * parseAbsolute(dt.PrecioReal-dt.precio);
            elementoDetalle.UnidadMedida = dt.MedidaUnidad;
        }
        else if(TipoAplicacion == 'PESO' && dt.VolumenReal>0)
        {
            if(Decimal.ValueOf(dt.Volumen.trim()) <= dt.VolumenReal)
            {
                showPageMessage('WARNING','No puede capturar un volumen real mayor al volumen del material. Favor de validar.');
                return null;
            }
            elementoDetalle.Producto = Integer.Valueof(dt.CodigoProducto.trim());
            elementoDetalle.Cantidad = Integer.Valueof(dt.Cantidad.trim());
            //elementoDetalle.Importe =  dt.VolumenReal * dt.precio;
            elementoDetalle.Importe =  parseAbsolute(dt.VolumenReal-Decimal.ValueOf(dt.Volumen.trim())) * dt.precio;
            elementoDetalle.UnidadMedida = dt.MedidaUnidad;
        }
        else
        {
            Decimal importeFactura   = dt.Importe/decimal.valueOf(factura.ImporteFactura)*factura.ImporteBonificar;	 
            elementoDetalle.Producto =   	Integer.Valueof(dt.CodigoProducto.trim());
            elementoDetalle.Cantidad =   	Integer.Valueof(dt.Cantidad.trim());
            elementoDetalle.Importe  =  	parseAbsolute(importeFactura);
            elementoDetalle.UnidadMedida = 	dt.MedidaUnidad;
        }
       importe += elementoDetalle.Importe;
    }
    catch(Exception e){
       showPageMessage('WARNING','Ocurrio un problema al generar la información para la bonificación. Favor de validar.');
       elementoDetalle = null; 
    }
	return elementoDetalle;
}
    PUBLIC decimal parseAbsolute(decimal numero){
        numero= numero < 0 ? numero * (-1) : numero;        
        return numero;
    }
public void LlenarEntidadFactura(EntityConsultaFactura_SF_to_ECC.Datos_element[] Datos)
{
		factura = new Factura(); 
  		factura.CodigoCliente = String.ValueOf(Datos[0].Cabecero.CodigoCliente);
  		factura.NombreCliente = String.ValueOf(Datos[0].Cabecero.CodigoCliente)+' - '+Datos[0].Cabecero.DescripcionCliente;
  		factura.OficinaVentas = Datos[0].Cabecero.OficinaVentas;
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
    CountList =  factura.ListaProductos.size();
  system.debug('FACTURA=> '+ factura);
   
  
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
public static List<SelectOption> fillMotivos() {
        List<Motivos_Bonificacion__c> frntrs = Motivos_Bonificacion__c.getall().values();
        List<SelectOption> fronteras = new List<SelectOption>();
        System.debug('FronterasConf: ' + frntrs);
        if( frntrs.size() > 0 ) {
            fronteras = new List<SelectOption>();
            SelectOption opt1 = new SelectOption( '', '--- Seleccionar ---' );
            fronteras.add( opt1 );
            for( Motivos_Bonificacion__c f: frntrs ) {
                if( f == null ) { continue; }
                SelectOption opt = new SelectOption( f.Value__c, f.Value__c+'-'+f.Descripcion__c);
                fronteras.add( opt );
            }
        }

        return fronteras;
}
public  List<SelectOption> fillAplicacion(string motivo) {
        List<Configuracion_Aplicacion__c> frntrs = Configuracion_Aplicacion__c.getall().values();
        List<SelectOption> fronteras = new List<SelectOption>();
        System.debug('FronterasConf: ' + frntrs);
        if( frntrs.size() > 0 ) {
            fronteras = new List<SelectOption>();
            SelectOption opt1 = new SelectOption( '', '--- Seleccionar ---' );
            fronteras.add( opt1 );
            for( Configuracion_Aplicacion__c f: frntrs ) {
                if( f == null ) { continue; }
                if(f.Tipo_Motivo__c != motivo) { continue; }
                SelectOption opt = new SelectOption( f.Descripcion__c,f.Descripcion__c);
                fronteras.add( opt );
            }
        }
        return fronteras;
}
public  void   FillAplicacionOptions()
{
    importe =  0;
    factura.ImporteBonificar = 0;    
	Aplicacion = fillAplicacion(Motivo);
}
public  void   SelectedAplicacion()
{
	if(TipoAplicacion == 'PRECIO')
	{
		DisabledImporte  = true;     
    	DisabledVolumen  = true; 
    	DisabledPrecio   = false;
        if(DisableGuardar)
             for(DetalleFactura dt : factura.ListaProductos )
        			dt.VolumenReal = 0;
	}
	else if(TipoAplicacion == 'PESO')
	{
		DisabledImporte  = true;     
    	DisabledVolumen  = false; 
    	DisabledPrecio   = true;
        if(DisableGuardar)
             for(DetalleFactura dt : factura.ListaProductos )
        			dt.PrecioReal = 0;
	}
	else if(TipoAplicacion == 'IMPORTE GENERAL')
	{
		DisabledImporte  = false;     
    	DisabledVolumen  = true; 
    	DisabledPrecio   = true;
	}
    else{
        DisabledImporte   = true;
    }
}
    public void CancelarGuardado()
    { 
        importe = 0;
        DisableGuardar =  true; 
        DisableAceptar =  false;
        SelectedAplicacion();
        GeneraDevoluciones();
    }
    public void GeneraDevoluciones(){
        importe = 0;
     	for(DetalleFactura dt : factura.ListaProductos )
        {  
            EntityDevolucionNotaCredito_SF_to_ECC.Detalle_element generaDetalle = GenerarDetalle(dt,factura); 
            if(generaDetalle==null)
                break;
        }
    }
    public void Confirmacion()
    {    
        DisabledVolumen  = true; 
        DisabledPrecio   = true;  
        importe = 0;
       request = GenerarRequestDevoluciones('K'); 
        if(request == null){  
            SelectedAplicacion();
            return;
        }
        else
        {
            showPageMessage('WARNING','¿Está seguro de guardar la bonificación?'); 
            DisableGuardar =  false; 
            DisableAceptar =  true;
       }
    }
public class Factura
{
    public String CodigoCliente 			    {get;set;}
    public String NombreCliente 				{get;set;}
    public String OficinaVentas 				{get;set;}
    public String Sucursal 				   		{get;set;}
    public String CanalDistribucion 			{get;set;}
    public String GrupoVendedores 				{get;set;}
    public String FechaFactura 					{get;set;}
    public String ImporteFactura 				{get;set;}
    public String Abonos 				        {get;set;}
    public String Saldo 				        {get;set;}
    public String Moneda 				        {get;set;}
    public Decimal ImporteBonificar   			{get;set;}
    public list<DetalleFactura> ListaProductos 	{get;set;}
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