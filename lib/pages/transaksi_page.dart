import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/transaksi.dart';
import 'transaksi_detail_page.dart';

class TransaksiPage extends StatefulWidget {
  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  List<Transaksi> transaksiList = [];
  bool loading = true;
  String? errorMessage;

  final String apiUrl = "http://127.0.0.1:8000/api/transaksi";

  @override
  void initState() {
    super.initState();
    fetchTransaksi();
  }

  // ============================================
  // FETCH DATA (SUDAH PAKAI MOUNTED CHECK)
  // ============================================
  Future<void> fetchTransaksi() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        if (!mounted) return;
        setState(() {
          transaksiList = data.map((e) => Transaksi.fromJson(e)).toList();
          loading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          errorMessage = "Server error: ${response.statusCode}";
          loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Tidak dapat terhubung ke server API";
        loading = false;
      });
    }
  }

  // ============================================
  // BADGE STATUS
  // ============================================
  Widget statusBadge(String status) {
    Color color;

    switch (status.toLowerCase()) {
      case "selesai":
        color = Colors.green;
        break;
      case "proses":
        color = Colors.orange;
        break;
      case "pending":
        color = Colors.grey;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // ============================================
  // UI
  // ============================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[150],

      appBar: AppBar(
        backgroundColor: Color(0xff0099FF),
        elevation: 0,
        title: Text("Data Transaksi"),
      ),

      // tombol tambah transaksi
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff0099FF),
        child: Icon(Icons.add),
        onPressed: () {
          // TODO: buka halaman tambah transaksi
        },
      ),

      body: loading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: transaksiList.length,
              itemBuilder: (context, index) {
                final t = transaksiList[index];

                return GestureDetector(
                  onTap: () {
                    // buka detail transaksi
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TransaksiDetailPage(transaksi: t),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    // Card isi
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BARIS 1: INVOICE + STATUS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.kodeInvoice,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff0099FF),
                              ),
                            ),
                            statusBadge(t.status ?? "Unknown"),
                          ],
                        ),

                        SizedBox(height: 8),

                        // Nama pelanggan
                        Text(
                          t.pelanggan.nama,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 4),

                        // Tanggal masuk
                        Text(
                          "Masuk: ${t.tglMasuk}",
                          style: TextStyle(color: Colors.black54),
                        ),

                        SizedBox(height: 4),

                        // Total
                        Text(
                          "Total: Rp ${t.total}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),

                        SizedBox(height: 10),

                        // TANDA LEBIH LANJUT
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Lihat Detail",
                              style: TextStyle(
                                color: Color(0xff0099FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Color(0xff0099FF),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
