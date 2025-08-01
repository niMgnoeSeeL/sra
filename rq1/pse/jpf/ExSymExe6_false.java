package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExSymExe6_false {

  public static void main(String[] args) {
    test();
  }

  /*
   * test IFEQ (and ISUB) bytecodes (Note: javac compiles "!=" to IFEQ)
   */
  public static void test() {
        int x = Debug.makeSymbolicInteger("x");
        int z = Debug.makeSymbolicInteger("z");
    x = x % 3;
    z = z % 1;
    System.out.println("Testing ExSymExe6");
    int y = 0;
    x = z - y;
    if (z != 0) 
      System.out.println("branch FOO1");
    else {
      System.out.println("branch FOO2");
      // assert false;
    }
    if (x != 0)
      System.out.println("branch BOO1");
    else
      System.out.println("branch BOO2");
  }
}

