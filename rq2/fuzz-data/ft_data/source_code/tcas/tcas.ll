; ModuleID = 'tcas_fuzz.c'
source_filename = "tcas_fuzz.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

@Positive_RA_Alt_Thresh = global [4 x i32] zeroinitializer, align 4, !dbg !0
@Alt_Layer_Value = global i32 0, align 4, !dbg !42
@Climb_Inhibit = global i32 0, align 4, !dbg !52
@Up_Separation = global i32 0, align 4, !dbg !44
@Down_Separation = global i32 0, align 4, !dbg !46
@Cur_Vertical_Sep = global i32 0, align 4, !dbg !28
@Own_Tracked_Alt = global i32 0, align 4, !dbg !36
@Other_Tracked_Alt = global i32 0, align 4, !dbg !40
@High_Confidence = global i32 0, align 4, !dbg !31
@Own_Tracked_Alt_Rate = global i32 0, align 4, !dbg !38
@Other_Capability = global i32 0, align 4, !dbg !50
@Two_of_Three_Reports_Valid = global i32 0, align 4, !dbg !34
@Other_RAC = global i32 0, align 4, !dbg !48
@__stderrp = external global ptr, align 8
@.str = private unnamed_addr constant [31 x i8] c"Error: No filepath specified!\0A\00", align 1, !dbg !7
@.str.1 = private unnamed_addr constant [3 x i8] c"rb\00", align 1, !dbg !13
@.str.2 = private unnamed_addr constant [35 x i8] c"Error: Could not open input file!\0A\00", align 1, !dbg !18
@__stdoutp = external global ptr, align 8
@.str.3 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1, !dbg !23

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @initialize() #0 !dbg !62 {
  store i32 400, ptr @Positive_RA_Alt_Thresh, align 4, !dbg !66
  store i32 500, ptr getelementptr inbounds ([4 x i32], ptr @Positive_RA_Alt_Thresh, i64 0, i64 1), align 4, !dbg !67
  store i32 640, ptr getelementptr inbounds ([4 x i32], ptr @Positive_RA_Alt_Thresh, i64 0, i64 2), align 4, !dbg !68
  store i32 740, ptr getelementptr inbounds ([4 x i32], ptr @Positive_RA_Alt_Thresh, i64 0, i64 3), align 4, !dbg !69
  ret void, !dbg !70
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @ALIM() #0 !dbg !71 {
  %1 = load i32, ptr @Alt_Layer_Value, align 4, !dbg !74
  %2 = sext i32 %1 to i64, !dbg !75
  %3 = getelementptr inbounds [4 x i32], ptr @Positive_RA_Alt_Thresh, i64 0, i64 %2, !dbg !75
  %4 = load i32, ptr %3, align 4, !dbg !75
  ret i32 %4, !dbg !76
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @Inhibit_Biased_Climb() #0 !dbg !77 {
  %1 = load i32, ptr @Climb_Inhibit, align 4, !dbg !78
  %2 = icmp ne i32 %1, 0, !dbg !78
  br i1 %2, label %3, label %6, !dbg !78

3:                                                ; preds = %0
  %4 = load i32, ptr @Up_Separation, align 4, !dbg !79
  %5 = add nsw i32 %4, 100, !dbg !80
  br label %8, !dbg !78

6:                                                ; preds = %0
  %7 = load i32, ptr @Up_Separation, align 4, !dbg !81
  br label %8, !dbg !78

8:                                                ; preds = %6, %3
  %9 = phi i32 [ %5, %3 ], [ %7, %6 ], !dbg !78
  ret i32 %9, !dbg !82
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @Non_Crossing_Biased_Climb() #0 !dbg !83 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata ptr %1, metadata !86, metadata !DIExpression()), !dbg !87
  call void @llvm.dbg.declare(metadata ptr %2, metadata !88, metadata !DIExpression()), !dbg !89
  call void @llvm.dbg.declare(metadata ptr %3, metadata !90, metadata !DIExpression()), !dbg !91
  %4 = call i32 @Inhibit_Biased_Climb(), !dbg !92
  %5 = load i32, ptr @Down_Separation, align 4, !dbg !93
  %6 = icmp sgt i32 %4, %5, !dbg !94
  %7 = zext i1 %6 to i32, !dbg !94
  store i32 %7, ptr %1, align 4, !dbg !95
  %8 = load i32, ptr %1, align 4, !dbg !96
  %9 = icmp ne i32 %8, 0, !dbg !96
  br i1 %9, label %10, label %26, !dbg !98

10:                                               ; preds = %0
  %11 = call i32 @Own_Below_Threat(), !dbg !99
  %12 = icmp ne i32 %11, 0, !dbg !99
  br i1 %12, label %13, label %23, !dbg !101

13:                                               ; preds = %10
  %14 = call i32 @Own_Below_Threat(), !dbg !102
  %15 = icmp ne i32 %14, 0, !dbg !102
  br i1 %15, label %16, label %21, !dbg !103

16:                                               ; preds = %13
  %17 = load i32, ptr @Down_Separation, align 4, !dbg !104
  %18 = call i32 @ALIM(), !dbg !105
  %19 = icmp sge i32 %17, %18, !dbg !106
  %20 = xor i1 %19, true, !dbg !107
  br label %21

21:                                               ; preds = %16, %13
  %22 = phi i1 [ false, %13 ], [ %20, %16 ], !dbg !108
  br label %23, !dbg !101

23:                                               ; preds = %21, %10
  %24 = phi i1 [ true, %10 ], [ %22, %21 ]
  %25 = zext i1 %24 to i32, !dbg !101
  store i32 %25, ptr %3, align 4, !dbg !109
  br label %39, !dbg !110

26:                                               ; preds = %0
  %27 = call i32 @Own_Above_Threat(), !dbg !111
  %28 = icmp ne i32 %27, 0, !dbg !111
  br i1 %28, label %29, label %36, !dbg !113

29:                                               ; preds = %26
  %30 = load i32, ptr @Cur_Vertical_Sep, align 4, !dbg !114
  %31 = icmp sge i32 %30, 300, !dbg !115
  br i1 %31, label %32, label %36, !dbg !116

32:                                               ; preds = %29
  %33 = load i32, ptr @Up_Separation, align 4, !dbg !117
  %34 = call i32 @ALIM(), !dbg !118
  %35 = icmp sge i32 %33, %34, !dbg !119
  br label %36

36:                                               ; preds = %32, %29, %26
  %37 = phi i1 [ false, %29 ], [ false, %26 ], [ %35, %32 ], !dbg !120
  %38 = zext i1 %37 to i32, !dbg !116
  store i32 %38, ptr %3, align 4, !dbg !121
  br label %39

