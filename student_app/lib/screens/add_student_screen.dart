import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/student.dart';

class AddStudentScreen extends StatefulWidget {
  final Student? student;

  const AddStudentScreen({super.key, this.student});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final DBHelper dbHelper = DBHelper();

  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final departmentController = TextEditingController();
  final semesterController = TextEditingController();
  final cgpaController = TextEditingController();
  final phoneController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    if (widget.student != null) {
      isEdit = true;

      nameController.text = widget.student!.name;
      rollController.text = widget.student!.rollNo;
      departmentController.text = widget.student!.department;
      semesterController.text = widget.student!.semester;
      cgpaController.text = widget.student!.cgpa.toString();
      phoneController.text = widget.student!.phone;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    rollController.dispose();
    departmentController.dispose();
    semesterController.dispose();
    cgpaController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void saveStudent() async {
    if (nameController.text.isEmpty ||
        rollController.text.isEmpty ||
        departmentController.text.isEmpty ||
        semesterController.text.isEmpty ||
        cgpaController.text.isEmpty ||
        phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    double? cgpa = double.tryParse(cgpaController.text);

    if (cgpa == null || cgpa > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter valid CGPA"),
        ),
      );
      return;
    }

    Student student = Student(
      id: isEdit ? widget.student!.id : null,
      name: nameController.text,
      rollNo: rollController.text,
      department: departmentController.text,
      semester: semesterController.text,
      cgpa: cgpa,
      phone: phoneController.text,
    );

    if (isEdit) {
      await dbHelper.updateStudent(student);
    } else {
      await dbHelper.insertStudent(student);
    }

    Navigator.pop(context);
  }

  Widget inputField(
      String label,
      TextEditingController controller,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor:  Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Student" : "Add Student",
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                inputField(
                  "Student Name",
                  nameController,
                ),

                inputField(
                  "Roll Number",
                  rollController,
                ),

                inputField(
                  "Department",
                  departmentController,
                ),

                inputField(
                  "Semester",
                  semesterController,
                ),

                inputField(
                  "CGPA",
                  cgpaController,
                ),

                inputField(
                  "Phone Number",
                  phoneController,
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: saveStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      isEdit
                          ? "Update Student"
                          : "Save Student",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}