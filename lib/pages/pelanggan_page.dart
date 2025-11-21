import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/pelanggan.dart';

class PelangganPage extends StatefulWidget {
  @override
  State<PelangganPage> createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  List<Pelanggan> pelangganList = [];
  List<Pelanggan> filteredList = []; // LIST HASIL FILTER
  bool loading = true;
  String? errorMessage;

  final String apiUrl = "http://127.0.0.1:8000/api/pelanggan";

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        setState(() {
          pelangganList = data.map((e) => Pelanggan.fromJson(e)).toList();
          filteredList = pelangganList; // TAMPILKAN SEMUA AWALNYA
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

  // ======================
  // FUNGSI FILTER PENCARIAN
  // ======================
  void filterSearch(String keyword) {
    final query = keyword.toLowerCase();

    setState(() {
      filteredList = pelangganList.where((p) {
        final nama = p.nama.toLowerCase();
        final alamat = (p.alamat ?? "").toLowerCase();
        final hp = (p.noHp ?? "").toLowerCase();

        return nama.contains(query) ||
            alamat.contains(query) ||
            hp.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F6FA),

      appBar: AppBar(
        backgroundColor: Color(0xff0099FF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Data Pelanggan",
          style: TextStyle(
            fontFamily: "Poppins",
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff0099FF),
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),

      body: loading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Text(
                errorMessage!,
                style: TextStyle(fontSize: 16, fontFamily: "Poppins"),
              ),
            )
          : Column(
              children: [
                // ===============================
                // SEARCH BAR MODERN DI SINI
                // ===============================
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: filterSearch,
                      style: TextStyle(fontFamily: "Poppins"),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        hintText: "Cari pelanggan...",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Poppins",
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),

                // ===============================
                // LIST DATA + FILTER
                // ===============================
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: fetchPelanggan,
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return _buildModernCard(filteredList[index], index);
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // ==========================
  // CARD MODERN (SAMA TRANSAKSI)
  // ==========================
  Widget _buildModernCard(Pelanggan p, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.black12,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xff0099FF).withOpacity(0.15),
                  child: Icon(Icons.person, size: 32, color: Color(0xff0099FF)),
                ),
                SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.nama,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              p.alamat ?? "-",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            p.noHp ?? "-",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (value) {},
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Hapus')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
