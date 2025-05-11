import 'package:flutter/material.dart';

class BottomLoaderWidget extends StatelessWidget {
  const BottomLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}