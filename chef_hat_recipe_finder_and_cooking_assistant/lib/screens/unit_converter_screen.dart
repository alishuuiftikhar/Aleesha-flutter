import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  double _inputValue = 1.0;
  String _fromUnit = 'Grams';
  String _toUnit = 'Ounces';
  double _result = 0.035;

  final Map<String, double> _conversions = {
    'Grams to Ounces': 0.035274,
    'Ounces to Grams': 28.3495,
    'Liters to Cups': 4.22675,
    'Cups to Liters': 0.236588,
    'Celsius to Fahrenheit': 1.8, // (C * 1.8) + 32
    'Fahrenheit to Celsius': 0.555, // (F - 32) * 0.555
  };

  void _calculate() {
    setState(() {
      String key = '$_fromUnit to $_toUnit';
      if (key == 'Celsius to Fahrenheit') {
        _result = (_inputValue * 1.8) + 32;
      } else if (key == 'Fahrenheit to Celsius') {
        _result = (_inputValue - 32) * 5 / 9;
      } else if (_conversions.containsKey(key)) {
        _result = _inputValue * _conversions[key]!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kitchen Tools')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Unit Converter', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Quickly convert weights, volumes, and temperatures for your recipes.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Value',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      prefixIcon: const Icon(Icons.calculate_outlined),
                    ),
                    onChanged: (val) {
                      _inputValue = double.tryParse(val) ?? 0.0;
                      _calculate();
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _fromUnit,
                          items: ['Grams', 'Ounces', 'Liters', 'Cups', 'Celsius', 'Fahrenheit']
                              .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                              .toList(),
                          onChanged: (val) {
                            setState(() => _fromUnit = val!);
                            _calculate();
                          },
                          decoration: const InputDecoration(labelText: 'From'),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Icon(Icons.swap_horiz, color: Colors.blue)),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _toUnit,
                          items: ['Grams', 'Ounces', 'Liters', 'Cups', 'Celsius', 'Fahrenheit']
                              .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                              .toList(),
                          onChanged: (val) {
                            setState(() => _toUnit = val!);
                            _calculate();
                          },
                          decoration: const InputDecoration(labelText: 'To'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text('Result', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text(
                    '${_result.toStringAsFixed(2)} $_toUnit',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppTheme.accentOrange),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            const Text('Common Substitutions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _subItem('1 Egg', '1/4 cup Applesauce'),
            _subItem('1 cup Butter', '1 cup Greek Yogurt'),
            _subItem('1 tsp Baking Powder', '1/4 tsp Soda + 1/2 tsp Cream of Tartar'),
          ],
        ),
      ),
    );
  }

  Widget _subItem(String original, String sub) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(original, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Substitute with: $sub'),
        trailing: const Icon(Icons.info_outline, size: 16),
      ),
    );
  }
}
