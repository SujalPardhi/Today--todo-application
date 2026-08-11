import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt_rounded,
              size: 64,
              color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).textTheme.headlineMedium?.color,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a task to get started.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