39:                                               ; preds = %36, %23
  %40 = load i32, ptr %3, align 4, !dbg !122
  ret i32 %40, !dbg !123
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @Non_Crossing_Biased_Descend() #0 !dbg !124 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata ptr %1, metadata !125, metadata !DIExpression()), !dbg !126
  call void @llvm.dbg.declare(metadata ptr %2, metadata !127, metadata !DIExpression()), !dbg !128
  call void @llvm.dbg.declare(metadata ptr %3, metadata !129, metadata !DIExpression()), !dbg !130
  %4 = call i32 @Inhibit_Biased_Climb(), !dbg !131
  %5 = load i32, ptr @Down_Separation, align 4, !dbg !132
  %6 = icmp sgt i32 %4, %5, !dbg !133
  %7 = zext i1 %6 to i32, !dbg !133
  store i32 %7, ptr %1, align 4, !dbg !134
  %8 = load i32, ptr %1, align 4, !dbg !135
  %9 = icmp ne i32 %8, 0, !dbg !135
  br i1 %9, label %10, label %23, !dbg !137

10:                                               ; preds = %0
  %11 = call i32 @Own_Below_Threat(), !dbg !138
  %12 = icmp ne i32 %11, 0, !dbg !138
  br i1 %12, label %13, label %20, !dbg !140

13:                                               ; preds = %10
  %14 = load i32, ptr @Cur_Vertical_Sep, align 4, !dbg !141
  %15 = icmp sge i32 %14, 300, !dbg !142
  br i1 %15, label %16, label %20, !dbg !143

16:                                               ; preds = %13
  %17 = load i32, ptr @Down_Separation, align 4, !dbg !144
  %18 = call i32 @ALIM(), !dbg !145
  %19 = icmp sge i32 %17, %18, !dbg !146
  br label %20

20:                                               ; preds = %16, %13, %10
  %21 = phi i1 [ false, %13 ], [ false, %10 ], [ %19, %16 ], !dbg !147
  %22 = zext i1 %21 to i32, !dbg !143
  store i32 %22, ptr %3, align 4, !dbg !148
  br label %38, !dbg !149

23:                                               ; preds = %0
  %24 = call i32 @Own_Above_Threat(), !dbg !150
  %25 = icmp ne i32 %24, 0, !dbg !150
  br i1 %25, label %26, label %35, !dbg !152

26:                                               ; preds = %23
  %27 = call i32 @Own_Above_Threat(), !dbg !153
  %28 = icmp ne i32 %27, 0, !dbg !153
  br i1 %28, label %29, label %33, !dbg !154

29:                                               ; preds = %26
  %30 = load i32, ptr @Up_Separation, align 4, !dbg !155
  %31 = call i32 @ALIM(), !dbg !156
  %32 = icmp sge i32 %30, %31, !dbg !157
  br label %33

33:                                               ; preds = %29, %26
  %34 = phi i1 [ false, %26 ], [ %32, %29 ], !dbg !158
  br label %35, !dbg !152

35:                                               ; preds = %33, %23
  %36 = phi i1 [ true, %23 ], [ %34, %33 ]
  %37 = zext i1 %36 to i32, !dbg !152
  store i32 %37, ptr %3, align 4, !dbg !159
  br label %38

38:                                               ; preds = %35, %20
  %39 = load i32, ptr %3, align 4, !dbg !160
  ret i32 %39, !dbg !161
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @Own_Below_Threat() #0 !dbg !162 {
  %1 = load i32, ptr @Own_Tracked_Alt, align 4, !dbg !163
  %2 = load i32, ptr @Other_Tracked_Alt, align 4, !dbg !164
  %3 = icmp slt i32 %1, %2, !dbg !165
  %4 = zext i1 %3 to i32, !dbg !165
  ret i32 %4, !dbg !166
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @Own_Above_Threat() #0 !dbg !167 {
  %1 = load i32, ptr @Other_Tracked_Alt, align 4, !dbg !168
  %2 = load i32, ptr @Own_Tracked_Alt, align 4, !dbg !169
  %3 = icmp slt i32 %1, %2, !dbg !170
  %4 = zext i1 %3 to i32, !dbg !170
  ret i32 %4, !dbg !171
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @alt_sep_test() #0 !dbg !172 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata ptr %1, metadata !173, metadata !DIExpression()), !dbg !174
  call void @llvm.dbg.declare(metadata ptr %2, metadata !175, metadata !DIExpression()), !dbg !176
  call void @llvm.dbg.declare(metadata ptr %3, metadata !177, metadata !DIExpression()), !dbg !178
  call void @llvm.dbg.declare(metadata ptr %4, metadata !179, metadata !DIExpression()), !dbg !180
  call void @llvm.dbg.declare(metadata ptr %5, metadata !181, metadata !DIExpression()), !dbg !182
  call void @llvm.dbg.declare(metadata ptr %6, metadata !183, metadata !DIExpression()), !dbg !184
  %7 = load i32, ptr @High_Confidence, align 4, !dbg !185
  %8 = icmp ne i32 %7, 0, !dbg !185
  br i1 %8, label %9, label %15, !dbg !186

9:                                                ; preds = %0
  %10 = load i32, ptr @Own_Tracked_Alt_Rate, align 4, !dbg !187
  %11 = icmp sle i32 %10, 600, !dbg !188
  br i1 %11, label %12, label %15, !dbg !189

12:                                               ; preds = %9
  %13 = load i32, ptr @Cur_Vertical_Sep, align 4, !dbg !190
  %14 = icmp sgt i32 %13, 600, !dbg !191
  br label %15

15:                                               ; preds = %12, %9, %0
  %16 = phi i1 [ false, %9 ], [ false, %0 ], [ %14, %12 ], !dbg !192
  %17 = zext i1 %16 to i32, !dbg !189
  store i32 %17, ptr %1, align 4, !dbg !193
  %18 = load i32, ptr @Other_Capability, align 4, !dbg !194
  %19 = icmp eq i32 %18, 1, !dbg !195
  %20 = zext i1 %19 to i32, !dbg !195
  store i32 %20, ptr %2, align 4, !dbg !196
  %21 = load i32, ptr @Two_of_Three_Reports_Valid, align 4, !dbg !197
  %22 = icmp ne i32 %21, 0, !dbg !197
  br i1 %22, label %23, label %26, !dbg !198

23:                                               ; preds = %15
  %24 = load i32, ptr @Other_RAC, align 4, !dbg !199
  %25 = icmp eq i32 %24, 0, !dbg !200
  br label %26

26:                                               ; preds = %23, %15
  %27 = phi i1 [ false, %15 ], [ %25, %23 ], !dbg !192
  %28 = zext i1 %27 to i32, !dbg !198
  store i32 %28, ptr %3, align 4, !dbg !201
  store i32 0, ptr %6, align 4, !dbg !202
  %29 = load i32, ptr %1, align 4, !dbg !203
  %30 = icmp ne i32 %29, 0, !dbg !203
  br i1 %30, label %31, label %75, !dbg !205

31:                                               ; preds = %26
  %32 = load i32, ptr %2, align 4, !dbg !206
  %33 = icmp ne i32 %32, 0, !dbg !206
  br i1 %33, label %34, label %37, !dbg !207

