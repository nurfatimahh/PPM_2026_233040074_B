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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
      ),

      //  FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Edit profil belum tersedia'),
            ),
          );
        },
        child: const Icon(Icons.edit),
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

            // ENGATURAN
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Pengaturan'),
                    content: const Text('Fitur belum tersedia'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              },
            ),

            // GALLERY
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GalleryHome(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // BODY + BACKGROUND
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F7FB),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //  AVATAR
              const CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage(
                  'assets/nur.jpeg',
                ),
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
                content: 'Universitas Pasundan — Semester 6',
              ),
              const _SectionCard(
                icon: Icons.favorite,
                title: 'Hobi',
                content: 'Coding • Game • Membaca',
              ),

              //  SKILLS
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.star),
                          SizedBox(width: 8),
                          Text(
                            'Skills',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(label: Text('Flutter')),
                          Chip(label: Text('Java')),
                          Chip(label: Text('UI/UX')),
                          Chip(label: Text('SQL')),
                          Chip(label: Text('Problem Solving')),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      //  NAVIGATION BAR (Material 3)
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// ================= COMPONENT =================

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

// ================= GALLERY =================

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