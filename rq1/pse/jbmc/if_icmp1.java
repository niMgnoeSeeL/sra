package sampling.svcomp.jbmc;

import gov.nasa.jpf.symbc.Debug;

public class if_icmp1 {
    private static void f(int i, int j) {
        if (i == j) {
            // assert false;
            System.out.println("here i am");
        }
        // if (i >= j) {
        // assert false;
        // }
        // if (j > i) {
        // assert true;
        // } else {
        // assert false;
        // }
        // if (j <= i) {
        // assert false;
        // }
        // if (j < i) {
        // assert false;
        // } else {
        // assert true;
        // }
    }

    public static void main(String[] args) {
        test();
    }

    public static void test() {
        int i = Debug.makeSymbolicInteger("i");
        if (i + 1 < 0)
            return;
        f(i, i + 1);
    }
}
