int f(int a, int b, int c) {
  int x = (a && b) ? 1 : c;
  if (a || b) return x;
  return x && b;
}