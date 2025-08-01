; ModuleID = 'totinfo_fuzz.c'
source_filename = "totinfo_fuzz.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

@line = internal global [256 x i8] zeroinitializer, align 1, !dbg !0
@__stdinp = external global ptr, align 8
@__stdoutp = external global ptr, align 8
@.str = private unnamed_addr constant [7 x i8] c"%d %d\0A\00", align 1, !dbg !12
@r = internal global i32 0, align 4, !dbg !83
@c = internal global i32 0, align 4, !dbg !85
@.str.1 = private unnamed_addr constant [29 x i8] c"* invalid row/column line *\0A\00", align 1, !dbg !18
@.str.2 = private unnamed_addr constant [21 x i8] c"* table too large *\0A\00", align 1, !dbg !23
@.str.3 = private unnamed_addr constant [5 x i8] c" %ld\00", align 1, !dbg !28
@f = internal global [1000 x i64] zeroinitializer, align 8, !dbg !77
@.str.4 = private unnamed_addr constant [18 x i8] c"* EOF in table *\0A\00", align 1, !dbg !33
@.str.5 = private unnamed_addr constant [34 x i8] c"2info = %5.2f\09df = %2d\09q = %7.4f\0A\00", align 1, !dbg !38
@.str.6 = private unnamed_addr constant [15 x i8] c"out of memory\0A\00", align 1, !dbg !43
@.str.7 = private unnamed_addr constant [17 x i8] c"table too small\0A\00", align 1, !dbg !48
@.str.8 = private unnamed_addr constant [15 x i8] c"negative freq\0A\00", align 1, !dbg !53
@.str.9 = private unnamed_addr constant [17 x i8] c"table all zeros\0A\00", align 1, !dbg !55
@.str.10 = private unnamed_addr constant [37 x i8] c"\0A*** no information accumulated ***\0A\00", align 1, !dbg !57
@.str.11 = private unnamed_addr constant [41 x i8] c"\0Atotal 2info = %5.2f\09df = %2d\09q = %7.4f\0A\00", align 1, !dbg !62
@LGamma.cof = internal constant [6 x double] [double 0x40530B869F76A853, double 0xC055A0572B14D6A7, double 0x4038039BF0E1D4F2, double 0xBFF3B5347EA692EB, double 0x3F53CD26ED054DB1, double 0xBED67F5B9D652131], align 8, !dbg !67

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main(i32 noundef %0, ptr noundef %1) #0 !dbg !97 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca double, align 8
  %10 = alloca i32, align 4
  %11 = alloca double, align 8
  %12 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !102, metadata !DIExpression()), !dbg !103
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !104, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.declare(metadata ptr %6, metadata !106, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.declare(metadata ptr %7, metadata !108, metadata !DIExpression()), !dbg !109
  call void @llvm.dbg.declare(metadata ptr %8, metadata !110, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.declare(metadata ptr %9, metadata !112, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.declare(metadata ptr %10, metadata !114, metadata !DIExpression()), !dbg !115
  call void @llvm.dbg.declare(metadata ptr %11, metadata !116, metadata !DIExpression()), !dbg !117
  store double 0.000000e+00, ptr %11, align 8, !dbg !117
  call void @llvm.dbg.declare(metadata ptr %12, metadata !118, metadata !DIExpression()), !dbg !119
  store i32 0, ptr %12, align 4, !dbg !120
  br label %13, !dbg !121

13:                                               ; preds = %134, %47, %41, %2
  %14 = load ptr, ptr @__stdinp, align 8, !dbg !122
  %15 = call ptr @fgets(ptr noundef @line, i32 noundef 256, ptr noundef %14), !dbg !123
  %16 = icmp ne ptr %15, null, !dbg !124
  br i1 %16, label %17, label %135, !dbg !121

17:                                               ; preds = %13
  %18 = call i32 @"\01_usleep"(i32 noundef 10000), !dbg !125
  store ptr @line, ptr %6, align 8, !dbg !127
  br label %19, !dbg !129

19:                                               ; preds = %33, %17
  %20 = load ptr, ptr %6, align 8, !dbg !130
  %21 = load i8, ptr %20, align 1, !dbg !132
  %22 = sext i8 %21 to i32, !dbg !132
  %23 = icmp ne i32 %22, 0, !dbg !133
  br i1 %23, label %24, label %30, !dbg !134

24:                                               ; preds = %19
  %25 = load ptr, ptr %6, align 8, !dbg !135
  %26 = load i8, ptr %25, align 1, !dbg !136
  %27 = sext i8 %26 to i32, !dbg !137
  %28 = call i32 @isspace(i32 noundef %27) #5, !dbg !138
  %29 = icmp ne i32 %28, 0, !dbg !134
  br label %30

30:                                               ; preds = %24, %19
  %31 = phi i1 [ false, %19 ], [ %29, %24 ], !dbg !139
  br i1 %31, label %32, label %36, !dbg !140

32:                                               ; preds = %30
  br label %33, !dbg !140

33:                                               ; preds = %32
  %34 = load ptr, ptr %6, align 8, !dbg !141
  %35 = getelementptr inbounds i8, ptr %34, i32 1, !dbg !141
  store ptr %35, ptr %6, align 8, !dbg !141
  br label %19, !dbg !142, !llvm.loop !143

36:                                               ; preds = %30
  %37 = load ptr, ptr %6, align 8, !dbg !146
  %38 = load i8, ptr %37, align 1, !dbg !148
  %39 = sext i8 %38 to i32, !dbg !148
  %40 = icmp eq i32 %39, 0, !dbg !149
  br i1 %40, label %41, label %42, !dbg !150

41:                                               ; preds = %36
  br label %13, !dbg !151, !llvm.loop !152

42:                                               ; preds = %36
  %43 = load ptr, ptr %6, align 8, !dbg !154
  %44 = load i8, ptr %43, align 1, !dbg !156
  %45 = sext i8 %44 to i32, !dbg !156
  %46 = icmp eq i32 %45, 35, !dbg !157
  br i1 %46, label %47, label %50, !dbg !158

47:                                               ; preds = %42
  %48 = load ptr, ptr @__stdoutp, align 8, !dbg !159
  %49 = call i32 @"\01_fputs"(ptr noundef @line, ptr noundef %48), !dbg !161
  br label %13, !dbg !162, !llvm.loop !152

50:                                               ; preds = %42
  %51 = load ptr, ptr %6, align 8, !dbg !163
  %52 = call i32 (ptr, ptr, ...) @sscanf(ptr noundef %51, ptr noundef @.str, ptr noundef @r, ptr noundef @c), !dbg !165
  %53 = icmp ne i32 %52, 2, !dbg !166
  br i1 %53, label %54, label %57, !dbg !167

54:                                               ; preds = %50
  %55 = load ptr, ptr @__stdoutp, align 8, !dbg !168
  %56 = call i32 @"\01_fputs"(ptr noundef @.str.1, ptr noundef %55), !dbg !170
  store i32 1, ptr %3, align 4, !dbg !171
  br label %148, !dbg !171

57:                                               ; preds = %50
  %58 = load i32, ptr @r, align 4, !dbg !172
  %59 = load i32, ptr @c, align 4, !dbg !174
  %60 = mul nsw i32 %58, %59, !dbg !175
  %61 = icmp sgt i32 %60, 1000, !dbg !176
  br i1 %61, label %62, label %65, !dbg !177

62:                                               ; preds = %57
  %63 = load ptr, ptr @__stdoutp, align 8, !dbg !178
  %64 = call i32 @"\01_fputs"(ptr noundef @.str.2, ptr noundef %63), !dbg !180
  store i32 1, ptr %3, align 4, !dbg !181
  br label %148, !dbg !181

65:                                               ; preds = %57
  store i32 0, ptr %7, align 4, !dbg !182
  br label %66, !dbg !184

66:                                               ; preds = %93, %65
  %67 = load i32, ptr %7, align 4, !dbg !185
  %68 = load i32, ptr @r, align 4, !dbg !187
  %69 = icmp slt i32 %67, %68, !dbg !188
  br i1 %69, label %70, label %96, !dbg !189

70:                                               ; preds = %66
  store i32 0, ptr %8, align 4, !dbg !190
  br label %71, !dbg !192

71:                                               ; preds = %89, %70
  %72 = load i32, ptr %8, align 4, !dbg !193
  %73 = load i32, ptr @c, align 4, !dbg !195
  %74 = icmp slt i32 %72, %73, !dbg !196
  br i1 %74, label %75, label %92, !dbg !197

75:                                               ; preds = %71
  %76 = load i32, ptr %7, align 4, !dbg !198
  %77 = load i32, ptr @c, align 4, !dbg !198
  %78 = mul nsw i32 %76, %77, !dbg !198
  %79 = load i32, ptr %8, align 4, !dbg !198
  %80 = add nsw i32 %78, %79, !dbg !198
  %81 = sext i32 %80 to i64, !dbg !198
  %82 = getelementptr inbounds [1000 x i64], ptr @f, i64 0, i64 %81, !dbg !198
  %83 = call i32 (ptr, ...) @scanf(ptr noundef @.str.3, ptr noundef %82), !dbg !200
  %84 = icmp ne i32 %83, 1, !dbg !201
  br i1 %84, label %85, label %88, !dbg !202

85:                                               ; preds = %75
  %86 = load ptr, ptr @__stdoutp, align 8, !dbg !203
  %87 = call i32 @"\01_fputs"(ptr noundef @.str.4, ptr noundef %86), !dbg !205
  store i32 1, ptr %3, align 4, !dbg !206
  br label %148, !dbg !206

88:                                               ; preds = %75
  br label %89, !dbg !207

89:                                               ; preds = %88
  %90 = load i32, ptr %8, align 4, !dbg !208
  %91 = add nsw i32 %90, 1, !dbg !208
  store i32 %91, ptr %8, align 4, !dbg !208
  br label %71, !dbg !209, !llvm.loop !210

92:                                               ; preds = %71
  br label %93, !dbg !211

93:                                               ; preds = %92
  %94 = load i32, ptr %7, align 4, !dbg !212
  %95 = add nsw i32 %94, 1, !dbg !212
  store i32 %95, ptr %7, align 4, !dbg !212
  br label %66, !dbg !213, !llvm.loop !214

96:                                               ; preds = %66
  %97 = load i32, ptr @r, align 4, !dbg !216
  %98 = load i32, ptr @c, align 4, !dbg !217
  %99 = call double @InfoTbl(i32 noundef %97, i32 noundef %98, ptr noundef @f, ptr noundef %10), !dbg !218
  store double %99, ptr %9, align 8, !dbg !219
  %100 = load double, ptr %9, align 8, !dbg !220
  %101 = fcmp oge double %100, 0.000000e+00, !dbg !222
  br i1 %101, label %102, label %115, !dbg !223

102:                                              ; preds = %96
  %103 = load double, ptr %9, align 8, !dbg !224
  %104 = load i32, ptr %10, align 4, !dbg !226
  %105 = load double, ptr %9, align 8, !dbg !227
  %106 = load i32, ptr %10, align 4, !dbg !228
  %107 = call double @QChiSq(double noundef %105, i32 noundef %106), !dbg !229
  %108 = call i32 (ptr, ...) @printf(ptr noundef @.str.5, double noundef %103, i32 noundef %104, double noundef %107), !dbg !230
  %109 = load double, ptr %9, align 8, !dbg !231
  %110 = load double, ptr %11, align 8, !dbg !232
  %111 = fadd double %110, %109, !dbg !232
  store double %111, ptr %11, align 8, !dbg !232
  %112 = load i32, ptr %10, align 4, !dbg !233
  %113 = load i32, ptr %12, align 4, !dbg !234
  %114 = add nsw i32 %113, %112, !dbg !234
  store i32 %114, ptr %12, align 4, !dbg !234
  br label %134, !dbg !235

115:                                              ; preds = %96
  %116 = load double, ptr %9, align 8, !dbg !236
  %117 = fcmp olt double %116, -3.500000e+00, !dbg !237
  br i1 %117, label %118, label %119, !dbg !236

118:                                              ; preds = %115
  br label %130, !dbg !236

119:                                              ; preds = %115
  %120 = load double, ptr %9, align 8, !dbg !238
  %121 = fcmp olt double %120, -2.500000e+00, !dbg !239
  br i1 %121, label %122, label %123, !dbg !238

122:                                              ; preds = %119
  br label %128, !dbg !238

123:                                              ; preds = %119
  %124 = load double, ptr %9, align 8, !dbg !240
  %125 = fcmp olt double %124, -1.500000e+00, !dbg !241
  %126 = zext i1 %125 to i64, !dbg !240
  %127 = select i1 %125, ptr @.str.8, ptr @.str.9, !dbg !240
  br label %128, !dbg !238

128:                                              ; preds = %123, %122
  %129 = phi ptr [ @.str.7, %122 ], [ %127, %123 ], !dbg !238
  br label %130, !dbg !236

130:                                              ; preds = %128, %118
  %131 = phi ptr [ @.str.6, %118 ], [ %129, %128 ], !dbg !236
  %132 = load ptr, ptr @__stdoutp, align 8, !dbg !242
  %133 = call i32 @"\01_fputs"(ptr noundef %131, ptr noundef %132), !dbg !243
  br label %134

134:                                              ; preds = %130, %102
  br label %13, !dbg !121, !llvm.loop !152

135:                                              ; preds = %13
  %136 = load i32, ptr %12, align 4, !dbg !244
  %137 = icmp sle i32 %136, 0, !dbg !246
  br i1 %137, label %138, label %141, !dbg !247

138:                                              ; preds = %135
  %139 = load ptr, ptr @__stdoutp, align 8, !dbg !248
  %140 = call i32 @"\01_fputs"(ptr noundef @.str.10, ptr noundef %139), !dbg !250
  store i32 1, ptr %3, align 4, !dbg !251
  br label %148, !dbg !251

141:                                              ; preds = %135
  %142 = load double, ptr %11, align 8, !dbg !252
  %143 = load i32, ptr %12, align 4, !dbg !253
  %144 = load double, ptr %11, align 8, !dbg !254
  %145 = load i32, ptr %12, align 4, !dbg !255
  %146 = call double @QChiSq(double noundef %144, i32 noundef %145), !dbg !256
  %147 = call i32 (ptr, ...) @printf(ptr noundef @.str.11, double noundef %142, i32 noundef %143, double noundef %146), !dbg !257
  store i32 0, ptr %3, align 4, !dbg !258
  br label %148, !dbg !258

148:                                              ; preds = %141, %138, %85, %62, %54
  %149 = load i32, ptr %3, align 4, !dbg !259
  ret i32 %149, !dbg !259
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare ptr @fgets(ptr noundef, i32 noundef, ptr noundef) #2

declare i32 @"\01_usleep"(i32 noundef) #2

; Function Attrs: nounwind readonly willreturn
declare i32 @isspace(i32 noundef) #3

declare i32 @"\01_fputs"(ptr noundef, ptr noundef) #2

declare i32 @sscanf(ptr noundef, ptr noundef, ...) #2

declare i32 @scanf(ptr noundef, ...) #2

; Function Attrs: noinline nounwind optnone ssp uwtable
define double @InfoTbl(i32 noundef %0, i32 noundef %1, ptr noundef %2, ptr noundef %3) #0 !dbg !260 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca double, align 8
  %12 = alloca double, align 8
  %13 = alloca ptr, align 8
  %14 = alloca ptr, align 8
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca double, align 8
  %18 = alloca i64, align 8
  %19 = alloca double, align 8
  %20 = alloca double, align 8
  %21 = alloca double, align 8
  %22 = alloca double, align 8
  store i32 %0, ptr %5, align 4
  call void @llvm.dbg.declare(metadata ptr %5, metadata !266, metadata !DIExpression()), !dbg !267
  store i32 %1, ptr %6, align 4
  call void @llvm.dbg.declare(metadata ptr %6, metadata !268, metadata !DIExpression()), !dbg !269
  store ptr %2, ptr %7, align 8
  call void @llvm.dbg.declare(metadata ptr %7, metadata !270, metadata !DIExpression()), !dbg !271
  store ptr %3, ptr %8, align 8
  call void @llvm.dbg.declare(metadata ptr %8, metadata !272, metadata !DIExpression()), !dbg !273
  call void @llvm.dbg.declare(metadata ptr %9, metadata !274, metadata !DIExpression()), !dbg !275
  call void @llvm.dbg.declare(metadata ptr %10, metadata !276, metadata !DIExpression()), !dbg !277
  call void @llvm.dbg.declare(metadata ptr %11, metadata !278, metadata !DIExpression()), !dbg !279
  call void @llvm.dbg.declare(metadata ptr %12, metadata !280, metadata !DIExpression()), !dbg !281
  call void @llvm.dbg.declare(metadata ptr %13, metadata !282, metadata !DIExpression()), !dbg !283
  call void @llvm.dbg.declare(metadata ptr %14, metadata !284, metadata !DIExpression()), !dbg !285
  call void @llvm.dbg.declare(metadata ptr %15, metadata !286, metadata !DIExpression()), !dbg !287
  %23 = load i32, ptr %5, align 4, !dbg !288
  %24 = sub nsw i32 %23, 1, !dbg !289
  store i32 %24, ptr %15, align 4, !dbg !287
  call void @llvm.dbg.declare(metadata ptr %16, metadata !290, metadata !DIExpression()), !dbg !291
  %25 = load i32, ptr %6, align 4, !dbg !292
  %26 = sub nsw i32 %25, 1, !dbg !293
  store i32 %26, ptr %16, align 4, !dbg !291
  %27 = load i32, ptr %15, align 4, !dbg !294
  %28 = icmp sle i32 %27, 0, !dbg !296
  br i1 %28, label %32, label %29, !dbg !297

29:                                               ; preds = %4
  %30 = load i32, ptr %16, align 4, !dbg !298
  %31 = icmp sle i32 %30, 0, !dbg !299
  br i1 %31, label %32, label %33, !dbg !300

32:                                               ; preds = %29, %4
  store double -3.000000e+00, ptr %12, align 8, !dbg !301
  br label %219, !dbg !303

33:                                               ; preds = %29
  %34 = load i32, ptr %15, align 4, !dbg !304
  %35 = load i32, ptr %16, align 4, !dbg !305
  %36 = mul nsw i32 %34, %35, !dbg !306
  %37 = load ptr, ptr %8, align 8, !dbg !307
  store i32 %36, ptr %37, align 4, !dbg !308
  %38 = load i32, ptr %5, align 4, !dbg !309
  %39 = sext i32 %38 to i64, !dbg !309
  %40 = mul i64 %39, 8, !dbg !311
  %41 = call ptr @malloc(i64 noundef %40) #6, !dbg !312
  store ptr %41, ptr %13, align 8, !dbg !313
  %42 = icmp eq ptr %41, null, !dbg !314
  br i1 %42, label %43, label %44, !dbg !315

43:                                               ; preds = %33
  store double -4.000000e+00, ptr %12, align 8, !dbg !316
  br label %219, !dbg !318

44:                                               ; preds = %33
  %45 = load i32, ptr %6, align 4, !dbg !319
  %46 = sext i32 %45 to i64, !dbg !319
  %47 = mul i64 %46, 8, !dbg !321
  %48 = call ptr @malloc(i64 noundef %47) #6, !dbg !322
  store ptr %48, ptr %14, align 8, !dbg !323
  %49 = icmp eq ptr %48, null, !dbg !324
  br i1 %49, label %50, label %51, !dbg !325

50:                                               ; preds = %44
  store double -4.000000e+00, ptr %12, align 8, !dbg !326
  br label %217, !dbg !328

51:                                               ; preds = %44
  store double 0.000000e+00, ptr %11, align 8, !dbg !329
  store i32 0, ptr %9, align 4, !dbg !330
  br label %52, !dbg !332

52:                                               ; preds = %90, %51
  %53 = load i32, ptr %9, align 4, !dbg !333
  %54 = load i32, ptr %5, align 4, !dbg !335
  %55 = icmp slt i32 %53, %54, !dbg !336
  br i1 %55, label %56, label %93, !dbg !337

56:                                               ; preds = %52
  call void @llvm.dbg.declare(metadata ptr %17, metadata !338, metadata !DIExpression()), !dbg !340
  store double 0.000000e+00, ptr %17, align 8, !dbg !340
  store i32 0, ptr %10, align 4, !dbg !341
  br label %57, !dbg !343

57:                                               ; preds = %79, %56
  %58 = load i32, ptr %10, align 4, !dbg !344
  %59 = load i32, ptr %6, align 4, !dbg !346
  %60 = icmp slt i32 %58, %59, !dbg !347
  br i1 %60, label %61, label %82, !dbg !348

61:                                               ; preds = %57
  call void @llvm.dbg.declare(metadata ptr %18, metadata !349, metadata !DIExpression()), !dbg !351
  %62 = load ptr, ptr %7, align 8, !dbg !352
  %63 = load i32, ptr %9, align 4, !dbg !352
  %64 = load i32, ptr %6, align 4, !dbg !352
  %65 = mul nsw i32 %63, %64, !dbg !352
  %66 = load i32, ptr %10, align 4, !dbg !352
  %67 = add nsw i32 %65, %66, !dbg !352
  %68 = sext i32 %67 to i64, !dbg !352
  %69 = getelementptr inbounds i64, ptr %62, i64 %68, !dbg !352
  %70 = load i64, ptr %69, align 8, !dbg !352
  store i64 %70, ptr %18, align 8, !dbg !351
  %71 = load i64, ptr %18, align 8, !dbg !353
  %72 = icmp slt i64 %71, 0, !dbg !355
  br i1 %72, label %73, label %74, !dbg !356

73:                                               ; preds = %61
  store double -2.000000e+00, ptr %12, align 8, !dbg !357
  br label %215, !dbg !359

74:                                               ; preds = %61
  %75 = load i64, ptr %18, align 8, !dbg !360
  %76 = sitofp i64 %75 to double, !dbg !361
  %77 = load double, ptr %17, align 8, !dbg !362
  %78 = fadd double %77, %76, !dbg !362
  store double %78, ptr %17, align 8, !dbg !362
  br label %79, !dbg !363

79:                                               ; preds = %74
  %80 = load i32, ptr %10, align 4, !dbg !364
  %81 = add nsw i32 %80, 1, !dbg !364
  store i32 %81, ptr %10, align 4, !dbg !364
  br label %57, !dbg !365, !llvm.loop !366

82:                                               ; preds = %57
  %83 = load double, ptr %17, align 8, !dbg !368
  %84 = load ptr, ptr %13, align 8, !dbg !369
  %85 = load i32, ptr %9, align 4, !dbg !370
  %86 = sext i32 %85 to i64, !dbg !369
  %87 = getelementptr inbounds double, ptr %84, i64 %86, !dbg !369
  store double %83, ptr %87, align 8, !dbg !371
  %88 = load double, ptr %11, align 8, !dbg !372
  %89 = fadd double %88, %83, !dbg !372
  store double %89, ptr %11, align 8, !dbg !372
  br label %90, !dbg !373

90:                                               ; preds = %82
  %91 = load i32, ptr %9, align 4, !dbg !374
  %92 = add nsw i32 %91, 1, !dbg !374
  store i32 %92, ptr %9, align 4, !dbg !374
  br label %52, !dbg !375, !llvm.loop !376

93:                                               ; preds = %52
  %94 = load double, ptr %11, align 8, !dbg !378
  %95 = fcmp ole double %94, 0.000000e+00, !dbg !380
  br i1 %95, label %96, label %97, !dbg !381

96:                                               ; preds = %93
  store double -1.000000e+00, ptr %12, align 8, !dbg !382
  br label %215, !dbg !384

97:                                               ; preds = %93
  store i32 0, ptr %10, align 4, !dbg !385
  br label %98, !dbg !387

98:                                               ; preds = %129, %97
  %99 = load i32, ptr %10, align 4, !dbg !388
  %100 = load i32, ptr %6, align 4, !dbg !390
  %101 = icmp slt i32 %99, %100, !dbg !391
  br i1 %101, label %102, label %132, !dbg !392

102:                                              ; preds = %98
  call void @llvm.dbg.declare(metadata ptr %19, metadata !393, metadata !DIExpression()), !dbg !395
  store double 0.000000e+00, ptr %19, align 8, !dbg !395
  store i32 0, ptr %9, align 4, !dbg !396
  br label %103, !dbg !398

103:                                              ; preds = %120, %102
  %104 = load i32, ptr %9, align 4, !dbg !399
  %105 = load i32, ptr %5, align 4, !dbg !401
  %106 = icmp slt i32 %104, %105, !dbg !402
  br i1 %106, label %107, label %123, !dbg !403

107:                                              ; preds = %103
  %108 = load ptr, ptr %7, align 8, !dbg !404
  %109 = load i32, ptr %9, align 4, !dbg !404
  %110 = load i32, ptr %6, align 4, !dbg !404
  %111 = mul nsw i32 %109, %110, !dbg !404
  %112 = load i32, ptr %10, align 4, !dbg !404
  %113 = add nsw i32 %111, %112, !dbg !404
  %114 = sext i32 %113 to i64, !dbg !404
  %115 = getelementptr inbounds i64, ptr %108, i64 %114, !dbg !404
  %116 = load i64, ptr %115, align 8, !dbg !404
  %117 = sitofp i64 %116 to double, !dbg !405
  %118 = load double, ptr %19, align 8, !dbg !406
  %119 = fadd double %118, %117, !dbg !406
  store double %119, ptr %19, align 8, !dbg !406
  br label %120, !dbg !407

120:                                              ; preds = %107
  %121 = load i32, ptr %9, align 4, !dbg !408
  %122 = add nsw i32 %121, 1, !dbg !408
  store i32 %122, ptr %9, align 4, !dbg !408
  br label %103, !dbg !409, !llvm.loop !410

123:                                              ; preds = %103
  %124 = load double, ptr %19, align 8, !dbg !412
  %125 = load ptr, ptr %14, align 8, !dbg !413
  %126 = load i32, ptr %10, align 4, !dbg !414
  %127 = sext i32 %126 to i64, !dbg !413
  %128 = getelementptr inbounds double, ptr %125, i64 %127, !dbg !413
  store double %124, ptr %128, align 8, !dbg !415
  br label %129, !dbg !416

129:                                              ; preds = %123
  %130 = load i32, ptr %10, align 4, !dbg !417
  %131 = add nsw i32 %130, 1, !dbg !417
  store i32 %131, ptr %10, align 4, !dbg !417
  br label %98, !dbg !418, !llvm.loop !419

132:                                              ; preds = %98
  %133 = load double, ptr %11, align 8, !dbg !421
  %134 = load double, ptr %11, align 8, !dbg !422
  %135 = call double @llvm.log.f64(double %134), !dbg !423
  %136 = fmul double %133, %135, !dbg !424
  store double %136, ptr %12, align 8, !dbg !425
  store i32 0, ptr %9, align 4, !dbg !426
  br label %137, !dbg !428

137:                                              ; preds = %185, %132
  %138 = load i32, ptr %9, align 4, !dbg !429
  %139 = load i32, ptr %5, align 4, !dbg !431
  %140 = icmp slt i32 %138, %139, !dbg !432
  br i1 %140, label %141, label %188, !dbg !433

141:                                              ; preds = %137
  call void @llvm.dbg.declare(metadata ptr %20, metadata !434, metadata !DIExpression()), !dbg !436
  %142 = load ptr, ptr %13, align 8, !dbg !437
  %143 = load i32, ptr %9, align 4, !dbg !438
  %144 = sext i32 %143 to i64, !dbg !437
  %145 = getelementptr inbounds double, ptr %142, i64 %144, !dbg !437
  %146 = load double, ptr %145, align 8, !dbg !437
  store double %146, ptr %20, align 8, !dbg !436
  %147 = load double, ptr %20, align 8, !dbg !439
  %148 = fcmp ogt double %147, 0.000000e+00, !dbg !441
  br i1 %148, label %149, label %156, !dbg !442

149:                                              ; preds = %141
  %150 = load double, ptr %20, align 8, !dbg !443
  %151 = load double, ptr %20, align 8, !dbg !444
  %152 = call double @llvm.log.f64(double %151), !dbg !445
  %153 = load double, ptr %12, align 8, !dbg !446
  %154 = fneg double %150, !dbg !446
  %155 = call double @llvm.fmuladd.f64(double %154, double %152, double %153), !dbg !446
  store double %155, ptr %12, align 8, !dbg !446
  br label %156, !dbg !447

156:                                              ; preds = %149, %141
  store i32 0, ptr %10, align 4, !dbg !448
  br label %157, !dbg !450

157:                                              ; preds = %181, %156
  %158 = load i32, ptr %10, align 4, !dbg !451
  %159 = load i32, ptr %6, align 4, !dbg !453
  %160 = icmp slt i32 %158, %159, !dbg !454
  br i1 %160, label %161, label %184, !dbg !455

161:                                              ; preds = %157
  call void @llvm.dbg.declare(metadata ptr %21, metadata !456, metadata !DIExpression()), !dbg !458
  %162 = load ptr, ptr %7, align 8, !dbg !459
  %163 = load i32, ptr %9, align 4, !dbg !459
  %164 = load i32, ptr %6, align 4, !dbg !459
  %165 = mul nsw i32 %163, %164, !dbg !459
  %166 = load i32, ptr %10, align 4, !dbg !459
  %167 = add nsw i32 %165, %166, !dbg !459
  %168 = sext i32 %167 to i64, !dbg !459
  %169 = getelementptr inbounds i64, ptr %162, i64 %168, !dbg !459
  %170 = load i64, ptr %169, align 8, !dbg !459
  %171 = sitofp i64 %170 to double, !dbg !460
  store double %171, ptr %21, align 8, !dbg !458
  %172 = load double, ptr %21, align 8, !dbg !461
  %173 = fcmp ogt double %172, 0.000000e+00, !dbg !463
  br i1 %173, label %174, label %180, !dbg !464

174:                                              ; preds = %161
  %175 = load double, ptr %21, align 8, !dbg !465
  %176 = load double, ptr %21, align 8, !dbg !466
  %177 = call double @llvm.log.f64(double %176), !dbg !467
  %178 = load double, ptr %12, align 8, !dbg !468
  %179 = call double @llvm.fmuladd.f64(double %175, double %177, double %178), !dbg !468
  store double %179, ptr %12, align 8, !dbg !468
  br label %180, !dbg !469

180:                                              ; preds = %174, %161
  br label %181, !dbg !470

181:                                              ; preds = %180
  %182 = load i32, ptr %10, align 4, !dbg !471
  %183 = add nsw i32 %182, 1, !dbg !471
  store i32 %183, ptr %10, align 4, !dbg !471
  br label %157, !dbg !472, !llvm.loop !473

184:                                              ; preds = %157
  br label %185, !dbg !475

185:                                              ; preds = %184
  %186 = load i32, ptr %9, align 4, !dbg !476
  %187 = add nsw i32 %186, 1, !dbg !476
  store i32 %187, ptr %9, align 4, !dbg !476
  br label %137, !dbg !477, !llvm.loop !478

188:                                              ; preds = %137
  store i32 0, ptr %10, align 4, !dbg !480
  br label %189, !dbg !482

189:                                              ; preds = %209, %188
  %190 = load i32, ptr %10, align 4, !dbg !483
  %191 = load i32, ptr %6, align 4, !dbg !485
  %192 = icmp slt i32 %190, %191, !dbg !486
  br i1 %192, label %193, label %212, !dbg !487

193:                                              ; preds = %189
  call void @llvm.dbg.declare(metadata ptr %22, metadata !488, metadata !DIExpression()), !dbg !490
  %194 = load ptr, ptr %14, align 8, !dbg !491
  %195 = load i32, ptr %10, align 4, !dbg !492
  %196 = sext i32 %195 to i64, !dbg !491
  %197 = getelementptr inbounds double, ptr %194, i64 %196, !dbg !491
  %198 = load double, ptr %197, align 8, !dbg !491
  store double %198, ptr %22, align 8, !dbg !490
  %199 = load double, ptr %22, align 8, !dbg !493
  %200 = fcmp ogt double %199, 0.000000e+00, !dbg !495
  br i1 %200, label %201, label %208, !dbg !496

201:                                              ; preds = %193
  %202 = load double, ptr %22, align 8, !dbg !497
  %203 = load double, ptr %22, align 8, !dbg !498
  %204 = call double @llvm.log.f64(double %203), !dbg !499
  %205 = load double, ptr %12, align 8, !dbg !500
  %206 = fneg double %202, !dbg !500
  %207 = call double @llvm.fmuladd.f64(double %206, double %204, double %205), !dbg !500
  store double %207, ptr %12, align 8, !dbg !500
  br label %208, !dbg !501

208:                                              ; preds = %201, %193
  br label %209, !dbg !502

209:                                              ; preds = %208
  %210 = load i32, ptr %10, align 4, !dbg !503
  %211 = add nsw i32 %210, 1, !dbg !503
  store i32 %211, ptr %10, align 4, !dbg !503
  br label %189, !dbg !504, !llvm.loop !505

212:                                              ; preds = %189
  %213 = load double, ptr %12, align 8, !dbg !507
  %214 = fmul double %213, 2.000000e+00, !dbg !507
  store double %214, ptr %12, align 8, !dbg !507
  br label %215, !dbg !508

215:                                              ; preds = %212, %96, %73
  call void @llvm.dbg.label(metadata !509), !dbg !510
  %216 = load ptr, ptr %14, align 8, !dbg !511
  call void @free(ptr noundef %216), !dbg !512
  br label %217, !dbg !512

217:                                              ; preds = %215, %50
  call void @llvm.dbg.label(metadata !513), !dbg !514
  %218 = load ptr, ptr %13, align 8, !dbg !515
  call void @free(ptr noundef %218), !dbg !516
  br label %219, !dbg !516

219:                                              ; preds = %217, %43, %32
  call void @llvm.dbg.label(metadata !517), !dbg !518
  %220 = load double, ptr %12, align 8, !dbg !519
  ret double %220, !dbg !520
}

declare i32 @printf(ptr noundef, ...) #2

; Function Attrs: noinline nounwind optnone ssp uwtable
define double @QChiSq(double noundef %0, i32 noundef %1) #0 !dbg !521 {
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  store double %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !524, metadata !DIExpression()), !dbg !525
  store i32 %1, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !526, metadata !DIExpression()), !dbg !527
  %5 = load i32, ptr %4, align 4, !dbg !528
  %6 = sitofp i32 %5 to double, !dbg !529
  %7 = fdiv double %6, 2.000000e+00, !dbg !530
  %8 = load double, ptr %3, align 8, !dbg !531
  %9 = fdiv double %8, 2.000000e+00, !dbg !532
  %10 = call double @QGamma(double noundef %7, double noundef %9), !dbg !533
  ret double %10, !dbg !534
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define double @LGamma(double noundef %0) #0 !dbg !69 {
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  %6 = alloca i32, align 4
  %7 = alloca double, align 8
  store double %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !535, metadata !DIExpression()), !dbg !536
  call void @llvm.dbg.declare(metadata ptr %4, metadata !537, metadata !DIExpression()), !dbg !538
  call void @llvm.dbg.declare(metadata ptr %5, metadata !539, metadata !DIExpression()), !dbg !540
  call void @llvm.dbg.declare(metadata ptr %6, metadata !541, metadata !DIExpression()), !dbg !542
  %8 = load double, ptr %3, align 8, !dbg !543
  %9 = fadd double %8, -1.000000e+00, !dbg !543
  store double %9, ptr %3, align 8, !dbg !543
  %10 = fcmp olt double %9, 0.000000e+00, !dbg !545
  br i1 %10, label %11, label %23, !dbg !546

