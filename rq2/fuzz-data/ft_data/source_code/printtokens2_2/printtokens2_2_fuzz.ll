; ModuleID = 'printtokens2_2_fuzz.c'
source_filename = "printtokens2_2_fuzz.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

@__stdoutp = external global ptr, align 8
@.str = private unnamed_addr constant [37 x i8] c"Error!,please give the token stream\0A\00", align 1, !dbg !0
@__stdinp = external global ptr, align 8
@.str.1 = private unnamed_addr constant [2 x i8] c"r\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [28 x i8] c"The file %s doesn't exists\0A\00", align 1, !dbg !12
@.str.3 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1, !dbg !17
@buffer = global [81 x i8] zeroinitializer, align 1, !dbg !22
@.str.4 = private unnamed_addr constant [13 x i8] c"error,\22%s\22.\0A\00", align 1, !dbg !29
@.str.5 = private unnamed_addr constant [15 x i8] c"keyword,\22%s\22.\0A\00", align 1, !dbg !34
@.str.6 = private unnamed_addr constant [18 x i8] c"identifier,\22%s\22.\0A\00", align 1, !dbg !39
@.str.7 = private unnamed_addr constant [13 x i8] c"numeric,%s.\0A\00", align 1, !dbg !44
@.str.8 = private unnamed_addr constant [12 x i8] c"string,%s.\0A\00", align 1, !dbg !46
@.str.9 = private unnamed_addr constant [17 x i8] c"character,\22%s\22.\0A\00", align 1, !dbg !51
@.str.10 = private unnamed_addr constant [6 x i8] c"eof.\0A\00", align 1, !dbg !56
@.str.11 = private unnamed_addr constant [4 x i8] c"and\00", align 1, !dbg !61
@.str.12 = private unnamed_addr constant [3 x i8] c"or\00", align 1, !dbg !66
@.str.13 = private unnamed_addr constant [3 x i8] c"if\00", align 1, !dbg !71
@.str.14 = private unnamed_addr constant [4 x i8] c"xor\00", align 1, !dbg !73
@.str.15 = private unnamed_addr constant [7 x i8] c"lambda\00", align 1, !dbg !75
@.str.16 = private unnamed_addr constant [3 x i8] c"=>\00", align 1, !dbg !80
@.str.17 = private unnamed_addr constant [25 x i8] c"It can not get charcter\0A\00", align 1, !dbg !82
@.str.18 = private unnamed_addr constant [2 x i8] c"(\00", align 1, !dbg !87
@.str.19 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1, !dbg !89
@.str.20 = private unnamed_addr constant [8 x i8] c"lparen.\00", align 1, !dbg !91
@.str.21 = private unnamed_addr constant [2 x i8] c")\00", align 1, !dbg !96
@.str.22 = private unnamed_addr constant [8 x i8] c"rparen.\00", align 1, !dbg !98
@.str.23 = private unnamed_addr constant [2 x i8] c"[\00", align 1, !dbg !100
@.str.24 = private unnamed_addr constant [9 x i8] c"lsquare.\00", align 1, !dbg !102
@.str.25 = private unnamed_addr constant [2 x i8] c"]\00", align 1, !dbg !107
@.str.26 = private unnamed_addr constant [9 x i8] c"rsquare.\00", align 1, !dbg !109
@.str.27 = private unnamed_addr constant [2 x i8] c"'\00", align 1, !dbg !111
@.str.28 = private unnamed_addr constant [7 x i8] c"quote.\00", align 1, !dbg !113
@.str.29 = private unnamed_addr constant [2 x i8] c"`\00", align 1, !dbg !115
@.str.30 = private unnamed_addr constant [8 x i8] c"bquote.\00", align 1, !dbg !117
@.str.31 = private unnamed_addr constant [7 x i8] c"comma.\00", align 1, !dbg !119
@.str.32 = private unnamed_addr constant [2 x i8] c",\00", align 1, !dbg !121

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main(i32 noundef %0, ptr noundef %1) #0 !dbg !133 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !139, metadata !DIExpression()), !dbg !140
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !141, metadata !DIExpression()), !dbg !142
  call void @llvm.dbg.declare(metadata ptr %6, metadata !143, metadata !DIExpression()), !dbg !144
  call void @llvm.dbg.declare(metadata ptr %7, metadata !145, metadata !DIExpression()), !dbg !148
  call void @llvm.dbg.declare(metadata ptr %8, metadata !149, metadata !DIExpression()), !dbg !207
  %9 = load i32, ptr %4, align 4, !dbg !208
  %10 = icmp eq i32 %9, 1, !dbg !210
  br i1 %10, label %11, label %14, !dbg !211

11:                                               ; preds = %2
  %12 = call ptr @malloc(i64 noundef 1) #6, !dbg !212
  store ptr %12, ptr %6, align 8, !dbg !214
  %13 = load ptr, ptr %6, align 8, !dbg !215
  store i8 0, ptr %13, align 1, !dbg !216
  br label %25, !dbg !217

14:                                               ; preds = %2
  %15 = load i32, ptr %4, align 4, !dbg !218
  %16 = icmp eq i32 %15, 2, !dbg !220
  br i1 %16, label %17, label %21, !dbg !221

17:                                               ; preds = %14
  %18 = load ptr, ptr %5, align 8, !dbg !222
  %19 = getelementptr inbounds ptr, ptr %18, i64 1, !dbg !222
  %20 = load ptr, ptr %19, align 8, !dbg !222
  store ptr %20, ptr %6, align 8, !dbg !223
  br label %24, !dbg !224

21:                                               ; preds = %14
  %22 = load ptr, ptr @__stdoutp, align 8, !dbg !225
  %23 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %22, ptr noundef @.str), !dbg !227
  call void @exit(i32 noundef 0) #7, !dbg !228
  unreachable, !dbg !228

24:                                               ; preds = %17
  br label %25

25:                                               ; preds = %24, %11
  %26 = call double @llvm.pow.f64(double 9.100000e-01, double 1.000000e+01), !dbg !229
  %27 = fmul double 1.000000e+04, %26, !dbg !230
  %28 = fptoui double %27 to i32, !dbg !231
  %29 = call i32 @"\01_usleep"(i32 noundef %28), !dbg !232
  %30 = load ptr, ptr %6, align 8, !dbg !233
  %31 = call ptr @open_token_stream(ptr noundef %30), !dbg !234
  store ptr %31, ptr %8, align 8, !dbg !235
  %32 = load ptr, ptr %8, align 8, !dbg !236
  %33 = call ptr @get_token(ptr noundef %32), !dbg !237
  store ptr %33, ptr %7, align 8, !dbg !238
  br label %34, !dbg !239

34:                                               ; preds = %38, %25
  %35 = load ptr, ptr %7, align 8, !dbg !240
  %36 = call i32 @is_eof_token(ptr noundef %35), !dbg !241
  %37 = icmp eq i32 %36, 0, !dbg !242
  br i1 %37, label %38, label %43, !dbg !239

38:                                               ; preds = %34
  %39 = load ptr, ptr %7, align 8, !dbg !243
  %40 = call i32 @print_token(ptr noundef %39), !dbg !245
  %41 = load ptr, ptr %8, align 8, !dbg !246
  %42 = call ptr @get_token(ptr noundef %41), !dbg !247
  store ptr %42, ptr %7, align 8, !dbg !248
  br label %34, !dbg !239, !llvm.loop !249

43:                                               ; preds = %34
  %44 = load ptr, ptr %7, align 8, !dbg !252
  %45 = call i32 @print_token(ptr noundef %44), !dbg !253
  call void @exit(i32 noundef 0) #7, !dbg !254
  unreachable, !dbg !254
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #2

declare i32 @fprintf(ptr noundef, ptr noundef, ...) #3

; Function Attrs: noreturn
declare void @exit(i32 noundef) #4

declare i32 @"\01_usleep"(i32 noundef) #3

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.pow.f64(double, double) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
define ptr @open_character_stream(ptr noundef %0) #0 !dbg !255 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !260, metadata !DIExpression()), !dbg !261
  call void @llvm.dbg.declare(metadata ptr %3, metadata !262, metadata !DIExpression()), !dbg !263
  %4 = load ptr, ptr %2, align 8, !dbg !264
  %5 = icmp eq ptr %4, null, !dbg !266
  br i1 %5, label %6, label %8, !dbg !267

6:                                                ; preds = %1
  %7 = load ptr, ptr @__stdinp, align 8, !dbg !268
  store ptr %7, ptr %3, align 8, !dbg !269
  br label %17, !dbg !270

8:                                                ; preds = %1
  %9 = load ptr, ptr %2, align 8, !dbg !271
  %10 = call ptr @"\01_fopen"(ptr noundef %9, ptr noundef @.str.1), !dbg !273
  store ptr %10, ptr %3, align 8, !dbg !274
  %11 = icmp eq ptr %10, null, !dbg !275
  br i1 %11, label %12, label %16, !dbg !276

12:                                               ; preds = %8
  %13 = load ptr, ptr @__stdoutp, align 8, !dbg !277
  %14 = load ptr, ptr %2, align 8, !dbg !279
  %15 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %13, ptr noundef @.str.2, ptr noundef %14), !dbg !280
  call void @exit(i32 noundef 0) #7, !dbg !281
  unreachable, !dbg !281

16:                                               ; preds = %8
  br label %17

17:                                               ; preds = %16, %6
  %18 = load ptr, ptr %3, align 8, !dbg !282
  ret ptr %18, !dbg !283
}

declare ptr @"\01_fopen"(ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable
define signext i8 @get_char(ptr noundef %0) #0 !dbg !284 {
  %2 = alloca ptr, align 8
  %3 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !287, metadata !DIExpression()), !dbg !288
  call void @llvm.dbg.declare(metadata ptr %3, metadata !289, metadata !DIExpression()), !dbg !290
  %4 = load ptr, ptr %2, align 8, !dbg !291
  %5 = call i32 @getc(ptr noundef %4), !dbg !292
  %6 = trunc i32 %5 to i8, !dbg !292
  store i8 %6, ptr %3, align 1, !dbg !293
  %7 = load i8, ptr %3, align 1, !dbg !294
  ret i8 %7, !dbg !295
}

declare i32 @getc(ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable
define signext i8 @unget_char(i32 noundef %0, ptr noundef %1) #0 !dbg !296 {
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  %5 = alloca ptr, align 8
  %6 = alloca i8, align 1
  %7 = trunc i32 %0 to i8
  store i8 %7, ptr %4, align 1
  call void @llvm.dbg.declare(metadata ptr %4, metadata !299, metadata !DIExpression()), !dbg !300
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !301, metadata !DIExpression()), !dbg !302
  call void @llvm.dbg.declare(metadata ptr %6, metadata !303, metadata !DIExpression()), !dbg !304
  %8 = load i8, ptr %4, align 1, !dbg !305
  %9 = sext i8 %8 to i32, !dbg !305
  %10 = load ptr, ptr %5, align 8, !dbg !306
  %11 = call i32 @ungetc(i32 noundef %9, ptr noundef %10), !dbg !307
  %12 = trunc i32 %11 to i8, !dbg !307
  store i8 %12, ptr %6, align 1, !dbg !308
  %13 = load i8, ptr %6, align 1, !dbg !309
  %14 = sext i8 %13 to i32, !dbg !309
  %15 = icmp eq i32 %14, -1, !dbg !311
  br i1 %15, label %16, label %18, !dbg !312

16:                                               ; preds = %2
  %17 = load i8, ptr %6, align 1, !dbg !313
  store i8 %17, ptr %3, align 1, !dbg !315
  br label %20, !dbg !315

18:                                               ; preds = %2
  %19 = load i8, ptr %6, align 1, !dbg !316
  store i8 %19, ptr %3, align 1, !dbg !317
  br label %20, !dbg !317

20:                                               ; preds = %18, %16
  %21 = load i8, ptr %3, align 1, !dbg !318
  ret i8 %21, !dbg !318
}

declare i32 @ungetc(i32 noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable
define ptr @open_token_stream(ptr noundef %0) #0 !dbg !319 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !322, metadata !DIExpression()), !dbg !323
  call void @llvm.dbg.declare(metadata ptr %3, metadata !324, metadata !DIExpression()), !dbg !325
  %4 = load ptr, ptr %2, align 8, !dbg !326
  %5 = call i32 @strcmp(ptr noundef %4, ptr noundef @.str.3), !dbg !328
  %6 = icmp eq i32 %5, 0, !dbg !329
  br i1 %6, label %7, label %9, !dbg !330

7:                                                ; preds = %1
  %8 = call ptr @open_character_stream(ptr noundef null), !dbg !331
  store ptr %8, ptr %3, align 8, !dbg !332
  br label %12, !dbg !333

9:                                                ; preds = %1
  %10 = load ptr, ptr %2, align 8, !dbg !334
  %11 = call ptr @open_character_stream(ptr noundef %10), !dbg !335
  store ptr %11, ptr %3, align 8, !dbg !336
  br label %12

12:                                               ; preds = %9, %7
  %13 = load ptr, ptr %3, align 8, !dbg !337
  ret ptr %13, !dbg !338
}

declare i32 @strcmp(ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable
define ptr @get_token(ptr noundef %0) #0 !dbg !339 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i8, align 1
  %8 = alloca [2 x i8], align 1
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !342, metadata !DIExpression()), !dbg !343
  call void @llvm.dbg.declare(metadata ptr %4, metadata !344, metadata !DIExpression()), !dbg !345
  store i32 0, ptr %4, align 4, !dbg !345
  call void @llvm.dbg.declare(metadata ptr %5, metadata !346, metadata !DIExpression()), !dbg !347
  call void @llvm.dbg.declare(metadata ptr %6, metadata !348, metadata !DIExpression()), !dbg !349
  store i32 0, ptr %6, align 4, !dbg !349
  call void @llvm.dbg.declare(metadata ptr %7, metadata !350, metadata !DIExpression()), !dbg !351
  call void @llvm.dbg.declare(metadata ptr %8, metadata !352, metadata !DIExpression()), !dbg !353
  store i32 0, ptr %5, align 4, !dbg !354
  br label %9, !dbg !356

9:                                                ; preds = %16, %1
  %10 = load i32, ptr %5, align 4, !dbg !357
  %11 = icmp sle i32 %10, 80, !dbg !359
  br i1 %11, label %12, label %19, !dbg !360

12:                                               ; preds = %9
  %13 = load i32, ptr %5, align 4, !dbg !361
  %14 = sext i32 %13 to i64, !dbg !363
  %15 = getelementptr inbounds [81 x i8], ptr @buffer, i64 0, i64 %14, !dbg !363
  store i8 0, ptr %15, align 1, !dbg !364
  br label %16, !dbg !365

16:                                               ; preds = %12
  %17 = load i32, ptr %5, align 4, !dbg !366
  %18 = add nsw i32 %17, 1, !dbg !366
  store i32 %18, ptr %5, align 4, !dbg !366
  br label %9, !dbg !367, !llvm.loop !368

19:                                               ; preds = %9
  %20 = getelementptr inbounds [2 x i8], ptr %8, i64 0, i64 0, !dbg !370
  store i8 0, ptr %20, align 1, !dbg !371
  %21 = getelementptr inbounds [2 x i8], ptr %8, i64 0, i64 1, !dbg !372
  store i8 0, ptr %21, align 1, !dbg !373
  %22 = load ptr, ptr %3, align 8, !dbg !374
  %23 = call signext i8 @get_char(ptr noundef %22), !dbg !375
  store i8 %23, ptr %7, align 1, !dbg !376
  br label %24, !dbg !377

24:                                               ; preds = %34, %19
  %25 = load i8, ptr %7, align 1, !dbg !378
  %26 = sext i8 %25 to i32, !dbg !378
  %27 = icmp eq i32 %26, 32, !dbg !379
  br i1 %27, label %32, label %28, !dbg !380

28:                                               ; preds = %24
  %29 = load i8, ptr %7, align 1, !dbg !381
  %30 = sext i8 %29 to i32, !dbg !381
  %31 = icmp eq i32 %30, 10, !dbg !382
  br label %32, !dbg !380

32:                                               ; preds = %28, %24
  %33 = phi i1 [ true, %24 ], [ %31, %28 ]
  br i1 %33, label %34, label %37, !dbg !377

34:                                               ; preds = %32
  %35 = load ptr, ptr %3, align 8, !dbg !383
  %36 = call signext i8 @get_char(ptr noundef %35), !dbg !385
  store i8 %36, ptr %7, align 1, !dbg !386
  br label %24, !dbg !377, !llvm.loop !387

