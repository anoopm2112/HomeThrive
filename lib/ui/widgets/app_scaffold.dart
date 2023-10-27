import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;

  const AppScaffold({
    Key key,
    @required this.body,
  })  : assert(body != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F4F8), // TODO add to colors/ theme
      body: SafeArea(
        child: this.body,
      ),
    );
  }
}
