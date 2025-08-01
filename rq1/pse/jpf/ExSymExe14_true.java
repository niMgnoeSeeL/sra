package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExSymExe14_true {

  public static void main(String[] args) {
    test();
  }

  public static void test() {
        int arg = Debug.makeSymbolicInteger("arg");
    if(arg < 0)
      return;
    int x = arg;
    testOrig(x, arg);
  }
  /* we want to let the user specify that this method should be symbolic */

  /*
   * test IF_ICMPGT, IADD & ISUB  bytecodes
   */
  public static void testOrig(int x, int z) {
    System.out.println("Testing ExSymExe14");
    int y = 3;
    int r = x + z;
    x = z - y;
    z = r;
    if (z <= x) { 
      System.out.println("branch FOO1");
      // assert false;
    } else
      System.out.println("branch FOO2");
    if (x <= r)
      System.out.println("branch BOO1");
    else
      System.out.println("branch BOO2");

    
  }
}

