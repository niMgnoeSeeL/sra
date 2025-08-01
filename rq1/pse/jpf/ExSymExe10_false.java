package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExSymExe10_false {
  static int field;

  public static void main(String[] args) {
    test();
  }
  /* we want to let the user specify that this method should be symbolic */

  /*
   * test IMUl, INEG & IFGT bytecodes
   */
  public static void test() {
        int x = Debug.makeSymbolicInteger("x");
        int z = Debug.makeSymbolicInteger("z");
    if (z < 0)
      return;
    System.out.println("Testing ExSymExe10");
    int y = 3;
    x = x * z;
    z = -x + y;
    if (z <= 0) 
      System.out.println("branch FOO1");
    else {
      System.out.println("branch FOO2");
      // assert false;
    }
    if (x <= 0)
      System.out.println("branch BOO1");
    else
      System.out.println("branch BOO2");

    
  }
}

