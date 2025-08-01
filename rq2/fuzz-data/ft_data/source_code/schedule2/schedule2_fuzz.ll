; ModuleID = 'schedule2_fuzz.c'
source_filename = "schedule2_fuzz.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

%struct.queue = type { i32, ptr }
%struct.process = type { i32, i32, ptr }

@__stdinp = external global ptr, align 8
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [6 x i8] c"%*s%d\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [6 x i8] c"%*s%f\00", align 1, !dbg !12
@.str.3 = private unnamed_addr constant [8 x i8] c"%*s%d%f\00", align 1, !dbg !14
@next_pid = internal global i32 0, align 4, !dbg !19
@current_job = internal global ptr null, align 8, !dbg !43
@__stdoutp = external global ptr, align 8
@.str.4 = private unnamed_addr constant [4 x i8] c" %d\00", align 1, !dbg !33
@.str.5 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1, !dbg !38
@prio_queue = internal global [4 x %struct.queue] zeroinitializer, align 8, !dbg !45
@afl_init_argv.in_buf = internal global [100000 x i8] zeroinitializer, align 1, !dbg !52
@afl_init_argv.ret = internal global [1000 x ptr] zeroinitializer, align 8, !dbg !65

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @enqueue(i32 noundef %0, ptr noundef %1) #0 !dbg !77 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store i32 %0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !80, metadata !DIExpression()), !dbg !81
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !82, metadata !DIExpression()), !dbg !83
  call void @llvm.dbg.declare(metadata ptr %6, metadata !84, metadata !DIExpression()), !dbg !85
  %7 = load i32, ptr %4, align 4, !dbg !86
  %8 = load ptr, ptr %5, align 8, !dbg !88
  %9 = call i32 @put_end(i32 noundef %7, ptr noundef %8), !dbg !89
  store i32 %9, ptr %6, align 4, !dbg !90
  %10 = icmp ne i32 %9, 0, !dbg !90
  br i1 %10, label %11, label %13, !dbg !91

11:                                               ; preds = %2
  %12 = load i32, ptr %6, align 4, !dbg !92
  store i32 %12, ptr %3, align 4, !dbg !93
  br label %16, !dbg !93

13:                                               ; preds = %2
  %14 = load i32, ptr %4, align 4, !dbg !94
  %15 = call i32 @reschedule(i32 noundef %14), !dbg !95
  store i32 %15, ptr %3, align 4, !dbg !96
  br label %16, !dbg !96

16:                                               ; preds = %13, %11
  %17 = load i32, ptr %3, align 4, !dbg !97
  ret i32 %17, !dbg !97
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main(i32 noundef %0, ptr noundef %1) #0 !dbg !98 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca float, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca ptr, align 8
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !101, metadata !DIExpression()), !dbg !102
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !103, metadata !DIExpression()), !dbg !104
  br label %13, !dbg !105

13:                                               ; preds = %2
  %14 = call ptr @afl_init_argv(ptr noundef %4), !dbg !106
  store ptr %14, ptr %5, align 8, !dbg !106
  br label %15, !dbg !106

