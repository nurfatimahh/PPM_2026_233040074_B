import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
      ),

      // DRAWER 
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            const ListTile(
              leading: Icon(Icons.home),
              title: Text('Beranda'),
            ),

            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
            ),

            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan'),
            ),

            // ✅ MENU BARU (GALERI)
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const GalleryHome()),
                );
              },
            ),
          ],
        ),
      ),

      // BODY 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              'Nurfatimah',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Mahasiswa Teknik Informatika',
              style:
                  TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 24),

            Row(
              children: const [
                Expanded(child: _StatBox(label: 'Post', value: '12')),
                Expanded(child: _StatBox(label: 'Teman', value: '128')),
                Expanded(child: _StatBox(label: 'Like', value: '1.2K')),
              ],
            ),

            const SizedBox(height: 24),

            const _SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content: 'Saya suka belajar teknologi mobile.',
            ),
            const _SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: 'Universitas Pasundan — Semester 5',
            ),
            const _SectionCard(
              icon: Icons.favorite,
              title: 'Hobi',
              content: 'Coding • Game • Membaca',
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

// COMPONENT

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(content),
      ),
    );
  }
}

// GALLERY
// Halaman utama gallery
class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Display', Icons.image, Colors.blue),
      ('Input', Icons.edit, Colors.green),
      ('Button', Icons.smart_button, Colors.orange),
      ('Feedback', Icons.notifications, Colors.purple),
      ('Layout', Icons.dashboard, Colors.teal),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final (name, icon, color) = categories[i];

          return ListTile(
            leading: Icon(icon, color: color),
            title: Text(name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryPage(name: name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Halaman kategori
class CategoryPage extends StatelessWidget {
  final String name;

  const CategoryPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final body = switch (name) {
      'Display' => const _DisplayDemo(),
      'Input' => const _InputDemo(),
      'Button' => const _ButtonDemo(),
      'Feedback' => const _FeedbackDemo(),
      'Layout' => const _LayoutDemo(),
      _ => const Center(child: Text('?')),
    };

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
    );
  }
}

// ================= DEMO =================

class _DisplayDemo extends StatelessWidget {
  const _DisplayDemo();

  @override
  Widget build(BuildContext context) {
    return const Text('Demo Display');
  }
}

class _InputDemo extends StatelessWidget {
  const _InputDemo();

  @override
  Widget build(BuildContext context) {
    return const Text('Demo Input');
  }
}

class _ButtonDemo extends StatelessWidget {
  const _ButtonDemo();

  @override
  Widget build(BuildContext context) {
    return const Text('Demo Button');
  }
}

class _FeedbackDemo extends StatelessWidget {
  const _FeedbackDemo();

  @override
  Widget build(BuildContext context) {
    return const Text('Demo Feedback');
  }
}

class _LayoutDemo extends StatelessWidget {
  const _LayoutDemo();

  @override
  Widget build(BuildContext context) {
    return const Text('Demo Layout');
  }
}