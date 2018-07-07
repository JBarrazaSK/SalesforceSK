/*
 * @developer   : Rene Carpazo
 * @company     : Evolusoftware
 * @created     : 2017-07-06
 * @description : This class is a controller extension to vfpDispDiaraPlanta VF page.
 */
public with sharing class ctrlDispDiaraPlanta{
	private ctrlDispDiaraPlantaDAO DBA;
	private list<Oficina_de_Venta__c> lsPlantas;
	private list<Product2> lsProductos;
	public list<Master> resTabla{get;set;}
	public list<header> hdSemana{get;set;}
	private map<String,Master>mpTabla;
	public AjusteDisponiblidadPlanta__c filtroObj {get;set;}
    public AjusteDisponiblidadPlanta__c filtroObj2 {get;set;} //solo para la segunda fecha
    public String[] errCust = new String[4];
    private final boolean primerDiaDomingo = true;
    
    public ctrlDispDiaraPlanta(){
    	init();
    }
	
	public void init(){
		//codigoPlanta = null; //DEPRECIADO
		//codigoProducto = null; //DEPRECIADO
		errCust = new String[4];
		resTabla = new list<Master>();
		mpTabla = new map<String,Master>();
		hdSemana = new list<header>();
		lsPlantas = new list<Oficina_de_Venta__c>();
		lsProductos = new list<Product2>();
		filtroObj = new AjusteDisponiblidadPlanta__c();
		filtroObj2 = new AjusteDisponiblidadPlanta__c();
		DBA = new ctrlDispDiaraPlantaDAO();
		opcAddMaster = new list<String>();
		opcRemMaster = new list<String>();
		opcAddPlantas = new list<String>();
		opcRemPlantas = new list<String>();
		selMaster = new set<Id>();
		selPlantas = new set<Id>(); 
	}
	
	//FILTROS MASTER
	private set<Id> selMaster = new set<Id>();
	public list<String> opcAddMaster {get;set;}
	public list<SelectOption> getMasterDispo(){
		List<SelectOption> result = new List<SelectOption>();
		for(Producto_Master__c P: DBA.obtenerMasterDisp(selMaster))
			result.add(new SelectOption(P.Id,P.Name + ' - ' + P.MasterID__c));
		return (result.isEmpty())?new List<SelectOption>{new SelectOption('','--Ninguno--')}:result;
	}
	
	public void aniadeMaster(){
		for(String S:opcAddMaster)
			selMaster.add(S);
		opcAddMaster = new list<String>();
	}
	
	public list<String> opcRemMaster {get;set;}
	public list<SelectOption> getMasterSelect(){
		List<SelectOption> result = new List<SelectOption>();
		for(Producto_Master__c P: DBA.obtenerMasterSel(selMaster))
			result.add(new SelectOption(P.Id,P.Name + ' - ' + P.MasterID__c));
		return (result.isEmpty())?new List<SelectOption>{new SelectOption('','--Ninguno--')}:result;
	}
	
	public void removeMaster(){
		for(String S:opcRemMaster)
			selMaster.remove(S);
		opcAddMaster = new list<String>();
	}
	
	//FILTROS PLANTAS 2.0
	private set<Id> selPlantas = new set<Id>();
	public list<String> opcAddPlantas {get;set;}
	public list<SelectOption> getPlantasDispo(){
		List<SelectOption> result = new List<SelectOption>();
		for(Oficina_de_Venta__c P: DBA.obtenerPlantasDisp(selPlantas))
			result.add(new SelectOption(P.Id,P.Name));
		return (result.isEmpty())?new List<SelectOption>{new SelectOption('','--Ninguno--')}:result;
	}
	
	public void aniadePlantas(){
		for(String S:opcAddPlantas)
			selPlantas.add(S);
		opcAddPlantas = new list<String>();
	}
	
	public list<String> opcRemPlantas {get;set;}
	public list<SelectOption> getPlantasSelect(){
		List<SelectOption> result = new List<SelectOption>();
		for(Oficina_de_Venta__c P: DBA.obtenerPlantasSel(selPlantas))
			result.add(new SelectOption(P.Id,P.Name));
		return (result.isEmpty())?new List<SelectOption>{new SelectOption('','--Ninguno--')}:result;
	}
	
	public void removePlantas(){
		for(String S:opcRemPlantas)
			selPlantas.remove(S);
		opcRemPlantas = new list<String>();
	}
	

	//FILTROS PLANTAS
	/*public String codigoPlanta{get;set;}
	public void obtenerPlanta(){
		filtroObj.Oficina_Venta__c = DBA.obtenerPlanta(codigoPlanta);
	}
	
	public void obtenerCodigoPlanta(){
		codigoPlanta = DBA.obtenerCodigoPlanta(filtroObj.Oficina_Venta__c);
	}
	
	public void aniadirPlanta(){
		if(filtroObj.Oficina_Venta__c != null && DBA.plantaValida(filtroObj.Oficina_Venta__c)){
			lsPlantas.add(new Oficina_de_Venta__c(Id=filtroObj.Oficina_Venta__c));
			lsPlantas = DBA.obtenerPlantas(lsPlantas);
		}else if(filtroObj.Oficina_Venta__c != null)
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Planta seleccionada no válida'));
		filtroObj.Oficina_Venta__c = null;
		codigoPlanta = null;
	}
	
	public list<SelectOption> getopPlantas(){
		List<SelectOption> result = new List<SelectOption>();
		Integer contador = 0;
		for(Oficina_de_Venta__c O:lsPlantas)
			result.add(new SelectOption('' + contador++ ,O.Name));
		return result;
	}
	
	public String plantaSelec{get;set;}
	public void removerPlanta(){
		if(plantaSelec != null && plantaSelec.isNumeric() && Integer.valueOf(plantaSelec) < lsPlantas.size())
			lsPlantas.remove(Integer.valueOf(plantaSelec));
		plantaSelec = null;
	}*/
	//TERMINA FILTRO PLANTA
	//FILTROS PRODUCTO
	/*public String codigoProducto{get;set;}
	public void obtenerProducto(){
		filtroObj.Producto__c = DBA.obtenerProducto(codigoProducto);
	}
	
	public void obtenerCodigoProducto(){
		codigoProducto = DBA.obtenerCodigoProducto(filtroObj.Producto__c);
	}
	
	public void aniadirProducto(){
		if(filtroObj.Producto__c != null && DBA.ProductoValido(filtroObj.Producto__c)){
			lsProductos.add(new Product2(Id=filtroObj.Producto__c));
			lsProductos = DBA.obtenerProductos(lsProductos);
		}else if(filtroObj.Producto__c != null)
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Producto seleccionado no válida'));
		filtroObj.Producto__c = null;
		codigoProducto = null;
	}
	
	public list<SelectOption> getopProductos(){
		List<SelectOption> result = new List<SelectOption>();
		Integer contador = 0;
		for(Product2 P:lsProductos)
			result.add(new SelectOption('' + contador++ ,P.Name));
		return result;
	}
	
	public String productoSelec{get;set;}
	public void removerProducto(){
		if(productoSelec != null && productoSelec.isNumeric() && Integer.valueOf(productoSelec) < lsProductos.size())
			lsProductos.remove(Integer.valueOf(productoSelec));
		productoSelec = null;
	}*/
	//TERMINA FILTRO PLANTA
	
    private final Integer maxRows = 8000;
	public void consultaDispo(){
		lsProductos = DBA.obtenerProductos(selMaster);
		lsPlantas = DBA.obtenerPlantas(selPlantas);
		if(lsProductos.isEmpty())
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Se requiere ingresar por lo menos un código Master'));
		else if(lsPlantas.isEmpty())
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Se requiere ingresar por lo menos una planta válida'));
		else if(filtroObj.Fecha_Embarque__c == null)
			filtroObj.Fecha_Embarque__c.addError('Se requiere ingresar una fecha');
		else if(filtroObj2.Fecha_Embarque__c == null)
			filtroObj2.Fecha_Embarque__c.addError('Se requiere ingresar una fecha');
		else if(filtroObj.Fecha_Embarque__c > filtroObj2.Fecha_Embarque__c)
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Se requiere que la fecha inicial sea menor a la fecha final'));
        else if(calculaRows(lsProductos.size(),lsPlantas.size(),filtroObj.Fecha_Embarque__c.daysBetween(filtroObj2.Fecha_Embarque__c)) > maxRows){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Demaciados registros: Ingrese menos criterios o reduzca el periodo de fechas'));
            hdSemana = new list<header>();
            resTabla = new list<Master>();
        }else{
			try{
				construirSemanas();
				construirEstructura();
				DBA.obtenerDatosWS(lsPlantas,lsProductos,filtroObj.Fecha_Embarque__c,filtroObj2.Fecha_Embarque__c,mpTabla);
			}catch(Exception e){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
			}
		}
	}
    
    private Integer calculaRows(Integer totProds,Integer totPlantas,Integer totDias){
        return totProds * totPlantas * (totDias + 2);
    }
	
	private void construirSemanas(){
		hdSemana = new list<header>();
		Date Fecha = filtroObj.Fecha_Embarque__c;
		Integer diaSem = diaSemana(Fecha);
		Integer Semana = obtenerNumeroSemana(filtroObj.Fecha_Embarque__c);
		list<Date> fechas = new list<Date>();
		do{
			if(diaSem == 7){
				hdSemana.add(new header(Semana++,fechas));
				fechas = new list<Date>();
				diaSem = 0;
			}
			fechas.add(Fecha);
			Fecha = fecha.addDays(1);
			diaSem++;
		}while(Fecha.daysBetween(filtroObj2.Fecha_Embarque__c) >= 0);
		hdSemana.add(new header(Semana,fechas));
	}
	
	private Integer diaSemana(Date Fecha){
		Date FechaISemana = Fecha.toStartOfWeek();
		Integer diaSem = FechaISemana.daysBetween(Fecha);
		return (diaSem == 6 && primerDiaDomingo)?0:(diaSem + ((primerDiaDomingo)?1:0));
	}
	
	private Integer obtenerNumeroSemana(Date Fecha){
		Date FechaISemana = (diaSemana(Fecha)==0)?Fecha:Fecha.toStartOfWeek().addDays((primerDiaDomingo)?-1:0);
		Date FechaIAnio = (diaSemana(Date.newInstance(Fecha.year(), 1, 1))==0)?Date.newInstance(Fecha.year(), 1, 1):Date.newInstance(Fecha.year(), 1, 1).toStartOfWeek().addDays((primerDiaDomingo)?-1:0);
		return (FechaIAnio.daysBetween(FechaISemana) / 7) + 1;
	}
	
	private void construirEstructura(){
		resTabla = new list<Master>();
		for(Product2 Producto: lsProductos){
			Master tmpMter = new Master(Producto,lsPlantas,filtroObj.Fecha_Embarque__c,filtroObj2.Fecha_Embarque__c);
			resTabla.add(tmpMter);
			mpTabla.put(Producto.ProductCode,tmpMter);
		}
	}
	
	//CLASES WRAPPER
	class header{
		public Integer Semana{get;set;}
		public list<Date> fechas {get;set;}
		public Integer getTamanio(){
			return (fechas.isEmpty())?1:fechas.size();
		}
		public header(Integer Semana,list<Date> fechas){
			this.Semana = Semana;
			this.fechas = fechas;
		}
	}
	
	public class Master{
		public Product2 Producto {get;set;}
		public list<Planta> Plantas {get;set;}
		private map<Integer,Planta> mpPlantas;
		public Integer getTamanio(){
			return (Plantas.isEmpty())?1:Plantas.size();
		}
		
		public master(Product2 Producto,list<Oficina_de_Venta__c> Plantas,Date FechaI,Date FechaF){
			this.Producto = Producto;
			this.Plantas = new list<Planta>();
			this.mpPlantas = new map<Integer,Planta>();
			for(Oficina_de_Venta__c O:Plantas){
				Planta tPlanta = new Planta(O,FechaI,FechaF);
				this.Plantas.add(tPlanta);
				if(O.Codigo__c.isNumeric())
					mpPlantas.put(Integer.valueOf(O.Codigo__c),tPlanta);
			}
		}
		
		public void insertaDisponibilidad(Integer Planta,Date Fecha,Decimal dispo){
			if(mpPlantas.containsKey(Planta))
				mpPlantas.get(Planta).insertaDisponibilidad(Fecha,dispo);
		}
	}
	
	class Planta{
		public Oficina_de_Venta__c Planta {get;set;}
		public list<Disponibilidad> DispXFecha {get;set;}
		private map<Date,Disponibilidad> mpDispXFecha;
		
		public Planta(Oficina_de_Venta__c Planta,Date FechaI,Date FechaF){
			this.Planta = Planta;
			this.DispXFecha = new list<Disponibilidad>();
			this.mpDispXFecha = new map<Date,Disponibilidad>();
			Date fecha = fechaI;
			do{
				Disponibilidad tDisponibilidad = new Disponibilidad(fecha);
				this.DispXFecha.add(tDisponibilidad);
				this.mpDispXFecha.put(fecha,tDisponibilidad);
				fecha = fecha.addDays(1);
			}while(fecha.daysBetween(FechaF) >= 0);
		}
		
		public void insertaDisponibilidad(Date Fecha,Decimal dispo){
			if(mpDispXFecha.containsKey(Fecha))
				mpDispXFecha.get(Fecha).insertaDisponibilidad(dispo);
		}
	}
	
	class Disponibilidad{
		public decimal Cantidad {get;set;}
		public Date fecha {get;set;}
		public Disponibilidad(Date fecha){
			this.fecha = fecha;
		}
		
		public void insertaDisponibilidad(Decimal dispo){
			this.Cantidad = dispo;
		}
	}
}