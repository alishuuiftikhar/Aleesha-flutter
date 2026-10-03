import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/museum.dart';
import '../models/exhibition.dart';
import '../models/artwork.dart';
import '../models/artist.dart';

class DataService {
  Future<List<Museum>> loadMuseums() async {
    final String response = await rootBundle.loadString('assets/data/museums.json');
    final List<dynamic> data = json.decode(response);
    return data.map((e) => Museum.fromJson(e)).toList();
  }

  Future<List<Exhibition>> loadExhibitions() async {
    final String response = await rootBundle.loadString('assets/data/exhibitions.json');
    final List<dynamic> data = json.decode(response);
    return data.map((e) => Exhibition.fromJson(e)).toList();
  }

  Future<List<Artwork>> loadArtworks() async {
    final String response = await rootBundle.loadString('assets/data/artworks.json');
    final List<dynamic> data = json.decode(response);
    return data.map((e) => Artwork.fromJson(e)).toList();
  }

  Future<List<Artist>> loadArtists() async {
    final String response = await rootBundle.loadString('assets/data/artists.json');
    final List<dynamic> data = json.decode(response);
    return data.map((e) => Artist.fromJson(e)).toList();
  }
}
