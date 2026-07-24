import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/student.dart';
import 'add_student_screen.dart';
import 'student_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
final DBHelper dbHelper = DBHelper();
List<Student> students = [];
List<Student> filteredStudents = [];

@override
void initState() {
super.initState();
loadStudents();
}

void loadStudents() async {
students = await dbHelper.getStudents();
setState(() {
filteredStudents = students;
});
}

void searchStudent(String value) {
setState(() {
filteredStudents = students.where((student) {
return student.name.toLowerCase().contains(value.toLowerCase()) ||
student.rollNo.toLowerCase().contains(value.toLowerCase());
}).toList();
});
}

void deleteStudent(int id) async {
await dbHelper.deleteStudent(id);
loadStudents();
}

void showDeleteDialog(int id) {
showDialog(
context: context,
builder: (context) => AlertDialog(
title: const Text("Delete Student"),
content: const Text("Delete this student?"),
actions: [
TextButton(
onPressed: () => Navigator.pop(context),
child: const Text("Cancel"),
),
TextButton(
onPressed: () {
deleteStudent(id);
Navigator.pop(context);
},
child: const Text("Delete"),
),
],
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Student Record"),
backgroundColor: Colors.deepPurple,
foregroundColor: Colors.white,
centerTitle: true,
),
body: Container(
color: Colors.white,
child: Column(
children: [
Container(
margin: const EdgeInsets.all(10),
padding: const EdgeInsets.all(12),
width: double.infinity,
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(15),
border: Border.all(color: Colors.deepPurple),
),
child: Text(
"Total Students: ${students.length}",
style: const TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
),

Padding(
padding: const EdgeInsets.symmetric(horizontal: 10),
child: TextField(
onChanged: searchStudent,
decoration: InputDecoration(
hintText: "Search Student",
prefixIcon: const Icon(Icons.search),
filled: true,
fillColor:  Colors.white,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(15),
),
),
),
),
  Expanded(
    child: filteredStudents.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.school,
            size: 80,
            color: Colors.deepPurple,
          ),
          SizedBox(height: 15),
          Text(
            "No Students Added Yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Press + button to add student",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    )
        : ListView.builder(
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        Student student = filteredStudents[index];

        return Card(
          color: Colors.white,
          elevation: 3,
          margin: const EdgeInsets.all(10),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      StudentDetailScreen(student: student),
                ),
              );
            },
            title: Text(
              student.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              "Roll No: ${student.rollNo}\n"
                  "Department: ${student.department}\n"
                  "Semester: ${student.semester}\n"
                  "CGPA: ${student.cgpa}",
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AddStudentScreen(student: student),
                      ),
                    );
                    loadStudents();
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    showDeleteDialog(student.id!);
                  },
                ),
              ],
            ),
          ),
        );
      },
    ),
  ),
],
),
),
  floatingActionButton: FloatingActionButton(
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,
    child: const Icon(Icons.add),
    onPressed: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AddStudentScreen(),
        ),
      );
      loadStudents();
    },
  ),
);
}
}