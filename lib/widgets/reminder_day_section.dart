import 'package:flutter/material.dart';
import 'package:dayflow/models/reminder_model.dart';
import 'package:dayflow/widgets/custom_card.dart';
import 'package:dayflow/widgets/reminder_item.dart';

class ReminderDaySection extends StatelessWidget {
  final String day;
  final List<ReminderModel> reminders;

  const ReminderDaySection({
    super.key,
    required this.day,
    required this.reminders,
  });

  @override
  Widget build(BuildContext context) {
    if (reminders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context),
        const SizedBox(height: 8),
        _buildRemindersList(),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        day,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildRemindersList() {
    return CustomCard(
      child: Column(
        children: List.generate(
          reminders.length,
          (index) {
            final reminder = reminders[index];
            return Column(
              children: [
                if (index > 0) const Divider(height: 1),
                ReminderItem(reminder: reminder),
              ],
            );
          },
        ),
      ),
    );
  }
}