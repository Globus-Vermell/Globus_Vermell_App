import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _modoAltoContraste = true;
  bool _modoOscuro = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Configuració',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSwitch(
                titulo: "Modo alto contraste",
                valor: _modoAltoContraste,
                onChanged: (val) => setState(() => _modoAltoContraste = val),
              ),
              const SizedBox(height: 15),
              _buildSwitch(
                titulo: "Modo Oscuro",
                valor: _modoOscuro,
                onChanged: (val) => setState(() => _modoOscuro = val),
              ),
              const SizedBox(height: 15),
              _buildDesplegable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitch({required String titulo, required bool valor, required ValueChanged<bool> onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SwitchListTile(
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w500)),
        value: valor,
        onChanged: onChanged,
        activeThumbColor: Colors.redAccent,
      ),
    );
  }

  Widget _buildDesplegable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.cyanAccent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        shape: const Border(),
        title: const Text("Idioma", style: TextStyle(fontWeight: FontWeight.w500)),
        children: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Wow"),
          ),
        ],
      ),
    );
  }
}