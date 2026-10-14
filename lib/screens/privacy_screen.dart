import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Política de Privacidade',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Política de Privacidade',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Última atualização: 06/09/2026',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 24),
            _Section(
              title: '1. Informações que Coletamos',
              content:
                  'O HábitoJá coleta os seguintes dados para fornecer uma melhor experiência:\n\n'
                  '• Hábitos e preferências do usuário\n'
                  '• Dados de progresso e conclusão de hábitos\n'
                  '• Configurações de notificações\n'
                  '• Dados de uso do aplicativo (anônimos)\n\n'
                  'Não coletamos informações pessoais identificáveis como nome, email ou telefone.',
            ),
            _Section(
              title: '2. Como Usamos seus Dados',
              content: 'Utilizamos seus dados para:\n\n'
                  '• Gerenciar seus hábitos e progresso\n'
                  '• Enviar lembretes e notificações\n'
                  '• Melhorar o aplicativo com base no uso\n'
                  '• Gerar estatísticas de desempenho\n\n'
                  'Todos os dados são armazenados localmente no seu dispositivo.',
            ),
            _Section(
              title: '3. Armazenamento e Segurança',
              content:
                  '• Seus dados são armazenados localmente usando SharedPreferences\n'
                  '• Não compartilhamos seus dados com terceiros\n'
                  '• Você pode excluir todos os dados a qualquer momento\n'
                  '• Dados de uso são anônimos e não te identificam',
            ),
            _Section(
              title: '4. Seus Direitos',
              content: 'Você tem o direito de:\n\n'
                  '• Acessar seus dados a qualquer momento\n'
                  '• Corrigir ou atualizar seus hábitos\n'
                  '• Excluir todos os seus dados\n'
                  '• Desativar notificações\n'
                  '• Revogar o consentimento do uso de dados',
            ),
            _Section(
              title: '5. Feedback e Contato',
              content: 'Para dúvidas, sugestões ou reclamações:\n\n'
                  '📧 Email: contato@habitoja.com\n'
                  '📱 App: Menu Configurações > Enviar Feedback\n\n'
                  'Responderemos em até 48 horas úteis.',
            ),
            _Section(
              title: '6. Atualizações desta Política',
              content: 'Esta política pode ser atualizada periodicamente. '
                  'Recomendamos revisar esta página regularmente para '
                  'se manter informado sobre como protegemos suas informações.',
            ),
            SizedBox(height: 24),
            Text(
              'Ao usar o HábitoJá, você concorda com esta política de privacidade.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF00E676),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
