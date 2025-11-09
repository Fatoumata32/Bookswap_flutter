// Reusable loading spinner widget

import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final Color? color;
  
  const LoadingSpinner({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}