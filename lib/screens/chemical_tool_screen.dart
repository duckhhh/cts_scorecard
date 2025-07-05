// screens/chemical_tool_screen.dart
import 'package:flutter/material.dart';

class ChemicalToolScreen extends StatelessWidget {
  const ChemicalToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chemical & Tool Inventory')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('I. CHEMICALS FOR CLEANING (Per Coach)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          _buildTable([
            ['S/N', 'Name of Chemical', 'Approved Brand', 'Qty/Coach (ml)'],
            ['1', 'PVC floor cleaning agent', 'Spiral / Eco Lab / AFC / Haylide', '50'],
            ['2', 'Ceramic & SS toilet fitting cleaner', 'Taski R1 / Taski R6 / Spiral HD', '50'],
            ['3', 'Glass cleaner (mirror, basin)', 'Taski R3 / OC glass / Eco lab', '20'],
            ['4', 'Disinfectants', 'TRIAD III / Antiback / Nimp', '10'],
            ['5', 'Air Freshener', 'Tased R5 / Chela / Haylide', '10'],
          ]),

          const SizedBox(height: 20),
          const Text('II. TOOLS & EQUIPMENTS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          _buildTable([
            ['S/N', 'Item', 'Unit', 'Qty/Month'],
            ['1', 'Spray Bottles (@2/workstation, replaced in 2 months)', 'Nos', '11'],
            ['2', 'Brush for door area (steel bristle)', 'Nos', '22'],
            ['3', 'Brush for toilet cleaning (mixed nylon/steel)', 'Nos', '22'],
            ['4', 'Broom (Coconut/Plastic)', 'Nos', '22'],
            ['5', 'Bucket/Tub (10 lt for mopping)', 'Nos', '3.67'],
            ['6', 'Floor Mopper (long handle + PVA sponge)', 'Nos', '3.67'],
            ['7', 'Cotton Duster for basin cleaning (45×45cm)', 'Nos', '88'],
            ['8', 'Khadi Cotton Duster (48×48cm)', 'Nos', '88'],
            ['9', 'Disposal Bags (20×30”, 80 microns)', 'Kg', '36.80'],
            ['10', 'Passenger Feedback Expenses', '—', '—'],
            ['11', 'Stationery & Scorecard Printing', '—', '—'],
          ]),

          const SizedBox(height: 20),
          const Text('III. STAFF CONSUMABLES', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          _buildTable([
            ['S/N', 'Item', 'Unit', 'Qty'],
            ['1', 'Gum Boot (1 pair/staff/year)', 'Pair', '3'],
            ['2', 'Coverall (2 sets/staff/year)', 'Sets', '6'],
            ['3', 'Cap (2 nos/person/year)', 'Nos', '6'],
            ['4', 'Rain Suit (1 set/person/year)', 'Sets', '3'],
            ['5', 'Goggles (1 no/person/year)', 'Nos', '3'],
            ['6', 'Ebonite Name Plate (1/person/year)', 'Nos', '3'],
            ['7', 'Cotton Masks (1 per staff/month)', 'Nos', '36'],
            ['8', 'Orange Gloves (1 per staff/month)', 'Nos', '36'],
          ]),
        ],
      ),
    );
  }

  Widget _buildTable(List<List<String>> rows) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FixedColumnWidth(40),
      },
      children: rows.map((row) => TableRow(
        decoration: rows.indexOf(row) == 0
            ? const BoxDecoration(color: Color(0xFFE0E0E0))
            : null,
        children: row.map((cell) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(cell, style: const TextStyle(fontSize: 14)),
        )).toList(),
      )).toList(),
    );
  }
}
