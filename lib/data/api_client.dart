import 'package:dio/dio.dart';
import '../core/env.dart';

class ApiClient {
  late final Dio _dio;
  ApiClient() {
    _dio = Dio(BaseOptions(baseUrl: Env.apiBase, connectTimeout: const Duration(seconds: 10)));
  }

  // MOCK endpoints (คุณค่อยชี้ไป backend จริงภายหลัง)
  Future<int> getWalletBalance() async {
    // final res = await _dio.get('/wallet');
    // return res.data['balance'] as int;
    await Future.delayed(const Duration(milliseconds: 300));
    return 120; // mock
  }

  Future<int> purchaseTokens(int pack) async {
    // final res = await _dio.post('/tokens/purchase', data: {'pack': pack});
    await Future.delayed(const Duration(milliseconds: 500));
    return pack; // add to balance (mock)
  }

  Future<bool> feedAnimal({required String animalId, required int tokens}) async {
    // final res = await _dio.post('/feed-events', data: {'animalId': animalId});
    await Future.delayed(const Duration(milliseconds: 800));
    // 10% ล้มเหลวให้ลองแจ้งเตือน/คืนโทเคนจริงเมื่อมี backend
    return DateTime.now().millisecond % 10 != 0;
  }
}