11:                                               ; preds = %1
  call void @llvm.dbg.declare(metadata ptr %7, metadata !547, metadata !DIExpression()), !dbg !549
  %12 = load double, ptr %3, align 8, !dbg !550
  %13 = fmul double 0x400921FB54442D18, %12, !dbg !551
  store double %13, ptr %7, align 8, !dbg !549
  %14 = load double, ptr %7, align 8, !dbg !552
  %15 = load double, ptr %7, align 8, !dbg !553
  %16 = call double @llvm.sin.f64(double %15), !dbg !554
  %17 = fdiv double %14, %16, !dbg !555
  %18 = call double @llvm.log.f64(double %17), !dbg !556
  %19 = load double, ptr %3, align 8, !dbg !557
  %20 = fsub double 1.000000e+00, %19, !dbg !558
  %21 = call double @LGamma(double noundef %20), !dbg !559
  %22 = fsub double %18, %21, !dbg !560
  store double %22, ptr %2, align 8, !dbg !561
  br label %56, !dbg !561

23:                                               ; preds = %1
  %24 = load double, ptr %3, align 8, !dbg !562
  %25 = fadd double %24, 5.500000e+00, !dbg !563
  store double %25, ptr %4, align 8, !dbg !564
  %26 = load double, ptr %3, align 8, !dbg !565
  %27 = fadd double %26, 5.000000e-01, !dbg !566
  %28 = load double, ptr %4, align 8, !dbg !567
  %29 = call double @llvm.log.f64(double %28), !dbg !568
  %30 = load double, ptr %4, align 8, !dbg !569
  %31 = fneg double %27, !dbg !569
  %32 = call double @llvm.fmuladd.f64(double %31, double %29, double %30), !dbg !569
  store double %32, ptr %4, align 8, !dbg !569
  store double 1.000000e+00, ptr %5, align 8, !dbg !570
  store i32 0, ptr %6, align 4, !dbg !571
  br label %33, !dbg !573

