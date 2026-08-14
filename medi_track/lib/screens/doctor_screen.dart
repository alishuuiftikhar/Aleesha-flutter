import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'edit_doctor_screen.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
final supabase = Supabase.instance.client;

List doctors = [];
List filteredDoctors = [];

bool isLoading = false;

final searchController = TextEditingController();

final nameController = TextEditingController();
final specialityController = TextEditingController();
final phoneController = TextEditingController();

@override
void initState() {
super.initState();
fetchDoctors();
}

Future<void> fetchDoctors() async {
setState(() => isLoading = true);

try {
final data = await supabase
.from('doctors')
.select()
.order('id', ascending: false);

setState(() {
doctors = data;
filteredDoctors = data;
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

void searchDoctor(String value) {
setState(() {
filteredDoctors = doctors.where((doctor) {
return doctor['name']
.toString()
.toLowerCase()
.contains(value.toLowerCase());
}).toList();
});
}
Future<void> addDoctor() async {
if (nameController.text.trim().isEmpty ||
specialityController.text.trim().isEmpty ||
phoneController.text.trim().isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Please fill all fields"),
),
);
return;
}

setState(() => isLoading = true);

try {
await supabase.from('doctors').insert({
'name': nameController.text.trim(),
'speciality': specialityController.text.trim(),
'phone': phoneController.text.trim(),
});

nameController.clear();
specialityController.clear();
phoneController.clear();

await fetchDoctors();

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Doctor Added Successfully"),
),
);
} catch (e) {
if (!mounted) return;

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

Future<void> deleteDoctor(int id) async {
try {
await supabase
.from('doctors')
.delete()
.eq('id', id);

fetchDoctors();

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Doctor Deleted"),
),
);
} catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text("Error: $e"),
),
);
}
}

@override
void dispose() {
searchController.dispose();
nameController.dispose();
specialityController.dispose();
phoneController.dispose();
super.dispose();
}
@override
Widget build(BuildContext context) {
  return Scaffold(

    appBar: AppBar(
      title: const Text("Doctors"),
      centerTitle: true,
    ),

    body: isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )

        : Padding(
      padding: const EdgeInsets.all(15),

      child: Column(
        children: [

          TextField(
            controller: searchController,
            onChanged: searchDoctor,

            decoration: InputDecoration(
              hintText: "Search Doctor",
              prefixIcon: const Icon(Icons.search),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          const SizedBox(height: 15),


          TextField(
            controller: nameController,

            decoration: input(
              "Doctor Name",
              Icons.person,
            ),
          ),

          const SizedBox(height: 10),


          TextField(
            controller: specialityController,

            decoration: input(
              "Speciality",
              Icons.medical_services,
            ),
          ),

          const SizedBox(height: 10),


          TextField(
            controller: phoneController,

            keyboardType: TextInputType.phone,

            decoration: input(
              "Phone",
              Icons.phone,
            ),
          ),


          const SizedBox(height: 15),


          SizedBox(
            width: double.infinity,
            height: 55,

            child: ElevatedButton.icon(

              onPressed: addDoctor,

              icon: const Icon(Icons.add),

              label: const Text(
                "Add Doctor",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          ),


          const SizedBox(height: 15),


          Expanded(

            child: ListView.builder(

              itemCount: filteredDoctors.length,

              itemBuilder: (context,index){

                final doctor =
                filteredDoctors[index];


                return Card(

                  elevation: 4,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                  ),

                  child: ListTile(

                    leading: const CircleAvatar(

                      backgroundColor:
                      Color(0xFFEC4899),

                      child: Icon(
                        Icons.medical_services,
                        color: Colors.white,
                      ),
                    ),


                    title: Text(

                      doctor['name'],

                      style: const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),


                    subtitle: Text(
                      "Speciality: ${doctor['speciality']}\nPhone: ${doctor['phone']}",
                    ),


                    trailing: Row(

                      mainAxisSize:
                      MainAxisSize.min,

                      children: [

                        IconButton(

                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),


                          onPressed: (){

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context)=>
                                    EditDoctorScreen(
                                      doctor: doctor,
                                    ),
                              ),
                            ).then(
                                  (_) => fetchDoctors(),
                            );

                          },
                        ),


                        IconButton(

                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),


                          onPressed: (){

                            deleteDoctor(
                              doctor['id'],
                            );

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


InputDecoration input(
    String text,
    IconData icon,
    ){

  return InputDecoration(

    labelText: text,

    prefixIcon: Icon(
      icon,
      color: const Color(0xFFEC4899),
    ),


    filled: true,

    fillColor: Colors.white,


    border: OutlineInputBorder(

      borderRadius:
      BorderRadius.circular(15),

      borderSide: BorderSide.none,
    ),
  );
}
}