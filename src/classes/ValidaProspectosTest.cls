/**
 * Description: ValidaProspectos.page controller class.
 * Author: Rene Carpazo
 * Company: evolusoftware
 * Email: rene.carpazo@gmail.com
 * Created date: 2018-08-08
 **/
@isTest
private class ValidaProspectosTest {

	static testMethod void myUnitTest() {  
        crearlead();
        ValidaProspectos valPro = new ValidaProspectos();
        valPro.gpoVendedor = crearEstructuraVenta().Id;   		
   		valPro.addInfoMaps(new Account(Name = 'tst',Telefono__c = '6671000001',Celular__c= '6671000001', Fax__c= '6671000001', Telefono_Adicional__c = '6671000001',Telefono_Adicional_Contacto__c = '6671000001',Telefono_Contacto__c = '6671000001'),new map<String,Id>(),new map<String,Id>());
  		valPro.validate();
   		valPro.fecAccount.Aniversario_del_Negocio__c = Date.today();
   		valPro.validate();
   		valPro.prospectos = new list<ValidaProspectos.ProspectoWRP>{new ValidaProspectos.ProspectoWRP(new lead(Id='00Q99000002Emrw'))};
   		valPro.prospectos[0].applyConvert = true;
   		valPro.reject();
   		valPro.prospectos = new list<ValidaProspectos.ProspectoWRP>{new ValidaProspectos.ProspectoWRP(new lead(Id='00Q99000002Emrw'))};
   		valPro.prospectos[0].applyConvert = true;
   		valPro.convert();
	}
	
	static testMethod void myUnitTest2() {
        system.debug('Pedidos> '+ obtenerPedidos());
        lead lead = crearlead();
        //pedidosyvisitas();
		ValidaProspectos.ProspectoWRP wrap = new ValidaProspectos.ProspectoWRP(lead);
        wrap.pedidos = 3;
        wrap.visitas = 3;		
		wrap.getHayVisitasPedidos();
        wrap.getNOHayDatosIncorrectos();
		wrap.validaName(new map<String,Id>{null=>'0012C00000GgE7r'});
        wrap.validaName(new map<String,Id>{null=>null});
		wrap.validaTelefonos(new map<String,Id>{'6671000001'=>'0012C00000GgE7r'});
	}
    static lead crearlead(){
        String strRecordTypeId = [Select Id,name,SobjectType  From RecordType Where SobjectType = 'Lead' and Name = 'Export Lead'].Id;
		lead le = new lead();
        le.Status = 'Aprobado JV'; 
        le.FirstName = 'Atondo';
        le.LastName = 'Echa';
        le.Telefono_Contacto__c = '6671000001';
        le.Telefono__c = '6671000001';
        le.Celular__c = '6671000001';
        le.Celular_Contacto__c = '6671000001';
        le.Company = '12';
        le.IsConverted = false;
        le.RecordTypeId =  strRecordTypeId;
        insert le;
        return le;
  
        
    }
    static void pedidosyvisitas()
    {       
        pedidos();
        pedidos2();
        pedidos3();
        visitas();
        visitas2();
        visitas3();
    }
    static void pedidos(){
        Pedido__c pedidos = new Pedido__c();
        pedidos.Canal__c = '2';
        pedidos.Cuenta__c = '0012C00000FCWsuQAH';
        pedidos.Fecha_Registro__c = date.today();
        pedidos.Prospecto__c =  obtenerLead().Id;
        insert pedidos;
        
    }
      static void pedidos2(){
        Pedido__c pedidos = new Pedido__c();
        pedidos.Canal__c = '2';
             pedidos.Cuenta__c = '0012C00000FCWsuQAH';
        pedidos.Fecha_Registro__c = date.today();
        pedidos.Prospecto__c  =  obtenerLead().Id;
        insert pedidos;
        
    }
      static void pedidos3(){
        Pedido__c pedidos = new Pedido__c();
        pedidos.Canal__c = '2';
             pedidos.Cuenta__c = '0012C00000FCWsuQAH';
        pedidos.Fecha_Registro__c = date.today();
        pedidos.Prospecto__c  =  obtenerLead().Id;
        insert pedidos;        
    }
    static void visitas(){
        Visita__c v = new Visita__c();
        v.Prospecto__c = obtenerLead().Id;
        insert v; 
    }
    static void visitas2(){
        Visita__c v = new Visita__c();
        v.Prospecto__c = obtenerLead().Id;
        insert v; 
    }
    static void visitas3(){
        Visita__c v = new Visita__c();
        v.Prospecto__c = obtenerLead().Id;
        insert v; 
    }
    static lead obtenerLead(){
        return [Select id from lead];
    }
    static list<Pedido__c> obtenerPedidos(){
        return [select id from Pedido__c];        
    }
      static list<Visita__c> obtenerVisitas(){
        return [select id from Visita__c];        
    }
    
    static Estructura_de_venta__c crearEstructuraVenta(){
        Estructura_de_venta__c st =  new Estructura_de_venta__c();
        
        st.Fecha_Hora__c =  date.today();
        st.Grupo_de_clientes_Codigo__c = '01';
        st.Name = 'okok';
        st.Zona__c = '1010';
        st.Grupo_de_Vendedores__c = crearGrupoVendedores().Id;        
        insert st;    
        return st;
    }
    static Grupo_de_Vendedores__c crearGrupoVendedores(){
        Grupo_de_Vendedores__c  gpo = new Grupo_de_Vendedores__c();
        
        gpo.Codigo__c = '101';
        gpo.Descripcion__c = 'Gpo 1';
        insert gpo;
        
        return gpo;
        
    }
    
}