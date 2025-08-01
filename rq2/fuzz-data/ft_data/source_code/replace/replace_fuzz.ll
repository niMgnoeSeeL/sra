; ModuleID = 'replace_fuzz.c'
source_filename = "replace_fuzz.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

@__stdinp = external global ptr, align 8
@__stdoutp = external global ptr, align 8
@.str = private unnamed_addr constant [25 x i8] c"in omatch: can't happen\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [26 x i8] c"in patsize: can't happen\0A\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [3 x i8] c"rb\00", align 1, !dbg !12
@.str.3 = private unnamed_addr constant [16 x i8] c"cant open file\0A\00", align 1, !dbg !17
@.str.4 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1, !dbg !22
@.str.5 = private unnamed_addr constant [25 x i8] c"usage: change from [to]\0A\00", align 1, !dbg !27
@.str.6 = private unnamed_addr constant [32 x i8] c"change: illegal \22from\22 pattern\0A\00", align 1, !dbg !29
@.str.7 = private unnamed_addr constant [29 x i8] c"change: illegal \22to\22 string\0A\00", align 1, !dbg !34
@.str.8 = private unnamed_addr constant [28 x i8] c"Missing case limb: line %d\0A\00", align 1, !dbg !39

; Function Attrs: noinline nounwind optnone ssp uwtable
define signext i8 @getlines(ptr noundef %0, i32 noundef %1) #0 !dbg !56 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !62, metadata !DIExpression()), !dbg !63
  store i32 %1, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !64, metadata !DIExpression()), !dbg !65
  call void @llvm.dbg.declare(metadata ptr %5, metadata !66, metadata !DIExpression()), !dbg !67
  %6 = load ptr, ptr %3, align 8, !dbg !68
  %7 = load i32, ptr %4, align 4, !dbg !69
  %8 = load ptr, ptr @__stdinp, align 8, !dbg !70
  %9 = call ptr @fgets(ptr noundef %6, i32 noundef %7, ptr noundef %8), !dbg !71
  store ptr %9, ptr %5, align 8, !dbg !72
  %10 = load ptr, ptr %5, align 8, !dbg !73
  %11 = icmp ne ptr %10, null, !dbg !74
  %12 = zext i1 %11 to i32, !dbg !74
  %13 = trunc i32 %12 to i8, !dbg !75
  ret i8 %13, !dbg !76
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare ptr @fgets(ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @addstr(i32 noundef %0, ptr noundef %1, ptr noundef %2, i32 noundef %3) #0 !dbg !77 {
  %5 = alloca i8, align 1
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  %9 = alloca i8, align 1
  %10 = trunc i32 %0 to i8
  store i8 %10, ptr %5, align 1
  call void @llvm.dbg.declare(metadata ptr %5, metadata !81, metadata !DIExpression()), !dbg !82
  store ptr %1, ptr %6, align 8
  call void @llvm.dbg.declare(metadata ptr %6, metadata !83, metadata !DIExpression()), !dbg !84
  store ptr %2, ptr %7, align 8
  call void @llvm.dbg.declare(metadata ptr %7, metadata !85, metadata !DIExpression()), !dbg !86
  store i32 %3, ptr %8, align 4
  call void @llvm.dbg.declare(metadata ptr %8, metadata !87, metadata !DIExpression()), !dbg !88
  call void @llvm.dbg.declare(metadata ptr %9, metadata !89, metadata !DIExpression()), !dbg !90
  %11 = load ptr, ptr %7, align 8, !dbg !91
  %12 = load i32, ptr %11, align 4, !dbg !93
  %13 = load i32, ptr %8, align 4, !dbg !94
  %14 = icmp sge i32 %12, %13, !dbg !95
  br i1 %14, label %15, label %16, !dbg !96

15:                                               ; preds = %4
  store i8 0, ptr %9, align 1, !dbg !97
  br label %27, !dbg !98

16:                                               ; preds = %4
  %17 = load i8, ptr %5, align 1, !dbg !99
  %18 = load ptr, ptr %6, align 8, !dbg !101
  %19 = load ptr, ptr %7, align 8, !dbg !102
  %20 = load i32, ptr %19, align 4, !dbg !103
  %21 = sext i32 %20 to i64, !dbg !101
  %22 = getelementptr inbounds i8, ptr %18, i64 %21, !dbg !101
  store i8 %17, ptr %22, align 1, !dbg !104
  %23 = load ptr, ptr %7, align 8, !dbg !105
  %24 = load i32, ptr %23, align 4, !dbg !106
  %25 = add nsw i32 %24, 1, !dbg !107
  %26 = load ptr, ptr %7, align 8, !dbg !108
  store i32 %25, ptr %26, align 4, !dbg !109
  store i8 1, ptr %9, align 1, !dbg !110
  br label %27

27:                                               ; preds = %16, %15
  %28 = load i8, ptr %9, align 1, !dbg !111
  %29 = sext i8 %28 to i32, !dbg !111
  ret i32 %29, !dbg !112
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define signext i8 @esc(ptr noundef %0, ptr noundef %1) #0 !dbg !113 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i8, align 1
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !116, metadata !DIExpression()), !dbg !117
  store ptr %1, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !118, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.declare(metadata ptr %5, metadata !120, metadata !DIExpression()), !dbg !121
  %6 = load ptr, ptr %3, align 8, !dbg !122
  %7 = load ptr, ptr %4, align 8, !dbg !124
  %8 = load i32, ptr %7, align 4, !dbg !125
  %9 = sext i32 %8 to i64, !dbg !122
  %10 = getelementptr inbounds i8, ptr %6, i64 %9, !dbg !122
  %11 = load i8, ptr %10, align 1, !dbg !122
  %12 = sext i8 %11 to i32, !dbg !122
  %13 = icmp ne i32 %12, 64, !dbg !126
  br i1 %13, label %14, label %21, !dbg !127

14:                                               ; preds = %2
  %15 = load ptr, ptr %3, align 8, !dbg !128
  %16 = load ptr, ptr %4, align 8, !dbg !129
  %17 = load i32, ptr %16, align 4, !dbg !130
  %18 = sext i32 %17 to i64, !dbg !128
  %19 = getelementptr inbounds i8, ptr %15, i64 %18, !dbg !128
  %20 = load i8, ptr %19, align 1, !dbg !128
  store i8 %20, ptr %5, align 1, !dbg !131
  br label %66, !dbg !132

21:                                               ; preds = %2
  %22 = load ptr, ptr %3, align 8, !dbg !133
  %23 = load ptr, ptr %4, align 8, !dbg !135
  %24 = load i32, ptr %23, align 4, !dbg !136
  %25 = add nsw i32 %24, 1, !dbg !137
  %26 = sext i32 %25 to i64, !dbg !133
  %27 = getelementptr inbounds i8, ptr %22, i64 %26, !dbg !133
  %28 = load i8, ptr %27, align 1, !dbg !133
  %29 = sext i8 %28 to i32, !dbg !133
  %30 = icmp eq i32 %29, 0, !dbg !138
  br i1 %30, label %31, label %32, !dbg !139

31:                                               ; preds = %21
  store i8 64, ptr %5, align 1, !dbg !140
  br label %65, !dbg !141

32:                                               ; preds = %21
  %33 = load ptr, ptr %4, align 8, !dbg !142
  %34 = load i32, ptr %33, align 4, !dbg !144
  %35 = add nsw i32 %34, 1, !dbg !145
  %36 = load ptr, ptr %4, align 8, !dbg !146
  store i32 %35, ptr %36, align 4, !dbg !147
  %37 = load ptr, ptr %3, align 8, !dbg !148
  %38 = load ptr, ptr %4, align 8, !dbg !150
  %39 = load i32, ptr %38, align 4, !dbg !151
  %40 = sext i32 %39 to i64, !dbg !148
  %41 = getelementptr inbounds i8, ptr %37, i64 %40, !dbg !148
  %42 = load i8, ptr %41, align 1, !dbg !148
  %43 = sext i8 %42 to i32, !dbg !148
  %44 = icmp eq i32 %43, 110, !dbg !152
  br i1 %44, label %45, label %46, !dbg !153

45:                                               ; preds = %32
  store i8 10, ptr %5, align 1, !dbg !154
  br label %64, !dbg !155

46:                                               ; preds = %32
  %47 = load ptr, ptr %3, align 8, !dbg !156
  %48 = load ptr, ptr %4, align 8, !dbg !158
  %49 = load i32, ptr %48, align 4, !dbg !159
  %50 = sext i32 %49 to i64, !dbg !156
  %51 = getelementptr inbounds i8, ptr %47, i64 %50, !dbg !156
  %52 = load i8, ptr %51, align 1, !dbg !156
  %53 = sext i8 %52 to i32, !dbg !156
  %54 = icmp eq i32 %53, 116, !dbg !160
  br i1 %54, label %55, label %56, !dbg !161

55:                                               ; preds = %46
  store i8 9, ptr %5, align 1, !dbg !162
  br label %63, !dbg !163

56:                                               ; preds = %46
  %57 = load ptr, ptr %3, align 8, !dbg !164
  %58 = load ptr, ptr %4, align 8, !dbg !165
  %59 = load i32, ptr %58, align 4, !dbg !166
  %60 = sext i32 %59 to i64, !dbg !164
  %61 = getelementptr inbounds i8, ptr %57, i64 %60, !dbg !164
  %62 = load i8, ptr %61, align 1, !dbg !164
  store i8 %62, ptr %5, align 1, !dbg !167
  br label %63

63:                                               ; preds = %56, %55
  br label %64

64:                                               ; preds = %63, %45
  br label %65

65:                                               ; preds = %64, %31
  br label %66

66:                                               ; preds = %65, %14
  %67 = load i8, ptr %5, align 1, !dbg !168
  ret i8 %67, !dbg !169
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @dodash(i32 noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3, ptr noundef %4, i32 noundef %5) #0 !dbg !170 {
  %7 = alloca i8, align 1
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca ptr, align 8
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i8, align 1
  %15 = alloca i8, align 1
  %16 = trunc i32 %0 to i8
  store i8 %16, ptr %7, align 1
  call void @llvm.dbg.declare(metadata ptr %7, metadata !173, metadata !DIExpression()), !dbg !174
  store ptr %1, ptr %8, align 8
  call void @llvm.dbg.declare(metadata ptr %8, metadata !175, metadata !DIExpression()), !dbg !176
  store ptr %2, ptr %9, align 8
  call void @llvm.dbg.declare(metadata ptr %9, metadata !177, metadata !DIExpression()), !dbg !178
  store ptr %3, ptr %10, align 8
  call void @llvm.dbg.declare(metadata ptr %10, metadata !179, metadata !DIExpression()), !dbg !180
  store ptr %4, ptr %11, align 8
  call void @llvm.dbg.declare(metadata ptr %11, metadata !181, metadata !DIExpression()), !dbg !182
  store i32 %5, ptr %12, align 4
  call void @llvm.dbg.declare(metadata ptr %12, metadata !183, metadata !DIExpression()), !dbg !184
  call void @llvm.dbg.declare(metadata ptr %13, metadata !185, metadata !DIExpression()), !dbg !186
  call void @llvm.dbg.declare(metadata ptr %14, metadata !187, metadata !DIExpression()), !dbg !188
  call void @llvm.dbg.declare(metadata ptr %15, metadata !189, metadata !DIExpression()), !dbg !190
  br label %17, !dbg !191

17:                                               ; preds = %187, %6
  %18 = load ptr, ptr %8, align 8, !dbg !192
  %19 = load ptr, ptr %9, align 8, !dbg !193
  %20 = load i32, ptr %19, align 4, !dbg !194
  %21 = sext i32 %20 to i64, !dbg !192
  %22 = getelementptr inbounds i8, ptr %18, i64 %21, !dbg !192
  %23 = load i8, ptr %22, align 1, !dbg !192
  %24 = sext i8 %23 to i32, !dbg !192
  %25 = load i8, ptr %7, align 1, !dbg !195
  %26 = sext i8 %25 to i32, !dbg !195
  %27 = icmp ne i32 %24, %26, !dbg !196
  br i1 %27, label %28, label %37, !dbg !197

28:                                               ; preds = %17
  %29 = load ptr, ptr %8, align 8, !dbg !198
  %30 = load ptr, ptr %9, align 8, !dbg !199
  %31 = load i32, ptr %30, align 4, !dbg !200
  %32 = sext i32 %31 to i64, !dbg !198
  %33 = getelementptr inbounds i8, ptr %29, i64 %32, !dbg !198
  %34 = load i8, ptr %33, align 1, !dbg !198
  %35 = sext i8 %34 to i32, !dbg !198
  %36 = icmp ne i32 %35, 0, !dbg !201
  br label %37

37:                                               ; preds = %28, %17
  %38 = phi i1 [ false, %17 ], [ %36, %28 ], !dbg !202
  br i1 %38, label %39, label %192, !dbg !191

39:                                               ; preds = %37
  %40 = load ptr, ptr %8, align 8, !dbg !203
  %41 = load ptr, ptr %9, align 8, !dbg !206
  %42 = load i32, ptr %41, align 4, !dbg !207
  %43 = sub nsw i32 %42, 1, !dbg !208
  %44 = sext i32 %43 to i64, !dbg !203
  %45 = getelementptr inbounds i8, ptr %40, i64 %44, !dbg !203
  %46 = load i8, ptr %45, align 1, !dbg !203
  %47 = sext i8 %46 to i32, !dbg !203
  %48 = icmp eq i32 %47, 64, !dbg !209
  br i1 %48, label %49, label %60, !dbg !210

49:                                               ; preds = %39
  %50 = load ptr, ptr %8, align 8, !dbg !211
  %51 = load ptr, ptr %9, align 8, !dbg !213
  %52 = call signext i8 @esc(ptr noundef %50, ptr noundef %51), !dbg !214
  store i8 %52, ptr %15, align 1, !dbg !215
  %53 = load i8, ptr %15, align 1, !dbg !216
  %54 = sext i8 %53 to i32, !dbg !216
  %55 = load ptr, ptr %10, align 8, !dbg !217
  %56 = load ptr, ptr %11, align 8, !dbg !218
  %57 = load i32, ptr %12, align 4, !dbg !219
  %58 = call i32 @addstr(i32 noundef %54, ptr noundef %55, ptr noundef %56, i32 noundef %57), !dbg !220
  %59 = trunc i32 %58 to i8, !dbg !220
  store i8 %59, ptr %14, align 1, !dbg !221
  br label %187, !dbg !222

60:                                               ; preds = %39
  %61 = load ptr, ptr %8, align 8, !dbg !223
  %62 = load ptr, ptr %9, align 8, !dbg !225
  %63 = load i32, ptr %62, align 4, !dbg !226
  %64 = sext i32 %63 to i64, !dbg !223
  %65 = getelementptr inbounds i8, ptr %61, i64 %64, !dbg !223
  %66 = load i8, ptr %65, align 1, !dbg !223
  %67 = sext i8 %66 to i32, !dbg !223
  %68 = icmp ne i32 %67, 45, !dbg !227
  br i1 %68, label %69, label %82, !dbg !228

69:                                               ; preds = %60
  %70 = load ptr, ptr %8, align 8, !dbg !229
  %71 = load ptr, ptr %9, align 8, !dbg !230
  %72 = load i32, ptr %71, align 4, !dbg !231
  %73 = sext i32 %72 to i64, !dbg !229
  %74 = getelementptr inbounds i8, ptr %70, i64 %73, !dbg !229
  %75 = load i8, ptr %74, align 1, !dbg !229
  %76 = sext i8 %75 to i32, !dbg !229
  %77 = load ptr, ptr %10, align 8, !dbg !232
  %78 = load ptr, ptr %11, align 8, !dbg !233
  %79 = load i32, ptr %12, align 4, !dbg !234
  %80 = call i32 @addstr(i32 noundef %76, ptr noundef %77, ptr noundef %78, i32 noundef %79), !dbg !235
  %81 = trunc i32 %80 to i8, !dbg !235
  store i8 %81, ptr %14, align 1, !dbg !236
  br label %186, !dbg !237

82:                                               ; preds = %60
  %83 = load ptr, ptr %11, align 8, !dbg !238
  %84 = load i32, ptr %83, align 4, !dbg !240
  %85 = icmp sle i32 %84, 1, !dbg !241
  br i1 %85, label %96, label %86, !dbg !242

86:                                               ; preds = %82
  %87 = load ptr, ptr %8, align 8, !dbg !243
  %88 = load ptr, ptr %9, align 8, !dbg !244
  %89 = load i32, ptr %88, align 4, !dbg !245
  %90 = add nsw i32 %89, 1, !dbg !246
  %91 = sext i32 %90 to i64, !dbg !243
  %92 = getelementptr inbounds i8, ptr %87, i64 %91, !dbg !243
  %93 = load i8, ptr %92, align 1, !dbg !243
  %94 = sext i8 %93 to i32, !dbg !243
  %95 = icmp eq i32 %94, 0, !dbg !247
  br i1 %95, label %96, label %102, !dbg !248

96:                                               ; preds = %86, %82
  %97 = load ptr, ptr %10, align 8, !dbg !249
  %98 = load ptr, ptr %11, align 8, !dbg !250
  %99 = load i32, ptr %12, align 4, !dbg !251
  %100 = call i32 @addstr(i32 noundef 45, ptr noundef %97, ptr noundef %98, i32 noundef %99), !dbg !252
  %101 = trunc i32 %100 to i8, !dbg !252
  store i8 %101, ptr %14, align 1, !dbg !253
  br label %185, !dbg !254

102:                                              ; preds = %86
  %103 = load ptr, ptr %8, align 8, !dbg !255
  %104 = load ptr, ptr %9, align 8, !dbg !257
  %105 = load i32, ptr %104, align 4, !dbg !258
  %106 = sub nsw i32 %105, 1, !dbg !259
  %107 = sext i32 %106 to i64, !dbg !255
  %108 = getelementptr inbounds i8, ptr %103, i64 %107, !dbg !255
  %109 = load i8, ptr %108, align 1, !dbg !255
  %110 = sext i8 %109 to i32, !dbg !255
  %111 = call i32 @isalnum(i32 noundef %110) #7, !dbg !260
  %112 = icmp ne i32 %111, 0, !dbg !260
  br i1 %112, label %113, label %178, !dbg !261

113:                                              ; preds = %102
  %114 = load ptr, ptr %8, align 8, !dbg !262
  %115 = load ptr, ptr %9, align 8, !dbg !263
  %116 = load i32, ptr %115, align 4, !dbg !264
  %117 = add nsw i32 %116, 1, !dbg !265
  %118 = sext i32 %117 to i64, !dbg !262
  %119 = getelementptr inbounds i8, ptr %114, i64 %118, !dbg !262
  %120 = load i8, ptr %119, align 1, !dbg !262
  %121 = sext i8 %120 to i32, !dbg !262
  %122 = call i32 @isalnum(i32 noundef %121) #7, !dbg !266
  %123 = icmp ne i32 %122, 0, !dbg !266
  br i1 %123, label %124, label %178, !dbg !267

124:                                              ; preds = %113
  %125 = load ptr, ptr %8, align 8, !dbg !268
  %126 = load ptr, ptr %9, align 8, !dbg !269
  %127 = load i32, ptr %126, align 4, !dbg !270
  %128 = sub nsw i32 %127, 1, !dbg !271
  %129 = sext i32 %128 to i64, !dbg !268
  %130 = getelementptr inbounds i8, ptr %125, i64 %129, !dbg !268
  %131 = load i8, ptr %130, align 1, !dbg !268
  %132 = sext i8 %131 to i32, !dbg !268
  %133 = load ptr, ptr %8, align 8, !dbg !272
  %134 = load ptr, ptr %9, align 8, !dbg !273
  %135 = load i32, ptr %134, align 4, !dbg !274
  %136 = add nsw i32 %135, 1, !dbg !275
  %137 = sext i32 %136 to i64, !dbg !272
  %138 = getelementptr inbounds i8, ptr %133, i64 %137, !dbg !272
  %139 = load i8, ptr %138, align 1, !dbg !272
  %140 = sext i8 %139 to i32, !dbg !272
  %141 = icmp sle i32 %132, %140, !dbg !276
  br i1 %141, label %142, label %178, !dbg !277

142:                                              ; preds = %124
  %143 = load ptr, ptr %8, align 8, !dbg !278
  %144 = load ptr, ptr %9, align 8, !dbg !281
  %145 = load i32, ptr %144, align 4, !dbg !282
  %146 = sub nsw i32 %145, 1, !dbg !283
  %147 = sext i32 %146 to i64, !dbg !278
  %148 = getelementptr inbounds i8, ptr %143, i64 %147, !dbg !278
  %149 = load i8, ptr %148, align 1, !dbg !278
  %150 = sext i8 %149 to i32, !dbg !278
  %151 = add nsw i32 %150, 1, !dbg !284
  store i32 %151, ptr %13, align 4, !dbg !285
  br label %152, !dbg !286

152:                                              ; preds = %170, %142
  %153 = load i32, ptr %13, align 4, !dbg !287
  %154 = load ptr, ptr %8, align 8, !dbg !289
  %155 = load ptr, ptr %9, align 8, !dbg !290
  %156 = load i32, ptr %155, align 4, !dbg !291
  %157 = add nsw i32 %156, 1, !dbg !292
  %158 = sext i32 %157 to i64, !dbg !289
  %159 = getelementptr inbounds i8, ptr %154, i64 %158, !dbg !289
  %160 = load i8, ptr %159, align 1, !dbg !289
  %161 = sext i8 %160 to i32, !dbg !289
  %162 = icmp sle i32 %153, %161, !dbg !293
  br i1 %162, label %163, label %173, !dbg !294

163:                                              ; preds = %152
  %164 = load i32, ptr %13, align 4, !dbg !295
  %165 = load ptr, ptr %10, align 8, !dbg !297
  %166 = load ptr, ptr %11, align 8, !dbg !298
  %167 = load i32, ptr %12, align 4, !dbg !299
  %168 = call i32 @addstr(i32 noundef %164, ptr noundef %165, ptr noundef %166, i32 noundef %167), !dbg !300
  %169 = trunc i32 %168 to i8, !dbg !300
  store i8 %169, ptr %14, align 1, !dbg !301
  br label %170, !dbg !302

170:                                              ; preds = %163
  %171 = load i32, ptr %13, align 4, !dbg !303
  %172 = add nsw i32 %171, 1, !dbg !303
  store i32 %172, ptr %13, align 4, !dbg !303
  br label %152, !dbg !304, !llvm.loop !305

173:                                              ; preds = %152
  %174 = load ptr, ptr %9, align 8, !dbg !308
  %175 = load i32, ptr %174, align 4, !dbg !309
  %176 = add nsw i32 %175, 1, !dbg !310
  %177 = load ptr, ptr %9, align 8, !dbg !311
  store i32 %176, ptr %177, align 4, !dbg !312
  br label %184, !dbg !313

178:                                              ; preds = %124, %113, %102
  %179 = load ptr, ptr %10, align 8, !dbg !314
  %180 = load ptr, ptr %11, align 8, !dbg !315
  %181 = load i32, ptr %12, align 4, !dbg !316
  %182 = call i32 @addstr(i32 noundef 45, ptr noundef %179, ptr noundef %180, i32 noundef %181), !dbg !317
  %183 = trunc i32 %182 to i8, !dbg !317
  store i8 %183, ptr %14, align 1, !dbg !318
  br label %184

184:                                              ; preds = %178, %173
  br label %185

185:                                              ; preds = %184, %96
  br label %186

186:                                              ; preds = %185, %69
  br label %187

187:                                              ; preds = %186, %49
  %188 = load ptr, ptr %9, align 8, !dbg !319
  %189 = load i32, ptr %188, align 4, !dbg !320
  %190 = add nsw i32 %189, 1, !dbg !321
  %191 = load ptr, ptr %9, align 8, !dbg !322
  store i32 %190, ptr %191, align 4, !dbg !323
  br label %17, !dbg !191, !llvm.loop !324

192:                                              ; preds = %37
  ret void, !dbg !326
}

