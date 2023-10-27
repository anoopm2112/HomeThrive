import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/ui_utils.dart';

class HorizontalButtonsListView extends StatelessWidget {
  final double height;
  final int itemCount;
  final List<String> labels;
  final int selectedLabelIndex;
  final void Function(int index) onPressed;

  const HorizontalButtonsListView({
    Key key,
    this.height = 50,
    @required this.itemCount,
    @required this.labels,
    this.selectedLabelIndex,
    this.onPressed,
  })  : assert(height != null),
        assert(itemCount != null && itemCount >= 0),
        assert(labels != null && labels.length == itemCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 50, // TODO look into
      // height: screenHeighPercentage(
      //   context,
      //   percentage:,
      // ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: this.itemCount,
        padding: defaultViewPaddingHorizontal,
        separatorBuilder: (context, _) => SizedBox(width: 10),
        itemBuilder: (context, index) {
          final bool isSelected = selectedLabelIndex == index;
          return isSelected
              ? ElevatedButton(
                  onPressed: () => this.onPressed?.call(index),
                  child: Text(
                    this.labels[index],
                    style: textTheme.button,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF1D334B), // TODO
                  ),
                )
              : OutlinedButton(
                  onPressed: () => this.onPressed?.call(index),
                  child: Text(
                    this.labels[index],
                    style: textTheme.button.copyWith(
                      color: Color(0xFF95A1AC),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Color(0xFFF1F4F8),
                    side: BorderSide(
                      color: Color(0xFFE6E6E6), // TODO
                    ),
                  ),
                );
        },
      ),
    );
  }
}
