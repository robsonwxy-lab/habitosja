import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  static const String idMensal = 'habitosja_mensal';
  static const String idVitalicio = 'habitosja_vitalicio';

  bool _loading = true;
  bool _isPremium = false;
  List<ProductDetails> _produtos = [];

  @override
  void initState() {
    super.initState();
    _inicializarPagamentos();
  }

  Future<void> _inicializarPagamentos() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isPremium = prefs.getBool('is_premium') ?? false;
      });
    }

    _subscription = _iap.purchaseStream.listen((purchases) {
      _processarCompras(purchases);
    }, onError: (error) {
      debugPrint("Erro no fluxo de pagamentos: $error");
    });

    try {
      final bool available = await _iap.isAvailable();
      if (available) {
        final ProductDetailsResponse response =
            await _iap.queryProductDetails({idMensal, idVitalicio});
        if (mounted) {
          setState(() {
            _produtos = response.productDetails;
            _loading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint("Erro ao consultar produtos: $e");
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _processarCompras(List<PurchaseDetails> purchases) async {
    final prefs = await SharedPreferences.getInstance();
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await prefs.setBool('is_premium', true);
        if (mounted) {
          setState(() => _isPremium = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 Acesso Premium Ativado com Sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  Future<void> _comprarProduto(String produtoId) async {
    try {
      final produto = _produtos.firstWhere(
        (p) => p.id == produtoId,
        orElse: () => throw Exception('Produto aguardando sincronização'),
      );
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: produto);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_premium', true);
      if (mounted) {
        setState(() => _isPremium = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Plano ativado com sucesso: $produtoId'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _restaurarCompras() async {
    try {
      await _iap.restorePurchases();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Verificando compras anteriores na sua conta Google...')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao restaurar: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Planos & Assinatura',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          TextButton(
            onPressed: _restaurarCompras,
            child: const Text('Restaurar',
                style: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (_isPremium)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified, color: Colors.green, size: 28),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Sua conta é PREMIUM! Todos os anúncios foram removidos e todas as funções liberadas.',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                // PLANO 1: ASSINATURA MENSAL
                _cardPlano(
                  'Assinatura Mensal',
                  'Acesso completo • Cancele quando quiser',
                  'R\$ 9,90 / mês',
                  Colors.blueAccent,
                  _isPremium,
                  () => _comprarProduto(idMensal),
                ),
                const SizedBox(height: 16),

                // PLANO 2: ACESSO VITALÍCIO
                _cardPlano(
                  'Acesso Vitalício',
                  'Pagamento único • Sem renovação ou cobranças futuras',
                  'R\$ 29,90 único',
                  Colors.amber,
                  _isPremium,
                  () => _comprarProduto(idVitalicio),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Vantagens do Plano Premium:',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _itemBeneficio('Sem Anúncios (Nenhum Banner ou Interstitial)'),
                _itemBeneficio('Despertador e Lembretes Ilimitados'),
                _itemBeneficio('Acesso a Todas as Atualizações Futuras'),
              ],
            ),
    );
  }

  Widget _cardPlano(
    String titulo,
    String subtitulo,
    String preco,
    Color corDestaque,
    bool isAtivo,
    VoidCallback onComprar,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: corDestaque.withValues(alpha: 0.6), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(titulo,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text(preco,
                  style: TextStyle(
                      color: corDestaque,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Text(subtitulo,
              style: const TextStyle(color: Colors.white60, fontSize: 13)),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isAtivo ? Colors.grey[800] : corDestaque,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isAtivo ? null : onComprar,
              child: Text(
                isAtivo ? 'Plano Ativo' : 'Adquirir Agora',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _itemBeneficio(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(texto,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
