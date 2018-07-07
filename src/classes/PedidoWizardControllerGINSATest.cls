@isTest(SeeAllData = true)
public class PedidoWizardControllerGINSATest implements WebServiceMock {
    
    public void doInvoke(Object stub, Object request, Map<String, Object> responseMap, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        if(stub instanceOf CierrePlazaPedidoQueryNSCWS.CierrePedidosSoap) {
            new CierrePlazaPedidoQueryNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf ProductoInventarioQueryNSCWS.DisponibilidadInventarioSoap) {
            new ProductoInventarioQueryNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf ListaPreciosQueryNSCWS.ListaPreciosSoap) {
            new ListaPreciosQueryNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(stub instanceOf PedidoInsertNSCWS.PedidosSoap) {
            new PedidoInsertNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        } else if(request instanceOf BalanceoNSCWS.GuardarPedidos_element) {
            new BalanceoNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        }
    }
    
    static testMethod void myUnitTest() {
        
        String standardPriceBook = [SELECT p.IsStandard, p.Id From Pricebook2 p WHERE isStandard = true AND isActive = true LIMIT 1].Id;
        RecordType tipoRegistro = [Select Name, Id From RecordType  where sObjectType='Colonia__c' and isActive=true and DeveloperName ='Colonia_GINSA' LIMIT 1];
        Colonia__c colonia = new  Colonia__c(Codigo_Colonia__c ='80010',Name='80010 - BENITO JUAREZ', recordTypeId = tipoRegistro.Id);
    	insert colonia;
    	
        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
            Codigo__c = '0'
        );
        insert canalDistribucionNSC;
        
        Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c( Codigo__c = '123', Descripcion__c = 'BNM MANAGUA' );
        upsert ofiVta;
        
        Grupo_de_Vendedores__c gpoVendedores = new Grupo_de_Vendedores__c( Codigo__c = '108', Descripcion__c = 'T2 MANAGUA', TipoSurtido__c = '2 - Directo' );
        upsert gpoVendedores;
        
        Estructura_de_venta__c estructura = new Estructura_de_venta__c(
            Name = 'TSK HUMAYA - 272',
            Organizacion_de_Ventas_Codigo__c = '300',
            Organizacion_de_Ventas__c = 'SUKARNE - 300',
            Zona_Codigo__c = '102',
            Zona__c = 'NOROESTE - 102',
            Grupo_de_clientes_Codigo__c = '7',
            Grupo_de_clientes__c = 'CULIACAN - 7',
            Grupo_de_vendedores__c = gpoVendedores.Id,
            Grupo_de_Vendedores_Codigo__c = '108',
            Oficina_de_ventas__c = ofiVta.Id
        );
        insert estructura;
        /*
        PedidoParameters__c pedidoParameters = new PedidoParameters__c(
            DiasPreventaMaximos__c = 4,
            PrecioUnitarioDecrementoMaximo__c = 30,
            PrecioUnitarioIncrementoMaximo__c = 0,
            TipoCambioDolarPeso__c = 14.8876,
            EndpointPedidos__c = 'http://187.216.127.15:2562'
        );
        upsert pedidoParameters;
        */
        Account cliente = new Account(
            Name = 'TEST',
            Numero_Cliente_SAP__c = '0',
            RFC__c = 'XXXXXXXXXXX5',
            Telefono__c = '0000000000',
            Oficina_de_Ventas__c = ofiVta.Id,
            Grupo_de_Vendedores__c = gpoVendedores.Id
        );
        insert cliente;
        
        Account sucursal = new Account(
            Cadena__c = 'TEST - 0',
            Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
            Canal_Distribucion__c = 'Detalle - DT',
            Estatus_Cliente__c = 'Activo',
            Name = 'TEST',
            Numero_Cliente_SAP__c = '1',
            ParentId = cliente.Id,
            Ramo__c = 'TEST - 0',
            RecordTypeId = Constants.recordTypeMap.get('Account').get('Sucursal'),
            RFC__c = 'XXXXXXXXXXX3',
            Telefono__c = '0000000000',
            Oficina_de_Ventas__c = ofiVta.Id,
            Grupo_de_Vendedores__c = gpoVendedores.Id
        );
        insert sucursal;

        Lead lead = new Lead(
            Canal_de_Distribucion_NSC__c = canalDistribucionNSC.Id,
            Company = 'TEST',
            FirstName = 'TEST',
            LastName = 'TEST',
            RFC__c = 'XXXXXXXXXXX9',
            Telefono__c = '1234567890',
            Estructura_de_venta__c = estructura.Id,
            Colonia__c = colonia.id
        );
        insert lead;
        Product2 product2 = new Product2(
            Codigo_Id_Externo__c = '0',
            Name = 'TEST',
            ProductCode = '0',
            IsActive = true
        );
        insert product2;
        
        Opportunity pedido = new Opportunity(
            AccountId = sucursal.Id,
            Fecha_Registro__c = System.today(),
            Numero_de_Pedido_NSC__c = '0',
            Prospecto__c = lead.Id,
            Name = 'Test',
            StageName = '1 - Pedido Colocado',
            CloseDate = System.today(),
            Pricebook2Id = standardPriceBook
        );
        insert pedido;
        
        PriceBookEntry pbe = new PriceBookEntry( PriceBook2Id = standardPriceBook, Product2Id = product2.Id, UnitPrice = 332.11, IsActive = true );
        insert pbe;
        
        OpportunityLineItem pedidoItem = new OpportunityLineItem(
            Kilos_Conf__c = 1,
            OpportunityId = pedido.Id,
            PricebookEntryId = pbe.Id,
            TotalPrice = 1298.33,
            Quantity = 4
        );
        insert pedidoItem;
        
        Test.setMock(WebServiceMock.class, new PedidoWizardControllerGINSATest());
        
        Test.startTest();
        
        Test.setCurrentPage(new PageReference('/apex/PedidoWizardGINSA?CF00N500000030Mvx_lkid='+lead.Id));
        PedidoWizardControllerGINSA controller = new PedidoWizardControllerGINSA();
        Test.setCurrentPage(new PageReference('/apex/PedidoWizardGINSA?id='+lead.Id));
        controller = new PedidoWizardControllerGINSA();
        Test.setCurrentPage(new PageReference('/apex/PedidoWizardGINSA?id='+sucursal.Id));
        controller = new PedidoWizardControllerGINSA();
        controller.stepForth();
        controller.product2XproductCodeMap.get('0');//} catch( Exception e ) { System.debug('ERR: '+e.getMessage()); }
        controller.pedidoWrapper.indexToRemove = 0;
        controller.pedidoWrapper.removePedidoItem();//}catch( Exception e ) { System.debug('ERR: '+e.getMessage()); }
        controller.pedidoWrapper.clearPedidoItemList();//}catch( Exception e ) { System.debug('ERR: '+e.getMessage()); }
        controller.pedidoWrapper.addPedidoItem();//}catch( Exception e ) { System.debug('ERR: '+e.getMessage()); }
        controller.pedidoWrapper.pedidoItemList[0] = pedidoItem;//}catch( Exception e ) { System.debug('ERR: '+e.getMessage()); }
        controller.submit();//}catch( Exception e ) { System.debug('ERR: '+e.getMessage()); }
        Test.setCurrentPage(new PageReference('/apex/PedidoWizardGINSA?id='+controller.pedidoWrapper.pedido.Id));
        controller = new PedidoWizardControllerGINSA();
        
        Test.stopTest();
    }
}