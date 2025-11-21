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
      appBar: AppBar(
        title: Text("Paket Laundry"),
        backgroundColor: Color(0xff0097A7),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff0097A7),
        onPressed: () {
          // TODO: buka form tambah paket
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: fetchPaket,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? ListView(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(errorMessage!, textAlign: TextAlign.center),
                    ),
                  ),
                ],
              )
            : ListView.separated(
                padding: EdgeInsets.all(12),
                separatorBuilder: (_, __) => SizedBox(height: 8),
                itemCount: paketList.length,
                itemBuilder: (context, index) {
                  final p = paketList[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      title: Text(
                        p.namaPaket,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Harga: Rp ${p.harga} • Durasi: ${p.durasi ?? '-'} hari",
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            // TODO: buka form edit
                          } else if (value == 'delete') {
                            // TODO: panggil API delete
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Hapus')),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
