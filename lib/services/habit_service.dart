import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class HabitService {
  static const String _storageKey = 'habitosja_dados_oficial_v3';

  static List<Habit> getPreDefinedHabits() {
    final now = DateTime.now();
    return [
      Habit(
          id: '1',
          name: 'Estudar',
          emoji: '📚',
          category: 'Estudo',
          hour: 8,
          minute: 0,
          createdAt: now),
      Habit(
          id: '2',
          name: 'Trabalhar',
          emoji: '💼',
          category: 'Trabalho',
          hour: 9,
          minute: 0,
          createdAt: now),
      Habit(
          id: '3',
          name: 'Academia Treino 1',
          emoji: '🏋️',
          category: 'Fitness',
          hour: 7,
          minute: 0,
          createdAt: now),
      Habit(
          id: '4',
          name: 'Saúde',
          emoji: '❤️',
          category: 'Saúde',
          hour: 7,
          minute: 30,
          createdAt: now),
      Habit(
          id: '5',
          name: 'Acordar',
          emoji: '⏰',
          category: 'Saúde',
          hour: 6,
          minute: 0,
          createdAt: now),
      Habit(
          id: '6',
          name: 'Alimentação',
          emoji: '🥗',
          category: 'Saúde',
          hour: 12,
          minute: 0,
          createdAt: now),
      Habit(
          id: '7',
          name: 'Sem Celular',
          emoji: '📵',
          category: 'Saúde',
          hour: 22,
          minute: 0,
          createdAt: now),
      Habit(
          id: '8',
          name: 'Dormir',
          emoji: '🌙',
          category: 'Saúde',
          hour: 23,
          minute: 0,
          createdAt: now),
    ];
  }

  static Future<List<Habit>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null || jsonString.isEmpty) {
      final padroes = getPreDefinedHabits();
      await saveHabits(padroes);
      return padroes;
    }
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded
          .map((item) => Habit.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      final padroes = getPreDefinedHabits();
      await saveHabits(padroes);
      return padroes;
    }
  }

  static Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(habits.map((h) => h.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  static Future<void> addHabit(Habit habit) async {
    final habits = await getHabits();
    habits.removeWhere((h) => h.id == habit.id);
    habits.add(habit);
    await saveHabits(habits);
  }

  static Future<void> updateHabit(Habit habit) async {
    final habits = await getHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      habits[index] = habit;
      await saveHabits(habits);
    }
  }

  static Future<void> deleteHabit(String id) async {
    final habits = await getHabits();
    habits.removeWhere((h) => h.id == id);
    await saveHabits(habits);
  }

  static Future<void> toggleHabit(String id) async {
    final habits = await getHabits();
    final index = habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      final habit = habits[index];
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final List<DateTime> updatedDates = List.from(habit.completedDates);

      final jaConcluido = updatedDates.any((d) =>
          d.year == today.year && d.month == today.month && d.day == today.day);

      if (jaConcluido) {
        updatedDates.removeWhere((d) =>
            d.year == today.year &&
            d.month == today.month &&
            d.day == today.day);
      } else {
        updatedDates.add(today);
      }

      habits[index] = habit.copyWith(completedDates: updatedDates);
      await saveHabits(habits);
    }
  }
}
