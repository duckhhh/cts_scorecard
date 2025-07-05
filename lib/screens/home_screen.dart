import 'package:flutter/material.dart';
import 'scorecard_form.dart';
import 'platform_return_form.dart';
import 'chemical_tool_screen.dart';
import 'bpb_station_info.dart';
import 'penalty_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CTS Score Card Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavButton(context, '1. Score Card (En-route Trains)', const ScoreCardForm()),
            _buildNavButton(context, '2. Platform Return Form', const PlatformReturnForm()),
            _buildNavButton(context, '3. Chemical & Tools List', const ChemicalToolScreen()),
            _buildNavButton(context, '4. BPB Station Train Info', const BpbStationInfoScreen()),
            _buildNavButton(context, '5. Penalty Schedule Form', const PenaltyFormScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        ),
        child: Text(title),
      ),
    );
  }
}
