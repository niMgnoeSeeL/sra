package sampling.svcomp.algorithm;

import gov.nasa.jpf.symbc.Debug;
import sampling.svcomp.algorithm.rbtree.*;

public class RedBlackTreeMain {
  public static void main(String[] args) {
    test(args);
  }

  public static void test(String[] args) {
    // int N = Debug.makeSymbolicInteger("N");
    final int N = Integer.parseInt(args[0]);
    int n = Debug.makeSymbolicInteger("n");
    if (N <= 0)
      return;

    RedBlackTree tree = new RedBlackTree();

    for (int i = 0; i < N; i++)
      tree.treeInsert(new RedBlackTreeNode(i));

    int data = n;
    if (data < 0 || data >= N)
      return;
    RedBlackTreeNode node = tree.treeSearch(tree.root(), data);
    // assert (node != null);
    System.out.println("here i am");
    if (node != null)
      System.out.println("here i am 2");
    else
      System.out.println("here i am 3");
  }
}
