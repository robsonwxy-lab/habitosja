import 'dart:math';
import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';
import '../services/notificacion_service.dart';
import '../services/ad_service.dart'; // <-- IMPORTAÇÃO DO SERVIÇO DE ANÚNCIOS ADICIONADA AQUI
import 'habit_detail_screen.dart';
import 'schedule_screen.dart';
import 'premium_screen.dart';
import 'settings_screen.dart';

class _HomeLang {
  static String atual = 'pt';

  static const Map<String, Map<String, String>> _textos = {
    'pt': {
      'titulo': 'HábitosJá 🚀',
      'novo_habito': '✨ Criar Rotina / Hábito',
      'modelos_prontos': 'Modelos rápidos (toque para usar):',
      'nome_campo': 'Qual é a sua rotina?',
      'categoria': 'Categoria',
      'horario': 'Horário do Despertador',
      'cancelar': 'Cancelar',
      'adicionar': 'Salvar Rotina',
      'excluir_titulo': 'Excluir Hábito?',
      'excluir_msg':
          'Tem certeza que deseja apagar este hábito e cancelar o despertador?',
      'excluir': 'Excluir',
      'vazio_titulo': 'Nenhum hábito cadastrado!',
      'restaurar': 'Carregar Hábitos Recomendados',
      'agenda': 'Agenda & Horários',
      'premium': 'Premium & Assinatura',
      'config': 'Configurações',
      'progresso_hoje': 'Metas de Hoje Concluídas:',
      'dica_zero':
          '💡 Comece pelo primeiro da lista. Um passo já transforma o seu dia!',
      'dica_meio':
          '💡 Muito bem! Continue firme para fechar 100% das suas metas.',
      'dica_100': '🎉 Parabéns! Você concluiu todas as suas metas de hoje!',
    },
    'es': {
      'titulo': 'HábitosJá 🚀',
      'novo_habito': '✨ Crear Rutina / Hábito',
      'modelos_prontos': 'Modelos rápidos:',
      'nome_campo': '¿Cuál es tu rutina?',
      'categoria': 'Categoría',
      'horario': 'Horario de Alarma',
      'cancelar': 'Cancelar',
      'adicionar': 'Guardar Rutina',
      'excluir_titulo': '¿Eliminar Hábito?',
      'excluir_msg': '¿Estás seguro de que deseas eliminar este hábito?',
      'excluir': 'Eliminar',
      'vazio_titulo': '¡No hay hábitos!',
      'restaurar': 'Cargar Hábitos Recomendados',
      'agenda': 'Agenda y Horarios',
      'premium': 'Premium y Suscripción',
      'config': 'Configuraciones',
      'progresso_hoje': 'Metas de hoy completadas:',
      'dica_zero': '💡 Empieza por el primero. ¡El primer paso cuenta mucho!',
      'dica_meio': '💡 ¡Muy bien! Sigue adelante para cumplir todas tus metas.',
      'dica_100': '🎉 ¡Felicidades! ¡Completaste el 100% de tus metas hoy!',
    },
    'en': {
      'titulo': 'HábitosJá 🚀',
      'novo_habito': '✨ Create Routine / Habit',
      'modelos_prontos': 'Quick templates:',
      'nome_campo': 'What is your routine?',
      'categoria': 'Category',
      'horario': 'Alarm Time',
      'cancelar': 'Cancel',
      'adicionar': 'Save Routine',
      'excluir_titulo': 'Delete Habit?',
      'excluir_msg':
          'Are you sure you want to delete this habit and cancel its alarm?',
      'excluir': 'Delete',
      'vazio_titulo': 'No habits registered!',
      'restaurar': 'Load Recommended Habits',
      'agenda': 'Schedule & Times',
      'premium': 'Premium & Subscription',
      'config': 'Settings',
      'progresso_hoje': 'Today\'s Completed Goals:',
      'dica_zero': '💡 Start with the first one. Small steps build greatness!',
      'dica_meio': '💡 Great job! Keep going to hit 100% of your goals today.',
      'dica_100': '🎉 Awesome! You completed all your habits today!',
    },
  };

  static String t(String chave) {
    return _textos[atual]?[chave] ?? _textos['pt']![chave] ?? chave;
  }
}

class _ModeloRapido {
  final String nome;
  final String emoji;
  final String categoria;
  const _ModeloRapido(this.nome, this.emoji, this.categoria);
}

