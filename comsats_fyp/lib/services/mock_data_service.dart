import '../models/user_model.dart';
import '../models/project_idea_model.dart';
import '../models/team_model.dart';
import '../models/supervision_request_model.dart';
import '../models/submission_model.dart';
import '../models/evaluation_model.dart';
import '../models/notification_model.dart';

/// Centralized in-memory mock dataset that simulates the FYP Portal backend.
/// Replace the methods here with real HTTP calls to your API when ready.
class MockDataService {
  MockDataService._internal() {
    _seed();
  }
  static final MockDataService instance = MockDataService._internal();

  final List<AppUser> users = [];
  final List<ProjectIdea> ideas = [];
  final List<Team> teams = [];
  final List<SupervisionRequest> supervisionRequests = [];
  final List<Submission> submissions = [];
  final List<Evaluation> evaluations = [];
  final List<AppNotification> notifications = [];

  void _seed() {
    users.addAll([
      AppUser(id: 'u1', name: 'Muneeb Ahmed', email: 'fa21-student@cuivehari.edu.pk', regNumber: 'FA21-BCS-045', role: UserRole.student, department: 'Computer Science'),
      AppUser(id: 'u2', name: 'Dr. Manzoor Ahmad', email: 'manzoor@cuivehari.edu.pk', regNumber: 'EMP-1021', role: UserRole.supervisor, department: 'Computer Science'),
      AppUser(id: 'u3', name: 'Mr. Muhammad Abdullah', email: 'abdullah@cuivehari.edu.pk', regNumber: 'EMP-1042', role: UserRole.supervisor, department: 'Computer Science'),
      AppUser(id: 'u4', name: 'Dr. Rab Nawaz', email: 'rabnawaz@cuivehari.edu.pk', regNumber: 'EMP-1077', role: UserRole.evaluator, department: 'Computer Science'),
      AppUser(id: 'u5', name: 'Sub Admin Office', email: 'subadmin@cuivehari.edu.pk', regNumber: 'EMP-2001', role: UserRole.subAdmin, department: 'FYP Office'),
      AppUser(id: 'u6', name: 'Super Admin', email: 'superadmin@cuivehari.edu.pk', regNumber: 'EMP-0001', role: UserRole.superAdmin, department: 'FYP Office'),
    ]);

    ideas.addAll([
      ProjectIdea(
        id: 'i1', title: 'Restaurant Indicator',
        description: 'A GPS-based mobile application which helps people find the closest restaurants based on current position, price, restaurant type, and dish. Restaurant owners manage listings via a web portal; an administrator verifies owners and manages accuracy. Integrates with an on-device GPS-Navigator for turn-by-turn results.',
        domain: 'Mobile Development', techStack: const ['Mobile', 'Flutter', 'Firebase'],
        supervisorId: 'u2', supervisorName: 'Dr. Manzoor Ahmad', maxTeams: 1, teamsAssigned: 0,
        status: 'Open', postedOn: DateTime(2026, 8, 24), difficulty: 'Medium',
      ),
      ProjectIdea(
        id: 'i2', title: 'E-Government Training Management System (TMS)',
        description: 'A web based system for Government of Punjab to acquire and track training/testing sessions for employees, supporting bidding, nomination, registration, results, and feedback with role-based access.',
        domain: 'Web Development', techStack: const ['Web', 'React', 'Node.js'],
        supervisorId: 'u2', supervisorName: 'Dr. Manzoor Ahmad', maxTeams: 1, teamsAssigned: 0,
        status: 'Open', postedOn: DateTime(2026, 8, 24), difficulty: 'Medium',
      ),
      ProjectIdea(
        id: 'i3', title: 'Punjab Agricultural Accounting System (PAAS)',
        description: 'A standardized, transparent financial accounting platform for Punjab farmers and cooperatives to track cost of production, profitability, and access credit and subsidies.',
        domain: 'Web Development', techStack: const ['Web', 'PHP', 'MySQL'],
        supervisorId: 'u2', supervisorName: 'Dr. Manzoor Ahmad', maxTeams: 1, teamsAssigned: 0,
        status: 'Open', postedOn: DateTime(2026, 8, 24), difficulty: 'Medium',
      ),
      ProjectIdea(
        id: 'i4', title: 'COMSATS University Inventory System (CUIS)',
        description: 'A unified web-based inventory system for CUI faculties, students, and staff covering Persons, Locations, Assets, and Licenses with role-based permissions and bulk data import.',
        domain: 'Web Development', techStack: const ['Web', 'Laravel', 'MySQL'],
        supervisorId: 'u2', supervisorName: 'Dr. Manzoor Ahmad', maxTeams: 1, teamsAssigned: 0,
        status: 'Open', postedOn: DateTime(2026, 8, 24), difficulty: 'Medium',
      ),
      ProjectIdea(
        id: 'i5', title: 'AI Based Final Year Project Management with NCEAC Rules',
        description: 'AI-powered tools to analyse project titles, SRS, and reports, detect plagiarism risk, score document quality, recommend supervisors/ideas, auto-assign evaluators, and provide an AI chat-assistant for FAQs — supporting faculty, not replacing them.',
        domain: 'AI & Machine Learning', techStack: const ['AI/ML', 'Python', 'FastAPI'],
        supervisorId: 'u3', supervisorName: 'Mr. Muhammad Abdullah', maxTeams: 1, teamsAssigned: 0,
        status: 'Open', postedOn: DateTime(2026, 3, 6), difficulty: 'Medium',
      ),
    ]);

    teams.add(Team(
      id: 't1', name: 'Team Innovate',
      members: [
        TeamMember(id: 'u1', name: 'Muneeb Ahmed', regNumber: 'FA21-BCS-045', isLeader: true),
      ],
    ));

    submissions.addAll([
      Submission(
        id: 's1', teamId: 't1', type: 'Proposal', fileName: 'proposal_v1.pdf', version: 1,
        submittedOn: DateTime(2026, 8, 28), windowDeadline: DateTime(2026, 9, 5),
        status: 'Approved', feedback: 'Well scoped. Proceed to SRS.',
      ),
      Submission(
        id: 's2', teamId: 't1', type: 'SRS', fileName: 'srs_v1.pdf', version: 1,
        submittedOn: DateTime(2026, 9, 10), windowDeadline: DateTime(2026, 9, 20),
        status: 'Revision Requested', feedback: 'Add non-functional requirements section.',
      ),
    ]);

    evaluations.add(Evaluation(
      id: 'e1', teamId: 't1', evaluatorId: 'u4', evaluatorName: 'Dr. Rab Nawaz',
      evaluationType: 'Internal',
      rubric: [
        RubricScore(criterion: 'Problem Definition', score: 8, maxScore: 10),
        RubricScore(criterion: 'Methodology', score: 7, maxScore: 10),
        RubricScore(criterion: 'Presentation', score: 9, maxScore: 10),
      ],
      remarks: 'Solid proposal defense, refine methodology section.',
      evaluatedOn: DateTime(2026, 9, 1),
    ));

    notifications.addAll([
      AppNotification(id: 'n1', title: 'Submission window opens', message: 'SRS submission window is open until Sep 20.', type: NotificationType.deadline, createdAt: DateTime(2026, 9, 10)),
      AppNotification(id: 'n2', title: 'Feedback received', message: 'Your Proposal was approved by Dr. Manzoor Ahmad.', type: NotificationType.feedback, createdAt: DateTime(2026, 8, 29)),
      AppNotification(id: 'n3', title: 'Milestone reminder', message: 'Design Document is due in 5 days.', type: NotificationType.milestone, createdAt: DateTime(2026, 9, 12)),
    ]);
  }
}
