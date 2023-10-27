import 'package:flutter/widgets.dart';

class SelectableButton<T> extends StatelessWidget {
  final bool selected;
  final Widget child;
  final T value;
  final void Function(T value) onSelected;
  final double width;
  final double height;

  const SelectableButton({
    Key key,
    this.selected = false,
    @required this.child,
    this.value,
    this.onSelected,
    this.width,
    this.height,
  })  : assert(selected != null),
        assert(child != null),
        super(key: key);

  factory SelectableButton.withLabel({
    Key key,
    bool selected,
    @required String label,
    T value,
    void Function(T value) onSelected,
  }) = _SelectableButtonWithLabel;

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decoration = this.selected
        ? BoxDecoration(
            color: Color(0xFF1D334B).withOpacity(.20),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Color(0xFFF37123),
              width: 2,
            ),
          )
        : BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Color(0xFFE6E6E6),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000).withOpacity(.15),
                offset: Offset(0, 2),
                blurRadius: 5,
              ),
            ],
          );
    return GestureDetector(
      onTap: () => this.onSelected?.call(value),
      child: Container(
        width: this.width,
        height: this.height,
        decoration: decoration,
        child: this.child,
      ),
    );
  }
}

class _SelectableButtonWithLabel<T> extends SelectableButton<T> {
  _SelectableButtonWithLabel({
    Key key,
    bool selected = false,
    @required String label,
    T value,
    void Function(T value) onSelected,
  })  : assert(selected != null),
        assert(label != null),
        super(
          key: key,
          selected: selected,
          child: Center(
            child: Text(label),
          ),
          value: value,
          onSelected: onSelected,
          width: 60,
          height: 60, // TODO dynamic
        );
}
