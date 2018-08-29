@isTest
private class BalanceoControllerTest  implements WebServiceMock {

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
        } else if(request instanceOf BalanceoNSCWS.RegresaInventarioPorProducto_element) {
            new BalanceoNSCWSTest().doInvoke(stub, request, responseMap, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        }
    }

	@isTest
	static void balanceoTest(){

        Product2 prod01  = new Product2(
        	Name='test', 
        	Description='test',
        	Codigo_Id_Externo__c='0',
            ProductCode='0',
            Peso_Promedio__c=10,
        	Sub_Familia__c='test');
        insert prod01;

        Canal_de_Distribucion_NSC__c canalDistribucionNSC = new Canal_de_Distribucion_NSC__c(
            Codigo__c = '0',
            Name = '0'
        );
        insert canalDistribucionNSC;

        Oficina_de_Venta__c ovCedis = new Oficina_de_Venta__c(Name='100', Codigo__c = '100', Descripcion__c = 'CEDIS MANAGUA');
        upsert ovCedis;

        Oficina_de_Venta__c ofiVta = new Oficina_de_Venta__c(Name='123', Codigo__c = '123', Descripcion__c = 'BNM MANAGUA', CEDIS__c=ovCedis.Id );
        upsert ofiVta;
        
        Grupo_de_Vendedores__c gpoVendedores = new Grupo_de_Vendedores__c( Name='108', Codigo__c = '108', Descripcion__c = 'T2 MANAGUA', TipoSurtido__c = '2 - Directo' );
        upsert gpoVendedores;
        
        Estructura_de_venta__c estructura = new Estructura_de_venta__c(
            Name = 'TSK HUMAYA - 272',
            Organizacion_de_Ventas_Codigo__c = '300',
            Organizacion_de_Ventas__c = 'SUKARNE - 300',
            Zona_Codigo__c = '102',
            Zona__c = 'NOROESTE - 102',
            Grupo_de_clientes_Codigo__c = '7',
            Grupo_de_clientes__c = 'CULIACAN - 7',
            Grupo_de_Vendedores_Codigo__c = '108',
            Grupo_de_vendedores__c = gpoVendedores.Id,
            Oficina_de_ventas__c = ofiVta.Id
        );
        //insert estructura;

        Colonia__c colonia = new Colonia__c(
            Codigo_Colonia__c = '0'
        );
        insert colonia;

        Account accountSucursal = new Account(
            Estatus_Cliente__c  = 'Activo',
            RecordTypeId = Constants.recordTypeMap.get('Account').get('Sucursal'),
            Name = 'TEST SUC',
            RFC_Generico__c = true,
            RFC__c = 'XXXXXXXXXXX3',
            Telefono__c = '1234567890',
            Organizacion_de_Ventas__c = 'SUKARNE - SK01',
            Numero_Cliente_SAP__c = '0'
        );
        insert accountSucursal;
        
        Account account = new Account(
            Colonia__c = colonia.Id,
            Estatus_Cliente__c  = 'Activo',
            Name = 'TEST',
            RecordTypeId = Constants.recordTypeMap.get('Account').get('Sucursal'),
            RFC__c = 'XXXXXXXXXXX1',
            Telefono__c = '1234567890',
            Organizacion_de_Ventas__c = 'SUKARNE - SK01',
            Oficina_de_Ventas__c = ofiVta.Id,
            Grupo_de_Vendedores__c = gpoVendedores.Id,
            Numero_Cliente_SAP__c = '000000012',
            Canal_Distribucion__c = '100',
            Ramo__c = 'Ramo',
            Cadena__c = '',
            ParentId = accountSucursal.Id
        );
        insert account;

        Account account2 = new Account(
            Colonia__c = colonia.Id,
            Estatus_Cliente__c  = 'Activo',
            Name = 'TEST2',
            RecordTypeId = Constants.recordTypeMap.get('Account').get('Sucursal'),
            RFC__c = 'XXXXXXXXXXX2',
            Telefono__c = '1234567892',
            Organizacion_de_Ventas__c = 'SUKARNE - SK01',
            Oficina_de_Ventas__c = ofiVta.Id,
            Grupo_de_Vendedores__c = gpoVendedores.Id,
            ParentId = account.Id,
            Numero_Cliente_SAP__c = 'SUC - 000000012'
        );
        insert account2;

        Oficina_de_Venta__c oficinaVentas = new Oficina_de_Venta__c(
        	Name = 'BODEGA 29 MEXICALI - 918',
        	Descripcion__c = 'BODEGA 29 MEXICALI - 918',
        	Codigo__c = '918'
        );
        upsert oficinaVentas;

        DateTime dtPedido = System.now().addDays(-1);

        Pedido__c pedido0 = new Pedido__c(
            Cuenta__c = account.Id,
            Canal__c = '639',
            Fecha_Registro__c = dtPedido.date(),
            FechaSurtidoProgramada__c = dtPedido,
            Numero_de_Pedido_NSC__c = '0',
            //Prospecto__c = lead.Id,
            OficinaVentas__c = oficinaVentas.Id,
            PedidoRechazado__c = false,
            PedidoCanceladoPorElSistema__c=false,
            EstatusPedido__c = '1 - Pedido Colocado'
        );
        insert pedido0;
        Pedido__c pedido00 = new Pedido__c(
            Cuenta__c = account2.Id,
            Canal__c = '639',
            Fecha_Registro__c = dtPedido.date(),
            FechaSurtidoProgramada__c = dtPedido,
            Numero_de_Pedido_NSC__c = '1',
            //Prospecto__c = lead.Id,
            OficinaVentas__c = oficinaVentas.Id,
            PedidoRechazado__c = false,
            PedidoCanceladoPorElSistema__c=false,
            EstatusPedido__c = '1 - Pedido Colocado'
        );
        insert pedido00;

        Pedido__c pedido1 = new Pedido__c(
            Cuenta__c = account.Id,
            Canal__c = '639',
            Fecha_Registro__c = System.now().date(),
            FechaSurtidoProgramada__c = System.now(),
            Numero_de_Pedido_NSC__c = '2',
            //Prospecto__c = lead.Id,
            OficinaVentas__c = oficinaVentas.Id,
            PedidoRechazado__c = false,
            PedidoCanceladoPorElSistema__c=false,
            EstatusPedido__c = '1 - Pedido Colocado'
        );
        insert pedido1;

        Pedido__c pedido2 = new Pedido__c(
            Cuenta__c = account.Id,
            Canal__c = '639',
            Fecha_Registro__c = System.now().date().addDays(-2),
            FechaSurtidoProgramada__c = System.now().addDays(1),
            Numero_de_Pedido_NSC__c = '3',
            //Prospecto__c = lead.Id,
            OficinaVentas__c = oficinaVentas.Id,
            PedidoRechazado__c = false,
            PedidoCanceladoPorElSistema__c=false,
            EstatusPedido__c = '1 - Pedido Colocado'
        );
        insert pedido2;

        Pedido__c pedido3 = new Pedido__c(
            Cuenta__c = account.Id,
            Canal__c = '639',
            Fecha_Registro__c = System.now().date(),
            FechaSurtidoProgramada__c = System.now(),
            Numero_de_Pedido_NSC__c = '4',
            //Prospecto__c = lead.Id,
            OficinaVentas__c = oficinaVentas.Id,
            PedidoRechazado__c = false,
            PedidoCanceladoPorElSistema__c = false,
            EstatusPedido__c = '1 - Pedido Colocado'
        );
        insert pedido3;

        Pedido__c pedido4 = new Pedido__c(
            Cuenta__c = account.Id,
            Canal__c = '639',
            Fecha_Registro__c = System.now().date().addDays(-1),
            FechaSurtidoProgramada__c = System.now().addDays(-1),
            Numero_de_Pedido_NSC__c = '5',
            //Prospecto__c = lead.Id,
            OficinaVentas__c = oficinaVentas.Id,
            PedidoRechazado__c = false,
            PedidoCanceladoPorElSistema__c=false,
            EstatusPedido__c = '1 - Pedido Colocado'
        );
        insert pedido4;

        PedidoItem__c pedidoItem01 = new PedidoItem__c(
            Kilos_Conf__c = 1,
            Cajas_Conf__c = 1,
            Pedido__c = pedido0.Id,
            Producto__c = prod01.Id
        );
        insert pedidoItem01;

        PedidoItem__c pedidoItem02 = new PedidoItem__c(
            Kilos_Conf__c = 1,
            Pedido__c = pedido0.Id,
            Cajas_Conf__c = 1,
            Producto__c = prod01.Id,
            CantidadConfirmada__c = 3,
            Cantidad_Balanceada__c = 2,
            Cajas__c = 10
        );
        insert pedidoItem02;

        PedidoItem__c pedidoItem010 = new PedidoItem__c(
            Kilos_Conf__c = 1,
            Cajas_Conf__c = 1,
            Pedido__c = pedido00.Id,
            Producto__c = prod01.Id
        );
        insert pedidoItem010;

        PedidoItem__c pedidoItem020 = new PedidoItem__c(
            Kilos_Conf__c = 1,
            Pedido__c = pedido00.Id,
            Cajas_Conf__c = 1,
            Producto__c = prod01.Id,
            CantidadConfirmada__c = 3,
            Cantidad_Balanceada__c = 2
        );
        insert pedidoItem020;

        PedidoItem__c pedidoItem03 = new PedidoItem__c(
            Kilos_Conf__c = 1,
            Pedido__c = pedido1.Id,
            Producto__c = prod01.Id,
            Cajas_Conf__c = 1,
            CantidadConfirmada__c = 3,
            Cantidad_Balanceada__c = null
        );
        insert pedidoItem03;

        PedidoItem__c pedidoItem04 = new PedidoItem__c(
            Kilos_Conf__c = 1,
            Pedido__c = pedido2.Id,
            Producto__c = prod01.Id,
            Cajas_Conf__c = 1,
            CantidadConfirmada__c = 3,
            Cantidad_Balanceada__c = 2
        );
        insert pedidoItem04;

        PedidoItem__c pedidoItem05 = new PedidoItem__c(
            Kilos_Conf__c = 1,
            Pedido__c = pedido3.Id,
            Producto__c = prod01.Id,
            Cajas_Conf__c = 1,
            CantidadConfirmada__c = 3,
            Cantidad_Balanceada__c = 2
        );
        insert pedidoItem05;

        PedidoItem__c pedidoItem06 = new PedidoItem__c(
            Kilos_Conf__c = 1,
            Pedido__c = pedido4.Id,
            Cajas_Conf__c = 1,
            Producto__c = prod01.Id,
            CantidadConfirmada__c = 3,
            Cantidad_Balanceada__c = 2
        );
        insert pedidoItem06;

        Test.setMock(WebServiceMock.class, new BalanceoControllerTest());
        Test.startTest();
        	BalanceoController controller = new BalanceoController();
        	System.assertEquals(controller.productSelectionList.size(),3);
            List<BalanceoController.ProductoWrapper> lista;
            try{
        	   lista = BalanceoController.buscarRemoto(String.valueOf(dtPedido.date()),String.valueOf(oficinaVentas.Id));
            }catch(Exception e){
                System.debug('Validación correcta=' + e.getMessage());
            }

            lista = BalanceoController.buscarRemoto(String.valueOf(System.now().date()),String.valueOf(oficinaVentas.Id));
        	if(lista.size()>0){
        		lista.get(0).getPedidosIds();
        		lista.get(0).getAccountsIds();
        	}

            Map<Integer,Boolean> cierrePlazas = BalanceoController.validaCierrePlaza(new List<String>{'100','123'}, 100);

            List<String> pedidosIdsText = new List<String>();
            pedidosIdsText.add(pedido1.Id);
            String respuesta;
            try{
                respuesta = BalanceoController.guardaBalanceRemoto(pedidosIdsText, new List<String>{pedidoItem03.Id+'@1'});
                respuesta = BalanceoController.guardaBalanceRemoto(pedidosIdsText, new List<String>{pedidoItem03.Id+'@0'});
                respuesta = BalanceoController.guardaBalanceRemoto(pedidosIdsText, new List<String>{pedidoItem03.Id+'@100'});
                respuesta = BalanceoController.guardaBalanceRemoto(pedidosIdsText, new List<String>{pedidoItem03.Id+'@-2'});
            }catch(Exception e){
                System.debug('Validación correcta=' + e.getMessage());
            }
            BalanceoController.generaProductosPorCliente(new Set<String>{'0'});
            BalanceoController.getGruposVendedoresPedidosBySet(new Set<String>{''});
            BalanceoController.setCuentaPXC([select Id, Cadena__c, Canal_Distribucion__c, Canal_Padre__c, Correo_Electronico__c, 
                DiasEntrega__c, Name, Numero_Cliente_SAP__c, Organizacion_de_Ventas__c, 
                Ramo__c, RFC_Generico__c, Territorio__c, 
                Canal_de_Distribucion_NSC__r.Codigo__c, Canal_de_Distribucion_NSC__r.Name, 
                Parent.Numero_Cliente_SAP__c, Parent.Tipo_de_Credito__c, Parent.RFC__c, 
                Parent.RFC_Generico__c, 
                Tipo_Surtido__c, 
                RecordType.Name from Account Where Name='TEST2']);

            ListaPreciosQueryNSCWS.ArrayOfPreciosXCliente listClientesLP = new ListaPreciosQueryNSCWS.ArrayOfPreciosXCliente();
		BalanceoController.OperaEnSapOfiCerrada('123');

        Test.stopTest();
	}
}