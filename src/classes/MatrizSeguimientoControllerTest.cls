@isTest
private class MatrizSeguimientoControllerTest {

    static testMethod void myUnitTest() {
      Test.StartTest();
      MatrizSeguimientoController con = new MatrizSeguimientoController();
      con.getEfectividad();
      con.getObjetivoEfec();
      con.Ops.getPocValor1();
      con.Ops.getPocValor2();
      con.Ops.getPocValor3();
      con.Ops.getPocTotal();
      Test.stopTest();
        
    }
}