15:                                               ; preds = %13
  %16 = call i32 @"\01_usleep"(i32 noundef 0), !dbg !108
  call void @llvm.dbg.declare(metadata ptr %6, metadata !109, metadata !DIExpression()), !dbg !110
  call void @llvm.dbg.declare(metadata ptr %7, metadata !111, metadata !DIExpression()), !dbg !112
  call void @llvm.dbg.declare(metadata ptr %8, metadata !113, metadata !DIExpression()), !dbg !115
  call void @llvm.dbg.declare(metadata ptr %9, metadata !116, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.declare(metadata ptr %10, metadata !118, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.declare(metadata ptr %11, metadata !120, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.declare(metadata ptr %12, metadata !122, metadata !DIExpression()), !dbg !123
  %17 = load i32, ptr %4, align 4, !dbg !124
  %18 = icmp ne i32 %17, 4, !dbg !126
  br i1 %18, label %19, label %21, !dbg !127

19:                                               ; preds = %15
  %20 = call i32 @exit_here(i32 noundef -1), !dbg !128
  br label %21, !dbg !128

21:                                               ; preds = %19, %15
  store i32 3, ptr %7, align 4, !dbg !129
  br label %22, !dbg !131

22:                                               ; preds = %52, %21
  %23 = load i32, ptr %7, align 4, !dbg !132
  %24 = icmp sgt i32 %23, 0, !dbg !134
  br i1 %24, label %25, label %55, !dbg !135

25:                                               ; preds = %22
  %26 = load ptr, ptr %5, align 8, !dbg !136
  %27 = load i32, ptr %7, align 4, !dbg !139
  %28 = sub nsw i32 4, %27, !dbg !140
  %29 = sext i32 %28 to i64, !dbg !136
  %30 = getelementptr inbounds ptr, ptr %26, i64 %29, !dbg !136
  %31 = load ptr, ptr %30, align 8, !dbg !136
  %32 = call i32 @atoi(ptr noundef %31), !dbg !141
  store i32 %32, ptr %9, align 4, !dbg !142
  %33 = icmp slt i32 %32, 0, !dbg !143
  br i1 %33, label %34, label %36, !dbg !144

34:                                               ; preds = %25
  %35 = call i32 @exit_here(i32 noundef -2), !dbg !145
  br label %36, !dbg !145

36:                                               ; preds = %34, %25
  br label %37, !dbg !146

37:                                               ; preds = %48, %36
  %38 = load i32, ptr %9, align 4, !dbg !147
  %39 = icmp sgt i32 %38, 0, !dbg !150
  br i1 %39, label %40, label %51, !dbg !151

40:                                               ; preds = %37
  %41 = load i32, ptr %7, align 4, !dbg !152
  %42 = call i32 @new_job(i32 noundef %41), !dbg !155
  store i32 %42, ptr %10, align 4, !dbg !156
  %43 = icmp ne i32 %42, 0, !dbg !156
  br i1 %43, label %44, label %47, !dbg !157

44:                                               ; preds = %40
  %45 = load i32, ptr %10, align 4, !dbg !158
  %46 = call i32 @exit_here(i32 noundef %45), !dbg !159
  br label %47, !dbg !159

47:                                               ; preds = %44, %40
  br label %48, !dbg !160

48:                                               ; preds = %47
  %49 = load i32, ptr %9, align 4, !dbg !161
  %50 = add nsw i32 %49, -1, !dbg !161
  store i32 %50, ptr %9, align 4, !dbg !161
  br label %37, !dbg !162, !llvm.loop !163

51:                                               ; preds = %37
  br label %52, !dbg !166

52:                                               ; preds = %51
  %53 = load i32, ptr %7, align 4, !dbg !167
  %54 = add nsw i32 %53, -1, !dbg !167
  store i32 %54, ptr %7, align 4, !dbg !167
  br label %22, !dbg !168, !llvm.loop !169

55:                                               ; preds = %22
  br label %56, !dbg !171

56:                                               ; preds = %59, %55
  %57 = call i32 @get_command(ptr noundef %6, ptr noundef %7, ptr noundef %8), !dbg !172
  store i32 %57, ptr %10, align 4, !dbg !173
  %58 = icmp sgt i32 %57, 0, !dbg !174
  br i1 %58, label %59, label %65, !dbg !171

59:                                               ; preds = %56
  %60 = load i32, ptr %6, align 4, !dbg !175
  %61 = load i32, ptr %7, align 4, !dbg !177
  %62 = load float, ptr %8, align 4, !dbg !178
  %63 = fpext float %62 to double, !dbg !178
  %64 = call i32 @schedule(i32 noundef %60, i32 noundef %61, double noundef %63), !dbg !179
  br label %56, !dbg !171, !llvm.loop !180

65:                                               ; preds = %56
  %66 = load i32, ptr %10, align 4, !dbg !182
  %67 = icmp slt i32 %66, 0, !dbg !184
  br i1 %67, label %68, label %71, !dbg !185

68:                                               ; preds = %65
  %69 = load i32, ptr %10, align 4, !dbg !186
  %70 = call i32 @exit_here(i32 noundef %69), !dbg !187
  br label %71, !dbg !187

71:                                               ; preds = %68, %65
  %72 = call i32 @exit_here(i32 noundef 0), !dbg !188
  %73 = load i32, ptr %3, align 4, !dbg !189
  ret i32 %73, !dbg !189
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define internal ptr @afl_init_argv(ptr noundef %0) #0 !dbg !54 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !190, metadata !DIExpression()), !dbg !191
  call void @llvm.dbg.declare(metadata ptr %3, metadata !192, metadata !DIExpression()), !dbg !193
  store ptr @afl_init_argv.in_buf, ptr %3, align 8, !dbg !193
  call void @llvm.dbg.declare(metadata ptr %4, metadata !194, metadata !DIExpression()), !dbg !195
  store i32 0, ptr %4, align 4, !dbg !195
  %5 = call i64 @"\01_read"(i32 noundef 0, ptr noundef @afl_init_argv.in_buf, i64 noundef 99998), !dbg !196
  %6 = icmp slt i64 %5, 0, !dbg !198
  br i1 %6, label %7, label %8, !dbg !199

7:                                                ; preds = %1
  br label %8, !dbg !199

8:                                                ; preds = %7, %1
  br label %9, !dbg !200

9:                                                ; preds = %50, %8
  %10 = load ptr, ptr %3, align 8, !dbg !201
  %11 = load i8, ptr %10, align 1, !dbg !202
  %12 = icmp ne i8 %11, 0, !dbg !200
  br i1 %12, label %13, label %53, !dbg !200

13:                                               ; preds = %9
  %14 = load ptr, ptr %3, align 8, !dbg !203
  %15 = load i32, ptr %4, align 4, !dbg !205
  %16 = sext i32 %15 to i64, !dbg !206
  %17 = getelementptr inbounds [1000 x ptr], ptr @afl_init_argv.ret, i64 0, i64 %16, !dbg !206
  store ptr %14, ptr %17, align 8, !dbg !207
  %18 = load i32, ptr %4, align 4, !dbg !208
  %19 = sext i32 %18 to i64, !dbg !210
  %20 = getelementptr inbounds [1000 x ptr], ptr @afl_init_argv.ret, i64 0, i64 %19, !dbg !210
  %21 = load ptr, ptr %20, align 8, !dbg !210
  %22 = getelementptr inbounds i8, ptr %21, i64 0, !dbg !210
  %23 = load i8, ptr %22, align 1, !dbg !210
  %24 = sext i8 %23 to i32, !dbg !210
  %25 = icmp eq i32 %24, 2, !dbg !211
  br i1 %25, label %26, label %40, !dbg !212

26:                                               ; preds = %13
  %27 = load i32, ptr %4, align 4, !dbg !213
  %28 = sext i32 %27 to i64, !dbg !214
  %29 = getelementptr inbounds [1000 x ptr], ptr @afl_init_argv.ret, i64 0, i64 %28, !dbg !214
  %30 = load ptr, ptr %29, align 8, !dbg !214
  %31 = getelementptr inbounds i8, ptr %30, i64 1, !dbg !214
  %32 = load i8, ptr %31, align 1, !dbg !214
  %33 = icmp ne i8 %32, 0, !dbg !214
  br i1 %33, label %40, label %34, !dbg !215

34:                                               ; preds = %26
  %35 = load i32, ptr %4, align 4, !dbg !216
  %36 = sext i32 %35 to i64, !dbg !217
  %37 = getelementptr inbounds [1000 x ptr], ptr @afl_init_argv.ret, i64 0, i64 %36, !dbg !217
  %38 = load ptr, ptr %37, align 8, !dbg !218
  %39 = getelementptr inbounds i8, ptr %38, i32 1, !dbg !218
  store ptr %39, ptr %37, align 8, !dbg !218
  br label %40, !dbg !217

40:                                               ; preds = %34, %26, %13
  %41 = load i32, ptr %4, align 4, !dbg !219
  %42 = add nsw i32 %41, 1, !dbg !219
  store i32 %42, ptr %4, align 4, !dbg !219
  br label %43, !dbg !220

43:                                               ; preds = %47, %40
  %44 = load ptr, ptr %3, align 8, !dbg !221
  %45 = load i8, ptr %44, align 1, !dbg !222
  %46 = icmp ne i8 %45, 0, !dbg !220
  br i1 %46, label %47, label %50, !dbg !220

47:                                               ; preds = %43
  %48 = load ptr, ptr %3, align 8, !dbg !223
  %49 = getelementptr inbounds i8, ptr %48, i32 1, !dbg !223
  store ptr %49, ptr %3, align 8, !dbg !223
  br label %43, !dbg !220, !llvm.loop !224

50:                                               ; preds = %43
  %51 = load ptr, ptr %3, align 8, !dbg !225
  %52 = getelementptr inbounds i8, ptr %51, i32 1, !dbg !225
  store ptr %52, ptr %3, align 8, !dbg !225
  br label %9, !dbg !200, !llvm.loop !226

53:                                               ; preds = %9
  %54 = load i32, ptr %4, align 4, !dbg !228
  %55 = load ptr, ptr %2, align 8, !dbg !229
  store i32 %54, ptr %55, align 4, !dbg !230
  ret ptr @afl_init_argv.ret, !dbg !231
}

declare i32 @"\01_usleep"(i32 noundef) #2

declare i32 @atoi(ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @get_command(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !232 {
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  %9 = alloca [20 x i8], align 1
  store ptr %0, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !236, metadata !DIExpression()), !dbg !237
  store ptr %1, ptr %6, align 8
  call void @llvm.dbg.declare(metadata ptr %6, metadata !238, metadata !DIExpression()), !dbg !239
  store ptr %2, ptr %7, align 8
  call void @llvm.dbg.declare(metadata ptr %7, metadata !240, metadata !DIExpression()), !dbg !241
  call void @llvm.dbg.declare(metadata ptr %8, metadata !242, metadata !DIExpression()), !dbg !243
  store i32 0, ptr %8, align 4, !dbg !243
  call void @llvm.dbg.declare(metadata ptr %9, metadata !244, metadata !DIExpression()), !dbg !248
  %10 = getelementptr inbounds [20 x i8], ptr %9, i64 0, i64 0, !dbg !249
  %11 = load ptr, ptr @__stdinp, align 8, !dbg !251
  %12 = call ptr @fgets(ptr noundef %10, i32 noundef 20, ptr noundef %11), !dbg !252
  %13 = icmp ne ptr %12, null, !dbg !252
  br i1 %13, label %14, label %54, !dbg !253

14:                                               ; preds = %3
  %15 = load ptr, ptr %5, align 8, !dbg !254
  store i32 -1, ptr %15, align 4, !dbg !256
  %16 = load ptr, ptr %6, align 8, !dbg !257
  store i32 -1, ptr %16, align 4, !dbg !258
  %17 = load ptr, ptr %7, align 8, !dbg !259
  store float -1.000000e+00, ptr %17, align 4, !dbg !260
  %18 = getelementptr inbounds [20 x i8], ptr %9, i64 0, i64 0, !dbg !261
  %19 = load ptr, ptr %5, align 8, !dbg !262
  %20 = call i32 (ptr, ptr, ...) @sscanf(ptr noundef %18, ptr noundef @.str, ptr noundef %19), !dbg !263
  %21 = load ptr, ptr %5, align 8, !dbg !264
  %22 = load i32, ptr %21, align 4, !dbg !265
  switch i32 %22, label %36 [
    i32 1, label %23
    i32 4, label %27
    i32 2, label %31
  ], !dbg !266

23:                                               ; preds = %14
  %24 = getelementptr inbounds [20 x i8], ptr %9, i64 0, i64 0, !dbg !267
  %25 = load ptr, ptr %6, align 8, !dbg !269
  %26 = call i32 (ptr, ptr, ...) @sscanf(ptr noundef %24, ptr noundef @.str.1, ptr noundef %25), !dbg !270
  br label %36, !dbg !271

27:                                               ; preds = %14
  %28 = getelementptr inbounds [20 x i8], ptr %9, i64 0, i64 0, !dbg !272
  %29 = load ptr, ptr %7, align 8, !dbg !273
  %30 = call i32 (ptr, ptr, ...) @sscanf(ptr noundef %28, ptr noundef @.str.2, ptr noundef %29), !dbg !274
  br label %36, !dbg !275

31:                                               ; preds = %14
  %32 = getelementptr inbounds [20 x i8], ptr %9, i64 0, i64 0, !dbg !276
  %33 = load ptr, ptr %6, align 8, !dbg !277
  %34 = load ptr, ptr %7, align 8, !dbg !278
  %35 = call i32 (ptr, ptr, ...) @sscanf(ptr noundef %32, ptr noundef @.str.3, ptr noundef %33, ptr noundef %34), !dbg !279
  br label %36, !dbg !280

36:                                               ; preds = %14, %31, %27, %23
  br label %37, !dbg !281

37:                                               ; preds = %52, %36
  %38 = getelementptr inbounds [20 x i8], ptr %9, i64 0, i64 0, !dbg !282
  %39 = call i64 @strlen(ptr noundef %38), !dbg !283
  %40 = sub i64 %39, 1, !dbg !284
  %41 = getelementptr inbounds [20 x i8], ptr %9, i64 0, i64 %40, !dbg !285
  %42 = load i8, ptr %41, align 1, !dbg !285
  %43 = sext i8 %42 to i32, !dbg !285
  %44 = icmp ne i32 %43, 10, !dbg !286
  br i1 %44, label %45, label %50, !dbg !287

45:                                               ; preds = %37
  %46 = getelementptr inbounds [20 x i8], ptr %9, i64 0, i64 0, !dbg !288
  %47 = load ptr, ptr @__stdinp, align 8, !dbg !289
  %48 = call ptr @fgets(ptr noundef %46, i32 noundef 20, ptr noundef %47), !dbg !290
  %49 = icmp ne ptr %48, null, !dbg !287
  br label %50

50:                                               ; preds = %45, %37
  %51 = phi i1 [ false, %37 ], [ %49, %45 ], !dbg !291
  br i1 %51, label %52, label %53, !dbg !281

52:                                               ; preds = %50
  br label %37, !dbg !281, !llvm.loop !292

53:                                               ; preds = %50
  store i32 1, ptr %4, align 4, !dbg !294
  br label %55, !dbg !294

54:                                               ; preds = %3
  store i32 0, ptr %4, align 4, !dbg !295
  br label %55, !dbg !295

55:                                               ; preds = %54, %53
  %56 = load i32, ptr %4, align 4, !dbg !296
  ret i32 %56, !dbg !296
}

declare ptr @fgets(ptr noundef, i32 noundef, ptr noundef) #2

declare i32 @sscanf(ptr noundef, ptr noundef, ...) #2

declare i64 @strlen(ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @exit_here(i32 noundef %0) #0 !dbg !297 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !300, metadata !DIExpression()), !dbg !301
  %3 = load i32, ptr %2, align 4, !dbg !302
  %4 = call i32 @abs(i32 noundef %3) #6, !dbg !303
  call void @exit(i32 noundef %4) #7, !dbg !304
  unreachable, !dbg !304
}

; Function Attrs: noreturn
declare void @exit(i32 noundef) #3

; Function Attrs: nounwind readnone willreturn
declare i32 @abs(i32 noundef) #4

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @new_job(i32 noundef %0) #0 !dbg !305 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !306, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.declare(metadata ptr %3, metadata !308, metadata !DIExpression()), !dbg !309
  call void @llvm.dbg.declare(metadata ptr %4, metadata !310, metadata !DIExpression()), !dbg !311
  store i32 0, ptr %4, align 4, !dbg !311
  call void @llvm.dbg.declare(metadata ptr %5, metadata !312, metadata !DIExpression()), !dbg !313
  %6 = load i32, ptr @next_pid, align 4, !dbg !314
  %7 = add nsw i32 %6, 1, !dbg !314
  store i32 %7, ptr @next_pid, align 4, !dbg !314
  store i32 %6, ptr %3, align 4, !dbg !315
  %8 = call ptr @malloc(i64 noundef 16) #8, !dbg !316
  store ptr %8, ptr %5, align 8, !dbg !317
  %9 = load ptr, ptr %5, align 8, !dbg !318
  %10 = icmp ne ptr %9, null, !dbg !318
  br i1 %10, label %12, label %11, !dbg !320

11:                                               ; preds = %1
  store i32 -3, ptr %4, align 4, !dbg !321
  br label %29, !dbg !322

12:                                               ; preds = %1
  %13 = load i32, ptr %3, align 4, !dbg !323
  %14 = load ptr, ptr %5, align 8, !dbg !325
  %15 = getelementptr inbounds %struct.process, ptr %14, i32 0, i32 0, !dbg !326
  store i32 %13, ptr %15, align 8, !dbg !327
  %16 = load i32, ptr %2, align 4, !dbg !328
  %17 = load ptr, ptr %5, align 8, !dbg !329
  %18 = getelementptr inbounds %struct.process, ptr %17, i32 0, i32 1, !dbg !330
  store i32 %16, ptr %18, align 4, !dbg !331
  %19 = load ptr, ptr %5, align 8, !dbg !332
  %20 = getelementptr inbounds %struct.process, ptr %19, i32 0, i32 2, !dbg !333
  store ptr null, ptr %20, align 8, !dbg !334
  %21 = load i32, ptr %2, align 4, !dbg !335
  %22 = load ptr, ptr %5, align 8, !dbg !336
  %23 = call i32 @enqueue(i32 noundef %21, ptr noundef %22), !dbg !337
  store i32 %23, ptr %4, align 4, !dbg !338
  %24 = load i32, ptr %4, align 4, !dbg !339
  %25 = icmp ne i32 %24, 0, !dbg !339
  br i1 %25, label %26, label %28, !dbg !341

26:                                               ; preds = %12
  %27 = load ptr, ptr %5, align 8, !dbg !342
  call void @free(ptr noundef %27), !dbg !344
  br label %28, !dbg !345

28:                                               ; preds = %26, %12
  br label %29

29:                                               ; preds = %28, %11
  %30 = load i32, ptr %4, align 4, !dbg !346
  %31 = icmp ne i32 %30, 0, !dbg !346
  br i1 %31, label %32, label %35, !dbg !348

32:                                               ; preds = %29
  %33 = load i32, ptr @next_pid, align 4, !dbg !349
  %34 = add nsw i32 %33, -1, !dbg !349
  store i32 %34, ptr @next_pid, align 4, !dbg !349
  br label %35, !dbg !350

35:                                               ; preds = %32, %29
  %36 = load i32, ptr %4, align 4, !dbg !351
  ret i32 %36, !dbg !352
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #5

declare void @free(ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @upgrade_prio(i32 noundef %0, double noundef %1) #0 !dbg !353 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca float, align 4
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = fptrunc double %1 to float
  store i32 %0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !356, metadata !DIExpression()), !dbg !357
  store float %8, ptr %5, align 4
  call void @llvm.dbg.declare(metadata ptr %5, metadata !358, metadata !DIExpression()), !dbg !359
  call void @llvm.dbg.declare(metadata ptr %6, metadata !360, metadata !DIExpression()), !dbg !361
  call void @llvm.dbg.declare(metadata ptr %7, metadata !362, metadata !DIExpression()), !dbg !363
  %9 = load i32, ptr %4, align 4, !dbg !364
  %10 = icmp slt i32 %9, 1, !dbg !366
  br i1 %10, label %14, label %11, !dbg !367

11:                                               ; preds = %2
  %12 = load i32, ptr %4, align 4, !dbg !368
  %13 = icmp sgt i32 %12, 2, !dbg !369
  br i1 %13, label %14, label %15, !dbg !370

14:                                               ; preds = %11, %2
  store i32 -4, ptr %3, align 4, !dbg !371
  br label %32, !dbg !371

15:                                               ; preds = %11
  %16 = load i32, ptr %4, align 4, !dbg !372
  %17 = load float, ptr %5, align 4, !dbg !374
  %18 = fpext float %17 to double, !dbg !374
  %19 = call i32 @get_process(i32 noundef %16, double noundef %18, ptr noundef %7), !dbg !375
  store i32 %19, ptr %6, align 4, !dbg !376
  %20 = icmp sle i32 %19, 0, !dbg !377
  br i1 %20, label %21, label %23, !dbg !378

21:                                               ; preds = %15
  %22 = load i32, ptr %6, align 4, !dbg !379
  store i32 %22, ptr %3, align 4, !dbg !380
  br label %32, !dbg !380

23:                                               ; preds = %15
  %24 = load i32, ptr %4, align 4, !dbg !381
  %25 = add nsw i32 %24, 1, !dbg !382
  %26 = load ptr, ptr %7, align 8, !dbg !383
  %27 = getelementptr inbounds %struct.process, ptr %26, i32 0, i32 1, !dbg !384
  store i32 %25, ptr %27, align 4, !dbg !385
  %28 = load i32, ptr %4, align 4, !dbg !386
  %29 = add nsw i32 %28, 1, !dbg !387
  %30 = load ptr, ptr %7, align 8, !dbg !388
  %31 = call i32 @enqueue(i32 noundef %29, ptr noundef %30), !dbg !389
  store i32 %31, ptr %3, align 4, !dbg !390
  br label %32, !dbg !390

32:                                               ; preds = %23, %21, %14
  %33 = load i32, ptr %3, align 4, !dbg !391
  ret i32 %33, !dbg !391
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @block() #0 !dbg !392 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !395, metadata !DIExpression()), !dbg !396
  %3 = call ptr @get_current(), !dbg !397
  store ptr %3, ptr %2, align 8, !dbg !398
  %4 = load ptr, ptr %2, align 8, !dbg !399
  %5 = icmp ne ptr %4, null, !dbg !399
  br i1 %5, label %6, label %9, !dbg !401

6:                                                ; preds = %0
  store ptr null, ptr @current_job, align 8, !dbg !402
  %7 = load ptr, ptr %2, align 8, !dbg !404
  %8 = call i32 @enqueue(i32 noundef 0, ptr noundef %7), !dbg !405
  store i32 %8, ptr %1, align 4, !dbg !406
  br label %10, !dbg !406

9:                                                ; preds = %0
  store i32 0, ptr %1, align 4, !dbg !407
  br label %10, !dbg !407

10:                                               ; preds = %9, %6
  %11 = load i32, ptr %1, align 4, !dbg !408
  ret i32 %11, !dbg !408
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @unblock(double noundef %0) #0 !dbg !409 {
  %2 = alloca i32, align 4
  %3 = alloca float, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = fptrunc double %0 to float
  store float %6, ptr %3, align 4
  call void @llvm.dbg.declare(metadata ptr %3, metadata !412, metadata !DIExpression()), !dbg !413
  call void @llvm.dbg.declare(metadata ptr %4, metadata !414, metadata !DIExpression()), !dbg !415
  call void @llvm.dbg.declare(metadata ptr %5, metadata !416, metadata !DIExpression()), !dbg !417
  %7 = load float, ptr %3, align 4, !dbg !418
  %8 = fpext float %7 to double, !dbg !418
  %9 = call i32 @get_process(i32 noundef 0, double noundef %8, ptr noundef %5), !dbg !420
  store i32 %9, ptr %4, align 4, !dbg !421
  %10 = icmp sle i32 %9, 0, !dbg !422
  br i1 %10, label %11, label %13, !dbg !423

11:                                               ; preds = %1
  %12 = load i32, ptr %4, align 4, !dbg !424
  store i32 %12, ptr %2, align 4, !dbg !425
  br label %19, !dbg !425

13:                                               ; preds = %1
  %14 = load ptr, ptr %5, align 8, !dbg !426
  %15 = getelementptr inbounds %struct.process, ptr %14, i32 0, i32 1, !dbg !427
  %16 = load i32, ptr %15, align 4, !dbg !427
  %17 = load ptr, ptr %5, align 8, !dbg !428
  %18 = call i32 @enqueue(i32 noundef %16, ptr noundef %17), !dbg !429
  store i32 %18, ptr %2, align 4, !dbg !430
  br label %19, !dbg !430

19:                                               ; preds = %13, %11
  %20 = load i32, ptr %2, align 4, !dbg !431
  ret i32 %20, !dbg !431
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @quantum_expire() #0 !dbg !432 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !433, metadata !DIExpression()), !dbg !434
  %3 = call ptr @get_current(), !dbg !435
  store ptr %3, ptr %2, align 8, !dbg !436
  %4 = load ptr, ptr %2, align 8, !dbg !437
  %5 = icmp ne ptr %4, null, !dbg !437
  br i1 %5, label %6, label %12, !dbg !439

6:                                                ; preds = %0
  store ptr null, ptr @current_job, align 8, !dbg !440
  %7 = load ptr, ptr %2, align 8, !dbg !442
  %8 = getelementptr inbounds %struct.process, ptr %7, i32 0, i32 1, !dbg !443
  %9 = load i32, ptr %8, align 4, !dbg !443
  %10 = load ptr, ptr %2, align 8, !dbg !444
  %11 = call i32 @enqueue(i32 noundef %9, ptr noundef %10), !dbg !445
  store i32 %11, ptr %1, align 4, !dbg !446
  br label %13, !dbg !446

12:                                               ; preds = %0
  store i32 0, ptr %1, align 4, !dbg !447
  br label %13, !dbg !447

13:                                               ; preds = %12, %6
  %14 = load i32, ptr %1, align 4, !dbg !448
  ret i32 %14, !dbg !448
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @finish() #0 !dbg !449 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !450, metadata !DIExpression()), !dbg !451
  %3 = call ptr @get_current(), !dbg !452
  store ptr %3, ptr %2, align 8, !dbg !453
  %4 = load ptr, ptr %2, align 8, !dbg !454
  %5 = icmp ne ptr %4, null, !dbg !454
  br i1 %5, label %6, label %14, !dbg !456

6:                                                ; preds = %0
  store ptr null, ptr @current_job, align 8, !dbg !457
  %7 = call i32 @reschedule(i32 noundef 0), !dbg !459
  %8 = load ptr, ptr @__stdoutp, align 8, !dbg !460
  %9 = load ptr, ptr %2, align 8, !dbg !461
  %10 = getelementptr inbounds %struct.process, ptr %9, i32 0, i32 0, !dbg !462
  %11 = load i32, ptr %10, align 8, !dbg !462
  %12 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %8, ptr noundef @.str.4, i32 noundef %11), !dbg !463
  %13 = load ptr, ptr %2, align 8, !dbg !464
  call void @free(ptr noundef %13), !dbg !465
  store i32 0, ptr %1, align 4, !dbg !466
  br label %15, !dbg !466

14:                                               ; preds = %0
  store i32 1, ptr %1, align 4, !dbg !467
  br label %15, !dbg !467

15:                                               ; preds = %14, %6
  %16 = load i32, ptr %1, align 4, !dbg !468
  ret i32 %16, !dbg !468
}

declare i32 @fprintf(ptr noundef, ptr noundef, ...) #2

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @flush() #0 !dbg !469 {
  br label %1, !dbg !470

1:                                                ; preds = %5, %0
  %2 = call i32 @finish(), !dbg !471
  %3 = icmp ne i32 %2, 0, !dbg !472
  %4 = xor i1 %3, true, !dbg !472
  br i1 %4, label %5, label %6, !dbg !470

5:                                                ; preds = %1
  br label %1, !dbg !470, !llvm.loop !473

6:                                                ; preds = %1
  %7 = load ptr, ptr @__stdoutp, align 8, !dbg !475
  %8 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %7, ptr noundef @.str.5), !dbg !476
  ret i32 0, !dbg !477
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define ptr @get_current() #0 !dbg !478 {
  %1 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata ptr %1, metadata !480, metadata !DIExpression()), !dbg !481
  %2 = load ptr, ptr @current_job, align 8, !dbg !482
  %3 = icmp ne ptr %2, null, !dbg !482
  br i1 %3, label %18, label %4, !dbg !484

