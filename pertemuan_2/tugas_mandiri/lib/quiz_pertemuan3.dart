import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

// =====================================================================
// DATA GLOBAL
// =====================================================================

String profileImage   = 'assets/nur.jpg';
bool   profileIsFile  = false;
Uint8List? profileBytes;

String nama       = 'Nurfatimah';
String tentang    = 'Saya suka belajar hal baru, terutama teknologi mobile dan UI/UX.';
String pendidikan = 'Universitas Pasundan — Semester 5';
String lokasi     = 'Bandung, Jawa Barat';
String kontak     = 'nurfatimah@email.com\n+62 812-3456-7890';
List<String> skills = ['Flutter', 'Java', 'UI/UX'];

String pengalamanJudul     = 'Membuat Aplikasi Mobile';
String pengalamanDeskripsi = 'Membuat aplikasi mobile menggunakan Flutter untuk tugas kuliah.';
String pengalamanImage     = 'assets/nur.jpg';
bool   pengalamanIsFile    = false;
Uint8List? pengalamanBytes;

// =====================================================================
// HELPER: tampilkan gambar (support web & mobile)
// =====================================================================

Widget buildImage({
  required String assetPath,
  required bool isFile,
  Uint8List? bytes,
  double? height,
  double? width,
  BoxFit fit = BoxFit.cover,
  double radius = 0,
}) {
  ImageProvider provider;

  if (bytes != null) {
    provider = MemoryImage(bytes);
  } else if (isFile && !kIsWeb) {
    provider = FileImage(File(assetPath));
  } else {
    provider = AssetImage(assetPath);
  }

  final img = Image(
    image: provider,
    height: height,
    width: width,
    fit: fit,
  );

  if (radius > 0) {
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: img);
  }
  return img;
}

// =====================================================================
// APP
// =====================================================================

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: softBg,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.light(
          primary: softPrimary,
          secondary: softSecondary,
          surface: softSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: softPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: softPrimary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: softAccent.withOpacity(0.3),
          labelStyle: TextStyle(color: softPrimary, fontWeight: FontWeight.w600),
          side: BorderSide(color: softSecondary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: softPrimary),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: softAccent),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: softPrimary, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: softCard,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: softAccent.withOpacity(0.5)),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: softAccent,
          labelTextStyle: WidgetStateProperty.all(
            TextStyle(color: softPrimary, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          iconTheme: WidgetStateProperty.all(
            IconThemeData(color: softPrimary),
          ),
        ),
      ),
      home: ProfilePage(onUpdate: refresh),
    );
  }
}

// =====================================================================
// PROFILE PAGE
// =====================================================================