34:                                               ; preds = %31
  %35 = load i32, ptr %3, align 4, !dbg !208
  %36 = icmp ne i32 %35, 0, !dbg !208
  br i1 %36, label %40, label %37, !dbg !209

37:                                               ; preds = %34, %31
  %38 = load i32, ptr %2, align 4, !dbg !210
  %39 = icmp ne i32 %38, 0, !dbg !210
  br i1 %39, label %75, label %40, !dbg !211

40:                                               ; preds = %37, %34
  %41 = call i32 @Non_Crossing_Biased_Climb(), !dbg !212
  %42 = icmp ne i32 %41, 0, !dbg !212
  br i1 %42, label %43, label %46, !dbg !214

43:                                               ; preds = %40
  %44 = call i32 @Own_Below_Threat(), !dbg !215
  %45 = icmp ne i32 %44, 0, !dbg !214
  br label %46

46:                                               ; preds = %43, %40
  %47 = phi i1 [ false, %40 ], [ %45, %43 ], !dbg !216
  %48 = zext i1 %47 to i32, !dbg !214
  store i32 %48, ptr %4, align 4, !dbg !217
  %49 = call i32 @Non_Crossing_Biased_Descend(), !dbg !218
  %50 = icmp ne i32 %49, 0, !dbg !218
  br i1 %50, label %51, label %54, !dbg !219

51:                                               ; preds = %46
  %52 = call i32 @Own_Above_Threat(), !dbg !220
  %53 = icmp ne i32 %52, 0, !dbg !219
  br label %54

54:                                               ; preds = %51, %46
  %55 = phi i1 [ false, %46 ], [ %53, %51 ], !dbg !216
  %56 = zext i1 %55 to i32, !dbg !219
  store i32 %56, ptr %5, align 4, !dbg !221
  %57 = load i32, ptr %4, align 4, !dbg !222
  %58 = icmp ne i32 %57, 0, !dbg !222
  br i1 %58, label %59, label %63, !dbg !224

59:                                               ; preds = %54
  %60 = load i32, ptr %5, align 4, !dbg !225
  %61 = icmp ne i32 %60, 0, !dbg !225
  br i1 %61, label %62, label %63, !dbg !226

62:                                               ; preds = %59
  store i32 0, ptr %6, align 4, !dbg !227
  br label %74, !dbg !228

63:                                               ; preds = %59, %54
  %64 = load i32, ptr %4, align 4, !dbg !229
  %65 = icmp ne i32 %64, 0, !dbg !229
  br i1 %65, label %66, label %67, !dbg !231

66:                                               ; preds = %63
  store i32 1, ptr %6, align 4, !dbg !232
  br label %73, !dbg !233

67:                                               ; preds = %63
  %68 = load i32, ptr %5, align 4, !dbg !234
  %69 = icmp ne i32 %68, 0, !dbg !234
  br i1 %69, label %70, label %71, !dbg !236

70:                                               ; preds = %67
  store i32 2, ptr %6, align 4, !dbg !237
  br label %72, !dbg !238

71:                                               ; preds = %67
  store i32 0, ptr %6, align 4, !dbg !239
  br label %72

72:                                               ; preds = %71, %70
  br label %73

73:                                               ; preds = %72, %66
  br label %74

74:                                               ; preds = %73, %62
  br label %75, !dbg !240

75:                                               ; preds = %74, %37, %26
  %76 = load i32, ptr %6, align 4, !dbg !241
  ret i32 %76, !dbg !242
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main(i32 noundef %0, ptr noundef %1) #0 !dbg !243 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca [24 x i8], align 1
  %8 = alloca [12 x i16], align 2
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !248, metadata !DIExpression()), !dbg !249
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !250, metadata !DIExpression()), !dbg !251
  %11 = load i32, ptr %4, align 4, !dbg !252
  %12 = icmp slt i32 %11, 2, !dbg !254
  br i1 %12, label %13, label %16, !dbg !255

13:                                               ; preds = %2
  %14 = load ptr, ptr @__stderrp, align 8, !dbg !256
  %15 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %14, ptr noundef @.str), !dbg !258
  call void @exit(i32 noundef 1) #5, !dbg !259
  unreachable, !dbg !259

16:                                               ; preds = %2
  call void @llvm.dbg.declare(metadata ptr %6, metadata !260, metadata !DIExpression()), !dbg !319
  %17 = load ptr, ptr %5, align 8, !dbg !320
  %18 = getelementptr inbounds ptr, ptr %17, i64 1, !dbg !320
  %19 = load ptr, ptr %18, align 8, !dbg !320
  %20 = call ptr @"\01_fopen"(ptr noundef %19, ptr noundef @.str.1), !dbg !321
  store ptr %20, ptr %6, align 8, !dbg !319
  %21 = load ptr, ptr %6, align 8, !dbg !322
  %22 = icmp eq ptr %21, null, !dbg !324
  br i1 %22, label %23, label %26, !dbg !325

23:                                               ; preds = %16
  %24 = load ptr, ptr @__stderrp, align 8, !dbg !326
  %25 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %24, ptr noundef @.str.2), !dbg !328
  call void @exit(i32 noundef 1) #5, !dbg !329
  unreachable, !dbg !329

26:                                               ; preds = %16
  call void @llvm.dbg.declare(metadata ptr %7, metadata !330, metadata !DIExpression()), !dbg !335
  call void @llvm.memset.p0.i64(ptr align 1 %7, i8 0, i64 24, i1 false), !dbg !335
  %27 = getelementptr inbounds [24 x i8], ptr %7, i64 0, i64 0, !dbg !336
  %28 = load ptr, ptr %6, align 8, !dbg !337
  %29 = call i64 @fread(ptr noundef %27, i64 noundef 1, i64 noundef 24, ptr noundef %28), !dbg !338
  %30 = load ptr, ptr %6, align 8, !dbg !339
  %31 = call i32 @fclose(ptr noundef %30), !dbg !340
  call void @llvm.dbg.declare(metadata ptr %8, metadata !341, metadata !DIExpression()), !dbg !346
  call void @llvm.dbg.declare(metadata ptr %9, metadata !347, metadata !DIExpression()), !dbg !349
  store i32 0, ptr %9, align 4, !dbg !349
  call void @llvm.dbg.declare(metadata ptr %10, metadata !350, metadata !DIExpression()), !dbg !351
  store i32 0, ptr %10, align 4, !dbg !351
  br label %32, !dbg !352

32:                                               ; preds = %53, %26
  %33 = load i32, ptr %10, align 4, !dbg !353
  %34 = icmp slt i32 %33, 23, !dbg !355
  br i1 %34, label %35, label %58, !dbg !356

