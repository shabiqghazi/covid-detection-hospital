import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text(
          'Tentang',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: [
          const ListTile(
            title: Text("Tentang Aplikasi"),
            subtitle: Column(
              children: [
                Text(
                    "Aplikasi ini dikembangkan untuk membantu rumah sakit dan tenaga medis dalam penanganan pasien COVID-19. Ditenagai oleh teknologi kecerdasan buatan, aplikasi ini mampu menganalisis data kesehatan pasien dengan cepat, termasuk suara batuk, suhu tubuh, dan gejala lainnya, untuk memprediksi kemungkinan infeksi COVID-19."),
                Text(
                    "Selain fungsi deteksi dini, aplikasi ini juga memfasilitasi pengelolaan data pasien yang terintegrasi, membantu tenaga medis memantau kondisi pasien secara real-time, serta mendukung proses triase yang lebih efektif. Dengan aplikasi ini, rumah sakit dapat merespons pasien lebih cepat, memberikan penanganan yang lebih tepat, dan mengurangi beban kerja di tengah situasi pandemi yang dinamis.")
              ],
            ),
          ),
          const Expanded(child: Divider()),
          const ListTile(
            title: Text("Tentang Pengembang"),
            subtitle: Text(
                "Andromeda Teknologi adalah perusahaan pengembang perangkat lunak yang berfokus pada solusi digital inovatif untuk berbagai sektor, termasuk kesehatan, pendidikan, dan teknologi konsumen. Dengan komitmen untuk menghadirkan teknologi yang dapat memudahkan kehidupan sehari-hari, Andromeda Teknologi menggabungkan kecerdasan buatan (AI) dan pendekatan berbasis data untuk menciptakan aplikasi yang tangguh, aman, dan mudah digunakan."),
          ),
          const Expanded(child: Divider()),
          ListTile(
            title: const Text("Pengembang"),
            subtitle: Column(
              children: [
                ListTile(
                  leading: Image.asset(
                    'images/zawil.jpeg',
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person);
                    },
                  ),
                  title: const Text("Zawil Hikam"),
                  subtitle: const Text("zawilhikam"),
                  onTap: () async {
                    var url = "https://www.instagram.com/zawilhikam";
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'images/shabiq.jpeg',
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person);
                    },
                  ),
                  title: const Text("Shabiq Ghazi Arkaan"),
                  subtitle: const Text("shabiqghazi"),
                  onTap: () async {
                    var url = "https://www.instagram.com/shabiqghazi";
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'images/yoss.jpeg',
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person);
                    },
                  ),
                  title: const Text("Yoss Sagita Ananto"),
                  subtitle: const Text("yossananto"),
                  onTap: () async {
                    var url = "https://www.instagram.com/yossananto";
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'images/rahmat.jpeg',
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person);
                    },
                  ),
                  title: const Text("Rizky Rahmat Nugraha"),
                  subtitle: const Text("rrahmatn_"),
                  onTap: () async {
                    var url = "https://www.instagram.com/rrahmatn_";
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                )
              ],
            ),
          ),
          const Expanded(child: Divider()),
          const ListTile(
            title: Text("Versi Aplikasi"),
            subtitle: Text("1.0.0"),
          ),
        ],
      ),
    );
  }
}
