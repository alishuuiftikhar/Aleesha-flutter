class Client {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String company;

  Client({this.id, required this.name, required this.email, required this.phone, required this.company});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'company': company,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      company: map['company'],
    );
  }
}

class Project {
  final int? id;
  final String name;
  final String description;
  final int clientId;
  final DateTime deadline;
  final double budget;
  final String status; // 'Active', 'Completed', 'On Hold'

  Project({
    this.id,
    required this.name,
    required this.description,
    required this.clientId,
    required this.deadline,
    required this.budget,
    this.status = 'Active',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'client_id': clientId,
      'deadline': deadline.toIso8601String(),
      'budget': budget,
      'status': status,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      clientId: map['client_id'],
      deadline: DateTime.parse(map['deadline']),
      budget: map['budget'],
      status: map['status'],
    );
  }
}

class Task {
  final int? id;
  final int projectId;
  final String title;
  final String description;
  final bool isCompleted;
  final String priority; // 'Low', 'Medium', 'High'
  final DateTime? deadline;

  Task({
    this.id,
    required this.projectId,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.priority = 'Medium',
    this.deadline,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'title': title,
      'description': description,
      'is_completed': isCompleted ? 1 : 0,
      'priority': priority,
      'deadline': deadline?.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      projectId: map['project_id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['is_completed'] == 1,
      priority: map['priority'],
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
    );
  }
}

class TimeEntry {
  final int? id;
  final int projectId;
  final DateTime startTime;
  final DateTime? endTime;
  final String description;

  TimeEntry({
    this.id,
    required this.projectId,
    required this.startTime,
    this.endTime,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'description': description,
    };
  }

  factory TimeEntry.fromMap(Map<String, dynamic> map) {
    return TimeEntry(
      id: map['id'],
      projectId: map['project_id'],
      startTime: DateTime.parse(map['start_time']),
      endTime: map['end_time'] != null ? DateTime.parse(map['end_time']) : null,
      description: map['description'],
    );
  }
}

class Expense {
  final int? id;
  final int projectId;
  final String category;
  final double amount;
  final DateTime date;
  final String description;

  Expense({
    this.id,
    required this.projectId,
    required this.category,
    required this.amount,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      projectId: map['project_id'],
      category: map['category'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      description: map['description'],
    );
  }
}

class Note {
  final int? id;
  final int projectId;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    this.id,
    required this.projectId,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      projectId: map['project_id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
