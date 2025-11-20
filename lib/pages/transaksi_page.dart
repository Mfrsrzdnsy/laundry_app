import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/transaksi.dart';

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

  Future<void> fetchTransaksi() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        setState(() {
          transaksiList = data.map((e) => Transaksi.fromJson(e)).toList();
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
        title: Text("Data Transaksi"),
        backgroundColor: Colors.blue,
      ),

      body: loading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : ListView.builder(
              itemCount: transaksiList.length,
              itemBuilder: (context, index) {
                final t = transaksiList[index];

                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      "${t.kodeInvoice} - ${t.pelanggan.nama}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text("No HP: ${t.pelanggan.noHp}"),
                        Text("Total: Rp ${t.total}"),

                        SizedBox(height: 10),
                        Text(
                          "Detail:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        ...t.detail.map(
                          (d) => Text(
                            "- ${d.paket.namaPaket} (${d.qty} x Rp ${d.paket.harga}) = Rp ${d.subtotal}",
                          ),
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
