package sampling.svcomp.jbmc;

import gov.nasa.jpf.symbc.Debug;

public class TokenTest02 {
    public static void main(String[] args) {
        test();
      }
    
      public static void test() {
        String sentence = Debug.makeSymbolicString("sentence", 15);
        String[] tokens = sentence.split(" ");
    
        int i = 0;
        for (String token : tokens) {
          if (i == 3)
            assert false;
          ++i;
        }
      }
}
