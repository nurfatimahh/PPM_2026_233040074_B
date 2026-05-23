import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ================= MODEL =================
class Catatan {
  final String id;
  final String judul;
  final String isi;
  final String kategori;
  final String email;
  final DateTime dibuatPada;

  Catatan({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email,
    required this.dibuatPada,
  });
}

// ================= APP =================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catatan Mahasiswa',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const HomePage(),
    );
  }
}

// ================= WARNA =================
const _kategoriWarna = {
  'Kuliah': Color(0xFF6B8CFF),
  'Tugas': Color(0xFFFFB347),
  'Pribadi': Color(0xFF6BCB77),
  'Lainnya': Color(0xFFB39DDB),
};

// ================= IKON =================
const _kategoriIkon = {
  'Kuliah': Icons.school_outlined,
  'Tugas': Icons.assignment_outlined,
  'Pribadi': Icons.person_outline,
  'Lainnya': Icons.label_outline,
};

// ================= HOME PAGE =================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Catatan> _catatan = [
    Catatan(
      id: '1',
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget dan Navigation.',
      kategori: 'Kuliah',
      email: 'mahasiswa@email.com',
      dibuatPada: DateTime.now(),
    ),
  ];

  String _filterKategori = 'Semua';

  List<Catatan> get _catatanFiltered {
    if (_filterKategori == 'Semua') {
      return _catatan;
    }

    return _catatan.where((c) => c.kategori == _filterKategori).toList();
  }

  Future<void> _tambahCatatan() async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TambahCatatanPage()),
    );

    if (hasil is Catatan) {
      setState(() {
        _catatan.add(hasil);
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Catatan "${hasil.judul}" berhasil ditambahkan'),
        ),
      );
    }
  }

  void _hapusCatatan(int index) {
    final catatan = _catatanFiltered[index];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Hapus Catatan'),
          content: Text('Yakin ingin menghapus "${catatan.judul}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _catatan.removeWhere((c) => c.id == catatan.id);
                });

                Navigator.pop(ctx);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Catatan "${catatan.judul}" berhasil dihapus',
                    ),
                  ),
                );
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editCatatan(Catatan c) async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TambahCatatanPage(catatan: c)),
    );

    if (hasil is Catatan) {
      setState(() {
        final index = _catatan.indexWhere((item) => item.id == hasil.id);

        if (index != -1) {
          _catatan[index] = hasil;
        }
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasil.judul}" berhasil diperbarui')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.indigo.shade100),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _filterKategori,
                  isDense: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.indigo,
                    size: 18,
                  ),
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  items: ['Semua', 'Kuliah', 'Tugas', 'Pribadi', 'Lainnya']
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      _filterKategori = v!;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),

      // ================= BODY =================
      body: _catatanFiltered.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notes_rounded,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada catatan',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _catatanFiltered.length,
              itemBuilder: (context, index) {
                final c = _catatanFiltered[index];

                final warna = _kategoriWarna[c.kategori] ?? Colors.indigo;

                final ikon = _kategoriIkon[c.kategori] ?? Icons.label_outline;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: warna.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(ikon, color: warna),
                    ),

                    title: Text(
                      c.judul,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    subtitle: Text(
                      c.kategori,
                      style: TextStyle(
                        color: warna,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _editCatatan(c);
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Colors.blue.shade300,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _hapusCatatan(index);
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red.shade300,
                          ),
                        ),
                      ],
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailCatatanPage(catatan: c),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: _tambahCatatan,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ================= DETAIL PAGE =================
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;

  const DetailCatatanPage({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    final warna = _kategoriWarna[catatan.kategori] ?? Colors.indigo;

    final ikon = _kategoriIkon[catatan.kategori] ?? Icons.label_outline;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Catatan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: warna.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(ikon, size: 14, color: warna),
                  const SizedBox(width: 6),
                  Text(
                    catatan.kategori,
                    style: TextStyle(color: warna, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              catatan.judul,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(width: 6),
                Text(
                  catatan.email,
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),

            const Divider(height: 32),

            Text(
              catatan.isi,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= TAMBAH / EDIT PAGE =================
class TambahCatatanPage extends StatefulWidget {
  final Catatan? catatan;

  const TambahCatatanPage({super.key, this.catatan});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();

  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String _kategori = 'Kuliah';

  final _emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');

  @override
  void initState() {
    super.initState();

    if (widget.catatan != null) {
      _judulCtrl.text = widget.catatan!.judul;
      _isiCtrl.text = widget.catatan!.isi;
      _emailCtrl.text = widget.catatan!.email;
      _kategori = widget.catatan!.kategori;
    }
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final catatanBaru = Catatan(
      id: widget.catatan?.id ?? DateTime.now().toIso8601String(),
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      email: _emailCtrl.text.trim(),
      dibuatPada: widget.catatan?.dibuatPada ?? DateTime.now(),
    );

    Navigator.pop(context, catatanBaru);
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.catatan != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: _inputDecoration('Judul', Icons.title),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Judul wajib diisi';
                }

                if (v.trim().length < 3) {
                  return 'Minimal 3 karakter';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: _inputDecoration('Isi', Icons.notes),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Isi wajib diisi';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration(
                'Email Pengirim',
                Icons.email_outlined,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Email wajib diisi';
                }

                if (!_emailRegex.hasMatch(v.trim())) {
                  return 'Format email tidak valid';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: _inputDecoration('Kategori', Icons.label_outline),
              items: [
                'Kuliah',
                'Tugas',
                'Pribadi',
                'Lainnya',
              ].map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
              onChanged: (v) {
                setState(() {
                  _kategori = v!;
                });
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _simpan,
              icon: const Icon(Icons.save),
              label: Text(isEdit ? 'Update Catatan' : 'Simpan Catatan'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
