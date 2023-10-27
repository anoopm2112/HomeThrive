import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/components/view_bar/view_bar_model.dart';
import 'package:stacked/stacked.dart';

class ViewBar extends StatelessWidget {
  final String title;
  final Widget trailing;
  final bool notificationButton;

  const ViewBar({
    Key key,
    @required this.title,
    this.trailing,
    this.notificationButton = false,
  })  : assert(title != null),
        assert(notificationButton != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewBarModel>.reactive(
      viewModelBuilder: () => ViewBarModel(),
      builder: (context, model, child) => Padding(
        padding: defaultViewPaddingHorizontal,
        child: Row(
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
            if (this.trailing != null) this.trailing,
            if (model.isSignedIn)
              GestureDetector(
                onTap: model.onAlerts,
                child: Icon(
                  AppIcons.bell,
                  color: Color(0xFF95A1AC), // TODO theme
                ),
              ),
          ],
        ),
      ),
    );
  }
}
