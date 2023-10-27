part of onboarding;

class _OnboardingContent extends StatelessWidget {
  final Widget top;
  final Widget bottom;

  const _OnboardingContent({
    Key key,
    this.top = const SizedBox(),
    this.bottom = const SizedBox(),
  })  : assert(top != null),
        assert(bottom != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: this.top,
        ),
        Flexible(
          child: this.bottom,
        ),
      ],
    );
  }
}
