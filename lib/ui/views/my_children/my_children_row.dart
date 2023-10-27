import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/svg_asset_images.dart';
import 'package:fostershare/ui/common/ui_utils.dart';

class MyChildrenRow extends StatelessWidget {
  final String label;
  final String info;
  final bool edit;
  final void Function() editTap;

  const MyChildrenRow({
    Key key,
    @required this.label,
    @required this.info,
    this.edit = false,
    this.editTap,
  })  : assert(label != null),
        assert(info != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: defaultViewChildPaddingHorizontal,
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
            flex: 24,
            child: Text(
              this.label.trim(),
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: getResponsiveSmallFontSize(context),
                  ),
            ),
          ),
          Expanded(
            flex: this.edit ? 45 : 50,
            child: Text(this.info.trim()),
          ),
          if (this.edit)
            Expanded(
              flex: 5,
              child: GestureDetector(onTap: editTap, child: Icon(Icons.edit)),
            ),
        ],
      ),
    );
  }
}