35:                                               ; preds = %32
  %36 = load i32, ptr %10, align 4, !dbg !357
  %37 = sext i32 %36 to i64, !dbg !359
  %38 = getelementptr inbounds [24 x i8], ptr %7, i64 0, i64 %37, !dbg !359
  %39 = load i8, ptr %38, align 1, !dbg !359
  %40 = zext i8 %39 to i32, !dbg !359
  %41 = shl i32 %40, 8, !dbg !360
  %42 = load i32, ptr %10, align 4, !dbg !361
  %43 = add nsw i32 %42, 1, !dbg !362
  %44 = sext i32 %43 to i64, !dbg !363
  %45 = getelementptr inbounds [24 x i8], ptr %7, i64 0, i64 %44, !dbg !363
  %46 = load i8, ptr %45, align 1, !dbg !363
  %47 = zext i8 %46 to i32, !dbg !363
  %48 = or i32 %41, %47, !dbg !364
  %49 = trunc i32 %48 to i16, !dbg !365
  %50 = load i32, ptr %9, align 4, !dbg !366
  %51 = sext i32 %50 to i64, !dbg !367
  %52 = getelementptr inbounds [12 x i16], ptr %8, i64 0, i64 %51, !dbg !367
  store i16 %49, ptr %52, align 2, !dbg !368
  br label %53, !dbg !369

53:                                               ; preds = %35
  %54 = load i32, ptr %9, align 4, !dbg !370
  %55 = add nsw i32 %54, 1, !dbg !370
  store i32 %55, ptr %9, align 4, !dbg !370
  %56 = load i32, ptr %10, align 4, !dbg !371
  %57 = add nsw i32 %56, 2, !dbg !371
  store i32 %57, ptr %10, align 4, !dbg !371
  br label %32, !dbg !372, !llvm.loop !373

58:                                               ; preds = %32
  call void @initialize(), !dbg !376
  %59 = call i32 @"\01_usleep"(i32 noundef 0), !dbg !377
  %60 = getelementptr inbounds [12 x i16], ptr %8, i64 0, i64 0, !dbg !378
  %61 = load i16, ptr %60, align 2, !dbg !378
  %62 = sext i16 %61 to i32, !dbg !378
  store i32 %62, ptr @Cur_Vertical_Sep, align 4, !dbg !379
  %63 = getelementptr inbounds [12 x i16], ptr %8, i64 0, i64 1, !dbg !380
  %64 = load i16, ptr %63, align 2, !dbg !380
  %65 = sext i16 %64 to i32, !dbg !380
  store i32 %65, ptr @High_Confidence, align 4, !dbg !381
  %66 = getelementptr inbounds [12 x i16], ptr %8, i64 0, i64 2, !dbg !382
  %67 = load i16, ptr %66, align 2, !dbg !382
  %68 = sext i16 %67 to i32, !dbg !382
  store i32 %68, ptr @Two_of_Three_Reports_Valid, align 4, !dbg !383
  %69 = getelementptr inbounds [12 x i16], ptr %8, i64 0, i64 3, !dbg !384
  %70 = load i16, ptr %69, align 2, !dbg !384
  %71 = sext i16 %70 to i32, !dbg !384
  store i32 %71, ptr @Own_Tracked_Alt, align 4, !dbg !385
  %72 = getelementptr inbounds [12 x i16], ptr %8, i64 0, i64 4, !dbg !386
  %73 = load i16, ptr %72, align 2, !dbg !386
  %74 = sext i16 %73 to i32, !dbg !386
  store i32 %74, ptr @Own_Tracked_Alt_Rate, align 4, !dbg !387
  %75 = getelementptr inbounds [12 x i16], ptr %8, i64 0, i64 5, !dbg !388
  %76 = load i16, ptr %75, align 2, !dbg !388
  %77 = sext i16 %76 to i32, !dbg !388
  store i32 %77, ptr @Other_Tracked_Alt, align 4, !dbg !389
  %78 = getelementptr inbounds [12 x i16], ptr %8, i64 0, i64 6, !dbg !390
  %79 = load i16, ptr %78, align 2, !dbg !390
  %80 = sext i16 %79 to i32, !dbg !390
  store i32 %80, ptr @Alt_Layer_Value, align 4, !dbg !391
  %81 = getelementptr inbounds [12 x i16], ptr %8, i64 0, i64 7, !dbg !392
  %82 = load i16, ptr %81, align 2, !dbg !392
  %83 = sext i16 %82 to i32, !dbg !392
  store i32 %83, ptr @Up_Separation, align 4, !dbg !393
  %84 = getelementptr inbounds [12 x i16], ptr %8, i64 0, i64 8, !dbg !394
  %85 = load i16, ptr %84, align 2, !dbg !394
  %86 = sext i16 %85 to i32, !dbg !394
  store i32 %86, ptr @Down_Separation, align 4, !dbg !395
  %87 = getelementptr inbounds [12 x i16], ptr %8, i64 0, i64 9, !dbg !396
  %88 = load i16, ptr %87, align 2, !dbg !396
  %89 = sext i16 %88 to i32, !dbg !396
  store i32 %89, ptr @Other_RAC, align 4, !dbg !397
  %90 = getelementptr inbounds [12 x i16], ptr %8, i64 0, i64 10, !dbg !398
  %91 = load i16, ptr %90, align 2, !dbg !398
  %92 = sext i16 %91 to i32, !dbg !398
  store i32 %92, ptr @Other_Capability, align 4, !dbg !399
  %93 = getelementptr inbounds [12 x i16], ptr %8, i64 0, i64 11, !dbg !400
  %94 = load i16, ptr %93, align 2, !dbg !400
  %95 = sext i16 %94 to i32, !dbg !400
  store i32 %95, ptr @Climb_Inhibit, align 4, !dbg !401
  %96 = load ptr, ptr @__stdoutp, align 8, !dbg !402
  %97 = call i32 @alt_sep_test(), !dbg !403
  %98 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %96, ptr noundef @.str.3, i32 noundef %97), !dbg !404
  call void @exit(i32 noundef 0) #5, !dbg !405
  unreachable, !dbg !405
}

declare i32 @fprintf(ptr noundef, ptr noundef, ...) #2

; Function Attrs: noreturn
declare void @exit(i32 noundef) #3

declare ptr @"\01_fopen"(ptr noundef, ptr noundef) #2

; Function Attrs: argmemonly nocallback nofree nounwind willreturn writeonly
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #4

declare i64 @fread(ptr noundef, i64 noundef, i64 noundef, ptr noundef) #2

declare i32 @fclose(ptr noundef) #2

