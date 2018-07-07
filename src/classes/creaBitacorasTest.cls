@isTest
/*
 * @developer   : Rene Carpazo
 * @company     : Evolusoftware
 * @created     : 2017-07-09
 * @description : This is testMethod of the trigger creaBitacoras
 */
private class creaBitacorasTest{
    static testMethod void myTest() {
        AdminSaldosEstrategias__c AdminSaldo = new AdminSaldosEstrategias__c(Name = 'test', Anio__c = '2017', Fecha_Inicial__c = Date.Today(),
            Fecha_Final__c = Date.Today().addDays(2),Saldo_Inicial_Mayo__c = '100',Saldo_Inicial_Export__c = '100',Saldo_Inicial_Auto__c = '100',
            Saldo_Final_Mayo__c = '400',Saldo_Final_Export__c = '200',Saldo_Final_Auto__c = '400');
        Test.StartTest();
        insert AdminSaldo;
        AdminSaldo.Saldo_Inicial_Auto__c = '200';
        update AdminSaldo;
        Test.StopTest();
    }
}