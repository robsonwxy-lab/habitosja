import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/notificacion_service.dart';
import 'premium_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const String packageId = 'com.djst.habitosja';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=$packageId';

  String _userName = '';

  @override
  void initState() {
    super.initState();
    _carregarNome();
  }

  Future<void> _carregarNome() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _userName = prefs.getString('user_name') ?? '';
      });
    }
  }

  Future<void> _editarNome() async {
    final controller = TextEditingController(text: _userName);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Como quer ser chamado?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Digite seu nome (Ex: Robson)',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.greenAccent)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text('Cancelar', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('user_name', controller.text.trim());
              if (!mounted) return;
              setState(() => _userName = controller.text.trim());
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Nome atualizado para: $_userName!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Salvar',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _abrirUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir o link: $e')),
        );
      }
    }
  }

  void _compartilharApp() {
    const String texto =
        'Organize suas metas e hábitos diários com o app HábitosJá! Baixe agora na Google Play Store: $playStoreUrl';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Compartilhar HábitosJá',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.greenAccent),
              title: const Text('Enviar via WhatsApp',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _abrirUrl(
                    'https://api.whatsapp.com/send?text=${Uri.encodeComponent(texto)}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.blueAccent),
              title: const Text('Copiar Link Oficial da Play Store',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Clipboard.setData(const ClipboardData(text: playStoreUrl));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Link copiado com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
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
        title: const Text('Configurações & Perfil',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Perfil do Usuário',
              style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 8),
          _itemTile(
            Icons.person,
            'Seu Nome',
            _userName.isEmpty ? 'Toque para cadastrar seu nome' : _userName,
            onTap: _editarNome,
          ),
          const SizedBox(height: 20),
          const Text('Despertador & Alarmes',
              style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 8),
          _itemTile(
            Icons.alarm,
            'Testar Despertador Agora',
            'Toque para disparar o alarme sonoro com som e vibração',
            onTap: () async {
              await NotificacionService.testarAlarmeImediato();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🔔 Despertador acionado com sucesso!'),
                  backgroundColor: Colors.deepPurpleAccent,
                  duration: Duration(seconds: 4),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text('Planos & Monetização',
              style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 8),
          _itemTile(
            Icons.star,
            'Planos Mensal & Vitalício',
            'Ativar assinatura ou compra única sem anúncios',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PremiumScreen()),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text('Comunidade & Loja',
              style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 8),
          _itemTile(
            Icons.star_rate_rounded,
            'Avalie na Play Store',
            'Ajude o HábitosJá a crescer no ranking mundial',
            onTap: () => _abrirUrl(playStoreUrl),
          ),
          _itemTile(
            Icons.share,
            'Compartilhar Aplicativo',
            'Envie o link oficial para amigos via WhatsApp',
            onTap: _compartilharApp,
          ),
          _itemTile(
            Icons.mail,
            'Suporte do Desenvolvedor',
            'robsonwxy@gmail.com',
            onTap: () => _abrirUrl(
                'mailto:robsonwxy@gmail.com?subject=Suporte HábitosJá'),
          ),
        ],
      ),
    );
  }

  Widget _itemTile(IconData icon, String title, String subtitle,
      {required VoidCallback onTap}) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.greenAccent),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: Colors.white60, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white30),
        onTap: onTap,
      ),
    );
  }
}
