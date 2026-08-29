import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  
  DatabaseHelper._init();

  // Updated Getter
  SupabaseClient get _client {
    try {
      final client = Supabase.instance.client;
      return client;
    } catch (e) {
      throw 'Supabase not initialized. API Key or URL is wrong.';
    }
  }

  void _handleError(String action, Object error) {
    print('SUPABASE_DEBUG: Error during $action');
    print('ERROR_DETAILS: $error');
  }

  // --- CRUD for Classes ---
  Future<int> insertClass(Map<String, dynamic> row) async {
    try {
      final response = await _client.from('classes').insert(row).select('id').single();
      
      // Detailed ID conversion
      if (response['id'] != null) {
        return int.parse(response['id'].toString());
      }
      throw 'Insert successful but no ID returned.';
    } catch (e) {
      _handleError('insertClass', e);
      if (e is PostgrestException) {
        if (e.code == '42P01') throw 'TABLE ERROR: "classes" table nahi mili. Kya aapne SQL Editor mein code Run kiya tha?';
        if (e.code == '401' || e.code == '403') throw 'PERMISSION ERROR: API Key sahi nahi hai ya RLS on hai. SQL Editor mein "ALTER TABLE classes DISABLE ROW LEVEL SECURITY;" run karein.';
        throw 'Supabase DB Error: ${e.message}';
      }
      throw 'Connection Error: $e';
    }
  }

  Future<List<Map<String, dynamic>>> queryAllClasses() async {
    try {
      final response = await _client.from('classes').select().order('name', ascending: true);
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      _handleError('queryAllClasses', e);
      return [];
    }
  }

  Future<void> updateClass(Map<String, dynamic> row) async {
    try {
      final id = row['id'];
      await _client.from('classes').update(row).eq('id', id);
    } catch (e) {
      _handleError('updateClass', e);
      throw 'Update Failed: ${e.toString()}';
    }
  }

  Future<void> deleteClass(int id) async {
    try {
      await _client.from('classes').delete().eq('id', id);
    } catch (e) {
      _handleError('deleteClass', e);
      throw 'Delete Failed: ${e.toString()}';
    }
  }

  // --- CRUD for Subjects ---
  Future<void> insertSubject(Map<String, dynamic> row) async {
    try {
      await _client.from('subjects').insert(row);
    } catch (e) {
      _handleError('insertSubject', e);
      throw 'Subject Save Error: ${e.toString()}';
    }
  }

  Future<List<Map<String, dynamic>>> querySubjectsByClass(int classId) async {
    try {
      final List<dynamic> response = await _client.from('subjects').select().eq('class_id', classId).order('name', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      _handleError('querySubjectsByClass', e);
      return [];
    }
  }

  Future<void> updateSubject(int id, String name) async {
    try {
      await _client.from('subjects').update({'name': name}).eq('id', id);
    } catch (e) {
      _handleError('updateSubject', e);
      throw 'Subject Update Error: ${e.toString()}';
    }
  }

  Future<void> deleteSubject(int id) async {
    try {
      await _client.from('subjects').delete().eq('id', id);
    } catch (e) {
      _handleError('deleteSubject', e);
      throw 'Subject Delete Error: ${e.toString()}';
    }
  }

  // --- CRUD for Students ---
  Future<void> insertStudent(Map<String, dynamic> row) async {
    try {
      await _client.from('students').insert(row);
    } catch (e) {
      _handleError('insertStudent', e);
      throw 'Student Save Error: ${e.toString()}';
    }
  }

  Future<List<Map<String, dynamic>>> queryStudentsByClass(int classId) async {
    try {
      final List<dynamic> response = await _client.from('students').select().eq('class_id', classId).order('name', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      _handleError('queryStudentsByClass', e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> queryAllStudents() async {
    try {
      final List<dynamic> response = await _client.from('students').select('''
        *,
        classes (name)
      ''').order('name', ascending: true);
      
      return response.map((item) {
        final map = Map<String, dynamic>.from(item);
        if (item['classes'] != null) {
          map['class_name'] = item['classes']['name'];
        }
        return map;
      }).toList();
    } catch (e) {
      _handleError('queryAllStudents', e);
      return [];
    }
  }

  Future<void> updateStudent(Map<String, dynamic> row) async {
    try {
      final id = row['id'];
      await _client.from('students').update(row).eq('id', id);
    } catch (e) {
      _handleError('updateStudent', e);
      throw 'Student Update Error: ${e.toString()}';
    }
  }

  Future<void> deleteStudent(int id) async {
    try {
      await _client.from('students').delete().eq('id', id);
    } catch (e) {
      _handleError('deleteStudent', e);
      throw 'Student Delete Error: ${e.toString()}';
    }
  }

  // --- CRUD for Attendance ---
  Future<void> insertAttendance(Map<String, dynamic> row) async {
    try {
      await _client.from('attendance').upsert(row, onConflict: 'student_id, subject_id, date');
    } catch (e) {
      _handleError('insertAttendance', e);
      throw 'Attendance Save Error: ${e.toString()}';
    }
  }

  Future<List<Map<String, dynamic>>> queryAttendance(int subjectId, String date) async {
    try {
      final List<dynamic> response = await _client.from('attendance')
          .select()
          .eq('subject_id', subjectId)
          .eq('date', date);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      _handleError('queryAttendance', e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> queryStudentAttendance(int studentId) async {
    try {
      final List<dynamic> data = await _client.from('attendance').select('''
        *,
        subjects (name)
      ''').eq('student_id', studentId).order('date', ascending: false);
      
      return data.map((e) {
        final map = Map<String, dynamic>.from(e);
        map['subject_name'] = e['subjects'] != null ? e['subjects']['name'] : 'Unknown';
        return map;
      }).toList();
    } catch (e) {
      _handleError('queryStudentAttendance', e);
      return [];
    }
  }

  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final students = await _client.from('students').select('id');
      final classes = await _client.from('classes').select('id');
      final subjects = await _client.from('subjects').select('id');
      
      final attendanceData = await _client.from('attendance').select('status');
      
      Map<String, int> statusCounts = {'Present': 0, 'Absent': 0, 'Late': 0};
      for (var row in attendanceData) {
        String status = row['status'] as String;
        statusCounts[status] = (statusCounts[status] ?? 0) + 1;
      }

      List<Map<String, dynamic>> attendanceStats = statusCounts.entries
          .map((e) => {'status': e.key, 'count': e.value})
          .toList();

      return {
        'students': (students as List).length,
        'classes': (classes as List).length,
        'subjects': (subjects as List).length,
        'attendance': attendanceStats,
      };
    } catch (e) {
      _handleError('getStatistics', e);
      return {
        'students': 0,
        'classes': 0,
        'subjects': 0,
        'attendance': [],
      };
    }
  }
}