37:                                               ; preds = %32
  %38 = load i8, ptr %7, align 1, !dbg !389
  %39 = load i32, ptr %4, align 4, !dbg !390
  %40 = sext i32 %39 to i64, !dbg !391
  %41 = getelementptr inbounds [81 x i8], ptr @buffer, i64 0, i64 %40, !dbg !391
  store i8 %38, ptr %41, align 1, !dbg !392
  %42 = call i32 @is_eof_token(ptr noundef @buffer), !dbg !393
  %43 = icmp eq i32 %42, 1, !dbg !395
  br i1 %43, label %44, label %45, !dbg !396

44:                                               ; preds = %37
  store ptr @buffer, ptr %2, align 8, !dbg !397
  br label %141, !dbg !397

45:                                               ; preds = %37
  %46 = call i32 @is_spec_symbol(ptr noundef @buffer), !dbg !398
  %47 = icmp eq i32 %46, 1, !dbg !400
  br i1 %47, label %48, label %49, !dbg !401

48:                                               ; preds = %45
  store ptr @buffer, ptr %2, align 8, !dbg !402
  br label %141, !dbg !402

49:                                               ; preds = %45
  %50 = load i8, ptr %7, align 1, !dbg !403
  %51 = sext i8 %50 to i32, !dbg !403
  %52 = icmp eq i32 %51, 34, !dbg !405
  br i1 %52, label %53, label %54, !dbg !406

53:                                               ; preds = %49
  store i32 1, ptr %6, align 4, !dbg !407
  br label %54, !dbg !408

54:                                               ; preds = %53, %49
  %55 = load i8, ptr %7, align 1, !dbg !409
  %56 = sext i8 %55 to i32, !dbg !409
  %57 = icmp eq i32 %56, 59, !dbg !411
  br i1 %57, label %58, label %59, !dbg !412

58:                                               ; preds = %54
  store i32 2, ptr %6, align 4, !dbg !413
  br label %59, !dbg !414

59:                                               ; preds = %58, %54
  %60 = load ptr, ptr %3, align 8, !dbg !415
  %61 = call signext i8 @get_char(ptr noundef %60), !dbg !416
  store i8 %61, ptr %7, align 1, !dbg !417
  br label %62, !dbg !418

62:                                               ; preds = %68, %59
  %63 = load i32, ptr %6, align 4, !dbg !419
  %64 = load i8, ptr %7, align 1, !dbg !420
  %65 = sext i8 %64 to i32, !dbg !420
  %66 = call i32 @is_token_end(i32 noundef %63, i32 noundef %65), !dbg !421
  %67 = icmp eq i32 %66, 0, !dbg !422
  br i1 %67, label %68, label %77, !dbg !418

68:                                               ; preds = %62
  %69 = load i32, ptr %4, align 4, !dbg !423
  %70 = add nsw i32 %69, 1, !dbg !423
  store i32 %70, ptr %4, align 4, !dbg !423
  %71 = load i8, ptr %7, align 1, !dbg !425
  %72 = load i32, ptr %4, align 4, !dbg !426
  %73 = sext i32 %72 to i64, !dbg !427
  %74 = getelementptr inbounds [81 x i8], ptr @buffer, i64 0, i64 %73, !dbg !427
  store i8 %71, ptr %74, align 1, !dbg !428
  %75 = load ptr, ptr %3, align 8, !dbg !429
  %76 = call signext i8 @get_char(ptr noundef %75), !dbg !430
  store i8 %76, ptr %7, align 1, !dbg !431
  br label %62, !dbg !418, !llvm.loop !432

77:                                               ; preds = %62
  %78 = load i8, ptr %7, align 1, !dbg !434
  %79 = getelementptr inbounds [2 x i8], ptr %8, i64 0, i64 0, !dbg !435
  store i8 %78, ptr %79, align 1, !dbg !436
  %80 = getelementptr inbounds [2 x i8], ptr %8, i64 0, i64 0, !dbg !437
  %81 = call i32 @is_eof_token(ptr noundef %80), !dbg !439
  %82 = icmp eq i32 %81, 1, !dbg !440
  br i1 %82, label %83, label %95, !dbg !441

83:                                               ; preds = %77
  %84 = load i8, ptr %7, align 1, !dbg !442
  %85 = sext i8 %84 to i32, !dbg !442
  %86 = load ptr, ptr %3, align 8, !dbg !444
  %87 = call signext i8 @unget_char(i32 noundef %85, ptr noundef %86), !dbg !445
  store i8 %87, ptr %7, align 1, !dbg !446
  %88 = load i8, ptr %7, align 1, !dbg !447
  %89 = sext i8 %88 to i32, !dbg !447
  %90 = icmp eq i32 %89, -1, !dbg !449
  br i1 %90, label %91, label %94, !dbg !450

91:                                               ; preds = %83
  %92 = load ptr, ptr %3, align 8, !dbg !451
  %93 = call i32 @unget_error(ptr noundef %92), !dbg !452
  br label %94, !dbg !452

94:                                               ; preds = %91, %83
  store ptr @buffer, ptr %2, align 8, !dbg !453
  br label %141, !dbg !453

95:                                               ; preds = %77
  %96 = getelementptr inbounds [2 x i8], ptr %8, i64 0, i64 0, !dbg !454
  %97 = call i32 @is_spec_symbol(ptr noundef %96), !dbg !456
  %98 = icmp eq i32 %97, 1, !dbg !457
  br i1 %98, label %99, label %111, !dbg !458

99:                                               ; preds = %95
  %100 = load i8, ptr %7, align 1, !dbg !459
  %101 = sext i8 %100 to i32, !dbg !459
  %102 = load ptr, ptr %3, align 8, !dbg !461
  %103 = call signext i8 @unget_char(i32 noundef %101, ptr noundef %102), !dbg !462
  store i8 %103, ptr %7, align 1, !dbg !463
  %104 = load i8, ptr %7, align 1, !dbg !464
  %105 = sext i8 %104 to i32, !dbg !464
  %106 = icmp eq i32 %105, -1, !dbg !466
  br i1 %106, label %107, label %110, !dbg !467

107:                                              ; preds = %99
  %108 = load ptr, ptr %3, align 8, !dbg !468
  %109 = call i32 @unget_error(ptr noundef %108), !dbg !469
  br label %110, !dbg !469

110:                                              ; preds = %107, %99
  store ptr @buffer, ptr %2, align 8, !dbg !470
  br label %141, !dbg !470

111:                                              ; preds = %95
  %112 = load i32, ptr %6, align 4, !dbg !471
  %113 = icmp eq i32 %112, 1, !dbg !473
  br i1 %113, label %114, label %121, !dbg !474

114:                                              ; preds = %111
  %115 = load i32, ptr %4, align 4, !dbg !475
  %116 = add nsw i32 %115, 1, !dbg !475
  store i32 %116, ptr %4, align 4, !dbg !475
  %117 = load i8, ptr %7, align 1, !dbg !477
  %118 = load i32, ptr %4, align 4, !dbg !478
  %119 = sext i32 %118 to i64, !dbg !479
  %120 = getelementptr inbounds [81 x i8], ptr @buffer, i64 0, i64 %119, !dbg !479
  store i8 %117, ptr %120, align 1, !dbg !480
  store ptr @buffer, ptr %2, align 8, !dbg !481
  br label %141, !dbg !481

121:                                              ; preds = %111
  %122 = load i32, ptr %6, align 4, !dbg !482
  %123 = icmp eq i32 %122, 0, !dbg !484
  br i1 %123, label %124, label %140, !dbg !485

124:                                              ; preds = %121
  %125 = load i8, ptr %7, align 1, !dbg !486
  %126 = sext i8 %125 to i32, !dbg !486
  %127 = icmp eq i32 %126, 59, !dbg !487
  br i1 %127, label %128, label %140, !dbg !488

128:                                              ; preds = %124
  %129 = load i8, ptr %7, align 1, !dbg !489
  %130 = sext i8 %129 to i32, !dbg !489
  %131 = load ptr, ptr %3, align 8, !dbg !491
  %132 = call signext i8 @unget_char(i32 noundef %130, ptr noundef %131), !dbg !492
  store i8 %132, ptr %7, align 1, !dbg !493
  %133 = load i8, ptr %7, align 1, !dbg !494
  %134 = sext i8 %133 to i32, !dbg !494
  %135 = icmp eq i32 %134, -1, !dbg !496
  br i1 %135, label %136, label %139, !dbg !497

136:                                              ; preds = %128
  %137 = load ptr, ptr %3, align 8, !dbg !498
  %138 = call i32 @unget_error(ptr noundef %137), !dbg !499
  br label %139, !dbg !499

139:                                              ; preds = %136, %128
  store ptr @buffer, ptr %2, align 8, !dbg !500
  br label %141, !dbg !500

140:                                              ; preds = %124, %121
  store ptr @buffer, ptr %2, align 8, !dbg !501
  br label %141, !dbg !501

141:                                              ; preds = %140, %139, %114, %110, %94, %48, %44
  %142 = load ptr, ptr %2, align 8, !dbg !502
  ret ptr %142, !dbg !502
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @print_token(ptr noundef %0) #0 !dbg !503 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !506, metadata !DIExpression()), !dbg !507
  call void @llvm.dbg.declare(metadata ptr %4, metadata !508, metadata !DIExpression()), !dbg !509
  %5 = load ptr, ptr %3, align 8, !dbg !510
  %6 = call i32 @token_type(ptr noundef %5), !dbg !511
  store i32 %6, ptr %4, align 4, !dbg !512
  %7 = load i32, ptr %4, align 4, !dbg !513
  %8 = icmp eq i32 %7, 0, !dbg !515
  br i1 %8, label %9, label %13, !dbg !516

9:                                                ; preds = %1
  %10 = load ptr, ptr @__stdoutp, align 8, !dbg !517
  %11 = load ptr, ptr %3, align 8, !dbg !519
  %12 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %10, ptr noundef @.str.4, ptr noundef %11), !dbg !520
  br label %13, !dbg !521

13:                                               ; preds = %9, %1
  %14 = load i32, ptr %4, align 4, !dbg !522
  %15 = icmp eq i32 %14, 1, !dbg !524
  br i1 %15, label %16, label %20, !dbg !525

16:                                               ; preds = %13
  %17 = load ptr, ptr @__stdoutp, align 8, !dbg !526
  %18 = load ptr, ptr %3, align 8, !dbg !528
  %19 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %17, ptr noundef @.str.5, ptr noundef %18), !dbg !529
  br label %20, !dbg !530

20:                                               ; preds = %16, %13
  %21 = load i32, ptr %4, align 4, !dbg !531
  %22 = icmp eq i32 %21, 2, !dbg !533
  br i1 %22, label %23, label %25, !dbg !534

23:                                               ; preds = %20
  %24 = load ptr, ptr %3, align 8, !dbg !535
  call void @print_spec_symbol(ptr noundef %24), !dbg !536
  br label %25, !dbg !536

25:                                               ; preds = %23, %20
  %26 = load i32, ptr %4, align 4, !dbg !537
  %27 = icmp eq i32 %26, 3, !dbg !539
  br i1 %27, label %28, label %32, !dbg !540

28:                                               ; preds = %25
  %29 = load ptr, ptr @__stdoutp, align 8, !dbg !541
  %30 = load ptr, ptr %3, align 8, !dbg !543
  %31 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %29, ptr noundef @.str.6, ptr noundef %30), !dbg !544
  br label %32, !dbg !545

32:                                               ; preds = %28, %25
  %33 = load i32, ptr %4, align 4, !dbg !546
  %34 = icmp eq i32 %33, 41, !dbg !548
  br i1 %34, label %35, label %39, !dbg !549

35:                                               ; preds = %32
  %36 = load ptr, ptr @__stdoutp, align 8, !dbg !550
  %37 = load ptr, ptr %3, align 8, !dbg !552
  %38 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %36, ptr noundef @.str.7, ptr noundef %37), !dbg !553
  br label %39, !dbg !554

39:                                               ; preds = %35, %32
  %40 = load i32, ptr %4, align 4, !dbg !555
  %41 = icmp eq i32 %40, 42, !dbg !557
  br i1 %41, label %42, label %46, !dbg !558

42:                                               ; preds = %39
  %43 = load ptr, ptr @__stdoutp, align 8, !dbg !559
  %44 = load ptr, ptr %3, align 8, !dbg !561
  %45 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %43, ptr noundef @.str.8, ptr noundef %44), !dbg !562
  br label %46, !dbg !563

46:                                               ; preds = %42, %39
  %47 = load i32, ptr %4, align 4, !dbg !564
  %48 = icmp eq i32 %47, 43, !dbg !566
  br i1 %48, label %49, label %55, !dbg !567

49:                                               ; preds = %46
  %50 = load ptr, ptr %3, align 8, !dbg !568
  %51 = getelementptr inbounds i8, ptr %50, i64 1, !dbg !570
  store ptr %51, ptr %3, align 8, !dbg !571
  %52 = load ptr, ptr @__stdoutp, align 8, !dbg !572
  %53 = load ptr, ptr %3, align 8, !dbg !573
  %54 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %52, ptr noundef @.str.9, ptr noundef %53), !dbg !574
  br label %55, !dbg !575

55:                                               ; preds = %49, %46
  %56 = load i32, ptr %4, align 4, !dbg !576
  %57 = icmp eq i32 %56, 6, !dbg !578
  br i1 %57, label %58, label %61, !dbg !579

58:                                               ; preds = %55
  %59 = load ptr, ptr @__stdoutp, align 8, !dbg !580
  %60 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %59, ptr noundef @.str.10), !dbg !581
  br label %61, !dbg !581

61:                                               ; preds = %58, %55
  %62 = load i32, ptr %2, align 4, !dbg !582
  ret i32 %62, !dbg !582
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define internal i32 @token_type(ptr noundef %0) #0 !dbg !583 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !584, metadata !DIExpression()), !dbg !585
  %4 = load ptr, ptr %3, align 8, !dbg !586
  %5 = call i32 @is_keyword(ptr noundef %4), !dbg !588
  %6 = icmp ne i32 %5, 0, !dbg !588
  br i1 %6, label %7, label %8, !dbg !589

7:                                                ; preds = %1
  store i32 1, ptr %2, align 4, !dbg !590
  br label %44, !dbg !590

8:                                                ; preds = %1
  %9 = load ptr, ptr %3, align 8, !dbg !591
  %10 = call i32 @is_spec_symbol(ptr noundef %9), !dbg !593
  %11 = icmp ne i32 %10, 0, !dbg !593
  br i1 %11, label %12, label %13, !dbg !594

12:                                               ; preds = %8
  store i32 2, ptr %2, align 4, !dbg !595
  br label %44, !dbg !595

13:                                               ; preds = %8
  %14 = load ptr, ptr %3, align 8, !dbg !596
  %15 = call i32 @is_identifier(ptr noundef %14), !dbg !598
  %16 = icmp ne i32 %15, 0, !dbg !598
  br i1 %16, label %17, label %18, !dbg !599

17:                                               ; preds = %13
  store i32 3, ptr %2, align 4, !dbg !600
  br label %44, !dbg !600

18:                                               ; preds = %13
  %19 = load ptr, ptr %3, align 8, !dbg !601
  %20 = call i32 @is_num_constant(ptr noundef %19), !dbg !603
  %21 = icmp ne i32 %20, 0, !dbg !603
  br i1 %21, label %22, label %23, !dbg !604

22:                                               ; preds = %18
  store i32 41, ptr %2, align 4, !dbg !605
  br label %44, !dbg !605

23:                                               ; preds = %18
  %24 = load ptr, ptr %3, align 8, !dbg !606
  %25 = call i32 @is_str_constant(ptr noundef %24), !dbg !608
  %26 = icmp ne i32 %25, 0, !dbg !608
  br i1 %26, label %27, label %28, !dbg !609

27:                                               ; preds = %23
  store i32 42, ptr %2, align 4, !dbg !610
  br label %44, !dbg !610

28:                                               ; preds = %23
  %29 = load ptr, ptr %3, align 8, !dbg !611
  %30 = call i32 @is_char_constant(ptr noundef %29), !dbg !613
  %31 = icmp ne i32 %30, 0, !dbg !613
  br i1 %31, label %32, label %33, !dbg !614

32:                                               ; preds = %28
  store i32 43, ptr %2, align 4, !dbg !615
  br label %44, !dbg !615

33:                                               ; preds = %28
  %34 = load ptr, ptr %3, align 8, !dbg !616
  %35 = call i32 @is_comment(ptr noundef %34), !dbg !618
  %36 = icmp ne i32 %35, 0, !dbg !618
  br i1 %36, label %37, label %38, !dbg !619

