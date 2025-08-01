package sampling.svcomp.jbmc;

import gov.nasa.jpf.symbc.Debug;

public class lookupswitch1 {
    public static void main(String[] args) {
        test();
    }

    public static void test() {
        int i = Debug.makeSymbolicInteger("i");
        int j;
        switch (i) {
            case 1:
                j = 2;
                break;
            case 10:
                j = 11;
                break;
            case 100:
                j = 101;
                break;
            case 1000:
                j = 1001;
                break;
            case 10000:
                j = 10001;
                break;
            case 100000:
                j = 100001;
                break;
            default:
                j = -1;
        }

        if (i == 1 || i == 10 || i == 100 || i == 1000 || i == 10000 || i == 100000)
            System.out.println("here i am");
        // assert j == i + 1;
        // else
        // assert j == -1;
    }
}
