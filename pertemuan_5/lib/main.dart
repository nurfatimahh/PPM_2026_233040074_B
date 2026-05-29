import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.instance.initDatabaseFactory();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class Catatan {
  final int? id;
  final String judul;
  final String isi;
  final String kategori;
  final String email;
  final DateTime dibuatPada;

  Catatan({
    this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email,
    required this.dibuatPada,
  });

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'judul': judul,
    'isi': isi,
    'kategori': kategori,
    'email': email,
    'dibuat_pada': dibuatPada.millisecondsSinceEpoch,
  };

  static Catatan fromMap(Map<String, Object?> m) => Catatan(
    id: m['id'] as int?,
    judul: m['judul'] as String,
    isi: m['isi'] as String,
    kategori: m['kategori'] as String,
    email: m['email'] as String,
    dibuatPada: DateTime.fromMillisecondsSinceEpoch(m['dibuat_pada'] as int),
  );

  Catatan copyWith({
    int? id,
    String? judul,
    String? isi,
    String? kategori,
    String? email,
  }) => Catatan(
    id: id ?? this.id,
    judul: judul ?? this.judul,
    isi: isi ?? this.isi,
    kategori: kategori ?? this.kategori,
    email: email ?? this.email,
    dibuatPada: dibuatPada,
  );
}

const _bgDark = Color(0xFFF5F5FA);
const _bgCard = Color(0xFFFFFFFF);
const _bgCard2 = Color(0xFFF0F0F8);
const _accent = Color(0xFF7C83FD);
const _accentLight = Color(0xFFB8BBFE);
const _textPrimary = Color(0xFF2D2D3A);
const _textSecondary = Color(0xFF9090A8);
const _danger = Color(0xFFFF8FAB);
const _kategoriList = ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

final _kategoriColor = <String, Color>{
  'Kuliah': Color(0xFF7C83FD),
  'Tugas': Color(0xFFFFB347),
  'Pribadi': Color(0xFF6BCB77),
  'Lainnya': Color(0xFFFF8FAB),
};

