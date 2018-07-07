/**
 * Description: WsArmarEmbarqueSDL.cls test methods.
 * Author: Ruben Barraza
 * Company: Sk
 * Email:jose.barraza@sukarne.com
 * Created date:17/01/2017
 **/
@isTest
public class CtrlReporteInventarioDataTest {

   public static testMethod Oficina_de_Venta__c CrearOficinaVentas() {
        Oficina_de_Venta__c ov = new Oficina_de_Venta__c();
        ov.name='Bodega Calexico - 64';
        ov.Codigo__c = '64';
        ov.Descripcion__c = 'Bodega Calexico';
        ov.Valida_Disponibilidad__c = true;
        upsert ov;
        return ov;
        
    }
    public static testMethod product2 crearProducto()
    {
    	product2 p = new product2();
    	p.Name = '10251714 - FZN LIP ON RIB EYE 11 DN';
    	p.Codigo_Id_Externo__c = '10251714';
    	p.ProductCode = '10251714';
    	p.IsActive = true;
    	upsert p;
    	return p;
    }
    @isTest
     public static  Portafolio__c CrearPortafolio()
    {
    	Portafolio__c p = new Portafolio__c();
    	p.Canal_de_ventas__c = 'Autoservicio';
    	p.Producto__c = crearProducto().Id;
    	
    	upsert p;
    	return p;
    }
}