33:                                               ; preds = %46, %23
  %34 = load i32, ptr %6, align 4, !dbg !574
  %35 = icmp slt i32 %34, 6, !dbg !576
  br i1 %35, label %36, label %49, !dbg !577

36:                                               ; preds = %33
  %37 = load i32, ptr %6, align 4, !dbg !578
  %38 = sext i32 %37 to i64, !dbg !579
  %39 = getelementptr inbounds [6 x double], ptr @LGamma.cof, i64 0, i64 %38, !dbg !579
  %40 = load double, ptr %39, align 8, !dbg !579
  %41 = load double, ptr %3, align 8, !dbg !580
  %42 = fadd double %41, 1.000000e+00, !dbg !580
  store double %42, ptr %3, align 8, !dbg !580
  %43 = fdiv double %40, %42, !dbg !581
  %44 = load double, ptr %5, align 8, !dbg !582
  %45 = fadd double %44, %43, !dbg !582
  store double %45, ptr %5, align 8, !dbg !582
  br label %46, !dbg !583

46:                                               ; preds = %36
  %47 = load i32, ptr %6, align 4, !dbg !584
  %48 = add nsw i32 %47, 1, !dbg !584
  store i32 %48, ptr %6, align 4, !dbg !584
  br label %33, !dbg !585, !llvm.loop !586

49:                                               ; preds = %33
  %50 = load double, ptr %4, align 8, !dbg !588
  %51 = fneg double %50, !dbg !589
  %52 = load double, ptr %5, align 8, !dbg !590
  %53 = fmul double 0x40040D931FF6CE25, %52, !dbg !591
  %54 = call double @llvm.log.f64(double %53), !dbg !592
  %55 = fadd double %51, %54, !dbg !593
  store double %55, ptr %2, align 8, !dbg !594
  br label %56, !dbg !594

56:                                               ; preds = %49, %11
  %57 = load double, ptr %2, align 8, !dbg !595
  ret double %57, !dbg !595
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.sin.f64(double) #1

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.log.f64(double) #1

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
define double @QGamma(double noundef %0, double noundef %1) #0 !dbg !596 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  store double %0, ptr %3, align 8
  call void @llvm.dbg.declare(metadata ptr %3, metadata !599, metadata !DIExpression()), !dbg !600
  store double %1, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !601, metadata !DIExpression()), !dbg !602
  %5 = load double, ptr %4, align 8, !dbg !603
  %6 = load double, ptr %3, align 8, !dbg !604
  %7 = fadd double %6, 1.000000e+00, !dbg !605
  %8 = fcmp olt double %5, %7, !dbg !606
  br i1 %8, label %9, label %14, !dbg !603

9:                                                ; preds = %2
  %10 = load double, ptr %3, align 8, !dbg !607
  %11 = load double, ptr %4, align 8, !dbg !608
  %12 = call double @gser(double noundef %10, double noundef %11), !dbg !609
  %13 = fsub double 1.000000e+00, %12, !dbg !610
  br label %18, !dbg !603

14:                                               ; preds = %2
  %15 = load double, ptr %3, align 8, !dbg !611
  %16 = load double, ptr %4, align 8, !dbg !612
  %17 = call double @gcf(double noundef %15, double noundef %16), !dbg !613
  br label %18, !dbg !603