class ProfilePage extends StatelessWidget {
  final VoidCallback onUpdate;
  const ProfilePage({super.key, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [softPrimary, softSecondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      drawer: Drawer(
        backgroundColor: softBg,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [softPrimary, softSecondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text('Menu', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            _drawerItem(context, Icons.home, 'Beranda', null),
            _drawerItem(context, Icons.edit, 'Edit Profile', () async {
              Navigator.pop(context);
              await Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfilePage(onUpdate: onUpdate)));
            }),
            _drawerItem(context, Icons.work, 'Edit Pengalaman', () async {
              Navigator.pop(context);
              await Navigator.push(context, MaterialPageRoute(builder: (_) => EditPengalamanPage(onUpdate: onUpdate)));
            }),
            _drawerItem(context, Icons.widgets, 'Widget Gallery', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const GalleryHome()));
            }),
          ],
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [softBg, softSurface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // FOTO
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [softPrimary, softSecondary]),
                  boxShadow: [BoxShadow(color: softPrimary.withOpacity(0.3), blurRadius: 20, spreadRadius: 3)],
                ),
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: profileBytes != null
                      ? MemoryImage(profileBytes!) as ImageProvider
                      : (profileIsFile && !kIsWeb)
                          ? FileImage(File(profileImage))
                          : AssetImage(profileImage),
                ),
              ),

              const SizedBox(height: 12),

              Text(nama, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textDark)),
              const SizedBox(height: 4),
              const Text('Mahasiswa Teknik Informatika', style: TextStyle(color: textMuted)),

              const SizedBox(height: 20),

              // DIVIDER
              Container(
                height: 1.5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.transparent, softPrimary, Colors.transparent]),
                ),
              ),

              const SizedBox(height: 20),

              // STAT
              Row(
                children: [
                  Expanded(child: _StatBox(label: 'Post', value: '12')),
                  Container(width: 1, height: 40, color: softAccent),
                  Expanded(child: _StatBox(label: 'Teman', value: '128K')),
                  Container(width: 1, height: 40, color: softAccent),
                  Expanded(child: _StatBox(label: 'Like', value: '1.2M')),
                ],
              ),

              const SizedBox(height: 20),

              _SectionCard(icon: Icons.info, title: 'Tentang', content: Text(tentang, style: const TextStyle(color: textDark))),
              _SectionCard(icon: Icons.school, title: 'Pendidikan', content: Text(pendidikan, style: const TextStyle(color: textDark))),
              _SectionCard(icon: Icons.location_on, title: 'Lokasi', content: Text(lokasi, style: const TextStyle(color: textDark))),
              _SectionCard(icon: Icons.email, title: 'Kontak', content: Text(kontak, style: const TextStyle(color: textDark))),
              _SectionCard(
                icon: Icons.star,
                title: 'Skills',
                content: Wrap(spacing: 8, children: skills.map((e) => Chip(label: Text(e))).toList()),
              ),

              // PENGALAMAN
              Card(
                margin: const EdgeInsets.only(top: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.work, color: softPrimary),
                        const SizedBox(width: 8),
                        Text('Pengalaman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: softPrimary)),
                      ]),
                      const SizedBox(height: 12),
                      buildImage(
                        assetPath: pengalamanImage,
                        isFile: pengalamanIsFile,
                        bytes: pengalamanBytes,
                        height: 180,
                        width: double.infinity,
                        radius: 12,
                      ),
                      const SizedBox(height: 12),
                      Text(pengalamanJudul, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
                      const SizedBox(height: 8),
                      Text(pengalamanDeskripsi, style: const TextStyle(color: textMuted)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: softPrimary,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfilePage(onUpdate: onUpdate)));
        },
        child: const Icon(Icons.edit),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Pesan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: softPrimary),
      title: Text(title, style: const TextStyle(color: textDark)),
      onTap: onTap,
    );
  }
}

// =====================================================================
// WARNA 
// =====================================================================

const Color softBg = Color(0xFFF5F5F5);
const Color softCard = Color(0xFFFFFFFF);
const Color softPrimary = Color(0xFF757575);
const Color softSecondary = Color(0xFF9E9E9E);
const Color softAccent = Color(0xFFE0E0E0);
const Color softSurface = Color(0xFFEEEEEE);
const Color textDark = Color(0xFF212121);
const Color textMuted = Color(0xFF757575);


// =====================================================================
// STAT BOX
// =====================================================================

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: softPrimary)),
        Text(label, style: const TextStyle(color: textMuted, fontSize: 12)),
      ],
    );
  }
}

// =====================================================================
// SECTION CARD
// =====================================================================

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget content;
  const _SectionCard({required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: softPrimary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: softPrimary)),
                  const SizedBox(height: 8),
                  content,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// EDIT PROFILE
// =====================================================================

class EditProfilePage extends StatefulWidget {
  final VoidCallback onUpdate;
  const EditProfilePage({super.key, required this.onUpdate});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController tentangController;
  late TextEditingController pendidikanController;
  late TextEditingController lokasiController;
  late TextEditingController kontakController;
  late TextEditingController skillController;

  Uint8List? _pickedBytes;
  String?    _pickedPath;

