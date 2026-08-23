import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/account.dart';
import '../../models/transaction.dart';
import '../../models/beneficiary.dart';
import '../../models/profile.dart';

class BankingRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Profile> getProfile() async {
    final userId = _supabase.auth.currentUser!.id;
    final data = await _supabase.from('profiles').select().eq('id', userId).single();
    return Profile.fromJson(data);
  }

  Future<List<Account>> getAccounts() async {
    final userId = _supabase.auth.currentUser!.id;
    final data = await _supabase.from('accounts').select().eq('user_id', userId);
    return (data as List).map((json) => Account.fromJson(json)).toList();
  }

  Future<List<Transaction>> getTransactions(String accountId) async {
    final data = await _supabase
        .from('transactions')
        .select()
        .or('from_account_id.eq.$accountId,to_account_id.eq.$accountId')
        .order('created_at', ascending: false);
    return (data as List).map((json) => Transaction.fromJson(json)).toList();
  }

  Future<List<Beneficiary>> getBeneficiaries() async {
    final userId = _supabase.auth.currentUser!.id;
    final data = await _supabase.from('beneficiaries').select().eq('user_id', userId);
    return (data as List).map((json) => Beneficiary.fromJson(json)).toList();
  }

  Future<void> addBeneficiary(String name, String accountNumber) async {
    final userId = _supabase.auth.currentUser!.id;
    await _supabase.from('beneficiaries').insert({
      'user_id': userId,
      'name': name,
      'account_number': accountNumber,
    });
  }

  Future<void> removeBeneficiary(String id) async {
    await _supabase.from('beneficiaries').delete().eq('id', id);
  }

  Future<void> transferMoney({
    required String fromAccountId,
    required String toAccountNumber,
    required double amount,
    required String description,
  }) async {
    // 1. Find target account
    final toAccountData = await _supabase
        .from('accounts')
        .select()
        .eq('account_number', toAccountNumber)
        .maybeSingle();
    
    if (toAccountData == null) {
      throw Exception('Target account not found');
    }
    
    final toAccountId = toAccountData['id'];

    // In a real app, this should be a stored procedure or transaction to ensure atomicity
    // For this simulation, we'll do sequential updates
    
    // 2. Debit sender
    final fromAccount = await _supabase.from('accounts').select().eq('id', fromAccountId).single();
    final currentBalance = (fromAccount['balance'] as num).toDouble();
    
    if (currentBalance < amount) {
      throw Exception('Insufficient funds');
    }
    
    await _supabase.from('accounts').update({
      'balance': currentBalance - amount
    }).eq('id', fromAccountId);
    
    // 3. Credit receiver
    final targetBalance = (toAccountData['balance'] as num).toDouble();
    await _supabase.from('accounts').update({
      'balance': targetBalance + amount
    }).eq('id', toAccountId);
    
    // 4. Record transaction
    await _supabase.from('transactions').insert({
      'from_account_id': fromAccountId,
      'to_account_id': toAccountId,
      'amount': amount,
      'description': description,
      'transaction_type': 'transfer',
    });
  }
}
