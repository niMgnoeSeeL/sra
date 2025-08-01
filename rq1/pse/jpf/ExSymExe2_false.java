package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExSymExe2_false {

  public static void main(String[] args) {
    test();
  }

  /*
   * test IINC & IFLE bytecodes (Note: javac compiles ">" to IFLE)
   */
  public static void test() {
        int x = Debug.makeSymbolicInteger("x");
        int z = Debug.makeSymbolicInteger("z");
    if (x < 0)
      return;
    x = x % 5 - 5;
    if (z < 0)
      return;
    z = z % 5 - 5;
    System.out.println("Testing ExSymExe2");
    z++;
    x = ++z;
    if (z > 0) 
      System.out.println("branch FOO1");
    else {
      System.out.println("branch FOO2");
      // assert false;
    }
    if (x > 0)
      System.out.println("branch BOO1");
    else {
      System.out.println("branch BOO2");
      
    }
  }
}