37:                                               ; preds = %33
  store i32 5, ptr %2, align 4, !dbg !620
  br label %44, !dbg !620

38:                                               ; preds = %33
  %39 = load ptr, ptr %3, align 8, !dbg !621
  %40 = call i32 @is_eof_token(ptr noundef %39), !dbg !623
  %41 = icmp ne i32 %40, 0, !dbg !623
  br i1 %41, label %42, label %43, !dbg !624

42:                                               ; preds = %38
  store i32 6, ptr %2, align 4, !dbg !625
  br label %44, !dbg !625

43:                                               ; preds = %38
  store i32 0, ptr %2, align 4, !dbg !626
  br label %44, !dbg !626

44:                                               ; preds = %43, %42, %37, %32, %27, %22, %17, %12, %7
  %45 = load i32, ptr %2, align 4, !dbg !627
  ret i32 %45, !dbg !627
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @is_eof_token(ptr noundef %0) #0 !dbg !628 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !629, metadata !DIExpression()), !dbg !630
  %4 = load ptr, ptr %3, align 8, !dbg !631
  %5 = load i8, ptr %4, align 1, !dbg !633
  %6 = sext i8 %5 to i32, !dbg !633
  %7 = icmp eq i32 %6, -1, !dbg !634
  br i1 %7, label %8, label %9, !dbg !635

8:                                                ; preds = %1
  store i32 1, ptr %2, align 4, !dbg !636
  br label %10, !dbg !636

9:                                                ; preds = %1
  store i32 0, ptr %2, align 4, !dbg !637
  br label %10, !dbg !637

10:                                               ; preds = %9, %8
  %11 = load i32, ptr %2, align 4, !dbg !638
  ret i32 %11, !dbg !638
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define internal i32 @is_token_end(i32 noundef %0, i32 noundef %1) #0 !dbg !639 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  %6 = alloca [2 x i8], align 1
  %7 = trunc i32 %1 to i8
  store i32 %0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !642, metadata !DIExpression()), !dbg !643
  store i8 %7, ptr %5, align 1
  call void @llvm.dbg.declare(metadata ptr %5, metadata !644, metadata !DIExpression()), !dbg !645
  call void @llvm.dbg.declare(metadata ptr %6, metadata !646, metadata !DIExpression()), !dbg !647
  %8 = load i8, ptr %5, align 1, !dbg !648
  %9 = getelementptr inbounds [2 x i8], ptr %6, i64 0, i64 0, !dbg !649
  store i8 %8, ptr %9, align 1, !dbg !650
  %10 = getelementptr inbounds [2 x i8], ptr %6, i64 0, i64 1, !dbg !651
  store i8 0, ptr %10, align 1, !dbg !652
  %11 = getelementptr inbounds [2 x i8], ptr %6, i64 0, i64 0, !dbg !653
  %12 = call i32 @is_eof_token(ptr noundef %11), !dbg !655
  %13 = icmp eq i32 %12, 1, !dbg !656
  br i1 %13, label %14, label %15, !dbg !657

14:                                               ; preds = %2
  store i32 1, ptr %3, align 4, !dbg !658
  br label %59, !dbg !658

15:                                               ; preds = %2
  %16 = load i32, ptr %4, align 4, !dbg !659
  %17 = icmp eq i32 %16, 1, !dbg !661
  br i1 %17, label %18, label %31, !dbg !662

18:                                               ; preds = %15
  %19 = load i8, ptr %5, align 1, !dbg !663
  %20 = sext i8 %19 to i32, !dbg !663
  %21 = icmp eq i32 %20, 34, !dbg !666
  %22 = zext i1 %21 to i32, !dbg !666
  %23 = load i8, ptr %5, align 1, !dbg !667
  %24 = sext i8 %23 to i32, !dbg !667
  %25 = icmp eq i32 %24, 10, !dbg !668
  %26 = zext i1 %25 to i32, !dbg !668
  %27 = or i32 %22, %26, !dbg !669
  %28 = icmp ne i32 %27, 0, !dbg !669
  br i1 %28, label %29, label %30, !dbg !670

29:                                               ; preds = %18
  store i32 1, ptr %3, align 4, !dbg !671
  br label %59, !dbg !671

30:                                               ; preds = %18
  store i32 0, ptr %3, align 4, !dbg !672
  br label %59, !dbg !672

31:                                               ; preds = %15
  %32 = load i32, ptr %4, align 4, !dbg !673
  %33 = icmp eq i32 %32, 2, !dbg !675
  br i1 %33, label %34, label %40, !dbg !676

34:                                               ; preds = %31
  %35 = load i8, ptr %5, align 1, !dbg !677
  %36 = sext i8 %35 to i32, !dbg !677
  %37 = icmp eq i32 %36, 10, !dbg !680
  br i1 %37, label %38, label %39, !dbg !681

38:                                               ; preds = %34
  store i32 1, ptr %3, align 4, !dbg !682
  br label %59, !dbg !682

39:                                               ; preds = %34
  store i32 0, ptr %3, align 4, !dbg !683
  br label %59, !dbg !683

40:                                               ; preds = %31
  %41 = getelementptr inbounds [2 x i8], ptr %6, i64 0, i64 0, !dbg !684
  %42 = call i32 @is_spec_symbol(ptr noundef %41), !dbg !686
  %43 = icmp eq i32 %42, 1, !dbg !687
  br i1 %43, label %44, label %45, !dbg !688

44:                                               ; preds = %40
  store i32 1, ptr %3, align 4, !dbg !689
  br label %59, !dbg !689

45:                                               ; preds = %40
  %46 = load i8, ptr %5, align 1, !dbg !690
  %47 = sext i8 %46 to i32, !dbg !690
  %48 = icmp eq i32 %47, 32, !dbg !692
  br i1 %48, label %57, label %49, !dbg !693

49:                                               ; preds = %45
  %50 = load i8, ptr %5, align 1, !dbg !694
  %51 = sext i8 %50 to i32, !dbg !694
  %52 = icmp eq i32 %51, 10, !dbg !695
  br i1 %52, label %57, label %53, !dbg !696

53:                                               ; preds = %49
  %54 = load i8, ptr %5, align 1, !dbg !697
  %55 = sext i8 %54 to i32, !dbg !697
  %56 = icmp eq i32 %55, 59, !dbg !698
  br i1 %56, label %57, label %58, !dbg !699

57:                                               ; preds = %53, %49, %45
  store i32 1, ptr %3, align 4, !dbg !700
  br label %59, !dbg !700

58:                                               ; preds = %53
  store i32 0, ptr %3, align 4, !dbg !701
  br label %59, !dbg !701

59:                                               ; preds = %58, %57, %44, %39, %38, %30, %29, %14
  %60 = load i32, ptr %3, align 4, !dbg !702
  ret i32 %60, !dbg !702
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define internal i32 @is_keyword(ptr noundef %0) #0 !dbg !703 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !704, metadata !DIExpression()), !dbg !705
  %4 = load ptr, ptr %3, align 8, !dbg !706
  %5 = call i32 @strcmp(ptr noundef %4, ptr noundef @.str.11), !dbg !708
  %6 = icmp ne i32 %5, 0, !dbg !708
  br i1 %6, label %7, label %27, !dbg !709

7:                                                ; preds = %1
  %8 = load ptr, ptr %3, align 8, !dbg !710
  %9 = call i32 @strcmp(ptr noundef %8, ptr noundef @.str.12), !dbg !711
  %10 = icmp ne i32 %9, 0, !dbg !711
  br i1 %10, label %11, label %27, !dbg !712

11:                                               ; preds = %7
  %12 = load ptr, ptr %3, align 8, !dbg !713
  %13 = call i32 @strcmp(ptr noundef %12, ptr noundef @.str.13), !dbg !714
  %14 = icmp ne i32 %13, 0, !dbg !714
  br i1 %14, label %15, label %27, !dbg !715

15:                                               ; preds = %11
  %16 = load ptr, ptr %3, align 8, !dbg !716
  %17 = call i32 @strcmp(ptr noundef %16, ptr noundef @.str.14), !dbg !717
  %18 = icmp ne i32 %17, 0, !dbg !717
  br i1 %18, label %19, label %27, !dbg !718

19:                                               ; preds = %15
  %20 = load ptr, ptr %3, align 8, !dbg !719
  %21 = call i32 @strcmp(ptr noundef %20, ptr noundef @.str.15), !dbg !720
  %22 = icmp ne i32 %21, 0, !dbg !720
  br i1 %22, label %23, label %27, !dbg !721

23:                                               ; preds = %19
  %24 = load ptr, ptr %3, align 8, !dbg !722
  %25 = call i32 @strcmp(ptr noundef %24, ptr noundef @.str.16), !dbg !723
  %26 = icmp ne i32 %25, 0, !dbg !723
  br i1 %26, label %28, label %27, !dbg !724

27:                                               ; preds = %23, %19, %15, %11, %7, %1
  store i32 1, ptr %2, align 4, !dbg !725
  br label %29, !dbg !725

28:                                               ; preds = %23
  store i32 0, ptr %2, align 4, !dbg !726
  br label %29, !dbg !726

29:                                               ; preds = %28, %27
  %30 = load i32, ptr %2, align 4, !dbg !727
  ret i32 %30, !dbg !727
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define internal i32 @is_identifier(ptr noundef %0) #0 !dbg !728 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !729, metadata !DIExpression()), !dbg !730
  call void @llvm.dbg.declare(metadata ptr %4, metadata !731, metadata !DIExpression()), !dbg !732
  store i32 1, ptr %4, align 4, !dbg !732
  %5 = load ptr, ptr %3, align 8, !dbg !733
  %6 = load i8, ptr %5, align 1, !dbg !735
  %7 = sext i8 %6 to i32, !dbg !735
  %8 = call i32 @isalpha(i32 noundef %7) #8, !dbg !736
  %9 = icmp ne i32 %8, 0, !dbg !736
  br i1 %9, label %10, label %43, !dbg !737

10:                                               ; preds = %1
  br label %11, !dbg !738

11:                                               ; preds = %41, %10
  %12 = load ptr, ptr %3, align 8, !dbg !740
  %13 = load i32, ptr %4, align 4, !dbg !741
  %14 = sext i32 %13 to i64, !dbg !742
  %15 = getelementptr inbounds i8, ptr %12, i64 %14, !dbg !742
  %16 = load i8, ptr %15, align 1, !dbg !743
  %17 = sext i8 %16 to i32, !dbg !743
  %18 = icmp ne i32 %17, 0, !dbg !744
  br i1 %18, label %19, label %42, !dbg !738

19:                                               ; preds = %11
  %20 = load ptr, ptr %3, align 8, !dbg !745
  %21 = load i32, ptr %4, align 4, !dbg !748
  %22 = sext i32 %21 to i64, !dbg !749
  %23 = getelementptr inbounds i8, ptr %20, i64 %22, !dbg !749
  %24 = load i8, ptr %23, align 1, !dbg !750
  %25 = sext i8 %24 to i32, !dbg !750
  %26 = call i32 @isalpha(i32 noundef %25) #8, !dbg !751
  %27 = icmp ne i32 %26, 0, !dbg !751
  br i1 %27, label %37, label %28, !dbg !752

28:                                               ; preds = %19
  %29 = load ptr, ptr %3, align 8, !dbg !753
  %30 = load i32, ptr %4, align 4, !dbg !754
  %31 = sext i32 %30 to i64, !dbg !755
  %32 = getelementptr inbounds i8, ptr %29, i64 %31, !dbg !755
  %33 = load i8, ptr %32, align 1, !dbg !756
  %34 = sext i8 %33 to i32, !dbg !756
  %35 = call i32 @isdigit(i32 noundef %34) #8, !dbg !757
  %36 = icmp ne i32 %35, 0, !dbg !757
  br i1 %36, label %37, label %40, !dbg !758

37:                                               ; preds = %28, %19
  %38 = load i32, ptr %4, align 4, !dbg !759
  %39 = add nsw i32 %38, 1, !dbg !759
  store i32 %39, ptr %4, align 4, !dbg !759
  br label %41, !dbg !760

40:                                               ; preds = %28
  store i32 0, ptr %2, align 4, !dbg !761
  br label %44, !dbg !761

41:                                               ; preds = %37
  br label %11, !dbg !738, !llvm.loop !762

42:                                               ; preds = %11
  store i32 1, ptr %2, align 4, !dbg !764
  br label %44, !dbg !764

43:                                               ; preds = %1
  store i32 0, ptr %2, align 4, !dbg !765
  br label %44, !dbg !765

44:                                               ; preds = %43, %42, %40
  %45 = load i32, ptr %2, align 4, !dbg !766
  ret i32 %45, !dbg !766
}

; Function Attrs: nounwind readonly willreturn
declare i32 @isalpha(i32 noundef) #5

; Function Attrs: nounwind readonly willreturn
declare i32 @isdigit(i32 noundef) #5

; Function Attrs: noinline nounwind optnone ssp uwtable
define internal i32 @is_num_constant(ptr noundef %0) #0 !dbg !767 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !768, metadata !DIExpression()), !dbg !769
  call void @llvm.dbg.declare(metadata ptr %4, metadata !770, metadata !DIExpression()), !dbg !771
  store i32 1, ptr %4, align 4, !dbg !771
  %5 = load ptr, ptr %3, align 8, !dbg !772
  %6 = load i8, ptr %5, align 1, !dbg !774
  %7 = sext i8 %6 to i32, !dbg !774
  %8 = call i32 @isdigit(i32 noundef %7) #8, !dbg !775
  %9 = icmp ne i32 %8, 0, !dbg !775
  br i1 %9, label %10, label %34, !dbg !776

10:                                               ; preds = %1
  br label %11, !dbg !777

11:                                               ; preds = %32, %10
  %12 = load ptr, ptr %3, align 8, !dbg !779
  %13 = load i32, ptr %4, align 4, !dbg !780
  %14 = sext i32 %13 to i64, !dbg !781
  %15 = getelementptr inbounds i8, ptr %12, i64 %14, !dbg !781
  %16 = load i8, ptr %15, align 1, !dbg !782
  %17 = sext i8 %16 to i32, !dbg !782
  %18 = icmp ne i32 %17, 0, !dbg !783
  br i1 %18, label %19, label %33, !dbg !777

19:                                               ; preds = %11
  %20 = load ptr, ptr %3, align 8, !dbg !784
  %21 = load i32, ptr %4, align 4, !dbg !787
  %22 = sext i32 %21 to i64, !dbg !788
  %23 = getelementptr inbounds i8, ptr %20, i64 %22, !dbg !788
  %24 = load i8, ptr %23, align 1, !dbg !789
  %25 = sext i8 %24 to i32, !dbg !789
  %26 = call i32 @isdigit(i32 noundef %25) #8, !dbg !790
  %27 = icmp ne i32 %26, 0, !dbg !790
  br i1 %27, label %28, label %31, !dbg !791

28:                                               ; preds = %19
  %29 = load i32, ptr %4, align 4, !dbg !792
  %30 = add nsw i32 %29, 1, !dbg !792
  store i32 %30, ptr %4, align 4, !dbg !792
  br label %32, !dbg !793

31:                                               ; preds = %19
  store i32 0, ptr %2, align 4, !dbg !794
  br label %35, !dbg !794

32:                                               ; preds = %28
  br label %11, !dbg !777, !llvm.loop !795

33:                                               ; preds = %11
  store i32 1, ptr %2, align 4, !dbg !797
  br label %35, !dbg !797

34:                                               ; preds = %1
  store i32 0, ptr %2, align 4, !dbg !798
  br label %35, !dbg !798

35:                                               ; preds = %34, %33, %31
  %36 = load i32, ptr %2, align 4, !dbg !799
  ret i32 %36, !dbg !799
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define internal i32 @is_str_constant(ptr noundef %0) #0 !dbg !800 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !801, metadata !DIExpression()), !dbg !802
  call void @llvm.dbg.declare(metadata ptr %4, metadata !803, metadata !DIExpression()), !dbg !804
  store i32 1, ptr %4, align 4, !dbg !804
  %5 = load ptr, ptr %3, align 8, !dbg !805
  %6 = load i8, ptr %5, align 1, !dbg !807
  %7 = sext i8 %6 to i32, !dbg !807
  %8 = icmp eq i32 %7, 34, !dbg !808
  br i1 %8, label %9, label %32, !dbg !809

9:                                                ; preds = %1
  br label %10, !dbg !810

