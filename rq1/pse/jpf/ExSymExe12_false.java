package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExSymExe12_false {
  static int field;
  static int field2;

  public static void main(String[] args) {
    test();
  }
  /* we want to let the user specify that this method should be symbolic */

  /*
   * test IF_ICMPGE, IADD & ISUB  bytecodes
   */
  public static void test() {
        int x = Debug.makeSymbolicInteger("x");
        int z = Debug.makeSymbolicInteger("z");
    System.out.println("Testing ExSymExe12");
    int y = 3;
    int r = x + z;
    x = z - y;
    z = r;
    if (z < x)
      System.out.println("branch FOO1");
    else
      System.out.println("branch FOO2");
    if (x < r) 
      System.out.println("branch BOO1");
    else {
      System.out.println("branch BOO2");
      // assert false;
    }
  }
}

