import '../models/transaksi.dart';
import '../services/api_service.dart';

class TransaksiController {
  final ApiService _api = ApiService();

  Future<List<Transaksi>> fetchTransaksi() {
    return _api.getTransaksi();
  }
}
