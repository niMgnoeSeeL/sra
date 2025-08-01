; ModuleID = 'gif2png.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%struct.GIFelement = type { %struct.GIFelement*, i8, i8*, i64, i64, %struct.GIFimagestruct* }
%struct.GIFimagestruct = type { [256 x %struct.png_color_struct], [256 x i64], i32, i32, i32, i32, i32, i32 }
%struct.png_color_struct = type { i8, i8, i8 }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque
%struct.anon = type { i32, i32, i32, i32 }
%struct.gif_scr = type { i32, i32, [256 x %struct.png_color_struct], i32, i32, i32, i32, i32 }
%struct.png_struct_def = type { [1 x %struct.__jmp_buf_tag], void (%struct.__jmp_buf_tag*, i32)*, void (%struct.png_struct_def*, i8*)*, void (%struct.png_struct_def*, i8*)*, i8*, void (%struct.png_struct_def*, i8*, i64)*, void (%struct.png_struct_def*, i8*, i64)*, i8*, void (%struct.png_struct_def*, %struct.png_row_info_struct*, i8*)*, void (%struct.png_struct_def*, %struct.png_row_info_struct*, i8*)*, i8*, i8, i8, i32, i32, i32, %struct.z_stream_s, i8*, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i64, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, %struct.png_row_info_struct, i32, i32, %struct.png_color_struct*, i16, i16, [5 x i8], i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i16, i8, float, %struct.png_color_16_struct, %struct.png_color_16_struct, void (%struct.png_struct_def*)*, i32, i32, i32, float, float, i8*, i8*, i8*, i16**, i16**, i16**, %struct.png_color_8_struct, %struct.png_color_8_struct, i8*, %struct.png_color_16_struct, void (%struct.png_struct_def*, i32, i32)*, void (%struct.png_struct_def*, i32, i32)*, void (%struct.png_struct_def*, %struct.png_info_struct*)*, void (%struct.png_struct_def*, i8*, i32, i32)*, void (%struct.png_struct_def*, %struct.png_info_struct*)*, i8*, i8*, i8*, i8*, i32, i32, i64, i64, i64, i64, i32, i32, i64, i64, i8*, i8*, i8*, i8*, i16*, i8*, i32, i8*, i32 (%struct.png_struct_def*, %struct.png_unknown_chunk_t*)*, i32, i8*, i8, i16, i16, i16, i32, i32, i8, i8*, i8* (%struct.png_struct_def*, i64)*, void (%struct.png_struct_def*, i8*)*, i8*, i8*, i8*, i8*, i8, i32, i32, i32, %struct.png_unknown_chunk_t, i32, i32, i8*, i32 }
%struct.__jmp_buf_tag = type { [22 x i64], i32, %struct.__sigset_t }
%struct.__sigset_t = type { [16 x i64] }
%struct.z_stream_s = type { i8*, i32, i64, i8*, i32, i64, i8*, %struct.internal_state*, i8* (i8*, i32, i32)*, void (i8*, i8*)*, i8*, i32, i64, i64 }
%struct.internal_state = type opaque
%struct.png_row_info_struct = type { i32, i64, i8, i8, i8, i8 }
%struct.png_color_8_struct = type { i8, i8, i8, i8, i8 }
%struct.png_color_16_struct = type { i8, i16, i16, i16, i16 }
%struct.png_info_struct = type { i32, i32, i32, i64, %struct.png_color_struct*, i16, i16, i8, i8, i8, i8, i8, i8, i8, i8, [8 x i8], float, i8, i32, i32, %struct.png_text_struct*, %struct.png_time_struct, %struct.png_color_8_struct, i8*, %struct.png_color_16_struct, %struct.png_color_16_struct, i32, i32, i8, i32, i32, i8, i16*, float, float, float, float, float, float, float, float, i8*, i32, i32, i8*, i8**, i8, i8, i32, %struct.png_unknown_chunk_t*, i64, i8*, i8*, i32, i8, %struct.png_sPLT_struct*, i32, i8, double, double, i8*, i8*, i8**, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.png_text_struct = type { i32, i8*, i8*, i64, i64, i8*, i8* }
%struct.png_time_struct = type { i16, i8, i8, i8, i8, i8 }
%struct.png_sPLT_struct = type { i8*, i8, %struct.png_sPLT_entry_struct*, i32 }
%struct.png_sPLT_entry_struct = type { i16, i16, i16, i16, i16 }
%struct.png_unknown_chunk_t = type { [5 x i8], i8*, i64, i8 }

@c_437_l1 = dso_local global [256 x i32] [i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 182, i32 167, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127, i32 199, i32 252, i32 233, i32 226, i32 228, i32 224, i32 229, i32 231, i32 234, i32 235, i32 232, i32 239, i32 238, i32 236, i32 196, i32 197, i32 201, i32 230, i32 198, i32 244, i32 246, i32 242, i32 251, i32 249, i32 255, i32 214, i32 220, i32 162, i32 163, i32 165, i32 32, i32 32, i32 225, i32 237, i32 243, i32 250, i32 241, i32 209, i32 170, i32 186, i32 191, i32 32, i32 172, i32 189, i32 188, i32 161, i32 171, i32 187, i32 42, i32 37, i32 35, i32 124, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 124, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 45, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 61, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 43, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 223, i32 32, i32 32, i32 32, i32 32, i32 181, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 177, i32 32, i32 32, i32 32, i32 32, i32 247, i32 32, i32 176, i32 32, i32 183, i32 32, i32 32, i32 178, i32 32, i32 160], align 4, !dbg !0
@first = dso_local global %struct.GIFelement zeroinitializer, align 8, !dbg !10
@delete = dso_local global i32 0, align 4, !dbg !205
@optimize = dso_local global i32 0, align 4, !dbg !207
@histogram = dso_local global i32 0, align 4, !dbg !209
@interlaced = dso_local global i32 2, align 4, !dbg !211
@progress = dso_local global i32 0, align 4, !dbg !213
@verbose = dso_local global i32 0, align 4, !dbg !215
@recover = dso_local global i32 0, align 4, !dbg !217
@webconvert = dso_local global i32 0, align 4, !dbg !219
@software_chunk = dso_local global i32 1, align 4, !dbg !221
@filtermode = dso_local global i32 0, align 4, !dbg !223
@matte = dso_local global i32 0, align 4, !dbg !225
@gamma_srgb = dso_local global i32 0, align 4, !dbg !227
@numgifs = dso_local global i64 0, align 8, !dbg !229
@numpngs = dso_local global i64 0, align 8, !dbg !231
@current = common dso_local global %struct.GIFelement* null, align 8, !dbg !233
@matte_color = common dso_local global %struct.png_color_struct zeroinitializer, align 1, !dbg !259
@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [54 x i8] c"gif2png: %d unused colors; convert with -O to remove\0A\00", align 1
@.str.1 = private unnamed_addr constant [35 x i8] c"gif2png: input image is grayscale\0A\00", align 1
@.str.2 = private unnamed_addr constant [73 x i8] c"gif2png: transparent color is repeated in visible colors, using palette\0A\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"gray\00", align 1
@.str.5 = private unnamed_addr constant [8 x i8] c"palette\00", align 1
@.str.3 = private unnamed_addr constant [60 x i8] c"gif2png: %d colors used, highest color %d, %s, bitdepth %d\0A\00", align 1
@.str.6 = private unnamed_addr constant [17 x i8] c"(%3d, %3d, %3d)\0A\00", align 1
@.str.7 = private unnamed_addr constant [48 x i8] c"gif2png:  libpng returns fatal error condition\0A\00", align 1
@.str.8 = private unnamed_addr constant [7 x i8] c"1.4.22\00", align 1
@.str.9 = private unnamed_addr constant [42 x i8] c"gif2png: handling grayscale transparency\0A\00", align 1
@.str.10 = private unnamed_addr constant [40 x i8] c"gif2png: handling palette transparency\0A\00", align 1
@.str.11 = private unnamed_addr constant [22 x i8] c"Remapping palette...\0A\00", align 1
@.str.12 = private unnamed_addr constant [35 x i8] c"Palette copied from GIF colors...\0A\00", align 1
@.str.13 = private unnamed_addr constant [39 x i8] c"PNG palette generated with %d colors:\0A\00", align 1
@.str.14 = private unnamed_addr constant [9 x i8] c"Software\00", align 1
@.str.15 = private unnamed_addr constant [7 x i8] c"%d/%d \00", align 1
@.str.16 = private unnamed_addr constant [7 x i8] c"%2d%%\0D\00", align 1
@.str.17 = private unnamed_addr constant [8 x i8] c"Comment\00", align 1
@.str.18 = private unnamed_addr constant [5 x i8] c"gIFx\00", align 1
@.str.19 = private unnamed_addr constant [5 x i8] c"gIFg\00", align 1
@.str.20 = private unnamed_addr constant [60 x i8] c"gif2png internal error: encountered unused element type %c\0A\00", align 1
@.str.21 = private unnamed_addr constant [68 x i8] c"gif2png: no transparency color in image %d, matte argument ignored\0A\00", align 1
@.str.22 = private unnamed_addr constant [46 x i8] c"gif2png: transparent value in image %d is %d\0A\00", align 1
@stdin = external dso_local global %struct._IO_FILE*, align 8
@.str.23 = private unnamed_addr constant [40 x i8] c"gif2png: %d images in -f (filter) mode\0A\00", align 1
@stdout = external dso_local global %struct._IO_FILE*, align 8
@.str.24 = private unnamed_addr constant [30 x i8] c"gif2png: number of images %d\0A\00", align 1
@.str.25 = private unnamed_addr constant [28 x i8] c"gif2png: %s is multi-image\0A\00", align 1
@.str.26 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.27 = private unnamed_addr constant [5 x i8] c".gif\00", align 1
@.str.28 = private unnamed_addr constant [5 x i8] c".GIF\00", align 1
@.str.29 = private unnamed_addr constant [5 x i8] c"_gif\00", align 1
@.str.30 = private unnamed_addr constant [5 x i8] c"_GIF\00", align 1
@.str.31 = private unnamed_addr constant [5 x i8] c".png\00", align 1
@.str.32 = private unnamed_addr constant [3 x i8] c"wb\00", align 1
@.str.33 = private unnamed_addr constant [7 x i8] c".p%02d\00", align 1
@.str.34 = private unnamed_addr constant [44 x i8] c"gif2png: missing background-matte argument\0A\00", align 1
@.str.35 = private unnamed_addr constant [3 x i8] c"%x\00", align 1
@.str.36 = private unnamed_addr constant [31 x i8] c"gif2png: unknown option `-%c'\0A\00", align 1
@.str.37 = private unnamed_addr constant [984 x i8] c"\0Ausage: gif2png [ -bdfghinprstvwO ] [file[.gif]] ...\0A\0A   -b  replace background pels with given RRGGBB color (hex digits)\0A   -d  delete source GIF files after successful conversion\0A   -f  allow use as filter, die on multi-image GIF\0A   -g  write gamma=(1.0/2.2) and sRGB chunks\0A   -h  generate PNG histogram chunks into color output files\0A   -i  force conversion to interlaced PNG files\0A   -n  force conversion to noninterlaced PNG files\0A   -p  display progress of PNG writing in %%\0A   -r  try to recover corrupted GIF files\0A   -s  do not write Software text chunk\0A   -t  transparency OK, web probe mode accepts transparent GIFs\0A   -v  verbose; display conversion statistics and debugging messages\0A   -w  web probe, list images without animation or transparency\0A   -O  optimize; remove unused color-table entries; use zlib level 9\0A   -1  one-only; same as -f; provided for backward compatibility\0A\0A   If no source files are listed, stdin is converted to noname.png.\0A\0A   This is %s, %s\0A\00", align 1
@.str.38 = private unnamed_addr constant [17 x i8] c"gif2png: %s, %s\0A\00", align 1
@.str.39 = private unnamed_addr constant [8 x i8] c"stdin:\0A\00", align 1
@.str.40 = private unnamed_addr constant [11 x i8] c"noname.gif\00", align 1
@.str.41 = private unnamed_addr constant [3 x i8] c"rb\00", align 1
@.str.42 = private unnamed_addr constant [5 x i8] c"%s:\0A\00", align 1
@.str.44 = private unnamed_addr constant [24 x i8] c"with one or more errors\00", align 1
@.str.45 = private unnamed_addr constant [19 x i8] c"no errors detected\00", align 1
@.str.46 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.47 = private unnamed_addr constant [2 x i8] c"s\00", align 1
@.str.43 = private unnamed_addr constant [49 x i8] c"Done (%s).  Converted %ld GIF%s into %ld PNG%s.\0A\00", align 1
@imagecount = common dso_local global i32 0, align 4, !dbg !261
@recover_message = common dso_local global i32 0, align 4, !dbg !355
@Gif89 = common dso_local global %struct.anon zeroinitializer, align 4, !dbg !347
@GifScreen = common dso_local global %struct.gif_scr zeroinitializer, align 4, !dbg !327
@.str.48 = private unnamed_addr constant [56 x i8] c"gif2png: image reading error, use option -r to recover \00", align 1
@.str.2.49 = private unnamed_addr constant [2 x i8] c"s\00", align 1
@.str.3.50 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.1.51 = private unnamed_addr constant [21 x i8] c"%d complete image%s \00", align 1
@.str.4.52 = private unnamed_addr constant [5 x i8] c"and \00", align 1
@.str.5.53 = private unnamed_addr constant [31 x i8] c"partial data of a broken image\00", align 1
@.str.6.54 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.7.57 = private unnamed_addr constant [37 x i8] c"gif2png: error reading magic number\0A\00", align 1
@.str.8.58 = private unnamed_addr constant [4 x i8] c"GIF\00", align 1
@.str.9.59 = private unnamed_addr constant [25 x i8] c"gif2png: not a GIF file\0A\00", align 1
@.str.10.60 = private unnamed_addr constant [4 x i8] c"87a\00", align 1
@.str.11.61 = private unnamed_addr constant [4 x i8] c"89a\00", align 1
@.str.12.62 = private unnamed_addr constant [64 x i8] c"gif2png: bad version number, not '87a' or '89a', trying anyway\0A\00", align 1
@.str.13.63 = private unnamed_addr constant [43 x i8] c"gif2png: failed to read screen descriptor\0A\00", align 1
@.str.14.64 = private unnamed_addr constant [40 x i8] c"gif2png: error reading global colormap\0A\00", align 1
@ReadGIF.colors = internal global [8 x i32] [i32 0, i32 7, i32 1, i32 2, i32 4, i32 3, i32 5, i32 6], align 4, !dbg !267
@.str.15.65 = private unnamed_addr constant [41 x i8] c"gif2png: EOF / read error on image data\0A\00", align 1
@.str.16.66 = private unnamed_addr constant [33 x i8] c"gif2png: end of GIF data stream\0A\00", align 1
@.str.17.67 = private unnamed_addr constant [54 x i8] c"gif2png: EOF / read error on extension function code\0A\00", align 1
@.str.18.68 = private unnamed_addr constant [33 x i8] c"gif2png: bogus character 0x%02x\0A\00", align 1
@.str.19.69 = private unnamed_addr constant [46 x i8] c"gif2png: couldn't read left/top/width/height\0A\00", align 1
@.str.20.70 = private unnamed_addr constant [39 x i8] c"gif2png: error reading local colormap\0A\00", align 1
@.str.21.71 = private unnamed_addr constant [59 x i8] c"gif2png: neither global nor local colormap, using default\0A\00", align 1
@.str.33.72 = private unnamed_addr constant [12 x i8] c" interlaced\00", align 1
@.str.32.73 = private unnamed_addr constant [39 x i8] c"gif2png: reading %d by %d%s GIF image\0A\00", align 1
@sp = internal global i32* null, align 8, !dbg !387
@stack = internal global [8192 x i32] zeroinitializer, align 4, !dbg !390
@.str.34.74 = private unnamed_addr constant [48 x i8] c"gif2png: reference to undefined colormap entry\0A\00", align 1
@code_size = internal global i32 0, align 4, !dbg !367
@clear_code = internal global i32 0, align 4, !dbg !369
@nextLWZ.table = internal global [2 x [4096 x i32]] zeroinitializer, align 4, !dbg !395
@set_code_size = internal global i32 0, align 4, !dbg !365
@max_code_size = internal global i32 0, align 4, !dbg !373
@max_code = internal global i32 0, align 4, !dbg !375
@nextLWZ.oldcode = internal global i32 0, align 4, !dbg !404
@nextLWZ.firstcode = internal global i32 0, align 4, !dbg !402
@end_code = internal global i32 0, align 4, !dbg !371
@ZeroDataBlock = internal global i32 0, align 4, !dbg !363
@.str.35.75 = private unnamed_addr constant [57 x i8] c"gif2png: missing EOD in data stream (common occurrence)\0A\00", align 1
@.str.36.76 = private unnamed_addr constant [41 x i8] c"gif2png: circular table entry BIG ERROR\0A\00", align 1
@.str.37.77 = private unnamed_addr constant [41 x i8] c"gif2png: circular table STACK OVERFLOW!\0A\00", align 1
@.str.30.78 = private unnamed_addr constant [42 x i8] c"gif2png: error in getting DataBlock size\0A\00", align 1
@.str.31.79 = private unnamed_addr constant [37 x i8] c"gif2png: error in reading DataBlock\0A\00", align 1
@return_clear = internal global i32 0, align 4, !dbg !385
@curbit = internal global i32 0, align 4, !dbg !379
@lastbit = internal global i32 0, align 4, !dbg !377
@get_done = internal global i32 0, align 4, !dbg !383
@.str.38.80 = private unnamed_addr constant [40 x i8] c"gif2png: ran off the end of input bits\0A\00", align 1
@last_byte = internal global i32 0, align 4, !dbg !381
@nextCode.buf = internal global [280 x i8] zeroinitializer, align 1, !dbg !406
@nextCode.maskTbl = internal global [16 x i32] [i32 0, i32 1, i32 3, i32 7, i32 15, i32 31, i32 63, i32 127, i32 255, i32 511, i32 1023, i32 2047, i32 4095, i32 8191, i32 16383, i32 32767], align 4, !dbg !412
@.str.23.81 = private unnamed_addr constant [21 x i8] c"Plain Text Extension\00", align 1
@.str.24.82 = private unnamed_addr constant [60 x i8] c"gif2png: got a 'Plain Text Extension' extension (skipping)\0A\00", align 1
@DoExtension.buf = internal global [256 x i8] zeroinitializer, align 1, !dbg !357
@.str.25.83 = private unnamed_addr constant [22 x i8] c"Application Extension\00", align 1
@.str.26.84 = private unnamed_addr constant [46 x i8] c"gif2png: got a 'Comment Extension' extension\0A\00", align 1
@.str.27.85 = private unnamed_addr constant [26 x i8] c"Graphic Control Extension\00", align 1
@.str.28.86 = private unnamed_addr constant [44 x i8] c"gif2png: skipping unknown extension 0x%02x\0A\00", align 1
@.str.29.87 = private unnamed_addr constant [31 x i8] c"gif2png: got a '%s' extension\0A\00", align 1
@.str.22.88 = private unnamed_addr constant [23 x i8] c"gif2png: bad colormap\0A\00", align 1
@.str.91 = private unnamed_addr constant [37 x i8] c"gif2png: fatal error, out of memory\0A\00", align 1
@.str.1.92 = private unnamed_addr constant [31 x i8] c"gif2png: exiting ungracefully\0A\00", align 1
@version = dso_local constant [14 x i8] c"gif2png 2.5.3\00", align 1, !dbg !417
@compile_info = dso_local constant [57 x i8] c"compiled Nov 30 2022 with libpng 1.4.22 and zlib 1.2.11.\00", align 1, !dbg !422

; Function Attrs: noinline nounwind optnone
define dso_local i32 @interlace_line(i32 %0, i32 %1) #0 !dbg !438 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !441, metadata !DIExpression()), !dbg !442
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !443, metadata !DIExpression()), !dbg !444
  call void @llvm.dbg.declare(metadata i32* %6, metadata !445, metadata !DIExpression()), !dbg !446
  %7 = load i32, i32* %5, align 4, !dbg !447
  %8 = and i32 %7, 7, !dbg !449
  %9 = icmp eq i32 %8, 0, !dbg !450
  br i1 %9, label %10, label %13, !dbg !451

10:                                               ; preds = %2
  %11 = load i32, i32* %5, align 4, !dbg !452
  %12 = ashr i32 %11, 3, !dbg !454
  store i32 %12, i32* %3, align 4, !dbg !455
  br label %51, !dbg !455

13:                                               ; preds = %2
  %14 = load i32, i32* %4, align 4, !dbg !456
  %15 = add nsw i32 %14, 7, !dbg !457
  %16 = ashr i32 %15, 3, !dbg !458
  store i32 %16, i32* %6, align 4, !dbg !459
  %17 = load i32, i32* %5, align 4, !dbg !460
  %18 = and i32 %17, 7, !dbg !462
  %19 = icmp eq i32 %18, 4, !dbg !463
  br i1 %19, label %20, label %26, !dbg !464

20:                                               ; preds = %13
  %21 = load i32, i32* %6, align 4, !dbg !465
  %22 = load i32, i32* %5, align 4, !dbg !467
  %23 = sub nsw i32 %22, 4, !dbg !468
  %24 = ashr i32 %23, 3, !dbg !469
  %25 = add nsw i32 %21, %24, !dbg !470
  store i32 %25, i32* %3, align 4, !dbg !471
  br label %51, !dbg !471

26:                                               ; preds = %13
  %27 = load i32, i32* %4, align 4, !dbg !472
  %28 = add nsw i32 %27, 3, !dbg !473
  %29 = ashr i32 %28, 3, !dbg !474
  %30 = load i32, i32* %6, align 4, !dbg !475
  %31 = add nsw i32 %30, %29, !dbg !475
  store i32 %31, i32* %6, align 4, !dbg !475
  %32 = load i32, i32* %5, align 4, !dbg !476
  %33 = and i32 %32, 3, !dbg !478
  %34 = icmp eq i32 %33, 2, !dbg !479
  br i1 %34, label %35, label %41, !dbg !480

35:                                               ; preds = %26
  %36 = load i32, i32* %6, align 4, !dbg !481
  %37 = load i32, i32* %5, align 4, !dbg !483
  %38 = sub nsw i32 %37, 2, !dbg !484
  %39 = ashr i32 %38, 2, !dbg !485
  %40 = add nsw i32 %36, %39, !dbg !486
  store i32 %40, i32* %3, align 4, !dbg !487
  br label %51, !dbg !487

41:                                               ; preds = %26
  %42 = load i32, i32* %6, align 4, !dbg !488
  %43 = load i32, i32* %4, align 4, !dbg !489
  %44 = add nsw i32 %43, 1, !dbg !490
  %45 = ashr i32 %44, 2, !dbg !491
  %46 = add nsw i32 %42, %45, !dbg !492
  %47 = load i32, i32* %5, align 4, !dbg !493
  %48 = sub nsw i32 %47, 1, !dbg !494
  %49 = ashr i32 %48, 1, !dbg !495
  %50 = add nsw i32 %46, %49, !dbg !496
  store i32 %50, i32* %3, align 4, !dbg !497
  br label %51, !dbg !497

51:                                               ; preds = %41, %35, %20, %10
  %52 = load i32, i32* %3, align 4, !dbg !498
  ret i32 %52, !dbg !498
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone
define dso_local i32 @inv_interlace_line(i32 %0, i32 %1) #0 !dbg !499 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !500, metadata !DIExpression()), !dbg !501
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !502, metadata !DIExpression()), !dbg !503
  %6 = load i32, i32* %5, align 4, !dbg !504
  %7 = shl i32 %6, 3, !dbg !506
  %8 = load i32, i32* %4, align 4, !dbg !507
  %9 = icmp slt i32 %7, %8, !dbg !508
  br i1 %9, label %10, label %13, !dbg !509

10:                                               ; preds = %2
  %11 = load i32, i32* %5, align 4, !dbg !510
  %12 = shl i32 %11, 3, !dbg !512
  store i32 %12, i32* %3, align 4, !dbg !513
  br label %52, !dbg !513

13:                                               ; preds = %2
  %14 = load i32, i32* %4, align 4, !dbg !514
  %15 = add nsw i32 %14, 7, !dbg !515
  %16 = ashr i32 %15, 3, !dbg !516
  %17 = load i32, i32* %5, align 4, !dbg !517
  %18 = sub nsw i32 %17, %16, !dbg !517
  store i32 %18, i32* %5, align 4, !dbg !517
  %19 = load i32, i32* %5, align 4, !dbg !518
  %20 = shl i32 %19, 3, !dbg !520
  %21 = add nsw i32 %20, 4, !dbg !521
  %22 = load i32, i32* %4, align 4, !dbg !522
  %23 = icmp slt i32 %21, %22, !dbg !523
  br i1 %23, label %24, label %28, !dbg !524

24:                                               ; preds = %13
  %25 = load i32, i32* %5, align 4, !dbg !525
  %26 = shl i32 %25, 3, !dbg !527
  %27 = add nsw i32 %26, 4, !dbg !528
  store i32 %27, i32* %3, align 4, !dbg !529
  br label %52, !dbg !529

28:                                               ; preds = %13
  %29 = load i32, i32* %4, align 4, !dbg !530
  %30 = add nsw i32 %29, 3, !dbg !531
  %31 = ashr i32 %30, 3, !dbg !532
  %32 = load i32, i32* %5, align 4, !dbg !533
  %33 = sub nsw i32 %32, %31, !dbg !533
  store i32 %33, i32* %5, align 4, !dbg !533
  %34 = load i32, i32* %5, align 4, !dbg !534
  %35 = shl i32 %34, 2, !dbg !536
  %36 = add nsw i32 %35, 2, !dbg !537
  %37 = load i32, i32* %4, align 4, !dbg !538
  %38 = icmp slt i32 %36, %37, !dbg !539
  br i1 %38, label %39, label %43, !dbg !540

39:                                               ; preds = %28
  %40 = load i32, i32* %5, align 4, !dbg !541
  %41 = shl i32 %40, 2, !dbg !543
  %42 = add nsw i32 %41, 2, !dbg !544
  store i32 %42, i32* %3, align 4, !dbg !545
  br label %52, !dbg !545

43:                                               ; preds = %28
  %44 = load i32, i32* %4, align 4, !dbg !546
  %45 = add nsw i32 %44, 1, !dbg !547
  %46 = ashr i32 %45, 2, !dbg !548
  %47 = load i32, i32* %5, align 4, !dbg !549
  %48 = sub nsw i32 %47, %46, !dbg !549
  store i32 %48, i32* %5, align 4, !dbg !549
  %49 = load i32, i32* %5, align 4, !dbg !550
  %50 = shl i32 %49, 1, !dbg !551
  %51 = add nsw i32 %50, 1, !dbg !552
  store i32 %51, i32* %3, align 4, !dbg !553
  br label %52, !dbg !553

52:                                               ; preds = %43, %39, %24, %10
  %53 = load i32, i32* %3, align 4, !dbg !554
  ret i32 %53, !dbg !554
}

; Function Attrs: noinline nounwind optnone
define dso_local i32 @is_gray(i64 %0) #0 !dbg !555 {
  %2 = alloca %struct.png_color_struct, align 1
  %3 = alloca i64, align 8
  store i64 %0, i64* %3, align 8
  %4 = bitcast i64* %3 to i8*
  %5 = bitcast %struct.png_color_struct* %2 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %5, i8* align 8 %4, i64 3, i1 false)
  call void @llvm.dbg.declare(metadata %struct.png_color_struct* %2, metadata !558, metadata !DIExpression()), !dbg !559
  %6 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %2, i32 0, i32 0, !dbg !560
  %7 = load i8, i8* %6, align 1, !dbg !560
  %8 = zext i8 %7 to i32, !dbg !561
  %9 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %2, i32 0, i32 1, !dbg !562
  %10 = load i8, i8* %9, align 1, !dbg !562
  %11 = zext i8 %10 to i32, !dbg !563
  %12 = icmp eq i32 %8, %11, !dbg !564
  br i1 %12, label %13, label %21, !dbg !565

13:                                               ; preds = %1
  %14 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %2, i32 0, i32 1, !dbg !566
  %15 = load i8, i8* %14, align 1, !dbg !566
  %16 = zext i8 %15 to i32, !dbg !567
  %17 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %2, i32 0, i32 2, !dbg !568
  %18 = load i8, i8* %17, align 1, !dbg !568
  %19 = zext i8 %18 to i32, !dbg !569
  %20 = icmp eq i32 %16, %19, !dbg !570
  br label %21

21:                                               ; preds = %13, %1
  %22 = phi i1 [ false, %1 ], [ %20, %13 ], !dbg !571
  %23 = zext i1 %22 to i32, !dbg !565
  ret i32 %23, !dbg !572
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: noinline nounwind optnone
define dso_local i32 @writefile(%struct.GIFelement* %0, %struct.GIFelement* %1, %struct._IO_FILE* %2, i32 %3) #0 !dbg !573 {
  %5 = alloca i32, align 4
  %6 = alloca %struct.GIFelement*, align 8
  %7 = alloca %struct.GIFelement*, align 8
  %8 = alloca %struct._IO_FILE*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca %struct.GIFimagestruct*, align 8
  %12 = alloca i64*, align 8
  %13 = alloca %struct.png_color_struct*, align 8
  %14 = alloca i32, align 4
  %15 = alloca [256 x i8], align 1
  %16 = alloca i32, align 4
  %17 = alloca %struct.png_struct_def*, align 8
  %18 = alloca %struct.png_info_struct*, align 8
  %19 = alloca i32, align 4
  %20 = alloca i32, align 4
  %21 = alloca [256 x %struct.png_color_struct], align 1
  %22 = alloca %struct.png_color_struct*, align 8
  %23 = alloca [256 x i8], align 1
  %24 = alloca %struct.png_color_16_struct, align 2
  %25 = alloca %struct.png_color_16_struct, align 2
  %26 = alloca [24 x i8], align 1
  %27 = alloca i32, align 4
  %28 = alloca [256 x i16], align 2
  %29 = alloca i64, align 8
  %30 = alloca i32, align 4
  %31 = alloca i32, align 4
  %32 = alloca i32, align 4
  %33 = alloca %struct.png_text_struct, align 8
  %34 = alloca %struct.png_text_struct, align 8
  %35 = alloca i32, align 4
  %36 = alloca i32, align 4
  %37 = alloca i32, align 4
  %38 = alloca i32, align 4
  %39 = alloca i32, align 4
  %40 = alloca i64, align 8
  %41 = alloca i64, align 8
  %42 = alloca i8*, align 8
  store %struct.GIFelement* %0, %struct.GIFelement** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.GIFelement** %6, metadata !610, metadata !DIExpression()), !dbg !611
  store %struct.GIFelement* %1, %struct.GIFelement** %7, align 8
  call void @llvm.dbg.declare(metadata %struct.GIFelement** %7, metadata !612, metadata !DIExpression()), !dbg !613
  store %struct._IO_FILE* %2, %struct._IO_FILE** %8, align 8
  call void @llvm.dbg.declare(metadata %struct._IO_FILE** %8, metadata !614, metadata !DIExpression()), !dbg !615
  store i32 %3, i32* %9, align 4
  call void @llvm.dbg.declare(metadata i32* %9, metadata !616, metadata !DIExpression()), !dbg !617
  call void @llvm.dbg.declare(metadata i32* %10, metadata !618, metadata !DIExpression()), !dbg !619
  call void @llvm.dbg.declare(metadata %struct.GIFimagestruct** %11, metadata !620, metadata !DIExpression()), !dbg !621
  %43 = load %struct.GIFelement*, %struct.GIFelement** %7, align 8, !dbg !622
  %44 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %43, i32 0, i32 5, !dbg !623
  %45 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %44, align 8, !dbg !623
  store %struct.GIFimagestruct* %45, %struct.GIFimagestruct** %11, align 8, !dbg !621
  call void @llvm.dbg.declare(metadata i64** %12, metadata !624, metadata !DIExpression()), !dbg !626
  %46 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !627
  %47 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %46, i32 0, i32 1, !dbg !628
  %48 = getelementptr inbounds [256 x i64], [256 x i64]* %47, i64 0, i64 0, !dbg !627
  store i64* %48, i64** %12, align 8, !dbg !626
  call void @llvm.dbg.declare(metadata %struct.png_color_struct** %13, metadata !629, metadata !DIExpression()), !dbg !631
  %49 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !632
  %50 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %49, i32 0, i32 0, !dbg !633
  %51 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* %50, i64 0, i64 0, !dbg !632
  store %struct.png_color_struct* %51, %struct.png_color_struct** %13, align 8, !dbg !631
  call void @llvm.dbg.declare(metadata i32* %14, metadata !634, metadata !DIExpression()), !dbg !635
  store i32 0, i32* %14, align 4, !dbg !635
  call void @llvm.dbg.declare(metadata [256 x i8]* %15, metadata !636, metadata !DIExpression()), !dbg !638
  call void @llvm.dbg.declare(metadata i32* %16, metadata !639, metadata !DIExpression()), !dbg !640
  call void @llvm.dbg.declare(metadata %struct.png_struct_def** %17, metadata !641, metadata !DIExpression()), !dbg !898
  %52 = call i8* @xalloc(i64 1240), !dbg !899
  %53 = bitcast i8* %52 to %struct.png_struct_def*, !dbg !899
  store %struct.png_struct_def* %53, %struct.png_struct_def** %17, align 8, !dbg !898
  call void @llvm.dbg.declare(metadata %struct.png_info_struct** %18, metadata !900, metadata !DIExpression()), !dbg !901
  %54 = call i8* @xalloc(i64 368), !dbg !902
  %55 = bitcast i8* %54 to %struct.png_info_struct*, !dbg !902
  store %struct.png_info_struct* %55, %struct.png_info_struct** %18, align 8, !dbg !901
  call void @llvm.dbg.declare(metadata i32* %19, metadata !903, metadata !DIExpression()), !dbg !904
  call void @llvm.dbg.declare(metadata i32* %20, metadata !905, metadata !DIExpression()), !dbg !906
  call void @llvm.dbg.declare(metadata [256 x %struct.png_color_struct]* %21, metadata !907, metadata !DIExpression()), !dbg !909
  call void @llvm.dbg.declare(metadata %struct.png_color_struct** %22, metadata !910, metadata !DIExpression()), !dbg !911
  call void @llvm.dbg.declare(metadata [256 x i8]* %23, metadata !912, metadata !DIExpression()), !dbg !914
  call void @llvm.dbg.declare(metadata %struct.png_color_16_struct* %24, metadata !915, metadata !DIExpression()), !dbg !916
  call void @llvm.dbg.declare(metadata %struct.png_color_16_struct* %25, metadata !917, metadata !DIExpression()), !dbg !918
  call void @llvm.dbg.declare(metadata [24 x i8]* %26, metadata !919, metadata !DIExpression()), !dbg !923
  call void @llvm.dbg.declare(metadata i32* %27, metadata !924, metadata !DIExpression()), !dbg !925
  call void @llvm.dbg.declare(metadata [256 x i16]* %28, metadata !926, metadata !DIExpression()), !dbg !928
  call void @llvm.dbg.declare(metadata i64* %29, metadata !929, metadata !DIExpression()), !dbg !930
  call void @llvm.dbg.declare(metadata i32* %30, metadata !931, metadata !DIExpression()), !dbg !932
  call void @llvm.dbg.declare(metadata i32* %31, metadata !933, metadata !DIExpression()), !dbg !934
  call void @llvm.dbg.declare(metadata i32* %32, metadata !935, metadata !DIExpression()), !dbg !936
  store i32 0, i32* %32, align 4, !dbg !936
  call void @llvm.dbg.declare(metadata %struct.png_text_struct* %33, metadata !937, metadata !DIExpression()), !dbg !938
  call void @llvm.dbg.declare(metadata %struct.png_text_struct* %34, metadata !939, metadata !DIExpression()), !dbg !940
  call void @llvm.dbg.declare(metadata i32* %35, metadata !941, metadata !DIExpression()), !dbg !943
  store volatile i32 1, i32* %35, align 4, !dbg !943
  call void @llvm.dbg.declare(metadata i32* %36, metadata !944, metadata !DIExpression()), !dbg !945
  store volatile i32 0, i32* %36, align 4, !dbg !945
  call void @llvm.dbg.declare(metadata i32* %37, metadata !946, metadata !DIExpression()), !dbg !947
  store volatile i32 0, i32* %37, align 4, !dbg !947
  call void @llvm.dbg.declare(metadata i32* %38, metadata !948, metadata !DIExpression()), !dbg !949
  %56 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !950
  %57 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %56, i32 0, i32 6, !dbg !952
  %58 = load i32, i32* %57, align 8, !dbg !952
  %59 = icmp ne i32 %58, -1, !dbg !953
  br i1 %59, label %60, label %72, !dbg !954

60:                                               ; preds = %4
  %61 = load i64*, i64** %12, align 8, !dbg !955
  %62 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !956
  %63 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %62, i32 0, i32 6, !dbg !957
  %64 = load i32, i32* %63, align 8, !dbg !957
  %65 = sext i32 %64 to i64, !dbg !955
  %66 = getelementptr inbounds i64, i64* %61, i64 %65, !dbg !955
  %67 = load i64, i64* %66, align 8, !dbg !955
  %68 = icmp ne i64 %67, 0, !dbg !955
  br i1 %68, label %72, label %69, !dbg !958

69:                                               ; preds = %60
  %70 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !959
  %71 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %70, i32 0, i32 6, !dbg !960
  store i32 -1, i32* %71, align 8, !dbg !961
  br label %72, !dbg !959

72:                                               ; preds = %69, %60, %4
  %73 = load i32, i32* @optimize, align 4, !dbg !962
  %74 = icmp ne i32 %73, 0, !dbg !962
  br i1 %74, label %75, label %107, !dbg !964

75:                                               ; preds = %72
  store i32 0, i32* %10, align 4, !dbg !965
  br label %76, !dbg !968

76:                                               ; preds = %103, %75
  %77 = load i32, i32* %10, align 4, !dbg !969
  %78 = icmp slt i32 %77, 256, !dbg !971
  br i1 %78, label %79, label %106, !dbg !972

79:                                               ; preds = %76
  %80 = load i64*, i64** %12, align 8, !dbg !973
  %81 = load i32, i32* %10, align 4, !dbg !975
  %82 = sext i32 %81 to i64, !dbg !973
  %83 = getelementptr inbounds i64, i64* %80, i64 %82, !dbg !973
  %84 = load i64, i64* %83, align 8, !dbg !973
  %85 = icmp ne i64 %84, 0, !dbg !973
  br i1 %85, label %102, label %86, !dbg !976

86:                                               ; preds = %79
  %87 = load %struct.png_color_struct*, %struct.png_color_struct** %13, align 8, !dbg !977
  %88 = load i32, i32* %10, align 4, !dbg !978
  %89 = sext i32 %88 to i64, !dbg !977
  %90 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %87, i64 %89, !dbg !977
  %91 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %90, i32 0, i32 2, !dbg !979
  store i8 0, i8* %91, align 1, !dbg !980
  %92 = load %struct.png_color_struct*, %struct.png_color_struct** %13, align 8, !dbg !981
  %93 = load i32, i32* %10, align 4, !dbg !982
  %94 = sext i32 %93 to i64, !dbg !981
  %95 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %92, i64 %94, !dbg !981
  %96 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %95, i32 0, i32 1, !dbg !983
  store i8 0, i8* %96, align 1, !dbg !984
  %97 = load %struct.png_color_struct*, %struct.png_color_struct** %13, align 8, !dbg !985
  %98 = load i32, i32* %10, align 4, !dbg !986
  %99 = sext i32 %98 to i64, !dbg !985
  %100 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %97, i64 %99, !dbg !985
  %101 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %100, i32 0, i32 0, !dbg !987
  store i8 0, i8* %101, align 1, !dbg !988
  br label %102, !dbg !985

102:                                              ; preds = %86, %79
  br label %103, !dbg !989

103:                                              ; preds = %102
  %104 = load i32, i32* %10, align 4, !dbg !990
  %105 = add nsw i32 %104, 1, !dbg !990
  store i32 %105, i32* %10, align 4, !dbg !990
  br label %76, !dbg !991, !llvm.loop !992

106:                                              ; preds = %76
  br label %139, !dbg !994

107:                                              ; preds = %72
  %108 = load i32, i32* @recover, align 4, !dbg !995
  %109 = icmp ne i32 %108, 0, !dbg !995
  br i1 %109, label %138, label %110, !dbg !997

110:                                              ; preds = %107
  call void @llvm.dbg.declare(metadata i32* %39, metadata !998, metadata !DIExpression()), !dbg !1000
  store i32 0, i32* %39, align 4, !dbg !1000
  store i32 0, i32* %10, align 4, !dbg !1001
  br label %111, !dbg !1003

111:                                              ; preds = %125, %110
  %112 = load i32, i32* %10, align 4, !dbg !1004
  %113 = icmp slt i32 %112, 256, !dbg !1006
  br i1 %113, label %114, label %128, !dbg !1007

114:                                              ; preds = %111
  %115 = load i64*, i64** %12, align 8, !dbg !1008
  %116 = load i32, i32* %10, align 4, !dbg !1010
  %117 = sext i32 %116 to i64, !dbg !1008
  %118 = getelementptr inbounds i64, i64* %115, i64 %117, !dbg !1008
  %119 = load i64, i64* %118, align 8, !dbg !1008
  %120 = icmp ne i64 %119, 0, !dbg !1008
  br i1 %120, label %124, label %121, !dbg !1011

121:                                              ; preds = %114
  %122 = load i32, i32* %39, align 4, !dbg !1012
  %123 = add nsw i32 %122, 1, !dbg !1012
  store i32 %123, i32* %39, align 4, !dbg !1012
  br label %124, !dbg !1013

124:                                              ; preds = %121, %114
  br label %125, !dbg !1014

125:                                              ; preds = %124
  %126 = load i32, i32* %10, align 4, !dbg !1015
  %127 = add nsw i32 %126, 1, !dbg !1015
  store i32 %127, i32* %10, align 4, !dbg !1015
  br label %111, !dbg !1016, !llvm.loop !1017

128:                                              ; preds = %111
  %129 = load i32, i32* %39, align 4, !dbg !1019
  %130 = icmp ne i32 %129, 0, !dbg !1019
  br i1 %130, label %131, label %137, !dbg !1021

131:                                              ; preds = %128
  %132 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1022
  %133 = load i32, i32* %39, align 4, !dbg !1024
  %134 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %132, i8* getelementptr inbounds ([54 x i8], [54 x i8]* @.str, i64 0, i64 0), i32 %133), !dbg !1025
  %135 = load i32, i32* %32, align 4, !dbg !1026
  %136 = add nsw i32 %135, 1, !dbg !1026
  store i32 %136, i32* %32, align 4, !dbg !1026
  br label %137, !dbg !1027

137:                                              ; preds = %131, %128
  br label %138, !dbg !1028

138:                                              ; preds = %137, %107
  br label %139

139:                                              ; preds = %138, %106
  store i32 0, i32* %10, align 4, !dbg !1029
  br label %140, !dbg !1031

140:                                              ; preds = %170, %139
  %141 = load i32, i32* %10, align 4, !dbg !1032
  %142 = icmp slt i32 %141, 256, !dbg !1034
  br i1 %142, label %143, label %173, !dbg !1035

143:                                              ; preds = %140
  %144 = load i64*, i64** %12, align 8, !dbg !1036
  %145 = load i32, i32* %10, align 4, !dbg !1038
  %146 = sext i32 %145 to i64, !dbg !1036
  %147 = getelementptr inbounds i64, i64* %144, i64 %146, !dbg !1036
  %148 = load i64, i64* %147, align 8, !dbg !1036
  %149 = icmp ne i64 %148, 0, !dbg !1036
  br i1 %149, label %150, label %169, !dbg !1039

150:                                              ; preds = %143
  %151 = load %struct.png_color_struct*, %struct.png_color_struct** %13, align 8, !dbg !1040
  %152 = load i32, i32* %10, align 4, !dbg !1042
  %153 = sext i32 %152 to i64, !dbg !1040
  %154 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %151, i64 %153, !dbg !1040
  %155 = bitcast i64* %40 to i8*, !dbg !1043
  %156 = bitcast %struct.png_color_struct* %154 to i8*, !dbg !1043
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %155, i8* align 1 %156, i64 3, i1 false), !dbg !1043
  %157 = load i64, i64* %40, align 8, !dbg !1043
  %158 = call i32 @is_gray(i64 %157), !dbg !1043
  %159 = load volatile i32, i32* %35, align 4, !dbg !1044
  %160 = and i32 %159, %158, !dbg !1044
  store volatile i32 %160, i32* %35, align 4, !dbg !1044
  %161 = load i32, i32* %14, align 4, !dbg !1045
  %162 = add nsw i32 %161, 1, !dbg !1045
  store i32 %162, i32* %14, align 4, !dbg !1045
  %163 = load volatile i32, i32* %36, align 4, !dbg !1046
  %164 = load i32, i32* %10, align 4, !dbg !1048
  %165 = icmp slt i32 %163, %164, !dbg !1049
  br i1 %165, label %166, label %168, !dbg !1050

166:                                              ; preds = %150
  %167 = load i32, i32* %10, align 4, !dbg !1051
  store volatile i32 %167, i32* %36, align 4, !dbg !1052
  br label %168, !dbg !1053

168:                                              ; preds = %166, %150
  br label %169, !dbg !1054

169:                                              ; preds = %168, %143
  br label %170, !dbg !1055

170:                                              ; preds = %169
  %171 = load i32, i32* %10, align 4, !dbg !1056
  %172 = add nsw i32 %171, 1, !dbg !1056
  store i32 %172, i32* %10, align 4, !dbg !1056
  br label %140, !dbg !1057, !llvm.loop !1058

173:                                              ; preds = %140
  %174 = load volatile i32, i32* %35, align 4, !dbg !1060
  %175 = icmp ne i32 %174, 0, !dbg !1060
  br i1 %175, label %176, label %228, !dbg !1062

176:                                              ; preds = %173
  %177 = load i32, i32* @verbose, align 4, !dbg !1063
  %178 = icmp sgt i32 %177, 1, !dbg !1066
  br i1 %178, label %179, label %182, !dbg !1067

179:                                              ; preds = %176
  %180 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1068
  %181 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %180, i8* getelementptr inbounds ([35 x i8], [35 x i8]* @.str.1, i64 0, i64 0)), !dbg !1069
  br label %182, !dbg !1069

182:                                              ; preds = %179, %176
  %183 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !1070
  %184 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %183, i32 0, i32 6, !dbg !1072
  %185 = load i32, i32* %184, align 8, !dbg !1072
  %186 = icmp ne i32 %185, -1, !dbg !1073
  br i1 %186, label %187, label %227, !dbg !1074

187:                                              ; preds = %182
  store i32 0, i32* %10, align 4, !dbg !1075
  br label %188, !dbg !1078

188:                                              ; preds = %223, %187
  %189 = load i32, i32* %10, align 4, !dbg !1079
  %190 = icmp slt i32 %189, 256, !dbg !1081
  br i1 %190, label %191, label %226, !dbg !1082

191:                                              ; preds = %188
  %192 = load i32, i32* %10, align 4, !dbg !1083
  %193 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !1086
  %194 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %193, i32 0, i32 6, !dbg !1087
  %195 = load i32, i32* %194, align 8, !dbg !1087
  %196 = icmp ne i32 %192, %195, !dbg !1088
  br i1 %196, label %197, label %222, !dbg !1089

197:                                              ; preds = %191
  %198 = load %struct.png_color_struct*, %struct.png_color_struct** %13, align 8, !dbg !1090
  %199 = load i32, i32* %10, align 4, !dbg !1091
  %200 = sext i32 %199 to i64, !dbg !1090
  %201 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %198, i64 %200, !dbg !1090
  %202 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %201, i32 0, i32 0, !dbg !1092
  %203 = load i8, i8* %202, align 1, !dbg !1092
  %204 = zext i8 %203 to i32, !dbg !1090
  %205 = load %struct.png_color_struct*, %struct.png_color_struct** %13, align 8, !dbg !1093
  %206 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !1094
  %207 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %206, i32 0, i32 6, !dbg !1095
  %208 = load i32, i32* %207, align 8, !dbg !1095
  %209 = sext i32 %208 to i64, !dbg !1093
  %210 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %205, i64 %209, !dbg !1093
  %211 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %210, i32 0, i32 0, !dbg !1096
  %212 = load i8, i8* %211, align 1, !dbg !1096
  %213 = zext i8 %212 to i32, !dbg !1093
  %214 = icmp eq i32 %204, %213, !dbg !1097
  br i1 %214, label %215, label %222, !dbg !1098

215:                                              ; preds = %197
  store volatile i32 0, i32* %35, align 4, !dbg !1099
  %216 = load i32, i32* @verbose, align 4, !dbg !1101
  %217 = icmp sgt i32 %216, 1, !dbg !1103
  br i1 %217, label %218, label %221, !dbg !1104

218:                                              ; preds = %215
  %219 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1105
  %220 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %219, i8* getelementptr inbounds ([73 x i8], [73 x i8]* @.str.2, i64 0, i64 0)), !dbg !1106
  br label %221, !dbg !1106

221:                                              ; preds = %218, %215
  br label %226, !dbg !1107

222:                                              ; preds = %197, %191
  br label %223, !dbg !1108

223:                                              ; preds = %222
  %224 = load i32, i32* %10, align 4, !dbg !1109
  %225 = add nsw i32 %224, 1, !dbg !1109
  store i32 %225, i32* %10, align 4, !dbg !1109
  br label %188, !dbg !1110, !llvm.loop !1111

226:                                              ; preds = %221, %188
  br label %227, !dbg !1113

227:                                              ; preds = %226, %182
  br label %228, !dbg !1114

228:                                              ; preds = %227, %173
  store volatile i32 8, i32* %38, align 4, !dbg !1115
  %229 = load volatile i32, i32* %36, align 4, !dbg !1116
  %230 = icmp slt i32 %229, 16, !dbg !1118
  br i1 %230, label %231, label %232, !dbg !1119

231:                                              ; preds = %228
  store volatile i32 4, i32* %38, align 4, !dbg !1120
  br label %232, !dbg !1121

232:                                              ; preds = %231, %228
  %233 = load volatile i32, i32* %36, align 4, !dbg !1122
  %234 = icmp slt i32 %233, 4, !dbg !1124
  br i1 %234, label %235, label %236, !dbg !1125

235:                                              ; preds = %232
  store volatile i32 2, i32* %38, align 4, !dbg !1126
  br label %236, !dbg !1127

236:                                              ; preds = %235, %232
  %237 = load volatile i32, i32* %36, align 4, !dbg !1128
  %238 = icmp slt i32 %237, 2, !dbg !1130
  br i1 %238, label %239, label %240, !dbg !1131

239:                                              ; preds = %236
  store volatile i32 1, i32* %38, align 4, !dbg !1132
  br label %240, !dbg !1133

240:                                              ; preds = %239, %236
  %241 = load volatile i32, i32* %35, align 4, !dbg !1134
  %242 = icmp ne i32 %241, 0, !dbg !1134
  br i1 %242, label %243, label %402, !dbg !1136

243:                                              ; preds = %240
  store volatile i32 1, i32* %37, align 4, !dbg !1137
  store i32 0, i32* %10, align 4, !dbg !1139
  br label %244, !dbg !1141

244:                                              ; preds = %257, %243
  %245 = load i32, i32* %10, align 4, !dbg !1142
  %246 = icmp slt i32 %245, 256, !dbg !1144
  br i1 %246, label %247, label %260, !dbg !1145

247:                                              ; preds = %244
  %248 = load %struct.png_color_struct*, %struct.png_color_struct** %13, align 8, !dbg !1146
  %249 = load i32, i32* %10, align 4, !dbg !1147
  %250 = sext i32 %249 to i64, !dbg !1146
  %251 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %248, i64 %250, !dbg !1146
  %252 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %251, i32 0, i32 0, !dbg !1148
  %253 = load i8, i8* %252, align 1, !dbg !1148
  %254 = load i32, i32* %10, align 4, !dbg !1149
  %255 = sext i32 %254 to i64, !dbg !1150
  %256 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %255, !dbg !1150
  store i8 %253, i8* %256, align 1, !dbg !1151
  br label %257, !dbg !1150

257:                                              ; preds = %247
  %258 = load i32, i32* %10, align 4, !dbg !1152
  %259 = add nsw i32 %258, 1, !dbg !1152
  store i32 %259, i32* %10, align 4, !dbg !1152
  br label %244, !dbg !1153, !llvm.loop !1154

260:                                              ; preds = %244
  store i32 8, i32* %20, align 4, !dbg !1156
  store i32 1, i32* %16, align 4, !dbg !1157
  store i32 0, i32* %10, align 4, !dbg !1158
  br label %261, !dbg !1160

261:                                              ; preds = %280, %260
  %262 = load i32, i32* %10, align 4, !dbg !1161
  %263 = icmp slt i32 %262, 256, !dbg !1163
  br i1 %263, label %264, label %283, !dbg !1164

264:                                              ; preds = %261
  %265 = load i32, i32* %10, align 4, !dbg !1165
  %266 = sext i32 %265 to i64, !dbg !1168
  %267 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %266, !dbg !1168
  %268 = load i8, i8* %267, align 1, !dbg !1168
  %269 = zext i8 %268 to i32, !dbg !1168
  %270 = and i32 %269, 15, !dbg !1169
  %271 = mul nsw i32 %270, 17, !dbg !1170
  %272 = load i32, i32* %10, align 4, !dbg !1171
  %273 = sext i32 %272 to i64, !dbg !1172
  %274 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %273, !dbg !1172
  %275 = load i8, i8* %274, align 1, !dbg !1172
  %276 = zext i8 %275 to i32, !dbg !1172
  %277 = icmp ne i32 %271, %276, !dbg !1173
  br i1 %277, label %278, label %279, !dbg !1174

278:                                              ; preds = %264
  store i32 0, i32* %16, align 4, !dbg !1175
  br label %283, !dbg !1177

279:                                              ; preds = %264
  br label %280, !dbg !1178

280:                                              ; preds = %279
  %281 = load i32, i32* %10, align 4, !dbg !1179
  %282 = add nsw i32 %281, 1, !dbg !1179
  store i32 %282, i32* %10, align 4, !dbg !1179
  br label %261, !dbg !1180, !llvm.loop !1181

283:                                              ; preds = %278, %261
  %284 = load i32, i32* %16, align 4, !dbg !1183
  %285 = icmp ne i32 %284, 0, !dbg !1183
  br i1 %285, label %286, label %302, !dbg !1185

286:                                              ; preds = %283
  store i32 0, i32* %10, align 4, !dbg !1186
  br label %287, !dbg !1189

287:                                              ; preds = %298, %286
  %288 = load i32, i32* %10, align 4, !dbg !1190
  %289 = icmp slt i32 %288, 256, !dbg !1192
  br i1 %289, label %290, label %301, !dbg !1193

290:                                              ; preds = %287
  %291 = load i32, i32* %10, align 4, !dbg !1194
  %292 = sext i32 %291 to i64, !dbg !1196
  %293 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %292, !dbg !1196
  %294 = load i8, i8* %293, align 1, !dbg !1197
  %295 = zext i8 %294 to i32, !dbg !1197
  %296 = and i32 %295, 15, !dbg !1197
  %297 = trunc i32 %296 to i8, !dbg !1197
  store i8 %297, i8* %293, align 1, !dbg !1197
  br label %298, !dbg !1198

298:                                              ; preds = %290
  %299 = load i32, i32* %10, align 4, !dbg !1199
  %300 = add nsw i32 %299, 1, !dbg !1199
  store i32 %300, i32* %10, align 4, !dbg !1199
  br label %287, !dbg !1200, !llvm.loop !1201

301:                                              ; preds = %287
  store i32 4, i32* %20, align 4, !dbg !1203
  br label %302, !dbg !1204

302:                                              ; preds = %301, %283
  %303 = load i32, i32* %16, align 4, !dbg !1205
  %304 = icmp ne i32 %303, 0, !dbg !1205
  br i1 %304, label %305, label %329, !dbg !1207

305:                                              ; preds = %302
  store i32 0, i32* %10, align 4, !dbg !1208
  br label %306, !dbg !1211

306:                                              ; preds = %325, %305
  %307 = load i32, i32* %10, align 4, !dbg !1212
  %308 = icmp slt i32 %307, 256, !dbg !1214
  br i1 %308, label %309, label %328, !dbg !1215

309:                                              ; preds = %306
  %310 = load i32, i32* %10, align 4, !dbg !1216
  %311 = sext i32 %310 to i64, !dbg !1219
  %312 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %311, !dbg !1219
  %313 = load i8, i8* %312, align 1, !dbg !1219
  %314 = zext i8 %313 to i32, !dbg !1219
  %315 = and i32 %314, 3, !dbg !1220
  %316 = mul nsw i32 %315, 5, !dbg !1221
  %317 = load i32, i32* %10, align 4, !dbg !1222
  %318 = sext i32 %317 to i64, !dbg !1223
  %319 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %318, !dbg !1223
  %320 = load i8, i8* %319, align 1, !dbg !1223
  %321 = zext i8 %320 to i32, !dbg !1223
  %322 = icmp ne i32 %316, %321, !dbg !1224
  br i1 %322, label %323, label %324, !dbg !1225

323:                                              ; preds = %309
  store i32 0, i32* %16, align 4, !dbg !1226
  br label %328, !dbg !1228

324:                                              ; preds = %309
  br label %325, !dbg !1229

325:                                              ; preds = %324
  %326 = load i32, i32* %10, align 4, !dbg !1230
  %327 = add nsw i32 %326, 1, !dbg !1230
  store i32 %327, i32* %10, align 4, !dbg !1230
  br label %306, !dbg !1231, !llvm.loop !1232

328:                                              ; preds = %323, %306
  br label %329, !dbg !1234

329:                                              ; preds = %328, %302
  %330 = load i32, i32* %16, align 4, !dbg !1235
  %331 = icmp ne i32 %330, 0, !dbg !1235
  br i1 %331, label %332, label %348, !dbg !1237

332:                                              ; preds = %329
  store i32 0, i32* %10, align 4, !dbg !1238
  br label %333, !dbg !1241

333:                                              ; preds = %344, %332
  %334 = load i32, i32* %10, align 4, !dbg !1242
  %335 = icmp slt i32 %334, 256, !dbg !1244
  br i1 %335, label %336, label %347, !dbg !1245

336:                                              ; preds = %333
  %337 = load i32, i32* %10, align 4, !dbg !1246
  %338 = sext i32 %337 to i64, !dbg !1248
  %339 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %338, !dbg !1248
  %340 = load i8, i8* %339, align 1, !dbg !1249
  %341 = zext i8 %340 to i32, !dbg !1249
  %342 = and i32 %341, 3, !dbg !1249
  %343 = trunc i32 %342 to i8, !dbg !1249
  store i8 %343, i8* %339, align 1, !dbg !1249
  br label %344, !dbg !1250

344:                                              ; preds = %336
  %345 = load i32, i32* %10, align 4, !dbg !1251
  %346 = add nsw i32 %345, 1, !dbg !1251
  store i32 %346, i32* %10, align 4, !dbg !1251
  br label %333, !dbg !1252, !llvm.loop !1253

347:                                              ; preds = %333
  store i32 2, i32* %20, align 4, !dbg !1255
  br label %348, !dbg !1256

348:                                              ; preds = %347, %329
  %349 = load i32, i32* %16, align 4, !dbg !1257
  %350 = icmp ne i32 %349, 0, !dbg !1257
  br i1 %350, label %351, label %375, !dbg !1259

351:                                              ; preds = %348
  store i32 0, i32* %10, align 4, !dbg !1260
  br label %352, !dbg !1263

352:                                              ; preds = %371, %351
  %353 = load i32, i32* %10, align 4, !dbg !1264
  %354 = icmp slt i32 %353, 256, !dbg !1266
  br i1 %354, label %355, label %374, !dbg !1267

355:                                              ; preds = %352
  %356 = load i32, i32* %10, align 4, !dbg !1268
  %357 = sext i32 %356 to i64, !dbg !1271
  %358 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %357, !dbg !1271
  %359 = load i8, i8* %358, align 1, !dbg !1271
  %360 = zext i8 %359 to i32, !dbg !1271
  %361 = and i32 %360, 1, !dbg !1272
  %362 = mul nsw i32 %361, 3, !dbg !1273
  %363 = load i32, i32* %10, align 4, !dbg !1274
  %364 = sext i32 %363 to i64, !dbg !1275
  %365 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %364, !dbg !1275
  %366 = load i8, i8* %365, align 1, !dbg !1275
  %367 = zext i8 %366 to i32, !dbg !1275
  %368 = icmp ne i32 %362, %367, !dbg !1276
  br i1 %368, label %369, label %370, !dbg !1277

369:                                              ; preds = %355
  store i32 0, i32* %16, align 4, !dbg !1278
  br label %374, !dbg !1280

370:                                              ; preds = %355
  br label %371, !dbg !1281

371:                                              ; preds = %370
  %372 = load i32, i32* %10, align 4, !dbg !1282
  %373 = add nsw i32 %372, 1, !dbg !1282
  store i32 %373, i32* %10, align 4, !dbg !1282
  br label %352, !dbg !1283, !llvm.loop !1284

374:                                              ; preds = %369, %352
  br label %375, !dbg !1286

375:                                              ; preds = %374, %348
  %376 = load i32, i32* %16, align 4, !dbg !1287
  %377 = icmp ne i32 %376, 0, !dbg !1287
  br i1 %377, label %378, label %394, !dbg !1289

378:                                              ; preds = %375
  store i32 0, i32* %10, align 4, !dbg !1290
  br label %379, !dbg !1293

379:                                              ; preds = %390, %378
  %380 = load i32, i32* %10, align 4, !dbg !1294
  %381 = icmp slt i32 %380, 256, !dbg !1296
  br i1 %381, label %382, label %393, !dbg !1297

382:                                              ; preds = %379
  %383 = load i32, i32* %10, align 4, !dbg !1298
  %384 = sext i32 %383 to i64, !dbg !1300
  %385 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %384, !dbg !1300
  %386 = load i8, i8* %385, align 1, !dbg !1301
  %387 = zext i8 %386 to i32, !dbg !1301
  %388 = and i32 %387, 1, !dbg !1301
  %389 = trunc i32 %388 to i8, !dbg !1301
  store i8 %389, i8* %385, align 1, !dbg !1301
  br label %390, !dbg !1302

390:                                              ; preds = %382
  %391 = load i32, i32* %10, align 4, !dbg !1303
  %392 = add nsw i32 %391, 1, !dbg !1303
  store i32 %392, i32* %10, align 4, !dbg !1303
  br label %379, !dbg !1304, !llvm.loop !1305

393:                                              ; preds = %379
  store i32 1, i32* %20, align 4, !dbg !1307
  br label %394, !dbg !1308

394:                                              ; preds = %393, %375
  %395 = load volatile i32, i32* %38, align 4, !dbg !1309
  %396 = load i32, i32* %20, align 4, !dbg !1311
  %397 = icmp slt i32 %395, %396, !dbg !1312
  br i1 %397, label %398, label %399, !dbg !1313

398:                                              ; preds = %394
  store volatile i32 0, i32* %35, align 4, !dbg !1314
  store volatile i32 0, i32* %37, align 4, !dbg !1316
  br label %401, !dbg !1317

399:                                              ; preds = %394
  %400 = load i32, i32* %20, align 4, !dbg !1318
  store volatile i32 %400, i32* %38, align 4, !dbg !1320
  br label %401

401:                                              ; preds = %399, %398
  br label %402, !dbg !1321

402:                                              ; preds = %401, %240
  %403 = load i32, i32* @verbose, align 4, !dbg !1322
  %404 = icmp sgt i32 %403, 1, !dbg !1324
  br i1 %404, label %405, label %415, !dbg !1325

405:                                              ; preds = %402
  %406 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1326
  %407 = load i32, i32* %14, align 4, !dbg !1327
  %408 = load volatile i32, i32* %36, align 4, !dbg !1328
  %409 = load volatile i32, i32* %35, align 4, !dbg !1329
  %410 = icmp ne i32 %409, 0, !dbg !1329
  %411 = zext i1 %410 to i64, !dbg !1329
  %412 = select i1 %410, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.4, i64 0, i64 0), i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.5, i64 0, i64 0), !dbg !1329
  %413 = load volatile i32, i32* %38, align 4, !dbg !1330
  %414 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %406, i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.3, i64 0, i64 0), i32 %407, i32 %408, i8* %412, i32 %413), !dbg !1331
  br label %415, !dbg !1331

415:                                              ; preds = %405, %402
  %416 = load i32, i32* @verbose, align 4, !dbg !1332
  %417 = icmp sgt i32 %416, 2, !dbg !1334
  br i1 %417, label %418, label %451, !dbg !1335

418:                                              ; preds = %415
  store i32 0, i32* %10, align 4, !dbg !1336
  br label %419, !dbg !1338

419:                                              ; preds = %447, %418
  %420 = load i32, i32* %10, align 4, !dbg !1339
  %421 = load volatile i32, i32* %36, align 4, !dbg !1341
  %422 = icmp sle i32 %420, %421, !dbg !1342
  br i1 %422, label %423, label %450, !dbg !1343

423:                                              ; preds = %419
  %424 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1344
  %425 = load %struct.png_color_struct*, %struct.png_color_struct** %13, align 8, !dbg !1346
  %426 = load i32, i32* %10, align 4, !dbg !1347
  %427 = sext i32 %426 to i64, !dbg !1346
  %428 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %425, i64 %427, !dbg !1346
  %429 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %428, i32 0, i32 0, !dbg !1348
  %430 = load i8, i8* %429, align 1, !dbg !1348
  %431 = zext i8 %430 to i32, !dbg !1346
  %432 = load %struct.png_color_struct*, %struct.png_color_struct** %13, align 8, !dbg !1349
  %433 = load i32, i32* %10, align 4, !dbg !1350
  %434 = sext i32 %433 to i64, !dbg !1349
  %435 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %432, i64 %434, !dbg !1349
  %436 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %435, i32 0, i32 2, !dbg !1351
  %437 = load i8, i8* %436, align 1, !dbg !1351
  %438 = zext i8 %437 to i32, !dbg !1349
  %439 = load %struct.png_color_struct*, %struct.png_color_struct** %13, align 8, !dbg !1352
  %440 = load i32, i32* %10, align 4, !dbg !1353
  %441 = sext i32 %440 to i64, !dbg !1352
  %442 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %439, i64 %441, !dbg !1352
  %443 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %442, i32 0, i32 1, !dbg !1354
  %444 = load i8, i8* %443, align 1, !dbg !1354
  %445 = zext i8 %444 to i32, !dbg !1352
  %446 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %424, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.6, i64 0, i64 0), i32 %431, i32 %438, i32 %445), !dbg !1355
  br label %447, !dbg !1356

447:                                              ; preds = %423
  %448 = load i32, i32* %10, align 4, !dbg !1357
  %449 = add nsw i32 %448, 1, !dbg !1357
  store i32 %449, i32* %10, align 4, !dbg !1357
  br label %419, !dbg !1358, !llvm.loop !1359

450:                                              ; preds = %419
  br label %451, !dbg !1360

451:                                              ; preds = %450, %415
  %452 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1361
  %453 = call [1 x %struct.__jmp_buf_tag]* @png_set_longjmp_fn(%struct.png_struct_def* %452, void (%struct.__jmp_buf_tag*, i32)* @longjmp, i64 312), !dbg !1361
  %454 = getelementptr inbounds [1 x %struct.__jmp_buf_tag], [1 x %struct.__jmp_buf_tag]* %453, i64 0, i64 0, !dbg !1361
  %455 = call i32 @_setjmp(%struct.__jmp_buf_tag* %454) #8, !dbg !1361
  %456 = icmp ne i32 %455, 0, !dbg !1361
  br i1 %456, label %457, label %464, !dbg !1363

457:                                              ; preds = %451
  %458 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1364
  %459 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %458, i8* getelementptr inbounds ([48 x i8], [48 x i8]* @.str.7, i64 0, i64 0)), !dbg !1366
  %460 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1367
  %461 = bitcast %struct.png_struct_def* %460 to i8*, !dbg !1367
  call void @free(i8* %461) #9, !dbg !1368
  %462 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1369
  %463 = bitcast %struct.png_info_struct* %462 to i8*, !dbg !1369
  call void @free(i8* %463) #9, !dbg !1370
  store i32 1, i32* %5, align 4, !dbg !1371
  br label %1210, !dbg !1371

464:                                              ; preds = %451
  %465 = call noalias %struct.png_struct_def* @png_create_write_struct(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.8, i64 0, i64 0), i8* null, void (%struct.png_struct_def*, i8*)* null, void (%struct.png_struct_def*, i8*)* null), !dbg !1372
  store %struct.png_struct_def* %465, %struct.png_struct_def** %17, align 8, !dbg !1373
  %466 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1374
  %467 = icmp eq %struct.png_struct_def* %466, null, !dbg !1376
  br i1 %467, label %468, label %469, !dbg !1377

468:                                              ; preds = %464
  store i32 2, i32* %5, align 4, !dbg !1378
  br label %1210, !dbg !1378

469:                                              ; preds = %464
  %470 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1379
  %471 = call noalias %struct.png_info_struct* @png_create_info_struct(%struct.png_struct_def* %470), !dbg !1380
  store %struct.png_info_struct* %471, %struct.png_info_struct** %18, align 8, !dbg !1381
  %472 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1382
  %473 = icmp eq %struct.png_info_struct* %472, null, !dbg !1384
  br i1 %473, label %474, label %475, !dbg !1385

474:                                              ; preds = %469
  call void @png_destroy_write_struct(%struct.png_struct_def** %17, %struct.png_info_struct** null), !dbg !1386
  store i32 2, i32* %5, align 4, !dbg !1388
  br label %1210, !dbg !1388

475:                                              ; preds = %469
  %476 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1389
  %477 = call [1 x %struct.__jmp_buf_tag]* @png_set_longjmp_fn(%struct.png_struct_def* %476, void (%struct.__jmp_buf_tag*, i32)* @longjmp, i64 312), !dbg !1389
  %478 = getelementptr inbounds [1 x %struct.__jmp_buf_tag], [1 x %struct.__jmp_buf_tag]* %477, i64 0, i64 0, !dbg !1389
  %479 = call i32 @_setjmp(%struct.__jmp_buf_tag* %478) #8, !dbg !1389
  store i32 %479, i32* %31, align 4, !dbg !1391
  %480 = icmp ne i32 %479, 0, !dbg !1391
  br i1 %480, label %481, label %483, !dbg !1392

481:                                              ; preds = %475
  call void @png_destroy_write_struct(%struct.png_struct_def** %17, %struct.png_info_struct** %18), !dbg !1393
  %482 = load i32, i32* %31, align 4, !dbg !1395
  store i32 %482, i32* %5, align 4, !dbg !1396
  br label %1210, !dbg !1396

483:                                              ; preds = %475
  %484 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1397
  %485 = load %struct._IO_FILE*, %struct._IO_FILE** %8, align 8, !dbg !1398
  call void @png_init_io(%struct.png_struct_def* %484, %struct._IO_FILE* %485), !dbg !1399
  %486 = load i32, i32* @optimize, align 4, !dbg !1400
  %487 = icmp ne i32 %486, 0, !dbg !1400
  br i1 %487, label %488, label %490, !dbg !1402

488:                                              ; preds = %483
  %489 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1403
  call void @png_set_compression_level(%struct.png_struct_def* %489, i32 9), !dbg !1404
  br label %490, !dbg !1404

490:                                              ; preds = %488, %483
  %491 = load i32, i32* @gamma_srgb, align 4, !dbg !1405
  %492 = icmp ne i32 %491, 0, !dbg !1405
  br i1 %492, label %493, label %498, !dbg !1407

493:                                              ; preds = %490
  %494 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1408
  %495 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1410
  call void @png_set_gAMA(%struct.png_struct_def* %494, %struct.png_info_struct* %495, double 0x3FDD1745D1745D17), !dbg !1411
  %496 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1412
  %497 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1413
  call void @png_set_sRGB(%struct.png_struct_def* %496, %struct.png_info_struct* %497, i32 0), !dbg !1414
  br label %498, !dbg !1415

498:                                              ; preds = %493, %490
  %499 = load i32, i32* @interlaced, align 4, !dbg !1416
  %500 = icmp eq i32 %499, 2, !dbg !1418
  br i1 %500, label %501, label %510, !dbg !1419

501:                                              ; preds = %498
  %502 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !1420
  %503 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %502, i32 0, i32 5, !dbg !1421
  %504 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %503, align 8, !dbg !1421
  %505 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %504, i32 0, i32 7, !dbg !1422
  %506 = load i32, i32* %505, align 4, !dbg !1422
  %507 = icmp ne i32 %506, 0, !dbg !1420
  %508 = zext i1 %507 to i64, !dbg !1420
  %509 = select i1 %507, i32 1, i32 0, !dbg !1420
  store i32 %509, i32* @interlaced, align 4, !dbg !1423
  br label %510, !dbg !1424

510:                                              ; preds = %501, %498
  %511 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1425
  %512 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1426
  %513 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !1427
  %514 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %513, i32 0, i32 5, !dbg !1428
  %515 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %514, align 8, !dbg !1428
  %516 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %515, i32 0, i32 4, !dbg !1429
  %517 = load i32, i32* %516, align 8, !dbg !1429
  %518 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !1430
  %519 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %518, i32 0, i32 5, !dbg !1431
  %520 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %519, align 8, !dbg !1431
  %521 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %520, i32 0, i32 5, !dbg !1432
  %522 = load i32, i32* %521, align 4, !dbg !1432
  %523 = load volatile i32, i32* %38, align 4, !dbg !1433
  %524 = load volatile i32, i32* %35, align 4, !dbg !1434
  %525 = icmp ne i32 %524, 0, !dbg !1434
  %526 = zext i1 %525 to i64, !dbg !1434
  %527 = select i1 %525, i32 0, i32 3, !dbg !1434
  %528 = load i32, i32* @interlaced, align 4, !dbg !1435
  call void @png_set_IHDR(%struct.png_struct_def* %511, %struct.png_info_struct* %512, i32 %517, i32 %522, i32 %523, i32 %527, i32 %528, i32 0, i32 0), !dbg !1436
  %529 = load i32, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 7), align 4, !dbg !1437
  %530 = icmp ne i32 %529, 0, !dbg !1439
  br i1 %530, label %531, label %539, !dbg !1440

531:                                              ; preds = %510
  %532 = load i32, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 7), align 4, !dbg !1441
  %533 = icmp ne i32 %532, 49, !dbg !1442
  br i1 %533, label %534, label %539, !dbg !1443

534:                                              ; preds = %531
  %535 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1444
  %536 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1445
  %537 = load i32, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 7), align 4, !dbg !1446
  %538 = add i32 %537, 15, !dbg !1447
  call void @png_set_pHYs(%struct.png_struct_def* %535, %struct.png_info_struct* %536, i32 %538, i32 64, i32 0), !dbg !1448
  br label %539, !dbg !1448

539:                                              ; preds = %534, %531, %510
  %540 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !1449
  %541 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %540, i32 0, i32 2, !dbg !1451
  %542 = load i32, i32* %541, align 8, !dbg !1451
  %543 = icmp sgt i32 %542, 0, !dbg !1452
  br i1 %543, label %544, label %558, !dbg !1453

544:                                              ; preds = %539
  %545 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !1454
  %546 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %545, i32 0, i32 3, !dbg !1455
  %547 = load i32, i32* %546, align 4, !dbg !1455
  %548 = icmp sgt i32 %547, 0, !dbg !1456
  br i1 %548, label %549, label %558, !dbg !1457

549:                                              ; preds = %544
  %550 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1458
  %551 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1459
  %552 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !1460
  %553 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %552, i32 0, i32 2, !dbg !1461
  %554 = load i32, i32* %553, align 8, !dbg !1461
  %555 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !1462
  %556 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %555, i32 0, i32 3, !dbg !1463
  %557 = load i32, i32* %556, align 4, !dbg !1463
  call void @png_set_oFFs(%struct.png_struct_def* %550, %struct.png_info_struct* %551, i32 %554, i32 %557, i32 0), !dbg !1464
  br label %558, !dbg !1464

558:                                              ; preds = %549, %544, %539
  %559 = load i32, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 6), align 4, !dbg !1465
  %560 = icmp sgt i32 %559, 0, !dbg !1467
  br i1 %560, label %561, label %650, !dbg !1468

561:                                              ; preds = %558
  %562 = load volatile i32, i32* %35, align 4, !dbg !1469
  %563 = icmp ne i32 %562, 0, !dbg !1469
  br i1 %563, label %564, label %583, !dbg !1472

564:                                              ; preds = %561
  %565 = load i32, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 6), align 4, !dbg !1473
  %566 = sext i32 %565 to i64, !dbg !1476
  %567 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 2), i64 0, i64 %566, !dbg !1476
  %568 = bitcast i64* %41 to i8*, !dbg !1477
  %569 = bitcast %struct.png_color_struct* %567 to i8*, !dbg !1477
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %568, i8* align 1 %569, i64 3, i1 false), !dbg !1477
  %570 = load i64, i64* %41, align 8, !dbg !1477
  %571 = call i32 @is_gray(i64 %570), !dbg !1477
  %572 = icmp ne i32 %571, 0, !dbg !1477
  br i1 %572, label %573, label %582, !dbg !1478

573:                                              ; preds = %564
  %574 = load i32, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 6), align 4, !dbg !1479
  %575 = sext i32 %574 to i64, !dbg !1481
  %576 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %575, !dbg !1481
  %577 = load i8, i8* %576, align 1, !dbg !1481
  %578 = zext i8 %577 to i16, !dbg !1481
  %579 = getelementptr inbounds %struct.png_color_16_struct, %struct.png_color_16_struct* %25, i32 0, i32 4, !dbg !1482
  store i16 %578, i16* %579, align 2, !dbg !1483
  %580 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1484
  %581 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1485
  call void @png_set_bKGD(%struct.png_struct_def* %580, %struct.png_info_struct* %581, %struct.png_color_16_struct* %25), !dbg !1486
  br label %582, !dbg !1487

582:                                              ; preds = %573, %564
  br label %649, !dbg !1488

583:                                              ; preds = %561
  store i32 0, i32* %10, align 4, !dbg !1489
  br label %584, !dbg !1492

584:                                              ; preds = %645, %583
  %585 = load i32, i32* %10, align 4, !dbg !1493
  %586 = icmp slt i32 %585, 256, !dbg !1495
  br i1 %586, label %587, label %648, !dbg !1496

587:                                              ; preds = %584
  %588 = load i32, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 6), align 4, !dbg !1497
  %589 = sext i32 %588 to i64, !dbg !1500
  %590 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 2), i64 0, i64 %589, !dbg !1500
  %591 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %590, i32 0, i32 0, !dbg !1501
  %592 = load i8, i8* %591, align 1, !dbg !1501
  %593 = zext i8 %592 to i32, !dbg !1500
  %594 = load %struct.png_color_struct*, %struct.png_color_struct** %13, align 8, !dbg !1502
  %595 = load i32, i32* %10, align 4, !dbg !1503
  %596 = sext i32 %595 to i64, !dbg !1502
  %597 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %594, i64 %596, !dbg !1502
  %598 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %597, i32 0, i32 0, !dbg !1504
  %599 = load i8, i8* %598, align 1, !dbg !1504
  %600 = zext i8 %599 to i32, !dbg !1502
  %601 = icmp eq i32 %593, %600, !dbg !1505
  br i1 %601, label %602, label %644, !dbg !1506

602:                                              ; preds = %587
  %603 = load i32, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 6), align 4, !dbg !1507
  %604 = sext i32 %603 to i64, !dbg !1508
  %605 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 2), i64 0, i64 %604, !dbg !1508
  %606 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %605, i32 0, i32 1, !dbg !1509
  %607 = load i8, i8* %606, align 1, !dbg !1509
  %608 = zext i8 %607 to i32, !dbg !1508
  %609 = load %struct.png_color_struct*, %struct.png_color_struct** %13, align 8, !dbg !1510
  %610 = load i32, i32* %10, align 4, !dbg !1511
  %611 = sext i32 %610 to i64, !dbg !1510
  %612 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %609, i64 %611, !dbg !1510
  %613 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %612, i32 0, i32 1, !dbg !1512
  %614 = load i8, i8* %613, align 1, !dbg !1512
  %615 = zext i8 %614 to i32, !dbg !1510
  %616 = icmp eq i32 %608, %615, !dbg !1513
  br i1 %616, label %617, label %644, !dbg !1514

617:                                              ; preds = %602
  %618 = load i32, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 6), align 4, !dbg !1515
  %619 = sext i32 %618 to i64, !dbg !1516
  %620 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 2), i64 0, i64 %619, !dbg !1516
  %621 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %620, i32 0, i32 2, !dbg !1517
  %622 = load i8, i8* %621, align 1, !dbg !1517
  %623 = zext i8 %622 to i32, !dbg !1516
  %624 = load %struct.png_color_struct*, %struct.png_color_struct** %13, align 8, !dbg !1518
  %625 = load i32, i32* %10, align 4, !dbg !1519
  %626 = sext i32 %625 to i64, !dbg !1518
  %627 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %624, i64 %626, !dbg !1518
  %628 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %627, i32 0, i32 2, !dbg !1520
  %629 = load i8, i8* %628, align 1, !dbg !1520
  %630 = zext i8 %629 to i32, !dbg !1518
  %631 = icmp eq i32 %623, %630, !dbg !1521
  br i1 %631, label %632, label %644, !dbg !1522

632:                                              ; preds = %617
  %633 = load volatile i32, i32* %36, align 4, !dbg !1523
  %634 = load i32, i32* %10, align 4, !dbg !1526
  %635 = icmp slt i32 %633, %634, !dbg !1527
  br i1 %635, label %636, label %638, !dbg !1528

636:                                              ; preds = %632
  %637 = load i32, i32* %10, align 4, !dbg !1529
  store volatile i32 %637, i32* %36, align 4, !dbg !1530
  br label %638, !dbg !1531

638:                                              ; preds = %636, %632
  %639 = load i32, i32* %10, align 4, !dbg !1532
  %640 = trunc i32 %639 to i8, !dbg !1532
  %641 = getelementptr inbounds %struct.png_color_16_struct, %struct.png_color_16_struct* %25, i32 0, i32 0, !dbg !1533
  store i8 %640, i8* %641, align 2, !dbg !1534
  %642 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1535
  %643 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1536
  call void @png_set_bKGD(%struct.png_struct_def* %642, %struct.png_info_struct* %643, %struct.png_color_16_struct* %25), !dbg !1537
  br label %648, !dbg !1538

644:                                              ; preds = %617, %602, %587
  br label %645, !dbg !1539

645:                                              ; preds = %644
  %646 = load i32, i32* %10, align 4, !dbg !1540
  %647 = add nsw i32 %646, 1, !dbg !1540
  store i32 %647, i32* %10, align 4, !dbg !1540
  br label %584, !dbg !1541, !llvm.loop !1542

648:                                              ; preds = %638, %584
  br label %649

649:                                              ; preds = %648, %582
  br label %650, !dbg !1544

650:                                              ; preds = %649, %558
  %651 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !1545
  %652 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %651, i32 0, i32 6, !dbg !1547
  %653 = load i32, i32* %652, align 8, !dbg !1547
  %654 = icmp ne i32 %653, -1, !dbg !1548
  br i1 %654, label %655, label %710, !dbg !1549

655:                                              ; preds = %650
  %656 = load volatile i32, i32* %35, align 4, !dbg !1550
  %657 = icmp ne i32 %656, 0, !dbg !1550
  br i1 %657, label %658, label %675, !dbg !1553

658:                                              ; preds = %655
  %659 = load i32, i32* @verbose, align 4, !dbg !1554
  %660 = icmp sgt i32 %659, 2, !dbg !1557
  br i1 %660, label %661, label %664, !dbg !1558

661:                                              ; preds = %658
  %662 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1559
  %663 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %662, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.9, i64 0, i64 0)), !dbg !1560
  br label %664, !dbg !1560

664:                                              ; preds = %661, %658
  %665 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !1561
  %666 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %665, i32 0, i32 6, !dbg !1562
  %667 = load i32, i32* %666, align 8, !dbg !1562
  %668 = sext i32 %667 to i64, !dbg !1563
  %669 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %668, !dbg !1563
  %670 = load i8, i8* %669, align 1, !dbg !1563
  %671 = zext i8 %670 to i16, !dbg !1563
  %672 = getelementptr inbounds %struct.png_color_16_struct, %struct.png_color_16_struct* %24, i32 0, i32 4, !dbg !1564
  store i16 %671, i16* %672, align 2, !dbg !1565
  %673 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1566
  %674 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1567
  call void @png_set_tRNS(%struct.png_struct_def* %673, %struct.png_info_struct* %674, i8* null, i32 0, %struct.png_color_16_struct* %24), !dbg !1568
  br label %709, !dbg !1569

675:                                              ; preds = %655
  %676 = load i32, i32* @verbose, align 4, !dbg !1570
  %677 = icmp sgt i32 %676, 2, !dbg !1573
  br i1 %677, label %678, label %681, !dbg !1574

678:                                              ; preds = %675
  %679 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1575
  %680 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %679, i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.10, i64 0, i64 0)), !dbg !1576
  br label %681, !dbg !1576

681:                                              ; preds = %678, %675
  store volatile i32 1, i32* %37, align 4, !dbg !1577
  store i32 0, i32* %10, align 4, !dbg !1578
  br label %682, !dbg !1580

682:                                              ; preds = %691, %681
  %683 = load i32, i32* %10, align 4, !dbg !1581
  %684 = icmp slt i32 %683, 256, !dbg !1583
  br i1 %684, label %685, label %694, !dbg !1584

685:                                              ; preds = %682
  %686 = load i32, i32* %10, align 4, !dbg !1585
  %687 = trunc i32 %686 to i8, !dbg !1585
  %688 = load i32, i32* %10, align 4, !dbg !1586
  %689 = sext i32 %688 to i64, !dbg !1587
  %690 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %689, !dbg !1587
  store i8 %687, i8* %690, align 1, !dbg !1588
  br label %691, !dbg !1587

691:                                              ; preds = %685
  %692 = load i32, i32* %10, align 4, !dbg !1589
  %693 = add nsw i32 %692, 1, !dbg !1589
  store i32 %693, i32* %10, align 4, !dbg !1589
  br label %682, !dbg !1590, !llvm.loop !1591

694:                                              ; preds = %682
  %695 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !1593
  %696 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %695, i32 0, i32 6, !dbg !1594
  %697 = load i32, i32* %696, align 8, !dbg !1594
  %698 = trunc i32 %697 to i8, !dbg !1593
  %699 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 0, !dbg !1595
  store i8 %698, i8* %699, align 1, !dbg !1596
  %700 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !1597
  %701 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %700, i32 0, i32 6, !dbg !1598
  %702 = load i32, i32* %701, align 8, !dbg !1598
  %703 = sext i32 %702 to i64, !dbg !1599
  %704 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %703, !dbg !1599
  store i8 0, i8* %704, align 1, !dbg !1600
  %705 = getelementptr inbounds [256 x i8], [256 x i8]* %23, i64 0, i64 0, !dbg !1601
  store i8 0, i8* %705, align 1, !dbg !1602
  %706 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1603
  %707 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1604
  %708 = getelementptr inbounds [256 x i8], [256 x i8]* %23, i64 0, i64 0, !dbg !1605
  call void @png_set_tRNS(%struct.png_struct_def* %706, %struct.png_info_struct* %707, i8* %708, i32 1, %struct.png_color_16_struct* null), !dbg !1606
  br label %709

709:                                              ; preds = %694, %664
  br label %710, !dbg !1607

710:                                              ; preds = %709, %650
  %711 = load volatile i32, i32* %35, align 4, !dbg !1608
  %712 = icmp ne i32 %711, 0, !dbg !1608
  br i1 %712, label %839, label %713, !dbg !1610

713:                                              ; preds = %710
  %714 = load volatile i32, i32* %37, align 4, !dbg !1611
  %715 = icmp ne i32 %714, 0, !dbg !1611
  br i1 %715, label %716, label %781, !dbg !1614

716:                                              ; preds = %713
  %717 = load i32, i32* @verbose, align 4, !dbg !1615
  %718 = icmp sgt i32 %717, 2, !dbg !1618
  br i1 %718, label %719, label %722, !dbg !1619

719:                                              ; preds = %716
  %720 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1620
  %721 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %720, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.11, i64 0, i64 0)), !dbg !1621
  br label %722, !dbg !1621

722:                                              ; preds = %719, %716
  store i32 0, i32* %10, align 4, !dbg !1622
  br label %723, !dbg !1624

723:                                              ; preds = %776, %722
  %724 = load i32, i32* %10, align 4, !dbg !1625
  %725 = load volatile i32, i32* %36, align 4, !dbg !1627
  %726 = icmp sle i32 %724, %725, !dbg !1628
  br i1 %726, label %727, label %779, !dbg !1629

727:                                              ; preds = %723
  %728 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !1630
  %729 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %728, i32 0, i32 5, !dbg !1632
  %730 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %729, align 8, !dbg !1632
  %731 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %730, i32 0, i32 0, !dbg !1633
  %732 = load i32, i32* %10, align 4, !dbg !1634
  %733 = sext i32 %732 to i64, !dbg !1635
  %734 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %733, !dbg !1635
  %735 = load i8, i8* %734, align 1, !dbg !1635
  %736 = zext i8 %735 to i64, !dbg !1630
  %737 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* %731, i64 0, i64 %736, !dbg !1630
  %738 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %737, i32 0, i32 0, !dbg !1636
  %739 = load i8, i8* %738, align 1, !dbg !1636
  %740 = load i32, i32* %10, align 4, !dbg !1637
  %741 = sext i32 %740 to i64, !dbg !1638
  %742 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* %21, i64 0, i64 %741, !dbg !1638
  %743 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %742, i32 0, i32 0, !dbg !1639
  store i8 %739, i8* %743, align 1, !dbg !1640
  %744 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !1641
  %745 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %744, i32 0, i32 5, !dbg !1642
  %746 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %745, align 8, !dbg !1642
  %747 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %746, i32 0, i32 0, !dbg !1643
  %748 = load i32, i32* %10, align 4, !dbg !1644
  %749 = sext i32 %748 to i64, !dbg !1645
  %750 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %749, !dbg !1645
  %751 = load i8, i8* %750, align 1, !dbg !1645
  %752 = zext i8 %751 to i64, !dbg !1641
  %753 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* %747, i64 0, i64 %752, !dbg !1641
  %754 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %753, i32 0, i32 1, !dbg !1646
  %755 = load i8, i8* %754, align 1, !dbg !1646
  %756 = load i32, i32* %10, align 4, !dbg !1647
  %757 = sext i32 %756 to i64, !dbg !1648
  %758 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* %21, i64 0, i64 %757, !dbg !1648
  %759 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %758, i32 0, i32 1, !dbg !1649
  store i8 %755, i8* %759, align 1, !dbg !1650
  %760 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !1651
  %761 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %760, i32 0, i32 5, !dbg !1652
  %762 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %761, align 8, !dbg !1652
  %763 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %762, i32 0, i32 0, !dbg !1653
  %764 = load i32, i32* %10, align 4, !dbg !1654
  %765 = sext i32 %764 to i64, !dbg !1655
  %766 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %765, !dbg !1655
  %767 = load i8, i8* %766, align 1, !dbg !1655
  %768 = zext i8 %767 to i64, !dbg !1651
  %769 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* %763, i64 0, i64 %768, !dbg !1651
  %770 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %769, i32 0, i32 2, !dbg !1656
  %771 = load i8, i8* %770, align 1, !dbg !1656
  %772 = load i32, i32* %10, align 4, !dbg !1657
  %773 = sext i32 %772 to i64, !dbg !1658
  %774 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* %21, i64 0, i64 %773, !dbg !1658
  %775 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %774, i32 0, i32 2, !dbg !1659
  store i8 %771, i8* %775, align 1, !dbg !1660
  br label %776, !dbg !1661

776:                                              ; preds = %727
  %777 = load i32, i32* %10, align 4, !dbg !1662
  %778 = add nsw i32 %777, 1, !dbg !1662
  store i32 %778, i32* %10, align 4, !dbg !1662
  br label %723, !dbg !1663, !llvm.loop !1664

779:                                              ; preds = %723
  %780 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* %21, i64 0, i64 0, !dbg !1666
  store %struct.png_color_struct* %780, %struct.png_color_struct** %22, align 8, !dbg !1667
  br label %793, !dbg !1668

781:                                              ; preds = %713
  %782 = load i32, i32* @verbose, align 4, !dbg !1669
  %783 = icmp sgt i32 %782, 2, !dbg !1672
  br i1 %783, label %784, label %787, !dbg !1673

784:                                              ; preds = %781
  %785 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1674
  %786 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %785, i8* getelementptr inbounds ([35 x i8], [35 x i8]* @.str.12, i64 0, i64 0)), !dbg !1675
  br label %787, !dbg !1675

787:                                              ; preds = %784, %781
  %788 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !1676
  %789 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %788, i32 0, i32 5, !dbg !1677
  %790 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %789, align 8, !dbg !1677
  %791 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %790, i32 0, i32 0, !dbg !1678
  %792 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* %791, i64 0, i64 0, !dbg !1676
  store %struct.png_color_struct* %792, %struct.png_color_struct** %22, align 8, !dbg !1679
  br label %793

793:                                              ; preds = %787, %779
  %794 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1680
  %795 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1681
  %796 = load %struct.png_color_struct*, %struct.png_color_struct** %22, align 8, !dbg !1682
  %797 = load volatile i32, i32* %36, align 4, !dbg !1683
  %798 = add nsw i32 %797, 1, !dbg !1684
  call void @png_set_PLTE(%struct.png_struct_def* %794, %struct.png_info_struct* %795, %struct.png_color_struct* %796, i32 %798), !dbg !1685
  %799 = load i32, i32* @verbose, align 4, !dbg !1686
  %800 = icmp sgt i32 %799, 2, !dbg !1688
  br i1 %800, label %801, label %838, !dbg !1689

801:                                              ; preds = %793
  %802 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1690
  %803 = load volatile i32, i32* %36, align 4, !dbg !1692
  %804 = add nsw i32 %803, 1, !dbg !1693
  %805 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %802, i8* getelementptr inbounds ([39 x i8], [39 x i8]* @.str.13, i64 0, i64 0), i32 %804), !dbg !1694
  store i32 0, i32* %10, align 4, !dbg !1695
  br label %806, !dbg !1697

806:                                              ; preds = %834, %801
  %807 = load i32, i32* %10, align 4, !dbg !1698
  %808 = load volatile i32, i32* %36, align 4, !dbg !1700
  %809 = icmp sle i32 %807, %808, !dbg !1701
  br i1 %809, label %810, label %837, !dbg !1702

810:                                              ; preds = %806
  %811 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1703
  %812 = load %struct.png_color_struct*, %struct.png_color_struct** %22, align 8, !dbg !1705
  %813 = load i32, i32* %10, align 4, !dbg !1706
  %814 = sext i32 %813 to i64, !dbg !1705
  %815 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %812, i64 %814, !dbg !1705
  %816 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %815, i32 0, i32 0, !dbg !1707
  %817 = load i8, i8* %816, align 1, !dbg !1707
  %818 = zext i8 %817 to i32, !dbg !1705
  %819 = load %struct.png_color_struct*, %struct.png_color_struct** %22, align 8, !dbg !1708
  %820 = load i32, i32* %10, align 4, !dbg !1709
  %821 = sext i32 %820 to i64, !dbg !1708
  %822 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %819, i64 %821, !dbg !1708
  %823 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %822, i32 0, i32 2, !dbg !1710
  %824 = load i8, i8* %823, align 1, !dbg !1710
  %825 = zext i8 %824 to i32, !dbg !1708
  %826 = load %struct.png_color_struct*, %struct.png_color_struct** %22, align 8, !dbg !1711
  %827 = load i32, i32* %10, align 4, !dbg !1712
  %828 = sext i32 %827 to i64, !dbg !1711
  %829 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %826, i64 %828, !dbg !1711
  %830 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %829, i32 0, i32 1, !dbg !1713
  %831 = load i8, i8* %830, align 1, !dbg !1713
  %832 = zext i8 %831 to i32, !dbg !1711
  %833 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %811, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.6, i64 0, i64 0), i32 %818, i32 %825, i32 %832), !dbg !1714
  br label %834, !dbg !1715

834:                                              ; preds = %810
  %835 = load i32, i32* %10, align 4, !dbg !1716
  %836 = add nsw i32 %835, 1, !dbg !1716
  store i32 %836, i32* %10, align 4, !dbg !1716
  br label %806, !dbg !1717, !llvm.loop !1718

837:                                              ; preds = %806
  br label %838, !dbg !1720

838:                                              ; preds = %837, %793
  br label %839, !dbg !1721

839:                                              ; preds = %838, %710
  %840 = load i32, i32* @histogram, align 4, !dbg !1722
  %841 = icmp ne i32 %840, 0, !dbg !1722
  br i1 %841, label %842, label %938, !dbg !1724

842:                                              ; preds = %839
  %843 = load volatile i32, i32* %35, align 4, !dbg !1725
  %844 = icmp ne i32 %843, 0, !dbg !1725
  br i1 %844, label %938, label %845, !dbg !1726

845:                                              ; preds = %842
  store i64 0, i64* %29, align 8, !dbg !1727
  store i32 0, i32* %10, align 4, !dbg !1729
  br label %846, !dbg !1731

846:                                              ; preds = %864, %845
  %847 = load i32, i32* %10, align 4, !dbg !1732
  %848 = icmp slt i32 %847, 256, !dbg !1734
  br i1 %848, label %849, label %867, !dbg !1735

849:                                              ; preds = %846
  %850 = load i64*, i64** %12, align 8, !dbg !1736
  %851 = load i32, i32* %10, align 4, !dbg !1738
  %852 = sext i32 %851 to i64, !dbg !1736
  %853 = getelementptr inbounds i64, i64* %850, i64 %852, !dbg !1736
  %854 = load i64, i64* %853, align 8, !dbg !1736
  %855 = load i64, i64* %29, align 8, !dbg !1739
  %856 = icmp ugt i64 %854, %855, !dbg !1740
  br i1 %856, label %857, label %863, !dbg !1741

857:                                              ; preds = %849
  %858 = load i64*, i64** %12, align 8, !dbg !1742
  %859 = load i32, i32* %10, align 4, !dbg !1743
  %860 = sext i32 %859 to i64, !dbg !1742
  %861 = getelementptr inbounds i64, i64* %858, i64 %860, !dbg !1742
  %862 = load i64, i64* %861, align 8, !dbg !1742
  store i64 %862, i64* %29, align 8, !dbg !1744
  br label %863, !dbg !1745

863:                                              ; preds = %857, %849
  br label %864, !dbg !1739

864:                                              ; preds = %863
  %865 = load i32, i32* %10, align 4, !dbg !1746
  %866 = add nsw i32 %865, 1, !dbg !1746
  store i32 %866, i32* %10, align 4, !dbg !1746
  br label %846, !dbg !1747, !llvm.loop !1748

867:                                              ; preds = %846
  %868 = load i64, i64* %29, align 8, !dbg !1750
  %869 = icmp ule i64 %868, 65535, !dbg !1752
  br i1 %869, label %870, label %888, !dbg !1753

870:                                              ; preds = %867
  store i32 0, i32* %10, align 4, !dbg !1754
  br label %871, !dbg !1757

871:                                              ; preds = %884, %870
  %872 = load i32, i32* %10, align 4, !dbg !1758
  %873 = icmp slt i32 %872, 256, !dbg !1760
  br i1 %873, label %874, label %887, !dbg !1761

874:                                              ; preds = %871
  %875 = load i64*, i64** %12, align 8, !dbg !1762
  %876 = load i32, i32* %10, align 4, !dbg !1763
  %877 = sext i32 %876 to i64, !dbg !1762
  %878 = getelementptr inbounds i64, i64* %875, i64 %877, !dbg !1762
  %879 = load i64, i64* %878, align 8, !dbg !1762
  %880 = trunc i64 %879 to i16, !dbg !1764
  %881 = load i32, i32* %10, align 4, !dbg !1765
  %882 = sext i32 %881 to i64, !dbg !1766
  %883 = getelementptr inbounds [256 x i16], [256 x i16]* %28, i64 0, i64 %882, !dbg !1766
  store i16 %880, i16* %883, align 2, !dbg !1767
  br label %884, !dbg !1766

884:                                              ; preds = %874
  %885 = load i32, i32* %10, align 4, !dbg !1768
  %886 = add nsw i32 %885, 1, !dbg !1768
  store i32 %886, i32* %10, align 4, !dbg !1768
  br label %871, !dbg !1769, !llvm.loop !1770

887:                                              ; preds = %871
  br label %934, !dbg !1772

888:                                              ; preds = %867
  store i32 0, i32* %10, align 4, !dbg !1773
  br label %889, !dbg !1776

889:                                              ; preds = %930, %888
  %890 = load i32, i32* %10, align 4, !dbg !1777
  %891 = icmp slt i32 %890, 256, !dbg !1779
  br i1 %891, label %892, label %933, !dbg !1780

892:                                              ; preds = %889
  %893 = load i64*, i64** %12, align 8, !dbg !1781
  %894 = load i32, i32* %10, align 4, !dbg !1783
  %895 = sext i32 %894 to i64, !dbg !1781
  %896 = getelementptr inbounds i64, i64* %893, i64 %895, !dbg !1781
  %897 = load i64, i64* %896, align 8, !dbg !1781
  %898 = icmp ne i64 %897, 0, !dbg !1781
  br i1 %898, label %899, label %925, !dbg !1784

899:                                              ; preds = %892
  %900 = load i64*, i64** %12, align 8, !dbg !1785
  %901 = load i32, i32* %10, align 4, !dbg !1787
  %902 = sext i32 %901 to i64, !dbg !1785
  %903 = getelementptr inbounds i64, i64* %900, i64 %902, !dbg !1785
  %904 = load i64, i64* %903, align 8, !dbg !1785
  %905 = uitofp i64 %904 to double, !dbg !1788
  %906 = fmul double %905, 6.553500e+04, !dbg !1789
  %907 = load i64, i64* %29, align 8, !dbg !1790
  %908 = uitofp i64 %907 to double, !dbg !1790
  %909 = fdiv double %906, %908, !dbg !1791
  %910 = fptoui double %909 to i16, !dbg !1792
  %911 = load i32, i32* %10, align 4, !dbg !1793
  %912 = sext i32 %911 to i64, !dbg !1794
  %913 = getelementptr inbounds [256 x i16], [256 x i16]* %28, i64 0, i64 %912, !dbg !1794
  store i16 %910, i16* %913, align 2, !dbg !1795
  %914 = load i32, i32* %10, align 4, !dbg !1796
  %915 = sext i32 %914 to i64, !dbg !1798
  %916 = getelementptr inbounds [256 x i16], [256 x i16]* %28, i64 0, i64 %915, !dbg !1798
  %917 = load i16, i16* %916, align 2, !dbg !1798
  %918 = zext i16 %917 to i32, !dbg !1798
  %919 = icmp eq i32 %918, 0, !dbg !1799
  br i1 %919, label %920, label %924, !dbg !1800

920:                                              ; preds = %899
  %921 = load i32, i32* %10, align 4, !dbg !1801
  %922 = sext i32 %921 to i64, !dbg !1802
  %923 = getelementptr inbounds [256 x i16], [256 x i16]* %28, i64 0, i64 %922, !dbg !1802
  store i16 1, i16* %923, align 2, !dbg !1803
  br label %924, !dbg !1802

924:                                              ; preds = %920, %899
  br label %929, !dbg !1804

925:                                              ; preds = %892
  %926 = load i32, i32* %10, align 4, !dbg !1805
  %927 = sext i32 %926 to i64, !dbg !1807
  %928 = getelementptr inbounds [256 x i16], [256 x i16]* %28, i64 0, i64 %927, !dbg !1807
  store i16 0, i16* %928, align 2, !dbg !1808
  br label %929

929:                                              ; preds = %925, %924
  br label %930, !dbg !1809

930:                                              ; preds = %929
  %931 = load i32, i32* %10, align 4, !dbg !1810
  %932 = add nsw i32 %931, 1, !dbg !1810
  store i32 %932, i32* %10, align 4, !dbg !1810
  br label %889, !dbg !1811, !llvm.loop !1812

933:                                              ; preds = %889
  br label %934

934:                                              ; preds = %933, %887
  %935 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1814
  %936 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1815
  %937 = getelementptr inbounds [256 x i16], [256 x i16]* %28, i64 0, i64 0, !dbg !1816
  call void @png_set_hIST(%struct.png_struct_def* %935, %struct.png_info_struct* %936, i16* %937), !dbg !1817
  br label %938, !dbg !1818

938:                                              ; preds = %934, %842, %839
  %939 = load i32, i32* @software_chunk, align 4, !dbg !1819
  %940 = icmp ne i32 %939, 0, !dbg !1819
  br i1 %940, label %941, label %951, !dbg !1821

941:                                              ; preds = %938
  %942 = getelementptr inbounds %struct.png_text_struct, %struct.png_text_struct* %33, i32 0, i32 0, !dbg !1822
  store i32 -1, i32* %942, align 8, !dbg !1824
  %943 = getelementptr inbounds %struct.png_text_struct, %struct.png_text_struct* %33, i32 0, i32 1, !dbg !1825
  store i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.14, i64 0, i64 0), i8** %943, align 8, !dbg !1826
  %944 = getelementptr inbounds %struct.png_text_struct, %struct.png_text_struct* %33, i32 0, i32 2, !dbg !1827
  store i8* getelementptr inbounds ([14 x i8], [14 x i8]* @version, i64 0, i64 0), i8** %944, align 8, !dbg !1828
  %945 = getelementptr inbounds %struct.png_text_struct, %struct.png_text_struct* %33, i32 0, i32 2, !dbg !1829
  %946 = load i8*, i8** %945, align 8, !dbg !1829
  %947 = call i64 @strlen(i8* %946) #10, !dbg !1830
  %948 = getelementptr inbounds %struct.png_text_struct, %struct.png_text_struct* %33, i32 0, i32 3, !dbg !1831
  store i64 %947, i64* %948, align 8, !dbg !1832
  %949 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1833
  %950 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1834
  call void @png_set_text(%struct.png_struct_def* %949, %struct.png_info_struct* %950, %struct.png_text_struct* %33, i32 1), !dbg !1835
  br label %951, !dbg !1836

951:                                              ; preds = %941, %938
  %952 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1837
  %953 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !1838
  call void @png_write_info(%struct.png_struct_def* %952, %struct.png_info_struct* %953), !dbg !1839
  %954 = load volatile i32, i32* %38, align 4, !dbg !1840
  %955 = icmp slt i32 %954, 8, !dbg !1842
  br i1 %955, label %956, label %958, !dbg !1843

956:                                              ; preds = %951
  %957 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1844
  call void @png_set_packing(%struct.png_struct_def* %957), !dbg !1845
  br label %958, !dbg !1845

958:                                              ; preds = %956, %951
  br label %959, !dbg !1846

959:                                              ; preds = %1202, %958
  %960 = load i32, i32* %9, align 4, !dbg !1847
  %961 = icmp ne i32 %960, 0, !dbg !1847
  br i1 %961, label %962, label %966, !dbg !1847

962:                                              ; preds = %959
  %963 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !1848
  %964 = icmp ne %struct.GIFelement* %963, null, !dbg !1849
  %965 = zext i1 %964 to i32, !dbg !1849
  br label %973, !dbg !1847

966:                                              ; preds = %959
  %967 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !1850
  %968 = load %struct.GIFelement*, %struct.GIFelement** %7, align 8, !dbg !1851
  %969 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %968, i32 0, i32 0, !dbg !1852
  %970 = load %struct.GIFelement*, %struct.GIFelement** %969, align 8, !dbg !1852
  %971 = icmp ne %struct.GIFelement* %967, %970, !dbg !1853
  %972 = zext i1 %971 to i32, !dbg !1853
  br label %973, !dbg !1847

973:                                              ; preds = %966, %962
  %974 = phi i32 [ %965, %962 ], [ %972, %966 ], !dbg !1847
  %975 = icmp ne i32 %974, 0, !dbg !1846
  br i1 %975, label %976, label %1206, !dbg !1846

976:                                              ; preds = %973
  call void @llvm.dbg.declare(metadata i8** %42, metadata !1854, metadata !DIExpression()), !dbg !1856
  %977 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !1857
  %978 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %977, i32 0, i32 1, !dbg !1858
  %979 = load i8, i8* %978, align 8, !dbg !1858
  %980 = zext i8 %979 to i32, !dbg !1859
  switch i32 %980, label %1195 [
    i32 44, label %981
    i32 254, label %1094
    i32 255, label %1146
    i32 249, label %1160
  ], !dbg !1860

981:                                              ; preds = %976
  %982 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1861
  %983 = call i32 @png_set_interlace_handling(%struct.png_struct_def* %982), !dbg !1863
  store i32 %983, i32* %30, align 4, !dbg !1864
  store i32 0, i32* %19, align 4, !dbg !1865
  br label %984, !dbg !1867

984:                                              ; preds = %1090, %981
  %985 = load i32, i32* %19, align 4, !dbg !1868
  %986 = load i32, i32* %30, align 4, !dbg !1870
  %987 = icmp slt i32 %985, %986, !dbg !1871
  br i1 %987, label %988, label %1093, !dbg !1872

988:                                              ; preds = %984
  store i32 0, i32* %10, align 4, !dbg !1873
  br label %989, !dbg !1875

989:                                              ; preds = %1086, %988
  %990 = load i32, i32* %10, align 4, !dbg !1876
  %991 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !1878
  %992 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %991, i32 0, i32 5, !dbg !1879
  %993 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %992, align 8, !dbg !1879
  %994 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %993, i32 0, i32 5, !dbg !1880
  %995 = load i32, i32* %994, align 4, !dbg !1880
  %996 = icmp slt i32 %990, %995, !dbg !1881
  br i1 %996, label %997, label %1089, !dbg !1882

997:                                              ; preds = %989
  %998 = load i32, i32* @progress, align 4, !dbg !1883
  %999 = icmp ne i32 %998, 0, !dbg !1883
  br i1 %999, label %1000, label %1025, !dbg !1886

1000:                                             ; preds = %997
  %1001 = load i32, i32* %30, align 4, !dbg !1887
  %1002 = icmp sgt i32 %1001, 1, !dbg !1890
  br i1 %1002, label %1003, label %1009, !dbg !1891

1003:                                             ; preds = %1000
  %1004 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1892
  %1005 = load i32, i32* %19, align 4, !dbg !1893
  %1006 = add nsw i32 %1005, 1, !dbg !1894
  %1007 = load i32, i32* %30, align 4, !dbg !1895
  %1008 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %1004, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.15, i64 0, i64 0), i32 %1006, i32 %1007), !dbg !1896
  br label %1009, !dbg !1896

1009:                                             ; preds = %1003, %1000
  %1010 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1897
  %1011 = load i32, i32* %10, align 4, !dbg !1898
  %1012 = sext i32 %1011 to i64, !dbg !1899
  %1013 = mul nsw i64 %1012, 100, !dbg !1900
  %1014 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !1901
  %1015 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1014, i32 0, i32 5, !dbg !1902
  %1016 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %1015, align 8, !dbg !1902
  %1017 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %1016, i32 0, i32 5, !dbg !1903
  %1018 = load i32, i32* %1017, align 4, !dbg !1903
  %1019 = sext i32 %1018 to i64, !dbg !1901
  %1020 = sdiv i64 %1013, %1019, !dbg !1904
  %1021 = trunc i64 %1020 to i32, !dbg !1905
  %1022 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %1010, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.16, i64 0, i64 0), i32 %1021), !dbg !1906
  %1023 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1907
  %1024 = call i32 @fflush(%struct._IO_FILE* %1023), !dbg !1908
  br label %1025, !dbg !1909

1025:                                             ; preds = %1009, %997
  %1026 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !1910
  %1027 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1026, i32 0, i32 2, !dbg !1911
  %1028 = load i8*, i8** %1027, align 8, !dbg !1911
  %1029 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !1912
  %1030 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %1029, i32 0, i32 7, !dbg !1913
  %1031 = load i32, i32* %1030, align 4, !dbg !1913
  %1032 = icmp ne i32 %1031, 0, !dbg !1912
  br i1 %1032, label %1033, label %1041, !dbg !1912

1033:                                             ; preds = %1025
  %1034 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !1914
  %1035 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1034, i32 0, i32 5, !dbg !1915
  %1036 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %1035, align 8, !dbg !1915
  %1037 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %1036, i32 0, i32 5, !dbg !1916
  %1038 = load i32, i32* %1037, align 4, !dbg !1916
  %1039 = load i32, i32* %10, align 4, !dbg !1917
  %1040 = call i32 @interlace_line(i32 %1038, i32 %1039), !dbg !1918
  br label %1043, !dbg !1912

1041:                                             ; preds = %1025
  %1042 = load i32, i32* %10, align 4, !dbg !1919
  br label %1043, !dbg !1912

1043:                                             ; preds = %1041, %1033
  %1044 = phi i32 [ %1040, %1033 ], [ %1042, %1041 ], !dbg !1912
  %1045 = sext i32 %1044 to i64, !dbg !1920
  %1046 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !1921
  %1047 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1046, i32 0, i32 5, !dbg !1922
  %1048 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %1047, align 8, !dbg !1922
  %1049 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %1048, i32 0, i32 4, !dbg !1923
  %1050 = load i32, i32* %1049, align 8, !dbg !1923
  %1051 = sext i32 %1050 to i64, !dbg !1921
  %1052 = mul nsw i64 %1045, %1051, !dbg !1924
  %1053 = getelementptr inbounds i8, i8* %1028, i64 %1052, !dbg !1925
  store i8* %1053, i8** %42, align 8, !dbg !1926
  %1054 = load volatile i32, i32* %37, align 4, !dbg !1927
  %1055 = icmp ne i32 %1054, 0, !dbg !1927
  br i1 %1055, label %1056, label %1083, !dbg !1929

1056:                                             ; preds = %1043
  %1057 = load i32, i32* %19, align 4, !dbg !1930
  %1058 = icmp eq i32 %1057, 0, !dbg !1931
  br i1 %1058, label %1059, label %1083, !dbg !1932

1059:                                             ; preds = %1056
  store i32 0, i32* %27, align 4, !dbg !1933
  br label %1060, !dbg !1936

1060:                                             ; preds = %1079, %1059
  %1061 = load i32, i32* %27, align 4, !dbg !1937
  %1062 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %11, align 8, !dbg !1939
  %1063 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %1062, i32 0, i32 4, !dbg !1940
  %1064 = load i32, i32* %1063, align 8, !dbg !1940
  %1065 = icmp slt i32 %1061, %1064, !dbg !1941
  br i1 %1065, label %1066, label %1082, !dbg !1942

1066:                                             ; preds = %1060
  %1067 = load i8*, i8** %42, align 8, !dbg !1943
  %1068 = load i32, i32* %27, align 4, !dbg !1945
  %1069 = sext i32 %1068 to i64, !dbg !1943
  %1070 = getelementptr inbounds i8, i8* %1067, i64 %1069, !dbg !1943
  %1071 = load i8, i8* %1070, align 1, !dbg !1943
  %1072 = zext i8 %1071 to i64, !dbg !1946
  %1073 = getelementptr inbounds [256 x i8], [256 x i8]* %15, i64 0, i64 %1072, !dbg !1946
  %1074 = load i8, i8* %1073, align 1, !dbg !1946
  %1075 = load i8*, i8** %42, align 8, !dbg !1947
  %1076 = load i32, i32* %27, align 4, !dbg !1948
  %1077 = sext i32 %1076 to i64, !dbg !1947
  %1078 = getelementptr inbounds i8, i8* %1075, i64 %1077, !dbg !1947
  store i8 %1074, i8* %1078, align 1, !dbg !1949
  br label %1079, !dbg !1950

1079:                                             ; preds = %1066
  %1080 = load i32, i32* %27, align 4, !dbg !1951
  %1081 = add nsw i32 %1080, 1, !dbg !1951
  store i32 %1081, i32* %27, align 4, !dbg !1951
  br label %1060, !dbg !1952, !llvm.loop !1953

1082:                                             ; preds = %1060
  br label %1083, !dbg !1955

1083:                                             ; preds = %1082, %1056, %1043
  %1084 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !1956
  %1085 = load i8*, i8** %42, align 8, !dbg !1957
  call void @png_write_row(%struct.png_struct_def* %1084, i8* %1085), !dbg !1958
  br label %1086, !dbg !1959

1086:                                             ; preds = %1083
  %1087 = load i32, i32* %10, align 4, !dbg !1960
  %1088 = add nsw i32 %1087, 1, !dbg !1960
  store i32 %1088, i32* %10, align 4, !dbg !1960
  br label %989, !dbg !1961, !llvm.loop !1962

1089:                                             ; preds = %989
  br label %1090, !dbg !1963

1090:                                             ; preds = %1089
  %1091 = load i32, i32* %19, align 4, !dbg !1964
  %1092 = add nsw i32 %1091, 1, !dbg !1964
  store i32 %1092, i32* %19, align 4, !dbg !1964
  br label %984, !dbg !1965, !llvm.loop !1966

1093:                                             ; preds = %984
  br label %1202, !dbg !1968

1094:                                             ; preds = %976
  %1095 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !1969
  %1096 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1095, i32 0, i32 4, !dbg !1970
  %1097 = load i64, i64* %1096, align 8, !dbg !1970
  %1098 = trunc i64 %1097 to i32, !dbg !1969
  store i32 %1098, i32* %27, align 4, !dbg !1971
  %1099 = load i32, i32* %27, align 4, !dbg !1972
  %1100 = icmp sgt i32 %1099, 0, !dbg !1974
  br i1 %1100, label %1101, label %1127, !dbg !1975

1101:                                             ; preds = %1094
  %1102 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !1976
  %1103 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1102, i32 0, i32 2, !dbg !1977
  %1104 = load i8*, i8** %1103, align 8, !dbg !1977
  %1105 = load i32, i32* %27, align 4, !dbg !1978
  %1106 = sub nsw i32 %1105, 1, !dbg !1979
  %1107 = sext i32 %1106 to i64, !dbg !1976
  %1108 = getelementptr inbounds i8, i8* %1104, i64 %1107, !dbg !1976
  %1109 = load i8, i8* %1108, align 1, !dbg !1976
  %1110 = zext i8 %1109 to i32, !dbg !1976
  %1111 = icmp eq i32 %1110, 0, !dbg !1980
  br i1 %1111, label %1124, label %1112, !dbg !1981

1112:                                             ; preds = %1101
  %1113 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !1982
  %1114 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1113, i32 0, i32 2, !dbg !1983
  %1115 = load i8*, i8** %1114, align 8, !dbg !1983
  %1116 = load i32, i32* %27, align 4, !dbg !1984
  %1117 = sub nsw i32 %1116, 1, !dbg !1985
  %1118 = sext i32 %1117 to i64, !dbg !1982
  %1119 = getelementptr inbounds i8, i8* %1115, i64 %1118, !dbg !1982
  %1120 = load i8, i8* %1119, align 1, !dbg !1982
  %1121 = zext i8 %1120 to i32, !dbg !1982
  %1122 = and i32 %1121, 128, !dbg !1986
  %1123 = icmp ne i32 %1122, 0, !dbg !1986
  br i1 %1123, label %1124, label %1127, !dbg !1987

1124:                                             ; preds = %1112, %1101
  %1125 = load i32, i32* %27, align 4, !dbg !1988
  %1126 = add nsw i32 %1125, -1, !dbg !1988
  store i32 %1126, i32* %27, align 4, !dbg !1988
  br label %1127, !dbg !1988

1127:                                             ; preds = %1124, %1112, %1094
  %1128 = getelementptr inbounds %struct.png_text_struct, %struct.png_text_struct* %34, i32 0, i32 1, !dbg !1989
  store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.17, i64 0, i64 0), i8** %1128, align 8, !dbg !1990
  %1129 = load i32, i32* %27, align 4, !dbg !1991
  %1130 = icmp slt i32 %1129, 500, !dbg !1993
  br i1 %1130, label %1131, label %1133, !dbg !1994

1131:                                             ; preds = %1127
  %1132 = getelementptr inbounds %struct.png_text_struct, %struct.png_text_struct* %34, i32 0, i32 0, !dbg !1995
  store i32 -1, i32* %1132, align 8, !dbg !1997
  br label %1135, !dbg !1998

1133:                                             ; preds = %1127
  %1134 = getelementptr inbounds %struct.png_text_struct, %struct.png_text_struct* %34, i32 0, i32 0, !dbg !1999
  store i32 0, i32* %1134, align 8, !dbg !2001
  br label %1135

1135:                                             ; preds = %1133, %1131
  %1136 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !2002
  %1137 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1136, i32 0, i32 2, !dbg !2003
  %1138 = load i8*, i8** %1137, align 8, !dbg !2003
  %1139 = getelementptr inbounds %struct.png_text_struct, %struct.png_text_struct* %34, i32 0, i32 2, !dbg !2004
  store i8* %1138, i8** %1139, align 8, !dbg !2005
  %1140 = getelementptr inbounds %struct.png_text_struct, %struct.png_text_struct* %34, i32 0, i32 2, !dbg !2006
  %1141 = load i8*, i8** %1140, align 8, !dbg !2006
  %1142 = call i64 @strlen(i8* %1141) #10, !dbg !2007
  %1143 = getelementptr inbounds %struct.png_text_struct, %struct.png_text_struct* %34, i32 0, i32 3, !dbg !2008
  store i64 %1142, i64* %1143, align 8, !dbg !2009
  %1144 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !2010
  %1145 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !2011
  call void @png_set_text(%struct.png_struct_def* %1144, %struct.png_info_struct* %1145, %struct.png_text_struct* %34, i32 1), !dbg !2012
  br label %1202, !dbg !2013

1146:                                             ; preds = %976
  %1147 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !2014
  %1148 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !2015
  %1149 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1148, i32 0, i32 4, !dbg !2016
  %1150 = load i64, i64* %1149, align 8, !dbg !2016
  %1151 = trunc i64 %1150 to i32, !dbg !2015
  call void @png_write_chunk_start(%struct.png_struct_def* %1147, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.18, i64 0, i64 0), i32 %1151), !dbg !2017
  %1152 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !2018
  %1153 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !2019
  %1154 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1153, i32 0, i32 2, !dbg !2020
  %1155 = load i8*, i8** %1154, align 8, !dbg !2020
  %1156 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !2021
  %1157 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1156, i32 0, i32 4, !dbg !2022
  %1158 = load i64, i64* %1157, align 8, !dbg !2022
  call void @png_write_chunk_data(%struct.png_struct_def* %1152, i8* %1155, i64 %1158), !dbg !2023
  %1159 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !2024
  call void @png_write_chunk_end(%struct.png_struct_def* %1159), !dbg !2025
  br label %1202, !dbg !2026

1160:                                             ; preds = %976
  %1161 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !2027
  %1162 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1161, i32 0, i32 2, !dbg !2028
  %1163 = load i8*, i8** %1162, align 8, !dbg !2028
  %1164 = getelementptr inbounds i8, i8* %1163, i64 0, !dbg !2027
  %1165 = load i8, i8* %1164, align 1, !dbg !2027
  %1166 = zext i8 %1165 to i32, !dbg !2027
  %1167 = ashr i32 %1166, 2, !dbg !2029
  %1168 = and i32 %1167, 7, !dbg !2030
  %1169 = trunc i32 %1168 to i8, !dbg !2031
  %1170 = getelementptr inbounds [24 x i8], [24 x i8]* %26, i64 0, i64 0, !dbg !2032
  store i8 %1169, i8* %1170, align 1, !dbg !2033
  %1171 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !2034
  %1172 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1171, i32 0, i32 2, !dbg !2035
  %1173 = load i8*, i8** %1172, align 8, !dbg !2035
  %1174 = getelementptr inbounds i8, i8* %1173, i64 0, !dbg !2034
  %1175 = load i8, i8* %1174, align 1, !dbg !2034
  %1176 = zext i8 %1175 to i32, !dbg !2034
  %1177 = ashr i32 %1176, 1, !dbg !2036
  %1178 = and i32 %1177, 1, !dbg !2037
  %1179 = trunc i32 %1178 to i8, !dbg !2038
  %1180 = getelementptr inbounds [24 x i8], [24 x i8]* %26, i64 0, i64 1, !dbg !2039
  store i8 %1179, i8* %1180, align 1, !dbg !2040
  %1181 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !2041
  %1182 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1181, i32 0, i32 2, !dbg !2042
  %1183 = load i8*, i8** %1182, align 8, !dbg !2042
  %1184 = getelementptr inbounds i8, i8* %1183, i64 2, !dbg !2041
  %1185 = load i8, i8* %1184, align 1, !dbg !2041
  %1186 = getelementptr inbounds [24 x i8], [24 x i8]* %26, i64 0, i64 2, !dbg !2043
  store i8 %1185, i8* %1186, align 1, !dbg !2044
  %1187 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !2045
  %1188 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1187, i32 0, i32 2, !dbg !2046
  %1189 = load i8*, i8** %1188, align 8, !dbg !2046
  %1190 = getelementptr inbounds i8, i8* %1189, i64 1, !dbg !2045
  %1191 = load i8, i8* %1190, align 1, !dbg !2045
  %1192 = getelementptr inbounds [24 x i8], [24 x i8]* %26, i64 0, i64 3, !dbg !2047
  store i8 %1191, i8* %1192, align 1, !dbg !2048
  %1193 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !2049
  %1194 = getelementptr inbounds [24 x i8], [24 x i8]* %26, i64 0, i64 0, !dbg !2050
  call void @png_write_chunk(%struct.png_struct_def* %1193, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.19, i64 0, i64 0), i8* %1194, i64 4), !dbg !2051
  br label %1202, !dbg !2052

1195:                                             ; preds = %976
  %1196 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2053
  %1197 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !2054
  %1198 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1197, i32 0, i32 1, !dbg !2055
  %1199 = load i8, i8* %1198, align 8, !dbg !2055
  %1200 = zext i8 %1199 to i32, !dbg !2054
  %1201 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %1196, i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.20, i64 0, i64 0), i32 %1200), !dbg !2056
  br label %1202, !dbg !2057

1202:                                             ; preds = %1195, %1160, %1146, %1135, %1093
  %1203 = load %struct.GIFelement*, %struct.GIFelement** %6, align 8, !dbg !2058
  %1204 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1203, i32 0, i32 0, !dbg !2059
  %1205 = load %struct.GIFelement*, %struct.GIFelement** %1204, align 8, !dbg !2059
  store %struct.GIFelement* %1205, %struct.GIFelement** %6, align 8, !dbg !2060
  br label %959, !dbg !1846, !llvm.loop !2061

1206:                                             ; preds = %973
  %1207 = load %struct.png_struct_def*, %struct.png_struct_def** %17, align 8, !dbg !2063
  %1208 = load %struct.png_info_struct*, %struct.png_info_struct** %18, align 8, !dbg !2064
  call void @png_write_end(%struct.png_struct_def* %1207, %struct.png_info_struct* %1208), !dbg !2065
  call void @png_destroy_write_struct(%struct.png_struct_def** %17, %struct.png_info_struct** %18), !dbg !2066
  %1209 = load i32, i32* %32, align 4, !dbg !2067
  store i32 %1209, i32* %5, align 4, !dbg !2068
  br label %1210, !dbg !2068

1210:                                             ; preds = %1206, %481, %474, %468, %457
  %1211 = load i32, i32* %5, align 4, !dbg !2069
  ret i32 %1211, !dbg !2069
}

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #3

; Function Attrs: noreturn nounwind
declare dso_local void @longjmp(%struct.__jmp_buf_tag*, i32) #4

declare dso_local [1 x %struct.__jmp_buf_tag]* @png_set_longjmp_fn(%struct.png_struct_def*, void (%struct.__jmp_buf_tag*, i32)*, i64) #3

; Function Attrs: nounwind returns_twice
declare dso_local i32 @_setjmp(%struct.__jmp_buf_tag*) #5

; Function Attrs: nounwind
declare dso_local void @free(i8*) #6

declare dso_local noalias %struct.png_struct_def* @png_create_write_struct(i8*, i8*, void (%struct.png_struct_def*, i8*)*, void (%struct.png_struct_def*, i8*)*) #3

declare dso_local noalias %struct.png_info_struct* @png_create_info_struct(%struct.png_struct_def*) #3

declare dso_local void @png_destroy_write_struct(%struct.png_struct_def**, %struct.png_info_struct**) #3

declare dso_local void @png_init_io(%struct.png_struct_def*, %struct._IO_FILE*) #3

declare dso_local void @png_set_compression_level(%struct.png_struct_def*, i32) #3

declare dso_local void @png_set_gAMA(%struct.png_struct_def*, %struct.png_info_struct*, double) #3

declare dso_local void @png_set_sRGB(%struct.png_struct_def*, %struct.png_info_struct*, i32) #3

declare dso_local void @png_set_IHDR(%struct.png_struct_def*, %struct.png_info_struct*, i32, i32, i32, i32, i32, i32, i32) #3

declare dso_local void @png_set_pHYs(%struct.png_struct_def*, %struct.png_info_struct*, i32, i32, i32) #3

declare dso_local void @png_set_oFFs(%struct.png_struct_def*, %struct.png_info_struct*, i32, i32, i32) #3

declare dso_local void @png_set_bKGD(%struct.png_struct_def*, %struct.png_info_struct*, %struct.png_color_16_struct*) #3

declare dso_local void @png_set_tRNS(%struct.png_struct_def*, %struct.png_info_struct*, i8*, i32, %struct.png_color_16_struct*) #3

declare dso_local void @png_set_PLTE(%struct.png_struct_def*, %struct.png_info_struct*, %struct.png_color_struct*, i32) #3

declare dso_local void @png_set_hIST(%struct.png_struct_def*, %struct.png_info_struct*, i16*) #3

; Function Attrs: nounwind readonly
declare dso_local i64 @strlen(i8*) #7

declare dso_local void @png_set_text(%struct.png_struct_def*, %struct.png_info_struct*, %struct.png_text_struct*, i32) #3

declare dso_local void @png_write_info(%struct.png_struct_def*, %struct.png_info_struct*) #3

declare dso_local void @png_set_packing(%struct.png_struct_def*) #3

declare dso_local i32 @png_set_interlace_handling(%struct.png_struct_def*) #3

declare dso_local i32 @fflush(%struct._IO_FILE*) #3

declare dso_local void @png_write_row(%struct.png_struct_def*, i8*) #3

declare dso_local void @png_write_chunk_start(%struct.png_struct_def*, i8*, i32) #3

declare dso_local void @png_write_chunk_data(%struct.png_struct_def*, i8*, i64) #3

declare dso_local void @png_write_chunk_end(%struct.png_struct_def*) #3

declare dso_local void @png_write_chunk(%struct.png_struct_def*, i8*, i8*, i64) #3

declare dso_local void @png_write_end(%struct.png_struct_def*, %struct.png_info_struct*) #3

; Function Attrs: noinline nounwind optnone
define dso_local i32 @MatteGIF(i64 %0) #0 !dbg !2070 {
  %2 = alloca %struct.png_color_struct, align 1
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  store i64 %0, i64* %3, align 8
  %5 = bitcast i64* %3 to i8*
  %6 = bitcast %struct.png_color_struct* %2 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %6, i8* align 8 %5, i64 3, i1 false)
  call void @llvm.dbg.declare(metadata %struct.png_color_struct* %2, metadata !2073, metadata !DIExpression()), !dbg !2074
  call void @llvm.dbg.declare(metadata i32* %4, metadata !2075, metadata !DIExpression()), !dbg !2076
  store i32 0, i32* %4, align 4, !dbg !2076
  store %struct.GIFelement* @first, %struct.GIFelement** @current, align 8, !dbg !2077
  br label %7, !dbg !2079

7:                                                ; preds = %58, %1
  %8 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2080
  %9 = icmp ne %struct.GIFelement* %8, null, !dbg !2082
  br i1 %9, label %10, label %62, !dbg !2082

10:                                               ; preds = %7
  %11 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2083
  %12 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %11, i32 0, i32 5, !dbg !2086
  %13 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %12, align 8, !dbg !2086
  %14 = icmp ne %struct.GIFimagestruct* %13, null, !dbg !2083
  br i1 %14, label %15, label %57, !dbg !2087

15:                                               ; preds = %10
  %16 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2088
  %17 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %16, i32 0, i32 5, !dbg !2091
  %18 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %17, align 8, !dbg !2091
  %19 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %18, i32 0, i32 6, !dbg !2092
  %20 = load i32, i32* %19, align 8, !dbg !2092
  %21 = icmp eq i32 %20, -1, !dbg !2093
  br i1 %21, label %22, label %26, !dbg !2094

22:                                               ; preds = %15
  %23 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2095
  %24 = load i32, i32* %4, align 4, !dbg !2096
  %25 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([68 x i8], [68 x i8]* @.str.21, i64 0, i64 0), i32 %24), !dbg !2097
  br label %56, !dbg !2097

26:                                               ; preds = %15
  %27 = load i32, i32* @verbose, align 4, !dbg !2098
  %28 = icmp ne i32 %27, 0, !dbg !2098
  br i1 %28, label %29, label %38, !dbg !2101

29:                                               ; preds = %26
  %30 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2102
  %31 = load i32, i32* %4, align 4, !dbg !2104
  %32 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2105
  %33 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %32, i32 0, i32 5, !dbg !2106
  %34 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %33, align 8, !dbg !2106
  %35 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %34, i32 0, i32 6, !dbg !2107
  %36 = load i32, i32* %35, align 8, !dbg !2107
  %37 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %30, i8* getelementptr inbounds ([46 x i8], [46 x i8]* @.str.22, i64 0, i64 0), i32 %31, i32 %36), !dbg !2108
  br label %38, !dbg !2109

38:                                               ; preds = %29, %26
  %39 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2110
  %40 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %39, i32 0, i32 5, !dbg !2111
  %41 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %40, align 8, !dbg !2111
  %42 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %41, i32 0, i32 0, !dbg !2112
  %43 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2113
  %44 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %43, i32 0, i32 5, !dbg !2114
  %45 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %44, align 8, !dbg !2114
  %46 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %45, i32 0, i32 6, !dbg !2115
  %47 = load i32, i32* %46, align 8, !dbg !2115
  %48 = sext i32 %47 to i64, !dbg !2110
  %49 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* %42, i64 0, i64 %48, !dbg !2110
  %50 = bitcast %struct.png_color_struct* %49 to i8*, !dbg !2116
  %51 = bitcast %struct.png_color_struct* %2 to i8*, !dbg !2116
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %50, i8* align 1 %51, i64 3, i1 false), !dbg !2116
  %52 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2117
  %53 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %52, i32 0, i32 5, !dbg !2118
  %54 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %53, align 8, !dbg !2118
  %55 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %54, i32 0, i32 6, !dbg !2119
  store i32 -1, i32* %55, align 8, !dbg !2120
  br label %56

56:                                               ; preds = %38, %22
  br label %57, !dbg !2121

57:                                               ; preds = %56, %10
  br label %58, !dbg !2122

58:                                               ; preds = %57
  %59 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2123
  %60 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %59, i32 0, i32 0, !dbg !2124
  %61 = load %struct.GIFelement*, %struct.GIFelement** %60, align 8, !dbg !2124
  store %struct.GIFelement* %61, %struct.GIFelement** @current, align 8, !dbg !2125
  br label %7, !dbg !2126, !llvm.loop !2127

62:                                               ; preds = %7
  %63 = load i32, i32* %4, align 4, !dbg !2129
  ret i32 %63, !dbg !2130
}

; Function Attrs: noinline nounwind optnone
define dso_local i32 @processfilter() #0 !dbg !2131 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca %struct.GIFelement*, align 8
  %4 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i32* %2, metadata !2134, metadata !DIExpression()), !dbg !2135
  call void @llvm.dbg.declare(metadata %struct.GIFelement** %3, metadata !2136, metadata !DIExpression()), !dbg !2137
  store %struct.GIFelement* @first, %struct.GIFelement** @current, align 8, !dbg !2138
  %5 = load %struct._IO_FILE*, %struct._IO_FILE** @stdin, align 8, !dbg !2139
  %6 = call i32 @ReadGIF(%struct._IO_FILE* %5), !dbg !2140
  store i32 %6, i32* %2, align 4, !dbg !2141
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stdin, align 8, !dbg !2142
  %8 = call i32 @fclose(%struct._IO_FILE* %7), !dbg !2143
  %9 = load i32, i32* %2, align 4, !dbg !2144
  %10 = icmp ne i32 %9, 1, !dbg !2146
  br i1 %10, label %11, label %15, !dbg !2147

11:                                               ; preds = %0
  %12 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2148
  %13 = load i32, i32* %2, align 4, !dbg !2150
  %14 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %12, i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.23, i64 0, i64 0), i32 %13), !dbg !2151
  store i32 1, i32* %1, align 4, !dbg !2152
  br label %51, !dbg !2152

15:                                               ; preds = %0
  %16 = load i32, i32* @matte, align 4, !dbg !2153
  %17 = icmp ne i32 %16, 0, !dbg !2153
  br i1 %17, label %18, label %22, !dbg !2155

18:                                               ; preds = %15
  %19 = bitcast i64* %4 to i8*, !dbg !2156
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %19, i8* align 1 getelementptr inbounds (%struct.png_color_struct, %struct.png_color_struct* @matte_color, i32 0, i32 0), i64 3, i1 false), !dbg !2156
  %20 = load i64, i64* %4, align 8, !dbg !2156
  %21 = call i32 @MatteGIF(i64 %20), !dbg !2156
  br label %22, !dbg !2156

22:                                               ; preds = %18, %15
  store %struct.GIFelement* null, %struct.GIFelement** %3, align 8, !dbg !2157
  %23 = load %struct.GIFelement*, %struct.GIFelement** getelementptr inbounds (%struct.GIFelement, %struct.GIFelement* @first, i32 0, i32 0), align 8, !dbg !2158
  store %struct.GIFelement* %23, %struct.GIFelement** @current, align 8, !dbg !2160
  br label %24, !dbg !2161

24:                                               ; preds = %46, %22
  %25 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2162
  %26 = icmp ne %struct.GIFelement* %25, null, !dbg !2164
  br i1 %26, label %27, label %50, !dbg !2164

27:                                               ; preds = %24
  %28 = load %struct.GIFelement*, %struct.GIFelement** %3, align 8, !dbg !2165
  %29 = icmp eq %struct.GIFelement* %28, null, !dbg !2168
  br i1 %29, label %30, label %32, !dbg !2169

30:                                               ; preds = %27
  %31 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2170
  store %struct.GIFelement* %31, %struct.GIFelement** %3, align 8, !dbg !2171
  br label %32, !dbg !2172

32:                                               ; preds = %30, %27
  %33 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2173
  %34 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %33, i32 0, i32 1, !dbg !2175
  %35 = load i8, i8* %34, align 8, !dbg !2175
  %36 = zext i8 %35 to i32, !dbg !2173
  %37 = icmp eq i32 %36, 44, !dbg !2176
  br i1 %37, label %38, label %45, !dbg !2177

38:                                               ; preds = %32
  %39 = load %struct.GIFelement*, %struct.GIFelement** %3, align 8, !dbg !2178
  %40 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2180
  %41 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !2181
  %42 = call i32 @writefile(%struct.GIFelement* %39, %struct.GIFelement* %40, %struct._IO_FILE* %41, i32 1), !dbg !2182
  store %struct.GIFelement* null, %struct.GIFelement** %3, align 8, !dbg !2183
  %43 = load i64, i64* @numpngs, align 8, !dbg !2184
  %44 = add nsw i64 %43, 1, !dbg !2184
  store i64 %44, i64* @numpngs, align 8, !dbg !2184
  br label %45, !dbg !2185

45:                                               ; preds = %38, %32
  br label %46, !dbg !2186

46:                                               ; preds = %45
  %47 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2187
  %48 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %47, i32 0, i32 0, !dbg !2188
  %49 = load %struct.GIFelement*, %struct.GIFelement** %48, align 8, !dbg !2188
  store %struct.GIFelement* %49, %struct.GIFelement** @current, align 8, !dbg !2189
  br label %24, !dbg !2190, !llvm.loop !2191

50:                                               ; preds = %24
  call void @free_mem(), !dbg !2193
  store i32 0, i32* %1, align 4, !dbg !2194
  br label %51, !dbg !2194

51:                                               ; preds = %50, %11
  %52 = load i32, i32* %1, align 4, !dbg !2195
  ret i32 %52, !dbg !2195
}

declare dso_local i32 @fclose(%struct._IO_FILE*) #3

; Function Attrs: noinline nounwind optnone
define dso_local i32 @processfile(i8* %0, %struct._IO_FILE* %1) #0 !dbg !2196 {
  %3 = alloca i32, align 4
  %4 = alloca i8*, align 8
  %5 = alloca %struct._IO_FILE*, align 8
  %6 = alloca [1025 x i8], align 1
  %7 = alloca i32, align 4
  %8 = alloca %struct.GIFelement*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i8*, align 8
  %12 = alloca i64, align 8
  store i8* %0, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !2199, metadata !DIExpression()), !dbg !2200
  store %struct._IO_FILE* %1, %struct._IO_FILE** %5, align 8
  call void @llvm.dbg.declare(metadata %struct._IO_FILE** %5, metadata !2201, metadata !DIExpression()), !dbg !2202
  call void @llvm.dbg.declare(metadata [1025 x i8]* %6, metadata !2203, metadata !DIExpression()), !dbg !2207
  call void @llvm.dbg.declare(metadata i32* %7, metadata !2208, metadata !DIExpression()), !dbg !2209
  call void @llvm.dbg.declare(metadata %struct.GIFelement** %8, metadata !2210, metadata !DIExpression()), !dbg !2211
  call void @llvm.dbg.declare(metadata i32* %9, metadata !2212, metadata !DIExpression()), !dbg !2213
  call void @llvm.dbg.declare(metadata i32* %10, metadata !2214, metadata !DIExpression()), !dbg !2215
  store i32 0, i32* %10, align 4, !dbg !2215
  call void @llvm.dbg.declare(metadata i8** %11, metadata !2216, metadata !DIExpression()), !dbg !2217
  %13 = load %struct._IO_FILE*, %struct._IO_FILE** %5, align 8, !dbg !2218
  %14 = icmp eq %struct._IO_FILE* %13, null, !dbg !2220
  br i1 %14, label %15, label %16, !dbg !2221

15:                                               ; preds = %2
  store i32 1, i32* %3, align 4, !dbg !2222
  br label %181, !dbg !2222

16:                                               ; preds = %2
  store %struct.GIFelement* @first, %struct.GIFelement** @current, align 8, !dbg !2223
  %17 = load %struct._IO_FILE*, %struct._IO_FILE** %5, align 8, !dbg !2224
  %18 = call i32 @ReadGIF(%struct._IO_FILE* %17), !dbg !2225
  store i32 %18, i32* %7, align 4, !dbg !2226
  %19 = load %struct._IO_FILE*, %struct._IO_FILE** %5, align 8, !dbg !2227
  %20 = call i32 @fclose(%struct._IO_FILE* %19), !dbg !2228
  %21 = load i32, i32* %7, align 4, !dbg !2229
  %22 = icmp sge i32 %21, 0, !dbg !2231
  br i1 %22, label %23, label %30, !dbg !2232

23:                                               ; preds = %16
  %24 = load i32, i32* @verbose, align 4, !dbg !2233
  %25 = icmp sgt i32 %24, 1, !dbg !2234
  br i1 %25, label %26, label %30, !dbg !2235

26:                                               ; preds = %23
  %27 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2236
  %28 = load i32, i32* %7, align 4, !dbg !2237
  %29 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %27, i8* getelementptr inbounds ([30 x i8], [30 x i8]* @.str.24, i64 0, i64 0), i32 %28), !dbg !2238
  br label %30, !dbg !2238

30:                                               ; preds = %26, %23, %16
  %31 = load i32, i32* %7, align 4, !dbg !2239
  %32 = icmp sle i32 %31, 0, !dbg !2241
  br i1 %32, label %33, label %34, !dbg !2242

33:                                               ; preds = %30
  store i32 1, i32* %3, align 4, !dbg !2243
  br label %181, !dbg !2243

34:                                               ; preds = %30
  %35 = load i32, i32* @webconvert, align 4, !dbg !2244
  %36 = icmp ne i32 %35, 0, !dbg !2244
  br i1 %36, label %37, label %47, !dbg !2246

37:                                               ; preds = %34
  %38 = load i32, i32* %7, align 4, !dbg !2247
  %39 = icmp ne i32 %38, 1, !dbg !2249
  br i1 %39, label %40, label %44, !dbg !2250

40:                                               ; preds = %37
  %41 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2251
  %42 = load i8*, i8** %4, align 8, !dbg !2253
  %43 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %41, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.25, i64 0, i64 0), i8* %42), !dbg !2254
  store i32 0, i32* %3, align 4, !dbg !2255
  br label %181, !dbg !2255

44:                                               ; preds = %37
  %45 = load i8*, i8** %4, align 8, !dbg !2256
  %46 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.26, i64 0, i64 0), i8* %45), !dbg !2258
  store i32 0, i32* %3, align 4, !dbg !2259
  br label %181, !dbg !2259

47:                                               ; preds = %34
  %48 = load i32, i32* @matte, align 4, !dbg !2260
  %49 = icmp ne i32 %48, 0, !dbg !2260
  br i1 %49, label %50, label %54, !dbg !2262

50:                                               ; preds = %47
  %51 = bitcast i64* %12 to i8*, !dbg !2263
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %51, i8* align 1 getelementptr inbounds (%struct.png_color_struct, %struct.png_color_struct* @matte_color, i32 0, i32 0), i64 3, i1 false), !dbg !2263
  %52 = load i64, i64* %12, align 8, !dbg !2263
  %53 = call i32 @MatteGIF(i64 %52), !dbg !2263
  br label %54, !dbg !2263

54:                                               ; preds = %50, %47
  %55 = getelementptr inbounds [1025 x i8], [1025 x i8]* %6, i64 0, i64 0, !dbg !2264
  %56 = load i8*, i8** %4, align 8, !dbg !2265
  %57 = call i8* @strcpy(i8* %55, i8* %56) #9, !dbg !2266
  %58 = getelementptr inbounds [1025 x i8], [1025 x i8]* %6, i64 0, i64 0, !dbg !2267
  %59 = getelementptr inbounds [1025 x i8], [1025 x i8]* %6, i64 0, i64 0, !dbg !2268
  %60 = call i64 @strlen(i8* %59) #10, !dbg !2269
  %61 = getelementptr inbounds i8, i8* %58, i64 %60, !dbg !2270
  %62 = getelementptr inbounds i8, i8* %61, i64 -4, !dbg !2271
  store i8* %62, i8** %11, align 8, !dbg !2272
  %63 = load i8*, i8** %11, align 8, !dbg !2273
  %64 = call i32 @strcmp(i8* %63, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.27, i64 0, i64 0)) #10, !dbg !2275
  %65 = icmp ne i32 %64, 0, !dbg !2276
  br i1 %65, label %66, label %121, !dbg !2277

66:                                               ; preds = %54
  %67 = load i8*, i8** %11, align 8, !dbg !2278
  %68 = call i32 @strcmp(i8* %67, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.28, i64 0, i64 0)) #10, !dbg !2279
  %69 = icmp ne i32 %68, 0, !dbg !2280
  br i1 %69, label %70, label %121, !dbg !2281

70:                                               ; preds = %66
  %71 = load i8*, i8** %11, align 8, !dbg !2282
  %72 = call i32 @strcmp(i8* %71, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.29, i64 0, i64 0)) #10, !dbg !2283
  %73 = icmp ne i32 %72, 0, !dbg !2284
  br i1 %73, label %74, label %121, !dbg !2285

74:                                               ; preds = %70
  %75 = load i8*, i8** %11, align 8, !dbg !2286
  %76 = call i32 @strcmp(i8* %75, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.30, i64 0, i64 0)) #10, !dbg !2287
  %77 = icmp ne i32 %76, 0, !dbg !2288
  br i1 %77, label %78, label %121, !dbg !2289

78:                                               ; preds = %74
  %79 = getelementptr inbounds [1025 x i8], [1025 x i8]* %6, i64 0, i64 0, !dbg !2290
  %80 = getelementptr inbounds [1025 x i8], [1025 x i8]* %6, i64 0, i64 0, !dbg !2292
  %81 = call i64 @strlen(i8* %80) #10, !dbg !2293
  %82 = getelementptr inbounds i8, i8* %79, i64 %81, !dbg !2294
  store i8* %82, i8** %11, align 8, !dbg !2295
  br label %83, !dbg !2296

83:                                               ; preds = %103, %78
  %84 = load i8*, i8** %11, align 8, !dbg !2297
  %85 = getelementptr inbounds [1025 x i8], [1025 x i8]* %6, i64 0, i64 0, !dbg !2298
  %86 = icmp uge i8* %84, %85, !dbg !2299
  br i1 %86, label %87, label %106, !dbg !2296

87:                                               ; preds = %83
  %88 = load i8*, i8** %11, align 8, !dbg !2300
  %89 = load i8, i8* %88, align 1, !dbg !2303
  %90 = zext i8 %89 to i32, !dbg !2303
  %91 = icmp eq i32 %90, 46, !dbg !2304
  br i1 %91, label %102, label %92, !dbg !2305

92:                                               ; preds = %87
  %93 = load i8*, i8** %11, align 8, !dbg !2306
  %94 = load i8, i8* %93, align 1, !dbg !2307
  %95 = zext i8 %94 to i32, !dbg !2307
  %96 = icmp eq i32 %95, 47, !dbg !2308
  br i1 %96, label %102, label %97, !dbg !2309

97:                                               ; preds = %92
  %98 = load i8*, i8** %11, align 8, !dbg !2310
  %99 = load i8, i8* %98, align 1, !dbg !2311
  %100 = zext i8 %99 to i32, !dbg !2311
  %101 = icmp eq i32 %100, 92, !dbg !2312
  br i1 %101, label %102, label %103, !dbg !2313

102:                                              ; preds = %97, %92, %87
  br label %106, !dbg !2314

103:                                              ; preds = %97
  %104 = load i8*, i8** %11, align 8, !dbg !2315
  %105 = getelementptr inbounds i8, i8* %104, i32 -1, !dbg !2315
  store i8* %105, i8** %11, align 8, !dbg !2315
  br label %83, !dbg !2296, !llvm.loop !2316

106:                                              ; preds = %102, %83
  %107 = load i8*, i8** %11, align 8, !dbg !2318
  %108 = getelementptr inbounds [1025 x i8], [1025 x i8]* %6, i64 0, i64 0, !dbg !2320
  %109 = icmp ult i8* %107, %108, !dbg !2321
  br i1 %109, label %115, label %110, !dbg !2322

110:                                              ; preds = %106
  %111 = load i8*, i8** %11, align 8, !dbg !2323
  %112 = load i8, i8* %111, align 1, !dbg !2324
  %113 = zext i8 %112 to i32, !dbg !2324
  %114 = icmp ne i32 %113, 46, !dbg !2325
  br i1 %114, label %115, label %120, !dbg !2326

115:                                              ; preds = %110, %106
  %116 = getelementptr inbounds [1025 x i8], [1025 x i8]* %6, i64 0, i64 0, !dbg !2327
  %117 = getelementptr inbounds [1025 x i8], [1025 x i8]* %6, i64 0, i64 0, !dbg !2329
  %118 = call i64 @strlen(i8* %117) #10, !dbg !2330
  %119 = getelementptr inbounds i8, i8* %116, i64 %118, !dbg !2331
  store i8* %119, i8** %11, align 8, !dbg !2332
  br label %120, !dbg !2333

120:                                              ; preds = %115, %110
  br label %121, !dbg !2334

121:                                              ; preds = %120, %74, %70, %66, %54
  %122 = load i8*, i8** %11, align 8, !dbg !2335
  %123 = call i8* @strcpy(i8* %122, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.31, i64 0, i64 0)) #9, !dbg !2336
  store %struct.GIFelement* null, %struct.GIFelement** %8, align 8, !dbg !2337
  store i32 0, i32* %9, align 4, !dbg !2338
  %124 = load %struct.GIFelement*, %struct.GIFelement** getelementptr inbounds (%struct.GIFelement, %struct.GIFelement* @first, i32 0, i32 0), align 8, !dbg !2339
  store %struct.GIFelement* %124, %struct.GIFelement** @current, align 8, !dbg !2341
  br label %125, !dbg !2342

125:                                              ; preds = %167, %121
  %126 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2343
  %127 = icmp ne %struct.GIFelement* %126, null, !dbg !2345
  br i1 %127, label %128, label %171, !dbg !2345

128:                                              ; preds = %125
  %129 = load %struct.GIFelement*, %struct.GIFelement** %8, align 8, !dbg !2346
  %130 = icmp eq %struct.GIFelement* %129, null, !dbg !2349
  br i1 %130, label %131, label %133, !dbg !2350

131:                                              ; preds = %128
  %132 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2351
  store %struct.GIFelement* %132, %struct.GIFelement** %8, align 8, !dbg !2352
  br label %133, !dbg !2353

133:                                              ; preds = %131, %128
  %134 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2354
  %135 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %134, i32 0, i32 1, !dbg !2356
  %136 = load i8, i8* %135, align 8, !dbg !2356
  %137 = zext i8 %136 to i32, !dbg !2354
  %138 = icmp eq i32 %137, 44, !dbg !2357
  br i1 %138, label %139, label %166, !dbg !2358

139:                                              ; preds = %133
  %140 = load i32, i32* %9, align 4, !dbg !2359
  %141 = add nsw i32 %140, 1, !dbg !2359
  store i32 %141, i32* %9, align 4, !dbg !2359
  %142 = getelementptr inbounds [1025 x i8], [1025 x i8]* %6, i64 0, i64 0, !dbg !2361
  %143 = call %struct._IO_FILE* @fopen(i8* %142, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.32, i64 0, i64 0)), !dbg !2363
  store %struct._IO_FILE* %143, %struct._IO_FILE** %5, align 8, !dbg !2364
  %144 = icmp eq %struct._IO_FILE* %143, null, !dbg !2365
  br i1 %144, label %145, label %147, !dbg !2366

145:                                              ; preds = %139
  %146 = getelementptr inbounds [1025 x i8], [1025 x i8]* %6, i64 0, i64 0, !dbg !2367
  call void @perror(i8* %146), !dbg !2369
  store i32 1, i32* %3, align 4, !dbg !2370
  br label %181, !dbg !2370

147:                                              ; preds = %139
  %148 = load %struct.GIFelement*, %struct.GIFelement** %8, align 8, !dbg !2371
  %149 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2373
  %150 = load %struct._IO_FILE*, %struct._IO_FILE** %5, align 8, !dbg !2374
  %151 = load i32, i32* %9, align 4, !dbg !2375
  %152 = load i32, i32* %7, align 4, !dbg !2376
  %153 = icmp eq i32 %151, %152, !dbg !2377
  %154 = zext i1 %153 to i32, !dbg !2377
  %155 = call i32 @writefile(%struct.GIFelement* %148, %struct.GIFelement* %149, %struct._IO_FILE* %150, i32 %154), !dbg !2378
  %156 = load i32, i32* %10, align 4, !dbg !2379
  %157 = or i32 %156, %155, !dbg !2379
  store i32 %157, i32* %10, align 4, !dbg !2379
  %158 = load %struct._IO_FILE*, %struct._IO_FILE** %5, align 8, !dbg !2380
  %159 = call i32 @fclose(%struct._IO_FILE* %158), !dbg !2381
  %160 = load i64, i64* @numpngs, align 8, !dbg !2382
  %161 = add nsw i64 %160, 1, !dbg !2382
  store i64 %161, i64* @numpngs, align 8, !dbg !2382
  store %struct.GIFelement* null, %struct.GIFelement** %8, align 8, !dbg !2383
  %162 = load i8*, i8** %11, align 8, !dbg !2384
  %163 = load i32, i32* %9, align 4, !dbg !2385
  %164 = call i32 (i8*, i8*, ...) @sprintf(i8* %162, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.33, i64 0, i64 0), i32 %163) #9, !dbg !2386
  br label %165

165:                                              ; preds = %147
  br label %166, !dbg !2387

166:                                              ; preds = %165, %133
  br label %167, !dbg !2388

167:                                              ; preds = %166
  %168 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !2389
  %169 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %168, i32 0, i32 0, !dbg !2390
  %170 = load %struct.GIFelement*, %struct.GIFelement** %169, align 8, !dbg !2390
  store %struct.GIFelement* %170, %struct.GIFelement** @current, align 8, !dbg !2391
  br label %125, !dbg !2392, !llvm.loop !2393

171:                                              ; preds = %125
  call void @free_mem(), !dbg !2395
  %172 = load i32, i32* @delete, align 4, !dbg !2396
  %173 = icmp ne i32 %172, 0, !dbg !2396
  br i1 %173, label %174, label %180, !dbg !2398

174:                                              ; preds = %171
  %175 = load i32, i32* %10, align 4, !dbg !2399
  %176 = icmp ne i32 %175, 0, !dbg !2399
  br i1 %176, label %180, label %177, !dbg !2400

177:                                              ; preds = %174
  %178 = load i8*, i8** %4, align 8, !dbg !2401
  %179 = call i32 @unlink(i8* %178) #9, !dbg !2403
  br label %180, !dbg !2404

180:                                              ; preds = %177, %174, %171
  store i32 0, i32* %3, align 4, !dbg !2405
  br label %181, !dbg !2405

181:                                              ; preds = %180, %145, %44, %40, %33, %15
  %182 = load i32, i32* %3, align 4, !dbg !2406
  ret i32 %182, !dbg !2406
}

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: nounwind
declare dso_local i8* @strcpy(i8*, i8*) #6

; Function Attrs: nounwind readonly
declare dso_local i32 @strcmp(i8*, i8*) #7

declare dso_local %struct._IO_FILE* @fopen(i8*, i8*) #3

declare dso_local void @perror(i8*) #3

; Function Attrs: nounwind
declare dso_local i32 @sprintf(i8*, i8*, ...) #6

; Function Attrs: nounwind
declare dso_local i32 @unlink(i8*) #6

; Function Attrs: noinline nounwind optnone
define dso_local i32 @input_is_terminal() #0 !dbg !2407 {
  %1 = load %struct._IO_FILE*, %struct._IO_FILE** @stdin, align 8, !dbg !2408
  %2 = call i32 @fileno(%struct._IO_FILE* %1) #9, !dbg !2409
  %3 = call i32 @isatty(i32 %2) #9, !dbg !2410
  ret i32 %3, !dbg !2411
}

; Function Attrs: nounwind
declare dso_local i32 @fileno(%struct._IO_FILE*) #6

; Function Attrs: nounwind
declare dso_local i32 @isatty(i32) #6

; Function Attrs: noinline nounwind optnone
define dso_local i32 @main(i32 %0, i8** %1) #0 !dbg !2412 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca %struct._IO_FILE*, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca [1025 x i8], align 1
  %11 = alloca i32, align 4
  %12 = alloca i8*, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !2415, metadata !DIExpression()), !dbg !2416
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !2417, metadata !DIExpression()), !dbg !2418
  call void @llvm.dbg.declare(metadata %struct._IO_FILE** %6, metadata !2419, metadata !DIExpression()), !dbg !2420
  call void @llvm.dbg.declare(metadata i32* %7, metadata !2421, metadata !DIExpression()), !dbg !2422
  call void @llvm.dbg.declare(metadata i32* %8, metadata !2423, metadata !DIExpression()), !dbg !2424
  call void @llvm.dbg.declare(metadata i32* %9, metadata !2425, metadata !DIExpression()), !dbg !2426
  store i32 0, i32* %9, align 4, !dbg !2426
  call void @llvm.dbg.declare(metadata [1025 x i8]* %10, metadata !2427, metadata !DIExpression()), !dbg !2428
  call void @llvm.dbg.declare(metadata i32* %11, metadata !2429, metadata !DIExpression()), !dbg !2430
  call void @llvm.dbg.declare(metadata i8** %12, metadata !2431, metadata !DIExpression()), !dbg !2432
  store i32 1, i32* @software_chunk, align 4, !dbg !2433
  store i32 1, i32* %11, align 4, !dbg !2434
  store i32 1, i32* %11, align 4, !dbg !2435
  br label %13, !dbg !2437

13:                                               ; preds = %123, %2
  %14 = load i32, i32* %11, align 4, !dbg !2438
  %15 = load i32, i32* %4, align 4, !dbg !2440
  %16 = icmp slt i32 %14, %15, !dbg !2441
  br i1 %16, label %17, label %27, !dbg !2442

17:                                               ; preds = %13
  %18 = load i8**, i8*** %5, align 8, !dbg !2443
  %19 = load i32, i32* %11, align 4, !dbg !2444
  %20 = sext i32 %19 to i64, !dbg !2443
  %21 = getelementptr inbounds i8*, i8** %18, i64 %20, !dbg !2443
  %22 = load i8*, i8** %21, align 8, !dbg !2443
  %23 = getelementptr inbounds i8, i8* %22, i64 0, !dbg !2443
  %24 = load i8, i8* %23, align 1, !dbg !2443
  %25 = zext i8 %24 to i32, !dbg !2443
  %26 = icmp eq i32 %25, 45, !dbg !2445
  br label %27

27:                                               ; preds = %17, %13
  %28 = phi i1 [ false, %13 ], [ %26, %17 ], !dbg !2446
  br i1 %28, label %29, label %126, !dbg !2447

29:                                               ; preds = %27
  store i32 1, i32* %7, align 4, !dbg !2448
  br label %30, !dbg !2451

30:                                               ; preds = %118, %29
  %31 = load i32, i32* %7, align 4, !dbg !2452
  %32 = sext i32 %31 to i64, !dbg !2452
  %33 = load i8**, i8*** %5, align 8, !dbg !2454
  %34 = load i32, i32* %11, align 4, !dbg !2455
  %35 = sext i32 %34 to i64, !dbg !2454
  %36 = getelementptr inbounds i8*, i8** %33, i64 %35, !dbg !2454
  %37 = load i8*, i8** %36, align 8, !dbg !2454
  %38 = call i64 @strlen(i8* %37) #10, !dbg !2456
  %39 = icmp ult i64 %32, %38, !dbg !2457
  br i1 %39, label %40, label %121, !dbg !2458

40:                                               ; preds = %30
  %41 = load i8**, i8*** %5, align 8, !dbg !2459
  %42 = load i32, i32* %11, align 4, !dbg !2460
  %43 = sext i32 %42 to i64, !dbg !2459
  %44 = getelementptr inbounds i8*, i8** %41, i64 %43, !dbg !2459
  %45 = load i8*, i8** %44, align 8, !dbg !2459
  %46 = load i32, i32* %7, align 4, !dbg !2461
  %47 = sext i32 %46 to i64, !dbg !2459
  %48 = getelementptr inbounds i8, i8* %45, i64 %47, !dbg !2459
  %49 = load i8, i8* %48, align 1, !dbg !2459
  %50 = zext i8 %49 to i32, !dbg !2459
  switch i32 %50, label %101 [
    i32 98, label %51
    i32 100, label %87
    i32 102, label %88
    i32 49, label %88
    i32 103, label %89
    i32 104, label %90
    i32 105, label %91
    i32 110, label %92
    i32 112, label %93
    i32 114, label %94
    i32 115, label %95
    i32 118, label %96
    i32 119, label %99
    i32 79, label %100
  ], !dbg !2462

51:                                               ; preds = %40
  %52 = load i32, i32* %11, align 4, !dbg !2463
  %53 = load i32, i32* %4, align 4, !dbg !2466
  %54 = sub nsw i32 %53, 1, !dbg !2467
  %55 = icmp sge i32 %52, %54, !dbg !2468
  br i1 %55, label %56, label %59, !dbg !2469

56:                                               ; preds = %51
  %57 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2470
  %58 = call i32 @fputs(i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str.34, i64 0, i64 0), %struct._IO_FILE* %57), !dbg !2472
  call void @exit(i32 1) #11, !dbg !2473
  unreachable, !dbg !2473

59:                                               ; preds = %51
  %60 = load i8**, i8*** %5, align 8, !dbg !2474
  %61 = load i32, i32* %11, align 4, !dbg !2475
  %62 = add nsw i32 %61, 1, !dbg !2475
  store i32 %62, i32* %11, align 4, !dbg !2475
  %63 = sext i32 %62 to i64, !dbg !2474
  %64 = getelementptr inbounds i8*, i8** %60, i64 %63, !dbg !2474
  %65 = load i8*, i8** %64, align 8, !dbg !2474
  store i8* %65, i8** %12, align 8, !dbg !2476
  %66 = load i8*, i8** %12, align 8, !dbg !2477
  %67 = load i8, i8* %66, align 1, !dbg !2479
  %68 = zext i8 %67 to i32, !dbg !2479
  %69 = icmp eq i32 %68, 35, !dbg !2480
  br i1 %69, label %70, label %73, !dbg !2481

70:                                               ; preds = %59
  %71 = load i8*, i8** %12, align 8, !dbg !2482
  %72 = getelementptr inbounds i8, i8* %71, i32 1, !dbg !2482
  store i8* %72, i8** %12, align 8, !dbg !2482
  br label %73, !dbg !2483

73:                                               ; preds = %70, %59
  %74 = load i8*, i8** %12, align 8, !dbg !2484
  %75 = call i32 (i8*, i8*, ...) @__isoc99_sscanf(i8* %74, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.35, i64 0, i64 0), i32* %8) #9, !dbg !2485
  %76 = load i32, i32* %8, align 4, !dbg !2486
  %77 = ashr i32 %76, 16, !dbg !2487
  %78 = and i32 %77, 255, !dbg !2488
  %79 = trunc i32 %78 to i8, !dbg !2489
  store i8 %79, i8* getelementptr inbounds (%struct.png_color_struct, %struct.png_color_struct* @matte_color, i32 0, i32 0), align 1, !dbg !2490
  %80 = load i32, i32* %8, align 4, !dbg !2491
  %81 = ashr i32 %80, 8, !dbg !2492
  %82 = and i32 %81, 255, !dbg !2493
  %83 = trunc i32 %82 to i8, !dbg !2494
  store i8 %83, i8* getelementptr inbounds (%struct.png_color_struct, %struct.png_color_struct* @matte_color, i32 0, i32 1), align 1, !dbg !2495
  %84 = load i32, i32* %8, align 4, !dbg !2496
  %85 = and i32 %84, 255, !dbg !2497
  %86 = trunc i32 %85 to i8, !dbg !2496
  store i8 %86, i8* getelementptr inbounds (%struct.png_color_struct, %struct.png_color_struct* @matte_color, i32 0, i32 2), align 1, !dbg !2498
  store i32 1, i32* @matte, align 4, !dbg !2499
  br label %122, !dbg !2500

87:                                               ; preds = %40
  store i32 1, i32* @delete, align 4, !dbg !2501
  br label %117, !dbg !2502

88:                                               ; preds = %40, %40
  store i32 1, i32* @filtermode, align 4, !dbg !2503
  br label %117, !dbg !2504

89:                                               ; preds = %40
  store i32 1, i32* @gamma_srgb, align 4, !dbg !2505
  br label %117, !dbg !2506

90:                                               ; preds = %40
  store i32 1, i32* @histogram, align 4, !dbg !2507
  br label %117, !dbg !2508

91:                                               ; preds = %40
  store i32 1, i32* @interlaced, align 4, !dbg !2509
  br label %117, !dbg !2510

92:                                               ; preds = %40
  store i32 0, i32* @interlaced, align 4, !dbg !2511
  br label %117, !dbg !2512

93:                                               ; preds = %40
  store i32 1, i32* @progress, align 4, !dbg !2513
  br label %117, !dbg !2514

94:                                               ; preds = %40
  store i32 1, i32* @recover, align 4, !dbg !2515
  br label %117, !dbg !2516

95:                                               ; preds = %40
  store i32 0, i32* @software_chunk, align 4, !dbg !2517
  br label %117, !dbg !2518

96:                                               ; preds = %40
  %97 = load i32, i32* @verbose, align 4, !dbg !2519
  %98 = add nsw i32 %97, 1, !dbg !2519
  store i32 %98, i32* @verbose, align 4, !dbg !2519
  br label %117, !dbg !2520

99:                                               ; preds = %40
  store i32 1, i32* @webconvert, align 4, !dbg !2521
  br label %117, !dbg !2522

100:                                              ; preds = %40
  store i32 1, i32* @optimize, align 4, !dbg !2523
  br label %117, !dbg !2524

101:                                              ; preds = %40
  %102 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2525
  %103 = load i8**, i8*** %5, align 8, !dbg !2526
  %104 = load i32, i32* %11, align 4, !dbg !2527
  %105 = sext i32 %104 to i64, !dbg !2526
  %106 = getelementptr inbounds i8*, i8** %103, i64 %105, !dbg !2526
  %107 = load i8*, i8** %106, align 8, !dbg !2526
  %108 = load i32, i32* %7, align 4, !dbg !2528
  %109 = sext i32 %108 to i64, !dbg !2526
  %110 = getelementptr inbounds i8, i8* %107, i64 %109, !dbg !2526
  %111 = load i8, i8* %110, align 1, !dbg !2526
  %112 = zext i8 %111 to i32, !dbg !2526
  %113 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %102, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.36, i64 0, i64 0), i32 %112), !dbg !2529
  br label %114, !dbg !2529

114:                                              ; preds = %139, %101
  call void @llvm.dbg.label(metadata !2530), !dbg !2531
  %115 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2532
  %116 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %115, i8* getelementptr inbounds ([984 x i8], [984 x i8]* @.str.37, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @version, i64 0, i64 0), i8* getelementptr inbounds ([57 x i8], [57 x i8]* @compile_info, i64 0, i64 0)), !dbg !2533
  store i32 1, i32* %3, align 4, !dbg !2534
  br label %235, !dbg !2534

117:                                              ; preds = %100, %99, %96, %95, %94, %93, %92, %91, %90, %89, %88, %87
  br label %118, !dbg !2535

118:                                              ; preds = %117
  %119 = load i32, i32* %7, align 4, !dbg !2536
  %120 = add nsw i32 %119, 1, !dbg !2536
  store i32 %120, i32* %7, align 4, !dbg !2536
  br label %30, !dbg !2537, !llvm.loop !2538

121:                                              ; preds = %30
  br label %122, !dbg !2539

122:                                              ; preds = %121, %73
  call void @llvm.dbg.label(metadata !2540), !dbg !2541
  br label %123, !dbg !2542

123:                                              ; preds = %122
  %124 = load i32, i32* %11, align 4, !dbg !2543
  %125 = add nsw i32 %124, 1, !dbg !2543
  store i32 %125, i32* %11, align 4, !dbg !2543
  br label %13, !dbg !2544, !llvm.loop !2545

126:                                              ; preds = %27
  %127 = load i32, i32* @verbose, align 4, !dbg !2547
  %128 = icmp sgt i32 %127, 1, !dbg !2549
  br i1 %128, label %129, label %132, !dbg !2550

129:                                              ; preds = %126
  %130 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2551
  %131 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %130, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.38, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @version, i64 0, i64 0), i8* getelementptr inbounds ([57 x i8], [57 x i8]* @compile_info, i64 0, i64 0)), !dbg !2552
  br label %132, !dbg !2552

132:                                              ; preds = %129, %126
  %133 = load i32, i32* %4, align 4, !dbg !2553
  %134 = load i32, i32* %11, align 4, !dbg !2555
  %135 = icmp eq i32 %133, %134, !dbg !2556
  br i1 %135, label %136, label %162, !dbg !2557

136:                                              ; preds = %132
  %137 = call i32 @input_is_terminal(), !dbg !2558
  %138 = icmp ne i32 %137, 0, !dbg !2558
  br i1 %138, label %139, label %140, !dbg !2561

139:                                              ; preds = %136
  br label %114, !dbg !2562

140:                                              ; preds = %136
  %141 = load i32, i32* @verbose, align 4, !dbg !2564
  %142 = icmp sgt i32 %141, 1, !dbg !2566
  br i1 %142, label %143, label %146, !dbg !2567

143:                                              ; preds = %140
  %144 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2568
  %145 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %144, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.39, i64 0, i64 0)), !dbg !2569
  br label %146, !dbg !2569

146:                                              ; preds = %143, %140
  %147 = load i32, i32* @filtermode, align 4, !dbg !2570
  %148 = icmp ne i32 %147, 0, !dbg !2570
  br i1 %148, label %149, label %156, !dbg !2572

149:                                              ; preds = %146
  %150 = call i32 @processfilter(), !dbg !2573
  %151 = icmp ne i32 %150, 0, !dbg !2576
  br i1 %151, label %152, label %155, !dbg !2577

152:                                              ; preds = %149
  %153 = load i32, i32* %9, align 4, !dbg !2578
  %154 = add nsw i32 %153, 1, !dbg !2578
  store i32 %154, i32* %9, align 4, !dbg !2578
  br label %155, !dbg !2578

155:                                              ; preds = %152, %149
  br label %161, !dbg !2579

156:                                              ; preds = %146
  %157 = load %struct._IO_FILE*, %struct._IO_FILE** @stdin, align 8, !dbg !2580
  %158 = call i32 @processfile(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.40, i64 0, i64 0), %struct._IO_FILE* %157), !dbg !2582
  %159 = load i64, i64* @numgifs, align 8, !dbg !2583
  %160 = add nsw i64 %159, 1, !dbg !2583
  store i64 %160, i64* @numgifs, align 8, !dbg !2583
  br label %161

161:                                              ; preds = %156, %155
  br label %213, !dbg !2584

162:                                              ; preds = %132
  %163 = load i32, i32* %11, align 4, !dbg !2585
  store i32 %163, i32* %7, align 4, !dbg !2588
  br label %164, !dbg !2589

164:                                              ; preds = %209, %162
  %165 = load i32, i32* %7, align 4, !dbg !2590
  %166 = load i32, i32* %4, align 4, !dbg !2592
  %167 = icmp slt i32 %165, %166, !dbg !2593
  br i1 %167, label %168, label %212, !dbg !2594

168:                                              ; preds = %164
  %169 = getelementptr inbounds [1025 x i8], [1025 x i8]* %10, i64 0, i64 0, !dbg !2595
  %170 = load i8**, i8*** %5, align 8, !dbg !2597
  %171 = load i32, i32* %7, align 4, !dbg !2598
  %172 = sext i32 %171 to i64, !dbg !2597
  %173 = getelementptr inbounds i8*, i8** %170, i64 %172, !dbg !2597
  %174 = load i8*, i8** %173, align 8, !dbg !2597
  %175 = call i8* @strcpy(i8* %169, i8* %174) #9, !dbg !2599
  %176 = getelementptr inbounds [1025 x i8], [1025 x i8]* %10, i64 0, i64 0, !dbg !2600
  %177 = call %struct._IO_FILE* @fopen(i8* %176, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.41, i64 0, i64 0)), !dbg !2602
  store %struct._IO_FILE* %177, %struct._IO_FILE** %6, align 8, !dbg !2603
  %178 = icmp eq %struct._IO_FILE* %177, null, !dbg !2604
  br i1 %178, label %179, label %184, !dbg !2605

179:                                              ; preds = %168
  %180 = getelementptr inbounds [1025 x i8], [1025 x i8]* %10, i64 0, i64 0, !dbg !2606
  %181 = call i8* @strcat(i8* %180, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.27, i64 0, i64 0)) #9, !dbg !2608
  %182 = getelementptr inbounds [1025 x i8], [1025 x i8]* %10, i64 0, i64 0, !dbg !2609
  %183 = call %struct._IO_FILE* @fopen(i8* %182, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.41, i64 0, i64 0)), !dbg !2610
  store %struct._IO_FILE* %183, %struct._IO_FILE** %6, align 8, !dbg !2611
  br label %184, !dbg !2612

184:                                              ; preds = %179, %168
  %185 = load %struct._IO_FILE*, %struct._IO_FILE** %6, align 8, !dbg !2613
  %186 = icmp eq %struct._IO_FILE* %185, null, !dbg !2615
  br i1 %186, label %187, label %193, !dbg !2616

187:                                              ; preds = %184
  %188 = load i8**, i8*** %5, align 8, !dbg !2617
  %189 = load i32, i32* %7, align 4, !dbg !2619
  %190 = sext i32 %189 to i64, !dbg !2617
  %191 = getelementptr inbounds i8*, i8** %188, i64 %190, !dbg !2617
  %192 = load i8*, i8** %191, align 8, !dbg !2617
  call void @perror(i8* %192), !dbg !2620
  store i32 1, i32* %9, align 4, !dbg !2621
  br label %208, !dbg !2622

193:                                              ; preds = %184
  %194 = load i32, i32* @verbose, align 4, !dbg !2623
  %195 = icmp sgt i32 %194, 1, !dbg !2626
  br i1 %195, label %196, label %200, !dbg !2627

196:                                              ; preds = %193
  %197 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2628
  %198 = getelementptr inbounds [1025 x i8], [1025 x i8]* %10, i64 0, i64 0, !dbg !2629
  %199 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %197, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.42, i64 0, i64 0), i8* %198), !dbg !2630
  br label %200, !dbg !2630

200:                                              ; preds = %196, %193
  %201 = getelementptr inbounds [1025 x i8], [1025 x i8]* %10, i64 0, i64 0, !dbg !2631
  %202 = load %struct._IO_FILE*, %struct._IO_FILE** %6, align 8, !dbg !2632
  %203 = call i32 @processfile(i8* %201, %struct._IO_FILE* %202), !dbg !2633
  %204 = load i32, i32* %9, align 4, !dbg !2634
  %205 = or i32 %204, %203, !dbg !2634
  store i32 %205, i32* %9, align 4, !dbg !2634
  %206 = load i64, i64* @numgifs, align 8, !dbg !2635
  %207 = add nsw i64 %206, 1, !dbg !2635
  store i64 %207, i64* @numgifs, align 8, !dbg !2635
  br label %208

208:                                              ; preds = %200, %187
  br label %209, !dbg !2636

209:                                              ; preds = %208
  %210 = load i32, i32* %7, align 4, !dbg !2637
  %211 = add nsw i32 %210, 1, !dbg !2637
  store i32 %211, i32* %7, align 4, !dbg !2637
  br label %164, !dbg !2638, !llvm.loop !2639

212:                                              ; preds = %164
  br label %213

213:                                              ; preds = %212, %161
  %214 = load i32, i32* @verbose, align 4, !dbg !2641
  %215 = icmp ne i32 %214, 0, !dbg !2641
  br i1 %215, label %216, label %233, !dbg !2643

216:                                              ; preds = %213
  %217 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2644
  %218 = load i32, i32* %9, align 4, !dbg !2645
  %219 = icmp ne i32 %218, 0, !dbg !2645
  %220 = zext i1 %219 to i64, !dbg !2645
  %221 = select i1 %219, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.44, i64 0, i64 0), i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.45, i64 0, i64 0), !dbg !2645
  %222 = load i64, i64* @numgifs, align 8, !dbg !2646
  %223 = load i64, i64* @numgifs, align 8, !dbg !2647
  %224 = icmp eq i64 %223, 1, !dbg !2648
  %225 = zext i1 %224 to i64, !dbg !2649
  %226 = select i1 %224, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.46, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.47, i64 0, i64 0), !dbg !2649
  %227 = load i64, i64* @numpngs, align 8, !dbg !2650
  %228 = load i64, i64* @numpngs, align 8, !dbg !2651
  %229 = icmp eq i64 %228, 1, !dbg !2652
  %230 = zext i1 %229 to i64, !dbg !2653
  %231 = select i1 %229, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.46, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.47, i64 0, i64 0), !dbg !2653
  %232 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %217, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.43, i64 0, i64 0), i8* %221, i64 %222, i8* %226, i64 %227, i8* %231), !dbg !2654
  br label %233, !dbg !2654

233:                                              ; preds = %216, %213
  %234 = load i32, i32* %9, align 4, !dbg !2655
  store i32 %234, i32* %3, align 4, !dbg !2656
  br label %235, !dbg !2656

235:                                              ; preds = %233, %114
  %236 = load i32, i32* %3, align 4, !dbg !2657
  ret i32 %236, !dbg !2657
}

declare dso_local i32 @fputs(i8*, %struct._IO_FILE*) #3

; Function Attrs: noreturn nounwind
declare dso_local void @exit(i32) #4

; Function Attrs: nounwind
declare dso_local i32 @__isoc99_sscanf(i8*, i8*, ...) #6

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: nounwind
declare dso_local i8* @strcat(i8*, i8*) #6

; Function Attrs: noinline nounwind optnone
define dso_local i32 @check_recover(i32 %0) #0 !dbg !2658 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !2661, metadata !DIExpression()), !dbg !2662
  %4 = load i32, i32* @recover, align 4, !dbg !2663
  %5 = icmp ne i32 %4, 0, !dbg !2663
  br i1 %5, label %6, label %8, !dbg !2665

6:                                                ; preds = %1
  %7 = load i32, i32* @imagecount, align 4, !dbg !2666
  store i32 %7, i32* %2, align 4, !dbg !2667
  br label %49, !dbg !2667

8:                                                ; preds = %1
  %9 = load i32, i32* @recover_message, align 4, !dbg !2668
  %10 = icmp ne i32 %9, 0, !dbg !2668
  br i1 %10, label %48, label %11, !dbg !2670

11:                                               ; preds = %8
  %12 = load i32, i32* @imagecount, align 4, !dbg !2671
  %13 = icmp sgt i32 %12, 0, !dbg !2672
  br i1 %13, label %17, label %14, !dbg !2673

14:                                               ; preds = %11
  %15 = load i32, i32* %3, align 4, !dbg !2674
  %16 = icmp ne i32 %15, 0, !dbg !2674
  br i1 %16, label %17, label %48, !dbg !2675

17:                                               ; preds = %14, %11
  %18 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2676
  %19 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %18, i8* getelementptr inbounds ([56 x i8], [56 x i8]* @.str.48, i64 0, i64 0)), !dbg !2678
  %20 = load i32, i32* @imagecount, align 4, !dbg !2679
  %21 = icmp sgt i32 %20, 0, !dbg !2681
  br i1 %21, label %22, label %30, !dbg !2682

22:                                               ; preds = %17
  %23 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2683
  %24 = load i32, i32* @imagecount, align 4, !dbg !2684
  %25 = load i32, i32* @imagecount, align 4, !dbg !2685
  %26 = icmp sgt i32 %25, 1, !dbg !2686
  %27 = zext i1 %26 to i64, !dbg !2685
  %28 = select i1 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2.49, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.3.50, i64 0, i64 0), !dbg !2685
  %29 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.1.51, i64 0, i64 0), i32 %24, i8* %28), !dbg !2687
  br label %30, !dbg !2687

30:                                               ; preds = %22, %17
  %31 = load i32, i32* @imagecount, align 4, !dbg !2688
  %32 = icmp sgt i32 %31, 0, !dbg !2690
  br i1 %32, label %33, label %39, !dbg !2691

33:                                               ; preds = %30
  %34 = load i32, i32* %3, align 4, !dbg !2692
  %35 = icmp ne i32 %34, 0, !dbg !2692
  br i1 %35, label %36, label %39, !dbg !2693

36:                                               ; preds = %33
  %37 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2694
  %38 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %37, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.4.52, i64 0, i64 0)), !dbg !2695
  br label %39, !dbg !2695

39:                                               ; preds = %36, %33, %30
  %40 = load i32, i32* %3, align 4, !dbg !2696
  %41 = icmp ne i32 %40, 0, !dbg !2696
  br i1 %41, label %42, label %45, !dbg !2698

42:                                               ; preds = %39
  %43 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2699
  %44 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %43, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.5.53, i64 0, i64 0)), !dbg !2700
  br label %45, !dbg !2700

45:                                               ; preds = %42, %39
  %46 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2701
  %47 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %46, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6.54, i64 0, i64 0)), !dbg !2702
  store i32 1, i32* @recover_message, align 4, !dbg !2703
  br label %48, !dbg !2704

48:                                               ; preds = %45, %14, %8
  store i32 -1, i32* %2, align 4, !dbg !2705
  br label %49, !dbg !2705

49:                                               ; preds = %48, %6
  %50 = load i32, i32* %2, align 4, !dbg !2706
  ret i32 %50, !dbg !2706
}

; Function Attrs: noinline nounwind optnone
define dso_local i32 @ReadGIF(%struct._IO_FILE* %0) #0 !dbg !269 {
  %2 = alloca i32, align 4
  %3 = alloca %struct._IO_FILE*, align 8
  %4 = alloca [16 x i8], align 1
  %5 = alloca i8, align 1
  %6 = alloca [256 x %struct.png_color_struct], align 1
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca [4 x i8], align 1
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  store %struct._IO_FILE* %0, %struct._IO_FILE** %3, align 8
  call void @llvm.dbg.declare(metadata %struct._IO_FILE** %3, metadata !2707, metadata !DIExpression()), !dbg !2708
  call void @llvm.dbg.declare(metadata [16 x i8]* %4, metadata !2709, metadata !DIExpression()), !dbg !2711
  call void @llvm.dbg.declare(metadata i8* %5, metadata !2712, metadata !DIExpression()), !dbg !2713
  call void @llvm.dbg.declare(metadata [256 x %struct.png_color_struct]* %6, metadata !2714, metadata !DIExpression()), !dbg !2715
  call void @llvm.dbg.declare(metadata i32* %7, metadata !2716, metadata !DIExpression()), !dbg !2717
  call void @llvm.dbg.declare(metadata i32* %8, metadata !2718, metadata !DIExpression()), !dbg !2719
  call void @llvm.dbg.declare(metadata [4 x i8]* %9, metadata !2720, metadata !DIExpression()), !dbg !2724
  call void @llvm.dbg.declare(metadata i32* %10, metadata !2725, metadata !DIExpression()), !dbg !2726
  call void @llvm.dbg.declare(metadata i32* %11, metadata !2727, metadata !DIExpression()), !dbg !2728
  call void @llvm.dbg.declare(metadata i32* %12, metadata !2729, metadata !DIExpression()), !dbg !2730
  call void @llvm.dbg.declare(metadata i32* %13, metadata !2731, metadata !DIExpression()), !dbg !2732
  call void @llvm.dbg.declare(metadata i32* %14, metadata !2733, metadata !DIExpression()), !dbg !2734
  store i32 0, i32* @imagecount, align 4, !dbg !2735
  store i32 0, i32* @recover_message, align 4, !dbg !2736
  store i32 -1, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 0), align 4, !dbg !2737
  store i32 -1, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 1), align 4, !dbg !2738
  store i32 -1, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 2), align 4, !dbg !2739
  store i32 0, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 3), align 4, !dbg !2740
  %15 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 0, !dbg !2741
  %16 = load %struct._IO_FILE*, %struct._IO_FILE** %3, align 8, !dbg !2741
  %17 = call i64 @fread(i8* %15, i64 6, i64 1, %struct._IO_FILE* %16), !dbg !2741
  %18 = icmp ne i64 %17, 0, !dbg !2741
  br i1 %18, label %22, label %19, !dbg !2743

19:                                               ; preds = %1
  %20 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2744
  %21 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %20, i8* getelementptr inbounds ([37 x i8], [37 x i8]* @.str.7.57, i64 0, i64 0)), !dbg !2746
  store i32 -1, i32* %2, align 4, !dbg !2747
  br label %394, !dbg !2747

22:                                               ; preds = %1
  %23 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 0, !dbg !2748
  %24 = call i32 @strncmp(i8* %23, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8.58, i64 0, i64 0), i64 3) #10, !dbg !2750
  %25 = icmp ne i32 %24, 0, !dbg !2751
  br i1 %25, label %26, label %29, !dbg !2752

26:                                               ; preds = %22
  %27 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2753
  %28 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %27, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.9.59, i64 0, i64 0)), !dbg !2755
  store i32 -1, i32* %2, align 4, !dbg !2756
  br label %394, !dbg !2756

29:                                               ; preds = %22
  %30 = getelementptr inbounds [4 x i8], [4 x i8]* %9, i64 0, i64 0, !dbg !2757
  %31 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 0, !dbg !2758
  %32 = getelementptr inbounds i8, i8* %31, i64 3, !dbg !2759
  %33 = call i8* @strncpy(i8* %30, i8* %32, i64 3) #9, !dbg !2760
  %34 = getelementptr inbounds [4 x i8], [4 x i8]* %9, i64 0, i64 3, !dbg !2761
  store i8 0, i8* %34, align 1, !dbg !2762
  %35 = getelementptr inbounds [4 x i8], [4 x i8]* %9, i64 0, i64 0, !dbg !2763
  %36 = call i32 @strcmp(i8* %35, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.10.60, i64 0, i64 0)) #10, !dbg !2765
  %37 = icmp ne i32 %36, 0, !dbg !2766
  br i1 %37, label %38, label %45, !dbg !2767

38:                                               ; preds = %29
  %39 = getelementptr inbounds [4 x i8], [4 x i8]* %9, i64 0, i64 0, !dbg !2768
  %40 = call i32 @strcmp(i8* %39, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.11.61, i64 0, i64 0)) #10, !dbg !2769
  %41 = icmp ne i32 %40, 0, !dbg !2770
  br i1 %41, label %42, label %45, !dbg !2771

42:                                               ; preds = %38
  %43 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2772
  %44 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %43, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @.str.12.62, i64 0, i64 0)), !dbg !2774
  br label %45, !dbg !2775

45:                                               ; preds = %42, %38, %29
  %46 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 0, !dbg !2776
  %47 = load %struct._IO_FILE*, %struct._IO_FILE** %3, align 8, !dbg !2776
  %48 = call i64 @fread(i8* %46, i64 7, i64 1, %struct._IO_FILE* %47), !dbg !2776
  %49 = icmp ne i64 %48, 0, !dbg !2776
  br i1 %49, label %53, label %50, !dbg !2778

50:                                               ; preds = %45
  %51 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2779
  %52 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %51, i8* getelementptr inbounds ([43 x i8], [43 x i8]* @.str.13.63, i64 0, i64 0)), !dbg !2781
  store i32 -1, i32* %2, align 4, !dbg !2782
  br label %394, !dbg !2782

53:                                               ; preds = %45
  %54 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 1, !dbg !2783
  %55 = load i8, i8* %54, align 1, !dbg !2783
  %56 = zext i8 %55 to i32, !dbg !2783
  %57 = shl i32 %56, 8, !dbg !2783
  %58 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 0, !dbg !2783
  %59 = load i8, i8* %58, align 1, !dbg !2783
  %60 = zext i8 %59 to i32, !dbg !2783
  %61 = or i32 %57, %60, !dbg !2783
  store i32 %61, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 0), align 4, !dbg !2784
  %62 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 3, !dbg !2785
  %63 = load i8, i8* %62, align 1, !dbg !2785
  %64 = zext i8 %63 to i32, !dbg !2785
  %65 = shl i32 %64, 8, !dbg !2785
  %66 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 2, !dbg !2785
  %67 = load i8, i8* %66, align 1, !dbg !2785
  %68 = zext i8 %67 to i32, !dbg !2785
  %69 = or i32 %65, %68, !dbg !2785
  store i32 %69, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 1), align 4, !dbg !2786
  %70 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 4, !dbg !2787
  %71 = load i8, i8* %70, align 1, !dbg !2787
  %72 = zext i8 %71 to i32, !dbg !2787
  %73 = and i32 %72, 7, !dbg !2788
  %74 = shl i32 2, %73, !dbg !2789
  store i32 %74, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 4), align 4, !dbg !2790
  %75 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 4, !dbg !2791
  %76 = load i8, i8* %75, align 1, !dbg !2791
  %77 = zext i8 %76 to i32, !dbg !2791
  %78 = and i32 %77, 112, !dbg !2792
  %79 = ashr i32 %78, 3, !dbg !2793
  %80 = add nsw i32 %79, 1, !dbg !2794
  store i32 %80, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 5), align 4, !dbg !2795
  %81 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 4, !dbg !2796
  %82 = load i8, i8* %81, align 1, !dbg !2796
  %83 = zext i8 %82 to i32, !dbg !2796
  %84 = and i32 %83, 128, !dbg !2796
  %85 = icmp eq i32 %84, 128, !dbg !2796
  %86 = zext i1 %85 to i32, !dbg !2796
  store i32 %86, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 3), align 4, !dbg !2797
  %87 = load i32, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 3), align 4, !dbg !2798
  %88 = icmp ne i32 %87, 0, !dbg !2800
  br i1 %88, label %89, label %98, !dbg !2801

89:                                               ; preds = %53
  %90 = load %struct._IO_FILE*, %struct._IO_FILE** %3, align 8, !dbg !2802
  %91 = load i32, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 4), align 4, !dbg !2805
  %92 = call i32 @ReadColorMap(%struct._IO_FILE* %90, i32 %91, %struct.png_color_struct* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 2, i64 0)), !dbg !2806
  %93 = icmp ne i32 %92, 0, !dbg !2806
  br i1 %93, label %94, label %97, !dbg !2807

94:                                               ; preds = %89
  %95 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2808
  %96 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %95, i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.14.64, i64 0, i64 0)), !dbg !2810
  store i32 -1, i32* %2, align 4, !dbg !2811
  br label %394, !dbg !2811

97:                                               ; preds = %89
  br label %214, !dbg !2812

98:                                               ; preds = %53
  store i32 0, i32* %10, align 4, !dbg !2813
  br label %99, !dbg !2816

99:                                               ; preds = %160, %98
  %100 = load i32, i32* %10, align 4, !dbg !2817
  %101 = icmp slt i32 %100, 248, !dbg !2819
  br i1 %101, label %102, label %163, !dbg !2820

102:                                              ; preds = %99
  %103 = load i32, i32* %10, align 4, !dbg !2821
  %104 = and i32 %103, 7, !dbg !2823
  %105 = sext i32 %104 to i64, !dbg !2824
  %106 = getelementptr inbounds [8 x i32], [8 x i32]* @ReadGIF.colors, i64 0, i64 %105, !dbg !2824
  %107 = load i32, i32* %106, align 4, !dbg !2824
  %108 = and i32 %107, 1, !dbg !2825
  %109 = icmp ne i32 %108, 0, !dbg !2825
  br i1 %109, label %110, label %114, !dbg !2826

110:                                              ; preds = %102
  %111 = load i32, i32* %10, align 4, !dbg !2827
  %112 = sub nsw i32 255, %111, !dbg !2828
  %113 = and i32 %112, 248, !dbg !2829
  br label %115, !dbg !2826

114:                                              ; preds = %102
  br label %115, !dbg !2826

115:                                              ; preds = %114, %110
  %116 = phi i32 [ %113, %110 ], [ 0, %114 ], !dbg !2826
  %117 = trunc i32 %116 to i8, !dbg !2826
  %118 = load i32, i32* %10, align 4, !dbg !2830
  %119 = sext i32 %118 to i64, !dbg !2831
  %120 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 2), i64 0, i64 %119, !dbg !2831
  %121 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %120, i32 0, i32 0, !dbg !2832
  store i8 %117, i8* %121, align 1, !dbg !2833
  %122 = load i32, i32* %10, align 4, !dbg !2834
  %123 = and i32 %122, 7, !dbg !2835
  %124 = sext i32 %123 to i64, !dbg !2836
  %125 = getelementptr inbounds [8 x i32], [8 x i32]* @ReadGIF.colors, i64 0, i64 %124, !dbg !2836
  %126 = load i32, i32* %125, align 4, !dbg !2836
  %127 = and i32 %126, 2, !dbg !2837
  %128 = icmp ne i32 %127, 0, !dbg !2837
  br i1 %128, label %129, label %133, !dbg !2838

129:                                              ; preds = %115
  %130 = load i32, i32* %10, align 4, !dbg !2839
  %131 = sub nsw i32 255, %130, !dbg !2840
  %132 = and i32 %131, 248, !dbg !2841
  br label %134, !dbg !2838

133:                                              ; preds = %115
  br label %134, !dbg !2838

134:                                              ; preds = %133, %129
  %135 = phi i32 [ %132, %129 ], [ 0, %133 ], !dbg !2838
  %136 = trunc i32 %135 to i8, !dbg !2838
  %137 = load i32, i32* %10, align 4, !dbg !2842
  %138 = sext i32 %137 to i64, !dbg !2843
  %139 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 2), i64 0, i64 %138, !dbg !2843
  %140 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %139, i32 0, i32 1, !dbg !2844
  store i8 %136, i8* %140, align 1, !dbg !2845
  %141 = load i32, i32* %10, align 4, !dbg !2846
  %142 = and i32 %141, 7, !dbg !2847
  %143 = sext i32 %142 to i64, !dbg !2848
  %144 = getelementptr inbounds [8 x i32], [8 x i32]* @ReadGIF.colors, i64 0, i64 %143, !dbg !2848
  %145 = load i32, i32* %144, align 4, !dbg !2848
  %146 = and i32 %145, 4, !dbg !2849
  %147 = icmp ne i32 %146, 0, !dbg !2849
  br i1 %147, label %148, label %152, !dbg !2850

148:                                              ; preds = %134
  %149 = load i32, i32* %10, align 4, !dbg !2851
  %150 = sub nsw i32 255, %149, !dbg !2852
  %151 = and i32 %150, 248, !dbg !2853
  br label %153, !dbg !2850

152:                                              ; preds = %134
  br label %153, !dbg !2850

153:                                              ; preds = %152, %148
  %154 = phi i32 [ %151, %148 ], [ 0, %152 ], !dbg !2850
  %155 = trunc i32 %154 to i8, !dbg !2850
  %156 = load i32, i32* %10, align 4, !dbg !2854
  %157 = sext i32 %156 to i64, !dbg !2855
  %158 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 2), i64 0, i64 %157, !dbg !2855
  %159 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %158, i32 0, i32 2, !dbg !2856
  store i8 %155, i8* %159, align 1, !dbg !2857
  br label %160, !dbg !2858

160:                                              ; preds = %153
  %161 = load i32, i32* %10, align 4, !dbg !2859
  %162 = add nsw i32 %161, 1, !dbg !2859
  store i32 %162, i32* %10, align 4, !dbg !2859
  br label %99, !dbg !2860, !llvm.loop !2861

163:                                              ; preds = %99
  store i32 248, i32* %10, align 4, !dbg !2863
  br label %164, !dbg !2865

164:                                              ; preds = %210, %163
  %165 = load i32, i32* %10, align 4, !dbg !2866
  %166 = icmp slt i32 %165, 256, !dbg !2868
  br i1 %166, label %167, label %213, !dbg !2869

167:                                              ; preds = %164
  %168 = load i32, i32* %10, align 4, !dbg !2870
  %169 = and i32 %168, 7, !dbg !2872
  %170 = sext i32 %169 to i64, !dbg !2873
  %171 = getelementptr inbounds [8 x i32], [8 x i32]* @ReadGIF.colors, i64 0, i64 %170, !dbg !2873
  %172 = load i32, i32* %171, align 4, !dbg !2873
  %173 = and i32 %172, 1, !dbg !2874
  %174 = icmp ne i32 %173, 0, !dbg !2875
  %175 = zext i1 %174 to i64, !dbg !2875
  %176 = select i1 %174, i32 4, i32 0, !dbg !2875
  %177 = trunc i32 %176 to i8, !dbg !2875
  %178 = load i32, i32* %10, align 4, !dbg !2876
  %179 = sext i32 %178 to i64, !dbg !2877
  %180 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 2), i64 0, i64 %179, !dbg !2877
  %181 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %180, i32 0, i32 0, !dbg !2878
  store i8 %177, i8* %181, align 1, !dbg !2879
  %182 = load i32, i32* %10, align 4, !dbg !2880
  %183 = and i32 %182, 7, !dbg !2881
  %184 = sext i32 %183 to i64, !dbg !2882
  %185 = getelementptr inbounds [8 x i32], [8 x i32]* @ReadGIF.colors, i64 0, i64 %184, !dbg !2882
  %186 = load i32, i32* %185, align 4, !dbg !2882
  %187 = and i32 %186, 2, !dbg !2883
  %188 = icmp ne i32 %187, 0, !dbg !2884
  %189 = zext i1 %188 to i64, !dbg !2884
  %190 = select i1 %188, i32 4, i32 0, !dbg !2884
  %191 = trunc i32 %190 to i8, !dbg !2884
  %192 = load i32, i32* %10, align 4, !dbg !2885
  %193 = sext i32 %192 to i64, !dbg !2886
  %194 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 2), i64 0, i64 %193, !dbg !2886
  %195 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %194, i32 0, i32 1, !dbg !2887
  store i8 %191, i8* %195, align 1, !dbg !2888
  %196 = load i32, i32* %10, align 4, !dbg !2889
  %197 = and i32 %196, 7, !dbg !2890
  %198 = sext i32 %197 to i64, !dbg !2891
  %199 = getelementptr inbounds [8 x i32], [8 x i32]* @ReadGIF.colors, i64 0, i64 %198, !dbg !2891
  %200 = load i32, i32* %199, align 4, !dbg !2891
  %201 = and i32 %200, 4, !dbg !2892
  %202 = icmp ne i32 %201, 0, !dbg !2893
  %203 = zext i1 %202 to i64, !dbg !2893
  %204 = select i1 %202, i32 4, i32 0, !dbg !2893
  %205 = trunc i32 %204 to i8, !dbg !2893
  %206 = load i32, i32* %10, align 4, !dbg !2894
  %207 = sext i32 %206 to i64, !dbg !2895
  %208 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 2), i64 0, i64 %207, !dbg !2895
  %209 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %208, i32 0, i32 2, !dbg !2896
  store i8 %205, i8* %209, align 1, !dbg !2897
  br label %210, !dbg !2898

210:                                              ; preds = %167
  %211 = load i32, i32* %10, align 4, !dbg !2899
  %212 = add nsw i32 %211, 1, !dbg !2899
  store i32 %212, i32* %10, align 4, !dbg !2899
  br label %164, !dbg !2900, !llvm.loop !2901

213:                                              ; preds = %164
  br label %214

214:                                              ; preds = %213, %97
  %215 = load i32, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 3), align 4, !dbg !2903
  %216 = icmp ne i32 %215, 0, !dbg !2905
  br i1 %216, label %217, label %221, !dbg !2906

217:                                              ; preds = %214
  %218 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 5, !dbg !2907
  %219 = load i8, i8* %218, align 1, !dbg !2907
  %220 = zext i8 %219 to i32, !dbg !2907
  store i32 %220, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 6), align 4, !dbg !2909
  br label %222, !dbg !2910

221:                                              ; preds = %214
  store i32 -1, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 6), align 4, !dbg !2911
  br label %222

222:                                              ; preds = %221, %217
  %223 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 6, !dbg !2913
  %224 = load i8, i8* %223, align 1, !dbg !2913
  %225 = zext i8 %224 to i32, !dbg !2913
  store i32 %225, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 7), align 4, !dbg !2914
  br label %226, !dbg !2915

226:                                              ; preds = %222, %266, %393
  %227 = load %struct._IO_FILE*, %struct._IO_FILE** %3, align 8, !dbg !2916
  %228 = call i64 @fread(i8* %5, i64 1, i64 1, %struct._IO_FILE* %227), !dbg !2916
  %229 = icmp ne i64 %228, 0, !dbg !2916
  br i1 %229, label %234, label %230, !dbg !2919

230:                                              ; preds = %226
  %231 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2920
  %232 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %231, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.15.65, i64 0, i64 0)), !dbg !2922
  %233 = call i32 @check_recover(i32 0), !dbg !2923
  store i32 %233, i32* %2, align 4, !dbg !2924
  br label %394, !dbg !2924

234:                                              ; preds = %226
  %235 = load i8, i8* %5, align 1, !dbg !2925
  %236 = zext i8 %235 to i32, !dbg !2925
  %237 = icmp eq i32 %236, 59, !dbg !2927
  br i1 %237, label %238, label %246, !dbg !2928

238:                                              ; preds = %234
  %239 = load i32, i32* @verbose, align 4, !dbg !2929
  %240 = icmp sgt i32 %239, 1, !dbg !2932
  br i1 %240, label %241, label %244, !dbg !2933

241:                                              ; preds = %238
  %242 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2934
  %243 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %242, i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str.16.66, i64 0, i64 0)), !dbg !2935
  br label %244, !dbg !2935

244:                                              ; preds = %241, %238
  %245 = load i32, i32* @imagecount, align 4, !dbg !2936
  store i32 %245, i32* %2, align 4, !dbg !2937
  br label %394, !dbg !2937

246:                                              ; preds = %234
  %247 = load i8, i8* %5, align 1, !dbg !2938
  %248 = zext i8 %247 to i32, !dbg !2938
  %249 = icmp eq i32 %248, 33, !dbg !2940
  br i1 %249, label %250, label %267, !dbg !2941

250:                                              ; preds = %246
  %251 = load %struct._IO_FILE*, %struct._IO_FILE** %3, align 8, !dbg !2942
  %252 = call i64 @fread(i8* %5, i64 1, i64 1, %struct._IO_FILE* %251), !dbg !2942
  %253 = icmp ne i64 %252, 0, !dbg !2942
  br i1 %253, label %258, label %254, !dbg !2945

254:                                              ; preds = %250
  %255 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2946
  %256 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %255, i8* getelementptr inbounds ([54 x i8], [54 x i8]* @.str.17.67, i64 0, i64 0)), !dbg !2948
  %257 = call i32 @check_recover(i32 0), !dbg !2949
  store i32 %257, i32* %2, align 4, !dbg !2950
  br label %394, !dbg !2950

258:                                              ; preds = %250
  %259 = load %struct._IO_FILE*, %struct._IO_FILE** %3, align 8, !dbg !2951
  %260 = load i8, i8* %5, align 1, !dbg !2953
  %261 = zext i8 %260 to i32, !dbg !2953
  %262 = call i32 @DoExtension(%struct._IO_FILE* %259, i32 %261), !dbg !2954
  %263 = icmp ne i32 %262, 0, !dbg !2954
  br i1 %263, label %264, label %266, !dbg !2955

264:                                              ; preds = %258
  %265 = call i32 @check_recover(i32 0), !dbg !2956
  store i32 %265, i32* %2, align 4, !dbg !2957
  br label %394, !dbg !2957

266:                                              ; preds = %258
  br label %226, !dbg !2958, !llvm.loop !2959

267:                                              ; preds = %246
  %268 = load i8, i8* %5, align 1, !dbg !2961
  %269 = zext i8 %268 to i32, !dbg !2961
  %270 = icmp ne i32 %269, 44, !dbg !2963
  br i1 %270, label %271, label %277, !dbg !2964

271:                                              ; preds = %267
  %272 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2965
  %273 = load i8, i8* %5, align 1, !dbg !2967
  %274 = zext i8 %273 to i32, !dbg !2968
  %275 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %272, i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str.18.68, i64 0, i64 0), i32 %274), !dbg !2969
  %276 = call i32 @check_recover(i32 0), !dbg !2970
  store i32 %276, i32* %2, align 4, !dbg !2971
  br label %394, !dbg !2971

277:                                              ; preds = %267
  %278 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 0, !dbg !2972
  %279 = load %struct._IO_FILE*, %struct._IO_FILE** %3, align 8, !dbg !2972
  %280 = call i64 @fread(i8* %278, i64 9, i64 1, %struct._IO_FILE* %279), !dbg !2972
  %281 = icmp ne i64 %280, 0, !dbg !2972
  br i1 %281, label %286, label %282, !dbg !2974

282:                                              ; preds = %277
  %283 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !2975
  %284 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %283, i8* getelementptr inbounds ([46 x i8], [46 x i8]* @.str.19.69, i64 0, i64 0)), !dbg !2977
  %285 = call i32 @check_recover(i32 0), !dbg !2978
  store i32 %285, i32* %2, align 4, !dbg !2979
  br label %394, !dbg !2979

286:                                              ; preds = %277
  %287 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 8, !dbg !2980
  %288 = load i8, i8* %287, align 1, !dbg !2980
  %289 = zext i8 %288 to i32, !dbg !2980
  %290 = and i32 %289, 128, !dbg !2980
  %291 = icmp eq i32 %290, 128, !dbg !2980
  %292 = xor i1 %291, true, !dbg !2981
  %293 = zext i1 %292 to i32, !dbg !2981
  store i32 %293, i32* %7, align 4, !dbg !2982
  %294 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 8, !dbg !2983
  %295 = load i8, i8* %294, align 1, !dbg !2983
  %296 = zext i8 %295 to i32, !dbg !2983
  %297 = and i32 %296, 7, !dbg !2984
  %298 = add nsw i32 %297, 1, !dbg !2985
  %299 = shl i32 1, %298, !dbg !2986
  store i32 %299, i32* %8, align 4, !dbg !2987
  %300 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 1, !dbg !2988
  %301 = load i8, i8* %300, align 1, !dbg !2988
  %302 = zext i8 %301 to i32, !dbg !2988
  %303 = shl i32 %302, 8, !dbg !2988
  %304 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 0, !dbg !2988
  %305 = load i8, i8* %304, align 1, !dbg !2988
  %306 = zext i8 %305 to i32, !dbg !2988
  %307 = or i32 %303, %306, !dbg !2988
  store i32 %307, i32* %13, align 4, !dbg !2989
  %308 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 3, !dbg !2990
  %309 = load i8, i8* %308, align 1, !dbg !2990
  %310 = zext i8 %309 to i32, !dbg !2990
  %311 = shl i32 %310, 8, !dbg !2990
  %312 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 2, !dbg !2990
  %313 = load i8, i8* %312, align 1, !dbg !2990
  %314 = zext i8 %313 to i32, !dbg !2990
  %315 = or i32 %311, %314, !dbg !2990
  store i32 %315, i32* %14, align 4, !dbg !2991
  %316 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 5, !dbg !2992
  %317 = load i8, i8* %316, align 1, !dbg !2992
  %318 = zext i8 %317 to i32, !dbg !2992
  %319 = shl i32 %318, 8, !dbg !2992
  %320 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 4, !dbg !2992
  %321 = load i8, i8* %320, align 1, !dbg !2992
  %322 = zext i8 %321 to i32, !dbg !2992
  %323 = or i32 %319, %322, !dbg !2992
  store i32 %323, i32* %11, align 4, !dbg !2993
  %324 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 7, !dbg !2994
  %325 = load i8, i8* %324, align 1, !dbg !2994
  %326 = zext i8 %325 to i32, !dbg !2994
  %327 = shl i32 %326, 8, !dbg !2994
  %328 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 6, !dbg !2994
  %329 = load i8, i8* %328, align 1, !dbg !2994
  %330 = zext i8 %329 to i32, !dbg !2994
  %331 = or i32 %327, %330, !dbg !2994
  store i32 %331, i32* %12, align 4, !dbg !2995
  %332 = load i32, i32* %7, align 4, !dbg !2996
  %333 = icmp ne i32 %332, 0, !dbg !2996
  br i1 %333, label %364, label %334, !dbg !2998

334:                                              ; preds = %286
  %335 = load %struct._IO_FILE*, %struct._IO_FILE** %3, align 8, !dbg !2999
  %336 = load i32, i32* %8, align 4, !dbg !3002
  %337 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* %6, i64 0, i64 0, !dbg !3003
  %338 = call i32 @ReadColorMap(%struct._IO_FILE* %335, i32 %336, %struct.png_color_struct* %337), !dbg !3004
  %339 = icmp ne i32 %338, 0, !dbg !3004
  br i1 %339, label %340, label %344, !dbg !3005

340:                                              ; preds = %334
  %341 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !3006
  %342 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %341, i8* getelementptr inbounds ([39 x i8], [39 x i8]* @.str.20.70, i64 0, i64 0)), !dbg !3008
  %343 = call i32 @check_recover(i32 0), !dbg !3009
  store i32 %343, i32* %2, align 4, !dbg !3010
  br label %394, !dbg !3010

344:                                              ; preds = %334
  %345 = load %struct._IO_FILE*, %struct._IO_FILE** %3, align 8, !dbg !3011
  %346 = load i32, i32* %13, align 4, !dbg !3013
  %347 = load i32, i32* %14, align 4, !dbg !3014
  %348 = load i32, i32* %11, align 4, !dbg !3015
  %349 = load i32, i32* %12, align 4, !dbg !3016
  %350 = load i32, i32* %8, align 4, !dbg !3017
  %351 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* %6, i64 0, i64 0, !dbg !3018
  %352 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 8, !dbg !3019
  %353 = load i8, i8* %352, align 1, !dbg !3019
  %354 = zext i8 %353 to i32, !dbg !3019
  %355 = and i32 %354, 64, !dbg !3019
  %356 = icmp eq i32 %355, 64, !dbg !3019
  %357 = zext i1 %356 to i32, !dbg !3019
  %358 = call i32 @ReadImage(%struct._IO_FILE* %345, i32 %346, i32 %347, i32 %348, i32 %349, i32 %350, %struct.png_color_struct* %351, i32 %357), !dbg !3020
  %359 = icmp ne i32 %358, 0, !dbg !3020
  br i1 %359, label %363, label %360, !dbg !3021

360:                                              ; preds = %344
  %361 = load i32, i32* @imagecount, align 4, !dbg !3022
  %362 = add nsw i32 %361, 1, !dbg !3022
  store i32 %362, i32* @imagecount, align 4, !dbg !3022
  br label %363, !dbg !3024

363:                                              ; preds = %360, %344
  br label %393, !dbg !3025

364:                                              ; preds = %286
  %365 = load i32, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 3), align 4, !dbg !3026
  %366 = icmp ne i32 %365, 0, !dbg !3029
  br i1 %366, label %374, label %367, !dbg !3030

367:                                              ; preds = %364
  %368 = load i32, i32* @verbose, align 4, !dbg !3031
  %369 = icmp sgt i32 %368, 1, !dbg !3034
  br i1 %369, label %370, label %373, !dbg !3035

370:                                              ; preds = %367
  %371 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !3036
  %372 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %371, i8* getelementptr inbounds ([59 x i8], [59 x i8]* @.str.21.71, i64 0, i64 0)), !dbg !3037
  br label %373, !dbg !3037

373:                                              ; preds = %370, %367
  br label %374, !dbg !3038

374:                                              ; preds = %373, %364
  %375 = load %struct._IO_FILE*, %struct._IO_FILE** %3, align 8, !dbg !3039
  %376 = load i32, i32* %13, align 4, !dbg !3041
  %377 = load i32, i32* %14, align 4, !dbg !3042
  %378 = load i32, i32* %11, align 4, !dbg !3043
  %379 = load i32, i32* %12, align 4, !dbg !3044
  %380 = load i32, i32* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 4), align 4, !dbg !3045
  %381 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 8, !dbg !3046
  %382 = load i8, i8* %381, align 1, !dbg !3046
  %383 = zext i8 %382 to i32, !dbg !3046
  %384 = and i32 %383, 64, !dbg !3046
  %385 = icmp eq i32 %384, 64, !dbg !3046
  %386 = zext i1 %385 to i32, !dbg !3046
  %387 = call i32 @ReadImage(%struct._IO_FILE* %375, i32 %376, i32 %377, i32 %378, i32 %379, i32 %380, %struct.png_color_struct* getelementptr inbounds (%struct.gif_scr, %struct.gif_scr* @GifScreen, i32 0, i32 2, i64 0), i32 %386), !dbg !3047
  %388 = icmp ne i32 %387, 0, !dbg !3047
  br i1 %388, label %392, label %389, !dbg !3048

389:                                              ; preds = %374
  %390 = load i32, i32* @imagecount, align 4, !dbg !3049
  %391 = add nsw i32 %390, 1, !dbg !3049
  store i32 %391, i32* @imagecount, align 4, !dbg !3049
  br label %392, !dbg !3051

392:                                              ; preds = %389, %374
  br label %393

393:                                              ; preds = %392, %363
  store i32 -1, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 0), align 4, !dbg !3052
  store i32 -1, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 1), align 4, !dbg !3053
  store i32 -1, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 2), align 4, !dbg !3054
  store i32 0, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 3), align 4, !dbg !3055
  br label %226, !dbg !2915, !llvm.loop !2959

394:                                              ; preds = %340, %282, %271, %264, %254, %244, %230, %94, %50, %26, %19
  %395 = load i32, i32* %2, align 4, !dbg !3056
  ret i32 %395, !dbg !3056
}

declare dso_local i64 @fread(i8*, i64, i64, %struct._IO_FILE*) #3

; Function Attrs: nounwind readonly
declare dso_local i32 @strncmp(i8*, i8*, i64) #7

; Function Attrs: nounwind
declare dso_local i8* @strncpy(i8*, i8*, i64) #6

; Function Attrs: noinline nounwind optnone
define internal i32 @ReadColorMap(%struct._IO_FILE* %0, i32 %1, %struct.png_color_struct* %2) #0 !dbg !3057 {
  %4 = alloca i32, align 4
  %5 = alloca %struct._IO_FILE*, align 8
  %6 = alloca i32, align 4
  %7 = alloca %struct.png_color_struct*, align 8
  %8 = alloca i32, align 4
  %9 = alloca [3 x i8], align 1
  store %struct._IO_FILE* %0, %struct._IO_FILE** %5, align 8
  call void @llvm.dbg.declare(metadata %struct._IO_FILE** %5, metadata !3061, metadata !DIExpression()), !dbg !3062
  store i32 %1, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !3063, metadata !DIExpression()), !dbg !3064
  store %struct.png_color_struct* %2, %struct.png_color_struct** %7, align 8
  call void @llvm.dbg.declare(metadata %struct.png_color_struct** %7, metadata !3065, metadata !DIExpression()), !dbg !3066
  call void @llvm.dbg.declare(metadata i32* %8, metadata !3067, metadata !DIExpression()), !dbg !3068
  call void @llvm.dbg.declare(metadata [3 x i8]* %9, metadata !3069, metadata !DIExpression()), !dbg !3073
  store i32 0, i32* %8, align 4, !dbg !3074
  br label %10, !dbg !3076

10:                                               ; preds = %44, %3
  %11 = load i32, i32* %8, align 4, !dbg !3077
  %12 = load i32, i32* %6, align 4, !dbg !3079
  %13 = icmp slt i32 %11, %12, !dbg !3080
  br i1 %13, label %14, label %47, !dbg !3081

14:                                               ; preds = %10
  %15 = getelementptr inbounds [3 x i8], [3 x i8]* %9, i64 0, i64 0, !dbg !3082
  %16 = load %struct._IO_FILE*, %struct._IO_FILE** %5, align 8, !dbg !3082
  %17 = call i64 @fread(i8* %15, i64 3, i64 1, %struct._IO_FILE* %16), !dbg !3082
  %18 = icmp ne i64 %17, 0, !dbg !3082
  br i1 %18, label %22, label %19, !dbg !3085

19:                                               ; preds = %14
  %20 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !3086
  %21 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %20, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.22.88, i64 0, i64 0)), !dbg !3088
  store i32 1, i32* %4, align 4, !dbg !3089
  br label %72, !dbg !3089

22:                                               ; preds = %14
  %23 = getelementptr inbounds [3 x i8], [3 x i8]* %9, i64 0, i64 0, !dbg !3090
  %24 = load i8, i8* %23, align 1, !dbg !3090
  %25 = load %struct.png_color_struct*, %struct.png_color_struct** %7, align 8, !dbg !3091
  %26 = load i32, i32* %8, align 4, !dbg !3092
  %27 = sext i32 %26 to i64, !dbg !3091
  %28 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %25, i64 %27, !dbg !3091
  %29 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %28, i32 0, i32 0, !dbg !3093
  store i8 %24, i8* %29, align 1, !dbg !3094
  %30 = getelementptr inbounds [3 x i8], [3 x i8]* %9, i64 0, i64 1, !dbg !3095
  %31 = load i8, i8* %30, align 1, !dbg !3095
  %32 = load %struct.png_color_struct*, %struct.png_color_struct** %7, align 8, !dbg !3096
  %33 = load i32, i32* %8, align 4, !dbg !3097
  %34 = sext i32 %33 to i64, !dbg !3096
  %35 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %32, i64 %34, !dbg !3096
  %36 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %35, i32 0, i32 1, !dbg !3098
  store i8 %31, i8* %36, align 1, !dbg !3099
  %37 = getelementptr inbounds [3 x i8], [3 x i8]* %9, i64 0, i64 2, !dbg !3100
  %38 = load i8, i8* %37, align 1, !dbg !3100
  %39 = load %struct.png_color_struct*, %struct.png_color_struct** %7, align 8, !dbg !3101
  %40 = load i32, i32* %8, align 4, !dbg !3102
  %41 = sext i32 %40 to i64, !dbg !3101
  %42 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %39, i64 %41, !dbg !3101
  %43 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %42, i32 0, i32 2, !dbg !3103
  store i8 %38, i8* %43, align 1, !dbg !3104
  br label %44, !dbg !3105

44:                                               ; preds = %22
  %45 = load i32, i32* %8, align 4, !dbg !3106
  %46 = add nsw i32 %45, 1, !dbg !3106
  store i32 %46, i32* %8, align 4, !dbg !3106
  br label %10, !dbg !3107, !llvm.loop !3108

47:                                               ; preds = %10
  %48 = load i32, i32* %6, align 4, !dbg !3110
  store i32 %48, i32* %8, align 4, !dbg !3112
  br label %49, !dbg !3113

49:                                               ; preds = %68, %47
  %50 = load i32, i32* %8, align 4, !dbg !3114
  %51 = icmp slt i32 %50, 256, !dbg !3116
  br i1 %51, label %52, label %71, !dbg !3117

52:                                               ; preds = %49
  %53 = load %struct.png_color_struct*, %struct.png_color_struct** %7, align 8, !dbg !3118
  %54 = load i32, i32* %8, align 4, !dbg !3120
  %55 = sext i32 %54 to i64, !dbg !3118
  %56 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %53, i64 %55, !dbg !3118
  %57 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %56, i32 0, i32 0, !dbg !3121
  store i8 0, i8* %57, align 1, !dbg !3122
  %58 = load %struct.png_color_struct*, %struct.png_color_struct** %7, align 8, !dbg !3123
  %59 = load i32, i32* %8, align 4, !dbg !3124
  %60 = sext i32 %59 to i64, !dbg !3123
  %61 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %58, i64 %60, !dbg !3123
  %62 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %61, i32 0, i32 1, !dbg !3125
  store i8 0, i8* %62, align 1, !dbg !3126
  %63 = load %struct.png_color_struct*, %struct.png_color_struct** %7, align 8, !dbg !3127
  %64 = load i32, i32* %8, align 4, !dbg !3128
  %65 = sext i32 %64 to i64, !dbg !3127
  %66 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %63, i64 %65, !dbg !3127
  %67 = getelementptr inbounds %struct.png_color_struct, %struct.png_color_struct* %66, i32 0, i32 2, !dbg !3129
  store i8 0, i8* %67, align 1, !dbg !3130
  br label %68, !dbg !3131

68:                                               ; preds = %52
  %69 = load i32, i32* %8, align 4, !dbg !3132
  %70 = add nsw i32 %69, 1, !dbg !3132
  store i32 %70, i32* %8, align 4, !dbg !3132
  br label %49, !dbg !3133, !llvm.loop !3134

71:                                               ; preds = %49
  store i32 0, i32* %4, align 4, !dbg !3136
  br label %72, !dbg !3136

72:                                               ; preds = %71, %19
  %73 = load i32, i32* %4, align 4, !dbg !3137
  ret i32 %73, !dbg !3137
}

; Function Attrs: noinline nounwind optnone
define internal i32 @DoExtension(%struct._IO_FILE* %0, i32 %1) #0 !dbg !359 {
  %3 = alloca i32, align 4
  %4 = alloca %struct._IO_FILE*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store %struct._IO_FILE* %0, %struct._IO_FILE** %4, align 8
  call void @llvm.dbg.declare(metadata %struct._IO_FILE** %4, metadata !3138, metadata !DIExpression()), !dbg !3139
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !3140, metadata !DIExpression()), !dbg !3141
  call void @llvm.dbg.declare(metadata i8** %6, metadata !3142, metadata !DIExpression()), !dbg !3143
  call void @llvm.dbg.declare(metadata i8** %7, metadata !3144, metadata !DIExpression()), !dbg !3145
  call void @llvm.dbg.declare(metadata i8** %8, metadata !3146, metadata !DIExpression()), !dbg !3147
  call void @llvm.dbg.declare(metadata i32* %9, metadata !3148, metadata !DIExpression()), !dbg !3149
  call void @llvm.dbg.declare(metadata i32* %10, metadata !3150, metadata !DIExpression()), !dbg !3151
  %11 = load i32, i32* %5, align 4, !dbg !3152
  switch i32 %11, label %136 [
    i32 1, label %12
    i32 255, label %25
    i32 254, label %26
    i32 249, label %95
  ], !dbg !3153

12:                                               ; preds = %2
  store i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.23.81, i64 0, i64 0), i8** %6, align 8, !dbg !3154
  store i32 -1, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 0), align 4, !dbg !3156
  store i32 -1, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 1), align 4, !dbg !3157
  store i32 -1, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 2), align 4, !dbg !3158
  store i32 0, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 3), align 4, !dbg !3159
  %13 = load i32, i32* @verbose, align 4, !dbg !3160
  %14 = icmp sgt i32 %13, 1, !dbg !3162
  br i1 %14, label %15, label %18, !dbg !3163

15:                                               ; preds = %12
  %16 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !3164
  %17 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %16, i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.24.82, i64 0, i64 0)), !dbg !3165
  br label %18, !dbg !3165

18:                                               ; preds = %15, %12
  br label %19, !dbg !3166

19:                                               ; preds = %23, %18
  %20 = load %struct._IO_FILE*, %struct._IO_FILE** %4, align 8, !dbg !3167
  %21 = call i32 @GetDataBlock(%struct._IO_FILE* %20, i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 0)), !dbg !3168
  %22 = icmp sgt i32 %21, 0, !dbg !3169
  br i1 %22, label %23, label %24, !dbg !3166

23:                                               ; preds = %19
  br label %19, !dbg !3170, !llvm.loop !3171

24:                                               ; preds = %19
  store i32 0, i32* %3, align 4, !dbg !3172
  br label %172, !dbg !3172

25:                                               ; preds = %2
  store i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.25.83, i64 0, i64 0), i8** %6, align 8, !dbg !3173
  br label %152, !dbg !3174

26:                                               ; preds = %2
  call void @allocate_element(), !dbg !3175
  store i32 0, i32* %10, align 4, !dbg !3176
  br label %27, !dbg !3177

27:                                               ; preds = %78, %26
  %28 = load %struct._IO_FILE*, %struct._IO_FILE** %4, align 8, !dbg !3178
  %29 = call i32 @GetDataBlock(%struct._IO_FILE* %28, i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 0)), !dbg !3179
  store i32 %29, i32* %9, align 4, !dbg !3180
  %30 = icmp sgt i32 %29, 0, !dbg !3181
  br i1 %30, label %31, label %84, !dbg !3177

31:                                               ; preds = %27
  store i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 0), i8** %7, align 8, !dbg !3182
  store i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 0), i8** %8, align 8, !dbg !3184
  %32 = load i32, i32* %10, align 4, !dbg !3185
  %33 = icmp ne i32 %32, 0, !dbg !3185
  br i1 %33, label %34, label %40, !dbg !3187

34:                                               ; preds = %31
  %35 = load i8*, i8** %7, align 8, !dbg !3188
  %36 = load i8, i8* %35, align 1, !dbg !3189
  %37 = zext i8 %36 to i32, !dbg !3189
  %38 = icmp ne i32 %37, 10, !dbg !3190
  br i1 %38, label %39, label %40, !dbg !3191

39:                                               ; preds = %34
  call void @store_block(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6.54, i64 0, i64 0), i32 1), !dbg !3192
  store i32 0, i32* %10, align 4, !dbg !3194
  br label %40, !dbg !3195

40:                                               ; preds = %39, %34, %31
  br label %41, !dbg !3196

41:                                               ; preds = %75, %40
  %42 = load i8*, i8** %7, align 8, !dbg !3197
  %43 = ptrtoint i8* %42 to i64, !dbg !3198
  %44 = sub i64 %43, ptrtoint ([256 x i8]* @DoExtension.buf to i64), !dbg !3198
  %45 = load i32, i32* %9, align 4, !dbg !3199
  %46 = sext i32 %45 to i64, !dbg !3199
  %47 = icmp slt i64 %44, %46, !dbg !3200
  br i1 %47, label %48, label %78, !dbg !3196

48:                                               ; preds = %41
  %49 = load i32, i32* %10, align 4, !dbg !3201
  %50 = icmp ne i32 %49, 0, !dbg !3201
  br i1 %50, label %51, label %60, !dbg !3204

51:                                               ; preds = %48
  %52 = load i8*, i8** %7, align 8, !dbg !3205
  %53 = load i8, i8* %52, align 1, !dbg !3208
  %54 = zext i8 %53 to i32, !dbg !3208
  %55 = icmp ne i32 %54, 10, !dbg !3209
  br i1 %55, label %56, label %59, !dbg !3210

56:                                               ; preds = %51
  %57 = load i8*, i8** %8, align 8, !dbg !3211
  %58 = getelementptr inbounds i8, i8* %57, i32 1, !dbg !3211
  store i8* %58, i8** %8, align 8, !dbg !3211
  store i8 10, i8* %57, align 1, !dbg !3212
  br label %59, !dbg !3213

59:                                               ; preds = %56, %51
  store i32 0, i32* %10, align 4, !dbg !3214
  br label %60, !dbg !3215

60:                                               ; preds = %59, %48
  %61 = load i8*, i8** %7, align 8, !dbg !3216
  %62 = load i8, i8* %61, align 1, !dbg !3218
  %63 = zext i8 %62 to i32, !dbg !3218
  %64 = icmp eq i32 %63, 13, !dbg !3219
  br i1 %64, label %65, label %66, !dbg !3220

65:                                               ; preds = %60
  store i32 1, i32* %10, align 4, !dbg !3221
  br label %75, !dbg !3222

66:                                               ; preds = %60
  %67 = load i8*, i8** %7, align 8, !dbg !3223
  %68 = load i8, i8* %67, align 1, !dbg !3224
  %69 = zext i8 %68 to i64, !dbg !3225
  %70 = getelementptr inbounds [0 x i32], [0 x i32]* bitcast ([256 x i32]* @c_437_l1 to [0 x i32]*), i64 0, i64 %69, !dbg !3225
  %71 = load i32, i32* %70, align 4, !dbg !3225
  %72 = trunc i32 %71 to i8, !dbg !3225
  %73 = load i8*, i8** %8, align 8, !dbg !3226
  %74 = getelementptr inbounds i8, i8* %73, i32 1, !dbg !3226
  store i8* %74, i8** %8, align 8, !dbg !3226
  store i8 %72, i8* %73, align 1, !dbg !3227
  br label %75

75:                                               ; preds = %66, %65
  %76 = load i8*, i8** %7, align 8, !dbg !3228
  %77 = getelementptr inbounds i8, i8* %76, i32 1, !dbg !3228
  store i8* %77, i8** %7, align 8, !dbg !3228
  br label %41, !dbg !3196, !llvm.loop !3229

78:                                               ; preds = %41
  %79 = load i8*, i8** %8, align 8, !dbg !3231
  %80 = ptrtoint i8* %79 to i64, !dbg !3232
  %81 = sub i64 %80, ptrtoint ([256 x i8]* @DoExtension.buf to i64), !dbg !3232
  %82 = trunc i64 %81 to i32, !dbg !3231
  store i32 %82, i32* %9, align 4, !dbg !3233
  %83 = load i32, i32* %9, align 4, !dbg !3234
  call void @store_block(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 0), i32 %83), !dbg !3235
  br label %27, !dbg !3177, !llvm.loop !3236

84:                                               ; preds = %27
  %85 = load i32, i32* @verbose, align 4, !dbg !3238
  %86 = icmp sgt i32 %85, 1, !dbg !3240
  br i1 %86, label %87, label %90, !dbg !3241

87:                                               ; preds = %84
  %88 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !3242
  %89 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %88, i8* getelementptr inbounds ([46 x i8], [46 x i8]* @.str.26.84, i64 0, i64 0)), !dbg !3243
  br label %90, !dbg !3243

90:                                               ; preds = %87, %84
  %91 = load i32, i32* %5, align 4, !dbg !3244
  %92 = trunc i32 %91 to i8, !dbg !3244
  %93 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !3245
  %94 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %93, i32 0, i32 1, !dbg !3246
  store i8 %92, i8* %94, align 8, !dbg !3247
  call void @fix_current(), !dbg !3248
  store i32 0, i32* %3, align 4, !dbg !3249
  br label %172, !dbg !3249

95:                                               ; preds = %2
  store i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.27.85, i64 0, i64 0), i8** %6, align 8, !dbg !3250
  %96 = load %struct._IO_FILE*, %struct._IO_FILE** %4, align 8, !dbg !3251
  %97 = call i32 @GetDataBlock(%struct._IO_FILE* %96, i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 0)), !dbg !3252
  store i32 %97, i32* %9, align 4, !dbg !3253
  %98 = load i8, i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 0), align 1, !dbg !3254
  %99 = zext i8 %98 to i32, !dbg !3254
  %100 = ashr i32 %99, 2, !dbg !3255
  %101 = and i32 %100, 7, !dbg !3256
  store i32 %101, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 3), align 4, !dbg !3257
  %102 = load i8, i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 0), align 1, !dbg !3258
  %103 = zext i8 %102 to i32, !dbg !3258
  %104 = ashr i32 %103, 1, !dbg !3259
  %105 = and i32 %104, 1, !dbg !3260
  store i32 %105, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 2), align 4, !dbg !3261
  %106 = load i8, i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 2), align 1, !dbg !3262
  %107 = zext i8 %106 to i32, !dbg !3262
  %108 = shl i32 %107, 8, !dbg !3262
  %109 = load i8, i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 1), align 1, !dbg !3262
  %110 = zext i8 %109 to i32, !dbg !3262
  %111 = or i32 %108, %110, !dbg !3262
  store i32 %111, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 1), align 4, !dbg !3263
  %112 = load i8, i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 0), align 1, !dbg !3264
  %113 = zext i8 %112 to i32, !dbg !3264
  %114 = and i32 %113, 1, !dbg !3266
  %115 = icmp ne i32 %114, 0, !dbg !3267
  br i1 %115, label %116, label %119, !dbg !3268

116:                                              ; preds = %95
  %117 = load i8, i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 3), align 1, !dbg !3269
  %118 = zext i8 %117 to i32, !dbg !3270
  store i32 %118, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 0), align 4, !dbg !3271
  br label %119, !dbg !3272

119:                                              ; preds = %116, %95
  %120 = load i32, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 3), align 4, !dbg !3273
  %121 = icmp eq i32 %120, 0, !dbg !3275
  br i1 %121, label %122, label %135, !dbg !3276

122:                                              ; preds = %119
  %123 = load i32, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 2), align 4, !dbg !3277
  %124 = icmp eq i32 %123, 0, !dbg !3278
  br i1 %124, label %125, label %135, !dbg !3279

125:                                              ; preds = %122
  %126 = load i32, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 1), align 4, !dbg !3280
  %127 = icmp eq i32 %126, 0, !dbg !3281
  br i1 %127, label %128, label %135, !dbg !3282

128:                                              ; preds = %125
  br label %129, !dbg !3283

129:                                              ; preds = %133, %128
  %130 = load %struct._IO_FILE*, %struct._IO_FILE** %4, align 8, !dbg !3285
  %131 = call i32 @GetDataBlock(%struct._IO_FILE* %130, i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 0)), !dbg !3286
  %132 = icmp sgt i32 %131, 0, !dbg !3287
  br i1 %132, label %133, label %134, !dbg !3283

133:                                              ; preds = %129
  br label %129, !dbg !3283, !llvm.loop !3288

134:                                              ; preds = %129
  store i32 0, i32* %3, align 4, !dbg !3290
  br label %172, !dbg !3290

135:                                              ; preds = %125, %122, %119
  call void @allocate_element(), !dbg !3291
  br label %158, !dbg !3293

136:                                              ; preds = %2
  %137 = load i32, i32* @verbose, align 4, !dbg !3294
  %138 = icmp sgt i32 %137, 1, !dbg !3296
  br i1 %138, label %139, label %145, !dbg !3297

139:                                              ; preds = %136
  %140 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !3298
  %141 = load i32, i32* %5, align 4, !dbg !3299
  %142 = trunc i32 %141 to i8, !dbg !3300
  %143 = zext i8 %142 to i32, !dbg !3300
  %144 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %140, i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str.28.86, i64 0, i64 0), i32 %143), !dbg !3301
  br label %145, !dbg !3301

145:                                              ; preds = %139, %136
  br label %146, !dbg !3302

146:                                              ; preds = %150, %145
  %147 = load %struct._IO_FILE*, %struct._IO_FILE** %4, align 8, !dbg !3303
  %148 = call i32 @GetDataBlock(%struct._IO_FILE* %147, i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 0)), !dbg !3304
  %149 = icmp sgt i32 %148, 0, !dbg !3305
  br i1 %149, label %150, label %151, !dbg !3302

150:                                              ; preds = %146
  br label %146, !dbg !3302, !llvm.loop !3306

151:                                              ; preds = %146
  store i32 1, i32* %3, align 4, !dbg !3308
  br label %172, !dbg !3308

152:                                              ; preds = %25
  call void @allocate_element(), !dbg !3309
  br label %153, !dbg !3310

153:                                              ; preds = %158, %152
  %154 = load %struct._IO_FILE*, %struct._IO_FILE** %4, align 8, !dbg !3311
  %155 = call i32 @GetDataBlock(%struct._IO_FILE* %154, i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 0)), !dbg !3312
  store i32 %155, i32* %9, align 4, !dbg !3313
  %156 = icmp sgt i32 %155, 0, !dbg !3314
  br i1 %156, label %157, label %160, !dbg !3310

157:                                              ; preds = %153
  br label %158, !dbg !3315

158:                                              ; preds = %157, %135
  call void @llvm.dbg.label(metadata !3316), !dbg !3318
  %159 = load i32, i32* %9, align 4, !dbg !3319
  call void @store_block(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @DoExtension.buf, i64 0, i64 0), i32 %159), !dbg !3320
  br label %153, !dbg !3310, !llvm.loop !3321

160:                                              ; preds = %153
  %161 = load i32, i32* @verbose, align 4, !dbg !3323
  %162 = icmp sgt i32 %161, 1, !dbg !3325
  br i1 %162, label %163, label %167, !dbg !3326

163:                                              ; preds = %160
  %164 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !3327
  %165 = load i8*, i8** %6, align 8, !dbg !3328
  %166 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %164, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.29.87, i64 0, i64 0), i8* %165), !dbg !3329
  br label %167, !dbg !3329

167:                                              ; preds = %163, %160
  %168 = load i32, i32* %5, align 4, !dbg !3330
  %169 = trunc i32 %168 to i8, !dbg !3330
  %170 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !3331
  %171 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %170, i32 0, i32 1, !dbg !3332
  store i8 %169, i8* %171, align 8, !dbg !3333
  call void @fix_current(), !dbg !3334
  store i32 0, i32* %3, align 4, !dbg !3335
  br label %172, !dbg !3335

172:                                              ; preds = %167, %151, %134, %90, %24
  %173 = load i32, i32* %3, align 4, !dbg !3336
  ret i32 %173, !dbg !3336
}

; Function Attrs: noinline nounwind optnone
define internal i32 @ReadImage(%struct._IO_FILE* %0, i32 %1, i32 %2, i32 %3, i32 %4, i32 %5, %struct.png_color_struct* %6, i32 %7) #0 !dbg !3337 {
  %9 = alloca i32, align 4
  %10 = alloca %struct._IO_FILE*, align 8
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca %struct.png_color_struct*, align 8
  %17 = alloca i32, align 4
  %18 = alloca i8*, align 8
  %19 = alloca i8, align 1
  %20 = alloca i32, align 4
  %21 = alloca i32, align 4
  %22 = alloca i32, align 4
  %23 = alloca i8*, align 8
  %24 = alloca i32, align 4
  %25 = alloca i64*, align 8
  store %struct._IO_FILE* %0, %struct._IO_FILE** %10, align 8
  call void @llvm.dbg.declare(metadata %struct._IO_FILE** %10, metadata !3340, metadata !DIExpression()), !dbg !3341
  store i32 %1, i32* %11, align 4
  call void @llvm.dbg.declare(metadata i32* %11, metadata !3342, metadata !DIExpression()), !dbg !3343
  store i32 %2, i32* %12, align 4
  call void @llvm.dbg.declare(metadata i32* %12, metadata !3344, metadata !DIExpression()), !dbg !3345
  store i32 %3, i32* %13, align 4
  call void @llvm.dbg.declare(metadata i32* %13, metadata !3346, metadata !DIExpression()), !dbg !3347
  store i32 %4, i32* %14, align 4
  call void @llvm.dbg.declare(metadata i32* %14, metadata !3348, metadata !DIExpression()), !dbg !3349
  store i32 %5, i32* %15, align 4
  call void @llvm.dbg.declare(metadata i32* %15, metadata !3350, metadata !DIExpression()), !dbg !3351
  store %struct.png_color_struct* %6, %struct.png_color_struct** %16, align 8
  call void @llvm.dbg.declare(metadata %struct.png_color_struct** %16, metadata !3352, metadata !DIExpression()), !dbg !3353
  store i32 %7, i32* %17, align 4
  call void @llvm.dbg.declare(metadata i32* %17, metadata !3354, metadata !DIExpression()), !dbg !3355
  call void @llvm.dbg.declare(metadata i8** %18, metadata !3356, metadata !DIExpression()), !dbg !3357
  call void @llvm.dbg.declare(metadata i8* %19, metadata !3358, metadata !DIExpression()), !dbg !3359
  call void @llvm.dbg.declare(metadata i32* %20, metadata !3360, metadata !DIExpression()), !dbg !3361
  call void @llvm.dbg.declare(metadata i32* %21, metadata !3362, metadata !DIExpression()), !dbg !3363
  store i32 0, i32* %21, align 4, !dbg !3363
  call void @llvm.dbg.declare(metadata i32* %22, metadata !3364, metadata !DIExpression()), !dbg !3365
  store i32 0, i32* %22, align 4, !dbg !3365
  call void @llvm.dbg.declare(metadata i8** %23, metadata !3366, metadata !DIExpression()), !dbg !3367
  call void @llvm.dbg.declare(metadata i32* %24, metadata !3368, metadata !DIExpression()), !dbg !3369
  call void @llvm.dbg.declare(metadata i64** %25, metadata !3370, metadata !DIExpression()), !dbg !3371
  %26 = load %struct._IO_FILE*, %struct._IO_FILE** %10, align 8, !dbg !3372
  %27 = call i64 @fread(i8* %19, i64 1, i64 1, %struct._IO_FILE* %26), !dbg !3372
  %28 = icmp ne i64 %27, 0, !dbg !3372
  br i1 %28, label %32, label %29, !dbg !3374

29:                                               ; preds = %8
  %30 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !3375
  %31 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %30, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.15.65, i64 0, i64 0)), !dbg !3377
  store i32 1, i32* %9, align 4, !dbg !3378
  br label %299, !dbg !3378

32:                                               ; preds = %8
  %33 = load i8, i8* %19, align 1, !dbg !3379
  %34 = zext i8 %33 to i32, !dbg !3379
  call void @initLWZ(i32 %34), !dbg !3380
  %35 = load i32, i32* @verbose, align 4, !dbg !3381
  %36 = icmp sgt i32 %35, 1, !dbg !3383
  br i1 %36, label %37, label %46, !dbg !3384

37:                                               ; preds = %32
  %38 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !3385
  %39 = load i32, i32* %13, align 4, !dbg !3386
  %40 = load i32, i32* %14, align 4, !dbg !3387
  %41 = load i32, i32* %17, align 4, !dbg !3388
  %42 = icmp ne i32 %41, 0, !dbg !3388
  %43 = zext i1 %42 to i64, !dbg !3388
  %44 = select i1 %42, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.33.72, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.3.50, i64 0, i64 0), !dbg !3388
  %45 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %38, i8* getelementptr inbounds ([39 x i8], [39 x i8]* @.str.32.73, i64 0, i64 0), i32 %39, i32 %40, i8* %44), !dbg !3389
  br label %46, !dbg !3389

46:                                               ; preds = %37, %32
  call void @allocate_image(), !dbg !3390
  %47 = load i32, i32* %13, align 4, !dbg !3391
  %48 = sext i32 %47 to i64, !dbg !3392
  %49 = load i32, i32* %14, align 4, !dbg !3393
  %50 = sext i32 %49 to i64, !dbg !3393
  %51 = mul nsw i64 %48, %50, !dbg !3394
  call void @set_size(i64 %51), !dbg !3395
  %52 = load i32, i32* %13, align 4, !dbg !3396
  %53 = sext i32 %52 to i64, !dbg !3396
  %54 = call i8* @xalloc(i64 %53), !dbg !3397
  store i8* %54, i8** %23, align 8, !dbg !3398
  %55 = load i32, i32* %11, align 4, !dbg !3399
  %56 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !3400
  %57 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %56, i32 0, i32 5, !dbg !3401
  %58 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %57, align 8, !dbg !3401
  %59 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %58, i32 0, i32 2, !dbg !3402
  store i32 %55, i32* %59, align 8, !dbg !3403
  %60 = load i32, i32* %12, align 4, !dbg !3404
  %61 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !3405
  %62 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %61, i32 0, i32 5, !dbg !3406
  %63 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %62, align 8, !dbg !3406
  %64 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %63, i32 0, i32 3, !dbg !3407
  store i32 %60, i32* %64, align 4, !dbg !3408
  %65 = load i32, i32* %13, align 4, !dbg !3409
  %66 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !3410
  %67 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %66, i32 0, i32 5, !dbg !3411
  %68 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %67, align 8, !dbg !3411
  %69 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %68, i32 0, i32 4, !dbg !3412
  store i32 %65, i32* %69, align 8, !dbg !3413
  %70 = load i32, i32* %14, align 4, !dbg !3414
  %71 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !3415
  %72 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %71, i32 0, i32 5, !dbg !3416
  %73 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %72, align 8, !dbg !3416
  %74 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %73, i32 0, i32 5, !dbg !3417
  store i32 %70, i32* %74, align 4, !dbg !3418
  %75 = load i32, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 0), align 4, !dbg !3419
  %76 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !3420
  %77 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %76, i32 0, i32 5, !dbg !3421
  %78 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %77, align 8, !dbg !3421
  %79 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %78, i32 0, i32 6, !dbg !3422
  store i32 %75, i32* %79, align 8, !dbg !3423
  %80 = load i32, i32* %17, align 4, !dbg !3424
  %81 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !3425
  %82 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %81, i32 0, i32 5, !dbg !3426
  %83 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %82, align 8, !dbg !3426
  %84 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %83, i32 0, i32 7, !dbg !3427
  store i32 %80, i32* %84, align 4, !dbg !3428
  %85 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !3429
  %86 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %85, i32 0, i32 5, !dbg !3430
  %87 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %86, align 8, !dbg !3430
  %88 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %87, i32 0, i32 0, !dbg !3431
  %89 = getelementptr inbounds [256 x %struct.png_color_struct], [256 x %struct.png_color_struct]* %88, i64 0, i64 0, !dbg !3432
  %90 = bitcast %struct.png_color_struct* %89 to i8*, !dbg !3432
  %91 = load %struct.png_color_struct*, %struct.png_color_struct** %16, align 8, !dbg !3433
  %92 = bitcast %struct.png_color_struct* %91 to i8*, !dbg !3432
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %90, i8* align 1 %92, i64 768, i1 false), !dbg !3432
  %93 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !3434
  %94 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %93, i32 0, i32 5, !dbg !3435
  %95 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %94, align 8, !dbg !3435
  %96 = getelementptr inbounds %struct.GIFimagestruct, %struct.GIFimagestruct* %95, i32 0, i32 1, !dbg !3436
  %97 = getelementptr inbounds [256 x i64], [256 x i64]* %96, i64 0, i64 0, !dbg !3434
  store i64* %97, i64** %25, align 8, !dbg !3437
  store i32 0, i32* %24, align 4, !dbg !3438
  br label %98, !dbg !3440

98:                                               ; preds = %106, %46
  %99 = load i32, i32* %24, align 4, !dbg !3441
  %100 = icmp slt i32 %99, 256, !dbg !3443
  br i1 %100, label %101, label %109, !dbg !3444

101:                                              ; preds = %98
  %102 = load i64*, i64** %25, align 8, !dbg !3445
  %103 = load i32, i32* %24, align 4, !dbg !3447
  %104 = sext i32 %103 to i64, !dbg !3445
  %105 = getelementptr inbounds i64, i64* %102, i64 %104, !dbg !3445
  store i64 0, i64* %105, align 8, !dbg !3448
  br label %106, !dbg !3449

106:                                              ; preds = %101
  %107 = load i32, i32* %24, align 4, !dbg !3450
  %108 = add nsw i32 %107, 1, !dbg !3450
  store i32 %108, i32* %24, align 4, !dbg !3450
  br label %98, !dbg !3451, !llvm.loop !3452

109:                                              ; preds = %98
  store i32 0, i32* %22, align 4, !dbg !3454
  br label %110, !dbg !3456

110:                                              ; preds = %278, %109
  %111 = load i32, i32* %22, align 4, !dbg !3457
  %112 = load i32, i32* %14, align 4, !dbg !3459
  %113 = icmp slt i32 %111, %112, !dbg !3460
  br i1 %113, label %114, label %281, !dbg !3461

114:                                              ; preds = %110
  %115 = load i8*, i8** %23, align 8, !dbg !3462
  store i8* %115, i8** %18, align 8, !dbg !3464
  store i32 0, i32* %21, align 4, !dbg !3465
  br label %116, !dbg !3467

116:                                              ; preds = %272, %114
  %117 = load i32, i32* %21, align 4, !dbg !3468
  %118 = load i32, i32* %13, align 4, !dbg !3470
  %119 = icmp slt i32 %117, %118, !dbg !3471
  br i1 %119, label %120, label %275, !dbg !3472

120:                                              ; preds = %116
  %121 = load i32*, i32** @sp, align 8, !dbg !3473
  %122 = icmp ugt i32* %121, getelementptr inbounds ([8192 x i32], [8192 x i32]* @stack, i64 0, i64 0), !dbg !3473
  br i1 %122, label %123, label %127, !dbg !3473

123:                                              ; preds = %120
  %124 = load i32*, i32** @sp, align 8, !dbg !3473
  %125 = getelementptr inbounds i32, i32* %124, i32 -1, !dbg !3473
  store i32* %125, i32** @sp, align 8, !dbg !3473
  %126 = load i32, i32* %125, align 4, !dbg !3473
  br label %130, !dbg !3473

127:                                              ; preds = %120
  %128 = load %struct._IO_FILE*, %struct._IO_FILE** %10, align 8, !dbg !3473
  %129 = call i32 @nextLWZ(%struct._IO_FILE* %128), !dbg !3473
  br label %130, !dbg !3473

130:                                              ; preds = %127, %123
  %131 = phi i32 [ %126, %123 ], [ %129, %127 ], !dbg !3473
  store i32 %131, i32* %20, align 4, !dbg !3476
  %132 = icmp slt i32 %131, 0, !dbg !3477
  br i1 %132, label %137, label %133, !dbg !3478

133:                                              ; preds = %130
  %134 = load i32, i32* %20, align 4, !dbg !3479
  %135 = load i32, i32* %15, align 4, !dbg !3480
  %136 = icmp sge i32 %134, %135, !dbg !3481
  br i1 %136, label %137, label %261, !dbg !3482

137:                                              ; preds = %133, %130
  %138 = load i32, i32* %20, align 4, !dbg !3483
  %139 = load i32, i32* %15, align 4, !dbg !3486
  %140 = icmp sge i32 %138, %139, !dbg !3487
  br i1 %140, label %141, label %144, !dbg !3488

141:                                              ; preds = %137
  %142 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !3489
  %143 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %142, i8* getelementptr inbounds ([48 x i8], [48 x i8]* @.str.34.74, i64 0, i64 0)), !dbg !3490
  br label %144, !dbg !3490

144:                                              ; preds = %141, %137
  %145 = load i32, i32* %21, align 4, !dbg !3491
  %146 = icmp sgt i32 %145, 0, !dbg !3493
  br i1 %146, label %150, label %147, !dbg !3494

147:                                              ; preds = %144
  %148 = load i32, i32* %22, align 4, !dbg !3495
  %149 = icmp sgt i32 %148, 0, !dbg !3496
  br i1 %149, label %150, label %260, !dbg !3497

150:                                              ; preds = %147, %144
  %151 = load i32, i32* @recover, align 4, !dbg !3498
  %152 = icmp ne i32 %151, 0, !dbg !3498
  br i1 %152, label %153, label %258, !dbg !3501

153:                                              ; preds = %150
  %154 = load i32, i32* %17, align 4, !dbg !3502
  %155 = icmp ne i32 %154, 0, !dbg !3502
  br i1 %155, label %183, label %156, !dbg !3505

156:                                              ; preds = %153
  %157 = load i8*, i8** %23, align 8, !dbg !3506
  %158 = load i32, i32* %21, align 4, !dbg !3508
  %159 = sext i32 %158 to i64, !dbg !3509
  %160 = getelementptr inbounds i8, i8* %157, i64 %159, !dbg !3509
  %161 = load i32, i32* %13, align 4, !dbg !3510
  %162 = load i32, i32* %21, align 4, !dbg !3511
  %163 = sub nsw i32 %161, %162, !dbg !3512
  %164 = sext i32 %163 to i64, !dbg !3510
  call void @llvm.memset.p0i8.i64(i8* align 1 %160, i8 0, i64 %164, i1 false), !dbg !3513
  %165 = load i8*, i8** %23, align 8, !dbg !3514
  %166 = load i32, i32* %13, align 4, !dbg !3515
  call void @store_block(i8* %165, i32 %166), !dbg !3516
  %167 = load i32, i32* %22, align 4, !dbg !3517
  %168 = add nsw i32 %167, 1, !dbg !3517
  store i32 %168, i32* %22, align 4, !dbg !3517
  %169 = load i8*, i8** %23, align 8, !dbg !3518
  %170 = load i32, i32* %13, align 4, !dbg !3519
  %171 = sext i32 %170 to i64, !dbg !3519
  call void @llvm.memset.p0i8.i64(i8* align 1 %169, i8 0, i64 %171, i1 false), !dbg !3520
  br label %172, !dbg !3521

172:                                              ; preds = %179, %156
  %173 = load i32, i32* %22, align 4, !dbg !3522
  %174 = load i32, i32* %14, align 4, !dbg !3525
  %175 = icmp slt i32 %173, %174, !dbg !3526
  br i1 %175, label %176, label %182, !dbg !3527

176:                                              ; preds = %172
  %177 = load i8*, i8** %23, align 8, !dbg !3528
  %178 = load i32, i32* %13, align 4, !dbg !3529
  call void @store_block(i8* %177, i32 %178), !dbg !3530
  br label %179, !dbg !3530

179:                                              ; preds = %176
  %180 = load i32, i32* %22, align 4, !dbg !3531
  %181 = add nsw i32 %180, 1, !dbg !3531
  store i32 %181, i32* %22, align 4, !dbg !3531
  br label %172, !dbg !3532, !llvm.loop !3533

182:                                              ; preds = %172
  br label %257, !dbg !3535

183:                                              ; preds = %153
  %184 = load i32, i32* %21, align 4, !dbg !3536
  %185 = icmp sgt i32 %184, 0, !dbg !3539
  br i1 %185, label %186, label %222, !dbg !3540

186:                                              ; preds = %183
  %187 = load i32, i32* %14, align 4, !dbg !3541
  %188 = load i32, i32* %22, align 4, !dbg !3544
  %189 = call i32 @inv_interlace_line(i32 %187, i32 %188), !dbg !3545
  %190 = and i32 %189, 7, !dbg !3546
  %191 = icmp eq i32 %190, 0, !dbg !3547
  br i1 %191, label %192, label %201, !dbg !3548

192:                                              ; preds = %186
  %193 = load i8*, i8** %23, align 8, !dbg !3549
  %194 = load i32, i32* %21, align 4, !dbg !3551
  %195 = sext i32 %194 to i64, !dbg !3552
  %196 = getelementptr inbounds i8, i8* %193, i64 %195, !dbg !3552
  %197 = load i32, i32* %13, align 4, !dbg !3553
  %198 = load i32, i32* %21, align 4, !dbg !3554
  %199 = sub nsw i32 %197, %198, !dbg !3555
  %200 = sext i32 %199 to i64, !dbg !3553
  call void @llvm.memset.p0i8.i64(i8* align 1 %196, i8 0, i64 %200, i1 false), !dbg !3556
  br label %217, !dbg !3557

201:                                              ; preds = %186
  %202 = load i8*, i8** %23, align 8, !dbg !3558
  %203 = load i32, i32* %21, align 4, !dbg !3560
  %204 = sext i32 %203 to i64, !dbg !3561
  %205 = getelementptr inbounds i8, i8* %202, i64 %204, !dbg !3561
  %206 = load i32, i32* %13, align 4, !dbg !3562
  %207 = load i32, i32* %14, align 4, !dbg !3563
  %208 = load i32, i32* %22, align 4, !dbg !3564
  %209 = call i8* @get_prev_line(i32 %206, i32 %207, i32 %208), !dbg !3565
  %210 = load i32, i32* %21, align 4, !dbg !3566
  %211 = sext i32 %210 to i64, !dbg !3567
  %212 = getelementptr inbounds i8, i8* %209, i64 %211, !dbg !3567
  %213 = load i32, i32* %13, align 4, !dbg !3568
  %214 = load i32, i32* %21, align 4, !dbg !3569
  %215 = sub nsw i32 %213, %214, !dbg !3570
  %216 = sext i32 %215 to i64, !dbg !3568
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %205, i8* align 1 %212, i64 %216, i1 false), !dbg !3571
  br label %217

217:                                              ; preds = %201, %192
  %218 = load i8*, i8** %23, align 8, !dbg !3572
  %219 = load i32, i32* %13, align 4, !dbg !3573
  call void @store_block(i8* %218, i32 %219), !dbg !3574
  %220 = load i32, i32* %22, align 4, !dbg !3575
  %221 = add nsw i32 %220, 1, !dbg !3575
  store i32 %221, i32* %22, align 4, !dbg !3575
  br label %222, !dbg !3576

222:                                              ; preds = %217, %183
  %223 = load i8*, i8** %23, align 8, !dbg !3577
  %224 = load i32, i32* %13, align 4, !dbg !3578
  %225 = sext i32 %224 to i64, !dbg !3578
  call void @llvm.memset.p0i8.i64(i8* align 1 %223, i8 0, i64 %225, i1 false), !dbg !3579
  br label %226, !dbg !3580

226:                                              ; preds = %235, %222
  %227 = load i32, i32* %14, align 4, !dbg !3581
  %228 = load i32, i32* %22, align 4, !dbg !3584
  %229 = call i32 @inv_interlace_line(i32 %227, i32 %228), !dbg !3585
  %230 = and i32 %229, 7, !dbg !3586
  %231 = icmp eq i32 %230, 0, !dbg !3587
  br i1 %231, label %232, label %238, !dbg !3588

232:                                              ; preds = %226
  %233 = load i8*, i8** %23, align 8, !dbg !3589
  %234 = load i32, i32* %13, align 4, !dbg !3590
  call void @store_block(i8* %233, i32 %234), !dbg !3591
  br label %235, !dbg !3591

235:                                              ; preds = %232
  %236 = load i32, i32* %22, align 4, !dbg !3592
  %237 = add nsw i32 %236, 1, !dbg !3592
  store i32 %237, i32* %22, align 4, !dbg !3592
  br label %226, !dbg !3593, !llvm.loop !3594

238:                                              ; preds = %226
  br label %239, !dbg !3596

239:                                              ; preds = %253, %238
  %240 = load i32, i32* %22, align 4, !dbg !3597
  %241 = load i32, i32* %14, align 4, !dbg !3600
  %242 = icmp slt i32 %240, %241, !dbg !3601
  br i1 %242, label %243, label %256, !dbg !3602

243:                                              ; preds = %239
  %244 = load i8*, i8** %23, align 8, !dbg !3603
  %245 = load i32, i32* %13, align 4, !dbg !3605
  %246 = load i32, i32* %14, align 4, !dbg !3606
  %247 = load i32, i32* %22, align 4, !dbg !3607
  %248 = call i8* @get_prev_line(i32 %245, i32 %246, i32 %247), !dbg !3608
  %249 = load i32, i32* %13, align 4, !dbg !3609
  %250 = sext i32 %249 to i64, !dbg !3609
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %244, i8* align 1 %248, i64 %250, i1 false), !dbg !3610
  %251 = load i8*, i8** %23, align 8, !dbg !3611
  %252 = load i32, i32* %13, align 4, !dbg !3612
  call void @store_block(i8* %251, i32 %252), !dbg !3613
  br label %253, !dbg !3614

253:                                              ; preds = %243
  %254 = load i32, i32* %22, align 4, !dbg !3615
  %255 = add nsw i32 %254, 1, !dbg !3615
  store i32 %255, i32* %22, align 4, !dbg !3615
  br label %239, !dbg !3616, !llvm.loop !3617

256:                                              ; preds = %239
  br label %257

257:                                              ; preds = %256, %182
  br label %282, !dbg !3619

258:                                              ; preds = %150
  %259 = call i32 @check_recover(i32 1), !dbg !3620
  store i32 1, i32* %9, align 4, !dbg !3622
  br label %299, !dbg !3622

260:                                              ; preds = %147
  store i32 1, i32* %9, align 4, !dbg !3623
  br label %299, !dbg !3623

261:                                              ; preds = %133
  %262 = load i64*, i64** %25, align 8, !dbg !3625
  %263 = load i32, i32* %20, align 4, !dbg !3626
  %264 = sext i32 %263 to i64, !dbg !3625
  %265 = getelementptr inbounds i64, i64* %262, i64 %264, !dbg !3625
  %266 = load i64, i64* %265, align 8, !dbg !3627
  %267 = add i64 %266, 1, !dbg !3627
  store i64 %267, i64* %265, align 8, !dbg !3627
  %268 = load i32, i32* %20, align 4, !dbg !3628
  %269 = trunc i32 %268 to i8, !dbg !3628
  %270 = load i8*, i8** %18, align 8, !dbg !3629
  %271 = getelementptr inbounds i8, i8* %270, i32 1, !dbg !3629
  store i8* %271, i8** %18, align 8, !dbg !3629
  store i8 %269, i8* %270, align 1, !dbg !3630
  br label %272, !dbg !3631

272:                                              ; preds = %261
  %273 = load i32, i32* %21, align 4, !dbg !3632
  %274 = add nsw i32 %273, 1, !dbg !3632
  store i32 %274, i32* %21, align 4, !dbg !3632
  br label %116, !dbg !3633, !llvm.loop !3634

275:                                              ; preds = %116
  %276 = load i8*, i8** %23, align 8, !dbg !3636
  %277 = load i32, i32* %13, align 4, !dbg !3637
  call void @store_block(i8* %276, i32 %277), !dbg !3638
  br label %278, !dbg !3639

278:                                              ; preds = %275
  %279 = load i32, i32* %22, align 4, !dbg !3640
  %280 = add nsw i32 %279, 1, !dbg !3640
  store i32 %280, i32* %22, align 4, !dbg !3640
  br label %110, !dbg !3641, !llvm.loop !3642

281:                                              ; preds = %110
  br label %282, !dbg !3643

282:                                              ; preds = %281, %257
  call void @llvm.dbg.label(metadata !3644), !dbg !3645
  br label %283, !dbg !3646

283:                                              ; preds = %296, %282
  %284 = load i32*, i32** @sp, align 8, !dbg !3647
  %285 = icmp ugt i32* %284, getelementptr inbounds ([8192 x i32], [8192 x i32]* @stack, i64 0, i64 0), !dbg !3647
  br i1 %285, label %286, label %290, !dbg !3647

286:                                              ; preds = %283
  %287 = load i32*, i32** @sp, align 8, !dbg !3647
  %288 = getelementptr inbounds i32, i32* %287, i32 -1, !dbg !3647
  store i32* %288, i32** @sp, align 8, !dbg !3647
  %289 = load i32, i32* %288, align 4, !dbg !3647
  br label %293, !dbg !3647

290:                                              ; preds = %283
  %291 = load %struct._IO_FILE*, %struct._IO_FILE** %10, align 8, !dbg !3647
  %292 = call i32 @nextLWZ(%struct._IO_FILE* %291), !dbg !3647
  br label %293, !dbg !3647

293:                                              ; preds = %290, %286
  %294 = phi i32 [ %289, %286 ], [ %292, %290 ], !dbg !3647
  %295 = icmp sge i32 %294, 0, !dbg !3648
  br i1 %295, label %296, label %297, !dbg !3646

296:                                              ; preds = %293
  br label %283, !dbg !3649, !llvm.loop !3650

297:                                              ; preds = %293
  %298 = load i8*, i8** %23, align 8, !dbg !3651
  call void @free(i8* %298) #9, !dbg !3652
  call void @fix_current(), !dbg !3653
  store i32 -1, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 0), align 4, !dbg !3654
  store i32 -1, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 1), align 4, !dbg !3655
  store i32 -1, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 2), align 4, !dbg !3656
  store i32 0, i32* getelementptr inbounds (%struct.anon, %struct.anon* @Gif89, i32 0, i32 3), align 4, !dbg !3657
  store i32 0, i32* %9, align 4, !dbg !3658
  br label %299, !dbg !3658

299:                                              ; preds = %297, %260, %258, %29
  %300 = load i32, i32* %9, align 4, !dbg !3659
  ret i32 %300, !dbg !3659
}

; Function Attrs: noinline nounwind optnone
define internal void @initLWZ(i32 %0) #0 !dbg !3660 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !3663, metadata !DIExpression()), !dbg !3664
  %3 = load i32, i32* %2, align 4, !dbg !3665
  store i32 %3, i32* @set_code_size, align 4, !dbg !3666
  %4 = load i32, i32* @set_code_size, align 4, !dbg !3667
  %5 = add nsw i32 %4, 1, !dbg !3668
  store i32 %5, i32* @code_size, align 4, !dbg !3669
  %6 = load i32, i32* @set_code_size, align 4, !dbg !3670
  %7 = shl i32 1, %6, !dbg !3671
  store i32 %7, i32* @clear_code, align 4, !dbg !3672
  %8 = load i32, i32* @clear_code, align 4, !dbg !3673
  %9 = add nsw i32 %8, 1, !dbg !3674
  store i32 %9, i32* @end_code, align 4, !dbg !3675
  %10 = load i32, i32* @clear_code, align 4, !dbg !3676
  %11 = mul nsw i32 2, %10, !dbg !3677
  store i32 %11, i32* @max_code_size, align 4, !dbg !3678
  %12 = load i32, i32* @clear_code, align 4, !dbg !3679
  %13 = add nsw i32 %12, 2, !dbg !3680
  store i32 %13, i32* @max_code, align 4, !dbg !3681
  store i32 0, i32* @lastbit, align 4, !dbg !3682
  store i32 0, i32* @curbit, align 4, !dbg !3683
  store i32 2, i32* @last_byte, align 4, !dbg !3684
  store i32 0, i32* @get_done, align 4, !dbg !3685
  store i32 1, i32* @return_clear, align 4, !dbg !3686
  store i32* getelementptr inbounds ([8192 x i32], [8192 x i32]* @stack, i64 0, i64 0), i32** @sp, align 8, !dbg !3687
  ret void, !dbg !3688
}

; Function Attrs: noinline nounwind optnone
define internal i32 @nextLWZ(%struct._IO_FILE* %0) #0 !dbg !397 {
  %2 = alloca i32, align 4
  %3 = alloca %struct._IO_FILE*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca [260 x i8], align 1
  store %struct._IO_FILE* %0, %struct._IO_FILE** %3, align 8
  call void @llvm.dbg.declare(metadata %struct._IO_FILE** %3, metadata !3689, metadata !DIExpression()), !dbg !3690
  call void @llvm.dbg.declare(metadata i32* %4, metadata !3691, metadata !DIExpression()), !dbg !3692
  call void @llvm.dbg.declare(metadata i32* %5, metadata !3693, metadata !DIExpression()), !dbg !3694
  call void @llvm.dbg.declare(metadata i32* %6, metadata !3695, metadata !DIExpression()), !dbg !3696
  br label %9, !dbg !3697

9:                                                ; preds = %178, %1
  %10 = load %struct._IO_FILE*, %struct._IO_FILE** %3, align 8, !dbg !3698
  %11 = load i32, i32* @code_size, align 4, !dbg !3699
  %12 = call i32 @nextCode(%struct._IO_FILE* %10, i32 %11), !dbg !3700
  store i32 %12, i32* %4, align 4, !dbg !3701
  %13 = icmp sge i32 %12, 0, !dbg !3702
  br i1 %13, label %14, label %179, !dbg !3697

14:                                               ; preds = %9
  %15 = load i32, i32* %4, align 4, !dbg !3703
  %16 = load i32, i32* @clear_code, align 4, !dbg !3706
  %17 = icmp eq i32 %15, %16, !dbg !3707
  br i1 %17, label %18, label %69, !dbg !3708

18:                                               ; preds = %14
  %19 = load i32, i32* @clear_code, align 4, !dbg !3709
  %20 = icmp sge i32 %19, 4096, !dbg !3712
  br i1 %20, label %21, label %22, !dbg !3713

21:                                               ; preds = %18
  store i32 -2, i32* %2, align 4, !dbg !3714
  br label %181, !dbg !3714

22:                                               ; preds = %18
  store i32 0, i32* %6, align 4, !dbg !3716
  br label %23, !dbg !3718

23:                                               ; preds = %35, %22
  %24 = load i32, i32* %6, align 4, !dbg !3719
  %25 = load i32, i32* @clear_code, align 4, !dbg !3721
  %26 = icmp slt i32 %24, %25, !dbg !3722
  br i1 %26, label %27, label %38, !dbg !3723

27:                                               ; preds = %23
  %28 = load i32, i32* %6, align 4, !dbg !3724
  %29 = sext i32 %28 to i64, !dbg !3726
  %30 = getelementptr inbounds [4096 x i32], [4096 x i32]* getelementptr inbounds ([2 x [4096 x i32]], [2 x [4096 x i32]]* @nextLWZ.table, i64 0, i64 0), i64 0, i64 %29, !dbg !3726
  store i32 0, i32* %30, align 4, !dbg !3727
  %31 = load i32, i32* %6, align 4, !dbg !3728
  %32 = load i32, i32* %6, align 4, !dbg !3729
  %33 = sext i32 %32 to i64, !dbg !3730
  %34 = getelementptr inbounds [4096 x i32], [4096 x i32]* getelementptr inbounds ([2 x [4096 x i32]], [2 x [4096 x i32]]* @nextLWZ.table, i64 0, i64 1), i64 0, i64 %33, !dbg !3730
  store i32 %31, i32* %34, align 4, !dbg !3731
  br label %35, !dbg !3732

35:                                               ; preds = %27
  %36 = load i32, i32* %6, align 4, !dbg !3733
  %37 = add nsw i32 %36, 1, !dbg !3733
  store i32 %37, i32* %6, align 4, !dbg !3733
  br label %23, !dbg !3734, !llvm.loop !3735

38:                                               ; preds = %23
  br label %39, !dbg !3737

39:                                               ; preds = %49, %38
  %40 = load i32, i32* %6, align 4, !dbg !3738
  %41 = icmp slt i32 %40, 4096, !dbg !3741
  br i1 %41, label %42, label %52, !dbg !3742

42:                                               ; preds = %39
  %43 = load i32, i32* %6, align 4, !dbg !3743
  %44 = sext i32 %43 to i64, !dbg !3744
  %45 = getelementptr inbounds [4096 x i32], [4096 x i32]* getelementptr inbounds ([2 x [4096 x i32]], [2 x [4096 x i32]]* @nextLWZ.table, i64 0, i64 1), i64 0, i64 %44, !dbg !3744
  store i32 0, i32* %45, align 4, !dbg !3745
  %46 = load i32, i32* %6, align 4, !dbg !3746
  %47 = sext i32 %46 to i64, !dbg !3747
  %48 = getelementptr inbounds [4096 x i32], [4096 x i32]* getelementptr inbounds ([2 x [4096 x i32]], [2 x [4096 x i32]]* @nextLWZ.table, i64 0, i64 0), i64 0, i64 %47, !dbg !3747
  store i32 0, i32* %48, align 4, !dbg !3748
  br label %49, !dbg !3747

49:                                               ; preds = %42
  %50 = load i32, i32* %6, align 4, !dbg !3749
  %51 = add nsw i32 %50, 1, !dbg !3749
  store i32 %51, i32* %6, align 4, !dbg !3749
  br label %39, !dbg !3750, !llvm.loop !3751

52:                                               ; preds = %39
  %53 = load i32, i32* @set_code_size, align 4, !dbg !3753
  %54 = add nsw i32 %53, 1, !dbg !3754
  store i32 %54, i32* @code_size, align 4, !dbg !3755
  %55 = load i32, i32* @clear_code, align 4, !dbg !3756
  %56 = mul nsw i32 2, %55, !dbg !3757
  store i32 %56, i32* @max_code_size, align 4, !dbg !3758
  %57 = load i32, i32* @clear_code, align 4, !dbg !3759
  %58 = add nsw i32 %57, 2, !dbg !3760
  store i32 %58, i32* @max_code, align 4, !dbg !3761
  store i32* getelementptr inbounds ([8192 x i32], [8192 x i32]* @stack, i64 0, i64 0), i32** @sp, align 8, !dbg !3762
  br label %59, !dbg !3763

59:                                               ; preds = %63, %52
  %60 = load %struct._IO_FILE*, %struct._IO_FILE** %3, align 8, !dbg !3764
  %61 = load i32, i32* @code_size, align 4, !dbg !3766
  %62 = call i32 @nextCode(%struct._IO_FILE* %60, i32 %61), !dbg !3767
  store i32 %62, i32* @nextLWZ.oldcode, align 4, !dbg !3768
  store i32 %62, i32* @nextLWZ.firstcode, align 4, !dbg !3769
  br label %63, !dbg !3770

63:                                               ; preds = %59
  %64 = load i32, i32* @nextLWZ.firstcode, align 4, !dbg !3771
  %65 = load i32, i32* @clear_code, align 4, !dbg !3772
  %66 = icmp eq i32 %64, %65, !dbg !3773
  br i1 %66, label %59, label %67, !dbg !3770, !llvm.loop !3774

67:                                               ; preds = %63
  %68 = load i32, i32* @nextLWZ.firstcode, align 4, !dbg !3776
  store i32 %68, i32* %2, align 4, !dbg !3777
  br label %181, !dbg !3777

69:                                               ; preds = %14
  %70 = load i32, i32* %4, align 4, !dbg !3778
  %71 = load i32, i32* @end_code, align 4, !dbg !3780
  %72 = icmp eq i32 %70, %71, !dbg !3781
  br i1 %72, label %73, label %91, !dbg !3782

73:                                               ; preds = %69
  call void @llvm.dbg.declare(metadata i32* %7, metadata !3783, metadata !DIExpression()), !dbg !3785
  call void @llvm.dbg.declare(metadata [260 x i8]* %8, metadata !3786, metadata !DIExpression()), !dbg !3790
  %74 = load i32, i32* @ZeroDataBlock, align 4, !dbg !3791
  %75 = icmp ne i32 %74, 0, !dbg !3791
  br i1 %75, label %76, label %77, !dbg !3793

76:                                               ; preds = %73
  store i32 -2, i32* %2, align 4, !dbg !3794
  br label %181, !dbg !3794

77:                                               ; preds = %73
  br label %78, !dbg !3795

78:                                               ; preds = %83, %77
  %79 = load %struct._IO_FILE*, %struct._IO_FILE** %3, align 8, !dbg !3796
  %80 = getelementptr inbounds [260 x i8], [260 x i8]* %8, i64 0, i64 0, !dbg !3797
  %81 = call i32 @GetDataBlock(%struct._IO_FILE* %79, i8* %80), !dbg !3798
  store i32 %81, i32* %7, align 4, !dbg !3799
  %82 = icmp sgt i32 %81, 0, !dbg !3800
  br i1 %82, label %83, label %84, !dbg !3795

83:                                               ; preds = %78
  br label %78, !dbg !3795, !llvm.loop !3801

84:                                               ; preds = %78
  %85 = load i32, i32* %7, align 4, !dbg !3803
  %86 = icmp ne i32 %85, 0, !dbg !3805
  br i1 %86, label %87, label %90, !dbg !3806

87:                                               ; preds = %84
  %88 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !3807
  %89 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %88, i8* getelementptr inbounds ([57 x i8], [57 x i8]* @.str.35.75, i64 0, i64 0)), !dbg !3809
  br label %90, !dbg !3810

90:                                               ; preds = %87, %84
  store i32 -2, i32* %2, align 4, !dbg !3811
  br label %181, !dbg !3811

91:                                               ; preds = %69
  %92 = load i32, i32* %4, align 4, !dbg !3812
  store i32 %92, i32* %5, align 4, !dbg !3813
  %93 = load i32, i32* %4, align 4, !dbg !3814
  %94 = load i32, i32* @max_code, align 4, !dbg !3816
  %95 = icmp sge i32 %93, %94, !dbg !3817
  br i1 %95, label %96, label %101, !dbg !3818

96:                                               ; preds = %91
  %97 = load i32, i32* @nextLWZ.firstcode, align 4, !dbg !3819
  %98 = load i32*, i32** @sp, align 8, !dbg !3821
  %99 = getelementptr inbounds i32, i32* %98, i32 1, !dbg !3821
  store i32* %99, i32** @sp, align 8, !dbg !3821
  store i32 %97, i32* %98, align 4, !dbg !3822
  %100 = load i32, i32* @nextLWZ.oldcode, align 4, !dbg !3823
  store i32 %100, i32* %4, align 4, !dbg !3824
  br label %101, !dbg !3825

101:                                              ; preds = %96, %91
  br label %102, !dbg !3826

102:                                              ; preds = %133, %101
  %103 = load i32, i32* %4, align 4, !dbg !3827
  %104 = load i32, i32* @clear_code, align 4, !dbg !3828
  %105 = icmp sge i32 %103, %104, !dbg !3829
  br i1 %105, label %106, label %138, !dbg !3826

106:                                              ; preds = %102
  %107 = load i32, i32* %4, align 4, !dbg !3830
  %108 = sext i32 %107 to i64, !dbg !3832
  %109 = getelementptr inbounds [4096 x i32], [4096 x i32]* getelementptr inbounds ([2 x [4096 x i32]], [2 x [4096 x i32]]* @nextLWZ.table, i64 0, i64 1), i64 0, i64 %108, !dbg !3832
  %110 = load i32, i32* %109, align 4, !dbg !3832
  %111 = load i32*, i32** @sp, align 8, !dbg !3833
  %112 = getelementptr inbounds i32, i32* %111, i32 1, !dbg !3833
  store i32* %112, i32** @sp, align 8, !dbg !3833
  store i32 %110, i32* %111, align 4, !dbg !3834
  %113 = load i32, i32* %4, align 4, !dbg !3835
  %114 = load i32, i32* %4, align 4, !dbg !3837
  %115 = sext i32 %114 to i64, !dbg !3838
  %116 = getelementptr inbounds [4096 x i32], [4096 x i32]* getelementptr inbounds ([2 x [4096 x i32]], [2 x [4096 x i32]]* @nextLWZ.table, i64 0, i64 0), i64 0, i64 %115, !dbg !3838
  %117 = load i32, i32* %116, align 4, !dbg !3838
  %118 = icmp eq i32 %113, %117, !dbg !3839
  br i1 %118, label %119, label %123, !dbg !3840

119:                                              ; preds = %106
  %120 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !3841
  %121 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %120, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.36.76, i64 0, i64 0)), !dbg !3843
  %122 = load i32, i32* %4, align 4, !dbg !3844
  store i32 %122, i32* %2, align 4, !dbg !3845
  br label %181, !dbg !3845

123:                                              ; preds = %106
  %124 = load i32*, i32** @sp, align 8, !dbg !3846
  %125 = bitcast i32* %124 to i8*, !dbg !3848
  %126 = ptrtoint i8* %125 to i64, !dbg !3849
  %127 = sub i64 %126, ptrtoint ([8192 x i32]* @stack to i64), !dbg !3849
  %128 = icmp uge i64 %127, 32768, !dbg !3850
  br i1 %128, label %129, label %133, !dbg !3851

129:                                              ; preds = %123
  %130 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !3852
  %131 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %130, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.37.77, i64 0, i64 0)), !dbg !3854
  %132 = load i32, i32* %4, align 4, !dbg !3855
  store i32 %132, i32* %2, align 4, !dbg !3856
  br label %181, !dbg !3856

133:                                              ; preds = %123
  %134 = load i32, i32* %4, align 4, !dbg !3857
  %135 = sext i32 %134 to i64, !dbg !3858
  %136 = getelementptr inbounds [4096 x i32], [4096 x i32]* getelementptr inbounds ([2 x [4096 x i32]], [2 x [4096 x i32]]* @nextLWZ.table, i64 0, i64 0), i64 0, i64 %135, !dbg !3858
  %137 = load i32, i32* %136, align 4, !dbg !3858
  store i32 %137, i32* %4, align 4, !dbg !3859
  br label %102, !dbg !3826, !llvm.loop !3860

138:                                              ; preds = %102
  %139 = load i32, i32* %4, align 4, !dbg !3862
  %140 = sext i32 %139 to i64, !dbg !3863
  %141 = getelementptr inbounds [4096 x i32], [4096 x i32]* getelementptr inbounds ([2 x [4096 x i32]], [2 x [4096 x i32]]* @nextLWZ.table, i64 0, i64 1), i64 0, i64 %140, !dbg !3863
  %142 = load i32, i32* %141, align 4, !dbg !3863
  store i32 %142, i32* @nextLWZ.firstcode, align 4, !dbg !3864
  %143 = load i32*, i32** @sp, align 8, !dbg !3865
  %144 = getelementptr inbounds i32, i32* %143, i32 1, !dbg !3865
  store i32* %144, i32** @sp, align 8, !dbg !3865
  store i32 %142, i32* %143, align 4, !dbg !3866
  %145 = load i32, i32* @max_code, align 4, !dbg !3867
  store i32 %145, i32* %4, align 4, !dbg !3869
  %146 = icmp slt i32 %145, 4096, !dbg !3870
  br i1 %146, label %147, label %170, !dbg !3871

147:                                              ; preds = %138
  %148 = load i32, i32* @nextLWZ.oldcode, align 4, !dbg !3872
  %149 = load i32, i32* %4, align 4, !dbg !3874
  %150 = sext i32 %149 to i64, !dbg !3875
  %151 = getelementptr inbounds [4096 x i32], [4096 x i32]* getelementptr inbounds ([2 x [4096 x i32]], [2 x [4096 x i32]]* @nextLWZ.table, i64 0, i64 0), i64 0, i64 %150, !dbg !3875
  store i32 %148, i32* %151, align 4, !dbg !3876
  %152 = load i32, i32* @nextLWZ.firstcode, align 4, !dbg !3877
  %153 = load i32, i32* %4, align 4, !dbg !3878
  %154 = sext i32 %153 to i64, !dbg !3879
  %155 = getelementptr inbounds [4096 x i32], [4096 x i32]* getelementptr inbounds ([2 x [4096 x i32]], [2 x [4096 x i32]]* @nextLWZ.table, i64 0, i64 1), i64 0, i64 %154, !dbg !3879
  store i32 %152, i32* %155, align 4, !dbg !3880
  %156 = load i32, i32* @max_code, align 4, !dbg !3881
  %157 = add nsw i32 %156, 1, !dbg !3881
  store i32 %157, i32* @max_code, align 4, !dbg !3881
  %158 = load i32, i32* @max_code, align 4, !dbg !3882
  %159 = load i32, i32* @max_code_size, align 4, !dbg !3884
  %160 = icmp sge i32 %158, %159, !dbg !3885
  br i1 %160, label %161, label %169, !dbg !3886

161:                                              ; preds = %147
  %162 = load i32, i32* @max_code_size, align 4, !dbg !3887
  %163 = icmp slt i32 %162, 4096, !dbg !3888
  br i1 %163, label %164, label %169, !dbg !3889

164:                                              ; preds = %161
  %165 = load i32, i32* @max_code_size, align 4, !dbg !3890
  %166 = mul nsw i32 %165, 2, !dbg !3890
  store i32 %166, i32* @max_code_size, align 4, !dbg !3890
  %167 = load i32, i32* @code_size, align 4, !dbg !3892
  %168 = add nsw i32 %167, 1, !dbg !3892
  store i32 %168, i32* @code_size, align 4, !dbg !3892
  br label %169, !dbg !3893

169:                                              ; preds = %164, %161, %147
  br label %170, !dbg !3894

170:                                              ; preds = %169, %138
  %171 = load i32, i32* %5, align 4, !dbg !3895
  store i32 %171, i32* @nextLWZ.oldcode, align 4, !dbg !3896
  %172 = load i32*, i32** @sp, align 8, !dbg !3897
  %173 = icmp ugt i32* %172, getelementptr inbounds ([8192 x i32], [8192 x i32]* @stack, i64 0, i64 0), !dbg !3899
  br i1 %173, label %174, label %178, !dbg !3900

174:                                              ; preds = %170
  %175 = load i32*, i32** @sp, align 8, !dbg !3901
  %176 = getelementptr inbounds i32, i32* %175, i32 -1, !dbg !3901
  store i32* %176, i32** @sp, align 8, !dbg !3901
  %177 = load i32, i32* %176, align 4, !dbg !3902
  store i32 %177, i32* %2, align 4, !dbg !3903
  br label %181, !dbg !3903

178:                                              ; preds = %170
  br label %9, !dbg !3697, !llvm.loop !3904

179:                                              ; preds = %9
  %180 = load i32, i32* %4, align 4, !dbg !3906
  store i32 %180, i32* %2, align 4, !dbg !3907
  br label %181, !dbg !3907

181:                                              ; preds = %179, %174, %129, %119, %90, %76, %67, %21
  %182 = load i32, i32* %2, align 4, !dbg !3908
  ret i32 %182, !dbg !3908
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: noinline nounwind optnone
define internal i8* @get_prev_line(i32 %0, i32 %1, i32 %2) #0 !dbg !3909 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i8*, align 8
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !3912, metadata !DIExpression()), !dbg !3913
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !3914, metadata !DIExpression()), !dbg !3915
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !3916, metadata !DIExpression()), !dbg !3917
  call void @llvm.dbg.declare(metadata i32* %7, metadata !3918, metadata !DIExpression()), !dbg !3919
  call void @llvm.dbg.declare(metadata i8** %8, metadata !3920, metadata !DIExpression()), !dbg !3921
  %9 = load i32, i32* %5, align 4, !dbg !3922
  %10 = load i32, i32* %6, align 4, !dbg !3923
  %11 = call i32 @inv_interlace_line(i32 %9, i32 %10), !dbg !3924
  %12 = sub nsw i32 %11, 1, !dbg !3925
  store i32 %12, i32* %7, align 4, !dbg !3926
  br label %13, !dbg !3927

13:                                               ; preds = %19, %3
  %14 = load i32, i32* %5, align 4, !dbg !3928
  %15 = load i32, i32* %7, align 4, !dbg !3929
  %16 = call i32 @interlace_line(i32 %14, i32 %15), !dbg !3930
  %17 = load i32, i32* %6, align 4, !dbg !3931
  %18 = icmp sge i32 %16, %17, !dbg !3932
  br i1 %18, label %19, label %22, !dbg !3927

19:                                               ; preds = %13
  %20 = load i32, i32* %7, align 4, !dbg !3933
  %21 = add nsw i32 %20, -1, !dbg !3933
  store i32 %21, i32* %7, align 4, !dbg !3933
  br label %13, !dbg !3927, !llvm.loop !3934

22:                                               ; preds = %13
  %23 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !3935
  %24 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %23, i32 0, i32 2, !dbg !3936
  %25 = load i8*, i8** %24, align 8, !dbg !3936
  %26 = load i32, i32* %4, align 4, !dbg !3937
  %27 = load i32, i32* %5, align 4, !dbg !3938
  %28 = load i32, i32* %7, align 4, !dbg !3939
  %29 = call i32 @interlace_line(i32 %27, i32 %28), !dbg !3940
  %30 = mul nsw i32 %26, %29, !dbg !3941
  %31 = sext i32 %30 to i64, !dbg !3942
  %32 = getelementptr inbounds i8, i8* %25, i64 %31, !dbg !3942
  store i8* %32, i8** %8, align 8, !dbg !3943
  %33 = load i8*, i8** %8, align 8, !dbg !3944
  ret i8* %33, !dbg !3945
}

; Function Attrs: noinline nounwind optnone
define internal i32 @nextCode(%struct._IO_FILE* %0, i32 %1) #0 !dbg !408 {
  %3 = alloca i32, align 4
  %4 = alloca %struct._IO_FILE*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i64, align 8
  %10 = alloca i32, align 4
  store %struct._IO_FILE* %0, %struct._IO_FILE** %4, align 8
  call void @llvm.dbg.declare(metadata %struct._IO_FILE** %4, metadata !3946, metadata !DIExpression()), !dbg !3947
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !3948, metadata !DIExpression()), !dbg !3949
  call void @llvm.dbg.declare(metadata i32* %6, metadata !3950, metadata !DIExpression()), !dbg !3951
  call void @llvm.dbg.declare(metadata i32* %7, metadata !3952, metadata !DIExpression()), !dbg !3953
  call void @llvm.dbg.declare(metadata i32* %8, metadata !3954, metadata !DIExpression()), !dbg !3955
  call void @llvm.dbg.declare(metadata i64* %9, metadata !3956, metadata !DIExpression()), !dbg !3957
  %11 = load i32, i32* @return_clear, align 4, !dbg !3958
  %12 = icmp ne i32 %11, 0, !dbg !3958
  br i1 %12, label %13, label %15, !dbg !3960

13:                                               ; preds = %2
  store i32 0, i32* @return_clear, align 4, !dbg !3961
  %14 = load i32, i32* @clear_code, align 4, !dbg !3963
  store i32 %14, i32* %3, align 4, !dbg !3964
  br label %141, !dbg !3964

15:                                               ; preds = %2
  %16 = load i32, i32* @curbit, align 4, !dbg !3965
  %17 = load i32, i32* %5, align 4, !dbg !3966
  %18 = add nsw i32 %16, %17, !dbg !3967
  store i32 %18, i32* %8, align 4, !dbg !3968
  %19 = load i32, i32* %8, align 4, !dbg !3969
  %20 = load i32, i32* @lastbit, align 4, !dbg !3971
  %21 = icmp sge i32 %19, %20, !dbg !3972
  br i1 %21, label %22, label %68, !dbg !3973

22:                                               ; preds = %15
  call void @llvm.dbg.declare(metadata i32* %10, metadata !3974, metadata !DIExpression()), !dbg !3976
  %23 = load i32, i32* @get_done, align 4, !dbg !3977
  %24 = icmp ne i32 %23, 0, !dbg !3977
  br i1 %24, label %25, label %36, !dbg !3979

25:                                               ; preds = %22
  %26 = load i32, i32* @verbose, align 4, !dbg !3980
  %27 = icmp ne i32 %26, 0, !dbg !3980
  br i1 %27, label %28, label %35, !dbg !3983

28:                                               ; preds = %25
  %29 = load i32, i32* @curbit, align 4, !dbg !3984
  %30 = load i32, i32* @lastbit, align 4, !dbg !3985
  %31 = icmp sge i32 %29, %30, !dbg !3986
  br i1 %31, label %32, label %35, !dbg !3987

32:                                               ; preds = %28
  %33 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !3988
  %34 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.38.80, i64 0, i64 0)), !dbg !3990
  br label %35, !dbg !3991

35:                                               ; preds = %32, %28, %25
  store i32 -1, i32* %3, align 4, !dbg !3992
  br label %141, !dbg !3992

36:                                               ; preds = %22
  %37 = load i32, i32* @last_byte, align 4, !dbg !3993
  %38 = sub nsw i32 %37, 2, !dbg !3994
  %39 = sext i32 %38 to i64, !dbg !3995
  %40 = getelementptr inbounds [280 x i8], [280 x i8]* @nextCode.buf, i64 0, i64 %39, !dbg !3995
  %41 = load i8, i8* %40, align 1, !dbg !3995
  store i8 %41, i8* getelementptr inbounds ([280 x i8], [280 x i8]* @nextCode.buf, i64 0, i64 0), align 1, !dbg !3996
  %42 = load i32, i32* @last_byte, align 4, !dbg !3997
  %43 = sub nsw i32 %42, 1, !dbg !3998
  %44 = sext i32 %43 to i64, !dbg !3999
  %45 = getelementptr inbounds [280 x i8], [280 x i8]* @nextCode.buf, i64 0, i64 %44, !dbg !3999
  %46 = load i8, i8* %45, align 1, !dbg !3999
  store i8 %46, i8* getelementptr inbounds ([280 x i8], [280 x i8]* @nextCode.buf, i64 0, i64 1), align 1, !dbg !4000
  %47 = load %struct._IO_FILE*, %struct._IO_FILE** %4, align 8, !dbg !4001
  %48 = call i32 @GetDataBlock(%struct._IO_FILE* %47, i8* getelementptr inbounds ([280 x i8], [280 x i8]* @nextCode.buf, i64 0, i64 2)), !dbg !4003
  store i32 %48, i32* %10, align 4, !dbg !4004
  %49 = icmp eq i32 %48, 0, !dbg !4005
  br i1 %49, label %50, label %51, !dbg !4006

50:                                               ; preds = %36
  store i32 1, i32* @get_done, align 4, !dbg !4007
  br label %51, !dbg !4008

51:                                               ; preds = %50, %36
  %52 = load i32, i32* %10, align 4, !dbg !4009
  %53 = icmp slt i32 %52, 0, !dbg !4011
  br i1 %53, label %54, label %55, !dbg !4012

54:                                               ; preds = %51
  store i32 -1, i32* %3, align 4, !dbg !4013
  br label %141, !dbg !4013

55:                                               ; preds = %51
  %56 = load i32, i32* %10, align 4, !dbg !4014
  %57 = add nsw i32 2, %56, !dbg !4015
  store i32 %57, i32* @last_byte, align 4, !dbg !4016
  %58 = load i32, i32* @curbit, align 4, !dbg !4017
  %59 = load i32, i32* @lastbit, align 4, !dbg !4018
  %60 = sub nsw i32 %58, %59, !dbg !4019
  %61 = add nsw i32 %60, 16, !dbg !4020
  store i32 %61, i32* @curbit, align 4, !dbg !4021
  %62 = load i32, i32* %10, align 4, !dbg !4022
  %63 = add nsw i32 2, %62, !dbg !4023
  %64 = mul nsw i32 %63, 8, !dbg !4024
  store i32 %64, i32* @lastbit, align 4, !dbg !4025
  %65 = load i32, i32* @curbit, align 4, !dbg !4026
  %66 = load i32, i32* %5, align 4, !dbg !4027
  %67 = add nsw i32 %65, %66, !dbg !4028
  store i32 %67, i32* %8, align 4, !dbg !4029
  br label %68, !dbg !4030

68:                                               ; preds = %55, %15
  %69 = load i32, i32* %8, align 4, !dbg !4031
  %70 = sdiv i32 %69, 8, !dbg !4032
  store i32 %70, i32* %7, align 4, !dbg !4033
  %71 = load i32, i32* @curbit, align 4, !dbg !4034
  %72 = sdiv i32 %71, 8, !dbg !4035
  store i32 %72, i32* %6, align 4, !dbg !4036
  %73 = load i32, i32* %6, align 4, !dbg !4037
  %74 = load i32, i32* %7, align 4, !dbg !4039
  %75 = icmp eq i32 %73, %74, !dbg !4040
  br i1 %75, label %76, label %82, !dbg !4041

76:                                               ; preds = %68
  %77 = load i32, i32* %6, align 4, !dbg !4042
  %78 = sext i32 %77 to i64, !dbg !4043
  %79 = getelementptr inbounds [280 x i8], [280 x i8]* @nextCode.buf, i64 0, i64 %78, !dbg !4043
  %80 = load i8, i8* %79, align 1, !dbg !4043
  %81 = zext i8 %80 to i64, !dbg !4044
  store i64 %81, i64* %9, align 8, !dbg !4045
  br label %124, !dbg !4046

82:                                               ; preds = %68
  %83 = load i32, i32* %6, align 4, !dbg !4047
  %84 = add nsw i32 %83, 1, !dbg !4049
  %85 = load i32, i32* %7, align 4, !dbg !4050
  %86 = icmp eq i32 %84, %85, !dbg !4051
  br i1 %86, label %87, label %101, !dbg !4052

87:                                               ; preds = %82
  %88 = load i32, i32* %6, align 4, !dbg !4053
  %89 = sext i32 %88 to i64, !dbg !4054
  %90 = getelementptr inbounds [280 x i8], [280 x i8]* @nextCode.buf, i64 0, i64 %89, !dbg !4054
  %91 = load i8, i8* %90, align 1, !dbg !4054
  %92 = zext i8 %91 to i64, !dbg !4055
  %93 = load i32, i32* %6, align 4, !dbg !4056
  %94 = add nsw i32 %93, 1, !dbg !4057
  %95 = sext i32 %94 to i64, !dbg !4058
  %96 = getelementptr inbounds [280 x i8], [280 x i8]* @nextCode.buf, i64 0, i64 %95, !dbg !4058
  %97 = load i8, i8* %96, align 1, !dbg !4058
  %98 = zext i8 %97 to i64, !dbg !4059
  %99 = shl i64 %98, 8, !dbg !4060
  %100 = or i64 %92, %99, !dbg !4061
  store i64 %100, i64* %9, align 8, !dbg !4062
  br label %123, !dbg !4063

101:                                              ; preds = %82
  %102 = load i32, i32* %6, align 4, !dbg !4064
  %103 = sext i32 %102 to i64, !dbg !4065
  %104 = getelementptr inbounds [280 x i8], [280 x i8]* @nextCode.buf, i64 0, i64 %103, !dbg !4065
  %105 = load i8, i8* %104, align 1, !dbg !4065
  %106 = zext i8 %105 to i64, !dbg !4066
  %107 = load i32, i32* %6, align 4, !dbg !4067
  %108 = add nsw i32 %107, 1, !dbg !4068
  %109 = sext i32 %108 to i64, !dbg !4069
  %110 = getelementptr inbounds [280 x i8], [280 x i8]* @nextCode.buf, i64 0, i64 %109, !dbg !4069
  %111 = load i8, i8* %110, align 1, !dbg !4069
  %112 = zext i8 %111 to i64, !dbg !4070
  %113 = shl i64 %112, 8, !dbg !4071
  %114 = or i64 %106, %113, !dbg !4072
  %115 = load i32, i32* %6, align 4, !dbg !4073
  %116 = add nsw i32 %115, 2, !dbg !4074
  %117 = sext i32 %116 to i64, !dbg !4075
  %118 = getelementptr inbounds [280 x i8], [280 x i8]* @nextCode.buf, i64 0, i64 %117, !dbg !4075
  %119 = load i8, i8* %118, align 1, !dbg !4075
  %120 = zext i8 %119 to i64, !dbg !4076
  %121 = shl i64 %120, 16, !dbg !4077
  %122 = or i64 %114, %121, !dbg !4078
  store i64 %122, i64* %9, align 8, !dbg !4079
  br label %123

123:                                              ; preds = %101, %87
  br label %124

124:                                              ; preds = %123, %76
  %125 = load i64, i64* %9, align 8, !dbg !4080
  %126 = load i32, i32* @curbit, align 4, !dbg !4081
  %127 = srem i32 %126, 8, !dbg !4082
  %128 = zext i32 %127 to i64, !dbg !4083
  %129 = ashr i64 %125, %128, !dbg !4083
  %130 = load i32, i32* %5, align 4, !dbg !4084
  %131 = sext i32 %130 to i64, !dbg !4085
  %132 = getelementptr inbounds [16 x i32], [16 x i32]* @nextCode.maskTbl, i64 0, i64 %131, !dbg !4085
  %133 = load i32, i32* %132, align 4, !dbg !4085
  %134 = sext i32 %133 to i64, !dbg !4085
  %135 = and i64 %129, %134, !dbg !4086
  store i64 %135, i64* %9, align 8, !dbg !4087
  %136 = load i32, i32* %5, align 4, !dbg !4088
  %137 = load i32, i32* @curbit, align 4, !dbg !4089
  %138 = add nsw i32 %137, %136, !dbg !4089
  store i32 %138, i32* @curbit, align 4, !dbg !4089
  %139 = load i64, i64* %9, align 8, !dbg !4090
  %140 = trunc i64 %139 to i32, !dbg !4091
  store i32 %140, i32* %3, align 4, !dbg !4092
  br label %141, !dbg !4092

141:                                              ; preds = %124, %54, %35, %13
  %142 = load i32, i32* %3, align 4, !dbg !4093
  ret i32 %142, !dbg !4093
}

; Function Attrs: noinline nounwind optnone
define internal i32 @GetDataBlock(%struct._IO_FILE* %0, i8* %1) #0 !dbg !4094 {
  %3 = alloca i32, align 4
  %4 = alloca %struct._IO_FILE*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i8, align 1
  store %struct._IO_FILE* %0, %struct._IO_FILE** %4, align 8
  call void @llvm.dbg.declare(metadata %struct._IO_FILE** %4, metadata !4097, metadata !DIExpression()), !dbg !4098
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !4099, metadata !DIExpression()), !dbg !4100
  call void @llvm.dbg.declare(metadata i8* %6, metadata !4101, metadata !DIExpression()), !dbg !4102
  store i8 0, i8* %6, align 1, !dbg !4103
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** %4, align 8, !dbg !4104
  %8 = call i64 @fread(i8* %6, i64 1, i64 1, %struct._IO_FILE* %7), !dbg !4104
  %9 = icmp ne i64 %8, 0, !dbg !4104
  br i1 %9, label %13, label %10, !dbg !4106

10:                                               ; preds = %2
  %11 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !4107
  %12 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.30.78, i64 0, i64 0)), !dbg !4109
  store i32 -1, i32* %3, align 4, !dbg !4110
  br label %34, !dbg !4110

13:                                               ; preds = %2
  %14 = load i8, i8* %6, align 1, !dbg !4111
  %15 = zext i8 %14 to i32, !dbg !4111
  %16 = icmp eq i32 %15, 0, !dbg !4112
  %17 = zext i1 %16 to i32, !dbg !4112
  store i32 %17, i32* @ZeroDataBlock, align 4, !dbg !4113
  %18 = load i8, i8* %6, align 1, !dbg !4114
  %19 = zext i8 %18 to i32, !dbg !4114
  %20 = icmp ne i32 %19, 0, !dbg !4116
  br i1 %20, label %21, label %31, !dbg !4117

21:                                               ; preds = %13
  %22 = load i8*, i8** %5, align 8, !dbg !4118
  %23 = load i8, i8* %6, align 1, !dbg !4118
  %24 = zext i8 %23 to i64, !dbg !4118
  %25 = load %struct._IO_FILE*, %struct._IO_FILE** %4, align 8, !dbg !4118
  %26 = call i64 @fread(i8* %22, i64 %24, i64 1, %struct._IO_FILE* %25), !dbg !4118
  %27 = icmp ne i64 %26, 0, !dbg !4118
  br i1 %27, label %31, label %28, !dbg !4119

28:                                               ; preds = %21
  %29 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !4120
  %30 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %29, i8* getelementptr inbounds ([37 x i8], [37 x i8]* @.str.31.79, i64 0, i64 0)), !dbg !4122
  store i32 -1, i32* %3, align 4, !dbg !4123
  br label %34, !dbg !4123

31:                                               ; preds = %21, %13
  %32 = load i8, i8* %6, align 1, !dbg !4124
  %33 = zext i8 %32 to i32, !dbg !4125
  store i32 %33, i32* %3, align 4, !dbg !4126
  br label %34, !dbg !4126

34:                                               ; preds = %31, %28, %10
  %35 = load i32, i32* %3, align 4, !dbg !4127
  ret i32 %35, !dbg !4127
}

; Function Attrs: noinline nounwind optnone
define dso_local i8* @xalloc(i64 %0) #0 !dbg !4128 {
  %2 = alloca i64, align 8
  %3 = alloca i8*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !4131, metadata !DIExpression()), !dbg !4132
  call void @llvm.dbg.declare(metadata i8** %3, metadata !4133, metadata !DIExpression()), !dbg !4134
  %4 = load i64, i64* %2, align 8, !dbg !4135
  %5 = call noalias i8* @malloc(i64 %4) #9, !dbg !4136
  store i8* %5, i8** %3, align 8, !dbg !4134
  %6 = load i8*, i8** %3, align 8, !dbg !4137
  %7 = icmp eq i8* %6, null, !dbg !4139
  br i1 %7, label %8, label %13, !dbg !4140

8:                                                ; preds = %1
  %9 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !4141
  %10 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %9, i8* getelementptr inbounds ([37 x i8], [37 x i8]* @.str.91, i64 0, i64 0)), !dbg !4143
  %11 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !4144
  %12 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.1.92, i64 0, i64 0)), !dbg !4145
  call void @exit(i32 1) #11, !dbg !4146
  unreachable, !dbg !4146

13:                                               ; preds = %1
  %14 = load i8*, i8** %3, align 8, !dbg !4147
  ret i8* %14, !dbg !4148
}

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #6

; Function Attrs: noinline nounwind optnone
define dso_local i8* @xrealloc(i8* %0, i64 %1) #0 !dbg !4149 {
  %3 = alloca i8*, align 8
  %4 = alloca i64, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !4152, metadata !DIExpression()), !dbg !4153
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !4154, metadata !DIExpression()), !dbg !4155
  %5 = load i8*, i8** %3, align 8, !dbg !4156
  %6 = load i64, i64* %4, align 8, !dbg !4157
  %7 = call i8* @realloc(i8* %5, i64 %6) #9, !dbg !4158
  store i8* %7, i8** %3, align 8, !dbg !4159
  %8 = load i8*, i8** %3, align 8, !dbg !4160
  %9 = icmp eq i8* %8, null, !dbg !4162
  br i1 %9, label %10, label %15, !dbg !4163

10:                                               ; preds = %2
  %11 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !4164
  %12 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([37 x i8], [37 x i8]* @.str.91, i64 0, i64 0)), !dbg !4166
  %13 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !4167
  %14 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.1.92, i64 0, i64 0)), !dbg !4168
  call void @exit(i32 1) #11, !dbg !4169
  unreachable, !dbg !4169

15:                                               ; preds = %2
  %16 = load i8*, i8** %3, align 8, !dbg !4170
  ret i8* %16, !dbg !4171
}

; Function Attrs: nounwind
declare dso_local i8* @realloc(i8*, i64) #6

; Function Attrs: noinline nounwind optnone
define dso_local void @allocate_element() #0 !dbg !4172 {
  %1 = alloca %struct.GIFelement*, align 8
  call void @llvm.dbg.declare(metadata %struct.GIFelement** %1, metadata !4175, metadata !DIExpression()), !dbg !4204
  %2 = call i8* @xalloc(i64 48), !dbg !4205
  %3 = bitcast i8* %2 to %struct.GIFelement*, !dbg !4205
  store %struct.GIFelement* %3, %struct.GIFelement** %1, align 8, !dbg !4204
  %4 = load %struct.GIFelement*, %struct.GIFelement** %1, align 8, !dbg !4206
  %5 = bitcast %struct.GIFelement* %4 to i8*, !dbg !4207
  call void @llvm.memset.p0i8.i64(i8* align 8 %5, i8 0, i64 48, i1 false), !dbg !4207
  %6 = load %struct.GIFelement*, %struct.GIFelement** %1, align 8, !dbg !4208
  %7 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %6, i32 0, i32 0, !dbg !4209
  store %struct.GIFelement* null, %struct.GIFelement** %7, align 8, !dbg !4210
  %8 = load %struct.GIFelement*, %struct.GIFelement** %1, align 8, !dbg !4211
  %9 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4212
  %10 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %9, i32 0, i32 0, !dbg !4213
  store %struct.GIFelement* %8, %struct.GIFelement** %10, align 8, !dbg !4214
  %11 = load %struct.GIFelement*, %struct.GIFelement** %1, align 8, !dbg !4215
  store %struct.GIFelement* %11, %struct.GIFelement** @current, align 8, !dbg !4216
  ret void, !dbg !4217
}

; Function Attrs: noinline nounwind optnone
define dso_local void @set_size(i64 %0) #0 !dbg !4218 {
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !4221, metadata !DIExpression()), !dbg !4222
  call void @llvm.dbg.declare(metadata i64* %3, metadata !4223, metadata !DIExpression()), !dbg !4224
  %4 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4225
  %5 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %4, i32 0, i32 3, !dbg !4227
  %6 = load i64, i64* %5, align 8, !dbg !4227
  %7 = icmp eq i64 %6, 0, !dbg !4228
  br i1 %7, label %8, label %21, !dbg !4229

8:                                                ; preds = %1
  %9 = load i64, i64* %2, align 8, !dbg !4230
  store i64 %9, i64* %3, align 8, !dbg !4232
  %10 = load i64, i64* %3, align 8, !dbg !4233
  %11 = icmp slt i64 %10, 8192, !dbg !4235
  br i1 %11, label %12, label %13, !dbg !4236

12:                                               ; preds = %8
  store i64 8192, i64* %3, align 8, !dbg !4237
  br label %13, !dbg !4238

13:                                               ; preds = %12, %8
  %14 = load i64, i64* %3, align 8, !dbg !4239
  %15 = call i8* @xalloc(i64 %14), !dbg !4240
  %16 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4241
  %17 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %16, i32 0, i32 2, !dbg !4242
  store i8* %15, i8** %17, align 8, !dbg !4243
  %18 = load i64, i64* %3, align 8, !dbg !4244
  %19 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4245
  %20 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %19, i32 0, i32 3, !dbg !4246
  store i64 %18, i64* %20, align 8, !dbg !4247
  br label %54, !dbg !4248

21:                                               ; preds = %1
  %22 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4249
  %23 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %22, i32 0, i32 3, !dbg !4251
  %24 = load i64, i64* %23, align 8, !dbg !4251
  %25 = load i64, i64* %2, align 8, !dbg !4252
  %26 = icmp slt i64 %24, %25, !dbg !4253
  br i1 %26, label %27, label %53, !dbg !4254

27:                                               ; preds = %21
  %28 = load i64, i64* %2, align 8, !dbg !4255
  %29 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4257
  %30 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %29, i32 0, i32 3, !dbg !4258
  %31 = load i64, i64* %30, align 8, !dbg !4258
  %32 = sub nsw i64 %28, %31, !dbg !4259
  store i64 %32, i64* %3, align 8, !dbg !4260
  %33 = load i64, i64* %3, align 8, !dbg !4261
  %34 = icmp slt i64 %33, 8192, !dbg !4263
  br i1 %34, label %35, label %36, !dbg !4264

35:                                               ; preds = %27
  store i64 8192, i64* %3, align 8, !dbg !4265
  br label %36, !dbg !4266

36:                                               ; preds = %35, %27
  %37 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4267
  %38 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %37, i32 0, i32 2, !dbg !4268
  %39 = load i8*, i8** %38, align 8, !dbg !4268
  %40 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4269
  %41 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %40, i32 0, i32 3, !dbg !4270
  %42 = load i64, i64* %41, align 8, !dbg !4270
  %43 = load i64, i64* %3, align 8, !dbg !4271
  %44 = add nsw i64 %42, %43, !dbg !4272
  %45 = call i8* @xrealloc(i8* %39, i64 %44), !dbg !4273
  %46 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4274
  %47 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %46, i32 0, i32 2, !dbg !4275
  store i8* %45, i8** %47, align 8, !dbg !4276
  %48 = load i64, i64* %3, align 8, !dbg !4277
  %49 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4278
  %50 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %49, i32 0, i32 3, !dbg !4279
  %51 = load i64, i64* %50, align 8, !dbg !4280
  %52 = add nsw i64 %51, %48, !dbg !4280
  store i64 %52, i64* %50, align 8, !dbg !4280
  br label %53, !dbg !4281

53:                                               ; preds = %36, %21
  br label %54

54:                                               ; preds = %53, %13
  ret void, !dbg !4282
}

; Function Attrs: noinline nounwind optnone
define dso_local void @store_block(i8* %0, i32 %1) #0 !dbg !4283 {
  %3 = alloca i8*, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !4286, metadata !DIExpression()), !dbg !4287
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !4288, metadata !DIExpression()), !dbg !4289
  %5 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4290
  %6 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %5, i32 0, i32 4, !dbg !4291
  %7 = load i64, i64* %6, align 8, !dbg !4291
  %8 = load i32, i32* %4, align 4, !dbg !4292
  %9 = sext i32 %8 to i64, !dbg !4292
  %10 = add nsw i64 %7, %9, !dbg !4293
  call void @set_size(i64 %10), !dbg !4294
  %11 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4295
  %12 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %11, i32 0, i32 2, !dbg !4296
  %13 = load i8*, i8** %12, align 8, !dbg !4296
  %14 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4297
  %15 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %14, i32 0, i32 4, !dbg !4298
  %16 = load i64, i64* %15, align 8, !dbg !4298
  %17 = getelementptr inbounds i8, i8* %13, i64 %16, !dbg !4299
  %18 = load i8*, i8** %3, align 8, !dbg !4300
  %19 = load i32, i32* %4, align 4, !dbg !4301
  %20 = sext i32 %19 to i64, !dbg !4301
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %17, i8* align 1 %18, i64 %20, i1 false), !dbg !4302
  %21 = load i32, i32* %4, align 4, !dbg !4303
  %22 = sext i32 %21 to i64, !dbg !4303
  %23 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4304
  %24 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %23, i32 0, i32 4, !dbg !4305
  %25 = load i64, i64* %24, align 8, !dbg !4306
  %26 = add nsw i64 %25, %22, !dbg !4306
  store i64 %26, i64* %24, align 8, !dbg !4306
  ret void, !dbg !4307
}

; Function Attrs: noinline nounwind optnone
define dso_local void @allocate_image() #0 !dbg !4308 {
  call void @allocate_element(), !dbg !4309
  %1 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4310
  %2 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1, i32 0, i32 1, !dbg !4311
  store i8 44, i8* %2, align 8, !dbg !4312
  %3 = call i8* @xalloc(i64 2840), !dbg !4313
  %4 = bitcast i8* %3 to %struct.GIFimagestruct*, !dbg !4313
  %5 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4314
  %6 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %5, i32 0, i32 5, !dbg !4315
  store %struct.GIFimagestruct* %4, %struct.GIFimagestruct** %6, align 8, !dbg !4316
  %7 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4317
  %8 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %7, i32 0, i32 5, !dbg !4318
  %9 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %8, align 8, !dbg !4318
  %10 = bitcast %struct.GIFimagestruct* %9 to i8*, !dbg !4319
  call void @llvm.memset.p0i8.i64(i8* align 8 %10, i8 0, i64 2840, i1 false), !dbg !4319
  ret void, !dbg !4320
}

; Function Attrs: noinline nounwind optnone
define dso_local void @fix_current() #0 !dbg !4321 {
  %1 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4322
  %2 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %1, i32 0, i32 3, !dbg !4324
  %3 = load i64, i64* %2, align 8, !dbg !4324
  %4 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4325
  %5 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %4, i32 0, i32 4, !dbg !4326
  %6 = load i64, i64* %5, align 8, !dbg !4326
  %7 = icmp ne i64 %3, %6, !dbg !4327
  br i1 %7, label %8, label %23, !dbg !4328

8:                                                ; preds = %0
  %9 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4329
  %10 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %9, i32 0, i32 2, !dbg !4331
  %11 = load i8*, i8** %10, align 8, !dbg !4331
  %12 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4332
  %13 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %12, i32 0, i32 4, !dbg !4333
  %14 = load i64, i64* %13, align 8, !dbg !4333
  %15 = call i8* @xrealloc(i8* %11, i64 %14), !dbg !4334
  %16 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4335
  %17 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %16, i32 0, i32 2, !dbg !4336
  store i8* %15, i8** %17, align 8, !dbg !4337
  %18 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4338
  %19 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %18, i32 0, i32 4, !dbg !4339
  %20 = load i64, i64* %19, align 8, !dbg !4339
  %21 = load %struct.GIFelement*, %struct.GIFelement** @current, align 8, !dbg !4340
  %22 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %21, i32 0, i32 3, !dbg !4341
  store i64 %20, i64* %22, align 8, !dbg !4342
  br label %23, !dbg !4343

23:                                               ; preds = %8, %0
  ret void, !dbg !4344
}

; Function Attrs: noinline nounwind optnone
define dso_local void @free_mem() #0 !dbg !4345 {
  %1 = alloca %struct.GIFelement*, align 8
  %2 = alloca %struct.GIFelement*, align 8
  call void @llvm.dbg.declare(metadata %struct.GIFelement** %1, metadata !4346, metadata !DIExpression()), !dbg !4347
  call void @llvm.dbg.declare(metadata %struct.GIFelement** %2, metadata !4348, metadata !DIExpression()), !dbg !4349
  %3 = load %struct.GIFelement*, %struct.GIFelement** getelementptr inbounds (%struct.GIFelement, %struct.GIFelement* @first, i32 0, i32 0), align 8, !dbg !4350
  store %struct.GIFelement* %3, %struct.GIFelement** %1, align 8, !dbg !4351
  store %struct.GIFelement* null, %struct.GIFelement** getelementptr inbounds (%struct.GIFelement, %struct.GIFelement* @first, i32 0, i32 0), align 8, !dbg !4352
  br label %4, !dbg !4353

4:                                                ; preds = %30, %0
  %5 = load %struct.GIFelement*, %struct.GIFelement** %1, align 8, !dbg !4354
  %6 = icmp ne %struct.GIFelement* %5, null, !dbg !4353
  br i1 %6, label %7, label %33, !dbg !4353

7:                                                ; preds = %4
  %8 = load %struct.GIFelement*, %struct.GIFelement** %1, align 8, !dbg !4355
  store %struct.GIFelement* %8, %struct.GIFelement** %2, align 8, !dbg !4357
  %9 = load %struct.GIFelement*, %struct.GIFelement** %1, align 8, !dbg !4358
  %10 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %9, i32 0, i32 0, !dbg !4359
  %11 = load %struct.GIFelement*, %struct.GIFelement** %10, align 8, !dbg !4359
  store %struct.GIFelement* %11, %struct.GIFelement** %1, align 8, !dbg !4360
  %12 = load %struct.GIFelement*, %struct.GIFelement** %2, align 8, !dbg !4361
  %13 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %12, i32 0, i32 2, !dbg !4363
  %14 = load i8*, i8** %13, align 8, !dbg !4363
  %15 = icmp ne i8* %14, null, !dbg !4361
  br i1 %15, label %16, label %20, !dbg !4364

16:                                               ; preds = %7
  %17 = load %struct.GIFelement*, %struct.GIFelement** %2, align 8, !dbg !4365
  %18 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %17, i32 0, i32 2, !dbg !4366
  %19 = load i8*, i8** %18, align 8, !dbg !4366
  call void @free(i8* %19) #9, !dbg !4367
  br label %20, !dbg !4367

20:                                               ; preds = %16, %7
  %21 = load %struct.GIFelement*, %struct.GIFelement** %2, align 8, !dbg !4368
  %22 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %21, i32 0, i32 5, !dbg !4370
  %23 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %22, align 8, !dbg !4370
  %24 = icmp ne %struct.GIFimagestruct* %23, null, !dbg !4368
  br i1 %24, label %25, label %30, !dbg !4371

25:                                               ; preds = %20
  %26 = load %struct.GIFelement*, %struct.GIFelement** %2, align 8, !dbg !4372
  %27 = getelementptr inbounds %struct.GIFelement, %struct.GIFelement* %26, i32 0, i32 5, !dbg !4373
  %28 = load %struct.GIFimagestruct*, %struct.GIFimagestruct** %27, align 8, !dbg !4373
  %29 = bitcast %struct.GIFimagestruct* %28 to i8*, !dbg !4372
  call void @free(i8* %29) #9, !dbg !4374
  br label %30, !dbg !4374

30:                                               ; preds = %25, %20
  %31 = load %struct.GIFelement*, %struct.GIFelement** %2, align 8, !dbg !4375
  %32 = bitcast %struct.GIFelement* %31 to i8*, !dbg !4375
  call void @free(i8* %32) #9, !dbg !4376
  br label %4, !dbg !4353, !llvm.loop !4377

33:                                               ; preds = %4
  ret void, !dbg !4379
}

attributes #0 = { noinline nounwind optnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+neon" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nounwind willreturn }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+neon" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+neon" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind returns_twice "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+neon" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+neon" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="non-leaf" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+neon" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { nounwind returns_twice }
attributes #9 = { nounwind }
attributes #10 = { nounwind readonly }
attributes #11 = { noreturn nounwind }

!llvm.dbg.cu = !{!2, !12, !263, !431, !419}
!llvm.ident = !{!434, !434, !434, !434, !434}
!llvm.module.flags = !{!435, !436, !437}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "c_437_l1", scope: !2, file: !3, line: 26, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "437_l1.c", directory: "/gif2png/gif2png")
!4 = !{}
!5 = !{!0}
!6 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 8192, elements: !8)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !{!9}
!9 = !DISubrange(count: 256)
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "first", scope: !12, file: !13, line: 26, type: !236, isLocal: false, isDefinition: true)
!12 = distinct !DICompileUnit(language: DW_LANG_C99, file: !13, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !14, globals: !204, splitDebugInlining: false, nameTableKind: None)
!13 = !DIFile(filename: "gif2png.c", directory: "/gif2png/gif2png")
!14 = !{!15, !16, !46, !183, !75, !200, !7, !202, !74, !203}
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_infopp", file: !17, line: 820, baseType: !18)
!17 = !DIFile(filename: "/usr/local/include/png.h", directory: "")
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_info", file: !17, line: 816, baseType: !21)
!21 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "png_info_struct", file: !17, line: 555, size: 2944, elements: !22)
!22 = !{!23, !27, !28, !29, !34, !45, !48, !49, !50, !51, !52, !53, !54, !55, !56, !57, !61, !63, !64, !65, !66, !82, !92, !101, !104, !113, !114, !116, !117, !118, !119, !120, !121, !124, !125, !126, !127, !128, !129, !130, !131, !132, !133, !134, !135, !136, !139, !140, !141, !142, !155, !156, !157, !158, !159, !160, !180, !181, !182, !184, !185, !186, !187, !190, !192, !193, !194, !195, !196, !197, !198, !199}
!23 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !21, file: !17, line: 558, baseType: !24, size: 32)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_uint_32", file: !25, line: 1122, baseType: !26)
!25 = !DIFile(filename: "/usr/local/include/pngconf.h", directory: "")
!26 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "height", scope: !21, file: !17, line: 559, baseType: !24, size: 32, offset: 32)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "valid", scope: !21, file: !17, line: 560, baseType: !24, size: 32, offset: 64)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "rowbytes", scope: !21, file: !17, line: 562, baseType: !30, size: 64, offset: 128)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_size_t", file: !25, line: 1135, baseType: !31)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !32, line: 46, baseType: !33)
!32 = !DIFile(filename: "/usr/lib/llvm-10/lib/clang/10.0.0/include/stddef.h", directory: "")
!33 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "palette", scope: !21, file: !17, line: 564, baseType: !35, size: 64, offset: 192)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_colorp", file: !17, line: 380, baseType: !36)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_color", file: !17, line: 379, baseType: !38)
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "png_color_struct", file: !17, line: 374, size: 24, elements: !39)
!39 = !{!40, !43, !44}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "red", scope: !38, file: !17, line: 376, baseType: !41, size: 8)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_byte", file: !25, line: 1130, baseType: !42)
!42 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "green", scope: !38, file: !17, line: 377, baseType: !41, size: 8, offset: 8)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "blue", scope: !38, file: !17, line: 378, baseType: !41, size: 8, offset: 16)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "num_palette", scope: !21, file: !17, line: 566, baseType: !46, size: 16, offset: 256)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_uint_16", file: !25, line: 1128, baseType: !47)
!47 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "num_trans", scope: !21, file: !17, line: 568, baseType: !46, size: 16, offset: 272)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "bit_depth", scope: !21, file: !17, line: 570, baseType: !41, size: 8, offset: 288)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "color_type", scope: !21, file: !17, line: 572, baseType: !41, size: 8, offset: 296)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "compression_type", scope: !21, file: !17, line: 575, baseType: !41, size: 8, offset: 304)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "filter_type", scope: !21, file: !17, line: 577, baseType: !41, size: 8, offset: 312)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "interlace_type", scope: !21, file: !17, line: 579, baseType: !41, size: 8, offset: 320)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "channels", scope: !21, file: !17, line: 583, baseType: !41, size: 8, offset: 328)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "pixel_depth", scope: !21, file: !17, line: 585, baseType: !41, size: 8, offset: 336)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "spare_byte", scope: !21, file: !17, line: 586, baseType: !41, size: 8, offset: 344)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "signature", scope: !21, file: !17, line: 588, baseType: !58, size: 64, offset: 352)
!58 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 64, elements: !59)
!59 = !{!60}
!60 = !DISubrange(count: 8)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "gamma", scope: !21, file: !17, line: 602, baseType: !62, size: 32, offset: 416)
!62 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "srgb_intent", scope: !21, file: !17, line: 609, baseType: !41, size: 8, offset: 448)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "num_text", scope: !21, file: !17, line: 622, baseType: !7, size: 32, offset: 480)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "max_text", scope: !21, file: !17, line: 623, baseType: !7, size: 32, offset: 512)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "text", scope: !21, file: !17, line: 624, baseType: !67, size: 64, offset: 576)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_textp", file: !17, line: 463, baseType: !68)
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_text", file: !17, line: 462, baseType: !70)
!70 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "png_text_struct", file: !17, line: 444, size: 448, elements: !71)
!71 = !{!72, !73, !77, !78, !79, !80, !81}
!72 = !DIDerivedType(tag: DW_TAG_member, name: "compression", scope: !70, file: !17, line: 446, baseType: !7, size: 32)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !70, file: !17, line: 451, baseType: !74, size: 64, offset: 64)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_charp", file: !25, line: 1211, baseType: !75)
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "text", scope: !70, file: !17, line: 452, baseType: !74, size: 64, offset: 128)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "text_length", scope: !70, file: !17, line: 454, baseType: !30, size: 64, offset: 192)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "itxt_length", scope: !70, file: !17, line: 456, baseType: !30, size: 64, offset: 256)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "lang", scope: !70, file: !17, line: 457, baseType: !74, size: 64, offset: 320)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "lang_key", scope: !70, file: !17, line: 459, baseType: !74, size: 64, offset: 384)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "mod_time", scope: !21, file: !17, line: 631, baseType: !83, size: 64, offset: 640)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_time", file: !17, line: 491, baseType: !84)
!84 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "png_time_struct", file: !17, line: 483, size: 64, elements: !85)
!85 = !{!86, !87, !88, !89, !90, !91}
!86 = !DIDerivedType(tag: DW_TAG_member, name: "year", scope: !84, file: !17, line: 485, baseType: !46, size: 16)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "month", scope: !84, file: !17, line: 486, baseType: !41, size: 8, offset: 16)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "day", scope: !84, file: !17, line: 487, baseType: !41, size: 8, offset: 24)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "hour", scope: !84, file: !17, line: 488, baseType: !41, size: 8, offset: 32)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "minute", scope: !84, file: !17, line: 489, baseType: !41, size: 8, offset: 40)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "second", scope: !84, file: !17, line: 490, baseType: !41, size: 8, offset: 48)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "sig_bit", scope: !21, file: !17, line: 641, baseType: !93, size: 40, offset: 704)
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_color_8", file: !17, line: 401, baseType: !94)
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "png_color_8_struct", file: !17, line: 394, size: 40, elements: !95)
!95 = !{!96, !97, !98, !99, !100}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "red", scope: !94, file: !17, line: 396, baseType: !41, size: 8)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "green", scope: !94, file: !17, line: 397, baseType: !41, size: 8, offset: 8)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "blue", scope: !94, file: !17, line: 398, baseType: !41, size: 8, offset: 16)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "gray", scope: !94, file: !17, line: 399, baseType: !41, size: 8, offset: 24)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "alpha", scope: !94, file: !17, line: 400, baseType: !41, size: 8, offset: 32)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "trans_alpha", scope: !21, file: !17, line: 655, baseType: !102, size: 64, offset: 768)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_bytep", file: !25, line: 1205, baseType: !103)
!103 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "trans_color", scope: !21, file: !17, line: 657, baseType: !105, size: 80, offset: 832)
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_color_16", file: !17, line: 390, baseType: !106)
!106 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "png_color_16_struct", file: !17, line: 383, size: 80, elements: !107)
!107 = !{!108, !109, !110, !111, !112}
!108 = !DIDerivedType(tag: DW_TAG_member, name: "index", scope: !106, file: !17, line: 385, baseType: !41, size: 8)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "red", scope: !106, file: !17, line: 386, baseType: !46, size: 16, offset: 16)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "green", scope: !106, file: !17, line: 387, baseType: !46, size: 16, offset: 32)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "blue", scope: !106, file: !17, line: 388, baseType: !46, size: 16, offset: 48)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "gray", scope: !106, file: !17, line: 389, baseType: !46, size: 16, offset: 64)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "background", scope: !21, file: !17, line: 668, baseType: !105, size: 80, offset: 912)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "x_offset", scope: !21, file: !17, line: 677, baseType: !115, size: 32, offset: 992)
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_int_32", file: !25, line: 1123, baseType: !7)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "y_offset", scope: !21, file: !17, line: 678, baseType: !115, size: 32, offset: 1024)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "offset_unit_type", scope: !21, file: !17, line: 679, baseType: !41, size: 8, offset: 1056)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "x_pixels_per_unit", scope: !21, file: !17, line: 687, baseType: !24, size: 32, offset: 1088)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "y_pixels_per_unit", scope: !21, file: !17, line: 688, baseType: !24, size: 32, offset: 1120)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "phys_unit_type", scope: !21, file: !17, line: 689, baseType: !41, size: 8, offset: 1152)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "hist", scope: !21, file: !17, line: 700, baseType: !122, size: 64, offset: 1216)
!122 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_uint_16p", file: !25, line: 1208, baseType: !123)
!123 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "x_white", scope: !21, file: !17, line: 711, baseType: !62, size: 32, offset: 1280)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "y_white", scope: !21, file: !17, line: 712, baseType: !62, size: 32, offset: 1312)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "x_red", scope: !21, file: !17, line: 713, baseType: !62, size: 32, offset: 1344)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "y_red", scope: !21, file: !17, line: 714, baseType: !62, size: 32, offset: 1376)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "x_green", scope: !21, file: !17, line: 715, baseType: !62, size: 32, offset: 1408)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "y_green", scope: !21, file: !17, line: 716, baseType: !62, size: 32, offset: 1440)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "x_blue", scope: !21, file: !17, line: 717, baseType: !62, size: 32, offset: 1472)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "y_blue", scope: !21, file: !17, line: 718, baseType: !62, size: 32, offset: 1504)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "pcal_purpose", scope: !21, file: !17, line: 734, baseType: !74, size: 64, offset: 1536)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "pcal_X0", scope: !21, file: !17, line: 735, baseType: !115, size: 32, offset: 1600)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "pcal_X1", scope: !21, file: !17, line: 736, baseType: !115, size: 32, offset: 1632)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "pcal_units", scope: !21, file: !17, line: 737, baseType: !74, size: 64, offset: 1664)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "pcal_params", scope: !21, file: !17, line: 739, baseType: !137, size: 64, offset: 1728)
!137 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_charpp", file: !25, line: 1229, baseType: !138)
!138 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !75, size: 64)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "pcal_type", scope: !21, file: !17, line: 741, baseType: !41, size: 8, offset: 1792)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "pcal_nparams", scope: !21, file: !17, line: 743, baseType: !41, size: 8, offset: 1800)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "free_me", scope: !21, file: !17, line: 748, baseType: !24, size: 32, offset: 1824)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "unknown_chunks", scope: !21, file: !17, line: 754, baseType: !143, size: 64, offset: 1856)
!143 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_unknown_chunkp", file: !17, line: 512, baseType: !144)
!144 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !145, size: 64)
!145 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_unknown_chunk", file: !17, line: 511, baseType: !146)
!146 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "png_unknown_chunk_t", file: !17, line: 502, size: 256, elements: !147)
!147 = !{!148, !152, !153, !154}
!148 = !DIDerivedType(tag: DW_TAG_member, name: "name", scope: !146, file: !17, line: 504, baseType: !149, size: 40)
!149 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 40, elements: !150)
!150 = !{!151}
!151 = !DISubrange(count: 5)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !146, file: !17, line: 505, baseType: !103, size: 64, offset: 64)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !146, file: !17, line: 506, baseType: !30, size: 64, offset: 128)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "location", scope: !146, file: !17, line: 509, baseType: !41, size: 8, offset: 192)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "unknown_chunks_num", scope: !21, file: !17, line: 755, baseType: !30, size: 64, offset: 1920)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "iccp_name", scope: !21, file: !17, line: 760, baseType: !74, size: 64, offset: 1984)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "iccp_profile", scope: !21, file: !17, line: 761, baseType: !74, size: 64, offset: 2048)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "iccp_proflen", scope: !21, file: !17, line: 764, baseType: !24, size: 32, offset: 2112)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "iccp_compression", scope: !21, file: !17, line: 765, baseType: !41, size: 8, offset: 2144)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "splt_palettes", scope: !21, file: !17, line: 770, baseType: !161, size: 64, offset: 2176)
!161 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_sPLT_tp", file: !17, line: 432, baseType: !162)
!162 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !163, size: 64)
!163 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_sPLT_t", file: !17, line: 431, baseType: !164)
!164 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "png_sPLT_struct", file: !17, line: 425, size: 256, elements: !165)
!165 = !{!166, !167, !168, !179}
!166 = !DIDerivedType(tag: DW_TAG_member, name: "name", scope: !164, file: !17, line: 427, baseType: !74, size: 64)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "depth", scope: !164, file: !17, line: 428, baseType: !41, size: 8, offset: 64)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "entries", scope: !164, file: !17, line: 429, baseType: !169, size: 64, offset: 128)
!169 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_sPLT_entryp", file: !17, line: 417, baseType: !170)
!170 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !171, size: 64)
!171 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_sPLT_entry", file: !17, line: 416, baseType: !172)
!172 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "png_sPLT_entry_struct", file: !17, line: 409, size: 80, elements: !173)
!173 = !{!174, !175, !176, !177, !178}
!174 = !DIDerivedType(tag: DW_TAG_member, name: "red", scope: !172, file: !17, line: 411, baseType: !46, size: 16)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "green", scope: !172, file: !17, line: 412, baseType: !46, size: 16, offset: 16)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "blue", scope: !172, file: !17, line: 413, baseType: !46, size: 16, offset: 32)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "alpha", scope: !172, file: !17, line: 414, baseType: !46, size: 16, offset: 48)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "frequency", scope: !172, file: !17, line: 415, baseType: !46, size: 16, offset: 64)
!179 = !DIDerivedType(tag: DW_TAG_member, name: "nentries", scope: !164, file: !17, line: 430, baseType: !115, size: 32, offset: 192)
!180 = !DIDerivedType(tag: DW_TAG_member, name: "splt_palettes_num", scope: !21, file: !17, line: 771, baseType: !24, size: 32, offset: 2240)
!181 = !DIDerivedType(tag: DW_TAG_member, name: "scal_unit", scope: !21, file: !17, line: 782, baseType: !41, size: 8, offset: 2272)
!182 = !DIDerivedType(tag: DW_TAG_member, name: "scal_pixel_width", scope: !21, file: !17, line: 784, baseType: !183, size: 64, offset: 2304)
!183 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "scal_pixel_height", scope: !21, file: !17, line: 785, baseType: !183, size: 64, offset: 2368)
!185 = !DIDerivedType(tag: DW_TAG_member, name: "scal_s_width", scope: !21, file: !17, line: 788, baseType: !74, size: 64, offset: 2432)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "scal_s_height", scope: !21, file: !17, line: 789, baseType: !74, size: 64, offset: 2496)
!187 = !DIDerivedType(tag: DW_TAG_member, name: "row_pointers", scope: !21, file: !17, line: 797, baseType: !188, size: 64, offset: 2560)
!188 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_bytepp", file: !25, line: 1223, baseType: !189)
!189 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!190 = !DIDerivedType(tag: DW_TAG_member, name: "int_gamma", scope: !21, file: !17, line: 801, baseType: !191, size: 32, offset: 2624)
!191 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_fixed_point", file: !25, line: 1201, baseType: !115)
!192 = !DIDerivedType(tag: DW_TAG_member, name: "int_x_white", scope: !21, file: !17, line: 806, baseType: !191, size: 32, offset: 2656)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "int_y_white", scope: !21, file: !17, line: 807, baseType: !191, size: 32, offset: 2688)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "int_x_red", scope: !21, file: !17, line: 808, baseType: !191, size: 32, offset: 2720)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "int_y_red", scope: !21, file: !17, line: 809, baseType: !191, size: 32, offset: 2752)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "int_x_green", scope: !21, file: !17, line: 810, baseType: !191, size: 32, offset: 2784)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "int_y_green", scope: !21, file: !17, line: 811, baseType: !191, size: 32, offset: 2816)
!198 = !DIDerivedType(tag: DW_TAG_member, name: "int_x_blue", scope: !21, file: !17, line: 812, baseType: !191, size: 32, offset: 2848)
!199 = !DIDerivedType(tag: DW_TAG_member, name: "int_y_blue", scope: !21, file: !17, line: 813, baseType: !191, size: 32, offset: 2880)
!200 = !DIDerivedType(tag: DW_TAG_typedef, name: "byte", file: !201, line: 17, baseType: !42)
!201 = !DIFile(filename: "./gif2png.h", directory: "/gif2png/gif2png")
!202 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!203 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!204 = !{!10, !205, !207, !209, !211, !213, !215, !217, !219, !221, !223, !225, !227, !229, !231, !233, !259}
!205 = !DIGlobalVariableExpression(var: !206, expr: !DIExpression())
!206 = distinct !DIGlobalVariable(name: "delete", scope: !12, file: !13, line: 28, type: !7, isLocal: false, isDefinition: true)
!207 = !DIGlobalVariableExpression(var: !208, expr: !DIExpression())
!208 = distinct !DIGlobalVariable(name: "optimize", scope: !12, file: !13, line: 29, type: !7, isLocal: false, isDefinition: true)
!209 = !DIGlobalVariableExpression(var: !210, expr: !DIExpression())
!210 = distinct !DIGlobalVariable(name: "histogram", scope: !12, file: !13, line: 30, type: !7, isLocal: false, isDefinition: true)
!211 = !DIGlobalVariableExpression(var: !212, expr: !DIExpression())
!212 = distinct !DIGlobalVariable(name: "interlaced", scope: !12, file: !13, line: 31, type: !7, isLocal: false, isDefinition: true)
!213 = !DIGlobalVariableExpression(var: !214, expr: !DIExpression())
!214 = distinct !DIGlobalVariable(name: "progress", scope: !12, file: !13, line: 32, type: !7, isLocal: false, isDefinition: true)
!215 = !DIGlobalVariableExpression(var: !216, expr: !DIExpression())
!216 = distinct !DIGlobalVariable(name: "verbose", scope: !12, file: !13, line: 33, type: !7, isLocal: false, isDefinition: true)
!217 = !DIGlobalVariableExpression(var: !218, expr: !DIExpression())
!218 = distinct !DIGlobalVariable(name: "recover", scope: !12, file: !13, line: 34, type: !7, isLocal: false, isDefinition: true)
!219 = !DIGlobalVariableExpression(var: !220, expr: !DIExpression())
!220 = distinct !DIGlobalVariable(name: "webconvert", scope: !12, file: !13, line: 35, type: !7, isLocal: false, isDefinition: true)
!221 = !DIGlobalVariableExpression(var: !222, expr: !DIExpression())
!222 = distinct !DIGlobalVariable(name: "software_chunk", scope: !12, file: !13, line: 36, type: !7, isLocal: false, isDefinition: true)
!223 = !DIGlobalVariableExpression(var: !224, expr: !DIExpression())
!224 = distinct !DIGlobalVariable(name: "filtermode", scope: !12, file: !13, line: 37, type: !7, isLocal: false, isDefinition: true)
!225 = !DIGlobalVariableExpression(var: !226, expr: !DIExpression())
!226 = distinct !DIGlobalVariable(name: "matte", scope: !12, file: !13, line: 38, type: !7, isLocal: false, isDefinition: true)
!227 = !DIGlobalVariableExpression(var: !228, expr: !DIExpression())
!228 = distinct !DIGlobalVariable(name: "gamma_srgb", scope: !12, file: !13, line: 39, type: !7, isLocal: false, isDefinition: true)
!229 = !DIGlobalVariableExpression(var: !230, expr: !DIExpression())
!230 = distinct !DIGlobalVariable(name: "numgifs", scope: !12, file: !13, line: 41, type: !202, isLocal: false, isDefinition: true)
!231 = !DIGlobalVariableExpression(var: !232, expr: !DIExpression())
!232 = distinct !DIGlobalVariable(name: "numpngs", scope: !12, file: !13, line: 42, type: !202, isLocal: false, isDefinition: true)
!233 = !DIGlobalVariableExpression(var: !234, expr: !DIExpression())
!234 = distinct !DIGlobalVariable(name: "current", scope: !12, file: !13, line: 27, type: !235, isLocal: false, isDefinition: true)
!235 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !236, size: 64)
!236 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "GIFelement", file: !201, line: 32, size: 384, elements: !237)
!237 = !{!238, !239, !240, !242, !243, !244}
!238 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !236, file: !201, line: 33, baseType: !235, size: 64)
!239 = !DIDerivedType(tag: DW_TAG_member, name: "GIFtype", scope: !236, file: !201, line: 34, baseType: !76, size: 8, offset: 64)
!240 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !236, file: !201, line: 35, baseType: !241, size: 64, offset: 128)
!241 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !200, size: 64)
!242 = !DIDerivedType(tag: DW_TAG_member, name: "allocated_size", scope: !236, file: !201, line: 36, baseType: !202, size: 64, offset: 192)
!243 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !236, file: !201, line: 37, baseType: !202, size: 64, offset: 256)
!244 = !DIDerivedType(tag: DW_TAG_member, name: "imagestruct", scope: !236, file: !201, line: 39, baseType: !245, size: 64, offset: 320)
!245 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !246, size: 64)
!246 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "GIFimagestruct", file: !201, line: 21, size: 22720, elements: !247)
!247 = !{!248, !251, !253, !254, !255, !256, !257, !258}
!248 = !DIDerivedType(tag: DW_TAG_member, name: "colors", scope: !246, file: !201, line: 22, baseType: !249, size: 6144)
!249 = !DICompositeType(tag: DW_TAG_array_type, baseType: !250, size: 6144, elements: !8)
!250 = !DIDerivedType(tag: DW_TAG_typedef, name: "GifColor", file: !201, line: 19, baseType: !37)
!251 = !DIDerivedType(tag: DW_TAG_member, name: "color_count", scope: !246, file: !201, line: 23, baseType: !252, size: 16384, offset: 6144)
!252 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 16384, elements: !8)
!253 = !DIDerivedType(tag: DW_TAG_member, name: "offset_x", scope: !246, file: !201, line: 24, baseType: !7, size: 32, offset: 22528)
!254 = !DIDerivedType(tag: DW_TAG_member, name: "offset_y", scope: !246, file: !201, line: 25, baseType: !7, size: 32, offset: 22560)
!255 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !246, file: !201, line: 26, baseType: !7, size: 32, offset: 22592)
!256 = !DIDerivedType(tag: DW_TAG_member, name: "height", scope: !246, file: !201, line: 27, baseType: !7, size: 32, offset: 22624)
!257 = !DIDerivedType(tag: DW_TAG_member, name: "trans", scope: !246, file: !201, line: 28, baseType: !7, size: 32, offset: 22656)
!258 = !DIDerivedType(tag: DW_TAG_member, name: "interlace", scope: !246, file: !201, line: 29, baseType: !7, size: 32, offset: 22688)
!259 = !DIGlobalVariableExpression(var: !260, expr: !DIExpression())
!260 = distinct !DIGlobalVariable(name: "matte_color", scope: !12, file: !13, line: 40, type: !250, isLocal: false, isDefinition: true)
!261 = !DIGlobalVariableExpression(var: !262, expr: !DIExpression())
!262 = distinct !DIGlobalVariable(name: "imagecount", scope: !263, file: !264, line: 43, type: !7, isLocal: false, isDefinition: true)
!263 = distinct !DICompileUnit(language: DW_LANG_C99, file: !264, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !265, globals: !266, splitDebugInlining: false, nameTableKind: None)
!264 = !DIFile(filename: "gifread.c", directory: "/gif2png/gif2png")
!265 = !{!75, !7, !203, !42, !202}
!266 = !{!267, !327, !347, !261, !355, !357, !363, !365, !367, !369, !371, !373, !375, !377, !379, !381, !383, !385, !387, !390, !395, !402, !404, !406, !412}
!267 = !DIGlobalVariableExpression(var: !268, expr: !DIExpression())
!268 = distinct !DIGlobalVariable(name: "colors", scope: !269, file: !264, line: 134, type: !326, isLocal: true, isDefinition: true)
!269 = distinct !DISubprogram(name: "ReadGIF", scope: !264, file: !264, line: 68, type: !270, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !263, retainedNodes: !4)
!270 = !DISubroutineType(types: !271)
!271 = !{!7, !272}
!272 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !273, size: 64)
!273 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !274, line: 7, baseType: !275)
!274 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/bits/types/FILE.h", directory: "")
!275 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !276, line: 49, size: 1728, elements: !277)
!276 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/bits/types/struct_FILE.h", directory: "")
!277 = !{!278, !279, !280, !281, !282, !283, !284, !285, !286, !287, !288, !289, !290, !293, !295, !296, !297, !300, !301, !303, !307, !310, !312, !315, !318, !319, !320, !321, !322}
!278 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !275, file: !276, line: 51, baseType: !7, size: 32)
!279 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_ptr", scope: !275, file: !276, line: 54, baseType: !75, size: 64, offset: 64)
!280 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_end", scope: !275, file: !276, line: 55, baseType: !75, size: 64, offset: 128)
!281 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_base", scope: !275, file: !276, line: 56, baseType: !75, size: 64, offset: 192)
!282 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_base", scope: !275, file: !276, line: 57, baseType: !75, size: 64, offset: 256)
!283 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_ptr", scope: !275, file: !276, line: 58, baseType: !75, size: 64, offset: 320)
!284 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_end", scope: !275, file: !276, line: 59, baseType: !75, size: 64, offset: 384)
!285 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_base", scope: !275, file: !276, line: 60, baseType: !75, size: 64, offset: 448)
!286 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_end", scope: !275, file: !276, line: 61, baseType: !75, size: 64, offset: 512)
!287 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_base", scope: !275, file: !276, line: 64, baseType: !75, size: 64, offset: 576)
!288 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_backup_base", scope: !275, file: !276, line: 65, baseType: !75, size: 64, offset: 640)
!289 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_end", scope: !275, file: !276, line: 66, baseType: !75, size: 64, offset: 704)
!290 = !DIDerivedType(tag: DW_TAG_member, name: "_markers", scope: !275, file: !276, line: 68, baseType: !291, size: 64, offset: 768)
!291 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !292, size: 64)
!292 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_marker", file: !276, line: 36, flags: DIFlagFwdDecl)
!293 = !DIDerivedType(tag: DW_TAG_member, name: "_chain", scope: !275, file: !276, line: 70, baseType: !294, size: 64, offset: 832)
!294 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !275, size: 64)
!295 = !DIDerivedType(tag: DW_TAG_member, name: "_fileno", scope: !275, file: !276, line: 72, baseType: !7, size: 32, offset: 896)
!296 = !DIDerivedType(tag: DW_TAG_member, name: "_flags2", scope: !275, file: !276, line: 73, baseType: !7, size: 32, offset: 928)
!297 = !DIDerivedType(tag: DW_TAG_member, name: "_old_offset", scope: !275, file: !276, line: 74, baseType: !298, size: 64, offset: 960)
!298 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off_t", file: !299, line: 152, baseType: !202)
!299 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/bits/types.h", directory: "")
!300 = !DIDerivedType(tag: DW_TAG_member, name: "_cur_column", scope: !275, file: !276, line: 77, baseType: !47, size: 16, offset: 1024)
!301 = !DIDerivedType(tag: DW_TAG_member, name: "_vtable_offset", scope: !275, file: !276, line: 78, baseType: !302, size: 8, offset: 1040)
!302 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!303 = !DIDerivedType(tag: DW_TAG_member, name: "_shortbuf", scope: !275, file: !276, line: 79, baseType: !304, size: 8, offset: 1048)
!304 = !DICompositeType(tag: DW_TAG_array_type, baseType: !76, size: 8, elements: !305)
!305 = !{!306}
!306 = !DISubrange(count: 1)
!307 = !DIDerivedType(tag: DW_TAG_member, name: "_lock", scope: !275, file: !276, line: 81, baseType: !308, size: 64, offset: 1088)
!308 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !309, size: 64)
!309 = !DIDerivedType(tag: DW_TAG_typedef, name: "_IO_lock_t", file: !276, line: 43, baseType: null)
!310 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !275, file: !276, line: 89, baseType: !311, size: 64, offset: 1152)
!311 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off64_t", file: !299, line: 153, baseType: !202)
!312 = !DIDerivedType(tag: DW_TAG_member, name: "_codecvt", scope: !275, file: !276, line: 91, baseType: !313, size: 64, offset: 1216)
!313 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !314, size: 64)
!314 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_codecvt", file: !276, line: 37, flags: DIFlagFwdDecl)
!315 = !DIDerivedType(tag: DW_TAG_member, name: "_wide_data", scope: !275, file: !276, line: 92, baseType: !316, size: 64, offset: 1280)
!316 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !317, size: 64)
!317 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_wide_data", file: !276, line: 38, flags: DIFlagFwdDecl)
!318 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_list", scope: !275, file: !276, line: 93, baseType: !294, size: 64, offset: 1344)
!319 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_buf", scope: !275, file: !276, line: 94, baseType: !15, size: 64, offset: 1408)
!320 = !DIDerivedType(tag: DW_TAG_member, name: "__pad5", scope: !275, file: !276, line: 95, baseType: !31, size: 64, offset: 1472)
!321 = !DIDerivedType(tag: DW_TAG_member, name: "_mode", scope: !275, file: !276, line: 96, baseType: !7, size: 32, offset: 1536)
!322 = !DIDerivedType(tag: DW_TAG_member, name: "_unused2", scope: !275, file: !276, line: 98, baseType: !323, size: 160, offset: 1568)
!323 = !DICompositeType(tag: DW_TAG_array_type, baseType: !76, size: 160, elements: !324)
!324 = !{!325}
!325 = !DISubrange(count: 20)
!326 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 256, elements: !59)
!327 = !DIGlobalVariableExpression(var: !328, expr: !DIExpression())
!328 = distinct !DIGlobalVariable(name: "GifScreen", scope: !263, file: !264, line: 26, type: !329, isLocal: false, isDefinition: true)
!329 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "gif_scr", file: !201, line: 42, size: 6368, elements: !330)
!330 = !{!331, !332, !333, !342, !343, !344, !345, !346}
!331 = !DIDerivedType(tag: DW_TAG_member, name: "Width", scope: !329, file: !201, line: 43, baseType: !26, size: 32)
!332 = !DIDerivedType(tag: DW_TAG_member, name: "Height", scope: !329, file: !201, line: 44, baseType: !26, size: 32, offset: 32)
!333 = !DIDerivedType(tag: DW_TAG_member, name: "ColorMap", scope: !329, file: !201, line: 45, baseType: !334, size: 6144, offset: 64)
!334 = !DICompositeType(tag: DW_TAG_array_type, baseType: !335, size: 6144, elements: !8)
!335 = !DIDerivedType(tag: DW_TAG_typedef, name: "GifColor", file: !201, line: 19, baseType: !336)
!336 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_color", file: !17, line: 379, baseType: !337)
!337 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "png_color_struct", file: !17, line: 374, size: 24, elements: !338)
!338 = !{!339, !340, !341}
!339 = !DIDerivedType(tag: DW_TAG_member, name: "red", scope: !337, file: !17, line: 376, baseType: !41, size: 8)
!340 = !DIDerivedType(tag: DW_TAG_member, name: "green", scope: !337, file: !17, line: 377, baseType: !41, size: 8, offset: 8)
!341 = !DIDerivedType(tag: DW_TAG_member, name: "blue", scope: !337, file: !17, line: 378, baseType: !41, size: 8, offset: 16)
!342 = !DIDerivedType(tag: DW_TAG_member, name: "ColorMap_present", scope: !329, file: !201, line: 46, baseType: !26, size: 32, offset: 6208)
!343 = !DIDerivedType(tag: DW_TAG_member, name: "BitPixel", scope: !329, file: !201, line: 47, baseType: !26, size: 32, offset: 6240)
!344 = !DIDerivedType(tag: DW_TAG_member, name: "ColorResolution", scope: !329, file: !201, line: 48, baseType: !26, size: 32, offset: 6272)
!345 = !DIDerivedType(tag: DW_TAG_member, name: "Background", scope: !329, file: !201, line: 49, baseType: !7, size: 32, offset: 6304)
!346 = !DIDerivedType(tag: DW_TAG_member, name: "AspectRatio", scope: !329, file: !201, line: 50, baseType: !26, size: 32, offset: 6336)
!347 = !DIGlobalVariableExpression(var: !348, expr: !DIExpression())
!348 = distinct !DIGlobalVariable(name: "Gif89", scope: !263, file: !264, line: 33, type: !349, isLocal: false, isDefinition: true)
!349 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !264, line: 28, size: 128, elements: !350)
!350 = !{!351, !352, !353, !354}
!351 = !DIDerivedType(tag: DW_TAG_member, name: "transparent", scope: !349, file: !264, line: 29, baseType: !7, size: 32)
!352 = !DIDerivedType(tag: DW_TAG_member, name: "delayTime", scope: !349, file: !264, line: 30, baseType: !7, size: 32, offset: 32)
!353 = !DIDerivedType(tag: DW_TAG_member, name: "inputFlag", scope: !349, file: !264, line: 31, baseType: !7, size: 32, offset: 64)
!354 = !DIDerivedType(tag: DW_TAG_member, name: "disposal", scope: !349, file: !264, line: 32, baseType: !7, size: 32, offset: 96)
!355 = !DIGlobalVariableExpression(var: !356, expr: !DIExpression())
!356 = distinct !DIGlobalVariable(name: "recover_message", scope: !263, file: !264, line: 44, type: !7, isLocal: false, isDefinition: true)
!357 = !DIGlobalVariableExpression(var: !358, expr: !DIExpression())
!358 = distinct !DIGlobalVariable(name: "buf", scope: !359, file: !264, line: 259, type: !362, isLocal: true, isDefinition: true)
!359 = distinct !DISubprogram(name: "DoExtension", scope: !264, file: !264, line: 257, type: !360, scopeLine: 258, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !263, retainedNodes: !4)
!360 = !DISubroutineType(types: !361)
!361 = !{!7, !272, !7}
!362 = !DICompositeType(tag: DW_TAG_array_type, baseType: !76, size: 2048, elements: !8)
!363 = !DIGlobalVariableExpression(var: !364, expr: !DIExpression())
!364 = distinct !DIGlobalVariable(name: "ZeroDataBlock", scope: !263, file: !264, line: 388, type: !7, isLocal: true, isDefinition: true)
!365 = !DIGlobalVariableExpression(var: !366, expr: !DIExpression())
!366 = distinct !DIGlobalVariable(name: "set_code_size", scope: !263, file: !264, line: 420, type: !7, isLocal: true, isDefinition: true)
!367 = !DIGlobalVariableExpression(var: !368, expr: !DIExpression())
!368 = distinct !DIGlobalVariable(name: "code_size", scope: !263, file: !264, line: 420, type: !7, isLocal: true, isDefinition: true)
!369 = !DIGlobalVariableExpression(var: !370, expr: !DIExpression())
!370 = distinct !DIGlobalVariable(name: "clear_code", scope: !263, file: !264, line: 422, type: !7, isLocal: true, isDefinition: true)
!371 = !DIGlobalVariableExpression(var: !372, expr: !DIExpression())
!372 = distinct !DIGlobalVariable(name: "end_code", scope: !263, file: !264, line: 422, type: !7, isLocal: true, isDefinition: true)
!373 = !DIGlobalVariableExpression(var: !374, expr: !DIExpression())
!374 = distinct !DIGlobalVariable(name: "max_code_size", scope: !263, file: !264, line: 421, type: !7, isLocal: true, isDefinition: true)
!375 = !DIGlobalVariableExpression(var: !376, expr: !DIExpression())
!376 = distinct !DIGlobalVariable(name: "max_code", scope: !263, file: !264, line: 421, type: !7, isLocal: true, isDefinition: true)
!377 = !DIGlobalVariableExpression(var: !378, expr: !DIExpression())
!378 = distinct !DIGlobalVariable(name: "lastbit", scope: !263, file: !264, line: 414, type: !7, isLocal: true, isDefinition: true)
!379 = !DIGlobalVariableExpression(var: !380, expr: !DIExpression())
!380 = distinct !DIGlobalVariable(name: "curbit", scope: !263, file: !264, line: 414, type: !7, isLocal: true, isDefinition: true)
!381 = !DIGlobalVariableExpression(var: !382, expr: !DIExpression())
!382 = distinct !DIGlobalVariable(name: "last_byte", scope: !263, file: !264, line: 414, type: !7, isLocal: true, isDefinition: true)
!383 = !DIGlobalVariableExpression(var: !384, expr: !DIExpression())
!384 = distinct !DIGlobalVariable(name: "get_done", scope: !263, file: !264, line: 414, type: !7, isLocal: true, isDefinition: true)
!385 = !DIGlobalVariableExpression(var: !386, expr: !DIExpression())
!386 = distinct !DIGlobalVariable(name: "return_clear", scope: !263, file: !264, line: 415, type: !7, isLocal: true, isDefinition: true)
!387 = !DIGlobalVariableExpression(var: !388, expr: !DIExpression())
!388 = distinct !DIGlobalVariable(name: "sp", scope: !263, file: !264, line: 419, type: !389, isLocal: true, isDefinition: true)
!389 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!390 = !DIGlobalVariableExpression(var: !391, expr: !DIExpression())
!391 = distinct !DIGlobalVariable(name: "stack", scope: !263, file: !264, line: 419, type: !392, isLocal: true, isDefinition: true)
!392 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 262144, elements: !393)
!393 = !{!394}
!394 = !DISubrange(count: 8192)
!395 = !DIGlobalVariableExpression(var: !396, expr: !DIExpression())
!396 = distinct !DIGlobalVariable(name: "table", scope: !397, file: !264, line: 506, type: !398, isLocal: true, isDefinition: true)
!397 = distinct !DISubprogram(name: "nextLWZ", scope: !264, file: !264, line: 504, type: !270, scopeLine: 505, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !263, retainedNodes: !4)
!398 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 262144, elements: !399)
!399 = !{!400, !401}
!400 = !DISubrange(count: 2)
!401 = !DISubrange(count: 4096)
!402 = !DIGlobalVariableExpression(var: !403, expr: !DIExpression())
!403 = distinct !DIGlobalVariable(name: "firstcode", scope: !397, file: !264, line: 507, type: !7, isLocal: true, isDefinition: true)
!404 = !DIGlobalVariableExpression(var: !405, expr: !DIExpression())
!405 = distinct !DIGlobalVariable(name: "oldcode", scope: !397, file: !264, line: 507, type: !7, isLocal: true, isDefinition: true)
!406 = !DIGlobalVariableExpression(var: !407, expr: !DIExpression())
!407 = distinct !DIGlobalVariable(name: "buf", scope: !408, file: !264, line: 444, type: !409, isLocal: true, isDefinition: true)
!408 = distinct !DISubprogram(name: "nextCode", scope: !264, file: !264, line: 442, type: !360, scopeLine: 443, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !263, retainedNodes: !4)
!409 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 2240, elements: !410)
!410 = !{!411}
!411 = !DISubrange(count: 280)
!412 = !DIGlobalVariableExpression(var: !413, expr: !DIExpression())
!413 = distinct !DIGlobalVariable(name: "maskTbl", scope: !408, file: !264, line: 445, type: !414, isLocal: true, isDefinition: true)
!414 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 512, elements: !415)
!415 = !{!416}
!416 = !DISubrange(count: 16)
!417 = !DIGlobalVariableExpression(var: !418, expr: !DIExpression())
!418 = distinct !DIGlobalVariable(name: "version", scope: !419, file: !420, line: 18, type: !428, isLocal: false, isDefinition: true)
!419 = distinct !DICompileUnit(language: DW_LANG_C99, file: !420, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !421, splitDebugInlining: false, nameTableKind: None)
!420 = !DIFile(filename: "version.c", directory: "/gif2png/gif2png")
!421 = !{!417, !422}
!422 = !DIGlobalVariableExpression(var: !423, expr: !DIExpression())
!423 = distinct !DIGlobalVariable(name: "compile_info", scope: !419, file: !420, line: 20, type: !424, isLocal: false, isDefinition: true)
!424 = !DICompositeType(tag: DW_TAG_array_type, baseType: !425, size: 456, elements: !426)
!425 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !76)
!426 = !{!427}
!427 = !DISubrange(count: 57)
!428 = !DICompositeType(tag: DW_TAG_array_type, baseType: !425, size: 112, elements: !429)
!429 = !{!430}
!430 = !DISubrange(count: 14)
!431 = distinct !DICompileUnit(language: DW_LANG_C99, file: !432, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !433, splitDebugInlining: false, nameTableKind: None)
!432 = !DIFile(filename: "memory.c", directory: "/gif2png/gif2png")
!433 = !{!31, !15}
!434 = !{!"clang version 10.0.0-4ubuntu1 "}
!435 = !{i32 7, !"Dwarf Version", i32 4}
!436 = !{i32 2, !"Debug Info Version", i32 3}
!437 = !{i32 1, !"wchar_size", i32 4}
!438 = distinct !DISubprogram(name: "interlace_line", scope: !13, file: !13, line: 45, type: !439, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !4)
!439 = !DISubroutineType(types: !440)
!440 = !{!7, !7, !7}
!441 = !DILocalVariable(name: "height", arg: 1, scope: !438, file: !13, line: 45, type: !7)
!442 = !DILocation(line: 45, column: 24, scope: !438)
!443 = !DILocalVariable(name: "line", arg: 2, scope: !438, file: !13, line: 45, type: !7)
!444 = !DILocation(line: 45, column: 36, scope: !438)
!445 = !DILocalVariable(name: "res", scope: !438, file: !13, line: 48, type: !7)
!446 = !DILocation(line: 48, column: 9, scope: !438)
!447 = !DILocation(line: 50, column: 10, scope: !448)
!448 = distinct !DILexicalBlock(scope: !438, file: !13, line: 50, column: 9)
!449 = !DILocation(line: 50, column: 15, scope: !448)
!450 = !DILocation(line: 50, column: 20, scope: !448)
!451 = !DILocation(line: 50, column: 9, scope: !438)
!452 = !DILocation(line: 51, column: 9, scope: !453)
!453 = distinct !DILexicalBlock(scope: !448, file: !13, line: 50, column: 26)
!454 = !DILocation(line: 51, column: 14, scope: !453)
!455 = !DILocation(line: 51, column: 2, scope: !453)
!456 = !DILocation(line: 53, column: 12, scope: !438)
!457 = !DILocation(line: 53, column: 18, scope: !438)
!458 = !DILocation(line: 53, column: 22, scope: !438)
!459 = !DILocation(line: 53, column: 9, scope: !438)
!460 = !DILocation(line: 54, column: 10, scope: !461)
!461 = distinct !DILexicalBlock(scope: !438, file: !13, line: 54, column: 9)
!462 = !DILocation(line: 54, column: 15, scope: !461)
!463 = !DILocation(line: 54, column: 20, scope: !461)
!464 = !DILocation(line: 54, column: 9, scope: !438)
!465 = !DILocation(line: 55, column: 9, scope: !466)
!466 = distinct !DILexicalBlock(scope: !461, file: !13, line: 54, column: 26)
!467 = !DILocation(line: 55, column: 15, scope: !466)
!468 = !DILocation(line: 55, column: 19, scope: !466)
!469 = !DILocation(line: 55, column: 23, scope: !466)
!470 = !DILocation(line: 55, column: 12, scope: !466)
!471 = !DILocation(line: 55, column: 2, scope: !466)
!472 = !DILocation(line: 57, column: 13, scope: !438)
!473 = !DILocation(line: 57, column: 19, scope: !438)
!474 = !DILocation(line: 57, column: 23, scope: !438)
!475 = !DILocation(line: 57, column: 9, scope: !438)
!476 = !DILocation(line: 58, column: 10, scope: !477)
!477 = distinct !DILexicalBlock(scope: !438, file: !13, line: 58, column: 9)
!478 = !DILocation(line: 58, column: 15, scope: !477)
!479 = !DILocation(line: 58, column: 20, scope: !477)
!480 = !DILocation(line: 58, column: 9, scope: !438)
!481 = !DILocation(line: 59, column: 9, scope: !482)
!482 = distinct !DILexicalBlock(scope: !477, file: !13, line: 58, column: 26)
!483 = !DILocation(line: 59, column: 17, scope: !482)
!484 = !DILocation(line: 59, column: 21, scope: !482)
!485 = !DILocation(line: 59, column: 25, scope: !482)
!486 = !DILocation(line: 59, column: 13, scope: !482)
!487 = !DILocation(line: 59, column: 2, scope: !482)
!488 = !DILocation(line: 61, column: 12, scope: !438)
!489 = !DILocation(line: 61, column: 20, scope: !438)
!490 = !DILocation(line: 61, column: 26, scope: !438)
!491 = !DILocation(line: 61, column: 30, scope: !438)
!492 = !DILocation(line: 61, column: 16, scope: !438)
!493 = !DILocation(line: 61, column: 40, scope: !438)
!494 = !DILocation(line: 61, column: 44, scope: !438)
!495 = !DILocation(line: 61, column: 48, scope: !438)
!496 = !DILocation(line: 61, column: 36, scope: !438)
!497 = !DILocation(line: 61, column: 5, scope: !438)
!498 = !DILocation(line: 62, column: 1, scope: !438)
!499 = distinct !DISubprogram(name: "inv_interlace_line", scope: !13, file: !13, line: 64, type: !439, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !4)
!500 = !DILocalVariable(name: "height", arg: 1, scope: !499, file: !13, line: 64, type: !7)
!501 = !DILocation(line: 64, column: 28, scope: !499)
!502 = !DILocalVariable(name: "line", arg: 2, scope: !499, file: !13, line: 64, type: !7)
!503 = !DILocation(line: 64, column: 40, scope: !499)
!504 = !DILocation(line: 67, column: 10, scope: !505)
!505 = distinct !DILexicalBlock(scope: !499, file: !13, line: 67, column: 9)
!506 = !DILocation(line: 67, column: 15, scope: !505)
!507 = !DILocation(line: 67, column: 21, scope: !505)
!508 = !DILocation(line: 67, column: 20, scope: !505)
!509 = !DILocation(line: 67, column: 9, scope: !499)
!510 = !DILocation(line: 68, column: 9, scope: !511)
!511 = distinct !DILexicalBlock(scope: !505, file: !13, line: 67, column: 29)
!512 = !DILocation(line: 68, column: 14, scope: !511)
!513 = !DILocation(line: 68, column: 2, scope: !511)
!514 = !DILocation(line: 70, column: 14, scope: !499)
!515 = !DILocation(line: 70, column: 20, scope: !499)
!516 = !DILocation(line: 70, column: 24, scope: !499)
!517 = !DILocation(line: 70, column: 10, scope: !499)
!518 = !DILocation(line: 71, column: 10, scope: !519)
!519 = distinct !DILexicalBlock(scope: !499, file: !13, line: 71, column: 9)
!520 = !DILocation(line: 71, column: 15, scope: !519)
!521 = !DILocation(line: 71, column: 21, scope: !519)
!522 = !DILocation(line: 71, column: 27, scope: !519)
!523 = !DILocation(line: 71, column: 25, scope: !519)
!524 = !DILocation(line: 71, column: 9, scope: !499)
!525 = !DILocation(line: 72, column: 10, scope: !526)
!526 = distinct !DILexicalBlock(scope: !519, file: !13, line: 71, column: 35)
!527 = !DILocation(line: 72, column: 15, scope: !526)
!528 = !DILocation(line: 72, column: 21, scope: !526)
!529 = !DILocation(line: 72, column: 2, scope: !526)
!530 = !DILocation(line: 74, column: 14, scope: !499)
!531 = !DILocation(line: 74, column: 20, scope: !499)
!532 = !DILocation(line: 74, column: 24, scope: !499)
!533 = !DILocation(line: 74, column: 10, scope: !499)
!534 = !DILocation(line: 75, column: 10, scope: !535)
!535 = distinct !DILexicalBlock(scope: !499, file: !13, line: 75, column: 9)
!536 = !DILocation(line: 75, column: 15, scope: !535)
!537 = !DILocation(line: 75, column: 21, scope: !535)
!538 = !DILocation(line: 75, column: 27, scope: !535)
!539 = !DILocation(line: 75, column: 25, scope: !535)
!540 = !DILocation(line: 75, column: 9, scope: !499)
!541 = !DILocation(line: 76, column: 10, scope: !542)
!542 = distinct !DILexicalBlock(scope: !535, file: !13, line: 75, column: 35)
!543 = !DILocation(line: 76, column: 15, scope: !542)
!544 = !DILocation(line: 76, column: 21, scope: !542)
!545 = !DILocation(line: 76, column: 2, scope: !542)
!546 = !DILocation(line: 78, column: 14, scope: !499)
!547 = !DILocation(line: 78, column: 21, scope: !499)
!548 = !DILocation(line: 78, column: 26, scope: !499)
!549 = !DILocation(line: 78, column: 10, scope: !499)
!550 = !DILocation(line: 79, column: 13, scope: !499)
!551 = !DILocation(line: 79, column: 18, scope: !499)
!552 = !DILocation(line: 79, column: 24, scope: !499)
!553 = !DILocation(line: 79, column: 5, scope: !499)
!554 = !DILocation(line: 80, column: 1, scope: !499)
!555 = distinct !DISubprogram(name: "is_gray", scope: !13, file: !13, line: 105, type: !556, scopeLine: 106, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !4)
!556 = !DISubroutineType(types: !557)
!557 = !{!7, !37}
!558 = !DILocalVariable(name: "c", arg: 1, scope: !555, file: !13, line: 105, type: !37)
!559 = !DILocation(line: 105, column: 23, scope: !555)
!560 = !DILocation(line: 110, column: 14, scope: !555)
!561 = !DILocation(line: 110, column: 12, scope: !555)
!562 = !DILocation(line: 110, column: 23, scope: !555)
!563 = !DILocation(line: 110, column: 21, scope: !555)
!564 = !DILocation(line: 110, column: 18, scope: !555)
!565 = !DILocation(line: 110, column: 29, scope: !555)
!566 = !DILocation(line: 110, column: 34, scope: !555)
!567 = !DILocation(line: 110, column: 32, scope: !555)
!568 = !DILocation(line: 110, column: 45, scope: !555)
!569 = !DILocation(line: 110, column: 43, scope: !555)
!570 = !DILocation(line: 110, column: 40, scope: !555)
!571 = !DILocation(line: 0, scope: !555)
!572 = !DILocation(line: 110, column: 5, scope: !555)
!573 = distinct !DISubprogram(name: "writefile", scope: !13, file: !13, line: 113, type: !574, scopeLine: 114, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !4)
!574 = !DISubroutineType(types: !575)
!575 = !{!7, !235, !235, !576, !7}
!576 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !577, size: 64)
!577 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !274, line: 7, baseType: !578)
!578 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !276, line: 49, size: 1728, elements: !579)
!579 = !{!580, !581, !582, !583, !584, !585, !586, !587, !588, !589, !590, !591, !592, !593, !595, !596, !597, !598, !599, !600, !601, !602, !603, !604, !605, !606, !607, !608, !609}
!580 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !578, file: !276, line: 51, baseType: !7, size: 32)
!581 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_ptr", scope: !578, file: !276, line: 54, baseType: !75, size: 64, offset: 64)
!582 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_end", scope: !578, file: !276, line: 55, baseType: !75, size: 64, offset: 128)
!583 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_base", scope: !578, file: !276, line: 56, baseType: !75, size: 64, offset: 192)
!584 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_base", scope: !578, file: !276, line: 57, baseType: !75, size: 64, offset: 256)
!585 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_ptr", scope: !578, file: !276, line: 58, baseType: !75, size: 64, offset: 320)
!586 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_end", scope: !578, file: !276, line: 59, baseType: !75, size: 64, offset: 384)
!587 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_base", scope: !578, file: !276, line: 60, baseType: !75, size: 64, offset: 448)
!588 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_end", scope: !578, file: !276, line: 61, baseType: !75, size: 64, offset: 512)
!589 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_base", scope: !578, file: !276, line: 64, baseType: !75, size: 64, offset: 576)
!590 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_backup_base", scope: !578, file: !276, line: 65, baseType: !75, size: 64, offset: 640)
!591 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_end", scope: !578, file: !276, line: 66, baseType: !75, size: 64, offset: 704)
!592 = !DIDerivedType(tag: DW_TAG_member, name: "_markers", scope: !578, file: !276, line: 68, baseType: !291, size: 64, offset: 768)
!593 = !DIDerivedType(tag: DW_TAG_member, name: "_chain", scope: !578, file: !276, line: 70, baseType: !594, size: 64, offset: 832)
!594 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !578, size: 64)
!595 = !DIDerivedType(tag: DW_TAG_member, name: "_fileno", scope: !578, file: !276, line: 72, baseType: !7, size: 32, offset: 896)
!596 = !DIDerivedType(tag: DW_TAG_member, name: "_flags2", scope: !578, file: !276, line: 73, baseType: !7, size: 32, offset: 928)
!597 = !DIDerivedType(tag: DW_TAG_member, name: "_old_offset", scope: !578, file: !276, line: 74, baseType: !298, size: 64, offset: 960)
!598 = !DIDerivedType(tag: DW_TAG_member, name: "_cur_column", scope: !578, file: !276, line: 77, baseType: !47, size: 16, offset: 1024)
!599 = !DIDerivedType(tag: DW_TAG_member, name: "_vtable_offset", scope: !578, file: !276, line: 78, baseType: !302, size: 8, offset: 1040)
!600 = !DIDerivedType(tag: DW_TAG_member, name: "_shortbuf", scope: !578, file: !276, line: 79, baseType: !304, size: 8, offset: 1048)
!601 = !DIDerivedType(tag: DW_TAG_member, name: "_lock", scope: !578, file: !276, line: 81, baseType: !308, size: 64, offset: 1088)
!602 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !578, file: !276, line: 89, baseType: !311, size: 64, offset: 1152)
!603 = !DIDerivedType(tag: DW_TAG_member, name: "_codecvt", scope: !578, file: !276, line: 91, baseType: !313, size: 64, offset: 1216)
!604 = !DIDerivedType(tag: DW_TAG_member, name: "_wide_data", scope: !578, file: !276, line: 92, baseType: !316, size: 64, offset: 1280)
!605 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_list", scope: !578, file: !276, line: 93, baseType: !594, size: 64, offset: 1344)
!606 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_buf", scope: !578, file: !276, line: 94, baseType: !15, size: 64, offset: 1408)
!607 = !DIDerivedType(tag: DW_TAG_member, name: "__pad5", scope: !578, file: !276, line: 95, baseType: !31, size: 64, offset: 1472)
!608 = !DIDerivedType(tag: DW_TAG_member, name: "_mode", scope: !578, file: !276, line: 96, baseType: !7, size: 32, offset: 1536)
!609 = !DIDerivedType(tag: DW_TAG_member, name: "_unused2", scope: !578, file: !276, line: 98, baseType: !323, size: 160, offset: 1568)
!610 = !DILocalVariable(name: "s", arg: 1, scope: !573, file: !13, line: 113, type: !235)
!611 = !DILocation(line: 113, column: 34, scope: !573)
!612 = !DILocalVariable(name: "e", arg: 2, scope: !573, file: !13, line: 113, type: !235)
!613 = !DILocation(line: 113, column: 55, scope: !573)
!614 = !DILocalVariable(name: "fp", arg: 3, scope: !573, file: !13, line: 113, type: !576)
!615 = !DILocation(line: 113, column: 64, scope: !573)
!616 = !DILocalVariable(name: "lastimg", arg: 4, scope: !573, file: !13, line: 113, type: !7)
!617 = !DILocation(line: 113, column: 72, scope: !573)
!618 = !DILocalVariable(name: "i", scope: !573, file: !13, line: 115, type: !7)
!619 = !DILocation(line: 115, column: 9, scope: !573)
!620 = !DILocalVariable(name: "img", scope: !573, file: !13, line: 116, type: !245)
!621 = !DILocation(line: 116, column: 28, scope: !573)
!622 = !DILocation(line: 116, column: 34, scope: !573)
!623 = !DILocation(line: 116, column: 37, scope: !573)
!624 = !DILocalVariable(name: "count", scope: !573, file: !13, line: 117, type: !625)
!625 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!626 = !DILocation(line: 117, column: 20, scope: !573)
!627 = !DILocation(line: 117, column: 28, scope: !573)
!628 = !DILocation(line: 117, column: 33, scope: !573)
!629 = !DILocalVariable(name: "colors", scope: !573, file: !13, line: 118, type: !630)
!630 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !250, size: 64)
!631 = !DILocation(line: 118, column: 15, scope: !573)
!632 = !DILocation(line: 118, column: 24, scope: !573)
!633 = !DILocation(line: 118, column: 29, scope: !573)
!634 = !DILocalVariable(name: "colors_used", scope: !573, file: !13, line: 119, type: !7)
!635 = !DILocation(line: 119, column: 9, scope: !573)
!636 = !DILocalVariable(name: "remap", scope: !573, file: !13, line: 120, type: !637)
!637 = !DICompositeType(tag: DW_TAG_array_type, baseType: !200, size: 2048, elements: !8)
!638 = !DILocation(line: 120, column: 10, scope: !573)
!639 = !DILocalVariable(name: "low_prec", scope: !573, file: !13, line: 121, type: !7)
!640 = !DILocation(line: 121, column: 9, scope: !573)
!641 = !DILocalVariable(name: "png_ptr", scope: !573, file: !13, line: 122, type: !642)
!642 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !643, size: 64)
!643 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_struct", file: !17, line: 938, baseType: !644)
!644 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "png_struct_def", file: !17, line: 1014, size: 9920, elements: !645)
!645 = !{!646, !667, !673, !681, !682, !684, !689, !690, !691, !707, !708, !709, !710, !711, !712, !713, !714, !750, !751, !752, !753, !754, !755, !756, !757, !758, !759, !760, !761, !762, !764, !765, !766, !767, !768, !769, !770, !771, !772, !773, !774, !775, !776, !777, !778, !779, !780, !781, !782, !783, !784, !785, !786, !787, !788, !789, !790, !791, !792, !793, !794, !795, !796, !801, !802, !803, !804, !805, !806, !807, !808, !809, !812, !813, !814, !815, !816, !817, !818, !823, !825, !831, !836, !838, !839, !840, !841, !842, !843, !844, !845, !846, !847, !848, !849, !850, !851, !852, !853, !854, !855, !856, !857, !858, !859, !860, !865, !866, !867, !868, !869, !870, !871, !872, !873, !874, !875, !880, !885, !886, !887, !888, !889, !890, !891, !892, !893, !894, !895, !896, !897}
!646 = !DIDerivedType(tag: DW_TAG_member, name: "jmpbuf", scope: !644, file: !17, line: 1017, baseType: !647, size: 2496)
!647 = !DIDerivedType(tag: DW_TAG_typedef, name: "jmp_buf", file: !648, line: 45, baseType: !649)
!648 = !DIFile(filename: "/usr/include/setjmp.h", directory: "")
!649 = !DICompositeType(tag: DW_TAG_array_type, baseType: !650, size: 2496, elements: !305)
!650 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__jmp_buf_tag", file: !648, line: 33, size: 2496, elements: !651)
!651 = !{!652, !659, !660}
!652 = !DIDerivedType(tag: DW_TAG_member, name: "__jmpbuf", scope: !650, file: !648, line: 39, baseType: !653, size: 1408)
!653 = !DIDerivedType(tag: DW_TAG_typedef, name: "__jmp_buf", file: !654, line: 30, baseType: !655)
!654 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/bits/setjmp.h", directory: "")
!655 = !DICompositeType(tag: DW_TAG_array_type, baseType: !656, size: 1408, elements: !657)
!656 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!657 = !{!658}
!658 = !DISubrange(count: 22)
!659 = !DIDerivedType(tag: DW_TAG_member, name: "__mask_was_saved", scope: !650, file: !648, line: 40, baseType: !7, size: 32, offset: 1408)
!660 = !DIDerivedType(tag: DW_TAG_member, name: "__saved_mask", scope: !650, file: !648, line: 41, baseType: !661, size: 1024, offset: 1472)
!661 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sigset_t", file: !662, line: 8, baseType: !663)
!662 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/bits/types/__sigset_t.h", directory: "")
!663 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !662, line: 5, size: 1024, elements: !664)
!664 = !{!665}
!665 = !DIDerivedType(tag: DW_TAG_member, name: "__val", scope: !663, file: !662, line: 7, baseType: !666, size: 1024)
!666 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 1024, elements: !415)
!667 = !DIDerivedType(tag: DW_TAG_member, name: "longjmp_fn", scope: !644, file: !17, line: 1018, baseType: !668, size: 64, offset: 2496)
!668 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_longjmp_ptr", file: !17, line: 976, baseType: !669)
!669 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !670, size: 64)
!670 = !DISubroutineType(types: !671)
!671 = !{null, !672, !7}
!672 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !650, size: 64)
!673 = !DIDerivedType(tag: DW_TAG_member, name: "error_fn", scope: !644, file: !17, line: 1021, baseType: !674, size: 64, offset: 2560)
!674 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_error_ptr", file: !17, line: 942, baseType: !675)
!675 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !676, size: 64)
!676 = !DISubroutineType(types: !677)
!677 = !{null, !678, !679}
!678 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_structp", file: !17, line: 939, baseType: !642)
!679 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_const_charp", file: !25, line: 1210, baseType: !680)
!680 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !425, size: 64)
!681 = !DIDerivedType(tag: DW_TAG_member, name: "warning_fn", scope: !644, file: !17, line: 1023, baseType: !674, size: 64, offset: 2624)
!682 = !DIDerivedType(tag: DW_TAG_member, name: "error_ptr", scope: !644, file: !17, line: 1025, baseType: !683, size: 64, offset: 2688)
!683 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_voidp", file: !25, line: 1204, baseType: !15)
!684 = !DIDerivedType(tag: DW_TAG_member, name: "write_data_fn", scope: !644, file: !17, line: 1027, baseType: !685, size: 64, offset: 2752)
!685 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_rw_ptr", file: !17, line: 943, baseType: !686)
!686 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !687, size: 64)
!687 = !DISubroutineType(types: !688)
!688 = !{null, !678, !102, !30}
!689 = !DIDerivedType(tag: DW_TAG_member, name: "read_data_fn", scope: !644, file: !17, line: 1029, baseType: !685, size: 64, offset: 2816)
!690 = !DIDerivedType(tag: DW_TAG_member, name: "io_ptr", scope: !644, file: !17, line: 1031, baseType: !683, size: 64, offset: 2880)
!691 = !DIDerivedType(tag: DW_TAG_member, name: "read_user_transform_fn", scope: !644, file: !17, line: 1035, baseType: !692, size: 64, offset: 2944)
!692 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_user_transform_ptr", file: !17, line: 960, baseType: !693)
!693 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !694, size: 64)
!694 = !DISubroutineType(types: !695)
!695 = !{null, !678, !696, !102}
!696 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_row_infop", file: !17, line: 929, baseType: !697)
!697 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !698, size: 64)
!698 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_row_info", file: !17, line: 927, baseType: !699)
!699 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "png_row_info_struct", file: !17, line: 919, size: 192, elements: !700)
!700 = !{!701, !702, !703, !704, !705, !706}
!701 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !699, file: !17, line: 921, baseType: !24, size: 32)
!702 = !DIDerivedType(tag: DW_TAG_member, name: "rowbytes", scope: !699, file: !17, line: 922, baseType: !30, size: 64, offset: 64)
!703 = !DIDerivedType(tag: DW_TAG_member, name: "color_type", scope: !699, file: !17, line: 923, baseType: !41, size: 8, offset: 128)
!704 = !DIDerivedType(tag: DW_TAG_member, name: "bit_depth", scope: !699, file: !17, line: 924, baseType: !41, size: 8, offset: 136)
!705 = !DIDerivedType(tag: DW_TAG_member, name: "channels", scope: !699, file: !17, line: 925, baseType: !41, size: 8, offset: 144)
!706 = !DIDerivedType(tag: DW_TAG_member, name: "pixel_depth", scope: !699, file: !17, line: 926, baseType: !41, size: 8, offset: 152)
!707 = !DIDerivedType(tag: DW_TAG_member, name: "write_user_transform_fn", scope: !644, file: !17, line: 1040, baseType: !692, size: 64, offset: 3008)
!708 = !DIDerivedType(tag: DW_TAG_member, name: "user_transform_ptr", scope: !644, file: !17, line: 1048, baseType: !683, size: 64, offset: 3072)
!709 = !DIDerivedType(tag: DW_TAG_member, name: "user_transform_depth", scope: !644, file: !17, line: 1050, baseType: !41, size: 8, offset: 3136)
!710 = !DIDerivedType(tag: DW_TAG_member, name: "user_transform_channels", scope: !644, file: !17, line: 1052, baseType: !41, size: 8, offset: 3144)
!711 = !DIDerivedType(tag: DW_TAG_member, name: "mode", scope: !644, file: !17, line: 1057, baseType: !24, size: 32, offset: 3168)
!712 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !644, file: !17, line: 1059, baseType: !24, size: 32, offset: 3200)
!713 = !DIDerivedType(tag: DW_TAG_member, name: "transformations", scope: !644, file: !17, line: 1061, baseType: !24, size: 32, offset: 3232)
!714 = !DIDerivedType(tag: DW_TAG_member, name: "zstream", scope: !644, file: !17, line: 1064, baseType: !715, size: 896, offset: 3264)
!715 = !DIDerivedType(tag: DW_TAG_typedef, name: "z_stream", file: !716, line: 106, baseType: !717)
!716 = !DIFile(filename: "/usr/include/zlib.h", directory: "")
!717 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "z_stream_s", file: !716, line: 86, size: 896, elements: !718)
!718 = !{!719, !724, !726, !728, !729, !730, !731, !732, !735, !741, !746, !747, !748, !749}
!719 = !DIDerivedType(tag: DW_TAG_member, name: "next_in", scope: !717, file: !716, line: 87, baseType: !720, size: 64)
!720 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !721, size: 64)
!721 = !DIDerivedType(tag: DW_TAG_typedef, name: "Bytef", file: !722, line: 400, baseType: !723)
!722 = !DIFile(filename: "/usr/include/zconf.h", directory: "")
!723 = !DIDerivedType(tag: DW_TAG_typedef, name: "Byte", file: !722, line: 391, baseType: !42)
!724 = !DIDerivedType(tag: DW_TAG_member, name: "avail_in", scope: !717, file: !716, line: 88, baseType: !725, size: 32, offset: 64)
!725 = !DIDerivedType(tag: DW_TAG_typedef, name: "uInt", file: !722, line: 393, baseType: !26)
!726 = !DIDerivedType(tag: DW_TAG_member, name: "total_in", scope: !717, file: !716, line: 89, baseType: !727, size: 64, offset: 128)
!727 = !DIDerivedType(tag: DW_TAG_typedef, name: "uLong", file: !722, line: 394, baseType: !33)
!728 = !DIDerivedType(tag: DW_TAG_member, name: "next_out", scope: !717, file: !716, line: 91, baseType: !720, size: 64, offset: 192)
!729 = !DIDerivedType(tag: DW_TAG_member, name: "avail_out", scope: !717, file: !716, line: 92, baseType: !725, size: 32, offset: 256)
!730 = !DIDerivedType(tag: DW_TAG_member, name: "total_out", scope: !717, file: !716, line: 93, baseType: !727, size: 64, offset: 320)
!731 = !DIDerivedType(tag: DW_TAG_member, name: "msg", scope: !717, file: !716, line: 95, baseType: !75, size: 64, offset: 384)
!732 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !717, file: !716, line: 96, baseType: !733, size: 64, offset: 448)
!733 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !734, size: 64)
!734 = !DICompositeType(tag: DW_TAG_structure_type, name: "internal_state", file: !716, line: 84, flags: DIFlagFwdDecl)
!735 = !DIDerivedType(tag: DW_TAG_member, name: "zalloc", scope: !717, file: !716, line: 98, baseType: !736, size: 64, offset: 512)
!736 = !DIDerivedType(tag: DW_TAG_typedef, name: "alloc_func", file: !716, line: 81, baseType: !737)
!737 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !738, size: 64)
!738 = !DISubroutineType(types: !739)
!739 = !{!740, !740, !725, !725}
!740 = !DIDerivedType(tag: DW_TAG_typedef, name: "voidpf", file: !722, line: 409, baseType: !15)
!741 = !DIDerivedType(tag: DW_TAG_member, name: "zfree", scope: !717, file: !716, line: 99, baseType: !742, size: 64, offset: 576)
!742 = !DIDerivedType(tag: DW_TAG_typedef, name: "free_func", file: !716, line: 82, baseType: !743)
!743 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !744, size: 64)
!744 = !DISubroutineType(types: !745)
!745 = !{null, !740, !740}
!746 = !DIDerivedType(tag: DW_TAG_member, name: "opaque", scope: !717, file: !716, line: 100, baseType: !740, size: 64, offset: 640)
!747 = !DIDerivedType(tag: DW_TAG_member, name: "data_type", scope: !717, file: !716, line: 102, baseType: !7, size: 32, offset: 704)
!748 = !DIDerivedType(tag: DW_TAG_member, name: "adler", scope: !717, file: !716, line: 104, baseType: !727, size: 64, offset: 768)
!749 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", scope: !717, file: !716, line: 105, baseType: !727, size: 64, offset: 832)
!750 = !DIDerivedType(tag: DW_TAG_member, name: "zbuf", scope: !644, file: !17, line: 1066, baseType: !102, size: 64, offset: 4160)
!751 = !DIDerivedType(tag: DW_TAG_member, name: "zbuf_size", scope: !644, file: !17, line: 1067, baseType: !30, size: 64, offset: 4224)
!752 = !DIDerivedType(tag: DW_TAG_member, name: "zlib_level", scope: !644, file: !17, line: 1068, baseType: !7, size: 32, offset: 4288)
!753 = !DIDerivedType(tag: DW_TAG_member, name: "zlib_method", scope: !644, file: !17, line: 1069, baseType: !7, size: 32, offset: 4320)
!754 = !DIDerivedType(tag: DW_TAG_member, name: "zlib_window_bits", scope: !644, file: !17, line: 1070, baseType: !7, size: 32, offset: 4352)
!755 = !DIDerivedType(tag: DW_TAG_member, name: "zlib_mem_level", scope: !644, file: !17, line: 1072, baseType: !7, size: 32, offset: 4384)
!756 = !DIDerivedType(tag: DW_TAG_member, name: "zlib_strategy", scope: !644, file: !17, line: 1074, baseType: !7, size: 32, offset: 4416)
!757 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !644, file: !17, line: 1077, baseType: !24, size: 32, offset: 4448)
!758 = !DIDerivedType(tag: DW_TAG_member, name: "height", scope: !644, file: !17, line: 1078, baseType: !24, size: 32, offset: 4480)
!759 = !DIDerivedType(tag: DW_TAG_member, name: "num_rows", scope: !644, file: !17, line: 1079, baseType: !24, size: 32, offset: 4512)
!760 = !DIDerivedType(tag: DW_TAG_member, name: "usr_width", scope: !644, file: !17, line: 1080, baseType: !24, size: 32, offset: 4544)
!761 = !DIDerivedType(tag: DW_TAG_member, name: "rowbytes", scope: !644, file: !17, line: 1081, baseType: !30, size: 64, offset: 4608)
!762 = !DIDerivedType(tag: DW_TAG_member, name: "user_chunk_malloc_max", scope: !644, file: !17, line: 1092, baseType: !763, size: 64, offset: 4672)
!763 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_alloc_size_t", file: !25, line: 1526, baseType: !30)
!764 = !DIDerivedType(tag: DW_TAG_member, name: "iwidth", scope: !644, file: !17, line: 1094, baseType: !24, size: 32, offset: 4736)
!765 = !DIDerivedType(tag: DW_TAG_member, name: "row_number", scope: !644, file: !17, line: 1096, baseType: !24, size: 32, offset: 4768)
!766 = !DIDerivedType(tag: DW_TAG_member, name: "prev_row", scope: !644, file: !17, line: 1097, baseType: !102, size: 64, offset: 4800)
!767 = !DIDerivedType(tag: DW_TAG_member, name: "row_buf", scope: !644, file: !17, line: 1099, baseType: !102, size: 64, offset: 4864)
!768 = !DIDerivedType(tag: DW_TAG_member, name: "sub_row", scope: !644, file: !17, line: 1101, baseType: !102, size: 64, offset: 4928)
!769 = !DIDerivedType(tag: DW_TAG_member, name: "up_row", scope: !644, file: !17, line: 1103, baseType: !102, size: 64, offset: 4992)
!770 = !DIDerivedType(tag: DW_TAG_member, name: "avg_row", scope: !644, file: !17, line: 1105, baseType: !102, size: 64, offset: 5056)
!771 = !DIDerivedType(tag: DW_TAG_member, name: "paeth_row", scope: !644, file: !17, line: 1107, baseType: !102, size: 64, offset: 5120)
!772 = !DIDerivedType(tag: DW_TAG_member, name: "row_info", scope: !644, file: !17, line: 1109, baseType: !698, size: 192, offset: 5184)
!773 = !DIDerivedType(tag: DW_TAG_member, name: "idat_size", scope: !644, file: !17, line: 1112, baseType: !24, size: 32, offset: 5376)
!774 = !DIDerivedType(tag: DW_TAG_member, name: "crc", scope: !644, file: !17, line: 1113, baseType: !24, size: 32, offset: 5408)
!775 = !DIDerivedType(tag: DW_TAG_member, name: "palette", scope: !644, file: !17, line: 1114, baseType: !35, size: 64, offset: 5440)
!776 = !DIDerivedType(tag: DW_TAG_member, name: "num_palette", scope: !644, file: !17, line: 1115, baseType: !46, size: 16, offset: 5504)
!777 = !DIDerivedType(tag: DW_TAG_member, name: "num_trans", scope: !644, file: !17, line: 1117, baseType: !46, size: 16, offset: 5520)
!778 = !DIDerivedType(tag: DW_TAG_member, name: "chunk_name", scope: !644, file: !17, line: 1118, baseType: !149, size: 40, offset: 5536)
!779 = !DIDerivedType(tag: DW_TAG_member, name: "compression", scope: !644, file: !17, line: 1120, baseType: !41, size: 8, offset: 5576)
!780 = !DIDerivedType(tag: DW_TAG_member, name: "filter", scope: !644, file: !17, line: 1122, baseType: !41, size: 8, offset: 5584)
!781 = !DIDerivedType(tag: DW_TAG_member, name: "interlaced", scope: !644, file: !17, line: 1123, baseType: !41, size: 8, offset: 5592)
!782 = !DIDerivedType(tag: DW_TAG_member, name: "pass", scope: !644, file: !17, line: 1125, baseType: !41, size: 8, offset: 5600)
!783 = !DIDerivedType(tag: DW_TAG_member, name: "do_filter", scope: !644, file: !17, line: 1126, baseType: !41, size: 8, offset: 5608)
!784 = !DIDerivedType(tag: DW_TAG_member, name: "color_type", scope: !644, file: !17, line: 1128, baseType: !41, size: 8, offset: 5616)
!785 = !DIDerivedType(tag: DW_TAG_member, name: "bit_depth", scope: !644, file: !17, line: 1129, baseType: !41, size: 8, offset: 5624)
!786 = !DIDerivedType(tag: DW_TAG_member, name: "usr_bit_depth", scope: !644, file: !17, line: 1130, baseType: !41, size: 8, offset: 5632)
!787 = !DIDerivedType(tag: DW_TAG_member, name: "pixel_depth", scope: !644, file: !17, line: 1131, baseType: !41, size: 8, offset: 5640)
!788 = !DIDerivedType(tag: DW_TAG_member, name: "channels", scope: !644, file: !17, line: 1132, baseType: !41, size: 8, offset: 5648)
!789 = !DIDerivedType(tag: DW_TAG_member, name: "usr_channels", scope: !644, file: !17, line: 1133, baseType: !41, size: 8, offset: 5656)
!790 = !DIDerivedType(tag: DW_TAG_member, name: "sig_bytes", scope: !644, file: !17, line: 1134, baseType: !41, size: 8, offset: 5664)
!791 = !DIDerivedType(tag: DW_TAG_member, name: "filler", scope: !644, file: !17, line: 1138, baseType: !46, size: 16, offset: 5680)
!792 = !DIDerivedType(tag: DW_TAG_member, name: "background_gamma_type", scope: !644, file: !17, line: 1143, baseType: !41, size: 8, offset: 5696)
!793 = !DIDerivedType(tag: DW_TAG_member, name: "background_gamma", scope: !644, file: !17, line: 1145, baseType: !62, size: 32, offset: 5728)
!794 = !DIDerivedType(tag: DW_TAG_member, name: "background", scope: !644, file: !17, line: 1147, baseType: !105, size: 80, offset: 5760)
!795 = !DIDerivedType(tag: DW_TAG_member, name: "background_1", scope: !644, file: !17, line: 1150, baseType: !105, size: 80, offset: 5840)
!796 = !DIDerivedType(tag: DW_TAG_member, name: "output_flush_fn", scope: !644, file: !17, line: 1156, baseType: !797, size: 64, offset: 5952)
!797 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_flush_ptr", file: !17, line: 944, baseType: !798)
!798 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !799, size: 64)
!799 = !DISubroutineType(types: !800)
!800 = !{null, !678}
!801 = !DIDerivedType(tag: DW_TAG_member, name: "flush_dist", scope: !644, file: !17, line: 1158, baseType: !24, size: 32, offset: 6016)
!802 = !DIDerivedType(tag: DW_TAG_member, name: "flush_rows", scope: !644, file: !17, line: 1160, baseType: !24, size: 32, offset: 6048)
!803 = !DIDerivedType(tag: DW_TAG_member, name: "gamma_shift", scope: !644, file: !17, line: 1165, baseType: !7, size: 32, offset: 6080)
!804 = !DIDerivedType(tag: DW_TAG_member, name: "gamma", scope: !644, file: !17, line: 1168, baseType: !62, size: 32, offset: 6112)
!805 = !DIDerivedType(tag: DW_TAG_member, name: "screen_gamma", scope: !644, file: !17, line: 1169, baseType: !62, size: 32, offset: 6144)
!806 = !DIDerivedType(tag: DW_TAG_member, name: "gamma_table", scope: !644, file: !17, line: 1175, baseType: !102, size: 64, offset: 6208)
!807 = !DIDerivedType(tag: DW_TAG_member, name: "gamma_from_1", scope: !644, file: !17, line: 1177, baseType: !102, size: 64, offset: 6272)
!808 = !DIDerivedType(tag: DW_TAG_member, name: "gamma_to_1", scope: !644, file: !17, line: 1178, baseType: !102, size: 64, offset: 6336)
!809 = !DIDerivedType(tag: DW_TAG_member, name: "gamma_16_table", scope: !644, file: !17, line: 1179, baseType: !810, size: 64, offset: 6400)
!810 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_uint_16pp", file: !25, line: 1226, baseType: !811)
!811 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !123, size: 64)
!812 = !DIDerivedType(tag: DW_TAG_member, name: "gamma_16_from_1", scope: !644, file: !17, line: 1181, baseType: !810, size: 64, offset: 6464)
!813 = !DIDerivedType(tag: DW_TAG_member, name: "gamma_16_to_1", scope: !644, file: !17, line: 1183, baseType: !810, size: 64, offset: 6528)
!814 = !DIDerivedType(tag: DW_TAG_member, name: "sig_bit", scope: !644, file: !17, line: 1187, baseType: !93, size: 40, offset: 6592)
!815 = !DIDerivedType(tag: DW_TAG_member, name: "shift", scope: !644, file: !17, line: 1192, baseType: !93, size: 40, offset: 6632)
!816 = !DIDerivedType(tag: DW_TAG_member, name: "trans_alpha", scope: !644, file: !17, line: 1198, baseType: !102, size: 64, offset: 6720)
!817 = !DIDerivedType(tag: DW_TAG_member, name: "trans_color", scope: !644, file: !17, line: 1200, baseType: !105, size: 80, offset: 6784)
!818 = !DIDerivedType(tag: DW_TAG_member, name: "read_row_fn", scope: !644, file: !17, line: 1204, baseType: !819, size: 64, offset: 6912)
!819 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_read_status_ptr", file: !17, line: 945, baseType: !820)
!820 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !821, size: 64)
!821 = !DISubroutineType(types: !822)
!822 = !{null, !678, !24, !7}
!823 = !DIDerivedType(tag: DW_TAG_member, name: "write_row_fn", scope: !644, file: !17, line: 1206, baseType: !824, size: 64, offset: 6976)
!824 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_write_status_ptr", file: !17, line: 947, baseType: !820)
!825 = !DIDerivedType(tag: DW_TAG_member, name: "info_fn", scope: !644, file: !17, line: 1209, baseType: !826, size: 64, offset: 7040)
!826 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_progressive_info_ptr", file: !17, line: 951, baseType: !827)
!827 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !828, size: 64)
!828 = !DISubroutineType(types: !829)
!829 = !{null, !678, !830}
!830 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_infop", file: !17, line: 818, baseType: !19)
!831 = !DIDerivedType(tag: DW_TAG_member, name: "row_fn", scope: !644, file: !17, line: 1211, baseType: !832, size: 64, offset: 7104)
!832 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_progressive_row_ptr", file: !17, line: 954, baseType: !833)
!833 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !834, size: 64)
!834 = !DISubroutineType(types: !835)
!835 = !{null, !678, !102, !24, !7}
!836 = !DIDerivedType(tag: DW_TAG_member, name: "end_fn", scope: !644, file: !17, line: 1213, baseType: !837, size: 64, offset: 7168)
!837 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_progressive_end_ptr", file: !17, line: 953, baseType: !827)
!838 = !DIDerivedType(tag: DW_TAG_member, name: "save_buffer_ptr", scope: !644, file: !17, line: 1215, baseType: !102, size: 64, offset: 7232)
!839 = !DIDerivedType(tag: DW_TAG_member, name: "save_buffer", scope: !644, file: !17, line: 1217, baseType: !102, size: 64, offset: 7296)
!840 = !DIDerivedType(tag: DW_TAG_member, name: "current_buffer_ptr", scope: !644, file: !17, line: 1219, baseType: !102, size: 64, offset: 7360)
!841 = !DIDerivedType(tag: DW_TAG_member, name: "current_buffer", scope: !644, file: !17, line: 1221, baseType: !102, size: 64, offset: 7424)
!842 = !DIDerivedType(tag: DW_TAG_member, name: "push_length", scope: !644, file: !17, line: 1223, baseType: !24, size: 32, offset: 7488)
!843 = !DIDerivedType(tag: DW_TAG_member, name: "skip_length", scope: !644, file: !17, line: 1225, baseType: !24, size: 32, offset: 7520)
!844 = !DIDerivedType(tag: DW_TAG_member, name: "save_buffer_size", scope: !644, file: !17, line: 1227, baseType: !30, size: 64, offset: 7552)
!845 = !DIDerivedType(tag: DW_TAG_member, name: "save_buffer_max", scope: !644, file: !17, line: 1229, baseType: !30, size: 64, offset: 7616)
!846 = !DIDerivedType(tag: DW_TAG_member, name: "buffer_size", scope: !644, file: !17, line: 1231, baseType: !30, size: 64, offset: 7680)
!847 = !DIDerivedType(tag: DW_TAG_member, name: "current_buffer_size", scope: !644, file: !17, line: 1233, baseType: !30, size: 64, offset: 7744)
!848 = !DIDerivedType(tag: DW_TAG_member, name: "process_mode", scope: !644, file: !17, line: 1235, baseType: !7, size: 32, offset: 7808)
!849 = !DIDerivedType(tag: DW_TAG_member, name: "cur_palette", scope: !644, file: !17, line: 1237, baseType: !7, size: 32, offset: 7840)
!850 = !DIDerivedType(tag: DW_TAG_member, name: "current_text_size", scope: !644, file: !17, line: 1241, baseType: !30, size: 64, offset: 7872)
!851 = !DIDerivedType(tag: DW_TAG_member, name: "current_text_left", scope: !644, file: !17, line: 1243, baseType: !30, size: 64, offset: 7936)
!852 = !DIDerivedType(tag: DW_TAG_member, name: "current_text", scope: !644, file: !17, line: 1245, baseType: !74, size: 64, offset: 8000)
!853 = !DIDerivedType(tag: DW_TAG_member, name: "current_text_ptr", scope: !644, file: !17, line: 1247, baseType: !74, size: 64, offset: 8064)
!854 = !DIDerivedType(tag: DW_TAG_member, name: "palette_lookup", scope: !644, file: !17, line: 1263, baseType: !102, size: 64, offset: 8128)
!855 = !DIDerivedType(tag: DW_TAG_member, name: "quantize_index", scope: !644, file: !17, line: 1264, baseType: !102, size: 64, offset: 8192)
!856 = !DIDerivedType(tag: DW_TAG_member, name: "hist", scope: !644, file: !17, line: 1269, baseType: !122, size: 64, offset: 8256)
!857 = !DIDerivedType(tag: DW_TAG_member, name: "time_buffer", scope: !644, file: !17, line: 1273, baseType: !74, size: 64, offset: 8320)
!858 = !DIDerivedType(tag: DW_TAG_member, name: "free_me", scope: !644, file: !17, line: 1278, baseType: !24, size: 32, offset: 8384)
!859 = !DIDerivedType(tag: DW_TAG_member, name: "user_chunk_ptr", scope: !644, file: !17, line: 1282, baseType: !683, size: 64, offset: 8448)
!860 = !DIDerivedType(tag: DW_TAG_member, name: "read_user_chunk_fn", scope: !644, file: !17, line: 1283, baseType: !861, size: 64, offset: 8512)
!861 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_user_chunk_ptr", file: !17, line: 965, baseType: !862)
!862 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !863, size: 64)
!863 = !DISubroutineType(types: !864)
!864 = !{!7, !678, !143}
!865 = !DIDerivedType(tag: DW_TAG_member, name: "num_chunk_list", scope: !644, file: !17, line: 1288, baseType: !7, size: 32, offset: 8576)
!866 = !DIDerivedType(tag: DW_TAG_member, name: "chunk_list", scope: !644, file: !17, line: 1289, baseType: !102, size: 64, offset: 8640)
!867 = !DIDerivedType(tag: DW_TAG_member, name: "rgb_to_gray_status", scope: !644, file: !17, line: 1294, baseType: !41, size: 8, offset: 8704)
!868 = !DIDerivedType(tag: DW_TAG_member, name: "rgb_to_gray_red_coeff", scope: !644, file: !17, line: 1296, baseType: !46, size: 16, offset: 8720)
!869 = !DIDerivedType(tag: DW_TAG_member, name: "rgb_to_gray_green_coeff", scope: !644, file: !17, line: 1297, baseType: !46, size: 16, offset: 8736)
!870 = !DIDerivedType(tag: DW_TAG_member, name: "rgb_to_gray_blue_coeff", scope: !644, file: !17, line: 1298, baseType: !46, size: 16, offset: 8752)
!871 = !DIDerivedType(tag: DW_TAG_member, name: "mng_features_permitted", scope: !644, file: !17, line: 1306, baseType: !24, size: 32, offset: 8768)
!872 = !DIDerivedType(tag: DW_TAG_member, name: "int_gamma", scope: !644, file: !17, line: 1311, baseType: !191, size: 32, offset: 8800)
!873 = !DIDerivedType(tag: DW_TAG_member, name: "filter_type", scope: !644, file: !17, line: 1316, baseType: !41, size: 8, offset: 8832)
!874 = !DIDerivedType(tag: DW_TAG_member, name: "mem_ptr", scope: !644, file: !17, line: 1323, baseType: !683, size: 64, offset: 8896)
!875 = !DIDerivedType(tag: DW_TAG_member, name: "malloc_fn", scope: !644, file: !17, line: 1325, baseType: !876, size: 64, offset: 8960)
!876 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_malloc_ptr", file: !17, line: 1004, baseType: !877)
!877 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !878, size: 64)
!878 = !DISubroutineType(types: !879)
!879 = !{!683, !678, !763}
!880 = !DIDerivedType(tag: DW_TAG_member, name: "free_fn", scope: !644, file: !17, line: 1327, baseType: !881, size: 64, offset: 9024)
!881 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_free_ptr", file: !17, line: 1005, baseType: !882)
!882 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !883, size: 64)
!883 = !DISubroutineType(types: !884)
!884 = !{null, !678, !683}
!885 = !DIDerivedType(tag: DW_TAG_member, name: "big_row_buf", scope: !644, file: !17, line: 1332, baseType: !102, size: 64, offset: 9088)
!886 = !DIDerivedType(tag: DW_TAG_member, name: "quantize_sort", scope: !644, file: !17, line: 1337, baseType: !102, size: 64, offset: 9152)
!887 = !DIDerivedType(tag: DW_TAG_member, name: "index_to_palette", scope: !644, file: !17, line: 1338, baseType: !102, size: 64, offset: 9216)
!888 = !DIDerivedType(tag: DW_TAG_member, name: "palette_to_index", scope: !644, file: !17, line: 1341, baseType: !102, size: 64, offset: 9280)
!889 = !DIDerivedType(tag: DW_TAG_member, name: "compression_type", scope: !644, file: !17, line: 1347, baseType: !41, size: 8, offset: 9344)
!890 = !DIDerivedType(tag: DW_TAG_member, name: "user_width_max", scope: !644, file: !17, line: 1350, baseType: !24, size: 32, offset: 9376)
!891 = !DIDerivedType(tag: DW_TAG_member, name: "user_height_max", scope: !644, file: !17, line: 1351, baseType: !24, size: 32, offset: 9408)
!892 = !DIDerivedType(tag: DW_TAG_member, name: "user_chunk_cache_max", scope: !644, file: !17, line: 1355, baseType: !24, size: 32, offset: 9440)
!893 = !DIDerivedType(tag: DW_TAG_member, name: "unknown_chunk", scope: !644, file: !17, line: 1361, baseType: !145, size: 256, offset: 9472)
!894 = !DIDerivedType(tag: DW_TAG_member, name: "old_big_row_buf_size", scope: !644, file: !17, line: 1365, baseType: !24, size: 32, offset: 9728)
!895 = !DIDerivedType(tag: DW_TAG_member, name: "old_prev_row_size", scope: !644, file: !17, line: 1366, baseType: !24, size: 32, offset: 9760)
!896 = !DIDerivedType(tag: DW_TAG_member, name: "chunkdata", scope: !644, file: !17, line: 1369, baseType: !74, size: 64, offset: 9792)
!897 = !DIDerivedType(tag: DW_TAG_member, name: "io_state", scope: !644, file: !17, line: 1373, baseType: !24, size: 32, offset: 9856)
!898 = !DILocation(line: 122, column: 17, scope: !573)
!899 = !DILocation(line: 122, column: 27, scope: !573)
!900 = !DILocalVariable(name: "info_ptr", scope: !573, file: !13, line: 123, type: !19)
!901 = !DILocation(line: 123, column: 15, scope: !573)
!902 = !DILocation(line: 123, column: 26, scope: !573)
!903 = !DILocalVariable(name: "p", scope: !573, file: !13, line: 124, type: !7)
!904 = !DILocation(line: 124, column: 9, scope: !573)
!905 = !DILocalVariable(name: "gray_bitdepth", scope: !573, file: !13, line: 125, type: !7)
!906 = !DILocation(line: 125, column: 9, scope: !573)
!907 = !DILocalVariable(name: "pal_rgb", scope: !573, file: !13, line: 126, type: !908)
!908 = !DICompositeType(tag: DW_TAG_array_type, baseType: !37, size: 6144, elements: !8)
!909 = !DILocation(line: 126, column: 15, scope: !573)
!910 = !DILocalVariable(name: "pltep", scope: !573, file: !13, line: 126, type: !36)
!911 = !DILocation(line: 126, column: 36, scope: !573)
!912 = !DILocalVariable(name: "pal_trans", scope: !573, file: !13, line: 127, type: !913)
!913 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 2048, elements: !8)
!914 = !DILocation(line: 127, column: 14, scope: !573)
!915 = !DILocalVariable(name: "color16trans", scope: !573, file: !13, line: 128, type: !105)
!916 = !DILocation(line: 128, column: 18, scope: !573)
!917 = !DILocalVariable(name: "color16back", scope: !573, file: !13, line: 128, type: !105)
!918 = !DILocation(line: 128, column: 32, scope: !573)
!919 = !DILocalVariable(name: "buffer", scope: !573, file: !13, line: 129, type: !920)
!920 = !DICompositeType(tag: DW_TAG_array_type, baseType: !200, size: 192, elements: !921)
!921 = !{!922}
!922 = !DISubrange(count: 24)
!923 = !DILocation(line: 129, column: 10, scope: !573)
!924 = !DILocalVariable(name: "j", scope: !573, file: !13, line: 130, type: !7)
!925 = !DILocation(line: 130, column: 9, scope: !573)
!926 = !DILocalVariable(name: "histogr", scope: !573, file: !13, line: 131, type: !927)
!927 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 4096, elements: !8)
!928 = !DILocation(line: 131, column: 17, scope: !573)
!929 = !DILocalVariable(name: "hist_maxvalue", scope: !573, file: !13, line: 132, type: !33)
!930 = !DILocation(line: 132, column: 19, scope: !573)
!931 = !DILocalVariable(name: "passcount", scope: !573, file: !13, line: 133, type: !7)
!932 = !DILocation(line: 133, column: 9, scope: !573)
!933 = !DILocalVariable(name: "errtype", scope: !573, file: !13, line: 134, type: !7)
!934 = !DILocation(line: 134, column: 9, scope: !573)
!935 = !DILocalVariable(name: "errorcount", scope: !573, file: !13, line: 134, type: !7)
!936 = !DILocation(line: 134, column: 18, scope: !573)
!937 = !DILocalVariable(name: "software", scope: !573, file: !13, line: 135, type: !69)
!938 = !DILocation(line: 135, column: 14, scope: !573)
!939 = !DILocalVariable(name: "comment", scope: !573, file: !13, line: 136, type: !69)
!940 = !DILocation(line: 136, column: 14, scope: !573)
!941 = !DILocalVariable(name: "gray", scope: !573, file: !13, line: 140, type: !942)
!942 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !7)
!943 = !DILocation(line: 140, column: 18, scope: !573)
!944 = !DILocalVariable(name: "last_color", scope: !573, file: !13, line: 141, type: !942)
!945 = !DILocation(line: 141, column: 18, scope: !573)
!946 = !DILocalVariable(name: "remapping", scope: !573, file: !13, line: 142, type: !942)
!947 = !DILocation(line: 142, column: 18, scope: !573)
!948 = !DILocalVariable(name: "bitdepth", scope: !573, file: !13, line: 143, type: !942)
!949 = !DILocation(line: 143, column: 18, scope: !573)
!950 = !DILocation(line: 146, column: 9, scope: !951)
!951 = distinct !DILexicalBlock(scope: !573, file: !13, line: 146, column: 9)
!952 = !DILocation(line: 146, column: 14, scope: !951)
!953 = !DILocation(line: 146, column: 20, scope: !951)
!954 = !DILocation(line: 146, column: 26, scope: !951)
!955 = !DILocation(line: 146, column: 30, scope: !951)
!956 = !DILocation(line: 146, column: 36, scope: !951)
!957 = !DILocation(line: 146, column: 41, scope: !951)
!958 = !DILocation(line: 146, column: 9, scope: !573)
!959 = !DILocation(line: 147, column: 2, scope: !951)
!960 = !DILocation(line: 147, column: 7, scope: !951)
!961 = !DILocation(line: 147, column: 13, scope: !951)
!962 = !DILocation(line: 149, column: 9, scope: !963)
!963 = distinct !DILexicalBlock(scope: !573, file: !13, line: 149, column: 9)
!964 = !DILocation(line: 149, column: 9, scope: !573)
!965 = !DILocation(line: 151, column: 9, scope: !966)
!966 = distinct !DILexicalBlock(scope: !967, file: !13, line: 151, column: 2)
!967 = distinct !DILexicalBlock(scope: !963, file: !13, line: 149, column: 19)
!968 = !DILocation(line: 151, column: 7, scope: !966)
!969 = !DILocation(line: 151, column: 14, scope: !970)
!970 = distinct !DILexicalBlock(scope: !966, file: !13, line: 151, column: 2)
!971 = !DILocation(line: 151, column: 16, scope: !970)
!972 = !DILocation(line: 151, column: 2, scope: !966)
!973 = !DILocation(line: 152, column: 10, scope: !974)
!974 = distinct !DILexicalBlock(scope: !970, file: !13, line: 152, column: 9)
!975 = !DILocation(line: 152, column: 16, scope: !974)
!976 = !DILocation(line: 152, column: 9, scope: !970)
!977 = !DILocation(line: 153, column: 37, scope: !974)
!978 = !DILocation(line: 153, column: 44, scope: !974)
!979 = !DILocation(line: 153, column: 47, scope: !974)
!980 = !DILocation(line: 153, column: 52, scope: !974)
!981 = !DILocation(line: 153, column: 19, scope: !974)
!982 = !DILocation(line: 153, column: 26, scope: !974)
!983 = !DILocation(line: 153, column: 29, scope: !974)
!984 = !DILocation(line: 153, column: 35, scope: !974)
!985 = !DILocation(line: 153, column: 3, scope: !974)
!986 = !DILocation(line: 153, column: 10, scope: !974)
!987 = !DILocation(line: 153, column: 13, scope: !974)
!988 = !DILocation(line: 153, column: 17, scope: !974)
!989 = !DILocation(line: 152, column: 17, scope: !974)
!990 = !DILocation(line: 151, column: 30, scope: !970)
!991 = !DILocation(line: 151, column: 2, scope: !970)
!992 = distinct !{!992, !972, !993}
!993 = !DILocation(line: 153, column: 54, scope: !966)
!994 = !DILocation(line: 160, column: 5, scope: !967)
!995 = !DILocation(line: 160, column: 17, scope: !996)
!996 = distinct !DILexicalBlock(scope: !963, file: !13, line: 160, column: 16)
!997 = !DILocation(line: 160, column: 16, scope: !963)
!998 = !DILocalVariable(name: "unused", scope: !999, file: !13, line: 162, type: !7)
!999 = distinct !DILexicalBlock(scope: !996, file: !13, line: 160, column: 26)
!1000 = !DILocation(line: 162, column: 6, scope: !999)
!1001 = !DILocation(line: 164, column: 9, scope: !1002)
!1002 = distinct !DILexicalBlock(scope: !999, file: !13, line: 164, column: 2)
!1003 = !DILocation(line: 164, column: 7, scope: !1002)
!1004 = !DILocation(line: 164, column: 14, scope: !1005)
!1005 = distinct !DILexicalBlock(scope: !1002, file: !13, line: 164, column: 2)
!1006 = !DILocation(line: 164, column: 16, scope: !1005)
!1007 = !DILocation(line: 164, column: 2, scope: !1002)
!1008 = !DILocation(line: 165, column: 11, scope: !1009)
!1009 = distinct !DILexicalBlock(scope: !1005, file: !13, line: 165, column: 10)
!1010 = !DILocation(line: 165, column: 17, scope: !1009)
!1011 = !DILocation(line: 165, column: 10, scope: !1005)
!1012 = !DILocation(line: 166, column: 9, scope: !1009)
!1013 = !DILocation(line: 166, column: 3, scope: !1009)
!1014 = !DILocation(line: 165, column: 18, scope: !1009)
!1015 = !DILocation(line: 164, column: 30, scope: !1005)
!1016 = !DILocation(line: 164, column: 2, scope: !1005)
!1017 = distinct !{!1017, !1007, !1018}
!1018 = !DILocation(line: 166, column: 9, scope: !1002)
!1019 = !DILocation(line: 168, column: 6, scope: !1020)
!1020 = distinct !DILexicalBlock(scope: !999, file: !13, line: 168, column: 6)
!1021 = !DILocation(line: 168, column: 6, scope: !999)
!1022 = !DILocation(line: 170, column: 14, scope: !1023)
!1023 = distinct !DILexicalBlock(scope: !1020, file: !13, line: 169, column: 2)
!1024 = !DILocation(line: 172, column: 7, scope: !1023)
!1025 = !DILocation(line: 170, column: 6, scope: !1023)
!1026 = !DILocation(line: 173, column: 16, scope: !1023)
!1027 = !DILocation(line: 174, column: 2, scope: !1023)
!1028 = !DILocation(line: 175, column: 5, scope: !999)
!1029 = !DILocation(line: 177, column: 12, scope: !1030)
!1030 = distinct !DILexicalBlock(scope: !573, file: !13, line: 177, column: 5)
!1031 = !DILocation(line: 177, column: 10, scope: !1030)
!1032 = !DILocation(line: 177, column: 17, scope: !1033)
!1033 = distinct !DILexicalBlock(scope: !1030, file: !13, line: 177, column: 5)
!1034 = !DILocation(line: 177, column: 19, scope: !1033)
!1035 = !DILocation(line: 177, column: 5, scope: !1030)
!1036 = !DILocation(line: 178, column: 6, scope: !1037)
!1037 = distinct !DILexicalBlock(scope: !1033, file: !13, line: 178, column: 6)
!1038 = !DILocation(line: 178, column: 12, scope: !1037)
!1039 = !DILocation(line: 178, column: 6, scope: !1033)
!1040 = !DILocation(line: 179, column: 22, scope: !1041)
!1041 = distinct !DILexicalBlock(scope: !1037, file: !13, line: 178, column: 16)
!1042 = !DILocation(line: 179, column: 29, scope: !1041)
!1043 = !DILocation(line: 179, column: 14, scope: !1041)
!1044 = !DILocation(line: 179, column: 11, scope: !1041)
!1045 = !DILocation(line: 180, column: 17, scope: !1041)
!1046 = !DILocation(line: 181, column: 10, scope: !1047)
!1047 = distinct !DILexicalBlock(scope: !1041, file: !13, line: 181, column: 10)
!1048 = !DILocation(line: 181, column: 23, scope: !1047)
!1049 = !DILocation(line: 181, column: 21, scope: !1047)
!1050 = !DILocation(line: 181, column: 10, scope: !1041)
!1051 = !DILocation(line: 182, column: 16, scope: !1047)
!1052 = !DILocation(line: 182, column: 14, scope: !1047)
!1053 = !DILocation(line: 182, column: 3, scope: !1047)
!1054 = !DILocation(line: 183, column: 2, scope: !1041)
!1055 = !DILocation(line: 178, column: 13, scope: !1037)
!1056 = !DILocation(line: 177, column: 33, scope: !1033)
!1057 = !DILocation(line: 177, column: 5, scope: !1033)
!1058 = distinct !{!1058, !1035, !1059}
!1059 = !DILocation(line: 183, column: 2, scope: !1030)
!1060 = !DILocation(line: 185, column: 9, scope: !1061)
!1061 = distinct !DILexicalBlock(scope: !573, file: !13, line: 185, column: 9)
!1062 = !DILocation(line: 185, column: 9, scope: !573)
!1063 = !DILocation(line: 186, column: 6, scope: !1064)
!1064 = distinct !DILexicalBlock(scope: !1065, file: !13, line: 186, column: 6)
!1065 = distinct !DILexicalBlock(scope: !1061, file: !13, line: 185, column: 15)
!1066 = !DILocation(line: 186, column: 14, scope: !1064)
!1067 = !DILocation(line: 186, column: 6, scope: !1065)
!1068 = !DILocation(line: 187, column: 14, scope: !1064)
!1069 = !DILocation(line: 187, column: 6, scope: !1064)
!1070 = !DILocation(line: 189, column: 6, scope: !1071)
!1071 = distinct !DILexicalBlock(scope: !1065, file: !13, line: 189, column: 6)
!1072 = !DILocation(line: 189, column: 11, scope: !1071)
!1073 = !DILocation(line: 189, column: 17, scope: !1071)
!1074 = !DILocation(line: 189, column: 6, scope: !1065)
!1075 = !DILocation(line: 190, column: 13, scope: !1076)
!1076 = distinct !DILexicalBlock(scope: !1077, file: !13, line: 190, column: 6)
!1077 = distinct !DILexicalBlock(scope: !1071, file: !13, line: 189, column: 24)
!1078 = !DILocation(line: 190, column: 11, scope: !1076)
!1079 = !DILocation(line: 190, column: 18, scope: !1080)
!1080 = distinct !DILexicalBlock(scope: !1076, file: !13, line: 190, column: 6)
!1081 = !DILocation(line: 190, column: 20, scope: !1080)
!1082 = !DILocation(line: 190, column: 6, scope: !1076)
!1083 = !DILocation(line: 191, column: 7, scope: !1084)
!1084 = distinct !DILexicalBlock(scope: !1085, file: !13, line: 191, column: 7)
!1085 = distinct !DILexicalBlock(scope: !1080, file: !13, line: 190, column: 38)
!1086 = !DILocation(line: 191, column: 10, scope: !1084)
!1087 = !DILocation(line: 191, column: 15, scope: !1084)
!1088 = !DILocation(line: 191, column: 8, scope: !1084)
!1089 = !DILocation(line: 191, column: 21, scope: !1084)
!1090 = !DILocation(line: 191, column: 24, scope: !1084)
!1091 = !DILocation(line: 191, column: 31, scope: !1084)
!1092 = !DILocation(line: 191, column: 34, scope: !1084)
!1093 = !DILocation(line: 191, column: 41, scope: !1084)
!1094 = !DILocation(line: 191, column: 48, scope: !1084)
!1095 = !DILocation(line: 191, column: 53, scope: !1084)
!1096 = !DILocation(line: 191, column: 60, scope: !1084)
!1097 = !DILocation(line: 191, column: 38, scope: !1084)
!1098 = !DILocation(line: 191, column: 7, scope: !1085)
!1099 = !DILocation(line: 192, column: 12, scope: !1100)
!1100 = distinct !DILexicalBlock(scope: !1084, file: !13, line: 191, column: 65)
!1101 = !DILocation(line: 193, column: 11, scope: !1102)
!1102 = distinct !DILexicalBlock(scope: !1100, file: !13, line: 193, column: 11)
!1103 = !DILocation(line: 193, column: 19, scope: !1102)
!1104 = !DILocation(line: 193, column: 11, scope: !1100)
!1105 = !DILocation(line: 194, column: 12, scope: !1102)
!1106 = !DILocation(line: 194, column: 4, scope: !1102)
!1107 = !DILocation(line: 196, column: 7, scope: !1100)
!1108 = !DILocation(line: 198, column: 6, scope: !1085)
!1109 = !DILocation(line: 190, column: 34, scope: !1080)
!1110 = !DILocation(line: 190, column: 6, scope: !1080)
!1111 = distinct !{!1111, !1082, !1112}
!1112 = !DILocation(line: 198, column: 6, scope: !1076)
!1113 = !DILocation(line: 199, column: 2, scope: !1077)
!1114 = !DILocation(line: 200, column: 5, scope: !1065)
!1115 = !DILocation(line: 202, column: 14, scope: !573)
!1116 = !DILocation(line: 203, column: 9, scope: !1117)
!1117 = distinct !DILexicalBlock(scope: !573, file: !13, line: 203, column: 9)
!1118 = !DILocation(line: 203, column: 19, scope: !1117)
!1119 = !DILocation(line: 203, column: 9, scope: !573)
!1120 = !DILocation(line: 203, column: 33, scope: !1117)
!1121 = !DILocation(line: 203, column: 24, scope: !1117)
!1122 = !DILocation(line: 204, column: 9, scope: !1123)
!1123 = distinct !DILexicalBlock(scope: !573, file: !13, line: 204, column: 9)
!1124 = !DILocation(line: 204, column: 19, scope: !1123)
!1125 = !DILocation(line: 204, column: 9, scope: !573)
!1126 = !DILocation(line: 204, column: 32, scope: !1123)
!1127 = !DILocation(line: 204, column: 23, scope: !1123)
!1128 = !DILocation(line: 205, column: 9, scope: !1129)
!1129 = distinct !DILexicalBlock(scope: !573, file: !13, line: 205, column: 9)
!1130 = !DILocation(line: 205, column: 19, scope: !1129)
!1131 = !DILocation(line: 205, column: 9, scope: !573)
!1132 = !DILocation(line: 205, column: 32, scope: !1129)
!1133 = !DILocation(line: 205, column: 23, scope: !1129)
!1134 = !DILocation(line: 207, column: 9, scope: !1135)
!1135 = distinct !DILexicalBlock(scope: !573, file: !13, line: 207, column: 9)
!1136 = !DILocation(line: 207, column: 9, scope: !573)
!1137 = !DILocation(line: 208, column: 12, scope: !1138)
!1138 = distinct !DILexicalBlock(scope: !1135, file: !13, line: 207, column: 15)
!1139 = !DILocation(line: 209, column: 9, scope: !1140)
!1140 = distinct !DILexicalBlock(scope: !1138, file: !13, line: 209, column: 2)
!1141 = !DILocation(line: 209, column: 7, scope: !1140)
!1142 = !DILocation(line: 209, column: 14, scope: !1143)
!1143 = distinct !DILexicalBlock(scope: !1140, file: !13, line: 209, column: 2)
!1144 = !DILocation(line: 209, column: 16, scope: !1143)
!1145 = !DILocation(line: 209, column: 2, scope: !1140)
!1146 = !DILocation(line: 210, column: 17, scope: !1143)
!1147 = !DILocation(line: 210, column: 24, scope: !1143)
!1148 = !DILocation(line: 210, column: 27, scope: !1143)
!1149 = !DILocation(line: 210, column: 12, scope: !1143)
!1150 = !DILocation(line: 210, column: 6, scope: !1143)
!1151 = !DILocation(line: 210, column: 15, scope: !1143)
!1152 = !DILocation(line: 209, column: 30, scope: !1143)
!1153 = !DILocation(line: 209, column: 2, scope: !1143)
!1154 = distinct !{!1154, !1145, !1155}
!1155 = !DILocation(line: 210, column: 27, scope: !1140)
!1156 = !DILocation(line: 212, column: 16, scope: !1138)
!1157 = !DILocation(line: 216, column: 11, scope: !1138)
!1158 = !DILocation(line: 217, column: 9, scope: !1159)
!1159 = distinct !DILexicalBlock(scope: !1138, file: !13, line: 217, column: 2)
!1160 = !DILocation(line: 217, column: 7, scope: !1159)
!1161 = !DILocation(line: 217, column: 14, scope: !1162)
!1162 = distinct !DILexicalBlock(scope: !1159, file: !13, line: 217, column: 2)
!1163 = !DILocation(line: 217, column: 16, scope: !1162)
!1164 = !DILocation(line: 217, column: 2, scope: !1159)
!1165 = !DILocation(line: 218, column: 17, scope: !1166)
!1166 = distinct !DILexicalBlock(scope: !1167, file: !13, line: 218, column: 10)
!1167 = distinct !DILexicalBlock(scope: !1162, file: !13, line: 217, column: 34)
!1168 = !DILocation(line: 218, column: 11, scope: !1166)
!1169 = !DILocation(line: 218, column: 19, scope: !1166)
!1170 = !DILocation(line: 218, column: 24, scope: !1166)
!1171 = !DILocation(line: 218, column: 39, scope: !1166)
!1172 = !DILocation(line: 218, column: 33, scope: !1166)
!1173 = !DILocation(line: 218, column: 30, scope: !1166)
!1174 = !DILocation(line: 218, column: 10, scope: !1167)
!1175 = !DILocation(line: 219, column: 12, scope: !1176)
!1176 = distinct !DILexicalBlock(scope: !1166, file: !13, line: 218, column: 43)
!1177 = !DILocation(line: 220, column: 3, scope: !1176)
!1178 = !DILocation(line: 222, column: 2, scope: !1167)
!1179 = !DILocation(line: 217, column: 30, scope: !1162)
!1180 = !DILocation(line: 217, column: 2, scope: !1162)
!1181 = distinct !{!1181, !1164, !1182}
!1182 = !DILocation(line: 222, column: 2, scope: !1159)
!1183 = !DILocation(line: 223, column: 6, scope: !1184)
!1184 = distinct !DILexicalBlock(scope: !1138, file: !13, line: 223, column: 6)
!1185 = !DILocation(line: 223, column: 6, scope: !1138)
!1186 = !DILocation(line: 224, column: 13, scope: !1187)
!1187 = distinct !DILexicalBlock(scope: !1188, file: !13, line: 224, column: 6)
!1188 = distinct !DILexicalBlock(scope: !1184, file: !13, line: 223, column: 16)
!1189 = !DILocation(line: 224, column: 11, scope: !1187)
!1190 = !DILocation(line: 224, column: 18, scope: !1191)
!1191 = distinct !DILexicalBlock(scope: !1187, file: !13, line: 224, column: 6)
!1192 = !DILocation(line: 224, column: 20, scope: !1191)
!1193 = !DILocation(line: 224, column: 6, scope: !1187)
!1194 = !DILocation(line: 225, column: 9, scope: !1195)
!1195 = distinct !DILexicalBlock(scope: !1191, file: !13, line: 224, column: 38)
!1196 = !DILocation(line: 225, column: 3, scope: !1195)
!1197 = !DILocation(line: 225, column: 12, scope: !1195)
!1198 = !DILocation(line: 226, column: 6, scope: !1195)
!1199 = !DILocation(line: 224, column: 34, scope: !1191)
!1200 = !DILocation(line: 224, column: 6, scope: !1191)
!1201 = distinct !{!1201, !1193, !1202}
!1202 = !DILocation(line: 226, column: 6, scope: !1187)
!1203 = !DILocation(line: 227, column: 20, scope: !1188)
!1204 = !DILocation(line: 228, column: 2, scope: !1188)
!1205 = !DILocation(line: 232, column: 6, scope: !1206)
!1206 = distinct !DILexicalBlock(scope: !1138, file: !13, line: 232, column: 6)
!1207 = !DILocation(line: 232, column: 6, scope: !1138)
!1208 = !DILocation(line: 233, column: 13, scope: !1209)
!1209 = distinct !DILexicalBlock(scope: !1210, file: !13, line: 233, column: 6)
!1210 = distinct !DILexicalBlock(scope: !1206, file: !13, line: 232, column: 16)
!1211 = !DILocation(line: 233, column: 11, scope: !1209)
!1212 = !DILocation(line: 233, column: 18, scope: !1213)
!1213 = distinct !DILexicalBlock(scope: !1209, file: !13, line: 233, column: 6)
!1214 = !DILocation(line: 233, column: 20, scope: !1213)
!1215 = !DILocation(line: 233, column: 6, scope: !1209)
!1216 = !DILocation(line: 234, column: 14, scope: !1217)
!1217 = distinct !DILexicalBlock(scope: !1218, file: !13, line: 234, column: 7)
!1218 = distinct !DILexicalBlock(scope: !1213, file: !13, line: 233, column: 38)
!1219 = !DILocation(line: 234, column: 8, scope: !1217)
!1220 = !DILocation(line: 234, column: 16, scope: !1217)
!1221 = !DILocation(line: 234, column: 19, scope: !1217)
!1222 = !DILocation(line: 234, column: 31, scope: !1217)
!1223 = !DILocation(line: 234, column: 25, scope: !1217)
!1224 = !DILocation(line: 234, column: 22, scope: !1217)
!1225 = !DILocation(line: 234, column: 7, scope: !1218)
!1226 = !DILocation(line: 235, column: 16, scope: !1227)
!1227 = distinct !DILexicalBlock(scope: !1217, file: !13, line: 234, column: 35)
!1228 = !DILocation(line: 236, column: 7, scope: !1227)
!1229 = !DILocation(line: 238, column: 6, scope: !1218)
!1230 = !DILocation(line: 233, column: 34, scope: !1213)
!1231 = !DILocation(line: 233, column: 6, scope: !1213)
!1232 = distinct !{!1232, !1215, !1233}
!1233 = !DILocation(line: 238, column: 6, scope: !1209)
!1234 = !DILocation(line: 239, column: 2, scope: !1210)
!1235 = !DILocation(line: 241, column: 6, scope: !1236)
!1236 = distinct !DILexicalBlock(scope: !1138, file: !13, line: 241, column: 6)
!1237 = !DILocation(line: 241, column: 6, scope: !1138)
!1238 = !DILocation(line: 242, column: 13, scope: !1239)
!1239 = distinct !DILexicalBlock(scope: !1240, file: !13, line: 242, column: 6)
!1240 = distinct !DILexicalBlock(scope: !1236, file: !13, line: 241, column: 16)
!1241 = !DILocation(line: 242, column: 11, scope: !1239)
!1242 = !DILocation(line: 242, column: 18, scope: !1243)
!1243 = distinct !DILexicalBlock(scope: !1239, file: !13, line: 242, column: 6)
!1244 = !DILocation(line: 242, column: 20, scope: !1243)
!1245 = !DILocation(line: 242, column: 6, scope: !1239)
!1246 = !DILocation(line: 243, column: 9, scope: !1247)
!1247 = distinct !DILexicalBlock(scope: !1243, file: !13, line: 242, column: 38)
!1248 = !DILocation(line: 243, column: 3, scope: !1247)
!1249 = !DILocation(line: 243, column: 12, scope: !1247)
!1250 = !DILocation(line: 244, column: 6, scope: !1247)
!1251 = !DILocation(line: 242, column: 34, scope: !1243)
!1252 = !DILocation(line: 242, column: 6, scope: !1243)
!1253 = distinct !{!1253, !1245, !1254}
!1254 = !DILocation(line: 244, column: 6, scope: !1239)
!1255 = !DILocation(line: 245, column: 20, scope: !1240)
!1256 = !DILocation(line: 246, column: 2, scope: !1240)
!1257 = !DILocation(line: 250, column: 6, scope: !1258)
!1258 = distinct !DILexicalBlock(scope: !1138, file: !13, line: 250, column: 6)
!1259 = !DILocation(line: 250, column: 6, scope: !1138)
!1260 = !DILocation(line: 251, column: 13, scope: !1261)
!1261 = distinct !DILexicalBlock(scope: !1262, file: !13, line: 251, column: 6)
!1262 = distinct !DILexicalBlock(scope: !1258, file: !13, line: 250, column: 16)
!1263 = !DILocation(line: 251, column: 11, scope: !1261)
!1264 = !DILocation(line: 251, column: 18, scope: !1265)
!1265 = distinct !DILexicalBlock(scope: !1261, file: !13, line: 251, column: 6)
!1266 = !DILocation(line: 251, column: 20, scope: !1265)
!1267 = !DILocation(line: 251, column: 6, scope: !1261)
!1268 = !DILocation(line: 252, column: 14, scope: !1269)
!1269 = distinct !DILexicalBlock(scope: !1270, file: !13, line: 252, column: 7)
!1270 = distinct !DILexicalBlock(scope: !1265, file: !13, line: 251, column: 38)
!1271 = !DILocation(line: 252, column: 8, scope: !1269)
!1272 = !DILocation(line: 252, column: 16, scope: !1269)
!1273 = !DILocation(line: 252, column: 19, scope: !1269)
!1274 = !DILocation(line: 252, column: 31, scope: !1269)
!1275 = !DILocation(line: 252, column: 25, scope: !1269)
!1276 = !DILocation(line: 252, column: 22, scope: !1269)
!1277 = !DILocation(line: 252, column: 7, scope: !1270)
!1278 = !DILocation(line: 253, column: 16, scope: !1279)
!1279 = distinct !DILexicalBlock(scope: !1269, file: !13, line: 252, column: 35)
!1280 = !DILocation(line: 254, column: 7, scope: !1279)
!1281 = !DILocation(line: 256, column: 6, scope: !1270)
!1282 = !DILocation(line: 251, column: 34, scope: !1265)
!1283 = !DILocation(line: 251, column: 6, scope: !1265)
!1284 = distinct !{!1284, !1267, !1285}
!1285 = !DILocation(line: 256, column: 6, scope: !1261)
!1286 = !DILocation(line: 257, column: 2, scope: !1262)
!1287 = !DILocation(line: 258, column: 6, scope: !1288)
!1288 = distinct !DILexicalBlock(scope: !1138, file: !13, line: 258, column: 6)
!1289 = !DILocation(line: 258, column: 6, scope: !1138)
!1290 = !DILocation(line: 259, column: 13, scope: !1291)
!1291 = distinct !DILexicalBlock(scope: !1292, file: !13, line: 259, column: 6)
!1292 = distinct !DILexicalBlock(scope: !1288, file: !13, line: 258, column: 16)
!1293 = !DILocation(line: 259, column: 11, scope: !1291)
!1294 = !DILocation(line: 259, column: 18, scope: !1295)
!1295 = distinct !DILexicalBlock(scope: !1291, file: !13, line: 259, column: 6)
!1296 = !DILocation(line: 259, column: 20, scope: !1295)
!1297 = !DILocation(line: 259, column: 6, scope: !1291)
!1298 = !DILocation(line: 260, column: 9, scope: !1299)
!1299 = distinct !DILexicalBlock(scope: !1295, file: !13, line: 259, column: 38)
!1300 = !DILocation(line: 260, column: 3, scope: !1299)
!1301 = !DILocation(line: 260, column: 12, scope: !1299)
!1302 = !DILocation(line: 261, column: 6, scope: !1299)
!1303 = !DILocation(line: 259, column: 34, scope: !1295)
!1304 = !DILocation(line: 259, column: 6, scope: !1295)
!1305 = distinct !{!1305, !1297, !1306}
!1306 = !DILocation(line: 261, column: 6, scope: !1291)
!1307 = !DILocation(line: 262, column: 19, scope: !1292)
!1308 = !DILocation(line: 263, column: 2, scope: !1292)
!1309 = !DILocation(line: 265, column: 6, scope: !1310)
!1310 = distinct !DILexicalBlock(scope: !1138, file: !13, line: 265, column: 6)
!1311 = !DILocation(line: 265, column: 15, scope: !1310)
!1312 = !DILocation(line: 265, column: 14, scope: !1310)
!1313 = !DILocation(line: 265, column: 6, scope: !1138)
!1314 = !DILocation(line: 266, column: 11, scope: !1315)
!1315 = distinct !DILexicalBlock(scope: !1310, file: !13, line: 265, column: 30)
!1316 = !DILocation(line: 267, column: 16, scope: !1315)
!1317 = !DILocation(line: 268, column: 2, scope: !1315)
!1318 = !DILocation(line: 269, column: 17, scope: !1319)
!1319 = distinct !DILexicalBlock(scope: !1310, file: !13, line: 268, column: 9)
!1320 = !DILocation(line: 269, column: 15, scope: !1319)
!1321 = !DILocation(line: 271, column: 5, scope: !1138)
!1322 = !DILocation(line: 273, column: 9, scope: !1323)
!1323 = distinct !DILexicalBlock(scope: !573, file: !13, line: 273, column: 9)
!1324 = !DILocation(line: 273, column: 17, scope: !1323)
!1325 = !DILocation(line: 273, column: 9, scope: !573)
!1326 = !DILocation(line: 274, column: 10, scope: !1323)
!1327 = !DILocation(line: 275, column: 3, scope: !1323)
!1328 = !DILocation(line: 275, column: 16, scope: !1323)
!1329 = !DILocation(line: 275, column: 28, scope: !1323)
!1330 = !DILocation(line: 275, column: 53, scope: !1323)
!1331 = !DILocation(line: 274, column: 2, scope: !1323)
!1332 = !DILocation(line: 277, column: 9, scope: !1333)
!1333 = distinct !DILexicalBlock(scope: !573, file: !13, line: 277, column: 9)
!1334 = !DILocation(line: 277, column: 17, scope: !1333)
!1335 = !DILocation(line: 277, column: 9, scope: !573)
!1336 = !DILocation(line: 278, column: 9, scope: !1337)
!1337 = distinct !DILexicalBlock(scope: !1333, file: !13, line: 278, column: 2)
!1338 = !DILocation(line: 278, column: 7, scope: !1337)
!1339 = !DILocation(line: 278, column: 14, scope: !1340)
!1340 = distinct !DILexicalBlock(scope: !1337, file: !13, line: 278, column: 2)
!1341 = !DILocation(line: 278, column: 19, scope: !1340)
!1342 = !DILocation(line: 278, column: 16, scope: !1340)
!1343 = !DILocation(line: 278, column: 2, scope: !1337)
!1344 = !DILocation(line: 279, column: 14, scope: !1345)
!1345 = distinct !DILexicalBlock(scope: !1340, file: !13, line: 278, column: 36)
!1346 = !DILocation(line: 280, column: 7, scope: !1345)
!1347 = !DILocation(line: 280, column: 14, scope: !1345)
!1348 = !DILocation(line: 280, column: 17, scope: !1345)
!1349 = !DILocation(line: 280, column: 22, scope: !1345)
!1350 = !DILocation(line: 280, column: 29, scope: !1345)
!1351 = !DILocation(line: 280, column: 32, scope: !1345)
!1352 = !DILocation(line: 280, column: 38, scope: !1345)
!1353 = !DILocation(line: 280, column: 45, scope: !1345)
!1354 = !DILocation(line: 280, column: 48, scope: !1345)
!1355 = !DILocation(line: 279, column: 6, scope: !1345)
!1356 = !DILocation(line: 281, column: 2, scope: !1345)
!1357 = !DILocation(line: 278, column: 32, scope: !1340)
!1358 = !DILocation(line: 278, column: 2, scope: !1340)
!1359 = distinct !{!1359, !1343, !1360}
!1360 = !DILocation(line: 281, column: 2, scope: !1337)
!1361 = !DILocation(line: 283, column: 9, scope: !1362)
!1362 = distinct !DILexicalBlock(scope: !573, file: !13, line: 283, column: 9)
!1363 = !DILocation(line: 283, column: 9, scope: !573)
!1364 = !DILocation(line: 284, column: 10, scope: !1365)
!1365 = distinct !DILexicalBlock(scope: !1362, file: !13, line: 283, column: 38)
!1366 = !DILocation(line: 284, column: 2, scope: !1365)
!1367 = !DILocation(line: 285, column: 7, scope: !1365)
!1368 = !DILocation(line: 285, column: 2, scope: !1365)
!1369 = !DILocation(line: 286, column: 7, scope: !1365)
!1370 = !DILocation(line: 286, column: 2, scope: !1365)
!1371 = !DILocation(line: 287, column: 2, scope: !1365)
!1372 = !DILocation(line: 297, column: 15, scope: !573)
!1373 = !DILocation(line: 297, column: 13, scope: !573)
!1374 = !DILocation(line: 300, column: 9, scope: !1375)
!1375 = distinct !DILexicalBlock(scope: !573, file: !13, line: 300, column: 9)
!1376 = !DILocation(line: 300, column: 17, scope: !1375)
!1377 = !DILocation(line: 300, column: 9, scope: !573)
!1378 = !DILocation(line: 301, column: 2, scope: !1375)
!1379 = !DILocation(line: 304, column: 39, scope: !573)
!1380 = !DILocation(line: 304, column: 16, scope: !573)
!1381 = !DILocation(line: 304, column: 14, scope: !573)
!1382 = !DILocation(line: 305, column: 9, scope: !1383)
!1383 = distinct !DILexicalBlock(scope: !573, file: !13, line: 305, column: 9)
!1384 = !DILocation(line: 305, column: 18, scope: !1383)
!1385 = !DILocation(line: 305, column: 9, scope: !573)
!1386 = !DILocation(line: 307, column: 2, scope: !1387)
!1387 = distinct !DILexicalBlock(scope: !1383, file: !13, line: 306, column: 5)
!1388 = !DILocation(line: 308, column: 2, scope: !1387)
!1389 = !DILocation(line: 312, column: 20, scope: !1390)
!1390 = distinct !DILexicalBlock(scope: !573, file: !13, line: 312, column: 9)
!1391 = !DILocation(line: 312, column: 18, scope: !1390)
!1392 = !DILocation(line: 312, column: 9, scope: !573)
!1393 = !DILocation(line: 313, column: 2, scope: !1394)
!1394 = distinct !DILexicalBlock(scope: !1390, file: !13, line: 312, column: 50)
!1395 = !DILocation(line: 314, column: 9, scope: !1394)
!1396 = !DILocation(line: 314, column: 2, scope: !1394)
!1397 = !DILocation(line: 318, column: 17, scope: !573)
!1398 = !DILocation(line: 318, column: 26, scope: !573)
!1399 = !DILocation(line: 318, column: 5, scope: !573)
!1400 = !DILocation(line: 320, column: 8, scope: !1401)
!1401 = distinct !DILexicalBlock(scope: !573, file: !13, line: 320, column: 8)
!1402 = !DILocation(line: 320, column: 8, scope: !573)
!1403 = !DILocation(line: 321, column: 34, scope: !1401)
!1404 = !DILocation(line: 321, column: 8, scope: !1401)
!1405 = !DILocation(line: 323, column: 9, scope: !1406)
!1406 = distinct !DILexicalBlock(scope: !573, file: !13, line: 323, column: 9)
!1407 = !DILocation(line: 323, column: 9, scope: !573)
!1408 = !DILocation(line: 325, column: 24, scope: !1409)
!1409 = distinct !DILexicalBlock(scope: !1406, file: !13, line: 324, column: 5)
!1410 = !DILocation(line: 325, column: 33, scope: !1409)
!1411 = !DILocation(line: 325, column: 11, scope: !1409)
!1412 = !DILocation(line: 327, column: 17, scope: !1409)
!1413 = !DILocation(line: 327, column: 26, scope: !1409)
!1414 = !DILocation(line: 327, column: 4, scope: !1409)
!1415 = !DILocation(line: 329, column: 5, scope: !1409)
!1416 = !DILocation(line: 332, column: 9, scope: !1417)
!1417 = distinct !DILexicalBlock(scope: !573, file: !13, line: 332, column: 9)
!1418 = !DILocation(line: 332, column: 20, scope: !1417)
!1419 = !DILocation(line: 332, column: 9, scope: !573)
!1420 = !DILocation(line: 333, column: 15, scope: !1417)
!1421 = !DILocation(line: 333, column: 24, scope: !1417)
!1422 = !DILocation(line: 333, column: 37, scope: !1417)
!1423 = !DILocation(line: 333, column: 13, scope: !1417)
!1424 = !DILocation(line: 333, column: 2, scope: !1417)
!1425 = !DILocation(line: 335, column: 18, scope: !573)
!1426 = !DILocation(line: 335, column: 27, scope: !573)
!1427 = !DILocation(line: 336, column: 4, scope: !573)
!1428 = !DILocation(line: 336, column: 13, scope: !573)
!1429 = !DILocation(line: 336, column: 26, scope: !573)
!1430 = !DILocation(line: 336, column: 33, scope: !573)
!1431 = !DILocation(line: 336, column: 42, scope: !573)
!1432 = !DILocation(line: 336, column: 55, scope: !573)
!1433 = !DILocation(line: 337, column: 4, scope: !573)
!1434 = !DILocation(line: 338, column: 4, scope: !573)
!1435 = !DILocation(line: 339, column: 4, scope: !573)
!1436 = !DILocation(line: 335, column: 5, scope: !573)
!1437 = !DILocation(line: 343, column: 19, scope: !1438)
!1438 = distinct !DILexicalBlock(scope: !573, file: !13, line: 343, column: 9)
!1439 = !DILocation(line: 343, column: 31, scope: !1438)
!1440 = !DILocation(line: 343, column: 36, scope: !1438)
!1441 = !DILocation(line: 343, column: 49, scope: !1438)
!1442 = !DILocation(line: 343, column: 61, scope: !1438)
!1443 = !DILocation(line: 343, column: 9, scope: !573)
!1444 = !DILocation(line: 344, column: 15, scope: !1438)
!1445 = !DILocation(line: 344, column: 24, scope: !1438)
!1446 = !DILocation(line: 345, column: 18, scope: !1438)
!1447 = !DILocation(line: 345, column: 29, scope: !1438)
!1448 = !DILocation(line: 344, column: 2, scope: !1438)
!1449 = !DILocation(line: 348, column: 9, scope: !1450)
!1450 = distinct !DILexicalBlock(scope: !573, file: !13, line: 348, column: 9)
!1451 = !DILocation(line: 348, column: 14, scope: !1450)
!1452 = !DILocation(line: 348, column: 22, scope: !1450)
!1453 = !DILocation(line: 348, column: 25, scope: !1450)
!1454 = !DILocation(line: 348, column: 28, scope: !1450)
!1455 = !DILocation(line: 348, column: 33, scope: !1450)
!1456 = !DILocation(line: 348, column: 41, scope: !1450)
!1457 = !DILocation(line: 348, column: 9, scope: !573)
!1458 = !DILocation(line: 349, column: 15, scope: !1450)
!1459 = !DILocation(line: 349, column: 24, scope: !1450)
!1460 = !DILocation(line: 350, column: 8, scope: !1450)
!1461 = !DILocation(line: 350, column: 13, scope: !1450)
!1462 = !DILocation(line: 350, column: 23, scope: !1450)
!1463 = !DILocation(line: 350, column: 28, scope: !1450)
!1464 = !DILocation(line: 349, column: 2, scope: !1450)
!1465 = !DILocation(line: 352, column: 19, scope: !1466)
!1466 = distinct !DILexicalBlock(scope: !573, file: !13, line: 352, column: 9)
!1467 = !DILocation(line: 352, column: 30, scope: !1466)
!1468 = !DILocation(line: 352, column: 9, scope: !573)
!1469 = !DILocation(line: 357, column: 6, scope: !1470)
!1470 = distinct !DILexicalBlock(scope: !1471, file: !13, line: 357, column: 6)
!1471 = distinct !DILexicalBlock(scope: !1466, file: !13, line: 352, column: 35)
!1472 = !DILocation(line: 357, column: 6, scope: !1471)
!1473 = !DILocation(line: 358, column: 47, scope: !1474)
!1474 = distinct !DILexicalBlock(scope: !1475, file: !13, line: 358, column: 10)
!1475 = distinct !DILexicalBlock(scope: !1470, file: !13, line: 357, column: 12)
!1476 = !DILocation(line: 358, column: 18, scope: !1474)
!1477 = !DILocation(line: 358, column: 10, scope: !1474)
!1478 = !DILocation(line: 358, column: 10, scope: !1475)
!1479 = !DILocation(line: 359, column: 39, scope: !1480)
!1480 = distinct !DILexicalBlock(scope: !1474, file: !13, line: 358, column: 61)
!1481 = !DILocation(line: 359, column: 23, scope: !1480)
!1482 = !DILocation(line: 359, column: 16, scope: !1480)
!1483 = !DILocation(line: 359, column: 21, scope: !1480)
!1484 = !DILocation(line: 360, column: 16, scope: !1480)
!1485 = !DILocation(line: 360, column: 25, scope: !1480)
!1486 = !DILocation(line: 360, column: 3, scope: !1480)
!1487 = !DILocation(line: 361, column: 6, scope: !1480)
!1488 = !DILocation(line: 362, column: 2, scope: !1475)
!1489 = !DILocation(line: 363, column: 13, scope: !1490)
!1490 = distinct !DILexicalBlock(scope: !1491, file: !13, line: 363, column: 6)
!1491 = distinct !DILexicalBlock(scope: !1470, file: !13, line: 362, column: 9)
!1492 = !DILocation(line: 363, column: 11, scope: !1490)
!1493 = !DILocation(line: 363, column: 18, scope: !1494)
!1494 = distinct !DILexicalBlock(scope: !1490, file: !13, line: 363, column: 6)
!1495 = !DILocation(line: 363, column: 20, scope: !1494)
!1496 = !DILocation(line: 363, column: 6, scope: !1490)
!1497 = !DILocation(line: 364, column: 36, scope: !1498)
!1498 = distinct !DILexicalBlock(scope: !1499, file: !13, line: 364, column: 7)
!1499 = distinct !DILexicalBlock(scope: !1494, file: !13, line: 363, column: 38)
!1500 = !DILocation(line: 364, column: 7, scope: !1498)
!1501 = !DILocation(line: 364, column: 48, scope: !1498)
!1502 = !DILocation(line: 364, column: 55, scope: !1498)
!1503 = !DILocation(line: 364, column: 62, scope: !1498)
!1504 = !DILocation(line: 364, column: 65, scope: !1498)
!1505 = !DILocation(line: 364, column: 52, scope: !1498)
!1506 = !DILocation(line: 364, column: 69, scope: !1498)
!1507 = !DILocation(line: 365, column: 36, scope: !1498)
!1508 = !DILocation(line: 365, column: 7, scope: !1498)
!1509 = !DILocation(line: 365, column: 48, scope: !1498)
!1510 = !DILocation(line: 365, column: 57, scope: !1498)
!1511 = !DILocation(line: 365, column: 64, scope: !1498)
!1512 = !DILocation(line: 365, column: 67, scope: !1498)
!1513 = !DILocation(line: 365, column: 54, scope: !1498)
!1514 = !DILocation(line: 365, column: 73, scope: !1498)
!1515 = !DILocation(line: 366, column: 36, scope: !1498)
!1516 = !DILocation(line: 366, column: 7, scope: !1498)
!1517 = !DILocation(line: 366, column: 48, scope: !1498)
!1518 = !DILocation(line: 366, column: 56, scope: !1498)
!1519 = !DILocation(line: 366, column: 63, scope: !1498)
!1520 = !DILocation(line: 366, column: 66, scope: !1498)
!1521 = !DILocation(line: 366, column: 53, scope: !1498)
!1522 = !DILocation(line: 364, column: 7, scope: !1499)
!1523 = !DILocation(line: 367, column: 11, scope: !1524)
!1524 = distinct !DILexicalBlock(scope: !1525, file: !13, line: 367, column: 11)
!1525 = distinct !DILexicalBlock(scope: !1498, file: !13, line: 366, column: 72)
!1526 = !DILocation(line: 367, column: 24, scope: !1524)
!1527 = !DILocation(line: 367, column: 22, scope: !1524)
!1528 = !DILocation(line: 367, column: 11, scope: !1525)
!1529 = !DILocation(line: 368, column: 17, scope: !1524)
!1530 = !DILocation(line: 368, column: 15, scope: !1524)
!1531 = !DILocation(line: 368, column: 4, scope: !1524)
!1532 = !DILocation(line: 369, column: 27, scope: !1525)
!1533 = !DILocation(line: 369, column: 19, scope: !1525)
!1534 = !DILocation(line: 369, column: 25, scope: !1525)
!1535 = !DILocation(line: 370, column: 20, scope: !1525)
!1536 = !DILocation(line: 370, column: 29, scope: !1525)
!1537 = !DILocation(line: 370, column: 7, scope: !1525)
!1538 = !DILocation(line: 371, column: 7, scope: !1525)
!1539 = !DILocation(line: 373, column: 6, scope: !1499)
!1540 = !DILocation(line: 363, column: 34, scope: !1494)
!1541 = !DILocation(line: 363, column: 6, scope: !1494)
!1542 = distinct !{!1542, !1496, !1543}
!1543 = !DILocation(line: 373, column: 6, scope: !1490)
!1544 = !DILocation(line: 375, column: 5, scope: !1471)
!1545 = !DILocation(line: 378, column: 9, scope: !1546)
!1546 = distinct !DILexicalBlock(scope: !573, file: !13, line: 378, column: 9)
!1547 = !DILocation(line: 378, column: 14, scope: !1546)
!1548 = !DILocation(line: 378, column: 20, scope: !1546)
!1549 = !DILocation(line: 378, column: 9, scope: !573)
!1550 = !DILocation(line: 379, column: 6, scope: !1551)
!1551 = distinct !DILexicalBlock(scope: !1552, file: !13, line: 379, column: 6)
!1552 = distinct !DILexicalBlock(scope: !1546, file: !13, line: 378, column: 27)
!1553 = !DILocation(line: 379, column: 6, scope: !1552)
!1554 = !DILocation(line: 380, column: 10, scope: !1555)
!1555 = distinct !DILexicalBlock(scope: !1556, file: !13, line: 380, column: 10)
!1556 = distinct !DILexicalBlock(scope: !1551, file: !13, line: 379, column: 12)
!1557 = !DILocation(line: 380, column: 18, scope: !1555)
!1558 = !DILocation(line: 380, column: 10, scope: !1556)
!1559 = !DILocation(line: 381, column: 11, scope: !1555)
!1560 = !DILocation(line: 381, column: 3, scope: !1555)
!1561 = !DILocation(line: 382, column: 32, scope: !1556)
!1562 = !DILocation(line: 382, column: 37, scope: !1556)
!1563 = !DILocation(line: 382, column: 26, scope: !1556)
!1564 = !DILocation(line: 382, column: 19, scope: !1556)
!1565 = !DILocation(line: 382, column: 24, scope: !1556)
!1566 = !DILocation(line: 383, column: 19, scope: !1556)
!1567 = !DILocation(line: 383, column: 28, scope: !1556)
!1568 = !DILocation(line: 383, column: 6, scope: !1556)
!1569 = !DILocation(line: 384, column: 2, scope: !1556)
!1570 = !DILocation(line: 385, column: 10, scope: !1571)
!1571 = distinct !DILexicalBlock(scope: !1572, file: !13, line: 385, column: 10)
!1572 = distinct !DILexicalBlock(scope: !1551, file: !13, line: 384, column: 9)
!1573 = !DILocation(line: 385, column: 18, scope: !1571)
!1574 = !DILocation(line: 385, column: 10, scope: !1572)
!1575 = !DILocation(line: 386, column: 11, scope: !1571)
!1576 = !DILocation(line: 386, column: 3, scope: !1571)
!1577 = !DILocation(line: 388, column: 16, scope: !1572)
!1578 = !DILocation(line: 389, column: 13, scope: !1579)
!1579 = distinct !DILexicalBlock(scope: !1572, file: !13, line: 389, column: 6)
!1580 = !DILocation(line: 389, column: 11, scope: !1579)
!1581 = !DILocation(line: 389, column: 18, scope: !1582)
!1582 = distinct !DILexicalBlock(scope: !1579, file: !13, line: 389, column: 6)
!1583 = !DILocation(line: 389, column: 20, scope: !1582)
!1584 = !DILocation(line: 389, column: 6, scope: !1579)
!1585 = !DILocation(line: 390, column: 14, scope: !1582)
!1586 = !DILocation(line: 390, column: 9, scope: !1582)
!1587 = !DILocation(line: 390, column: 3, scope: !1582)
!1588 = !DILocation(line: 390, column: 12, scope: !1582)
!1589 = !DILocation(line: 389, column: 34, scope: !1582)
!1590 = !DILocation(line: 389, column: 6, scope: !1582)
!1591 = distinct !{!1591, !1584, !1592}
!1592 = !DILocation(line: 390, column: 14, scope: !1579)
!1593 = !DILocation(line: 391, column: 17, scope: !1572)
!1594 = !DILocation(line: 391, column: 22, scope: !1572)
!1595 = !DILocation(line: 391, column: 6, scope: !1572)
!1596 = !DILocation(line: 391, column: 15, scope: !1572)
!1597 = !DILocation(line: 392, column: 12, scope: !1572)
!1598 = !DILocation(line: 392, column: 17, scope: !1572)
!1599 = !DILocation(line: 392, column: 6, scope: !1572)
!1600 = !DILocation(line: 392, column: 24, scope: !1572)
!1601 = !DILocation(line: 393, column: 6, scope: !1572)
!1602 = !DILocation(line: 393, column: 19, scope: !1572)
!1603 = !DILocation(line: 394, column: 19, scope: !1572)
!1604 = !DILocation(line: 394, column: 28, scope: !1572)
!1605 = !DILocation(line: 394, column: 38, scope: !1572)
!1606 = !DILocation(line: 394, column: 6, scope: !1572)
!1607 = !DILocation(line: 396, column: 5, scope: !1552)
!1608 = !DILocation(line: 399, column: 10, scope: !1609)
!1609 = distinct !DILexicalBlock(scope: !573, file: !13, line: 399, column: 9)
!1610 = !DILocation(line: 399, column: 9, scope: !573)
!1611 = !DILocation(line: 400, column: 6, scope: !1612)
!1612 = distinct !DILexicalBlock(scope: !1613, file: !13, line: 400, column: 6)
!1613 = distinct !DILexicalBlock(scope: !1609, file: !13, line: 399, column: 16)
!1614 = !DILocation(line: 400, column: 6, scope: !1613)
!1615 = !DILocation(line: 401, column: 10, scope: !1616)
!1616 = distinct !DILexicalBlock(scope: !1617, file: !13, line: 401, column: 10)
!1617 = distinct !DILexicalBlock(scope: !1612, file: !13, line: 400, column: 17)
!1618 = !DILocation(line: 401, column: 18, scope: !1616)
!1619 = !DILocation(line: 401, column: 10, scope: !1617)
!1620 = !DILocation(line: 402, column: 11, scope: !1616)
!1621 = !DILocation(line: 402, column: 3, scope: !1616)
!1622 = !DILocation(line: 403, column: 13, scope: !1623)
!1623 = distinct !DILexicalBlock(scope: !1617, file: !13, line: 403, column: 6)
!1624 = !DILocation(line: 403, column: 11, scope: !1623)
!1625 = !DILocation(line: 403, column: 18, scope: !1626)
!1626 = distinct !DILexicalBlock(scope: !1623, file: !13, line: 403, column: 6)
!1627 = !DILocation(line: 403, column: 23, scope: !1626)
!1628 = !DILocation(line: 403, column: 20, scope: !1626)
!1629 = !DILocation(line: 403, column: 6, scope: !1623)
!1630 = !DILocation(line: 404, column: 22, scope: !1631)
!1631 = distinct !DILexicalBlock(scope: !1626, file: !13, line: 403, column: 40)
!1632 = !DILocation(line: 404, column: 31, scope: !1631)
!1633 = !DILocation(line: 404, column: 44, scope: !1631)
!1634 = !DILocation(line: 404, column: 57, scope: !1631)
!1635 = !DILocation(line: 404, column: 51, scope: !1631)
!1636 = !DILocation(line: 404, column: 61, scope: !1631)
!1637 = !DILocation(line: 404, column: 11, scope: !1631)
!1638 = !DILocation(line: 404, column: 3, scope: !1631)
!1639 = !DILocation(line: 404, column: 14, scope: !1631)
!1640 = !DILocation(line: 404, column: 20, scope: !1631)
!1641 = !DILocation(line: 405, column: 22, scope: !1631)
!1642 = !DILocation(line: 405, column: 31, scope: !1631)
!1643 = !DILocation(line: 405, column: 44, scope: !1631)
!1644 = !DILocation(line: 405, column: 57, scope: !1631)
!1645 = !DILocation(line: 405, column: 51, scope: !1631)
!1646 = !DILocation(line: 405, column: 61, scope: !1631)
!1647 = !DILocation(line: 405, column: 11, scope: !1631)
!1648 = !DILocation(line: 405, column: 3, scope: !1631)
!1649 = !DILocation(line: 405, column: 14, scope: !1631)
!1650 = !DILocation(line: 405, column: 20, scope: !1631)
!1651 = !DILocation(line: 406, column: 22, scope: !1631)
!1652 = !DILocation(line: 406, column: 31, scope: !1631)
!1653 = !DILocation(line: 406, column: 44, scope: !1631)
!1654 = !DILocation(line: 406, column: 57, scope: !1631)
!1655 = !DILocation(line: 406, column: 51, scope: !1631)
!1656 = !DILocation(line: 406, column: 61, scope: !1631)
!1657 = !DILocation(line: 406, column: 11, scope: !1631)
!1658 = !DILocation(line: 406, column: 3, scope: !1631)
!1659 = !DILocation(line: 406, column: 14, scope: !1631)
!1660 = !DILocation(line: 406, column: 20, scope: !1631)
!1661 = !DILocation(line: 407, column: 6, scope: !1631)
!1662 = !DILocation(line: 403, column: 36, scope: !1626)
!1663 = !DILocation(line: 403, column: 6, scope: !1626)
!1664 = distinct !{!1664, !1629, !1665}
!1665 = !DILocation(line: 407, column: 6, scope: !1623)
!1666 = !DILocation(line: 408, column: 14, scope: !1617)
!1667 = !DILocation(line: 408, column: 12, scope: !1617)
!1668 = !DILocation(line: 409, column: 2, scope: !1617)
!1669 = !DILocation(line: 410, column: 10, scope: !1670)
!1670 = distinct !DILexicalBlock(scope: !1671, file: !13, line: 410, column: 10)
!1671 = distinct !DILexicalBlock(scope: !1612, file: !13, line: 409, column: 9)
!1672 = !DILocation(line: 410, column: 18, scope: !1670)
!1673 = !DILocation(line: 410, column: 10, scope: !1671)
!1674 = !DILocation(line: 411, column: 11, scope: !1670)
!1675 = !DILocation(line: 411, column: 3, scope: !1670)
!1676 = !DILocation(line: 412, column: 14, scope: !1671)
!1677 = !DILocation(line: 412, column: 23, scope: !1671)
!1678 = !DILocation(line: 412, column: 36, scope: !1671)
!1679 = !DILocation(line: 412, column: 12, scope: !1671)
!1680 = !DILocation(line: 414, column: 15, scope: !1613)
!1681 = !DILocation(line: 414, column: 24, scope: !1613)
!1682 = !DILocation(line: 414, column: 34, scope: !1613)
!1683 = !DILocation(line: 414, column: 41, scope: !1613)
!1684 = !DILocation(line: 414, column: 51, scope: !1613)
!1685 = !DILocation(line: 414, column: 2, scope: !1613)
!1686 = !DILocation(line: 416, column: 6, scope: !1687)
!1687 = distinct !DILexicalBlock(scope: !1613, file: !13, line: 416, column: 6)
!1688 = !DILocation(line: 416, column: 14, scope: !1687)
!1689 = !DILocation(line: 416, column: 6, scope: !1613)
!1690 = !DILocation(line: 417, column: 14, scope: !1691)
!1691 = distinct !DILexicalBlock(scope: !1687, file: !13, line: 416, column: 19)
!1692 = !DILocation(line: 417, column: 63, scope: !1691)
!1693 = !DILocation(line: 417, column: 73, scope: !1691)
!1694 = !DILocation(line: 417, column: 6, scope: !1691)
!1695 = !DILocation(line: 418, column: 13, scope: !1696)
!1696 = distinct !DILexicalBlock(scope: !1691, file: !13, line: 418, column: 6)
!1697 = !DILocation(line: 418, column: 11, scope: !1696)
!1698 = !DILocation(line: 418, column: 18, scope: !1699)
!1699 = distinct !DILexicalBlock(scope: !1696, file: !13, line: 418, column: 6)
!1700 = !DILocation(line: 418, column: 23, scope: !1699)
!1701 = !DILocation(line: 418, column: 20, scope: !1699)
!1702 = !DILocation(line: 418, column: 6, scope: !1696)
!1703 = !DILocation(line: 419, column: 11, scope: !1704)
!1704 = distinct !DILexicalBlock(scope: !1699, file: !13, line: 418, column: 40)
!1705 = !DILocation(line: 420, column: 4, scope: !1704)
!1706 = !DILocation(line: 420, column: 10, scope: !1704)
!1707 = !DILocation(line: 420, column: 13, scope: !1704)
!1708 = !DILocation(line: 420, column: 18, scope: !1704)
!1709 = !DILocation(line: 420, column: 24, scope: !1704)
!1710 = !DILocation(line: 420, column: 27, scope: !1704)
!1711 = !DILocation(line: 420, column: 33, scope: !1704)
!1712 = !DILocation(line: 420, column: 39, scope: !1704)
!1713 = !DILocation(line: 420, column: 42, scope: !1704)
!1714 = !DILocation(line: 419, column: 3, scope: !1704)
!1715 = !DILocation(line: 421, column: 6, scope: !1704)
!1716 = !DILocation(line: 418, column: 36, scope: !1699)
!1717 = !DILocation(line: 418, column: 6, scope: !1699)
!1718 = distinct !{!1718, !1702, !1719}
!1719 = !DILocation(line: 421, column: 6, scope: !1696)
!1720 = !DILocation(line: 422, column: 2, scope: !1691)
!1721 = !DILocation(line: 423, column: 5, scope: !1613)
!1722 = !DILocation(line: 426, column: 9, scope: !1723)
!1723 = distinct !DILexicalBlock(scope: !573, file: !13, line: 426, column: 9)
!1724 = !DILocation(line: 426, column: 19, scope: !1723)
!1725 = !DILocation(line: 426, column: 23, scope: !1723)
!1726 = !DILocation(line: 426, column: 9, scope: !573)
!1727 = !DILocation(line: 427, column: 16, scope: !1728)
!1728 = distinct !DILexicalBlock(scope: !1723, file: !13, line: 426, column: 29)
!1729 = !DILocation(line: 428, column: 9, scope: !1730)
!1730 = distinct !DILexicalBlock(scope: !1728, file: !13, line: 428, column: 2)
!1731 = !DILocation(line: 428, column: 7, scope: !1730)
!1732 = !DILocation(line: 428, column: 14, scope: !1733)
!1733 = distinct !DILexicalBlock(scope: !1730, file: !13, line: 428, column: 2)
!1734 = !DILocation(line: 428, column: 16, scope: !1733)
!1735 = !DILocation(line: 428, column: 2, scope: !1730)
!1736 = !DILocation(line: 429, column: 10, scope: !1737)
!1737 = distinct !DILexicalBlock(scope: !1733, file: !13, line: 429, column: 10)
!1738 = !DILocation(line: 429, column: 16, scope: !1737)
!1739 = !DILocation(line: 429, column: 19, scope: !1737)
!1740 = !DILocation(line: 429, column: 18, scope: !1737)
!1741 = !DILocation(line: 429, column: 10, scope: !1733)
!1742 = !DILocation(line: 430, column: 19, scope: !1737)
!1743 = !DILocation(line: 430, column: 25, scope: !1737)
!1744 = !DILocation(line: 430, column: 17, scope: !1737)
!1745 = !DILocation(line: 430, column: 3, scope: !1737)
!1746 = !DILocation(line: 428, column: 30, scope: !1733)
!1747 = !DILocation(line: 428, column: 2, scope: !1733)
!1748 = distinct !{!1748, !1735, !1749}
!1749 = !DILocation(line: 430, column: 26, scope: !1730)
!1750 = !DILocation(line: 431, column: 6, scope: !1751)
!1751 = distinct !DILexicalBlock(scope: !1728, file: !13, line: 431, column: 6)
!1752 = !DILocation(line: 431, column: 20, scope: !1751)
!1753 = !DILocation(line: 431, column: 6, scope: !1728)
!1754 = !DILocation(line: 433, column: 13, scope: !1755)
!1755 = distinct !DILexicalBlock(scope: !1756, file: !13, line: 433, column: 6)
!1756 = distinct !DILexicalBlock(scope: !1751, file: !13, line: 431, column: 30)
!1757 = !DILocation(line: 433, column: 11, scope: !1755)
!1758 = !DILocation(line: 433, column: 18, scope: !1759)
!1759 = distinct !DILexicalBlock(scope: !1755, file: !13, line: 433, column: 6)
!1760 = !DILocation(line: 433, column: 20, scope: !1759)
!1761 = !DILocation(line: 433, column: 6, scope: !1755)
!1762 = !DILocation(line: 434, column: 29, scope: !1759)
!1763 = !DILocation(line: 434, column: 35, scope: !1759)
!1764 = !DILocation(line: 434, column: 16, scope: !1759)
!1765 = !DILocation(line: 434, column: 11, scope: !1759)
!1766 = !DILocation(line: 434, column: 3, scope: !1759)
!1767 = !DILocation(line: 434, column: 14, scope: !1759)
!1768 = !DILocation(line: 433, column: 34, scope: !1759)
!1769 = !DILocation(line: 433, column: 6, scope: !1759)
!1770 = distinct !{!1770, !1761, !1771}
!1771 = !DILocation(line: 434, column: 36, scope: !1755)
!1772 = !DILocation(line: 435, column: 2, scope: !1756)
!1773 = !DILocation(line: 436, column: 13, scope: !1774)
!1774 = distinct !DILexicalBlock(scope: !1775, file: !13, line: 436, column: 6)
!1775 = distinct !DILexicalBlock(scope: !1751, file: !13, line: 435, column: 9)
!1776 = !DILocation(line: 436, column: 11, scope: !1774)
!1777 = !DILocation(line: 436, column: 18, scope: !1778)
!1778 = distinct !DILexicalBlock(scope: !1774, file: !13, line: 436, column: 6)
!1779 = !DILocation(line: 436, column: 20, scope: !1778)
!1780 = !DILocation(line: 436, column: 6, scope: !1774)
!1781 = !DILocation(line: 437, column: 7, scope: !1782)
!1782 = distinct !DILexicalBlock(scope: !1778, file: !13, line: 437, column: 7)
!1783 = !DILocation(line: 437, column: 13, scope: !1782)
!1784 = !DILocation(line: 437, column: 7, scope: !1778)
!1785 = !DILocation(line: 443, column: 16, scope: !1786)
!1786 = distinct !DILexicalBlock(scope: !1782, file: !13, line: 437, column: 17)
!1787 = !DILocation(line: 443, column: 22, scope: !1786)
!1788 = !DILocation(line: 443, column: 8, scope: !1786)
!1789 = !DILocation(line: 443, column: 24, scope: !1786)
!1790 = !DILocation(line: 443, column: 33, scope: !1786)
!1791 = !DILocation(line: 443, column: 32, scope: !1786)
!1792 = !DILocation(line: 438, column: 20, scope: !1786)
!1793 = !DILocation(line: 438, column: 15, scope: !1786)
!1794 = !DILocation(line: 438, column: 7, scope: !1786)
!1795 = !DILocation(line: 438, column: 18, scope: !1786)
!1796 = !DILocation(line: 445, column: 19, scope: !1797)
!1797 = distinct !DILexicalBlock(scope: !1786, file: !13, line: 445, column: 11)
!1798 = !DILocation(line: 445, column: 11, scope: !1797)
!1799 = !DILocation(line: 445, column: 22, scope: !1797)
!1800 = !DILocation(line: 445, column: 11, scope: !1786)
!1801 = !DILocation(line: 446, column: 12, scope: !1797)
!1802 = !DILocation(line: 446, column: 4, scope: !1797)
!1803 = !DILocation(line: 446, column: 15, scope: !1797)
!1804 = !DILocation(line: 447, column: 3, scope: !1786)
!1805 = !DILocation(line: 448, column: 15, scope: !1806)
!1806 = distinct !DILexicalBlock(scope: !1782, file: !13, line: 447, column: 10)
!1807 = !DILocation(line: 448, column: 7, scope: !1806)
!1808 = !DILocation(line: 448, column: 18, scope: !1806)
!1809 = !DILocation(line: 437, column: 14, scope: !1782)
!1810 = !DILocation(line: 436, column: 34, scope: !1778)
!1811 = !DILocation(line: 436, column: 6, scope: !1778)
!1812 = distinct !{!1812, !1780, !1813}
!1813 = !DILocation(line: 449, column: 3, scope: !1774)
!1814 = !DILocation(line: 451, column: 15, scope: !1728)
!1815 = !DILocation(line: 451, column: 24, scope: !1728)
!1816 = !DILocation(line: 451, column: 34, scope: !1728)
!1817 = !DILocation(line: 451, column: 2, scope: !1728)
!1818 = !DILocation(line: 452, column: 5, scope: !1728)
!1819 = !DILocation(line: 455, column: 9, scope: !1820)
!1820 = distinct !DILexicalBlock(scope: !573, file: !13, line: 455, column: 9)
!1821 = !DILocation(line: 455, column: 9, scope: !573)
!1822 = !DILocation(line: 456, column: 11, scope: !1823)
!1823 = distinct !DILexicalBlock(scope: !1820, file: !13, line: 455, column: 25)
!1824 = !DILocation(line: 456, column: 23, scope: !1823)
!1825 = !DILocation(line: 457, column: 11, scope: !1823)
!1826 = !DILocation(line: 457, column: 15, scope: !1823)
!1827 = !DILocation(line: 458, column: 11, scope: !1823)
!1828 = !DILocation(line: 458, column: 16, scope: !1823)
!1829 = !DILocation(line: 459, column: 41, scope: !1823)
!1830 = !DILocation(line: 459, column: 25, scope: !1823)
!1831 = !DILocation(line: 459, column: 11, scope: !1823)
!1832 = !DILocation(line: 459, column: 23, scope: !1823)
!1833 = !DILocation(line: 461, column: 15, scope: !1823)
!1834 = !DILocation(line: 461, column: 24, scope: !1823)
!1835 = !DILocation(line: 461, column: 2, scope: !1823)
!1836 = !DILocation(line: 462, column: 5, scope: !1823)
!1837 = !DILocation(line: 464, column: 20, scope: !573)
!1838 = !DILocation(line: 464, column: 29, scope: !573)
!1839 = !DILocation(line: 464, column: 5, scope: !573)
!1840 = !DILocation(line: 466, column: 9, scope: !1841)
!1841 = distinct !DILexicalBlock(scope: !573, file: !13, line: 466, column: 9)
!1842 = !DILocation(line: 466, column: 17, scope: !1841)
!1843 = !DILocation(line: 466, column: 9, scope: !573)
!1844 = !DILocation(line: 467, column: 18, scope: !1841)
!1845 = !DILocation(line: 467, column: 2, scope: !1841)
!1846 = !DILocation(line: 472, column: 5, scope: !573)
!1847 = !DILocation(line: 472, column: 11, scope: !573)
!1848 = !DILocation(line: 472, column: 21, scope: !573)
!1849 = !DILocation(line: 472, column: 23, scope: !573)
!1850 = !DILocation(line: 472, column: 33, scope: !573)
!1851 = !DILocation(line: 472, column: 38, scope: !573)
!1852 = !DILocation(line: 472, column: 41, scope: !573)
!1853 = !DILocation(line: 472, column: 35, scope: !573)
!1854 = !DILocalVariable(name: "data", scope: !1855, file: !13, line: 473, type: !241)
!1855 = distinct !DILexicalBlock(scope: !573, file: !13, line: 472, column: 47)
!1856 = !DILocation(line: 473, column: 8, scope: !1855)
!1857 = !DILocation(line: 474, column: 15, scope: !1855)
!1858 = !DILocation(line: 474, column: 18, scope: !1855)
!1859 = !DILocation(line: 474, column: 9, scope: !1855)
!1860 = !DILocation(line: 474, column: 2, scope: !1855)
!1861 = !DILocation(line: 476, column: 45, scope: !1862)
!1862 = distinct !DILexicalBlock(scope: !1855, file: !13, line: 474, column: 27)
!1863 = !DILocation(line: 476, column: 18, scope: !1862)
!1864 = !DILocation(line: 476, column: 16, scope: !1862)
!1865 = !DILocation(line: 477, column: 13, scope: !1866)
!1866 = distinct !DILexicalBlock(scope: !1862, file: !13, line: 477, column: 6)
!1867 = !DILocation(line: 477, column: 11, scope: !1866)
!1868 = !DILocation(line: 477, column: 18, scope: !1869)
!1869 = distinct !DILexicalBlock(scope: !1866, file: !13, line: 477, column: 6)
!1870 = !DILocation(line: 477, column: 20, scope: !1869)
!1871 = !DILocation(line: 477, column: 19, scope: !1869)
!1872 = !DILocation(line: 477, column: 6, scope: !1866)
!1873 = !DILocation(line: 478, column: 10, scope: !1874)
!1874 = distinct !DILexicalBlock(scope: !1869, file: !13, line: 478, column: 3)
!1875 = !DILocation(line: 478, column: 8, scope: !1874)
!1876 = !DILocation(line: 478, column: 15, scope: !1877)
!1877 = distinct !DILexicalBlock(scope: !1874, file: !13, line: 478, column: 3)
!1878 = !DILocation(line: 478, column: 17, scope: !1877)
!1879 = !DILocation(line: 478, column: 26, scope: !1877)
!1880 = !DILocation(line: 478, column: 39, scope: !1877)
!1881 = !DILocation(line: 478, column: 16, scope: !1877)
!1882 = !DILocation(line: 478, column: 3, scope: !1874)
!1883 = !DILocation(line: 479, column: 11, scope: !1884)
!1884 = distinct !DILexicalBlock(scope: !1885, file: !13, line: 479, column: 11)
!1885 = distinct !DILexicalBlock(scope: !1877, file: !13, line: 478, column: 52)
!1886 = !DILocation(line: 479, column: 11, scope: !1885)
!1887 = !DILocation(line: 480, column: 8, scope: !1888)
!1888 = distinct !DILexicalBlock(scope: !1889, file: !13, line: 480, column: 8)
!1889 = distinct !DILexicalBlock(scope: !1884, file: !13, line: 479, column: 21)
!1890 = !DILocation(line: 480, column: 17, scope: !1888)
!1891 = !DILocation(line: 480, column: 8, scope: !1889)
!1892 = !DILocation(line: 481, column: 16, scope: !1888)
!1893 = !DILocation(line: 481, column: 34, scope: !1888)
!1894 = !DILocation(line: 481, column: 35, scope: !1888)
!1895 = !DILocation(line: 481, column: 39, scope: !1888)
!1896 = !DILocation(line: 481, column: 8, scope: !1888)
!1897 = !DILocation(line: 482, column: 12, scope: !1889)
!1898 = !DILocation(line: 483, column: 18, scope: !1889)
!1899 = !DILocation(line: 483, column: 12, scope: !1889)
!1900 = !DILocation(line: 483, column: 19, scope: !1889)
!1901 = !DILocation(line: 483, column: 25, scope: !1889)
!1902 = !DILocation(line: 483, column: 34, scope: !1889)
!1903 = !DILocation(line: 483, column: 47, scope: !1889)
!1904 = !DILocation(line: 483, column: 24, scope: !1889)
!1905 = !DILocation(line: 483, column: 5, scope: !1889)
!1906 = !DILocation(line: 482, column: 4, scope: !1889)
!1907 = !DILocation(line: 484, column: 11, scope: !1889)
!1908 = !DILocation(line: 484, column: 4, scope: !1889)
!1909 = !DILocation(line: 485, column: 7, scope: !1889)
!1910 = !DILocation(line: 486, column: 14, scope: !1885)
!1911 = !DILocation(line: 486, column: 23, scope: !1885)
!1912 = !DILocation(line: 487, column: 20, scope: !1885)
!1913 = !DILocation(line: 487, column: 25, scope: !1885)
!1914 = !DILocation(line: 488, column: 23, scope: !1885)
!1915 = !DILocation(line: 488, column: 32, scope: !1885)
!1916 = !DILocation(line: 488, column: 45, scope: !1885)
!1917 = !DILocation(line: 488, column: 52, scope: !1885)
!1918 = !DILocation(line: 488, column: 8, scope: !1885)
!1919 = !DILocation(line: 488, column: 57, scope: !1885)
!1920 = !DILocation(line: 487, column: 12, scope: !1885)
!1921 = !DILocation(line: 488, column: 62, scope: !1885)
!1922 = !DILocation(line: 488, column: 71, scope: !1885)
!1923 = !DILocation(line: 488, column: 84, scope: !1885)
!1924 = !DILocation(line: 488, column: 60, scope: !1885)
!1925 = !DILocation(line: 486, column: 28, scope: !1885)
!1926 = !DILocation(line: 486, column: 12, scope: !1885)
!1927 = !DILocation(line: 490, column: 11, scope: !1928)
!1928 = distinct !DILexicalBlock(scope: !1885, file: !13, line: 490, column: 11)
!1929 = !DILocation(line: 490, column: 21, scope: !1928)
!1930 = !DILocation(line: 490, column: 24, scope: !1928)
!1931 = !DILocation(line: 490, column: 26, scope: !1928)
!1932 = !DILocation(line: 490, column: 11, scope: !1885)
!1933 = !DILocation(line: 492, column: 11, scope: !1934)
!1934 = distinct !DILexicalBlock(scope: !1935, file: !13, line: 492, column: 4)
!1935 = distinct !DILexicalBlock(scope: !1928, file: !13, line: 491, column: 7)
!1936 = !DILocation(line: 492, column: 9, scope: !1934)
!1937 = !DILocation(line: 492, column: 16, scope: !1938)
!1938 = distinct !DILexicalBlock(scope: !1934, file: !13, line: 492, column: 4)
!1939 = !DILocation(line: 492, column: 20, scope: !1938)
!1940 = !DILocation(line: 492, column: 25, scope: !1938)
!1941 = !DILocation(line: 492, column: 18, scope: !1938)
!1942 = !DILocation(line: 492, column: 4, scope: !1934)
!1943 = !DILocation(line: 493, column: 24, scope: !1944)
!1944 = distinct !DILexicalBlock(scope: !1938, file: !13, line: 492, column: 37)
!1945 = !DILocation(line: 493, column: 29, scope: !1944)
!1946 = !DILocation(line: 493, column: 18, scope: !1944)
!1947 = !DILocation(line: 493, column: 8, scope: !1944)
!1948 = !DILocation(line: 493, column: 13, scope: !1944)
!1949 = !DILocation(line: 493, column: 16, scope: !1944)
!1950 = !DILocation(line: 494, column: 4, scope: !1944)
!1951 = !DILocation(line: 492, column: 33, scope: !1938)
!1952 = !DILocation(line: 492, column: 4, scope: !1938)
!1953 = distinct !{!1953, !1942, !1954}
!1954 = !DILocation(line: 494, column: 4, scope: !1934)
!1955 = !DILocation(line: 495, column: 7, scope: !1935)
!1956 = !DILocation(line: 496, column: 21, scope: !1885)
!1957 = !DILocation(line: 496, column: 30, scope: !1885)
!1958 = !DILocation(line: 496, column: 7, scope: !1885)
!1959 = !DILocation(line: 497, column: 3, scope: !1885)
!1960 = !DILocation(line: 478, column: 48, scope: !1877)
!1961 = !DILocation(line: 478, column: 3, scope: !1877)
!1962 = distinct !{!1962, !1882, !1963}
!1963 = !DILocation(line: 497, column: 3, scope: !1874)
!1964 = !DILocation(line: 477, column: 31, scope: !1869)
!1965 = !DILocation(line: 477, column: 6, scope: !1869)
!1966 = distinct !{!1966, !1872, !1967}
!1967 = !DILocation(line: 497, column: 3, scope: !1866)
!1968 = !DILocation(line: 498, column: 6, scope: !1862)
!1969 = !DILocation(line: 501, column: 10, scope: !1862)
!1970 = !DILocation(line: 501, column: 13, scope: !1862)
!1971 = !DILocation(line: 501, column: 8, scope: !1862)
!1972 = !DILocation(line: 503, column: 10, scope: !1973)
!1973 = distinct !DILexicalBlock(scope: !1862, file: !13, line: 503, column: 10)
!1974 = !DILocation(line: 503, column: 12, scope: !1973)
!1975 = !DILocation(line: 503, column: 16, scope: !1973)
!1976 = !DILocation(line: 503, column: 21, scope: !1973)
!1977 = !DILocation(line: 503, column: 24, scope: !1973)
!1978 = !DILocation(line: 503, column: 29, scope: !1973)
!1979 = !DILocation(line: 503, column: 30, scope: !1973)
!1980 = !DILocation(line: 503, column: 34, scope: !1973)
!1981 = !DILocation(line: 503, column: 43, scope: !1973)
!1982 = !DILocation(line: 503, column: 47, scope: !1973)
!1983 = !DILocation(line: 503, column: 50, scope: !1973)
!1984 = !DILocation(line: 503, column: 55, scope: !1973)
!1985 = !DILocation(line: 503, column: 56, scope: !1973)
!1986 = !DILocation(line: 503, column: 60, scope: !1973)
!1987 = !DILocation(line: 503, column: 10, scope: !1862)
!1988 = !DILocation(line: 504, column: 3, scope: !1973)
!1989 = !DILocation(line: 505, column: 14, scope: !1862)
!1990 = !DILocation(line: 505, column: 18, scope: !1862)
!1991 = !DILocation(line: 506, column: 10, scope: !1992)
!1992 = distinct !DILexicalBlock(scope: !1862, file: !13, line: 506, column: 10)
!1993 = !DILocation(line: 506, column: 11, scope: !1992)
!1994 = !DILocation(line: 506, column: 10, scope: !1862)
!1995 = !DILocation(line: 507, column: 11, scope: !1996)
!1996 = distinct !DILexicalBlock(scope: !1992, file: !13, line: 506, column: 17)
!1997 = !DILocation(line: 507, column: 23, scope: !1996)
!1998 = !DILocation(line: 508, column: 6, scope: !1996)
!1999 = !DILocation(line: 509, column: 11, scope: !2000)
!2000 = distinct !DILexicalBlock(scope: !1992, file: !13, line: 508, column: 13)
!2001 = !DILocation(line: 509, column: 23, scope: !2000)
!2002 = !DILocation(line: 511, column: 33, scope: !1862)
!2003 = !DILocation(line: 511, column: 36, scope: !1862)
!2004 = !DILocation(line: 511, column: 15, scope: !1862)
!2005 = !DILocation(line: 511, column: 20, scope: !1862)
!2006 = !DILocation(line: 512, column: 44, scope: !1862)
!2007 = !DILocation(line: 512, column: 29, scope: !1862)
!2008 = !DILocation(line: 512, column: 15, scope: !1862)
!2009 = !DILocation(line: 512, column: 27, scope: !1862)
!2010 = !DILocation(line: 513, column: 20, scope: !1862)
!2011 = !DILocation(line: 513, column: 29, scope: !1862)
!2012 = !DILocation(line: 513, column: 7, scope: !1862)
!2013 = !DILocation(line: 514, column: 6, scope: !1862)
!2014 = !DILocation(line: 517, column: 28, scope: !1862)
!2015 = !DILocation(line: 517, column: 62, scope: !1862)
!2016 = !DILocation(line: 517, column: 65, scope: !1862)
!2017 = !DILocation(line: 517, column: 6, scope: !1862)
!2018 = !DILocation(line: 518, column: 27, scope: !1862)
!2019 = !DILocation(line: 518, column: 36, scope: !1862)
!2020 = !DILocation(line: 518, column: 39, scope: !1862)
!2021 = !DILocation(line: 518, column: 45, scope: !1862)
!2022 = !DILocation(line: 518, column: 48, scope: !1862)
!2023 = !DILocation(line: 518, column: 6, scope: !1862)
!2024 = !DILocation(line: 519, column: 26, scope: !1862)
!2025 = !DILocation(line: 519, column: 6, scope: !1862)
!2026 = !DILocation(line: 520, column: 6, scope: !1862)
!2027 = !DILocation(line: 555, column: 19, scope: !1862)
!2028 = !DILocation(line: 555, column: 22, scope: !1862)
!2029 = !DILocation(line: 555, column: 30, scope: !1862)
!2030 = !DILocation(line: 555, column: 36, scope: !1862)
!2031 = !DILocation(line: 555, column: 18, scope: !1862)
!2032 = !DILocation(line: 555, column: 6, scope: !1862)
!2033 = !DILocation(line: 555, column: 16, scope: !1862)
!2034 = !DILocation(line: 556, column: 19, scope: !1862)
!2035 = !DILocation(line: 556, column: 22, scope: !1862)
!2036 = !DILocation(line: 556, column: 30, scope: !1862)
!2037 = !DILocation(line: 556, column: 36, scope: !1862)
!2038 = !DILocation(line: 556, column: 18, scope: !1862)
!2039 = !DILocation(line: 556, column: 6, scope: !1862)
!2040 = !DILocation(line: 556, column: 16, scope: !1862)
!2041 = !DILocation(line: 557, column: 18, scope: !1862)
!2042 = !DILocation(line: 557, column: 21, scope: !1862)
!2043 = !DILocation(line: 557, column: 6, scope: !1862)
!2044 = !DILocation(line: 557, column: 16, scope: !1862)
!2045 = !DILocation(line: 558, column: 18, scope: !1862)
!2046 = !DILocation(line: 558, column: 21, scope: !1862)
!2047 = !DILocation(line: 558, column: 6, scope: !1862)
!2048 = !DILocation(line: 558, column: 16, scope: !1862)
!2049 = !DILocation(line: 560, column: 22, scope: !1862)
!2050 = !DILocation(line: 560, column: 56, scope: !1862)
!2051 = !DILocation(line: 560, column: 6, scope: !1862)
!2052 = !DILocation(line: 561, column: 6, scope: !1862)
!2053 = !DILocation(line: 564, column: 14, scope: !1862)
!2054 = !DILocation(line: 564, column: 86, scope: !1862)
!2055 = !DILocation(line: 564, column: 89, scope: !1862)
!2056 = !DILocation(line: 564, column: 6, scope: !1862)
!2057 = !DILocation(line: 565, column: 6, scope: !1862)
!2058 = !DILocation(line: 567, column: 6, scope: !1855)
!2059 = !DILocation(line: 567, column: 9, scope: !1855)
!2060 = !DILocation(line: 567, column: 4, scope: !1855)
!2061 = distinct !{!2061, !1846, !2062}
!2062 = !DILocation(line: 568, column: 5, scope: !573)
!2063 = !DILocation(line: 569, column: 19, scope: !573)
!2064 = !DILocation(line: 569, column: 28, scope: !573)
!2065 = !DILocation(line: 569, column: 5, scope: !573)
!2066 = !DILocation(line: 572, column: 5, scope: !573)
!2067 = !DILocation(line: 574, column: 12, scope: !573)
!2068 = !DILocation(line: 574, column: 5, scope: !573)
!2069 = !DILocation(line: 575, column: 1, scope: !573)
!2070 = distinct !DISubprogram(name: "MatteGIF", scope: !13, file: !13, line: 578, type: !2071, scopeLine: 580, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !4)
!2071 = !DISubroutineType(types: !2072)
!2072 = !{!7, !250}
!2073 = !DILocalVariable(name: "matte", arg: 1, scope: !2070, file: !13, line: 578, type: !250)
!2074 = !DILocation(line: 578, column: 19, scope: !2070)
!2075 = !DILocalVariable(name: "icount", scope: !2070, file: !13, line: 581, type: !7)
!2076 = !DILocation(line: 581, column: 9, scope: !2070)
!2077 = !DILocation(line: 584, column: 18, scope: !2078)
!2078 = distinct !DILexicalBlock(scope: !2070, file: !13, line: 584, column: 5)
!2079 = !DILocation(line: 584, column: 10, scope: !2078)
!2080 = !DILocation(line: 584, column: 28, scope: !2081)
!2081 = distinct !DILexicalBlock(scope: !2078, file: !13, line: 584, column: 5)
!2082 = !DILocation(line: 584, column: 5, scope: !2078)
!2083 = !DILocation(line: 585, column: 6, scope: !2084)
!2084 = distinct !DILexicalBlock(scope: !2085, file: !13, line: 585, column: 6)
!2085 = distinct !DILexicalBlock(scope: !2081, file: !13, line: 584, column: 63)
!2086 = !DILocation(line: 585, column: 15, scope: !2084)
!2087 = !DILocation(line: 585, column: 6, scope: !2085)
!2088 = !DILocation(line: 586, column: 10, scope: !2089)
!2089 = distinct !DILexicalBlock(scope: !2090, file: !13, line: 586, column: 10)
!2090 = distinct !DILexicalBlock(scope: !2084, file: !13, line: 585, column: 28)
!2091 = !DILocation(line: 586, column: 19, scope: !2089)
!2092 = !DILocation(line: 586, column: 32, scope: !2089)
!2093 = !DILocation(line: 586, column: 38, scope: !2089)
!2094 = !DILocation(line: 586, column: 10, scope: !2090)
!2095 = !DILocation(line: 587, column: 11, scope: !2089)
!2096 = !DILocation(line: 589, column: 4, scope: !2089)
!2097 = !DILocation(line: 587, column: 3, scope: !2089)
!2098 = !DILocation(line: 591, column: 7, scope: !2099)
!2099 = distinct !DILexicalBlock(scope: !2100, file: !13, line: 591, column: 7)
!2100 = distinct !DILexicalBlock(scope: !2089, file: !13, line: 590, column: 11)
!2101 = !DILocation(line: 591, column: 7, scope: !2100)
!2102 = !DILocation(line: 592, column: 15, scope: !2103)
!2103 = distinct !DILexicalBlock(scope: !2099, file: !13, line: 591, column: 16)
!2104 = !DILocation(line: 594, column: 4, scope: !2103)
!2105 = !DILocation(line: 594, column: 12, scope: !2103)
!2106 = !DILocation(line: 594, column: 21, scope: !2103)
!2107 = !DILocation(line: 594, column: 34, scope: !2103)
!2108 = !DILocation(line: 592, column: 7, scope: !2103)
!2109 = !DILocation(line: 595, column: 3, scope: !2103)
!2110 = !DILocation(line: 597, column: 3, scope: !2100)
!2111 = !DILocation(line: 597, column: 12, scope: !2100)
!2112 = !DILocation(line: 597, column: 25, scope: !2100)
!2113 = !DILocation(line: 597, column: 32, scope: !2100)
!2114 = !DILocation(line: 597, column: 41, scope: !2100)
!2115 = !DILocation(line: 597, column: 54, scope: !2100)
!2116 = !DILocation(line: 597, column: 63, scope: !2100)
!2117 = !DILocation(line: 598, column: 3, scope: !2100)
!2118 = !DILocation(line: 598, column: 12, scope: !2100)
!2119 = !DILocation(line: 598, column: 25, scope: !2100)
!2120 = !DILocation(line: 598, column: 31, scope: !2100)
!2121 = !DILocation(line: 600, column: 2, scope: !2090)
!2122 = !DILocation(line: 601, column: 5, scope: !2085)
!2123 = !DILocation(line: 584, column: 48, scope: !2081)
!2124 = !DILocation(line: 584, column: 57, scope: !2081)
!2125 = !DILocation(line: 584, column: 46, scope: !2081)
!2126 = !DILocation(line: 584, column: 5, scope: !2081)
!2127 = distinct !{!2127, !2082, !2128}
!2128 = !DILocation(line: 601, column: 5, scope: !2078)
!2129 = !DILocation(line: 602, column: 12, scope: !2070)
!2130 = !DILocation(line: 602, column: 5, scope: !2070)
!2131 = distinct !DISubprogram(name: "processfilter", scope: !13, file: !13, line: 605, type: !2132, scopeLine: 606, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !4)
!2132 = !DISubroutineType(types: !2133)
!2133 = !{!7}
!2134 = !DILocalVariable(name: "num_pics", scope: !2131, file: !13, line: 607, type: !7)
!2135 = !DILocation(line: 607, column: 9, scope: !2131)
!2136 = !DILocalVariable(name: "start", scope: !2131, file: !13, line: 608, type: !235)
!2137 = !DILocation(line: 608, column: 24, scope: !2131)
!2138 = !DILocation(line: 610, column: 13, scope: !2131)
!2139 = !DILocation(line: 611, column: 25, scope: !2131)
!2140 = !DILocation(line: 611, column: 16, scope: !2131)
!2141 = !DILocation(line: 611, column: 14, scope: !2131)
!2142 = !DILocation(line: 612, column: 12, scope: !2131)
!2143 = !DILocation(line: 612, column: 5, scope: !2131)
!2144 = !DILocation(line: 614, column: 9, scope: !2145)
!2145 = distinct !DILexicalBlock(scope: !2131, file: !13, line: 614, column: 9)
!2146 = !DILocation(line: 614, column: 18, scope: !2145)
!2147 = !DILocation(line: 614, column: 9, scope: !2131)
!2148 = !DILocation(line: 615, column: 10, scope: !2149)
!2149 = distinct !DILexicalBlock(scope: !2145, file: !13, line: 614, column: 24)
!2150 = !DILocation(line: 615, column: 62, scope: !2149)
!2151 = !DILocation(line: 615, column: 2, scope: !2149)
!2152 = !DILocation(line: 616, column: 2, scope: !2149)
!2153 = !DILocation(line: 620, column: 9, scope: !2154)
!2154 = distinct !DILexicalBlock(scope: !2131, file: !13, line: 620, column: 9)
!2155 = !DILocation(line: 620, column: 9, scope: !2131)
!2156 = !DILocation(line: 621, column: 2, scope: !2154)
!2157 = !DILocation(line: 623, column: 11, scope: !2131)
!2158 = !DILocation(line: 624, column: 26, scope: !2159)
!2159 = distinct !DILexicalBlock(scope: !2131, file: !13, line: 624, column: 5)
!2160 = !DILocation(line: 624, column: 18, scope: !2159)
!2161 = !DILocation(line: 624, column: 10, scope: !2159)
!2162 = !DILocation(line: 624, column: 32, scope: !2163)
!2163 = distinct !DILexicalBlock(scope: !2159, file: !13, line: 624, column: 5)
!2164 = !DILocation(line: 624, column: 5, scope: !2159)
!2165 = !DILocation(line: 625, column: 6, scope: !2166)
!2166 = distinct !DILexicalBlock(scope: !2167, file: !13, line: 625, column: 6)
!2167 = distinct !DILexicalBlock(scope: !2163, file: !13, line: 624, column: 67)
!2168 = !DILocation(line: 625, column: 12, scope: !2166)
!2169 = !DILocation(line: 625, column: 6, scope: !2167)
!2170 = !DILocation(line: 625, column: 29, scope: !2166)
!2171 = !DILocation(line: 625, column: 27, scope: !2166)
!2172 = !DILocation(line: 625, column: 21, scope: !2166)
!2173 = !DILocation(line: 626, column: 6, scope: !2174)
!2174 = distinct !DILexicalBlock(scope: !2167, file: !13, line: 626, column: 6)
!2175 = !DILocation(line: 626, column: 15, scope: !2174)
!2176 = !DILocation(line: 626, column: 23, scope: !2174)
!2177 = !DILocation(line: 626, column: 6, scope: !2167)
!2178 = !DILocation(line: 627, column: 22, scope: !2179)
!2179 = distinct !DILexicalBlock(scope: !2174, file: !13, line: 626, column: 36)
!2180 = !DILocation(line: 627, column: 29, scope: !2179)
!2181 = !DILocation(line: 627, column: 38, scope: !2179)
!2182 = !DILocation(line: 627, column: 12, scope: !2179)
!2183 = !DILocation(line: 628, column: 12, scope: !2179)
!2184 = !DILocation(line: 629, column: 6, scope: !2179)
!2185 = !DILocation(line: 630, column: 2, scope: !2179)
!2186 = !DILocation(line: 631, column: 5, scope: !2167)
!2187 = !DILocation(line: 624, column: 52, scope: !2163)
!2188 = !DILocation(line: 624, column: 61, scope: !2163)
!2189 = !DILocation(line: 624, column: 50, scope: !2163)
!2190 = !DILocation(line: 624, column: 5, scope: !2163)
!2191 = distinct !{!2191, !2164, !2192}
!2192 = !DILocation(line: 631, column: 5, scope: !2159)
!2193 = !DILocation(line: 632, column: 5, scope: !2131)
!2194 = !DILocation(line: 633, column: 5, scope: !2131)
!2195 = !DILocation(line: 634, column: 1, scope: !2131)
!2196 = distinct !DISubprogram(name: "processfile", scope: !13, file: !13, line: 636, type: !2197, scopeLine: 637, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !4)
!2197 = !DISubroutineType(types: !2198)
!2198 = !{!7, !75, !576}
!2199 = !DILocalVariable(name: "fname", arg: 1, scope: !2196, file: !13, line: 636, type: !75)
!2200 = !DILocation(line: 636, column: 23, scope: !2196)
!2201 = !DILocalVariable(name: "fp", arg: 2, scope: !2196, file: !13, line: 636, type: !576)
!2202 = !DILocation(line: 636, column: 36, scope: !2196)
!2203 = !DILocalVariable(name: "outname", scope: !2196, file: !13, line: 638, type: !2204)
!2204 = !DICompositeType(tag: DW_TAG_array_type, baseType: !76, size: 8200, elements: !2205)
!2205 = !{!2206}
!2206 = !DISubrange(count: 1025)
!2207 = !DILocation(line: 638, column: 10, scope: !2196)
!2208 = !DILocalVariable(name: "num_pics", scope: !2196, file: !13, line: 639, type: !7)
!2209 = !DILocation(line: 639, column: 9, scope: !2196)
!2210 = !DILocalVariable(name: "start", scope: !2196, file: !13, line: 640, type: !235)
!2211 = !DILocation(line: 640, column: 24, scope: !2196)
!2212 = !DILocalVariable(name: "i", scope: !2196, file: !13, line: 641, type: !7)
!2213 = !DILocation(line: 641, column: 9, scope: !2196)
!2214 = !DILocalVariable(name: "suppress_delete", scope: !2196, file: !13, line: 641, type: !7)
!2215 = !DILocation(line: 641, column: 12, scope: !2196)
!2216 = !DILocalVariable(name: "file_ext", scope: !2196, file: !13, line: 642, type: !75)
!2217 = !DILocation(line: 642, column: 11, scope: !2196)
!2218 = !DILocation(line: 644, column: 9, scope: !2219)
!2219 = distinct !DILexicalBlock(scope: !2196, file: !13, line: 644, column: 9)
!2220 = !DILocation(line: 644, column: 12, scope: !2219)
!2221 = !DILocation(line: 644, column: 9, scope: !2196)
!2222 = !DILocation(line: 644, column: 21, scope: !2219)
!2223 = !DILocation(line: 646, column: 13, scope: !2196)
!2224 = !DILocation(line: 648, column: 25, scope: !2196)
!2225 = !DILocation(line: 648, column: 16, scope: !2196)
!2226 = !DILocation(line: 648, column: 14, scope: !2196)
!2227 = !DILocation(line: 650, column: 12, scope: !2196)
!2228 = !DILocation(line: 650, column: 5, scope: !2196)
!2229 = !DILocation(line: 652, column: 9, scope: !2230)
!2230 = distinct !DILexicalBlock(scope: !2196, file: !13, line: 652, column: 9)
!2231 = !DILocation(line: 652, column: 18, scope: !2230)
!2232 = !DILocation(line: 652, column: 23, scope: !2230)
!2233 = !DILocation(line: 652, column: 26, scope: !2230)
!2234 = !DILocation(line: 652, column: 34, scope: !2230)
!2235 = !DILocation(line: 652, column: 9, scope: !2196)
!2236 = !DILocation(line: 653, column: 10, scope: !2230)
!2237 = !DILocation(line: 653, column: 52, scope: !2230)
!2238 = !DILocation(line: 653, column: 2, scope: !2230)
!2239 = !DILocation(line: 655, column: 9, scope: !2240)
!2240 = distinct !DILexicalBlock(scope: !2196, file: !13, line: 655, column: 9)
!2241 = !DILocation(line: 655, column: 18, scope: !2240)
!2242 = !DILocation(line: 655, column: 9, scope: !2196)
!2243 = !DILocation(line: 656, column: 2, scope: !2240)
!2244 = !DILocation(line: 658, column: 9, scope: !2245)
!2245 = distinct !DILexicalBlock(scope: !2196, file: !13, line: 658, column: 9)
!2246 = !DILocation(line: 658, column: 9, scope: !2196)
!2247 = !DILocation(line: 659, column: 6, scope: !2248)
!2248 = distinct !DILexicalBlock(scope: !2245, file: !13, line: 659, column: 6)
!2249 = !DILocation(line: 659, column: 15, scope: !2248)
!2250 = !DILocation(line: 659, column: 6, scope: !2245)
!2251 = !DILocation(line: 661, column: 14, scope: !2252)
!2252 = distinct !DILexicalBlock(scope: !2248, file: !13, line: 660, column: 2)
!2253 = !DILocation(line: 661, column: 54, scope: !2252)
!2254 = !DILocation(line: 661, column: 6, scope: !2252)
!2255 = !DILocation(line: 662, column: 6, scope: !2252)
!2256 = !DILocation(line: 666, column: 21, scope: !2257)
!2257 = distinct !DILexicalBlock(scope: !2248, file: !13, line: 665, column: 2)
!2258 = !DILocation(line: 666, column: 6, scope: !2257)
!2259 = !DILocation(line: 667, column: 6, scope: !2257)
!2260 = !DILocation(line: 671, column: 9, scope: !2261)
!2261 = distinct !DILexicalBlock(scope: !2196, file: !13, line: 671, column: 9)
!2262 = !DILocation(line: 671, column: 9, scope: !2196)
!2263 = !DILocation(line: 672, column: 2, scope: !2261)
!2264 = !DILocation(line: 676, column: 12, scope: !2196)
!2265 = !DILocation(line: 676, column: 21, scope: !2196)
!2266 = !DILocation(line: 676, column: 5, scope: !2196)
!2267 = !DILocation(line: 678, column: 16, scope: !2196)
!2268 = !DILocation(line: 678, column: 31, scope: !2196)
!2269 = !DILocation(line: 678, column: 24, scope: !2196)
!2270 = !DILocation(line: 678, column: 23, scope: !2196)
!2271 = !DILocation(line: 678, column: 39, scope: !2196)
!2272 = !DILocation(line: 678, column: 14, scope: !2196)
!2273 = !DILocation(line: 679, column: 16, scope: !2274)
!2274 = distinct !DILexicalBlock(scope: !2196, file: !13, line: 679, column: 9)
!2275 = !DILocation(line: 679, column: 9, scope: !2274)
!2276 = !DILocation(line: 679, column: 34, scope: !2274)
!2277 = !DILocation(line: 679, column: 39, scope: !2274)
!2278 = !DILocation(line: 679, column: 49, scope: !2274)
!2279 = !DILocation(line: 679, column: 42, scope: !2274)
!2280 = !DILocation(line: 679, column: 67, scope: !2274)
!2281 = !DILocation(line: 679, column: 72, scope: !2274)
!2282 = !DILocation(line: 680, column: 9, scope: !2274)
!2283 = !DILocation(line: 680, column: 2, scope: !2274)
!2284 = !DILocation(line: 680, column: 27, scope: !2274)
!2285 = !DILocation(line: 680, column: 32, scope: !2274)
!2286 = !DILocation(line: 680, column: 42, scope: !2274)
!2287 = !DILocation(line: 680, column: 35, scope: !2274)
!2288 = !DILocation(line: 680, column: 60, scope: !2274)
!2289 = !DILocation(line: 679, column: 9, scope: !2196)
!2290 = !DILocation(line: 682, column: 13, scope: !2291)
!2291 = distinct !DILexicalBlock(scope: !2274, file: !13, line: 680, column: 66)
!2292 = !DILocation(line: 682, column: 28, scope: !2291)
!2293 = !DILocation(line: 682, column: 21, scope: !2291)
!2294 = !DILocation(line: 682, column: 20, scope: !2291)
!2295 = !DILocation(line: 682, column: 11, scope: !2291)
!2296 = !DILocation(line: 683, column: 2, scope: !2291)
!2297 = !DILocation(line: 683, column: 8, scope: !2291)
!2298 = !DILocation(line: 683, column: 20, scope: !2291)
!2299 = !DILocation(line: 683, column: 17, scope: !2291)
!2300 = !DILocation(line: 684, column: 11, scope: !2301)
!2301 = distinct !DILexicalBlock(scope: !2302, file: !13, line: 684, column: 10)
!2302 = distinct !DILexicalBlock(scope: !2291, file: !13, line: 683, column: 29)
!2303 = !DILocation(line: 684, column: 10, scope: !2301)
!2304 = !DILocation(line: 684, column: 20, scope: !2301)
!2305 = !DILocation(line: 684, column: 27, scope: !2301)
!2306 = !DILocation(line: 684, column: 31, scope: !2301)
!2307 = !DILocation(line: 684, column: 30, scope: !2301)
!2308 = !DILocation(line: 684, column: 40, scope: !2301)
!2309 = !DILocation(line: 684, column: 47, scope: !2301)
!2310 = !DILocation(line: 684, column: 51, scope: !2301)
!2311 = !DILocation(line: 684, column: 50, scope: !2301)
!2312 = !DILocation(line: 684, column: 60, scope: !2301)
!2313 = !DILocation(line: 684, column: 10, scope: !2302)
!2314 = !DILocation(line: 684, column: 69, scope: !2301)
!2315 = !DILocation(line: 685, column: 14, scope: !2302)
!2316 = distinct !{!2316, !2296, !2317}
!2317 = !DILocation(line: 686, column: 2, scope: !2291)
!2318 = !DILocation(line: 687, column: 6, scope: !2319)
!2319 = distinct !DILexicalBlock(scope: !2291, file: !13, line: 687, column: 6)
!2320 = !DILocation(line: 687, column: 15, scope: !2319)
!2321 = !DILocation(line: 687, column: 14, scope: !2319)
!2322 = !DILocation(line: 687, column: 23, scope: !2319)
!2323 = !DILocation(line: 687, column: 27, scope: !2319)
!2324 = !DILocation(line: 687, column: 26, scope: !2319)
!2325 = !DILocation(line: 687, column: 36, scope: !2319)
!2326 = !DILocation(line: 687, column: 6, scope: !2291)
!2327 = !DILocation(line: 689, column: 17, scope: !2328)
!2328 = distinct !DILexicalBlock(scope: !2319, file: !13, line: 687, column: 44)
!2329 = !DILocation(line: 689, column: 32, scope: !2328)
!2330 = !DILocation(line: 689, column: 25, scope: !2328)
!2331 = !DILocation(line: 689, column: 24, scope: !2328)
!2332 = !DILocation(line: 689, column: 15, scope: !2328)
!2333 = !DILocation(line: 690, column: 2, scope: !2328)
!2334 = !DILocation(line: 691, column: 5, scope: !2291)
!2335 = !DILocation(line: 693, column: 12, scope: !2196)
!2336 = !DILocation(line: 693, column: 5, scope: !2196)
!2337 = !DILocation(line: 695, column: 11, scope: !2196)
!2338 = !DILocation(line: 697, column: 7, scope: !2196)
!2339 = !DILocation(line: 699, column: 26, scope: !2340)
!2340 = distinct !DILexicalBlock(scope: !2196, file: !13, line: 699, column: 5)
!2341 = !DILocation(line: 699, column: 18, scope: !2340)
!2342 = !DILocation(line: 699, column: 10, scope: !2340)
!2343 = !DILocation(line: 699, column: 32, scope: !2344)
!2344 = distinct !DILexicalBlock(scope: !2340, file: !13, line: 699, column: 5)
!2345 = !DILocation(line: 699, column: 5, scope: !2340)
!2346 = !DILocation(line: 700, column: 6, scope: !2347)
!2347 = distinct !DILexicalBlock(scope: !2348, file: !13, line: 700, column: 6)
!2348 = distinct !DILexicalBlock(scope: !2344, file: !13, line: 699, column: 67)
!2349 = !DILocation(line: 700, column: 12, scope: !2347)
!2350 = !DILocation(line: 700, column: 6, scope: !2348)
!2351 = !DILocation(line: 700, column: 29, scope: !2347)
!2352 = !DILocation(line: 700, column: 27, scope: !2347)
!2353 = !DILocation(line: 700, column: 21, scope: !2347)
!2354 = !DILocation(line: 701, column: 6, scope: !2355)
!2355 = distinct !DILexicalBlock(scope: !2348, file: !13, line: 701, column: 6)
!2356 = !DILocation(line: 701, column: 15, scope: !2355)
!2357 = !DILocation(line: 701, column: 23, scope: !2355)
!2358 = !DILocation(line: 701, column: 6, scope: !2348)
!2359 = !DILocation(line: 702, column: 7, scope: !2360)
!2360 = distinct !DILexicalBlock(scope: !2355, file: !13, line: 701, column: 36)
!2361 = !DILocation(line: 703, column: 22, scope: !2362)
!2362 = distinct !DILexicalBlock(scope: !2360, file: !13, line: 703, column: 10)
!2363 = !DILocation(line: 703, column: 16, scope: !2362)
!2364 = !DILocation(line: 703, column: 14, scope: !2362)
!2365 = !DILocation(line: 703, column: 38, scope: !2362)
!2366 = !DILocation(line: 703, column: 10, scope: !2360)
!2367 = !DILocation(line: 704, column: 10, scope: !2368)
!2368 = distinct !DILexicalBlock(scope: !2362, file: !13, line: 703, column: 47)
!2369 = !DILocation(line: 704, column: 3, scope: !2368)
!2370 = !DILocation(line: 705, column: 3, scope: !2368)
!2371 = !DILocation(line: 707, column: 32, scope: !2372)
!2372 = distinct !DILexicalBlock(scope: !2362, file: !13, line: 706, column: 13)
!2373 = !DILocation(line: 707, column: 39, scope: !2372)
!2374 = !DILocation(line: 707, column: 48, scope: !2372)
!2375 = !DILocation(line: 707, column: 52, scope: !2372)
!2376 = !DILocation(line: 707, column: 57, scope: !2372)
!2377 = !DILocation(line: 707, column: 54, scope: !2372)
!2378 = !DILocation(line: 707, column: 22, scope: !2372)
!2379 = !DILocation(line: 707, column: 19, scope: !2372)
!2380 = !DILocation(line: 708, column: 10, scope: !2372)
!2381 = !DILocation(line: 708, column: 3, scope: !2372)
!2382 = !DILocation(line: 709, column: 3, scope: !2372)
!2383 = !DILocation(line: 710, column: 9, scope: !2372)
!2384 = !DILocation(line: 711, column: 11, scope: !2372)
!2385 = !DILocation(line: 711, column: 31, scope: !2372)
!2386 = !DILocation(line: 711, column: 3, scope: !2372)
!2387 = !DILocation(line: 713, column: 2, scope: !2360)
!2388 = !DILocation(line: 714, column: 5, scope: !2348)
!2389 = !DILocation(line: 699, column: 52, scope: !2344)
!2390 = !DILocation(line: 699, column: 61, scope: !2344)
!2391 = !DILocation(line: 699, column: 50, scope: !2344)
!2392 = !DILocation(line: 699, column: 5, scope: !2344)
!2393 = distinct !{!2393, !2345, !2394}
!2394 = !DILocation(line: 714, column: 5, scope: !2340)
!2395 = !DILocation(line: 716, column: 5, scope: !2196)
!2396 = !DILocation(line: 718, column: 9, scope: !2397)
!2397 = distinct !DILexicalBlock(scope: !2196, file: !13, line: 718, column: 9)
!2398 = !DILocation(line: 718, column: 16, scope: !2397)
!2399 = !DILocation(line: 718, column: 20, scope: !2397)
!2400 = !DILocation(line: 718, column: 9, scope: !2196)
!2401 = !DILocation(line: 719, column: 9, scope: !2402)
!2402 = distinct !DILexicalBlock(scope: !2397, file: !13, line: 718, column: 37)
!2403 = !DILocation(line: 719, column: 2, scope: !2402)
!2404 = !DILocation(line: 720, column: 5, scope: !2402)
!2405 = !DILocation(line: 722, column: 5, scope: !2196)
!2406 = !DILocation(line: 723, column: 1, scope: !2196)
!2407 = distinct !DISubprogram(name: "input_is_terminal", scope: !13, file: !13, line: 729, type: !2132, scopeLine: 730, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !4)
!2408 = !DILocation(line: 731, column: 26, scope: !2407)
!2409 = !DILocation(line: 731, column: 19, scope: !2407)
!2410 = !DILocation(line: 731, column: 12, scope: !2407)
!2411 = !DILocation(line: 731, column: 5, scope: !2407)
!2412 = distinct !DISubprogram(name: "main", scope: !13, file: !13, line: 734, type: !2413, scopeLine: 735, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !4)
!2413 = !DISubroutineType(types: !2414)
!2414 = !{!7, !7, !138}
!2415 = !DILocalVariable(name: "argc", arg: 1, scope: !2412, file: !13, line: 734, type: !7)
!2416 = !DILocation(line: 734, column: 14, scope: !2412)
!2417 = !DILocalVariable(name: "argv", arg: 2, scope: !2412, file: !13, line: 734, type: !138)
!2418 = !DILocation(line: 734, column: 26, scope: !2412)
!2419 = !DILocalVariable(name: "fp", scope: !2412, file: !13, line: 736, type: !576)
!2420 = !DILocation(line: 736, column: 11, scope: !2412)
!2421 = !DILocalVariable(name: "i", scope: !2412, file: !13, line: 737, type: !7)
!2422 = !DILocation(line: 737, column: 9, scope: !2412)
!2423 = !DILocalVariable(name: "background", scope: !2412, file: !13, line: 737, type: !7)
!2424 = !DILocation(line: 737, column: 12, scope: !2412)
!2425 = !DILocalVariable(name: "errors", scope: !2412, file: !13, line: 738, type: !7)
!2426 = !DILocation(line: 738, column: 9, scope: !2412)
!2427 = !DILocalVariable(name: "name", scope: !2412, file: !13, line: 739, type: !2204)
!2428 = !DILocation(line: 739, column: 10, scope: !2412)
!2429 = !DILocalVariable(name: "ac", scope: !2412, file: !13, line: 740, type: !7)
!2430 = !DILocation(line: 740, column: 9, scope: !2412)
!2431 = !DILocalVariable(name: "color", scope: !2412, file: !13, line: 741, type: !75)
!2432 = !DILocation(line: 741, column: 11, scope: !2412)
!2433 = !DILocation(line: 743, column: 20, scope: !2412)
!2434 = !DILocation(line: 745, column: 8, scope: !2412)
!2435 = !DILocation(line: 747, column: 13, scope: !2436)
!2436 = distinct !DILexicalBlock(scope: !2412, file: !13, line: 747, column: 5)
!2437 = !DILocation(line: 747, column: 10, scope: !2436)
!2438 = !DILocation(line: 747, column: 18, scope: !2439)
!2439 = distinct !DILexicalBlock(scope: !2436, file: !13, line: 747, column: 5)
!2440 = !DILocation(line: 747, column: 21, scope: !2439)
!2441 = !DILocation(line: 747, column: 20, scope: !2439)
!2442 = !DILocation(line: 747, column: 26, scope: !2439)
!2443 = !DILocation(line: 747, column: 29, scope: !2439)
!2444 = !DILocation(line: 747, column: 34, scope: !2439)
!2445 = !DILocation(line: 747, column: 41, scope: !2439)
!2446 = !DILocation(line: 0, scope: !2439)
!2447 = !DILocation(line: 747, column: 5, scope: !2436)
!2448 = !DILocation(line: 749, column: 9, scope: !2449)
!2449 = distinct !DILexicalBlock(scope: !2450, file: !13, line: 749, column: 2)
!2450 = distinct !DILexicalBlock(scope: !2439, file: !13, line: 748, column: 5)
!2451 = !DILocation(line: 749, column: 7, scope: !2449)
!2452 = !DILocation(line: 749, column: 13, scope: !2453)
!2453 = distinct !DILexicalBlock(scope: !2449, file: !13, line: 749, column: 2)
!2454 = !DILocation(line: 749, column: 22, scope: !2453)
!2455 = !DILocation(line: 749, column: 27, scope: !2453)
!2456 = !DILocation(line: 749, column: 15, scope: !2453)
!2457 = !DILocation(line: 749, column: 14, scope: !2453)
!2458 = !DILocation(line: 749, column: 2, scope: !2449)
!2459 = !DILocation(line: 750, column: 13, scope: !2453)
!2460 = !DILocation(line: 750, column: 18, scope: !2453)
!2461 = !DILocation(line: 750, column: 22, scope: !2453)
!2462 = !DILocation(line: 750, column: 6, scope: !2453)
!2463 = !DILocation(line: 752, column: 7, scope: !2464)
!2464 = distinct !DILexicalBlock(scope: !2465, file: !13, line: 752, column: 7)
!2465 = distinct !DILexicalBlock(scope: !2453, file: !13, line: 750, column: 26)
!2466 = !DILocation(line: 752, column: 13, scope: !2464)
!2467 = !DILocation(line: 752, column: 18, scope: !2464)
!2468 = !DILocation(line: 752, column: 10, scope: !2464)
!2469 = !DILocation(line: 752, column: 7, scope: !2465)
!2470 = !DILocation(line: 755, column: 6, scope: !2471)
!2471 = distinct !DILexicalBlock(scope: !2464, file: !13, line: 753, column: 3)
!2472 = !DILocation(line: 754, column: 7, scope: !2471)
!2473 = !DILocation(line: 756, column: 7, scope: !2471)
!2474 = !DILocation(line: 758, column: 11, scope: !2465)
!2475 = !DILocation(line: 758, column: 16, scope: !2465)
!2476 = !DILocation(line: 758, column: 9, scope: !2465)
!2477 = !DILocation(line: 759, column: 8, scope: !2478)
!2478 = distinct !DILexicalBlock(scope: !2465, file: !13, line: 759, column: 7)
!2479 = !DILocation(line: 759, column: 7, scope: !2478)
!2480 = !DILocation(line: 759, column: 14, scope: !2478)
!2481 = !DILocation(line: 759, column: 7, scope: !2465)
!2482 = !DILocation(line: 760, column: 12, scope: !2478)
!2483 = !DILocation(line: 760, column: 7, scope: !2478)
!2484 = !DILocation(line: 761, column: 17, scope: !2465)
!2485 = !DILocation(line: 761, column: 10, scope: !2465)
!2486 = !DILocation(line: 762, column: 22, scope: !2465)
!2487 = !DILocation(line: 762, column: 33, scope: !2465)
!2488 = !DILocation(line: 762, column: 40, scope: !2465)
!2489 = !DILocation(line: 762, column: 21, scope: !2465)
!2490 = !DILocation(line: 762, column: 19, scope: !2465)
!2491 = !DILocation(line: 763, column: 24, scope: !2465)
!2492 = !DILocation(line: 763, column: 35, scope: !2465)
!2493 = !DILocation(line: 763, column: 41, scope: !2465)
!2494 = !DILocation(line: 763, column: 23, scope: !2465)
!2495 = !DILocation(line: 763, column: 21, scope: !2465)
!2496 = !DILocation(line: 764, column: 22, scope: !2465)
!2497 = !DILocation(line: 764, column: 33, scope: !2465)
!2498 = !DILocation(line: 764, column: 20, scope: !2465)
!2499 = !DILocation(line: 765, column: 9, scope: !2465)
!2500 = !DILocation(line: 766, column: 3, scope: !2465)
!2501 = !DILocation(line: 769, column: 10, scope: !2465)
!2502 = !DILocation(line: 770, column: 3, scope: !2465)
!2503 = !DILocation(line: 774, column: 14, scope: !2465)
!2504 = !DILocation(line: 775, column: 3, scope: !2465)
!2505 = !DILocation(line: 778, column: 14, scope: !2465)
!2506 = !DILocation(line: 779, column: 3, scope: !2465)
!2507 = !DILocation(line: 782, column: 13, scope: !2465)
!2508 = !DILocation(line: 783, column: 3, scope: !2465)
!2509 = !DILocation(line: 786, column: 14, scope: !2465)
!2510 = !DILocation(line: 787, column: 3, scope: !2465)
!2511 = !DILocation(line: 790, column: 14, scope: !2465)
!2512 = !DILocation(line: 791, column: 3, scope: !2465)
!2513 = !DILocation(line: 794, column: 12, scope: !2465)
!2514 = !DILocation(line: 795, column: 3, scope: !2465)
!2515 = !DILocation(line: 798, column: 11, scope: !2465)
!2516 = !DILocation(line: 799, column: 3, scope: !2465)
!2517 = !DILocation(line: 802, column: 18, scope: !2465)
!2518 = !DILocation(line: 803, column: 3, scope: !2465)
!2519 = !DILocation(line: 806, column: 3, scope: !2465)
!2520 = !DILocation(line: 807, column: 3, scope: !2465)
!2521 = !DILocation(line: 810, column: 14, scope: !2465)
!2522 = !DILocation(line: 811, column: 3, scope: !2465)
!2523 = !DILocation(line: 814, column: 12, scope: !2465)
!2524 = !DILocation(line: 815, column: 3, scope: !2465)
!2525 = !DILocation(line: 818, column: 11, scope: !2465)
!2526 = !DILocation(line: 818, column: 54, scope: !2465)
!2527 = !DILocation(line: 818, column: 59, scope: !2465)
!2528 = !DILocation(line: 818, column: 63, scope: !2465)
!2529 = !DILocation(line: 818, column: 3, scope: !2465)
!2530 = !DILabel(scope: !2465, name: "usage", file: !13, line: 819)
!2531 = !DILocation(line: 819, column: 6, scope: !2465)
!2532 = !DILocation(line: 820, column: 11, scope: !2465)
!2533 = !DILocation(line: 820, column: 3, scope: !2465)
!2534 = !DILocation(line: 843, column: 3, scope: !2465)
!2535 = !DILocation(line: 844, column: 6, scope: !2465)
!2536 = !DILocation(line: 749, column: 34, scope: !2453)
!2537 = !DILocation(line: 749, column: 2, scope: !2453)
!2538 = distinct !{!2538, !2458, !2539}
!2539 = !DILocation(line: 844, column: 6, scope: !2449)
!2540 = !DILabel(scope: !2450, name: "skiparg", file: !13, line: 845)
!2541 = !DILocation(line: 845, column: 5, scope: !2450)
!2542 = !DILocation(line: 846, column: 5, scope: !2450)
!2543 = !DILocation(line: 747, column: 51, scope: !2439)
!2544 = !DILocation(line: 747, column: 5, scope: !2439)
!2545 = distinct !{!2545, !2447, !2546}
!2546 = !DILocation(line: 846, column: 5, scope: !2436)
!2547 = !DILocation(line: 848, column: 9, scope: !2548)
!2548 = distinct !DILexicalBlock(scope: !2412, file: !13, line: 848, column: 9)
!2549 = !DILocation(line: 848, column: 17, scope: !2548)
!2550 = !DILocation(line: 848, column: 9, scope: !2412)
!2551 = !DILocation(line: 849, column: 10, scope: !2548)
!2552 = !DILocation(line: 849, column: 2, scope: !2548)
!2553 = !DILocation(line: 852, column: 9, scope: !2554)
!2554 = distinct !DILexicalBlock(scope: !2412, file: !13, line: 852, column: 9)
!2555 = !DILocation(line: 852, column: 17, scope: !2554)
!2556 = !DILocation(line: 852, column: 14, scope: !2554)
!2557 = !DILocation(line: 852, column: 9, scope: !2412)
!2558 = !DILocation(line: 853, column: 6, scope: !2559)
!2559 = distinct !DILexicalBlock(scope: !2560, file: !13, line: 853, column: 6)
!2560 = distinct !DILexicalBlock(scope: !2554, file: !13, line: 852, column: 21)
!2561 = !DILocation(line: 853, column: 6, scope: !2560)
!2562 = !DILocation(line: 854, column: 6, scope: !2563)
!2563 = distinct !DILexicalBlock(scope: !2559, file: !13, line: 853, column: 27)
!2564 = !DILocation(line: 856, column: 6, scope: !2565)
!2565 = distinct !DILexicalBlock(scope: !2560, file: !13, line: 856, column: 6)
!2566 = !DILocation(line: 856, column: 14, scope: !2565)
!2567 = !DILocation(line: 856, column: 6, scope: !2560)
!2568 = !DILocation(line: 857, column: 14, scope: !2565)
!2569 = !DILocation(line: 857, column: 6, scope: !2565)
!2570 = !DILocation(line: 858, column: 6, scope: !2571)
!2571 = distinct !DILexicalBlock(scope: !2560, file: !13, line: 858, column: 6)
!2572 = !DILocation(line: 858, column: 6, scope: !2560)
!2573 = !DILocation(line: 859, column: 10, scope: !2574)
!2574 = distinct !DILexicalBlock(scope: !2575, file: !13, line: 859, column: 10)
!2575 = distinct !DILexicalBlock(scope: !2571, file: !13, line: 858, column: 18)
!2576 = !DILocation(line: 859, column: 26, scope: !2574)
!2577 = !DILocation(line: 859, column: 10, scope: !2575)
!2578 = !DILocation(line: 859, column: 32, scope: !2574)
!2579 = !DILocation(line: 860, column: 2, scope: !2575)
!2580 = !DILocation(line: 861, column: 32, scope: !2581)
!2581 = distinct !DILexicalBlock(scope: !2571, file: !13, line: 860, column: 9)
!2582 = !DILocation(line: 861, column: 6, scope: !2581)
!2583 = !DILocation(line: 862, column: 6, scope: !2581)
!2584 = !DILocation(line: 864, column: 5, scope: !2560)
!2585 = !DILocation(line: 865, column: 11, scope: !2586)
!2586 = distinct !DILexicalBlock(scope: !2587, file: !13, line: 865, column: 2)
!2587 = distinct !DILexicalBlock(scope: !2554, file: !13, line: 864, column: 12)
!2588 = !DILocation(line: 865, column: 9, scope: !2586)
!2589 = !DILocation(line: 865, column: 7, scope: !2586)
!2590 = !DILocation(line: 865, column: 14, scope: !2591)
!2591 = distinct !DILexicalBlock(scope: !2586, file: !13, line: 865, column: 2)
!2592 = !DILocation(line: 865, column: 16, scope: !2591)
!2593 = !DILocation(line: 865, column: 15, scope: !2591)
!2594 = !DILocation(line: 865, column: 2, scope: !2586)
!2595 = !DILocation(line: 866, column: 13, scope: !2596)
!2596 = distinct !DILexicalBlock(scope: !2591, file: !13, line: 865, column: 27)
!2597 = !DILocation(line: 866, column: 19, scope: !2596)
!2598 = !DILocation(line: 866, column: 24, scope: !2596)
!2599 = !DILocation(line: 866, column: 6, scope: !2596)
!2600 = !DILocation(line: 867, column: 22, scope: !2601)
!2601 = distinct !DILexicalBlock(scope: !2596, file: !13, line: 867, column: 10)
!2602 = !DILocation(line: 867, column: 16, scope: !2601)
!2603 = !DILocation(line: 867, column: 14, scope: !2601)
!2604 = !DILocation(line: 867, column: 35, scope: !2601)
!2605 = !DILocation(line: 867, column: 10, scope: !2596)
!2606 = !DILocation(line: 869, column: 10, scope: !2607)
!2607 = distinct !DILexicalBlock(scope: !2601, file: !13, line: 867, column: 44)
!2608 = !DILocation(line: 869, column: 3, scope: !2607)
!2609 = !DILocation(line: 870, column: 14, scope: !2607)
!2610 = !DILocation(line: 870, column: 8, scope: !2607)
!2611 = !DILocation(line: 870, column: 6, scope: !2607)
!2612 = !DILocation(line: 871, column: 6, scope: !2607)
!2613 = !DILocation(line: 872, column: 10, scope: !2614)
!2614 = distinct !DILexicalBlock(scope: !2596, file: !13, line: 872, column: 10)
!2615 = !DILocation(line: 872, column: 13, scope: !2614)
!2616 = !DILocation(line: 872, column: 10, scope: !2596)
!2617 = !DILocation(line: 873, column: 10, scope: !2618)
!2618 = distinct !DILexicalBlock(scope: !2614, file: !13, line: 872, column: 22)
!2619 = !DILocation(line: 873, column: 15, scope: !2618)
!2620 = !DILocation(line: 873, column: 3, scope: !2618)
!2621 = !DILocation(line: 874, column: 10, scope: !2618)
!2622 = !DILocation(line: 875, column: 6, scope: !2618)
!2623 = !DILocation(line: 876, column: 7, scope: !2624)
!2624 = distinct !DILexicalBlock(scope: !2625, file: !13, line: 876, column: 7)
!2625 = distinct !DILexicalBlock(scope: !2614, file: !13, line: 875, column: 13)
!2626 = !DILocation(line: 876, column: 15, scope: !2624)
!2627 = !DILocation(line: 876, column: 7, scope: !2625)
!2628 = !DILocation(line: 877, column: 15, scope: !2624)
!2629 = !DILocation(line: 877, column: 32, scope: !2624)
!2630 = !DILocation(line: 877, column: 7, scope: !2624)
!2631 = !DILocation(line: 878, column: 25, scope: !2625)
!2632 = !DILocation(line: 878, column: 31, scope: !2625)
!2633 = !DILocation(line: 878, column: 13, scope: !2625)
!2634 = !DILocation(line: 878, column: 10, scope: !2625)
!2635 = !DILocation(line: 880, column: 3, scope: !2625)
!2636 = !DILocation(line: 882, column: 2, scope: !2596)
!2637 = !DILocation(line: 865, column: 23, scope: !2591)
!2638 = !DILocation(line: 865, column: 2, scope: !2591)
!2639 = distinct !{!2639, !2594, !2640}
!2640 = !DILocation(line: 882, column: 2, scope: !2586)
!2641 = !DILocation(line: 885, column: 9, scope: !2642)
!2642 = distinct !DILexicalBlock(scope: !2412, file: !13, line: 885, column: 9)
!2643 = !DILocation(line: 885, column: 9, scope: !2412)
!2644 = !DILocation(line: 886, column: 10, scope: !2642)
!2645 = !DILocation(line: 887, column: 3, scope: !2642)
!2646 = !DILocation(line: 888, column: 3, scope: !2642)
!2647 = !DILocation(line: 888, column: 13, scope: !2642)
!2648 = !DILocation(line: 888, column: 21, scope: !2642)
!2649 = !DILocation(line: 888, column: 12, scope: !2642)
!2650 = !DILocation(line: 888, column: 39, scope: !2642)
!2651 = !DILocation(line: 888, column: 49, scope: !2642)
!2652 = !DILocation(line: 888, column: 57, scope: !2642)
!2653 = !DILocation(line: 888, column: 48, scope: !2642)
!2654 = !DILocation(line: 886, column: 2, scope: !2642)
!2655 = !DILocation(line: 890, column: 12, scope: !2412)
!2656 = !DILocation(line: 890, column: 5, scope: !2412)
!2657 = !DILocation(line: 891, column: 1, scope: !2412)
!2658 = distinct !DISubprogram(name: "check_recover", scope: !264, file: !264, line: 48, type: !2659, scopeLine: 49, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !263, retainedNodes: !4)
!2659 = !DISubroutineType(types: !2660)
!2660 = !{!7, !7}
!2661 = !DILocalVariable(name: "some_data", arg: 1, scope: !2658, file: !264, line: 48, type: !7)
!2662 = !DILocation(line: 48, column: 23, scope: !2658)
!2663 = !DILocation(line: 50, column: 6, scope: !2664)
!2664 = distinct !DILexicalBlock(scope: !2658, file: !264, line: 50, column: 6)
!2665 = !DILocation(line: 50, column: 6, scope: !2658)
!2666 = !DILocation(line: 51, column: 12, scope: !2664)
!2667 = !DILocation(line: 51, column: 5, scope: !2664)
!2668 = !DILocation(line: 52, column: 7, scope: !2669)
!2669 = distinct !DILexicalBlock(scope: !2658, file: !264, line: 52, column: 6)
!2670 = !DILocation(line: 52, column: 23, scope: !2669)
!2671 = !DILocation(line: 52, column: 27, scope: !2669)
!2672 = !DILocation(line: 52, column: 37, scope: !2669)
!2673 = !DILocation(line: 52, column: 40, scope: !2669)
!2674 = !DILocation(line: 52, column: 43, scope: !2669)
!2675 = !DILocation(line: 52, column: 6, scope: !2658)
!2676 = !DILocation(line: 53, column: 13, scope: !2677)
!2677 = distinct !DILexicalBlock(scope: !2669, file: !264, line: 52, column: 55)
!2678 = !DILocation(line: 53, column: 5, scope: !2677)
!2679 = !DILocation(line: 54, column: 8, scope: !2680)
!2680 = distinct !DILexicalBlock(scope: !2677, file: !264, line: 54, column: 8)
!2681 = !DILocation(line: 54, column: 18, scope: !2680)
!2682 = !DILocation(line: 54, column: 8, scope: !2677)
!2683 = !DILocation(line: 55, column: 15, scope: !2680)
!2684 = !DILocation(line: 55, column: 47, scope: !2680)
!2685 = !DILocation(line: 56, column: 16, scope: !2680)
!2686 = !DILocation(line: 56, column: 26, scope: !2680)
!2687 = !DILocation(line: 55, column: 7, scope: !2680)
!2688 = !DILocation(line: 57, column: 8, scope: !2689)
!2689 = distinct !DILexicalBlock(scope: !2677, file: !264, line: 57, column: 8)
!2690 = !DILocation(line: 57, column: 18, scope: !2689)
!2691 = !DILocation(line: 57, column: 21, scope: !2689)
!2692 = !DILocation(line: 57, column: 24, scope: !2689)
!2693 = !DILocation(line: 57, column: 8, scope: !2677)
!2694 = !DILocation(line: 58, column: 15, scope: !2689)
!2695 = !DILocation(line: 58, column: 7, scope: !2689)
!2696 = !DILocation(line: 59, column: 8, scope: !2697)
!2697 = distinct !DILexicalBlock(scope: !2677, file: !264, line: 59, column: 8)
!2698 = !DILocation(line: 59, column: 8, scope: !2677)
!2699 = !DILocation(line: 60, column: 15, scope: !2697)
!2700 = !DILocation(line: 60, column: 7, scope: !2697)
!2701 = !DILocation(line: 61, column: 13, scope: !2677)
!2702 = !DILocation(line: 61, column: 5, scope: !2677)
!2703 = !DILocation(line: 62, column: 20, scope: !2677)
!2704 = !DILocation(line: 63, column: 3, scope: !2677)
!2705 = !DILocation(line: 64, column: 3, scope: !2658)
!2706 = !DILocation(line: 65, column: 1, scope: !2658)
!2707 = !DILocalVariable(name: "fd", arg: 1, scope: !269, file: !264, line: 68, type: !272)
!2708 = !DILocation(line: 68, column: 15, scope: !269)
!2709 = !DILocalVariable(name: "buf", scope: !269, file: !264, line: 70, type: !2710)
!2710 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 128, elements: !415)
!2711 = !DILocation(line: 70, column: 17, scope: !269)
!2712 = !DILocalVariable(name: "c", scope: !269, file: !264, line: 71, type: !42)
!2713 = !DILocation(line: 71, column: 17, scope: !269)
!2714 = !DILocalVariable(name: "localColorMap", scope: !269, file: !264, line: 72, type: !334)
!2715 = !DILocation(line: 72, column: 17, scope: !269)
!2716 = !DILocalVariable(name: "useGlobalColormap", scope: !269, file: !264, line: 73, type: !7)
!2717 = !DILocation(line: 73, column: 17, scope: !269)
!2718 = !DILocalVariable(name: "bitPixel", scope: !269, file: !264, line: 74, type: !7)
!2719 = !DILocation(line: 74, column: 17, scope: !269)
!2720 = !DILocalVariable(name: "gif_version", scope: !269, file: !264, line: 75, type: !2721)
!2721 = !DICompositeType(tag: DW_TAG_array_type, baseType: !76, size: 32, elements: !2722)
!2722 = !{!2723}
!2723 = !DISubrange(count: 4)
!2724 = !DILocation(line: 75, column: 17, scope: !269)
!2725 = !DILocalVariable(name: "i", scope: !269, file: !264, line: 76, type: !7)
!2726 = !DILocation(line: 76, column: 7, scope: !269)
!2727 = !DILocalVariable(name: "w", scope: !269, file: !264, line: 77, type: !7)
!2728 = !DILocation(line: 77, column: 7, scope: !269)
!2729 = !DILocalVariable(name: "h", scope: !269, file: !264, line: 77, type: !7)
!2730 = !DILocation(line: 77, column: 10, scope: !269)
!2731 = !DILocalVariable(name: "x_off", scope: !269, file: !264, line: 77, type: !7)
!2732 = !DILocation(line: 77, column: 13, scope: !269)
!2733 = !DILocalVariable(name: "y_off", scope: !269, file: !264, line: 77, type: !7)
!2734 = !DILocation(line: 77, column: 20, scope: !269)
!2735 = !DILocation(line: 79, column: 13, scope: !269)
!2736 = !DILocation(line: 80, column: 18, scope: !269)
!2737 = !DILocation(line: 85, column: 21, scope: !269)
!2738 = !DILocation(line: 86, column: 19, scope: !269)
!2739 = !DILocation(line: 87, column: 19, scope: !269)
!2740 = !DILocation(line: 88, column: 18, scope: !269)
!2741 = !DILocation(line: 90, column: 9, scope: !2742)
!2742 = distinct !DILexicalBlock(scope: !269, file: !264, line: 90, column: 7)
!2743 = !DILocation(line: 90, column: 7, scope: !269)
!2744 = !DILocation(line: 91, column: 13, scope: !2745)
!2745 = distinct !DILexicalBlock(scope: !2742, file: !264, line: 90, column: 27)
!2746 = !DILocation(line: 91, column: 5, scope: !2745)
!2747 = !DILocation(line: 92, column: 5, scope: !2745)
!2748 = !DILocation(line: 95, column: 23, scope: !2749)
!2749 = distinct !DILexicalBlock(scope: !269, file: !264, line: 95, column: 7)
!2750 = !DILocation(line: 95, column: 7, scope: !2749)
!2751 = !DILocation(line: 95, column: 36, scope: !2749)
!2752 = !DILocation(line: 95, column: 7, scope: !269)
!2753 = !DILocation(line: 96, column: 13, scope: !2754)
!2754 = distinct !DILexicalBlock(scope: !2749, file: !264, line: 95, column: 42)
!2755 = !DILocation(line: 96, column: 5, scope: !2754)
!2756 = !DILocation(line: 97, column: 5, scope: !2754)
!2757 = !DILocation(line: 100, column: 11, scope: !269)
!2758 = !DILocation(line: 100, column: 32, scope: !269)
!2759 = !DILocation(line: 100, column: 36, scope: !269)
!2760 = !DILocation(line: 100, column: 3, scope: !269)
!2761 = !DILocation(line: 101, column: 3, scope: !269)
!2762 = !DILocation(line: 101, column: 18, scope: !269)
!2763 = !DILocation(line: 103, column: 15, scope: !2764)
!2764 = distinct !DILexicalBlock(scope: !269, file: !264, line: 103, column: 7)
!2765 = !DILocation(line: 103, column: 8, scope: !2764)
!2766 = !DILocation(line: 103, column: 35, scope: !2764)
!2767 = !DILocation(line: 103, column: 41, scope: !2764)
!2768 = !DILocation(line: 103, column: 52, scope: !2764)
!2769 = !DILocation(line: 103, column: 45, scope: !2764)
!2770 = !DILocation(line: 103, column: 72, scope: !2764)
!2771 = !DILocation(line: 103, column: 7, scope: !269)
!2772 = !DILocation(line: 104, column: 13, scope: !2773)
!2773 = distinct !DILexicalBlock(scope: !2764, file: !264, line: 103, column: 79)
!2774 = !DILocation(line: 104, column: 5, scope: !2773)
!2775 = !DILocation(line: 105, column: 3, scope: !2773)
!2776 = !DILocation(line: 107, column: 9, scope: !2777)
!2777 = distinct !DILexicalBlock(scope: !269, file: !264, line: 107, column: 7)
!2778 = !DILocation(line: 107, column: 7, scope: !269)
!2779 = !DILocation(line: 108, column: 13, scope: !2780)
!2780 = distinct !DILexicalBlock(scope: !2777, file: !264, line: 107, column: 27)
!2781 = !DILocation(line: 108, column: 5, scope: !2780)
!2782 = !DILocation(line: 109, column: 5, scope: !2780)
!2783 = !DILocation(line: 112, column: 31, scope: !269)
!2784 = !DILocation(line: 112, column: 29, scope: !269)
!2785 = !DILocation(line: 113, column: 31, scope: !269)
!2786 = !DILocation(line: 113, column: 29, scope: !269)
!2787 = !DILocation(line: 114, column: 35, scope: !269)
!2788 = !DILocation(line: 114, column: 41, scope: !269)
!2789 = !DILocation(line: 114, column: 32, scope: !269)
!2790 = !DILocation(line: 114, column: 29, scope: !269)
!2791 = !DILocation(line: 115, column: 34, scope: !269)
!2792 = !DILocation(line: 115, column: 40, scope: !269)
!2793 = !DILocation(line: 115, column: 46, scope: !269)
!2794 = !DILocation(line: 115, column: 50, scope: !269)
!2795 = !DILocation(line: 115, column: 29, scope: !269)
!2796 = !DILocation(line: 116, column: 32, scope: !269)
!2797 = !DILocation(line: 116, column: 30, scope: !269)
!2798 = !DILocation(line: 118, column: 17, scope: !2799)
!2799 = distinct !DILexicalBlock(scope: !269, file: !264, line: 118, column: 7)
!2800 = !DILocation(line: 118, column: 7, scope: !2799)
!2801 = !DILocation(line: 118, column: 7, scope: !269)
!2802 = !DILocation(line: 120, column: 22, scope: !2803)
!2803 = distinct !DILexicalBlock(scope: !2804, file: !264, line: 120, column: 9)
!2804 = distinct !DILexicalBlock(scope: !2799, file: !264, line: 118, column: 35)
!2805 = !DILocation(line: 120, column: 35, scope: !2803)
!2806 = !DILocation(line: 120, column: 9, scope: !2803)
!2807 = !DILocation(line: 120, column: 9, scope: !2804)
!2808 = !DILocation(line: 121, column: 15, scope: !2809)
!2809 = distinct !DILexicalBlock(scope: !2803, file: !264, line: 120, column: 65)
!2810 = !DILocation(line: 121, column: 7, scope: !2809)
!2811 = !DILocation(line: 122, column: 7, scope: !2809)
!2812 = !DILocation(line: 124, column: 3, scope: !2804)
!2813 = !DILocation(line: 136, column: 10, scope: !2814)
!2814 = distinct !DILexicalBlock(scope: !2815, file: !264, line: 136, column: 5)
!2815 = distinct !DILexicalBlock(scope: !2799, file: !264, line: 124, column: 10)
!2816 = !DILocation(line: 136, column: 9, scope: !2814)
!2817 = !DILocation(line: 136, column: 15, scope: !2818)
!2818 = distinct !DILexicalBlock(scope: !2814, file: !264, line: 136, column: 5)
!2819 = !DILocation(line: 136, column: 16, scope: !2818)
!2820 = !DILocation(line: 136, column: 5, scope: !2814)
!2821 = !DILocation(line: 137, column: 45, scope: !2822)
!2822 = distinct !DILexicalBlock(scope: !2818, file: !264, line: 136, column: 36)
!2823 = !DILocation(line: 137, column: 46, scope: !2822)
!2824 = !DILocation(line: 137, column: 38, scope: !2822)
!2825 = !DILocation(line: 137, column: 49, scope: !2822)
!2826 = !DILocation(line: 137, column: 37, scope: !2822)
!2827 = !DILocation(line: 137, column: 61, scope: !2822)
!2828 = !DILocation(line: 137, column: 60, scope: !2822)
!2829 = !DILocation(line: 137, column: 63, scope: !2822)
!2830 = !DILocation(line: 137, column: 26, scope: !2822)
!2831 = !DILocation(line: 137, column: 7, scope: !2822)
!2832 = !DILocation(line: 137, column: 29, scope: !2822)
!2833 = !DILocation(line: 137, column: 35, scope: !2822)
!2834 = !DILocation(line: 138, column: 45, scope: !2822)
!2835 = !DILocation(line: 138, column: 46, scope: !2822)
!2836 = !DILocation(line: 138, column: 38, scope: !2822)
!2837 = !DILocation(line: 138, column: 49, scope: !2822)
!2838 = !DILocation(line: 138, column: 37, scope: !2822)
!2839 = !DILocation(line: 138, column: 61, scope: !2822)
!2840 = !DILocation(line: 138, column: 60, scope: !2822)
!2841 = !DILocation(line: 138, column: 63, scope: !2822)
!2842 = !DILocation(line: 138, column: 26, scope: !2822)
!2843 = !DILocation(line: 138, column: 7, scope: !2822)
!2844 = !DILocation(line: 138, column: 29, scope: !2822)
!2845 = !DILocation(line: 138, column: 35, scope: !2822)
!2846 = !DILocation(line: 139, column: 45, scope: !2822)
!2847 = !DILocation(line: 139, column: 46, scope: !2822)
!2848 = !DILocation(line: 139, column: 38, scope: !2822)
!2849 = !DILocation(line: 139, column: 49, scope: !2822)
!2850 = !DILocation(line: 139, column: 37, scope: !2822)
!2851 = !DILocation(line: 139, column: 61, scope: !2822)
!2852 = !DILocation(line: 139, column: 60, scope: !2822)
!2853 = !DILocation(line: 139, column: 63, scope: !2822)
!2854 = !DILocation(line: 139, column: 26, scope: !2822)
!2855 = !DILocation(line: 139, column: 7, scope: !2822)
!2856 = !DILocation(line: 139, column: 29, scope: !2822)
!2857 = !DILocation(line: 139, column: 35, scope: !2822)
!2858 = !DILocation(line: 140, column: 5, scope: !2822)
!2859 = !DILocation(line: 136, column: 32, scope: !2818)
!2860 = !DILocation(line: 136, column: 5, scope: !2818)
!2861 = distinct !{!2861, !2820, !2862}
!2862 = !DILocation(line: 140, column: 5, scope: !2814)
!2863 = !DILocation(line: 141, column: 10, scope: !2864)
!2864 = distinct !DILexicalBlock(scope: !2815, file: !264, line: 141, column: 5)
!2865 = !DILocation(line: 141, column: 9, scope: !2864)
!2866 = !DILocation(line: 141, column: 25, scope: !2867)
!2867 = distinct !DILexicalBlock(scope: !2864, file: !264, line: 141, column: 5)
!2868 = !DILocation(line: 141, column: 26, scope: !2867)
!2869 = !DILocation(line: 141, column: 5, scope: !2864)
!2870 = !DILocation(line: 142, column: 45, scope: !2871)
!2871 = distinct !DILexicalBlock(scope: !2867, file: !264, line: 141, column: 43)
!2872 = !DILocation(line: 142, column: 46, scope: !2871)
!2873 = !DILocation(line: 142, column: 38, scope: !2871)
!2874 = !DILocation(line: 142, column: 49, scope: !2871)
!2875 = !DILocation(line: 142, column: 37, scope: !2871)
!2876 = !DILocation(line: 142, column: 26, scope: !2871)
!2877 = !DILocation(line: 142, column: 7, scope: !2871)
!2878 = !DILocation(line: 142, column: 29, scope: !2871)
!2879 = !DILocation(line: 142, column: 35, scope: !2871)
!2880 = !DILocation(line: 143, column: 45, scope: !2871)
!2881 = !DILocation(line: 143, column: 46, scope: !2871)
!2882 = !DILocation(line: 143, column: 38, scope: !2871)
!2883 = !DILocation(line: 143, column: 49, scope: !2871)
!2884 = !DILocation(line: 143, column: 37, scope: !2871)
!2885 = !DILocation(line: 143, column: 26, scope: !2871)
!2886 = !DILocation(line: 143, column: 7, scope: !2871)
!2887 = !DILocation(line: 143, column: 29, scope: !2871)
!2888 = !DILocation(line: 143, column: 35, scope: !2871)
!2889 = !DILocation(line: 144, column: 45, scope: !2871)
!2890 = !DILocation(line: 144, column: 46, scope: !2871)
!2891 = !DILocation(line: 144, column: 38, scope: !2871)
!2892 = !DILocation(line: 144, column: 49, scope: !2871)
!2893 = !DILocation(line: 144, column: 37, scope: !2871)
!2894 = !DILocation(line: 144, column: 26, scope: !2871)
!2895 = !DILocation(line: 144, column: 7, scope: !2871)
!2896 = !DILocation(line: 144, column: 29, scope: !2871)
!2897 = !DILocation(line: 144, column: 35, scope: !2871)
!2898 = !DILocation(line: 145, column: 5, scope: !2871)
!2899 = !DILocation(line: 141, column: 39, scope: !2867)
!2900 = !DILocation(line: 141, column: 5, scope: !2867)
!2901 = distinct !{!2901, !2869, !2902}
!2902 = !DILocation(line: 145, column: 5, scope: !2864)
!2903 = !DILocation(line: 148, column: 16, scope: !2904)
!2904 = distinct !DILexicalBlock(scope: !269, file: !264, line: 148, column: 6)
!2905 = !DILocation(line: 148, column: 6, scope: !2904)
!2906 = !DILocation(line: 148, column: 6, scope: !269)
!2907 = !DILocation(line: 149, column: 34, scope: !2908)
!2908 = distinct !DILexicalBlock(scope: !2904, file: !264, line: 148, column: 34)
!2909 = !DILocation(line: 149, column: 32, scope: !2908)
!2910 = !DILocation(line: 150, column: 3, scope: !2908)
!2911 = !DILocation(line: 151, column: 32, scope: !2912)
!2912 = distinct !DILexicalBlock(scope: !2904, file: !264, line: 150, column: 10)
!2913 = !DILocation(line: 154, column: 31, scope: !269)
!2914 = !DILocation(line: 154, column: 29, scope: !269)
!2915 = !DILocation(line: 156, column: 3, scope: !269)
!2916 = !DILocation(line: 157, column: 11, scope: !2917)
!2917 = distinct !DILexicalBlock(scope: !2918, file: !264, line: 157, column: 9)
!2918 = distinct !DILexicalBlock(scope: !269, file: !264, line: 156, column: 13)
!2919 = !DILocation(line: 157, column: 9, scope: !2918)
!2920 = !DILocation(line: 158, column: 15, scope: !2921)
!2921 = distinct !DILexicalBlock(scope: !2917, file: !264, line: 157, column: 28)
!2922 = !DILocation(line: 158, column: 7, scope: !2921)
!2923 = !DILocation(line: 159, column: 14, scope: !2921)
!2924 = !DILocation(line: 159, column: 7, scope: !2921)
!2925 = !DILocation(line: 162, column: 9, scope: !2926)
!2926 = distinct !DILexicalBlock(scope: !2918, file: !264, line: 162, column: 9)
!2927 = !DILocation(line: 162, column: 11, scope: !2926)
!2928 = !DILocation(line: 162, column: 9, scope: !2918)
!2929 = !DILocation(line: 163, column: 11, scope: !2930)
!2930 = distinct !DILexicalBlock(scope: !2931, file: !264, line: 163, column: 11)
!2931 = distinct !DILexicalBlock(scope: !2926, file: !264, line: 162, column: 29)
!2932 = !DILocation(line: 163, column: 19, scope: !2930)
!2933 = !DILocation(line: 163, column: 11, scope: !2931)
!2934 = !DILocation(line: 164, column: 17, scope: !2930)
!2935 = !DILocation(line: 164, column: 9, scope: !2930)
!2936 = !DILocation(line: 165, column: 14, scope: !2931)
!2937 = !DILocation(line: 165, column: 7, scope: !2931)
!2938 = !DILocation(line: 168, column: 9, scope: !2939)
!2939 = distinct !DILexicalBlock(scope: !2918, file: !264, line: 168, column: 9)
!2940 = !DILocation(line: 168, column: 11, scope: !2939)
!2941 = !DILocation(line: 168, column: 9, scope: !2918)
!2942 = !DILocation(line: 169, column: 13, scope: !2943)
!2943 = distinct !DILexicalBlock(scope: !2944, file: !264, line: 169, column: 11)
!2944 = distinct !DILexicalBlock(scope: !2939, file: !264, line: 168, column: 28)
!2945 = !DILocation(line: 169, column: 11, scope: !2944)
!2946 = !DILocation(line: 170, column: 17, scope: !2947)
!2947 = distinct !DILexicalBlock(scope: !2943, file: !264, line: 169, column: 30)
!2948 = !DILocation(line: 170, column: 9, scope: !2947)
!2949 = !DILocation(line: 171, column: 16, scope: !2947)
!2950 = !DILocation(line: 171, column: 9, scope: !2947)
!2951 = !DILocation(line: 173, column: 22, scope: !2952)
!2952 = distinct !DILexicalBlock(scope: !2944, file: !264, line: 173, column: 10)
!2953 = !DILocation(line: 173, column: 26, scope: !2952)
!2954 = !DILocation(line: 173, column: 10, scope: !2952)
!2955 = !DILocation(line: 173, column: 10, scope: !2944)
!2956 = !DILocation(line: 174, column: 16, scope: !2952)
!2957 = !DILocation(line: 174, column: 9, scope: !2952)
!2958 = !DILocation(line: 175, column: 7, scope: !2944)
!2959 = distinct !{!2959, !2915, !2960}
!2960 = !DILocation(line: 227, column: 3, scope: !269)
!2961 = !DILocation(line: 178, column: 9, scope: !2962)
!2962 = distinct !DILexicalBlock(scope: !2918, file: !264, line: 178, column: 9)
!2963 = !DILocation(line: 178, column: 11, scope: !2962)
!2964 = !DILocation(line: 178, column: 9, scope: !2918)
!2965 = !DILocation(line: 179, column: 15, scope: !2966)
!2966 = distinct !DILexicalBlock(scope: !2962, file: !264, line: 178, column: 24)
!2967 = !DILocation(line: 180, column: 20, scope: !2966)
!2968 = !DILocation(line: 180, column: 15, scope: !2966)
!2969 = !DILocation(line: 179, column: 7, scope: !2966)
!2970 = !DILocation(line: 181, column: 14, scope: !2966)
!2971 = !DILocation(line: 181, column: 7, scope: !2966)
!2972 = !DILocation(line: 184, column: 11, scope: !2973)
!2973 = distinct !DILexicalBlock(scope: !2918, file: !264, line: 184, column: 9)
!2974 = !DILocation(line: 184, column: 9, scope: !2918)
!2975 = !DILocation(line: 185, column: 15, scope: !2976)
!2976 = distinct !DILexicalBlock(scope: !2973, file: !264, line: 184, column: 29)
!2977 = !DILocation(line: 185, column: 7, scope: !2976)
!2978 = !DILocation(line: 186, column: 14, scope: !2976)
!2979 = !DILocation(line: 186, column: 7, scope: !2976)
!2980 = !DILocation(line: 189, column: 27, scope: !2918)
!2981 = !DILocation(line: 189, column: 25, scope: !2918)
!2982 = !DILocation(line: 189, column: 23, scope: !2918)
!2983 = !DILocation(line: 191, column: 21, scope: !2918)
!2984 = !DILocation(line: 191, column: 27, scope: !2918)
!2985 = !DILocation(line: 191, column: 33, scope: !2918)
!2986 = !DILocation(line: 191, column: 17, scope: !2918)
!2987 = !DILocation(line: 191, column: 14, scope: !2918)
!2988 = !DILocation(line: 193, column: 13, scope: !2918)
!2989 = !DILocation(line: 193, column: 11, scope: !2918)
!2990 = !DILocation(line: 194, column: 13, scope: !2918)
!2991 = !DILocation(line: 194, column: 11, scope: !2918)
!2992 = !DILocation(line: 195, column: 9, scope: !2918)
!2993 = !DILocation(line: 195, column: 7, scope: !2918)
!2994 = !DILocation(line: 196, column: 9, scope: !2918)
!2995 = !DILocation(line: 196, column: 7, scope: !2918)
!2996 = !DILocation(line: 198, column: 11, scope: !2997)
!2997 = distinct !DILexicalBlock(scope: !2918, file: !264, line: 198, column: 9)
!2998 = !DILocation(line: 198, column: 9, scope: !2918)
!2999 = !DILocation(line: 199, column: 24, scope: !3000)
!3000 = distinct !DILexicalBlock(scope: !3001, file: !264, line: 199, column: 11)
!3001 = distinct !DILexicalBlock(scope: !2997, file: !264, line: 198, column: 30)
!3002 = !DILocation(line: 199, column: 27, scope: !3000)
!3003 = !DILocation(line: 199, column: 36, scope: !3000)
!3004 = !DILocation(line: 199, column: 11, scope: !3000)
!3005 = !DILocation(line: 199, column: 11, scope: !3001)
!3006 = !DILocation(line: 200, column: 17, scope: !3007)
!3007 = distinct !DILexicalBlock(scope: !3000, file: !264, line: 199, column: 52)
!3008 = !DILocation(line: 200, column: 9, scope: !3007)
!3009 = !DILocation(line: 201, column: 16, scope: !3007)
!3010 = !DILocation(line: 201, column: 9, scope: !3007)
!3011 = !DILocation(line: 204, column: 21, scope: !3012)
!3012 = distinct !DILexicalBlock(scope: !3001, file: !264, line: 204, column: 10)
!3013 = !DILocation(line: 204, column: 25, scope: !3012)
!3014 = !DILocation(line: 204, column: 32, scope: !3012)
!3015 = !DILocation(line: 204, column: 39, scope: !3012)
!3016 = !DILocation(line: 204, column: 42, scope: !3012)
!3017 = !DILocation(line: 204, column: 45, scope: !3012)
!3018 = !DILocation(line: 205, column: 21, scope: !3012)
!3019 = !DILocation(line: 205, column: 36, scope: !3012)
!3020 = !DILocation(line: 204, column: 11, scope: !3012)
!3021 = !DILocation(line: 204, column: 10, scope: !3001)
!3022 = !DILocation(line: 206, column: 19, scope: !3023)
!3023 = distinct !DILexicalBlock(scope: !3012, file: !264, line: 205, column: 64)
!3024 = !DILocation(line: 207, column: 7, scope: !3023)
!3025 = !DILocation(line: 208, column: 5, scope: !3001)
!3026 = !DILocation(line: 209, column: 21, scope: !3027)
!3027 = distinct !DILexicalBlock(scope: !3028, file: !264, line: 209, column: 10)
!3028 = distinct !DILexicalBlock(scope: !2997, file: !264, line: 208, column: 12)
!3029 = !DILocation(line: 209, column: 11, scope: !3027)
!3030 = !DILocation(line: 209, column: 10, scope: !3028)
!3031 = !DILocation(line: 210, column: 13, scope: !3032)
!3032 = distinct !DILexicalBlock(scope: !3033, file: !264, line: 210, column: 13)
!3033 = distinct !DILexicalBlock(scope: !3027, file: !264, line: 209, column: 39)
!3034 = !DILocation(line: 210, column: 21, scope: !3032)
!3035 = !DILocation(line: 210, column: 13, scope: !3033)
!3036 = !DILocation(line: 211, column: 19, scope: !3032)
!3037 = !DILocation(line: 211, column: 11, scope: !3032)
!3038 = !DILocation(line: 212, column: 7, scope: !3033)
!3039 = !DILocation(line: 214, column: 21, scope: !3040)
!3040 = distinct !DILexicalBlock(scope: !3028, file: !264, line: 214, column: 10)
!3041 = !DILocation(line: 214, column: 25, scope: !3040)
!3042 = !DILocation(line: 214, column: 32, scope: !3040)
!3043 = !DILocation(line: 214, column: 39, scope: !3040)
!3044 = !DILocation(line: 214, column: 42, scope: !3040)
!3045 = !DILocation(line: 214, column: 55, scope: !3040)
!3046 = !DILocation(line: 215, column: 42, scope: !3040)
!3047 = !DILocation(line: 214, column: 11, scope: !3040)
!3048 = !DILocation(line: 214, column: 10, scope: !3028)
!3049 = !DILocation(line: 216, column: 19, scope: !3050)
!3050 = distinct !DILexicalBlock(scope: !3040, file: !264, line: 215, column: 70)
!3051 = !DILocation(line: 217, column: 7, scope: !3050)
!3052 = !DILocation(line: 223, column: 23, scope: !2918)
!3053 = !DILocation(line: 224, column: 21, scope: !2918)
!3054 = !DILocation(line: 225, column: 21, scope: !2918)
!3055 = !DILocation(line: 226, column: 20, scope: !2918)
!3056 = !DILocation(line: 228, column: 1, scope: !269)
!3057 = distinct !DISubprogram(name: "ReadColorMap", scope: !264, file: !264, line: 231, type: !3058, scopeLine: 232, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !263, retainedNodes: !4)
!3058 = !DISubroutineType(types: !3059)
!3059 = !{!7, !272, !7, !3060}
!3060 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !335, size: 64)
!3061 = !DILocalVariable(name: "fd", arg: 1, scope: !3057, file: !264, line: 231, type: !272)
!3062 = !DILocation(line: 231, column: 20, scope: !3057)
!3063 = !DILocalVariable(name: "number", arg: 2, scope: !3057, file: !264, line: 231, type: !7)
!3064 = !DILocation(line: 231, column: 28, scope: !3057)
!3065 = !DILocalVariable(name: "colors", arg: 3, scope: !3057, file: !264, line: 231, type: !3060)
!3066 = !DILocation(line: 231, column: 45, scope: !3057)
!3067 = !DILocalVariable(name: "i", scope: !3057, file: !264, line: 233, type: !7)
!3068 = !DILocation(line: 233, column: 9, scope: !3057)
!3069 = !DILocalVariable(name: "rgb", scope: !3057, file: !264, line: 234, type: !3070)
!3070 = !DICompositeType(tag: DW_TAG_array_type, baseType: !200, size: 24, elements: !3071)
!3071 = !{!3072}
!3072 = !DISubrange(count: 3)
!3073 = !DILocation(line: 234, column: 9, scope: !3057)
!3074 = !DILocation(line: 236, column: 10, scope: !3075)
!3075 = distinct !DILexicalBlock(scope: !3057, file: !264, line: 236, column: 3)
!3076 = !DILocation(line: 236, column: 8, scope: !3075)
!3077 = !DILocation(line: 236, column: 15, scope: !3078)
!3078 = distinct !DILexicalBlock(scope: !3075, file: !264, line: 236, column: 3)
!3079 = !DILocation(line: 236, column: 19, scope: !3078)
!3080 = !DILocation(line: 236, column: 17, scope: !3078)
!3081 = !DILocation(line: 236, column: 3, scope: !3075)
!3082 = !DILocation(line: 237, column: 11, scope: !3083)
!3083 = distinct !DILexicalBlock(scope: !3084, file: !264, line: 237, column: 9)
!3084 = distinct !DILexicalBlock(scope: !3078, file: !264, line: 236, column: 32)
!3085 = !DILocation(line: 237, column: 9, scope: !3084)
!3086 = !DILocation(line: 238, column: 15, scope: !3087)
!3087 = distinct !DILexicalBlock(scope: !3083, file: !264, line: 237, column: 41)
!3088 = !DILocation(line: 238, column: 7, scope: !3087)
!3089 = !DILocation(line: 239, column: 7, scope: !3087)
!3090 = !DILocation(line: 242, column: 23, scope: !3084)
!3091 = !DILocation(line: 242, column: 5, scope: !3084)
!3092 = !DILocation(line: 242, column: 12, scope: !3084)
!3093 = !DILocation(line: 242, column: 15, scope: !3084)
!3094 = !DILocation(line: 242, column: 21, scope: !3084)
!3095 = !DILocation(line: 243, column: 23, scope: !3084)
!3096 = !DILocation(line: 243, column: 5, scope: !3084)
!3097 = !DILocation(line: 243, column: 12, scope: !3084)
!3098 = !DILocation(line: 243, column: 15, scope: !3084)
!3099 = !DILocation(line: 243, column: 21, scope: !3084)
!3100 = !DILocation(line: 244, column: 23, scope: !3084)
!3101 = !DILocation(line: 244, column: 5, scope: !3084)
!3102 = !DILocation(line: 244, column: 12, scope: !3084)
!3103 = !DILocation(line: 244, column: 15, scope: !3084)
!3104 = !DILocation(line: 244, column: 21, scope: !3084)
!3105 = !DILocation(line: 245, column: 3, scope: !3084)
!3106 = !DILocation(line: 236, column: 27, scope: !3078)
!3107 = !DILocation(line: 236, column: 3, scope: !3078)
!3108 = distinct !{!3108, !3081, !3109}
!3109 = !DILocation(line: 245, column: 3, scope: !3075)
!3110 = !DILocation(line: 247, column: 12, scope: !3111)
!3111 = distinct !DILexicalBlock(scope: !3057, file: !264, line: 247, column: 3)
!3112 = !DILocation(line: 247, column: 10, scope: !3111)
!3113 = !DILocation(line: 247, column: 8, scope: !3111)
!3114 = !DILocation(line: 247, column: 20, scope: !3115)
!3115 = distinct !DILexicalBlock(scope: !3111, file: !264, line: 247, column: 3)
!3116 = !DILocation(line: 247, column: 21, scope: !3115)
!3117 = !DILocation(line: 247, column: 3, scope: !3111)
!3118 = !DILocation(line: 248, column: 5, scope: !3119)
!3119 = distinct !DILexicalBlock(scope: !3115, file: !264, line: 247, column: 38)
!3120 = !DILocation(line: 248, column: 12, scope: !3119)
!3121 = !DILocation(line: 248, column: 15, scope: !3119)
!3122 = !DILocation(line: 248, column: 21, scope: !3119)
!3123 = !DILocation(line: 249, column: 5, scope: !3119)
!3124 = !DILocation(line: 249, column: 12, scope: !3119)
!3125 = !DILocation(line: 249, column: 15, scope: !3119)
!3126 = !DILocation(line: 249, column: 21, scope: !3119)
!3127 = !DILocation(line: 250, column: 5, scope: !3119)
!3128 = !DILocation(line: 250, column: 12, scope: !3119)
!3129 = !DILocation(line: 250, column: 15, scope: !3119)
!3130 = !DILocation(line: 250, column: 21, scope: !3119)
!3131 = !DILocation(line: 251, column: 3, scope: !3119)
!3132 = !DILocation(line: 247, column: 33, scope: !3115)
!3133 = !DILocation(line: 247, column: 3, scope: !3115)
!3134 = distinct !{!3134, !3117, !3135}
!3135 = !DILocation(line: 251, column: 3, scope: !3111)
!3136 = !DILocation(line: 253, column: 3, scope: !3057)
!3137 = !DILocation(line: 254, column: 1, scope: !3057)
!3138 = !DILocalVariable(name: "fd", arg: 1, scope: !359, file: !264, line: 257, type: !272)
!3139 = !DILocation(line: 257, column: 19, scope: !359)
!3140 = !DILocalVariable(name: "label", arg: 2, scope: !359, file: !264, line: 257, type: !7)
!3141 = !DILocation(line: 257, column: 27, scope: !359)
!3142 = !DILocalVariable(name: "str", scope: !359, file: !264, line: 260, type: !75)
!3143 = !DILocation(line: 260, column: 9, scope: !359)
!3144 = !DILocalVariable(name: "p", scope: !359, file: !264, line: 261, type: !75)
!3145 = !DILocation(line: 261, column: 9, scope: !359)
!3146 = !DILocalVariable(name: "p2", scope: !359, file: !264, line: 261, type: !75)
!3147 = !DILocation(line: 261, column: 12, scope: !359)
!3148 = !DILocalVariable(name: "size", scope: !359, file: !264, line: 262, type: !7)
!3149 = !DILocation(line: 262, column: 7, scope: !359)
!3150 = !DILocalVariable(name: "last_cr", scope: !359, file: !264, line: 263, type: !7)
!3151 = !DILocation(line: 263, column: 7, scope: !359)
!3152 = !DILocation(line: 265, column: 11, scope: !359)
!3153 = !DILocation(line: 265, column: 3, scope: !359)
!3154 = !DILocation(line: 267, column: 9, scope: !3155)
!3155 = distinct !DILexicalBlock(scope: !359, file: !264, line: 265, column: 18)
!3156 = !DILocation(line: 271, column: 23, scope: !3155)
!3157 = !DILocation(line: 272, column: 21, scope: !3155)
!3158 = !DILocation(line: 273, column: 21, scope: !3155)
!3159 = !DILocation(line: 274, column: 20, scope: !3155)
!3160 = !DILocation(line: 275, column: 9, scope: !3161)
!3161 = distinct !DILexicalBlock(scope: !3155, file: !264, line: 275, column: 9)
!3162 = !DILocation(line: 275, column: 17, scope: !3161)
!3163 = !DILocation(line: 275, column: 9, scope: !3155)
!3164 = !DILocation(line: 276, column: 17, scope: !3161)
!3165 = !DILocation(line: 276, column: 9, scope: !3161)
!3166 = !DILocation(line: 278, column: 7, scope: !3155)
!3167 = !DILocation(line: 278, column: 27, scope: !3155)
!3168 = !DILocation(line: 278, column: 14, scope: !3155)
!3169 = !DILocation(line: 278, column: 53, scope: !3155)
!3170 = !DILocation(line: 279, column: 9, scope: !3155)
!3171 = distinct !{!3171, !3166, !3170}
!3172 = !DILocation(line: 280, column: 7, scope: !3155)
!3173 = !DILocation(line: 283, column: 9, scope: !3155)
!3174 = !DILocation(line: 284, column: 5, scope: !3155)
!3175 = !DILocation(line: 287, column: 5, scope: !3155)
!3176 = !DILocation(line: 300, column: 12, scope: !3155)
!3177 = !DILocation(line: 302, column: 5, scope: !3155)
!3178 = !DILocation(line: 302, column: 31, scope: !3155)
!3179 = !DILocation(line: 302, column: 18, scope: !3155)
!3180 = !DILocation(line: 302, column: 17, scope: !3155)
!3181 = !DILocation(line: 302, column: 58, scope: !3155)
!3182 = !DILocation(line: 304, column: 11, scope: !3183)
!3183 = distinct !DILexicalBlock(scope: !3155, file: !264, line: 302, column: 63)
!3184 = !DILocation(line: 304, column: 9, scope: !3183)
!3185 = !DILocation(line: 308, column: 10, scope: !3186)
!3186 = distinct !DILexicalBlock(scope: !3183, file: !264, line: 308, column: 10)
!3187 = !DILocation(line: 308, column: 18, scope: !3186)
!3188 = !DILocation(line: 308, column: 22, scope: !3186)
!3189 = !DILocation(line: 308, column: 21, scope: !3186)
!3190 = !DILocation(line: 308, column: 23, scope: !3186)
!3191 = !DILocation(line: 308, column: 10, scope: !3183)
!3192 = !DILocation(line: 309, column: 9, scope: !3193)
!3193 = distinct !DILexicalBlock(scope: !3186, file: !264, line: 308, column: 31)
!3194 = !DILocation(line: 310, column: 16, scope: !3193)
!3195 = !DILocation(line: 311, column: 7, scope: !3193)
!3196 = !DILocation(line: 313, column: 7, scope: !3183)
!3197 = !DILocation(line: 313, column: 13, scope: !3183)
!3198 = !DILocation(line: 313, column: 14, scope: !3183)
!3199 = !DILocation(line: 313, column: 19, scope: !3183)
!3200 = !DILocation(line: 313, column: 18, scope: !3183)
!3201 = !DILocation(line: 314, column: 12, scope: !3202)
!3202 = distinct !DILexicalBlock(scope: !3203, file: !264, line: 314, column: 12)
!3203 = distinct !DILexicalBlock(scope: !3183, file: !264, line: 313, column: 25)
!3204 = !DILocation(line: 314, column: 12, scope: !3203)
!3205 = !DILocation(line: 315, column: 15, scope: !3206)
!3206 = distinct !DILexicalBlock(scope: !3207, file: !264, line: 315, column: 14)
!3207 = distinct !DILexicalBlock(scope: !3202, file: !264, line: 314, column: 21)
!3208 = !DILocation(line: 315, column: 14, scope: !3206)
!3209 = !DILocation(line: 315, column: 16, scope: !3206)
!3210 = !DILocation(line: 315, column: 14, scope: !3207)
!3211 = !DILocation(line: 316, column: 16, scope: !3206)
!3212 = !DILocation(line: 316, column: 18, scope: !3206)
!3213 = !DILocation(line: 316, column: 13, scope: !3206)
!3214 = !DILocation(line: 317, column: 18, scope: !3207)
!3215 = !DILocation(line: 318, column: 9, scope: !3207)
!3216 = !DILocation(line: 319, column: 13, scope: !3217)
!3217 = distinct !DILexicalBlock(scope: !3203, file: !264, line: 319, column: 12)
!3218 = !DILocation(line: 319, column: 12, scope: !3217)
!3219 = !DILocation(line: 319, column: 14, scope: !3217)
!3220 = !DILocation(line: 319, column: 12, scope: !3203)
!3221 = !DILocation(line: 320, column: 18, scope: !3217)
!3222 = !DILocation(line: 320, column: 11, scope: !3217)
!3223 = !DILocation(line: 322, column: 42, scope: !3217)
!3224 = !DILocation(line: 322, column: 41, scope: !3217)
!3225 = !DILocation(line: 322, column: 17, scope: !3217)
!3226 = !DILocation(line: 322, column: 14, scope: !3217)
!3227 = !DILocation(line: 322, column: 16, scope: !3217)
!3228 = !DILocation(line: 323, column: 10, scope: !3203)
!3229 = distinct !{!3229, !3196, !3230}
!3230 = !DILocation(line: 324, column: 7, scope: !3183)
!3231 = !DILocation(line: 325, column: 12, scope: !3183)
!3232 = !DILocation(line: 325, column: 14, scope: !3183)
!3233 = !DILocation(line: 325, column: 11, scope: !3183)
!3234 = !DILocation(line: 327, column: 24, scope: !3183)
!3235 = !DILocation(line: 327, column: 7, scope: !3183)
!3236 = distinct !{!3236, !3177, !3237}
!3237 = !DILocation(line: 328, column: 5, scope: !3155)
!3238 = !DILocation(line: 330, column: 9, scope: !3239)
!3239 = distinct !DILexicalBlock(scope: !3155, file: !264, line: 330, column: 9)
!3240 = !DILocation(line: 330, column: 17, scope: !3239)
!3241 = !DILocation(line: 330, column: 9, scope: !3155)
!3242 = !DILocation(line: 331, column: 15, scope: !3239)
!3243 = !DILocation(line: 331, column: 7, scope: !3239)
!3244 = !DILocation(line: 333, column: 22, scope: !3155)
!3245 = !DILocation(line: 333, column: 5, scope: !3155)
!3246 = !DILocation(line: 333, column: 14, scope: !3155)
!3247 = !DILocation(line: 333, column: 21, scope: !3155)
!3248 = !DILocation(line: 335, column: 5, scope: !3155)
!3249 = !DILocation(line: 336, column: 5, scope: !3155)
!3250 = !DILocation(line: 339, column: 9, scope: !3155)
!3251 = !DILocation(line: 340, column: 25, scope: !3155)
!3252 = !DILocation(line: 340, column: 12, scope: !3155)
!3253 = !DILocation(line: 340, column: 10, scope: !3155)
!3254 = !DILocation(line: 341, column: 26, scope: !3155)
!3255 = !DILocation(line: 341, column: 33, scope: !3155)
!3256 = !DILocation(line: 341, column: 39, scope: !3155)
!3257 = !DILocation(line: 341, column: 23, scope: !3155)
!3258 = !DILocation(line: 342, column: 26, scope: !3155)
!3259 = !DILocation(line: 342, column: 33, scope: !3155)
!3260 = !DILocation(line: 342, column: 39, scope: !3155)
!3261 = !DILocation(line: 342, column: 23, scope: !3155)
!3262 = !DILocation(line: 343, column: 25, scope: !3155)
!3263 = !DILocation(line: 343, column: 23, scope: !3155)
!3264 = !DILocation(line: 344, column: 10, scope: !3265)
!3265 = distinct !DILexicalBlock(scope: !3155, file: !264, line: 344, column: 9)
!3266 = !DILocation(line: 344, column: 17, scope: !3265)
!3267 = !DILocation(line: 344, column: 24, scope: !3265)
!3268 = !DILocation(line: 344, column: 9, scope: !3155)
!3269 = !DILocation(line: 345, column: 48, scope: !3265)
!3270 = !DILocation(line: 345, column: 27, scope: !3265)
!3271 = !DILocation(line: 345, column: 25, scope: !3265)
!3272 = !DILocation(line: 345, column: 7, scope: !3265)
!3273 = !DILocation(line: 347, column: 14, scope: !3274)
!3274 = distinct !DILexicalBlock(scope: !3155, file: !264, line: 347, column: 8)
!3275 = !DILocation(line: 347, column: 22, scope: !3274)
!3276 = !DILocation(line: 347, column: 26, scope: !3274)
!3277 = !DILocation(line: 347, column: 35, scope: !3274)
!3278 = !DILocation(line: 347, column: 44, scope: !3274)
!3279 = !DILocation(line: 347, column: 48, scope: !3274)
!3280 = !DILocation(line: 348, column: 14, scope: !3274)
!3281 = !DILocation(line: 348, column: 23, scope: !3274)
!3282 = !DILocation(line: 347, column: 8, scope: !3155)
!3283 = !DILocation(line: 352, column: 7, scope: !3284)
!3284 = distinct !DILexicalBlock(scope: !3274, file: !264, line: 348, column: 28)
!3285 = !DILocation(line: 352, column: 27, scope: !3284)
!3286 = !DILocation(line: 352, column: 14, scope: !3284)
!3287 = !DILocation(line: 352, column: 53, scope: !3284)
!3288 = distinct !{!3288, !3283, !3289}
!3289 = !DILocation(line: 353, column: 9, scope: !3284)
!3290 = !DILocation(line: 355, column: 7, scope: !3284)
!3291 = !DILocation(line: 358, column: 7, scope: !3292)
!3292 = distinct !DILexicalBlock(scope: !3274, file: !264, line: 356, column: 12)
!3293 = !DILocation(line: 360, column: 7, scope: !3292)
!3294 = !DILocation(line: 363, column: 9, scope: !3295)
!3295 = distinct !DILexicalBlock(scope: !3155, file: !264, line: 363, column: 9)
!3296 = !DILocation(line: 363, column: 17, scope: !3295)
!3297 = !DILocation(line: 363, column: 9, scope: !3155)
!3298 = !DILocation(line: 364, column: 15, scope: !3295)
!3299 = !DILocation(line: 365, column: 28, scope: !3295)
!3300 = !DILocation(line: 365, column: 13, scope: !3295)
!3301 = !DILocation(line: 364, column: 7, scope: !3295)
!3302 = !DILocation(line: 366, column: 5, scope: !3155)
!3303 = !DILocation(line: 366, column: 25, scope: !3155)
!3304 = !DILocation(line: 366, column: 12, scope: !3155)
!3305 = !DILocation(line: 366, column: 51, scope: !3155)
!3306 = distinct !{!3306, !3302, !3307}
!3307 = !DILocation(line: 367, column: 7, scope: !3155)
!3308 = !DILocation(line: 368, column: 5, scope: !3155)
!3309 = !DILocation(line: 371, column: 3, scope: !359)
!3310 = !DILocation(line: 373, column: 3, scope: !359)
!3311 = !DILocation(line: 373, column: 29, scope: !359)
!3312 = !DILocation(line: 373, column: 16, scope: !359)
!3313 = !DILocation(line: 373, column: 15, scope: !359)
!3314 = !DILocation(line: 373, column: 56, scope: !359)
!3315 = !DILocation(line: 373, column: 61, scope: !359)
!3316 = !DILabel(scope: !3317, name: "copy_block", file: !264, line: 374)
!3317 = distinct !DILexicalBlock(scope: !359, file: !264, line: 373, column: 61)
!3318 = !DILocation(line: 374, column: 1, scope: !3317)
!3319 = !DILocation(line: 375, column: 22, scope: !3317)
!3320 = !DILocation(line: 375, column: 5, scope: !3317)
!3321 = distinct !{!3321, !3310, !3322}
!3322 = !DILocation(line: 376, column: 3, scope: !359)
!3323 = !DILocation(line: 378, column: 7, scope: !3324)
!3324 = distinct !DILexicalBlock(scope: !359, file: !264, line: 378, column: 7)
!3325 = !DILocation(line: 378, column: 15, scope: !3324)
!3326 = !DILocation(line: 378, column: 7, scope: !359)
!3327 = !DILocation(line: 379, column: 13, scope: !3324)
!3328 = !DILocation(line: 379, column: 56, scope: !3324)
!3329 = !DILocation(line: 379, column: 5, scope: !3324)
!3330 = !DILocation(line: 381, column: 20, scope: !359)
!3331 = !DILocation(line: 381, column: 3, scope: !359)
!3332 = !DILocation(line: 381, column: 12, scope: !359)
!3333 = !DILocation(line: 381, column: 19, scope: !359)
!3334 = !DILocation(line: 383, column: 3, scope: !359)
!3335 = !DILocation(line: 385, column: 3, scope: !359)
!3336 = !DILocation(line: 386, column: 1, scope: !359)
!3337 = distinct !DISubprogram(name: "ReadImage", scope: !264, file: !264, line: 610, type: !3338, scopeLine: 612, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !263, retainedNodes: !4)
!3338 = !DISubroutineType(types: !3339)
!3339 = !{!7, !272, !7, !7, !7, !7, !7, !3060, !7}
!3340 = !DILocalVariable(name: "fd", arg: 1, scope: !3337, file: !264, line: 610, type: !272)
!3341 = !DILocation(line: 610, column: 17, scope: !3337)
!3342 = !DILocalVariable(name: "x_off", arg: 2, scope: !3337, file: !264, line: 610, type: !7)
!3343 = !DILocation(line: 610, column: 25, scope: !3337)
!3344 = !DILocalVariable(name: "y_off", arg: 3, scope: !3337, file: !264, line: 610, type: !7)
!3345 = !DILocation(line: 610, column: 36, scope: !3337)
!3346 = !DILocalVariable(name: "width", arg: 4, scope: !3337, file: !264, line: 610, type: !7)
!3347 = !DILocation(line: 610, column: 47, scope: !3337)
!3348 = !DILocalVariable(name: "height", arg: 5, scope: !3337, file: !264, line: 610, type: !7)
!3349 = !DILocation(line: 610, column: 58, scope: !3337)
!3350 = !DILocalVariable(name: "cmapSize", arg: 6, scope: !3337, file: !264, line: 610, type: !7)
!3351 = !DILocation(line: 610, column: 70, scope: !3337)
!3352 = !DILocalVariable(name: "cmap", arg: 7, scope: !3337, file: !264, line: 611, type: !3060)
!3353 = !DILocation(line: 611, column: 20, scope: !3337)
!3354 = !DILocalVariable(name: "interlace", arg: 8, scope: !3337, file: !264, line: 611, type: !7)
!3355 = !DILocation(line: 611, column: 41, scope: !3337)
!3356 = !DILocalVariable(name: "dp", scope: !3337, file: !264, line: 613, type: !203)
!3357 = !DILocation(line: 613, column: 18, scope: !3337)
!3358 = !DILocalVariable(name: "c", scope: !3337, file: !264, line: 613, type: !42)
!3359 = !DILocation(line: 613, column: 22, scope: !3337)
!3360 = !DILocalVariable(name: "v", scope: !3337, file: !264, line: 614, type: !7)
!3361 = !DILocation(line: 614, column: 17, scope: !3337)
!3362 = !DILocalVariable(name: "xpos", scope: !3337, file: !264, line: 615, type: !7)
!3363 = !DILocation(line: 615, column: 17, scope: !3337)
!3364 = !DILocalVariable(name: "ypos", scope: !3337, file: !264, line: 615, type: !7)
!3365 = !DILocation(line: 615, column: 27, scope: !3337)
!3366 = !DILocalVariable(name: "image", scope: !3337, file: !264, line: 616, type: !203)
!3367 = !DILocation(line: 616, column: 18, scope: !3337)
!3368 = !DILocalVariable(name: "i", scope: !3337, file: !264, line: 617, type: !7)
!3369 = !DILocation(line: 617, column: 7, scope: !3337)
!3370 = !DILocalVariable(name: "count", scope: !3337, file: !264, line: 618, type: !625)
!3371 = !DILocation(line: 618, column: 18, scope: !3337)
!3372 = !DILocation(line: 623, column: 9, scope: !3373)
!3373 = distinct !DILexicalBlock(scope: !3337, file: !264, line: 623, column: 7)
!3374 = !DILocation(line: 623, column: 7, scope: !3337)
!3375 = !DILocation(line: 624, column: 13, scope: !3376)
!3376 = distinct !DILexicalBlock(scope: !3373, file: !264, line: 623, column: 26)
!3377 = !DILocation(line: 624, column: 5, scope: !3376)
!3378 = !DILocation(line: 625, column: 5, scope: !3376)
!3379 = !DILocation(line: 628, column: 11, scope: !3337)
!3380 = !DILocation(line: 628, column: 3, scope: !3337)
!3381 = !DILocation(line: 630, column: 7, scope: !3382)
!3382 = distinct !DILexicalBlock(scope: !3337, file: !264, line: 630, column: 7)
!3383 = !DILocation(line: 630, column: 15, scope: !3382)
!3384 = !DILocation(line: 630, column: 7, scope: !3337)
!3385 = !DILocation(line: 631, column: 13, scope: !3382)
!3386 = !DILocation(line: 632, column: 11, scope: !3382)
!3387 = !DILocation(line: 632, column: 18, scope: !3382)
!3388 = !DILocation(line: 632, column: 26, scope: !3382)
!3389 = !DILocation(line: 631, column: 5, scope: !3382)
!3390 = !DILocation(line: 634, column: 3, scope: !3337)
!3391 = !DILocation(line: 638, column: 18, scope: !3337)
!3392 = !DILocation(line: 638, column: 12, scope: !3337)
!3393 = !DILocation(line: 638, column: 24, scope: !3337)
!3394 = !DILocation(line: 638, column: 23, scope: !3337)
!3395 = !DILocation(line: 638, column: 3, scope: !3337)
!3396 = !DILocation(line: 640, column: 16, scope: !3337)
!3397 = !DILocation(line: 640, column: 9, scope: !3337)
!3398 = !DILocation(line: 640, column: 8, scope: !3337)
!3399 = !DILocation(line: 642, column: 36, scope: !3337)
!3400 = !DILocation(line: 642, column: 3, scope: !3337)
!3401 = !DILocation(line: 642, column: 12, scope: !3337)
!3402 = !DILocation(line: 642, column: 25, scope: !3337)
!3403 = !DILocation(line: 642, column: 34, scope: !3337)
!3404 = !DILocation(line: 643, column: 36, scope: !3337)
!3405 = !DILocation(line: 643, column: 3, scope: !3337)
!3406 = !DILocation(line: 643, column: 12, scope: !3337)
!3407 = !DILocation(line: 643, column: 25, scope: !3337)
!3408 = !DILocation(line: 643, column: 34, scope: !3337)
!3409 = !DILocation(line: 644, column: 36, scope: !3337)
!3410 = !DILocation(line: 644, column: 3, scope: !3337)
!3411 = !DILocation(line: 644, column: 12, scope: !3337)
!3412 = !DILocation(line: 644, column: 25, scope: !3337)
!3413 = !DILocation(line: 644, column: 34, scope: !3337)
!3414 = !DILocation(line: 645, column: 36, scope: !3337)
!3415 = !DILocation(line: 645, column: 3, scope: !3337)
!3416 = !DILocation(line: 645, column: 12, scope: !3337)
!3417 = !DILocation(line: 645, column: 25, scope: !3337)
!3418 = !DILocation(line: 645, column: 34, scope: !3337)
!3419 = !DILocation(line: 646, column: 42, scope: !3337)
!3420 = !DILocation(line: 646, column: 3, scope: !3337)
!3421 = !DILocation(line: 646, column: 12, scope: !3337)
!3422 = !DILocation(line: 646, column: 25, scope: !3337)
!3423 = !DILocation(line: 646, column: 34, scope: !3337)
!3424 = !DILocation(line: 647, column: 36, scope: !3337)
!3425 = !DILocation(line: 647, column: 3, scope: !3337)
!3426 = !DILocation(line: 647, column: 12, scope: !3337)
!3427 = !DILocation(line: 647, column: 25, scope: !3337)
!3428 = !DILocation(line: 647, column: 34, scope: !3337)
!3429 = !DILocation(line: 649, column: 10, scope: !3337)
!3430 = !DILocation(line: 649, column: 19, scope: !3337)
!3431 = !DILocation(line: 649, column: 32, scope: !3337)
!3432 = !DILocation(line: 649, column: 3, scope: !3337)
!3433 = !DILocation(line: 649, column: 40, scope: !3337)
!3434 = !DILocation(line: 651, column: 9, scope: !3337)
!3435 = !DILocation(line: 651, column: 18, scope: !3337)
!3436 = !DILocation(line: 651, column: 31, scope: !3337)
!3437 = !DILocation(line: 651, column: 8, scope: !3337)
!3438 = !DILocation(line: 653, column: 8, scope: !3439)
!3439 = distinct !DILexicalBlock(scope: !3337, file: !264, line: 653, column: 3)
!3440 = !DILocation(line: 653, column: 7, scope: !3439)
!3441 = !DILocation(line: 653, column: 11, scope: !3442)
!3442 = distinct !DILexicalBlock(scope: !3439, file: !264, line: 653, column: 3)
!3443 = !DILocation(line: 653, column: 12, scope: !3442)
!3444 = !DILocation(line: 653, column: 3, scope: !3439)
!3445 = !DILocation(line: 654, column: 5, scope: !3446)
!3446 = distinct !DILexicalBlock(scope: !3442, file: !264, line: 653, column: 28)
!3447 = !DILocation(line: 654, column: 11, scope: !3446)
!3448 = !DILocation(line: 654, column: 13, scope: !3446)
!3449 = !DILocation(line: 655, column: 3, scope: !3446)
!3450 = !DILocation(line: 653, column: 24, scope: !3442)
!3451 = !DILocation(line: 653, column: 3, scope: !3442)
!3452 = distinct !{!3452, !3444, !3453}
!3453 = !DILocation(line: 655, column: 3, scope: !3439)
!3454 = !DILocation(line: 657, column: 13, scope: !3455)
!3455 = distinct !DILexicalBlock(scope: !3337, file: !264, line: 657, column: 3)
!3456 = !DILocation(line: 657, column: 8, scope: !3455)
!3457 = !DILocation(line: 657, column: 18, scope: !3458)
!3458 = distinct !DILexicalBlock(scope: !3455, file: !264, line: 657, column: 3)
!3459 = !DILocation(line: 657, column: 25, scope: !3458)
!3460 = !DILocation(line: 657, column: 23, scope: !3458)
!3461 = !DILocation(line: 657, column: 3, scope: !3455)
!3462 = !DILocation(line: 658, column: 8, scope: !3463)
!3463 = distinct !DILexicalBlock(scope: !3458, file: !264, line: 657, column: 41)
!3464 = !DILocation(line: 658, column: 7, scope: !3463)
!3465 = !DILocation(line: 659, column: 15, scope: !3466)
!3466 = distinct !DILexicalBlock(scope: !3463, file: !264, line: 659, column: 5)
!3467 = !DILocation(line: 659, column: 10, scope: !3466)
!3468 = !DILocation(line: 659, column: 20, scope: !3469)
!3469 = distinct !DILexicalBlock(scope: !3466, file: !264, line: 659, column: 5)
!3470 = !DILocation(line: 659, column: 27, scope: !3469)
!3471 = !DILocation(line: 659, column: 25, scope: !3469)
!3472 = !DILocation(line: 659, column: 5, scope: !3466)
!3473 = !DILocation(line: 660, column: 16, scope: !3474)
!3474 = distinct !DILexicalBlock(scope: !3475, file: !264, line: 660, column: 11)
!3475 = distinct !DILexicalBlock(scope: !3469, file: !264, line: 659, column: 42)
!3476 = !DILocation(line: 660, column: 14, scope: !3474)
!3477 = !DILocation(line: 660, column: 29, scope: !3474)
!3478 = !DILocation(line: 660, column: 33, scope: !3474)
!3479 = !DILocation(line: 660, column: 36, scope: !3474)
!3480 = !DILocation(line: 660, column: 39, scope: !3474)
!3481 = !DILocation(line: 660, column: 37, scope: !3474)
!3482 = !DILocation(line: 660, column: 11, scope: !3475)
!3483 = !DILocation(line: 661, column: 12, scope: !3484)
!3484 = distinct !DILexicalBlock(scope: !3485, file: !264, line: 661, column: 12)
!3485 = distinct !DILexicalBlock(scope: !3474, file: !264, line: 660, column: 49)
!3486 = !DILocation(line: 661, column: 15, scope: !3484)
!3487 = !DILocation(line: 661, column: 13, scope: !3484)
!3488 = !DILocation(line: 661, column: 12, scope: !3485)
!3489 = !DILocation(line: 662, column: 19, scope: !3484)
!3490 = !DILocation(line: 662, column: 11, scope: !3484)
!3491 = !DILocation(line: 664, column: 12, scope: !3492)
!3492 = distinct !DILexicalBlock(scope: !3485, file: !264, line: 664, column: 12)
!3493 = !DILocation(line: 664, column: 16, scope: !3492)
!3494 = !DILocation(line: 664, column: 19, scope: !3492)
!3495 = !DILocation(line: 664, column: 22, scope: !3492)
!3496 = !DILocation(line: 664, column: 26, scope: !3492)
!3497 = !DILocation(line: 664, column: 12, scope: !3485)
!3498 = !DILocation(line: 665, column: 14, scope: !3499)
!3499 = distinct !DILexicalBlock(scope: !3500, file: !264, line: 665, column: 14)
!3500 = distinct !DILexicalBlock(scope: !3492, file: !264, line: 664, column: 30)
!3501 = !DILocation(line: 665, column: 14, scope: !3500)
!3502 = !DILocation(line: 666, column: 17, scope: !3503)
!3503 = distinct !DILexicalBlock(scope: !3504, file: !264, line: 666, column: 16)
!3504 = distinct !DILexicalBlock(scope: !3499, file: !264, line: 665, column: 23)
!3505 = !DILocation(line: 666, column: 16, scope: !3504)
!3506 = !DILocation(line: 668, column: 22, scope: !3507)
!3507 = distinct !DILexicalBlock(scope: !3503, file: !264, line: 666, column: 28)
!3508 = !DILocation(line: 668, column: 28, scope: !3507)
!3509 = !DILocation(line: 668, column: 27, scope: !3507)
!3510 = !DILocation(line: 668, column: 36, scope: !3507)
!3511 = !DILocation(line: 668, column: 42, scope: !3507)
!3512 = !DILocation(line: 668, column: 41, scope: !3507)
!3513 = !DILocation(line: 668, column: 15, scope: !3507)
!3514 = !DILocation(line: 669, column: 35, scope: !3507)
!3515 = !DILocation(line: 669, column: 41, scope: !3507)
!3516 = !DILocation(line: 669, column: 15, scope: !3507)
!3517 = !DILocation(line: 670, column: 19, scope: !3507)
!3518 = !DILocation(line: 672, column: 22, scope: !3507)
!3519 = !DILocation(line: 672, column: 32, scope: !3507)
!3520 = !DILocation(line: 672, column: 15, scope: !3507)
!3521 = !DILocation(line: 673, column: 15, scope: !3507)
!3522 = !DILocation(line: 673, column: 22, scope: !3523)
!3523 = distinct !DILexicalBlock(scope: !3524, file: !264, line: 673, column: 15)
!3524 = distinct !DILexicalBlock(scope: !3507, file: !264, line: 673, column: 15)
!3525 = !DILocation(line: 673, column: 29, scope: !3523)
!3526 = !DILocation(line: 673, column: 27, scope: !3523)
!3527 = !DILocation(line: 673, column: 15, scope: !3524)
!3528 = !DILocation(line: 674, column: 37, scope: !3523)
!3529 = !DILocation(line: 674, column: 43, scope: !3523)
!3530 = !DILocation(line: 674, column: 17, scope: !3523)
!3531 = !DILocation(line: 673, column: 42, scope: !3523)
!3532 = !DILocation(line: 673, column: 15, scope: !3523)
!3533 = distinct !{!3533, !3527, !3534}
!3534 = !DILocation(line: 674, column: 48, scope: !3524)
!3535 = !DILocation(line: 675, column: 13, scope: !3507)
!3536 = !DILocation(line: 678, column: 18, scope: !3537)
!3537 = distinct !DILexicalBlock(scope: !3538, file: !264, line: 678, column: 18)
!3538 = distinct !DILexicalBlock(scope: !3503, file: !264, line: 675, column: 20)
!3539 = !DILocation(line: 678, column: 22, scope: !3537)
!3540 = !DILocation(line: 678, column: 18, scope: !3538)
!3541 = !DILocation(line: 679, column: 40, scope: !3542)
!3542 = distinct !DILexicalBlock(scope: !3543, file: !264, line: 679, column: 20)
!3543 = distinct !DILexicalBlock(scope: !3537, file: !264, line: 678, column: 26)
!3544 = !DILocation(line: 679, column: 48, scope: !3542)
!3545 = !DILocation(line: 679, column: 21, scope: !3542)
!3546 = !DILocation(line: 679, column: 53, scope: !3542)
!3547 = !DILocation(line: 679, column: 56, scope: !3542)
!3548 = !DILocation(line: 679, column: 20, scope: !3543)
!3549 = !DILocation(line: 681, column: 26, scope: !3550)
!3550 = distinct !DILexicalBlock(scope: !3542, file: !264, line: 679, column: 61)
!3551 = !DILocation(line: 681, column: 32, scope: !3550)
!3552 = !DILocation(line: 681, column: 31, scope: !3550)
!3553 = !DILocation(line: 681, column: 41, scope: !3550)
!3554 = !DILocation(line: 681, column: 47, scope: !3550)
!3555 = !DILocation(line: 681, column: 46, scope: !3550)
!3556 = !DILocation(line: 681, column: 19, scope: !3550)
!3557 = !DILocation(line: 682, column: 17, scope: !3550)
!3558 = !DILocation(line: 684, column: 26, scope: !3559)
!3559 = distinct !DILexicalBlock(scope: !3542, file: !264, line: 682, column: 24)
!3560 = !DILocation(line: 684, column: 32, scope: !3559)
!3561 = !DILocation(line: 684, column: 31, scope: !3559)
!3562 = !DILocation(line: 684, column: 52, scope: !3559)
!3563 = !DILocation(line: 684, column: 59, scope: !3559)
!3564 = !DILocation(line: 684, column: 67, scope: !3559)
!3565 = !DILocation(line: 684, column: 38, scope: !3559)
!3566 = !DILocation(line: 684, column: 73, scope: !3559)
!3567 = !DILocation(line: 684, column: 72, scope: !3559)
!3568 = !DILocation(line: 685, column: 26, scope: !3559)
!3569 = !DILocation(line: 685, column: 32, scope: !3559)
!3570 = !DILocation(line: 685, column: 31, scope: !3559)
!3571 = !DILocation(line: 684, column: 19, scope: !3559)
!3572 = !DILocation(line: 687, column: 37, scope: !3543)
!3573 = !DILocation(line: 687, column: 43, scope: !3543)
!3574 = !DILocation(line: 687, column: 17, scope: !3543)
!3575 = !DILocation(line: 688, column: 21, scope: !3543)
!3576 = !DILocation(line: 689, column: 15, scope: !3543)
!3577 = !DILocation(line: 692, column: 22, scope: !3538)
!3578 = !DILocation(line: 692, column: 32, scope: !3538)
!3579 = !DILocation(line: 692, column: 15, scope: !3538)
!3580 = !DILocation(line: 693, column: 15, scope: !3538)
!3581 = !DILocation(line: 693, column: 42, scope: !3582)
!3582 = distinct !DILexicalBlock(scope: !3583, file: !264, line: 693, column: 15)
!3583 = distinct !DILexicalBlock(scope: !3538, file: !264, line: 693, column: 15)
!3584 = !DILocation(line: 693, column: 50, scope: !3582)
!3585 = !DILocation(line: 693, column: 23, scope: !3582)
!3586 = !DILocation(line: 693, column: 55, scope: !3582)
!3587 = !DILocation(line: 693, column: 58, scope: !3582)
!3588 = !DILocation(line: 693, column: 15, scope: !3583)
!3589 = !DILocation(line: 694, column: 37, scope: !3582)
!3590 = !DILocation(line: 694, column: 43, scope: !3582)
!3591 = !DILocation(line: 694, column: 17, scope: !3582)
!3592 = !DILocation(line: 693, column: 68, scope: !3582)
!3593 = !DILocation(line: 693, column: 15, scope: !3582)
!3594 = distinct !{!3594, !3588, !3595}
!3595 = !DILocation(line: 694, column: 48, scope: !3583)
!3596 = !DILocation(line: 697, column: 15, scope: !3538)
!3597 = !DILocation(line: 697, column: 22, scope: !3598)
!3598 = distinct !DILexicalBlock(scope: !3599, file: !264, line: 697, column: 15)
!3599 = distinct !DILexicalBlock(scope: !3538, file: !264, line: 697, column: 15)
!3600 = !DILocation(line: 697, column: 27, scope: !3598)
!3601 = !DILocation(line: 697, column: 26, scope: !3598)
!3602 = !DILocation(line: 697, column: 15, scope: !3599)
!3603 = !DILocation(line: 698, column: 24, scope: !3604)
!3604 = distinct !DILexicalBlock(scope: !3598, file: !264, line: 697, column: 44)
!3605 = !DILocation(line: 698, column: 45, scope: !3604)
!3606 = !DILocation(line: 698, column: 52, scope: !3604)
!3607 = !DILocation(line: 698, column: 60, scope: !3604)
!3608 = !DILocation(line: 698, column: 31, scope: !3604)
!3609 = !DILocation(line: 698, column: 67, scope: !3604)
!3610 = !DILocation(line: 698, column: 17, scope: !3604)
!3611 = !DILocation(line: 699, column: 37, scope: !3604)
!3612 = !DILocation(line: 699, column: 43, scope: !3604)
!3613 = !DILocation(line: 699, column: 17, scope: !3604)
!3614 = !DILocation(line: 700, column: 15, scope: !3604)
!3615 = !DILocation(line: 697, column: 40, scope: !3598)
!3616 = !DILocation(line: 697, column: 15, scope: !3598)
!3617 = distinct !{!3617, !3602, !3618}
!3618 = !DILocation(line: 700, column: 15, scope: !3599)
!3619 = !DILocation(line: 702, column: 13, scope: !3504)
!3620 = !DILocation(line: 704, column: 13, scope: !3621)
!3621 = distinct !DILexicalBlock(scope: !3499, file: !264, line: 703, column: 18)
!3622 = !DILocation(line: 705, column: 13, scope: !3621)
!3623 = !DILocation(line: 708, column: 11, scope: !3624)
!3624 = distinct !DILexicalBlock(scope: !3492, file: !264, line: 707, column: 16)
!3625 = !DILocation(line: 712, column: 7, scope: !3475)
!3626 = !DILocation(line: 712, column: 13, scope: !3475)
!3627 = !DILocation(line: 712, column: 15, scope: !3475)
!3628 = !DILocation(line: 714, column: 13, scope: !3475)
!3629 = !DILocation(line: 714, column: 10, scope: !3475)
!3630 = !DILocation(line: 714, column: 12, scope: !3475)
!3631 = !DILocation(line: 715, column: 5, scope: !3475)
!3632 = !DILocation(line: 659, column: 38, scope: !3469)
!3633 = !DILocation(line: 659, column: 5, scope: !3469)
!3634 = distinct !{!3634, !3472, !3635}
!3635 = !DILocation(line: 715, column: 5, scope: !3466)
!3636 = !DILocation(line: 716, column: 25, scope: !3463)
!3637 = !DILocation(line: 716, column: 31, scope: !3463)
!3638 = !DILocation(line: 716, column: 5, scope: !3463)
!3639 = !DILocation(line: 717, column: 3, scope: !3463)
!3640 = !DILocation(line: 657, column: 37, scope: !3458)
!3641 = !DILocation(line: 657, column: 3, scope: !3458)
!3642 = distinct !{!3642, !3461, !3643}
!3643 = !DILocation(line: 717, column: 3, scope: !3455)
!3644 = !DILabel(scope: !3337, name: "fini", file: !264, line: 718)
!3645 = !DILocation(line: 718, column: 2, scope: !3337)
!3646 = !DILocation(line: 720, column: 3, scope: !3337)
!3647 = !DILocation(line: 720, column: 9, scope: !3337)
!3648 = !DILocation(line: 720, column: 20, scope: !3337)
!3649 = !DILocation(line: 721, column: 5, scope: !3337)
!3650 = distinct !{!3650, !3646, !3649}
!3651 = !DILocation(line: 723, column: 8, scope: !3337)
!3652 = !DILocation(line: 723, column: 3, scope: !3337)
!3653 = !DILocation(line: 725, column: 3, scope: !3337)
!3654 = !DILocation(line: 731, column: 21, scope: !3337)
!3655 = !DILocation(line: 732, column: 19, scope: !3337)
!3656 = !DILocation(line: 733, column: 19, scope: !3337)
!3657 = !DILocation(line: 734, column: 18, scope: !3337)
!3658 = !DILocation(line: 736, column: 3, scope: !3337)
!3659 = !DILocation(line: 737, column: 1, scope: !3337)
!3660 = distinct !DISubprogram(name: "initLWZ", scope: !264, file: !264, line: 424, type: !3661, scopeLine: 425, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !263, retainedNodes: !4)
!3661 = !DISubroutineType(types: !3662)
!3662 = !{null, !7}
!3663 = !DILocalVariable(name: "input_code_size", arg: 1, scope: !3660, file: !264, line: 424, type: !7)
!3664 = !DILocation(line: 424, column: 25, scope: !3660)
!3665 = !DILocation(line: 426, column: 19, scope: !3660)
!3666 = !DILocation(line: 426, column: 17, scope: !3660)
!3667 = !DILocation(line: 427, column: 19, scope: !3660)
!3668 = !DILocation(line: 427, column: 33, scope: !3660)
!3669 = !DILocation(line: 427, column: 17, scope: !3660)
!3670 = !DILocation(line: 428, column: 24, scope: !3660)
!3671 = !DILocation(line: 428, column: 21, scope: !3660)
!3672 = !DILocation(line: 428, column: 17, scope: !3660)
!3673 = !DILocation(line: 429, column: 19, scope: !3660)
!3674 = !DILocation(line: 429, column: 30, scope: !3660)
!3675 = !DILocation(line: 429, column: 17, scope: !3660)
!3676 = !DILocation(line: 430, column: 23, scope: !3660)
!3677 = !DILocation(line: 430, column: 21, scope: !3660)
!3678 = !DILocation(line: 430, column: 17, scope: !3660)
!3679 = !DILocation(line: 431, column: 19, scope: !3660)
!3680 = !DILocation(line: 431, column: 30, scope: !3660)
!3681 = !DILocation(line: 431, column: 17, scope: !3660)
!3682 = !DILocation(line: 433, column: 20, scope: !3660)
!3683 = !DILocation(line: 433, column: 10, scope: !3660)
!3684 = !DILocation(line: 434, column: 13, scope: !3660)
!3685 = !DILocation(line: 435, column: 12, scope: !3660)
!3686 = !DILocation(line: 437, column: 16, scope: !3660)
!3687 = !DILocation(line: 439, column: 6, scope: !3660)
!3688 = !DILocation(line: 440, column: 1, scope: !3660)
!3689 = !DILocalVariable(name: "fd", arg: 1, scope: !397, file: !264, line: 504, type: !272)
!3690 = !DILocation(line: 504, column: 26, scope: !397)
!3691 = !DILocalVariable(name: "code", scope: !397, file: !264, line: 508, type: !7)
!3692 = !DILocation(line: 508, column: 20, scope: !397)
!3693 = !DILocalVariable(name: "incode", scope: !397, file: !264, line: 508, type: !7)
!3694 = !DILocation(line: 508, column: 26, scope: !397)
!3695 = !DILocalVariable(name: "i", scope: !397, file: !264, line: 509, type: !7)
!3696 = !DILocation(line: 509, column: 20, scope: !397)
!3697 = !DILocation(line: 511, column: 3, scope: !397)
!3698 = !DILocation(line: 511, column: 27, scope: !397)
!3699 = !DILocation(line: 511, column: 31, scope: !397)
!3700 = !DILocation(line: 511, column: 18, scope: !397)
!3701 = !DILocation(line: 511, column: 16, scope: !397)
!3702 = !DILocation(line: 511, column: 43, scope: !397)
!3703 = !DILocation(line: 512, column: 9, scope: !3704)
!3704 = distinct !DILexicalBlock(scope: !3705, file: !264, line: 512, column: 9)
!3705 = distinct !DILexicalBlock(scope: !397, file: !264, line: 511, column: 49)
!3706 = !DILocation(line: 512, column: 17, scope: !3704)
!3707 = !DILocation(line: 512, column: 14, scope: !3704)
!3708 = !DILocation(line: 512, column: 9, scope: !3705)
!3709 = !DILocation(line: 515, column: 11, scope: !3710)
!3710 = distinct !DILexicalBlock(scope: !3711, file: !264, line: 515, column: 11)
!3711 = distinct !DILexicalBlock(scope: !3704, file: !264, line: 512, column: 29)
!3712 = !DILocation(line: 515, column: 22, scope: !3710)
!3713 = !DILocation(line: 515, column: 11, scope: !3711)
!3714 = !DILocation(line: 516, column: 9, scope: !3715)
!3715 = distinct !DILexicalBlock(scope: !3710, file: !264, line: 515, column: 44)
!3716 = !DILocation(line: 519, column: 14, scope: !3717)
!3717 = distinct !DILexicalBlock(scope: !3711, file: !264, line: 519, column: 7)
!3718 = !DILocation(line: 519, column: 12, scope: !3717)
!3719 = !DILocation(line: 519, column: 19, scope: !3720)
!3720 = distinct !DILexicalBlock(scope: !3717, file: !264, line: 519, column: 7)
!3721 = !DILocation(line: 519, column: 23, scope: !3720)
!3722 = !DILocation(line: 519, column: 21, scope: !3720)
!3723 = !DILocation(line: 519, column: 7, scope: !3717)
!3724 = !DILocation(line: 520, column: 18, scope: !3725)
!3725 = distinct !DILexicalBlock(scope: !3720, file: !264, line: 519, column: 40)
!3726 = !DILocation(line: 520, column: 9, scope: !3725)
!3727 = !DILocation(line: 520, column: 21, scope: !3725)
!3728 = !DILocation(line: 521, column: 23, scope: !3725)
!3729 = !DILocation(line: 521, column: 18, scope: !3725)
!3730 = !DILocation(line: 521, column: 9, scope: !3725)
!3731 = !DILocation(line: 521, column: 21, scope: !3725)
!3732 = !DILocation(line: 522, column: 7, scope: !3725)
!3733 = !DILocation(line: 519, column: 35, scope: !3720)
!3734 = !DILocation(line: 519, column: 7, scope: !3720)
!3735 = distinct !{!3735, !3723, !3736}
!3736 = !DILocation(line: 522, column: 7, scope: !3717)
!3737 = !DILocation(line: 523, column: 7, scope: !3711)
!3738 = !DILocation(line: 523, column: 14, scope: !3739)
!3739 = distinct !DILexicalBlock(scope: !3740, file: !264, line: 523, column: 7)
!3740 = distinct !DILexicalBlock(scope: !3711, file: !264, line: 523, column: 7)
!3741 = !DILocation(line: 523, column: 16, scope: !3739)
!3742 = !DILocation(line: 523, column: 7, scope: !3740)
!3743 = !DILocation(line: 524, column: 32, scope: !3739)
!3744 = !DILocation(line: 524, column: 23, scope: !3739)
!3745 = !DILocation(line: 524, column: 35, scope: !3739)
!3746 = !DILocation(line: 524, column: 18, scope: !3739)
!3747 = !DILocation(line: 524, column: 9, scope: !3739)
!3748 = !DILocation(line: 524, column: 21, scope: !3739)
!3749 = !DILocation(line: 523, column: 37, scope: !3739)
!3750 = !DILocation(line: 523, column: 7, scope: !3739)
!3751 = distinct !{!3751, !3742, !3752}
!3752 = !DILocation(line: 524, column: 37, scope: !3740)
!3753 = !DILocation(line: 525, column: 19, scope: !3711)
!3754 = !DILocation(line: 525, column: 32, scope: !3711)
!3755 = !DILocation(line: 525, column: 17, scope: !3711)
!3756 = !DILocation(line: 526, column: 25, scope: !3711)
!3757 = !DILocation(line: 526, column: 24, scope: !3711)
!3758 = !DILocation(line: 526, column: 21, scope: !3711)
!3759 = !DILocation(line: 527, column: 18, scope: !3711)
!3760 = !DILocation(line: 527, column: 28, scope: !3711)
!3761 = !DILocation(line: 527, column: 16, scope: !3711)
!3762 = !DILocation(line: 528, column: 10, scope: !3711)
!3763 = !DILocation(line: 529, column: 7, scope: !3711)
!3764 = !DILocation(line: 530, column: 40, scope: !3765)
!3765 = distinct !DILexicalBlock(scope: !3711, file: !264, line: 529, column: 10)
!3766 = !DILocation(line: 530, column: 44, scope: !3765)
!3767 = !DILocation(line: 530, column: 31, scope: !3765)
!3768 = !DILocation(line: 530, column: 29, scope: !3765)
!3769 = !DILocation(line: 530, column: 19, scope: !3765)
!3770 = !DILocation(line: 531, column: 7, scope: !3765)
!3771 = !DILocation(line: 531, column: 16, scope: !3711)
!3772 = !DILocation(line: 531, column: 29, scope: !3711)
!3773 = !DILocation(line: 531, column: 26, scope: !3711)
!3774 = distinct !{!3774, !3763, !3775}
!3775 = !DILocation(line: 531, column: 39, scope: !3711)
!3776 = !DILocation(line: 533, column: 14, scope: !3711)
!3777 = !DILocation(line: 533, column: 7, scope: !3711)
!3778 = !DILocation(line: 535, column: 9, scope: !3779)
!3779 = distinct !DILexicalBlock(scope: !3705, file: !264, line: 535, column: 9)
!3780 = !DILocation(line: 535, column: 17, scope: !3779)
!3781 = !DILocation(line: 535, column: 14, scope: !3779)
!3782 = !DILocation(line: 535, column: 9, scope: !3705)
!3783 = !DILocalVariable(name: "count", scope: !3784, file: !264, line: 536, type: !7)
!3784 = distinct !DILexicalBlock(scope: !3779, file: !264, line: 535, column: 27)
!3785 = !DILocation(line: 536, column: 23, scope: !3784)
!3786 = !DILocalVariable(name: "buf", scope: !3784, file: !264, line: 537, type: !3787)
!3787 = !DICompositeType(tag: DW_TAG_array_type, baseType: !42, size: 2080, elements: !3788)
!3788 = !{!3789}
!3789 = !DISubrange(count: 260)
!3790 = !DILocation(line: 537, column: 23, scope: !3784)
!3791 = !DILocation(line: 539, column: 11, scope: !3792)
!3792 = distinct !DILexicalBlock(scope: !3784, file: !264, line: 539, column: 11)
!3793 = !DILocation(line: 539, column: 11, scope: !3784)
!3794 = !DILocation(line: 540, column: 9, scope: !3792)
!3795 = !DILocation(line: 542, column: 7, scope: !3784)
!3796 = !DILocation(line: 542, column: 36, scope: !3784)
!3797 = !DILocation(line: 542, column: 40, scope: !3784)
!3798 = !DILocation(line: 542, column: 23, scope: !3784)
!3799 = !DILocation(line: 542, column: 21, scope: !3784)
!3800 = !DILocation(line: 542, column: 46, scope: !3784)
!3801 = distinct !{!3801, !3795, !3802}
!3802 = !DILocation(line: 543, column: 9, scope: !3784)
!3803 = !DILocation(line: 545, column: 11, scope: !3804)
!3804 = distinct !DILexicalBlock(scope: !3784, file: !264, line: 545, column: 11)
!3805 = !DILocation(line: 545, column: 17, scope: !3804)
!3806 = !DILocation(line: 545, column: 11, scope: !3784)
!3807 = !DILocation(line: 546, column: 17, scope: !3808)
!3808 = distinct !DILexicalBlock(scope: !3804, file: !264, line: 545, column: 23)
!3809 = !DILocation(line: 546, column: 9, scope: !3808)
!3810 = !DILocation(line: 547, column: 7, scope: !3808)
!3811 = !DILocation(line: 548, column: 7, scope: !3784)
!3812 = !DILocation(line: 551, column: 14, scope: !3705)
!3813 = !DILocation(line: 551, column: 12, scope: !3705)
!3814 = !DILocation(line: 553, column: 9, scope: !3815)
!3815 = distinct !DILexicalBlock(scope: !3705, file: !264, line: 553, column: 9)
!3816 = !DILocation(line: 553, column: 17, scope: !3815)
!3817 = !DILocation(line: 553, column: 14, scope: !3815)
!3818 = !DILocation(line: 553, column: 9, scope: !3705)
!3819 = !DILocation(line: 554, column: 15, scope: !3820)
!3820 = distinct !DILexicalBlock(scope: !3815, file: !264, line: 553, column: 27)
!3821 = !DILocation(line: 554, column: 10, scope: !3820)
!3822 = !DILocation(line: 554, column: 13, scope: !3820)
!3823 = !DILocation(line: 555, column: 14, scope: !3820)
!3824 = !DILocation(line: 555, column: 12, scope: !3820)
!3825 = !DILocation(line: 556, column: 5, scope: !3820)
!3826 = !DILocation(line: 558, column: 5, scope: !3705)
!3827 = !DILocation(line: 558, column: 12, scope: !3705)
!3828 = !DILocation(line: 558, column: 20, scope: !3705)
!3829 = !DILocation(line: 558, column: 17, scope: !3705)
!3830 = !DILocation(line: 559, column: 24, scope: !3831)
!3831 = distinct !DILexicalBlock(scope: !3705, file: !264, line: 558, column: 32)
!3832 = !DILocation(line: 559, column: 15, scope: !3831)
!3833 = !DILocation(line: 559, column: 10, scope: !3831)
!3834 = !DILocation(line: 559, column: 13, scope: !3831)
!3835 = !DILocation(line: 560, column: 11, scope: !3836)
!3836 = distinct !DILexicalBlock(scope: !3831, file: !264, line: 560, column: 11)
!3837 = !DILocation(line: 560, column: 28, scope: !3836)
!3838 = !DILocation(line: 560, column: 19, scope: !3836)
!3839 = !DILocation(line: 560, column: 16, scope: !3836)
!3840 = !DILocation(line: 560, column: 11, scope: !3831)
!3841 = !DILocation(line: 561, column: 17, scope: !3842)
!3842 = distinct !DILexicalBlock(scope: !3836, file: !264, line: 560, column: 35)
!3843 = !DILocation(line: 561, column: 9, scope: !3842)
!3844 = !DILocation(line: 562, column: 16, scope: !3842)
!3845 = !DILocation(line: 562, column: 9, scope: !3842)
!3846 = !DILocation(line: 564, column: 20, scope: !3847)
!3847 = distinct !DILexicalBlock(scope: !3831, file: !264, line: 564, column: 11)
!3848 = !DILocation(line: 564, column: 12, scope: !3847)
!3849 = !DILocation(line: 564, column: 23, scope: !3847)
!3850 = !DILocation(line: 564, column: 40, scope: !3847)
!3851 = !DILocation(line: 564, column: 11, scope: !3831)
!3852 = !DILocation(line: 565, column: 17, scope: !3853)
!3853 = distinct !DILexicalBlock(scope: !3847, file: !264, line: 564, column: 58)
!3854 = !DILocation(line: 565, column: 9, scope: !3853)
!3855 = !DILocation(line: 566, column: 16, scope: !3853)
!3856 = !DILocation(line: 566, column: 9, scope: !3853)
!3857 = !DILocation(line: 568, column: 23, scope: !3831)
!3858 = !DILocation(line: 568, column: 14, scope: !3831)
!3859 = !DILocation(line: 568, column: 12, scope: !3831)
!3860 = distinct !{!3860, !3826, !3861}
!3861 = !DILocation(line: 569, column: 5, scope: !3705)
!3862 = !DILocation(line: 571, column: 34, scope: !3705)
!3863 = !DILocation(line: 571, column: 25, scope: !3705)
!3864 = !DILocation(line: 571, column: 23, scope: !3705)
!3865 = !DILocation(line: 571, column: 8, scope: !3705)
!3866 = !DILocation(line: 571, column: 11, scope: !3705)
!3867 = !DILocation(line: 573, column: 17, scope: !3868)
!3868 = distinct !DILexicalBlock(scope: !3705, file: !264, line: 573, column: 9)
!3869 = !DILocation(line: 573, column: 15, scope: !3868)
!3870 = !DILocation(line: 573, column: 27, scope: !3868)
!3871 = !DILocation(line: 573, column: 9, scope: !3705)
!3872 = !DILocation(line: 574, column: 24, scope: !3873)
!3873 = distinct !DILexicalBlock(scope: !3868, file: !264, line: 573, column: 47)
!3874 = !DILocation(line: 574, column: 16, scope: !3873)
!3875 = !DILocation(line: 574, column: 7, scope: !3873)
!3876 = !DILocation(line: 574, column: 22, scope: !3873)
!3877 = !DILocation(line: 575, column: 24, scope: !3873)
!3878 = !DILocation(line: 575, column: 16, scope: !3873)
!3879 = !DILocation(line: 575, column: 7, scope: !3873)
!3880 = !DILocation(line: 575, column: 22, scope: !3873)
!3881 = !DILocation(line: 576, column: 7, scope: !3873)
!3882 = !DILocation(line: 577, column: 12, scope: !3883)
!3883 = distinct !DILexicalBlock(scope: !3873, file: !264, line: 577, column: 11)
!3884 = !DILocation(line: 577, column: 24, scope: !3883)
!3885 = !DILocation(line: 577, column: 21, scope: !3883)
!3886 = !DILocation(line: 577, column: 39, scope: !3883)
!3887 = !DILocation(line: 578, column: 12, scope: !3883)
!3888 = !DILocation(line: 578, column: 26, scope: !3883)
!3889 = !DILocation(line: 577, column: 11, scope: !3873)
!3890 = !DILocation(line: 579, column: 23, scope: !3891)
!3891 = distinct !DILexicalBlock(scope: !3883, file: !264, line: 578, column: 48)
!3892 = !DILocation(line: 580, column: 9, scope: !3891)
!3893 = !DILocation(line: 581, column: 7, scope: !3891)
!3894 = !DILocation(line: 582, column: 5, scope: !3873)
!3895 = !DILocation(line: 584, column: 15, scope: !3705)
!3896 = !DILocation(line: 584, column: 13, scope: !3705)
!3897 = !DILocation(line: 586, column: 9, scope: !3898)
!3898 = distinct !DILexicalBlock(scope: !3705, file: !264, line: 586, column: 9)
!3899 = !DILocation(line: 586, column: 12, scope: !3898)
!3900 = !DILocation(line: 586, column: 9, scope: !3705)
!3901 = !DILocation(line: 587, column: 15, scope: !3898)
!3902 = !DILocation(line: 587, column: 14, scope: !3898)
!3903 = !DILocation(line: 587, column: 7, scope: !3898)
!3904 = distinct !{!3904, !3697, !3905}
!3905 = !DILocation(line: 588, column: 3, scope: !397)
!3906 = !DILocation(line: 589, column: 10, scope: !397)
!3907 = !DILocation(line: 589, column: 3, scope: !397)
!3908 = !DILocation(line: 590, column: 1, scope: !397)
!3909 = distinct !DISubprogram(name: "get_prev_line", scope: !264, file: !264, line: 595, type: !3910, scopeLine: 596, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !263, retainedNodes: !4)
!3910 = !DISubroutineType(types: !3911)
!3911 = !{!241, !7, !7, !7}
!3912 = !DILocalVariable(name: "width", arg: 1, scope: !3909, file: !264, line: 595, type: !7)
!3913 = !DILocation(line: 595, column: 19, scope: !3909)
!3914 = !DILocalVariable(name: "height", arg: 2, scope: !3909, file: !264, line: 595, type: !7)
!3915 = !DILocation(line: 595, column: 30, scope: !3909)
!3916 = !DILocalVariable(name: "line", arg: 3, scope: !3909, file: !264, line: 595, type: !7)
!3917 = !DILocation(line: 595, column: 42, scope: !3909)
!3918 = !DILocalVariable(name: "prev_line", scope: !3909, file: !264, line: 597, type: !7)
!3919 = !DILocation(line: 597, column: 7, scope: !3909)
!3920 = !DILocalVariable(name: "res", scope: !3909, file: !264, line: 598, type: !241)
!3921 = !DILocation(line: 598, column: 9, scope: !3909)
!3922 = !DILocation(line: 600, column: 32, scope: !3909)
!3923 = !DILocation(line: 600, column: 39, scope: !3909)
!3924 = !DILocation(line: 600, column: 13, scope: !3909)
!3925 = !DILocation(line: 600, column: 44, scope: !3909)
!3926 = !DILocation(line: 600, column: 12, scope: !3909)
!3927 = !DILocation(line: 601, column: 3, scope: !3909)
!3928 = !DILocation(line: 601, column: 24, scope: !3909)
!3929 = !DILocation(line: 601, column: 32, scope: !3909)
!3930 = !DILocation(line: 601, column: 9, scope: !3909)
!3931 = !DILocation(line: 601, column: 44, scope: !3909)
!3932 = !DILocation(line: 601, column: 42, scope: !3909)
!3933 = !DILocation(line: 602, column: 14, scope: !3909)
!3934 = distinct !{!3934, !3927, !3933}
!3935 = !DILocation(line: 604, column: 9, scope: !3909)
!3936 = !DILocation(line: 604, column: 18, scope: !3909)
!3937 = !DILocation(line: 604, column: 25, scope: !3909)
!3938 = !DILocation(line: 604, column: 46, scope: !3909)
!3939 = !DILocation(line: 604, column: 54, scope: !3909)
!3940 = !DILocation(line: 604, column: 31, scope: !3909)
!3941 = !DILocation(line: 604, column: 30, scope: !3909)
!3942 = !DILocation(line: 604, column: 23, scope: !3909)
!3943 = !DILocation(line: 604, column: 7, scope: !3909)
!3944 = !DILocation(line: 606, column: 10, scope: !3909)
!3945 = !DILocation(line: 606, column: 3, scope: !3909)
!3946 = !DILocalVariable(name: "fd", arg: 1, scope: !408, file: !264, line: 442, type: !272)
!3947 = !DILocation(line: 442, column: 27, scope: !408)
!3948 = !DILocalVariable(name: "code_size", arg: 2, scope: !408, file: !264, line: 442, type: !7)
!3949 = !DILocation(line: 442, column: 35, scope: !408)
!3950 = !DILocalVariable(name: "i", scope: !408, file: !264, line: 451, type: !7)
!3951 = !DILocation(line: 451, column: 7, scope: !408)
!3952 = !DILocalVariable(name: "j", scope: !408, file: !264, line: 451, type: !7)
!3953 = !DILocation(line: 451, column: 10, scope: !408)
!3954 = !DILocalVariable(name: "end", scope: !408, file: !264, line: 451, type: !7)
!3955 = !DILocation(line: 451, column: 13, scope: !408)
!3956 = !DILocalVariable(name: "ret", scope: !408, file: !264, line: 452, type: !202)
!3957 = !DILocation(line: 452, column: 8, scope: !408)
!3958 = !DILocation(line: 454, column: 7, scope: !3959)
!3959 = distinct !DILexicalBlock(scope: !408, file: !264, line: 454, column: 7)
!3960 = !DILocation(line: 454, column: 7, scope: !408)
!3961 = !DILocation(line: 455, column: 18, scope: !3962)
!3962 = distinct !DILexicalBlock(scope: !3959, file: !264, line: 454, column: 21)
!3963 = !DILocation(line: 456, column: 12, scope: !3962)
!3964 = !DILocation(line: 456, column: 5, scope: !3962)
!3965 = !DILocation(line: 459, column: 9, scope: !408)
!3966 = !DILocation(line: 459, column: 18, scope: !408)
!3967 = !DILocation(line: 459, column: 16, scope: !408)
!3968 = !DILocation(line: 459, column: 7, scope: !408)
!3969 = !DILocation(line: 461, column: 7, scope: !3970)
!3970 = distinct !DILexicalBlock(scope: !408, file: !264, line: 461, column: 7)
!3971 = !DILocation(line: 461, column: 14, scope: !3970)
!3972 = !DILocation(line: 461, column: 11, scope: !3970)
!3973 = !DILocation(line: 461, column: 7, scope: !408)
!3974 = !DILocalVariable(name: "count", scope: !3975, file: !264, line: 462, type: !7)
!3975 = distinct !DILexicalBlock(scope: !3970, file: !264, line: 461, column: 23)
!3976 = !DILocation(line: 462, column: 13, scope: !3975)
!3977 = !DILocation(line: 464, column: 9, scope: !3978)
!3978 = distinct !DILexicalBlock(scope: !3975, file: !264, line: 464, column: 9)
!3979 = !DILocation(line: 464, column: 9, scope: !3975)
!3980 = !DILocation(line: 465, column: 11, scope: !3981)
!3981 = distinct !DILexicalBlock(scope: !3982, file: !264, line: 465, column: 11)
!3982 = distinct !DILexicalBlock(scope: !3978, file: !264, line: 464, column: 19)
!3983 = !DILocation(line: 465, column: 19, scope: !3981)
!3984 = !DILocation(line: 465, column: 22, scope: !3981)
!3985 = !DILocation(line: 465, column: 32, scope: !3981)
!3986 = !DILocation(line: 465, column: 29, scope: !3981)
!3987 = !DILocation(line: 465, column: 11, scope: !3982)
!3988 = !DILocation(line: 466, column: 17, scope: !3989)
!3989 = distinct !DILexicalBlock(scope: !3981, file: !264, line: 465, column: 41)
!3990 = !DILocation(line: 466, column: 9, scope: !3989)
!3991 = !DILocation(line: 467, column: 7, scope: !3989)
!3992 = !DILocation(line: 468, column: 7, scope: !3982)
!3993 = !DILocation(line: 470, column: 18, scope: !3975)
!3994 = !DILocation(line: 470, column: 27, scope: !3975)
!3995 = !DILocation(line: 470, column: 14, scope: !3975)
!3996 = !DILocation(line: 470, column: 12, scope: !3975)
!3997 = !DILocation(line: 471, column: 18, scope: !3975)
!3998 = !DILocation(line: 471, column: 27, scope: !3975)
!3999 = !DILocation(line: 471, column: 14, scope: !3975)
!4000 = !DILocation(line: 471, column: 12, scope: !3975)
!4001 = !DILocation(line: 473, column: 31, scope: !4002)
!4002 = distinct !DILexicalBlock(scope: !3975, file: !264, line: 473, column: 9)
!4003 = !DILocation(line: 473, column: 18, scope: !4002)
!4004 = !DILocation(line: 473, column: 16, scope: !4002)
!4005 = !DILocation(line: 473, column: 45, scope: !4002)
!4006 = !DILocation(line: 473, column: 9, scope: !3975)
!4007 = !DILocation(line: 474, column: 16, scope: !4002)
!4008 = !DILocation(line: 474, column: 7, scope: !4002)
!4009 = !DILocation(line: 476, column: 9, scope: !4010)
!4010 = distinct !DILexicalBlock(scope: !3975, file: !264, line: 476, column: 9)
!4011 = !DILocation(line: 476, column: 14, scope: !4010)
!4012 = !DILocation(line: 476, column: 9, scope: !3975)
!4013 = !DILocation(line: 476, column: 18, scope: !4010)
!4014 = !DILocation(line: 478, column: 21, scope: !3975)
!4015 = !DILocation(line: 478, column: 19, scope: !3975)
!4016 = !DILocation(line: 478, column: 15, scope: !3975)
!4017 = !DILocation(line: 479, column: 15, scope: !3975)
!4018 = !DILocation(line: 479, column: 24, scope: !3975)
!4019 = !DILocation(line: 479, column: 22, scope: !3975)
!4020 = !DILocation(line: 479, column: 33, scope: !3975)
!4021 = !DILocation(line: 479, column: 12, scope: !3975)
!4022 = !DILocation(line: 480, column: 18, scope: !3975)
!4023 = !DILocation(line: 480, column: 17, scope: !3975)
!4024 = !DILocation(line: 480, column: 24, scope: !3975)
!4025 = !DILocation(line: 480, column: 13, scope: !3975)
!4026 = !DILocation(line: 482, column: 11, scope: !3975)
!4027 = !DILocation(line: 482, column: 20, scope: !3975)
!4028 = !DILocation(line: 482, column: 18, scope: !3975)
!4029 = !DILocation(line: 482, column: 9, scope: !3975)
!4030 = !DILocation(line: 483, column: 3, scope: !3975)
!4031 = !DILocation(line: 485, column: 7, scope: !408)
!4032 = !DILocation(line: 485, column: 11, scope: !408)
!4033 = !DILocation(line: 485, column: 5, scope: !408)
!4034 = !DILocation(line: 486, column: 7, scope: !408)
!4035 = !DILocation(line: 486, column: 14, scope: !408)
!4036 = !DILocation(line: 486, column: 5, scope: !408)
!4037 = !DILocation(line: 488, column: 7, scope: !4038)
!4038 = distinct !DILexicalBlock(scope: !408, file: !264, line: 488, column: 7)
!4039 = !DILocation(line: 488, column: 12, scope: !4038)
!4040 = !DILocation(line: 488, column: 9, scope: !4038)
!4041 = !DILocation(line: 488, column: 7, scope: !408)
!4042 = !DILocation(line: 489, column: 21, scope: !4038)
!4043 = !DILocation(line: 489, column: 17, scope: !4038)
!4044 = !DILocation(line: 489, column: 11, scope: !4038)
!4045 = !DILocation(line: 489, column: 9, scope: !4038)
!4046 = !DILocation(line: 489, column: 5, scope: !4038)
!4047 = !DILocation(line: 490, column: 12, scope: !4048)
!4048 = distinct !DILexicalBlock(scope: !4038, file: !264, line: 490, column: 12)
!4049 = !DILocation(line: 490, column: 14, scope: !4048)
!4050 = !DILocation(line: 490, column: 21, scope: !4048)
!4051 = !DILocation(line: 490, column: 18, scope: !4048)
!4052 = !DILocation(line: 490, column: 12, scope: !4038)
!4053 = !DILocation(line: 491, column: 21, scope: !4048)
!4054 = !DILocation(line: 491, column: 17, scope: !4048)
!4055 = !DILocation(line: 491, column: 11, scope: !4048)
!4056 = !DILocation(line: 491, column: 37, scope: !4048)
!4057 = !DILocation(line: 491, column: 38, scope: !4048)
!4058 = !DILocation(line: 491, column: 33, scope: !4048)
!4059 = !DILocation(line: 491, column: 27, scope: !4048)
!4060 = !DILocation(line: 491, column: 42, scope: !4048)
!4061 = !DILocation(line: 491, column: 24, scope: !4048)
!4062 = !DILocation(line: 491, column: 9, scope: !4048)
!4063 = !DILocation(line: 491, column: 5, scope: !4048)
!4064 = !DILocation(line: 493, column: 21, scope: !4048)
!4065 = !DILocation(line: 493, column: 17, scope: !4048)
!4066 = !DILocation(line: 493, column: 11, scope: !4048)
!4067 = !DILocation(line: 493, column: 37, scope: !4048)
!4068 = !DILocation(line: 493, column: 38, scope: !4048)
!4069 = !DILocation(line: 493, column: 33, scope: !4048)
!4070 = !DILocation(line: 493, column: 27, scope: !4048)
!4071 = !DILocation(line: 493, column: 42, scope: !4048)
!4072 = !DILocation(line: 493, column: 24, scope: !4048)
!4073 = !DILocation(line: 493, column: 61, scope: !4048)
!4074 = !DILocation(line: 493, column: 62, scope: !4048)
!4075 = !DILocation(line: 493, column: 57, scope: !4048)
!4076 = !DILocation(line: 493, column: 51, scope: !4048)
!4077 = !DILocation(line: 493, column: 66, scope: !4048)
!4078 = !DILocation(line: 493, column: 48, scope: !4048)
!4079 = !DILocation(line: 493, column: 9, scope: !4048)
!4080 = !DILocation(line: 495, column: 10, scope: !408)
!4081 = !DILocation(line: 495, column: 18, scope: !408)
!4082 = !DILocation(line: 495, column: 25, scope: !408)
!4083 = !DILocation(line: 495, column: 14, scope: !408)
!4084 = !DILocation(line: 495, column: 41, scope: !408)
!4085 = !DILocation(line: 495, column: 33, scope: !408)
!4086 = !DILocation(line: 495, column: 31, scope: !408)
!4087 = !DILocation(line: 495, column: 7, scope: !408)
!4088 = !DILocation(line: 497, column: 13, scope: !408)
!4089 = !DILocation(line: 497, column: 10, scope: !408)
!4090 = !DILocation(line: 499, column: 15, scope: !408)
!4091 = !DILocation(line: 499, column: 10, scope: !408)
!4092 = !DILocation(line: 499, column: 3, scope: !408)
!4093 = !DILocation(line: 500, column: 1, scope: !408)
!4094 = distinct !DISubprogram(name: "GetDataBlock", scope: !264, file: !264, line: 391, type: !4095, scopeLine: 392, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !263, retainedNodes: !4)
!4095 = !DISubroutineType(types: !4096)
!4096 = !{!7, !272, !203}
!4097 = !DILocalVariable(name: "fd", arg: 1, scope: !4094, file: !264, line: 391, type: !272)
!4098 = !DILocation(line: 391, column: 20, scope: !4094)
!4099 = !DILocalVariable(name: "buf", arg: 2, scope: !4094, file: !264, line: 391, type: !203)
!4100 = !DILocation(line: 391, column: 39, scope: !4094)
!4101 = !DILocalVariable(name: "count", scope: !4094, file: !264, line: 393, type: !42)
!4102 = !DILocation(line: 393, column: 17, scope: !4094)
!4103 = !DILocation(line: 395, column: 9, scope: !4094)
!4104 = !DILocation(line: 396, column: 9, scope: !4105)
!4105 = distinct !DILexicalBlock(scope: !4094, file: !264, line: 396, column: 7)
!4106 = !DILocation(line: 396, column: 7, scope: !4094)
!4107 = !DILocation(line: 397, column: 13, scope: !4108)
!4108 = distinct !DILexicalBlock(scope: !4105, file: !264, line: 396, column: 32)
!4109 = !DILocation(line: 397, column: 5, scope: !4108)
!4110 = !DILocation(line: 398, column: 5, scope: !4108)
!4111 = !DILocation(line: 401, column: 19, scope: !4094)
!4112 = !DILocation(line: 401, column: 25, scope: !4094)
!4113 = !DILocation(line: 401, column: 17, scope: !4094)
!4114 = !DILocation(line: 403, column: 8, scope: !4115)
!4115 = distinct !DILexicalBlock(scope: !4094, file: !264, line: 403, column: 7)
!4116 = !DILocation(line: 403, column: 14, scope: !4115)
!4117 = !DILocation(line: 403, column: 20, scope: !4115)
!4118 = !DILocation(line: 403, column: 26, scope: !4115)
!4119 = !DILocation(line: 403, column: 7, scope: !4094)
!4120 = !DILocation(line: 404, column: 13, scope: !4121)
!4121 = distinct !DILexicalBlock(scope: !4115, file: !264, line: 403, column: 51)
!4122 = !DILocation(line: 404, column: 5, scope: !4121)
!4123 = !DILocation(line: 405, column: 5, scope: !4121)
!4124 = !DILocation(line: 408, column: 15, scope: !4094)
!4125 = !DILocation(line: 408, column: 10, scope: !4094)
!4126 = !DILocation(line: 408, column: 3, scope: !4094)
!4127 = !DILocation(line: 409, column: 1, scope: !4094)
!4128 = distinct !DISubprogram(name: "xalloc", scope: !432, file: !432, line: 14, type: !4129, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !431, retainedNodes: !4)
!4129 = !DISubroutineType(types: !4130)
!4130 = !{!15, !33}
!4131 = !DILocalVariable(name: "s", arg: 1, scope: !4128, file: !432, line: 14, type: !33)
!4132 = !DILocation(line: 14, column: 28, scope: !4128)
!4133 = !DILocalVariable(name: "p", scope: !4128, file: !432, line: 16, type: !15)
!4134 = !DILocation(line: 16, column: 9, scope: !4128)
!4135 = !DILocation(line: 16, column: 26, scope: !4128)
!4136 = !DILocation(line: 16, column: 11, scope: !4128)
!4137 = !DILocation(line: 18, column: 6, scope: !4138)
!4138 = distinct !DILexicalBlock(scope: !4128, file: !432, line: 18, column: 6)
!4139 = !DILocation(line: 18, column: 7, scope: !4138)
!4140 = !DILocation(line: 18, column: 6, scope: !4128)
!4141 = !DILocation(line: 19, column: 13, scope: !4142)
!4142 = distinct !DILexicalBlock(scope: !4138, file: !432, line: 18, column: 15)
!4143 = !DILocation(line: 19, column: 5, scope: !4142)
!4144 = !DILocation(line: 20, column: 13, scope: !4142)
!4145 = !DILocation(line: 20, column: 5, scope: !4142)
!4146 = !DILocation(line: 21, column: 5, scope: !4142)
!4147 = !DILocation(line: 24, column: 10, scope: !4128)
!4148 = !DILocation(line: 24, column: 3, scope: !4128)
!4149 = distinct !DISubprogram(name: "xrealloc", scope: !432, file: !432, line: 27, type: !4150, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !431, retainedNodes: !4)
!4150 = !DISubroutineType(types: !4151)
!4151 = !{!15, !15, !33}
!4152 = !DILocalVariable(name: "p", arg: 1, scope: !4149, file: !432, line: 27, type: !15)
!4153 = !DILocation(line: 27, column: 22, scope: !4149)
!4154 = !DILocalVariable(name: "s", arg: 2, scope: !4149, file: !432, line: 27, type: !33)
!4155 = !DILocation(line: 27, column: 39, scope: !4149)
!4156 = !DILocation(line: 29, column: 13, scope: !4149)
!4157 = !DILocation(line: 29, column: 23, scope: !4149)
!4158 = !DILocation(line: 29, column: 5, scope: !4149)
!4159 = !DILocation(line: 29, column: 4, scope: !4149)
!4160 = !DILocation(line: 31, column: 6, scope: !4161)
!4161 = distinct !DILexicalBlock(scope: !4149, file: !432, line: 31, column: 6)
!4162 = !DILocation(line: 31, column: 7, scope: !4161)
!4163 = !DILocation(line: 31, column: 6, scope: !4149)
!4164 = !DILocation(line: 32, column: 13, scope: !4165)
!4165 = distinct !DILexicalBlock(scope: !4161, file: !432, line: 31, column: 15)
!4166 = !DILocation(line: 32, column: 5, scope: !4165)
!4167 = !DILocation(line: 33, column: 13, scope: !4165)
!4168 = !DILocation(line: 33, column: 5, scope: !4165)
!4169 = !DILocation(line: 34, column: 5, scope: !4165)
!4170 = !DILocation(line: 37, column: 10, scope: !4149)
!4171 = !DILocation(line: 37, column: 3, scope: !4149)
!4172 = distinct !DISubprogram(name: "allocate_element", scope: !432, file: !432, line: 45, type: !4173, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !431, retainedNodes: !4)
!4173 = !DISubroutineType(types: !4174)
!4174 = !{null}
!4175 = !DILocalVariable(name: "new", scope: !4172, file: !432, line: 47, type: !4176)
!4176 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4177, size: 64)
!4177 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "GIFelement", file: !201, line: 32, size: 384, elements: !4178)
!4178 = !{!4179, !4180, !4181, !4182, !4183, !4184}
!4179 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !4177, file: !201, line: 33, baseType: !4176, size: 64)
!4180 = !DIDerivedType(tag: DW_TAG_member, name: "GIFtype", scope: !4177, file: !201, line: 34, baseType: !76, size: 8, offset: 64)
!4181 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !4177, file: !201, line: 35, baseType: !241, size: 64, offset: 128)
!4182 = !DIDerivedType(tag: DW_TAG_member, name: "allocated_size", scope: !4177, file: !201, line: 36, baseType: !202, size: 64, offset: 192)
!4183 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !4177, file: !201, line: 37, baseType: !202, size: 64, offset: 256)
!4184 = !DIDerivedType(tag: DW_TAG_member, name: "imagestruct", scope: !4177, file: !201, line: 39, baseType: !4185, size: 64, offset: 320)
!4185 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4186, size: 64)
!4186 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "GIFimagestruct", file: !201, line: 21, size: 22720, elements: !4187)
!4187 = !{!4188, !4197, !4198, !4199, !4200, !4201, !4202, !4203}
!4188 = !DIDerivedType(tag: DW_TAG_member, name: "colors", scope: !4186, file: !201, line: 22, baseType: !4189, size: 6144)
!4189 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4190, size: 6144, elements: !8)
!4190 = !DIDerivedType(tag: DW_TAG_typedef, name: "GifColor", file: !201, line: 19, baseType: !4191)
!4191 = !DIDerivedType(tag: DW_TAG_typedef, name: "png_color", file: !17, line: 379, baseType: !4192)
!4192 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "png_color_struct", file: !17, line: 374, size: 24, elements: !4193)
!4193 = !{!4194, !4195, !4196}
!4194 = !DIDerivedType(tag: DW_TAG_member, name: "red", scope: !4192, file: !17, line: 376, baseType: !41, size: 8)
!4195 = !DIDerivedType(tag: DW_TAG_member, name: "green", scope: !4192, file: !17, line: 377, baseType: !41, size: 8, offset: 8)
!4196 = !DIDerivedType(tag: DW_TAG_member, name: "blue", scope: !4192, file: !17, line: 378, baseType: !41, size: 8, offset: 16)
!4197 = !DIDerivedType(tag: DW_TAG_member, name: "color_count", scope: !4186, file: !201, line: 23, baseType: !252, size: 16384, offset: 6144)
!4198 = !DIDerivedType(tag: DW_TAG_member, name: "offset_x", scope: !4186, file: !201, line: 24, baseType: !7, size: 32, offset: 22528)
!4199 = !DIDerivedType(tag: DW_TAG_member, name: "offset_y", scope: !4186, file: !201, line: 25, baseType: !7, size: 32, offset: 22560)
!4200 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !4186, file: !201, line: 26, baseType: !7, size: 32, offset: 22592)
!4201 = !DIDerivedType(tag: DW_TAG_member, name: "height", scope: !4186, file: !201, line: 27, baseType: !7, size: 32, offset: 22624)
!4202 = !DIDerivedType(tag: DW_TAG_member, name: "trans", scope: !4186, file: !201, line: 28, baseType: !7, size: 32, offset: 22656)
!4203 = !DIDerivedType(tag: DW_TAG_member, name: "interlace", scope: !4186, file: !201, line: 29, baseType: !7, size: 32, offset: 22688)
!4204 = !DILocation(line: 47, column: 22, scope: !4172)
!4205 = !DILocation(line: 47, column: 26, scope: !4172)
!4206 = !DILocation(line: 49, column: 10, scope: !4172)
!4207 = !DILocation(line: 49, column: 3, scope: !4172)
!4208 = !DILocation(line: 51, column: 3, scope: !4172)
!4209 = !DILocation(line: 51, column: 8, scope: !4172)
!4210 = !DILocation(line: 51, column: 12, scope: !4172)
!4211 = !DILocation(line: 53, column: 17, scope: !4172)
!4212 = !DILocation(line: 53, column: 3, scope: !4172)
!4213 = !DILocation(line: 53, column: 12, scope: !4172)
!4214 = !DILocation(line: 53, column: 16, scope: !4172)
!4215 = !DILocation(line: 54, column: 11, scope: !4172)
!4216 = !DILocation(line: 54, column: 10, scope: !4172)
!4217 = !DILocation(line: 55, column: 1, scope: !4172)
!4218 = distinct !DISubprogram(name: "set_size", scope: !432, file: !432, line: 58, type: !4219, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !431, retainedNodes: !4)
!4219 = !DISubroutineType(types: !4220)
!4220 = !{null, !202}
!4221 = !DILocalVariable(name: "size", arg: 1, scope: !4218, file: !432, line: 58, type: !202)
!4222 = !DILocation(line: 58, column: 20, scope: !4218)
!4223 = !DILocalVariable(name: "nalloc", scope: !4218, file: !432, line: 60, type: !202)
!4224 = !DILocation(line: 60, column: 8, scope: !4218)
!4225 = !DILocation(line: 62, column: 6, scope: !4226)
!4226 = distinct !DILexicalBlock(scope: !4218, file: !432, line: 62, column: 6)
!4227 = !DILocation(line: 62, column: 15, scope: !4226)
!4228 = !DILocation(line: 62, column: 29, scope: !4226)
!4229 = !DILocation(line: 62, column: 6, scope: !4218)
!4230 = !DILocation(line: 63, column: 12, scope: !4231)
!4231 = distinct !DILexicalBlock(scope: !4226, file: !432, line: 62, column: 34)
!4232 = !DILocation(line: 63, column: 11, scope: !4231)
!4233 = !DILocation(line: 64, column: 8, scope: !4234)
!4234 = distinct !DILexicalBlock(scope: !4231, file: !432, line: 64, column: 8)
!4235 = !DILocation(line: 64, column: 14, scope: !4234)
!4236 = !DILocation(line: 64, column: 8, scope: !4231)
!4237 = !DILocation(line: 64, column: 32, scope: !4234)
!4238 = !DILocation(line: 64, column: 26, scope: !4234)
!4239 = !DILocation(line: 65, column: 26, scope: !4231)
!4240 = !DILocation(line: 65, column: 19, scope: !4231)
!4241 = !DILocation(line: 65, column: 5, scope: !4231)
!4242 = !DILocation(line: 65, column: 14, scope: !4231)
!4243 = !DILocation(line: 65, column: 18, scope: !4231)
!4244 = !DILocation(line: 66, column: 29, scope: !4231)
!4245 = !DILocation(line: 66, column: 5, scope: !4231)
!4246 = !DILocation(line: 66, column: 14, scope: !4231)
!4247 = !DILocation(line: 66, column: 28, scope: !4231)
!4248 = !DILocation(line: 67, column: 3, scope: !4231)
!4249 = !DILocation(line: 68, column: 6, scope: !4250)
!4250 = distinct !DILexicalBlock(scope: !4226, file: !432, line: 68, column: 6)
!4251 = !DILocation(line: 68, column: 15, scope: !4250)
!4252 = !DILocation(line: 68, column: 30, scope: !4250)
!4253 = !DILocation(line: 68, column: 29, scope: !4250)
!4254 = !DILocation(line: 68, column: 6, scope: !4226)
!4255 = !DILocation(line: 69, column: 12, scope: !4256)
!4256 = distinct !DILexicalBlock(scope: !4250, file: !432, line: 68, column: 36)
!4257 = !DILocation(line: 69, column: 17, scope: !4256)
!4258 = !DILocation(line: 69, column: 26, scope: !4256)
!4259 = !DILocation(line: 69, column: 16, scope: !4256)
!4260 = !DILocation(line: 69, column: 11, scope: !4256)
!4261 = !DILocation(line: 70, column: 8, scope: !4262)
!4262 = distinct !DILexicalBlock(scope: !4256, file: !432, line: 70, column: 8)
!4263 = !DILocation(line: 70, column: 14, scope: !4262)
!4264 = !DILocation(line: 70, column: 8, scope: !4256)
!4265 = !DILocation(line: 70, column: 32, scope: !4262)
!4266 = !DILocation(line: 70, column: 26, scope: !4262)
!4267 = !DILocation(line: 71, column: 28, scope: !4256)
!4268 = !DILocation(line: 71, column: 37, scope: !4256)
!4269 = !DILocation(line: 71, column: 43, scope: !4256)
!4270 = !DILocation(line: 71, column: 52, scope: !4256)
!4271 = !DILocation(line: 71, column: 67, scope: !4256)
!4272 = !DILocation(line: 71, column: 66, scope: !4256)
!4273 = !DILocation(line: 71, column: 19, scope: !4256)
!4274 = !DILocation(line: 71, column: 5, scope: !4256)
!4275 = !DILocation(line: 71, column: 14, scope: !4256)
!4276 = !DILocation(line: 71, column: 18, scope: !4256)
!4277 = !DILocation(line: 72, column: 30, scope: !4256)
!4278 = !DILocation(line: 72, column: 5, scope: !4256)
!4279 = !DILocation(line: 72, column: 14, scope: !4256)
!4280 = !DILocation(line: 72, column: 28, scope: !4256)
!4281 = !DILocation(line: 73, column: 3, scope: !4256)
!4282 = !DILocation(line: 74, column: 1, scope: !4218)
!4283 = distinct !DISubprogram(name: "store_block", scope: !432, file: !432, line: 76, type: !4284, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !431, retainedNodes: !4)
!4284 = !DISubroutineType(types: !4285)
!4285 = !{null, !75, !7}
!4286 = !DILocalVariable(name: "data", arg: 1, scope: !4283, file: !432, line: 76, type: !75)
!4287 = !DILocation(line: 76, column: 24, scope: !4283)
!4288 = !DILocalVariable(name: "size", arg: 2, scope: !4283, file: !432, line: 76, type: !7)
!4289 = !DILocation(line: 76, column: 34, scope: !4283)
!4290 = !DILocation(line: 78, column: 12, scope: !4283)
!4291 = !DILocation(line: 78, column: 21, scope: !4283)
!4292 = !DILocation(line: 78, column: 26, scope: !4283)
!4293 = !DILocation(line: 78, column: 25, scope: !4283)
!4294 = !DILocation(line: 78, column: 3, scope: !4283)
!4295 = !DILocation(line: 79, column: 10, scope: !4283)
!4296 = !DILocation(line: 79, column: 19, scope: !4283)
!4297 = !DILocation(line: 79, column: 24, scope: !4283)
!4298 = !DILocation(line: 79, column: 33, scope: !4283)
!4299 = !DILocation(line: 79, column: 23, scope: !4283)
!4300 = !DILocation(line: 79, column: 39, scope: !4283)
!4301 = !DILocation(line: 79, column: 45, scope: !4283)
!4302 = !DILocation(line: 79, column: 3, scope: !4283)
!4303 = !DILocation(line: 80, column: 18, scope: !4283)
!4304 = !DILocation(line: 80, column: 3, scope: !4283)
!4305 = !DILocation(line: 80, column: 12, scope: !4283)
!4306 = !DILocation(line: 80, column: 16, scope: !4283)
!4307 = !DILocation(line: 81, column: 1, scope: !4283)
!4308 = distinct !DISubprogram(name: "allocate_image", scope: !432, file: !432, line: 83, type: !4173, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !431, retainedNodes: !4)
!4309 = !DILocation(line: 85, column: 3, scope: !4308)
!4310 = !DILocation(line: 86, column: 3, scope: !4308)
!4311 = !DILocation(line: 86, column: 12, scope: !4308)
!4312 = !DILocation(line: 86, column: 19, scope: !4308)
!4313 = !DILocation(line: 87, column: 24, scope: !4308)
!4314 = !DILocation(line: 87, column: 3, scope: !4308)
!4315 = !DILocation(line: 87, column: 12, scope: !4308)
!4316 = !DILocation(line: 87, column: 23, scope: !4308)
!4317 = !DILocation(line: 88, column: 10, scope: !4308)
!4318 = !DILocation(line: 88, column: 19, scope: !4308)
!4319 = !DILocation(line: 88, column: 3, scope: !4308)
!4320 = !DILocation(line: 89, column: 1, scope: !4308)
!4321 = distinct !DISubprogram(name: "fix_current", scope: !432, file: !432, line: 91, type: !4173, scopeLine: 92, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !431, retainedNodes: !4)
!4322 = !DILocation(line: 93, column: 6, scope: !4323)
!4323 = distinct !DILexicalBlock(scope: !4321, file: !432, line: 93, column: 6)
!4324 = !DILocation(line: 93, column: 15, scope: !4323)
!4325 = !DILocation(line: 93, column: 31, scope: !4323)
!4326 = !DILocation(line: 93, column: 40, scope: !4323)
!4327 = !DILocation(line: 93, column: 29, scope: !4323)
!4328 = !DILocation(line: 93, column: 6, scope: !4321)
!4329 = !DILocation(line: 94, column: 28, scope: !4330)
!4330 = distinct !DILexicalBlock(scope: !4323, file: !432, line: 93, column: 46)
!4331 = !DILocation(line: 94, column: 37, scope: !4330)
!4332 = !DILocation(line: 94, column: 43, scope: !4330)
!4333 = !DILocation(line: 94, column: 52, scope: !4330)
!4334 = !DILocation(line: 94, column: 19, scope: !4330)
!4335 = !DILocation(line: 94, column: 5, scope: !4330)
!4336 = !DILocation(line: 94, column: 14, scope: !4330)
!4337 = !DILocation(line: 94, column: 18, scope: !4330)
!4338 = !DILocation(line: 95, column: 29, scope: !4330)
!4339 = !DILocation(line: 95, column: 38, scope: !4330)
!4340 = !DILocation(line: 95, column: 5, scope: !4330)
!4341 = !DILocation(line: 95, column: 14, scope: !4330)
!4342 = !DILocation(line: 95, column: 28, scope: !4330)
!4343 = !DILocation(line: 96, column: 3, scope: !4330)
!4344 = !DILocation(line: 97, column: 1, scope: !4321)
!4345 = distinct !DISubprogram(name: "free_mem", scope: !432, file: !432, line: 99, type: !4173, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !431, retainedNodes: !4)
!4346 = !DILocalVariable(name: "p", scope: !4345, file: !432, line: 101, type: !4176)
!4347 = !DILocation(line: 101, column: 22, scope: !4345)
!4348 = !DILocalVariable(name: "t", scope: !4345, file: !432, line: 101, type: !4176)
!4349 = !DILocation(line: 101, column: 25, scope: !4345)
!4350 = !DILocation(line: 103, column: 11, scope: !4345)
!4351 = !DILocation(line: 103, column: 4, scope: !4345)
!4352 = !DILocation(line: 104, column: 13, scope: !4345)
!4353 = !DILocation(line: 106, column: 3, scope: !4345)
!4354 = !DILocation(line: 106, column: 9, scope: !4345)
!4355 = !DILocation(line: 107, column: 7, scope: !4356)
!4356 = distinct !DILexicalBlock(scope: !4345, file: !432, line: 106, column: 12)
!4357 = !DILocation(line: 107, column: 6, scope: !4356)
!4358 = !DILocation(line: 108, column: 7, scope: !4356)
!4359 = !DILocation(line: 108, column: 10, scope: !4356)
!4360 = !DILocation(line: 108, column: 6, scope: !4356)
!4361 = !DILocation(line: 109, column: 8, scope: !4362)
!4362 = distinct !DILexicalBlock(scope: !4356, file: !432, line: 109, column: 8)
!4363 = !DILocation(line: 109, column: 11, scope: !4362)
!4364 = !DILocation(line: 109, column: 8, scope: !4356)
!4365 = !DILocation(line: 109, column: 22, scope: !4362)
!4366 = !DILocation(line: 109, column: 25, scope: !4362)
!4367 = !DILocation(line: 109, column: 17, scope: !4362)
!4368 = !DILocation(line: 110, column: 8, scope: !4369)
!4369 = distinct !DILexicalBlock(scope: !4356, file: !432, line: 110, column: 8)
!4370 = !DILocation(line: 110, column: 11, scope: !4369)
!4371 = !DILocation(line: 110, column: 8, scope: !4356)
!4372 = !DILocation(line: 110, column: 29, scope: !4369)
!4373 = !DILocation(line: 110, column: 32, scope: !4369)
!4374 = !DILocation(line: 110, column: 24, scope: !4369)
!4375 = !DILocation(line: 111, column: 10, scope: !4356)
!4376 = !DILocation(line: 111, column: 5, scope: !4356)
!4377 = distinct !{!4377, !4353, !4378}
!4378 = !DILocation(line: 112, column: 3, scope: !4345)
!4379 = !DILocation(line: 113, column: 1, scope: !4345)