const _modelosProntos = <_ModeloRapido>[
  _ModeloRapido('Beber água (2L)', '💧', 'Saúde'),
  _ModeloRapido('Treinar / Exercício', '💪', 'Fitness'),
  _ModeloRapido('Ler 15 minutos', '📚', 'Estudos'),
  _ModeloRapido('Comer salada e verduras', '🥗', 'Saúde'),
  _ModeloRapido('Tomar remédio', '💊', 'Saúde'),
  _ModeloRapido('Tempo sem celular', '📵', 'Foco'),
  _ModeloRapido('Trabalhar nas metas', '💼', 'Trabalho'),
  _ModeloRapido('Dormir cedo', '😴', 'Sono'),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Habit>> _habitsFuture;

  @override
  void initState() {
    super.initState();
    _loadHabits();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificacionService.solicitarPermissoes();
    });
  }

  void _loadHabits() {
    setState(() {
      _habitsFuture = HabitService.getHabits().then((habitos) {
        NotificacionService.sincronizarTodosOsHabitos(habitos);
        return habitos;
      });
    });
  }

  bool _isCompletedToday(Habit habit) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return habit.completedDates.any((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);
  }

  Future<void> _alterarHorarioDireto(Habit habit) async {
    final novo = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: habit.hour, minute: habit.minute),
    );

    if (novo != null) {
      final habitAtualizado =
          habit.copyWith(hour: novo.hour, minute: novo.minute);
      await HabitService.updateHabit(habitAtualizado);
      await NotificacionService.agendarLembreteHabito(habitAtualizado);
      _loadHabits();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Horário atualizado para ${novo.hour.toString().padLeft(2, '0')}:${novo.minute.toString().padLeft(2, '0')}!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _excluirHabito(Habit habit) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(_HomeLang.t('excluir_titulo'),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          '${_HomeLang.t('excluir_msg')}\n\n"${habit.emoji} ${habit.name}"',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(_HomeLang.t('cancelar'),
                style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(_HomeLang.t('excluir'),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await NotificacionService.cancelarLembreteHabito(habit.id);
      await HabitService.deleteHabit(habit.id);
      _loadHabits();

      // <-- ANÚNCIO DISPARA AO EXCLUIR UM HÁBITO
      AdService.exibirInterstitial();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hábito "${habit.name}" excluído e alarme cancelado.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showAddHabitDialog(BuildContext context) {
    final nameController = TextEditingController();
    String selectedCategory = 'Geral';
    String selectedEmoji = '🚀';
    int hour = DateTime.now().hour;
    int minute = (DateTime.now().minute + 2) % 60;

    const categorias = [
      'Geral',
      'Saúde',
      'Fitness',
      'Estudos',
      'Trabalho',
      'Foco',
      'Finanças'
    ];
    const emojis = ['🚀', '💧', '💪', '📚', '🥗', '💊', '⚡', '🏃', '🎯', '😴'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: Text(_HomeLang.t('novo_habito'),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_HomeLang.t('modelos_prontos'),
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _modelosProntos.map((m) {
                    return ActionChip(
                      backgroundColor: const Color(0xFF0F172A),
                      label: Text('${m.emoji} ${m.nome}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11)),
                      onPressed: () {
                        setDialogState(() {
                          nameController.text = m.nome;
                          selectedEmoji = m.emoji;
                          selectedCategory = m.categoria;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: _HomeLang.t('nome_campo'),
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(_HomeLang.t('categoria'),
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
                DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white),
                  items: categorias
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDialogState(() => selectedCategory = v);
                  },
                ),
                const SizedBox(height: 10),
                const Text('Ícone:',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: emojis.map((e) {
                    final sel = selectedEmoji == e;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedEmoji = e),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: sel
                              ? Colors.deepPurpleAccent.withValues(alpha: 0.3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: sel
                                  ? Colors.deepPurpleAccent
                                  : Colors.transparent),
                        ),
                        child: Text(e, style: const TextStyle(fontSize: 22)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_HomeLang.t('horario'),
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold),
                  ),
                  trailing:
                      const Icon(Icons.access_time, color: Colors.blueAccent),
                  onTap: () async {
                    final t = await showTimePicker(
                      context: ctx,
                      initialTime: TimeOfDay(hour: hour, minute: minute),
                    );
                    if (t != null) {
                      setDialogState(() {
                        hour = t.hour;
                        minute = t.minute;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(_HomeLang.t('cancelar'),
                  style: const TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty) {
                  final newHabit = Habit(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    emoji: selectedEmoji,
                    category: selectedCategory,
                    hour: hour,
                    minute: minute,
                    createdAt: DateTime.now(),
                  );
                  await HabitService.addHabit(newHabit);
                  await NotificacionService.agendarLembreteHabito(newHabit);

                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  _loadHabits();

                  // <-- ANÚNCIO DISPARA APÓS CRIAR UM HÁBITO NOVO
                  AdService.exibirInterstitial();
                }
              },
              child: Text(_HomeLang.t('adicionar')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(
          _HomeLang.t('titulo'),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          DropdownButton<String>(
            value: _HomeLang.atual,
            dropdownColor: const Color(0xFF1E293B),
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(
                  value: 'pt',
                  child:
                      Text('🇧🇷 PT', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(
                  value: 'es',
                  child:
                      Text('🇪🇸 ES', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(
                  value: 'en',
                  child:
                      Text('🇺🇸 EN', style: TextStyle(color: Colors.white))),
            ],
            onChanged: (lang) {
              if (lang != null) setState(() => _HomeLang.atual = lang);
            },
          ),
          IconButton(
            icon: const Icon(Icons.schedule, color: Colors.blueAccent),
            tooltip: _HomeLang.t('agenda'),
            onPressed: () async {
              final habits = await HabitService.getHabits();
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScheduleScreen(habits: habits)),
              ).then((_) => _loadHabits());
            },
          ),
          IconButton(
            icon: const Icon(Icons.star, color: Colors.amber),
            tooltip: _HomeLang.t('premium'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PremiumScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            tooltip: _HomeLang.t('config'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ).then((_) => _loadHabits());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Habit>>(
        future: _habitsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator(color: Colors.deepPurpleAccent));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar hábitos: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.task_alt, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    _HomeLang.t('vazio_titulo'),
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final padroes = HabitService.getPreDefinedHabits();
                      await HabitService.saveHabits(padroes);
                      await NotificacionService.sincronizarTodosOsHabitos(
                          padroes);
                      _loadHabits();
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(_HomeLang.t('restaurar')),
                  ),
                ],
              ),
            );
          }

          final habits = snapshot.data!;
          final feitos = habits.where((h) => _isCompletedToday(h)).length;
          final total = habits.length;
          final pct = total == 0 ? 0.0 : feitos / total;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.deepPurpleAccent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _HomeLang.t('progresso_hoje'),
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$feitos de $total rotinas concluídas',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pct == 0.0
                                ? _HomeLang.t('dica_zero')
                                : (pct == 1.0
                                    ? _HomeLang.t('dica_100')
                                    : _HomeLang.t('dica_meio')),
                            style: const TextStyle(
                                color: Colors.blueAccent, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CustomPaint(
                        painter: _ProgressoRingPainter(pct),
                        child: Center(
                          child: Text(
                            '${(pct * 100).round()}%',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...habits.map((habit) {
                final isCompleted = _isCompletedToday(habit);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: const Color(0xFF1E293B),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isCompleted
                          ? Colors.greenAccent.withValues(alpha: 0.5)
                          : Colors.transparent,
                    ),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading:
                        Text(habit.emoji, style: const TextStyle(fontSize: 32)),
                    title: Text(
                      habit.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                        color: isCompleted ? Colors.grey : Colors.white,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text('Categoria: ${habit.category} • ',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                        InkWell(
                          onTap: () => _alterarHorarioDireto(habit),
                          child: Text(
                            '⏰ ${habit.hour.toString().padLeft(2, '0')}:${habit.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: isCompleted,
                          activeColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          onChanged: (bool? value) async {
                            await HabitService.toggleHabit(habit.id);
                            _loadHabits();

                            // <-- ANÚNCIO DISPARA AO CONCLUIR A TAREFA
                            if (value == true) {
                              AdService.exibirInterstitial();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent, size: 22),
                          tooltip: 'Excluir Hábito',
                          onPressed: () => _excluirHabito(habit),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HabitDetailScreen(habit: habit),
                        ),
                      ).then((_) => _loadHabits());
                    },
                  ),
                );
              }),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddHabitDialog(context),
      ),
    );
  }
}

class _ProgressoRingPainter extends CustomPainter {
  final double progress;
  _ProgressoRingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final fundo = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius, fundo);

    final arco = Paint()
      ..shader = const SweepGradient(
        colors: [Colors.blueAccent, Colors.deepPurpleAccent],
        transform: GradientRotation(-pi / 2),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, arco);
  }

  @override
  bool shouldRepaint(covariant _ProgressoRingPainter old) =>
      old.progress != progress;
}
