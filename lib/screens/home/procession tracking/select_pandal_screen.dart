import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/tracking_repository.dart';
import 'track_pandals.dart';

class SelectPandalScreen extends StatefulWidget {
  const SelectPandalScreen({super.key});

  @override
  State<SelectPandalScreen> createState() => _SelectPandalScreenState();
}

class _SelectPandalScreenState extends State<SelectPandalScreen> {
  final _repo = TrackingRepository.instance;
  Future<List<Pandal>>? _futurePandals;
  Pandal? _selectedPandal;
  String _mode = 'aagman';

  @override
  void initState() {
    super.initState();
    _futurePandals = _repo.fetchPandals();
  }

  void _proceed() {
    if (_selectedPandal == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapSample(
          pandal: _selectedPandal!,
          mode: _mode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Pandal',
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD2691E),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Which pandal do you want to track?'),
            const SizedBox(height: 8),
            FutureBuilder<List<Pandal>>(
              future: _futurePandals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Failed to load: ${snapshot.error}');
                }
                final items = snapshot.data ?? const <Pandal>[];
                return DropdownButtonFormField<Pandal>(
                  decoration: const InputDecoration(hintText: 'Select Pandal'),
                  value: _selectedPandal,
                  items: items
                      .map(
                        (p) => DropdownMenuItem<Pandal>(
                          value: p,
                          child: Text(p.name),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() => _selectedPandal = val);
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('What do you want to track?'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(hintText: 'Select Mode'),
              value: _mode,
              items: const [
                DropdownMenuItem(value: 'aagman', child: Text('Aagman')),
                DropdownMenuItem(value: 'visarjan', child: Text('Visarjan')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _mode = val);
              },
            ),
            const SizedBox(height: 20,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedPandal == null ? null : _proceed,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


