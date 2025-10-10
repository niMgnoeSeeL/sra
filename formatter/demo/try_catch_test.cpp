// Test file for try-catch exception handling (C++)
#include <iostream>
#include <stdexcept>

int divide(int a, int b) {
    if (b == 0) throw std::runtime_error("Division by zero");
    return a / b;
}

int main() {
    // Try-catch block that should be broken
    try { int result = divide(10, 0); std::cout << result << std::endl; } catch (const std::exception& e) { std::cout << "Error: " << e.what() << std::endl; }
    
    // Nested try-catch
    try {
        try { throw std::runtime_error("Inner exception"); } catch (const std::runtime_error& e) { std::cout << "Inner: " << e.what() << std::endl; throw; }
    } catch (const std::exception& e) {
        std::cout << "Outer: " << e.what() << std::endl;
    }
    
    return 0;
}