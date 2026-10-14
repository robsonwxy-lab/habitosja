import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/habit.dart';

class NotificacionService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String canalId = 'habitosja_alarme_flutuante_v3';
  static const String canalNome = 'Despertador Oficial de Hábitos';

  static bool _inicializado = false;

  static Future<void> garantirInicializado() async {
    if (_inicializado) return;
    await inicializar();
    _inicializado = true;
  }

  static Future<void> init() async => inicializar();

  static Future<void> inicializar() async {
    tz.initializeTimeZones();

    // Sincroniza dinamicamente com o fuso horário exato do aparelho
    try {
      final now = DateTime.now();
      final offsetMs = now.timeZoneOffset.inMilliseconds;
      for (final loc in tz.timeZoneDatabase.locations.values) {
        if (loc.timeZone(now.millisecondsSinceEpoch).offset == offsetMs) {
          tz.setLocalLocation(loc);
          break;
        }
      }
    } catch (_) {}

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);

    final androidImplementation = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      // Cria canal com suporte nativo a NOTIFICAÇÃO FLUTUANTE e ALARME
      await androidImplementation.createNotificationChannel(
        const AndroidNotificationChannel(
          canalId,
          canalNome,
          description:
              'Alarmes com som alto, vibração e banner flutuante no topo',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        ),
      );
    }
  }

  static Future<void> solicitarPermissoes() async {
    await garantirInicializado();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android != null) {
      await android.requestNotificationsPermission();
      await android.requestExactAlarmsPermission();
    }
  }

  /// Calcula o horário exato em qualquer país
  static tz.TZDateTime _calcularHorarioDisparo(int hour, int minute) {
    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, hour, minute, 0);

    // Se o horário de hoje já passou, agenda para amanhã
    if (scheduled.isBefore(now.add(const Duration(seconds: 5)))) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final diferenca = scheduled.difference(now);
    return tz.TZDateTime.now(tz.local).add(diferenca);
  }

  /// Agenda o alarme sonoro, vibratório e com alerta flutuante
  static Future<void> agendarLembreteHabito(Habit habit) async {
    await garantirInicializado();
    final prefs = await SharedPreferences.getInstance();
    final String nomeUsuario = prefs.getString('user_name') ?? '';
    final String saudacao =
        nomeUsuario.trim().isNotEmpty ? '$nomeUsuario, ' : '';

    final int notifId = habit.id.hashCode;

    const androidDetails = AndroidNotificationDetails(
      canalId,
      canalNome,
      channelDescription: 'Alarme com som, vibração e banner flutuante',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true, // Acorda o ecrã se estiver bloqueado
      category: AndroidNotificationCategory.alarm,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      visibility: NotificationVisibility.public,
      ticker: 'Lembrete de Hábito',
    );

    final dataAgendada = _calcularHorarioDisparo(habit.hour, habit.minute);

    try {
      await _plugin.zonedSchedule(
        notifId,
        '⏰ ${saudacao}hora de: ${habit.name}!',
        '${habit.emoji} Mantenha a sua rotina em dia! Toque para concluir agora.',
        dataAgendada,
        const NotificationDetails(android: androidDetails),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint(
          "🔔 Despertador agendado para as ${habit.hour}:${habit.minute}");
    } catch (_) {
      // Fallback para dispositivos com restrição de alarmClock
      await _plugin.zonedSchedule(
        notifId,
        '⏰ ${saudacao}hora de: ${habit.name}!',
        '${habit.emoji} Mantenha a sua rotina em dia! Toque para concluir agora.',
        dataAgendada,
        const NotificationDetails(android: androidDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  static Future<void> sincronizarTodosOsHabitos(List<Habit> habitos) async {
    await garantirInicializado();
    for (var habito in habitos) {
      await agendarLembreteHabito(habito);
    }
  }

  static Future<void> testarAlarmeImediato() async => testarDisparoImediato();

  /// Teste duplo: banner flutuante imediato no ecrã + alarme sonoro em 10 segundos
  static Future<void> testarDisparoImediato() async {
    await garantirInicializado();
    final prefs = await SharedPreferences.getInstance();
    final String nome = prefs.getString('user_name') ?? 'Campeão';

    const androidDetails = AndroidNotificationDetails(
      canalId,
      canalNome,
      channelDescription: 'Alarme sonoro com notificação flutuante',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      visibility: NotificationVisibility.public,
    );

    // 1. Dispara banner flutuante no topo do ecrã
    await _plugin.show(
      888,
      '⏰ $nome, o Despertador Flutuante está FUNCIONANDO!',
      '🎉 Notificação flutuante, som alto e vibração ativos no telemóvel.',
      const NotificationDetails(android: androidDetails),
    );

    // 2. Programa alarme sonoro para 10 segundos à frente (para testar com ecrã bloqueado)
    final disparo10Segundos =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

    await _plugin.zonedSchedule(
      889,
      '⏰ $nome, ALARME DE TESTE (10 segundos)!',
      '🔔 O despertador acordou o telemóvel com som e vibração.',
      disparo10Segundos,
      const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelarLembreteHabito(String habitId) async {
    await garantirInicializado();
    await _plugin.cancel(habitId.hashCode);
  }
}