10:                                               ; preds = %30, %9
  %11 = load ptr, ptr %3, align 8, !dbg !812
  %12 = load i32, ptr %4, align 4, !dbg !813
  %13 = sext i32 %12 to i64, !dbg !814
  %14 = getelementptr inbounds i8, ptr %11, i64 %13, !dbg !814
  %15 = load i8, ptr %14, align 1, !dbg !815
  %16 = sext i8 %15 to i32, !dbg !815
  %17 = icmp ne i32 %16, 0, !dbg !816
  br i1 %17, label %18, label %31, !dbg !810

18:                                               ; preds = %10
  %19 = load ptr, ptr %3, align 8, !dbg !817
  %20 = load i32, ptr %4, align 4, !dbg !820
  %21 = sext i32 %20 to i64, !dbg !821
  %22 = getelementptr inbounds i8, ptr %19, i64 %21, !dbg !821
  %23 = load i8, ptr %22, align 1, !dbg !822
  %24 = sext i8 %23 to i32, !dbg !822
  %25 = icmp eq i32 %24, 34, !dbg !823
  br i1 %25, label %26, label %27, !dbg !824

26:                                               ; preds = %18
  store i32 1, ptr %2, align 4, !dbg !825
  br label %33, !dbg !825

27:                                               ; preds = %18
  %28 = load i32, ptr %4, align 4, !dbg !826
  %29 = add nsw i32 %28, 1, !dbg !826
  store i32 %29, ptr %4, align 4, !dbg !826
  br label %30

30:                                               ; preds = %27
  br label %10, !dbg !810, !llvm.loop !827

31:                                               ; preds = %10
  store i32 0, ptr %2, align 4, !dbg !829
  br label %33, !dbg !829

32:                                               ; preds = %1
  store i32 0, ptr %2, align 4, !dbg !830
  br label %33, !dbg !830

33:                                               ; preds = %32, %31, %26
  %34 = load i32, ptr %2, align 4, !dbg !831
  ret i32 %34, !dbg !831
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define internal i32 @is_char_constant(ptr noundef %0) #0 !dbg !832 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !833, metadata !DIExpression()), !dbg !834
  %4 = load ptr, ptr %3, align 8, !dbg !835
  %5 = load i8, ptr %4, align 1, !dbg !837
  %6 = sext i8 %5 to i32, !dbg !838
  %7 = icmp eq i32 %6, 35, !dbg !839
  br i1 %7, label %8, label %16, !dbg !840

8:                                                ; preds = %1
  %9 = load ptr, ptr %3, align 8, !dbg !841
  %10 = getelementptr inbounds i8, ptr %9, i64 1, !dbg !842
  %11 = load i8, ptr %10, align 1, !dbg !843
  %12 = sext i8 %11 to i32, !dbg !843
  %13 = call i32 @isalpha(i32 noundef %12) #8, !dbg !844
  %14 = icmp ne i32 %13, 0, !dbg !844
  br i1 %14, label %15, label %16, !dbg !845

15:                                               ; preds = %8
  store i32 1, ptr %2, align 4, !dbg !846
  br label %17, !dbg !846

16:                                               ; preds = %8, %1
  store i32 0, ptr %2, align 4, !dbg !847
  br label %17, !dbg !847

17:                                               ; preds = %16, %15
  %18 = load i32, ptr %2, align 4, !dbg !848
  ret i32 %18, !dbg !848
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define internal i32 @is_comment(ptr noundef %0) #0 !dbg !849 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !850, metadata !DIExpression()), !dbg !851
  %4 = load ptr, ptr %3, align 8, !dbg !852
  %5 = load i8, ptr %4, align 1, !dbg !854
  %6 = sext i8 %5 to i32, !dbg !855
  %7 = icmp eq i32 %6, 59, !dbg !856
  br i1 %7, label %8, label %9, !dbg !857

8:                                                ; preds = %1
  store i32 1, ptr %2, align 4, !dbg !858
  br label %10, !dbg !858

9:                                                ; preds = %1
  store i32 0, ptr %2, align 4, !dbg !859
  br label %10, !dbg !859

10:                                               ; preds = %9, %8
  %11 = load i32, ptr %2, align 4, !dbg !860
  ret i32 %11, !dbg !860
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define internal i32 @unget_error(ptr noundef %0) #0 !dbg !861 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !865, metadata !DIExpression()), !dbg !866
  %4 = load ptr, ptr @__stdoutp, align 8, !dbg !867
  %5 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %4, ptr noundef @.str.17), !dbg !868
  %6 = load i32, ptr %2, align 4, !dbg !869
  ret i32 %6, !dbg !869
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define internal void @print_spec_symbol(ptr noundef %0) #0 !dbg !870 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !873, metadata !DIExpression()), !dbg !874
  %3 = load ptr, ptr %2, align 8, !dbg !875
  %4 = call i32 @strcmp(ptr noundef %3, ptr noundef @.str.18), !dbg !877
  %5 = icmp ne i32 %4, 0, !dbg !877
  br i1 %5, label %9, label %6, !dbg !878

6:                                                ; preds = %1
  %7 = load ptr, ptr @__stdoutp, align 8, !dbg !879
  %8 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %7, ptr noundef @.str.19, ptr noundef @.str.20), !dbg !881
  br label %47, !dbg !882

9:                                                ; preds = %1
  %10 = load ptr, ptr %2, align 8, !dbg !883
  %11 = call i32 @strcmp(ptr noundef %10, ptr noundef @.str.21), !dbg !885
  %12 = icmp ne i32 %11, 0, !dbg !885
  br i1 %12, label %16, label %13, !dbg !886

13:                                               ; preds = %9
  %14 = load ptr, ptr @__stdoutp, align 8, !dbg !887
  %15 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %14, ptr noundef @.str.19, ptr noundef @.str.22), !dbg !889
  br label %47, !dbg !890

16:                                               ; preds = %9
  %17 = load ptr, ptr %2, align 8, !dbg !891
  %18 = call i32 @strcmp(ptr noundef %17, ptr noundef @.str.23), !dbg !893
  %19 = icmp ne i32 %18, 0, !dbg !893
  br i1 %19, label %23, label %20, !dbg !894

20:                                               ; preds = %16
  %21 = load ptr, ptr @__stdoutp, align 8, !dbg !895
  %22 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %21, ptr noundef @.str.19, ptr noundef @.str.24), !dbg !897
  br label %47, !dbg !898

23:                                               ; preds = %16
  %24 = load ptr, ptr %2, align 8, !dbg !899
  %25 = call i32 @strcmp(ptr noundef %24, ptr noundef @.str.25), !dbg !901
  %26 = icmp ne i32 %25, 0, !dbg !901
  br i1 %26, label %30, label %27, !dbg !902

27:                                               ; preds = %23
  %28 = load ptr, ptr @__stdoutp, align 8, !dbg !903
  %29 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %28, ptr noundef @.str.19, ptr noundef @.str.26), !dbg !905
  br label %47, !dbg !906

30:                                               ; preds = %23
  %31 = load ptr, ptr %2, align 8, !dbg !907
  %32 = call i32 @strcmp(ptr noundef %31, ptr noundef @.str.27), !dbg !909
  %33 = icmp ne i32 %32, 0, !dbg !909
  br i1 %33, label %37, label %34, !dbg !910

34:                                               ; preds = %30
  %35 = load ptr, ptr @__stdoutp, align 8, !dbg !911
  %36 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %35, ptr noundef @.str.19, ptr noundef @.str.28), !dbg !913
  br label %47, !dbg !914

37:                                               ; preds = %30
  %38 = load ptr, ptr %2, align 8, !dbg !915
  %39 = call i32 @strcmp(ptr noundef %38, ptr noundef @.str.29), !dbg !917
  %40 = icmp ne i32 %39, 0, !dbg !917
  br i1 %40, label %44, label %41, !dbg !918

41:                                               ; preds = %37
  %42 = load ptr, ptr @__stdoutp, align 8, !dbg !919
  %43 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %42, ptr noundef @.str.19, ptr noundef @.str.30), !dbg !921
  br label %47, !dbg !922

44:                                               ; preds = %37
  %45 = load ptr, ptr @__stdoutp, align 8, !dbg !923
  %46 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %45, ptr noundef @.str.19, ptr noundef @.str.31), !dbg !924
  br label %47, !dbg !925

47:                                               ; preds = %44, %41, %34, %27, %20, %13, %6
  ret void, !dbg !925
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define internal i32 @is_spec_symbol(ptr noundef %0) #0 !dbg !926 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !927, metadata !DIExpression()), !dbg !928
  %4 = load ptr, ptr %3, align 8, !dbg !929
  %5 = call i32 @strcmp(ptr noundef %4, ptr noundef @.str.18), !dbg !931
  %6 = icmp ne i32 %5, 0, !dbg !931
  br i1 %6, label %8, label %7, !dbg !932

7:                                                ; preds = %1
  store i32 1, ptr %2, align 4, !dbg !933
  br label %39, !dbg !933

8:                                                ; preds = %1
  %9 = load ptr, ptr %3, align 8, !dbg !935
  %10 = call i32 @strcmp(ptr noundef %9, ptr noundef @.str.21), !dbg !937
  %11 = icmp ne i32 %10, 0, !dbg !937
  br i1 %11, label %13, label %12, !dbg !938

12:                                               ; preds = %8
  store i32 1, ptr %2, align 4, !dbg !939
  br label %39, !dbg !939

13:                                               ; preds = %8
  %14 = load ptr, ptr %3, align 8, !dbg !941
  %15 = call i32 @strcmp(ptr noundef %14, ptr noundef @.str.23), !dbg !943
  %16 = icmp ne i32 %15, 0, !dbg !943
  br i1 %16, label %18, label %17, !dbg !944

17:                                               ; preds = %13
  store i32 1, ptr %2, align 4, !dbg !945
  br label %39, !dbg !945

18:                                               ; preds = %13
  %19 = load ptr, ptr %3, align 8, !dbg !947
  %20 = call i32 @strcmp(ptr noundef %19, ptr noundef @.str.25), !dbg !949
  %21 = icmp ne i32 %20, 0, !dbg !949
  br i1 %21, label %23, label %22, !dbg !950

22:                                               ; preds = %18
  store i32 1, ptr %2, align 4, !dbg !951
  br label %39, !dbg !951

23:                                               ; preds = %18
  %24 = load ptr, ptr %3, align 8, !dbg !953
  %25 = call i32 @strcmp(ptr noundef %24, ptr noundef @.str.27), !dbg !955
  %26 = icmp ne i32 %25, 0, !dbg !955
  br i1 %26, label %28, label %27, !dbg !956

27:                                               ; preds = %23
  store i32 1, ptr %2, align 4, !dbg !957
  br label %39, !dbg !957

28:                                               ; preds = %23
  %29 = load ptr, ptr %3, align 8, !dbg !959
  %30 = call i32 @strcmp(ptr noundef %29, ptr noundef @.str.29), !dbg !961
  %31 = icmp ne i32 %30, 0, !dbg !961
  br i1 %31, label %33, label %32, !dbg !962

32:                                               ; preds = %28
  store i32 1, ptr %2, align 4, !dbg !963
  br label %39, !dbg !963

33:                                               ; preds = %28
  %34 = load ptr, ptr %3, align 8, !dbg !965
  %35 = call i32 @strcmp(ptr noundef %34, ptr noundef @.str.32), !dbg !967
  %36 = icmp ne i32 %35, 0, !dbg !967
  br i1 %36, label %38, label %37, !dbg !968

37:                                               ; preds = %33
  store i32 1, ptr %2, align 4, !dbg !969
  br label %39, !dbg !969

38:                                               ; preds = %33
  store i32 0, ptr %2, align 4, !dbg !971
  br label %39, !dbg !971

39:                                               ; preds = %38, %37, %32, %27, %22, %17, %12, %7
  %40 = load i32, ptr %2, align 4, !dbg !972
  ret i32 %40, !dbg !972
}

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #3 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #4 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #5 = { nounwind readonly willreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #6 = { allocsize(0) }
attributes #7 = { noreturn }
attributes #8 = { nounwind readonly willreturn }

