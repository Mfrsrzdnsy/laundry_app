import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/transaksi.dart';
import 'transaksi_detail_page.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  List<Transaksi> transaksiList = [];
  bool loading = true;
  String? errorMessage;

  // untuk pencarian
  String cari = "";

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
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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

  // ================================
  // UI HALAMAN
  // ================================
  @override
  Widget build(BuildContext context) {
    // FILTER DATA BERDASARKAN SEARCH
    final filteredList = transaksiList.where((t) {
      return t.kodeInvoice.toLowerCase().contains(cari.toLowerCase()) ||
          t.pelanggan.nama.toLowerCase().contains(cari.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: const Color(0xff0099FF),
        elevation: 0,
        title: const Text("Data Transaksi"),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0099FF),
        child: const Icon(Icons.add),
        onPressed: () {},
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : Column(
              children: [
                // ================================
                // SEARCH BAR
                // ================================
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        cari = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Cari transaksi...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // ================================
                // LIST DATA
                // ================================
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final t = filteredList[index];

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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        print("EDIT: ${t.id}");
                                      } else if (value == "delete") {
                                        print("HAPUS: ${t.id}");
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: "edit",
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: Colors.orange,
                                            ),
                                            SizedBox(width: 10),
                                            Text("Edit"),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: "delete",
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
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
                ),
              ],
            ),
    );
  }
}
