import 'package:flutter/material.dart';

class ScoreInputMatrix extends StatelessWidget {
  final List<String> items; // A1 to E1
  final List<String> coaches; // C1 to C13
  final Map<String, Map<String, String>> values;
  final void Function(String item, String coach, String value) onChanged;

  const ScoreInputMatrix({
    super.key,
    required this.items,
    required this.coaches,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          const DataColumn(label: Text('Item')),
          ...coaches.map((c) => DataColumn(label: Text(c))),
        ],
        rows: items.map((item) {
          return DataRow(
            cells: [
              DataCell(Text(item)),
              ...coaches.map((coach) => DataCell(
                SizedBox(
                  width: 50,
                  child: DropdownButtonFormField<String>(
                    isDense: true,
                    value: values[item]?[coach],
                    onChanged: (val) => onChanged(item, coach, val ?? ''),
                    items: const [
                      DropdownMenuItem(value: '0', child: Text('0')),
                      DropdownMenuItem(value: '1', child: Text('1')),
                      DropdownMenuItem(value: 'x', child: Text('x')),
                    ],
                  ),
                ),
              )),
            ],
          );
        }).toList(),
      ),
    );
  }
}