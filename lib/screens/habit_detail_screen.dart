import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  late TextEditingController _nameController;
  late int _hour;
  late int _minute;
  late List<bool> _weekDays; // [Dom, Seg, Ter, Qua, Qui, Sex, Sáb]
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _hour = widget.habit.hour;
    _minute = widget.habit.minute;
    _weekDays = [true, true, true, true, true, true, true];
    _selectedDate = widget.habit.createdAt;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Seletor de Horário
  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour, minute: _minute),
    );
    if (picked != null) {
      setState(() {
        _hour = picked.hour;
        _minute = picked.minute;
      });
    }
  }

  // Seletor de Data
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Enviar link oficial da Google Play Store via WhatsApp
  Future<void> _shareDownloadLink() async {
    const String playStoreUrl =
        "https://play.google.com/store/apps/details?id=com.djst.habitosja";
    final Uri whatsappUri = Uri.parse(
      "https://api.whatsapp.com/send?text=Baixe%20o%20HabitoJá%20e%20organize%20sua%20rotina%20direto%20na%20Google%20Play:%20$playStoreUrl",
    );

    try {
      if (await launchUrl(whatsappUri, mode: LaunchMode.externalApplication)) {
        debugPrint('✅ Link da Play Store compartilhado com sucesso!');
      } else {
        debugPrint('❌ Não foi possível abrir o link.');
      }
    } catch (e) {
      debugPrint('❌ Erro ao disparar link: $e');
    }
  }

  Future<void> _saveChanges() async {
    final updatedHabit = widget.habit.copyWith(
      name: _nameController.text.trim(),
      hour: _hour,
      minute: _minute,
      createdAt: _selectedDate,
    );

    await HabitService.updateHabit(updatedHabit);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Editar Hábito', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.greenAccent),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome do Hábito
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                labelText: 'Nome do Hábito',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Controle de Horário
            const Text(
              '⏰ Horário do Alarme',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading:
                    const Icon(Icons.access_time, color: Colors.blueAccent),
                title: Text(
                  '${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                trailing: const Icon(Icons.edit, color: Colors.white70),
                onTap: () => _pickTime(context),
              ),
            ),
            const SizedBox(height: 20),

            // Controle de Data
            const Text(
              '📅 Data de Início / Referência',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.amber),
                title: Text(
                  '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                trailing: const Icon(Icons.edit, color: Colors.white70),
                onTap: () => _pickDate(context),
              ),
            ),
            const SizedBox(height: 20),

            // Dias da Semana
            const Text(
              '🔄 Repetição nos Dias da Semana',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb']
                  .asMap()
                  .entries
                  .map((entry) {
                int idx = entry.key;
                String day = entry.value;
                bool isSelected = _weekDays[idx];

                return FilterChip(
                  label: Text(day),
                  selected: isSelected,
                  selectedColor: Colors.deepPurpleAccent,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70),
                  backgroundColor: const Color(0xFF1E293B),
                  onSelected: (bool selected) {
                    setState(() {
                      _weekDays[idx] = selected;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Botão para Compartilhar App (Google Play) via WhatsApp
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _shareDownloadLink,
                icon: const Icon(Icons.share),
                label: const Text(
                  'Compartilhar App (Google Play)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
