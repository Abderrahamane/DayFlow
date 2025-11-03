import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add reminder dialog
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add Reminder Comming Soon!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  // TODO: Add reminder form
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDaySection(context, 'Today'),
          const SizedBox(height: 16),
          _buildDaySection(context, 'Tomorrow'),
        ],
      ),
    );
  }

  Widget _buildDaySection(BuildContext context, String day) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            day,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        CustomCard(
          child: Column(
            children: [
              if (day == 'Today') ...[
                _buildReminderItem(
                  context,
                  '10:00',
                  'AM',
                  'Meeting with Alex',
                  'Project detail and discussion',
                ),
                const Divider(),
                _buildReminderItem(
                  context,
                  '12:00',
                  'PM',
                  'Lunch with Sarah',
                  'Catch up at The Corner Cafe',
                ),
              ],
              if (day == 'Tomorrow')
                _buildReminderItem(
                  context,
                  '2:00',
                  'PM',
                  'Project Review',
                  'Final checks before launch',
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReminderItem(BuildContext context, String time, String period,
      String title, String description) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                period,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              // TODO: Implement reminder notification toggle
            },
          ),
        ],
      ),
    );
  }
}
