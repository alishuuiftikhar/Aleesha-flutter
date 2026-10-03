import 'package:flutter/foundation.dart';
import '../models/project_idea_model.dart';
import '../services/idea_service.dart';

class IdeaProvider extends ChangeNotifier {
  final IdeaService _service = IdeaService();

  List<ProjectIdea> _ideas = [];
  bool _isLoading = false;
  String _query = '';
  String _domain = 'All Domains';
  String _techStack = 'All Tech Stacks';
  String _supervisor = 'All Supervisors';

  List<ProjectIdea> get ideas => _ideas;
  bool get isLoading => _isLoading;
  String get query => _query;
  String get domain => _domain;
  String get techStack => _techStack;
  String get supervisor => _supervisor;
  List<String> get supervisorNames => _service.allSupervisorNames;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _ideas = await _service.fetchIdeas(
      query: _query, domain: _domain, techStack: _techStack, supervisorName: _supervisor,
    );
    _isLoading = false;
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    load();
  }

  void setDomain(String value) {
    _domain = value;
    load();
  }

  void setTechStack(String value) {
    _techStack = value;
    load();
  }

  void setSupervisor(String value) {
    _supervisor = value;
    load();
  }

  void resetFilters() {
    _query = '';
    _domain = 'All Domains';
    _techStack = 'All Tech Stacks';
    _supervisor = 'All Supervisors';
    load();
  }
}
