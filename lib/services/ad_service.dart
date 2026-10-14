import 'package:flutter/foundation.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';

class AdService {
  // Chave oficial do HábitosJá no LevelPlay
  static const String appKey = '27efa6c65';

  static bool isInitialized = false;
  static LevelPlayInterstitialAd? _interstitialAd;

  // Ouvinte de inicialização
  static final LevelPlayInitListener _initListener = _AdInitListener();

  /// Inicializa o SDK do LevelPlay
  static Future<void> inicializar() async {
    try {
      final initRequest = LevelPlayInitRequest.builder(appKey).build();
      await LevelPlay.init(
        initRequest: initRequest,
        initListener: _initListener,
      );
    } catch (e) {
      debugPrint("Erro ao chamar LevelPlay.init: $e");
    }
  }

  /// Pré-carrega o anúncio Interstitial na memória
  static void carregarInterstitial() {
    try {
      _interstitialAd ??= LevelPlayInterstitialAd(adUnitId: appKey);
      _interstitialAd!.loadAd();
      debugPrint("🔄 A transferir Interstitial para a memória...");
    } catch (e) {
      debugPrint("Erro ao carregar Interstitial: $e");
    }
  }

  /// Exibe o anúncio Interstitial no ecrã
  static Future<void> exibirInterstitial() async {
    try {
      if (_interstitialAd != null && await _interstitialAd!.isAdReady()) {
        debugPrint("🎬 A exibir anúncio Interstitial!");
        await _interstitialAd!.showAd();
        // Prepara logo o próximo anúncio em segundo plano
        _interstitialAd!.loadAd();
      } else {
        debugPrint(
            "⚠️ Anúncio ainda a descarregar. A tentar novo carregamento...");
        carregarInterstitial();
      }
    } catch (e) {
      debugPrint("Erro ao exibir Interstitial: $e");
    }
  }
}

/// Ouvinte da inicialização do Unity LevelPlay
class _AdInitListener implements LevelPlayInitListener {
  @override
  void onInitSuccess(LevelPlayConfiguration configuration) {
    AdService.isInitialized = true;
    debugPrint("🔥 Unity LevelPlay inicializado com sucesso!");
    // Começa logo a transferir o primeiro anúncio assim que a app arranca
    AdService.carregarInterstitial();
  }

  @override
  void onInitFailed(LevelPlayInitError error) {
    AdService.isInitialized = false;
    debugPrint("❌ Falha na inicialização do LevelPlay: ${error.errorMessage}");
  }
}
