; ModuleID = 'flow_scalars.c'
source_filename = "flow_scalars.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [9 x i8] c"int: %d\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [14 x i8] c"double: %.2f\0A\00", align 1, !dbg !7
@stdin = external global ptr, align 8
@.str.2 = private unnamed_addr constant [11 x i8] c"string: %s\00", align 1, !dbg !12

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !27 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca double, align 8
  %4 = alloca [16 x i8], align 16
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !32, !DIExpression(), !33)
  %5 = call i64 @read(i32 noundef 0, ptr noundef %2, i64 noundef 4), !dbg !34
  %6 = load i32, ptr %2, align 4, !dbg !35
  %7 = sitofp i32 %6 to double, !dbg !35
  %8 = call double @log(double noundef %7) #3, !dbg !36
  %9 = load i32, ptr %2, align 4, !dbg !37
  %10 = mul nsw i32 %9, 2, !dbg !38
  %11 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %10), !dbg !39
    #dbg_declare(ptr %3, !40, !DIExpression(), !42)
  %12 = call i64 @read(i32 noundef 0, ptr noundef %3, i64 noundef 8), !dbg !43
  %13 = load double, ptr %3, align 8, !dbg !44
  %14 = call double @log(double noundef %13) #3, !dbg !45
  %15 = load double, ptr %3, align 8, !dbg !46
  %16 = fmul double %15, 2.000000e+00, !dbg !47
  %17 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, double noundef %16), !dbg !48
    #dbg_declare(ptr %4, !49, !DIExpression(), !53)
  %18 = getelementptr inbounds [16 x i8], ptr %4, i64 0, i64 0, !dbg !54
  %19 = load ptr, ptr @stdin, align 8, !dbg !55
  %20 = call ptr @fgets(ptr noundef %18, i32 noundef 16, ptr noundef %19), !dbg !56
  %21 = getelementptr inbounds [16 x i8], ptr %4, i64 0, i64 0, !dbg !57
  %22 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, ptr noundef %21), !dbg !58
  ret i32 0, !dbg !59
}

declare i64 @read(i32 noundef, ptr noundef, i64 noundef) #1

; Function Attrs: nounwind
declare double @log(double noundef) #2

declare i32 @printf(ptr noundef, ...) #1

declare ptr @fgets(ptr noundef, i32 noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!17}
!llvm.module.flags = !{!19, !20, !21, !22, !23, !24, !25}
!llvm.ident = !{!26}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 10, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "flow_scalars.c", directory: "/workspaces/fuzzer/sense/demo", checksumkind: CSK_MD5, checksum: "c9f44379d434ab9f6929a8c759813216")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 9)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 16, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 112, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 14)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 21, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 88, elements: !15)
!15 = !{!16}
!16 = !DISubrange(count: 11)
!17 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Ubuntu clang version 20.1.8 (++20250804090239+87f0227cb601-1~exp1~20250804210352.139)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !18, splitDebugInlining: false, nameTableKind: None)
!18 = !{!0, !7, !12}
!19 = !{i32 7, !"Dwarf Version", i32 5}
!20 = !{i32 2, !"Debug Info Version", i32 3}
!21 = !{i32 1, !"wchar_size", i32 4}
!22 = !{i32 8, !"PIC Level", i32 2}
!23 = !{i32 7, !"PIE Level", i32 2}
!24 = !{i32 7, !"uwtable", i32 2}
!25 = !{i32 7, !"frame-pointer", i32 2}
!26 = !{!"Ubuntu clang version 20.1.8 (++20250804090239+87f0227cb601-1~exp1~20250804210352.139)"}
!27 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 5, type: !28, scopeLine: 5, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !31)
!28 = !DISubroutineType(types: !29)
!29 = !{!30}
!30 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!31 = !{}
!32 = !DILocalVariable(name: "x", scope: !27, file: !2, line: 7, type: !30)
!33 = !DILocation(line: 7, column: 7, scope: !27)
!34 = !DILocation(line: 8, column: 3, scope: !27)
!35 = !DILocation(line: 9, column: 7, scope: !27)
!36 = !DILocation(line: 9, column: 3, scope: !27)
!37 = !DILocation(line: 10, column: 23, scope: !27)
!38 = !DILocation(line: 10, column: 25, scope: !27)
!39 = !DILocation(line: 10, column: 3, scope: !27)
!40 = !DILocalVariable(name: "y", scope: !27, file: !2, line: 13, type: !41)
!41 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!42 = !DILocation(line: 13, column: 10, scope: !27)
!43 = !DILocation(line: 14, column: 3, scope: !27)
!44 = !DILocation(line: 15, column: 7, scope: !27)
!45 = !DILocation(line: 15, column: 3, scope: !27)
!46 = !DILocation(line: 16, column: 28, scope: !27)
!47 = !DILocation(line: 16, column: 30, scope: !27)
!48 = !DILocation(line: 16, column: 3, scope: !27)
!49 = !DILocalVariable(name: "buf", scope: !27, file: !2, line: 19, type: !50)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 128, elements: !51)
!51 = !{!52}
!52 = !DISubrange(count: 16)
!53 = !DILocation(line: 19, column: 8, scope: !27)
!54 = !DILocation(line: 20, column: 9, scope: !27)
!55 = !DILocation(line: 20, column: 27, scope: !27)
!56 = !DILocation(line: 20, column: 3, scope: !27)
!57 = !DILocation(line: 21, column: 24, scope: !27)
!58 = !DILocation(line: 21, column: 3, scope: !27)
!59 = !DILocation(line: 23, column: 3, scope: !27)
