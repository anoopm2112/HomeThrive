import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';

class NotificationSettingsRow extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool) onToggle;

  const NotificationSettingsRow({
    Key key,
    @required this.title,
    @required this.value,
    @required this.onToggle,
  })  : assert(title != null),
        assert(value != null),
        assert(onToggle != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFD8D8D8), // TODO
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              this.title,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: getResponsiveSmallFontSize(context),
                  ),
            ),
          ),
          FlutterSwitch(
            value: this.value,
            width: 50,
            height: 30,
            toggleSize: 28,
            padding: 1.5,
            activeColor: Color(0xFF1D334B),
            onToggle: this.onToggle,
          ),
        ],
      ),
    );
  }
}
