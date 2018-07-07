global class BatchLealtad implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC){

        // Selecciono las tarjetas que tengan ventas en el ultimo mes y no hayan sido procesadas
        String query = 'SELECT Id,Account__c,Puntos__c FROM Tarjeta__c WHERE Account__c IN (SELECT Cliente__c FROM Venta__c WHERE Procesada__c=false and Fecha__c=LAST_MONTH)';

        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Tarjeta__c> scope){

        if (scope.size() > 0) {
            
            // Id de las tarjetas
            Set<Id> tarjetasIds = new Set<Id>();
            
            // Clientes de las tarjetas
            Set<Id> clientesIds = new Set<Id>();
            
            for(Tarjeta__c tarjeta : scope){
                tarjetasIds.add(tarjeta.Id);
                clientesIds.add(tarjeta.Account__c);
            }
            
            // ID de las ventas que forman parte del proceso
            Set<Id> ventas = new Set<Id>();
            
            // Productos de las ventas
            Set<Id> productosIds = new Set<Id>();
            
            // Lista de ventas procesadas
            List<Venta__c> ventasList = new List<Venta__c>();
            
            // Ventas por cliente
            Map<Id,List<Venta__c>> ventasCliente = new Map<Id,List<Venta__c>>();
            
            for (Venta__c venta : [SELECT Id,Cliente__c,Importe__c,Fecha__c,Producto__c, Procesada__c FROM Venta__c WHERE Procesada__c=false and Fecha__c=LAST_MONTH and Cliente__c IN :clientesIds]){
                
                ventas.add(venta.Id);
                productosIds.add(venta.Producto__c);
                
                // Marco la venta como procesada
                venta.Procesada__c = true;
                ventasList.add(venta);

                if(ventasCliente.containsKey(venta.Cliente__c)){
                    ventasCliente.get(venta.Cliente__c).add(venta);
                } else {
                    List<Venta__c> ventaList = new List<Venta__c>();
                    ventaList.add(venta);
                    ventasCliente.put(venta.Cliente__c,ventaList);
                }
                
            }
            
            // Productos participantes de las ventas
            Map<Id,Product2> productos = new Map<Id,Product2 >([select Id,Name,ProductCode,Family from Product2  where Id IN :productosIds]);
            
            // Programas de Lealtad en los que participa cada tarjeta
            Map<Id,List<Id>> programasdeLealtadPorTarjeta = new Map<Id,List<Id>>();
            
            // ID de programas de lealtad que forman parte del proceso
            Set<Id> programasDeLealtad = new Set<Id>();
            
            for (AsociacionTarjetaProgramaDeLealtad__c pdlpt : [SELECT Id,Programa_de_Lealtad__c,Tarjeta__c FROM AsociacionTarjetaProgramaDeLealtad__c WHERE Tarjeta__c IN :tarjetasIds]){
                programasDeLealtad.add(pdlpt.Programa_de_Lealtad__c);
                if(programasdeLealtadPorTarjeta.containsKey(pdlpt.Tarjeta__c)){
                    programasdeLealtadPorTarjeta.get(pdlpt.Tarjeta__c).add(pdlpt.Programa_de_Lealtad__c);
                } else {
                    List<Id> programas = new List<Id>();
                    programas.add(pdlpt.Programa_de_Lealtad__c);
                    programasdeLealtadPorTarjeta.put(pdlpt.Tarjeta__c, programas);
                }
            }
            
            // Reglas participantes de los programas de lealtad
            List<ReglaNew__c> reglas = [select Id,Programa_de_Lealtad__c,Puntos_a_otorgar__c,Producto__r.ProductCode,Familia_de_Producto__c,Importe__c from ReglaNew__c where Programa_de_Lealtad__c IN :programasDeLealtad];
        	Set<Id> reglasIds = new Set<Id>();
            // Reglas por programa de lealtad
            Map<Id,List<ReglaNew__c>> reglasPorPrograma = new Map<Id,List<ReglaNew__c>>();
        
            for(ReglaNew__c regla:reglas){
                
                reglasIds.add(regla.Id);
                if(reglasPorPrograma.containsKey(regla.Programa_de_Lealtad__c)){
                    reglasPorPrograma.get(regla.Programa_de_Lealtad__c).add(regla);
                }else{
                    List<ReglaNew__c> reg = new List<ReglaNew__c>();
                    reg.add(regla);
                    reglasPorPrograma.put(regla.Programa_de_Lealtad__c,reg);
                }
                
            }
            
            // Lista de clientes para actualizar las fechas de ultima venta
            Map<Id, Account> clientesList = new Map<Id, Account>();
            
            // Lista de tarjetas que sumaron puntos para ser actualizadas
            Map<Id, Tarjeta__c> tarjetasList = new Map<Id,Tarjeta__c>();
            
            // Proceso las tarjetas
            for(Tarjeta__c tarjeta : scope){
                
                Boolean actualizarTarjeta = false;

                if (programasdeLealtadPorTarjeta.containsKey(tarjeta.Id)){
                
                    // Procesos los programas de lealtad en el que participa la tarjeta
                    for (Id prog: programasdeLealtadPorTarjeta.get(tarjeta.Id)){
    
                        Map<Id,Decimal> sumarizadoPorRegla = new Map<Id,Decimal>();
                    
                        // Proceso las ventas del cliente de la tarjeta
                        for(Venta__c venta : ventasCliente.get(tarjeta.Account__c)){
    
                            // Actualizo la fecha de ultima venta del cliente
                            Account cu = new Account();
                            cu.Id = venta.Cliente__c;
                            cu.Fecha_de_Ultima_Venta__c = venta.Fecha__c;
                            clientesList.put(cu.Id,cu);
                            
                            // Proceso las reglas del programa de lealtad
                            for (ReglaNew__c reglaEvalua : reglasPorPrograma.get(prog)){
                               
                                /*if(venta.Importe__c < reglaEvalua.Importe__c){
                                    continue;
                                }*/
                                
                                Product2 productoVenta = productos.get(venta.Producto__c);

                                if (reglaEvalua.Producto__r.ProductCode != null && 
                                    reglaEvalua.Producto__r.ProductCode != productoVenta.ProductCode){
                                        continue;
                                }
                                
                                if (reglaEvalua.Familia_de_Producto__c != null && 
                                    reglaEvalua.Familia_de_Producto__c != productoVenta.Family){
                                        continue;
                                }
                                
                                if (!sumarizadoPorRegla.containsKey(reglaEvalua.Id)){
                                    sumarizadoPorRegla.put(reglaEvalua.Id, 0);
                                }
                                
                                Decimal total = sumarizadoPorRegla.get(reglaEvalua.Id) + venta.Importe__c;
                                sumarizadoPorRegla.put(reglaEvalua.Id, total);
                                
                            }
                            
                            
                        }
    
                        // Calculo los puntos en base a lo sumarizado
                        for (ReglaNew__c reglaPuntos : reglasPorPrograma.get(prog)){
                            
                            if (sumarizadoPorRegla.containsKey(reglaPuntos.Id)){
                                
                                Decimal divider = sumarizadoPorRegla.get(reglaPuntos.Id) / reglaPuntos.Importe__c;
                                Integer multiplicador = divider.intValue();
    
                                tarjeta.Puntos__c = tarjeta.Puntos__c + reglaPuntos.Puntos_a_otorgar__c * multiplicador;
                                actualizarTarjeta = true;
                            }
                        }
                        
                    }
                }
                if(actualizarTarjeta){
                    tarjetasList.put(tarjeta.id,tarjeta);
                }
            }
            
            // Actualizo las ventas
            if(ventasList.size() > 0){
                update ventasList;                
            }
            
            // Actualizo los clientes
            if(clientesList.size() > 0){            
                update clientesList.values();                
            }
            
            // Actualizo las tarjetas
            if (tarjetasList.size() > 0){
                update tarjetasList.values();
        	}
            
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        BatchLimpiarPuntos b = new BatchLimpiarPuntos(); 
      	Database.executebatch(b);     
    }
}