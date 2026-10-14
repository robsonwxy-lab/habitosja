import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';
import '../services/notificacion_service.dart';

class ScheduleScreen extends StatefulWidget {
  final List<Habit> habits;
  const ScheduleScreen({super.key, required this.habits});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late List<Habit> _habits;

  @override
  void initState() {
    super.initState();
    _habits = List.from(widget.habits);
  }

  Future<void> _alterarHorario(Habit habit) async {
    final TimeOfDay? novo = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: habit.hour, minute: habit.minute),
    );

    if (novo != null) {
      final habitAtualizado =
          habit.copyWith(hour: novo.hour, minute: novo.minute);
      // Salva no SharedPreferences
      await HabitService.updateHabit(habitAtualizado);
      // Reagenda o despertador na hora exata
      await NotificacionService.agendarLembreteHabito(habitAtualizado);

      setState(() {
        final index = _habits.indexWhere((h) => h.id == habit.id);
        if (index != -1) _habits[index] = habitAtualizado;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Horário de "${habit.name}" alterado para ${novo.hour.toString().padLeft(2, '0')}:${novo.minute.toString().padLeft(2, '0')}!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Agenda de Hábitos',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: _habits.isEmpty
          ? const Center(
              child: Text('Nenhum hábito cadastrado.',
                  style: TextStyle(color: Colors.white70)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _habits.length,
              itemBuilder: (ctx, i) {
                final h = _habits[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: const Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading:
                        Text(h.emoji, style: const TextStyle(fontSize: 28)),
                    title: Text(h.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    subtitle: Text('Categoria: ${h.category}',
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 13)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _alterarHorario(h),
                      child: Text(
                        '${h.hour.toString().padLeft(2, '0')}:${h.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
