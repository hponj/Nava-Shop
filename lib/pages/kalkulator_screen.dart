import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class KalkulatorScreen extends StatefulWidget {
  const KalkulatorScreen({super.key});
  @override
  State<KalkulatorScreen> createState() => _KalkulatorScreenState();
}

class _KalkulatorScreenState extends State<KalkulatorScreen> {
  final angkaPertamaController = TextEditingController();
  final angkaKeduaController = TextEditingController();
  String hasil = '0';

  void hitung(String operasi) {
    final angka1 = double.tryParse(
      angkaPertamaController.text.replaceAll(',', '.'),
    );
    final angka2 = double.tryParse(
      angkaKeduaController.text.replaceAll(',', '.'),
    );
    if (angka1 == null || angka2 == null) {
      setState(() => hasil = 'Masukkan dua angka');
      return;
    }
    if (operasi == '÷' && angka2 == 0) {
      setState(() => hasil = 'Tidak bisa dibagi nol');
      return;
    }
    final value = switch (operasi) {
      '+' => angka1 + angka2,
      '−' => angka1 - angka2,
      '×' => angka1 * angka2,
      _ => angka1 / angka2,
    };
    setState(
      () => hasil = value == value.roundToDouble()
          ? value.round().toString()
          : value.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    angkaPertamaController.dispose();
    angkaKeduaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalkulator')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  constraints: const BoxConstraints(minHeight: 150),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, Color(0xFF8181EC)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'HASIL PERHITUNGAN',
                        style: TextStyle(
                          color: Color(0xFFDCDCFF),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 28),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          hasil,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: angkaPertamaController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Angka pertama',
                            prefixIcon: Icon(Icons.looks_one_outlined),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: angkaKeduaController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Angka kedua',
                            prefixIcon: Icon(Icons.looks_two_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: ['+', '−', '×', '÷']
                      .map(
                        (op) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: op == '÷' ? 0 : 9),
                            child: FilledButton.tonal(
                              onPressed: () => hitung(op),
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(0, 58),
                              ),
                              child: Text(
                                op,
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
