// ============================================================
// symptom_chat_screen.dart — CHAT GEJALA & PENILAIAN AWAL
// Chat terpandu: tiap jawaban ditambahkan ke daftar pesan, lalu pertanyaan
// berikutnya muncul. Hasil akhir bukan diagnosis (hanya contoh/demo).
// ============================================================

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'care_screens.dart';
import 'health_screen.dart';

class _Question {
  const _Question(this.text, this.options);

  final String text;
  final List<String> options;
}

class _Msg {
  const _Msg(this.text, {this.fromUser = false});

  final String text;
  final bool fromUser;
}

/// Chat gejala terpandu 3 pertanyaan.
class SymptomChatScreen extends StatefulWidget {
  const SymptomChatScreen({super.key, required this.petId});

  final String petId;

  @override
  State<SymptomChatScreen> createState() => _SymptomChatScreenState();
}

class _SymptomChatScreenState extends State<SymptomChatScreen> {
  final _scroll = ScrollController();
  final List<_Msg> _messages = [];
  final List<int> _answers = [];
  int _step = 0;
  bool _waiting = false;

  late final String _petName;

  List<_Question> get _questions => [
    const _Question('Apa yang kamu perhatikan?', [
      'Kulit gatal, merah, dan bulu rontok',
      'Lemas dan tidak mau makan',
      'Muntah atau diare',
      'Pincang atau tampak kesakitan',
    ]),
    const _Question('Sudah berapa lama? Ada perubahan perilaku?', [
      '2 hari. Lebih sering menggaruk, tapi makan dan bermain seperti biasa.',
      'Sejak hari ini. Lebih pendiam dari biasanya.',
      'Lebih dari seminggu. Makin parah.',
    ]),
    _Question(
      'Apakah napas $_petName normal, tanpa pingsan, kejang, atau pendarahan hebat?',
      ['Ya, tidak ada yang tersebut', 'Tidak / ragu'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    final state = context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
    _petName = state.petById(widget.petId)?.name ?? 'hewanmu';
    _messages.add(_Msg(_questions.first.text));
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _answer(int index) {
    if (_waiting) return;
    final q = _questions[_step];
    final isLast = _step == _questions.length - 1;
    // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
    setState(() {
      _messages.add(_Msg(q.options[index], fromUser: true));
      _answers.add(index);
    });
    _scrollDown();

    if (isLast) {
      if (index == 1) {
        // NAVIGASI: ganti halaman ini dengan halaman baru (tidak bisa kembali ke sini).
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => UrgentCareScreen(petId: widget.petId),
          ),
        );
      } else {
        // NAVIGASI: ganti halaman ini dengan halaman baru (tidak bisa kembali ke sini).
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => AssessmentScreen(
              petId: widget.petId,
              answers: List.of(_answers),
            ),
          ),
        );
      }
      return;
    }

    // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
    setState(() => _waiting = true);
    Future<void>.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      // setState: memberi tahu Flutter data berubah sehingga layar digambar ulang.
      setState(() {
        _step++;
        _waiting = false;
        _messages.add(_Msg(_questions[_step].text));
      });
      _scrollDown();
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_step];
    final stepNumber = _step + 2; // step 1 was choosing the pet
    // SCAFFOLD = kerangka satu halaman (background, body, dll.).
    return Scaffold(
      backgroundColor: AppTheme.canvas,
      // SAFEAREA: menjaga konten tidak tertutup poni/status bar/navigation bar.
      body: SafeArea(
        child: Column(
          children: [
            // PADDING: memberi ruang kosong di sekeliling child.
            Padding(
              // jarak dalam (padding): kiri 8, atas 6, kanan 14, bawah 0
              padding: const EdgeInsets.fromLTRB(8, 6, 14, 0),
              child: Row(
                children: [
                  // TOMBOL bawaan Flutter. onPressed = aksi saat ditekan.
                  IconButton(
                    // NAVIGASI: kembali / tutup halaman atau sheet ini.
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppTheme.purpleDark,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Chat gejala',
                      style: TextStyle(
                        color: AppTheme.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // PADDING: memberi ruang kosong di sekeliling child.
            Padding(
              // jarak dalam (padding): kiri 18, atas 2, kanan 18, bawah 8
              padding: const EdgeInsets.fromLTRB(18, 2, 18, 8),
              child: Column(
                // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pemeriksaan $_petName · Langkah $stepNumber dari 5',
                    style: const TextStyle(color: AppTheme.muted, fontSize: 11),
                  ),
                  // jarak vertikal 6
                  const SizedBox(height: 6),
                  ClipRRect(
                    // sudut membulat radius 6
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: stepNumber / 5,
                      minHeight: 5,
                      backgroundColor: Colors.white,
                      color: AppTheme.purple,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              // LISTVIEW: daftar yang bisa di-scroll; padding = jarak di sekeliling isi.
              child: ListView(
                controller: _scroll,
                // jarak dalam (padding): kiri 18, atas 4, kanan 18, bawah 12
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
                children: [
                  WhiteCard(
                    color: AppTheme.lilac,
                    shadow: false,
                    // jarak dalam (padding) 10 di semua sisi
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.shield_outlined,
                          size: 16,
                          color: AppTheme.purpleDark,
                        ),
                        // jarak horizontal 8
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Hanya penyaringan, bukan diagnosis. Dokter hewan harus memeriksa $_petName.',
                            style: const TextStyle(
                              color: AppTheme.purpleDark,
                              fontSize: 11,
                              // tinggi 1.35 px
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // jarak vertikal 12
                  const SizedBox(height: 12),
                  for (final m in _messages) _Bubble(msg: m),
                ],
              ),
            ),
            Container(
              // jarak dalam (padding): kiri 18, atas 12, kanan 18, bawah 6
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_waiting)
                    for (var i = 0; i < q.options.length; i++)
                      // PADDING: memberi ruang kosong di sekeliling child.
                      Padding(
                        // jarak dalam (padding): bawah: 8
                        padding: const EdgeInsets.only(bottom: 8),
                        // TOMBOL (AppButton). onPressed = aksi saat ditekan.
                        child: AppButton(
                          label: q.options[i],
                          kind: i == 0
                              ? AppButtonKind.primary
                              : AppButtonKind.soft,
                          // tinggi 40 px
                          height: 40,
                          fontSize: 11,
                          onPressed: () => _answer(i),
                        ),
                      ),
                  if (_waiting)
                    // PADDING: memberi ruang kosong di sekeliling child.
                    const Padding(
                      // jarak dalam (padding): atas-bawah: 14
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        '…',
                        style: TextStyle(color: AppTheme.muted, fontSize: 20),
                      ),
                    ),
                  Row(
                    // item didorong ke ujung-ujung, sisa ruang di antaranya
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // TOMBOL bawaan Flutter. onPressed = aksi saat ditekan.
                      TextButton(
                        // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                UrgentCareScreen(petId: widget.petId),
                          ),
                        ),
                        child: const Text(
                          'Bantuan darurat',
                          style: TextStyle(
                            color: AppTheme.rose,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      // TOMBOL bawaan Flutter. onPressed = aksi saat ditekan.
                      TextButton(
                        // NAVIGASI: kembali / tutup halaman atau sheet ini.
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Keluar dari cek',
                          style: TextStyle(
                            color: AppTheme.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg});

  final _Msg msg;

  @override
  Widget build(BuildContext context) {
    final user = msg.fromUser;
    // ALIGN: menempatkan child pada posisi tertentu (alignment).
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        // jarak luar (margin): bawah: 10
        margin: const EdgeInsets.only(bottom: 10),
        // jarak dalam (padding): kiri-kanan: 14, atas-bawah: 10
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          color: user ? AppTheme.purple : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(user ? 16 : 4),
            bottomRight: Radius.circular(user ? 4 : 16),
          ),
          boxShadow: user ? null : AppTheme.softShadow,
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: user ? Colors.white : AppTheme.ink,
            fontSize: 12,
            // tinggi 1.35 px
            height: 1.35,
          ),
        ),
      ),
    );
  }
}

class _Result {
  const _Result(this.title, this.steps);

  final String title;
  final List<String> steps;
}

const _results = <_Result>[
  _Result('Kemungkinan iritasi kulit / dermatitis', [
    'Jadwalkan pemeriksaan kulit ke dokter hewan.',
    'Catat perubahan dan hindari produk baru.',
    'Jangan pakai obat atau krim untuk manusia.',
  ]),
  _Result('Kemungkinan sakit umum atau nafsu makan menurun', [
    'Segera jadwalkan pemeriksaan ke dokter hewan.',
    'Catat kapan dan apa yang terakhir dimakan dan diminum.',
    'Jangan beri obat manusia.',
  ]),
  _Result('Kemungkinan gangguan perut', [
    'Jadwalkan pemeriksaan ke dokter hewan, terutama jika berlanjut.',
    'Catat seberapa sering terjadi.',
    'Jangan beri obat manusia.',
  ]),
  _Result('Kemungkinan cedera otot atau rasa tidak nyaman', [
    'Jadwalkan pemeriksaan ke dokter hewan.',
    'Jaga tetap tenang dan batasi lompatan.',
    'Jangan beri obat pereda nyeri manusia.',
  ]),
];

const _firstOptions = [
  'Kulit gatal, merah, dan bulu rontok',
  'Lemas dan tidak mau makan',
  'Muntah atau diare',
  'Pincang atau tampak kesakitan',
];
const _secondOptions = [
  '2 hari. Lebih sering menggaruk, tapi makan dan bermain seperti biasa.',
  'Sejak hari ini. Lebih pendiam dari biasanya.',
  'Lebih dari seminggu. Makin parah.',
];

/// Hasil penilaian awal berdasarkan jawaban chat.
class AssessmentScreen extends StatelessWidget {
  const AssessmentScreen({
    super.key,
    required this.petId,
    required this.answers,
  });

  final String petId;
  final List<int> answers;

  @override
  Widget build(BuildContext context) {
    // Mengambil AppState (data pet, sesi, profil) dari AppScope.
    final pet = AppScope.of(context).petById(petId);
    final name = pet?.name ?? 'Hewanmu';
    final first = answers.isNotEmpty ? answers[0] : 0;
    final second = answers.length > 1 ? answers[1] : 0;
    final result = _results[first.clamp(0, _results.length - 1)];
    final shared = '${_firstOptions[first]} · ${_secondOptions[second]}';

    return AppPage(
      title: 'Pemeriksaan $name',
      subtitle: 'Penilaian awal · Contoh hasil',
      children: [
        const SectionHeading(title: 'Yang kamu ceritakan'),
        // jarak vertikal 6
        const SizedBox(height: 6),
        WhiteCard(
          child: Text(
            shared,
            style: const TextStyle(
              color: AppTheme.ink,
              fontSize: 12,
              // tinggi 1.4 px
              height: 1.4,
            ),
          ),
        ),
        // jarak vertikal 16
        const SizedBox(height: 16),
        const SectionHeading(title: 'Kemungkinan sementara'),
        // jarak vertikal 6
        const SizedBox(height: 6),
        Container(
          // jarak dalam (padding) 14 di semua sisi
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.lilac,
            // sudut membulat radius 18
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.title,
                style: const TextStyle(
                  color: AppTheme.purpleDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // jarak vertikal 4
              const SizedBox(height: 4),
              const Text(
                'Beberapa kondisi tampak mirip. Chat tidak dapat memastikan penyebabnya.',
                style: TextStyle(
                  color: AppTheme.muted,
                  fontSize: 11,
                  // tinggi 1.4 px
                  height: 1.4,
                ),
              ),
              // jarak vertikal 8
              const SizedBox(height: 8),
              const Pill(
                label: 'Bukan diagnosis — dokter hewan harus memastikan',
                bg: Colors.white,
                icon: Icons.info_outline,
              ),
            ],
          ),
        ),
        // jarak vertikal 16
        const SizedBox(height: 16),
        const SectionHeading(title: 'Langkah selanjutnya'),
        // jarak vertikal 6
        const SizedBox(height: 6),
        WhiteCard(
          child: Column(
            children: [
              for (final s in result.steps)
                // PADDING: memberi ruang kosong di sekeliling child.
                Padding(
                  // jarak dalam (padding): atas-bawah: 4
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    // rata ke awal pada sumbu silang (Column: rata kiri, Row: rata atas)
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: AppTheme.purple,
                      ),
                      // jarak horizontal 8
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          s,
                          style: const TextStyle(
                            color: AppTheme.ink,
                            fontSize: 12,
                            // tinggi 1.35 px
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        // jarak vertikal 16
        const SizedBox(height: 16),
        const SectionHeading(title: 'Dokter hewan terdekat yang disarankan'),
        // jarak vertikal 8
        const SizedBox(height: 8),
        ProviderCard(provider: kProviders.first, reason: _firstOptions[first]),
        // jarak vertikal 4
        const SizedBox(height: 4),
        // TOMBOL TEKS «Gejala memburuk? Cari perawatan darurat →» (LinkButton). onPressed = aksi saat ditekan.
        LinkButton(
          label: 'Gejala memburuk? Cari perawatan darurat →',
          color: AppTheme.rose,
          // NAVIGASI: buka halaman baru di atas halaman ini (tombol kembali akan muncul).
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => UrgentCareScreen(petId: petId),
            ),
          ),
        ),
      ],
    );
  }
}
