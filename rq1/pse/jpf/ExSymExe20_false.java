package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExSymExe20_false {

  public static void main(String[] args) {
    test();
  }
  /* we want to let the user specify that this method should be symbolic */

  /*
   * test IF_ICMPLT, IADD & ISUB  bytecodes
   */
  public static void test() {
        int x = Debug.makeSymbolicInteger("x");
        int z = Debug.makeSymbolicInteger("z");
        int r = Debug.makeSymbolicInteger("r");
    if (x < 0)
      return;
    x = x % 3;
    if (z < 0)
      return;
    z = z % 9;
    System.out.println("Testing ExSymExe20");
    int y = 3;
    r = x + z;
    x = z - y;
    z = r;
    if (z >= x) 
      System.out.println("branch FOO1");
    else
      System.out.println("branch FOO2");
    if (x >= r)
      System.out.println("branch BOO1");
    else {
      // assert false;
      System.out.println("branch BOO2");
    }

    
  }
}

