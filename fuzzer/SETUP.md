## Setting up the development environment


1. Navigate to the `fuzzer` directory and open VSCode.
```bash
# Assuming you are in the root directory `sra`
cd fuzzer
code .
```
2. Build the container using the Dev containers extension in VSCode. In the Command Palette (Ctrl+Shift+P), search for and select `Dev Containers: Reopen in Container`. This will build the container based on the configuration defined in the `.devcontainer` folder and reopen the project inside the container.

3. Once the container is built and you are inside it, run `setup_tools.sh`. This will build afl++ and fuzztastic.

4. Build the instrumentation tool
In the Command Palette, search for and select `Tasks: Run Task`, then select `sense: cmake-config-debug` to configure the build system. Then run `sense: build-all` to build the instrumentation tool.

5. Build the dynamo RIO client
In the Command Palette, search for and select `Tasks: Run Task`, then select `dynamo: cmake-config` to configure the build system, then run `dynamo: build` to build the DynamoRIO client.

6. Under the `fuzzer/sense` directory, run `/workspaces/fuzzer/sense/merge_compile_commands.sh` to merge the compile commands from the instrumentation tool and the DynamoRIO client. This will allow clangD to work correctly for all projects.

7. Install CodeQL CLI. You will need this to run some security related queries.

8. Install `PyYAML` and `click` to the system python environment by `pip install --break-system-packages PyYAML click`.

## Implementation
The reachability estimator should be implemented in the `fuzzer/sense/monitor/` directory. You can create a new subdirectory and add your implementation there. The monitor service is a standalone Python process that receives runtime events from instrumented programs and correlates them to detect dataflow coverage and taint flow completions. It runs as a separate process from the target program and communicates via shared memory for high performance. For the design and implementation details, checkout the [README.md](sense/monitor/README.md).

## Examples
Subject programs should be placed under `/workspaces/fuzzer/subjects`. Copy the siemens suite subjects (totinfo, ...) to the `/workspaces/fuzzer/subjects/siemens-suite` directory. 

Run `build-analyze.sh` to build CodeQL databases and generate the necessary CodeQL query reports. The generated reports will be `.../siemens-suite/{PROJ}/taint_reports/*.sarif`, you can open it and visualize using the SARIF Viewer extension.

### TOTINFO
The `totinfo` subject is a simple C program that processes some input data. There is at least 1 reported dataflow in the `Siemens-totinfo_CODEQLCWE-190_ArithmeticTainted.sarif` report.

1. Move `BUILD.sh` to the totinfo directory.

2. Run `totinfo_fuzz_example.sh` to see end-to-end example of running the pipeline. This includes
    - Building the totinfo subject with debug info produce compilation database
    - Instrumenting totinfo with our taint tracking instrumentation tool
    - Fuzztastic instrumentation
    - AFL Instrumentation
    - Launching the Flow Monitor to track dataflows in real time
    - Launching AFL to fuzz


