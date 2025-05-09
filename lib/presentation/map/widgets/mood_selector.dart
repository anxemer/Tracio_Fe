import 'package:flutter/material.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';

enum RouteMood {
  none,
  happy,
  excited,
  relaxed,
  tired,
  challenging,
  adventurous,
  angry,
  sad,
  nervous,
  focused,
}

class MoodSelector extends StatefulWidget {
  final ValueChanged<RouteMood>? onChanged;

  const MoodSelector({super.key, this.onChanged});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  RouteMood _selectedMood = RouteMood.none;

  final Map<RouteMood, IconData> moodIcons = {
    RouteMood.happy: Icons.sentiment_satisfied_alt,
    RouteMood.excited: Icons.emoji_emotions,
    RouteMood.relaxed: Icons.spa,
    RouteMood.tired: Icons.bedtime,
    RouteMood.challenging: Icons.fitness_center,
    RouteMood.adventurous: Icons.explore,
    RouteMood.angry: Icons.sentiment_very_dissatisfied,
    RouteMood.sad: Icons.sentiment_dissatisfied,
    RouteMood.nervous: Icons.warning_amber,
    RouteMood.focused: Icons.track_changes,
  };

  final Map<RouteMood, String> moodLabels = {
    RouteMood.happy: "Happy",
    RouteMood.excited: "Excited",
    RouteMood.relaxed: "Relaxed",
    RouteMood.tired: "Tired",
    RouteMood.challenging: "Challenging",
    RouteMood.adventurous: "Adventurous",
    RouteMood.angry: "Angry",
    RouteMood.sad: "Sad",
    RouteMood.nervous: "Nervous",
    RouteMood.focused: "Focused",
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: moodIcons.entries.map((entry) {
        final mood = entry.key;
        final icon = entry.value;
        final isSelected = _selectedMood == mood;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedMood = mood;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(mood);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: isSelected
                    ? AppColors.secondBackground
                    : Colors.grey.shade200,
                child: Icon(icon,
                    color: isSelected ? Colors.white : Colors.grey.shade700),
              ),
              SizedBox(height: 4),
              Text(
                moodLabels[mood] ?? "",
                style: TextStyle(
                    fontSize: 12,
                    color:
                        isSelected ? AppColors.secondBackground : Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
