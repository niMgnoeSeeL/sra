; ModuleID = 'flow_scalars.c'
source_filename = "flow_scalars.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [9 x i8] c"int: %d\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [14 x i8] c"double: %.2f\0A\00", align 1, !dbg !7

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !22 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca double, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !27, !DIExpression(), !28)
  %4 = call i64 @read(i32 noundef 0, ptr noundef %2, i64 noundef 4), !dbg !29
  %5 = load i32, ptr %2, align 4, !dbg !30
  %6 = sitofp i32 %5 to double, !dbg !30
  %7 = call double @log(double noundef %6) #3, !dbg !31
  %8 = load i32, ptr %2, align 4, !dbg !32
  %9 = mul nsw i32 %8, 2, !dbg !33
  %10 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %9), !dbg !34
    #dbg_declare(ptr %3, !35, !DIExpression(), !37)
  %11 = call i64 @read(i32 noundef 0, ptr noundef %3, i64 noundef 8), !dbg !38
  %12 = load double, ptr %3, align 8, !dbg !39
  %13 = call double @log(double noundef %12) #3, !dbg !40
  %14 = load double, ptr %3, align 8, !dbg !41
  %15 = fmul double %14, 2.000000e+00, !dbg !42
  %16 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, double noundef %15), !dbg !43
  ret i32 0, !dbg !44
}

declare i64 @read(i32 noundef, ptr noundef, i64 noundef) #1

; Function Attrs: nounwind
declare double @log(double noundef) #2

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!12}
!llvm.module.flags = !{!14, !15, !16, !17, !18, !19, !20}
!llvm.ident = !{!21}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 10, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "flow_scalars.c", directory: "/workspaces/fuzzer/sense/demo", checksumkind: CSK_MD5, checksum: "9f185b28423dae24cf1f72b9ffeb6469")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 9)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 16, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 112, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 14)
!12 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Ubuntu clang version 20.1.8 (++20250804090239+87f0227cb601-1~exp1~20250804210352.139)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !13, splitDebugInlining: false, nameTableKind: None)
!13 = !{!0, !7}
!14 = !{i32 7, !"Dwarf Version", i32 5}
!15 = !{i32 2, !"Debug Info Version", i32 3}
!16 = !{i32 1, !"wchar_size", i32 4}
!17 = !{i32 8, !"PIC Level", i32 2}
!18 = !{i32 7, !"PIE Level", i32 2}
!19 = !{i32 7, !"uwtable", i32 2}
!20 = !{i32 7, !"frame-pointer", i32 2}
!21 = !{!"Ubuntu clang version 20.1.8 (++20250804090239+87f0227cb601-1~exp1~20250804210352.139)"}
!22 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 5, type: !23, scopeLine: 5, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !26)
!23 = !DISubroutineType(types: !24)
!24 = !{!25}
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !{}
!27 = !DILocalVariable(name: "x", scope: !22, file: !2, line: 7, type: !25)
!28 = !DILocation(line: 7, column: 7, scope: !22)
!29 = !DILocation(line: 8, column: 3, scope: !22)
!30 = !DILocation(line: 9, column: 7, scope: !22)
!31 = !DILocation(line: 9, column: 3, scope: !22)
!32 = !DILocation(line: 10, column: 23, scope: !22)
!33 = !DILocation(line: 10, column: 25, scope: !22)
!34 = !DILocation(line: 10, column: 3, scope: !22)
!35 = !DILocalVariable(name: "y", scope: !22, file: !2, line: 13, type: !36)
!36 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!37 = !DILocation(line: 13, column: 10, scope: !22)
!38 = !DILocation(line: 14, column: 3, scope: !22)
!39 = !DILocation(line: 15, column: 7, scope: !22)
!40 = !DILocation(line: 15, column: 3, scope: !22)
!41 = !DILocation(line: 16, column: 28, scope: !22)
!42 = !DILocation(line: 16, column: 30, scope: !22)
!43 = !DILocation(line: 16, column: 3, scope: !22)
!44 = !DILocation(line: 18, column: 3, scope: !22)