final _kategoriIcon = <String, IconData>{
  'Kuliah': Icons.school_rounded,
  'Tugas': Icons.assignment_rounded,
  'Pribadi': Icons.person_rounded,
  'Lainnya': Icons.category_rounded,
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catatan Mahasiswa',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: _bgDark,
        colorScheme: const ColorScheme.light(
          primary: _accent,
          secondary: _accentLight,
          surface: _bgCard,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _bgCard2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _accent, width: 2),
          ),
          labelStyle: const TextStyle(color: _textSecondary),
          hintStyle: const TextStyle(color: _textSecondary),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Catatan> _data = [];
  List<Catatan> _filtered = [];
  String _filterKategori = 'Semua';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _muatUlang();
  }

  void _muatUlang() {
    DbHelper.instance.getAll().then((list) {
      if (!mounted) return;
      setState(() {
        _data = list;
        _filtered = _filterKategori == 'Semua'
            ? list
            : list.where((c) => c.kategori == _filterKategori).toList();
        _loading = false;
      });
    });
  }

  void _applyFilter(String kategori) {
    setState(() {
      _filterKategori = kategori;
      _filtered = kategori == 'Semua'
          ? _data
          : _data.where((c) => c.kategori == kategori).toList();
    });
  }

  void _goTambah() {
    Navigator.push(
      context,
      _slideRoute(const TambahCatatanPage()),
    ).then((_) => _muatUlang());
  }

  void _goEdit(Catatan c) {
    Navigator.push(
      context,
      _slideRoute(TambahCatatanPage(catatan: c)),
    ).then((_) => _muatUlang());
  }

  void _hapus(Catatan c) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Hapus Catatan?',
          style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Catatan "${c.judul}" akan dihapus permanen.',
          style: const TextStyle(color: _textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _danger,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ).then((ok) {
      if (ok == true) {
        DbHelper.instance.delete(c.id!).then((_) => _muatUlang());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            backgroundColor: _bgDark,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _bgCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _accent.withAlpha(60)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _filterKategori,
                        isDense: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: _accent,
                          size: 18,
                        ),
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        dropdownColor: _bgCard,
                        borderRadius: BorderRadius.circular(12),
                        items: ['Semua', ..._kategoriList].map((k) {
                          final color = k == 'Semua'
                              ? _accent
                              : (_kategoriColor[k] ?? _accent);
                          return DropdownMenuItem(
                            value: k,
                            child: Row(
                              children: [
                                Icon(
                                  k == 'Semua'
                                      ? Icons.all_inbox_rounded
                                      : _kategoriIcon[k],
                                  color: color,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  k,
                                  style: TextStyle(
                                    color: _textPrimary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) => _applyFilter(val!),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE8E8FF), _bgDark],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _accent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.notes_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Catatan Mahasiswa',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: _accent)),
            )
          else if (_filtered.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_rounded,
                      size: 64,
                      color: _textSecondary.withAlpha(100),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum ada catatan',
                      style: TextStyle(color: _textSecondary, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap + untuk menambah catatan baru',
                      style: TextStyle(color: _textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _CatatanCard(
                    catatan: _filtered[i],
                    index: i,
                    onEdit: () => _goEdit(_filtered[i]),
                    onDelete: () => _hapus(_filtered[i]),
                  ),
                  childCount: _filtered.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goTambah,
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text(
          'Catatan Baru',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _CatatanCard extends StatelessWidget {
  final Catatan catatan;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CatatanCard({
    required this.catatan,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = _kategoriColor[catatan.kategori] ?? _accent;
    final icon = _kategoriIcon[catatan.kategori] ?? Icons.note_rounded;
    final tgl = catatan.dibuatPada;
    final tglStr =
        '${tgl.day.toString().padLeft(2, '0')}/${tgl.month.toString().padLeft(2, '0')}/${tgl.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(15)),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color.withAlpha(38),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          catatan.judul,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          catatan.email,
                          style: TextStyle(
                            color: _textSecondary.withAlpha(178),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withAlpha(38),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      catatan.kategori,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                catatan.isi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(height: 1, color: Colors.white.withAlpha(15)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 13,
                    color: _textSecondary.withAlpha(153),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    tglStr,
                    style: TextStyle(
                      color: _textSecondary.withAlpha(153),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  _IconBtn(
                    icon: Icons.edit_rounded,
                    color: _accentLight,
                    onTap: onEdit,
                  ),
                  const SizedBox(width: 4),
                  _IconBtn(
                    icon: Icons.delete_outline_rounded,
                    color: _danger,
                    onTap: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 16),
    ),
  );
}

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
  bool _loading = false;

  bool get isEdit => widget.catatan != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _judulCtrl.text = widget.catatan!.judul;
      _isiCtrl.text = widget.catatan!.isi;
      _emailCtrl.text = widget.catatan!.email;
      _kategori = widget.catatan!.kategori;
    }
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final future = isEdit
        ? DbHelper.instance.update(
            widget.catatan!.copyWith(
              judul: _judulCtrl.text.trim(),
              isi: _isiCtrl.text.trim(),
              kategori: _kategori,
              email: _emailCtrl.text.trim(),
            ),
          )
        : DbHelper.instance.insert(
            Catatan(
              judul: _judulCtrl.text.trim(),
              isi: _isiCtrl.text.trim(),
              kategori: _kategori,
              email: _emailCtrl.text.trim(),
              dibuatPada: DateTime.now(),
            ),
          );

    future
        .then((_) {
          if (mounted) Navigator.pop(context);
        })
        .catchError((_) {
          if (mounted) setState(() => _loading = false);
        });
  }

  @override
  Widget build(BuildContext context) {
    final katColor = _kategoriColor[_kategori] ?? _accent;

    return Scaffold(
      backgroundColor: _bgDark,
      appBar: AppBar(
        backgroundColor: _bgDark,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: _textPrimary,
              size: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Edit Catatan' : 'Catatan Baru',
          style: const TextStyle(
            color: _textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [katColor.withAlpha(51), katColor.withAlpha(13)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: katColor.withAlpha(77)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: katColor.withAlpha(51),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _kategoriIcon[_kategori] ?? Icons.note_rounded,
                      color: katColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEdit ? 'Edit Catatan' : 'Buat Catatan Baru',
                        style: const TextStyle(
                          color: _textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Kategori: $_kategori',
                        style: TextStyle(color: katColor, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const _Label('Judul Catatan'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _judulCtrl,
              style: const TextStyle(color: _textPrimary),
              decoration: const InputDecoration(
                hintText: 'Masukkan judul catatan...',
                prefixIcon: Icon(
                  Icons.title_rounded,
                  color: _textSecondary,
                  size: 20,
                ),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Judul tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 18),

            const _Label('Isi Catatan'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _isiCtrl,
              style: const TextStyle(color: _textPrimary, height: 1.5),
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Tulis isi catatan di sini...',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Isi tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 18),

            const _Label('Email'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailCtrl,
              style: const TextStyle(color: _textPrimary),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'contoh@email.com',
                prefixIcon: Icon(
                  Icons.alternate_email_rounded,
                  color: _textSecondary,
                  size: 20,
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty)
                  return 'Email tidak boleh kosong';
                if (!v.contains('@')) return 'Format email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 18),

            const _Label('Kategori'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _kategori,
              dropdownColor: _bgCard,
              style: const TextStyle(color: _textPrimary),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _textSecondary,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  _kategoriIcon[_kategori] ?? Icons.category_rounded,
                  color: _kategoriColor[_kategori] ?? _accent,
                  size: 20,
                ),
              ),
              items: _kategoriList.map((k) {
                final c = _kategoriColor[k] ?? _accent;
                return DropdownMenuItem(
                  value: k,
                  child: Row(
                    children: [
                      Icon(_kategoriIcon[k], color: c, size: 18),
                      const SizedBox(width: 10),
                      Text(k, style: const TextStyle(color: _textPrimary)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) => setState(() => _kategori = val!),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: katColor,
                  disabledBackgroundColor: katColor.withAlpha(128),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: _loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isEdit
                                ? Icons.save_rounded
                                : Icons.add_circle_outline_rounded,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isEdit ? 'Simpan Perubahan' : 'Tambah Catatan',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: _textSecondary,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );
}

Route _slideRoute(Widget page) => PageRouteBuilder(
  pageBuilder: (_, a, __) => page,
  transitionsBuilder: (_, a, __, child) => SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
    child: child,
  ),
  transitionDuration: const Duration(milliseconds: 300),
);