4:                                                ; preds = %0
  store i32 3, ptr %1, align 4, !dbg !485
  br label %5, !dbg !488

5:                                                ; preds = %14, %4
  %6 = load i32, ptr %1, align 4, !dbg !489
  %7 = icmp sgt i32 %6, 0, !dbg !491
  br i1 %7, label %8, label %17, !dbg !492

8:                                                ; preds = %5
  %9 = load i32, ptr %1, align 4, !dbg !493
  %10 = call i32 @get_process(i32 noundef %9, double noundef 0.000000e+00, ptr noundef @current_job), !dbg !496
  %11 = icmp sgt i32 %10, 0, !dbg !497
  br i1 %11, label %12, label %13, !dbg !498

12:                                               ; preds = %8
  br label %17, !dbg !499

13:                                               ; preds = %8
  br label %14, !dbg !500

14:                                               ; preds = %13
  %15 = load i32, ptr %1, align 4, !dbg !501
  %16 = add nsw i32 %15, -1, !dbg !501
  store i32 %16, ptr %1, align 4, !dbg !501
  br label %5, !dbg !502, !llvm.loop !503

17:                                               ; preds = %12, %5
  br label %18, !dbg !505

18:                                               ; preds = %17, %0
  %19 = load ptr, ptr @current_job, align 8, !dbg !506
  ret ptr %19, !dbg !507
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @reschedule(i32 noundef %0) #0 !dbg !508 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !509, metadata !DIExpression()), !dbg !510
  %3 = load ptr, ptr @current_job, align 8, !dbg !511
  %4 = icmp ne ptr %3, null, !dbg !511
  br i1 %4, label %5, label %17, !dbg !513

5:                                                ; preds = %1
  %6 = load i32, ptr %2, align 4, !dbg !514
  %7 = load ptr, ptr @current_job, align 8, !dbg !515
  %8 = getelementptr inbounds %struct.process, ptr %7, i32 0, i32 1, !dbg !516
  %9 = load i32, ptr %8, align 4, !dbg !516
  %10 = icmp sgt i32 %6, %9, !dbg !517
  br i1 %10, label %11, label %17, !dbg !518

11:                                               ; preds = %5
  %12 = load ptr, ptr @current_job, align 8, !dbg !519
  %13 = getelementptr inbounds %struct.process, ptr %12, i32 0, i32 1, !dbg !521
  %14 = load i32, ptr %13, align 4, !dbg !521
  %15 = load ptr, ptr @current_job, align 8, !dbg !522
  %16 = call i32 @put_end(i32 noundef %14, ptr noundef %15), !dbg !523
  store ptr null, ptr @current_job, align 8, !dbg !524
  br label %17, !dbg !525

17:                                               ; preds = %11, %5, %1
  %18 = call ptr @get_current(), !dbg !526
  ret i32 0, !dbg !527
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @schedule(i32 noundef %0, i32 noundef %1, double noundef %2) #0 !dbg !528 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca float, align 4
  %7 = alloca i32, align 4
  %8 = fptrunc double %2 to float
  store i32 %0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !531, metadata !DIExpression()), !dbg !532
  store i32 %1, ptr %5, align 4
  call void @llvm.dbg.declare(metadata ptr %5, metadata !533, metadata !DIExpression()), !dbg !534
  store float %8, ptr %6, align 4
  call void @llvm.dbg.declare(metadata ptr %6, metadata !535, metadata !DIExpression()), !dbg !536
  call void @llvm.dbg.declare(metadata ptr %7, metadata !537, metadata !DIExpression()), !dbg !538
  store i32 0, ptr %7, align 4, !dbg !538
  %9 = load i32, ptr %4, align 4, !dbg !539
  switch i32 %9, label %32 [
    i32 1, label %10
    i32 5, label %13
    i32 2, label %15
    i32 3, label %20
    i32 4, label %22
    i32 6, label %26
    i32 7, label %30
  ], !dbg !540

10:                                               ; preds = %3
  %11 = load i32, ptr %5, align 4, !dbg !541
  %12 = call i32 @new_job(i32 noundef %11), !dbg !543
  store i32 %12, ptr %7, align 4, !dbg !544
  br label %33, !dbg !545

13:                                               ; preds = %3
  %14 = call i32 @quantum_expire(), !dbg !546
  store i32 %14, ptr %7, align 4, !dbg !547
  br label %33, !dbg !548

15:                                               ; preds = %3
  %16 = load i32, ptr %5, align 4, !dbg !549
  %17 = load float, ptr %6, align 4, !dbg !550
  %18 = fpext float %17 to double, !dbg !550
  %19 = call i32 @upgrade_prio(i32 noundef %16, double noundef %18), !dbg !551
  store i32 %19, ptr %7, align 4, !dbg !552
  br label %33, !dbg !553

20:                                               ; preds = %3
  %21 = call i32 @block(), !dbg !554
  store i32 %21, ptr %7, align 4, !dbg !555
  br label %33, !dbg !556

