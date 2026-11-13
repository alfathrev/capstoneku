// ============================================================
// app_state.dart — DATA & STATE APLIKASI
// - Model: Pet, HistorySession, CareProvider, Booking, UserProfile.
// - AppState (ChangeNotifier): menyimpan daftar pet, sesi, booking, profil.
//   Setiap kali data berubah, notifyListeners() dipanggil sehingga layar
//   yang memakai AppScope.of(context) otomatis digambar ulang.
// - AppScope (InheritedNotifier): cara "membagikan" AppState ke seluruh widget.
// ============================================================

import 'package:flutter/material.dart';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];
const _weekdays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

String shortDate(DateTime d) => '${d.day} ${_months[d.month - 1]}';
String fullShortDate(DateTime d) =>
    '${d.day} ${_months[d.month - 1]} ${d.year}';
String weekdayDate(DateTime d) =>
    '${_weekdays[d.weekday - 1]} ${d.day} ${_months[d.month - 1]}';
String formatTime(TimeOfDay t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
String formatWeight(double w) =>
    w == w.roundToDouble() ? w.toStringAsFixed(0) : w.toString();

/// Model data satu hewan peliharaan.
class Pet {
  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.sex,
    required this.breed,
    required this.weight,
    required this.age,
  });

  final String id;
  String name;
  String type;
  String sex;
  String breed;
  double weight;
  int age;

  String get ageLabel => age == 1 ? '1 Tahun' : '$age Tahun';
  String get summary => '$breed · $sex · $age tahun';
}

/// Model satu sesi di Riwayat Sesi.
class HistorySession {
  const HistorySession({
    required this.id,
    required this.petId,
    required this.type,
    required this.date,
    required this.time,
    required this.provider,
    this.notes = '',
    this.rating,
  });

  final String id;
  final String petId;
  final String type;
  final DateTime date;
  final String time;
  final String provider;
  final String notes;
  final double? rating;
}

/// Model penyedia perawatan (klinik/petshop).
class CareProvider {
  const CareProvider({
    required this.id,
    required this.name,
    required this.tagline,
    required this.distance,
    required this.rating,
    required this.hours,
    required this.address,
    required this.services,
    required this.carMinutes,
    required this.walkMinutes,
    this.emergency = false,
  });

  final String id;
  final String name;
  final String tagline;
  final String distance;
  final String rating;
  final String hours;
  final String address;
  final List<String> services;
  final int carMinutes;
  final int walkMinutes;
  final bool emergency;

  String get shortName => name.split(' ').first;
}

const kProviders = <CareProvider>[
  CareProvider(
    id: 'pawcare',
    name: 'PawCare Vet & Petshop',
    tagline: 'Dokter Hewan & Petshop',
    distance: '1.2 km',
    rating: '4.8',
    hours: '09:00–21:00',
    address: 'Jl. Willow 38, Distrik Maple',
    services: [
      'Konsultasi dokter hewan',
      'Cek kulit & bulu',
      'Pemeriksaan umum',
      'Vaksinasi',
    ],
    carMinutes: 5,
    walkMinutes: 15,
  ),
  CareProvider(
    id: 'willow',
    name: 'Willow Veterinary Clinic',
    tagline: 'Klinik hewan',
    distance: '2.4 km',
    rating: '4.7',
    hours: '08:00–20:00',
    address: 'Jl. Birch 12, Distrik Maple',
    services: ['Konsultasi dokter hewan', 'Pemeriksaan umum', 'Vaksinasi'],
    carMinutes: 9,
    walkMinutes: 28,
  ),
  CareProvider(
    id: 'nightpaws',
    name: 'NightPaws Emergency Vet',
    tagline: 'Tim dokter hewan darurat',
    distance: '2.8 km',
    rating: '4.9',
    hours: 'Buka 24 jam',
    address: 'Jl. Oak 7, Distrik Maple',
    services: ['Emergency care', 'Konsultasi dokter hewan'],
    carMinutes: 11,
    walkMinutes: 34,
    emergency: true,
  ),
];

CareProvider get kEmergencyProvider =>
    kProviders.firstWhere((p) => p.emergency);

/// Model booking kunjungan (demo).
class Booking {
  const Booking({
    required this.provider,
    required this.petId,
    required this.date,
    required this.time,
    required this.reason,
  });

  final CareProvider provider;
  final String petId;
  final DateTime date;
  final String time;
  final String reason;

  String get endTime {
    final parts = time.split(':');
    final total = int.parse(parts[0]) * 60 + int.parse(parts[1]) + 30;
    final h = (total ~/ 60) % 24;
    final m = total % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}

/// Model data profil pengguna.
class UserProfile {
  UserProfile({
    this.fullName = '',
    this.username = 'fathrev',
    this.phone = '',
    this.email = '',
    this.location = '',
    this.placeOfBirth = '',
    this.dateOfBirth = '',
    this.hasPhoto = false,
  });

  String fullName;
  String username;
  String phone;
  String email;
  String location;
  String placeOfBirth;
  String dateOfBirth;
  bool hasPhoto;

  String get initial =>
      (fullName.isNotEmpty ? fullName : username).substring(0, 1).toUpperCase();
}

/// Penyimpan data aplikasi. notifyListeners() membuat layar terkait digambar ulang.
class AppState extends ChangeNotifier {
  final List<Pet> pets = [
    Pet(
      id: 'arthur',
      name: 'Arthur',
      type: 'Kucing',
      sex: 'Jantan',
      breed: 'Persia',
      weight: 8,
      age: 2,
    ),
  ];

  final List<HistorySession> sessions = [
    HistorySession(
      id: 's1',
      petId: 'arthur',
      type: 'Grooming',
      date: DateTime(2026, 8, 23),
      time: '14:15',
      provider: 'Nama Petshop',
      rating: 4.5,
    ),
  ];

  Booking? booking;
  final UserProfile profile = UserProfile();

  Pet? petById(String? id) {
    for (final pet in pets) {
      if (pet.id == id) return pet;
    }
    return null;
  }

  List<HistorySession> sessionsSorted({String? petId}) {
    final list = sessions
        .where((s) => petId == null || s.petId == petId)
        .toList();
    list.sort((a, b) {
      final byDate = b.date.compareTo(a.date);
      return byDate != 0 ? byDate : b.time.compareTo(a.time);
    });
    return list;
  }

  void addPet(Pet pet) {
    pets.add(pet);
    notifyListeners();
  }

  void updatePet(Pet updated) {
    final index = pets.indexWhere((p) => p.id == updated.id);
    if (index == -1) return;
    pets[index] = updated;
    notifyListeners();
  }

  void deletePet(String id) {
    pets.removeWhere((p) => p.id == id);
    sessions.removeWhere((s) => s.petId == id);
    if (booking?.petId == id) booking = null;
    notifyListeners();
  }

  void addSession(HistorySession session) {
    sessions.add(session);
    notifyListeners();
  }

  void setBooking(Booking? value) {
    booking = value;
    notifyListeners();
  }

  void touchProfile() => notifyListeners();
}

/// Membagikan AppState ke semua widget di bawahnya. Pakai AppScope.of(context).
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!.notifier!;
  }
}
