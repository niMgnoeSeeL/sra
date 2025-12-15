; ModuleID = 'flow_getenv.c'
source_filename = "flow_getenv.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [5 x i8] c"HOME\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [17 x i8] c"Value of %s: %s\0A\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [16 x i8] c"%s is not set.\0A\00", align 1, !dbg !12

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @taint_source(ptr noundef %0) #0 !dbg !27 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !32, !DIExpression(), !33)
  %3 = load ptr, ptr %2, align 8, !dbg !34
  %4 = call ptr @getenv(ptr noundef %3) #3, !dbg !35
  ret ptr %4, !dbg !36
}

; Function Attrs: nounwind
declare ptr @getenv(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !37 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !41, !DIExpression(), !42)
  store ptr @.str, ptr %2, align 8, !dbg !42
    #dbg_declare(ptr %3, !43, !DIExpression(), !44)
  %4 = load ptr, ptr %2, align 8, !dbg !45
  %5 = call ptr @taint_source(ptr noundef %4), !dbg !46
  store ptr %5, ptr %3, align 8, !dbg !44
  %6 = load ptr, ptr %3, align 8, !dbg !47
  %7 = icmp ne ptr %6, null, !dbg !47
  br i1 %7, label %8, label %12, !dbg !47

8:                                                ; preds = %0
  %9 = load ptr, ptr %2, align 8, !dbg !49
  %10 = load ptr, ptr %3, align 8, !dbg !51
  %11 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, ptr noundef %9, ptr noundef %10), !dbg !52
  br label %15, !dbg !53

12:                                               ; preds = %0
  %13 = load ptr, ptr %2, align 8, !dbg !54
  %14 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, ptr noundef %13), !dbg !56
  br label %15

15:                                               ; preds = %12, %8
  ret i32 0, !dbg !57
}

declare i32 @printf(ptr noundef, ...) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!17}
!llvm.module.flags = !{!19, !20, !21, !22, !23, !24, !25}
!llvm.ident = !{!26}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 11, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "flow_getenv.c", directory: "/workspaces/fuzzer/sense/demo", checksumkind: CSK_MD5, checksum: "ed805c922fbfee327b44d11bad94ca67")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 40, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 5)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 17)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 16, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 128, elements: !15)
!15 = !{!16}
!16 = !DISubrange(count: 16)
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
!27 = distinct !DISubprogram(name: "taint_source", scope: !2, file: !2, line: 4, type: !28, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !31)
!28 = !DISubroutineType(types: !29)
!29 = !{!30, !30}
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!31 = !{}
!32 = !DILocalVariable(name: "name", arg: 1, scope: !27, file: !2, line: 4, type: !30)
!33 = !DILocation(line: 4, column: 26, scope: !27)
!34 = !DILocation(line: 6, column: 17, scope: !27)
!35 = !DILocation(line: 6, column: 10, scope: !27)
!36 = !DILocation(line: 6, column: 3, scope: !27)
!37 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 9, type: !38, scopeLine: 9, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !31)
!38 = !DISubroutineType(types: !39)
!39 = !{!40}
!40 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!41 = !DILocalVariable(name: "var_name", scope: !37, file: !2, line: 11, type: !30)
!42 = !DILocation(line: 11, column: 9, scope: !37)
!43 = !DILocalVariable(name: "value", scope: !37, file: !2, line: 12, type: !30)
!44 = !DILocation(line: 12, column: 9, scope: !37)
!45 = !DILocation(line: 12, column: 30, scope: !37)
!46 = !DILocation(line: 12, column: 17, scope: !37)
!47 = !DILocation(line: 13, column: 7, scope: !48)
!48 = distinct !DILexicalBlock(scope: !37, file: !2, line: 13, column: 7)
!49 = !DILocation(line: 14, column: 33, scope: !50)
!50 = distinct !DILexicalBlock(scope: !48, file: !2, line: 13, column: 14)
!51 = !DILocation(line: 14, column: 43, scope: !50)
!52 = !DILocation(line: 14, column: 5, scope: !50)
!53 = !DILocation(line: 15, column: 3, scope: !50)
!54 = !DILocation(line: 16, column: 32, scope: !55)
!55 = distinct !DILexicalBlock(scope: !48, file: !2, line: 15, column: 10)
!56 = !DILocation(line: 16, column: 5, scope: !55)
!57 = !DILocation(line: 18, column: 3, scope: !37)
