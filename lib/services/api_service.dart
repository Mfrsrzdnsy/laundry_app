import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaksi.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  Future<List<Transaksi>> getTransaksi() async {
    final response = await http.get(Uri.parse("$baseUrl/transaksi"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Transaksi.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data transaksi");
    }
  }
}
