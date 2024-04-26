
import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree
// CustomPaint(
//     size: Size(WIDTH, (WIDTH*1.9854598921744813).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
//     painter: RPSCustomPainter(),
// )

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
            
Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Color(0xff384a53).withOpacity(1.0);
canvas.drawRect(Rect.fromLTWH(0,0,size.width,size.height),paint_0_fill);

Path path_1 = Path();
    path_1.moveTo(size.width*0.9343789,size.height*0.1129488);
    path_1.lineTo(size.width*0.06562109,size.height*0.1129488);
    path_1.lineTo(size.width*0.06562109,size.height*0.8386681);
    path_1.lineTo(size.width*0.06562109,size.height*0.8386681);
    path_1.lineTo(size.width*0.06562109,size.height*0.9018624);
    path_1.cubicTo(size.width*0.06589337,size.height*0.9014235,size.width*0.06616566,size.height*0.9009572,size.width*0.06643795,size.height*0.9005184);
    path_1.cubicTo(size.width*0.07188368,size.height*0.9024658,size.width*0.07809182,size.height*0.9040566,size.width*0.08272069,size.height*0.9063606);
    path_1.cubicTo(size.width*0.09208735,size.height*0.9109959,size.width*0.1000926,size.height*0.9108039,size.width*0.1092414,size.height*0.9062234);
    path_1.cubicTo(size.width*0.1280836,size.height*0.8967882,size.width*0.1310243,size.height*0.8967333,size.width*0.1495943,size.height*0.9061137);
    path_1.cubicTo(size.width*0.1595600,size.height*0.9111605,size.width*0.1677830,size.height*0.9106119,size.width*0.1772042,size.height*0.9058120);
    path_1.cubicTo(size.width*0.1943582,size.height*0.8968979,size.width*0.1995861,size.height*0.8969253,size.width*0.2163045,size.height*0.9058669);
    path_1.cubicTo(size.width*0.2250177,size.height*0.9105296,size.width*0.2330229,size.height*0.9110508,size.width*0.2427163,size.height*0.9066074);
    path_1.cubicTo(size.width*0.2645537,size.height*0.8966510,size.width*0.2650438,size.height*0.8966510,size.width*0.2855743,size.height*0.9066623);
    path_1.cubicTo(size.width*0.2947231,size.height*0.9111331,size.width*0.3024560,size.height*0.9101456,size.width*0.3109514,size.height*0.9062783);
    path_1.cubicTo(size.width*0.3311006,size.height*0.8970076,size.width*0.3334967,size.height*0.8968979,size.width*0.3515765,size.height*0.9060863);
    path_1.cubicTo(size.width*0.3613789,size.height*0.9110782,size.width*0.3698197,size.height*0.9106942,size.width*0.3792409,size.height*0.9059766);
    path_1.cubicTo(size.width*0.3976474,size.height*0.8968156,size.width*0.4005881,size.height*0.8968156,size.width*0.4194304,size.height*0.9063331);
    path_1.cubicTo(size.width*0.4288515,size.height*0.9110233,size.width*0.4369112,size.height*0.9105845,size.width*0.4458422,size.height*0.9060040);
    path_1.cubicTo(size.width*0.4638676,size.height*0.8967882,size.width*0.4688776,size.height*0.8968156,size.width*0.4863040,size.height*0.9058394);
    path_1.cubicTo(size.width*0.4970321,size.height*0.9114073,size.width*0.5034036,size.height*0.9112976,size.width*0.5145673,size.height*0.9053183);
    path_1.cubicTo(size.width*0.5296520,size.height*0.8973093,size.width*0.5362958,size.height*0.8972545,size.width*0.5519251,size.height*0.9048795);
    path_1.cubicTo(size.width*0.5652671,size.height*0.9114073,size.width*0.5702227,size.height*0.9114348,size.width*0.5825845,size.height*0.9049343);
    path_1.cubicTo(size.width*0.5970157,size.height*0.8973916,size.width*0.6045309,size.height*0.8973093,size.width*0.6187442,size.height*0.9047423);
    path_1.cubicTo(size.width*0.6317595,size.height*0.9115719,size.width*0.6371508,size.height*0.9115719,size.width*0.6506562,size.height*0.9047423);
    path_1.cubicTo(size.width*0.6650329,size.height*0.8974190,size.width*0.6718946,size.height*0.8975013,size.width*0.6868703,size.height*0.9051263);
    path_1.cubicTo(size.width*0.6995044,size.height*0.9115445,size.width*0.7046779,size.height*0.9114896,size.width*0.7175298,size.height*0.9048795);
    path_1.cubicTo(size.width*0.7319610,size.height*0.8974190,size.width*0.7386048,size.height*0.8974190,size.width*0.7539073,size.height*0.9048795);
    path_1.cubicTo(size.width*0.7679573,size.height*0.9115993,size.width*0.7726406,size.height*0.9115993,size.width*0.7857649,size.height*0.9045503);
    path_1.cubicTo(size.width*0.7989980,size.height*0.8974739,size.width*0.8067309,size.height*0.8975287,size.width*0.8205086,size.height*0.9047423);
    path_1.cubicTo(size.width*0.8338507,size.height*0.9115993,size.width*0.8391875,size.height*0.9116268,size.width*0.8524751,size.height*0.9048795);
    path_1.cubicTo(size.width*0.8672330,size.height*0.8974190,size.width*0.8741491,size.height*0.8974464,size.width*0.8886892,size.height*0.9050715);
    path_1.cubicTo(size.width*0.9012689,size.height*0.9116268,size.width*0.9066057,size.height*0.9115170,size.width*0.9193487,size.height*0.9051263);
    path_1.cubicTo(size.width*0.9232696,size.height*0.9032063,size.width*0.9287154,size.height*0.9020544,size.width*0.9335076,size.height*0.9005732);
    path_1.cubicTo(size.width*0.9337799,size.height*0.9009572,size.width*0.9340522,size.height*0.9013412,size.width*0.9343245,size.height*0.9017252);
    path_1.lineTo(size.width*0.9343245,size.height*0.8387504);
    path_1.lineTo(size.width*0.9343245,size.height*0.8387504);
    path_1.lineTo(size.width*0.9343245,size.height*0.1129488);
    path_1.close();

Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
paint_1_fill.color = Color(0xfff1f2f2).withOpacity(1.0);
canvas.drawPath(path_1,paint_1_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
}
}