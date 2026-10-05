import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  // Singleton pattern (Prinsip PBO Creational Design Pattern)
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  BaseUser? _currentUser;
  bool _isLoading = false;

  BaseUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  /// Preset 1: Dosen / Penilai Matkul PBO
  static AcademicEvaluatorUser get defaultEvaluator => AcademicEvaluatorUser(
        id: 'eval-pbo-01',
        username: 'dosen_pbo',
        displayName: 'Prof. Dr. Ir. Hendra Kusuma, M.Kom.',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
        university: 'Fakultas Ilmu Komputer (Dosen PBO)',
        courseTaught: 'Pemrograman Berorientasi Objek',
      );

  /// Preset 2: Tech Recruiter
  static RecruiterUser get defaultRecruiter => RecruiterUser(
        id: 'rec-02',
        username: 'sarah_hr',
        displayName: 'Sarah Wijaya, S.Psi. (Lead Talent Acquisition)',
        avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80',
        companyName: 'Nusantara Tech Innovator Labs',
      );

  /// Preset 3: Fellow Developer Guest
  static DeveloperGuestUser get defaultDeveloperGuest => DeveloperGuestUser(
        id: 'dev-03',
        username: 'guest_engineer',
        displayName: 'Rian Pratama (Flutter & Java Engineer)',
        avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=400&q=80',
        favoriteLanguage: 'Dart, Java, & C++',
      );

  /// Preset 4: Mahasiswa Pengembang / Author
  static MahasiswaAuthorUser get defaultAuthorStudent => MahasiswaAuthorUser(
        id: 'mhs-author-01',
        username: 'wishangsakti',
        displayName: 'Wishang Sakti H',
        nim: '25051204424',
        avatarUrl: 'assets/images/profile.jpeg',
        programStudi: 'Teknik Informatika (Software Engineering)',
        ipk: 3.92,
      );

  /// Autentikasi menggunakan preset cepat (1-Click Creative Access Pass)
  Future<bool> loginWithPreset(BaseUser presetUser) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi dekripsi token & handshake keamanan
    await Future.delayed(const Duration(milliseconds: 900));

    _currentUser = presetUser;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Autentikasi Mahasiswa menggunakan NIM dan Password
  Future<bool> loginWithNim({
    required String nim,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));

    _currentUser = MahasiswaAuthorUser(
      id: 'mhs-$nim',
      username: nim,
      displayName: 'Wishang ($nim)',
      nim: nim,
      avatarUrl: 'assets/images/profile.jpeg',
      programStudi: 'Teknik Informatika (Software Engineering)',
      ipk: 3.92,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Autentikasi dengan masukan kustom
  Future<bool> loginWithCustom({
    required String username,
    required String password,
    required String roleType,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1100));

    if (roleType == 'dosen') {
      _currentUser = AcademicEvaluatorUser(
        id: 'eval-${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        displayName: '$username (Evaluator PBO)',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
      );
    } else if (roleType == 'recruiter') {
      _currentUser = RecruiterUser(
        id: 'rec-${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        displayName: '$username (Recruiter Access)',
        avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80',
      );
    } else {
      _currentUser = DeveloperGuestUser(
        id: 'dev-${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        displayName: '$username (Developer Guest)',
        avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=400&q=80',
      );
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
