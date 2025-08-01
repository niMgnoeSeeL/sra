package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExSymExeFNEG_true {

  public static void main(String[] args) {
    test();
  }

  public static void test() {
        int x = Debug.makeSymbolicInteger("x");
    if(x >= 0) {
      System.out.println("Testing FNEG");
      int y = -x;
      if (y > 0) { 
        // assert false;
        System.out.println("branch -x > 0");
      } else
        System.out.println("branch -x <= 0");
    }
  }
}

