import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/student_model.dart';
import '../models/company_model.dart';
import '../models/supervisor_model.dart';
import '../models/internship_model.dart';
import '../models/certificate_model.dart';
import '../models/note_model.dart';

class AppProvider with ChangeNotifier {
  Student? _student;
  List<Internship> _internships = [];
  List<Company> _companies = [];
  List<Supervisor> _supervisors = [];
  List<Certificate> _certificates = [];
  bool _isLoading = true;

  Student? get student => _student;
  List<Internship> get internships => _internships;
  List<Company> get companies => _companies;
  List<Supervisor> get supervisors => _supervisors;
  List<Certificate> get certificates => _certificates;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    await loadAllData();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadAllData() async {
    final db = await DatabaseHelper.instance.database;

    // Load Student (Assume only one student for this app version)
    final studentData = await db.query('students', limit: 1);
    if (studentData.isNotEmpty) {
      _student = Student.fromMap(studentData.first);
    }

    // Load Companies
    final companyData = await db.query('companies');
    _companies = companyData.map((e) => Company.fromMap(e)).toList();

    // Load Supervisors
    final supervisorData = await db.query('supervisors');
    _supervisors = supervisorData.map((e) => Supervisor.fromMap(e)).toList();

    // Load Internships
    final internshipData = await db.query('internships');
    _internships = internshipData.map((e) => Internship.fromMap(e)).toList();

    // Load Certificates
    final certificateData = await db.query('certificates');
    _certificates = certificateData.map((e) => Certificate.fromMap(e)).toList();
  }

  // --- Student CRUD ---
  Future<void> saveStudent(Student student) async {
    final db = await DatabaseHelper.instance.database;
    if (student.id == null) {
      await db.insert('students', student.toMap());
    } else {
      await db.update('students', student.toMap(), where: 'id = ?', whereArgs: [student.id]);
    }
    await loadAllData();
    notifyListeners();
  }

  // --- Internship CRUD ---
  Future<void> addInternship(Internship internship) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('internships', internship.toMap());
    await loadAllData();
    notifyListeners();
  }

  Future<void> updateInternship(Internship internship) async {
    final db = await DatabaseHelper.instance.database;
    await db.update('internships', internship.toMap(), where: 'id = ?', whereArgs: [internship.id]);
    await loadAllData();
    notifyListeners();
  }

  Future<void> deleteInternship(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('internships', where: 'id = ?', whereArgs: [id]);
    await loadAllData();
    notifyListeners();
  }

  // --- Company CRUD ---
  Future<int> addCompany(Company company) async {
    final db = await DatabaseHelper.instance.database;
    int id = await db.insert('companies', company.toMap());
    await loadAllData();
    notifyListeners();
    return id;
  }

  // --- Supervisor CRUD ---
  Future<int> addSupervisor(Supervisor supervisor) async {
    final db = await DatabaseHelper.instance.database;
    int id = await db.insert('supervisors', supervisor.toMap());
    await loadAllData();
    notifyListeners();
    return id;
  }

  // --- Certificate CRUD ---
  Future<void> addCertificate(Certificate certificate) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('certificates', certificate.toMap());
    await loadAllData();
    notifyListeners();
  }

  Future<void> updateCertificate(Certificate certificate) async {
    final db = await DatabaseHelper.instance.database;
    await db.update('certificates', certificate.toMap(), where: 'id = ?', whereArgs: [certificate.id]);
    await loadAllData();
    notifyListeners();
  }

  Future<void> deleteCertificate(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('certificates', where: 'id = ?', whereArgs: [id]);
    await loadAllData();
    notifyListeners();
  }

  Future<void> toggleFavoriteCertificate(Certificate certificate) async {
    final updated = Certificate(
      id: certificate.id,
      title: certificate.title,
      organization: certificate.organization,
      issueDate: certificate.issueDate,
      certificateId: certificate.certificateId,
      category: certificate.category,
      description: certificate.description,
      imagePath: certificate.imagePath,
      status: certificate.status,
      isFavorite: !certificate.isFavorite,
    );
    await updateCertificate(updated);
  }

  // --- Notes CRUD ---
  Future<List<InternshipNote>> getNotesForInternship(int internshipId) async {
    final db = await DatabaseHelper.instance.database;
    final data = await db.query('internship_notes', where: 'internship_id = ?', whereArgs: [internshipId]);
    return data.map((e) => InternshipNote.fromMap(e)).toList();
  }

  Future<void> addNote(InternshipNote note) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('internship_notes', note.toMap());
    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('internship_notes', where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }

  // --- Dashboard Stats ---
  int get totalInternships => _internships.length;
  int get ongoingInternships => _internships.where((i) => i.status == 'Ongoing').length;
  int get completedInternships => _internships.where((i) => i.status == 'Completed').length;
  int get totalCertificates => _certificates.length;
  int get upcomingInternships => _internships.where((i) => i.status == 'Planned').length;

  // --- Helper Methods ---
  Company? getCompanyById(int id) {
    try {
      return _companies.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Supervisor? getSupervisorById(int id) {
    try {
      return _supervisors.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
