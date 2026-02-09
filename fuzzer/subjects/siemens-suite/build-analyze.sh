#!/bin/bash

# Helper script to build CodeQL databases for all subjects in the Siemens Suite
# 1) Build codeql databases for each subject
# 2) Run CodeQL queries against each database

set -e  # Exit on error
dry_run=false

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

CODEQL_PACK_DIR="/opt/codeql/qlpacks/codeql/cpp-queries/1.5.10/Security/CWE"
TAINT_REPORT_DIR="taint_reports"

# List the subdirectories to get the subjects in Siemens Suite
PROJECTS=$(find . -maxdepth 1 -type d -not -name "." -printf "%f\n")

# Print the available subjects
echo "Available Siemens Suite subjects:"
for PROJECT in $PROJECTS; do
    echo "  - $PROJECT"
done
echo ""

# Validate dependencies
if ! command -v codeql &> /dev/null; then
    echo "Error: codeql command not found. Please install CodeQL CLI."
    exit 1
fi

if [ ! -d "$CODEQL_PACK_DIR" ]; then
    echo "Error: CodeQL pack directory not found: $CODEQL_PACK_DIR"
    exit 1
fi

if [ ! -f "./build-codeql-db.sh" ]; then
    echo "Error: build-codeql-db.sh script not found in current directory."
    exit 1
fi


CODEQL_CWE_LIST=(
  "CWE-022/TaintedPath.ql"
  "CWE-078/ExecTainted.ql"
#   "CWE-079/CgiXss.ql" covered on in Java
#   "CWE-089/SqlTainted.ql" # covered in Java
  "CWE-114/UncontrolledProcessOperation.ql"
  "CWE-120/UnboundedWrite.ql"
#   "CWE-129/ImproperArrayIndexValidation.ql" # NOT COVERED
  "CWE-134/UncontrolledFormatString.ql"
  "CWE-190/ArithmeticTainted.ql"
  "CWE-190/ArithmeticUncontrolled.ql"
  "CWE-190/TaintedAllocationSize.ql"
#   "CWE-290/AuthenticationBypass.ql" # NOT COVERED
#   "CWE-311/CleartextBufferWrite.ql" # WINDOWS TESTS ONLY
#   "CWE-311/CleartextFileWrite.ql" # WINDOWS TESTS ONLY
#   "CWE-311/CleartextTransmission.ql" # WINDOWS TESTS ONLY
#   "CWE-313/CleartextSqliteDatabase.ql" # JAVA TESTS ONLY
#   "CWE-497/ExposedSystemData.ql" # NOT COVERED
#   "CWE-497/PotentiallyExposedSystemData.ql" # NOT COVERED
#   "CWE-611/XXE.ql" # NOT COVERED
#   "CWE-807/TaintedCondition.ql" # WINDOWS TESTS ONLY
)


echo "=== Building CodeQL Databases ==="
for PROJECT in $PROJECTS; do
    echo "Building database for project $PROJECT..."
    if [ "$dry_run" = true ]; then
        echo "(Dry Run) ./build-codeql-db.sh \"$PROJECT\""
    else
        ./build-codeql-db.sh "$PROJECT"
    fi
done
echo ""
sleep 3

# Step 2: Run CodeQL queries against appropriate databases
for PROJECT in $PROJECTS; do
    echo "Analyzing project: $PROJECT"
    mkdir -p "$PROJECT/$TAINT_REPORT_DIR"

    cd "$SCRIPT_DIR/$PROJECT" || { echo "Error: Could not change to project directory $PROJECT"; exit 1; }
    
    for QUERY in "${CODEQL_CWE_LIST[@]}"; do
        CWE_LABEL=$(echo "$QUERY" | cut -d'/' -f1)           # e.g. CWE-022
        QUERY_NAME=$(basename "$QUERY" .ql)                  # e.g. TaintedPath

        echo "  Running CodeQL Query: ${CWE_LABEL}/${QUERY_NAME} on project $PROJECT"
        
        DB_NAME="siemens-${PROJECT}"
        OUTPUT_SARIF="${TAINT_REPORT_DIR}/Siemens-${PROJECT}_CODEQL${CWE_LABEL}_${QUERY_NAME}.sarif"

        # Run CodeQL query
        if [ "$dry_run" = true ]; then
            echo "(Dry Run) codeql database analyze \"$DB_NAME\" \"$CODEQL_PACK_DIR/$QUERY\" --format=sarifv2.1.0 --output=\"$OUTPUT_SARIF\""
        else
            codeql database analyze "$DB_NAME" "$CODEQL_PACK_DIR/$QUERY" --format=sarifv2.1.0 --output="$OUTPUT_SARIF"
        fi

        # Check if any results were found
        if [ "$dry_run" = true ]; then
            echo "(Dry Run) Skipping SARIF result check."
        else
            if [ -f "$OUTPUT_SARIF" ]; then
                if grep -q '"results":[[:space:]]*\[[[:space:]]*\]' "$OUTPUT_SARIF"; then
                    echo "⚠️ No issues found for $CWE_LABEL/$QUERY_NAME in project $PROJECT."
                else
                    echo "✅ Issues found for $CWE_LABEL/$QUERY_NAME in project $PROJECT! See report: $OUTPUT_SARIF"
                fi
            else
                echo "❌ Report not found: $OUTPUT_SARIF"
            fi
        fi
        
    done
    echo ""
    cd "$SCRIPT_DIR" || { echo "Error: Could not change back to script directory"; exit 1; }
done