declare i32 @"\01_usleep"(i32 noundef) #2

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #3 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #4 = { argmemonly nocallback nofree nounwind willreturn writeonly }
attributes #5 = { noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!55, !56, !57, !58, !59, !60}
!llvm.ident = !{!61}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "Positive_RA_Alt_Thresh", scope: !2, file: !3, line: 30, type: !54, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 15.0.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk", sdk: "MacOSX12.sdk")
!3 = !DIFile(filename: "tcas_fuzz.c", directory: "XXX/converter/ft_data/source_code/tcas")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !13, !18, !23, !28, !31, !34, !36, !38, !40, !42, !0, !44, !46, !48, !50, !52}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 153, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 248, elements: !11)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = !{!12}
!12 = !DISubrange(count: 31)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !3, line: 157, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 24, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 3)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 160, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 280, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 35)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !3, line: 194, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 32, elements: !26)
!26 = !{!27}
!27 = !DISubrange(count: 4)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "Cur_Vertical_Sep", scope: !2, file: !3, line: 21, type: !30, isLocal: false, isDefinition: true)
!30 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "High_Confidence", scope: !2, file: !3, line: 22, type: !33, isLocal: false, isDefinition: true)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !3, line: 19, baseType: !30)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "Two_of_Three_Reports_Valid", scope: !2, file: !3, line: 23, type: !33, isLocal: false, isDefinition: true)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "Own_Tracked_Alt", scope: !2, file: !3, line: 25, type: !30, isLocal: false, isDefinition: true)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "Own_Tracked_Alt_Rate", scope: !2, file: !3, line: 26, type: !30, isLocal: false, isDefinition: true)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "Other_Tracked_Alt", scope: !2, file: !3, line: 27, type: !30, isLocal: false, isDefinition: true)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "Alt_Layer_Value", scope: !2, file: !3, line: 29, type: !30, isLocal: false, isDefinition: true)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "Up_Separation", scope: !2, file: !3, line: 32, type: !30, isLocal: false, isDefinition: true)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "Down_Separation", scope: !2, file: !3, line: 33, type: !30, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "Other_RAC", scope: !2, file: !3, line: 36, type: !30, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "Other_Capability", scope: !2, file: !3, line: 41, type: !30, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "Climb_Inhibit", scope: !2, file: !3, line: 45, type: !30, isLocal: false, isDefinition: true)
!54 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 128, elements: !26)
!55 = !{i32 7, !"Dwarf Version", i32 4}
!56 = !{i32 2, !"Debug Info Version", i32 3}
!57 = !{i32 1, !"wchar_size", i32 4}
!58 = !{i32 7, !"PIC Level", i32 2}
!59 = !{i32 7, !"uwtable", i32 2}
!60 = !{i32 7, !"frame-pointer", i32 1}
!61 = !{!"Homebrew clang version 15.0.3"}
!62 = distinct !DISubprogram(name: "initialize", scope: !3, file: !3, line: 51, type: !63, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!63 = !DISubroutineType(types: !64)
!64 = !{null}
!65 = !{}
!66 = !DILocation(line: 53, column: 31, scope: !62)
!67 = !DILocation(line: 54, column: 31, scope: !62)
!68 = !DILocation(line: 55, column: 31, scope: !62)
!69 = !DILocation(line: 56, column: 31, scope: !62)
!70 = !DILocation(line: 57, column: 1, scope: !62)
!71 = distinct !DISubprogram(name: "ALIM", scope: !3, file: !3, line: 59, type: !72, scopeLine: 60, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!72 = !DISubroutineType(types: !73)
!73 = !{!30}
!74 = !DILocation(line: 61, column: 35, scope: !71)
!75 = !DILocation(line: 61, column: 12, scope: !71)
!76 = !DILocation(line: 61, column: 5, scope: !71)
!77 = distinct !DISubprogram(name: "Inhibit_Biased_Climb", scope: !3, file: !3, line: 64, type: !72, scopeLine: 65, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!78 = !DILocation(line: 66, column: 13, scope: !77)
!79 = !DILocation(line: 66, column: 29, scope: !77)
!80 = !DILocation(line: 66, column: 43, scope: !77)
!81 = !DILocation(line: 66, column: 56, scope: !77)
!82 = !DILocation(line: 66, column: 5, scope: !77)
!83 = distinct !DISubprogram(name: "Non_Crossing_Biased_Climb", scope: !3, file: !3, line: 69, type: !84, scopeLine: 70, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!84 = !DISubroutineType(types: !85)
!85 = !{!33}
!86 = !DILocalVariable(name: "upward_preferred", scope: !83, file: !3, line: 71, type: !30)
!87 = !DILocation(line: 71, column: 9, scope: !83)
!88 = !DILocalVariable(name: "upward_crossing_situation", scope: !83, file: !3, line: 72, type: !30)
!89 = !DILocation(line: 72, column: 9, scope: !83)
!90 = !DILocalVariable(name: "result", scope: !83, file: !3, line: 73, type: !33)
!91 = !DILocation(line: 73, column: 10, scope: !83)
!92 = !DILocation(line: 75, column: 24, scope: !83)
!93 = !DILocation(line: 75, column: 49, scope: !83)
!94 = !DILocation(line: 75, column: 47, scope: !83)
!95 = !DILocation(line: 75, column: 22, scope: !83)
!96 = !DILocation(line: 76, column: 9, scope: !97)
!97 = distinct !DILexicalBlock(scope: !83, file: !3, line: 76, column: 9)
!98 = !DILocation(line: 76, column: 9, scope: !83)
!99 = !DILocation(line: 78, column: 20, scope: !100)
!100 = distinct !DILexicalBlock(scope: !97, file: !3, line: 77, column: 5)
!101 = !DILocation(line: 78, column: 40, scope: !100)
!102 = !DILocation(line: 78, column: 45, scope: !100)
!103 = !DILocation(line: 78, column: 65, scope: !100)
!104 = !DILocation(line: 78, column: 71, scope: !100)
!105 = !DILocation(line: 78, column: 90, scope: !100)
!106 = !DILocation(line: 78, column: 87, scope: !100)
!107 = !DILocation(line: 78, column: 69, scope: !100)
!108 = !DILocation(line: 0, scope: !100)
!109 = !DILocation(line: 78, column: 16, scope: !100)
!110 = !DILocation(line: 79, column: 5, scope: !100)
!111 = !DILocation(line: 82, column: 18, scope: !112)
!112 = distinct !DILexicalBlock(scope: !97, file: !3, line: 81, column: 5)
!113 = !DILocation(line: 82, column: 37, scope: !112)
!114 = !DILocation(line: 82, column: 41, scope: !112)
!115 = !DILocation(line: 82, column: 58, scope: !112)
!116 = !DILocation(line: 82, column: 69, scope: !112)
!117 = !DILocation(line: 82, column: 73, scope: !112)
!118 = !DILocation(line: 82, column: 90, scope: !112)
!119 = !DILocation(line: 82, column: 87, scope: !112)
!120 = !DILocation(line: 0, scope: !112)
!121 = !DILocation(line: 82, column: 16, scope: !112)
!122 = !DILocation(line: 84, column: 12, scope: !83)
!123 = !DILocation(line: 84, column: 5, scope: !83)
!124 = distinct !DISubprogram(name: "Non_Crossing_Biased_Descend", scope: !3, file: !3, line: 87, type: !84, scopeLine: 88, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!125 = !DILocalVariable(name: "upward_preferred", scope: !124, file: !3, line: 89, type: !30)
!126 = !DILocation(line: 89, column: 9, scope: !124)
!127 = !DILocalVariable(name: "upward_crossing_situation", scope: !124, file: !3, line: 90, type: !30)
!128 = !DILocation(line: 90, column: 9, scope: !124)
!129 = !DILocalVariable(name: "result", scope: !124, file: !3, line: 91, type: !33)
!130 = !DILocation(line: 91, column: 10, scope: !124)
!131 = !DILocation(line: 93, column: 24, scope: !124)
!132 = !DILocation(line: 93, column: 49, scope: !124)
!133 = !DILocation(line: 93, column: 47, scope: !124)
!134 = !DILocation(line: 93, column: 22, scope: !124)
!135 = !DILocation(line: 94, column: 9, scope: !136)
!136 = distinct !DILexicalBlock(scope: !124, file: !3, line: 94, column: 9)
!137 = !DILocation(line: 94, column: 9, scope: !124)
!138 = !DILocation(line: 96, column: 18, scope: !139)
!139 = distinct !DILexicalBlock(scope: !136, file: !3, line: 95, column: 5)
!140 = !DILocation(line: 96, column: 37, scope: !139)
!141 = !DILocation(line: 96, column: 41, scope: !139)
!142 = !DILocation(line: 96, column: 58, scope: !139)
!143 = !DILocation(line: 96, column: 69, scope: !139)
!144 = !DILocation(line: 96, column: 73, scope: !139)
!145 = !DILocation(line: 96, column: 92, scope: !139)
!146 = !DILocation(line: 96, column: 89, scope: !139)
!147 = !DILocation(line: 0, scope: !139)
!148 = !DILocation(line: 96, column: 16, scope: !139)
!149 = !DILocation(line: 97, column: 5, scope: !139)
!150 = !DILocation(line: 100, column: 20, scope: !151)
!151 = distinct !DILexicalBlock(scope: !136, file: !3, line: 99, column: 5)
!152 = !DILocation(line: 100, column: 40, scope: !151)
!153 = !DILocation(line: 100, column: 45, scope: !151)
!154 = !DILocation(line: 100, column: 65, scope: !151)
!155 = !DILocation(line: 100, column: 69, scope: !151)
!156 = !DILocation(line: 100, column: 86, scope: !151)
!157 = !DILocation(line: 100, column: 83, scope: !151)
!158 = !DILocation(line: 0, scope: !151)
!159 = !DILocation(line: 100, column: 16, scope: !151)
!160 = !DILocation(line: 102, column: 12, scope: !124)
!161 = !DILocation(line: 102, column: 5, scope: !124)
!162 = distinct !DISubprogram(name: "Own_Below_Threat", scope: !3, file: !3, line: 105, type: !84, scopeLine: 106, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!163 = !DILocation(line: 107, column: 13, scope: !162)
!164 = !DILocation(line: 107, column: 31, scope: !162)
!165 = !DILocation(line: 107, column: 29, scope: !162)
!166 = !DILocation(line: 107, column: 5, scope: !162)
!167 = distinct !DISubprogram(name: "Own_Above_Threat", scope: !3, file: !3, line: 110, type: !84, scopeLine: 111, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!168 = !DILocation(line: 112, column: 13, scope: !167)
!169 = !DILocation(line: 112, column: 33, scope: !167)
!170 = !DILocation(line: 112, column: 31, scope: !167)
!171 = !DILocation(line: 112, column: 5, scope: !167)
!172 = distinct !DISubprogram(name: "alt_sep_test", scope: !3, file: !3, line: 115, type: !72, scopeLine: 116, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!173 = !DILocalVariable(name: "enabled", scope: !172, file: !3, line: 117, type: !33)
!174 = !DILocation(line: 117, column: 10, scope: !172)
!175 = !DILocalVariable(name: "tcas_equipped", scope: !172, file: !3, line: 117, type: !33)
!176 = !DILocation(line: 117, column: 19, scope: !172)
!177 = !DILocalVariable(name: "intent_not_known", scope: !172, file: !3, line: 117, type: !33)
!178 = !DILocation(line: 117, column: 34, scope: !172)
!179 = !DILocalVariable(name: "need_upward_RA", scope: !172, file: !3, line: 118, type: !33)
!180 = !DILocation(line: 118, column: 10, scope: !172)
!181 = !DILocalVariable(name: "need_downward_RA", scope: !172, file: !3, line: 118, type: !33)
!182 = !DILocation(line: 118, column: 26, scope: !172)
!183 = !DILocalVariable(name: "alt_sep", scope: !172, file: !3, line: 119, type: !30)
!184 = !DILocation(line: 119, column: 9, scope: !172)
!185 = !DILocation(line: 121, column: 15, scope: !172)
!186 = !DILocation(line: 121, column: 31, scope: !172)
!187 = !DILocation(line: 121, column: 35, scope: !172)
!188 = !DILocation(line: 121, column: 56, scope: !172)
!189 = !DILocation(line: 121, column: 65, scope: !172)
!190 = !DILocation(line: 121, column: 69, scope: !172)
!191 = !DILocation(line: 121, column: 86, scope: !172)
!192 = !DILocation(line: 0, scope: !172)
!193 = !DILocation(line: 121, column: 13, scope: !172)
!194 = !DILocation(line: 122, column: 21, scope: !172)
!195 = !DILocation(line: 122, column: 38, scope: !172)
!196 = !DILocation(line: 122, column: 19, scope: !172)
!197 = !DILocation(line: 123, column: 24, scope: !172)
!198 = !DILocation(line: 123, column: 51, scope: !172)
!199 = !DILocation(line: 123, column: 54, scope: !172)
!200 = !DILocation(line: 123, column: 64, scope: !172)
!201 = !DILocation(line: 123, column: 22, scope: !172)
!202 = !DILocation(line: 125, column: 13, scope: !172)
!203 = !DILocation(line: 127, column: 9, scope: !204)
!204 = distinct !DILexicalBlock(scope: !172, file: !3, line: 127, column: 9)
!205 = !DILocation(line: 127, column: 17, scope: !204)
!206 = !DILocation(line: 127, column: 22, scope: !204)
!207 = !DILocation(line: 127, column: 36, scope: !204)
!208 = !DILocation(line: 127, column: 39, scope: !204)
!209 = !DILocation(line: 127, column: 57, scope: !204)
!210 = !DILocation(line: 127, column: 61, scope: !204)
!211 = !DILocation(line: 127, column: 9, scope: !172)
!212 = !DILocation(line: 129, column: 26, scope: !213)
!213 = distinct !DILexicalBlock(scope: !204, file: !3, line: 128, column: 5)
!214 = !DILocation(line: 129, column: 54, scope: !213)
!215 = !DILocation(line: 129, column: 57, scope: !213)
!216 = !DILocation(line: 0, scope: !213)
!217 = !DILocation(line: 129, column: 24, scope: !213)
!218 = !DILocation(line: 130, column: 28, scope: !213)
!219 = !DILocation(line: 130, column: 58, scope: !213)
!220 = !DILocation(line: 130, column: 61, scope: !213)
!221 = !DILocation(line: 130, column: 26, scope: !213)
!222 = !DILocation(line: 131, column: 13, scope: !223)
!223 = distinct !DILexicalBlock(scope: !213, file: !3, line: 131, column: 13)
!224 = !DILocation(line: 131, column: 28, scope: !223)
!225 = !DILocation(line: 131, column: 31, scope: !223)
!226 = !DILocation(line: 131, column: 13, scope: !213)
!227 = !DILocation(line: 135, column: 21, scope: !223)
!228 = !DILocation(line: 135, column: 13, scope: !223)
!229 = !DILocation(line: 136, column: 18, scope: !230)
!230 = distinct !DILexicalBlock(scope: !223, file: !3, line: 136, column: 18)
!231 = !DILocation(line: 136, column: 18, scope: !223)
!232 = !DILocation(line: 137, column: 21, scope: !230)
!233 = !DILocation(line: 137, column: 13, scope: !230)
!234 = !DILocation(line: 138, column: 18, scope: !235)
!235 = distinct !DILexicalBlock(scope: !230, file: !3, line: 138, column: 18)
!236 = !DILocation(line: 138, column: 18, scope: !230)
!237 = !DILocation(line: 139, column: 21, scope: !235)
!238 = !DILocation(line: 139, column: 13, scope: !235)
!239 = !DILocation(line: 141, column: 21, scope: !235)
!240 = !DILocation(line: 142, column: 5, scope: !213)
!241 = !DILocation(line: 144, column: 12, scope: !172)
!242 = !DILocation(line: 144, column: 5, scope: !172)
!243 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 147, type: !244, scopeLine: 149, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!244 = !DISubroutineType(types: !245)
!245 = !{!30, !30, !246}
!246 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !247, size: 64)
!247 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!248 = !DILocalVariable(name: "argc", arg: 1, scope: !243, file: !3, line: 147, type: !30)
!249 = !DILocation(line: 147, column: 22, scope: !243)
!250 = !DILocalVariable(name: "argv", arg: 2, scope: !243, file: !3, line: 148, type: !246)
!251 = !DILocation(line: 148, column: 7, scope: !243)
!252 = !DILocation(line: 151, column: 9, scope: !253)
!253 = distinct !DILexicalBlock(scope: !243, file: !3, line: 151, column: 9)
!254 = !DILocation(line: 151, column: 14, scope: !253)
!255 = !DILocation(line: 151, column: 9, scope: !243)
!256 = !DILocation(line: 153, column: 17, scope: !257)
!257 = distinct !DILexicalBlock(scope: !253, file: !3, line: 152, column: 5)
!258 = !DILocation(line: 153, column: 9, scope: !257)
!259 = !DILocation(line: 154, column: 9, scope: !257)
!260 = !DILocalVariable(name: "file", scope: !243, file: !3, line: 157, type: !261)
!261 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !262, size: 64)
!262 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !263, line: 157, baseType: !264)
!263 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk/usr/include/_stdio.h", directory: "")
!264 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sFILE", file: !263, line: 126, size: 1216, elements: !265)
!265 = !{!266, !269, !270, !271, !273, !274, !279, !280, !281, !285, !289, !299, !305, !306, !309, !310, !312, !316, !317, !318}
!266 = !DIDerivedType(tag: DW_TAG_member, name: "_p", scope: !264, file: !263, line: 127, baseType: !267, size: 64)
!267 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !268, size: 64)
!268 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!269 = !DIDerivedType(tag: DW_TAG_member, name: "_r", scope: !264, file: !263, line: 128, baseType: !30, size: 32, offset: 64)
!270 = !DIDerivedType(tag: DW_TAG_member, name: "_w", scope: !264, file: !263, line: 129, baseType: !30, size: 32, offset: 96)
!271 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !264, file: !263, line: 130, baseType: !272, size: 16, offset: 128)
!272 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!273 = !DIDerivedType(tag: DW_TAG_member, name: "_file", scope: !264, file: !263, line: 131, baseType: !272, size: 16, offset: 144)
!274 = !DIDerivedType(tag: DW_TAG_member, name: "_bf", scope: !264, file: !263, line: 132, baseType: !275, size: 128, offset: 192)
!275 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sbuf", file: !263, line: 92, size: 128, elements: !276)
!276 = !{!277, !278}
!277 = !DIDerivedType(tag: DW_TAG_member, name: "_base", scope: !275, file: !263, line: 93, baseType: !267, size: 64)
!278 = !DIDerivedType(tag: DW_TAG_member, name: "_size", scope: !275, file: !263, line: 94, baseType: !30, size: 32, offset: 64)
!279 = !DIDerivedType(tag: DW_TAG_member, name: "_lbfsize", scope: !264, file: !263, line: 133, baseType: !30, size: 32, offset: 320)
!280 = !DIDerivedType(tag: DW_TAG_member, name: "_cookie", scope: !264, file: !263, line: 136, baseType: !5, size: 64, offset: 384)
!281 = !DIDerivedType(tag: DW_TAG_member, name: "_close", scope: !264, file: !263, line: 137, baseType: !282, size: 64, offset: 448)
!282 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !283, size: 64)
!283 = !DISubroutineType(types: !284)
!284 = !{!30, !5}
!285 = !DIDerivedType(tag: DW_TAG_member, name: "_read", scope: !264, file: !263, line: 138, baseType: !286, size: 64, offset: 512)
!286 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !287, size: 64)
!287 = !DISubroutineType(types: !288)
!288 = !{!30, !5, !247, !30}
!289 = !DIDerivedType(tag: DW_TAG_member, name: "_seek", scope: !264, file: !263, line: 139, baseType: !290, size: 64, offset: 576)
!290 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !291, size: 64)
!291 = !DISubroutineType(types: !292)
!292 = !{!293, !5, !293, !30}
!293 = !DIDerivedType(tag: DW_TAG_typedef, name: "fpos_t", file: !263, line: 81, baseType: !294)
!294 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_off_t", file: !295, line: 71, baseType: !296)
!295 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk/usr/include/sys/_types.h", directory: "")
!296 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !297, line: 24, baseType: !298)
!297 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk/usr/include/arm/_types.h", directory: "")
!298 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!299 = !DIDerivedType(tag: DW_TAG_member, name: "_write", scope: !264, file: !263, line: 140, baseType: !300, size: 64, offset: 640)
!300 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !301, size: 64)
!301 = !DISubroutineType(types: !302)
!302 = !{!30, !5, !303, !30}
!303 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !304, size: 64)
!304 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!305 = !DIDerivedType(tag: DW_TAG_member, name: "_ub", scope: !264, file: !263, line: 143, baseType: !275, size: 128, offset: 704)
!306 = !DIDerivedType(tag: DW_TAG_member, name: "_extra", scope: !264, file: !263, line: 144, baseType: !307, size: 64, offset: 832)
!307 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !308, size: 64)
!308 = !DICompositeType(tag: DW_TAG_structure_type, name: "__sFILEX", file: !263, line: 98, flags: DIFlagFwdDecl)
!309 = !DIDerivedType(tag: DW_TAG_member, name: "_ur", scope: !264, file: !263, line: 145, baseType: !30, size: 32, offset: 896)
!310 = !DIDerivedType(tag: DW_TAG_member, name: "_ubuf", scope: !264, file: !263, line: 148, baseType: !311, size: 24, offset: 928)
!311 = !DICompositeType(tag: DW_TAG_array_type, baseType: !268, size: 24, elements: !16)
!312 = !DIDerivedType(tag: DW_TAG_member, name: "_nbuf", scope: !264, file: !263, line: 149, baseType: !313, size: 8, offset: 952)
!313 = !DICompositeType(tag: DW_TAG_array_type, baseType: !268, size: 8, elements: !314)
!314 = !{!315}
!315 = !DISubrange(count: 1)
!316 = !DIDerivedType(tag: DW_TAG_member, name: "_lb", scope: !264, file: !263, line: 152, baseType: !275, size: 128, offset: 960)
!317 = !DIDerivedType(tag: DW_TAG_member, name: "_blksize", scope: !264, file: !263, line: 155, baseType: !30, size: 32, offset: 1088)
!318 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !264, file: !263, line: 156, baseType: !293, size: 64, offset: 1152)
!319 = !DILocation(line: 157, column: 11, scope: !243)
!320 = !DILocation(line: 157, column: 24, scope: !243)
!321 = !DILocation(line: 157, column: 18, scope: !243)
!322 = !DILocation(line: 159, column: 9, scope: !323)
!323 = distinct !DILexicalBlock(scope: !243, file: !3, line: 159, column: 9)
!324 = !DILocation(line: 159, column: 14, scope: !323)
!325 = !DILocation(line: 159, column: 9, scope: !243)
!326 = !DILocation(line: 160, column: 17, scope: !327)
!327 = distinct !DILexicalBlock(scope: !323, file: !3, line: 159, column: 23)
!328 = !DILocation(line: 160, column: 9, scope: !327)
!329 = !DILocation(line: 161, column: 9, scope: !327)
!330 = !DILocalVariable(name: "buffer", scope: !243, file: !3, line: 164, type: !331)
!331 = !DICompositeType(tag: DW_TAG_array_type, baseType: !332, size: 192, elements: !333)
!332 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !297, line: 19, baseType: !268)
!333 = !{!334}
!334 = !DISubrange(count: 24)
!335 = !DILocation(line: 164, column: 15, scope: !243)
!336 = !DILocation(line: 166, column: 11, scope: !243)
!337 = !DILocation(line: 166, column: 26, scope: !243)
!338 = !DILocation(line: 166, column: 5, scope: !243)
!339 = !DILocation(line: 168, column: 12, scope: !243)
!340 = !DILocation(line: 168, column: 5, scope: !243)
!341 = !DILocalVariable(name: "inputs", scope: !243, file: !3, line: 170, type: !342)
!342 = !DICompositeType(tag: DW_TAG_array_type, baseType: !343, size: 192, elements: !344)
!343 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !297, line: 20, baseType: !272)
!344 = !{!345}
!345 = !DISubrange(count: 12)
!346 = !DILocation(line: 170, column: 15, scope: !243)
!347 = !DILocalVariable(name: "i", scope: !348, file: !3, line: 172, type: !30)
!348 = distinct !DILexicalBlock(scope: !243, file: !3, line: 172, column: 5)
!349 = !DILocation(line: 172, column: 14, scope: !348)
!350 = !DILocalVariable(name: "j", scope: !348, file: !3, line: 172, type: !30)
!351 = !DILocation(line: 172, column: 21, scope: !348)
!352 = !DILocation(line: 172, column: 10, scope: !348)
!353 = !DILocation(line: 172, column: 28, scope: !354)
!354 = distinct !DILexicalBlock(scope: !348, file: !3, line: 172, column: 5)
!355 = !DILocation(line: 172, column: 30, scope: !354)
!356 = !DILocation(line: 172, column: 5, scope: !348)
!357 = !DILocation(line: 174, column: 29, scope: !358)
!358 = distinct !DILexicalBlock(scope: !354, file: !3, line: 172, column: 47)
!359 = !DILocation(line: 174, column: 22, scope: !358)
!360 = !DILocation(line: 174, column: 32, scope: !358)
!361 = !DILocation(line: 174, column: 47, scope: !358)
!362 = !DILocation(line: 174, column: 48, scope: !358)
!363 = !DILocation(line: 174, column: 40, scope: !358)
!364 = !DILocation(line: 174, column: 38, scope: !358)
!365 = !DILocation(line: 174, column: 21, scope: !358)
!366 = !DILocation(line: 174, column: 16, scope: !358)
!367 = !DILocation(line: 174, column: 9, scope: !358)
!368 = !DILocation(line: 174, column: 19, scope: !358)
!369 = !DILocation(line: 175, column: 5, scope: !358)
!370 = !DILocation(line: 172, column: 37, scope: !354)
!371 = !DILocation(line: 172, column: 42, scope: !354)
!372 = !DILocation(line: 172, column: 5, scope: !354)
!373 = distinct !{!373, !356, !374, !375}
!374 = !DILocation(line: 175, column: 5, scope: !348)
!375 = !{!"llvm.loop.mustprogress"}
!376 = !DILocation(line: 178, column: 5, scope: !243)
!377 = !DILocation(line: 179, column: 5, scope: !243)
!378 = !DILocation(line: 181, column: 24, scope: !243)
!379 = !DILocation(line: 181, column: 22, scope: !243)
!380 = !DILocation(line: 182, column: 23, scope: !243)
!381 = !DILocation(line: 182, column: 21, scope: !243)
!382 = !DILocation(line: 183, column: 34, scope: !243)
!383 = !DILocation(line: 183, column: 32, scope: !243)
!384 = !DILocation(line: 184, column: 23, scope: !243)
!385 = !DILocation(line: 184, column: 21, scope: !243)
!386 = !DILocation(line: 185, column: 28, scope: !243)
!387 = !DILocation(line: 185, column: 26, scope: !243)
!388 = !DILocation(line: 186, column: 25, scope: !243)
!389 = !DILocation(line: 186, column: 23, scope: !243)
!390 = !DILocation(line: 187, column: 23, scope: !243)
!391 = !DILocation(line: 187, column: 21, scope: !243)
!392 = !DILocation(line: 188, column: 21, scope: !243)
!393 = !DILocation(line: 188, column: 19, scope: !243)
!394 = !DILocation(line: 189, column: 23, scope: !243)
!395 = !DILocation(line: 189, column: 21, scope: !243)
!396 = !DILocation(line: 190, column: 17, scope: !243)
!397 = !DILocation(line: 190, column: 15, scope: !243)
!398 = !DILocation(line: 191, column: 24, scope: !243)
!399 = !DILocation(line: 191, column: 22, scope: !243)
!400 = !DILocation(line: 192, column: 21, scope: !243)
!401 = !DILocation(line: 192, column: 19, scope: !243)
!402 = !DILocation(line: 194, column: 13, scope: !243)
!403 = !DILocation(line: 194, column: 29, scope: !243)
!404 = !DILocation(line: 194, column: 5, scope: !243)
!405 = !DILocation(line: 195, column: 5, scope: !243)
