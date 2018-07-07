global with sharing class SaldoEstrategiaController {
    public static AdminSaldosEstrategias__c AdminSaldosEstra { get; set; }
    public String level {get; set;}
    public String message {get; set;}
    public String column {get{
                            return column ='Id,Name,Anio__c,Fecha_Final__c,Fecha_Inicial__c,Folio__c,Num_Semana__r.Name,productoId__r.Codigo_Id_Externo__c,productoId__r.Name,Prod_Master__r.Name,Prod_Master__r.MasterID__c,Saldo_Inicial_Auto__c,Saldo_Inicial_Export__c,Saldo_Inicial_Mayo__c,Saldo_Final_Auto__c,Saldo_Final_Export__c,Saldo_Final_Mayo__c,productoId__c,Prod_Master__c,Num_Semana__c ';
                        } set;}
    public Map<String, Product2> product2XproductCodeMap {
        get {
            if(product2XproductCodeMap == null) {

                product2XproductCodeMap = new Map<String, Product2>();
                for(Product2 product2 : [
                        SELECT id, name,Codigo_Id_Externo__c,ProductCode,Producto_Master__r.MasterID__c,Ficha_comercial__c,Peso_Promedio__c,Description
                        FROM Product2
                        WHERE IsActive = true])
                        {
                         product2XproductCodeMap.put(product2.ProductCode, product2);
                }
            }
            return product2XproductCodeMap;
        }
        set;
    }
    public Map<String, Producto_Master__c> MasterXproductCodeMap {
        get {
            if(MasterXproductCodeMap == null) {

                MasterXproductCodeMap = new Map<String, Producto_Master__c>();
                for(Producto_Master__c pm : [
                        SELECT id, name,MasterID__c
                        FROM Producto_Master__c
                            ])
                        {
                         MasterXproductCodeMap.put(pm.MasterID__c, pm);
                }
            }
            return MasterXproductCodeMap;
        }
        set;
    }
     public Map<String, semana_viz__c> MapAnios {
        get {
            if(MapAnios == null) {
                Integer currentYear = System.Today().year();
                MapAnios = new Map<String, semana_viz__c>();
                set<String>setAnio = new set<String>();
                for(semana_viz__c pm : [
                        SELECT id, Name,Anio__c
                        FROM semana_viz__c
                            where Anio__C >=: string.valueof(currentYear)])
                        {
                         if(!setAnio.contains(pm.Anio__c))
                            MapAnios.put(pm.Anio__c, pm);
                }

            }
            return MapAnios;
        }
        set;
    }
     public Map<String, semana_viz__c> MapSemanas {
        get {
            if(MapSemanas == null) {
                Integer currentYear = System.Today().year();
                MapSemanas = new Map<String, semana_viz__c>();


                for(semana_viz__c pm : [
                        SELECT id, Name,Anio__c,Fecha_Final__c,Fecha_Inicial__c
                        FROM semana_viz__c
                        where
                            Anio__C >=: string.valueof(currentYear)
                            //and Name >=:string.valueof(semana)
                         ])
                        {
                            MapSemanas.put(pm.Name, pm);
                        }
            }
            return MapSemanas;
        }
        set;
    }
    public SaldoEstrategiaController() {

    }

    @RemoteAction
    global static string DeleteEstrategy(Id IdRow) {
          string Response = 'Se Elimino Con Exito';
          try {
                AdminSaldosEstra = [SELECT Id
                   FROM AdminSaldosEstrategias__c WHERE id = : IdRow];

            delete AdminSaldosEstra;

        } catch (Exception e) {

            Response = e.getMessage();
        }
        return Response;
    }
    @RemoteAction
    global static string AddAdmonEstrategyComercial(Map<String, String> AdmonEstraCom, string semIni,string semFin)
    {
         AdminSaldosEstrategias__c ase = null;
         set<String> setSemanas = new set<String>();
        try
        {
            system.debug('Nombre -------------------------------------> '+AdmonEstraCom.get('Name'));
            system.debug('Id -------------------------------------> '+AdmonEstraCom.get('Id'));
            system.debug('semIni -------------------------------------> '+semIni);
            system.debug('semFin -------------------------------------> '+semFin);
            system.debug('AdmonEstraCom -------------------------------------> '+AdmonEstraCom.size());

            list<AdminSaldosEstrategias__c> ListaEstrategias =  new list<AdminSaldosEstrategias__c>();
            for(semana_viz__c pm : [
                        SELECT id, Name,Anio__c,Fecha_Final__c,Fecha_Inicial__c
                        FROM semana_viz__c
                        where
                            Name >=: string.valueof(semIni)
                            and Name <=: string.valueof(semFin)
                            and Anio__c =: AdmonEstraCom.get('Anio__c')
                         ])
                        {

                            system.debug('Num_Semana__c -------------------------------------> '+pm.Name);
                            ase = new AdminSaldosEstrategias__c(
                                                   Name= AdmonEstraCom.get('Name'),
                                                   Anio__c= AdmonEstraCom.get('Anio__c'),
                                                   Num_Semana__c= pm.Id,
                                                   Fecha_Final__c= pm.Fecha_Final__c,
                                                   Fecha_Inicial__c= pm.Fecha_Inicial__c,
                                                   productoId__c= AdmonEstraCom.get('IdProducto'),
                                                   Prod_Master__c= AdmonEstraCom.get('IdMaster'),
                                                   Saldo_Final_Auto__c= AdmonEstraCom.get('SF_Auto'),
                                                   Saldo_Final_Export__c= AdmonEstraCom.get('SF_Ex'),
                                                   Saldo_Final_Mayo__c= AdmonEstraCom.get('SF_My'),
                                                   Saldo_Inicial_Auto__c= AdmonEstraCom.get('SI_Auto'),
                                                   Saldo_Inicial_Export__c= AdmonEstraCom.get('SI_Ex'),
                                                   Saldo_Inicial_Mayo__c= AdmonEstraCom.get('SI_My'),
                                                   Id= AdmonEstraCom.get('Id')
                                                   );
                              ListaEstrategias.add(ase);


                        }


          upsert(ListaEstrategias);

          ase = [SELECT Folio__c from AdminSaldosEstrategias__c where Id =: ase.Id];
        }catch (Exception e) {

           return e.getMessage();
        }
        return ase.Folio__c;
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