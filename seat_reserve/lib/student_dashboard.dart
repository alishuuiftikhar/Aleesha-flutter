import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models.dart';
import 'theme.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!user.isApproved) {
      return Scaffold(
        appBar: AppBar(title: const Text('Status')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.hourglass_bottom, size: 80, color: AppColors.primary),
                const SizedBox(height: 24),
                Text('Approval Pending', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                const Text(
                  'Your account is waiting for teacher approval. Please check back later once you are approved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    await context.read<AppState>().logout();
                    if (context.mounted) Navigator.pushReplacementNamed(context, '/');
                  },
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final mySeat = state.allSeats.firstWhere(
      (s) => s.reservedByUserId == user.id,
      orElse: () => Seat(id: '', label: '', zone: ''),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('SeatFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AppState>().logout();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, ${user.fullName}!', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 8),
            Text(
              'Reserve your seat before ${state.reservationDeadline.format(context)} today.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            if (mySeat.id.isNotEmpty)
              _ReservedSeatCard(mySeat: mySeat)
            else
              _ReservationActionCard(state: state),
            const SizedBox(height: 32),
            if (user.fines > 0)
              _FineAlert(fines: user.fines),
          ],
        ),
      ),
    );
  }
}

class _ReservedSeatCard extends StatelessWidget {
  final Seat mySeat;
  const _ReservedSeatCard({required this.mySeat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryVariant],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(50),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text(
            'SEAT RESERVED',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          Text(
            'Seat ${mySeat.label} • ${mySeat.zone}',
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Please arrive on time to avoid fines.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ReservationActionCard extends StatelessWidget {
  final AppState state;
  const _ReservationActionCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final availableCount = state.allSeats.where((s) => !s.isReserved).length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Available Workspace', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$availableCount Seats Left',
                  style: const TextStyle(color: AppColors.onSecondaryContainer, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              _InfoItem(label: 'HUB', value: 'Main Zone'),
              SizedBox(width: 40),
              _InfoItem(label: 'TYPE', value: 'Standard'),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              try {
                final seat = state.allSeats.firstWhere((s) => !s.isReserved);
                await state.reserveSeat(seat.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Seat reserved successfully!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No seats available.')),
                  );
                }
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Reserve My Spot Now'),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _FineAlert extends StatelessWidget {
  final int fines;
  const _FineAlert({required this.fines});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withAlpha(50)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.error),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Fine Alert', style: TextStyle(color: AppColors.onErrorContainer, fontWeight: FontWeight.bold)),
                Text('You have \$${fines} in unpaid fines for no-shows.', style: const TextStyle(color: AppColors.onErrorContainer)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
