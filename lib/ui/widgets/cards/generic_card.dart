import 'package:flutter/material.dart';

class GenericCard extends StatelessWidget {
  Widget child;
  VoidCallback onTap;
  Color color;
  EdgeInsets padding;

  GenericCard({@required this.child, this.onTap, this.color, this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        child: Padding(
          padding: padding ?? EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
