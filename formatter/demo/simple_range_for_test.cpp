// Simple range-based for loop test without compound statements
#include <vector>
#include <iostream>

int main() {
    std::vector<int> numbers = {1, 2, 3, 4, 5};
    
    // Simple range-based for loop without braces
    for (auto num : numbers) std::cout << num << " ";
    
    // Another simple range-based for loop
    for (const auto& n : numbers) printf("%d ", n);
    
    return 0;
}