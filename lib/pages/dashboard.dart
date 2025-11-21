// lib/pages/dashboard.dart
import 'package:flutter/material.dart';
import 'pelanggan_page.dart';
import 'paket_laundry_page.dart';
import 'transaksi_page.dart';

class DashboardLaundry extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem("Pelanggan", Icons.people_outline),
    MenuItem("Paket Laundry", Icons.local_laundry_service_outlined),
    MenuItem("Transaksi", Icons.receipt_long),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 153, 255),
        elevation: 0,
        title: const Text("Amanah Laundry"),
        actions: const [Icon(Icons.notifications_none), SizedBox(width: 12)],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⬆ HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 153, 255),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hallo",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Kelola Kasir",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ⬇ CARD MENU — DIPINDAH KE ATAS & DIPERKECIL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: GridView.builder(
                itemCount: menuItems.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return InkWell(
                    onTap: () {
                      if (item.title == "Pelanggan") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PelangganPage()),
                        );
                      } else if (item.title == "Paket Laundry") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PaketPage()),
                        );
                      } else if (item.title == "Transaksi") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TransaksiPage()),
                        );
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // CIRCLE CARD
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            item.icon,
                            size: 32,
                            color: const Color.fromARGB(255, 0, 153, 255),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // LABEL
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // NAVBAR BAWAH YANG RAPIH
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 0, 153, 255),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: "Order",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  MenuItem(this.title, this.icon);
}
