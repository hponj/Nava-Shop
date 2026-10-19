import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  // simpan session
  static Future<void> login(String username) async {
    // inisialisasi shared preferences
    final prefs = await SharedPreferences.getInstance();
    // mengatur nilai boolean untuk menandai bahwa pengguna telah login
    await prefs.setBool('isLogin', true);

    // mengatur nilai string untuk menyimpan username pengguna
    await prefs.setString('username', username);
  }
  // cek sudah login atau belum
  static Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    // ?? jika nilai boolean tidak ada, maka akan mengembalikan false
    return prefs.getBool('isLogin') ?? false;
  }

  // ambil username

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  // logout

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    await prefs.remove('username');
  }
}
