package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    import java.io.*;

public class ExSymExe13_SMedition {
  static int field;
  static int field2;

  public static void main(String[] args) throws IOException {
    test();
  }
  /* we want to let the user specify that this method should be symbolic */

  /*
   * test IF_ICMPGE, IADD & ISUB  bytecodes
   */
  public static void test() throws NumberFormatException, IOException {
        int x = Debug.makeSymbolicInteger("x");
        int z = Debug.makeSymbolicInteger("z");
    if(z < 0)
      return;
    System.out.println("Testing ExSymExe13");
    String command = "bash /PReach/preach-benchmarks/sv-comp/jpf-regression-modified/ExSymExe13_SMedition/test.sh";
    int y = Integer.parseInt(new BufferedReader(new InputStreamReader(Runtime.getRuntime().exec(command).getInputStream())).readLine());
    int r = x + z;
    z = x - y - 4;
    if (r < 99)
      System.out.println("branch FOO1");
    else
      System.out.println("branch FOO2");
    if (x < z) {
      System.out.println("branch BOO1");
      // assert false;
    } else
      System.out.println("branch BOO2");

    
  }
}