; Function Attrs: nounwind readonly willreturn
declare i32 @isalnum(i32 noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable
define signext i8 @getccl(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 !dbg !327 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  %10 = alloca i8, align 1
  store ptr %0, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !330, metadata !DIExpression()), !dbg !331
  store ptr %1, ptr %6, align 8
  call void @llvm.dbg.declare(metadata ptr %6, metadata !332, metadata !DIExpression()), !dbg !333
  store ptr %2, ptr %7, align 8
  call void @llvm.dbg.declare(metadata ptr %7, metadata !334, metadata !DIExpression()), !dbg !335
  store ptr %3, ptr %8, align 8
  call void @llvm.dbg.declare(metadata ptr %8, metadata !336, metadata !DIExpression()), !dbg !337
  call void @llvm.dbg.declare(metadata ptr %9, metadata !338, metadata !DIExpression()), !dbg !339
  call void @llvm.dbg.declare(metadata ptr %10, metadata !340, metadata !DIExpression()), !dbg !341
  %11 = load ptr, ptr %6, align 8, !dbg !342
  %12 = load i32, ptr %11, align 4, !dbg !343
  %13 = add nsw i32 %12, 1, !dbg !344
  %14 = load ptr, ptr %6, align 8, !dbg !345
  store i32 %13, ptr %14, align 4, !dbg !346
  %15 = load ptr, ptr %5, align 8, !dbg !347
  %16 = load ptr, ptr %6, align 8, !dbg !349
  %17 = load i32, ptr %16, align 4, !dbg !350
  %18 = sext i32 %17 to i64, !dbg !347
  %19 = getelementptr inbounds i8, ptr %15, i64 %18, !dbg !347
  %20 = load i8, ptr %19, align 1, !dbg !347
  %21 = sext i8 %20 to i32, !dbg !347
  %22 = icmp eq i32 %21, 94, !dbg !351
  br i1 %22, label %23, label %32, !dbg !352

23:                                               ; preds = %4
  %24 = load ptr, ptr %7, align 8, !dbg !353
  %25 = load ptr, ptr %8, align 8, !dbg !355
  %26 = call i32 @addstr(i32 noundef 33, ptr noundef %24, ptr noundef %25, i32 noundef 100), !dbg !356
  %27 = trunc i32 %26 to i8, !dbg !356
  store i8 %27, ptr %10, align 1, !dbg !357
  %28 = load ptr, ptr %6, align 8, !dbg !358
  %29 = load i32, ptr %28, align 4, !dbg !359
  %30 = add nsw i32 %29, 1, !dbg !360
  %31 = load ptr, ptr %6, align 8, !dbg !361
  store i32 %30, ptr %31, align 4, !dbg !362
  br label %37, !dbg !363

32:                                               ; preds = %4
  %33 = load ptr, ptr %7, align 8, !dbg !364
  %34 = load ptr, ptr %8, align 8, !dbg !365
  %35 = call i32 @addstr(i32 noundef 91, ptr noundef %33, ptr noundef %34, i32 noundef 100), !dbg !366
  %36 = trunc i32 %35 to i8, !dbg !366
  store i8 %36, ptr %10, align 1, !dbg !367
  br label %37

37:                                               ; preds = %32, %23
  %38 = load ptr, ptr %8, align 8, !dbg !368
  %39 = load i32, ptr %38, align 4, !dbg !369
  store i32 %39, ptr %9, align 4, !dbg !370
  %40 = load ptr, ptr %7, align 8, !dbg !371
  %41 = load ptr, ptr %8, align 8, !dbg !372
  %42 = call i32 @addstr(i32 noundef 0, ptr noundef %40, ptr noundef %41, i32 noundef 100), !dbg !373
  %43 = trunc i32 %42 to i8, !dbg !373
  store i8 %43, ptr %10, align 1, !dbg !374
  %44 = load ptr, ptr %5, align 8, !dbg !375
  %45 = load ptr, ptr %6, align 8, !dbg !376
  %46 = load ptr, ptr %7, align 8, !dbg !377
  %47 = load ptr, ptr %8, align 8, !dbg !378
  call void @dodash(i32 noundef 93, ptr noundef %44, ptr noundef %45, ptr noundef %46, ptr noundef %47, i32 noundef 100), !dbg !379
  %48 = load ptr, ptr %8, align 8, !dbg !380
  %49 = load i32, ptr %48, align 4, !dbg !381
  %50 = load i32, ptr %9, align 4, !dbg !382
  %51 = sub nsw i32 %49, %50, !dbg !383
  %52 = sub nsw i32 %51, 1, !dbg !384
  %53 = trunc i32 %52 to i8, !dbg !381
  %54 = load ptr, ptr %7, align 8, !dbg !385
  %55 = load i32, ptr %9, align 4, !dbg !386
  %56 = sext i32 %55 to i64, !dbg !385
  %57 = getelementptr inbounds i8, ptr %54, i64 %56, !dbg !385
  store i8 %53, ptr %57, align 1, !dbg !387
  %58 = load ptr, ptr %5, align 8, !dbg !388
  %59 = load ptr, ptr %6, align 8, !dbg !389
  %60 = load i32, ptr %59, align 4, !dbg !390
  %61 = sext i32 %60 to i64, !dbg !388
  %62 = getelementptr inbounds i8, ptr %58, i64 %61, !dbg !388
  %63 = load i8, ptr %62, align 1, !dbg !388
  %64 = sext i8 %63 to i32, !dbg !388
  %65 = icmp eq i32 %64, 93, !dbg !391
  %66 = zext i1 %65 to i32, !dbg !391
  %67 = trunc i32 %66 to i8, !dbg !392
  ret i8 %67, !dbg !393
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @stclose(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 !dbg !394 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i8, align 1
  store ptr %0, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !397, metadata !DIExpression()), !dbg !398
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !399, metadata !DIExpression()), !dbg !400
  store i32 %2, ptr %6, align 4
  call void @llvm.dbg.declare(metadata ptr %6, metadata !401, metadata !DIExpression()), !dbg !402
  call void @llvm.dbg.declare(metadata ptr %7, metadata !403, metadata !DIExpression()), !dbg !404
  call void @llvm.dbg.declare(metadata ptr %8, metadata !405, metadata !DIExpression()), !dbg !406
  call void @llvm.dbg.declare(metadata ptr %9, metadata !407, metadata !DIExpression()), !dbg !408
  %10 = load ptr, ptr %5, align 8, !dbg !409
  %11 = load i32, ptr %10, align 4, !dbg !411
  %12 = sub nsw i32 %11, 1, !dbg !412
  store i32 %12, ptr %8, align 4, !dbg !413
  br label %13, !dbg !414

13:                                               ; preds = %29, %3
  %14 = load i32, ptr %8, align 4, !dbg !415
  %15 = load i32, ptr %6, align 4, !dbg !417
  %16 = icmp sge i32 %14, %15, !dbg !418
  br i1 %16, label %17, label %32, !dbg !419

17:                                               ; preds = %13
  %18 = load i32, ptr %8, align 4, !dbg !420
  %19 = add nsw i32 %18, 1, !dbg !422
  store i32 %19, ptr %7, align 4, !dbg !423
  %20 = load ptr, ptr %4, align 8, !dbg !424
  %21 = load i32, ptr %8, align 4, !dbg !425
  %22 = sext i32 %21 to i64, !dbg !424
  %23 = getelementptr inbounds i8, ptr %20, i64 %22, !dbg !424
  %24 = load i8, ptr %23, align 1, !dbg !424
  %25 = sext i8 %24 to i32, !dbg !424
  %26 = load ptr, ptr %4, align 8, !dbg !426
  %27 = call i32 @addstr(i32 noundef %25, ptr noundef %26, ptr noundef %7, i32 noundef 100), !dbg !427
  %28 = trunc i32 %27 to i8, !dbg !427
  store i8 %28, ptr %9, align 1, !dbg !428
  br label %29, !dbg !429

29:                                               ; preds = %17
  %30 = load i32, ptr %8, align 4, !dbg !430
  %31 = add nsw i32 %30, -1, !dbg !430
  store i32 %31, ptr %8, align 4, !dbg !430
  br label %13, !dbg !431, !llvm.loop !432

32:                                               ; preds = %13
  %33 = load ptr, ptr %5, align 8, !dbg !434
  %34 = load i32, ptr %33, align 4, !dbg !435
  %35 = add nsw i32 %34, 1, !dbg !436
  %36 = load ptr, ptr %5, align 8, !dbg !437
  store i32 %35, ptr %36, align 4, !dbg !438
  %37 = load ptr, ptr %4, align 8, !dbg !439
  %38 = load i32, ptr %6, align 4, !dbg !440
  %39 = sext i32 %38 to i64, !dbg !439
  %40 = getelementptr inbounds i8, ptr %37, i64 %39, !dbg !439
  store i8 42, ptr %40, align 1, !dbg !441
  ret void, !dbg !442
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define signext i8 @in_set_2(i32 noundef %0) #0 !dbg !443 {
  %2 = alloca i8, align 1
  %3 = trunc i32 %0 to i8
  store i8 %3, ptr %2, align 1
  call void @llvm.dbg.declare(metadata ptr %2, metadata !446, metadata !DIExpression()), !dbg !447
  %4 = load i8, ptr %2, align 1, !dbg !448
  %5 = sext i8 %4 to i32, !dbg !448
  %6 = icmp eq i32 %5, 37, !dbg !449
  br i1 %6, label %15, label %7, !dbg !450

7:                                                ; preds = %1
  %8 = load i8, ptr %2, align 1, !dbg !451
  %9 = sext i8 %8 to i32, !dbg !451
  %10 = icmp eq i32 %9, 36, !dbg !452
  br i1 %10, label %15, label %11, !dbg !453

11:                                               ; preds = %7
  %12 = load i8, ptr %2, align 1, !dbg !454
  %13 = sext i8 %12 to i32, !dbg !454
  %14 = icmp eq i32 %13, 42, !dbg !455
  br label %15, !dbg !453

15:                                               ; preds = %11, %7, %1
  %16 = phi i1 [ true, %7 ], [ true, %1 ], [ %14, %11 ]
  %17 = zext i1 %16 to i32, !dbg !453
  %18 = trunc i32 %17 to i8, !dbg !456
  ret i8 %18, !dbg !457
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define signext i8 @in_pat_set(i32 noundef %0) #0 !dbg !458 {
  %2 = alloca i8, align 1
  %3 = trunc i32 %0 to i8
  store i8 %3, ptr %2, align 1
  call void @llvm.dbg.declare(metadata ptr %2, metadata !459, metadata !DIExpression()), !dbg !460
  %4 = load i8, ptr %2, align 1, !dbg !461
  %5 = sext i8 %4 to i32, !dbg !461
  %6 = icmp eq i32 %5, 99, !dbg !462
  br i1 %6, label %31, label %7, !dbg !463

7:                                                ; preds = %1
  %8 = load i8, ptr %2, align 1, !dbg !464
  %9 = sext i8 %8 to i32, !dbg !464
  %10 = icmp eq i32 %9, 37, !dbg !465
  br i1 %10, label %31, label %11, !dbg !466

11:                                               ; preds = %7
  %12 = load i8, ptr %2, align 1, !dbg !467
  %13 = sext i8 %12 to i32, !dbg !467
  %14 = icmp eq i32 %13, 36, !dbg !468
  br i1 %14, label %31, label %15, !dbg !469

15:                                               ; preds = %11
  %16 = load i8, ptr %2, align 1, !dbg !470
  %17 = sext i8 %16 to i32, !dbg !470
  %18 = icmp eq i32 %17, 63, !dbg !471
  br i1 %18, label %31, label %19, !dbg !472

19:                                               ; preds = %15
  %20 = load i8, ptr %2, align 1, !dbg !473
  %21 = sext i8 %20 to i32, !dbg !473
  %22 = icmp eq i32 %21, 91, !dbg !474
  br i1 %22, label %31, label %23, !dbg !475

23:                                               ; preds = %19
  %24 = load i8, ptr %2, align 1, !dbg !476
  %25 = sext i8 %24 to i32, !dbg !476
  %26 = icmp eq i32 %25, 33, !dbg !477
  br i1 %26, label %31, label %27, !dbg !478

27:                                               ; preds = %23
  %28 = load i8, ptr %2, align 1, !dbg !479
  %29 = sext i8 %28 to i32, !dbg !479
  %30 = icmp eq i32 %29, 42, !dbg !480
  br label %31, !dbg !478

31:                                               ; preds = %27, %23, %19, %15, %11, %7, %1
  %32 = phi i1 [ true, %23 ], [ true, %19 ], [ true, %15 ], [ true, %11 ], [ true, %7 ], [ true, %1 ], [ %30, %27 ]
  %33 = zext i1 %32 to i32, !dbg !478
  %34 = trunc i32 %33 to i8, !dbg !481
  ret i8 %34, !dbg !482
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @makepat(ptr noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3) #0 !dbg !483 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i8, align 1
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i8, align 1
  %15 = alloca i8, align 1
  %16 = alloca i8, align 1
  %17 = alloca i8, align 1
  %18 = trunc i32 %2 to i8
  store ptr %0, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !486, metadata !DIExpression()), !dbg !487
  store i32 %1, ptr %6, align 4
  call void @llvm.dbg.declare(metadata ptr %6, metadata !488, metadata !DIExpression()), !dbg !489
  store i8 %18, ptr %7, align 1
  call void @llvm.dbg.declare(metadata ptr %7, metadata !490, metadata !DIExpression()), !dbg !491
  store ptr %3, ptr %8, align 8
  call void @llvm.dbg.declare(metadata ptr %8, metadata !492, metadata !DIExpression()), !dbg !493
  call void @llvm.dbg.declare(metadata ptr %9, metadata !494, metadata !DIExpression()), !dbg !495
  call void @llvm.dbg.declare(metadata ptr %10, metadata !496, metadata !DIExpression()), !dbg !497
  call void @llvm.dbg.declare(metadata ptr %11, metadata !498, metadata !DIExpression()), !dbg !499
  call void @llvm.dbg.declare(metadata ptr %12, metadata !500, metadata !DIExpression()), !dbg !501
  call void @llvm.dbg.declare(metadata ptr %13, metadata !502, metadata !DIExpression()), !dbg !503
  call void @llvm.dbg.declare(metadata ptr %14, metadata !504, metadata !DIExpression()), !dbg !505
  call void @llvm.dbg.declare(metadata ptr %15, metadata !506, metadata !DIExpression()), !dbg !507
  call void @llvm.dbg.declare(metadata ptr %16, metadata !508, metadata !DIExpression()), !dbg !509
  call void @llvm.dbg.declare(metadata ptr %17, metadata !510, metadata !DIExpression()), !dbg !511
  store i32 0, ptr %11, align 4, !dbg !512
  %19 = load i32, ptr %6, align 4, !dbg !513
  store i32 %19, ptr %10, align 4, !dbg !514
  store i32 0, ptr %12, align 4, !dbg !515
  store i8 0, ptr %14, align 1, !dbg !516
  br label %20, !dbg !517

20:                                               ; preds = %161, %4
  %21 = load i8, ptr %14, align 1, !dbg !518
  %22 = icmp ne i8 %21, 0, !dbg !518
  br i1 %22, label %41, label %23, !dbg !519

23:                                               ; preds = %20
  %24 = load ptr, ptr %5, align 8, !dbg !520
  %25 = load i32, ptr %10, align 4, !dbg !521
  %26 = sext i32 %25 to i64, !dbg !520
  %27 = getelementptr inbounds i8, ptr %24, i64 %26, !dbg !520
  %28 = load i8, ptr %27, align 1, !dbg !520
  %29 = sext i8 %28 to i32, !dbg !520
  %30 = load i8, ptr %7, align 1, !dbg !522
  %31 = sext i8 %30 to i32, !dbg !522
  %32 = icmp ne i32 %29, %31, !dbg !523
  br i1 %32, label %33, label %41, !dbg !524

33:                                               ; preds = %23
  %34 = load ptr, ptr %5, align 8, !dbg !525
  %35 = load i32, ptr %10, align 4, !dbg !526
  %36 = sext i32 %35 to i64, !dbg !525
  %37 = getelementptr inbounds i8, ptr %34, i64 %36, !dbg !525
  %38 = load i8, ptr %37, align 1, !dbg !525
  %39 = sext i8 %38 to i32, !dbg !525
  %40 = icmp ne i32 %39, 0, !dbg !527
  br label %41

41:                                               ; preds = %33, %23, %20
  %42 = phi i1 [ false, %23 ], [ false, %20 ], [ %40, %33 ], !dbg !528
  br i1 %42, label %43, label %162, !dbg !517

43:                                               ; preds = %41
  %44 = load i32, ptr %11, align 4, !dbg !529
  store i32 %44, ptr %13, align 4, !dbg !531
  %45 = load ptr, ptr %5, align 8, !dbg !532
  %46 = load i32, ptr %10, align 4, !dbg !534
  %47 = sext i32 %46 to i64, !dbg !532
  %48 = getelementptr inbounds i8, ptr %45, i64 %47, !dbg !532
  %49 = load i8, ptr %48, align 1, !dbg !532
  %50 = sext i8 %49 to i32, !dbg !532
  %51 = icmp eq i32 %50, 63, !dbg !535
  br i1 %51, label %52, label %56, !dbg !536

52:                                               ; preds = %43
  %53 = load ptr, ptr %8, align 8, !dbg !537
  %54 = call i32 @addstr(i32 noundef 63, ptr noundef %53, ptr noundef %11, i32 noundef 100), !dbg !538
  %55 = trunc i32 %54 to i8, !dbg !538
  store i8 %55, ptr %15, align 1, !dbg !539
  br label %154, !dbg !540

56:                                               ; preds = %43
  %57 = load ptr, ptr %5, align 8, !dbg !541
  %58 = load i32, ptr %10, align 4, !dbg !543
  %59 = sext i32 %58 to i64, !dbg !541
  %60 = getelementptr inbounds i8, ptr %57, i64 %59, !dbg !541
  %61 = load i8, ptr %60, align 1, !dbg !541
  %62 = sext i8 %61 to i32, !dbg !541
  %63 = icmp eq i32 %62, 37, !dbg !544
  br i1 %63, label %64, label %72, !dbg !545

64:                                               ; preds = %56
  %65 = load i32, ptr %10, align 4, !dbg !546
  %66 = load i32, ptr %6, align 4, !dbg !547
  %67 = icmp eq i32 %65, %66, !dbg !548
  br i1 %67, label %68, label %72, !dbg !549

68:                                               ; preds = %64
  %69 = load ptr, ptr %8, align 8, !dbg !550
  %70 = call i32 @addstr(i32 noundef 37, ptr noundef %69, ptr noundef %11, i32 noundef 100), !dbg !551
  %71 = trunc i32 %70 to i8, !dbg !551
  store i8 %71, ptr %15, align 1, !dbg !552
  br label %153, !dbg !553

72:                                               ; preds = %64, %56
  %73 = load ptr, ptr %5, align 8, !dbg !554
  %74 = load i32, ptr %10, align 4, !dbg !556
  %75 = sext i32 %74 to i64, !dbg !554
  %76 = getelementptr inbounds i8, ptr %73, i64 %75, !dbg !554
  %77 = load i8, ptr %76, align 1, !dbg !554
  %78 = sext i8 %77 to i32, !dbg !554
  %79 = icmp eq i32 %78, 36, !dbg !557
  br i1 %79, label %80, label %95, !dbg !558

80:                                               ; preds = %72
  %81 = load ptr, ptr %5, align 8, !dbg !559
  %82 = load i32, ptr %10, align 4, !dbg !560
  %83 = add nsw i32 %82, 1, !dbg !561
  %84 = sext i32 %83 to i64, !dbg !559
  %85 = getelementptr inbounds i8, ptr %81, i64 %84, !dbg !559
  %86 = load i8, ptr %85, align 1, !dbg !559
  %87 = sext i8 %86 to i32, !dbg !559
  %88 = load i8, ptr %7, align 1, !dbg !562
  %89 = sext i8 %88 to i32, !dbg !562
  %90 = icmp eq i32 %87, %89, !dbg !563
  br i1 %90, label %91, label %95, !dbg !564

91:                                               ; preds = %80
  %92 = load ptr, ptr %8, align 8, !dbg !565
  %93 = call i32 @addstr(i32 noundef 36, ptr noundef %92, ptr noundef %11, i32 noundef 100), !dbg !566
  %94 = trunc i32 %93 to i8, !dbg !566
  store i8 %94, ptr %15, align 1, !dbg !567
  br label %152, !dbg !568

95:                                               ; preds = %80, %72
  %96 = load ptr, ptr %5, align 8, !dbg !569
  %97 = load i32, ptr %10, align 4, !dbg !571
  %98 = sext i32 %97 to i64, !dbg !569
  %99 = getelementptr inbounds i8, ptr %96, i64 %98, !dbg !569
  %100 = load i8, ptr %99, align 1, !dbg !569
  %101 = sext i8 %100 to i32, !dbg !569
  %102 = icmp eq i32 %101, 91, !dbg !572
  br i1 %102, label %103, label %112, !dbg !573

103:                                              ; preds = %95
  %104 = load ptr, ptr %5, align 8, !dbg !574
  %105 = load ptr, ptr %8, align 8, !dbg !576
  %106 = call signext i8 @getccl(ptr noundef %104, ptr noundef %10, ptr noundef %105, ptr noundef %11), !dbg !577
  store i8 %106, ptr %16, align 1, !dbg !578
  %107 = load i8, ptr %16, align 1, !dbg !579
  %108 = sext i8 %107 to i32, !dbg !579
  %109 = icmp eq i32 %108, 0, !dbg !580
  %110 = zext i1 %109 to i32, !dbg !580
  %111 = trunc i32 %110 to i8, !dbg !581
  store i8 %111, ptr %14, align 1, !dbg !582
  br label %151, !dbg !583

112:                                              ; preds = %95
  %113 = load ptr, ptr %5, align 8, !dbg !584
  %114 = load i32, ptr %10, align 4, !dbg !586
  %115 = sext i32 %114 to i64, !dbg !584
  %116 = getelementptr inbounds i8, ptr %113, i64 %115, !dbg !584
  %117 = load i8, ptr %116, align 1, !dbg !584
  %118 = sext i8 %117 to i32, !dbg !584
  %119 = icmp eq i32 %118, 42, !dbg !587
  br i1 %119, label %120, label %139, !dbg !588

120:                                              ; preds = %112
  %121 = load i32, ptr %10, align 4, !dbg !589
  %122 = load i32, ptr %6, align 4, !dbg !590
  %123 = icmp sgt i32 %121, %122, !dbg !591
  br i1 %123, label %124, label %139, !dbg !592

124:                                              ; preds = %120
  %125 = load i32, ptr %12, align 4, !dbg !593
  store i32 %125, ptr %13, align 4, !dbg !595
  %126 = load ptr, ptr %8, align 8, !dbg !596
  %127 = load i32, ptr %13, align 4, !dbg !598
  %128 = sext i32 %127 to i64, !dbg !596
  %129 = getelementptr inbounds i8, ptr %126, i64 %128, !dbg !596
  %130 = load i8, ptr %129, align 1, !dbg !596
  %131 = sext i8 %130 to i32, !dbg !596
  %132 = call signext i8 @in_set_2(i32 noundef %131), !dbg !599
  %133 = icmp ne i8 %132, 0, !dbg !599
  br i1 %133, label %134, label %135, !dbg !600

134:                                              ; preds = %124
  store i8 1, ptr %14, align 1, !dbg !601
  br label %138, !dbg !602

135:                                              ; preds = %124
  %136 = load ptr, ptr %8, align 8, !dbg !603
  %137 = load i32, ptr %12, align 4, !dbg !604
  call void @stclose(ptr noundef %136, ptr noundef %11, i32 noundef %137), !dbg !605
  br label %138

138:                                              ; preds = %135, %134
  br label %150, !dbg !606

139:                                              ; preds = %120, %112
  %140 = load ptr, ptr %8, align 8, !dbg !607
  %141 = call i32 @addstr(i32 noundef 99, ptr noundef %140, ptr noundef %11, i32 noundef 100), !dbg !609
  %142 = trunc i32 %141 to i8, !dbg !609
  store i8 %142, ptr %15, align 1, !dbg !610
  %143 = load ptr, ptr %5, align 8, !dbg !611
  %144 = call signext i8 @esc(ptr noundef %143, ptr noundef %10), !dbg !612
  store i8 %144, ptr %17, align 1, !dbg !613
  %145 = load i8, ptr %17, align 1, !dbg !614
  %146 = sext i8 %145 to i32, !dbg !614
  %147 = load ptr, ptr %8, align 8, !dbg !615
  %148 = call i32 @addstr(i32 noundef %146, ptr noundef %147, ptr noundef %11, i32 noundef 100), !dbg !616
  %149 = trunc i32 %148 to i8, !dbg !616
  store i8 %149, ptr %15, align 1, !dbg !617
  br label %150

150:                                              ; preds = %139, %138
  br label %151

151:                                              ; preds = %150, %103
  br label %152

152:                                              ; preds = %151, %91
  br label %153

153:                                              ; preds = %152, %68
  br label %154

154:                                              ; preds = %153, %52
  %155 = load i32, ptr %13, align 4, !dbg !618
  store i32 %155, ptr %12, align 4, !dbg !619
  %156 = load i8, ptr %14, align 1, !dbg !620
  %157 = icmp ne i8 %156, 0, !dbg !620
  br i1 %157, label %161, label %158, !dbg !622

158:                                              ; preds = %154
  %159 = load i32, ptr %10, align 4, !dbg !623
  %160 = add nsw i32 %159, 1, !dbg !624
  store i32 %160, ptr %10, align 4, !dbg !625
  br label %161, !dbg !626

161:                                              ; preds = %158, %154
  br label %20, !dbg !517, !llvm.loop !627

162:                                              ; preds = %41
  %163 = load ptr, ptr %8, align 8, !dbg !629
  %164 = call i32 @addstr(i32 noundef 0, ptr noundef %163, ptr noundef %11, i32 noundef 100), !dbg !630
  %165 = trunc i32 %164 to i8, !dbg !630
  store i8 %165, ptr %15, align 1, !dbg !631
  %166 = load i8, ptr %14, align 1, !dbg !632
  %167 = sext i8 %166 to i32, !dbg !634
  %168 = icmp ne i32 %167, 0, !dbg !634
  br i1 %168, label %179, label %169, !dbg !635

169:                                              ; preds = %162
  %170 = load ptr, ptr %5, align 8, !dbg !636
  %171 = load i32, ptr %10, align 4, !dbg !637
  %172 = sext i32 %171 to i64, !dbg !636
  %173 = getelementptr inbounds i8, ptr %170, i64 %172, !dbg !636
  %174 = load i8, ptr %173, align 1, !dbg !636
  %175 = sext i8 %174 to i32, !dbg !636
  %176 = load i8, ptr %7, align 1, !dbg !638
  %177 = sext i8 %176 to i32, !dbg !638
  %178 = icmp ne i32 %175, %177, !dbg !639
  br i1 %178, label %179, label %180, !dbg !640

179:                                              ; preds = %169, %162
  store i32 0, ptr %9, align 4, !dbg !641
  br label %187, !dbg !642

180:                                              ; preds = %169
  %181 = load i8, ptr %15, align 1, !dbg !643
  %182 = icmp ne i8 %181, 0, !dbg !643
  br i1 %182, label %184, label %183, !dbg !645

183:                                              ; preds = %180
  store i32 0, ptr %9, align 4, !dbg !646
  br label %186, !dbg !647

184:                                              ; preds = %180
  %185 = load i32, ptr %10, align 4, !dbg !648
  store i32 %185, ptr %9, align 4, !dbg !649
  br label %186

186:                                              ; preds = %184, %183
  br label %187

187:                                              ; preds = %186, %179
  %188 = load i32, ptr %9, align 4, !dbg !650
  ret i32 %188, !dbg !651
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @getpat(ptr noundef %0, ptr noundef %1) #0 !dbg !652 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !655, metadata !DIExpression()), !dbg !656
  store ptr %1, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !657, metadata !DIExpression()), !dbg !658
  call void @llvm.dbg.declare(metadata ptr %5, metadata !659, metadata !DIExpression()), !dbg !660
  %6 = load ptr, ptr %3, align 8, !dbg !661
  %7 = load ptr, ptr %4, align 8, !dbg !662
  %8 = call i32 @makepat(ptr noundef %6, i32 noundef 0, i32 noundef 0, ptr noundef %7), !dbg !663
  store i32 %8, ptr %5, align 4, !dbg !664
  %9 = load i32, ptr %5, align 4, !dbg !665
  %10 = icmp sgt i32 %9, 0, !dbg !666
  %11 = zext i1 %10 to i32, !dbg !666
  ret i32 %11, !dbg !667
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @makesub(ptr noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3) #0 !dbg !668 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i8, align 1
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i8, align 1
  %13 = alloca i8, align 1
  %14 = trunc i32 %2 to i8
  store ptr %0, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !672, metadata !DIExpression()), !dbg !673
  store i32 %1, ptr %6, align 4
  call void @llvm.dbg.declare(metadata ptr %6, metadata !674, metadata !DIExpression()), !dbg !675
  store i8 %14, ptr %7, align 1
  call void @llvm.dbg.declare(metadata ptr %7, metadata !676, metadata !DIExpression()), !dbg !677
  store ptr %3, ptr %8, align 8
  call void @llvm.dbg.declare(metadata ptr %8, metadata !678, metadata !DIExpression()), !dbg !679
  call void @llvm.dbg.declare(metadata ptr %9, metadata !680, metadata !DIExpression()), !dbg !681
  call void @llvm.dbg.declare(metadata ptr %10, metadata !682, metadata !DIExpression()), !dbg !683
  call void @llvm.dbg.declare(metadata ptr %11, metadata !684, metadata !DIExpression()), !dbg !685
  call void @llvm.dbg.declare(metadata ptr %12, metadata !686, metadata !DIExpression()), !dbg !687
  call void @llvm.dbg.declare(metadata ptr %13, metadata !688, metadata !DIExpression()), !dbg !689
  store i32 0, ptr %11, align 4, !dbg !690
  %15 = load i32, ptr %6, align 4, !dbg !691
  store i32 %15, ptr %10, align 4, !dbg !692
  br label %16, !dbg !693

