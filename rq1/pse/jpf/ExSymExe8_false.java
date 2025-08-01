package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExSymExe8_false {

  public static void main(String[] args) {
    test();
  }

  /*
   * test ISUB & IFGE bytecodes (Note: javac compiles "<" to IFGE)
   */
  public static void test() {
        int x = Debug.makeSymbolicInteger("x");
        int z = Debug.makeSymbolicInteger("z");
    x = x % 3;
    z = z % 5;
    System.out.println("Testing ExSymExe8");
    int y = 3;
    int p = 2;
    x = z - y;
    z = z - p;
    if (z < 0) 
      System.out.println("branch FOO1");
    else {
      System.out.println("branch FOO2");
      // assert false;
    }
    if (x < 0)
      System.out.println("branch BOO1");
    else
      System.out.println("branch BOO2");
  }
}

