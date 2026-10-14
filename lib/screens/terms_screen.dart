import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Termos de Uso',
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
              'Termos de Uso',
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
            _TermSection(
              title: '1. Aceitação dos Termos',
              content:
                  'Ao usar o HábitoJá, você concorda com estes termos de uso. '
                  'Se você não concorda, não use o aplicativo.',
            ),
            _TermSection(
              title: '2. Uso do Aplicativo',
              content: 'O HábitoJá é um aplicativo de uso pessoal. '
                  'Você é responsável por suas atividades e dados dentro do app. '
                  'Não use o aplicativo para fins ilegais ou prejudiciais.',
            ),
            _TermSection(
              title: '3. Propriedade Intelectual',
              content: 'Todo o conteúdo, design, código e funcionalidades do '
                  'HábitoJá são propriedade da HábitoJá Tecnologia e Inovação. '
                  'Não é permitido copiar, modificar ou distribuir sem autorização.',
            ),
            _TermSection(
              title: '4. Privacidade',
              content:
                  'Seus dados são armazenados localmente no seu dispositivo. '
                  'Não compartilhamos seus dados com terceiros. '
                  'Consulte nossa Política de Privacidade para mais detalhes.',
            ),
            _TermSection(
              title: '5. Limitação de Responsabilidade',
              content: 'O HábitoJá é fornecido "como está". '
                  'Não garantimos que o aplicativo atenderá a todas as suas necessidades '
                  'ou que será livre de erros. Use por sua conta e risco.',
            ),
            _TermSection(
              title: '6. Alterações nos Termos',
              content: 'Podemos atualizar estes termos periodicamente. '
                  'Notificaremos sobre mudanças significativas através do aplicativo. '
                  'O uso contínuo do app constitui aceitação dos novos termos.',
            ),
            _TermSection(
              title: '7. Contato',
              content: 'Para dúvidas sobre estes termos, entre em contato:\n'
                  '📧 contato@habitoja.com',
            ),
            SizedBox(height: 24),
            Text(
              'Ao usar o HábitoJá, você concorda com estes termos de uso.',
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

class _TermSection extends StatelessWidget {
  final String title;
  final String content;

  const _TermSection({
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