22:                                               ; preds = %3
  %23 = load float, ptr %6, align 4, !dbg !557
  %24 = fpext float %23 to double, !dbg !557
  %25 = call i32 @unblock(double noundef %24), !dbg !558
  store i32 %25, ptr %7, align 4, !dbg !559
  br label %33, !dbg !560

26:                                               ; preds = %3
  %27 = call i32 @finish(), !dbg !561
  %28 = load ptr, ptr @__stdoutp, align 8, !dbg !562
  %29 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %28, ptr noundef @.str.5), !dbg !563
  br label %33, !dbg !564

30:                                               ; preds = %3
  %31 = call i32 @flush(), !dbg !565
  store i32 %31, ptr %7, align 4, !dbg !566
  br label %33, !dbg !567

32:                                               ; preds = %3
  store i32 -6, ptr %7, align 4, !dbg !568
  br label %33, !dbg !569

33:                                               ; preds = %32, %30, %26, %22, %20, %15, %13, %10
  %34 = load i32, ptr %7, align 4, !dbg !570
  ret i32 %34, !dbg !571
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @put_end(i32 noundef %0, ptr noundef %1) #0 !dbg !572 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store i32 %0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !573, metadata !DIExpression()), !dbg !574
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !575, metadata !DIExpression()), !dbg !576
  call void @llvm.dbg.declare(metadata ptr %6, metadata !577, metadata !DIExpression()), !dbg !579
  %7 = load i32, ptr %4, align 4, !dbg !580
  %8 = icmp sgt i32 %7, 3, !dbg !582
  br i1 %8, label %12, label %9, !dbg !583

9:                                                ; preds = %2
  %10 = load i32, ptr %4, align 4, !dbg !584
  %11 = icmp slt i32 %10, 0, !dbg !585
  br i1 %11, label %12, label %13, !dbg !586

12:                                               ; preds = %9, %2
  store i32 -4, ptr %3, align 4, !dbg !587
  br label %36, !dbg !587

13:                                               ; preds = %9
  %14 = load i32, ptr %4, align 4, !dbg !588
  %15 = sext i32 %14 to i64, !dbg !590
  %16 = getelementptr inbounds [4 x %struct.queue], ptr @prio_queue, i64 0, i64 %15, !dbg !590
  %17 = getelementptr inbounds %struct.queue, ptr %16, i32 0, i32 1, !dbg !591
  store ptr %17, ptr %6, align 8, !dbg !592
  br label %18, !dbg !593

18:                                               ; preds = %23, %13
  %19 = load ptr, ptr %6, align 8, !dbg !594
  %20 = load ptr, ptr %19, align 8, !dbg !596
  %21 = icmp ne ptr %20, null, !dbg !597
  br i1 %21, label %22, label %27, !dbg !597

22:                                               ; preds = %18
  br label %23, !dbg !597

23:                                               ; preds = %22
  %24 = load ptr, ptr %6, align 8, !dbg !598
  %25 = load ptr, ptr %24, align 8, !dbg !599
  %26 = getelementptr inbounds %struct.process, ptr %25, i32 0, i32 2, !dbg !600
  store ptr %26, ptr %6, align 8, !dbg !601
  br label %18, !dbg !602, !llvm.loop !603

27:                                               ; preds = %18
  %28 = load ptr, ptr %5, align 8, !dbg !605
  %29 = load ptr, ptr %6, align 8, !dbg !606
  store ptr %28, ptr %29, align 8, !dbg !607
  %30 = load i32, ptr %4, align 4, !dbg !608
  %31 = sext i32 %30 to i64, !dbg !609
  %32 = getelementptr inbounds [4 x %struct.queue], ptr @prio_queue, i64 0, i64 %31, !dbg !609
  %33 = getelementptr inbounds %struct.queue, ptr %32, i32 0, i32 0, !dbg !610
  %34 = load i32, ptr %33, align 8, !dbg !611
  %35 = add nsw i32 %34, 1, !dbg !611
  store i32 %35, ptr %33, align 8, !dbg !611
  store i32 0, ptr %3, align 4, !dbg !612
  br label %36, !dbg !612

36:                                               ; preds = %27, %12
  %37 = load i32, ptr %3, align 4, !dbg !613
  ret i32 %37, !dbg !613
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @get_process(i32 noundef %0, double noundef %1, ptr noundef %2) #0 !dbg !614 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca float, align 4
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca ptr, align 8
  %11 = fptrunc double %1 to float
  store i32 %0, ptr %5, align 4
  call void @llvm.dbg.declare(metadata ptr %5, metadata !617, metadata !DIExpression()), !dbg !618
  store float %11, ptr %6, align 4
  call void @llvm.dbg.declare(metadata ptr %6, metadata !619, metadata !DIExpression()), !dbg !620
  store ptr %2, ptr %7, align 8
  call void @llvm.dbg.declare(metadata ptr %7, metadata !621, metadata !DIExpression()), !dbg !622
  call void @llvm.dbg.declare(metadata ptr %8, metadata !623, metadata !DIExpression()), !dbg !624
  call void @llvm.dbg.declare(metadata ptr %9, metadata !625, metadata !DIExpression()), !dbg !626
  call void @llvm.dbg.declare(metadata ptr %10, metadata !627, metadata !DIExpression()), !dbg !628
  %12 = load i32, ptr %5, align 4, !dbg !629
  %13 = icmp sgt i32 %12, 3, !dbg !631
  br i1 %13, label %17, label %14, !dbg !632

14:                                               ; preds = %3
  %15 = load i32, ptr %5, align 4, !dbg !633
  %16 = icmp slt i32 %15, 0, !dbg !634
  br i1 %16, label %17, label %18, !dbg !635

17:                                               ; preds = %14, %3
  store i32 -4, ptr %4, align 4, !dbg !636
  br label %91, !dbg !636

18:                                               ; preds = %14
  %19 = load float, ptr %6, align 4, !dbg !637
  %20 = fpext float %19 to double, !dbg !637
  %21 = fcmp olt double %20, 0.000000e+00, !dbg !639
  br i1 %21, label %26, label %22, !dbg !640

22:                                               ; preds = %18
  %23 = load float, ptr %6, align 4, !dbg !641
  %24 = fpext float %23 to double, !dbg !641
  %25 = fcmp ogt double %24, 1.000000e+00, !dbg !642
  br i1 %25, label %26, label %27, !dbg !643

26:                                               ; preds = %22, %18
  store i32 -5, ptr %4, align 4, !dbg !644
  br label %91, !dbg !644

27:                                               ; preds = %22
  %28 = load i32, ptr %5, align 4, !dbg !645
  %29 = sext i32 %28 to i64, !dbg !646
  %30 = getelementptr inbounds [4 x %struct.queue], ptr @prio_queue, i64 0, i64 %29, !dbg !646
  %31 = getelementptr inbounds %struct.queue, ptr %30, i32 0, i32 0, !dbg !647
  %32 = load i32, ptr %31, align 8, !dbg !647
  store i32 %32, ptr %8, align 4, !dbg !648
  %33 = load float, ptr %6, align 4, !dbg !649
  %34 = load i32, ptr %8, align 4, !dbg !650
  %35 = sitofp i32 %34 to float, !dbg !650
  %36 = fmul float %33, %35, !dbg !651
  %37 = fptosi float %36 to i32, !dbg !649
  store i32 %37, ptr %9, align 4, !dbg !652
  %38 = load i32, ptr %9, align 4, !dbg !653
  %39 = load i32, ptr %8, align 4, !dbg !654
  %40 = icmp sge i32 %38, %39, !dbg !655
  br i1 %40, label %41, label %44, !dbg !653

41:                                               ; preds = %27
  %42 = load i32, ptr %8, align 4, !dbg !656
  %43 = sub nsw i32 %42, 1, !dbg !657
  br label %46, !dbg !653

44:                                               ; preds = %27
  %45 = load i32, ptr %9, align 4, !dbg !658
  br label %46, !dbg !653

46:                                               ; preds = %44, %41
  %47 = phi i32 [ %43, %41 ], [ %45, %44 ], !dbg !653
  store i32 %47, ptr %9, align 4, !dbg !659
  %48 = load i32, ptr %5, align 4, !dbg !660
  %49 = sext i32 %48 to i64, !dbg !662
  %50 = getelementptr inbounds [4 x %struct.queue], ptr @prio_queue, i64 0, i64 %49, !dbg !662
  %51 = getelementptr inbounds %struct.queue, ptr %50, i32 0, i32 1, !dbg !663
  store ptr %51, ptr %10, align 8, !dbg !664
  br label %52, !dbg !665

52:                                               ; preds = %65, %46
  %53 = load i32, ptr %9, align 4, !dbg !666
  %54 = icmp ne i32 %53, 0, !dbg !666
  br i1 %54, label %55, label %59, !dbg !668

55:                                               ; preds = %52
  %56 = load ptr, ptr %10, align 8, !dbg !669
  %57 = load ptr, ptr %56, align 8, !dbg !670
  %58 = icmp ne ptr %57, null, !dbg !668
  br label %59

59:                                               ; preds = %55, %52
  %60 = phi i1 [ false, %52 ], [ %58, %55 ], !dbg !671
  br i1 %60, label %61, label %68, !dbg !672

61:                                               ; preds = %59
  %62 = load ptr, ptr %10, align 8, !dbg !673
  %63 = load ptr, ptr %62, align 8, !dbg !674
  %64 = getelementptr inbounds %struct.process, ptr %63, i32 0, i32 2, !dbg !675
  store ptr %64, ptr %10, align 8, !dbg !676
  br label %65, !dbg !677

65:                                               ; preds = %61
  %66 = load i32, ptr %9, align 4, !dbg !678
  %67 = add nsw i32 %66, -1, !dbg !678
  store i32 %67, ptr %9, align 4, !dbg !678
  br label %52, !dbg !679, !llvm.loop !680

68:                                               ; preds = %59
  %69 = load ptr, ptr %10, align 8, !dbg !682
  %70 = load ptr, ptr %69, align 8, !dbg !683
  %71 = load ptr, ptr %7, align 8, !dbg !684
  store ptr %70, ptr %71, align 8, !dbg !685
  %72 = load ptr, ptr %7, align 8, !dbg !686
  %73 = load ptr, ptr %72, align 8, !dbg !688
  %74 = icmp ne ptr %73, null, !dbg !688
  br i1 %74, label %75, label %90, !dbg !689

75:                                               ; preds = %68
  %76 = load ptr, ptr %10, align 8, !dbg !690
  %77 = load ptr, ptr %76, align 8, !dbg !692
  %78 = getelementptr inbounds %struct.process, ptr %77, i32 0, i32 2, !dbg !693
  %79 = load ptr, ptr %78, align 8, !dbg !693
  %80 = load ptr, ptr %10, align 8, !dbg !694
  store ptr %79, ptr %80, align 8, !dbg !695
  %81 = load ptr, ptr %7, align 8, !dbg !696
  %82 = load ptr, ptr %81, align 8, !dbg !697
  %83 = getelementptr inbounds %struct.process, ptr %82, i32 0, i32 2, !dbg !698
  store ptr null, ptr %83, align 8, !dbg !699
  %84 = load i32, ptr %5, align 4, !dbg !700
  %85 = sext i32 %84 to i64, !dbg !701
  %86 = getelementptr inbounds [4 x %struct.queue], ptr @prio_queue, i64 0, i64 %85, !dbg !701
  %87 = getelementptr inbounds %struct.queue, ptr %86, i32 0, i32 0, !dbg !702
  %88 = load i32, ptr %87, align 8, !dbg !703
  %89 = add nsw i32 %88, -1, !dbg !703
  store i32 %89, ptr %87, align 8, !dbg !703
  store i32 1, ptr %4, align 4, !dbg !704
  br label %91, !dbg !704

90:                                               ; preds = %68
  store i32 0, ptr %4, align 4, !dbg !705
  br label %91, !dbg !705

91:                                               ; preds = %90, %75, %26, %17
  %92 = load i32, ptr %4, align 4, !dbg !706
  ret i32 %92, !dbg !706
}

declare i64 @"\01_read"(i32 noundef, ptr noundef, i64 noundef) #2

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #3 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #4 = { nounwind readnone willreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #5 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #6 = { nounwind readnone willreturn }
attributes #7 = { noreturn }
attributes #8 = { allocsize(0) }

