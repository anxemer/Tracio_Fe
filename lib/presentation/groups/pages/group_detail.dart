import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/groups/widgets/create_group_activity.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({super.key});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSize.apHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for Avatar, Group Name and Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with square shape and border radius
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: Icon(
                    Icons.group,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16.0),
                // Group Name and Address Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Group Name',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '123 Group Address, City, Country',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),

            // Row for Total Members and Privacy
            Row(
              children: [
                // Total Members
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      '100 Members',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 20.0), // Space between the two items
                // Privacy (Private or Public)
                Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Private',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Edit Group Details Button
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth:
                          100), // Set max width here for the entire column
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300, // Background color
                          borderRadius: BorderRadius.circular(
                              50), // Round the corners to make it circular
                        ),
                        child: ClipOval(
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Edit')
                    ],
                  ),
                ),
                // Overview Button
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth:
                          100), // Set max width here for the entire column
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300, // Background color
                          borderRadius: BorderRadius.circular(
                              50), // Round the corners to make it circular
                        ),
                        child: ClipOval(
                          child: IconButton(
                            icon: Icon(Icons.visibility),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Overview')
                    ],
                  ),
                ),
                // Activities Button
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth:
                          100), // Set max width here for the entire column
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300, // Background color
                          borderRadius: BorderRadius.circular(
                              50), // Round the corners to make it circular
                        ),
                        child: ClipOval(
                          child: IconButton(
                            icon: Icon(Icons.access_time),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Activities')
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.0),
            Row(
              children: [
                Text("No upcoming activities"),
                Spacer(),
                InkWell(
                  splashColor: AppColors.secondBackground, // Color when tapping
                  highlightColor: AppColors
                      .background, // Color when the button is held down
                  onTap: () {
                    final result = Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateGroupActivity()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    width: 80.w, // Adjust the width as needed
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12), // Apply border radius
                    ),
                    child: Text(
                      "Create an event",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
