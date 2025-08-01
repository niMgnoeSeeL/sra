package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExSymExe27_false {

  public static void main(String[] args) {
    test();
  }

  /*
   * test concrete = symbolic
   * (con#sym#sym)
   */
  public static void test() {
        int x = Debug.makeSymbolicInteger("x");
        int y = Debug.makeSymbolicInteger("y");
        int z = Debug.makeSymbolicInteger("z");
    System.out.println("Testing ExSymExe27");
    x = z;
    y = z + x;
    if (x < y) { 
      // assert false;
      System.out.println("branch FOO1");
    } else
      System.out.println("branch FOO2");
    if (z > 0)
      System.out.println("branch BOO1");
    else
      System.out.println("branch BOO2");

    
  }
}