!llvm.dbg.cu = !{!21}
!llvm.module.flags = !{!70, !71, !72, !73, !74, !75}
!llvm.ident = !{!76}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 83, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "schedule2_fuzz.c", directory: "XXX/converter/ft_data/source_code/schedule2")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 24, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 3)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 87, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 48, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 6)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 90, type: !9, isLocal: true, isDefinition: true)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !2, line: 93, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 8)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(name: "next_pid", scope: !21, file: !2, line: 23, type: !30, isLocal: true, isDefinition: true)
!21 = distinct !DICompileUnit(language: DW_LANG_C99, file: !2, producer: "Homebrew clang version 15.0.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !22, globals: !32, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk", sdk: "MacOSX12.sdk")
!22 = !{!23}
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!24 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "process", file: !25, line: 61, size: 128, elements: !26)
!25 = !DIFile(filename: "./schedule2.h", directory: "XXX/converter/ft_data/source_code/schedule2")
!26 = !{!27, !29, !31}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "pid", scope: !24, file: !25, line: 63, baseType: !28, size: 32)
!28 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !24, file: !25, line: 64, baseType: !30, size: 32, offset: 32)
!30 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !24, file: !25, line: 65, baseType: !23, size: 64, offset: 64)
!32 = !{!0, !7, !12, !14, !33, !38, !43, !45, !52, !65, !19}
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(scope: null, file: !2, line: 193, type: !35, isLocal: true, isDefinition: true)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 32, elements: !36)
!36 = !{!37}
!37 = !DISubrange(count: 4)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !2, line: 204, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 16, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 2)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(name: "current_job", scope: !21, file: !2, line: 22, type: !23, isLocal: true, isDefinition: true)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(name: "prio_queue", scope: !21, file: !2, line: 41, type: !47, isLocal: true, isDefinition: true)
!47 = !DICompositeType(tag: DW_TAG_array_type, baseType: !48, size: 512, elements: !36)
!48 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "queue", file: !2, line: 35, size: 128, elements: !49)
!49 = !{!50, !51}
!50 = !DIDerivedType(tag: DW_TAG_member, name: "length", scope: !48, file: !2, line: 37, baseType: !30, size: 32)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !48, file: !2, line: 38, baseType: !23, size: 64, offset: 64)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "in_buf", scope: !54, file: !55, line: 42, type: !62, isLocal: true, isDefinition: true)
!54 = distinct !DISubprogram(name: "afl_init_argv", scope: !55, file: !55, line: 40, type: !56, scopeLine: 40, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !21, retainedNodes: !61)
!55 = !DIFile(filename: "./argv-fuzz-inl.h", directory: "XXX/converter/ft_data/source_code/schedule2")
!56 = !DISubroutineType(types: !57)
!57 = !{!58, !60}
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!61 = !{}
!62 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 800000, elements: !63)
!63 = !{!64}
!64 = !DISubrange(count: 100000)
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(name: "ret", scope: !54, file: !55, line: 43, type: !67, isLocal: true, isDefinition: true)
!67 = !DICompositeType(tag: DW_TAG_array_type, baseType: !59, size: 64000, elements: !68)
!68 = !{!69}
!69 = !DISubrange(count: 1000)
!70 = !{i32 7, !"Dwarf Version", i32 4}
!71 = !{i32 2, !"Debug Info Version", i32 3}
!72 = !{i32 1, !"wchar_size", i32 4}
!73 = !{i32 7, !"PIC Level", i32 2}
!74 = !{i32 7, !"uwtable", i32 2}
!75 = !{i32 7, !"frame-pointer", i32 1}
!76 = !{!"Homebrew clang version 15.0.3"}
!77 = distinct !DISubprogram(name: "enqueue", scope: !2, file: !2, line: 26, type: !78, scopeLine: 29, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!78 = !DISubroutineType(types: !79)
!79 = !{!30, !30, !23}
!80 = !DILocalVariable(name: "prio", arg: 1, scope: !77, file: !2, line: 27, type: !30)
!81 = !DILocation(line: 27, column: 10, scope: !77)
!82 = !DILocalVariable(name: "new_process", arg: 2, scope: !77, file: !2, line: 28, type: !23)
!83 = !DILocation(line: 28, column: 22, scope: !77)
!84 = !DILocalVariable(name: "status", scope: !77, file: !2, line: 30, type: !30)
!85 = !DILocation(line: 30, column: 9, scope: !77)
!86 = !DILocation(line: 31, column: 25, scope: !87)
!87 = distinct !DILexicalBlock(scope: !77, file: !2, line: 31, column: 8)
!88 = !DILocation(line: 31, column: 31, scope: !87)
!89 = !DILocation(line: 31, column: 17, scope: !87)
!90 = !DILocation(line: 31, column: 15, scope: !87)
!91 = !DILocation(line: 31, column: 8, scope: !77)
!92 = !DILocation(line: 31, column: 52, scope: !87)
!93 = !DILocation(line: 31, column: 45, scope: !87)
!94 = !DILocation(line: 32, column: 23, scope: !77)
!95 = !DILocation(line: 32, column: 12, scope: !77)
!96 = !DILocation(line: 32, column: 5, scope: !77)
!97 = !DILocation(line: 33, column: 1, scope: !77)
!98 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 45, type: !99, scopeLine: 48, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!99 = !DISubroutineType(types: !100)
!100 = !{!30, !30, !58}
!101 = !DILocalVariable(name: "argc", arg: 1, scope: !98, file: !2, line: 46, type: !30)
!102 = !DILocation(line: 46, column: 5, scope: !98)
!103 = !DILocalVariable(name: "argv", arg: 2, scope: !98, file: !2, line: 47, type: !58)
!104 = !DILocation(line: 47, column: 7, scope: !98)
!105 = !DILocation(line: 49, column: 5, scope: !98)
!106 = !DILocation(line: 49, column: 5, scope: !107)
!107 = distinct !DILexicalBlock(scope: !98, file: !2, line: 49, column: 5)
!108 = !DILocation(line: 50, column: 5, scope: !98)
!109 = !DILocalVariable(name: "command", scope: !98, file: !2, line: 51, type: !30)
!110 = !DILocation(line: 51, column: 9, scope: !98)
!111 = !DILocalVariable(name: "prio", scope: !98, file: !2, line: 51, type: !30)
!112 = !DILocation(line: 51, column: 18, scope: !98)
!113 = !DILocalVariable(name: "ratio", scope: !98, file: !2, line: 52, type: !114)
!114 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!115 = !DILocation(line: 52, column: 11, scope: !98)
!116 = !DILocalVariable(name: "nprocs", scope: !98, file: !2, line: 53, type: !30)
!117 = !DILocation(line: 53, column: 9, scope: !98)
!118 = !DILocalVariable(name: "status", scope: !98, file: !2, line: 53, type: !30)
!119 = !DILocation(line: 53, column: 17, scope: !98)
!120 = !DILocalVariable(name: "pid", scope: !98, file: !2, line: 53, type: !30)
!121 = !DILocation(line: 53, column: 25, scope: !98)
!122 = !DILocalVariable(name: "process", scope: !98, file: !2, line: 54, type: !23)
!123 = !DILocation(line: 54, column: 21, scope: !98)
!124 = !DILocation(line: 55, column: 8, scope: !125)
!125 = distinct !DILexicalBlock(scope: !98, file: !2, line: 55, column: 8)
!126 = !DILocation(line: 55, column: 13, scope: !125)
!127 = !DILocation(line: 55, column: 8, scope: !98)
!128 = !DILocation(line: 55, column: 29, scope: !125)
!129 = !DILocation(line: 56, column: 14, scope: !130)
!130 = distinct !DILexicalBlock(scope: !98, file: !2, line: 56, column: 5)
!131 = !DILocation(line: 56, column: 9, scope: !130)
!132 = !DILocation(line: 56, column: 25, scope: !133)
!133 = distinct !DILexicalBlock(scope: !130, file: !2, line: 56, column: 5)
!134 = !DILocation(line: 56, column: 30, scope: !133)
!135 = !DILocation(line: 56, column: 5, scope: !130)
!136 = !DILocation(line: 58, column: 20, scope: !137)
!137 = distinct !DILexicalBlock(scope: !138, file: !2, line: 58, column: 5)
!138 = distinct !DILexicalBlock(scope: !133, file: !2, line: 57, column: 5)
!139 = !DILocation(line: 58, column: 39, scope: !137)
!140 = !DILocation(line: 58, column: 37, scope: !137)
!141 = !DILocation(line: 58, column: 15, scope: !137)
!142 = !DILocation(line: 58, column: 13, scope: !137)
!143 = !DILocation(line: 58, column: 47, scope: !137)
!144 = !DILocation(line: 58, column: 5, scope: !138)
!145 = !DILocation(line: 58, column: 52, scope: !137)
!146 = !DILocation(line: 59, column: 2, scope: !138)
!147 = !DILocation(line: 59, column: 8, scope: !148)
!148 = distinct !DILexicalBlock(scope: !149, file: !2, line: 59, column: 2)
!149 = distinct !DILexicalBlock(scope: !138, file: !2, line: 59, column: 2)
!150 = !DILocation(line: 59, column: 15, scope: !148)
!151 = !DILocation(line: 59, column: 2, scope: !149)
!152 = !DILocation(line: 61, column: 26, scope: !153)
!153 = distinct !DILexicalBlock(scope: !154, file: !2, line: 61, column: 9)
!154 = distinct !DILexicalBlock(scope: !148, file: !2, line: 60, column: 2)
!155 = !DILocation(line: 61, column: 18, scope: !153)
!156 = !DILocation(line: 61, column: 16, scope: !153)
!157 = !DILocation(line: 61, column: 9, scope: !154)
!158 = !DILocation(line: 61, column: 43, scope: !153)
!159 = !DILocation(line: 61, column: 33, scope: !153)
!160 = !DILocation(line: 62, column: 2, scope: !154)
!161 = !DILocation(line: 59, column: 26, scope: !148)
!162 = !DILocation(line: 59, column: 2, scope: !148)
!163 = distinct !{!163, !151, !164, !165}
!164 = !DILocation(line: 62, column: 2, scope: !149)
!165 = !{!"llvm.loop.mustprogress"}
!166 = !DILocation(line: 63, column: 5, scope: !138)
!167 = !DILocation(line: 56, column: 39, scope: !133)
!168 = !DILocation(line: 56, column: 5, scope: !133)
!169 = distinct !{!169, !135, !170, !165}
!170 = !DILocation(line: 63, column: 5, scope: !130)
!171 = !DILocation(line: 65, column: 5, scope: !98)
!172 = !DILocation(line: 65, column: 21, scope: !98)
!173 = !DILocation(line: 65, column: 19, scope: !98)
!174 = !DILocation(line: 65, column: 59, scope: !98)
!175 = !DILocation(line: 67, column: 11, scope: !176)
!176 = distinct !DILexicalBlock(scope: !98, file: !2, line: 66, column: 5)
!177 = !DILocation(line: 67, column: 20, scope: !176)
!178 = !DILocation(line: 67, column: 26, scope: !176)
!179 = !DILocation(line: 67, column: 2, scope: !176)
!180 = distinct !{!180, !171, !181, !165}
!181 = !DILocation(line: 68, column: 5, scope: !98)
!182 = !DILocation(line: 69, column: 8, scope: !183)
!183 = distinct !DILexicalBlock(scope: !98, file: !2, line: 69, column: 8)
!184 = !DILocation(line: 69, column: 15, scope: !183)
!185 = !DILocation(line: 69, column: 8, scope: !98)
!186 = !DILocation(line: 69, column: 30, scope: !183)
!187 = !DILocation(line: 69, column: 20, scope: !183)
!188 = !DILocation(line: 70, column: 5, scope: !98)
!189 = !DILocation(line: 71, column: 1, scope: !98)
!190 = !DILocalVariable(name: "argc", arg: 1, scope: !54, file: !55, line: 40, type: !60)
!191 = !DILocation(line: 40, column: 34, scope: !54)
!192 = !DILocalVariable(name: "ptr", scope: !54, file: !55, line: 45, type: !59)
!193 = !DILocation(line: 45, column: 9, scope: !54)
!194 = !DILocalVariable(name: "rc", scope: !54, file: !55, line: 46, type: !30)
!195 = !DILocation(line: 46, column: 9, scope: !54)
!196 = !DILocation(line: 48, column: 7, scope: !197)
!197 = distinct !DILexicalBlock(scope: !54, file: !55, line: 48, column: 7)
!198 = !DILocation(line: 48, column: 44, scope: !197)
!199 = !DILocation(line: 48, column: 7, scope: !54)
!200 = !DILocation(line: 50, column: 3, scope: !54)
!201 = !DILocation(line: 50, column: 11, scope: !54)
!202 = !DILocation(line: 50, column: 10, scope: !54)
!203 = !DILocation(line: 52, column: 15, scope: !204)
!204 = distinct !DILexicalBlock(scope: !54, file: !55, line: 50, column: 16)
!205 = !DILocation(line: 52, column: 9, scope: !204)
!206 = !DILocation(line: 52, column: 5, scope: !204)
!207 = !DILocation(line: 52, column: 13, scope: !204)
!208 = !DILocation(line: 53, column: 13, scope: !209)
!209 = distinct !DILexicalBlock(scope: !204, file: !55, line: 53, column: 9)
!210 = !DILocation(line: 53, column: 9, scope: !209)
!211 = !DILocation(line: 53, column: 20, scope: !209)
!212 = !DILocation(line: 53, column: 28, scope: !209)
!213 = !DILocation(line: 53, column: 36, scope: !209)
!214 = !DILocation(line: 53, column: 32, scope: !209)
!215 = !DILocation(line: 53, column: 9, scope: !204)
!216 = !DILocation(line: 53, column: 48, scope: !209)
!217 = !DILocation(line: 53, column: 44, scope: !209)
!218 = !DILocation(line: 53, column: 51, scope: !209)
!219 = !DILocation(line: 54, column: 7, scope: !204)
!220 = !DILocation(line: 56, column: 5, scope: !204)
!221 = !DILocation(line: 56, column: 13, scope: !204)
!222 = !DILocation(line: 56, column: 12, scope: !204)
!223 = !DILocation(line: 56, column: 21, scope: !204)
!224 = distinct !{!224, !220, !223, !165}
!225 = !DILocation(line: 57, column: 8, scope: !204)
!226 = distinct !{!226, !200, !227, !165}
!227 = !DILocation(line: 59, column: 3, scope: !54)
!228 = !DILocation(line: 61, column: 11, scope: !54)
!229 = !DILocation(line: 61, column: 4, scope: !54)
!230 = !DILocation(line: 61, column: 9, scope: !54)
!231 = !DILocation(line: 63, column: 3, scope: !54)
!232 = distinct !DISubprogram(name: "get_command", scope: !2, file: !2, line: 74, type: !233, scopeLine: 77, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!233 = !DISubroutineType(types: !234)
!234 = !{!30, !60, !60, !235}
!235 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!236 = !DILocalVariable(name: "command", arg: 1, scope: !232, file: !2, line: 75, type: !60)
!237 = !DILocation(line: 75, column: 10, scope: !232)
!238 = !DILocalVariable(name: "prio", arg: 2, scope: !232, file: !2, line: 75, type: !60)
!239 = !DILocation(line: 75, column: 20, scope: !232)
!240 = !DILocalVariable(name: "ratio", arg: 3, scope: !232, file: !2, line: 76, type: !235)
!241 = !DILocation(line: 76, column: 12, scope: !232)
!242 = !DILocalVariable(name: "status", scope: !232, file: !2, line: 78, type: !30)
!243 = !DILocation(line: 78, column: 9, scope: !232)
!244 = !DILocalVariable(name: "buf", scope: !232, file: !2, line: 79, type: !245)
!245 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 160, elements: !246)
!246 = !{!247}
!247 = !DISubrange(count: 20)
!248 = !DILocation(line: 79, column: 10, scope: !232)
!249 = !DILocation(line: 80, column: 14, scope: !250)
!250 = distinct !DILexicalBlock(scope: !232, file: !2, line: 80, column: 8)
!251 = !DILocation(line: 80, column: 28, scope: !250)
!252 = !DILocation(line: 80, column: 8, scope: !250)
!253 = !DILocation(line: 80, column: 8, scope: !232)
!254 = !DILocation(line: 82, column: 11, scope: !255)
!255 = distinct !DILexicalBlock(scope: !250, file: !2, line: 81, column: 5)
!256 = !DILocation(line: 82, column: 19, scope: !255)
!257 = !DILocation(line: 82, column: 3, scope: !255)
!258 = !DILocation(line: 82, column: 8, scope: !255)
!259 = !DILocation(line: 82, column: 26, scope: !255)
!260 = !DILocation(line: 82, column: 32, scope: !255)
!261 = !DILocation(line: 83, column: 9, scope: !255)
!262 = !DILocation(line: 83, column: 20, scope: !255)
!263 = !DILocation(line: 83, column: 2, scope: !255)
!264 = !DILocation(line: 84, column: 10, scope: !255)
!265 = !DILocation(line: 84, column: 9, scope: !255)
!266 = !DILocation(line: 84, column: 2, scope: !255)
!267 = !DILocation(line: 87, column: 13, scope: !268)
!268 = distinct !DILexicalBlock(scope: !255, file: !2, line: 85, column: 2)
!269 = !DILocation(line: 87, column: 27, scope: !268)
!270 = !DILocation(line: 87, column: 6, scope: !268)
!271 = !DILocation(line: 88, column: 6, scope: !268)
!272 = !DILocation(line: 90, column: 13, scope: !268)
!273 = !DILocation(line: 90, column: 27, scope: !268)
!274 = !DILocation(line: 90, column: 6, scope: !268)
!275 = !DILocation(line: 91, column: 6, scope: !268)
!276 = !DILocation(line: 93, column: 13, scope: !268)
!277 = !DILocation(line: 93, column: 29, scope: !268)
!278 = !DILocation(line: 93, column: 35, scope: !268)
!279 = !DILocation(line: 93, column: 6, scope: !268)
!280 = !DILocation(line: 94, column: 6, scope: !268)
!281 = !DILocation(line: 97, column: 2, scope: !255)
!282 = !DILocation(line: 97, column: 19, scope: !255)
!283 = !DILocation(line: 97, column: 12, scope: !255)
!284 = !DILocation(line: 97, column: 23, scope: !255)
!285 = !DILocation(line: 97, column: 8, scope: !255)
!286 = !DILocation(line: 97, column: 27, scope: !255)
!287 = !DILocation(line: 97, column: 35, scope: !255)
!288 = !DILocation(line: 97, column: 44, scope: !255)
!289 = !DILocation(line: 97, column: 58, scope: !255)
!290 = !DILocation(line: 97, column: 38, scope: !255)
!291 = !DILocation(line: 0, scope: !255)
!292 = distinct !{!292, !281, !293, !165}
!293 = !DILocation(line: 97, column: 65, scope: !255)
!294 = !DILocation(line: 98, column: 2, scope: !255)
!295 = !DILocation(line: 100, column: 10, scope: !250)
!296 = !DILocation(line: 101, column: 1, scope: !232)
!297 = distinct !DISubprogram(name: "exit_here", scope: !2, file: !2, line: 103, type: !298, scopeLine: 105, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!298 = !DISubroutineType(types: !299)
!299 = !{!30, !30}
!300 = !DILocalVariable(name: "status", arg: 1, scope: !297, file: !2, line: 104, type: !30)
!301 = !DILocation(line: 104, column: 10, scope: !297)
!302 = !DILocation(line: 106, column: 14, scope: !297)
!303 = !DILocation(line: 106, column: 10, scope: !297)
!304 = !DILocation(line: 106, column: 5, scope: !297)
!305 = distinct !DISubprogram(name: "new_job", scope: !2, file: !2, line: 111, type: !298, scopeLine: 113, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!306 = !DILocalVariable(name: "prio", arg: 1, scope: !305, file: !2, line: 112, type: !30)
!307 = !DILocation(line: 112, column: 10, scope: !305)
!308 = !DILocalVariable(name: "pid", scope: !305, file: !2, line: 114, type: !30)
!309 = !DILocation(line: 114, column: 9, scope: !305)
!310 = !DILocalVariable(name: "status", scope: !305, file: !2, line: 114, type: !30)
!311 = !DILocation(line: 114, column: 14, scope: !305)
!312 = !DILocalVariable(name: "new_process", scope: !305, file: !2, line: 115, type: !23)
!313 = !DILocation(line: 115, column: 21, scope: !305)
!314 = !DILocation(line: 116, column: 19, scope: !305)
!315 = !DILocation(line: 116, column: 9, scope: !305)
!316 = !DILocation(line: 117, column: 38, scope: !305)
!317 = !DILocation(line: 117, column: 17, scope: !305)
!318 = !DILocation(line: 118, column: 9, scope: !319)
!319 = distinct !DILexicalBlock(scope: !305, file: !2, line: 118, column: 8)
!320 = !DILocation(line: 118, column: 8, scope: !305)
!321 = !DILocation(line: 118, column: 29, scope: !319)
!322 = !DILocation(line: 118, column: 22, scope: !319)
!323 = !DILocation(line: 121, column: 21, scope: !324)
!324 = distinct !DILexicalBlock(scope: !319, file: !2, line: 120, column: 5)
!325 = !DILocation(line: 121, column: 2, scope: !324)
!326 = !DILocation(line: 121, column: 15, scope: !324)
!327 = !DILocation(line: 121, column: 19, scope: !324)
!328 = !DILocation(line: 122, column: 26, scope: !324)
!329 = !DILocation(line: 122, column: 2, scope: !324)
!330 = !DILocation(line: 122, column: 15, scope: !324)
!331 = !DILocation(line: 122, column: 24, scope: !324)
!332 = !DILocation(line: 123, column: 2, scope: !324)
!333 = !DILocation(line: 123, column: 15, scope: !324)
!334 = !DILocation(line: 123, column: 20, scope: !324)
!335 = !DILocation(line: 124, column: 19, scope: !324)
!336 = !DILocation(line: 124, column: 25, scope: !324)
!337 = !DILocation(line: 124, column: 11, scope: !324)
!338 = !DILocation(line: 124, column: 9, scope: !324)
!339 = !DILocation(line: 125, column: 5, scope: !340)
!340 = distinct !DILexicalBlock(scope: !324, file: !2, line: 125, column: 5)
!341 = !DILocation(line: 125, column: 5, scope: !324)
!342 = !DILocation(line: 127, column: 11, scope: !343)
!343 = distinct !DILexicalBlock(scope: !340, file: !2, line: 126, column: 2)
!344 = !DILocation(line: 127, column: 6, scope: !343)
!345 = !DILocation(line: 128, column: 2, scope: !343)
!346 = !DILocation(line: 130, column: 8, scope: !347)
!347 = distinct !DILexicalBlock(scope: !305, file: !2, line: 130, column: 8)
!348 = !DILocation(line: 130, column: 8, scope: !305)
!349 = !DILocation(line: 130, column: 24, scope: !347)
!350 = !DILocation(line: 130, column: 16, scope: !347)
!351 = !DILocation(line: 131, column: 12, scope: !305)
!352 = !DILocation(line: 131, column: 5, scope: !305)
!353 = distinct !DISubprogram(name: "upgrade_prio", scope: !2, file: !2, line: 134, type: !354, scopeLine: 137, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!354 = !DISubroutineType(types: !355)
!355 = !{!30, !30, !114}
!356 = !DILocalVariable(name: "prio", arg: 1, scope: !353, file: !2, line: 135, type: !30)
!357 = !DILocation(line: 135, column: 10, scope: !353)
!358 = !DILocalVariable(name: "ratio", arg: 2, scope: !353, file: !2, line: 136, type: !114)
!359 = !DILocation(line: 136, column: 12, scope: !353)
!360 = !DILocalVariable(name: "status", scope: !353, file: !2, line: 138, type: !30)
!361 = !DILocation(line: 138, column: 9, scope: !353)
!362 = !DILocalVariable(name: "job", scope: !353, file: !2, line: 139, type: !23)
!363 = !DILocation(line: 139, column: 22, scope: !353)
!364 = !DILocation(line: 140, column: 8, scope: !365)
!365 = distinct !DILexicalBlock(scope: !353, file: !2, line: 140, column: 8)
!366 = !DILocation(line: 140, column: 13, scope: !365)
!367 = !DILocation(line: 140, column: 17, scope: !365)
!368 = !DILocation(line: 140, column: 20, scope: !365)
!369 = !DILocation(line: 140, column: 25, scope: !365)
!370 = !DILocation(line: 140, column: 8, scope: !353)
!371 = !DILocation(line: 140, column: 38, scope: !365)
!372 = !DILocation(line: 141, column: 30, scope: !373)
!373 = distinct !DILexicalBlock(scope: !353, file: !2, line: 141, column: 8)
!374 = !DILocation(line: 141, column: 36, scope: !373)
!375 = !DILocation(line: 141, column: 18, scope: !373)
!376 = !DILocation(line: 141, column: 16, scope: !373)
!377 = !DILocation(line: 141, column: 50, scope: !373)
!378 = !DILocation(line: 141, column: 8, scope: !353)
!379 = !DILocation(line: 141, column: 63, scope: !373)
!380 = !DILocation(line: 141, column: 56, scope: !373)
!381 = !DILocation(line: 143, column: 21, scope: !353)
!382 = !DILocation(line: 143, column: 26, scope: !353)
!383 = !DILocation(line: 143, column: 5, scope: !353)
!384 = !DILocation(line: 143, column: 10, scope: !353)
!385 = !DILocation(line: 143, column: 19, scope: !353)
!386 = !DILocation(line: 144, column: 20, scope: !353)
!387 = !DILocation(line: 144, column: 25, scope: !353)
!388 = !DILocation(line: 144, column: 30, scope: !353)
!389 = !DILocation(line: 144, column: 12, scope: !353)
!390 = !DILocation(line: 144, column: 5, scope: !353)
!391 = !DILocation(line: 145, column: 1, scope: !353)
!392 = distinct !DISubprogram(name: "block", scope: !2, file: !2, line: 148, type: !393, scopeLine: 149, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!393 = !DISubroutineType(types: !394)
!394 = !{!30}
!395 = !DILocalVariable(name: "job", scope: !392, file: !2, line: 150, type: !23)
!396 = !DILocation(line: 150, column: 22, scope: !392)
!397 = !DILocation(line: 151, column: 11, scope: !392)
!398 = !DILocation(line: 151, column: 9, scope: !392)
!399 = !DILocation(line: 152, column: 8, scope: !400)
!400 = distinct !DILexicalBlock(scope: !392, file: !2, line: 152, column: 8)
!401 = !DILocation(line: 152, column: 8, scope: !392)
!402 = !DILocation(line: 154, column: 14, scope: !403)
!403 = distinct !DILexicalBlock(scope: !400, file: !2, line: 153, column: 5)
!404 = !DILocation(line: 155, column: 28, scope: !403)
!405 = !DILocation(line: 155, column: 9, scope: !403)
!406 = !DILocation(line: 155, column: 2, scope: !403)
!407 = !DILocation(line: 157, column: 5, scope: !392)
!408 = !DILocation(line: 158, column: 1, scope: !392)
!409 = distinct !DISubprogram(name: "unblock", scope: !2, file: !2, line: 161, type: !410, scopeLine: 163, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!410 = !DISubroutineType(types: !411)
!411 = !{!30, !114}
!412 = !DILocalVariable(name: "ratio", arg: 1, scope: !409, file: !2, line: 162, type: !114)
!413 = !DILocation(line: 162, column: 12, scope: !409)
!414 = !DILocalVariable(name: "status", scope: !409, file: !2, line: 164, type: !30)
!415 = !DILocation(line: 164, column: 9, scope: !409)
!416 = !DILocalVariable(name: "job", scope: !409, file: !2, line: 165, type: !23)
!417 = !DILocation(line: 165, column: 22, scope: !409)
!418 = !DILocation(line: 166, column: 41, scope: !419)
!419 = distinct !DILexicalBlock(scope: !409, file: !2, line: 166, column: 8)
!420 = !DILocation(line: 166, column: 18, scope: !419)
!421 = !DILocation(line: 166, column: 16, scope: !419)
!422 = !DILocation(line: 166, column: 55, scope: !419)
!423 = !DILocation(line: 166, column: 8, scope: !409)
!424 = !DILocation(line: 166, column: 68, scope: !419)
!425 = !DILocation(line: 166, column: 61, scope: !419)
!426 = !DILocation(line: 168, column: 20, scope: !409)
!427 = !DILocation(line: 168, column: 25, scope: !409)
!428 = !DILocation(line: 168, column: 35, scope: !409)
!429 = !DILocation(line: 168, column: 12, scope: !409)
!430 = !DILocation(line: 168, column: 5, scope: !409)
!431 = !DILocation(line: 169, column: 1, scope: !409)
!432 = distinct !DISubprogram(name: "quantum_expire", scope: !2, file: !2, line: 172, type: !393, scopeLine: 173, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!433 = !DILocalVariable(name: "job", scope: !432, file: !2, line: 174, type: !23)
!434 = !DILocation(line: 174, column: 22, scope: !432)
!435 = !DILocation(line: 175, column: 11, scope: !432)
!436 = !DILocation(line: 175, column: 9, scope: !432)
!437 = !DILocation(line: 176, column: 8, scope: !438)
!438 = distinct !DILexicalBlock(scope: !432, file: !2, line: 176, column: 8)
!439 = !DILocation(line: 176, column: 8, scope: !432)
!440 = !DILocation(line: 178, column: 14, scope: !441)
!441 = distinct !DILexicalBlock(scope: !438, file: !2, line: 177, column: 5)
!442 = !DILocation(line: 179, column: 17, scope: !441)
!443 = !DILocation(line: 179, column: 22, scope: !441)
!444 = !DILocation(line: 179, column: 32, scope: !441)
!445 = !DILocation(line: 179, column: 9, scope: !441)
!446 = !DILocation(line: 179, column: 2, scope: !441)
!447 = !DILocation(line: 181, column: 5, scope: !432)
!448 = !DILocation(line: 182, column: 1, scope: !432)
!449 = distinct !DISubprogram(name: "finish", scope: !2, file: !2, line: 185, type: !393, scopeLine: 186, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!450 = !DILocalVariable(name: "job", scope: !449, file: !2, line: 187, type: !23)
!451 = !DILocation(line: 187, column: 22, scope: !449)
!452 = !DILocation(line: 188, column: 11, scope: !449)
!453 = !DILocation(line: 188, column: 9, scope: !449)
!454 = !DILocation(line: 189, column: 8, scope: !455)
!455 = distinct !DILexicalBlock(scope: !449, file: !2, line: 189, column: 8)
!456 = !DILocation(line: 189, column: 8, scope: !449)
!457 = !DILocation(line: 191, column: 14, scope: !458)
!458 = distinct !DILexicalBlock(scope: !455, file: !2, line: 190, column: 5)
!459 = !DILocation(line: 192, column: 2, scope: !458)
!460 = !DILocation(line: 193, column: 10, scope: !458)
!461 = !DILocation(line: 193, column: 25, scope: !458)
!462 = !DILocation(line: 193, column: 30, scope: !458)
!463 = !DILocation(line: 193, column: 2, scope: !458)
!464 = !DILocation(line: 194, column: 7, scope: !458)
!465 = !DILocation(line: 194, column: 2, scope: !458)
!466 = !DILocation(line: 195, column: 2, scope: !458)
!467 = !DILocation(line: 197, column: 10, scope: !455)
!468 = !DILocation(line: 198, column: 1, scope: !449)
!469 = distinct !DISubprogram(name: "flush", scope: !2, file: !2, line: 201, type: !393, scopeLine: 202, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!470 = !DILocation(line: 203, column: 5, scope: !469)
!471 = !DILocation(line: 203, column: 12, scope: !469)
!472 = !DILocation(line: 203, column: 11, scope: !469)
!473 = distinct !{!473, !470, !474, !165}
!474 = !DILocation(line: 203, column: 21, scope: !469)
!475 = !DILocation(line: 204, column: 13, scope: !469)
!476 = !DILocation(line: 204, column: 5, scope: !469)
!477 = !DILocation(line: 205, column: 5, scope: !469)
!478 = distinct !DISubprogram(name: "get_current", scope: !2, file: !2, line: 209, type: !479, scopeLine: 210, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!479 = !DISubroutineType(types: !22)
!480 = !DILocalVariable(name: "prio", scope: !478, file: !2, line: 211, type: !30)
!481 = !DILocation(line: 211, column: 9, scope: !478)
!482 = !DILocation(line: 212, column: 9, scope: !483)
!483 = distinct !DILexicalBlock(scope: !478, file: !2, line: 212, column: 8)
!484 = !DILocation(line: 212, column: 8, scope: !478)
!485 = !DILocation(line: 214, column: 11, scope: !486)
!486 = distinct !DILexicalBlock(scope: !487, file: !2, line: 214, column: 2)
!487 = distinct !DILexicalBlock(scope: !483, file: !2, line: 213, column: 5)
!488 = !DILocation(line: 214, column: 6, scope: !486)
!489 = !DILocation(line: 214, column: 22, scope: !490)
!490 = distinct !DILexicalBlock(scope: !486, file: !2, line: 214, column: 2)
!491 = !DILocation(line: 214, column: 27, scope: !490)
!492 = !DILocation(line: 214, column: 2, scope: !486)
!493 = !DILocation(line: 216, column: 21, scope: !494)
!494 = distinct !DILexicalBlock(scope: !495, file: !2, line: 216, column: 9)
!495 = distinct !DILexicalBlock(scope: !490, file: !2, line: 215, column: 2)
!496 = !DILocation(line: 216, column: 9, scope: !494)
!497 = !DILocation(line: 216, column: 46, scope: !494)
!498 = !DILocation(line: 216, column: 9, scope: !495)
!499 = !DILocation(line: 216, column: 51, scope: !494)
!500 = !DILocation(line: 217, column: 2, scope: !495)
!501 = !DILocation(line: 214, column: 36, scope: !490)
!502 = !DILocation(line: 214, column: 2, scope: !490)
!503 = distinct !{!503, !492, !504, !165}
!504 = !DILocation(line: 217, column: 2, scope: !486)
!505 = !DILocation(line: 218, column: 5, scope: !487)
!506 = !DILocation(line: 219, column: 12, scope: !478)
!507 = !DILocation(line: 219, column: 5, scope: !478)
!508 = distinct !DISubprogram(name: "reschedule", scope: !2, file: !2, line: 223, type: !298, scopeLine: 225, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!509 = !DILocalVariable(name: "prio", arg: 1, scope: !508, file: !2, line: 224, type: !30)
!510 = !DILocation(line: 224, column: 10, scope: !508)
!511 = !DILocation(line: 226, column: 8, scope: !512)
!512 = distinct !DILexicalBlock(scope: !508, file: !2, line: 226, column: 8)
!513 = !DILocation(line: 226, column: 20, scope: !512)
!514 = !DILocation(line: 226, column: 23, scope: !512)
!515 = !DILocation(line: 226, column: 30, scope: !512)
!516 = !DILocation(line: 226, column: 43, scope: !512)
!517 = !DILocation(line: 226, column: 28, scope: !512)
!518 = !DILocation(line: 226, column: 8, scope: !508)
!519 = !DILocation(line: 228, column: 10, scope: !520)
!520 = distinct !DILexicalBlock(scope: !512, file: !2, line: 227, column: 5)
!521 = !DILocation(line: 228, column: 23, scope: !520)
!522 = !DILocation(line: 228, column: 33, scope: !520)
!523 = !DILocation(line: 228, column: 2, scope: !520)
!524 = !DILocation(line: 229, column: 14, scope: !520)
!525 = !DILocation(line: 230, column: 5, scope: !520)
!526 = !DILocation(line: 231, column: 5, scope: !508)
!527 = !DILocation(line: 232, column: 5, scope: !508)
!528 = distinct !DISubprogram(name: "schedule", scope: !2, file: !2, line: 236, type: !529, scopeLine: 239, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!529 = !DISubroutineType(types: !530)
!530 = !{!30, !30, !30, !114}
!531 = !DILocalVariable(name: "command", arg: 1, scope: !528, file: !2, line: 237, type: !30)
!532 = !DILocation(line: 237, column: 9, scope: !528)
!533 = !DILocalVariable(name: "prio", arg: 2, scope: !528, file: !2, line: 237, type: !30)
!534 = !DILocation(line: 237, column: 18, scope: !528)
!535 = !DILocalVariable(name: "ratio", arg: 3, scope: !528, file: !2, line: 238, type: !114)
!536 = !DILocation(line: 238, column: 11, scope: !528)
!537 = !DILocalVariable(name: "status", scope: !528, file: !2, line: 240, type: !30)
!538 = !DILocation(line: 240, column: 9, scope: !528)
!539 = !DILocation(line: 241, column: 12, scope: !528)
!540 = !DILocation(line: 241, column: 5, scope: !528)
!541 = !DILocation(line: 244, column: 26, scope: !542)
!542 = distinct !DILexicalBlock(scope: !528, file: !2, line: 242, column: 5)
!543 = !DILocation(line: 244, column: 18, scope: !542)
!544 = !DILocation(line: 244, column: 16, scope: !542)
!545 = !DILocation(line: 245, column: 2, scope: !542)
!546 = !DILocation(line: 247, column: 18, scope: !542)
!547 = !DILocation(line: 247, column: 16, scope: !542)
!548 = !DILocation(line: 248, column: 2, scope: !542)
!549 = !DILocation(line: 250, column: 31, scope: !542)
!550 = !DILocation(line: 250, column: 37, scope: !542)
!551 = !DILocation(line: 250, column: 18, scope: !542)
!552 = !DILocation(line: 250, column: 16, scope: !542)
!553 = !DILocation(line: 251, column: 2, scope: !542)
!554 = !DILocation(line: 253, column: 18, scope: !542)
!555 = !DILocation(line: 253, column: 16, scope: !542)
!556 = !DILocation(line: 254, column: 2, scope: !542)
!557 = !DILocation(line: 256, column: 26, scope: !542)
!558 = !DILocation(line: 256, column: 18, scope: !542)
!559 = !DILocation(line: 256, column: 16, scope: !542)
!560 = !DILocation(line: 257, column: 2, scope: !542)
!561 = !DILocation(line: 259, column: 9, scope: !542)
!562 = !DILocation(line: 260, column: 10, scope: !542)
!563 = !DILocation(line: 260, column: 2, scope: !542)
!564 = !DILocation(line: 261, column: 2, scope: !542)
!565 = !DILocation(line: 263, column: 18, scope: !542)
!566 = !DILocation(line: 263, column: 16, scope: !542)
!567 = !DILocation(line: 264, column: 2, scope: !542)
!568 = !DILocation(line: 266, column: 9, scope: !542)
!569 = !DILocation(line: 267, column: 5, scope: !542)
!570 = !DILocation(line: 268, column: 12, scope: !528)
!571 = !DILocation(line: 268, column: 5, scope: !528)
!572 = distinct !DISubprogram(name: "put_end", scope: !2, file: !2, line: 275, type: !78, scopeLine: 278, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!573 = !DILocalVariable(name: "prio", arg: 1, scope: !572, file: !2, line: 276, type: !30)
!574 = !DILocation(line: 276, column: 10, scope: !572)
!575 = !DILocalVariable(name: "process", arg: 2, scope: !572, file: !2, line: 277, type: !23)
!576 = !DILocation(line: 277, column: 22, scope: !572)
!577 = !DILocalVariable(name: "next", scope: !572, file: !2, line: 279, type: !578)
!578 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!579 = !DILocation(line: 279, column: 22, scope: !572)
!580 = !DILocation(line: 280, column: 8, scope: !581)
!581 = distinct !DILexicalBlock(scope: !572, file: !2, line: 280, column: 8)
!582 = !DILocation(line: 280, column: 13, scope: !581)
!583 = !DILocation(line: 280, column: 23, scope: !581)
!584 = !DILocation(line: 280, column: 26, scope: !581)
!585 = !DILocation(line: 280, column: 31, scope: !581)
!586 = !DILocation(line: 280, column: 8, scope: !572)
!587 = !DILocation(line: 280, column: 36, scope: !581)
!588 = !DILocation(line: 282, column: 28, scope: !589)
!589 = distinct !DILexicalBlock(scope: !572, file: !2, line: 282, column: 5)
!590 = !DILocation(line: 282, column: 17, scope: !589)
!591 = !DILocation(line: 282, column: 34, scope: !589)
!592 = !DILocation(line: 282, column: 14, scope: !589)
!593 = !DILocation(line: 282, column: 9, scope: !589)
!594 = !DILocation(line: 282, column: 41, scope: !595)
!595 = distinct !DILexicalBlock(scope: !589, file: !2, line: 282, column: 5)
!596 = !DILocation(line: 282, column: 40, scope: !595)
!597 = !DILocation(line: 282, column: 5, scope: !589)
!598 = !DILocation(line: 282, column: 57, scope: !595)
!599 = !DILocation(line: 282, column: 56, scope: !595)
!600 = !DILocation(line: 282, column: 64, scope: !595)
!601 = !DILocation(line: 282, column: 52, scope: !595)
!602 = !DILocation(line: 282, column: 5, scope: !595)
!603 = distinct !{!603, !597, !604, !165}
!604 = !DILocation(line: 282, column: 69, scope: !589)
!605 = !DILocation(line: 283, column: 13, scope: !572)
!606 = !DILocation(line: 283, column: 6, scope: !572)
!607 = !DILocation(line: 283, column: 11, scope: !572)
!608 = !DILocation(line: 284, column: 16, scope: !572)
!609 = !DILocation(line: 284, column: 5, scope: !572)
!610 = !DILocation(line: 284, column: 22, scope: !572)
!611 = !DILocation(line: 284, column: 28, scope: !572)
!612 = !DILocation(line: 285, column: 5, scope: !572)
!613 = !DILocation(line: 286, column: 1, scope: !572)
!614 = distinct !DISubprogram(name: "get_process", scope: !2, file: !2, line: 289, type: !615, scopeLine: 293, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !61)
!615 = !DISubroutineType(types: !616)
!616 = !{!30, !30, !114, !578}
!617 = !DILocalVariable(name: "prio", arg: 1, scope: !614, file: !2, line: 290, type: !30)
!618 = !DILocation(line: 290, column: 10, scope: !614)
!619 = !DILocalVariable(name: "ratio", arg: 2, scope: !614, file: !2, line: 291, type: !114)
!620 = !DILocation(line: 291, column: 12, scope: !614)
!621 = !DILocalVariable(name: "job", arg: 3, scope: !614, file: !2, line: 292, type: !578)
!622 = !DILocation(line: 292, column: 24, scope: !614)
!623 = !DILocalVariable(name: "length", scope: !614, file: !2, line: 294, type: !30)
!624 = !DILocation(line: 294, column: 9, scope: !614)
!625 = !DILocalVariable(name: "index", scope: !614, file: !2, line: 294, type: !30)
!626 = !DILocation(line: 294, column: 17, scope: !614)
!627 = !DILocalVariable(name: "next", scope: !614, file: !2, line: 295, type: !578)
!628 = !DILocation(line: 295, column: 22, scope: !614)
!629 = !DILocation(line: 296, column: 8, scope: !630)
!630 = distinct !DILexicalBlock(scope: !614, file: !2, line: 296, column: 8)
!631 = !DILocation(line: 296, column: 13, scope: !630)
!632 = !DILocation(line: 296, column: 23, scope: !630)
!633 = !DILocation(line: 296, column: 26, scope: !630)
!634 = !DILocation(line: 296, column: 31, scope: !630)
!635 = !DILocation(line: 296, column: 8, scope: !614)
!636 = !DILocation(line: 296, column: 36, scope: !630)
!637 = !DILocation(line: 297, column: 8, scope: !638)
!638 = distinct !DILexicalBlock(scope: !614, file: !2, line: 297, column: 8)
!639 = !DILocation(line: 297, column: 14, scope: !638)
!640 = !DILocation(line: 297, column: 20, scope: !638)
!641 = !DILocation(line: 297, column: 23, scope: !638)
!642 = !DILocation(line: 297, column: 29, scope: !638)
!643 = !DILocation(line: 297, column: 8, scope: !614)
!644 = !DILocation(line: 297, column: 36, scope: !638)
!645 = !DILocation(line: 298, column: 25, scope: !614)
!646 = !DILocation(line: 298, column: 14, scope: !614)
!647 = !DILocation(line: 298, column: 31, scope: !614)
!648 = !DILocation(line: 298, column: 12, scope: !614)
!649 = !DILocation(line: 299, column: 13, scope: !614)
!650 = !DILocation(line: 299, column: 21, scope: !614)
!651 = !DILocation(line: 299, column: 19, scope: !614)
!652 = !DILocation(line: 299, column: 11, scope: !614)
!653 = !DILocation(line: 300, column: 13, scope: !614)
!654 = !DILocation(line: 300, column: 22, scope: !614)
!655 = !DILocation(line: 300, column: 19, scope: !614)
!656 = !DILocation(line: 300, column: 31, scope: !614)
!657 = !DILocation(line: 300, column: 38, scope: !614)
!658 = !DILocation(line: 300, column: 43, scope: !614)
!659 = !DILocation(line: 300, column: 11, scope: !614)
!660 = !DILocation(line: 301, column: 28, scope: !661)
!661 = distinct !DILexicalBlock(scope: !614, file: !2, line: 301, column: 5)
!662 = !DILocation(line: 301, column: 17, scope: !661)
!663 = !DILocation(line: 301, column: 34, scope: !661)
!664 = !DILocation(line: 301, column: 14, scope: !661)
!665 = !DILocation(line: 301, column: 9, scope: !661)
!666 = !DILocation(line: 301, column: 40, scope: !667)
!667 = distinct !DILexicalBlock(scope: !661, file: !2, line: 301, column: 5)
!668 = !DILocation(line: 301, column: 46, scope: !667)
!669 = !DILocation(line: 301, column: 50, scope: !667)
!670 = !DILocation(line: 301, column: 49, scope: !667)
!671 = !DILocation(line: 0, scope: !667)
!672 = !DILocation(line: 301, column: 5, scope: !661)
!673 = !DILocation(line: 302, column: 19, scope: !667)
!674 = !DILocation(line: 302, column: 18, scope: !667)
!675 = !DILocation(line: 302, column: 26, scope: !667)
!676 = !DILocation(line: 302, column: 14, scope: !667)
!677 = !DILocation(line: 302, column: 9, scope: !667)
!678 = !DILocation(line: 301, column: 61, scope: !667)
!679 = !DILocation(line: 301, column: 5, scope: !667)
!680 = distinct !{!680, !672, !681, !165}
!681 = !DILocation(line: 302, column: 26, scope: !661)
!682 = !DILocation(line: 303, column: 13, scope: !614)
!683 = !DILocation(line: 303, column: 12, scope: !614)
!684 = !DILocation(line: 303, column: 6, scope: !614)
!685 = !DILocation(line: 303, column: 10, scope: !614)
!686 = !DILocation(line: 304, column: 9, scope: !687)
!687 = distinct !DILexicalBlock(scope: !614, file: !2, line: 304, column: 8)
!688 = !DILocation(line: 304, column: 8, scope: !687)
!689 = !DILocation(line: 304, column: 8, scope: !614)
!690 = !DILocation(line: 306, column: 12, scope: !691)
!691 = distinct !DILexicalBlock(scope: !687, file: !2, line: 305, column: 5)
!692 = !DILocation(line: 306, column: 11, scope: !691)
!693 = !DILocation(line: 306, column: 19, scope: !691)
!694 = !DILocation(line: 306, column: 3, scope: !691)
!695 = !DILocation(line: 306, column: 8, scope: !691)
!696 = !DILocation(line: 307, column: 4, scope: !691)
!697 = !DILocation(line: 307, column: 3, scope: !691)
!698 = !DILocation(line: 307, column: 10, scope: !691)
!699 = !DILocation(line: 307, column: 15, scope: !691)
!700 = !DILocation(line: 308, column: 13, scope: !691)
!701 = !DILocation(line: 308, column: 2, scope: !691)
!702 = !DILocation(line: 308, column: 19, scope: !691)
!703 = !DILocation(line: 308, column: 25, scope: !691)
!704 = !DILocation(line: 309, column: 2, scope: !691)
!705 = !DILocation(line: 311, column: 10, scope: !687)
!706 = !DILocation(line: 312, column: 1, scope: !614)
