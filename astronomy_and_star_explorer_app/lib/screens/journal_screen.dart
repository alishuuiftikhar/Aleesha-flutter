import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/observation.dart';
import '../services/astronomy_provider.dart';
import '../utils/constants.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OBSERVATION JOURNAL')),
      body: Consumer<AstronomyProvider>(
        builder: (context, provider, child) {
          final observations = provider.observations;

          if (observations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_stories, size: 80, color: Colors.white24),
                  const SizedBox(height: 16),
                  const Text('Your journal is empty', style: TextStyle(color: Colors.white38, fontSize: 18)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _showObservationForm(context),
                    child: const Text('Add First Observation'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: observations.length,
            itemBuilder: (context, index) {
              final obs = observations[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              obs.objectName,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMM dd, yyyy').format(obs.date),
                            style: const TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white10, height: 20),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: AppColors.secondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              obs.location,
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: List.generate(5, (i) => Icon(
                              i < obs.rating ? Icons.star : Icons.star_border,
                              size: 16,
                              color: AppColors.accent,
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(obs.notes, style: const TextStyle(fontStyle: FontStyle.italic)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20, color: Colors.white60),
                            onPressed: () => _showObservationForm(context, observation: obs),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20, color: AppColors.error),
                            onPressed: () => _confirmDelete(context, provider, obs.id!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showObservationForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showObservationForm(BuildContext context, {Observation? observation}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ObservationForm(observation: observation),
    );
  }

  void _confirmDelete(BuildContext context, AstronomyProvider provider, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Observation?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              provider.deleteObservation(id);
              Navigator.pop(ctx);
            },
            child: const Text('DELETE', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class ObservationForm extends StatefulWidget {
  final Observation? observation;
  const ObservationForm({super.key, this.observation});

  @override
  State<ObservationForm> createState() => _ObservationFormState();
}

class _ObservationFormState extends State<ObservationForm> {
  final _formKey = GlobalKey<FormState>();
  late String _objectName;
  late DateTime _date;
  late String _location;
  late String _equipment;
  late String _notes;
  late double _rating;

  @override
  void initState() {
    super.initState();
    _objectName = widget.observation?.objectName ?? '';
    _date = widget.observation?.date ?? DateTime.now();
    _location = widget.observation?.location ?? '';
    _equipment = widget.observation?.equipment ?? '';
    _notes = widget.observation?.notes ?? '';
    _rating = widget.observation?.rating ?? 3.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.observation == null ? 'Add Observation' : 'Edit Observation',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _objectName,
                decoration: const InputDecoration(labelText: 'Object Observed'),
                onSaved: (val) => _objectName = val!,
                validator: (val) => val!.isEmpty ? 'Enter object name' : null,
              ),
              TextFormField(
                initialValue: _location,
                decoration: const InputDecoration(labelText: 'Location'),
                onSaved: (val) => _location = val!,
              ),
              TextFormField(
                initialValue: _equipment,
                decoration: const InputDecoration(labelText: 'Equipment'),
                onSaved: (val) => _equipment = val!,
              ),
              TextFormField(
                initialValue: _notes,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
                onSaved: (val) => _notes = val!,
              ),
              const SizedBox(height: 16),
              const Text('Rating'),
              Slider(
                value: _rating,
                min: 1, max: 5, divisions: 4,
                label: _rating.toString(),
                onChanged: (val) => setState(() => _rating = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: const Text('SAVE OBSERVATION'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final provider = Provider.of<AstronomyProvider>(context, listen: false);
      final obs = Observation(
        id: widget.observation?.id,
        objectName: _objectName,
        date: _date,
        time: DateFormat('HH:mm').format(_date),
        location: _location,
        equipment: _equipment,
        notes: _notes,
        rating: _rating,
      );

      if (widget.observation == null) {
        provider.addObservation(obs);
      } else {
        provider.updateObservation(obs);
      }
      Navigator.pop(context);
    }
  }
}
