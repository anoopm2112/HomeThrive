import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

class SlidingSwitch extends StatefulWidget {
  final double height;
  final ValueChanged<bool> onChanged;
  final double width;
  final bool value;
  final String textOff;
  final String textOn;
  final Duration animationDuration;
  final Color colorOn;
  final Color colorOff;
  final Color backgroundColor;
  final Color buttonColor;
  final Color inactiveColor;
  final Function onTap;
  final Function onDoubleTap;
  final Function onSwipe;

  const SlidingSwitch({
    this.value,
    @required this.onChanged,
    this.height = 55,
    this.width = 250,
    this.animationDuration = const Duration(milliseconds: 400),
    this.onTap,
    this.onDoubleTap,
    this.onSwipe,
    this.textOff,
    this.textOn,
    this.colorOn = const Color(0xFF1E2429),
    this.colorOff = const Color(0xFF1E2429),
    this.backgroundColor = const Color(0xFFDBE2E7),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.inactiveColor = const Color(0xFF1E2429),
  });

  @override
  _SlidingSwitch createState() => _SlidingSwitch();
}

class _SlidingSwitch extends State<SlidingSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  double _value = 0.0;

  bool turnState;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: widget.animationDuration,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.addListener(() {
      setState(() {
        _value = _animation.value;
      });
    });
    turnState = widget.value;
    _determine();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(6.93),
      ),
      padding: const EdgeInsets.all(2),
      child: Stack(
        // clipBehavior: Clip.none,
        children: <Widget>[
          if (this.widget.value != null)
            LayoutBuilder(
              builder: (context, contraints) => Transform.translate(
                offset: Offset(
                  ((contraints.maxWidth * 0.5) * _value),
                  0,
                ),
                child: Container(
                  height: widget.height,
                  width: contraints.maxWidth * .5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.93),
                    color: widget.buttonColor,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000).withOpacity(0.12),
                        offset: Offset(0, 3),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Color(0xFF000000).withOpacity(0.04),
                        offset: Offset(0, 3),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _determine(
                      changeState: true,
                      newTurnState: false,
                    );
                  },
                  // onDoubleTap: () {
                  //   _action();
                  //   if (widget.onDoubleTap != null) widget.onDoubleTap();
                  // },
                  // onTap: () {
                  //   _action();
                  //   if (widget.onTap != null) widget.onTap();
                  // },
                  onPanEnd: (details) {
                    // TODO
                    _determine(
                      changeState: true,
                      newTurnState: false,
                    );
                    if (widget.onSwipe != null) widget.onSwipe();
                  },
                  child: Center(
                    child: Text(
                      widget.textOff ?? localization.events,
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1E2429),
                        // color:
                        //     turnState ? widget.inactiveColor : widget.colorOff,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                width: 0,
                thickness: 1,
                indent: 8,
                endIndent: 8,
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _determine(
                      changeState: true,
                      newTurnState: true,
                    );
                  },
                  child: Center(
                    child: Text(
                      widget.textOn ?? localization.activity,
                      style: TextStyle(
                        color: Color(0xFF1E2429),
                        // color:
                        //     turnState ? widget.colorOn : widget.inactiveColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _action() {
    _determine(changeState: true);
  }

  _determine({bool changeState = false, bool newTurnState}) {
    setState(
      () {
        if (turnState == null)
          turnState = newTurnState;
        else if (changeState) turnState = !turnState;
      },
    );
    if (turnState != null)
      (turnState)
          ? _animationController.forward()
          : _animationController.reverse();
    if (changeState) widget.onChanged(turnState);
  }
}
