import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class CustomError extends StatelessWidget {
  final String title;
  final String description;

  const CustomError(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TDResult(
          theme: TDResultTheme.error,
          title: title,
          description: description,
        ),
      ),
    );
  }
}
