rm compile_commands.json
clang -g -O0 -Wno-everything totinfo_fuzz.c -MJ compile_commands.json -lm -o totinfo_fuzz
rm -f totinfo_fuzz.o totinfo.fuzz
gclang -g -O0 -Wno-everything totinfo_fuzz.c -lm -o totinfo_fuzz

get-bc totinfo_fuzz
llvm-dis-20 totinfo_fuzz.bc -o totinfo_fuzz.ll 