16:                                               ; preds = %56, %4
  %17 = load ptr, ptr %5, align 8, !dbg !694
  %18 = load i32, ptr %10, align 4, !dbg !695
  %19 = sext i32 %18 to i64, !dbg !694
  %20 = getelementptr inbounds i8, ptr %17, i64 %19, !dbg !694
  %21 = load i8, ptr %20, align 1, !dbg !694
  %22 = sext i8 %21 to i32, !dbg !694
  %23 = load i8, ptr %7, align 1, !dbg !696
  %24 = sext i8 %23 to i32, !dbg !696
  %25 = icmp ne i32 %22, %24, !dbg !697
  br i1 %25, label %26, label %34, !dbg !698

26:                                               ; preds = %16
  %27 = load ptr, ptr %5, align 8, !dbg !699
  %28 = load i32, ptr %10, align 4, !dbg !700
  %29 = sext i32 %28 to i64, !dbg !699
  %30 = getelementptr inbounds i8, ptr %27, i64 %29, !dbg !699
  %31 = load i8, ptr %30, align 1, !dbg !699
  %32 = sext i8 %31 to i32, !dbg !699
  %33 = icmp ne i32 %32, 0, !dbg !701
  br label %34

34:                                               ; preds = %26, %16
  %35 = phi i1 [ false, %16 ], [ %33, %26 ], !dbg !702
  br i1 %35, label %36, label %59, !dbg !693

36:                                               ; preds = %34
  %37 = load ptr, ptr %5, align 8, !dbg !703
  %38 = load i32, ptr %10, align 4, !dbg !706
  %39 = sext i32 %38 to i64, !dbg !703
  %40 = getelementptr inbounds i8, ptr %37, i64 %39, !dbg !703
  %41 = load i8, ptr %40, align 1, !dbg !703
  %42 = sext i8 %41 to i32, !dbg !703
  %43 = icmp eq i32 %42, 38, !dbg !707
  br i1 %43, label %44, label %48, !dbg !708

44:                                               ; preds = %36
  %45 = load ptr, ptr %8, align 8, !dbg !709
  %46 = call i32 @addstr(i32 noundef -1, ptr noundef %45, ptr noundef %11, i32 noundef 100), !dbg !710
  %47 = trunc i32 %46 to i8, !dbg !710
  store i8 %47, ptr %12, align 1, !dbg !711
  br label %56, !dbg !712

48:                                               ; preds = %36
  %49 = load ptr, ptr %5, align 8, !dbg !713
  %50 = call signext i8 @esc(ptr noundef %49, ptr noundef %10), !dbg !715
  store i8 %50, ptr %13, align 1, !dbg !716
  %51 = load i8, ptr %13, align 1, !dbg !717
  %52 = sext i8 %51 to i32, !dbg !717
  %53 = load ptr, ptr %8, align 8, !dbg !718
  %54 = call i32 @addstr(i32 noundef %52, ptr noundef %53, ptr noundef %11, i32 noundef 100), !dbg !719
  %55 = trunc i32 %54 to i8, !dbg !719
  store i8 %55, ptr %12, align 1, !dbg !720
  br label %56

56:                                               ; preds = %48, %44
  %57 = load i32, ptr %10, align 4, !dbg !721
  %58 = add nsw i32 %57, 1, !dbg !722
  store i32 %58, ptr %10, align 4, !dbg !723
  br label %16, !dbg !693, !llvm.loop !724

59:                                               ; preds = %34
  %60 = load ptr, ptr %5, align 8, !dbg !726
  %61 = load i32, ptr %10, align 4, !dbg !728
  %62 = sext i32 %61 to i64, !dbg !726
  %63 = getelementptr inbounds i8, ptr %60, i64 %62, !dbg !726
  %64 = load i8, ptr %63, align 1, !dbg !726
  %65 = sext i8 %64 to i32, !dbg !726
  %66 = load i8, ptr %7, align 1, !dbg !729
  %67 = sext i8 %66 to i32, !dbg !729
  %68 = icmp ne i32 %65, %67, !dbg !730
  br i1 %68, label %69, label %70, !dbg !731

69:                                               ; preds = %59
  store i32 0, ptr %9, align 4, !dbg !732
  br label %80, !dbg !733

70:                                               ; preds = %59
  %71 = load ptr, ptr %8, align 8, !dbg !734
  %72 = call i32 @addstr(i32 noundef 0, ptr noundef %71, ptr noundef %11, i32 noundef 100), !dbg !736
  %73 = trunc i32 %72 to i8, !dbg !736
  store i8 %73, ptr %12, align 1, !dbg !737
  %74 = load i8, ptr %12, align 1, !dbg !738
  %75 = icmp ne i8 %74, 0, !dbg !738
  br i1 %75, label %77, label %76, !dbg !740

76:                                               ; preds = %70
  store i32 0, ptr %9, align 4, !dbg !741
  br label %79, !dbg !742

77:                                               ; preds = %70
  %78 = load i32, ptr %10, align 4, !dbg !743
  store i32 %78, ptr %9, align 4, !dbg !744
  br label %79

79:                                               ; preds = %77, %76
  br label %80

80:                                               ; preds = %79, %69
  %81 = load i32, ptr %9, align 4, !dbg !745
  ret i32 %81, !dbg !746
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define signext i8 @getsub(ptr noundef %0, ptr noundef %1) #0 !dbg !747 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !750, metadata !DIExpression()), !dbg !751
  store ptr %1, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !752, metadata !DIExpression()), !dbg !753
  call void @llvm.dbg.declare(metadata ptr %5, metadata !754, metadata !DIExpression()), !dbg !755
  %6 = load ptr, ptr %3, align 8, !dbg !756
  %7 = load ptr, ptr %4, align 8, !dbg !757
  %8 = call i32 @makesub(ptr noundef %6, i32 noundef 0, i32 noundef 0, ptr noundef %7), !dbg !758
  store i32 %8, ptr %5, align 4, !dbg !759
  %9 = load i32, ptr %5, align 4, !dbg !760
  %10 = icmp sgt i32 %9, 0, !dbg !761
  %11 = zext i1 %10 to i32, !dbg !761
  %12 = trunc i32 %11 to i8, !dbg !762
  ret i8 %12, !dbg !763
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define signext i8 @locate(i32 noundef %0, ptr noundef %1, i32 noundef %2) #0 !dbg !764 {
  %4 = alloca i8, align 1
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i8, align 1
  %9 = trunc i32 %0 to i8
  store i8 %9, ptr %4, align 1
  call void @llvm.dbg.declare(metadata ptr %4, metadata !767, metadata !DIExpression()), !dbg !768
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !769, metadata !DIExpression()), !dbg !770
  store i32 %2, ptr %6, align 4
  call void @llvm.dbg.declare(metadata ptr %6, metadata !771, metadata !DIExpression()), !dbg !772
  call void @llvm.dbg.declare(metadata ptr %7, metadata !773, metadata !DIExpression()), !dbg !774
  call void @llvm.dbg.declare(metadata ptr %8, metadata !775, metadata !DIExpression()), !dbg !776
  store i8 0, ptr %8, align 1, !dbg !777
  %10 = load i32, ptr %6, align 4, !dbg !778
  %11 = load ptr, ptr %5, align 8, !dbg !779
  %12 = load i32, ptr %6, align 4, !dbg !780
  %13 = sext i32 %12 to i64, !dbg !779
  %14 = getelementptr inbounds i8, ptr %11, i64 %13, !dbg !779
  %15 = load i8, ptr %14, align 1, !dbg !779
  %16 = sext i8 %15 to i32, !dbg !779
  %17 = add nsw i32 %10, %16, !dbg !781
  store i32 %17, ptr %7, align 4, !dbg !782
  br label %18, !dbg !783

18:                                               ; preds = %37, %3
  %19 = load i32, ptr %7, align 4, !dbg !784
  %20 = load i32, ptr %6, align 4, !dbg !785
  %21 = icmp sgt i32 %19, %20, !dbg !786
  br i1 %21, label %22, label %38, !dbg !783

22:                                               ; preds = %18
  %23 = load i8, ptr %4, align 1, !dbg !787
  %24 = sext i8 %23 to i32, !dbg !787
  %25 = load ptr, ptr %5, align 8, !dbg !790
  %26 = load i32, ptr %7, align 4, !dbg !791
  %27 = sext i32 %26 to i64, !dbg !790
  %28 = getelementptr inbounds i8, ptr %25, i64 %27, !dbg !790
  %29 = load i8, ptr %28, align 1, !dbg !790
  %30 = sext i8 %29 to i32, !dbg !790
  %31 = icmp eq i32 %24, %30, !dbg !792
  br i1 %31, label %32, label %34, !dbg !793

32:                                               ; preds = %22
  store i8 1, ptr %8, align 1, !dbg !794
  %33 = load i32, ptr %6, align 4, !dbg !796
  store i32 %33, ptr %7, align 4, !dbg !797
  br label %37, !dbg !798

34:                                               ; preds = %22
  %35 = load i32, ptr %7, align 4, !dbg !799
  %36 = sub nsw i32 %35, 1, !dbg !800
  store i32 %36, ptr %7, align 4, !dbg !801
  br label %37

37:                                               ; preds = %34, %32
  br label %18, !dbg !783, !llvm.loop !802

38:                                               ; preds = %18
  %39 = load i8, ptr %8, align 1, !dbg !804
  ret i8 %39, !dbg !805
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define signext i8 @omatch(ptr noundef %0, ptr noundef %1, ptr noundef %2, i32 noundef %3) #0 !dbg !806 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  %9 = alloca i8, align 1
  %10 = alloca i8, align 1
  store ptr %0, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !809, metadata !DIExpression()), !dbg !810
  store ptr %1, ptr %6, align 8
  call void @llvm.dbg.declare(metadata ptr %6, metadata !811, metadata !DIExpression()), !dbg !812
  store ptr %2, ptr %7, align 8
  call void @llvm.dbg.declare(metadata ptr %7, metadata !813, metadata !DIExpression()), !dbg !814
  store i32 %3, ptr %8, align 4
  call void @llvm.dbg.declare(metadata ptr %8, metadata !815, metadata !DIExpression()), !dbg !816
  call void @llvm.dbg.declare(metadata ptr %9, metadata !817, metadata !DIExpression()), !dbg !818
  call void @llvm.dbg.declare(metadata ptr %10, metadata !819, metadata !DIExpression()), !dbg !820
  store i8 -1, ptr %9, align 1, !dbg !821
  %11 = load ptr, ptr %5, align 8, !dbg !822
  %12 = load ptr, ptr %6, align 8, !dbg !824
  %13 = load i32, ptr %12, align 4, !dbg !825
  %14 = sext i32 %13 to i64, !dbg !822
  %15 = getelementptr inbounds i8, ptr %11, i64 %14, !dbg !822
  %16 = load i8, ptr %15, align 1, !dbg !822
  %17 = sext i8 %16 to i32, !dbg !822
  %18 = icmp eq i32 %17, 0, !dbg !826
  br i1 %18, label %19, label %20, !dbg !827

19:                                               ; preds = %4
  store i8 0, ptr %10, align 1, !dbg !828
  br label %133, !dbg !829

20:                                               ; preds = %4
  %21 = load ptr, ptr %7, align 8, !dbg !830
  %22 = load i32, ptr %8, align 4, !dbg !833
  %23 = sext i32 %22 to i64, !dbg !830
  %24 = getelementptr inbounds i8, ptr %21, i64 %23, !dbg !830
  %25 = load i8, ptr %24, align 1, !dbg !830
  %26 = sext i8 %25 to i32, !dbg !830
  %27 = call signext i8 @in_pat_set(i32 noundef %26), !dbg !834
  %28 = icmp ne i8 %27, 0, !dbg !834
  br i1 %28, label %32, label %29, !dbg !835

29:                                               ; preds = %20
  %30 = load ptr, ptr @__stdoutp, align 8, !dbg !836
  %31 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %30, ptr noundef @.str), !dbg !838
  call void @abort() #8, !dbg !839
  unreachable, !dbg !839

32:                                               ; preds = %20
  %33 = load ptr, ptr %7, align 8, !dbg !840
  %34 = load i32, ptr %8, align 4, !dbg !842
  %35 = sext i32 %34 to i64, !dbg !840
  %36 = getelementptr inbounds i8, ptr %33, i64 %35, !dbg !840
  %37 = load i8, ptr %36, align 1, !dbg !840
  %38 = sext i8 %37 to i32, !dbg !840
  switch i32 %38, label %124 [
    i32 99, label %39
    i32 37, label %57
    i32 63, label %63
    i32 36, label %74
    i32 91, label %85
    i32 33, label %100
  ], !dbg !843

39:                                               ; preds = %32
  %40 = load ptr, ptr %5, align 8, !dbg !844
  %41 = load ptr, ptr %6, align 8, !dbg !847
  %42 = load i32, ptr %41, align 4, !dbg !848
  %43 = sext i32 %42 to i64, !dbg !844
  %44 = getelementptr inbounds i8, ptr %40, i64 %43, !dbg !844
  %45 = load i8, ptr %44, align 1, !dbg !844
  %46 = sext i8 %45 to i32, !dbg !844
  %47 = load ptr, ptr %7, align 8, !dbg !849
  %48 = load i32, ptr %8, align 4, !dbg !850
  %49 = add nsw i32 %48, 1, !dbg !851
  %50 = sext i32 %49 to i64, !dbg !849
  %51 = getelementptr inbounds i8, ptr %47, i64 %50, !dbg !849
  %52 = load i8, ptr %51, align 1, !dbg !849
  %53 = sext i8 %52 to i32, !dbg !849
  %54 = icmp eq i32 %46, %53, !dbg !852
  br i1 %54, label %55, label %56, !dbg !853

55:                                               ; preds = %39
  store i8 1, ptr %9, align 1, !dbg !854
  br label %56, !dbg !855

56:                                               ; preds = %55, %39
  br label %131, !dbg !856

57:                                               ; preds = %32
  %58 = load ptr, ptr %6, align 8, !dbg !857
  %59 = load i32, ptr %58, align 4, !dbg !859
  %60 = icmp eq i32 %59, 0, !dbg !860
  br i1 %60, label %61, label %62, !dbg !861

61:                                               ; preds = %57
  store i8 0, ptr %9, align 1, !dbg !862
  br label %62, !dbg !863

62:                                               ; preds = %61, %57
  br label %131, !dbg !864

63:                                               ; preds = %32
  %64 = load ptr, ptr %5, align 8, !dbg !865
  %65 = load ptr, ptr %6, align 8, !dbg !867
  %66 = load i32, ptr %65, align 4, !dbg !868
  %67 = sext i32 %66 to i64, !dbg !865
  %68 = getelementptr inbounds i8, ptr %64, i64 %67, !dbg !865
  %69 = load i8, ptr %68, align 1, !dbg !865
  %70 = sext i8 %69 to i32, !dbg !865
  %71 = icmp ne i32 %70, 10, !dbg !869
  br i1 %71, label %72, label %73, !dbg !870

72:                                               ; preds = %63
  store i8 1, ptr %9, align 1, !dbg !871
  br label %73, !dbg !872

73:                                               ; preds = %72, %63
  br label %131, !dbg !873

74:                                               ; preds = %32
  %75 = load ptr, ptr %5, align 8, !dbg !874
  %76 = load ptr, ptr %6, align 8, !dbg !876
  %77 = load i32, ptr %76, align 4, !dbg !877
  %78 = sext i32 %77 to i64, !dbg !874
  %79 = getelementptr inbounds i8, ptr %75, i64 %78, !dbg !874
  %80 = load i8, ptr %79, align 1, !dbg !874
  %81 = sext i8 %80 to i32, !dbg !874
  %82 = icmp eq i32 %81, 10, !dbg !878
  br i1 %82, label %83, label %84, !dbg !879

83:                                               ; preds = %74
  store i8 0, ptr %9, align 1, !dbg !880
  br label %84, !dbg !881

84:                                               ; preds = %83, %74
  br label %131, !dbg !882

85:                                               ; preds = %32
  %86 = load ptr, ptr %5, align 8, !dbg !883
  %87 = load ptr, ptr %6, align 8, !dbg !885
  %88 = load i32, ptr %87, align 4, !dbg !886
  %89 = sext i32 %88 to i64, !dbg !883
  %90 = getelementptr inbounds i8, ptr %86, i64 %89, !dbg !883
  %91 = load i8, ptr %90, align 1, !dbg !883
  %92 = sext i8 %91 to i32, !dbg !883
  %93 = load ptr, ptr %7, align 8, !dbg !887
  %94 = load i32, ptr %8, align 4, !dbg !888
  %95 = add nsw i32 %94, 1, !dbg !889
  %96 = call signext i8 @locate(i32 noundef %92, ptr noundef %93, i32 noundef %95), !dbg !890
  %97 = icmp ne i8 %96, 0, !dbg !890
  br i1 %97, label %98, label %99, !dbg !891

98:                                               ; preds = %85
  store i8 1, ptr %9, align 1, !dbg !892
  br label %99, !dbg !893

99:                                               ; preds = %98, %85
  br label %131, !dbg !894

100:                                              ; preds = %32
  %101 = load ptr, ptr %5, align 8, !dbg !895
  %102 = load ptr, ptr %6, align 8, !dbg !897
  %103 = load i32, ptr %102, align 4, !dbg !898
  %104 = sext i32 %103 to i64, !dbg !895
  %105 = getelementptr inbounds i8, ptr %101, i64 %104, !dbg !895
  %106 = load i8, ptr %105, align 1, !dbg !895
  %107 = sext i8 %106 to i32, !dbg !895
  %108 = icmp ne i32 %107, 10, !dbg !899
  br i1 %108, label %109, label %123, !dbg !900

109:                                              ; preds = %100
  %110 = load ptr, ptr %5, align 8, !dbg !901
  %111 = load ptr, ptr %6, align 8, !dbg !902
  %112 = load i32, ptr %111, align 4, !dbg !903
  %113 = sext i32 %112 to i64, !dbg !901
  %114 = getelementptr inbounds i8, ptr %110, i64 %113, !dbg !901
  %115 = load i8, ptr %114, align 1, !dbg !901
  %116 = sext i8 %115 to i32, !dbg !901
  %117 = load ptr, ptr %7, align 8, !dbg !904
  %118 = load i32, ptr %8, align 4, !dbg !905
  %119 = add nsw i32 %118, 1, !dbg !906
  %120 = call signext i8 @locate(i32 noundef %116, ptr noundef %117, i32 noundef %119), !dbg !907
  %121 = icmp ne i8 %120, 0, !dbg !907
  br i1 %121, label %123, label %122, !dbg !908

122:                                              ; preds = %109
  store i8 1, ptr %9, align 1, !dbg !909
  br label %123, !dbg !910

123:                                              ; preds = %122, %109, %100
  br label %131, !dbg !911

124:                                              ; preds = %32
  %125 = load ptr, ptr %7, align 8, !dbg !912
  %126 = load i32, ptr %8, align 4, !dbg !913
  %127 = sext i32 %126 to i64, !dbg !912
  %128 = getelementptr inbounds i8, ptr %125, i64 %127, !dbg !912
  %129 = load i8, ptr %128, align 1, !dbg !912
  %130 = sext i8 %129 to i32, !dbg !912
  call void @Caseerror(i32 noundef %130), !dbg !914
  br label %131, !dbg !915

131:                                              ; preds = %124, %123, %99, %84, %73, %62, %56
  br label %132

132:                                              ; preds = %131
  br label %133

133:                                              ; preds = %132, %19
  %134 = load i8, ptr %9, align 1, !dbg !916
  %135 = sext i8 %134 to i32, !dbg !916
  %136 = icmp sge i32 %135, 0, !dbg !918
  br i1 %136, label %137, label %144, !dbg !919

137:                                              ; preds = %133
  %138 = load ptr, ptr %6, align 8, !dbg !920
  %139 = load i32, ptr %138, align 4, !dbg !922
  %140 = load i8, ptr %9, align 1, !dbg !923
  %141 = sext i8 %140 to i32, !dbg !923
  %142 = add nsw i32 %139, %141, !dbg !924
  %143 = load ptr, ptr %6, align 8, !dbg !925
  store i32 %142, ptr %143, align 4, !dbg !926
  store i8 1, ptr %10, align 1, !dbg !927
  br label %145, !dbg !928

144:                                              ; preds = %133
  store i8 0, ptr %10, align 1, !dbg !929
  br label %145

145:                                              ; preds = %144, %137
  %146 = load i8, ptr %10, align 1, !dbg !930
  ret i8 %146, !dbg !931
}

declare i32 @fprintf(ptr noundef, ptr noundef, ...) #2

; Function Attrs: cold noreturn
declare void @abort() #4

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @patsize(ptr noundef %0, i32 noundef %1) #0 !dbg !932 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !935, metadata !DIExpression()), !dbg !936
  store i32 %1, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !937, metadata !DIExpression()), !dbg !938
  call void @llvm.dbg.declare(metadata ptr %5, metadata !939, metadata !DIExpression()), !dbg !940
  %6 = load ptr, ptr %3, align 8, !dbg !941
  %7 = load i32, ptr %4, align 4, !dbg !943
  %8 = sext i32 %7 to i64, !dbg !941
  %9 = getelementptr inbounds i8, ptr %6, i64 %8, !dbg !941
  %10 = load i8, ptr %9, align 1, !dbg !941
  %11 = sext i8 %10 to i32, !dbg !941
  %12 = call signext i8 @in_pat_set(i32 noundef %11), !dbg !944
  %13 = icmp ne i8 %12, 0, !dbg !944
  br i1 %13, label %17, label %14, !dbg !945

14:                                               ; preds = %2
  %15 = load ptr, ptr @__stdoutp, align 8, !dbg !946
  %16 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %15, ptr noundef @.str.1), !dbg !948
  call void @abort() #8, !dbg !949
  unreachable, !dbg !949

17:                                               ; preds = %2
  %18 = load ptr, ptr %3, align 8, !dbg !950
  %19 = load i32, ptr %4, align 4, !dbg !951
  %20 = sext i32 %19 to i64, !dbg !950
  %21 = getelementptr inbounds i8, ptr %18, i64 %20, !dbg !950
  %22 = load i8, ptr %21, align 1, !dbg !950
  %23 = sext i8 %22 to i32, !dbg !950
  switch i32 %23, label %36 [
    i32 99, label %24
    i32 37, label %25
    i32 36, label %25
    i32 63, label %25
    i32 91, label %26
    i32 33, label %26
    i32 42, label %35
  ], !dbg !952

24:                                               ; preds = %17
  store i32 2, ptr %5, align 4, !dbg !953
  br label %43, !dbg !955

25:                                               ; preds = %17, %17, %17
  store i32 1, ptr %5, align 4, !dbg !956
  br label %43, !dbg !957

26:                                               ; preds = %17, %17
  %27 = load ptr, ptr %3, align 8, !dbg !958
  %28 = load i32, ptr %4, align 4, !dbg !959
  %29 = add nsw i32 %28, 1, !dbg !960
  %30 = sext i32 %29 to i64, !dbg !958
  %31 = getelementptr inbounds i8, ptr %27, i64 %30, !dbg !958
  %32 = load i8, ptr %31, align 1, !dbg !958
  %33 = sext i8 %32 to i32, !dbg !958
  %34 = add nsw i32 %33, 2, !dbg !961
  store i32 %34, ptr %5, align 4, !dbg !962
  br label %43, !dbg !963

35:                                               ; preds = %17
  store i32 1, ptr %5, align 4, !dbg !964
  br label %43, !dbg !965

36:                                               ; preds = %17
  %37 = load ptr, ptr %3, align 8, !dbg !966
  %38 = load i32, ptr %4, align 4, !dbg !967
  %39 = sext i32 %38 to i64, !dbg !966
  %40 = getelementptr inbounds i8, ptr %37, i64 %39, !dbg !966
  %41 = load i8, ptr %40, align 1, !dbg !966
  %42 = sext i8 %41 to i32, !dbg !966
  call void @Caseerror(i32 noundef %42), !dbg !968
  br label %43, !dbg !969

43:                                               ; preds = %36, %35, %26, %25, %24
  br label %44

44:                                               ; preds = %43
  %45 = load i32, ptr %5, align 4, !dbg !970
  ret i32 %45, !dbg !971
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @amatch(ptr noundef %0, i32 noundef %1, ptr noundef %2, i32 noundef %3) #0 !dbg !972 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i8, align 1
  %12 = alloca i8, align 1
  store ptr %0, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !975, metadata !DIExpression()), !dbg !976
  store i32 %1, ptr %6, align 4
  call void @llvm.dbg.declare(metadata ptr %6, metadata !977, metadata !DIExpression()), !dbg !978
  store ptr %2, ptr %7, align 8
  call void @llvm.dbg.declare(metadata ptr %7, metadata !979, metadata !DIExpression()), !dbg !980
  store i32 %3, ptr %8, align 4
  call void @llvm.dbg.declare(metadata ptr %8, metadata !981, metadata !DIExpression()), !dbg !982
  call void @llvm.dbg.declare(metadata ptr %9, metadata !983, metadata !DIExpression()), !dbg !984
  call void @llvm.dbg.declare(metadata ptr %10, metadata !985, metadata !DIExpression()), !dbg !986
  call void @llvm.dbg.declare(metadata ptr %11, metadata !987, metadata !DIExpression()), !dbg !988
  call void @llvm.dbg.declare(metadata ptr %12, metadata !989, metadata !DIExpression()), !dbg !990
  store i8 0, ptr %12, align 1, !dbg !991
  br label %13, !dbg !992

13:                                               ; preds = %107, %4
  %14 = load i8, ptr %12, align 1, !dbg !993
  %15 = icmp ne i8 %14, 0, !dbg !993
  br i1 %15, label %24, label %16, !dbg !994

16:                                               ; preds = %13
  %17 = load ptr, ptr %7, align 8, !dbg !995
  %18 = load i32, ptr %8, align 4, !dbg !996
  %19 = sext i32 %18 to i64, !dbg !995
  %20 = getelementptr inbounds i8, ptr %17, i64 %19, !dbg !995
  %21 = load i8, ptr %20, align 1, !dbg !995
  %22 = sext i8 %21 to i32, !dbg !995
  %23 = icmp ne i32 %22, 0, !dbg !997
  br label %24

