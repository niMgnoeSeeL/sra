package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExSymExe15_true {

  public static void main(String[] args) {
    test();
  }
  /* we want to let the user specify that this method should be symbolic */

  /*
   * test IF_ICMPGT, IADD & ISUB  bytecodes
   */
  public static void test() {
        int x = Debug.makeSymbolicInteger("x");
        int z = Debug.makeSymbolicInteger("z");
        int r = Debug.makeSymbolicInteger("r");
    if(z < 0)
      return;
    System.out.println("Testing ExSymExe15");
    int y = 3;
    r = x + z;
    z = x - y - 4;
    if (r <= 99) { 
      System.out.println("branch FOO1");
      // assert false;
    } else
      System.out.println("branch FOO2");
    if (x <= z)
      System.out.println("branch BOO1");
    else
      System.out.println("branch BOO2");

    
  }
}

