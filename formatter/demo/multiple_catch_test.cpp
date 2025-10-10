// Test multiple catch clauses formatting
#include <iostream>
#include <stdexcept>

int main() {
    // Multiple catch clauses on same line
    try { throw std::runtime_error("error"); } catch (const std::runtime_error& e) { std::cout << "Runtime error\n"; } catch (const std::exception& e) { std::cout << "General error\n"; } catch (...) { std::cout << "Unknown error\n"; }
    
    return 0;
}