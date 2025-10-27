; ModuleID = 'flow_mdarray.c'
source_filename = "flow_mdarray.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [11 x i8] c"Row 1: %s\0A\00", align 1, !dbg !0

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !17 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x [16 x i8]], align 16
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !22, !DIExpression(), !27)
  %3 = getelementptr inbounds [4 x [16 x i8]], ptr %2, i64 0, i64 1, !dbg !28
  %4 = getelementptr inbounds [16 x i8], ptr %3, i64 0, i64 0, !dbg !28
  %5 = call i64 @read(i32 noundef 0, ptr noundef %4, i64 noundef 16), !dbg !29
  %6 = getelementptr inbounds [4 x [16 x i8]], ptr %2, i64 0, i64 1, !dbg !30
  %7 = getelementptr inbounds [16 x i8], ptr %6, i64 0, i64 0, !dbg !30
  %8 = call i32 (ptr, ...) @printf(ptr noundef @.str, ptr noundef %7), !dbg !31
  ret i32 0, !dbg !32
}

declare i64 @read(i32 noundef, ptr noundef, i64 noundef) #1

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 10, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "flow_mdarray.c", directory: "/workspaces/fuzzer/sense/demo", checksumkind: CSK_MD5, checksum: "8a8008cd6adec39404ead6705bd0f783")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 88, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 11)
!7 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Ubuntu clang version 20.1.8 (++20250804090239+87f0227cb601-1~exp1~20250804210352.139)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !8, splitDebugInlining: false, nameTableKind: None)
!8 = !{!0}
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 8, !"PIC Level", i32 2}
!13 = !{i32 7, !"PIE Level", i32 2}
!14 = !{i32 7, !"uwtable", i32 2}
!15 = !{i32 7, !"frame-pointer", i32 2}
!16 = !{!"Ubuntu clang version 20.1.8 (++20250804090239+87f0227cb601-1~exp1~20250804210352.139)"}
!17 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 4, type: !18, scopeLine: 4, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !21)
!18 = !DISubroutineType(types: !19)
!19 = !{!20}
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !{}
!22 = !DILocalVariable(name: "matrix", scope: !17, file: !2, line: 5, type: !23)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 512, elements: !24)
!24 = !{!25, !26}
!25 = !DISubrange(count: 4)
!26 = !DISubrange(count: 16)
!27 = !DILocation(line: 5, column: 8, scope: !17)
!28 = !DILocation(line: 8, column: 22, scope: !17)
!29 = !DILocation(line: 8, column: 3, scope: !17)
!30 = !DILocation(line: 10, column: 25, scope: !17)
!31 = !DILocation(line: 10, column: 3, scope: !17)
!32 = !DILocation(line: 12, column: 3, scope: !17)
