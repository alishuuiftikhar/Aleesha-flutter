import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({
    super.key,
    required this.student,
  });

  Widget detailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.deepPurple,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$title: $value",
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Detail"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),

      body: Container(
        color: Colors.lightBlue.shade100,
        padding: const EdgeInsets.all(16),

        child: Card(
          color:  Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [

                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.deepPurple,
                  child: Text(
                    student.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                detailItem(
                  Icons.person,
                  "Name",
                  student.name,
                ),

                detailItem(
                  Icons.badge,
                  "Roll No",
                  student.rollNo,
                ),

                detailItem(
                  Icons.school,
                  "Department",
                  student.department,
                ),

                detailItem(
                  Icons.menu_book,
                  "Semester",
                  student.semester,
                ),

                detailItem(
                  Icons.star,
                  "CGPA",
                  student.cgpa.toString(),
                ),

                detailItem(
                  Icons.phone,
                  "Phone",
                  student.phone,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}