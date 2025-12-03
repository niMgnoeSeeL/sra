# Merge compile_commands.json from sense build to main compile_commands.json
cd /workspaces/fuzzer/sense/build || exit 1
jq -s 'add' /workspaces/fuzzer/compile_commands_afl+ft.json /workspaces/fuzzer/sense/build/compile_commands.json > /tmp/merged.json && mv /tmp/merged.json /workspaces/fuzzer/compile_commands.json && echo "✓ Merged. Total entries:" && jq '. | length' /workspaces/fuzzer/compile_commands.json

# Merge compile_commands.json from dynamo build to main compile_commands.json
cd /workspaces/fuzzer/sense/dynamo/build || exit 1
jq -s 'add' /workspaces/fuzzer/compile_commands.json /workspaces/fuzzer/sense/dynamo/build/compile_commands.json > /tmp/merged.json && mv /tmp/merged.json /workspaces/fuzzer/compile_commands.json && echo "✓ Merged. Total entries:" && jq '. | length' /workspaces/fuzzer/compile_commands.json
