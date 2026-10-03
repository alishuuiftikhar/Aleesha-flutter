enum InspirationCategory { graphicDesign, interiorDesign, fashion, photography, uiDesign, colorPalettes }

class InspirationItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final InspirationCategory category;
  final List<String> colors;
  final List<String> tags;

  InspirationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.colors,
    required this.tags,
  });

  factory InspirationItem.fromJson(Map<String, dynamic> json) {
    String cat = (json['category'] ?? '').toString();
    InspirationCategory category = InspirationCategory.uiDesign;
    switch (cat.toLowerCase()) {
      case 'graphicdesign':
      case 'graphic_design':
      case 'graphic-design':
      case 'graphic':
        category = InspirationCategory.graphicDesign;
        break;
      case 'interiordesign':
      case 'interior_design':
      case 'interior-design':
      case 'interior':
        category = InspirationCategory.interiorDesign;
        break;
      case 'fashion':
        category = InspirationCategory.fashion;
        break;
      case 'photography':
        category = InspirationCategory.photography;
        break;
      case 'uidesign':
      case 'ui_design':
      case 'ui-design':
        category = InspirationCategory.uiDesign;
        break;
      case 'colorpalettes':
      case 'color_palettes':
      case 'color-palettes':
      case 'colorpalette':
      case 'color_palette':
        category = InspirationCategory.colorPalettes;
        break;
      default:
        category = InspirationCategory.uiDesign;
    }

    return InspirationItem(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      category: category,
      colors: List<String>.from(json['colors'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category.toString().split('.').last,
      'colors': colors,
      'tags': tags,
    };
  }
}
