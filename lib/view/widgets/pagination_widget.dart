import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final bool hasReachedMax;
  const PaginationWidget({super.key, required this.hasReachedMax});

  @override
  Widget build(BuildContext context) {
    if (hasReachedMax) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return const SizedBox.shrink();
  }
}