18:                                               ; preds = %14, %9
  %19 = phi double [ %13, %9 ], [ %17, %14 ], !dbg !603
  ret double %19, !dbg !614
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define internal double @gser(double noundef %0, double noundef %1) #0 !dbg !615 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  %6 = alloca double, align 8
  %7 = alloca double, align 8
  %8 = alloca double, align 8
  %9 = alloca i32, align 4
  store double %0, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !616, metadata !DIExpression()), !dbg !617
  store double %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !618, metadata !DIExpression()), !dbg !619
  call void @llvm.dbg.declare(metadata ptr %6, metadata !620, metadata !DIExpression()), !dbg !621
  call void @llvm.dbg.declare(metadata ptr %7, metadata !622, metadata !DIExpression()), !dbg !623
  call void @llvm.dbg.declare(metadata ptr %8, metadata !624, metadata !DIExpression()), !dbg !625
  call void @llvm.dbg.declare(metadata ptr %9, metadata !626, metadata !DIExpression()), !dbg !627
  %10 = load double, ptr %5, align 8, !dbg !628
  %11 = fcmp ole double %10, 0.000000e+00, !dbg !630
  br i1 %11, label %12, label %13, !dbg !631

12:                                               ; preds = %2
  store double 0.000000e+00, ptr %3, align 8, !dbg !632
  br label %65, !dbg !632

13:                                               ; preds = %2
  %14 = load double, ptr %4, align 8, !dbg !633
  store double %14, ptr %6, align 8, !dbg !634
  %15 = fdiv double 1.000000e+00, %14, !dbg !635
  store double %15, ptr %8, align 8, !dbg !636
  store double %15, ptr %7, align 8, !dbg !637
  store i32 1, ptr %9, align 4, !dbg !638
  br label %16, !dbg !640

16:                                               ; preds = %62, %13
  %17 = load i32, ptr %9, align 4, !dbg !641
  %18 = icmp sle i32 %17, 100, !dbg !643
  br i1 %18, label %19, label %65, !dbg !644

19:                                               ; preds = %16
  %20 = load double, ptr %5, align 8, !dbg !645
  %21 = load double, ptr %6, align 8, !dbg !647
  %22 = fadd double %21, 1.000000e+00, !dbg !647
  store double %22, ptr %6, align 8, !dbg !647
  %23 = fdiv double %20, %22, !dbg !648
  %24 = load double, ptr %7, align 8, !dbg !649
  %25 = fmul double %24, %23, !dbg !649
  store double %25, ptr %7, align 8, !dbg !649
  %26 = load double, ptr %8, align 8, !dbg !650
  %27 = fadd double %26, %25, !dbg !650
  store double %27, ptr %8, align 8, !dbg !650
  %28 = load double, ptr %7, align 8, !dbg !651
  %29 = fcmp olt double %28, 0.000000e+00, !dbg !651
  br i1 %29, label %30, label %33, !dbg !651

30:                                               ; preds = %19
  %31 = load double, ptr %7, align 8, !dbg !651
  %32 = fneg double %31, !dbg !651
  br label %35, !dbg !651

33:                                               ; preds = %19
  %34 = load double, ptr %7, align 8, !dbg !651
  br label %35, !dbg !651

35:                                               ; preds = %33, %30
  %36 = phi double [ %32, %30 ], [ %34, %33 ], !dbg !651
  %37 = load double, ptr %8, align 8, !dbg !653
  %38 = fcmp olt double %37, 0.000000e+00, !dbg !653
  br i1 %38, label %39, label %42, !dbg !653

39:                                               ; preds = %35
  %40 = load double, ptr %8, align 8, !dbg !653
  %41 = fneg double %40, !dbg !653
  br label %44, !dbg !653

42:                                               ; preds = %35
  %43 = load double, ptr %8, align 8, !dbg !653
  br label %44, !dbg !653

44:                                               ; preds = %42, %39
  %45 = phi double [ %41, %39 ], [ %43, %42 ], !dbg !653
  %46 = fmul double %45, 3.000000e-07, !dbg !654
  %47 = fcmp olt double %36, %46, !dbg !655
  br i1 %47, label %48, label %61, !dbg !656

48:                                               ; preds = %44
  %49 = load double, ptr %8, align 8, !dbg !657
  %50 = load double, ptr %5, align 8, !dbg !658
  %51 = fneg double %50, !dbg !659
  %52 = load double, ptr %4, align 8, !dbg !660
  %53 = load double, ptr %5, align 8, !dbg !661
  %54 = call double @llvm.log.f64(double %53), !dbg !662
  %55 = call double @llvm.fmuladd.f64(double %52, double %54, double %51), !dbg !663
  %56 = load double, ptr %4, align 8, !dbg !664
  %57 = call double @LGamma(double noundef %56), !dbg !665
  %58 = fsub double %55, %57, !dbg !666
  %59 = call double @llvm.exp.f64(double %58), !dbg !667
  %60 = fmul double %49, %59, !dbg !668
  store double %60, ptr %3, align 8, !dbg !669
  br label %65, !dbg !669

61:                                               ; preds = %44
  br label %62, !dbg !670

62:                                               ; preds = %61
  %63 = load i32, ptr %9, align 4, !dbg !671
  %64 = add nsw i32 %63, 1, !dbg !671
  store i32 %64, ptr %9, align 4, !dbg !671
  br label %16, !dbg !672, !llvm.loop !673

65:                                               ; preds = %12, %48, %16
  %66 = load double, ptr %3, align 8, !dbg !675
  ret double %66, !dbg !675
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define internal double @gcf(double noundef %0, double noundef %1) #0 !dbg !676 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  %6 = alloca i32, align 4
  %7 = alloca double, align 8
  %8 = alloca double, align 8
  %9 = alloca double, align 8
  %10 = alloca double, align 8
  %11 = alloca double, align 8
  %12 = alloca double, align 8
  %13 = alloca double, align 8
  %14 = alloca double, align 8
  %15 = alloca double, align 8
  %16 = alloca double, align 8
  store double %0, ptr %4, align 8
  call void @llvm.dbg.declare(metadata ptr %4, metadata !677, metadata !DIExpression()), !dbg !678
  store double %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !679, metadata !DIExpression()), !dbg !680
  call void @llvm.dbg.declare(metadata ptr %6, metadata !681, metadata !DIExpression()), !dbg !682
  call void @llvm.dbg.declare(metadata ptr %7, metadata !683, metadata !DIExpression()), !dbg !684
  store double 0.000000e+00, ptr %7, align 8, !dbg !684
  call void @llvm.dbg.declare(metadata ptr %8, metadata !685, metadata !DIExpression()), !dbg !686
  store double 1.000000e+00, ptr %8, align 8, !dbg !686
  call void @llvm.dbg.declare(metadata ptr %9, metadata !687, metadata !DIExpression()), !dbg !688
  store double 1.000000e+00, ptr %9, align 8, !dbg !688
  call void @llvm.dbg.declare(metadata ptr %10, metadata !689, metadata !DIExpression()), !dbg !690
  store double 0.000000e+00, ptr %10, align 8, !dbg !690
  call void @llvm.dbg.declare(metadata ptr %11, metadata !691, metadata !DIExpression()), !dbg !692
  store double 1.000000e+00, ptr %11, align 8, !dbg !692
  call void @llvm.dbg.declare(metadata ptr %12, metadata !693, metadata !DIExpression()), !dbg !694
  %17 = load double, ptr %5, align 8, !dbg !695
  store double %17, ptr %12, align 8, !dbg !694
  store i32 1, ptr %6, align 4, !dbg !696
  br label %18, !dbg !698

18:                                               ; preds = %100, %2
  %19 = load i32, ptr %6, align 4, !dbg !699
  %20 = icmp sle i32 %19, 100, !dbg !701
  br i1 %20, label %21, label %103, !dbg !702

21:                                               ; preds = %18
  call void @llvm.dbg.declare(metadata ptr %13, metadata !703, metadata !DIExpression()), !dbg !705
  call void @llvm.dbg.declare(metadata ptr %14, metadata !706, metadata !DIExpression()), !dbg !707
  %22 = load i32, ptr %6, align 4, !dbg !708
  %23 = sitofp i32 %22 to double, !dbg !709
  store double %23, ptr %14, align 8, !dbg !707
  call void @llvm.dbg.declare(metadata ptr %15, metadata !710, metadata !DIExpression()), !dbg !711
  %24 = load double, ptr %14, align 8, !dbg !712
  %25 = load double, ptr %4, align 8, !dbg !713
  %26 = fsub double %24, %25, !dbg !714
  store double %26, ptr %15, align 8, !dbg !711
  %27 = load double, ptr %12, align 8, !dbg !715
  %28 = load double, ptr %11, align 8, !dbg !716
  %29 = load double, ptr %15, align 8, !dbg !717
  %30 = call double @llvm.fmuladd.f64(double %28, double %29, double %27), !dbg !718
  %31 = load double, ptr %8, align 8, !dbg !719
  %32 = fmul double %30, %31, !dbg !720
  store double %32, ptr %11, align 8, !dbg !721
  %33 = load double, ptr %9, align 8, !dbg !722
  %34 = load double, ptr %10, align 8, !dbg !723
  %35 = load double, ptr %15, align 8, !dbg !724
  %36 = call double @llvm.fmuladd.f64(double %34, double %35, double %33), !dbg !725
  %37 = load double, ptr %8, align 8, !dbg !726
  %38 = fmul double %36, %37, !dbg !727
  store double %38, ptr %10, align 8, !dbg !728
  %39 = load double, ptr %14, align 8, !dbg !729
  %40 = load double, ptr %8, align 8, !dbg !730
  %41 = fmul double %39, %40, !dbg !731
  store double %41, ptr %13, align 8, !dbg !732
  %42 = load double, ptr %5, align 8, !dbg !733
  %43 = load double, ptr %10, align 8, !dbg !734
  %44 = load double, ptr %13, align 8, !dbg !735
  %45 = load double, ptr %9, align 8, !dbg !736
  %46 = fmul double %44, %45, !dbg !737
  %47 = call double @llvm.fmuladd.f64(double %42, double %43, double %46), !dbg !738
  store double %47, ptr %9, align 8, !dbg !739
  %48 = load double, ptr %5, align 8, !dbg !740
  %49 = load double, ptr %11, align 8, !dbg !741
  %50 = load double, ptr %13, align 8, !dbg !742
  %51 = load double, ptr %12, align 8, !dbg !743
  %52 = fmul double %50, %51, !dbg !744
  %53 = call double @llvm.fmuladd.f64(double %48, double %49, double %52), !dbg !745
  store double %53, ptr %12, align 8, !dbg !746
  %54 = load double, ptr %12, align 8, !dbg !747
  %55 = fcmp une double %54, 0.000000e+00, !dbg !749
  br i1 %55, label %56, label %99, !dbg !750

56:                                               ; preds = %21
  call void @llvm.dbg.declare(metadata ptr %16, metadata !751, metadata !DIExpression()), !dbg !753
  %57 = load double, ptr %9, align 8, !dbg !754
  %58 = load double, ptr %12, align 8, !dbg !755
  %59 = fdiv double 1.000000e+00, %58, !dbg !756
  store double %59, ptr %8, align 8, !dbg !757
  %60 = fmul double %57, %59, !dbg !758
  store double %60, ptr %16, align 8, !dbg !753
  %61 = load double, ptr %16, align 8, !dbg !759
  %62 = load double, ptr %7, align 8, !dbg !760
  %63 = fsub double %61, %62, !dbg !761
  store double %63, ptr %7, align 8, !dbg !762
  %64 = load double, ptr %7, align 8, !dbg !763
  %65 = fcmp olt double %64, 0.000000e+00, !dbg !763
  br i1 %65, label %66, label %69, !dbg !763

66:                                               ; preds = %56
  %67 = load double, ptr %7, align 8, !dbg !763
  %68 = fneg double %67, !dbg !763
  br label %71, !dbg !763

69:                                               ; preds = %56
  %70 = load double, ptr %7, align 8, !dbg !763
  br label %71, !dbg !763

71:                                               ; preds = %69, %66
  %72 = phi double [ %68, %66 ], [ %70, %69 ], !dbg !763
  %73 = load double, ptr %16, align 8, !dbg !765
  %74 = fcmp olt double %73, 0.000000e+00, !dbg !765
  br i1 %74, label %75, label %78, !dbg !765

75:                                               ; preds = %71
  %76 = load double, ptr %16, align 8, !dbg !765
  %77 = fneg double %76, !dbg !765
  br label %80, !dbg !765

78:                                               ; preds = %71
  %79 = load double, ptr %16, align 8, !dbg !765
  br label %80, !dbg !765

80:                                               ; preds = %78, %75
  %81 = phi double [ %77, %75 ], [ %79, %78 ], !dbg !765
  %82 = fmul double 3.000000e-07, %81, !dbg !766
  %83 = fcmp olt double %72, %82, !dbg !767
  br i1 %83, label %84, label %97, !dbg !768

84:                                               ; preds = %80
  %85 = load double, ptr %5, align 8, !dbg !769
  %86 = fneg double %85, !dbg !770
  %87 = load double, ptr %4, align 8, !dbg !771
  %88 = load double, ptr %5, align 8, !dbg !772
  %89 = call double @llvm.log.f64(double %88), !dbg !773
  %90 = call double @llvm.fmuladd.f64(double %87, double %89, double %86), !dbg !774
  %91 = load double, ptr %4, align 8, !dbg !775
  %92 = call double @LGamma(double noundef %91), !dbg !776
  %93 = fsub double %90, %92, !dbg !777
  %94 = call double @llvm.exp.f64(double %93), !dbg !778
  %95 = load double, ptr %16, align 8, !dbg !779
  %96 = fmul double %94, %95, !dbg !780
  store double %96, ptr %3, align 8, !dbg !781
  br label %103, !dbg !781

