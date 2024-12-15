import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  Future<void> launchCustomUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

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
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        children: [
          const ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text('Tentang Aplikasi', style: TextStyle(fontSize: 20)),
            ),
            subtitle: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Divider(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Cough Detection merupakan aplikasi Pre-Skrining pertama di Indonesia yang melakukan deteksi dini terhadap penyakit yang memiliki gejala batuk dengan menggunakan teknologi cerdas yang terbaru dengan tingkat akurasi tinggi. Aplikasi ini bersifat pemeriksaan mandiri yang dapat dilakukan di mana saja dan kapan saja langsung oleh pengguna. Pemanfaatan metodelogi PSKV-E semakin menjamin kehandalan dan keberlanjutan dari aplikasi ini dengan berkolaborasi dengan stakeholder seperti layanan kesehatan terdekat dan pemerintahan setempat.',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text('Tentang Pengembang', style: TextStyle(fontSize: 20)),
            ),
            subtitle: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Divider(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                      'Aplikasi ini dikembangkan di Institut Teknologi Bandung (ITB) dengan berkolaborasi dengan start up Andromeda Teknologi sebagai mitra developer pengembangan aplikasi. Melalui metodelogi ilmiah dan mengikuti perkembangan teknologi terkini, aplikasi ini telah teruji oleh akademisi bidang teknologi dari ITB pada tahun 2024. Diawasi oleh Prof. Ir. Armein Z.R. Langi, M.Sc. Ph.D yang merupakan Guru Besar di ITB pada KK Teknologi Informasi.',
                      style: TextStyle(fontSize: 15)),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15, bottom: 8),
                  child: Text('Pengembang', style: TextStyle(fontSize: 20)),
                ),
                Divider(),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'images/armein.png',
                        fit: BoxFit.contain,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 40,
                          );
                        },
                      ),
                    ),
                    title: const Text(
                      'Prof. Ir. Armein Z.R. Langi, M.Sc. Ph.D',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dewan Pengawas', style: TextStyle(fontSize: 13)),
                        // Text('Instagram: @zawilhikam'),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () => launchCustomUrl(
                        'https://www.instagram.com/zawilhikam_/'),
                    contentPadding: const EdgeInsets.all(0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'images/zawil.jpeg',
                        fit: BoxFit.contain,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 40,
                          );
                        },
                      ),
                    ),
                    title: const Text(
                      'Zawilhikam Mohammad, S. Kom',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Project Manager', style: TextStyle(fontSize: 13)),
                        Text('Instagram: @zawilhikam_'),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () => launchCustomUrl(
                        'https://www.instagram.com/shabiqghazi/'),
                    contentPadding: const EdgeInsets.all(0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'images/shabiq.jpeg',
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 40,
                          );
                        },
                      ),
                    ),
                    title: const Text(
                      'Shabiq Ghazi Arkaan',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Backend Developer',
                            style: TextStyle(fontSize: 13)),
                        Text('Instagram: @shabiqghazi'),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () => launchCustomUrl(
                        'https://www.instagram.com/yossananto/'),
                    contentPadding: const EdgeInsets.all(0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'images/yoss.jpeg',
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 40,
                          );
                        },
                      ),
                    ),
                    title: const Text(
                      'Yoss Sagita Ananto',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Frontend Developer',
                            style: TextStyle(fontSize: 13)),
                        Text('Instagram: @yossananto'),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () =>
                        launchCustomUrl('https://www.instagram.com/rrahmatn_/'),
                    contentPadding: const EdgeInsets.all(0),
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'images/mamat.jpeg',
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 40,
                            );
                          },
                        )),
                    title: const Text(
                      'Rizky Rahmat Nugraha',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Frontend Developer',
                            style: TextStyle(fontSize: 13)),
                        Text('Instagram: @rrahmatn_'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('Versi Aplikasi'),
            subtitle: Text('1.0.0'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                'Copyright Ⓒ 2024 Andromeda Teknologi',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
