import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.mobileBuilder,
    required this.tabletBuilder,
    super.key,
  });

  final Widget Function(BuildContext context, BoxConstraints constraints)?
  mobileBuilder;

  final Widget Function(BuildContext context, BoxConstraints constraints)?
  tabletBuilder;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1250 &&
      MediaQuery.of(context).size.width >= 650;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 650) {
          return tabletBuilder!(context, constraints);
        } else {
          return mobileBuilder!(context, constraints);
        }
      },
    );
  }
}
