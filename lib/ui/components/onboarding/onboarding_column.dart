part of onboarding;

class _OnboardingColumn extends StatelessWidget {
  final Widget start;
  final Widget middle;
  final Widget child;
  final Widget end;

  const _OnboardingColumn({
    Key key,
    this.start = const SizedBox(),
    this.middle = const SizedBox(),
    this.child = const SizedBox(),
    this.end = const SizedBox(),
  })  : assert(start != null),
        assert(middle != null),
        assert(end != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 345,
          child: this.start,
        ),
        Expanded(
          flex: 6,
          child: this.middle,
        ),
        SizedBox(height: 16),
        Expanded(
          flex: 250,
          child: _OnboardingContent(
            top: this.child,
            bottom: end,
          ),
        ),
      ],
    );
  }
}
