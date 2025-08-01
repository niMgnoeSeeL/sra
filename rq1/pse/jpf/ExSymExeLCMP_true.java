package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExSymExeLCMP_true {

  public static void main(String[] args) {
    test();
  }

  public static void test() {
        int x = Debug.makeSymbolicInteger("x");
        int y = Debug.makeSymbolicInteger("y");

    int res = x;
    if (res + 1 > res + 2) { 
      // assert false;
      System.out.println("x >0");
    } else
      System.out.println("x <=0");
  }
}

