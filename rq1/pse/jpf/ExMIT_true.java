package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    public class ExMIT_true {
  public static void main(String[] args) {
    test();
  }
  public static int test() {
        int i = Debug.makeSymbolicInteger("i");
    if (i != 1)
      return 0;
    if (2 * (i + 1) == 10) { 
      // assert false;
      return 1;
    }
    return 0;
  }
  public static int boo(float i) {
    if ((i + 1) * 2 > 10)
      return 1;
    return 0;
  }
}

