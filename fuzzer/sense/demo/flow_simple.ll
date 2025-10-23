; ModuleID = 'flow_simple.c'
source_filename = "flow_simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@stdin = external global ptr, align 8
@.str = private unnamed_addr constant [3 x i8] c"%s\00", align 1, !dbg !0

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !17 {
  %1 = alloca i32, align 4
  %2 = alloca [16 x i8], align 16
  %3 = alloca double, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !22, !DIExpression(), !26)
  %4 = getelementptr inbounds [16 x i8], ptr %2, i64 0, i64 0, !dbg !27
  %5 = load ptr, ptr @stdin, align 8, !dbg !28
  %6 = call ptr @fgets(ptr noundef %4, i32 noundef 16, ptr noundef %5), !dbg !29
    #dbg_declare(ptr %3, !30, !DIExpression(), !32)
  %7 = getelementptr inbounds [16 x i8], ptr %2, i64 0, i64 0, !dbg !33
  %8 = call double @atof(ptr noundef %7) #4, !dbg !34
  store double %8, ptr %3, align 8, !dbg !32
  %9 = load double, ptr %3, align 8, !dbg !35
  %10 = call double @log(double noundef %9) #5, !dbg !36
  %11 = getelementptr inbounds [16 x i8], ptr %2, i64 0, i64 0, !dbg !37
  %12 = call i32 (ptr, ...) @printf(ptr noundef @.str, ptr noundef %11), !dbg !38
  ret i32 0, !dbg !39
}

declare ptr @fgets(ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: nounwind willreturn memory(read)
declare double @atof(ptr noundef) #2

; Function Attrs: nounwind
declare double @log(double noundef) #3

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind willreturn memory(read) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind willreturn memory(read) }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 10, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "flow_simple.c", directory: "/workspaces/fuzzer/sense/demo", checksumkind: CSK_MD5, checksum: "dcb9ec9b129ea10b25517b71278545e8")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 24, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 3)
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
!17 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 5, type: !18, scopeLine: 5, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !21)
!18 = !DISubroutineType(types: !19)
!19 = !{!20}
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !{}
!22 = !DILocalVariable(name: "buf", scope: !17, file: !2, line: 6, type: !23)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 128, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 16)
!26 = !DILocation(line: 6, column: 8, scope: !17)
!27 = !DILocation(line: 7, column: 9, scope: !17)
!28 = !DILocation(line: 7, column: 27, scope: !17)
!29 = !DILocation(line: 7, column: 3, scope: !17)
!30 = !DILocalVariable(name: "x", scope: !17, file: !2, line: 8, type: !31)
!31 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!32 = !DILocation(line: 8, column: 10, scope: !17)
!33 = !DILocation(line: 8, column: 19, scope: !17)
!34 = !DILocation(line: 8, column: 14, scope: !17)
!35 = !DILocation(line: 9, column: 7, scope: !17)
!36 = !DILocation(line: 9, column: 3, scope: !17)
!37 = !DILocation(line: 10, column: 16, scope: !17)
!38 = !DILocation(line: 10, column: 3, scope: !17)
!39 = !DILocation(line: 11, column: 3, scope: !17)
