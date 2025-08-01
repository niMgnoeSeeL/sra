package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExSymExeTestAssignments_true {
  int field;

  public static void main(String[] args) {
    test();
  }

  public static void test() {
        int x = Debug.makeSymbolicInteger("x");
    if (x < 0)
      return;
    x = 3;
    if (x > 0) 
      System.out.println("branch BOO1");
    else {
      // assert false;
      System.out.println("branch BOO2");
    }
  }
}

