package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExSymExe26_false {

  public static void main(String[] args) {
    test();
  }

  public static void test() {
        int arg = Debug.makeSymbolicInteger("arg");
    if (arg < 0)
      return;

    int a = arg % 3;
    int b = arg % 8;
    testOrig(a, b, a);
  }

  /*
   * test symbolic = concrete
   * (con#sym#sym)
   */
  public static void testOrig(int x, int y, int z) {
    System.out.println("Testing ExSymExe26");
    y = x;
    z++;
    if (z > 0) { 
      System.out.println("branch FOO1");
      // assert false;
    } else
      System.out.println("branch FOO2");
    if (y > 0)
      System.out.println("branch BOO1");
    else
      System.out.println("branch BOO2");

    
  }
}

