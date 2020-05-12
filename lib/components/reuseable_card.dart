import 'package:flutter/material.dart';

class ReuseableCard extends StatelessWidget {
  ReuseableCard({
    @required this.color,
    this.cardChild,
    this.onPressed,
    this.onLongPressed,
    this.height,
    this.padding,
    this.margin,
  });
  final Color color;
  final Widget cardChild;
  final Function onPressed;
  final Function onLongPressed;
  double height;
  EdgeInsets padding;
  EdgeInsets margin;
  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: double.infinity,
      child: MaterialButton(
        onLongPress: onLongPressed,
        onPressed: onPressed,
        child: cardChild,
      ),
      margin: margin ?? EdgeInsets.fromLTRB(40, 20, 40, 25),
      padding: padding ?? EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
