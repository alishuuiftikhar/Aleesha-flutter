import '../models/astronomy_object.dart';
import '../models/quiz.dart';
import '../models/checklist_item.dart';

class InitialData {
  static List<AstronomyObject> objects = [
    // Planets
    AstronomyObject(
      name: 'Mars',
      category: 'Planets',
      image: 'https://images.unsplash.com/photo-1614728894747-a83421e2b9c9?w=800',
      description: 'The Red Planet, known for its reddish appearance due to iron oxide on its surface.',
      distance: '225 million km',
      size: '6,779 km diameter',
      discoveryInfo: 'Known since antiquity.',
      facts: ['Has two moons: Phobos and Deimos', 'Home to Olympus Mons, the largest volcano in the solar system'],
      relatedObjects: ['Phobos', 'Deimos', 'Earth'],
    ),
    AstronomyObject(
      name: 'Jupiter',
      category: 'Planets',
      image: 'https://images.unsplash.com/photo-1614732414444-096e5f1122d5?w=800',
      description: 'The largest planet in our solar system, a gas giant with a Great Red Spot.',
      distance: '778 million km',
      size: '139,820 km diameter',
      discoveryInfo: 'Known since antiquity.',
      facts: ['Has at least 79 moons', 'Mass is 2.5 times that of all other planets combined'],
      relatedObjects: ['Europa', 'Ganymede', 'Saturn'],
    ),
    AstronomyObject(
      name: 'Saturn',
      category: 'Planets',
      image: 'https://images.unsplash.com/photo-1506038634487-60a69ae4b7b1?w=800',
      description: 'Famous for its prominent ring system, composed mostly of ice particles.',
      distance: '1.4 billion km',
      size: '116,460 km diameter',
      discoveryInfo: 'Known since antiquity.',
      facts: ['Least dense planet in the solar system', 'Has 82 confirmed moons'],
      relatedObjects: ['Titan', 'Jupiter', 'Rhea'],
    ),
    // Stars
    AstronomyObject(
      name: 'Sirius',
      category: 'Stars',
      image: 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=800',
      description: 'The brightest star in the night sky, also known as the Dog Star.',
      distance: '8.6 light years',
      size: '1.7x Sun radius',
      discoveryInfo: 'Observed by ancient Egyptians.',
      facts: ['Binary star system', 'Sirius A is a main-sequence star'],
      relatedObjects: ['Canis Major', 'Sun'],
    ),
    AstronomyObject(
      name: 'Betelgeuse',
      category: 'Stars',
      image: 'https://images.unsplash.com/photo-1464802686167-b939a6910659?w=800',
      description: 'A red supergiant star in the constellation Orion.',
      distance: '642.5 light years',
      size: '887x Sun radius',
      discoveryInfo: 'Well known throughout history.',
      facts: ['One of the largest stars visible to the naked eye', 'Expected to go supernova soon in cosmic time'],
      relatedObjects: ['Orion', 'Rigel'],
    ),
    // Galaxies
    AstronomyObject(
      name: 'Andromeda Galaxy',
      category: 'Galaxies',
      image: 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=800',
      description: 'The nearest major galaxy to the Milky Way.',
      distance: '2.537 million light years',
      size: '220,000 light years diameter',
      discoveryInfo: 'First documented by Abd al-Rahman al-Sufi in 964 AD.',
      facts: ['Contains about 1 trillion stars', 'On a collision course with the Milky Way'],
      relatedObjects: ['Milky Way', 'Triangulum Galaxy'],
    ),
    // Constellations
    AstronomyObject(
      name: 'Orion',
      category: 'Constellations',
      image: 'https://images.unsplash.com/photo-1538370965046-79c0d6907d47?w=800',
      description: 'One of the most recognizable constellations, containing the Orion Nebula.',
      facts: ['Named after a hunter in Greek mythology', 'Contains the stars Betelgeuse and Rigel'],
      relatedObjects: ['Betelgeuse', 'Rigel', 'Orion Nebula'],
    ),
    // Moons
    AstronomyObject(
      name: 'Titan',
      category: 'Moons',
      image: 'https://images.unsplash.com/photo-1614728894747-a83421e2b9c9?w=800',
      description: 'The largest moon of Saturn and the only moon known to have a dense atmosphere.',
      distance: '1.2 million km from Saturn',
      size: '5,150 km diameter',
      facts: ['Only place other than Earth with liquid on its surface', 'Larger than the planet Mercury'],
      relatedObjects: ['Saturn', 'Enceladus'],
    ),
    // Missions
    AstronomyObject(
      name: 'Voyager 1',
      category: 'Space Missions',
      image: 'https://images.unsplash.com/photo-1454789548928-9efd52dc4031?w=800',
      description: 'A space probe launched by NASA to study the outer Solar System.',
      discoveryInfo: 'Launched September 5, 1977.',
      facts: ['Farthest man-made object from Earth', 'Entered interstellar space in 2012'],
      relatedObjects: ['Voyager 2', 'Jupiter', 'Saturn'],
    ),
  ];

  static List<QuizQuestion> questions = [
    QuizQuestion(
      question: 'Which planet is known as the Red Planet?',
      options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      correctIndex: 1,
      difficulty: 'Easy',
    ),
    QuizQuestion(
      question: 'What is the largest planet in our solar system?',
      options: ['Earth', 'Neptune', 'Jupiter', 'Saturn'],
      correctIndex: 2,
      difficulty: 'Easy',
    ),
    QuizQuestion(
      question: 'What type of galaxy is the Milky Way?',
      options: ['Elliptical', 'Spiral', 'Irregular', 'Lenticular'],
      correctIndex: 1,
      difficulty: 'Medium',
    ),
    QuizQuestion(
      question: 'What is the brightest star in the night sky?',
      options: ['Polaris', 'Sirius', 'Vega', 'Betelgeuse'],
      correctIndex: 1,
      difficulty: 'Medium',
    ),
    QuizQuestion(
      question: 'How many light years away is the Andromeda Galaxy?',
      options: ['1 million', '2.5 million', '10 million', '100,000'],
      correctIndex: 1,
      difficulty: 'Hard',
    ),
  ];

  static List<ChecklistItem> checklist = [
    ChecklistItem(title: 'Telescope'),
    ChecklistItem(title: 'Binoculars'),
    ChecklistItem(title: 'Notebook & Pen'),
    ChecklistItem(title: 'Phone/Camera'),
    ChecklistItem(title: 'Red light flashlight'),
    ChecklistItem(title: 'Water & Snacks'),
    ChecklistItem(title: 'Observation location selected'),
    ChecklistItem(title: 'Weather check done'),
  ];
}
