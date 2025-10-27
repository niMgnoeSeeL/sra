; ModuleID = 'flow_struct.c'
source_filename = "flow_struct.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Student = type { i32, i32, [32 x i8] }

@.str = private unnamed_addr constant [17 x i8] c"Student age: %d\0A\00", align 1, !dbg !0

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !17 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.Student, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !22, !DIExpression(), !31)
  %3 = getelementptr inbounds nuw %struct.Student, ptr %2, i32 0, i32 1, !dbg !32
  %4 = call i64 @read(i32 noundef 0, ptr noundef %3, i64 noundef 4), !dbg !33
  %5 = getelementptr inbounds nuw %struct.Student, ptr %2, i32 0, i32 1, !dbg !34
  %6 = load i32, ptr %5, align 4, !dbg !34
  %7 = mul nsw i32 %6, 2, !dbg !35
  %8 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %7), !dbg !36
  ret i32 0, !dbg !37
}

declare i64 @read(i32 noundef, ptr noundef, i64 noundef) #1

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 16, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "flow_struct.c", directory: "/workspaces/fuzzer/sense/demo", checksumkind: CSK_MD5, checksum: "7454d59aaaa2113ef7888ccd7d7837ff")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 17)
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
!17 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 10, type: !18, scopeLine: 10, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !21)
!18 = !DISubroutineType(types: !19)
!19 = !{!20}
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !{}
!22 = !DILocalVariable(name: "s", scope: !17, file: !2, line: 11, type: !23)
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Student", file: !2, line: 4, size: 320, elements: !24)
!24 = !{!25, !26, !27}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !23, file: !2, line: 5, baseType: !20, size: 32)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "age", scope: !23, file: !2, line: 6, baseType: !20, size: 32, offset: 32)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "name", scope: !23, file: !2, line: 7, baseType: !28, size: 256, offset: 64)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 256, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: 32)
!31 = !DILocation(line: 11, column: 18, scope: !17)
!32 = !DILocation(line: 14, column: 25, scope: !17)
!33 = !DILocation(line: 14, column: 3, scope: !17)
!34 = !DILocation(line: 16, column: 33, scope: !17)
!35 = !DILocation(line: 16, column: 37, scope: !17)
!36 = !DILocation(line: 16, column: 3, scope: !17)
!37 = !DILocation(line: 18, column: 3, scope: !17)
