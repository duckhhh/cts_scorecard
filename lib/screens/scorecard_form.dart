import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/form_provider.dart';
import '../widgets/section_header.dart';
import '../widgets/remarks_input.dart';
import '../widgets/submit_button.dart';
import '../widgets/score_input_matrix.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
//import 'package:pdf_google_fonts/pdf_google_fonts.dart';
import 'package:printing/printing.dart';

class ScoreCardForm extends StatelessWidget {
  const ScoreCardForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FormProvider>(context);
    final items = ['T1', 'T2', 'T3', 'T4', 'A1', 'B1', 'B2', 'D1', 'D2', 'E1'];
    final coaches = List.generate(13, (i) => 'C${i + 1}');
    final _formKey = GlobalKey<FormState>();

    bool validateMatrix(Map<String, Map<String, int>> scores, List<String> tasks, List<String> coaches) {
  for (var task in tasks) {
    for (var coach in coaches) {
      if (!(scores[task]?.containsKey(coach) ?? false)) {
        return false;
      }
    }
  }
  return true;
}


    return Scaffold(
      appBar: AppBar(title: const Text('Score Card - Clean Train Station')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader('Basic Details'),
              _field(context, 'W.O. No', 'woNo'),
              _field(context, 'Date', 'date'),
              _field(context, 'Name of Work', 'workName'),
              _field(context, 'Contractor Name', 'contractorName'),
              _field(context, 'Supervisor Name', 'supervisor'),
              _field(context, 'Designation', 'designation'),
              _field(context, 'Date of Inspection', 'inspectionDate'),
              _field(context, 'Train No', 'trainNo'),
              _field(context, 'Arrival Time', 'arrivalTime'),
              _field(context, 'Departure Time', 'departureTime'),
              _field(context, 'Total Coaches', 'totalCoaches'),
              _field(context, 'Coaches Attended', 'attendedCoaches'),

              const SectionHeader('Coach-wise Cleaning Scores'),
              ScoreInputMatrix(
                items: items,
                coaches: coaches,
                values: Map<String, Map<String, String>>.from(
                  provider.scoreCardData['matrix'] ?? {},
                ),
                onChanged: (item, coach, value) {
                  final matrix = Map<String, Map<String, String>>.from(
                    provider.scoreCardData['matrix'] ?? {},
                  );
                  matrix[item] = Map<String, String>.from(matrix[item] ?? {});
                  matrix[item]![coach] = value;
                  provider.updateScoreCard('matrix', matrix);
                },
              ),

              const SizedBox(height: 16),
              RemarksInput(
                onChanged: (val) => provider.updateScoreCard('remarks', val),
              ),
              const SizedBox(height: 24),
              SubmitButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all required fields'),
                      ),
                    );
                    return;
                  }

                  if (!validateMatrix(provider.scoreCardData['matrix'] ?? {}, items, coaches)) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Please fill all scores for all coaches and tasks.')),
  );
  return;
}


                  final data = provider.getFormattedScoreCard();

                  // 🔄 Submit to mock API
                  final response = await http.post(
                    Uri.parse('https://httpbin.org/post'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(data),
                  );
                  debugPrint('API Response: ${response.body}');

                  // 🧾 Generate and export PDF
                  final font = await PdfGoogleFonts.nunitoRegular();
                  final pdf = pw.Document();

                  final matrix = Map<String, Map<String, String>>.from(
                    data['matrix'],
                  );
                  final headers = [
                    'Item',
                    ...matrix.values.first.keys.toList(),
                  ];
                  final rows = matrix.entries.map((entry) {
                    return [entry.key, ...entry.value.values.toList()];
                  }).toList();

                  pdf.addPage(
                    pw.Page(
                      build: (context) => pw.Padding(
                        padding: const pw.EdgeInsets.all(24),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Score Card Report',
                              style: pw.TextStyle(font: font, fontSize: 18),
                            ),
                            pw.SizedBox(height: 12),
                            pw.Text(
                              'W.O. No: ${data['woNo'] ?? ''}',
                              style: pw.TextStyle(font: font),
                            ),
                            pw.Text(
                              'Date: ${data['date'] ?? ''}',
                              style: pw.TextStyle(font: font),
                            ),
                            pw.Text(
                              'Train No: ${data['trainNo'] ?? ''}',
                              style: pw.TextStyle(font: font),
                            ),
                            pw.SizedBox(height: 12),
                            pw.Table.fromTextArray(
                              headers: headers,
                              data: rows,
                              headerStyle: pw.TextStyle(
                                font: font,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              cellStyle: pw.TextStyle(font: font),
                            ),
                            if (data['remarks'] != null) ...[
                              pw.SizedBox(height: 20),
                              pw.Text(
                                'Remarks:',
                                style: pw.TextStyle(
                                  font: font,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                data['remarks'],
                                style: pw.TextStyle(font: font),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );

                  await Printing.sharePdf(
                    bytes: await pdf.save(),
                    filename: 'scorecard_report.pdf',
                  );

                  // ✅ Show confirmation
                  showDialog(
                    context: context,
                    builder: (_) => const AlertDialog(
                      title: Text('Submitted!'),
                      content: Text(
                        'Score card submitted and exported as PDF.',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(BuildContext context, String label, String key) {
    final provider = Provider.of<FormProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        onChanged: (val) => provider.updateScoreCard(key, val),
        validator: (val) =>
            val == null || val.trim().isEmpty ? 'Required' : null,
      ),
    );
  }
}
