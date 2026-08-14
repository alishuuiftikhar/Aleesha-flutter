import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/contact.dart';

class ContactService {
  final _supabase = Supabase.instance.client;

  Future<List<Contact>> getContacts() async {
    try {
      final response = await _supabase
          .from('contacts')
          .select()
          .order('created_at', ascending: false);
      
      return (response as List).map((json) => Contact.fromMap(json)).toList();
    } catch (e) {
      // Fallback to mock data if table doesn't exist or error occurs
      return _mockContacts;
    }
  }

  Future<void> addContact(Contact contact) async {
    await _supabase.from('contacts').insert(contact.toMap());
  }

  Future<void> updateContact(Contact contact) async {
    if (contact.id == null) return;
    await _supabase
        .from('contacts')
        .update(contact.toMap())
        .eq('id', contact.id!);
  }

  Future<void> deleteContact(String id) async {
    await _supabase.from('contacts').delete().eq('id', id);
  }

  final List<Contact> _mockContacts = [
    Contact(
      id: '1',
      name: 'David Miller',
      jobTitle: 'Technical Lead',
      phone: '+1 234 567 890',
      email: 'david.miller@example.com',
      website: 'https://davidmiller.dev',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=400',
    ),
    Contact(
      id: '2',
      name: 'Sarah Johnson',
      jobTitle: 'Product Designer',
      phone: '+1 987 654 321',
      email: 'sarah.j@design.co',
      website: 'https://sarahdesign.com',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=400',
    ),
  ];
}
