import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class AppTranslations {
  static String idiomaAtual = 'pt';

  static const Map<String, Map<String, String>> _dicionario = {
    'pt': {
      'app_title': 'HábitosJá: Metas e Rotina',
      'novo_habito': 'Novo Hábito',
      'horario': 'Horário',
      'cancelar': 'Cancelar',
      'salvar': 'Salvar',
      'progresso_hoje': 'Progresso de Hoje',
      'alarme_msg': 'Hora de cuidar de você!',
    },
    'en': {
      'app_title': 'HábitosJá: Habits & Routine',
      'novo_habito': 'New Habit',
      'horario': 'Time',
      'cancelar': 'Cancel',
      'salvar': 'Save',
      'progresso_hoje': 'Today\'s Progress',
      'alarme_msg': 'Time to focus on your goal!',
    },
    'es': {
      'app_title': 'HábitosJá: Metas y Rutinas',
      'novo_habito': 'Nuevo Hábito',
      'horario': 'Horario',
      'cancelar': 'Cancelar',
      'salvar': 'Guardar',
      'progresso_hoje': 'Progreso de Hoy',
      'alarme_msg': '¡Hora de tu hábito!',
    },
    'fr': {
      'app_title': 'HábitosJá: Habitudes & Routine',
      'novo_habito': 'Nouvelle Habitude',
      'horario': 'Heure',
      'cancelar': 'Annuler',
      'salvar': 'Enregistrer',
      'progresso_hoje': 'Progrès du Jour',
      'alarme_msg': 'C\'est l\'heure de votre habitude!',
    },
    'de': {
      'app_title': 'HábitosJá: Gewohnheiten & Routine',
      'novo_habito': 'Neue Gewohnheit',
      'horario': 'Uhrzeit',
      'cancelar': 'Abbrechen',
      'salvar': 'Speichern',
      'progresso_hoje': 'Heutiger Fortschritt',
      'alarme_msg': 'Zeit für deine Gewohnheit!',
    },
    'it': {
      'app_title': 'HábitosJá: Abitudini e Routine',
      'novo_habito': 'Nuova Abitudine',
      'horario': 'Orario',
      'cancelar': 'Annulla',
      'salvar': 'Salva',
      'progresso_hoje': 'Progressi di Oggi',
      'alarme_msg': 'È ora della tua abitudine!',
    },
    'ja': {
      'app_title': 'HábitosJá: 習慣とルーティン',
      'novo_habito': '新しい習慣',
      'horario': '時間',
      'cancelar': 'キャンセル',
      'salvar': '保存',
      'progresso_hoje': '今日の進捗',
      'alarme_msg': '習慣の時間です！',
    },
    'zh': {
      'app_title': 'HábitosJá: 习惯与目标',
      'novo_habito': '新建习惯',
      'horario': '时间',
      'cancelar': '取消',
      'salvar': '保存',
      'progresso_hoje': '今日进度',
      'alarme_msg': '培养习惯的时间到了！',
    },
    'ru': {
      'app_title': 'HábitosJá: Привычки и Цели',
      'novo_habito': 'Новая привычка',
      'horario': 'Время',
      'cancelar': 'Отмена',
      'salvar': 'Сохранить',
      'progresso_hoje': 'Прогресс за сегодня',
      'alarme_msg': 'Время вашей привычки!',
    },
    'ar': {
      'app_title': 'HábitosJá: العادات والروتين',
      'novo_habito': 'عادة جديدة',
      'horario': 'الوقت',
      'cancelar': 'إلغاء',
      'salvar': 'حفظ',
      'progresso_hoje': 'تقدم اليوم',
      'alarme_msg': 'حان وقت عادتك!',
    },
  };

  static Future<void> carregarIdioma() async {
    final prefs = await SharedPreferences.getInstance();
    final salvo = prefs.getString('app_lang');

    if (salvo != null) {
      idiomaAtual = salvo;
    } else {
      final codigo =
          PlatformDispatcher.instance.locale.languageCode.toLowerCase();
      idiomaAtual = _dicionario.containsKey(codigo) ? codigo : 'en';
    }
  }

  static String t(String chave) {
    return _dicionario[idiomaAtual]?[chave] ??
        _dicionario['en']?[chave] ??
        chave;
  }
}
