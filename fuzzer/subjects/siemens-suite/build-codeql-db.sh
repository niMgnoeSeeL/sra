#!/bin/bash

# Helper script to build CodeQL databases for subjects in the Siemens-suite
# Usage:
#   ./build-codeql-db.sh <subject_name>
# Examples:
#   ./build-codeql-db.sh tcas

set -e  # Exit on error

PROJECT="$1"
if [ -z "$PROJECT" ]; then
    echo "Usage: $0 <subject_name>"
    echo "Example: $0 tcas"
    exit 1
fi
cd "${PROJECT}" || { echo "Error: Could not change to project directory ${PROJECT}"; exit 1; }
DB_NAME="siemens-${PROJECT}"
CMAKE_OPTS=""


# Build the CodeQL database
echo "Creating CodeQL database: ${DB_NAME}"
codeql database create "${DB_NAME}" \
    --overwrite \
    --language=cpp \
    --source-root=. \
    --command="bash BUILD.sh"

echo ""
echo "✓ CodeQL database created: ${DB_NAME}"
echo ""
echo "Next steps:"
echo "  1. Run your queries:"
echo "     codeql database analyze ${DB_NAME} <query-suite> --format=sarif-latest --output=results.sarif"
echo ""
echo "  2. Or use VS Code CodeQL extension to analyze the database"
