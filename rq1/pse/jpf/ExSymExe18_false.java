package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExSymExe18_false {

  public static void main(String[] args) {
    test();
    
  }
  /* we want to let the user specify that this method should be symbolic */

  /*
   * test IF_ICMPLE & IMUL  bytecodes
   */
  public static void test() {
        int x = Debug.makeSymbolicInteger("x");
        int z = Debug.makeSymbolicInteger("z");
        int r = Debug.makeSymbolicInteger("r");
    System.out.println("Testing ExSymExe18");
    int y = 3;
    x = x * r;
    z = z * x;
    r = y * x;
    if (z > x) 
      System.out.println("branch FOO1");
    else {
      System.out.println("branch FOO2");
      // assert false;
    }
    if (x > r)
      System.out.println("branch BOO1");
    else
      System.out.println("branch BOO2");

    
  }
}

