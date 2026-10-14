import 'dart:math';

class GeminiService {
  // Motor nativo contextual: 100% offline, sem dependência de nuvem e sem risco na Google Play
  static final Map<String, List<String>> _frasesContextuais = {
    'agua': [
      'Hidratação é foco e energia! Beba água e revitalize o seu corpo agora.',
      'Cada copo de água é mais disposição e saúde para o seu dia.',
      'Mantenha o seu corpo hidratado para render ao máximo hoje!',
    ],
    'treino': [
      'A disciplina constrói o resultado que a motivação sozinha não alcança!',
      'O esforço de hoje é o orgulho de amanhã. Vá em frente e vença!',
      'Mais um treino concluído, mais um passo em direção à sua melhor versão!',
    ],
    'estudo': [
      'Conhecimento acumulado é poder. Foque no seu crescimento constante!',
      'A consistência diária nos estudos abre as portas mais difíceis do mundo.',
      'Aprender um pouco todos os dias transforma completamente o seu futuro.',
    ],
    'saude': [
      'Cuidar do seu corpo e da sua mente é o seu maior investimento.',
      'Pequenos hábitos diários constroem uma saúde forte e inabalável.',
      'Respeite o seu ritmo, mas nunca deixe de cuidar da sua saúde.',
    ],
    'sono': [
      'O descanso de hoje é o combustível para a sua vitória de amanhã.',
      'Desconecte-se dos ecrãs e garanta uma noite de sono reparadora.',
    ],
    'foco': [
      'Elimine as distrações e concentre-se no que realmente importa.',
      'Grandes objetivos exigem momentos de foco total. Mantenha o controle!',
    ],
    'geral': [
      'Grandes metas nascem de pequenos passos repetidos com determinação!',
      'A constância diária supera o talento. Continue firme nas suas metas!',
      'Você é o resultado dos hábitos que pratica todos os dias. Faça valer a pena!',
      'Mais um hábito cumprido! O sucesso é construído um dia de cada vez.',
    ],
  };

  /// Retorna instantaneamente uma frase contextual para o hábito sem chamada de rede externa
  static Future<String> getHabitMotivation(String habitName) async {
    final nomeLower = habitName.toLowerCase();
    final random = Random();

    for (var chave in _frasesContextuais.keys) {
      if (nomeLower.contains(chave)) {
        final lista = _frasesContextuais[chave]!;
        return lista[random.nextInt(lista.length)];
      }
    }

    final listaGeral = _frasesContextuais['geral']!;
    return listaGeral[random.nextInt(listaGeral.length)];
  }
}
