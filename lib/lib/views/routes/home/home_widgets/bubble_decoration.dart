import 'package:flutter/material.dart';

class BubbleDecoration extends Decoration  {

  final Color bubbleColor = Colors.lightGreen.withOpacity(0.7);

  @override
  BubblePainter createBoxPainter([VoidCallback onChanged]){
    return new BubblePainter(this, onChanged);
  }
}

class BubblePainter extends BoxPainter {

   BubblePainter(this.decoration, VoidCallback onChanged): assert(decoration != null), super(onChanged);

   final BubbleDecoration decoration;



   @override 
   void paint(Canvas canvas, Offset offset, ImageConfiguration imageConfiguration){
     assert(imageConfiguration != null);
     assert(imageConfiguration.size != null);
     final Paint paint = Paint();
     final Path path = Path();
     path.addPolygon([
      Offset(offset.dx + 26.0, offset.dy + (imageConfiguration.size.height -6.0)),
      Offset(offset.dx + 31.0, offset.dy + (imageConfiguration.size.height)),
      Offset(offset.dx + 36.0, offset.dy + (imageConfiguration.size.height -6.0)),
     ], true);
     final Rect rect = offset & Size(imageConfiguration.size.width, imageConfiguration.size.height - 6.0);
     paint.color = decoration.bubbleColor;
     paint.style = PaintingStyle.fill;
     // canvas.drawPath(path, paint);
     canvas.drawRect(rect, paint);
     canvas.drawPath(path,paint);
   }

}
