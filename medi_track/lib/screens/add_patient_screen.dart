import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'edit_patient_screen.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
final supabase = Supabase.instance.client;

List patients = [];
List filteredPatients = [];

bool isLoading = false;

final searchController = TextEditingController();

final patientNameController = TextEditingController();
final ageController = TextEditingController();
final phoneController = TextEditingController();
final diseaseController = TextEditingController();
final doctorController = TextEditingController();
final medicineController = TextEditingController();
final notesController = TextEditingController();

String gender = "Male";
DateTime selectedDate = DateTime.now();

@override
void initState() {
super.initState();
fetchPatients();
}

Future<void> fetchPatients() async {
setState(() => isLoading = true);

try {
final data = await supabase
.from('patients')
.select()
.order('created_at', ascending: false);

setState(() {
patients = data;
filteredPatients = data;
});
} catch (e) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text("Error: $e"),
),
);
}

setState(() => isLoading = false);
}

void searchPatient(String value) {
setState(() {
filteredPatients = patients.where((patient) {
return patient['patient_name']
.toString()
.toLowerCase()
.contains(value.toLowerCase());
}).toList();
});
}

Future<void> pickDate() async {
final picked = await showDatePicker(
context: context,
initialDate: selectedDate,
firstDate: DateTime(2024),
lastDate: DateTime(2035),
);

if (picked != null) {
setState(() {
selectedDate = picked;
});
}
}
Future<void> addPatient() async {
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

try {
await supabase.from('patients').insert({
'patient_name': patientNameController.text.trim(),
'age': int.parse(ageController.text.trim()),
'gender': gender,
'phone': phoneController.text.trim(),
'disease': diseaseController.text.trim(),
'doctor_name': doctorController.text.trim(),
'appointment_date':
DateFormat('yyyy-MM-dd').format(selectedDate),
'medicine': medicineController.text.trim(),
'notes': notesController.text.trim(),
});

patientNameController.clear();
ageController.clear();
phoneController.clear();
diseaseController.clear();
doctorController.clear();
medicineController.clear();
notesController.clear();

gender = "Male";
selectedDate = DateTime.now();

fetchPatients();

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Patient Added Successfully"),
),
);

setState(() {});
} catch (e) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text("Error: $e"),
),
);
}
}

Future<void> deletePatient(int id) async {
await supabase.from('patients').delete().eq('id', id);
fetchPatients();
}

@override
void dispose() {
searchController.dispose();
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
      title: const Text("Patients"),
      centerTitle: true,
    ),
    body: isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          TextField(
            controller: searchController,
            onChanged: searchPatient,
            decoration: const InputDecoration(
              hintText: "Search Patient",
              prefixIcon: Icon(Icons.search),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: patientNameController,
            decoration: const InputDecoration(
              labelText: "Patient Name",
              prefixIcon: Icon(Icons.person),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              Expanded(
                child: TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Age",
                    prefixIcon: Icon(Icons.cake),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: DropdownButtonFormField<String>(
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
              ),
            ],
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
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: "Notes",
              prefixIcon: Icon(Icons.notes),
            ),
          ),

          const SizedBox(height: 12),

          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            leading: const Icon(Icons.calendar_today),
            title: Text(
              DateFormat('dd MMM yyyy').format(selectedDate),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit_calendar),
              onPressed: pickDate,
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: addPatient,
              icon: const Icon(Icons.add),
              label: const Text("Add Patient"),
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {

                final patient = filteredPatients[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(patient['patient_name']),
                    subtitle: Text(
                      "${patient['disease']}\n${patient['phone']}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditPatientScreen(
                                      patient: patient,
                                    ),
                              ),
                            ).then((_) => fetchPatients());
                          },
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deletePatient(patient['id']);
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
  );
}
}