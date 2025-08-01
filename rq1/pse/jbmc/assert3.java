package sampling.svcomp.jbmc;

import gov.nasa.jpf.symbc.Debug;

public class assert3 {
    public static void main(String[] args) {
        test();
    }

    public static void test() {
        int i = Debug.makeSymbolicInteger("i");
        if (i >= 1000)
            if (!(i > 1000))
                // assert false;
                System.out.println("here i am");
    }
}