  @override
  void initState() {
    super.initState();
    tentangController    = TextEditingController(text: tentang);
    pendidikanController = TextEditingController(text: pendidikan);
    lokasiController     = TextEditingController(text: lokasi);
    kontakController     = TextEditingController(text: kontak);
    skillController      = TextEditingController(text: skills.join(', '));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _pickedBytes = bytes;
        _pickedPath  = picked.path;
      });
    }
  }

  ImageProvider get _previewImage {
    if (_pickedBytes != null) return MemoryImage(_pickedBytes!);
    if (profileBytes != null) return MemoryImage(profileBytes!);
    if (profileIsFile && !kIsWeb) return FileImage(File(profileImage));
    return AssetImage(profileImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [softPrimary, softSecondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [softBg, softSurface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // PREVIEW FOTO — TENGAH
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(colors: [softPrimary, softSecondary]),
                        boxShadow: [BoxShadow(color: softPrimary.withOpacity(0.3), blurRadius: 16, spreadRadius: 2)],
                      ),
                      padding: const EdgeInsets.all(3),
                      child: CircleAvatar(radius: 60, backgroundImage: _previewImage),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Ganti Foto Profile'),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildTextField(tentangController, 'Tentang', Icons.info),
              _buildTextField(pendidikanController, 'Pendidikan', Icons.school),
              _buildTextField(lokasiController, 'Lokasi', Icons.location_on),
              _buildTextField(kontakController, 'Kontak', Icons.email),
              _buildTextField(skillController, 'Skills (pisahkan dengan koma)', Icons.star),

              const SizedBox(height: 24),

              // TOMBOL SIMPAN — TENGAH
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                  onPressed: () {
                    tentang    = tentangController.text;
                    pendidikan = pendidikanController.text;
                    lokasi     = lokasiController.text;
                    kontak     = kontakController.text;
                    skills     = skillController.text.split(',').map((e) => e.trim()).toList();

                    if (_pickedBytes != null) {
                      profileBytes  = _pickedBytes;
                      profileImage  = _pickedPath ?? profileImage;
                      profileIsFile = true;
                    }

                    widget.onUpdate();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: textDark),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: softPrimary),
        ),
      ),
    );
  }
}

// =====================================================================
// EDIT PENGALAMAN
// =====================================================================

class EditPengalamanPage extends StatefulWidget {
  final VoidCallback onUpdate;
  const EditPengalamanPage({super.key, required this.onUpdate});

  @override
  State<EditPengalamanPage> createState() => _EditPengalamanPageState();
}

class _EditPengalamanPageState extends State<EditPengalamanPage> {
  late TextEditingController judulController;
  late TextEditingController deskripsiController;

  Uint8List? _pickedBytes;
  String?    _pickedPath;

  @override
  void initState() {
    super.initState();
    judulController     = TextEditingController(text: pengalamanJudul);
    deskripsiController = TextEditingController(text: pengalamanDeskripsi);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _pickedBytes = bytes;
        _pickedPath  = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pengalaman'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [softPrimary, softSecondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [softBg, softSurface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [

              // PREVIEW GAMBAR — TENGAH
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _pickedBytes != null
                          ? Image.memory(_pickedBytes!, height: 160, width: double.infinity, fit: BoxFit.cover)
                          : buildImage(
                              assetPath: pengalamanImage,
                              isFile: pengalamanIsFile,
                              bytes: pengalamanBytes,
                              height: 160,
                              width: double.infinity,
                            ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Ganti Gambar'),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: judulController,
                  style: const TextStyle(color: textDark),
                  decoration: const InputDecoration(
                    labelText: 'Judul Pengalaman',
                    prefixIcon: Icon(Icons.work, color: softPrimary),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: deskripsiController,
                  maxLines: 4,
                  style: const TextStyle(color: textDark),
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    prefixIcon: Icon(Icons.description, color: softPrimary),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // TOMBOL SIMPAN — TENGAH
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                  onPressed: () {
                    pengalamanJudul     = judulController.text;
                    pengalamanDeskripsi = deskripsiController.text;

                    if (_pickedBytes != null) {
                      pengalamanBytes  = _pickedBytes;
                      pengalamanImage  = _pickedPath ?? pengalamanImage;
                      pengalamanIsFile = true;
                    }

                    widget.onUpdate();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// GALLERY
// =====================================================================

class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Display', Icons.image),
      ('Input', Icons.edit),
      ('Button', Icons.smart_button),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Gallery'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [softPrimary, softSecondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [softBg, softSurface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, i) {
            final item = categories[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Icon(item.$2, color: softPrimary),
                title: Text(item.$1, style: const TextStyle(color: textDark, fontWeight: FontWeight.w600)),
              ),
            );
          },
        ),
      ),
    );
  }
}