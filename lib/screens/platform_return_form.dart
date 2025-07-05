import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/form_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PlatformReturnForm extends StatelessWidget {
  const PlatformReturnForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FormProvider>(context);
    final tasks = [
      '1. Cleaning and wiping of toilet area, fittings, washbasins, mirrors, mugs in AC coaches',
      '2. Interior cleaning of compartments, doors, vestibules',
      '3. Berth panels, Rexene & amenity fittings',
      '4. Floor including under seats/berths',
      '5. Disposal of garbage',
    ];
    final columns = List.generate(11, (i) => 'C${i + 1}');

    return Scaffold(
      appBar: AppBar(title: const Text('Platform Return Cleaning Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field(context, 'Agreement No & Date', 'agreementNo'),
            _field(context, 'Train No', 'trainNo'),
            _field(context, 'Depot Name', 'depotName'),
            _field(context, 'Contractor Name', 'contractorName'),
            _field(context, 'Supervisor Name', 'supervisorName'),
            _field(context, 'Date of Inspection', 'inspectionDate'),
            _field(context, 'Time Work Started', 'startTime'),
            _field(context, 'Time Work Completed', 'endTime'),

            const SizedBox(height: 16),
            const Text(
              'Platform Return Cleaning Matrix',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                columns: [
                  const DataColumn(
                    label: SizedBox(
                      width: 350,
                      child: Text(
                        'Task',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ...columns.map(
                    (c) => DataColumn(
                      label: SizedBox(width: 60, child: Center(child: Text(c))),
                    ),
                  ),
                ],
                rows: tasks.map((task) {
                  return DataRow(
                    cells: [
                      DataCell(SizedBox(width: 350, child: Text(task))),
                      ...columns.map((col) {
                        final currentMatrix =
                            provider.platformReturnData['matrix'] ??
                            <String, Map<String, String>>{};
                        final row = currentMatrix[task] ?? {};
                        final value = row[col];
                        return DataCell(
                          SizedBox(
                            width: 60,
                            child: DropdownButton<String>(
                              value: value,
                              onChanged: (val) {
                                final updated =
                                    Map<String, Map<String, String>>.from(
                                      currentMatrix,
                                    );
                                updated[task] = Map<String, String>.from(
                                  updated[task] ?? {},
                                );
                                updated[task]![col] = val!;
                                provider.updatePlatformReturn(
                                  'matrix',
                                  updated,
                                );
                              },
                              items: const [
                                DropdownMenuItem(value: '3', child: Text('3')),
                                DropdownMenuItem(value: '2', child: Text('2')),
                                DropdownMenuItem(value: '1', child: Text('1')),
                                DropdownMenuItem(value: '0', child: Text('0')),
                              ],
                              isDense: true,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final data = provider.getFormattedPlatformReturn();

                // 🔄 Submit to mock API
                final response = await http.post(
                  Uri.parse('https://httpbin.org/post'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode(data),
                );
                debugPrint('API Response: ${response.body}');

                // 🧾 Generate and share PDF
                final font = await PdfGoogleFonts.nunitoRegular();
                final pdf = pw.Document();

                final matrix = Map<String, Map<String, String>>.from(
                  data['matrix'],
                );
                final headers = ['Task', ...matrix.values.first.keys];
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
                            'Platform Return Cleaning Report',
                            style: pw.TextStyle(font: font, fontSize: 18),
                          ),
                          pw.SizedBox(height: 12),
                          pw.Text(
                            'Train No: ${data['trainNo'] ?? ''}',
                            style: pw.TextStyle(font: font),
                          ),
                          pw.Text(
                            'Depot: ${data['depotName'] ?? ''}',
                            style: pw.TextStyle(font: font),
                          ),
                          pw.Text(
                            'Date: ${data['inspectionDate'] ?? ''}',
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
                        ],
                      ),
                    ),
                  ),
                );

                await Printing.sharePdf(
                  bytes: await pdf.save(),
                  filename: 'platform_return_report.pdf',
                );

                // ✅ Confirmation dialog
                showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    title: Text('Submitted'),
                    content: Text(
                      'Platform return form submitted and exported as PDF.',
                    ),
                  ),
                );
              },

              child: const Text('Submit'),
            ),
          ],
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
        onChanged: (val) => provider.updatePlatformReturn(key, val),
      ),
    );
  }
}
