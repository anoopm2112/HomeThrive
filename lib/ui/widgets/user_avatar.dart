import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final ImageProvider<Object> image;
  final double radius;
  final Color backgroundColor;

  const UserAvatar({
    Key key,
    @required this.image,
    this.radius = 15,
    this.backgroundColor,
  })  : assert(image != null),
        assert(radius != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    final Color color = this.backgroundColor ?? Theme.of(context).primaryColor;

    return Container(
      decoration: ShapeDecoration(
        color: color,
        shape: CircleBorder(
          side: BorderSide(
            width: 2,
            color: color,
          ),
        ),
      ),
      child: CircleAvatar(
        backgroundImage: this.image,
        backgroundColor: color,
        radius: this.radius,
      ),
    );
  }
}
