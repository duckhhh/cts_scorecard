// screens/bpb_station_info_screen.dart
import 'package:flutter/material.dart';

class BpbStationInfoScreen extends StatelessWidget {
  const BpbStationInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BPB Station Train Info')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('List of Through Passing Trains from AGTL Depot at BPB Stations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildWideTable([
              ['S/N', 'Train No', 'Train Name', 'Freq/Week', 'AC Coach', 'Non-AC Coach', 'Total Coach/Week', 'Arr', 'Dep', 'Halt (min)'],
              ['1', '20501', 'Tejas Rajdhani Express', '1', '20', '0', '20', '19:45', '19:55', '10'],
              ['2', '20502', 'Tejas Rajdhani Express', '1', '20', '0', '20', '11:20', '11:30', '10'],
              ['3', '12503', 'Humsafar Express', '2', '21', '21', '42', '21:10', '21:20', '10'],
              ['4', '12504', 'Humsafar Express', '2', '21', '21', '42', '09:50', '10:00', '10'],
              ['5', '07029', 'AGTL-SC Express', '1', '7', '21', '21', '10:50', '11:00', '10'],
              ['6', '07030', 'SC-AGTL Express', '1', '7', '21', '21', '21:55', '22:05', '10'],
              ['7', '12502', 'Kolkata Garib Rath Express', '1', '22', '22', '22', '11:50', '12:00', '10'],
              ['8', '12501', 'AGTL Garib Rath Express', '1', '22', '22', '22', '12:30', '12:40', '10'],
              ['9', '14619', 'AGTL-FZR Express', '1', '9', '22', '22', '19:45', '19:55', '10'],
              ['10', '14620', 'FZR-AGTL Express', '1', '9', '22', '22', '16:45', '16:55', '10'],
              ['11', '01665', 'RKMP-AGTL Festival SPL', '1', '6', '24', '24', '12:05', '12:15', '10'],
              ['12', '13173', 'KANCHANJUNGA EXP', '4', '6', '21', '84', '12:35', '12:45', '10'],
              ['13', '13174', 'KANCHANJUNGA EXP', '4', '6', '21', '84', '12:50', '13:00', '10'],
              ['14', '15664', 'SCL-AGTL PASS EXP', '7', '2', '20', '140', '09:40', '09:50', '10'],
              ['15', '15663', 'AGTL-SCL PASS EXP', '7', '2', '20', '140', '17:10', '17:20', '10'],
              ['16', '12519', 'LTT-AGTL AC SF Express', '1', '22', '22', '22', '12:05', '12:15', '10'],
              ['17', '12520', 'AGTL-LTT AC SF Express', '1', '22', '22', '22', '11:35', '11:45', '10'],
            ]),
          ),
          const SizedBox(height: 20),
          const Text('Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildTable([
            ['Total coach per week at BPB station', '770'],
            ['Total coaches per day considering exigency (5+11)', '121'],
            ['Total coaches in 3 years (1095 days)', '132495'],
          ]),
        ],
      ),
    );
  }

  Widget _buildWideTable(List<List<String>> rows) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: rows.map((row) => TableRow(
        decoration: rows.indexOf(row) == 0 ? const BoxDecoration(color: Color(0xFFE0E0E0)) : null,
        children: row.map((cell) => Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(cell, style: const TextStyle(fontSize: 13)),
        )).toList(),
      )).toList(),
    );
  }

  Widget _buildTable(List<List<String>> rows) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows.map((row) => TableRow(
        decoration: rows.indexOf(row) == 0 ? const BoxDecoration(color: Color(0xFFE0E0E0)) : null,
        children: row.map((cell) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(cell, style: const TextStyle(fontSize: 14)),
        )).toList(),
      )).toList(),
    );
  }
}
