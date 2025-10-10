int main() {
    for (int i = 0; i < 100 && i > -10; i++) {
        int result = (i > 50) ? i * 2 : i + 5;
        if (result > 0 && result < 200 || result == 42) {
            printf("Result: %d\n", result);
        }
    }
    return 0;
}