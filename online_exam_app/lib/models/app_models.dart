class AppUser {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String role; // 'admin' or 'student'

  AppUser({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }
}

class Exam {
  final int? id;
  final String title;
  final String description;
  final String category;
  final int durationMinutes;
  final int totalMarks;
  final int isPublished; // 0 or 1
  final int creatorId;

  Exam({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.durationMinutes,
    required this.totalMarks,
    this.isPublished = 0,
    required this.creatorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'duration_minutes': durationMinutes,
      'total_marks': totalMarks,
      'is_published': isPublished,
      'creator_id': creatorId,
    };
  }

  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      durationMinutes: map['duration_minutes'],
      totalMarks: map['total_marks'],
      isPublished: map['is_published'],
      creatorId: map['creator_id'],
    );
  }
}

class Question {
  final int? id;
  final int examId;
  final String questionText;
  final int marks;

  Question({
    this.id,
    required this.examId,
    required this.questionText,
    required this.marks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exam_id': examId,
      'question_text': questionText,
      'marks': marks,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      examId: map['exam_id'],
      questionText: map['question_text'],
      marks: map['marks'],
    );
  }
}

class QuestionOption {
  final int? id;
  final int questionId;
  final String optionText;
  final int isCorrect; // 0 or 1

  QuestionOption({
    this.id,
    required this.questionId,
    required this.optionText,
    required this.isCorrect,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question_id': questionId,
      'option_text': optionText,
      'is_correct': isCorrect,
    };
  }

  factory QuestionOption.fromMap(Map<String, dynamic> map) {
    return QuestionOption(
      id: map['id'],
      questionId: map['question_id'],
      optionText: map['option_text'],
      isCorrect: map['is_correct'],
    );
  }
}

class ExamAttempt {
  final int? id;
  final int userId;
  final int examId;
  final String startTime;
  final String? endTime;
  final int score;
  final int status; // 0: in progress, 1: completed

  ExamAttempt({
    this.id,
    required this.userId,
    required this.examId,
    required this.startTime,
    this.endTime,
    this.score = 0,
    this.status = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'exam_id': examId,
      'start_time': startTime,
      'end_time': endTime,
      'score': score,
      'status': status,
    };
  }

  factory ExamAttempt.fromMap(Map<String, dynamic> map) {
    return ExamAttempt(
      id: map['id'],
      userId: map['user_id'],
      examId: map['exam_id'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      score: map['score'],
      status: map['status'],
    );
  }
}

class UserAnswer {
  final int? id;
  final int attemptId;
  final int questionId;
  final int selectedOptionId;

  UserAnswer({
    this.id,
    required this.attemptId,
    required this.questionId,
    required this.selectedOptionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'attempt_id': attemptId,
      'question_id': questionId,
      'selected_option_id': selectedOptionId,
    };
  }

  factory UserAnswer.fromMap(Map<String, dynamic> map) {
    return UserAnswer(
      id: map['id'],
      attemptId: map['attempt_id'],
      questionId: map['question_id'],
      selectedOptionId: map['selected_option_id'],
    );
  }
}
