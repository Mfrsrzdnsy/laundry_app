import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/transaksi.dart';
import 'transaksi_detail_page.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key}); // FIXED: tambahkan key

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

  // ================================
  // FETCH API
  // ================================
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
          errorMessage = "Server error ${response.statusCode}";
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

  // ================================
  // BADGE STATUS
  // ================================
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
        color: color.withValues(alpha: 0.15), // FIXED
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

  // ================================
  // UI HALAMAN
  // ================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: Color(0xff0099FF),
        elevation: 0,
        title: const Text("Data Transaksi"),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff0099FF),
        child: const Icon(Icons.add),
        onPressed: () {
          // TODO: tambah transaksi
        },
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transaksiList.length,
              itemBuilder: (context, index) {
                final t = transaksiList[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TransaksiDetailPage(transaksi: t),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BARIS 1: INVOICE + STATUS + MENU TITIK 3
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                t.kodeInvoice,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0099FF),
                                ),
                              ),
                            ),

                            statusBadge(t.status),

                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == "edit") {
                                  // TODO: buka halaman edit transaksi
                                  print("EDIT: ${t.id}");
                                } else if (value == "delete") {
                                  // TODO: konfirmasi hapus
                                  print("HAPUS: ${t.id}");
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: "edit",
                                  child: Row(
                                    children: const [
                                      Icon(Icons.edit, color: Colors.orange),
                                      SizedBox(width: 10),
                                      Text("Edit"),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: "delete",
                                  child: Row(
                                    children: const [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 10),
                                      Text("Hapus"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          t.pelanggan.nama,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Masuk: ${t.tglMasuk}",
                          style: const TextStyle(color: Colors.black54),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Total: Rp ${t.total}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
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