24:                                               ; preds = %16, %13
  %25 = phi i1 [ false, %13 ], [ %23, %16 ], !dbg !998
  br i1 %25, label %26, label %108, !dbg !992

26:                                               ; preds = %24
  %27 = load ptr, ptr %7, align 8, !dbg !999
  %28 = load i32, ptr %8, align 4, !dbg !1001
  %29 = sext i32 %28 to i64, !dbg !999
  %30 = getelementptr inbounds i8, ptr %27, i64 %29, !dbg !999
  %31 = load i8, ptr %30, align 1, !dbg !999
  %32 = sext i8 %31 to i32, !dbg !999
  %33 = icmp eq i32 %32, 42, !dbg !1002
  br i1 %33, label %34, label %92, !dbg !1003

34:                                               ; preds = %26
  %35 = load i32, ptr %8, align 4, !dbg !1004
  %36 = load ptr, ptr %7, align 8, !dbg !1006
  %37 = load i32, ptr %8, align 4, !dbg !1007
  %38 = call i32 @patsize(ptr noundef %36, i32 noundef %37), !dbg !1008
  %39 = add nsw i32 %35, %38, !dbg !1009
  store i32 %39, ptr %8, align 4, !dbg !1010
  %40 = load i32, ptr %6, align 4, !dbg !1011
  store i32 %40, ptr %9, align 4, !dbg !1012
  br label %41, !dbg !1013

41:                                               ; preds = %62, %34
  %42 = load i8, ptr %12, align 1, !dbg !1014
  %43 = icmp ne i8 %42, 0, !dbg !1014
  br i1 %43, label %52, label %44, !dbg !1015

44:                                               ; preds = %41
  %45 = load ptr, ptr %5, align 8, !dbg !1016
  %46 = load i32, ptr %9, align 4, !dbg !1017
  %47 = sext i32 %46 to i64, !dbg !1016
  %48 = getelementptr inbounds i8, ptr %45, i64 %47, !dbg !1016
  %49 = load i8, ptr %48, align 1, !dbg !1016
  %50 = sext i8 %49 to i32, !dbg !1016
  %51 = icmp ne i32 %50, 0, !dbg !1018
  br label %52

52:                                               ; preds = %44, %41
  %53 = phi i1 [ false, %41 ], [ %51, %44 ], !dbg !1019
  br i1 %53, label %54, label %63, !dbg !1013

54:                                               ; preds = %52
  %55 = load ptr, ptr %5, align 8, !dbg !1020
  %56 = load ptr, ptr %7, align 8, !dbg !1022
  %57 = load i32, ptr %8, align 4, !dbg !1023
  %58 = call signext i8 @omatch(ptr noundef %55, ptr noundef %9, ptr noundef %56, i32 noundef %57), !dbg !1024
  store i8 %58, ptr %11, align 1, !dbg !1025
  %59 = load i8, ptr %11, align 1, !dbg !1026
  %60 = icmp ne i8 %59, 0, !dbg !1026
  br i1 %60, label %62, label %61, !dbg !1028

61:                                               ; preds = %54
  store i8 1, ptr %12, align 1, !dbg !1029
  br label %62, !dbg !1030

62:                                               ; preds = %61, %54
  br label %41, !dbg !1013, !llvm.loop !1031

63:                                               ; preds = %52
  store i8 0, ptr %12, align 1, !dbg !1033
  br label %64, !dbg !1034

64:                                               ; preds = %89, %63
  %65 = load i8, ptr %12, align 1, !dbg !1035
  %66 = icmp ne i8 %65, 0, !dbg !1035
  br i1 %66, label %71, label %67, !dbg !1036

67:                                               ; preds = %64
  %68 = load i32, ptr %9, align 4, !dbg !1037
  %69 = load i32, ptr %6, align 4, !dbg !1038
  %70 = icmp sge i32 %68, %69, !dbg !1039
  br label %71

71:                                               ; preds = %67, %64
  %72 = phi i1 [ false, %64 ], [ %70, %67 ], !dbg !1019
  br i1 %72, label %73, label %90, !dbg !1034

73:                                               ; preds = %71
  %74 = load ptr, ptr %5, align 8, !dbg !1040
  %75 = load i32, ptr %9, align 4, !dbg !1042
  %76 = load ptr, ptr %7, align 8, !dbg !1043
  %77 = load i32, ptr %8, align 4, !dbg !1044
  %78 = load ptr, ptr %7, align 8, !dbg !1045
  %79 = load i32, ptr %8, align 4, !dbg !1046
  %80 = call i32 @patsize(ptr noundef %78, i32 noundef %79), !dbg !1047
  %81 = add nsw i32 %77, %80, !dbg !1048
  %82 = call i32 @amatch(ptr noundef %74, i32 noundef %75, ptr noundef %76, i32 noundef %81), !dbg !1049
  store i32 %82, ptr %10, align 4, !dbg !1050
  %83 = load i32, ptr %10, align 4, !dbg !1051
  %84 = icmp sge i32 %83, 0, !dbg !1053
  br i1 %84, label %85, label %86, !dbg !1054

85:                                               ; preds = %73
  store i8 1, ptr %12, align 1, !dbg !1055
  br label %89, !dbg !1056

86:                                               ; preds = %73
  %87 = load i32, ptr %9, align 4, !dbg !1057
  %88 = sub nsw i32 %87, 1, !dbg !1058
  store i32 %88, ptr %9, align 4, !dbg !1059
  br label %89

89:                                               ; preds = %86, %85
  br label %64, !dbg !1034, !llvm.loop !1060

90:                                               ; preds = %71
  %91 = load i32, ptr %10, align 4, !dbg !1062
  store i32 %91, ptr %6, align 4, !dbg !1063
  store i8 1, ptr %12, align 1, !dbg !1064
  br label %107, !dbg !1065

92:                                               ; preds = %26
  %93 = load ptr, ptr %5, align 8, !dbg !1066
  %94 = load ptr, ptr %7, align 8, !dbg !1068
  %95 = load i32, ptr %8, align 4, !dbg !1069
  %96 = call signext i8 @omatch(ptr noundef %93, ptr noundef %6, ptr noundef %94, i32 noundef %95), !dbg !1070
  store i8 %96, ptr %11, align 1, !dbg !1071
  %97 = load i8, ptr %11, align 1, !dbg !1072
  %98 = icmp ne i8 %97, 0, !dbg !1072
  br i1 %98, label %100, label %99, !dbg !1074

99:                                               ; preds = %92
  store i32 -1, ptr %6, align 4, !dbg !1075
  store i8 1, ptr %12, align 1, !dbg !1077
  br label %106, !dbg !1078

100:                                              ; preds = %92
  %101 = load i32, ptr %8, align 4, !dbg !1079
  %102 = load ptr, ptr %7, align 8, !dbg !1080
  %103 = load i32, ptr %8, align 4, !dbg !1081
  %104 = call i32 @patsize(ptr noundef %102, i32 noundef %103), !dbg !1082
  %105 = add nsw i32 %101, %104, !dbg !1083
  store i32 %105, ptr %8, align 4, !dbg !1084
  br label %106

106:                                              ; preds = %100, %99
  br label %107

107:                                              ; preds = %106, %90
  br label %13, !dbg !992, !llvm.loop !1085

108:                                              ; preds = %24
  %109 = load i32, ptr %6, align 4, !dbg !1087
  ret i32 %109, !dbg !1088
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @putsub(ptr noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3) #0 !dbg !1089 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !1092, metadata !DIExpression()), !dbg !1093
  store i32 %1, ptr %6, align 4
  call void @llvm.dbg.declare(metadata ptr %6, metadata !1094, metadata !DIExpression()), !dbg !1095
  store i32 %2, ptr %7, align 4
  call void @llvm.dbg.declare(metadata ptr %7, metadata !1096, metadata !DIExpression()), !dbg !1097
  store ptr %3, ptr %8, align 8
  call void @llvm.dbg.declare(metadata ptr %8, metadata !1098, metadata !DIExpression()), !dbg !1099
  call void @llvm.dbg.declare(metadata ptr %9, metadata !1100, metadata !DIExpression()), !dbg !1101
  call void @llvm.dbg.declare(metadata ptr %10, metadata !1102, metadata !DIExpression()), !dbg !1103
  store i32 0, ptr %9, align 4, !dbg !1104
  br label %11, !dbg !1105

11:                                               ; preds = %55, %4
  %12 = load ptr, ptr %8, align 8, !dbg !1106
  %13 = load i32, ptr %9, align 4, !dbg !1107
  %14 = sext i32 %13 to i64, !dbg !1106
  %15 = getelementptr inbounds i8, ptr %12, i64 %14, !dbg !1106
  %16 = load i8, ptr %15, align 1, !dbg !1106
  %17 = sext i8 %16 to i32, !dbg !1106
  %18 = icmp ne i32 %17, 0, !dbg !1108
  br i1 %18, label %19, label %58, !dbg !1105

19:                                               ; preds = %11
  %20 = load ptr, ptr %8, align 8, !dbg !1109
  %21 = load i32, ptr %9, align 4, !dbg !1112
  %22 = sext i32 %21 to i64, !dbg !1109
  %23 = getelementptr inbounds i8, ptr %20, i64 %22, !dbg !1109
  %24 = load i8, ptr %23, align 1, !dbg !1109
  %25 = sext i8 %24 to i32, !dbg !1109
  %26 = icmp eq i32 %25, -1, !dbg !1113
  br i1 %26, label %27, label %46, !dbg !1114

27:                                               ; preds = %19
  %28 = load i32, ptr %6, align 4, !dbg !1115
  store i32 %28, ptr %10, align 4, !dbg !1117
  br label %29, !dbg !1118

29:                                               ; preds = %42, %27
  %30 = load i32, ptr %10, align 4, !dbg !1119
  %31 = load i32, ptr %7, align 4, !dbg !1121
  %32 = icmp slt i32 %30, %31, !dbg !1122
  br i1 %32, label %33, label %45, !dbg !1123

33:                                               ; preds = %29
  %34 = load ptr, ptr %5, align 8, !dbg !1124
  %35 = load i32, ptr %10, align 4, !dbg !1126
  %36 = sext i32 %35 to i64, !dbg !1124
  %37 = getelementptr inbounds i8, ptr %34, i64 %36, !dbg !1124
  %38 = load i8, ptr %37, align 1, !dbg !1124
  %39 = sext i8 %38 to i32, !dbg !1124
  %40 = load ptr, ptr @__stdoutp, align 8, !dbg !1127
  %41 = call i32 @fputc(i32 noundef %39, ptr noundef %40), !dbg !1128
  br label %42, !dbg !1129

42:                                               ; preds = %33
  %43 = load i32, ptr %10, align 4, !dbg !1130
  %44 = add nsw i32 %43, 1, !dbg !1130
  store i32 %44, ptr %10, align 4, !dbg !1130
  br label %29, !dbg !1131, !llvm.loop !1132

45:                                               ; preds = %29
  br label %55, !dbg !1133

46:                                               ; preds = %19
  %47 = load ptr, ptr %8, align 8, !dbg !1134
  %48 = load i32, ptr %9, align 4, !dbg !1136
  %49 = sext i32 %48 to i64, !dbg !1134
  %50 = getelementptr inbounds i8, ptr %47, i64 %49, !dbg !1134
  %51 = load i8, ptr %50, align 1, !dbg !1134
  %52 = sext i8 %51 to i32, !dbg !1134
  %53 = load ptr, ptr @__stdoutp, align 8, !dbg !1137
  %54 = call i32 @fputc(i32 noundef %52, ptr noundef %53), !dbg !1138
  br label %55

55:                                               ; preds = %46, %45
  %56 = load i32, ptr %9, align 4, !dbg !1139
  %57 = add nsw i32 %56, 1, !dbg !1140
  store i32 %57, ptr %9, align 4, !dbg !1141
  br label %11, !dbg !1105, !llvm.loop !1142

58:                                               ; preds = %11
  ret void, !dbg !1144
}

declare i32 @fputc(i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @subline(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !1145 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !1148, metadata !DIExpression()), !dbg !1149
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !1150, metadata !DIExpression()), !dbg !1151
  store ptr %2, ptr %6, align 8
  call void @llvm.dbg.declare(metadata ptr %6, metadata !1152, metadata !DIExpression()), !dbg !1153
  call void @llvm.dbg.declare(metadata ptr %7, metadata !1154, metadata !DIExpression()), !dbg !1155
  call void @llvm.dbg.declare(metadata ptr %8, metadata !1156, metadata !DIExpression()), !dbg !1157
  call void @llvm.dbg.declare(metadata ptr %9, metadata !1158, metadata !DIExpression()), !dbg !1159
  store i32 -1, ptr %8, align 4, !dbg !1160
  store i32 0, ptr %7, align 4, !dbg !1161
  br label %10, !dbg !1162

10:                                               ; preds = %55, %3
  %11 = load ptr, ptr %4, align 8, !dbg !1163
  %12 = load i32, ptr %7, align 4, !dbg !1164
  %13 = sext i32 %12 to i64, !dbg !1163
  %14 = getelementptr inbounds i8, ptr %11, i64 %13, !dbg !1163
  %15 = load i8, ptr %14, align 1, !dbg !1163
  %16 = sext i8 %15 to i32, !dbg !1163
  %17 = icmp ne i32 %16, 0, !dbg !1165
  br i1 %17, label %18, label %56, !dbg !1162

18:                                               ; preds = %10
  %19 = load ptr, ptr %4, align 8, !dbg !1166
  %20 = load i32, ptr %7, align 4, !dbg !1168
  %21 = load ptr, ptr %5, align 8, !dbg !1169
  %22 = call i32 @amatch(ptr noundef %19, i32 noundef %20, ptr noundef %21, i32 noundef 0), !dbg !1170
  store i32 %22, ptr %9, align 4, !dbg !1171
  %23 = load i32, ptr %9, align 4, !dbg !1172
  %24 = icmp sge i32 %23, 0, !dbg !1174
  br i1 %24, label %25, label %35, !dbg !1175

25:                                               ; preds = %18
  %26 = load i32, ptr %8, align 4, !dbg !1176
  %27 = load i32, ptr %9, align 4, !dbg !1177
  %28 = icmp ne i32 %26, %27, !dbg !1178
  br i1 %28, label %29, label %35, !dbg !1179

29:                                               ; preds = %25
  %30 = load ptr, ptr %4, align 8, !dbg !1180
  %31 = load i32, ptr %7, align 4, !dbg !1182
  %32 = load i32, ptr %9, align 4, !dbg !1183
  %33 = load ptr, ptr %6, align 8, !dbg !1184
  call void @putsub(ptr noundef %30, i32 noundef %31, i32 noundef %32, ptr noundef %33), !dbg !1185
  %34 = load i32, ptr %9, align 4, !dbg !1186
  store i32 %34, ptr %8, align 4, !dbg !1187
  br label %35, !dbg !1188

35:                                               ; preds = %29, %25, %18
  %36 = load i32, ptr %9, align 4, !dbg !1189
  %37 = icmp eq i32 %36, -1, !dbg !1191
  br i1 %37, label %42, label %38, !dbg !1192

38:                                               ; preds = %35
  %39 = load i32, ptr %9, align 4, !dbg !1193
  %40 = load i32, ptr %7, align 4, !dbg !1194
  %41 = icmp eq i32 %39, %40, !dbg !1195
  br i1 %41, label %42, label %53, !dbg !1196

42:                                               ; preds = %38, %35
  %43 = load ptr, ptr %4, align 8, !dbg !1197
  %44 = load i32, ptr %7, align 4, !dbg !1199
  %45 = sext i32 %44 to i64, !dbg !1197
  %46 = getelementptr inbounds i8, ptr %43, i64 %45, !dbg !1197
  %47 = load i8, ptr %46, align 1, !dbg !1197
  %48 = sext i8 %47 to i32, !dbg !1197
  %49 = load ptr, ptr @__stdoutp, align 8, !dbg !1200
  %50 = call i32 @fputc(i32 noundef %48, ptr noundef %49), !dbg !1201
  %51 = load i32, ptr %7, align 4, !dbg !1202
  %52 = add nsw i32 %51, 1, !dbg !1203
  store i32 %52, ptr %7, align 4, !dbg !1204
  br label %55, !dbg !1205

53:                                               ; preds = %38
  %54 = load i32, ptr %9, align 4, !dbg !1206
  store i32 %54, ptr %7, align 4, !dbg !1207
  br label %55

55:                                               ; preds = %53, %42
  br label %10, !dbg !1162, !llvm.loop !1208

56:                                               ; preds = %10
  ret void, !dbg !1210
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @change(ptr noundef %0, ptr noundef %1) #0 !dbg !1211 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca [100 x i8], align 1
  %6 = alloca i8, align 1
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !1214, metadata !DIExpression()), !dbg !1215
  store ptr %1, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !1216, metadata !DIExpression()), !dbg !1217
  call void @llvm.dbg.declare(metadata ptr %5, metadata !1218, metadata !DIExpression()), !dbg !1223
  call void @llvm.dbg.declare(metadata ptr %6, metadata !1224, metadata !DIExpression()), !dbg !1225
  %7 = getelementptr inbounds [100 x i8], ptr %5, i64 0, i64 0, !dbg !1226
  %8 = call signext i8 @getlines(ptr noundef %7, i32 noundef 100), !dbg !1227
  store i8 %8, ptr %6, align 1, !dbg !1228
  br label %9, !dbg !1229

9:                                                ; preds = %12, %2
  %10 = load i8, ptr %6, align 1, !dbg !1230
  %11 = icmp ne i8 %10, 0, !dbg !1229
  br i1 %11, label %12, label %18, !dbg !1229

12:                                               ; preds = %9
  %13 = getelementptr inbounds [100 x i8], ptr %5, i64 0, i64 0, !dbg !1231
  %14 = load ptr, ptr %3, align 8, !dbg !1233
  %15 = load ptr, ptr %4, align 8, !dbg !1234
  call void @subline(ptr noundef %13, ptr noundef %14, ptr noundef %15), !dbg !1235
  %16 = getelementptr inbounds [100 x i8], ptr %5, i64 0, i64 0, !dbg !1236
  %17 = call signext i8 @getlines(ptr noundef %16, i32 noundef 100), !dbg !1237
  store i8 %17, ptr %6, align 1, !dbg !1238
  br label %9, !dbg !1229, !llvm.loop !1239

18:                                               ; preds = %9
  ret void, !dbg !1241
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main(i32 noundef %0, ptr noundef %1) #0 !dbg !1242 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca [100 x i8], align 1
  %7 = alloca [100 x i8], align 1
  %8 = alloca i8, align 1
  %9 = alloca [12 x [20 x i8]], align 1
  %10 = alloca [20 x [20 x i8]], align 1
  %11 = alloca ptr, align 8
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !1246, metadata !DIExpression()), !dbg !1247
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !1248, metadata !DIExpression()), !dbg !1249
  call void @llvm.dbg.declare(metadata ptr %6, metadata !1250, metadata !DIExpression()), !dbg !1251
  call void @llvm.dbg.declare(metadata ptr %7, metadata !1252, metadata !DIExpression()), !dbg !1253
  call void @llvm.dbg.declare(metadata ptr %8, metadata !1254, metadata !DIExpression()), !dbg !1255
  call void @llvm.dbg.declare(metadata ptr %9, metadata !1256, metadata !DIExpression()), !dbg !1261
  call void @llvm.dbg.declare(metadata ptr %10, metadata !1262, metadata !DIExpression()), !dbg !1265
  call void @llvm.dbg.declare(metadata ptr %11, metadata !1266, metadata !DIExpression()), !dbg !1326
  %15 = load ptr, ptr %5, align 8, !dbg !1327
  %16 = getelementptr inbounds ptr, ptr %15, i64 1, !dbg !1327
  %17 = load ptr, ptr %16, align 8, !dbg !1327
  %18 = call ptr @"\01_fopen"(ptr noundef %17, ptr noundef @.str.2), !dbg !1328
  store ptr %18, ptr %11, align 8, !dbg !1326
  %19 = load ptr, ptr %11, align 8, !dbg !1329
  %20 = icmp ne ptr %19, null, !dbg !1329
  br i1 %20, label %23, label %21, !dbg !1331

21:                                               ; preds = %2
  %22 = call i32 (ptr, ...) @printf(ptr noundef @.str.3), !dbg !1332
  call void @exit(i32 noundef 1) #9, !dbg !1334
  unreachable, !dbg !1334

23:                                               ; preds = %2
  call void @llvm.dbg.declare(metadata ptr %12, metadata !1335, metadata !DIExpression()), !dbg !1336
  store i32 0, ptr %12, align 4, !dbg !1336
  br label %24, !dbg !1337

24:                                               ; preds = %30, %23
  %25 = getelementptr inbounds [12 x [20 x i8]], ptr %9, i64 0, i64 0, !dbg !1338
  %26 = getelementptr inbounds [20 x i8], ptr %25, i64 0, i64 0, !dbg !1338
  %27 = load ptr, ptr %11, align 8, !dbg !1339
  %28 = call ptr @fgets(ptr noundef %26, i32 noundef 240, ptr noundef %27), !dbg !1340
  %29 = icmp ne ptr %28, null, !dbg !1337
  br i1 %29, label %30, label %45, !dbg !1337

30:                                               ; preds = %24
  %31 = load i32, ptr %12, align 4, !dbg !1341
  %32 = sext i32 %31 to i64, !dbg !1341
  %33 = getelementptr inbounds [20 x [20 x i8]], ptr %10, i64 0, i64 %32, !dbg !1341
  %34 = getelementptr inbounds [20 x i8], ptr %33, i64 0, i64 0, !dbg !1341
  %35 = getelementptr inbounds [12 x [20 x i8]], ptr %9, i64 0, i64 0, !dbg !1341
  %36 = getelementptr inbounds [20 x i8], ptr %35, i64 0, i64 0, !dbg !1341
  %37 = load i32, ptr %12, align 4, !dbg !1341
  %38 = sext i32 %37 to i64, !dbg !1341
  %39 = getelementptr inbounds [20 x [20 x i8]], ptr %10, i64 0, i64 %38, !dbg !1341
  %40 = getelementptr inbounds [20 x i8], ptr %39, i64 0, i64 0, !dbg !1341
  %41 = call i64 @llvm.objectsize.i64.p0(ptr %40, i1 false, i1 true, i1 false), !dbg !1341
  %42 = call ptr @__strncpy_chk(ptr noundef %34, ptr noundef %36, i64 noundef 20, i64 noundef %41) #10, !dbg !1341
  %43 = load i32, ptr %12, align 4, !dbg !1343
  %44 = add nsw i32 %43, 1, !dbg !1343
  store i32 %44, ptr %12, align 4, !dbg !1343
  br label %24, !dbg !1337, !llvm.loop !1344

45:                                               ; preds = %24
  call void @llvm.dbg.declare(metadata ptr %13, metadata !1346, metadata !DIExpression()), !dbg !1348
  store i32 0, ptr %13, align 4, !dbg !1348
  br label %46, !dbg !1349

46:                                               ; preds = %59, %45
  %47 = load i32, ptr %13, align 4, !dbg !1350
  %48 = load i32, ptr %12, align 4, !dbg !1352
  %49 = icmp slt i32 %47, %48, !dbg !1353
  br i1 %49, label %50, label %62, !dbg !1354

50:                                               ; preds = %46
  %51 = load i32, ptr %13, align 4, !dbg !1355
  %52 = sext i32 %51 to i64, !dbg !1357
  %53 = getelementptr inbounds [20 x [20 x i8]], ptr %10, i64 0, i64 %52, !dbg !1357
  %54 = load ptr, ptr %5, align 8, !dbg !1358
  %55 = load i32, ptr %13, align 4, !dbg !1359
  %56 = add nsw i32 %55, 1, !dbg !1360
  %57 = sext i32 %56 to i64, !dbg !1358
  %58 = getelementptr inbounds ptr, ptr %54, i64 %57, !dbg !1358
  store ptr %53, ptr %58, align 8, !dbg !1361
  br label %59, !dbg !1362

59:                                               ; preds = %50
  %60 = load i32, ptr %13, align 4, !dbg !1363
  %61 = add nsw i32 %60, 1, !dbg !1363
  store i32 %61, ptr %13, align 4, !dbg !1363
  br label %46, !dbg !1364, !llvm.loop !1365

62:                                               ; preds = %46
  call void @llvm.dbg.declare(metadata ptr %14, metadata !1367, metadata !DIExpression()), !dbg !1369
  store i32 0, ptr %14, align 4, !dbg !1369
  br label %63, !dbg !1370

63:                                               ; preds = %74, %62
  %64 = load i32, ptr %14, align 4, !dbg !1371
  %65 = icmp slt i32 %64, 2, !dbg !1373
  br i1 %65, label %66, label %77, !dbg !1374

66:                                               ; preds = %63
  %67 = load ptr, ptr %5, align 8, !dbg !1375
  %68 = load i32, ptr %14, align 4, !dbg !1377
  %69 = add nsw i32 %68, 1, !dbg !1378
  %70 = sext i32 %69 to i64, !dbg !1375
  %71 = getelementptr inbounds ptr, ptr %67, i64 %70, !dbg !1375
  %72 = load ptr, ptr %71, align 8, !dbg !1375
  %73 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef %72), !dbg !1379
  br label %74, !dbg !1380

74:                                               ; preds = %66
  %75 = load i32, ptr %14, align 4, !dbg !1381
  %76 = add nsw i32 %75, 1, !dbg !1381
  store i32 %76, ptr %14, align 4, !dbg !1381
  br label %63, !dbg !1382, !llvm.loop !1383

77:                                               ; preds = %63
  store i32 2, ptr %4, align 4, !dbg !1385
  %78 = load i32, ptr %4, align 4, !dbg !1386
  %79 = icmp slt i32 %78, 2, !dbg !1388
  br i1 %79, label %80, label %83, !dbg !1389

80:                                               ; preds = %77
  %81 = load ptr, ptr @__stdoutp, align 8, !dbg !1390
  %82 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %81, ptr noundef @.str.5), !dbg !1392
  call void @exit(i32 noundef 1) #9, !dbg !1393
  unreachable, !dbg !1393

83:                                               ; preds = %77
  %84 = load ptr, ptr %5, align 8, !dbg !1394
  %85 = getelementptr inbounds ptr, ptr %84, i64 1, !dbg !1394
  %86 = load ptr, ptr %85, align 8, !dbg !1394
  %87 = getelementptr inbounds [100 x i8], ptr %6, i64 0, i64 0, !dbg !1395
  %88 = call i32 @getpat(ptr noundef %86, ptr noundef %87), !dbg !1396
  %89 = trunc i32 %88 to i8, !dbg !1396
  store i8 %89, ptr %8, align 1, !dbg !1397
  %90 = load i8, ptr %8, align 1, !dbg !1398
  %91 = icmp ne i8 %90, 0, !dbg !1398
  br i1 %91, label %95, label %92, !dbg !1400

