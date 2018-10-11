import 'package:flutter/material.dart';


class CustomIconButton extends StatelessWidget {

  final Function tapCallBack;
  final IconData iconData;
  final Color buttonColor;

  static const _customContainerDimensions = 36.0;
  static const _customIconSize = 16.0;
  static const _customOpacity = 0.7;

  const CustomIconButton(this.tapCallBack,{Key key,@required this.iconData,this.buttonColor}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: _customContainerDimensions,
      height: _customContainerDimensions,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: buttonColor,
      ),
      child:  InkWell(
        splashColor: Colors.white.withOpacity(_customOpacity),
        highlightColor: Colors.white.withOpacity(_customOpacity),
        onTap: tapCallBack,
        child: Center(
          child: Icon(
            iconData,
            size:_customIconSize,
          ),
        ),
      ),
    );
  }


}