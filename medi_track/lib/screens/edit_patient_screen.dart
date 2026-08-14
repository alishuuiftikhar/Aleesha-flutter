import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPatientScreen extends StatefulWidget {
  final Map patient;

  const EditPatientScreen({
    super.key,
    required this.patient,
  });

  @override
  State<EditPatientScreen> createState() =>
      _EditPatientScreenState();
}

class _EditPatientScreenState
    extends State<EditPatientScreen> {
final supabase = Supabase.instance.client;

late TextEditingController patientNameController;
late TextEditingController ageController;
late TextEditingController phoneController;
late TextEditingController diseaseController;
late TextEditingController doctorController;
late TextEditingController medicineController;
late TextEditingController notesController;

String gender = "Male";
DateTime appointmentDate = DateTime.now();

bool isLoading = false;

@override
void initState() {
super.initState();

patientNameController = TextEditingController(
text: widget.patient['patient_name'],
);

ageController = TextEditingController(
text: widget.patient['age'].toString(),
);

phoneController = TextEditingController(
text: widget.patient['phone'],
);

diseaseController = TextEditingController(
text: widget.patient['disease'],
);

doctorController = TextEditingController(
text: widget.patient['doctor_name'],
);

medicineController = TextEditingController(
text: widget.patient['medicine'] ?? "",
);

notesController = TextEditingController(
text: widget.patient['notes'] ?? "",
);

gender = widget.patient['gender'] ?? "Male";

appointmentDate = DateTime.parse(
widget.patient['appointment_date'],
);
}

Future<void> pickDate() async {
final picked = await showDatePicker(
context: context,
initialDate: appointmentDate,
firstDate: DateTime(2024),
lastDate: DateTime(2035),
);

if (picked != null) {
setState(() {
appointmentDate = picked;
});
}
}
Future<void> updatePatient() async {
  if (patientNameController.text.trim().isEmpty ||
      ageController.text.trim().isEmpty ||
      phoneController.text.trim().isEmpty ||
      diseaseController.text.trim().isEmpty ||
      doctorController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please fill all required fields"),
      ),
    );
    return;
  }

  setState(() => isLoading = true);

  try {
    await supabase.from('patients').update({
      'patient_name': patientNameController.text.trim(),
      'age': int.parse(ageController.text.trim()),
      'gender': gender,
      'phone': phoneController.text.trim(),
      'disease': diseaseController.text.trim(),
      'doctor_name': doctorController.text.trim(),
      'appointment_date':
      DateFormat('yyyy-MM-dd').format(appointmentDate),
      'medicine': medicineController.text.trim(),
      'notes': notesController.text.trim(),
    }).eq('id', widget.patient['id']);

    if (!mounted) return;

    Navigator.pop(context, true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $e"),
      ),
    );
  }

  if (mounted) {
    setState(() => isLoading = false);
  }
}

@override
void dispose() {
  patientNameController.dispose();
  ageController.dispose();
  phoneController.dispose();
  diseaseController.dispose();
  doctorController.dispose();
  medicineController.dispose();
  notesController.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Edit Patient"),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          TextField(
            controller: patientNameController,
            decoration: const InputDecoration(
              labelText: "Patient Name",
              prefixIcon: Icon(Icons.person),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Age",
              prefixIcon: Icon(Icons.cake),
            ),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: gender,
            decoration: const InputDecoration(
              labelText: "Gender",
            ),
            items: const [
              DropdownMenuItem(
                value: "Male",
                child: Text("Male"),
              ),
              DropdownMenuItem(
                value: "Female",
                child: Text("Female"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                gender = value!;
              });
            },
          ),

          const SizedBox(height: 12),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: "Phone",
              prefixIcon: Icon(Icons.phone),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: diseaseController,
            decoration: const InputDecoration(
              labelText: "Disease",
              prefixIcon: Icon(Icons.health_and_safety),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: doctorController,
            decoration: const InputDecoration(
              labelText: "Doctor Name",
              prefixIcon: Icon(Icons.medical_services),
            ),
          ),

          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(
              DateFormat('dd MMM yyyy').format(appointmentDate),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit_calendar),
              onPressed: pickDate,
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: medicineController,
            decoration: const InputDecoration(
              labelText: "Medicine",
              prefixIcon: Icon(Icons.medication),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Notes",
              prefixIcon: Icon(Icons.notes),
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: isLoading ? null : updatePatient,
              child: isLoading
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : const Text(
                "Update Patient",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}