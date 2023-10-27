import 'package:flutter/widgets.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/circle_painter.dart';
import 'package:fostershare/ui/widgets/user_avatar.dart';

class PersonRow extends StatelessWidget {
  final ImageProvider<Object> image;
  final String name;
  final String description;
  final Color indexColor;

  const PersonRow({
    Key key,
    @required this.image,
    @required this.name,
    @required this.description,
    this.indexColor,
  })  : assert(image != null),
        assert(name != null),
        assert(description != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      // TODO
      children: [
        CustomPaint(
          painter: CirclePainter(
            color: this.indexColor ?? Color(0x999AC7DD), // TODO theme color
            radius: 7,
            offset: Offset(5, 0),
          ),
        ),
        SizedBox(width: 22),
        // UserAvatar(
        //   image: this.image,
        // ),
        //SizedBox(width: 16),
        Expanded(
          child: CardTextColumn(
            title: this.name,
            description: this.description,
            verticalSpace: 2,
          ),
        ),
        // if (!select)
        //   Text(
        //     _childLogStatusToText(), // TODO
        //     style: Theme.of(context).textTheme.bodyText2.copyWith(
        //           fontSize: 12,
        //           color: complete
        //               ? Color(0xFF8ABAD3)
        //               : missing
        //                   ? Color(0xFFE75365)
        //                   : Color(0xFFE47837),
        //         ),
        //   ),
        SizedBox(width: 8),

        Icon(
          AppIcons.chevronRight, // TODO
          color: Color(0xFFE47837),
        ),
      ],
    );
  }
}