!llvm.dbg.cu = !{!24}
!llvm.module.flags = !{!126, !127, !128, !129, !130, !131}
!llvm.ident = !{!132}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 37, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "printtokens2_2_fuzz.c", directory: "XXX/converter/ft_data/source_code/printtokens2_2")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 296, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 37)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 67, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 16, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 2)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 69, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 224, elements: !15)
!15 = !{!16}
!16 = !DISubrange(count: 28)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !2, line: 134, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 8, elements: !20)
!20 = !{!21}
!21 = !DISubrange(count: 1)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(name: "buffer", scope: !24, file: !2, line: 109, type: !123, isLocal: false, isDefinition: true)
!24 = distinct !DICompileUnit(language: DW_LANG_C99, file: !2, producer: "Homebrew clang version 15.0.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !25, globals: !28, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk", sdk: "MacOSX12.sdk")
!25 = !{!26, !27}
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !{!0, !7, !12, !17, !29, !34, !39, !44, !46, !51, !56, !22, !61, !66, !71, !73, !75, !80, !82, !87, !89, !91, !96, !98, !100, !102, !107, !109, !111, !113, !115, !117, !119, !121}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !2, line: 265, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 104, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 13)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !2, line: 268, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 120, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 15)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(scope: null, file: !2, line: 272, type: !41, isLocal: true, isDefinition: true)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 144, elements: !42)
!42 = !{!43}
!43 = !DISubrange(count: 18)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(scope: null, file: !2, line: 275, type: !31, isLocal: true, isDefinition: true)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(scope: null, file: !2, line: 278, type: !48, isLocal: true, isDefinition: true)
!48 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 96, elements: !49)
!49 = !{!50}
!50 = !DISubrange(count: 12)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(scope: null, file: !2, line: 282, type: !53, isLocal: true, isDefinition: true)
!53 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !54)
!54 = !{!55}
!55 = !DISubrange(count: 17)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(scope: null, file: !2, line: 285, type: !58, isLocal: true, isDefinition: true)
!58 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 48, elements: !59)
!59 = !{!60}
!60 = !DISubrange(count: 6)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(scope: null, file: !2, line: 326, type: !63, isLocal: true, isDefinition: true)
!63 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 32, elements: !64)
!64 = !{!65}
!65 = !DISubrange(count: 4)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(scope: null, file: !2, line: 326, type: !68, isLocal: true, isDefinition: true)
!68 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 24, elements: !69)
!69 = !{!70}
!70 = !DISubrange(count: 3)
!71 = !DIGlobalVariableExpression(var: !72, expr: !DIExpression())
!72 = distinct !DIGlobalVariable(scope: null, file: !2, line: 326, type: !68, isLocal: true, isDefinition: true)
!73 = !DIGlobalVariableExpression(var: !74, expr: !DIExpression())
!74 = distinct !DIGlobalVariable(scope: null, file: !2, line: 327, type: !63, isLocal: true, isDefinition: true)
!75 = !DIGlobalVariableExpression(var: !76, expr: !DIExpression())
!76 = distinct !DIGlobalVariable(scope: null, file: !2, line: 327, type: !77, isLocal: true, isDefinition: true)
!77 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 56, elements: !78)
!78 = !{!79}
!79 = !DISubrange(count: 7)
!80 = !DIGlobalVariableExpression(var: !81, expr: !DIExpression())
!81 = distinct !DIGlobalVariable(scope: null, file: !2, line: 327, type: !68, isLocal: true, isDefinition: true)
!82 = !DIGlobalVariableExpression(var: !83, expr: !DIExpression())
!83 = distinct !DIGlobalVariable(scope: null, file: !2, line: 427, type: !84, isLocal: true, isDefinition: true)
!84 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 200, elements: !85)
!85 = !{!86}
!86 = !DISubrange(count: 25)
!87 = !DIGlobalVariableExpression(var: !88, expr: !DIExpression())
!88 = distinct !DIGlobalVariable(scope: null, file: !2, line: 439, type: !9, isLocal: true, isDefinition: true)
!89 = !DIGlobalVariableExpression(var: !90, expr: !DIExpression())
!90 = distinct !DIGlobalVariable(scope: null, file: !2, line: 441, type: !63, isLocal: true, isDefinition: true)
!91 = !DIGlobalVariableExpression(var: !92, expr: !DIExpression())
!92 = distinct !DIGlobalVariable(scope: null, file: !2, line: 441, type: !93, isLocal: true, isDefinition: true)
!93 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !94)
!94 = !{!95}
!95 = !DISubrange(count: 8)
!96 = !DIGlobalVariableExpression(var: !97, expr: !DIExpression())
!97 = distinct !DIGlobalVariable(scope: null, file: !2, line: 444, type: !9, isLocal: true, isDefinition: true)
!98 = !DIGlobalVariableExpression(var: !99, expr: !DIExpression())
!99 = distinct !DIGlobalVariable(scope: null, file: !2, line: 446, type: !93, isLocal: true, isDefinition: true)
!100 = !DIGlobalVariableExpression(var: !101, expr: !DIExpression())
!101 = distinct !DIGlobalVariable(scope: null, file: !2, line: 449, type: !9, isLocal: true, isDefinition: true)
!102 = !DIGlobalVariableExpression(var: !103, expr: !DIExpression())
!103 = distinct !DIGlobalVariable(scope: null, file: !2, line: 451, type: !104, isLocal: true, isDefinition: true)
!104 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !105)
!105 = !{!106}
!106 = !DISubrange(count: 9)
!107 = !DIGlobalVariableExpression(var: !108, expr: !DIExpression())
!108 = distinct !DIGlobalVariable(scope: null, file: !2, line: 454, type: !9, isLocal: true, isDefinition: true)
!109 = !DIGlobalVariableExpression(var: !110, expr: !DIExpression())
!110 = distinct !DIGlobalVariable(scope: null, file: !2, line: 456, type: !104, isLocal: true, isDefinition: true)
!111 = !DIGlobalVariableExpression(var: !112, expr: !DIExpression())
!112 = distinct !DIGlobalVariable(scope: null, file: !2, line: 459, type: !9, isLocal: true, isDefinition: true)
!113 = !DIGlobalVariableExpression(var: !114, expr: !DIExpression())
!114 = distinct !DIGlobalVariable(scope: null, file: !2, line: 461, type: !77, isLocal: true, isDefinition: true)
!115 = !DIGlobalVariableExpression(var: !116, expr: !DIExpression())
!116 = distinct !DIGlobalVariable(scope: null, file: !2, line: 464, type: !9, isLocal: true, isDefinition: true)
!117 = !DIGlobalVariableExpression(var: !118, expr: !DIExpression())
!118 = distinct !DIGlobalVariable(scope: null, file: !2, line: 466, type: !93, isLocal: true, isDefinition: true)
!119 = !DIGlobalVariableExpression(var: !120, expr: !DIExpression())
!120 = distinct !DIGlobalVariable(scope: null, file: !2, line: 470, type: !77, isLocal: true, isDefinition: true)
!121 = !DIGlobalVariableExpression(var: !122, expr: !DIExpression())
!122 = distinct !DIGlobalVariable(scope: null, file: !2, line: 506, type: !9, isLocal: true, isDefinition: true)
!123 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 648, elements: !124)
!124 = !{!125}
!125 = !DISubrange(count: 81)
!126 = !{i32 7, !"Dwarf Version", i32 4}
!127 = !{i32 2, !"Debug Info Version", i32 3}
!128 = !{i32 1, !"wchar_size", i32 4}
!129 = !{i32 7, !"PIC Level", i32 2}
!130 = !{i32 7, !"uwtable", i32 2}
!131 = !{i32 7, !"frame-pointer", i32 1}
!132 = !{!"Homebrew clang version 15.0.3"}
!133 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 23, type: !134, scopeLine: 26, spFlags: DISPFlagDefinition, unit: !24, retainedNodes: !138)
!134 = !DISubroutineType(types: !135)
!135 = !{!136, !136, !137}
!136 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!137 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!138 = !{}
!139 = !DILocalVariable(name: "argc", arg: 1, scope: !133, file: !2, line: 24, type: !136)
!140 = !DILocation(line: 24, column: 5, scope: !133)
!141 = !DILocalVariable(name: "argv", arg: 2, scope: !133, file: !2, line: 25, type: !137)
!142 = !DILocation(line: 25, column: 7, scope: !133)
!143 = !DILocalVariable(name: "fname", scope: !133, file: !2, line: 26, type: !26)
!144 = !DILocation(line: 26, column: 10, scope: !133)
!145 = !DILocalVariable(name: "tok", scope: !133, file: !2, line: 27, type: !146)
!146 = !DIDerivedType(tag: DW_TAG_typedef, name: "token", file: !147, line: 18, baseType: !26)
!147 = !DIFile(filename: "./tokens.h", directory: "XXX/converter/ft_data/source_code/printtokens2_2")
!148 = !DILocation(line: 27, column: 10, scope: !133)
!149 = !DILocalVariable(name: "tp", scope: !133, file: !2, line: 28, type: !150)
!150 = !DIDerivedType(tag: DW_TAG_typedef, name: "token_stream", file: !147, line: 16, baseType: !151)
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !152, size: 64)
!152 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !153, line: 157, baseType: !154)
!153 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk/usr/include/_stdio.h", directory: "")
!154 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sFILE", file: !153, line: 126, size: 1216, elements: !155)
!155 = !{!156, !159, !160, !161, !163, !164, !169, !170, !171, !175, !179, !189, !195, !196, !199, !200, !202, !204, !205, !206}
!156 = !DIDerivedType(tag: DW_TAG_member, name: "_p", scope: !154, file: !153, line: 127, baseType: !157, size: 64)
!157 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !158, size: 64)
!158 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "_r", scope: !154, file: !153, line: 128, baseType: !136, size: 32, offset: 64)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "_w", scope: !154, file: !153, line: 129, baseType: !136, size: 32, offset: 96)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !154, file: !153, line: 130, baseType: !162, size: 16, offset: 128)
!162 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "_file", scope: !154, file: !153, line: 131, baseType: !162, size: 16, offset: 144)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "_bf", scope: !154, file: !153, line: 132, baseType: !165, size: 128, offset: 192)
!165 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sbuf", file: !153, line: 92, size: 128, elements: !166)
!166 = !{!167, !168}
!167 = !DIDerivedType(tag: DW_TAG_member, name: "_base", scope: !165, file: !153, line: 93, baseType: !157, size: 64)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "_size", scope: !165, file: !153, line: 94, baseType: !136, size: 32, offset: 64)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "_lbfsize", scope: !154, file: !153, line: 133, baseType: !136, size: 32, offset: 320)
!170 = !DIDerivedType(tag: DW_TAG_member, name: "_cookie", scope: !154, file: !153, line: 136, baseType: !27, size: 64, offset: 384)
!171 = !DIDerivedType(tag: DW_TAG_member, name: "_close", scope: !154, file: !153, line: 137, baseType: !172, size: 64, offset: 448)
!172 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !173, size: 64)
!173 = !DISubroutineType(types: !174)
!174 = !{!136, !27}
!175 = !DIDerivedType(tag: DW_TAG_member, name: "_read", scope: !154, file: !153, line: 138, baseType: !176, size: 64, offset: 512)
!176 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !177, size: 64)
!177 = !DISubroutineType(types: !178)
!178 = !{!136, !27, !26, !136}
!179 = !DIDerivedType(tag: DW_TAG_member, name: "_seek", scope: !154, file: !153, line: 139, baseType: !180, size: 64, offset: 576)
!180 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !181, size: 64)
!181 = !DISubroutineType(types: !182)
!182 = !{!183, !27, !183, !136}
!183 = !DIDerivedType(tag: DW_TAG_typedef, name: "fpos_t", file: !153, line: 81, baseType: !184)
!184 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_off_t", file: !185, line: 71, baseType: !186)
!185 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk/usr/include/sys/_types.h", directory: "")
!186 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !187, line: 24, baseType: !188)
!187 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk/usr/include/arm/_types.h", directory: "")
!188 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "_write", scope: !154, file: !153, line: 140, baseType: !190, size: 64, offset: 640)
!190 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !191, size: 64)
!191 = !DISubroutineType(types: !192)
!192 = !{!136, !27, !193, !136}
!193 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !194, size: 64)
!194 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "_ub", scope: !154, file: !153, line: 143, baseType: !165, size: 128, offset: 704)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "_extra", scope: !154, file: !153, line: 144, baseType: !197, size: 64, offset: 832)
!197 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !198, size: 64)
!198 = !DICompositeType(tag: DW_TAG_structure_type, name: "__sFILEX", file: !153, line: 98, flags: DIFlagFwdDecl)
!199 = !DIDerivedType(tag: DW_TAG_member, name: "_ur", scope: !154, file: !153, line: 145, baseType: !136, size: 32, offset: 896)
!200 = !DIDerivedType(tag: DW_TAG_member, name: "_ubuf", scope: !154, file: !153, line: 148, baseType: !201, size: 24, offset: 928)
!201 = !DICompositeType(tag: DW_TAG_array_type, baseType: !158, size: 24, elements: !69)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "_nbuf", scope: !154, file: !153, line: 149, baseType: !203, size: 8, offset: 952)
!203 = !DICompositeType(tag: DW_TAG_array_type, baseType: !158, size: 8, elements: !20)
!204 = !DIDerivedType(tag: DW_TAG_member, name: "_lb", scope: !154, file: !153, line: 152, baseType: !165, size: 128, offset: 960)
!205 = !DIDerivedType(tag: DW_TAG_member, name: "_blksize", scope: !154, file: !153, line: 155, baseType: !136, size: 32, offset: 1088)
!206 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !154, file: !153, line: 156, baseType: !183, size: 64, offset: 1152)
!207 = !DILocation(line: 28, column: 17, scope: !133)
!208 = !DILocation(line: 29, column: 9, scope: !209)
!209 = distinct !DILexicalBlock(scope: !133, file: !2, line: 29, column: 9)
!210 = !DILocation(line: 29, column: 13, scope: !209)
!211 = !DILocation(line: 29, column: 9, scope: !133)
!212 = !DILocation(line: 31, column: 25, scope: !213)
!213 = distinct !DILexicalBlock(scope: !209, file: !2, line: 30, column: 8)
!214 = !DILocation(line: 31, column: 14, scope: !213)
!215 = !DILocation(line: 32, column: 10, scope: !213)
!216 = !DILocation(line: 32, column: 16, scope: !213)
!217 = !DILocation(line: 33, column: 8, scope: !213)
!218 = !DILocation(line: 34, column: 14, scope: !219)
!219 = distinct !DILexicalBlock(scope: !209, file: !2, line: 34, column: 14)
!220 = !DILocation(line: 34, column: 18, scope: !219)
!221 = !DILocation(line: 34, column: 14, scope: !209)
!222 = !DILocation(line: 35, column: 16, scope: !219)
!223 = !DILocation(line: 35, column: 14, scope: !219)
!224 = !DILocation(line: 35, column: 9, scope: !219)
!225 = !DILocation(line: 37, column: 18, scope: !226)
!226 = distinct !DILexicalBlock(scope: !219, file: !2, line: 37, column: 8)
!227 = !DILocation(line: 37, column: 10, scope: !226)
!228 = !DILocation(line: 38, column: 10, scope: !226)
!229 = !DILocation(line: 40, column: 18, scope: !133)
!230 = !DILocation(line: 40, column: 17, scope: !133)
!231 = !DILocation(line: 40, column: 12, scope: !133)
!232 = !DILocation(line: 40, column: 5, scope: !133)
!233 = !DILocation(line: 41, column: 26, scope: !133)
!234 = !DILocation(line: 41, column: 8, scope: !133)
!235 = !DILocation(line: 41, column: 7, scope: !133)
!236 = !DILocation(line: 42, column: 19, scope: !133)
!237 = !DILocation(line: 42, column: 9, scope: !133)
!238 = !DILocation(line: 42, column: 8, scope: !133)
!239 = !DILocation(line: 43, column: 5, scope: !133)
!240 = !DILocation(line: 43, column: 25, scope: !133)
!241 = !DILocation(line: 43, column: 12, scope: !133)
!242 = !DILocation(line: 43, column: 30, scope: !133)
!243 = !DILocation(line: 45, column: 20, scope: !244)
!244 = distinct !DILexicalBlock(scope: !133, file: !2, line: 44, column: 5)
!245 = !DILocation(line: 45, column: 8, scope: !244)
!246 = !DILocation(line: 46, column: 22, scope: !244)
!247 = !DILocation(line: 46, column: 12, scope: !244)
!248 = !DILocation(line: 46, column: 11, scope: !244)
!249 = distinct !{!249, !239, !250, !251}
!250 = !DILocation(line: 47, column: 5, scope: !133)
!251 = !{!"llvm.loop.mustprogress"}
!252 = !DILocation(line: 48, column: 17, scope: !133)
!253 = !DILocation(line: 48, column: 5, scope: !133)
!254 = !DILocation(line: 49, column: 5, scope: !133)
!255 = distinct !DISubprogram(name: "open_character_stream", scope: !2, file: !2, line: 62, type: !256, scopeLine: 64, spFlags: DISPFlagDefinition, unit: !24, retainedNodes: !138)
!256 = !DISubroutineType(types: !257)
!257 = !{!258, !26}
!258 = !DIDerivedType(tag: DW_TAG_typedef, name: "character_stream", file: !259, line: 10, baseType: !151)
!259 = !DIFile(filename: "./stream.h", directory: "XXX/converter/ft_data/source_code/printtokens2_2")
!260 = !DILocalVariable(name: "fname", arg: 1, scope: !255, file: !2, line: 63, type: !26)
!261 = !DILocation(line: 63, column: 7, scope: !255)
!262 = !DILocalVariable(name: "fp", scope: !255, file: !2, line: 64, type: !258)
!263 = !DILocation(line: 64, column: 20, scope: !255)
!264 = !DILocation(line: 65, column: 6, scope: !265)
!265 = distinct !DILexicalBlock(scope: !255, file: !2, line: 65, column: 6)
!266 = !DILocation(line: 65, column: 12, scope: !265)
!267 = !DILocation(line: 65, column: 6, scope: !255)
!268 = !DILocation(line: 66, column: 9, scope: !265)
!269 = !DILocation(line: 66, column: 8, scope: !265)
!270 = !DILocation(line: 66, column: 6, scope: !265)
!271 = !DILocation(line: 67, column: 22, scope: !272)
!272 = distinct !DILexicalBlock(scope: !265, file: !2, line: 67, column: 12)
!273 = !DILocation(line: 67, column: 16, scope: !272)
!274 = !DILocation(line: 67, column: 15, scope: !272)
!275 = !DILocation(line: 67, column: 33, scope: !272)
!276 = !DILocation(line: 67, column: 12, scope: !265)
!277 = !DILocation(line: 69, column: 16, scope: !278)
!278 = distinct !DILexicalBlock(scope: !272, file: !2, line: 68, column: 3)
!279 = !DILocation(line: 69, column: 55, scope: !278)
!280 = !DILocation(line: 69, column: 8, scope: !278)
!281 = !DILocation(line: 70, column: 8, scope: !278)
!282 = !DILocation(line: 72, column: 10, scope: !255)
!283 = !DILocation(line: 72, column: 3, scope: !255)
!284 = distinct !DISubprogram(name: "get_char", scope: !2, file: !2, line: 80, type: !285, scopeLine: 82, spFlags: DISPFlagDefinition, unit: !24, retainedNodes: !138)
!285 = !DISubroutineType(types: !286)
!286 = !{!4, !258}
!287 = !DILocalVariable(name: "fp", arg: 1, scope: !284, file: !2, line: 81, type: !258)
!288 = !DILocation(line: 81, column: 18, scope: !284)
!289 = !DILocalVariable(name: "ch", scope: !284, file: !2, line: 82, type: !4)
!290 = !DILocation(line: 82, column: 8, scope: !284)
!291 = !DILocation(line: 83, column: 11, scope: !284)
!292 = !DILocation(line: 83, column: 6, scope: !284)
!293 = !DILocation(line: 83, column: 5, scope: !284)
!294 = !DILocation(line: 84, column: 10, scope: !284)
!295 = !DILocation(line: 84, column: 3, scope: !284)
!296 = distinct !DISubprogram(name: "unget_char", scope: !2, file: !2, line: 93, type: !297, scopeLine: 96, spFlags: DISPFlagDefinition, unit: !24, retainedNodes: !138)
!297 = !DISubroutineType(types: !298)
!298 = !{!4, !4, !258}
!299 = !DILocalVariable(name: "ch", arg: 1, scope: !296, file: !2, line: 95, type: !4)
!300 = !DILocation(line: 95, column: 6, scope: !296)
!301 = !DILocalVariable(name: "fp", arg: 2, scope: !296, file: !2, line: 94, type: !258)
!302 = !DILocation(line: 94, column: 18, scope: !296)
!303 = !DILocalVariable(name: "c", scope: !296, file: !2, line: 96, type: !4)
!304 = !DILocation(line: 96, column: 8, scope: !296)
!305 = !DILocation(line: 97, column: 12, scope: !296)
!306 = !DILocation(line: 97, column: 15, scope: !296)
!307 = !DILocation(line: 97, column: 5, scope: !296)
!308 = !DILocation(line: 97, column: 4, scope: !296)
!309 = !DILocation(line: 98, column: 6, scope: !310)
!310 = distinct !DILexicalBlock(scope: !296, file: !2, line: 98, column: 6)
!311 = !DILocation(line: 98, column: 8, scope: !310)
!312 = !DILocation(line: 98, column: 6, scope: !296)
!313 = !DILocation(line: 100, column: 13, scope: !314)
!314 = distinct !DILexicalBlock(scope: !310, file: !2, line: 99, column: 5)
!315 = !DILocation(line: 100, column: 6, scope: !314)
!316 = !DILocation(line: 103, column: 13, scope: !310)
!317 = !DILocation(line: 103, column: 6, scope: !310)
!318 = !DILocation(line: 104, column: 1, scope: !296)
!319 = distinct !DISubprogram(name: "open_token_stream", scope: !2, file: !2, line: 130, type: !320, scopeLine: 132, spFlags: DISPFlagDefinition, unit: !24, retainedNodes: !138)
!320 = !DISubroutineType(types: !321)
!321 = !{!150, !26}
!322 = !DILocalVariable(name: "fname", arg: 1, scope: !319, file: !2, line: 131, type: !26)
!323 = !DILocation(line: 131, column: 7, scope: !319)
!324 = !DILocalVariable(name: "fp", scope: !319, file: !2, line: 133, type: !150)
!325 = !DILocation(line: 133, column: 15, scope: !319)
!326 = !DILocation(line: 134, column: 12, scope: !327)
!327 = distinct !DILexicalBlock(scope: !319, file: !2, line: 134, column: 5)
!328 = !DILocation(line: 134, column: 5, scope: !327)
!329 = !DILocation(line: 134, column: 21, scope: !327)
!330 = !DILocation(line: 134, column: 5, scope: !319)
!331 = !DILocation(line: 135, column: 8, scope: !327)
!332 = !DILocation(line: 135, column: 7, scope: !327)
!333 = !DILocation(line: 135, column: 5, scope: !327)
!334 = !DILocation(line: 137, column: 30, scope: !327)
!335 = !DILocation(line: 137, column: 8, scope: !327)
!336 = !DILocation(line: 137, column: 7, scope: !327)
!337 = !DILocation(line: 138, column: 9, scope: !319)
!338 = !DILocation(line: 138, column: 2, scope: !319)
!339 = distinct !DISubprogram(name: "get_token", scope: !2, file: !2, line: 148, type: !340, scopeLine: 150, spFlags: DISPFlagDefinition, unit: !24, retainedNodes: !138)
!340 = !DISubroutineType(types: !341)
!341 = !{!146, !150}
!342 = !DILocalVariable(name: "tp", arg: 1, scope: !339, file: !2, line: 149, type: !150)
!343 = !DILocation(line: 149, column: 14, scope: !339)
!344 = !DILocalVariable(name: "i", scope: !339, file: !2, line: 151, type: !136)
!345 = !DILocation(line: 151, column: 7, scope: !339)
!346 = !DILocalVariable(name: "j", scope: !339, file: !2, line: 151, type: !136)
!347 = !DILocation(line: 151, column: 11, scope: !339)
!348 = !DILocalVariable(name: "id", scope: !339, file: !2, line: 152, type: !136)
!349 = !DILocation(line: 152, column: 7, scope: !339)
!350 = !DILocalVariable(name: "ch", scope: !339, file: !2, line: 153, type: !4)
!351 = !DILocation(line: 153, column: 8, scope: !339)
!352 = !DILocalVariable(name: "ch1", scope: !339, file: !2, line: 153, type: !9)
!353 = !DILocation(line: 153, column: 11, scope: !339)
!354 = !DILocation(line: 154, column: 9, scope: !355)
!355 = distinct !DILexicalBlock(scope: !339, file: !2, line: 154, column: 3)
!356 = !DILocation(line: 154, column: 8, scope: !355)
!357 = !DILocation(line: 154, column: 12, scope: !358)
!358 = distinct !DILexicalBlock(scope: !355, file: !2, line: 154, column: 3)
!359 = !DILocation(line: 154, column: 13, scope: !358)
!360 = !DILocation(line: 154, column: 3, scope: !355)
!361 = !DILocation(line: 155, column: 16, scope: !362)
!362 = distinct !DILexicalBlock(scope: !358, file: !2, line: 155, column: 7)
!363 = !DILocation(line: 155, column: 9, scope: !362)
!364 = !DILocation(line: 155, column: 18, scope: !362)
!365 = !DILocation(line: 155, column: 24, scope: !362)
!366 = !DILocation(line: 154, column: 19, scope: !358)
!367 = !DILocation(line: 154, column: 3, scope: !358)
!368 = distinct !{!368, !360, !369, !251}
!369 = !DILocation(line: 155, column: 24, scope: !355)
!370 = !DILocation(line: 156, column: 4, scope: !339)
!371 = !DILocation(line: 156, column: 10, scope: !339)
!372 = !DILocation(line: 157, column: 4, scope: !339)
!373 = !DILocation(line: 157, column: 10, scope: !339)
!374 = !DILocation(line: 158, column: 16, scope: !339)
!375 = !DILocation(line: 158, column: 7, scope: !339)
!376 = !DILocation(line: 158, column: 6, scope: !339)
!377 = !DILocation(line: 159, column: 4, scope: !339)
!378 = !DILocation(line: 159, column: 10, scope: !339)
!379 = !DILocation(line: 159, column: 12, scope: !339)
!380 = !DILocation(line: 159, column: 17, scope: !339)
!381 = !DILocation(line: 159, column: 19, scope: !339)
!382 = !DILocation(line: 159, column: 21, scope: !339)
!383 = !DILocation(line: 161, column: 20, scope: !384)
!384 = distinct !DILexicalBlock(scope: !339, file: !2, line: 160, column: 7)
!385 = !DILocation(line: 161, column: 11, scope: !384)
!386 = !DILocation(line: 161, column: 10, scope: !384)
!387 = distinct !{!387, !377, !388, !251}
!388 = !DILocation(line: 162, column: 7, scope: !339)
!389 = !DILocation(line: 163, column: 14, scope: !339)
!390 = !DILocation(line: 163, column: 11, scope: !339)
!391 = !DILocation(line: 163, column: 4, scope: !339)
!392 = !DILocation(line: 163, column: 13, scope: !339)
!393 = !DILocation(line: 164, column: 7, scope: !394)
!394 = distinct !DILexicalBlock(scope: !339, file: !2, line: 164, column: 7)
!395 = !DILocation(line: 164, column: 27, scope: !394)
!396 = !DILocation(line: 164, column: 7, scope: !339)
!397 = !DILocation(line: 164, column: 34, scope: !394)
!398 = !DILocation(line: 165, column: 7, scope: !399)
!399 = distinct !DILexicalBlock(scope: !339, file: !2, line: 165, column: 7)
!400 = !DILocation(line: 165, column: 29, scope: !399)
!401 = !DILocation(line: 165, column: 7, scope: !339)
!402 = !DILocation(line: 165, column: 36, scope: !399)
!403 = !DILocation(line: 166, column: 7, scope: !404)
!404 = distinct !DILexicalBlock(scope: !339, file: !2, line: 166, column: 7)
!405 = !DILocation(line: 166, column: 10, scope: !404)
!406 = !DILocation(line: 166, column: 7, scope: !339)
!407 = !DILocation(line: 166, column: 18, scope: !404)
!408 = !DILocation(line: 166, column: 16, scope: !404)
!409 = !DILocation(line: 167, column: 7, scope: !410)
!410 = distinct !DILexicalBlock(scope: !339, file: !2, line: 167, column: 7)
!411 = !DILocation(line: 167, column: 10, scope: !410)
!412 = !DILocation(line: 167, column: 7, scope: !339)
!413 = !DILocation(line: 167, column: 17, scope: !410)
!414 = !DILocation(line: 167, column: 15, scope: !410)
!415 = !DILocation(line: 168, column: 16, scope: !339)
!416 = !DILocation(line: 168, column: 7, scope: !339)
!417 = !DILocation(line: 168, column: 6, scope: !339)
!418 = !DILocation(line: 170, column: 4, scope: !339)
!419 = !DILocation(line: 170, column: 24, scope: !339)
!420 = !DILocation(line: 170, column: 27, scope: !339)
!421 = !DILocation(line: 170, column: 11, scope: !339)
!422 = !DILocation(line: 170, column: 31, scope: !339)
!423 = !DILocation(line: 172, column: 9, scope: !424)
!424 = distinct !DILexicalBlock(scope: !339, file: !2, line: 171, column: 4)
!425 = !DILocation(line: 173, column: 18, scope: !424)
!426 = !DILocation(line: 173, column: 15, scope: !424)
!427 = !DILocation(line: 173, column: 8, scope: !424)
!428 = !DILocation(line: 173, column: 17, scope: !424)
!429 = !DILocation(line: 174, column: 20, scope: !424)
!430 = !DILocation(line: 174, column: 11, scope: !424)
!431 = !DILocation(line: 174, column: 10, scope: !424)
!432 = distinct !{!432, !418, !433, !251}
!433 = !DILocation(line: 175, column: 4, scope: !339)
!434 = !DILocation(line: 176, column: 11, scope: !339)
!435 = !DILocation(line: 176, column: 4, scope: !339)
!436 = !DILocation(line: 176, column: 10, scope: !339)
!437 = !DILocation(line: 177, column: 20, scope: !438)
!438 = distinct !DILexicalBlock(scope: !339, file: !2, line: 177, column: 7)
!439 = !DILocation(line: 177, column: 7, scope: !438)
!440 = !DILocation(line: 177, column: 24, scope: !438)
!441 = !DILocation(line: 177, column: 7, scope: !339)
!442 = !DILocation(line: 178, column: 23, scope: !443)
!443 = distinct !DILexicalBlock(scope: !438, file: !2, line: 178, column: 7)
!444 = !DILocation(line: 178, column: 26, scope: !443)
!445 = !DILocation(line: 178, column: 12, scope: !443)
!446 = !DILocation(line: 178, column: 11, scope: !443)
!447 = !DILocation(line: 179, column: 12, scope: !448)
!448 = distinct !DILexicalBlock(scope: !443, file: !2, line: 179, column: 12)
!449 = !DILocation(line: 179, column: 14, scope: !448)
!450 = !DILocation(line: 179, column: 12, scope: !443)
!451 = !DILocation(line: 179, column: 32, scope: !448)
!452 = !DILocation(line: 179, column: 20, scope: !448)
!453 = !DILocation(line: 180, column: 9, scope: !443)
!454 = !DILocation(line: 182, column: 22, scope: !455)
!455 = distinct !DILexicalBlock(scope: !339, file: !2, line: 182, column: 7)
!456 = !DILocation(line: 182, column: 7, scope: !455)
!457 = !DILocation(line: 182, column: 26, scope: !455)
!458 = !DILocation(line: 182, column: 7, scope: !339)
!459 = !DILocation(line: 183, column: 23, scope: !460)
!460 = distinct !DILexicalBlock(scope: !455, file: !2, line: 183, column: 7)
!461 = !DILocation(line: 183, column: 26, scope: !460)
!462 = !DILocation(line: 183, column: 12, scope: !460)
!463 = !DILocation(line: 183, column: 11, scope: !460)
!464 = !DILocation(line: 184, column: 12, scope: !465)
!465 = distinct !DILexicalBlock(scope: !460, file: !2, line: 184, column: 12)
!466 = !DILocation(line: 184, column: 14, scope: !465)
!467 = !DILocation(line: 184, column: 12, scope: !460)
!468 = !DILocation(line: 184, column: 32, scope: !465)
!469 = !DILocation(line: 184, column: 20, scope: !465)
!470 = !DILocation(line: 185, column: 9, scope: !460)
!471 = !DILocation(line: 187, column: 7, scope: !472)
!472 = distinct !DILexicalBlock(scope: !339, file: !2, line: 187, column: 7)
!473 = !DILocation(line: 187, column: 9, scope: !472)
!474 = !DILocation(line: 187, column: 7, scope: !339)
!475 = !DILocation(line: 188, column: 9, scope: !476)
!476 = distinct !DILexicalBlock(scope: !472, file: !2, line: 188, column: 6)
!477 = !DILocation(line: 189, column: 18, scope: !476)
!478 = !DILocation(line: 189, column: 15, scope: !476)
!479 = !DILocation(line: 189, column: 8, scope: !476)
!480 = !DILocation(line: 189, column: 17, scope: !476)
!481 = !DILocation(line: 190, column: 8, scope: !476)
!482 = !DILocation(line: 192, column: 7, scope: !483)
!483 = distinct !DILexicalBlock(scope: !339, file: !2, line: 192, column: 7)
!484 = !DILocation(line: 192, column: 9, scope: !483)
!485 = !DILocation(line: 192, column: 13, scope: !483)
!486 = !DILocation(line: 192, column: 16, scope: !483)
!487 = !DILocation(line: 192, column: 18, scope: !483)
!488 = !DILocation(line: 192, column: 7, scope: !339)
!489 = !DILocation(line: 194, column: 22, scope: !490)
!490 = distinct !DILexicalBlock(scope: !483, file: !2, line: 194, column: 6)
!491 = !DILocation(line: 194, column: 25, scope: !490)
!492 = !DILocation(line: 194, column: 11, scope: !490)
!493 = !DILocation(line: 194, column: 10, scope: !490)
!494 = !DILocation(line: 195, column: 11, scope: !495)
!495 = distinct !DILexicalBlock(scope: !490, file: !2, line: 195, column: 11)
!496 = !DILocation(line: 195, column: 13, scope: !495)
!497 = !DILocation(line: 195, column: 11, scope: !490)
!498 = !DILocation(line: 195, column: 31, scope: !495)
!499 = !DILocation(line: 195, column: 19, scope: !495)
!500 = !DILocation(line: 196, column: 8, scope: !490)
!501 = !DILocation(line: 198, column: 3, scope: !339)
!502 = !DILocation(line: 199, column: 1, scope: !339)
!503 = distinct !DISubprogram(name: "print_token", scope: !2, file: !2, line: 260, type: !504, scopeLine: 262, spFlags: DISPFlagDefinition, unit: !24, retainedNodes: !138)
!504 = !DISubroutineType(types: !505)
!505 = !{!136, !146}
!506 = !DILocalVariable(name: "tok", arg: 1, scope: !503, file: !2, line: 261, type: !146)
!507 = !DILocation(line: 261, column: 7, scope: !503)
!508 = !DILocalVariable(name: "type", scope: !503, file: !2, line: 262, type: !136)
!509 = !DILocation(line: 262, column: 7, scope: !503)
!510 = !DILocation(line: 263, column: 19, scope: !503)
!511 = !DILocation(line: 263, column: 8, scope: !503)
!512 = !DILocation(line: 263, column: 7, scope: !503)
!513 = !DILocation(line: 264, column: 5, scope: !514)
!514 = distinct !DILexicalBlock(scope: !503, file: !2, line: 264, column: 5)
!515 = !DILocation(line: 264, column: 9, scope: !514)
!516 = !DILocation(line: 264, column: 5, scope: !503)
!517 = !DILocation(line: 265, column: 14, scope: !518)
!518 = distinct !DILexicalBlock(scope: !514, file: !2, line: 265, column: 4)
!519 = !DILocation(line: 265, column: 40, scope: !518)
!520 = !DILocation(line: 265, column: 6, scope: !518)
!521 = !DILocation(line: 266, column: 4, scope: !518)
!522 = !DILocation(line: 267, column: 5, scope: !523)
!523 = distinct !DILexicalBlock(scope: !503, file: !2, line: 267, column: 5)
!524 = !DILocation(line: 267, column: 9, scope: !523)
!525 = !DILocation(line: 267, column: 5, scope: !503)
!526 = !DILocation(line: 268, column: 13, scope: !527)
!527 = distinct !DILexicalBlock(scope: !523, file: !2, line: 268, column: 4)
!528 = !DILocation(line: 268, column: 41, scope: !527)
!529 = !DILocation(line: 268, column: 5, scope: !527)
!530 = !DILocation(line: 269, column: 4, scope: !527)
!531 = !DILocation(line: 270, column: 5, scope: !532)
!532 = distinct !DILexicalBlock(scope: !503, file: !2, line: 270, column: 5)
!533 = !DILocation(line: 270, column: 9, scope: !532)
!534 = !DILocation(line: 270, column: 5, scope: !503)
!535 = !DILocation(line: 270, column: 41, scope: !532)
!536 = !DILocation(line: 270, column: 23, scope: !532)
!537 = !DILocation(line: 271, column: 5, scope: !538)
!538 = distinct !DILexicalBlock(scope: !503, file: !2, line: 271, column: 5)
!539 = !DILocation(line: 271, column: 9, scope: !538)
!540 = !DILocation(line: 271, column: 5, scope: !503)
!541 = !DILocation(line: 272, column: 13, scope: !542)
!542 = distinct !DILexicalBlock(scope: !538, file: !2, line: 272, column: 4)
!543 = !DILocation(line: 272, column: 44, scope: !542)
!544 = !DILocation(line: 272, column: 5, scope: !542)
!545 = !DILocation(line: 273, column: 4, scope: !542)
!546 = !DILocation(line: 274, column: 5, scope: !547)
!547 = distinct !DILexicalBlock(scope: !503, file: !2, line: 274, column: 5)
!548 = !DILocation(line: 274, column: 9, scope: !547)
!549 = !DILocation(line: 274, column: 5, scope: !503)
!550 = !DILocation(line: 275, column: 13, scope: !551)
!551 = distinct !DILexicalBlock(scope: !547, file: !2, line: 275, column: 4)
!552 = !DILocation(line: 275, column: 37, scope: !551)
!553 = !DILocation(line: 275, column: 5, scope: !551)
!554 = !DILocation(line: 276, column: 4, scope: !551)
!555 = !DILocation(line: 277, column: 5, scope: !556)
!556 = distinct !DILexicalBlock(scope: !503, file: !2, line: 277, column: 5)
!557 = !DILocation(line: 277, column: 9, scope: !556)
!558 = !DILocation(line: 277, column: 5, scope: !503)
!559 = !DILocation(line: 278, column: 13, scope: !560)
!560 = distinct !DILexicalBlock(scope: !556, file: !2, line: 278, column: 4)
!561 = !DILocation(line: 278, column: 36, scope: !560)
!562 = !DILocation(line: 278, column: 5, scope: !560)
!563 = !DILocation(line: 279, column: 4, scope: !560)
!564 = !DILocation(line: 280, column: 5, scope: !565)
!565 = distinct !DILexicalBlock(scope: !503, file: !2, line: 280, column: 5)
!566 = !DILocation(line: 280, column: 9, scope: !565)
!567 = !DILocation(line: 280, column: 5, scope: !503)
!568 = !DILocation(line: 281, column: 9, scope: !569)
!569 = distinct !DILexicalBlock(scope: !565, file: !2, line: 281, column: 4)
!570 = !DILocation(line: 281, column: 12, scope: !569)
!571 = !DILocation(line: 281, column: 8, scope: !569)
!572 = !DILocation(line: 282, column: 13, scope: !569)
!573 = !DILocation(line: 282, column: 43, scope: !569)
!574 = !DILocation(line: 282, column: 5, scope: !569)
!575 = !DILocation(line: 283, column: 4, scope: !569)
!576 = !DILocation(line: 284, column: 5, scope: !577)
!577 = distinct !DILexicalBlock(scope: !503, file: !2, line: 284, column: 5)
!578 = !DILocation(line: 284, column: 9, scope: !577)
!579 = !DILocation(line: 284, column: 5, scope: !503)
!580 = !DILocation(line: 285, column: 12, scope: !577)
!581 = !DILocation(line: 285, column: 4, scope: !577)
!582 = !DILocation(line: 286, column: 4, scope: !503)
!583 = distinct !DISubprogram(name: "token_type", scope: !2, file: !2, line: 240, type: !504, scopeLine: 242, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !24, retainedNodes: !138)
!584 = !DILocalVariable(name: "tok", arg: 1, scope: !583, file: !2, line: 241, type: !146)
!585 = !DILocation(line: 241, column: 7, scope: !583)
!586 = !DILocation(line: 243, column: 16, scope: !587)
!587 = distinct !DILexicalBlock(scope: !583, file: !2, line: 243, column: 5)
!588 = !DILocation(line: 243, column: 5, scope: !587)
!589 = !DILocation(line: 243, column: 5, scope: !583)
!590 = !DILocation(line: 243, column: 21, scope: !587)
!591 = !DILocation(line: 244, column: 20, scope: !592)
!592 = distinct !DILexicalBlock(scope: !583, file: !2, line: 244, column: 5)
!593 = !DILocation(line: 244, column: 5, scope: !592)
!594 = !DILocation(line: 244, column: 5, scope: !583)
!595 = !DILocation(line: 244, column: 25, scope: !592)
!596 = !DILocation(line: 245, column: 19, scope: !597)
!597 = distinct !DILexicalBlock(scope: !583, file: !2, line: 245, column: 5)
!598 = !DILocation(line: 245, column: 5, scope: !597)
!599 = !DILocation(line: 245, column: 5, scope: !583)
!600 = !DILocation(line: 245, column: 24, scope: !597)
!601 = !DILocation(line: 246, column: 21, scope: !602)
!602 = distinct !DILexicalBlock(scope: !583, file: !2, line: 246, column: 5)
!603 = !DILocation(line: 246, column: 5, scope: !602)
!604 = !DILocation(line: 246, column: 5, scope: !583)
!605 = !DILocation(line: 246, column: 26, scope: !602)
!606 = !DILocation(line: 247, column: 21, scope: !607)
!607 = distinct !DILexicalBlock(scope: !583, file: !2, line: 247, column: 5)
!608 = !DILocation(line: 247, column: 5, scope: !607)
!609 = !DILocation(line: 247, column: 5, scope: !583)
!610 = !DILocation(line: 247, column: 26, scope: !607)
!611 = !DILocation(line: 248, column: 22, scope: !612)
!612 = distinct !DILexicalBlock(scope: !583, file: !2, line: 248, column: 5)
!613 = !DILocation(line: 248, column: 5, scope: !612)
!614 = !DILocation(line: 248, column: 5, scope: !583)
!615 = !DILocation(line: 248, column: 27, scope: !612)
!616 = !DILocation(line: 249, column: 16, scope: !617)
!617 = distinct !DILexicalBlock(scope: !583, file: !2, line: 249, column: 5)
!618 = !DILocation(line: 249, column: 5, scope: !617)
!619 = !DILocation(line: 249, column: 5, scope: !583)
!620 = !DILocation(line: 249, column: 21, scope: !617)
!621 = !DILocation(line: 250, column: 18, scope: !622)
!622 = distinct !DILexicalBlock(scope: !583, file: !2, line: 250, column: 5)
!623 = !DILocation(line: 250, column: 5, scope: !622)
!624 = !DILocation(line: 250, column: 5, scope: !583)
!625 = !DILocation(line: 250, column: 23, scope: !622)
!626 = !DILocation(line: 251, column: 2, scope: !583)
!627 = !DILocation(line: 252, column: 1, scope: !583)
!628 = distinct !DISubprogram(name: "is_eof_token", scope: !2, file: !2, line: 295, type: !504, scopeLine: 297, spFlags: DISPFlagDefinition, unit: !24, retainedNodes: !138)
!629 = !DILocalVariable(name: "tok", arg: 1, scope: !628, file: !2, line: 296, type: !146)
!630 = !DILocation(line: 296, column: 7, scope: !628)
!631 = !DILocation(line: 298, column: 8, scope: !632)
!632 = distinct !DILexicalBlock(scope: !628, file: !2, line: 298, column: 7)
!633 = !DILocation(line: 298, column: 7, scope: !632)
!634 = !DILocation(line: 298, column: 11, scope: !632)
!635 = !DILocation(line: 298, column: 7, scope: !628)
!636 = !DILocation(line: 299, column: 7, scope: !632)
!637 = !DILocation(line: 301, column: 7, scope: !632)
!638 = !DILocation(line: 302, column: 1, scope: !628)
!639 = distinct !DISubprogram(name: "is_token_end", scope: !2, file: !2, line: 206, type: !640, scopeLine: 209, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !24, retainedNodes: !138)
!640 = !DISubroutineType(types: !641)
!641 = !{!136, !136, !4}
!642 = !DILocalVariable(name: "str_com_id", arg: 1, scope: !639, file: !2, line: 208, type: !136)
!643 = !DILocation(line: 208, column: 5, scope: !639)
!644 = !DILocalVariable(name: "ch", arg: 2, scope: !639, file: !2, line: 207, type: !4)
!645 = !DILocation(line: 207, column: 6, scope: !639)
!646 = !DILocalVariable(name: "ch1", scope: !639, file: !2, line: 209, type: !9)
!647 = !DILocation(line: 209, column: 8, scope: !639)
!648 = !DILocation(line: 210, column: 9, scope: !639)
!649 = !DILocation(line: 210, column: 2, scope: !639)
!650 = !DILocation(line: 210, column: 8, scope: !639)
!651 = !DILocation(line: 211, column: 2, scope: !639)
!652 = !DILocation(line: 211, column: 8, scope: !639)
!653 = !DILocation(line: 212, column: 18, scope: !654)
!654 = distinct !DILexicalBlock(scope: !639, file: !2, line: 212, column: 5)
!655 = !DILocation(line: 212, column: 5, scope: !654)
!656 = !DILocation(line: 212, column: 22, scope: !654)
!657 = !DILocation(line: 212, column: 5, scope: !639)
!658 = !DILocation(line: 212, column: 29, scope: !654)
!659 = !DILocation(line: 213, column: 5, scope: !660)
!660 = distinct !DILexicalBlock(scope: !639, file: !2, line: 213, column: 5)
!661 = !DILocation(line: 213, column: 15, scope: !660)
!662 = !DILocation(line: 213, column: 5, scope: !639)
!663 = !DILocation(line: 214, column: 10, scope: !664)
!664 = distinct !DILexicalBlock(scope: !665, file: !2, line: 214, column: 10)
!665 = distinct !DILexicalBlock(scope: !660, file: !2, line: 214, column: 5)
!666 = !DILocation(line: 214, column: 12, scope: !664)
!667 = !DILocation(line: 214, column: 20, scope: !664)
!668 = !DILocation(line: 214, column: 22, scope: !664)
!669 = !DILocation(line: 214, column: 18, scope: !664)
!670 = !DILocation(line: 214, column: 10, scope: !665)
!671 = !DILocation(line: 215, column: 10, scope: !664)
!672 = !DILocation(line: 217, column: 10, scope: !664)
!673 = !DILocation(line: 220, column: 5, scope: !674)
!674 = distinct !DILexicalBlock(scope: !639, file: !2, line: 220, column: 5)
!675 = !DILocation(line: 220, column: 15, scope: !674)
!676 = !DILocation(line: 220, column: 5, scope: !639)
!677 = !DILocation(line: 221, column: 9, scope: !678)
!678 = distinct !DILexicalBlock(scope: !679, file: !2, line: 221, column: 9)
!679 = distinct !DILexicalBlock(scope: !674, file: !2, line: 221, column: 4)
!680 = !DILocation(line: 221, column: 11, scope: !678)
!681 = !DILocation(line: 221, column: 9, scope: !679)
!682 = !DILocation(line: 222, column: 9, scope: !678)
!683 = !DILocation(line: 224, column: 9, scope: !678)
!684 = !DILocation(line: 227, column: 20, scope: !685)
!685 = distinct !DILexicalBlock(scope: !639, file: !2, line: 227, column: 5)
!686 = !DILocation(line: 227, column: 5, scope: !685)
!687 = !DILocation(line: 227, column: 24, scope: !685)
!688 = !DILocation(line: 227, column: 5, scope: !639)
!689 = !DILocation(line: 227, column: 32, scope: !685)
!690 = !DILocation(line: 228, column: 5, scope: !691)
!691 = distinct !DILexicalBlock(scope: !639, file: !2, line: 228, column: 5)
!692 = !DILocation(line: 228, column: 8, scope: !691)
!693 = !DILocation(line: 228, column: 14, scope: !691)
!694 = !DILocation(line: 228, column: 17, scope: !691)
!695 = !DILocation(line: 228, column: 19, scope: !691)
!696 = !DILocation(line: 228, column: 26, scope: !691)
!697 = !DILocation(line: 228, column: 29, scope: !691)
!698 = !DILocation(line: 228, column: 31, scope: !691)
!699 = !DILocation(line: 228, column: 5, scope: !639)
!700 = !DILocation(line: 228, column: 37, scope: !691)
!701 = !DILocation(line: 230, column: 2, scope: !639)
!702 = !DILocation(line: 231, column: 1, scope: !639)
!703 = distinct !DISubprogram(name: "is_keyword", scope: !2, file: !2, line: 323, type: !504, scopeLine: 325, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !24, retainedNodes: !138)
!704 = !DILocalVariable(name: "str", arg: 1, scope: !703, file: !2, line: 324, type: !146)
!705 = !DILocation(line: 324, column: 12, scope: !703)
!706 = !DILocation(line: 326, column: 14, scope: !707)
!707 = distinct !DILexicalBlock(scope: !703, file: !2, line: 326, column: 6)
!708 = !DILocation(line: 326, column: 7, scope: !707)
!709 = !DILocation(line: 326, column: 25, scope: !707)
!710 = !DILocation(line: 326, column: 36, scope: !707)
!711 = !DILocation(line: 326, column: 29, scope: !707)
!712 = !DILocation(line: 326, column: 46, scope: !707)
!713 = !DILocation(line: 326, column: 57, scope: !707)
!714 = !DILocation(line: 326, column: 50, scope: !707)
!715 = !DILocation(line: 326, column: 67, scope: !707)
!716 = !DILocation(line: 327, column: 13, scope: !707)
!717 = !DILocation(line: 327, column: 6, scope: !707)
!718 = !DILocation(line: 327, column: 23, scope: !707)
!719 = !DILocation(line: 327, column: 33, scope: !707)
!720 = !DILocation(line: 327, column: 26, scope: !707)
!721 = !DILocation(line: 327, column: 46, scope: !707)
!722 = !DILocation(line: 327, column: 56, scope: !707)
!723 = !DILocation(line: 327, column: 49, scope: !707)
!724 = !DILocation(line: 326, column: 6, scope: !703)
!725 = !DILocation(line: 328, column: 7, scope: !707)
!726 = !DILocation(line: 330, column: 7, scope: !707)
!727 = !DILocation(line: 331, column: 1, scope: !703)
!728 = distinct !DISubprogram(name: "is_identifier", scope: !2, file: !2, line: 399, type: !504, scopeLine: 401, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !24, retainedNodes: !138)
!729 = !DILocalVariable(name: "str", arg: 1, scope: !728, file: !2, line: 400, type: !146)
!730 = !DILocation(line: 400, column: 12, scope: !728)
!731 = !DILocalVariable(name: "i", scope: !728, file: !2, line: 402, type: !136)
!732 = !DILocation(line: 402, column: 7, scope: !728)
!733 = !DILocation(line: 404, column: 18, scope: !734)
!734 = distinct !DILexicalBlock(scope: !728, file: !2, line: 404, column: 8)
!735 = !DILocation(line: 404, column: 17, scope: !734)
!736 = !DILocation(line: 404, column: 8, scope: !734)
!737 = !DILocation(line: 404, column: 8, scope: !728)
!738 = !DILocation(line: 406, column: 9, scope: !739)
!739 = distinct !DILexicalBlock(scope: !734, file: !2, line: 405, column: 6)
!740 = !DILocation(line: 406, column: 19, scope: !739)
!741 = !DILocation(line: 406, column: 23, scope: !739)
!742 = !DILocation(line: 406, column: 22, scope: !739)
!743 = !DILocation(line: 406, column: 17, scope: !739)
!744 = !DILocation(line: 406, column: 26, scope: !739)
!745 = !DILocation(line: 408, column: 26, scope: !746)
!746 = distinct !DILexicalBlock(scope: !747, file: !2, line: 408, column: 16)
!747 = distinct !DILexicalBlock(scope: !739, file: !2, line: 407, column: 12)
!748 = !DILocation(line: 408, column: 30, scope: !746)
!749 = !DILocation(line: 408, column: 29, scope: !746)
!750 = !DILocation(line: 408, column: 24, scope: !746)
!751 = !DILocation(line: 408, column: 16, scope: !746)
!752 = !DILocation(line: 408, column: 34, scope: !746)
!753 = !DILocation(line: 408, column: 47, scope: !746)
!754 = !DILocation(line: 408, column: 51, scope: !746)
!755 = !DILocation(line: 408, column: 50, scope: !746)
!756 = !DILocation(line: 408, column: 45, scope: !746)
!757 = !DILocation(line: 408, column: 37, scope: !746)
!758 = !DILocation(line: 408, column: 16, scope: !747)
!759 = !DILocation(line: 409, column: 17, scope: !746)
!760 = !DILocation(line: 409, column: 16, scope: !746)
!761 = !DILocation(line: 411, column: 16, scope: !746)
!762 = distinct !{!762, !738, !763, !251}
!763 = !DILocation(line: 412, column: 12, scope: !739)
!764 = !DILocation(line: 413, column: 6, scope: !739)
!765 = !DILocation(line: 416, column: 6, scope: !734)
!766 = !DILocation(line: 417, column: 1, scope: !728)
!767 = distinct !DISubprogram(name: "is_num_constant", scope: !2, file: !2, line: 352, type: !504, scopeLine: 354, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !24, retainedNodes: !138)
!768 = !DILocalVariable(name: "str", arg: 1, scope: !767, file: !2, line: 353, type: !146)
!769 = !DILocation(line: 353, column: 12, scope: !767)
!770 = !DILocalVariable(name: "i", scope: !767, file: !2, line: 355, type: !136)
!771 = !DILocation(line: 355, column: 7, scope: !767)
!772 = !DILocation(line: 357, column: 17, scope: !773)
!773 = distinct !DILexicalBlock(scope: !767, file: !2, line: 357, column: 8)
!774 = !DILocation(line: 357, column: 16, scope: !773)
!775 = !DILocation(line: 357, column: 8, scope: !773)
!776 = !DILocation(line: 357, column: 8, scope: !767)
!777 = !DILocation(line: 359, column: 5, scope: !778)
!778 = distinct !DILexicalBlock(scope: !773, file: !2, line: 358, column: 5)
!779 = !DILocation(line: 359, column: 15, scope: !778)
!780 = !DILocation(line: 359, column: 19, scope: !778)
!781 = !DILocation(line: 359, column: 18, scope: !778)
!782 = !DILocation(line: 359, column: 13, scope: !778)
!783 = !DILocation(line: 359, column: 22, scope: !778)
!784 = !DILocation(line: 361, column: 21, scope: !785)
!785 = distinct !DILexicalBlock(scope: !786, file: !2, line: 361, column: 11)
!786 = distinct !DILexicalBlock(scope: !778, file: !2, line: 360, column: 7)
!787 = !DILocation(line: 361, column: 25, scope: !785)
!788 = !DILocation(line: 361, column: 24, scope: !785)
!789 = !DILocation(line: 361, column: 19, scope: !785)
!790 = !DILocation(line: 361, column: 11, scope: !785)
!791 = !DILocation(line: 361, column: 11, scope: !786)
!792 = !DILocation(line: 362, column: 11, scope: !785)
!793 = !DILocation(line: 362, column: 10, scope: !785)
!794 = !DILocation(line: 364, column: 10, scope: !785)
!795 = distinct !{!795, !777, !796, !251}
!796 = !DILocation(line: 365, column: 7, scope: !778)
!797 = !DILocation(line: 366, column: 5, scope: !778)
!798 = !DILocation(line: 369, column: 4, scope: !773)
!799 = !DILocation(line: 370, column: 1, scope: !767)
!800 = distinct !DISubprogram(name: "is_str_constant", scope: !2, file: !2, line: 377, type: !504, scopeLine: 379, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !24, retainedNodes: !138)
!801 = !DILocalVariable(name: "str", arg: 1, scope: !800, file: !2, line: 378, type: !146)
!802 = !DILocation(line: 378, column: 11, scope: !800)
!803 = !DILocalVariable(name: "i", scope: !800, file: !2, line: 380, type: !136)
!804 = !DILocation(line: 380, column: 7, scope: !800)
!805 = !DILocation(line: 382, column: 9, scope: !806)
!806 = distinct !DILexicalBlock(scope: !800, file: !2, line: 382, column: 8)
!807 = !DILocation(line: 382, column: 8, scope: !806)
!808 = !DILocation(line: 382, column: 13, scope: !806)
!809 = !DILocation(line: 382, column: 8, scope: !800)
!810 = !DILocation(line: 383, column: 8, scope: !811)
!811 = distinct !DILexicalBlock(scope: !806, file: !2, line: 383, column: 6)
!812 = !DILocation(line: 383, column: 17, scope: !811)
!813 = !DILocation(line: 383, column: 21, scope: !811)
!814 = !DILocation(line: 383, column: 20, scope: !811)
!815 = !DILocation(line: 383, column: 15, scope: !811)
!816 = !DILocation(line: 383, column: 23, scope: !811)
!817 = !DILocation(line: 384, column: 17, scope: !818)
!818 = distinct !DILexicalBlock(scope: !819, file: !2, line: 384, column: 15)
!819 = distinct !DILexicalBlock(scope: !811, file: !2, line: 384, column: 10)
!820 = !DILocation(line: 384, column: 21, scope: !818)
!821 = !DILocation(line: 384, column: 20, scope: !818)
!822 = !DILocation(line: 384, column: 15, scope: !818)
!823 = !DILocation(line: 384, column: 23, scope: !818)
!824 = !DILocation(line: 384, column: 15, scope: !819)
!825 = !DILocation(line: 385, column: 14, scope: !818)
!826 = !DILocation(line: 387, column: 13, scope: !818)
!827 = distinct !{!827, !810, !828, !251}
!828 = !DILocation(line: 388, column: 10, scope: !811)
!829 = !DILocation(line: 389, column: 6, scope: !811)
!830 = !DILocation(line: 392, column: 5, scope: !806)
!831 = !DILocation(line: 393, column: 1, scope: !800)
!832 = distinct !DISubprogram(name: "is_char_constant", scope: !2, file: !2, line: 338, type: !504, scopeLine: 340, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !24, retainedNodes: !138)
!833 = !DILocalVariable(name: "str", arg: 1, scope: !832, file: !2, line: 339, type: !146)
!834 = !DILocation(line: 339, column: 11, scope: !832)
!835 = !DILocation(line: 341, column: 9, scope: !836)
!836 = distinct !DILexicalBlock(scope: !832, file: !2, line: 341, column: 7)
!837 = !DILocation(line: 341, column: 8, scope: !836)
!838 = !DILocation(line: 341, column: 7, scope: !836)
!839 = !DILocation(line: 341, column: 13, scope: !836)
!840 = !DILocation(line: 341, column: 19, scope: !836)
!841 = !DILocation(line: 341, column: 32, scope: !836)
!842 = !DILocation(line: 341, column: 35, scope: !836)
!843 = !DILocation(line: 341, column: 30, scope: !836)
!844 = !DILocation(line: 341, column: 22, scope: !836)
!845 = !DILocation(line: 341, column: 7, scope: !832)
!846 = !DILocation(line: 342, column: 6, scope: !836)
!847 = !DILocation(line: 344, column: 6, scope: !836)
!848 = !DILocation(line: 345, column: 1, scope: !832)
!849 = distinct !DISubprogram(name: "is_comment", scope: !2, file: !2, line: 309, type: !504, scopeLine: 311, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !24, retainedNodes: !138)
!850 = !DILocalVariable(name: "ident", arg: 1, scope: !849, file: !2, line: 310, type: !146)
!851 = !DILocation(line: 310, column: 7, scope: !849)
!852 = !DILocation(line: 312, column: 9, scope: !853)
!853 = distinct !DILexicalBlock(scope: !849, file: !2, line: 312, column: 7)
!854 = !DILocation(line: 312, column: 8, scope: !853)
!855 = !DILocation(line: 312, column: 7, scope: !853)
!856 = !DILocation(line: 312, column: 16, scope: !853)
!857 = !DILocation(line: 312, column: 7, scope: !849)
!858 = !DILocation(line: 313, column: 6, scope: !853)
!859 = !DILocation(line: 315, column: 6, scope: !853)
!860 = !DILocation(line: 316, column: 1, scope: !849)
!861 = distinct !DISubprogram(name: "unget_error", scope: !2, file: !2, line: 424, type: !862, scopeLine: 426, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !24, retainedNodes: !138)
!862 = !DISubroutineType(types: !863)
!863 = !{!136, !864}
!864 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !258, size: 64)
!865 = !DILocalVariable(name: "fp", arg: 1, scope: !861, file: !2, line: 425, type: !864)
!866 = !DILocation(line: 425, column: 19, scope: !861)
!867 = !DILocation(line: 427, column: 9, scope: !861)
!868 = !DILocation(line: 427, column: 1, scope: !861)
!869 = !DILocation(line: 428, column: 1, scope: !861)
!870 = distinct !DISubprogram(name: "print_spec_symbol", scope: !2, file: !2, line: 436, type: !871, scopeLine: 438, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !24, retainedNodes: !138)
!871 = !DISubroutineType(types: !872)
!872 = !{null, !146}
!873 = !DILocalVariable(name: "str", arg: 1, scope: !870, file: !2, line: 437, type: !146)
!874 = !DILocation(line: 437, column: 7, scope: !870)
!875 = !DILocation(line: 439, column: 22, scope: !876)
!876 = distinct !DILexicalBlock(scope: !870, file: !2, line: 439, column: 14)
!877 = !DILocation(line: 439, column: 15, scope: !876)
!878 = !DILocation(line: 439, column: 14, scope: !870)
!879 = !DILocation(line: 441, column: 22, scope: !880)
!880 = distinct !DILexicalBlock(scope: !876, file: !2, line: 440, column: 5)
!881 = !DILocation(line: 441, column: 14, scope: !880)
!882 = !DILocation(line: 442, column: 14, scope: !880)
!883 = !DILocation(line: 444, column: 17, scope: !884)
!884 = distinct !DILexicalBlock(scope: !870, file: !2, line: 444, column: 9)
!885 = !DILocation(line: 444, column: 10, scope: !884)
!886 = !DILocation(line: 444, column: 9, scope: !870)
!887 = !DILocation(line: 446, column: 22, scope: !888)
!888 = distinct !DILexicalBlock(scope: !884, file: !2, line: 445, column: 5)
!889 = !DILocation(line: 446, column: 14, scope: !888)
!890 = !DILocation(line: 447, column: 14, scope: !888)
!891 = !DILocation(line: 449, column: 17, scope: !892)
!892 = distinct !DILexicalBlock(scope: !870, file: !2, line: 449, column: 9)
!893 = !DILocation(line: 449, column: 10, scope: !892)
!894 = !DILocation(line: 449, column: 9, scope: !870)
!895 = !DILocation(line: 451, column: 22, scope: !896)
!896 = distinct !DILexicalBlock(scope: !892, file: !2, line: 450, column: 5)
!897 = !DILocation(line: 451, column: 14, scope: !896)
!898 = !DILocation(line: 452, column: 14, scope: !896)
!899 = !DILocation(line: 454, column: 17, scope: !900)
!900 = distinct !DILexicalBlock(scope: !870, file: !2, line: 454, column: 9)
!901 = !DILocation(line: 454, column: 10, scope: !900)
!902 = !DILocation(line: 454, column: 9, scope: !870)
!903 = !DILocation(line: 456, column: 22, scope: !904)
!904 = distinct !DILexicalBlock(scope: !900, file: !2, line: 455, column: 5)
!905 = !DILocation(line: 456, column: 14, scope: !904)
!906 = !DILocation(line: 457, column: 14, scope: !904)
!907 = !DILocation(line: 459, column: 17, scope: !908)
!908 = distinct !DILexicalBlock(scope: !870, file: !2, line: 459, column: 9)
!909 = !DILocation(line: 459, column: 10, scope: !908)
!910 = !DILocation(line: 459, column: 9, scope: !870)
!911 = !DILocation(line: 461, column: 22, scope: !912)
!912 = distinct !DILexicalBlock(scope: !908, file: !2, line: 460, column: 5)
!913 = !DILocation(line: 461, column: 14, scope: !912)
!914 = !DILocation(line: 462, column: 14, scope: !912)
!915 = !DILocation(line: 464, column: 17, scope: !916)
!916 = distinct !DILexicalBlock(scope: !870, file: !2, line: 464, column: 9)
!917 = !DILocation(line: 464, column: 10, scope: !916)
!918 = !DILocation(line: 464, column: 9, scope: !870)
!919 = !DILocation(line: 466, column: 22, scope: !920)
!920 = distinct !DILexicalBlock(scope: !916, file: !2, line: 465, column: 5)
!921 = !DILocation(line: 466, column: 14, scope: !920)
!922 = !DILocation(line: 467, column: 14, scope: !920)
!923 = !DILocation(line: 470, column: 22, scope: !870)
!924 = !DILocation(line: 470, column: 14, scope: !870)
!925 = !DILocation(line: 471, column: 1, scope: !870)
!926 = distinct !DISubprogram(name: "is_spec_symbol", scope: !2, file: !2, line: 479, type: !504, scopeLine: 481, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !24, retainedNodes: !138)
!927 = !DILocalVariable(name: "str", arg: 1, scope: !926, file: !2, line: 480, type: !146)
!928 = !DILocation(line: 480, column: 11, scope: !926)
!929 = !DILocation(line: 482, column: 17, scope: !930)
!930 = distinct !DILexicalBlock(scope: !926, file: !2, line: 482, column: 9)
!931 = !DILocation(line: 482, column: 10, scope: !930)
!932 = !DILocation(line: 482, column: 9, scope: !926)
!933 = !DILocation(line: 484, column: 9, scope: !934)
!934 = distinct !DILexicalBlock(scope: !930, file: !2, line: 483, column: 5)
!935 = !DILocation(line: 486, column: 17, scope: !936)
!936 = distinct !DILexicalBlock(scope: !926, file: !2, line: 486, column: 9)
!937 = !DILocation(line: 486, column: 10, scope: !936)
!938 = !DILocation(line: 486, column: 9, scope: !926)
!939 = !DILocation(line: 488, column: 9, scope: !940)
!940 = distinct !DILexicalBlock(scope: !936, file: !2, line: 487, column: 5)
!941 = !DILocation(line: 490, column: 17, scope: !942)
!942 = distinct !DILexicalBlock(scope: !926, file: !2, line: 490, column: 9)
!943 = !DILocation(line: 490, column: 10, scope: !942)
!944 = !DILocation(line: 490, column: 9, scope: !926)
!945 = !DILocation(line: 492, column: 9, scope: !946)
!946 = distinct !DILexicalBlock(scope: !942, file: !2, line: 491, column: 5)
!947 = !DILocation(line: 494, column: 17, scope: !948)
!948 = distinct !DILexicalBlock(scope: !926, file: !2, line: 494, column: 9)
!949 = !DILocation(line: 494, column: 10, scope: !948)
!950 = !DILocation(line: 494, column: 9, scope: !926)
!951 = !DILocation(line: 496, column: 9, scope: !952)
!952 = distinct !DILexicalBlock(scope: !948, file: !2, line: 495, column: 5)
!953 = !DILocation(line: 498, column: 17, scope: !954)
!954 = distinct !DILexicalBlock(scope: !926, file: !2, line: 498, column: 9)
!955 = !DILocation(line: 498, column: 10, scope: !954)
!956 = !DILocation(line: 498, column: 9, scope: !926)
!957 = !DILocation(line: 500, column: 9, scope: !958)
!958 = distinct !DILexicalBlock(scope: !954, file: !2, line: 499, column: 5)
!959 = !DILocation(line: 502, column: 17, scope: !960)
!960 = distinct !DILexicalBlock(scope: !926, file: !2, line: 502, column: 9)
!961 = !DILocation(line: 502, column: 10, scope: !960)
!962 = !DILocation(line: 502, column: 9, scope: !926)
!963 = !DILocation(line: 504, column: 9, scope: !964)
!964 = distinct !DILexicalBlock(scope: !960, file: !2, line: 503, column: 5)
!965 = !DILocation(line: 506, column: 17, scope: !966)
!966 = distinct !DILexicalBlock(scope: !926, file: !2, line: 506, column: 9)
!967 = !DILocation(line: 506, column: 10, scope: !966)
!968 = !DILocation(line: 506, column: 9, scope: !926)
!969 = !DILocation(line: 508, column: 9, scope: !970)
!970 = distinct !DILexicalBlock(scope: !966, file: !2, line: 507, column: 5)
!971 = !DILocation(line: 510, column: 5, scope: !926)
!972 = !DILocation(line: 511, column: 1, scope: !926)
