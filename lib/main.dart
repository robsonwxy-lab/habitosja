import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/notificacion_service.dart';
import 'services/ad_service.dart'; // <-- IMPORTAÇÃO DO SERVIÇO DE ANÚNCIOS
import 'screens/home_screen.dart';

void main() async {
  // Garante que os bindings do Flutter estejam prontos antes de chamar serviços nativos
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com segurança protegida
  try {
    await Firebase.initializeApp();
    debugPrint('🔥 Firebase inicializado com sucesso!');
  } catch (e) {
    debugPrint('⚠️ Erro ao inicializar Firebase: $e');
  }

  // Inicializa o serviço de notificações e alarmes
  try {
    await NotificacionService.inicializar();
    debugPrint('🔔 Notificações inicializadas com sucesso!');
  } catch (e) {
    debugPrint('⚠️ Erro ao inicializar notificações: $e');
  }

  // Inicializa o motor de anúncios Unity LevelPlay (LIGA O MOTOR)
  try {
    await AdService.inicializar();
    debugPrint('🔥 Anúncios inicializados com sucesso!');
  } catch (e) {
    debugPrint('⚠️ Erro ao inicializar anúncios: $e');
  }

  runApp(const HabitosJaApp());
}

class HabitosJaApp extends StatelessWidget {
  const HabitosJaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HábitosJá',
      debugShowCheckedModeBanner: false,
      // Tema moderno e escuro (estilo 10 estrelas)
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor:
            const Color(0xFF0F172A), // Fundo azul escuro moderno
        cardColor: const Color(0xFF1E293B),
        useMaterial3: true,
      ), // ThemeData
      home: const HomeScreen(),
    ); // MaterialApp
  }
}
