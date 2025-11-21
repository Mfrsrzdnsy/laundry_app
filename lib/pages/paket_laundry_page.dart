// lib/pages/paket_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/paket.dart';

class PaketPage extends StatefulWidget {
  @override
  State<PaketPage> createState() => _PaketPageState();
}

class _PaketPageState extends State<PaketPage> {
  List<Paket> paketList = [];
  bool loading = true;
  String? errorMessage;

  final String apiUrl = "http://127.0.0.1:8000/api/paket";

  @override
  void initState() {
    super.initState();
    fetchPaket();
  }

  Future<void> fetchPaket() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        setState(() {
          paketList = data.map((e) => Paket.fromJson(e)).toList();
          loading = false;
        });
      } else {
        setState(() {
          errorMessage = "Server error: ${response.statusCode}";
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Tidak dapat terhubung ke server API";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F7F8),

      // ---------------- APPBAR ----------------
      appBar: AppBar(
        backgroundColor: const Color(0xff0099FF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Paket Laundry",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff0099FF),
        onPressed: () {},
        child: Icon(Icons.add, size: 28, color: Colors.white),
      ),

      body: RefreshIndicator(
        onRefresh: fetchPaket,
        child: loading
            ? Center(child: CircularProgressIndicator(color: Color(0xff0099FF)))
            : errorMessage != null
            ? _buildErrorMessage()
            : _buildPaketList(),
      ),
    );
  }

  // ---------------- ERROR MESSAGE ----------------
  Widget _buildErrorMessage() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              errorMessage!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- PAKET LIST MODERN ----------------
  Widget _buildPaketList() {
    return ListView.separated(
      padding: EdgeInsets.all(16),
      separatorBuilder: (_, __) => SizedBox(height: 14),
      itemCount: paketList.length,
      itemBuilder: (context, index) {
        final p = paketList[index];

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),

          // ---------------- ROW CARD ----------------
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICON LAUNDRY
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Color(0xff0099FF).withOpacity(.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.local_laundry_service,
                  color: Color(0xff0099FF),
                  size: 26,
                ),
              ),

              SizedBox(width: 16),

              // TEXT SECTION
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NAMA PAKET
                    Text(
                      p.namaPaket,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 6),

                    // HARGA
                    Text(
                      "Rp ${p.harga}",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xff0099FF),
                      ),
                    ),

                    SizedBox(height: 6),

                    // DURASI
                    Row(
                      children: [
                        Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                        SizedBox(width: 6),
                        Text(
                          "${p.durasi ?? '-'} hari",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // MENU 3-DOT
              PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                icon: Icon(Icons.more_vert, size: 24),
                onSelected: (value) {
                  if (value == "edit") {}
                  if (value == "delete") {}
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue, size: 20),
                        SizedBox(width: 10),
                        Text("Edit"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 10),
                        Text("Hapus"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
