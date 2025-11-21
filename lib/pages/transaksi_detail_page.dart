// lib/pages/transaksi_detail_page.dart
import 'package:flutter/material.dart';
import '../models/transaksi.dart';

class TransaksiDetailPage extends StatelessWidget {
  final Transaksi transaksi;

  const TransaksiDetailPage({required this.transaksi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Transaksi", style: TextStyle(fontFamily: "Roboto")),
        backgroundColor: Color(0xff0099FF),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaksi.kodeInvoice,
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff0099FF),
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Pelanggan: ${transaksi.pelanggan.nama}",
              style: TextStyle(fontFamily: "Roboto"),
            ),
            Text(
              "No HP: ${transaksi.pelanggan.noHp}",
              style: TextStyle(fontFamily: "Roboto"),
            ),
            Text(
              "Alamat: ${transaksi.pelanggan.alamat}",
              style: TextStyle(fontFamily: "Roboto"),
            ),

            // 🔥 PERBAIKAN DI SINI (gunakan tglMasuk, bukan tanggal)
            Text(
              "Tanggal Masuk: ${transaksi.tglMasuk}",
              style: TextStyle(fontFamily: "Roboto"),
            ),

            SizedBox(height: 20),

            Text(
              "Detail Pesanan:",
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: transaksi.detail.length,
                itemBuilder: (context, index) {
                  final d = transaksi.detail[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        d.paket.namaPaket,
                        style: TextStyle(fontFamily: "Roboto"),
                      ),
                      subtitle: Text(
                        "${d.qty} x Rp ${d.paket.harga}",
                        style: TextStyle(fontFamily: "Roboto"),
                      ),
                      trailing: Text(
                        "Rp ${d.subtotal}",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
