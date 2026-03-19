// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../services/ai_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _duration = 1.0; 
  double _budget = 500.0;
  int _participants = 50;
  
  String _theme = 'Seminar& Workshop';
  String _location = 'Campus Hall';
  bool _isLoading = false;

  final List<String> _themes = [
    'Seminar& Workshop',
    'Competitions',
    'Charity Event',
    'Career Fair',
  ];
  final List<String> _locations = [
    'Campus Hall',
    'Classroom',
    'Outdoor Area',
    'Computer Lab',
  ];

  void _generateEventPlan() async {
    setState(() => _isLoading = true);

    try {
      
      final results = await Future.wait([
        AiService.generatePoster(
          _theme, 
          _location, 
          _budget
        ),
        AiService.generatePlanning(
          _theme,
          _duration,
          _budget,
          _participants,
          _location,
        ),
      ]);

    
      final Uint8List? imageBytes = results[0] as Uint8List?;
      final Map<String, dynamic> planData = results[1] as Map<String, dynamic>;

      if (!mounted) return;
      setState(() => _isLoading = false);

      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            imageBytes: imageBytes,
            planData: planData, 
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: _generateEventPlan,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Organizer Planner'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            
            DropdownButtonFormField<String>(
              value: _theme, 
              decoration: const InputDecoration(
                labelText: 'Event Theme', 
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event),
              ),
              items: _themes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) => setState(() => _theme = newValue!),
            ),
            const SizedBox(height: 20),

            
            DropdownButtonFormField<String>(
              value: _location, 
              decoration: const InputDecoration(
                labelText: 'Event Location', 
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              items: _locations.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) => setState(() => _location = newValue!),
            ),
            const SizedBox(height: 20),

          
            Text('Duration: ${_duration.toInt()} hours', 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Slider(
              value: _duration,
              min: 1,
              max: 24,
              divisions: 23,
              label: '${_duration.toInt()}h',
              onChanged: (val) => setState(() => _duration = val),
            ),

          
            Text('Budget: RM ${_budget.toInt()}', 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Slider(
              value: _budget,
              min: 0,
              max: 5000,
              divisions: 50,
              label: 'RM ${_budget.toInt()}',
              onChanged: (val) => setState(() => _budget = val),
            ),

            
            Text('Expected Participants: $_participants', 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Slider(
              value: _participants.toDouble(),
              min: 10,
              max: 500,
              divisions: 49,
              label: '$_participants people',
              onChanged: (val) => setState(() => _participants = val.toInt()),
            ),
            
            const SizedBox(height: 40),

            
            _isLoading
                ? const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('AI is creating your event plan...',
                            style: TextStyle(color: Colors.blueGrey)),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: _generateEventPlan,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Generate Event Plan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
