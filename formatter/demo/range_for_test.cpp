// Test file for range-based for loops (C++)
#include <vector>
#include <iostream>

int main() {
    std::vector<int> numbers = {1, 2, 3, 4, 5};
    
    // Range-based for loop that should be broken
    for (auto num : numbers) { std::cout << num << " "; }
    
    // Nested range-based for loop
    std::vector<std::vector<int>> matrix = {{1, 2}, {3, 4}};
    for (auto& row : matrix) { for (auto& elem : row) { std::cout << elem << " "; } }
    
    return 0;
}