92:                                               ; preds = %83
  %93 = load ptr, ptr @__stdoutp, align 8, !dbg !1401
  %94 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %93, ptr noundef @.str.6), !dbg !1403
  call void @exit(i32 noundef 2) #9, !dbg !1404
  unreachable, !dbg !1404

95:                                               ; preds = %83
  %96 = load i32, ptr %4, align 4, !dbg !1405
  %97 = icmp sge i32 %96, 3, !dbg !1407
  br i1 %97, label %98, label %110, !dbg !1408

98:                                               ; preds = %95
  %99 = load ptr, ptr %5, align 8, !dbg !1409
  %100 = getelementptr inbounds ptr, ptr %99, i64 2, !dbg !1409
  %101 = load ptr, ptr %100, align 8, !dbg !1409
  %102 = getelementptr inbounds [100 x i8], ptr %7, i64 0, i64 0, !dbg !1411
  %103 = call signext i8 @getsub(ptr noundef %101, ptr noundef %102), !dbg !1412
  store i8 %103, ptr %8, align 1, !dbg !1413
  %104 = load i8, ptr %8, align 1, !dbg !1414
  %105 = icmp ne i8 %104, 0, !dbg !1414
  br i1 %105, label %109, label %106, !dbg !1416

106:                                              ; preds = %98
  %107 = load ptr, ptr @__stdoutp, align 8, !dbg !1417
  %108 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %107, ptr noundef @.str.7), !dbg !1419
  call void @exit(i32 noundef 3) #9, !dbg !1420
  unreachable, !dbg !1420

109:                                              ; preds = %98
  br label %112, !dbg !1421

110:                                              ; preds = %95
  %111 = getelementptr inbounds [100 x i8], ptr %7, i64 0, i64 0, !dbg !1422
  store i8 0, ptr %111, align 1, !dbg !1424
  br label %112

112:                                              ; preds = %110, %109
  %113 = getelementptr inbounds [100 x i8], ptr %6, i64 0, i64 0, !dbg !1425
  %114 = getelementptr inbounds [100 x i8], ptr %7, i64 0, i64 0, !dbg !1426
  call void @change(ptr noundef %113, ptr noundef %114), !dbg !1427
  ret i32 0, !dbg !1428
}

declare ptr @"\01_fopen"(ptr noundef, ptr noundef) #2

declare i32 @printf(ptr noundef, ...) #2

; Function Attrs: noreturn
declare void @exit(i32 noundef) #5

; Function Attrs: nounwind
declare ptr @__strncpy_chk(ptr noundef, ptr noundef, i64 noundef, i64 noundef) #6

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.objectsize.i64.p0(ptr, i1 immarg, i1 immarg, i1 immarg) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @Caseerror(i32 noundef %0) #0 !dbg !1429 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !1432, metadata !DIExpression()), !dbg !1433
  %3 = load ptr, ptr @__stdoutp, align 8, !dbg !1434
  %4 = load i32, ptr %2, align 4, !dbg !1435
  %5 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %3, ptr noundef @.str.8, i32 noundef %4), !dbg !1436
  call void @exit(i32 noundef 4) #9, !dbg !1437
  unreachable, !dbg !1437
}

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #3 = { nounwind readonly willreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #4 = { cold noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #5 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #6 = { nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #7 = { nounwind readonly willreturn }
attributes #8 = { cold noreturn }
attributes #9 = { noreturn }
attributes #10 = { nounwind }

