import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/ui_utils.dart';

class GeneralViewBar extends StatelessWidget {
  final String title;
  final IconData iconData;

  const GeneralViewBar({
    Key key,
    @required this.title,
    this.iconData,
  })  : assert(title != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            this.title,
            style: Theme.of(context).textTheme.headline1.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: getResponsiveLargeFontSize(context),
                ),
          ),
        ),
        if (iconData != null)
          GestureDetector(
            // TODO handle implicitly
            child: Icon(
              this.iconData,
              size: 32, // TODO
              color: Color(0xFF95A1AC), // TODO theme
            ),
          ),
      ],
    );
  }
}
