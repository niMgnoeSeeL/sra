package sampling.svcomp.jpf;

    import gov.nasa.jpf.symbc.Debug;

    import java.util.Random;

public class ExSymExeSuzette_false {
  public static void test() {
        int x = Debug.makeSymbolicInteger("x");
        int y = Debug.makeSymbolicInteger("y");

    int v = method_a(x, y);

    if (v > 0) {

      System.out.println("branch taken");

      int tmp = method_b(x); 

      if (tmp == x) 

        System.out.println("inner branch taken"); 

    } else{
      // assert false;
    }
  }

  public static int method_a(int x, int y) {

    if (x > 10)

      return x;

    if (y > 10)

      return y;

    return 0;
  }
  public static int method_b(int z) {

    if (z > 10)
      return z++;
    else
      return z--;
  }

  public static void main(String[] args) {

    Random rand = new Random();
    test();
  }
}