!llvm.dbg.cu = !{!44}
!llvm.module.flags = !{!49, !50, !51, !52, !53, !54}
!llvm.ident = !{!55}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 345, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "replace_fuzz.c", directory: "XXX/converter/ft_data/source_code/replace")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 200, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 25)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 396, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 208, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 26)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 532, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 24, elements: !15)
!15 = !{!16}
!16 = !DISubrange(count: 3)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !2, line: 534, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 128, elements: !20)
!20 = !{!21}
!21 = !DISubrange(count: 16)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(scope: null, file: !2, line: 549, type: !24, isLocal: true, isDefinition: true)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 32, elements: !25)
!25 = !{!26}
!26 = !DISubrange(count: 4)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(scope: null, file: !2, line: 556, type: !3, isLocal: true, isDefinition: true)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !2, line: 563, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 256, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 32)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !2, line: 572, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 232, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 29)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(scope: null, file: !2, line: 588, type: !41, isLocal: true, isDefinition: true)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 224, elements: !42)
!42 = !{!43}
!43 = !DISubrange(count: 28)
!44 = distinct !DICompileUnit(language: DW_LANG_C99, file: !2, producer: "Homebrew clang version 15.0.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !45, globals: !48, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk", sdk: "MacOSX12.sdk")
!45 = !{!46, !47}
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !2, line: 10, baseType: !4)
!47 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!48 = !{!0, !7, !12, !17, !22, !27, !29, !34, !39}
!49 = !{i32 7, !"Dwarf Version", i32 4}
!50 = !{i32 2, !"Debug Info Version", i32 3}
!51 = !{i32 1, !"wchar_size", i32 4}
!52 = !{i32 7, !"PIC Level", i32 2}
!53 = !{i32 7, !"uwtable", i32 2}
!54 = !{i32 7, !"frame-pointer", i32 1}
!55 = !{!"Homebrew clang version 15.0.3"}
!56 = distinct !DISubprogram(name: "getlines", scope: !2, file: !2, line: 41, type: !57, scopeLine: 44, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!57 = !DISubroutineType(types: !58)
!58 = !{!46, !59, !60}
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!60 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!61 = !{}
!62 = !DILocalVariable(name: "s", arg: 1, scope: !56, file: !2, line: 42, type: !59)
!63 = !DILocation(line: 42, column: 7, scope: !56)
!64 = !DILocalVariable(name: "maxsize", arg: 2, scope: !56, file: !2, line: 43, type: !60)
!65 = !DILocation(line: 43, column: 5, scope: !56)
!66 = !DILocalVariable(name: "result", scope: !56, file: !2, line: 45, type: !59)
!67 = !DILocation(line: 45, column: 11, scope: !56)
!68 = !DILocation(line: 46, column: 20, scope: !56)
!69 = !DILocation(line: 46, column: 23, scope: !56)
!70 = !DILocation(line: 46, column: 32, scope: !56)
!71 = !DILocation(line: 46, column: 14, scope: !56)
!72 = !DILocation(line: 46, column: 12, scope: !56)
!73 = !DILocation(line: 47, column: 13, scope: !56)
!74 = !DILocation(line: 47, column: 20, scope: !56)
!75 = !DILocation(line: 47, column: 12, scope: !56)
!76 = !DILocation(line: 47, column: 5, scope: !56)
!77 = distinct !DISubprogram(name: "addstr", scope: !2, file: !2, line: 50, type: !78, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!78 = !DISubroutineType(types: !79)
!79 = !{!60, !4, !59, !80, !60}
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!81 = !DILocalVariable(name: "c", arg: 1, scope: !77, file: !2, line: 51, type: !4)
!82 = !DILocation(line: 51, column: 6, scope: !77)
!83 = !DILocalVariable(name: "outset", arg: 2, scope: !77, file: !2, line: 52, type: !59)
!84 = !DILocation(line: 52, column: 7, scope: !77)
!85 = !DILocalVariable(name: "j", arg: 3, scope: !77, file: !2, line: 53, type: !80)
!86 = !DILocation(line: 53, column: 6, scope: !77)
!87 = !DILocalVariable(name: "maxset", arg: 4, scope: !77, file: !2, line: 54, type: !60)
!88 = !DILocation(line: 54, column: 5, scope: !77)
!89 = !DILocalVariable(name: "result", scope: !77, file: !2, line: 56, type: !46)
!90 = !DILocation(line: 56, column: 10, scope: !77)
!91 = !DILocation(line: 57, column: 10, scope: !92)
!92 = distinct !DILexicalBlock(scope: !77, file: !2, line: 57, column: 9)
!93 = !DILocation(line: 57, column: 9, scope: !92)
!94 = !DILocation(line: 57, column: 15, scope: !92)
!95 = !DILocation(line: 57, column: 12, scope: !92)
!96 = !DILocation(line: 57, column: 9, scope: !77)
!97 = !DILocation(line: 58, column: 9, scope: !92)
!98 = !DILocation(line: 58, column: 2, scope: !92)
!99 = !DILocation(line: 60, column: 15, scope: !100)
!100 = distinct !DILexicalBlock(scope: !92, file: !2, line: 59, column: 10)
!101 = !DILocation(line: 60, column: 2, scope: !100)
!102 = !DILocation(line: 60, column: 10, scope: !100)
!103 = !DILocation(line: 60, column: 9, scope: !100)
!104 = !DILocation(line: 60, column: 13, scope: !100)
!105 = !DILocation(line: 61, column: 8, scope: !100)
!106 = !DILocation(line: 61, column: 7, scope: !100)
!107 = !DILocation(line: 61, column: 10, scope: !100)
!108 = !DILocation(line: 61, column: 3, scope: !100)
!109 = !DILocation(line: 61, column: 5, scope: !100)
!110 = !DILocation(line: 62, column: 9, scope: !100)
!111 = !DILocation(line: 64, column: 12, scope: !77)
!112 = !DILocation(line: 64, column: 5, scope: !77)
!113 = distinct !DISubprogram(name: "esc", scope: !2, file: !2, line: 68, type: !114, scopeLine: 71, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!114 = !DISubroutineType(types: !115)
!115 = !{!4, !59, !80}
!116 = !DILocalVariable(name: "s", arg: 1, scope: !113, file: !2, line: 69, type: !59)
!117 = !DILocation(line: 69, column: 8, scope: !113)
!118 = !DILocalVariable(name: "i", arg: 2, scope: !113, file: !2, line: 70, type: !80)
!119 = !DILocation(line: 70, column: 6, scope: !113)
!120 = !DILocalVariable(name: "result", scope: !113, file: !2, line: 72, type: !4)
!121 = !DILocation(line: 72, column: 10, scope: !113)
!122 = !DILocation(line: 73, column: 9, scope: !123)
!123 = distinct !DILexicalBlock(scope: !113, file: !2, line: 73, column: 9)
!124 = !DILocation(line: 73, column: 12, scope: !123)
!125 = !DILocation(line: 73, column: 11, scope: !123)
!126 = !DILocation(line: 73, column: 15, scope: !123)
!127 = !DILocation(line: 73, column: 9, scope: !113)
!128 = !DILocation(line: 74, column: 11, scope: !123)
!129 = !DILocation(line: 74, column: 14, scope: !123)
!130 = !DILocation(line: 74, column: 13, scope: !123)
!131 = !DILocation(line: 74, column: 9, scope: !123)
!132 = !DILocation(line: 74, column: 2, scope: !123)
!133 = !DILocation(line: 76, column: 6, scope: !134)
!134 = distinct !DILexicalBlock(scope: !123, file: !2, line: 76, column: 6)
!135 = !DILocation(line: 76, column: 9, scope: !134)
!136 = !DILocation(line: 76, column: 8, scope: !134)
!137 = !DILocation(line: 76, column: 11, scope: !134)
!138 = !DILocation(line: 76, column: 16, scope: !134)
!139 = !DILocation(line: 76, column: 6, scope: !123)
!140 = !DILocation(line: 77, column: 13, scope: !134)
!141 = !DILocation(line: 77, column: 6, scope: !134)
!142 = !DILocation(line: 80, column: 12, scope: !143)
!143 = distinct !DILexicalBlock(scope: !134, file: !2, line: 79, column: 2)
!144 = !DILocation(line: 80, column: 11, scope: !143)
!145 = !DILocation(line: 80, column: 14, scope: !143)
!146 = !DILocation(line: 80, column: 7, scope: !143)
!147 = !DILocation(line: 80, column: 9, scope: !143)
!148 = !DILocation(line: 81, column: 10, scope: !149)
!149 = distinct !DILexicalBlock(scope: !143, file: !2, line: 81, column: 10)
!150 = !DILocation(line: 81, column: 13, scope: !149)
!151 = !DILocation(line: 81, column: 12, scope: !149)
!152 = !DILocation(line: 81, column: 16, scope: !149)
!153 = !DILocation(line: 81, column: 10, scope: !143)
!154 = !DILocation(line: 82, column: 10, scope: !149)
!155 = !DILocation(line: 82, column: 3, scope: !149)
!156 = !DILocation(line: 84, column: 7, scope: !157)
!157 = distinct !DILexicalBlock(scope: !149, file: !2, line: 84, column: 7)
!158 = !DILocation(line: 84, column: 10, scope: !157)
!159 = !DILocation(line: 84, column: 9, scope: !157)
!160 = !DILocation(line: 84, column: 13, scope: !157)
!161 = !DILocation(line: 84, column: 7, scope: !149)
!162 = !DILocation(line: 85, column: 14, scope: !157)
!163 = !DILocation(line: 85, column: 7, scope: !157)
!164 = !DILocation(line: 87, column: 16, scope: !157)
!165 = !DILocation(line: 87, column: 19, scope: !157)
!166 = !DILocation(line: 87, column: 18, scope: !157)
!167 = !DILocation(line: 87, column: 14, scope: !157)
!168 = !DILocation(line: 89, column: 12, scope: !113)
!169 = !DILocation(line: 89, column: 5, scope: !113)
!170 = distinct !DISubprogram(name: "dodash", scope: !2, file: !2, line: 95, type: !171, scopeLine: 102, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!171 = !DISubroutineType(types: !172)
!172 = !{null, !4, !59, !80, !59, !80, !60}
!173 = !DILocalVariable(name: "delim", arg: 1, scope: !170, file: !2, line: 96, type: !4)
!174 = !DILocation(line: 96, column: 6, scope: !170)
!175 = !DILocalVariable(name: "src", arg: 2, scope: !170, file: !2, line: 97, type: !59)
!176 = !DILocation(line: 97, column: 7, scope: !170)
!177 = !DILocalVariable(name: "i", arg: 3, scope: !170, file: !2, line: 98, type: !80)
!178 = !DILocation(line: 98, column: 6, scope: !170)
!179 = !DILocalVariable(name: "dest", arg: 4, scope: !170, file: !2, line: 99, type: !59)
!180 = !DILocation(line: 99, column: 7, scope: !170)
!181 = !DILocalVariable(name: "j", arg: 5, scope: !170, file: !2, line: 100, type: !80)
!182 = !DILocation(line: 100, column: 6, scope: !170)
!183 = !DILocalVariable(name: "maxset", arg: 6, scope: !170, file: !2, line: 101, type: !60)
!184 = !DILocation(line: 101, column: 5, scope: !170)
!185 = !DILocalVariable(name: "k", scope: !170, file: !2, line: 103, type: !60)
!186 = !DILocation(line: 103, column: 9, scope: !170)
!187 = !DILocalVariable(name: "junk", scope: !170, file: !2, line: 104, type: !46)
!188 = !DILocation(line: 104, column: 10, scope: !170)
!189 = !DILocalVariable(name: "escjunk", scope: !170, file: !2, line: 105, type: !4)
!190 = !DILocation(line: 105, column: 10, scope: !170)
!191 = !DILocation(line: 107, column: 5, scope: !170)
!192 = !DILocation(line: 107, column: 13, scope: !170)
!193 = !DILocation(line: 107, column: 18, scope: !170)
!194 = !DILocation(line: 107, column: 17, scope: !170)
!195 = !DILocation(line: 107, column: 24, scope: !170)
!196 = !DILocation(line: 107, column: 21, scope: !170)
!197 = !DILocation(line: 107, column: 31, scope: !170)
!198 = !DILocation(line: 107, column: 35, scope: !170)
!199 = !DILocation(line: 107, column: 40, scope: !170)
!200 = !DILocation(line: 107, column: 39, scope: !170)
!201 = !DILocation(line: 107, column: 43, scope: !170)
!202 = !DILocation(line: 0, scope: !170)
!203 = !DILocation(line: 109, column: 6, scope: !204)
!204 = distinct !DILexicalBlock(scope: !205, file: !2, line: 109, column: 6)
!205 = distinct !DILexicalBlock(scope: !170, file: !2, line: 108, column: 5)
!206 = !DILocation(line: 109, column: 11, scope: !204)
!207 = !DILocation(line: 109, column: 10, scope: !204)
!208 = !DILocation(line: 109, column: 13, scope: !204)
!209 = !DILocation(line: 109, column: 18, scope: !204)
!210 = !DILocation(line: 109, column: 6, scope: !205)
!211 = !DILocation(line: 110, column: 20, scope: !212)
!212 = distinct !DILexicalBlock(scope: !204, file: !2, line: 109, column: 29)
!213 = !DILocation(line: 110, column: 25, scope: !212)
!214 = !DILocation(line: 110, column: 16, scope: !212)
!215 = !DILocation(line: 110, column: 14, scope: !212)
!216 = !DILocation(line: 111, column: 20, scope: !212)
!217 = !DILocation(line: 111, column: 29, scope: !212)
!218 = !DILocation(line: 111, column: 35, scope: !212)
!219 = !DILocation(line: 111, column: 38, scope: !212)
!220 = !DILocation(line: 111, column: 13, scope: !212)
!221 = !DILocation(line: 111, column: 11, scope: !212)
!222 = !DILocation(line: 112, column: 2, scope: !212)
!223 = !DILocation(line: 113, column: 10, scope: !224)
!224 = distinct !DILexicalBlock(scope: !204, file: !2, line: 113, column: 10)
!225 = !DILocation(line: 113, column: 15, scope: !224)
!226 = !DILocation(line: 113, column: 14, scope: !224)
!227 = !DILocation(line: 113, column: 18, scope: !224)
!228 = !DILocation(line: 113, column: 10, scope: !204)
!229 = !DILocation(line: 114, column: 17, scope: !224)
!230 = !DILocation(line: 114, column: 22, scope: !224)
!231 = !DILocation(line: 114, column: 21, scope: !224)
!232 = !DILocation(line: 114, column: 26, scope: !224)
!233 = !DILocation(line: 114, column: 32, scope: !224)
!234 = !DILocation(line: 114, column: 35, scope: !224)
!235 = !DILocation(line: 114, column: 10, scope: !224)
!236 = !DILocation(line: 114, column: 8, scope: !224)
!237 = !DILocation(line: 114, column: 3, scope: !224)
!238 = !DILocation(line: 115, column: 16, scope: !239)
!239 = distinct !DILexicalBlock(scope: !224, file: !2, line: 115, column: 15)
!240 = !DILocation(line: 115, column: 15, scope: !239)
!241 = !DILocation(line: 115, column: 18, scope: !239)
!242 = !DILocation(line: 115, column: 23, scope: !239)
!243 = !DILocation(line: 115, column: 26, scope: !239)
!244 = !DILocation(line: 115, column: 31, scope: !239)
!245 = !DILocation(line: 115, column: 30, scope: !239)
!246 = !DILocation(line: 115, column: 33, scope: !239)
!247 = !DILocation(line: 115, column: 38, scope: !239)
!248 = !DILocation(line: 115, column: 15, scope: !224)
!249 = !DILocation(line: 116, column: 23, scope: !239)
!250 = !DILocation(line: 116, column: 29, scope: !239)
!251 = !DILocation(line: 116, column: 32, scope: !239)
!252 = !DILocation(line: 116, column: 10, scope: !239)
!253 = !DILocation(line: 116, column: 8, scope: !239)
!254 = !DILocation(line: 116, column: 3, scope: !239)
!255 = !DILocation(line: 117, column: 24, scope: !256)
!256 = distinct !DILexicalBlock(scope: !239, file: !2, line: 117, column: 15)
!257 = !DILocation(line: 117, column: 29, scope: !256)
!258 = !DILocation(line: 117, column: 28, scope: !256)
!259 = !DILocation(line: 117, column: 31, scope: !256)
!260 = !DILocation(line: 117, column: 16, scope: !256)
!261 = !DILocation(line: 117, column: 38, scope: !256)
!262 = !DILocation(line: 117, column: 50, scope: !256)
!263 = !DILocation(line: 117, column: 55, scope: !256)
!264 = !DILocation(line: 117, column: 54, scope: !256)
!265 = !DILocation(line: 117, column: 57, scope: !256)
!266 = !DILocation(line: 117, column: 42, scope: !256)
!267 = !DILocation(line: 118, column: 3, scope: !256)
!268 = !DILocation(line: 118, column: 7, scope: !256)
!269 = !DILocation(line: 118, column: 12, scope: !256)
!270 = !DILocation(line: 118, column: 11, scope: !256)
!271 = !DILocation(line: 118, column: 14, scope: !256)
!272 = !DILocation(line: 118, column: 22, scope: !256)
!273 = !DILocation(line: 118, column: 27, scope: !256)
!274 = !DILocation(line: 118, column: 26, scope: !256)
!275 = !DILocation(line: 118, column: 29, scope: !256)
!276 = !DILocation(line: 118, column: 19, scope: !256)
!277 = !DILocation(line: 117, column: 15, scope: !239)
!278 = !DILocation(line: 120, column: 16, scope: !279)
!279 = distinct !DILexicalBlock(scope: !280, file: !2, line: 120, column: 7)
!280 = distinct !DILexicalBlock(scope: !256, file: !2, line: 119, column: 3)
!281 = !DILocation(line: 120, column: 21, scope: !279)
!282 = !DILocation(line: 120, column: 20, scope: !279)
!283 = !DILocation(line: 120, column: 22, scope: !279)
!284 = !DILocation(line: 120, column: 25, scope: !279)
!285 = !DILocation(line: 120, column: 14, scope: !279)
!286 = !DILocation(line: 120, column: 12, scope: !279)
!287 = !DILocation(line: 120, column: 29, scope: !288)
!288 = distinct !DILexicalBlock(scope: !279, file: !2, line: 120, column: 7)
!289 = !DILocation(line: 120, column: 32, scope: !288)
!290 = !DILocation(line: 120, column: 37, scope: !288)
!291 = !DILocation(line: 120, column: 36, scope: !288)
!292 = !DILocation(line: 120, column: 38, scope: !288)
!293 = !DILocation(line: 120, column: 30, scope: !288)
!294 = !DILocation(line: 120, column: 7, scope: !279)
!295 = !DILocation(line: 122, column: 18, scope: !296)
!296 = distinct !DILexicalBlock(scope: !288, file: !2, line: 121, column: 7)
!297 = !DILocation(line: 122, column: 21, scope: !296)
!298 = !DILocation(line: 122, column: 27, scope: !296)
!299 = !DILocation(line: 122, column: 30, scope: !296)
!300 = !DILocation(line: 122, column: 11, scope: !296)
!301 = !DILocation(line: 122, column: 9, scope: !296)
!302 = !DILocation(line: 123, column: 7, scope: !296)
!303 = !DILocation(line: 120, column: 44, scope: !288)
!304 = !DILocation(line: 120, column: 7, scope: !288)
!305 = distinct !{!305, !294, !306, !307}
!306 = !DILocation(line: 123, column: 7, scope: !279)
!307 = !{!"llvm.loop.mustprogress"}
!308 = !DILocation(line: 124, column: 13, scope: !280)
!309 = !DILocation(line: 124, column: 12, scope: !280)
!310 = !DILocation(line: 124, column: 15, scope: !280)
!311 = !DILocation(line: 124, column: 8, scope: !280)
!312 = !DILocation(line: 124, column: 10, scope: !280)
!313 = !DILocation(line: 125, column: 3, scope: !280)
!314 = !DILocation(line: 127, column: 23, scope: !256)
!315 = !DILocation(line: 127, column: 29, scope: !256)
!316 = !DILocation(line: 127, column: 32, scope: !256)
!317 = !DILocation(line: 127, column: 10, scope: !256)
!318 = !DILocation(line: 127, column: 8, scope: !256)
!319 = !DILocation(line: 128, column: 11, scope: !205)
!320 = !DILocation(line: 128, column: 10, scope: !205)
!321 = !DILocation(line: 128, column: 14, scope: !205)
!322 = !DILocation(line: 128, column: 4, scope: !205)
!323 = !DILocation(line: 128, column: 7, scope: !205)
!324 = distinct !{!324, !191, !325, !307}
!325 = !DILocation(line: 129, column: 5, scope: !170)
!326 = !DILocation(line: 130, column: 1, scope: !170)
!327 = distinct !DISubprogram(name: "getccl", scope: !2, file: !2, line: 133, type: !328, scopeLine: 138, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!328 = !DISubroutineType(types: !329)
!329 = !{!46, !59, !80, !59, !80}
!330 = !DILocalVariable(name: "arg", arg: 1, scope: !327, file: !2, line: 134, type: !59)
!331 = !DILocation(line: 134, column: 7, scope: !327)
!332 = !DILocalVariable(name: "i", arg: 2, scope: !327, file: !2, line: 135, type: !80)
!333 = !DILocation(line: 135, column: 6, scope: !327)
!334 = !DILocalVariable(name: "pat", arg: 3, scope: !327, file: !2, line: 136, type: !59)
!335 = !DILocation(line: 136, column: 7, scope: !327)
!336 = !DILocalVariable(name: "j", arg: 4, scope: !327, file: !2, line: 137, type: !80)
!337 = !DILocation(line: 137, column: 6, scope: !327)
!338 = !DILocalVariable(name: "jstart", scope: !327, file: !2, line: 139, type: !60)
!339 = !DILocation(line: 139, column: 9, scope: !327)
!340 = !DILocalVariable(name: "junk", scope: !327, file: !2, line: 140, type: !46)
!341 = !DILocation(line: 140, column: 10, scope: !327)
!342 = !DILocation(line: 142, column: 11, scope: !327)
!343 = !DILocation(line: 142, column: 10, scope: !327)
!344 = !DILocation(line: 142, column: 13, scope: !327)
!345 = !DILocation(line: 142, column: 6, scope: !327)
!346 = !DILocation(line: 142, column: 8, scope: !327)
!347 = !DILocation(line: 143, column: 9, scope: !348)
!348 = distinct !DILexicalBlock(scope: !327, file: !2, line: 143, column: 9)
!349 = !DILocation(line: 143, column: 14, scope: !348)
!350 = !DILocation(line: 143, column: 13, scope: !348)
!351 = !DILocation(line: 143, column: 17, scope: !348)
!352 = !DILocation(line: 143, column: 9, scope: !327)
!353 = !DILocation(line: 144, column: 22, scope: !354)
!354 = distinct !DILexicalBlock(scope: !348, file: !2, line: 143, column: 28)
!355 = !DILocation(line: 144, column: 27, scope: !354)
!356 = !DILocation(line: 144, column: 9, scope: !354)
!357 = !DILocation(line: 144, column: 7, scope: !354)
!358 = !DILocation(line: 145, column: 8, scope: !354)
!359 = !DILocation(line: 145, column: 7, scope: !354)
!360 = !DILocation(line: 145, column: 10, scope: !354)
!361 = !DILocation(line: 145, column: 3, scope: !354)
!362 = !DILocation(line: 145, column: 5, scope: !354)
!363 = !DILocation(line: 146, column: 5, scope: !354)
!364 = !DILocation(line: 147, column: 21, scope: !348)
!365 = !DILocation(line: 147, column: 26, scope: !348)
!366 = !DILocation(line: 147, column: 9, scope: !348)
!367 = !DILocation(line: 147, column: 7, scope: !348)
!368 = !DILocation(line: 148, column: 15, scope: !327)
!369 = !DILocation(line: 148, column: 14, scope: !327)
!370 = !DILocation(line: 148, column: 12, scope: !327)
!371 = !DILocation(line: 149, column: 22, scope: !327)
!372 = !DILocation(line: 149, column: 27, scope: !327)
!373 = !DILocation(line: 149, column: 12, scope: !327)
!374 = !DILocation(line: 149, column: 10, scope: !327)
!375 = !DILocation(line: 150, column: 20, scope: !327)
!376 = !DILocation(line: 150, column: 25, scope: !327)
!377 = !DILocation(line: 150, column: 28, scope: !327)
!378 = !DILocation(line: 150, column: 33, scope: !327)
!379 = !DILocation(line: 150, column: 5, scope: !327)
!380 = !DILocation(line: 151, column: 20, scope: !327)
!381 = !DILocation(line: 151, column: 19, scope: !327)
!382 = !DILocation(line: 151, column: 24, scope: !327)
!383 = !DILocation(line: 151, column: 22, scope: !327)
!384 = !DILocation(line: 151, column: 31, scope: !327)
!385 = !DILocation(line: 151, column: 5, scope: !327)
!386 = !DILocation(line: 151, column: 9, scope: !327)
!387 = !DILocation(line: 151, column: 17, scope: !327)
!388 = !DILocation(line: 152, column: 13, scope: !327)
!389 = !DILocation(line: 152, column: 18, scope: !327)
!390 = !DILocation(line: 152, column: 17, scope: !327)
!391 = !DILocation(line: 152, column: 21, scope: !327)
!392 = !DILocation(line: 152, column: 12, scope: !327)
!393 = !DILocation(line: 152, column: 5, scope: !327)
!394 = distinct !DISubprogram(name: "stclose", scope: !2, file: !2, line: 156, type: !395, scopeLine: 160, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!395 = !DISubroutineType(types: !396)
!396 = !{null, !59, !80, !60}
!397 = !DILocalVariable(name: "pat", arg: 1, scope: !394, file: !2, line: 157, type: !59)
!398 = !DILocation(line: 157, column: 7, scope: !394)
!399 = !DILocalVariable(name: "j", arg: 2, scope: !394, file: !2, line: 158, type: !80)
!400 = !DILocation(line: 158, column: 6, scope: !394)
!401 = !DILocalVariable(name: "lastj", arg: 3, scope: !394, file: !2, line: 159, type: !60)
!402 = !DILocation(line: 159, column: 5, scope: !394)
!403 = !DILocalVariable(name: "jt", scope: !394, file: !2, line: 161, type: !60)
!404 = !DILocation(line: 161, column: 9, scope: !394)
!405 = !DILocalVariable(name: "jp", scope: !394, file: !2, line: 162, type: !60)
!406 = !DILocation(line: 162, column: 9, scope: !394)
!407 = !DILocalVariable(name: "junk", scope: !394, file: !2, line: 163, type: !46)
!408 = !DILocation(line: 163, column: 10, scope: !394)
!409 = !DILocation(line: 166, column: 16, scope: !410)
!410 = distinct !DILexicalBlock(scope: !394, file: !2, line: 166, column: 5)
!411 = !DILocation(line: 166, column: 15, scope: !410)
!412 = !DILocation(line: 166, column: 18, scope: !410)
!413 = !DILocation(line: 166, column: 13, scope: !410)
!414 = !DILocation(line: 166, column: 10, scope: !410)
!415 = !DILocation(line: 166, column: 23, scope: !416)
!416 = distinct !DILexicalBlock(scope: !410, file: !2, line: 166, column: 5)
!417 = !DILocation(line: 166, column: 29, scope: !416)
!418 = !DILocation(line: 166, column: 26, scope: !416)
!419 = !DILocation(line: 166, column: 5, scope: !410)
!420 = !DILocation(line: 168, column: 7, scope: !421)
!421 = distinct !DILexicalBlock(scope: !416, file: !2, line: 167, column: 5)
!422 = !DILocation(line: 168, column: 10, scope: !421)
!423 = !DILocation(line: 168, column: 5, scope: !421)
!424 = !DILocation(line: 169, column: 16, scope: !421)
!425 = !DILocation(line: 169, column: 20, scope: !421)
!426 = !DILocation(line: 169, column: 25, scope: !421)
!427 = !DILocation(line: 169, column: 9, scope: !421)
!428 = !DILocation(line: 169, column: 7, scope: !421)
!429 = !DILocation(line: 170, column: 5, scope: !421)
!430 = !DILocation(line: 166, column: 39, scope: !416)
!431 = !DILocation(line: 166, column: 5, scope: !416)
!432 = distinct !{!432, !419, !433, !307}
!433 = !DILocation(line: 170, column: 5, scope: !410)
!434 = !DILocation(line: 171, column: 11, scope: !394)
!435 = !DILocation(line: 171, column: 10, scope: !394)
!436 = !DILocation(line: 171, column: 13, scope: !394)
!437 = !DILocation(line: 171, column: 6, scope: !394)
!438 = !DILocation(line: 171, column: 8, scope: !394)
!439 = !DILocation(line: 172, column: 5, scope: !394)
!440 = !DILocation(line: 172, column: 9, scope: !394)
!441 = !DILocation(line: 172, column: 16, scope: !394)
!442 = !DILocation(line: 173, column: 1, scope: !394)
!443 = distinct !DISubprogram(name: "in_set_2", scope: !2, file: !2, line: 175, type: !444, scopeLine: 177, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!444 = !DISubroutineType(types: !445)
!445 = !{!46, !4}
!446 = !DILocalVariable(name: "c", arg: 1, scope: !443, file: !2, line: 176, type: !4)
!447 = !DILocation(line: 176, column: 6, scope: !443)
!448 = !DILocation(line: 178, column: 11, scope: !443)
!449 = !DILocation(line: 178, column: 13, scope: !443)
!450 = !DILocation(line: 178, column: 20, scope: !443)
!451 = !DILocation(line: 178, column: 23, scope: !443)
!452 = !DILocation(line: 178, column: 25, scope: !443)
!453 = !DILocation(line: 178, column: 32, scope: !443)
!454 = !DILocation(line: 178, column: 35, scope: !443)
!455 = !DILocation(line: 178, column: 37, scope: !443)
!456 = !DILocation(line: 178, column: 10, scope: !443)
!457 = !DILocation(line: 178, column: 3, scope: !443)
!458 = distinct !DISubprogram(name: "in_pat_set", scope: !2, file: !2, line: 181, type: !444, scopeLine: 183, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!459 = !DILocalVariable(name: "c", arg: 1, scope: !458, file: !2, line: 182, type: !4)
!460 = !DILocation(line: 182, column: 6, scope: !458)
!461 = !DILocation(line: 184, column: 14, scope: !458)
!462 = !DILocation(line: 184, column: 16, scope: !458)
!463 = !DILocation(line: 184, column: 27, scope: !458)
!464 = !DILocation(line: 184, column: 30, scope: !458)
!465 = !DILocation(line: 184, column: 32, scope: !458)
!466 = !DILocation(line: 184, column: 40, scope: !458)
!467 = !DILocation(line: 184, column: 43, scope: !458)
!468 = !DILocation(line: 184, column: 45, scope: !458)
!469 = !DILocation(line: 184, column: 52, scope: !458)
!470 = !DILocation(line: 184, column: 55, scope: !458)
!471 = !DILocation(line: 184, column: 57, scope: !458)
!472 = !DILocation(line: 185, column: 11, scope: !458)
!473 = !DILocation(line: 185, column: 14, scope: !458)
!474 = !DILocation(line: 185, column: 16, scope: !458)
!475 = !DILocation(line: 185, column: 27, scope: !458)
!476 = !DILocation(line: 185, column: 30, scope: !458)
!477 = !DILocation(line: 185, column: 32, scope: !458)
!478 = !DILocation(line: 185, column: 40, scope: !458)
!479 = !DILocation(line: 185, column: 43, scope: !458)
!480 = !DILocation(line: 185, column: 45, scope: !458)
!481 = !DILocation(line: 184, column: 10, scope: !458)
!482 = !DILocation(line: 184, column: 3, scope: !458)
!483 = distinct !DISubprogram(name: "makepat", scope: !2, file: !2, line: 189, type: !484, scopeLine: 194, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!484 = !DISubroutineType(types: !485)
!485 = !{!60, !59, !60, !4, !59}
!486 = !DILocalVariable(name: "arg", arg: 1, scope: !483, file: !2, line: 190, type: !59)
!487 = !DILocation(line: 190, column: 7, scope: !483)
!488 = !DILocalVariable(name: "start", arg: 2, scope: !483, file: !2, line: 191, type: !60)
!489 = !DILocation(line: 191, column: 5, scope: !483)
!490 = !DILocalVariable(name: "delim", arg: 3, scope: !483, file: !2, line: 192, type: !4)
!491 = !DILocation(line: 192, column: 6, scope: !483)
!492 = !DILocalVariable(name: "pat", arg: 4, scope: !483, file: !2, line: 193, type: !59)
!493 = !DILocation(line: 193, column: 7, scope: !483)
!494 = !DILocalVariable(name: "result", scope: !483, file: !2, line: 195, type: !60)
!495 = !DILocation(line: 195, column: 9, scope: !483)
!496 = !DILocalVariable(name: "i", scope: !483, file: !2, line: 196, type: !60)
!497 = !DILocation(line: 196, column: 9, scope: !483)
!498 = !DILocalVariable(name: "j", scope: !483, file: !2, line: 196, type: !60)
!499 = !DILocation(line: 196, column: 12, scope: !483)
!500 = !DILocalVariable(name: "lastj", scope: !483, file: !2, line: 196, type: !60)
!501 = !DILocation(line: 196, column: 15, scope: !483)
!502 = !DILocalVariable(name: "lj", scope: !483, file: !2, line: 196, type: !60)
!503 = !DILocation(line: 196, column: 22, scope: !483)
!504 = !DILocalVariable(name: "done", scope: !483, file: !2, line: 197, type: !46)
!505 = !DILocation(line: 197, column: 10, scope: !483)
!506 = !DILocalVariable(name: "junk", scope: !483, file: !2, line: 197, type: !46)
!507 = !DILocation(line: 197, column: 16, scope: !483)
!508 = !DILocalVariable(name: "getres", scope: !483, file: !2, line: 198, type: !46)
!509 = !DILocation(line: 198, column: 10, scope: !483)
!510 = !DILocalVariable(name: "escjunk", scope: !483, file: !2, line: 199, type: !4)
!511 = !DILocation(line: 199, column: 10, scope: !483)
!512 = !DILocation(line: 201, column: 7, scope: !483)
!513 = !DILocation(line: 202, column: 9, scope: !483)
!514 = !DILocation(line: 202, column: 7, scope: !483)
!515 = !DILocation(line: 203, column: 11, scope: !483)
!516 = !DILocation(line: 204, column: 10, scope: !483)
!517 = !DILocation(line: 205, column: 5, scope: !483)
!518 = !DILocation(line: 205, column: 14, scope: !483)
!519 = !DILocation(line: 205, column: 20, scope: !483)
!520 = !DILocation(line: 205, column: 24, scope: !483)
!521 = !DILocation(line: 205, column: 28, scope: !483)
!522 = !DILocation(line: 205, column: 34, scope: !483)
!523 = !DILocation(line: 205, column: 31, scope: !483)
!524 = !DILocation(line: 205, column: 41, scope: !483)
!525 = !DILocation(line: 205, column: 45, scope: !483)
!526 = !DILocation(line: 205, column: 49, scope: !483)
!527 = !DILocation(line: 205, column: 52, scope: !483)
!528 = !DILocation(line: 0, scope: !483)
!529 = !DILocation(line: 206, column: 7, scope: !530)
!530 = distinct !DILexicalBlock(scope: !483, file: !2, line: 205, column: 64)
!531 = !DILocation(line: 206, column: 5, scope: !530)
!532 = !DILocation(line: 207, column: 7, scope: !533)
!533 = distinct !DILexicalBlock(scope: !530, file: !2, line: 207, column: 6)
!534 = !DILocation(line: 207, column: 11, scope: !533)
!535 = !DILocation(line: 207, column: 14, scope: !533)
!536 = !DILocation(line: 207, column: 6, scope: !530)
!537 = !DILocation(line: 208, column: 25, scope: !533)
!538 = !DILocation(line: 208, column: 13, scope: !533)
!539 = !DILocation(line: 208, column: 11, scope: !533)
!540 = !DILocation(line: 208, column: 6, scope: !533)
!541 = !DILocation(line: 209, column: 12, scope: !542)
!542 = distinct !DILexicalBlock(scope: !533, file: !2, line: 209, column: 11)
!543 = !DILocation(line: 209, column: 16, scope: !542)
!544 = !DILocation(line: 209, column: 19, scope: !542)
!545 = !DILocation(line: 209, column: 27, scope: !542)
!546 = !DILocation(line: 209, column: 31, scope: !542)
!547 = !DILocation(line: 209, column: 36, scope: !542)
!548 = !DILocation(line: 209, column: 33, scope: !542)
!549 = !DILocation(line: 209, column: 11, scope: !533)
!550 = !DILocation(line: 210, column: 25, scope: !542)
!551 = !DILocation(line: 210, column: 13, scope: !542)
!552 = !DILocation(line: 210, column: 11, scope: !542)
!553 = !DILocation(line: 210, column: 6, scope: !542)
!554 = !DILocation(line: 211, column: 12, scope: !555)
!555 = distinct !DILexicalBlock(scope: !542, file: !2, line: 211, column: 11)
!556 = !DILocation(line: 211, column: 16, scope: !555)
!557 = !DILocation(line: 211, column: 19, scope: !555)
!558 = !DILocation(line: 211, column: 27, scope: !555)
!559 = !DILocation(line: 211, column: 31, scope: !555)
!560 = !DILocation(line: 211, column: 35, scope: !555)
!561 = !DILocation(line: 211, column: 36, scope: !555)
!562 = !DILocation(line: 211, column: 43, scope: !555)
!563 = !DILocation(line: 211, column: 40, scope: !555)
!564 = !DILocation(line: 211, column: 11, scope: !542)
!565 = !DILocation(line: 212, column: 25, scope: !555)
!566 = !DILocation(line: 212, column: 13, scope: !555)
!567 = !DILocation(line: 212, column: 11, scope: !555)
!568 = !DILocation(line: 212, column: 6, scope: !555)
!569 = !DILocation(line: 213, column: 12, scope: !570)
!570 = distinct !DILexicalBlock(scope: !555, file: !2, line: 213, column: 11)
!571 = !DILocation(line: 213, column: 16, scope: !570)
!572 = !DILocation(line: 213, column: 19, scope: !570)
!573 = !DILocation(line: 213, column: 11, scope: !555)
!574 = !DILocation(line: 215, column: 22, scope: !575)
!575 = distinct !DILexicalBlock(scope: !570, file: !2, line: 214, column: 2)
!576 = !DILocation(line: 215, column: 31, scope: !575)
!577 = !DILocation(line: 215, column: 15, scope: !575)
!578 = !DILocation(line: 215, column: 13, scope: !575)
!579 = !DILocation(line: 216, column: 20, scope: !575)
!580 = !DILocation(line: 216, column: 27, scope: !575)
!581 = !DILocation(line: 216, column: 13, scope: !575)
!582 = !DILocation(line: 216, column: 11, scope: !575)
!583 = !DILocation(line: 217, column: 2, scope: !575)
!584 = !DILocation(line: 218, column: 12, scope: !585)
!585 = distinct !DILexicalBlock(scope: !570, file: !2, line: 218, column: 11)
!586 = !DILocation(line: 218, column: 16, scope: !585)
!587 = !DILocation(line: 218, column: 19, scope: !585)
!588 = !DILocation(line: 218, column: 31, scope: !585)
!589 = !DILocation(line: 218, column: 35, scope: !585)
!590 = !DILocation(line: 218, column: 39, scope: !585)
!591 = !DILocation(line: 218, column: 37, scope: !585)
!592 = !DILocation(line: 218, column: 11, scope: !570)
!593 = !DILocation(line: 220, column: 11, scope: !594)
!594 = distinct !DILexicalBlock(scope: !585, file: !2, line: 219, column: 2)
!595 = !DILocation(line: 220, column: 9, scope: !594)
!596 = !DILocation(line: 221, column: 19, scope: !597)
!597 = distinct !DILexicalBlock(scope: !594, file: !2, line: 221, column: 10)
!598 = !DILocation(line: 221, column: 23, scope: !597)
!599 = !DILocation(line: 221, column: 10, scope: !597)
!600 = !DILocation(line: 221, column: 10, scope: !594)
!601 = !DILocation(line: 222, column: 8, scope: !597)
!602 = !DILocation(line: 222, column: 3, scope: !597)
!603 = !DILocation(line: 224, column: 11, scope: !597)
!604 = !DILocation(line: 224, column: 20, scope: !597)
!605 = !DILocation(line: 224, column: 3, scope: !597)
!606 = !DILocation(line: 225, column: 2, scope: !594)
!607 = !DILocation(line: 228, column: 29, scope: !608)
!608 = distinct !DILexicalBlock(scope: !585, file: !2, line: 227, column: 2)
!609 = !DILocation(line: 228, column: 13, scope: !608)
!610 = !DILocation(line: 228, column: 11, scope: !608)
!611 = !DILocation(line: 229, column: 20, scope: !608)
!612 = !DILocation(line: 229, column: 16, scope: !608)
!613 = !DILocation(line: 229, column: 14, scope: !608)
!614 = !DILocation(line: 230, column: 20, scope: !608)
!615 = !DILocation(line: 230, column: 29, scope: !608)
!616 = !DILocation(line: 230, column: 13, scope: !608)
!617 = !DILocation(line: 230, column: 11, scope: !608)
!618 = !DILocation(line: 232, column: 10, scope: !530)
!619 = !DILocation(line: 232, column: 8, scope: !530)
!620 = !DILocation(line: 233, column: 8, scope: !621)
!621 = distinct !DILexicalBlock(scope: !530, file: !2, line: 233, column: 6)
!622 = !DILocation(line: 233, column: 6, scope: !530)
!623 = !DILocation(line: 234, column: 10, scope: !621)
!624 = !DILocation(line: 234, column: 12, scope: !621)
!625 = !DILocation(line: 234, column: 8, scope: !621)
!626 = !DILocation(line: 234, column: 6, scope: !621)
!627 = distinct !{!627, !517, !628, !307}
!628 = !DILocation(line: 235, column: 5, scope: !483)
!629 = !DILocation(line: 236, column: 27, scope: !483)
!630 = !DILocation(line: 236, column: 12, scope: !483)
!631 = !DILocation(line: 236, column: 10, scope: !483)
!632 = !DILocation(line: 237, column: 10, scope: !633)
!633 = distinct !DILexicalBlock(scope: !483, file: !2, line: 237, column: 9)
!634 = !DILocation(line: 237, column: 9, scope: !633)
!635 = !DILocation(line: 237, column: 16, scope: !633)
!636 = !DILocation(line: 237, column: 20, scope: !633)
!637 = !DILocation(line: 237, column: 24, scope: !633)
!638 = !DILocation(line: 237, column: 30, scope: !633)
!639 = !DILocation(line: 237, column: 27, scope: !633)
!640 = !DILocation(line: 237, column: 9, scope: !483)
!641 = !DILocation(line: 238, column: 9, scope: !633)
!642 = !DILocation(line: 238, column: 2, scope: !633)
!643 = !DILocation(line: 240, column: 8, scope: !644)
!644 = distinct !DILexicalBlock(scope: !633, file: !2, line: 240, column: 6)
!645 = !DILocation(line: 240, column: 6, scope: !633)
!646 = !DILocation(line: 241, column: 13, scope: !644)
!647 = !DILocation(line: 241, column: 6, scope: !644)
!648 = !DILocation(line: 243, column: 15, scope: !644)
!649 = !DILocation(line: 243, column: 13, scope: !644)
!650 = !DILocation(line: 244, column: 12, scope: !483)
!651 = !DILocation(line: 244, column: 5, scope: !483)
!652 = distinct !DISubprogram(name: "getpat", scope: !2, file: !2, line: 248, type: !653, scopeLine: 251, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!653 = !DISubroutineType(types: !654)
!654 = !{!60, !59, !59}
!655 = !DILocalVariable(name: "arg", arg: 1, scope: !652, file: !2, line: 249, type: !59)
!656 = !DILocation(line: 249, column: 7, scope: !652)
!657 = !DILocalVariable(name: "pat", arg: 2, scope: !652, file: !2, line: 250, type: !59)
!658 = !DILocation(line: 250, column: 7, scope: !652)
!659 = !DILocalVariable(name: "makeres", scope: !652, file: !2, line: 252, type: !60)
!660 = !DILocation(line: 252, column: 9, scope: !652)
!661 = !DILocation(line: 254, column: 23, scope: !652)
!662 = !DILocation(line: 254, column: 39, scope: !652)
!663 = !DILocation(line: 254, column: 15, scope: !652)
!664 = !DILocation(line: 254, column: 13, scope: !652)
!665 = !DILocation(line: 255, column: 13, scope: !652)
!666 = !DILocation(line: 255, column: 21, scope: !652)
!667 = !DILocation(line: 255, column: 5, scope: !652)
!668 = distinct !DISubprogram(name: "makesub", scope: !2, file: !2, line: 259, type: !669, scopeLine: 264, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!669 = !DISubroutineType(types: !670)
!670 = !{!60, !59, !60, !671, !59}
!671 = !DIDerivedType(tag: DW_TAG_typedef, name: "character", file: !2, line: 37, baseType: !4)
!672 = !DILocalVariable(name: "arg", arg: 1, scope: !668, file: !2, line: 260, type: !59)
!673 = !DILocation(line: 260, column: 8, scope: !668)
!674 = !DILocalVariable(name: "from", arg: 2, scope: !668, file: !2, line: 261, type: !60)
!675 = !DILocation(line: 261, column: 6, scope: !668)
!676 = !DILocalVariable(name: "delim", arg: 3, scope: !668, file: !2, line: 262, type: !671)
!677 = !DILocation(line: 262, column: 12, scope: !668)
!678 = !DILocalVariable(name: "sub", arg: 4, scope: !668, file: !2, line: 263, type: !59)
!679 = !DILocation(line: 263, column: 8, scope: !668)
!680 = !DILocalVariable(name: "result", scope: !668, file: !2, line: 265, type: !60)
!681 = !DILocation(line: 265, column: 10, scope: !668)
!682 = !DILocalVariable(name: "i", scope: !668, file: !2, line: 266, type: !60)
!683 = !DILocation(line: 266, column: 9, scope: !668)
!684 = !DILocalVariable(name: "j", scope: !668, file: !2, line: 266, type: !60)
!685 = !DILocation(line: 266, column: 12, scope: !668)
!686 = !DILocalVariable(name: "junk", scope: !668, file: !2, line: 267, type: !46)
!687 = !DILocation(line: 267, column: 10, scope: !668)
!688 = !DILocalVariable(name: "escjunk", scope: !668, file: !2, line: 268, type: !671)
!689 = !DILocation(line: 268, column: 15, scope: !668)
!690 = !DILocation(line: 270, column: 7, scope: !668)
!691 = !DILocation(line: 271, column: 9, scope: !668)
!692 = !DILocation(line: 271, column: 7, scope: !668)
!693 = !DILocation(line: 272, column: 5, scope: !668)
!694 = !DILocation(line: 272, column: 13, scope: !668)
!695 = !DILocation(line: 272, column: 17, scope: !668)
!696 = !DILocation(line: 272, column: 23, scope: !668)
!697 = !DILocation(line: 272, column: 20, scope: !668)
!698 = !DILocation(line: 272, column: 30, scope: !668)
!699 = !DILocation(line: 272, column: 34, scope: !668)
!700 = !DILocation(line: 272, column: 38, scope: !668)
!701 = !DILocation(line: 272, column: 41, scope: !668)
!702 = !DILocation(line: 0, scope: !668)
!703 = !DILocation(line: 273, column: 7, scope: !704)
!704 = distinct !DILexicalBlock(scope: !705, file: !2, line: 273, column: 6)
!705 = distinct !DILexicalBlock(scope: !668, file: !2, line: 272, column: 53)
!706 = !DILocation(line: 273, column: 11, scope: !704)
!707 = !DILocation(line: 273, column: 14, scope: !704)
!708 = !DILocation(line: 273, column: 6, scope: !705)
!709 = !DILocation(line: 274, column: 27, scope: !704)
!710 = !DILocation(line: 274, column: 13, scope: !704)
!711 = !DILocation(line: 274, column: 11, scope: !704)
!712 = !DILocation(line: 274, column: 6, scope: !704)
!713 = !DILocation(line: 276, column: 20, scope: !714)
!714 = distinct !DILexicalBlock(scope: !704, file: !2, line: 275, column: 7)
!715 = !DILocation(line: 276, column: 16, scope: !714)
!716 = !DILocation(line: 276, column: 14, scope: !714)
!717 = !DILocation(line: 277, column: 20, scope: !714)
!718 = !DILocation(line: 277, column: 29, scope: !714)
!719 = !DILocation(line: 277, column: 13, scope: !714)
!720 = !DILocation(line: 277, column: 11, scope: !714)
!721 = !DILocation(line: 279, column: 6, scope: !705)
!722 = !DILocation(line: 279, column: 8, scope: !705)
!723 = !DILocation(line: 279, column: 4, scope: !705)
!724 = distinct !{!724, !693, !725, !307}
!725 = !DILocation(line: 280, column: 5, scope: !668)
!726 = !DILocation(line: 281, column: 9, scope: !727)
!727 = distinct !DILexicalBlock(scope: !668, file: !2, line: 281, column: 9)
!728 = !DILocation(line: 281, column: 13, scope: !727)
!729 = !DILocation(line: 281, column: 19, scope: !727)
!730 = !DILocation(line: 281, column: 16, scope: !727)
!731 = !DILocation(line: 281, column: 9, scope: !668)
!732 = !DILocation(line: 282, column: 9, scope: !727)
!733 = !DILocation(line: 282, column: 2, scope: !727)
!734 = !DILocation(line: 284, column: 27, scope: !735)
!735 = distinct !DILexicalBlock(scope: !727, file: !2, line: 283, column: 10)
!736 = !DILocation(line: 284, column: 9, scope: !735)
!737 = !DILocation(line: 284, column: 7, scope: !735)
!738 = !DILocation(line: 285, column: 8, scope: !739)
!739 = distinct !DILexicalBlock(scope: !735, file: !2, line: 285, column: 6)
!740 = !DILocation(line: 285, column: 6, scope: !735)
!741 = !DILocation(line: 286, column: 13, scope: !739)
!742 = !DILocation(line: 286, column: 6, scope: !739)
!743 = !DILocation(line: 288, column: 15, scope: !739)
!744 = !DILocation(line: 288, column: 13, scope: !739)
!745 = !DILocation(line: 290, column: 12, scope: !668)
!746 = !DILocation(line: 290, column: 5, scope: !668)
!747 = distinct !DISubprogram(name: "getsub", scope: !2, file: !2, line: 294, type: !748, scopeLine: 297, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!748 = !DISubroutineType(types: !749)
!749 = !{!46, !59, !59}
!750 = !DILocalVariable(name: "arg", arg: 1, scope: !747, file: !2, line: 295, type: !59)
!751 = !DILocation(line: 295, column: 8, scope: !747)
!752 = !DILocalVariable(name: "sub", arg: 2, scope: !747, file: !2, line: 296, type: !59)
!753 = !DILocation(line: 296, column: 8, scope: !747)
!754 = !DILocalVariable(name: "makeres", scope: !747, file: !2, line: 298, type: !60)
!755 = !DILocation(line: 298, column: 9, scope: !747)
!756 = !DILocation(line: 300, column: 23, scope: !747)
!757 = !DILocation(line: 300, column: 39, scope: !747)
!758 = !DILocation(line: 300, column: 15, scope: !747)
!759 = !DILocation(line: 300, column: 13, scope: !747)
!760 = !DILocation(line: 301, column: 13, scope: !747)
!761 = !DILocation(line: 301, column: 21, scope: !747)
!762 = !DILocation(line: 301, column: 12, scope: !747)
!763 = !DILocation(line: 301, column: 5, scope: !747)
!764 = distinct !DISubprogram(name: "locate", scope: !2, file: !2, line: 307, type: !765, scopeLine: 311, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!765 = !DISubroutineType(types: !766)
!766 = !{!46, !671, !59, !60}
!767 = !DILocalVariable(name: "c", arg: 1, scope: !764, file: !2, line: 308, type: !671)
!768 = !DILocation(line: 308, column: 12, scope: !764)
!769 = !DILocalVariable(name: "pat", arg: 2, scope: !764, file: !2, line: 309, type: !59)
!770 = !DILocation(line: 309, column: 9, scope: !764)
!771 = !DILocalVariable(name: "offset", arg: 3, scope: !764, file: !2, line: 310, type: !60)
!772 = !DILocation(line: 310, column: 6, scope: !764)
!773 = !DILocalVariable(name: "i", scope: !764, file: !2, line: 312, type: !60)
!774 = !DILocation(line: 312, column: 9, scope: !764)
!775 = !DILocalVariable(name: "flag", scope: !764, file: !2, line: 313, type: !46)
!776 = !DILocation(line: 313, column: 10, scope: !764)
!777 = !DILocation(line: 315, column: 10, scope: !764)
!778 = !DILocation(line: 316, column: 9, scope: !764)
!779 = !DILocation(line: 316, column: 18, scope: !764)
!780 = !DILocation(line: 316, column: 22, scope: !764)
!781 = !DILocation(line: 316, column: 16, scope: !764)
!782 = !DILocation(line: 316, column: 7, scope: !764)
!783 = !DILocation(line: 317, column: 5, scope: !764)
!784 = !DILocation(line: 317, column: 13, scope: !764)
!785 = !DILocation(line: 317, column: 17, scope: !764)
!786 = !DILocation(line: 317, column: 15, scope: !764)
!787 = !DILocation(line: 319, column: 6, scope: !788)
!788 = distinct !DILexicalBlock(scope: !789, file: !2, line: 319, column: 6)
!789 = distinct !DILexicalBlock(scope: !764, file: !2, line: 318, column: 5)
!790 = !DILocation(line: 319, column: 11, scope: !788)
!791 = !DILocation(line: 319, column: 15, scope: !788)
!792 = !DILocation(line: 319, column: 8, scope: !788)
!793 = !DILocation(line: 319, column: 6, scope: !789)
!794 = !DILocation(line: 320, column: 11, scope: !795)
!795 = distinct !DILexicalBlock(scope: !788, file: !2, line: 319, column: 19)
!796 = !DILocation(line: 321, column: 10, scope: !795)
!797 = !DILocation(line: 321, column: 8, scope: !795)
!798 = !DILocation(line: 322, column: 2, scope: !795)
!799 = !DILocation(line: 323, column: 10, scope: !788)
!800 = !DILocation(line: 323, column: 12, scope: !788)
!801 = !DILocation(line: 323, column: 8, scope: !788)
!802 = distinct !{!802, !783, !803, !307}
!803 = !DILocation(line: 324, column: 5, scope: !764)
!804 = !DILocation(line: 325, column: 12, scope: !764)
!805 = !DILocation(line: 325, column: 5, scope: !764)
!806 = distinct !DISubprogram(name: "omatch", scope: !2, file: !2, line: 329, type: !807, scopeLine: 334, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!807 = !DISubroutineType(types: !808)
!808 = !{!46, !59, !80, !59, !60}
!809 = !DILocalVariable(name: "lin", arg: 1, scope: !806, file: !2, line: 330, type: !59)
!810 = !DILocation(line: 330, column: 8, scope: !806)
!811 = !DILocalVariable(name: "i", arg: 2, scope: !806, file: !2, line: 331, type: !80)
!812 = !DILocation(line: 331, column: 7, scope: !806)
!813 = !DILocalVariable(name: "pat", arg: 3, scope: !806, file: !2, line: 332, type: !59)
!814 = !DILocation(line: 332, column: 8, scope: !806)
!815 = !DILocalVariable(name: "j", arg: 4, scope: !806, file: !2, line: 333, type: !60)
!816 = !DILocation(line: 333, column: 6, scope: !806)
!817 = !DILocalVariable(name: "advance", scope: !806, file: !2, line: 335, type: !4)
!818 = !DILocation(line: 335, column: 10, scope: !806)
!819 = !DILocalVariable(name: "result", scope: !806, file: !2, line: 336, type: !46)
!820 = !DILocation(line: 336, column: 10, scope: !806)
!821 = !DILocation(line: 338, column: 13, scope: !806)
!822 = !DILocation(line: 339, column: 10, scope: !823)
!823 = distinct !DILexicalBlock(scope: !806, file: !2, line: 339, column: 9)
!824 = !DILocation(line: 339, column: 15, scope: !823)
!825 = !DILocation(line: 339, column: 14, scope: !823)
!826 = !DILocation(line: 339, column: 18, scope: !823)
!827 = !DILocation(line: 339, column: 9, scope: !806)
!828 = !DILocation(line: 340, column: 9, scope: !823)
!829 = !DILocation(line: 340, column: 2, scope: !823)
!830 = !DILocation(line: 343, column: 18, scope: !831)
!831 = distinct !DILexicalBlock(scope: !832, file: !2, line: 343, column: 6)
!832 = distinct !DILexicalBlock(scope: !823, file: !2, line: 342, column: 5)
!833 = !DILocation(line: 343, column: 22, scope: !831)
!834 = !DILocation(line: 343, column: 7, scope: !831)
!835 = !DILocation(line: 343, column: 6, scope: !832)
!836 = !DILocation(line: 345, column: 20, scope: !837)
!837 = distinct !DILexicalBlock(scope: !831, file: !2, line: 344, column: 2)
!838 = !DILocation(line: 345, column: 12, scope: !837)
!839 = !DILocation(line: 346, column: 6, scope: !837)
!840 = !DILocation(line: 349, column: 15, scope: !841)
!841 = distinct !DILexicalBlock(scope: !831, file: !2, line: 348, column: 2)
!842 = !DILocation(line: 349, column: 19, scope: !841)
!843 = !DILocation(line: 349, column: 7, scope: !841)
!844 = !DILocation(line: 352, column: 8, scope: !845)
!845 = distinct !DILexicalBlock(scope: !846, file: !2, line: 352, column: 8)
!846 = distinct !DILexicalBlock(scope: !841, file: !2, line: 350, column: 7)
!847 = !DILocation(line: 352, column: 13, scope: !845)
!848 = !DILocation(line: 352, column: 12, scope: !845)
!849 = !DILocation(line: 352, column: 19, scope: !845)
!850 = !DILocation(line: 352, column: 23, scope: !845)
!851 = !DILocation(line: 352, column: 25, scope: !845)
!852 = !DILocation(line: 352, column: 16, scope: !845)
!853 = !DILocation(line: 352, column: 8, scope: !846)
!854 = !DILocation(line: 353, column: 16, scope: !845)
!855 = !DILocation(line: 353, column: 8, scope: !845)
!856 = !DILocation(line: 354, column: 4, scope: !846)
!857 = !DILocation(line: 356, column: 9, scope: !858)
!858 = distinct !DILexicalBlock(scope: !846, file: !2, line: 356, column: 8)
!859 = !DILocation(line: 356, column: 8, scope: !858)
!860 = !DILocation(line: 356, column: 11, scope: !858)
!861 = !DILocation(line: 356, column: 8, scope: !846)
!862 = !DILocation(line: 357, column: 16, scope: !858)
!863 = !DILocation(line: 357, column: 8, scope: !858)
!864 = !DILocation(line: 358, column: 4, scope: !846)
!865 = !DILocation(line: 360, column: 8, scope: !866)
!866 = distinct !DILexicalBlock(scope: !846, file: !2, line: 360, column: 8)
!867 = !DILocation(line: 360, column: 13, scope: !866)
!868 = !DILocation(line: 360, column: 12, scope: !866)
!869 = !DILocation(line: 360, column: 16, scope: !866)
!870 = !DILocation(line: 360, column: 8, scope: !846)
!871 = !DILocation(line: 361, column: 16, scope: !866)
!872 = !DILocation(line: 361, column: 8, scope: !866)
!873 = !DILocation(line: 362, column: 4, scope: !846)
!874 = !DILocation(line: 364, column: 8, scope: !875)
!875 = distinct !DILexicalBlock(scope: !846, file: !2, line: 364, column: 8)
!876 = !DILocation(line: 364, column: 13, scope: !875)
!877 = !DILocation(line: 364, column: 12, scope: !875)
!878 = !DILocation(line: 364, column: 16, scope: !875)
!879 = !DILocation(line: 364, column: 8, scope: !846)
!880 = !DILocation(line: 365, column: 16, scope: !875)
!881 = !DILocation(line: 365, column: 8, scope: !875)
!882 = !DILocation(line: 366, column: 4, scope: !846)
!883 = !DILocation(line: 368, column: 15, scope: !884)
!884 = distinct !DILexicalBlock(scope: !846, file: !2, line: 368, column: 8)
!885 = !DILocation(line: 368, column: 20, scope: !884)
!886 = !DILocation(line: 368, column: 19, scope: !884)
!887 = !DILocation(line: 368, column: 24, scope: !884)
!888 = !DILocation(line: 368, column: 29, scope: !884)
!889 = !DILocation(line: 368, column: 31, scope: !884)
!890 = !DILocation(line: 368, column: 8, scope: !884)
!891 = !DILocation(line: 368, column: 8, scope: !846)
!892 = !DILocation(line: 369, column: 16, scope: !884)
!893 = !DILocation(line: 369, column: 8, scope: !884)
!894 = !DILocation(line: 370, column: 4, scope: !846)
!895 = !DILocation(line: 372, column: 9, scope: !896)
!896 = distinct !DILexicalBlock(scope: !846, file: !2, line: 372, column: 8)
!897 = !DILocation(line: 372, column: 14, scope: !896)
!898 = !DILocation(line: 372, column: 13, scope: !896)
!899 = !DILocation(line: 372, column: 17, scope: !896)
!900 = !DILocation(line: 372, column: 29, scope: !896)
!901 = !DILocation(line: 372, column: 41, scope: !896)
!902 = !DILocation(line: 372, column: 46, scope: !896)
!903 = !DILocation(line: 372, column: 45, scope: !896)
!904 = !DILocation(line: 372, column: 50, scope: !896)
!905 = !DILocation(line: 372, column: 55, scope: !896)
!906 = !DILocation(line: 372, column: 56, scope: !896)
!907 = !DILocation(line: 372, column: 34, scope: !896)
!908 = !DILocation(line: 372, column: 8, scope: !846)
!909 = !DILocation(line: 373, column: 16, scope: !896)
!910 = !DILocation(line: 373, column: 8, scope: !896)
!911 = !DILocation(line: 374, column: 4, scope: !846)
!912 = !DILocation(line: 376, column: 14, scope: !846)
!913 = !DILocation(line: 376, column: 18, scope: !846)
!914 = !DILocation(line: 376, column: 4, scope: !846)
!915 = !DILocation(line: 377, column: 7, scope: !846)
!916 = !DILocation(line: 380, column: 10, scope: !917)
!917 = distinct !DILexicalBlock(scope: !806, file: !2, line: 380, column: 9)
!918 = !DILocation(line: 380, column: 18, scope: !917)
!919 = !DILocation(line: 380, column: 9, scope: !806)
!920 = !DILocation(line: 382, column: 8, scope: !921)
!921 = distinct !DILexicalBlock(scope: !917, file: !2, line: 381, column: 5)
!922 = !DILocation(line: 382, column: 7, scope: !921)
!923 = !DILocation(line: 382, column: 12, scope: !921)
!924 = !DILocation(line: 382, column: 10, scope: !921)
!925 = !DILocation(line: 382, column: 3, scope: !921)
!926 = !DILocation(line: 382, column: 5, scope: !921)
!927 = !DILocation(line: 383, column: 9, scope: !921)
!928 = !DILocation(line: 384, column: 5, scope: !921)
!929 = !DILocation(line: 385, column: 9, scope: !917)
!930 = !DILocation(line: 386, column: 12, scope: !806)
!931 = !DILocation(line: 386, column: 5, scope: !806)
!932 = distinct !DISubprogram(name: "patsize", scope: !2, file: !2, line: 390, type: !933, scopeLine: 393, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!933 = !DISubroutineType(types: !934)
!934 = !{!60, !59, !60}
!935 = !DILocalVariable(name: "pat", arg: 1, scope: !932, file: !2, line: 391, type: !59)
!936 = !DILocation(line: 391, column: 8, scope: !932)
!937 = !DILocalVariable(name: "n", arg: 2, scope: !932, file: !2, line: 392, type: !60)
!938 = !DILocation(line: 392, column: 6, scope: !932)
!939 = !DILocalVariable(name: "size", scope: !932, file: !2, line: 394, type: !60)
!940 = !DILocation(line: 394, column: 9, scope: !932)
!941 = !DILocation(line: 395, column: 21, scope: !942)
!942 = distinct !DILexicalBlock(scope: !932, file: !2, line: 395, column: 9)
!943 = !DILocation(line: 395, column: 25, scope: !942)
!944 = !DILocation(line: 395, column: 10, scope: !942)
!945 = !DILocation(line: 395, column: 9, scope: !932)
!946 = !DILocation(line: 396, column: 16, scope: !947)
!947 = distinct !DILexicalBlock(scope: !942, file: !2, line: 395, column: 30)
!948 = !DILocation(line: 396, column: 8, scope: !947)
!949 = !DILocation(line: 397, column: 2, scope: !947)
!950 = !DILocation(line: 399, column: 10, scope: !942)
!951 = !DILocation(line: 399, column: 14, scope: !942)
!952 = !DILocation(line: 399, column: 2, scope: !942)
!953 = !DILocation(line: 401, column: 21, scope: !954)
!954 = distinct !DILexicalBlock(scope: !942, file: !2, line: 400, column: 2)
!955 = !DILocation(line: 401, column: 26, scope: !954)
!956 = !DILocation(line: 404, column: 11, scope: !954)
!957 = !DILocation(line: 405, column: 6, scope: !954)
!958 = !DILocation(line: 407, column: 13, scope: !954)
!959 = !DILocation(line: 407, column: 17, scope: !954)
!960 = !DILocation(line: 407, column: 19, scope: !954)
!961 = !DILocation(line: 407, column: 24, scope: !954)
!962 = !DILocation(line: 407, column: 11, scope: !954)
!963 = !DILocation(line: 408, column: 6, scope: !954)
!964 = !DILocation(line: 410, column: 11, scope: !954)
!965 = !DILocation(line: 411, column: 6, scope: !954)
!966 = !DILocation(line: 413, column: 16, scope: !954)
!967 = !DILocation(line: 413, column: 20, scope: !954)
!968 = !DILocation(line: 413, column: 6, scope: !954)
!969 = !DILocation(line: 414, column: 2, scope: !954)
!970 = !DILocation(line: 415, column: 12, scope: !932)
!971 = !DILocation(line: 415, column: 5, scope: !932)
!972 = distinct !DISubprogram(name: "amatch", scope: !2, file: !2, line: 419, type: !973, scopeLine: 424, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!973 = !DISubroutineType(types: !974)
!974 = !{!60, !59, !60, !59, !60}
!975 = !DILocalVariable(name: "lin", arg: 1, scope: !972, file: !2, line: 420, type: !59)
!976 = !DILocation(line: 420, column: 8, scope: !972)
!977 = !DILocalVariable(name: "offset", arg: 2, scope: !972, file: !2, line: 421, type: !60)
!978 = !DILocation(line: 421, column: 6, scope: !972)
!979 = !DILocalVariable(name: "pat", arg: 3, scope: !972, file: !2, line: 422, type: !59)
!980 = !DILocation(line: 422, column: 8, scope: !972)
!981 = !DILocalVariable(name: "j", arg: 4, scope: !972, file: !2, line: 423, type: !60)
!982 = !DILocation(line: 423, column: 6, scope: !972)
!983 = !DILocalVariable(name: "i", scope: !972, file: !2, line: 425, type: !60)
!984 = !DILocation(line: 425, column: 9, scope: !972)
!985 = !DILocalVariable(name: "k", scope: !972, file: !2, line: 425, type: !60)
!986 = !DILocation(line: 425, column: 12, scope: !972)
!987 = !DILocalVariable(name: "result", scope: !972, file: !2, line: 426, type: !46)
!988 = !DILocation(line: 426, column: 10, scope: !972)
!989 = !DILocalVariable(name: "done", scope: !972, file: !2, line: 426, type: !46)
!990 = !DILocation(line: 426, column: 18, scope: !972)
!991 = !DILocation(line: 428, column: 10, scope: !972)
!992 = !DILocation(line: 429, column: 5, scope: !972)
!993 = !DILocation(line: 429, column: 14, scope: !972)
!994 = !DILocation(line: 429, column: 20, scope: !972)
!995 = !DILocation(line: 429, column: 24, scope: !972)
!996 = !DILocation(line: 429, column: 28, scope: !972)
!997 = !DILocation(line: 429, column: 31, scope: !972)
!998 = !DILocation(line: 0, scope: !972)
!999 = !DILocation(line: 430, column: 7, scope: !1000)
!1000 = distinct !DILexicalBlock(scope: !972, file: !2, line: 430, column: 6)
!1001 = !DILocation(line: 430, column: 11, scope: !1000)
!1002 = !DILocation(line: 430, column: 14, scope: !1000)
!1003 = !DILocation(line: 430, column: 6, scope: !972)
!1004 = !DILocation(line: 431, column: 10, scope: !1005)
!1005 = distinct !DILexicalBlock(scope: !1000, file: !2, line: 430, column: 27)
!1006 = !DILocation(line: 431, column: 22, scope: !1005)
!1007 = !DILocation(line: 431, column: 27, scope: !1005)
!1008 = !DILocation(line: 431, column: 14, scope: !1005)
!1009 = !DILocation(line: 431, column: 12, scope: !1005)
!1010 = !DILocation(line: 431, column: 8, scope: !1005)
!1011 = !DILocation(line: 432, column: 10, scope: !1005)
!1012 = !DILocation(line: 432, column: 8, scope: !1005)
!1013 = !DILocation(line: 433, column: 6, scope: !1005)
!1014 = !DILocation(line: 433, column: 15, scope: !1005)
!1015 = !DILocation(line: 433, column: 21, scope: !1005)
!1016 = !DILocation(line: 433, column: 25, scope: !1005)
!1017 = !DILocation(line: 433, column: 29, scope: !1005)
!1018 = !DILocation(line: 433, column: 32, scope: !1005)
!1019 = !DILocation(line: 0, scope: !1005)
!1020 = !DILocation(line: 434, column: 19, scope: !1021)
!1021 = distinct !DILexicalBlock(scope: !1005, file: !2, line: 433, column: 44)
!1022 = !DILocation(line: 434, column: 28, scope: !1021)
!1023 = !DILocation(line: 434, column: 33, scope: !1021)
!1024 = !DILocation(line: 434, column: 12, scope: !1021)
!1025 = !DILocation(line: 434, column: 10, scope: !1021)
!1026 = !DILocation(line: 435, column: 8, scope: !1027)
!1027 = distinct !DILexicalBlock(scope: !1021, file: !2, line: 435, column: 7)
!1028 = !DILocation(line: 435, column: 7, scope: !1021)
!1029 = !DILocation(line: 436, column: 12, scope: !1027)
!1030 = !DILocation(line: 436, column: 7, scope: !1027)
!1031 = distinct !{!1031, !1013, !1032, !307}
!1032 = !DILocation(line: 437, column: 6, scope: !1005)
!1033 = !DILocation(line: 438, column: 11, scope: !1005)
!1034 = !DILocation(line: 439, column: 6, scope: !1005)
!1035 = !DILocation(line: 439, column: 15, scope: !1005)
!1036 = !DILocation(line: 439, column: 21, scope: !1005)
!1037 = !DILocation(line: 439, column: 25, scope: !1005)
!1038 = !DILocation(line: 439, column: 30, scope: !1005)
!1039 = !DILocation(line: 439, column: 27, scope: !1005)
!1040 = !DILocation(line: 440, column: 14, scope: !1041)
!1041 = distinct !DILexicalBlock(scope: !1005, file: !2, line: 439, column: 39)
!1042 = !DILocation(line: 440, column: 19, scope: !1041)
!1043 = !DILocation(line: 440, column: 22, scope: !1041)
!1044 = !DILocation(line: 440, column: 27, scope: !1041)
!1045 = !DILocation(line: 440, column: 39, scope: !1041)
!1046 = !DILocation(line: 440, column: 44, scope: !1041)
!1047 = !DILocation(line: 440, column: 31, scope: !1041)
!1048 = !DILocation(line: 440, column: 29, scope: !1041)
!1049 = !DILocation(line: 440, column: 7, scope: !1041)
!1050 = !DILocation(line: 440, column: 5, scope: !1041)
!1051 = !DILocation(line: 441, column: 8, scope: !1052)
!1052 = distinct !DILexicalBlock(scope: !1041, file: !2, line: 441, column: 7)
!1053 = !DILocation(line: 441, column: 10, scope: !1052)
!1054 = !DILocation(line: 441, column: 7, scope: !1041)
!1055 = !DILocation(line: 442, column: 12, scope: !1052)
!1056 = !DILocation(line: 442, column: 7, scope: !1052)
!1057 = !DILocation(line: 444, column: 11, scope: !1052)
!1058 = !DILocation(line: 444, column: 13, scope: !1052)
!1059 = !DILocation(line: 444, column: 9, scope: !1052)
!1060 = distinct !{!1060, !1034, !1061, !307}
!1061 = !DILocation(line: 445, column: 6, scope: !1005)
!1062 = !DILocation(line: 446, column: 15, scope: !1005)
!1063 = !DILocation(line: 446, column: 13, scope: !1005)
!1064 = !DILocation(line: 447, column: 11, scope: !1005)
!1065 = !DILocation(line: 448, column: 2, scope: !1005)
!1066 = !DILocation(line: 449, column: 22, scope: !1067)
!1067 = distinct !DILexicalBlock(scope: !1000, file: !2, line: 448, column: 9)
!1068 = !DILocation(line: 449, column: 36, scope: !1067)
!1069 = !DILocation(line: 449, column: 41, scope: !1067)
!1070 = !DILocation(line: 449, column: 15, scope: !1067)
!1071 = !DILocation(line: 449, column: 13, scope: !1067)
!1072 = !DILocation(line: 450, column: 12, scope: !1073)
!1073 = distinct !DILexicalBlock(scope: !1067, file: !2, line: 450, column: 10)
!1074 = !DILocation(line: 450, column: 10, scope: !1067)
!1075 = !DILocation(line: 451, column: 10, scope: !1076)
!1076 = distinct !DILexicalBlock(scope: !1073, file: !2, line: 450, column: 21)
!1077 = !DILocation(line: 452, column: 8, scope: !1076)
!1078 = !DILocation(line: 453, column: 6, scope: !1076)
!1079 = !DILocation(line: 454, column: 7, scope: !1073)
!1080 = !DILocation(line: 454, column: 19, scope: !1073)
!1081 = !DILocation(line: 454, column: 24, scope: !1073)
!1082 = !DILocation(line: 454, column: 11, scope: !1073)
!1083 = !DILocation(line: 454, column: 9, scope: !1073)
!1084 = !DILocation(line: 454, column: 5, scope: !1073)
!1085 = distinct !{!1085, !992, !1086, !307}
!1086 = !DILocation(line: 455, column: 2, scope: !972)
!1087 = !DILocation(line: 456, column: 13, scope: !972)
!1088 = !DILocation(line: 456, column: 6, scope: !972)
!1089 = distinct !DISubprogram(name: "putsub", scope: !2, file: !2, line: 460, type: !1090, scopeLine: 464, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!1090 = !DISubroutineType(types: !1091)
!1091 = !{null, !59, !60, !60, !59}
!1092 = !DILocalVariable(name: "lin", arg: 1, scope: !1089, file: !2, line: 461, type: !59)
!1093 = !DILocation(line: 461, column: 10, scope: !1089)
!1094 = !DILocalVariable(name: "s1", arg: 2, scope: !1089, file: !2, line: 462, type: !60)
!1095 = !DILocation(line: 462, column: 7, scope: !1089)
!1096 = !DILocalVariable(name: "s2", arg: 3, scope: !1089, file: !2, line: 462, type: !60)
!1097 = !DILocation(line: 462, column: 11, scope: !1089)
!1098 = !DILocalVariable(name: "sub", arg: 4, scope: !1089, file: !2, line: 463, type: !59)
!1099 = !DILocation(line: 463, column: 10, scope: !1089)
!1100 = !DILocalVariable(name: "i", scope: !1089, file: !2, line: 465, type: !60)
!1101 = !DILocation(line: 465, column: 9, scope: !1089)
!1102 = !DILocalVariable(name: "j", scope: !1089, file: !2, line: 466, type: !60)
!1103 = !DILocation(line: 466, column: 10, scope: !1089)
!1104 = !DILocation(line: 468, column: 7, scope: !1089)
!1105 = !DILocation(line: 469, column: 5, scope: !1089)
!1106 = !DILocation(line: 469, column: 13, scope: !1089)
!1107 = !DILocation(line: 469, column: 17, scope: !1089)
!1108 = !DILocation(line: 469, column: 20, scope: !1089)
!1109 = !DILocation(line: 470, column: 7, scope: !1110)
!1110 = distinct !DILexicalBlock(scope: !1111, file: !2, line: 470, column: 6)
!1111 = distinct !DILexicalBlock(scope: !1089, file: !2, line: 469, column: 32)
!1112 = !DILocation(line: 470, column: 11, scope: !1110)
!1113 = !DILocation(line: 470, column: 14, scope: !1110)
!1114 = !DILocation(line: 470, column: 6, scope: !1111)
!1115 = !DILocation(line: 471, column: 15, scope: !1116)
!1116 = distinct !DILexicalBlock(scope: !1110, file: !2, line: 471, column: 6)
!1117 = !DILocation(line: 471, column: 13, scope: !1116)
!1118 = !DILocation(line: 471, column: 11, scope: !1116)
!1119 = !DILocation(line: 471, column: 19, scope: !1120)
!1120 = distinct !DILexicalBlock(scope: !1116, file: !2, line: 471, column: 6)
!1121 = !DILocation(line: 471, column: 23, scope: !1120)
!1122 = !DILocation(line: 471, column: 21, scope: !1120)
!1123 = !DILocation(line: 471, column: 6, scope: !1116)
!1124 = !DILocation(line: 473, column: 9, scope: !1125)
!1125 = distinct !DILexicalBlock(scope: !1120, file: !2, line: 472, column: 6)
!1126 = !DILocation(line: 473, column: 13, scope: !1125)
!1127 = !DILocation(line: 473, column: 16, scope: !1125)
!1128 = !DILocation(line: 473, column: 3, scope: !1125)
!1129 = !DILocation(line: 474, column: 6, scope: !1125)
!1130 = !DILocation(line: 471, column: 28, scope: !1120)
!1131 = !DILocation(line: 471, column: 6, scope: !1120)
!1132 = distinct !{!1132, !1123, !1133, !307}
!1133 = !DILocation(line: 474, column: 6, scope: !1116)
!1134 = !DILocation(line: 477, column: 12, scope: !1135)
!1135 = distinct !DILexicalBlock(scope: !1110, file: !2, line: 476, column: 2)
!1136 = !DILocation(line: 477, column: 16, scope: !1135)
!1137 = !DILocation(line: 477, column: 19, scope: !1135)
!1138 = !DILocation(line: 477, column: 6, scope: !1135)
!1139 = !DILocation(line: 479, column: 6, scope: !1111)
!1140 = !DILocation(line: 479, column: 8, scope: !1111)
!1141 = !DILocation(line: 479, column: 4, scope: !1111)
!1142 = distinct !{!1142, !1105, !1143, !307}
!1143 = !DILocation(line: 480, column: 5, scope: !1089)
!1144 = !DILocation(line: 481, column: 1, scope: !1089)
!1145 = distinct !DISubprogram(name: "subline", scope: !2, file: !2, line: 484, type: !1146, scopeLine: 488, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!1146 = !DISubroutineType(types: !1147)
!1147 = !{null, !59, !59, !59}
!1148 = !DILocalVariable(name: "lin", arg: 1, scope: !1145, file: !2, line: 485, type: !59)
!1149 = !DILocation(line: 485, column: 8, scope: !1145)
!1150 = !DILocalVariable(name: "pat", arg: 2, scope: !1145, file: !2, line: 486, type: !59)
!1151 = !DILocation(line: 486, column: 10, scope: !1145)
!1152 = !DILocalVariable(name: "sub", arg: 3, scope: !1145, file: !2, line: 487, type: !59)
!1153 = !DILocation(line: 487, column: 10, scope: !1145)
!1154 = !DILocalVariable(name: "i", scope: !1145, file: !2, line: 489, type: !60)
!1155 = !DILocation(line: 489, column: 6, scope: !1145)
!1156 = !DILocalVariable(name: "lastm", scope: !1145, file: !2, line: 489, type: !60)
!1157 = !DILocation(line: 489, column: 9, scope: !1145)
!1158 = !DILocalVariable(name: "m", scope: !1145, file: !2, line: 489, type: !60)
!1159 = !DILocation(line: 489, column: 16, scope: !1145)
!1160 = !DILocation(line: 491, column: 8, scope: !1145)
!1161 = !DILocation(line: 492, column: 4, scope: !1145)
!1162 = !DILocation(line: 493, column: 2, scope: !1145)
!1163 = !DILocation(line: 493, column: 10, scope: !1145)
!1164 = !DILocation(line: 493, column: 14, scope: !1145)
!1165 = !DILocation(line: 493, column: 17, scope: !1145)
!1166 = !DILocation(line: 495, column: 17, scope: !1167)
!1167 = distinct !DILexicalBlock(scope: !1145, file: !2, line: 494, column: 2)
!1168 = !DILocation(line: 495, column: 22, scope: !1167)
!1169 = !DILocation(line: 495, column: 25, scope: !1167)
!1170 = !DILocation(line: 495, column: 10, scope: !1167)
!1171 = !DILocation(line: 495, column: 8, scope: !1167)
!1172 = !DILocation(line: 496, column: 11, scope: !1173)
!1173 = distinct !DILexicalBlock(scope: !1167, file: !2, line: 496, column: 10)
!1174 = !DILocation(line: 496, column: 13, scope: !1173)
!1175 = !DILocation(line: 496, column: 19, scope: !1173)
!1176 = !DILocation(line: 496, column: 23, scope: !1173)
!1177 = !DILocation(line: 496, column: 32, scope: !1173)
!1178 = !DILocation(line: 496, column: 29, scope: !1173)
!1179 = !DILocation(line: 496, column: 10, scope: !1167)
!1180 = !DILocation(line: 497, column: 10, scope: !1181)
!1181 = distinct !DILexicalBlock(scope: !1173, file: !2, line: 496, column: 36)
!1182 = !DILocation(line: 497, column: 15, scope: !1181)
!1183 = !DILocation(line: 497, column: 18, scope: !1181)
!1184 = !DILocation(line: 497, column: 21, scope: !1181)
!1185 = !DILocation(line: 497, column: 3, scope: !1181)
!1186 = !DILocation(line: 498, column: 11, scope: !1181)
!1187 = !DILocation(line: 498, column: 9, scope: !1181)
!1188 = !DILocation(line: 499, column: 6, scope: !1181)
!1189 = !DILocation(line: 500, column: 11, scope: !1190)
!1190 = distinct !DILexicalBlock(scope: !1167, file: !2, line: 500, column: 10)
!1191 = !DILocation(line: 500, column: 13, scope: !1190)
!1192 = !DILocation(line: 500, column: 20, scope: !1190)
!1193 = !DILocation(line: 500, column: 24, scope: !1190)
!1194 = !DILocation(line: 500, column: 29, scope: !1190)
!1195 = !DILocation(line: 500, column: 26, scope: !1190)
!1196 = !DILocation(line: 500, column: 10, scope: !1167)
!1197 = !DILocation(line: 501, column: 9, scope: !1198)
!1198 = distinct !DILexicalBlock(scope: !1190, file: !2, line: 500, column: 33)
!1199 = !DILocation(line: 501, column: 13, scope: !1198)
!1200 = !DILocation(line: 501, column: 16, scope: !1198)
!1201 = !DILocation(line: 501, column: 3, scope: !1198)
!1202 = !DILocation(line: 502, column: 7, scope: !1198)
!1203 = !DILocation(line: 502, column: 9, scope: !1198)
!1204 = !DILocation(line: 502, column: 5, scope: !1198)
!1205 = !DILocation(line: 503, column: 6, scope: !1198)
!1206 = !DILocation(line: 504, column: 7, scope: !1190)
!1207 = !DILocation(line: 504, column: 5, scope: !1190)
!1208 = distinct !{!1208, !1162, !1209, !307}
!1209 = !DILocation(line: 505, column: 2, scope: !1145)
!1210 = !DILocation(line: 506, column: 1, scope: !1145)
!1211 = distinct !DISubprogram(name: "change", scope: !2, file: !2, line: 509, type: !1212, scopeLine: 511, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!1212 = !DISubroutineType(types: !1213)
!1213 = !{null, !59, !59}
!1214 = !DILocalVariable(name: "pat", arg: 1, scope: !1211, file: !2, line: 510, type: !59)
!1215 = !DILocation(line: 510, column: 7, scope: !1211)
!1216 = !DILocalVariable(name: "sub", arg: 2, scope: !1211, file: !2, line: 510, type: !59)
!1217 = !DILocation(line: 510, column: 13, scope: !1211)
!1218 = !DILocalVariable(name: "line", scope: !1211, file: !2, line: 512, type: !1219)
!1219 = !DIDerivedType(tag: DW_TAG_typedef, name: "string", file: !2, line: 38, baseType: !1220)
!1220 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 800, elements: !1221)
!1221 = !{!1222}
!1222 = !DISubrange(count: 100)
!1223 = !DILocation(line: 512, column: 13, scope: !1211)
!1224 = !DILocalVariable(name: "result", scope: !1211, file: !2, line: 513, type: !46)
!1225 = !DILocation(line: 513, column: 10, scope: !1211)
!1226 = !DILocation(line: 515, column: 23, scope: !1211)
!1227 = !DILocation(line: 515, column: 14, scope: !1211)
!1228 = !DILocation(line: 515, column: 12, scope: !1211)
!1229 = !DILocation(line: 516, column: 5, scope: !1211)
!1230 = !DILocation(line: 516, column: 13, scope: !1211)
!1231 = !DILocation(line: 517, column: 10, scope: !1232)
!1232 = distinct !DILexicalBlock(scope: !1211, file: !2, line: 516, column: 22)
!1233 = !DILocation(line: 517, column: 16, scope: !1232)
!1234 = !DILocation(line: 517, column: 21, scope: !1232)
!1235 = !DILocation(line: 517, column: 2, scope: !1232)
!1236 = !DILocation(line: 518, column: 20, scope: !1232)
!1237 = !DILocation(line: 518, column: 11, scope: !1232)
!1238 = !DILocation(line: 518, column: 9, scope: !1232)
!1239 = distinct !{!1239, !1229, !1240, !307}
!1240 = !DILocation(line: 519, column: 5, scope: !1211)
!1241 = !DILocation(line: 520, column: 1, scope: !1211)
!1242 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 522, type: !1243, scopeLine: 525, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!1243 = !DISubroutineType(types: !1244)
!1244 = !{!60, !60, !1245}
!1245 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!1246 = !DILocalVariable(name: "argc", arg: 1, scope: !1242, file: !2, line: 523, type: !60)
!1247 = !DILocation(line: 523, column: 5, scope: !1242)
!1248 = !DILocalVariable(name: "argv", arg: 2, scope: !1242, file: !2, line: 524, type: !1245)
!1249 = !DILocation(line: 524, column: 7, scope: !1242)
!1250 = !DILocalVariable(name: "pat", scope: !1242, file: !2, line: 526, type: !1219)
!1251 = !DILocation(line: 526, column: 12, scope: !1242)
!1252 = !DILocalVariable(name: "sub", scope: !1242, file: !2, line: 526, type: !1219)
!1253 = !DILocation(line: 526, column: 17, scope: !1242)
!1254 = !DILocalVariable(name: "result", scope: !1242, file: !2, line: 527, type: !46)
!1255 = !DILocation(line: 527, column: 10, scope: !1242)
!1256 = !DILocalVariable(name: "line", scope: !1242, file: !2, line: 529, type: !1257)
!1257 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 1920, elements: !1258)
!1258 = !{!1259, !1260}
!1259 = !DISubrange(count: 12)
!1260 = !DISubrange(count: 20)
!1261 = !DILocation(line: 529, column: 10, scope: !1242)
!1262 = !DILocalVariable(name: "buffer", scope: !1242, file: !2, line: 530, type: !1263)
!1263 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 3200, elements: !1264)
!1264 = !{!1260, !1260}
!1265 = !DILocation(line: 530, column: 10, scope: !1242)
!1266 = !DILocalVariable(name: "file", scope: !1242, file: !2, line: 532, type: !1267)
!1267 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1268, size: 64)
!1268 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !1269, line: 157, baseType: !1270)
!1269 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk/usr/include/_stdio.h", directory: "")
!1270 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sFILE", file: !1269, line: 126, size: 1216, elements: !1271)
!1271 = !{!1272, !1275, !1276, !1277, !1279, !1280, !1285, !1286, !1288, !1292, !1296, !1306, !1312, !1313, !1316, !1317, !1319, !1323, !1324, !1325}
!1272 = !DIDerivedType(tag: DW_TAG_member, name: "_p", scope: !1270, file: !1269, line: 127, baseType: !1273, size: 64)
!1273 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1274, size: 64)
!1274 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!1275 = !DIDerivedType(tag: DW_TAG_member, name: "_r", scope: !1270, file: !1269, line: 128, baseType: !60, size: 32, offset: 64)
!1276 = !DIDerivedType(tag: DW_TAG_member, name: "_w", scope: !1270, file: !1269, line: 129, baseType: !60, size: 32, offset: 96)
!1277 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !1270, file: !1269, line: 130, baseType: !1278, size: 16, offset: 128)
!1278 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!1279 = !DIDerivedType(tag: DW_TAG_member, name: "_file", scope: !1270, file: !1269, line: 131, baseType: !1278, size: 16, offset: 144)
!1280 = !DIDerivedType(tag: DW_TAG_member, name: "_bf", scope: !1270, file: !1269, line: 132, baseType: !1281, size: 128, offset: 192)
!1281 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sbuf", file: !1269, line: 92, size: 128, elements: !1282)
!1282 = !{!1283, !1284}
!1283 = !DIDerivedType(tag: DW_TAG_member, name: "_base", scope: !1281, file: !1269, line: 93, baseType: !1273, size: 64)
!1284 = !DIDerivedType(tag: DW_TAG_member, name: "_size", scope: !1281, file: !1269, line: 94, baseType: !60, size: 32, offset: 64)
!1285 = !DIDerivedType(tag: DW_TAG_member, name: "_lbfsize", scope: !1270, file: !1269, line: 133, baseType: !60, size: 32, offset: 320)
!1286 = !DIDerivedType(tag: DW_TAG_member, name: "_cookie", scope: !1270, file: !1269, line: 136, baseType: !1287, size: 64, offset: 384)
!1287 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!1288 = !DIDerivedType(tag: DW_TAG_member, name: "_close", scope: !1270, file: !1269, line: 137, baseType: !1289, size: 64, offset: 448)
!1289 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1290, size: 64)
!1290 = !DISubroutineType(types: !1291)
!1291 = !{!60, !1287}
!1292 = !DIDerivedType(tag: DW_TAG_member, name: "_read", scope: !1270, file: !1269, line: 138, baseType: !1293, size: 64, offset: 512)
!1293 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1294, size: 64)
!1294 = !DISubroutineType(types: !1295)
!1295 = !{!60, !1287, !59, !60}
!1296 = !DIDerivedType(tag: DW_TAG_member, name: "_seek", scope: !1270, file: !1269, line: 139, baseType: !1297, size: 64, offset: 576)
!1297 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1298, size: 64)
!1298 = !DISubroutineType(types: !1299)
!1299 = !{!1300, !1287, !1300, !60}
!1300 = !DIDerivedType(tag: DW_TAG_typedef, name: "fpos_t", file: !1269, line: 81, baseType: !1301)
!1301 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_off_t", file: !1302, line: 71, baseType: !1303)
!1302 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk/usr/include/sys/_types.h", directory: "")
!1303 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !1304, line: 24, baseType: !1305)
!1304 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk/usr/include/arm/_types.h", directory: "")
!1305 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!1306 = !DIDerivedType(tag: DW_TAG_member, name: "_write", scope: !1270, file: !1269, line: 140, baseType: !1307, size: 64, offset: 640)
!1307 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1308, size: 64)
!1308 = !DISubroutineType(types: !1309)
!1309 = !{!60, !1287, !1310, !60}
!1310 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1311, size: 64)
!1311 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!1312 = !DIDerivedType(tag: DW_TAG_member, name: "_ub", scope: !1270, file: !1269, line: 143, baseType: !1281, size: 128, offset: 704)
!1313 = !DIDerivedType(tag: DW_TAG_member, name: "_extra", scope: !1270, file: !1269, line: 144, baseType: !1314, size: 64, offset: 832)
!1314 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1315, size: 64)
!1315 = !DICompositeType(tag: DW_TAG_structure_type, name: "__sFILEX", file: !1269, line: 98, flags: DIFlagFwdDecl)
!1316 = !DIDerivedType(tag: DW_TAG_member, name: "_ur", scope: !1270, file: !1269, line: 145, baseType: !60, size: 32, offset: 896)
!1317 = !DIDerivedType(tag: DW_TAG_member, name: "_ubuf", scope: !1270, file: !1269, line: 148, baseType: !1318, size: 24, offset: 928)
!1318 = !DICompositeType(tag: DW_TAG_array_type, baseType: !1274, size: 24, elements: !15)
!1319 = !DIDerivedType(tag: DW_TAG_member, name: "_nbuf", scope: !1270, file: !1269, line: 149, baseType: !1320, size: 8, offset: 952)
!1320 = !DICompositeType(tag: DW_TAG_array_type, baseType: !1274, size: 8, elements: !1321)
!1321 = !{!1322}
!1322 = !DISubrange(count: 1)
!1323 = !DIDerivedType(tag: DW_TAG_member, name: "_lb", scope: !1270, file: !1269, line: 152, baseType: !1281, size: 128, offset: 960)
!1324 = !DIDerivedType(tag: DW_TAG_member, name: "_blksize", scope: !1270, file: !1269, line: 155, baseType: !60, size: 32, offset: 1088)
!1325 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !1270, file: !1269, line: 156, baseType: !1300, size: 64, offset: 1152)
!1326 = !DILocation(line: 532, column: 11, scope: !1242)
!1327 = !DILocation(line: 532, column: 24, scope: !1242)
!1328 = !DILocation(line: 532, column: 18, scope: !1242)
!1329 = !DILocation(line: 533, column: 9, scope: !1330)
!1330 = distinct !DILexicalBlock(scope: !1242, file: !2, line: 533, column: 8)
!1331 = !DILocation(line: 533, column: 8, scope: !1242)
!1332 = !DILocation(line: 534, column: 9, scope: !1333)
!1333 = distinct !DILexicalBlock(scope: !1330, file: !2, line: 533, column: 14)
!1334 = !DILocation(line: 535, column: 9, scope: !1333)
!1335 = !DILocalVariable(name: "i", scope: !1242, file: !2, line: 538, type: !60)
!1336 = !DILocation(line: 538, column: 9, scope: !1242)
!1337 = !DILocation(line: 539, column: 5, scope: !1242)
!1338 = !DILocation(line: 539, column: 17, scope: !1242)
!1339 = !DILocation(line: 539, column: 38, scope: !1242)
!1340 = !DILocation(line: 539, column: 11, scope: !1242)
!1341 = !DILocation(line: 540, column: 9, scope: !1342)
!1342 = distinct !DILexicalBlock(scope: !1242, file: !2, line: 539, column: 44)
!1343 = !DILocation(line: 541, column: 10, scope: !1342)
!1344 = distinct !{!1344, !1337, !1345, !307}
!1345 = !DILocation(line: 542, column: 5, scope: !1242)
!1346 = !DILocalVariable(name: "j", scope: !1347, file: !2, line: 544, type: !60)
!1347 = distinct !DILexicalBlock(scope: !1242, file: !2, line: 544, column: 5)
!1348 = !DILocation(line: 544, column: 14, scope: !1347)
!1349 = !DILocation(line: 544, column: 10, scope: !1347)
!1350 = !DILocation(line: 544, column: 18, scope: !1351)
!1351 = distinct !DILexicalBlock(scope: !1347, file: !2, line: 544, column: 5)
!1352 = !DILocation(line: 544, column: 20, scope: !1351)
!1353 = !DILocation(line: 544, column: 19, scope: !1351)
!1354 = !DILocation(line: 544, column: 5, scope: !1347)
!1355 = !DILocation(line: 545, column: 29, scope: !1356)
!1356 = distinct !DILexicalBlock(scope: !1351, file: !2, line: 544, column: 26)
!1357 = !DILocation(line: 545, column: 22, scope: !1356)
!1358 = !DILocation(line: 545, column: 9, scope: !1356)
!1359 = !DILocation(line: 545, column: 14, scope: !1356)
!1360 = !DILocation(line: 545, column: 15, scope: !1356)
!1361 = !DILocation(line: 545, column: 19, scope: !1356)
!1362 = !DILocation(line: 546, column: 5, scope: !1356)
!1363 = !DILocation(line: 544, column: 23, scope: !1351)
!1364 = !DILocation(line: 544, column: 5, scope: !1351)
!1365 = distinct !{!1365, !1354, !1366, !307}
!1366 = !DILocation(line: 546, column: 5, scope: !1347)
!1367 = !DILocalVariable(name: "i", scope: !1368, file: !2, line: 548, type: !60)
!1368 = distinct !DILexicalBlock(scope: !1242, file: !2, line: 548, column: 5)
!1369 = !DILocation(line: 548, column: 13, scope: !1368)
!1370 = !DILocation(line: 548, column: 9, scope: !1368)
!1371 = !DILocation(line: 548, column: 17, scope: !1372)
!1372 = distinct !DILexicalBlock(scope: !1368, file: !2, line: 548, column: 5)
!1373 = !DILocation(line: 548, column: 18, scope: !1372)
!1374 = !DILocation(line: 548, column: 5, scope: !1368)
!1375 = !DILocation(line: 549, column: 21, scope: !1376)
!1376 = distinct !DILexicalBlock(scope: !1372, file: !2, line: 548, column: 25)
!1377 = !DILocation(line: 549, column: 26, scope: !1376)
!1378 = !DILocation(line: 549, column: 27, scope: !1376)
!1379 = !DILocation(line: 549, column: 7, scope: !1376)
!1380 = !DILocation(line: 550, column: 5, scope: !1376)
!1381 = !DILocation(line: 548, column: 22, scope: !1372)
!1382 = !DILocation(line: 548, column: 5, scope: !1372)
!1383 = distinct !{!1383, !1374, !1384, !307}
!1384 = !DILocation(line: 550, column: 5, scope: !1368)
!1385 = !DILocation(line: 552, column: 10, scope: !1242)
!1386 = !DILocation(line: 554, column: 8, scope: !1387)
!1387 = distinct !DILexicalBlock(scope: !1242, file: !2, line: 554, column: 8)
!1388 = !DILocation(line: 554, column: 13, scope: !1387)
!1389 = !DILocation(line: 554, column: 8, scope: !1242)
!1390 = !DILocation(line: 556, column: 22, scope: !1391)
!1391 = distinct !DILexicalBlock(scope: !1387, file: !2, line: 555, column: 4)
!1392 = !DILocation(line: 556, column: 14, scope: !1391)
!1393 = !DILocation(line: 557, column: 8, scope: !1391)
!1394 = !DILocation(line: 560, column: 20, scope: !1242)
!1395 = !DILocation(line: 560, column: 29, scope: !1242)
!1396 = !DILocation(line: 560, column: 13, scope: !1242)
!1397 = !DILocation(line: 560, column: 11, scope: !1242)
!1398 = !DILocation(line: 561, column: 9, scope: !1399)
!1399 = distinct !DILexicalBlock(scope: !1242, file: !2, line: 561, column: 8)
!1400 = !DILocation(line: 561, column: 8, scope: !1242)
!1401 = !DILocation(line: 563, column: 22, scope: !1402)
!1402 = distinct !DILexicalBlock(scope: !1399, file: !2, line: 562, column: 4)
!1403 = !DILocation(line: 563, column: 14, scope: !1402)
!1404 = !DILocation(line: 564, column: 8, scope: !1402)
!1405 = !DILocation(line: 567, column: 8, scope: !1406)
!1406 = distinct !DILexicalBlock(scope: !1242, file: !2, line: 567, column: 8)
!1407 = !DILocation(line: 567, column: 13, scope: !1406)
!1408 = !DILocation(line: 567, column: 8, scope: !1242)
!1409 = !DILocation(line: 569, column: 24, scope: !1410)
!1410 = distinct !DILexicalBlock(scope: !1406, file: !2, line: 568, column: 4)
!1411 = !DILocation(line: 569, column: 33, scope: !1410)
!1412 = !DILocation(line: 569, column: 17, scope: !1410)
!1413 = !DILocation(line: 569, column: 15, scope: !1410)
!1414 = !DILocation(line: 570, column: 13, scope: !1415)
!1415 = distinct !DILexicalBlock(scope: !1410, file: !2, line: 570, column: 12)
!1416 = !DILocation(line: 570, column: 12, scope: !1410)
!1417 = !DILocation(line: 572, column: 19, scope: !1418)
!1418 = distinct !DILexicalBlock(scope: !1415, file: !2, line: 571, column: 8)
!1419 = !DILocation(line: 572, column: 11, scope: !1418)
!1420 = !DILocation(line: 573, column: 5, scope: !1418)
!1421 = !DILocation(line: 575, column: 4, scope: !1410)
!1422 = !DILocation(line: 577, column: 8, scope: !1423)
!1423 = distinct !DILexicalBlock(scope: !1406, file: !2, line: 576, column: 4)
!1424 = !DILocation(line: 577, column: 15, scope: !1423)
!1425 = !DILocation(line: 580, column: 11, scope: !1242)
!1426 = !DILocation(line: 580, column: 16, scope: !1242)
!1427 = !DILocation(line: 580, column: 4, scope: !1242)
!1428 = !DILocation(line: 581, column: 4, scope: !1242)
!1429 = distinct !DISubprogram(name: "Caseerror", scope: !2, file: !2, line: 585, type: !1430, scopeLine: 587, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !61)
!1430 = !DISubroutineType(types: !1431)
!1431 = !{null, !60}
!1432 = !DILocalVariable(name: "n", arg: 1, scope: !1429, file: !2, line: 586, type: !60)
!1433 = !DILocation(line: 586, column: 6, scope: !1429)
!1434 = !DILocation(line: 588, column: 16, scope: !1429)
!1435 = !DILocation(line: 588, column: 56, scope: !1429)
!1436 = !DILocation(line: 588, column: 8, scope: !1429)
!1437 = !DILocation(line: 589, column: 2, scope: !1429)
