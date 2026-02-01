import 'package:flutter/material.dart';

class FrontDeskHeaderBar extends StatelessWidget {
  const FrontDeskHeaderBar({super.key, required this.onDailySales});

  final VoidCallback onDailySales;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dateText =
        "${_weekday(now.weekday)}, ${_month(now.month)} ${now.day}, ${now.year}";

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Front Desk Hotel Floor Plan Interface",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Hotel Floor Plan Management",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 18,
                color: Colors.black54,
              ),
              const SizedBox(width: 8),
              Text(
                dateText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 14),

              ElevatedButton.icon(
                onPressed: onDailySales,
                icon: const Icon(
                  Icons.attach_money,
                  size: 18,
                  color: Colors.white,
                ),
                label: const Text(
                  "Daily Sales",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _weekday(int w) => const [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ][w - 1];

  static String _month(int m) => const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ][m - 1];
}