97:                                               ; preds = %80
  %98 = load double, ptr %16, align 8, !dbg !782
  store double %98, ptr %7, align 8, !dbg !783
  br label %99, !dbg !784

99:                                               ; preds = %97, %21
  br label %100, !dbg !785

100:                                              ; preds = %99
  %101 = load i32, ptr %6, align 4, !dbg !786
  %102 = add nsw i32 %101, 1, !dbg !786
  store i32 %102, ptr %6, align 4, !dbg !786
  br label %18, !dbg !787, !llvm.loop !788

103:                                              ; preds = %84, %18
  %104 = load double, ptr %3, align 8, !dbg !790
  ret double %104, !dbg !790
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #4

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

declare void @free(ptr noundef) #2

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.exp.f64(double) #1

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #3 = { nounwind readonly willreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #4 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #5 = { nounwind readonly willreturn }
attributes #6 = { allocsize(0) }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!90, !91, !92, !93, !94, !95}
!llvm.ident = !{!96}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "line", scope: !2, file: !3, line: 27, type: !87, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 15.0.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !11, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX12.sdk", sdk: "MacOSX12.sdk")
!3 = !DIFile(filename: "totinfo_fuzz.c", directory: "XXX/converter/ft_data/source_code/totinfo")
!4 = !{!5, !6, !7, !8, !9}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "pointer", file: !10, line: 39, baseType: !5)
!10 = !DIFile(filename: "./std.h", directory: "XXX/converter/ft_data/source_code/totinfo")
!11 = !{!12, !18, !23, !28, !33, !38, !43, !48, !53, !55, !57, !62, !67, !0, !77, !83, !85}
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !3, line: 72, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 56, elements: !16)
!15 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!16 = !{!17}
!17 = !DISubrange(count: 7)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 74, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 232, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 29)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !3, line: 80, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 168, elements: !26)
!26 = !{!27}
!27 = !DISubrange(count: 21)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !3, line: 88, type: !30, isLocal: true, isDefinition: true)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 40, elements: !31)
!31 = !{!32}
!32 = !DISubrange(count: 5)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(scope: null, file: !3, line: 90, type: !35, isLocal: true, isDefinition: true)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 144, elements: !36)
!36 = !{!37}
!37 = !DISubrange(count: 18)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 104, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 272, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 34)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 112, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 120, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 15)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(scope: null, file: !3, line: 113, type: !50, isLocal: true, isDefinition: true)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 136, elements: !51)
!51 = !{!52}
!52 = !DISubrange(count: 17)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(scope: null, file: !3, line: 114, type: !45, isLocal: true, isDefinition: true)
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(scope: null, file: !3, line: 115, type: !50, isLocal: true, isDefinition: true)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(scope: null, file: !3, line: 122, type: !59, isLocal: true, isDefinition: true)
!59 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 296, elements: !60)
!60 = !{!61}
!61 = !DISubrange(count: 37)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(scope: null, file: !3, line: 126, type: !64, isLocal: true, isDefinition: true)
!64 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 328, elements: !65)
!65 = !{!66}
!66 = !DISubrange(count: 41)
!67 = !DIGlobalVariableExpression(var: !68, expr: !DIExpression())
!68 = distinct !DIGlobalVariable(name: "cof", scope: !69, file: !3, line: 156, type: !73, isLocal: true, isDefinition: true)
!69 = distinct !DISubprogram(name: "LGamma", scope: !3, file: !3, line: 153, type: !70, scopeLine: 155, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!70 = !DISubroutineType(types: !71)
!71 = !{!7, !7}
!72 = !{}
!73 = !DICompositeType(tag: DW_TAG_array_type, baseType: !74, size: 384, elements: !75)
!74 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !7)
!75 = !{!76}
!76 = !DISubrange(count: 6)
!77 = !DIGlobalVariableExpression(var: !78, expr: !DIExpression())
!78 = distinct !DIGlobalVariable(name: "f", scope: !2, file: !3, line: 28, type: !79, isLocal: true, isDefinition: true)
!79 = !DICompositeType(tag: DW_TAG_array_type, baseType: !80, size: 64000, elements: !81)
!80 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!81 = !{!82}
!82 = !DISubrange(count: 1000)
!83 = !DIGlobalVariableExpression(var: !84, expr: !DIExpression())
!84 = distinct !DIGlobalVariable(name: "r", scope: !2, file: !3, line: 29, type: !6, isLocal: true, isDefinition: true)
!85 = !DIGlobalVariableExpression(var: !86, expr: !DIExpression())
!86 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 30, type: !6, isLocal: true, isDefinition: true)
!87 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 2048, elements: !88)
!88 = !{!89}
!89 = !DISubrange(count: 256)
!90 = !{i32 7, !"Dwarf Version", i32 4}
!91 = !{i32 2, !"Debug Info Version", i32 3}
!92 = !{i32 1, !"wchar_size", i32 4}
!93 = !{i32 7, !"PIC Level", i32 2}
!94 = !{i32 7, !"uwtable", i32 2}
!95 = !{i32 7, !"frame-pointer", i32 1}
!96 = !{!"Homebrew clang version 15.0.3"}
!97 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 43, type: !98, scopeLine: 46, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!98 = !DISubroutineType(types: !99)
!99 = !{!6, !6, !100}
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!102 = !DILocalVariable(name: "argc", arg: 1, scope: !97, file: !3, line: 44, type: !6)
!103 = !DILocation(line: 44, column: 7, scope: !97)
!104 = !DILocalVariable(name: "argv", arg: 2, scope: !97, file: !3, line: 45, type: !100)
!105 = !DILocation(line: 45, column: 9, scope: !97)
!106 = !DILocalVariable(name: "p", scope: !97, file: !3, line: 47, type: !101)
!107 = !DILocation(line: 47, column: 8, scope: !97)
!108 = !DILocalVariable(name: "i", scope: !97, file: !3, line: 48, type: !6)
!109 = !DILocation(line: 48, column: 6, scope: !97)
!110 = !DILocalVariable(name: "j", scope: !97, file: !3, line: 49, type: !6)
!111 = !DILocation(line: 49, column: 6, scope: !97)
!112 = !DILocalVariable(name: "info", scope: !97, file: !3, line: 50, type: !7)
!113 = !DILocation(line: 50, column: 10, scope: !97)
!114 = !DILocalVariable(name: "infodf", scope: !97, file: !3, line: 51, type: !6)
!115 = !DILocation(line: 51, column: 7, scope: !97)
!116 = !DILocalVariable(name: "totinfo", scope: !97, file: !3, line: 52, type: !7)
!117 = !DILocation(line: 52, column: 10, scope: !97)
!118 = !DILocalVariable(name: "totdf", scope: !97, file: !3, line: 53, type: !6)
!119 = !DILocation(line: 53, column: 7, scope: !97)
!120 = !DILocation(line: 55, column: 15, scope: !97)
!121 = !DILocation(line: 57, column: 2, scope: !97)
!122 = !DILocation(line: 57, column: 32, scope: !97)
!123 = !DILocation(line: 57, column: 10, scope: !97)
!124 = !DILocation(line: 57, column: 40, scope: !97)
!125 = !DILocation(line: 59, column: 10, scope: !126)
!126 = distinct !DILexicalBlock(scope: !97, file: !3, line: 58, column: 3)
!127 = !DILocation(line: 60, column: 11, scope: !128)
!128 = distinct !DILexicalBlock(scope: !126, file: !3, line: 60, column: 3)
!129 = !DILocation(line: 60, column: 9, scope: !128)
!130 = !DILocation(line: 60, column: 20, scope: !131)
!131 = distinct !DILexicalBlock(scope: !128, file: !3, line: 60, column: 3)
!132 = !DILocation(line: 60, column: 19, scope: !131)
!133 = !DILocation(line: 60, column: 22, scope: !131)
!134 = !DILocation(line: 60, column: 30, scope: !131)
!135 = !DILocation(line: 60, column: 48, scope: !131)
!136 = !DILocation(line: 60, column: 47, scope: !131)
!137 = !DILocation(line: 60, column: 42, scope: !131)
!138 = !DILocation(line: 60, column: 33, scope: !131)
!139 = !DILocation(line: 0, scope: !131)
!140 = !DILocation(line: 60, column: 3, scope: !128)
!141 = !DILocation(line: 60, column: 53, scope: !131)
!142 = !DILocation(line: 60, column: 3, scope: !131)
!143 = distinct !{!143, !140, !144, !145}
!144 = !DILocation(line: 61, column: 4, scope: !128)
!145 = !{!"llvm.loop.mustprogress"}
!146 = !DILocation(line: 63, column: 9, scope: !147)
!147 = distinct !DILexicalBlock(scope: !126, file: !3, line: 63, column: 8)
!148 = !DILocation(line: 63, column: 8, scope: !147)
!149 = !DILocation(line: 63, column: 11, scope: !147)
!150 = !DILocation(line: 63, column: 8, scope: !126)
!151 = !DILocation(line: 64, column: 4, scope: !147)
!152 = distinct !{!152, !121, !153, !145}
!153 = !DILocation(line: 118, column: 3, scope: !97)
!154 = !DILocation(line: 66, column: 9, scope: !155)
!155 = distinct !DILexicalBlock(scope: !126, file: !3, line: 66, column: 8)
!156 = !DILocation(line: 66, column: 8, scope: !155)
!157 = !DILocation(line: 66, column: 11, scope: !155)
!158 = !DILocation(line: 66, column: 8, scope: !126)
!159 = !DILocation(line: 68, column: 23, scope: !160)
!160 = distinct !DILexicalBlock(scope: !155, file: !3, line: 67, column: 4)
!161 = !DILocation(line: 68, column: 10, scope: !160)
!162 = !DILocation(line: 69, column: 4, scope: !160)
!163 = !DILocation(line: 72, column: 16, scope: !164)
!164 = distinct !DILexicalBlock(scope: !126, file: !3, line: 72, column: 8)
!165 = !DILocation(line: 72, column: 8, scope: !164)
!166 = !DILocation(line: 72, column: 39, scope: !164)
!167 = !DILocation(line: 72, column: 8, scope: !126)
!168 = !DILocation(line: 74, column: 50, scope: !169)
!169 = distinct !DILexicalBlock(scope: !164, file: !3, line: 73, column: 4)
!170 = !DILocation(line: 74, column: 10, scope: !169)
!171 = !DILocation(line: 75, column: 4, scope: !169)
!172 = !DILocation(line: 78, column: 8, scope: !173)
!173 = distinct !DILexicalBlock(scope: !126, file: !3, line: 78, column: 8)
!174 = !DILocation(line: 78, column: 12, scope: !173)
!175 = !DILocation(line: 78, column: 10, scope: !173)
!176 = !DILocation(line: 78, column: 14, scope: !173)
!177 = !DILocation(line: 78, column: 8, scope: !126)
!178 = !DILocation(line: 80, column: 42, scope: !179)
!179 = distinct !DILexicalBlock(scope: !173, file: !3, line: 79, column: 4)
!180 = !DILocation(line: 80, column: 10, scope: !179)
!181 = !DILocation(line: 81, column: 4, scope: !179)
!182 = !DILocation(line: 86, column: 11, scope: !183)
!183 = distinct !DILexicalBlock(scope: !126, file: !3, line: 86, column: 3)
!184 = !DILocation(line: 86, column: 9, scope: !183)
!185 = !DILocation(line: 86, column: 16, scope: !186)
!186 = distinct !DILexicalBlock(scope: !183, file: !3, line: 86, column: 3)
!187 = !DILocation(line: 86, column: 20, scope: !186)
!188 = !DILocation(line: 86, column: 18, scope: !186)
!189 = !DILocation(line: 86, column: 3, scope: !183)
!190 = !DILocation(line: 87, column: 12, scope: !191)
!191 = distinct !DILexicalBlock(scope: !186, file: !3, line: 87, column: 4)
!192 = !DILocation(line: 87, column: 10, scope: !191)
!193 = !DILocation(line: 87, column: 17, scope: !194)
!194 = distinct !DILexicalBlock(scope: !191, file: !3, line: 87, column: 4)
!195 = !DILocation(line: 87, column: 21, scope: !194)
!196 = !DILocation(line: 87, column: 19, scope: !194)
!197 = !DILocation(line: 87, column: 4, scope: !191)
!198 = !DILocation(line: 88, column: 26, scope: !199)
!199 = distinct !DILexicalBlock(scope: !194, file: !3, line: 88, column: 10)
!200 = !DILocation(line: 88, column: 10, scope: !199)
!201 = !DILocation(line: 88, column: 35, scope: !199)
!202 = !DILocation(line: 88, column: 10, scope: !194)
!203 = !DILocation(line: 91, column: 12, scope: !204)
!204 = distinct !DILexicalBlock(scope: !199, file: !3, line: 89, column: 6)
!205 = !DILocation(line: 90, column: 12, scope: !204)
!206 = !DILocation(line: 93, column: 6, scope: !204)
!207 = !DILocation(line: 88, column: 38, scope: !199)
!208 = !DILocation(line: 87, column: 24, scope: !194)
!209 = !DILocation(line: 87, column: 4, scope: !194)
!210 = distinct !{!210, !197, !211, !145}
!211 = !DILocation(line: 94, column: 6, scope: !191)
!212 = !DILocation(line: 86, column: 23, scope: !186)
!213 = !DILocation(line: 86, column: 3, scope: !186)
!214 = distinct !{!214, !189, !215, !145}
!215 = !DILocation(line: 94, column: 6, scope: !183)
!216 = !DILocation(line: 98, column: 19, scope: !126)
!217 = !DILocation(line: 98, column: 22, scope: !126)
!218 = !DILocation(line: 98, column: 10, scope: !126)
!219 = !DILocation(line: 98, column: 8, scope: !126)
!220 = !DILocation(line: 102, column: 8, scope: !221)
!221 = distinct !DILexicalBlock(scope: !126, file: !3, line: 102, column: 8)
!222 = !DILocation(line: 102, column: 13, scope: !221)
!223 = !DILocation(line: 102, column: 8, scope: !126)
!224 = !DILocation(line: 105, column: 11, scope: !225)
!225 = distinct !DILexicalBlock(scope: !221, file: !3, line: 103, column: 4)
!226 = !DILocation(line: 105, column: 17, scope: !225)
!227 = !DILocation(line: 106, column: 19, scope: !225)
!228 = !DILocation(line: 106, column: 25, scope: !225)
!229 = !DILocation(line: 106, column: 11, scope: !225)
!230 = !DILocation(line: 104, column: 10, scope: !225)
!231 = !DILocation(line: 108, column: 15, scope: !225)
!232 = !DILocation(line: 108, column: 12, scope: !225)
!233 = !DILocation(line: 109, column: 13, scope: !225)
!234 = !DILocation(line: 109, column: 10, scope: !225)
!235 = !DILocation(line: 110, column: 4, scope: !225)
!236 = !DILocation(line: 112, column: 17, scope: !221)
!237 = !DILocation(line: 112, column: 22, scope: !221)
!238 = !DILocation(line: 113, column: 10, scope: !221)
!239 = !DILocation(line: 113, column: 15, scope: !221)
!240 = !DILocation(line: 114, column: 10, scope: !221)
!241 = !DILocation(line: 114, column: 15, scope: !221)
!242 = !DILocation(line: 116, column: 10, scope: !221)
!243 = !DILocation(line: 112, column: 10, scope: !221)
!244 = !DILocation(line: 120, column: 7, scope: !245)
!245 = distinct !DILexicalBlock(scope: !97, file: !3, line: 120, column: 7)
!246 = !DILocation(line: 120, column: 13, scope: !245)
!247 = !DILocation(line: 120, column: 7, scope: !97)
!248 = !DILocation(line: 122, column: 58, scope: !249)
!249 = distinct !DILexicalBlock(scope: !245, file: !3, line: 121, column: 3)
!250 = !DILocation(line: 122, column: 9, scope: !249)
!251 = !DILocation(line: 123, column: 3, scope: !249)
!252 = !DILocation(line: 127, column: 9, scope: !97)
!253 = !DILocation(line: 127, column: 18, scope: !97)
!254 = !DILocation(line: 128, column: 17, scope: !97)
!255 = !DILocation(line: 128, column: 26, scope: !97)
!256 = !DILocation(line: 128, column: 9, scope: !97)
!257 = !DILocation(line: 126, column: 8, scope: !97)
!258 = !DILocation(line: 130, column: 2, scope: !97)
!259 = !DILocation(line: 131, column: 2, scope: !97)
!260 = distinct !DISubprogram(name: "InfoTbl", scope: !3, file: !3, line: 296, type: !261, scopeLine: 301, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!261 = !DISubroutineType(types: !262)
!262 = !{!7, !6, !6, !263, !265}
!263 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !264, size: 64)
!264 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !80)
!265 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!266 = !DILocalVariable(name: "r", arg: 1, scope: !260, file: !3, line: 297, type: !6)
!267 = !DILocation(line: 297, column: 7, scope: !260)
!268 = !DILocalVariable(name: "c", arg: 2, scope: !260, file: !3, line: 298, type: !6)
!269 = !DILocation(line: 298, column: 7, scope: !260)
!270 = !DILocalVariable(name: "f", arg: 3, scope: !260, file: !3, line: 299, type: !263)
!271 = !DILocation(line: 299, column: 14, scope: !260)
!272 = !DILocalVariable(name: "pdf", arg: 4, scope: !260, file: !3, line: 300, type: !265)
!273 = !DILocation(line: 300, column: 8, scope: !260)
!274 = !DILocalVariable(name: "i", scope: !260, file: !3, line: 302, type: !6)
!275 = !DILocation(line: 302, column: 6, scope: !260)
!276 = !DILocalVariable(name: "j", scope: !260, file: !3, line: 303, type: !6)
!277 = !DILocation(line: 303, column: 6, scope: !260)
!278 = !DILocalVariable(name: "N", scope: !260, file: !3, line: 304, type: !7)
!279 = !DILocation(line: 304, column: 10, scope: !260)
!280 = !DILocalVariable(name: "info", scope: !260, file: !3, line: 305, type: !7)
!281 = !DILocation(line: 305, column: 10, scope: !260)
!282 = !DILocalVariable(name: "xi", scope: !260, file: !3, line: 306, type: !8)
!283 = !DILocation(line: 306, column: 11, scope: !260)
!284 = !DILocalVariable(name: "xj", scope: !260, file: !3, line: 307, type: !8)
!285 = !DILocation(line: 307, column: 11, scope: !260)
!286 = !DILocalVariable(name: "rdf", scope: !260, file: !3, line: 308, type: !6)
!287 = !DILocation(line: 308, column: 7, scope: !260)
!288 = !DILocation(line: 308, column: 13, scope: !260)
!289 = !DILocation(line: 308, column: 15, scope: !260)
!290 = !DILocalVariable(name: "cdf", scope: !260, file: !3, line: 309, type: !6)
!291 = !DILocation(line: 309, column: 7, scope: !260)
!292 = !DILocation(line: 309, column: 13, scope: !260)
!293 = !DILocation(line: 309, column: 15, scope: !260)
!294 = !DILocation(line: 311, column: 7, scope: !295)
!295 = distinct !DILexicalBlock(scope: !260, file: !3, line: 311, column: 7)
!296 = !DILocation(line: 311, column: 11, scope: !295)
!297 = !DILocation(line: 311, column: 16, scope: !295)
!298 = !DILocation(line: 311, column: 19, scope: !295)
!299 = !DILocation(line: 311, column: 23, scope: !295)
!300 = !DILocation(line: 311, column: 7, scope: !260)
!301 = !DILocation(line: 313, column: 8, scope: !302)
!302 = distinct !DILexicalBlock(scope: !295, file: !3, line: 312, column: 3)
!303 = !DILocation(line: 314, column: 3, scope: !302)
!304 = !DILocation(line: 317, column: 9, scope: !260)
!305 = !DILocation(line: 317, column: 15, scope: !260)
!306 = !DILocation(line: 317, column: 13, scope: !260)
!307 = !DILocation(line: 317, column: 3, scope: !260)
!308 = !DILocation(line: 317, column: 7, scope: !260)
!309 = !DILocation(line: 319, column: 31, scope: !310)
!310 = distinct !DILexicalBlock(scope: !260, file: !3, line: 319, column: 7)
!311 = !DILocation(line: 319, column: 33, scope: !310)
!312 = !DILocation(line: 319, column: 23, scope: !310)
!313 = !DILocation(line: 319, column: 11, scope: !310)
!314 = !DILocation(line: 319, column: 53, scope: !310)
!315 = !DILocation(line: 319, column: 7, scope: !260)
!316 = !DILocation(line: 321, column: 8, scope: !317)
!317 = distinct !DILexicalBlock(scope: !310, file: !3, line: 320, column: 3)
!318 = !DILocation(line: 322, column: 3, scope: !317)
!319 = !DILocation(line: 325, column: 31, scope: !320)
!320 = distinct !DILexicalBlock(scope: !260, file: !3, line: 325, column: 7)
!321 = !DILocation(line: 325, column: 33, scope: !320)
!322 = !DILocation(line: 325, column: 23, scope: !320)
!323 = !DILocation(line: 325, column: 11, scope: !320)
!324 = !DILocation(line: 325, column: 53, scope: !320)
!325 = !DILocation(line: 325, column: 7, scope: !260)
!326 = !DILocation(line: 327, column: 8, scope: !327)
!327 = distinct !DILexicalBlock(scope: !320, file: !3, line: 326, column: 3)
!328 = !DILocation(line: 328, column: 3, scope: !327)
!329 = !DILocation(line: 333, column: 4, scope: !260)
!330 = !DILocation(line: 335, column: 10, scope: !331)
!331 = distinct !DILexicalBlock(scope: !260, file: !3, line: 335, column: 2)
!332 = !DILocation(line: 335, column: 8, scope: !331)
!333 = !DILocation(line: 335, column: 15, scope: !334)
!334 = distinct !DILexicalBlock(scope: !331, file: !3, line: 335, column: 2)
!335 = !DILocation(line: 335, column: 19, scope: !334)
!336 = !DILocation(line: 335, column: 17, scope: !334)
!337 = !DILocation(line: 335, column: 2, scope: !331)
!338 = !DILocalVariable(name: "sum", scope: !339, file: !3, line: 337, type: !7)
!339 = distinct !DILexicalBlock(scope: !334, file: !3, line: 336, column: 3)
!340 = !DILocation(line: 337, column: 10, scope: !339)
!341 = !DILocation(line: 339, column: 11, scope: !342)
!342 = distinct !DILexicalBlock(scope: !339, file: !3, line: 339, column: 3)
!343 = !DILocation(line: 339, column: 9, scope: !342)
!344 = !DILocation(line: 339, column: 16, scope: !345)
!345 = distinct !DILexicalBlock(scope: !342, file: !3, line: 339, column: 3)
!346 = !DILocation(line: 339, column: 20, scope: !345)
!347 = !DILocation(line: 339, column: 18, scope: !345)
!348 = !DILocation(line: 339, column: 3, scope: !342)
!349 = !DILocalVariable(name: "k", scope: !350, file: !3, line: 341, type: !80)
!350 = distinct !DILexicalBlock(scope: !345, file: !3, line: 340, column: 4)
!351 = !DILocation(line: 341, column: 9, scope: !350)
!352 = !DILocation(line: 341, column: 13, scope: !350)
!353 = !DILocation(line: 343, column: 9, scope: !354)
!354 = distinct !DILexicalBlock(scope: !350, file: !3, line: 343, column: 9)
!355 = !DILocation(line: 343, column: 11, scope: !354)
!356 = !DILocation(line: 343, column: 9, scope: !350)
!357 = !DILocation(line: 345, column: 10, scope: !358)
!358 = distinct !DILexicalBlock(scope: !354, file: !3, line: 344, column: 5)
!359 = !DILocation(line: 346, column: 5, scope: !358)
!360 = !DILocation(line: 349, column: 19, scope: !350)
!361 = !DILocation(line: 349, column: 11, scope: !350)
!362 = !DILocation(line: 349, column: 8, scope: !350)
!363 = !DILocation(line: 350, column: 4, scope: !350)
!364 = !DILocation(line: 339, column: 23, scope: !345)
!365 = !DILocation(line: 339, column: 3, scope: !345)
!366 = distinct !{!366, !348, !367, !145}
!367 = !DILocation(line: 350, column: 4, scope: !342)
!368 = !DILocation(line: 352, column: 16, scope: !339)
!369 = !DILocation(line: 352, column: 8, scope: !339)
!370 = !DILocation(line: 352, column: 11, scope: !339)
!371 = !DILocation(line: 352, column: 14, scope: !339)
!372 = !DILocation(line: 352, column: 5, scope: !339)
!373 = !DILocation(line: 353, column: 3, scope: !339)
!374 = !DILocation(line: 335, column: 22, scope: !334)
!375 = !DILocation(line: 335, column: 2, scope: !334)
!376 = distinct !{!376, !337, !377, !145}
!377 = !DILocation(line: 353, column: 3, scope: !331)
!378 = !DILocation(line: 355, column: 7, scope: !379)
!379 = distinct !DILexicalBlock(scope: !260, file: !3, line: 355, column: 7)
!380 = !DILocation(line: 355, column: 9, scope: !379)
!381 = !DILocation(line: 355, column: 7, scope: !260)
!382 = !DILocation(line: 357, column: 8, scope: !383)
!383 = distinct !DILexicalBlock(scope: !379, file: !3, line: 356, column: 3)
!384 = !DILocation(line: 358, column: 3, scope: !383)
!385 = !DILocation(line: 363, column: 10, scope: !386)
!386 = distinct !DILexicalBlock(scope: !260, file: !3, line: 363, column: 2)
!387 = !DILocation(line: 363, column: 8, scope: !386)
!388 = !DILocation(line: 363, column: 15, scope: !389)
!389 = distinct !DILexicalBlock(scope: !386, file: !3, line: 363, column: 2)
!390 = !DILocation(line: 363, column: 19, scope: !389)
!391 = !DILocation(line: 363, column: 17, scope: !389)
!392 = !DILocation(line: 363, column: 2, scope: !386)
!393 = !DILocalVariable(name: "sum", scope: !394, file: !3, line: 365, type: !7)
!394 = distinct !DILexicalBlock(scope: !389, file: !3, line: 364, column: 3)
!395 = !DILocation(line: 365, column: 10, scope: !394)
!396 = !DILocation(line: 367, column: 11, scope: !397)
!397 = distinct !DILexicalBlock(scope: !394, file: !3, line: 367, column: 3)
!398 = !DILocation(line: 367, column: 9, scope: !397)
!399 = !DILocation(line: 367, column: 16, scope: !400)
!400 = distinct !DILexicalBlock(scope: !397, file: !3, line: 367, column: 3)
!401 = !DILocation(line: 367, column: 20, scope: !400)
!402 = !DILocation(line: 367, column: 18, scope: !400)
!403 = !DILocation(line: 367, column: 3, scope: !397)
!404 = !DILocation(line: 368, column: 19, scope: !400)
!405 = !DILocation(line: 368, column: 11, scope: !400)
!406 = !DILocation(line: 368, column: 8, scope: !400)
!407 = !DILocation(line: 368, column: 4, scope: !400)
!408 = !DILocation(line: 367, column: 23, scope: !400)
!409 = !DILocation(line: 367, column: 3, scope: !400)
!410 = distinct !{!410, !403, !411, !145}
!411 = !DILocation(line: 368, column: 19, scope: !397)
!412 = !DILocation(line: 370, column: 11, scope: !394)
!413 = !DILocation(line: 370, column: 3, scope: !394)
!414 = !DILocation(line: 370, column: 6, scope: !394)
!415 = !DILocation(line: 370, column: 9, scope: !394)
!416 = !DILocation(line: 371, column: 3, scope: !394)
!417 = !DILocation(line: 363, column: 22, scope: !389)
!418 = !DILocation(line: 363, column: 2, scope: !389)
!419 = distinct !{!419, !392, !420, !145}
!420 = !DILocation(line: 371, column: 3, scope: !386)
!421 = !DILocation(line: 375, column: 9, scope: !260)
!422 = !DILocation(line: 375, column: 18, scope: !260)
!423 = !DILocation(line: 375, column: 13, scope: !260)
!424 = !DILocation(line: 375, column: 11, scope: !260)
!425 = !DILocation(line: 375, column: 7, scope: !260)
!426 = !DILocation(line: 377, column: 10, scope: !427)
!427 = distinct !DILexicalBlock(scope: !260, file: !3, line: 377, column: 2)
!428 = !DILocation(line: 377, column: 8, scope: !427)
!429 = !DILocation(line: 377, column: 15, scope: !430)
!430 = distinct !DILexicalBlock(scope: !427, file: !3, line: 377, column: 2)
!431 = !DILocation(line: 377, column: 19, scope: !430)
!432 = !DILocation(line: 377, column: 17, scope: !430)
!433 = !DILocation(line: 377, column: 2, scope: !427)
!434 = !DILocalVariable(name: "pi", scope: !435, file: !3, line: 379, type: !7)
!435 = distinct !DILexicalBlock(scope: !430, file: !3, line: 378, column: 3)
!436 = !DILocation(line: 379, column: 10, scope: !435)
!437 = !DILocation(line: 379, column: 15, scope: !435)
!438 = !DILocation(line: 379, column: 18, scope: !435)
!439 = !DILocation(line: 381, column: 8, scope: !440)
!440 = distinct !DILexicalBlock(scope: !435, file: !3, line: 381, column: 8)
!441 = !DILocation(line: 381, column: 11, scope: !440)
!442 = !DILocation(line: 381, column: 8, scope: !435)
!443 = !DILocation(line: 382, column: 12, scope: !440)
!444 = !DILocation(line: 382, column: 22, scope: !440)
!445 = !DILocation(line: 382, column: 17, scope: !440)
!446 = !DILocation(line: 382, column: 9, scope: !440)
!447 = !DILocation(line: 382, column: 4, scope: !440)
!448 = !DILocation(line: 384, column: 11, scope: !449)
!449 = distinct !DILexicalBlock(scope: !435, file: !3, line: 384, column: 3)
!450 = !DILocation(line: 384, column: 9, scope: !449)
!451 = !DILocation(line: 384, column: 16, scope: !452)
!452 = distinct !DILexicalBlock(scope: !449, file: !3, line: 384, column: 3)
!453 = !DILocation(line: 384, column: 20, scope: !452)
!454 = !DILocation(line: 384, column: 18, scope: !452)
!455 = !DILocation(line: 384, column: 3, scope: !449)
!456 = !DILocalVariable(name: "pij", scope: !457, file: !3, line: 386, type: !7)
!457 = distinct !DILexicalBlock(scope: !452, file: !3, line: 385, column: 4)
!458 = !DILocation(line: 386, column: 11, scope: !457)
!459 = !DILocation(line: 386, column: 25, scope: !457)
!460 = !DILocation(line: 386, column: 17, scope: !457)
!461 = !DILocation(line: 388, column: 9, scope: !462)
!462 = distinct !DILexicalBlock(scope: !457, file: !3, line: 388, column: 9)
!463 = !DILocation(line: 388, column: 13, scope: !462)
!464 = !DILocation(line: 388, column: 9, scope: !457)
!465 = !DILocation(line: 389, column: 13, scope: !462)
!466 = !DILocation(line: 389, column: 24, scope: !462)
!467 = !DILocation(line: 389, column: 19, scope: !462)
!468 = !DILocation(line: 389, column: 10, scope: !462)
!469 = !DILocation(line: 389, column: 5, scope: !462)
!470 = !DILocation(line: 390, column: 4, scope: !457)
!471 = !DILocation(line: 384, column: 23, scope: !452)
!472 = !DILocation(line: 384, column: 3, scope: !452)
!473 = distinct !{!473, !455, !474, !145}
!474 = !DILocation(line: 390, column: 4, scope: !449)
!475 = !DILocation(line: 391, column: 3, scope: !435)
!476 = !DILocation(line: 377, column: 22, scope: !430)
!477 = !DILocation(line: 377, column: 2, scope: !430)
!478 = distinct !{!478, !433, !479, !145}
!479 = !DILocation(line: 391, column: 3, scope: !427)
!480 = !DILocation(line: 393, column: 10, scope: !481)
!481 = distinct !DILexicalBlock(scope: !260, file: !3, line: 393, column: 2)
!482 = !DILocation(line: 393, column: 8, scope: !481)
!483 = !DILocation(line: 393, column: 15, scope: !484)
!484 = distinct !DILexicalBlock(scope: !481, file: !3, line: 393, column: 2)
!485 = !DILocation(line: 393, column: 19, scope: !484)
!486 = !DILocation(line: 393, column: 17, scope: !484)
!487 = !DILocation(line: 393, column: 2, scope: !481)
!488 = !DILocalVariable(name: "pj", scope: !489, file: !3, line: 395, type: !7)
!489 = distinct !DILexicalBlock(scope: !484, file: !3, line: 394, column: 3)
!490 = !DILocation(line: 395, column: 10, scope: !489)
!491 = !DILocation(line: 395, column: 15, scope: !489)
!492 = !DILocation(line: 395, column: 18, scope: !489)
!493 = !DILocation(line: 397, column: 8, scope: !494)
!494 = distinct !DILexicalBlock(scope: !489, file: !3, line: 397, column: 8)
!495 = !DILocation(line: 397, column: 11, scope: !494)
!496 = !DILocation(line: 397, column: 8, scope: !489)
!497 = !DILocation(line: 398, column: 12, scope: !494)
!498 = !DILocation(line: 398, column: 22, scope: !494)
!499 = !DILocation(line: 398, column: 17, scope: !494)
!500 = !DILocation(line: 398, column: 9, scope: !494)
!501 = !DILocation(line: 398, column: 4, scope: !494)
!502 = !DILocation(line: 399, column: 3, scope: !489)
!503 = !DILocation(line: 393, column: 22, scope: !484)
!504 = !DILocation(line: 393, column: 2, scope: !484)
!505 = distinct !{!505, !487, !506, !145}
!506 = !DILocation(line: 399, column: 3, scope: !481)
!507 = !DILocation(line: 401, column: 7, scope: !260)
!508 = !DILocation(line: 401, column: 2, scope: !260)
!509 = !DILabel(scope: !260, name: "ret1", file: !3, line: 403)
!510 = !DILocation(line: 403, column: 5, scope: !260)
!511 = !DILocation(line: 404, column: 17, scope: !260)
!512 = !DILocation(line: 404, column: 2, scope: !260)
!513 = !DILabel(scope: !260, name: "ret2", file: !3, line: 405)
!514 = !DILocation(line: 405, column: 5, scope: !260)
!515 = !DILocation(line: 406, column: 17, scope: !260)
!516 = !DILocation(line: 406, column: 2, scope: !260)
!517 = !DILabel(scope: !260, name: "ret3", file: !3, line: 407)
!518 = !DILocation(line: 407, column: 5, scope: !260)
!519 = !DILocation(line: 408, column: 9, scope: !260)
!520 = !DILocation(line: 408, column: 2, scope: !260)
!521 = distinct !DISubprogram(name: "QChiSq", scope: !3, file: !3, line: 255, type: !522, scopeLine: 258, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!522 = !DISubroutineType(types: !523)
!523 = !{!7, !7, !6}
!524 = !DILocalVariable(name: "chisq", arg: 1, scope: !521, file: !3, line: 256, type: !7)
!525 = !DILocation(line: 256, column: 9, scope: !521)
!526 = !DILocalVariable(name: "df", arg: 2, scope: !521, file: !3, line: 257, type: !6)
!527 = !DILocation(line: 257, column: 6, scope: !521)
!528 = !DILocation(line: 259, column: 25, scope: !521)
!529 = !DILocation(line: 259, column: 17, scope: !521)
!530 = !DILocation(line: 259, column: 28, scope: !521)
!531 = !DILocation(line: 259, column: 35, scope: !521)
!532 = !DILocation(line: 259, column: 41, scope: !521)
!533 = !DILocation(line: 259, column: 9, scope: !521)
!534 = !DILocation(line: 259, column: 2, scope: !521)
!535 = !DILocalVariable(name: "x", arg: 1, scope: !69, file: !3, line: 154, type: !7)
!536 = !DILocation(line: 154, column: 11, scope: !69)
!537 = !DILocalVariable(name: "tmp", scope: !69, file: !3, line: 161, type: !7)
!538 = !DILocation(line: 161, column: 11, scope: !69)
!539 = !DILocalVariable(name: "ser", scope: !69, file: !3, line: 161, type: !7)
!540 = !DILocation(line: 161, column: 16, scope: !69)
!541 = !DILocalVariable(name: "j", scope: !69, file: !3, line: 162, type: !6)
!542 = !DILocation(line: 162, column: 7, scope: !69)
!543 = !DILocation(line: 165, column: 7, scope: !544)
!544 = distinct !DILexicalBlock(scope: !69, file: !3, line: 165, column: 7)
!545 = !DILocation(line: 165, column: 11, scope: !544)
!546 = !DILocation(line: 165, column: 7, scope: !69)
!547 = !DILocalVariable(name: "pix", scope: !548, file: !3, line: 167, type: !7)
!548 = distinct !DILexicalBlock(scope: !544, file: !3, line: 166, column: 3)
!549 = !DILocation(line: 167, column: 10, scope: !548)
!550 = !DILocation(line: 167, column: 21, scope: !548)
!551 = !DILocation(line: 167, column: 19, scope: !548)
!552 = !DILocation(line: 169, column: 15, scope: !548)
!553 = !DILocation(line: 169, column: 26, scope: !548)
!554 = !DILocation(line: 169, column: 21, scope: !548)
!555 = !DILocation(line: 169, column: 19, scope: !548)
!556 = !DILocation(line: 169, column: 10, scope: !548)
!557 = !DILocation(line: 169, column: 50, scope: !548)
!558 = !DILocation(line: 169, column: 48, scope: !548)
!559 = !DILocation(line: 169, column: 36, scope: !548)
!560 = !DILocation(line: 169, column: 34, scope: !548)
!561 = !DILocation(line: 169, column: 3, scope: !548)
!562 = !DILocation(line: 172, column: 8, scope: !69)
!563 = !DILocation(line: 172, column: 10, scope: !69)
!564 = !DILocation(line: 172, column: 6, scope: !69)
!565 = !DILocation(line: 173, column: 10, scope: !69)
!566 = !DILocation(line: 173, column: 12, scope: !69)
!567 = !DILocation(line: 173, column: 26, scope: !69)
!568 = !DILocation(line: 173, column: 21, scope: !69)
!569 = !DILocation(line: 173, column: 6, scope: !69)
!570 = !DILocation(line: 175, column: 6, scope: !69)
!571 = !DILocation(line: 177, column: 10, scope: !572)
!572 = distinct !DILexicalBlock(scope: !69, file: !3, line: 177, column: 2)
!573 = !DILocation(line: 177, column: 8, scope: !572)
!574 = !DILocation(line: 177, column: 15, scope: !575)
!575 = distinct !DILexicalBlock(scope: !572, file: !3, line: 177, column: 2)
!576 = !DILocation(line: 177, column: 17, scope: !575)
!577 = !DILocation(line: 177, column: 2, scope: !572)
!578 = !DILocation(line: 178, column: 14, scope: !575)
!579 = !DILocation(line: 178, column: 10, scope: !575)
!580 = !DILocation(line: 178, column: 19, scope: !575)
!581 = !DILocation(line: 178, column: 17, scope: !575)
!582 = !DILocation(line: 178, column: 7, scope: !575)
!583 = !DILocation(line: 178, column: 3, scope: !575)
!584 = !DILocation(line: 177, column: 22, scope: !575)
!585 = !DILocation(line: 177, column: 2, scope: !575)
!586 = distinct !{!586, !577, !587, !145}
!587 = !DILocation(line: 178, column: 21, scope: !572)
!588 = !DILocation(line: 180, column: 10, scope: !69)
!589 = !DILocation(line: 180, column: 9, scope: !69)
!590 = !DILocation(line: 180, column: 37, scope: !69)
!591 = !DILocation(line: 180, column: 35, scope: !69)
!592 = !DILocation(line: 180, column: 16, scope: !69)
!593 = !DILocation(line: 180, column: 14, scope: !69)
!594 = !DILocation(line: 180, column: 2, scope: !69)
!595 = !DILocation(line: 181, column: 2, scope: !69)
!596 = distinct !DISubprogram(name: "QGamma", scope: !3, file: !3, line: 247, type: !597, scopeLine: 249, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!597 = !DISubroutineType(types: !598)
!598 = !{!7, !7, !7}
!599 = !DILocalVariable(name: "a", arg: 1, scope: !596, file: !3, line: 248, type: !7)
!600 = !DILocation(line: 248, column: 9, scope: !596)
!601 = !DILocalVariable(name: "x", arg: 2, scope: !596, file: !3, line: 248, type: !7)
!602 = !DILocation(line: 248, column: 12, scope: !596)
!603 = !DILocation(line: 251, column: 9, scope: !596)
!604 = !DILocation(line: 251, column: 13, scope: !596)
!605 = !DILocation(line: 251, column: 15, scope: !596)
!606 = !DILocation(line: 251, column: 11, scope: !596)
!607 = !DILocation(line: 251, column: 35, scope: !596)
!608 = !DILocation(line: 251, column: 38, scope: !596)
!609 = !DILocation(line: 251, column: 29, scope: !596)
!610 = !DILocation(line: 251, column: 27, scope: !596)
!611 = !DILocation(line: 251, column: 49, scope: !596)
!612 = !DILocation(line: 251, column: 52, scope: !596)
!613 = !DILocation(line: 251, column: 44, scope: !596)
!614 = !DILocation(line: 251, column: 2, scope: !596)
!615 = distinct !DISubprogram(name: "gser", scope: !3, file: !3, line: 187, type: !597, scopeLine: 189, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !72)
!616 = !DILocalVariable(name: "a", arg: 1, scope: !615, file: !3, line: 188, type: !7)
!617 = !DILocation(line: 188, column: 10, scope: !615)
!618 = !DILocalVariable(name: "x", arg: 2, scope: !615, file: !3, line: 188, type: !7)
!619 = !DILocation(line: 188, column: 13, scope: !615)
!620 = !DILocalVariable(name: "ap", scope: !615, file: !3, line: 190, type: !7)
!621 = !DILocation(line: 190, column: 10, scope: !615)
!622 = !DILocalVariable(name: "del", scope: !615, file: !3, line: 190, type: !7)
!623 = !DILocation(line: 190, column: 14, scope: !615)
!624 = !DILocalVariable(name: "sum", scope: !615, file: !3, line: 190, type: !7)
!625 = !DILocation(line: 190, column: 19, scope: !615)
!626 = !DILocalVariable(name: "n", scope: !615, file: !3, line: 191, type: !6)
!627 = !DILocation(line: 191, column: 6, scope: !615)
!628 = !DILocation(line: 194, column: 7, scope: !629)
!629 = distinct !DILexicalBlock(scope: !615, file: !3, line: 194, column: 7)
!630 = !DILocation(line: 194, column: 9, scope: !629)
!631 = !DILocation(line: 194, column: 7, scope: !615)
!632 = !DILocation(line: 195, column: 3, scope: !629)
!633 = !DILocation(line: 197, column: 26, scope: !615)
!634 = !DILocation(line: 197, column: 24, scope: !615)
!635 = !DILocation(line: 197, column: 18, scope: !615)
!636 = !DILocation(line: 197, column: 12, scope: !615)
!637 = !DILocation(line: 197, column: 6, scope: !615)
!638 = !DILocation(line: 199, column: 10, scope: !639)
!639 = distinct !DILexicalBlock(scope: !615, file: !3, line: 199, column: 2)
!640 = !DILocation(line: 199, column: 8, scope: !639)
!641 = !DILocation(line: 199, column: 15, scope: !642)
!642 = distinct !DILexicalBlock(scope: !639, file: !3, line: 199, column: 2)
!643 = !DILocation(line: 199, column: 17, scope: !642)
!644 = !DILocation(line: 199, column: 2, scope: !639)
!645 = !DILocation(line: 201, column: 17, scope: !646)
!646 = distinct !DILexicalBlock(scope: !642, file: !3, line: 200, column: 3)
!647 = !DILocation(line: 201, column: 21, scope: !646)
!648 = !DILocation(line: 201, column: 19, scope: !646)
!649 = !DILocation(line: 201, column: 14, scope: !646)
!650 = !DILocation(line: 201, column: 7, scope: !646)
!651 = !DILocation(line: 203, column: 8, scope: !652)
!652 = distinct !DILexicalBlock(scope: !646, file: !3, line: 203, column: 8)
!653 = !DILocation(line: 203, column: 21, scope: !652)
!654 = !DILocation(line: 203, column: 32, scope: !652)
!655 = !DILocation(line: 203, column: 19, scope: !652)
!656 = !DILocation(line: 203, column: 8, scope: !646)
!657 = !DILocation(line: 204, column: 11, scope: !652)
!658 = !DILocation(line: 204, column: 23, scope: !652)
!659 = !DILocation(line: 204, column: 22, scope: !652)
!660 = !DILocation(line: 204, column: 27, scope: !652)
!661 = !DILocation(line: 204, column: 36, scope: !652)
!662 = !DILocation(line: 204, column: 31, scope: !652)
!663 = !DILocation(line: 204, column: 25, scope: !652)
!664 = !DILocation(line: 204, column: 50, scope: !652)
!665 = !DILocation(line: 204, column: 42, scope: !652)
!666 = !DILocation(line: 204, column: 40, scope: !652)
!667 = !DILocation(line: 204, column: 17, scope: !652)
!668 = !DILocation(line: 204, column: 15, scope: !652)
!669 = !DILocation(line: 204, column: 4, scope: !652)
!670 = !DILocation(line: 205, column: 3, scope: !646)
!671 = !DILocation(line: 199, column: 27, scope: !642)
!672 = !DILocation(line: 199, column: 2, scope: !642)
!673 = distinct !{!673, !644, !674, !145}
!674 = !DILocation(line: 205, column: 3, scope: !639)
!675 = !DILocation(line: 208, column: 2, scope: !615)
!676 = distinct !DISubprogram(name: "gcf", scope: !3, file: !3, line: 211, type: !597, scopeLine: 213, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !72)
!677 = !DILocalVariable(name: "a", arg: 1, scope: !676, file: !3, line: 212, type: !7)
!678 = !DILocation(line: 212, column: 10, scope: !676)
!679 = !DILocalVariable(name: "x", arg: 2, scope: !676, file: !3, line: 212, type: !7)
!680 = !DILocation(line: 212, column: 13, scope: !676)
!681 = !DILocalVariable(name: "n", scope: !676, file: !3, line: 214, type: !6)
!682 = !DILocation(line: 214, column: 6, scope: !676)
!683 = !DILocalVariable(name: "gold", scope: !676, file: !3, line: 215, type: !7)
!684 = !DILocation(line: 215, column: 10, scope: !676)
!685 = !DILocalVariable(name: "fac", scope: !676, file: !3, line: 215, type: !7)
!686 = !DILocation(line: 215, column: 22, scope: !676)
!687 = !DILocalVariable(name: "b1", scope: !676, file: !3, line: 215, type: !7)
!688 = !DILocation(line: 215, column: 33, scope: !676)
!689 = !DILocalVariable(name: "b0", scope: !676, file: !3, line: 216, type: !7)
!690 = !DILocation(line: 216, column: 4, scope: !676)
!691 = !DILocalVariable(name: "a0", scope: !676, file: !3, line: 216, type: !7)
!692 = !DILocation(line: 216, column: 14, scope: !676)
!693 = !DILocalVariable(name: "a1", scope: !676, file: !3, line: 216, type: !7)
!694 = !DILocation(line: 216, column: 24, scope: !676)
!695 = !DILocation(line: 216, column: 29, scope: !676)
!696 = !DILocation(line: 218, column: 10, scope: !697)
!697 = distinct !DILexicalBlock(scope: !676, file: !3, line: 218, column: 2)
!698 = !DILocation(line: 218, column: 8, scope: !697)
!699 = !DILocation(line: 218, column: 15, scope: !700)
!700 = distinct !DILexicalBlock(scope: !697, file: !3, line: 218, column: 2)
!701 = !DILocation(line: 218, column: 17, scope: !700)
!702 = !DILocation(line: 218, column: 2, scope: !697)
!703 = !DILocalVariable(name: "anf", scope: !704, file: !3, line: 220, type: !7)
!704 = distinct !DILexicalBlock(scope: !700, file: !3, line: 219, column: 3)
!705 = !DILocation(line: 220, column: 10, scope: !704)
!706 = !DILocalVariable(name: "an", scope: !704, file: !3, line: 221, type: !7)
!707 = !DILocation(line: 221, column: 10, scope: !704)
!708 = !DILocation(line: 221, column: 23, scope: !704)
!709 = !DILocation(line: 221, column: 15, scope: !704)
!710 = !DILocalVariable(name: "ana", scope: !704, file: !3, line: 222, type: !7)
!711 = !DILocation(line: 222, column: 10, scope: !704)
!712 = !DILocation(line: 222, column: 16, scope: !704)
!713 = !DILocation(line: 222, column: 21, scope: !704)
!714 = !DILocation(line: 222, column: 19, scope: !704)
!715 = !DILocation(line: 224, column: 9, scope: !704)
!716 = !DILocation(line: 224, column: 14, scope: !704)
!717 = !DILocation(line: 224, column: 19, scope: !704)
!718 = !DILocation(line: 224, column: 12, scope: !704)
!719 = !DILocation(line: 224, column: 26, scope: !704)
!720 = !DILocation(line: 224, column: 24, scope: !704)
!721 = !DILocation(line: 224, column: 6, scope: !704)
!722 = !DILocation(line: 225, column: 9, scope: !704)
!723 = !DILocation(line: 225, column: 14, scope: !704)
!724 = !DILocation(line: 225, column: 19, scope: !704)
!725 = !DILocation(line: 225, column: 12, scope: !704)
!726 = !DILocation(line: 225, column: 26, scope: !704)
!727 = !DILocation(line: 225, column: 24, scope: !704)
!728 = !DILocation(line: 225, column: 6, scope: !704)
!729 = !DILocation(line: 226, column: 9, scope: !704)
!730 = !DILocation(line: 226, column: 14, scope: !704)
!731 = !DILocation(line: 226, column: 12, scope: !704)
!732 = !DILocation(line: 226, column: 7, scope: !704)
!733 = !DILocation(line: 227, column: 8, scope: !704)
!734 = !DILocation(line: 227, column: 12, scope: !704)
!735 = !DILocation(line: 227, column: 17, scope: !704)
!736 = !DILocation(line: 227, column: 23, scope: !704)
!737 = !DILocation(line: 227, column: 21, scope: !704)
!738 = !DILocation(line: 227, column: 15, scope: !704)
!739 = !DILocation(line: 227, column: 6, scope: !704)
!740 = !DILocation(line: 228, column: 8, scope: !704)
!741 = !DILocation(line: 228, column: 12, scope: !704)
!742 = !DILocation(line: 228, column: 17, scope: !704)
!743 = !DILocation(line: 228, column: 23, scope: !704)
!744 = !DILocation(line: 228, column: 21, scope: !704)
!745 = !DILocation(line: 228, column: 15, scope: !704)
!746 = !DILocation(line: 228, column: 6, scope: !704)
!747 = !DILocation(line: 230, column: 8, scope: !748)
!748 = distinct !DILexicalBlock(scope: !704, file: !3, line: 230, column: 8)
!749 = !DILocation(line: 230, column: 11, scope: !748)
!750 = !DILocation(line: 230, column: 8, scope: !704)
!751 = !DILocalVariable(name: "g", scope: !752, file: !3, line: 232, type: !7)
!752 = distinct !DILexicalBlock(scope: !748, file: !3, line: 231, column: 4)
!753 = !DILocation(line: 232, column: 11, scope: !752)
!754 = !DILocation(line: 232, column: 15, scope: !752)
!755 = !DILocation(line: 232, column: 33, scope: !752)
!756 = !DILocation(line: 232, column: 31, scope: !752)
!757 = !DILocation(line: 232, column: 25, scope: !752)
!758 = !DILocation(line: 232, column: 18, scope: !752)
!759 = !DILocation(line: 234, column: 11, scope: !752)
!760 = !DILocation(line: 234, column: 15, scope: !752)
!761 = !DILocation(line: 234, column: 13, scope: !752)
!762 = !DILocation(line: 234, column: 9, scope: !752)
!763 = !DILocation(line: 236, column: 9, scope: !764)
!764 = distinct !DILexicalBlock(scope: !752, file: !3, line: 236, column: 9)
!765 = !DILocation(line: 236, column: 29, scope: !764)
!766 = !DILocation(line: 236, column: 27, scope: !764)
!767 = !DILocation(line: 236, column: 21, scope: !764)
!768 = !DILocation(line: 236, column: 9, scope: !752)
!769 = !DILocation(line: 237, column: 18, scope: !764)
!770 = !DILocation(line: 237, column: 17, scope: !764)
!771 = !DILocation(line: 237, column: 22, scope: !764)
!772 = !DILocation(line: 237, column: 31, scope: !764)
!773 = !DILocation(line: 237, column: 26, scope: !764)
!774 = !DILocation(line: 237, column: 20, scope: !764)
!775 = !DILocation(line: 237, column: 45, scope: !764)
!776 = !DILocation(line: 237, column: 37, scope: !764)
!777 = !DILocation(line: 237, column: 35, scope: !764)
!778 = !DILocation(line: 237, column: 12, scope: !764)
!779 = !DILocation(line: 237, column: 53, scope: !764)
!780 = !DILocation(line: 237, column: 51, scope: !764)
!781 = !DILocation(line: 237, column: 5, scope: !764)
!782 = !DILocation(line: 239, column: 11, scope: !752)
!783 = !DILocation(line: 239, column: 9, scope: !752)
!784 = !DILocation(line: 240, column: 4, scope: !752)
!785 = !DILocation(line: 241, column: 3, scope: !704)
!786 = !DILocation(line: 218, column: 27, scope: !700)
!787 = !DILocation(line: 218, column: 2, scope: !700)
!788 = distinct !{!788, !702, !789, !145}
!789 = !DILocation(line: 241, column: 3, scope: !697)
!790 = !DILocation(line: 244, column: 2, scope: !676)
