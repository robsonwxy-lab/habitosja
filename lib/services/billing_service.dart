import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillingService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static const String subscriptionId = 'habitosja_mensal';
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static Function(bool)? onStatusUpdated;

  static void inicializar({required Function(bool) onStatusChange}) {
    onStatusUpdated = onStatusChange;
    _subscription = _iap.purchaseStream.listen((compras) {
      _processarCompras(compras);
    }, onError: (_) {});
  }

  static Future<void> comprarAssinatura() async {
    final bool disponivel = await _iap.isAvailable();
    if (!disponivel) return;

    final response = await _iap.queryProductDetails({subscriptionId});
    if (response.productDetails.isEmpty) return;

    final ProductDetails produto = response.productDetails.first;
    final PurchaseParam param = PurchaseParam(productDetails: produto);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  static void _processarCompras(List<PurchaseDetails> compras) async {
    final prefs = await SharedPreferences.getInstance();
    for (var c in compras) {
      if (c.productID == subscriptionId) {
        if (c.status == PurchaseStatus.purchased ||
            c.status == PurchaseStatus.restored) {
          await prefs.setBool('is_premium', true);
          onStatusUpdated?.call(true);
        } else if (c.status == PurchaseStatus.error) {
          onStatusUpdated?.call(false);
        }

        if (c.pendingCompletePurchase) {
          await _iap.completePurchase(c);
        }
      }
    }
  }

  static void encerrar() {
    _subscription?.cancel();
  }
}
