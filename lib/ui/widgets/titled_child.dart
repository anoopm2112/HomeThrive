import 'package:flutter/widgets.dart';

class TitledChild extends StatelessWidget {
  final String title;
  final Widget child;

  const TitledChild({
    Key key,
    @required this.title,
    @required this.child,
  })  : assert(title != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.title,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF57636C),
            fontWeight: FontWeight.w600, // TODO character?
            height: 1.143,
          ), // TODO add to styles and theme
        ),
        SizedBox(height: 10),
        this.child,
      ],
    );
  }
}
