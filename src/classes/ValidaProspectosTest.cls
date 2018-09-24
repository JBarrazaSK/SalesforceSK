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
   		ValidaProspectos valPro = new ValidaProspectos();
   		
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
		ValidaProspectos.ProspectoWRP wrap = new ValidaProspectos.ProspectoWRP(new lead(Telefono_Contacto__c = '6671000001',Telefono__c = '6671000001',Celular__c = '6671000001',Celular_Contacto__c = '6671000001'));
		wrap.getNOHayDatosIncorrectos();
		wrap.getHayVisitasPedidos();
		wrap.validaName(new map<String,Id>{null=>'0012C00000GgE7r'});
		wrap.validaTelefonos(new map<String,Id>{'6671000001'=>'0012C00000GgE7r'});
	}
    static void crearlead(){
		lead le = new lead();
       
        insert le;
        
        
    }
    
    static void pedidos(){
        Pedido__c pedidos = new Pedido__c();
        pedidos.Canal__c = '2';
        insert pedidos;
        
    }
      static void pedidos2(){
        Pedido__c pedidos = new Pedido__c();
        pedidos.Canal__c = '2';
        insert pedidos;
        
    }
      static void pedidos3(){
        Pedido__c pedidos = new Pedido__c();
        pedidos.Canal__c = '2';
        insert pedidos;        
    }
    
    static list<Pedido__c> obtenerPedidos(){
        return [select id from Pedido__c];        
    }
    
}