import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/auth_repository.dart';
import 'features/dashboard/banking_repository.dart';
import 'models/account.dart';
import 'models/transaction.dart';
import 'models/beneficiary.dart';
import 'models/profile.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());
final bankingRepositoryProvider = Provider((ref) => BankingRepository());

final profileProvider = FutureProvider<Profile>((ref) async {
  return ref.watch(bankingRepositoryProvider).getProfile();
});

final accountsProvider = FutureProvider<List<Account>>((ref) async {
  return ref.watch(bankingRepositoryProvider).getAccounts();
});

final beneficiariesProvider = FutureProvider<List<Beneficiary>>((ref) async {
  return ref.watch(bankingRepositoryProvider).getBeneficiaries();
});

final selectedAccountProvider = StateProvider<Account?>((ref) => null);

final transactionsProvider = FutureProvider.family<List<Transaction>, String>((ref, accountId) async {
  return ref.watch(bankingRepositoryProvider).getTransactions(accountId);
});
