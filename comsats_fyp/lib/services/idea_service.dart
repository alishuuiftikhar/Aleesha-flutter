import '../models/project_idea_model.dart';
import 'mock_data_service.dart';

class IdeaService {
  Future<List<ProjectIdea>> fetchIdeas({
    String? query,
    String? domain,
    String? techStack,
    String? supervisorName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    var results = List<ProjectIdea>.from(MockDataService.instance.ideas);

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      results = results
          .where((i) => i.title.toLowerCase().contains(q) || i.description.toLowerCase().contains(q))
          .toList();
    }
    if (domain != null && domain.isNotEmpty && domain != 'All Domains') {
      results = results.where((i) => i.domain == domain).toList();
    }
    if (techStack != null && techStack.isNotEmpty && techStack != 'All Tech Stacks') {
      results = results.where((i) => i.techStack.contains(techStack)).toList();
    }
    if (supervisorName != null && supervisorName.isNotEmpty && supervisorName != 'All Supervisors') {
      results = results.where((i) => i.supervisorName == supervisorName).toList();
    }
    return results;
  }

  List<String> get allSupervisorNames => MockDataService.instance.ideas
      .map((i) => i.supervisorName)
      .toSet()
      .toList()
    ..sort();
}
