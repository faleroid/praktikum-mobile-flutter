import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  // Menyimpan username
  String? namauser;

  // Menyimpan username ke local storage
  Future<void> _saveUsername() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'username',
      _usernameController.text,
    );
  }

  // Membuat input username dan password
  Widget _showInput(
    TextEditingController controller,
    String placeholder,
    bool isPassword,
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: placeholder,
      ),
    );
  }

  // Menampilkan dialog
  void _showDialog(String pesan, Widget halaman) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(pesan),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => halaman,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input username
            _showInput(
              _usernameController,
              'Masukkan Username',
              false,
            ),

            // Input password
            _showInput(
              _passwordController,
              'Masukkan Password',
              true,
            ),

            // Tombol login
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () async {
                if (_usernameController.text == 'admin' &&
                    _passwordController.text == 'admin') {

                  await _saveUsername();

                  _showDialog(
                    'Anda Berhasil Login',
                    const HomePage(),
                  );
                } else {
                  _showDialog(
                    'Username dan Password Salah',
                    const LoginPage(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Membersihkan controller ketika halaman ditutup
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}