import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final EdgeInsetsGeometry margin;
  final ShapeBorder shape;

  AppListTile({
    @required this.title,
    this.subtitle = "",
    this.onTap,
    this.margin,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Card(
        margin: margin ?? EdgeInsets.only(bottom: 1),
        shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            top: 20,
            right: 20,
            bottom: 20,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
