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
  bool loading = true;
  String? errorMessage;

  final String apiUrl = "http://127.0.0.1:8000/api/pelanggan";

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
      backgroundColor: Color(0xffF3F6FA),
      appBar: AppBar(
        title: Text(
          "Data Pelanggan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xff0099FF),
        elevation: 3,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff0099FF),
        elevation: 3,
        onPressed: () {},
        child: Icon(Icons.add, size: 28),
      ),

      body: RefreshIndicator(
        onRefresh: fetchPelanggan,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(child: Text(errorMessage!, style: TextStyle(fontSize: 16)))
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: pelangganList.length,
                itemBuilder: (context, index) {
                  final p = pelangganList[index];
                  return _buildModernCard(p, index);
                },
              ),
      ),
    );
  }

  Widget _buildModernCard(Pelanggan p, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOut,
      margin: EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.black12,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar Circle
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xff0099FF).withOpacity(0.15),
                  child: Icon(Icons.person, size: 32, color: Color(0xff0099FF)),
                ),
                SizedBox(width: 16),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.nama,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
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
                              style: TextStyle(color: Colors.grey[700]),
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
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Menu Button
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      // TODO Edit
                    } else if (value == 'delete') {
                      // TODO Delete
                    }
                  },
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
