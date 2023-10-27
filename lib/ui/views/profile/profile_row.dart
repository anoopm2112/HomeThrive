import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/ui_utils.dart';

class ProfileRow extends StatelessWidget {
  final void Function() onTap;
  final String label;

  const ProfileRow({
    Key key,
    this.onTap,
    @required this.label,
  })  : assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFD8D8D8), // TODO
            ),
          ),
        ),
        child: Padding(
          padding: defaultViewChildPaddingHorizontal,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  this.label,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: getResponsiveSmallFontSize(context),
                      ),
                ),
              ),
              Icon(
                AppIcons.chevronRight,
                color: Color(0xFF95A1AC),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
