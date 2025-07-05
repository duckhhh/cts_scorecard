// screens/penalty_form_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PenaltyFormScreen extends StatefulWidget {
  const PenaltyFormScreen({super.key});

  @override
  State<PenaltyFormScreen> createState() => _PenaltyFormScreenState();
}

class _PenaltyFormScreenState extends State<PenaltyFormScreen> {
  final List<Map<String, dynamic>> penalties = [
    {'clause': '1.1', 'desc': 'Cleaning of toilets not done', 'amount': 100},
    {
      'clause': '1.2',
      'desc': 'Toilet fittings not cleaned properly',
      'amount': 100,
    },
    {'clause': '1.3', 'desc': 'Mirror and basin not cleaned', 'amount': 50},
    {'clause': '1.4', 'desc': 'Floor not wiped or cleaned', 'amount': 100},
    {'clause': '1.5', 'desc': 'Dustbins not emptied/cleaned', 'amount': 50},
    {'clause': '2.1', 'desc': 'Vestibule not cleaned', 'amount': 100},
    {'clause': '2.2', 'desc': 'Doorway not wiped properly', 'amount': 50},
    {'clause': '2.3', 'desc': 'Insect repellant not sprayed', 'amount': 50},
    {'clause': '2.4', 'desc': 'Air freshener not used', 'amount': 50},
    {'clause': '3.1', 'desc': 'Supervision not done properly', 'amount': 200},
    {
      'clause': '3.2',
      'desc': 'Staff not in uniform/safety gear',
      'amount': 100,
    },
    {'clause': '4.1', 'desc': 'Complaint from passenger', 'amount': 200},
    {'clause': '5.1', 'desc': 'Train delayed due to cleaning', 'amount': 500},
  ];

  final Map<String, bool> selected = {};

  int get totalPenalty => selected.entries
      .where((entry) => entry.value)
      .map(
        (entry) =>
            penalties.firstWhere((p) => p['clause'] == entry.key)['amount']
                as int,
      )
      .fold(0, (a, b) => a + b);

  Future<void> _submitToMockApi(BuildContext context, List<Map<String, dynamic>> data) async {
  try {
    final response = await http.post(
      Uri.parse('https://httpbin.org/post'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'penalties': data}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data submitted to API successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit: ${response.statusCode}')),
      );
    }

    debugPrint('API Response: ${response.body}');
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error submitting to API: $e')),
    );
  }
}


  Future<void> _generatePdf(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoRegular();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Padding(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Penalty Submission Report',
                style: pw.TextStyle(font: font, fontSize: 18),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Clause', 'Description', 'Amount (₹)'],
                data: data
                    .map(
                      (e) => [e['clause'], e['description'], '₹${e['amount']}'],
                    )
                    .toList(),
                headerStyle: pw.TextStyle(
                  font: font,
                  fontWeight: pw.FontWeight.bold,
                ),
                cellStyle: pw.TextStyle(font: font),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Total Penalty: ₹$totalPenalty',
                style: pw.TextStyle(font: font),
              ),
            ],
          ),
        ),
      ),
    );

    // Works on iOS to open share menu
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'penalty_report.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Penalty Schedule Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment cum Penalty Schedule for Platform Return Trains',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildInteractiveTable(),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Penalty: ₹$totalPenalty',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final selectedPenalties = penalties
                    .where((p) => selected[p['clause']] == true)
                    .map(
                      (p) => {
                        'clause': p['clause'],
                        'description': p['desc'],
                        'amount': p['amount'],
                      },
                    )
                    .toList();

                if (selectedPenalties.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select at least one clause.'),
                    ),
                  );
                  return;
                }

                // Submit + Show success/failure
                await _submitToMockApi(context, selectedPenalties);

                // Export PDF
                await _generatePdf(selectedPenalties);
              },

              child: const Text('Submit & Export PDF'),
            ),
            const SizedBox(height: 20),
            const Text('Note:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text(
              'Penalty is deducted from running bills and based on observations during surprise inspections.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: [
        const TableRow(
          decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
          children: [
            Padding(padding: EdgeInsets.all(12.0), child: Text('S/N')),
            Padding(padding: EdgeInsets.all(12.0), child: Text('Clause')),
            Padding(padding: EdgeInsets.all(12.0), child: Text('Description')),
            Padding(padding: EdgeInsets.all(12.0), child: Text('Penalty (₹)')),
            Padding(padding: EdgeInsets.all(12.0), child: Text('Select')),
          ],
        ),
        ...penalties.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final data = entry.value;
          selected.putIfAbsent(data['clause'], () => false);
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(index.toString()),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(data['clause']),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(data['desc']),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('₹${data['amount']}'),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Checkbox(
                  value: selected[data['clause']],
                  onChanged: (val) =>
                      setState(() => selected[data['clause']] = val!),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
