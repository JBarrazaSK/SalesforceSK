public with sharing class CtrlReporteInventario {
	public static String Canal {get; set;}
	public static String CodigoAlmacen {get; set;}
    public static String NombreAlmacen {get; set;}
    public list<Portafolio__c> listaDisponibilidad{get; set;}
    public static string AlmacenId {get; set;}
    public static List<SelectOption> options {get; set;}
    public List<string> rangoFechas {get; set;}
	public static Date fechaInicial{get; set;}
	public static Date fechaFin {get; set;}
	public String message {get; set;}
	public String level {get; set;}   
	public static map<string,string> mapProd {get; set;}
	public static Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>> mapDispoResp	{get; set;}

	public static Map<String, Oficina_de_Venta__c> MapAlmacenes {
        get {
            if(MapAlmacenes == null) {
                
                MapAlmacenes = CtrlReporteInventarioDAO.getOficinaVentas();
             }
            return MapAlmacenes;
        }
        set;
    }
	public CtrlReporteInventario() {
		
			fechaInicial = Date.today();
			fechaFin = Date.today().addDays(6);
		
		
	}
	public static List<SelectOption> getItems() { 
        options = new List<SelectOption>();
        options.add(new SelectOption('','Seleccione'));
        options.add(new SelectOption('A','Autoservicio'));
        options.add(new SelectOption('M','Mayoreo'));
        options.add(new SelectOption('E','Exportacion'));
        return options;
	}
	public static map<string,string> obtenerPortafolio()
	{
		mapProd = new map<string,string>();
		PedidosOtrosCanalesUtils.DispoMayoristas DispoMayo = null; 
		for(Portafolio__c p : CtrlReporteInventarioDAO.getPortafolio(obtenerCanal(Canal)))
		{
			mapProd.put(p.Producto__r.ProductCode,p.Producto__r.Description);
		}
		return mapProd;
	
	}
	
	public static void ConsultarDisponibilidad()
	{
		
		map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>> mapResultado =null;
		
		if(ValidarParametros()){
				map<string,string> mapProd1 = obtenerPortafolio();
			if(mapProd1.size() == 0)
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'No se encontro portafolio para esta canal de ventas'));

			}
			 else{
				//try{
		             mapResultado = CtrlReporteInventarioDAO.ConsultarDisponibilidad(obtenerCanal(Canal),Integer.valueOf(MapAlmacenes.get(Id.valueOf(AlmacenId)).Codigo__c),Integer.valueOf(MapAlmacenes.get(AlmacenId).Codigo__c)
		        												,fechaInicial,fechaFin,0);
		       // }
		       // catch(Exception ex)
		       // {
		         //   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, ex.getMessage())); 
		       // }
				mapDispoResp = new Map<String, Map<String, Map<String, List<PedidosOtrosCanalesUtils.DispoMayoristas>>>> ();
				 if(mapResultado != null && mapResultado.size() > 0)
				 {

					 	mapDispoResp.put(MapAlmacenes.get(AlmacenId).Codigo__c,mapResultado);
				 }
				 else if(mapResultado == null)
				 {
				 	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'No se encontro disponibilidad para las fechas seleccionadas'));

				 }
				 else
				 {
				 	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'El servicio no responde favor de intentar de nuevo'));
				 }
			}
		}

		
	}
	private static Boolean ValidarParametros()
	{
		System.debug('--------------------------------->fechaInicial '+ fechaInicial);
		System.debug('--------------------------------->fechaFin '+ fechaFin);
		Boolean isValid = true;
		System.debug(Canal);
		System.debug(AlmacenId);
		if(Canal == null)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Seleccionar el canal de ventas'));
			 isValid = false;
		}
		else if(AlmacenId== '')
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Seleccionar la oficina de ventas'));
			 isValid = false;
		}
		else if(fechaInicial == null)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Seleccionar fecha inicial'));
			 isValid = false;
		}
		else if(fechaFin == null)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Seleccionar fecha final'));
			 isValid = false;
		}
		else if(fechaInicial > fechaFin)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Seleccionar una fecha valida'));
			 isValid = false;
		}
		else if(fechaInicial <  Date.today())
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Seleccionar una fecha valida'));
			 isValid = false;
		}
		
		return isValid;
	}
	private static String obtenerCanal(string canalAlmacen)
	{
		string value = '';
		for(SelectOption o:options)
		{
			if(o.getValue() == canalAlmacen)
				value = o.getLabel();

		}
		return value;
	}
	 public void showPageMessage() {

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
	
   
}