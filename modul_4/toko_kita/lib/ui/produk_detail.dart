
import 'package:flutter/material.dart';
import 'package:toko_kita/bloc/produk_bloc.dart';
import 'package:toko_kita/model/produk.dart';
import 'package:toko_kita/ui/produk_form.dart';
import 'package:toko_kita/ui/produk_page.dart';
import 'package:toko_kita/widget/warning_dialog.dart';

class ProdukDetail extends StatefulWidget {
  final Produk? produk;

  const ProdukDetail({
    Key? key,
    this.produk,
  }) : super(key: key);

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kode : ${produk.kodeProduk}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              "Nama : ${produk.namaProduk}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Harga : Rp. ${produk.hargaProduk}",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  // Tombol Edit dan Delete
  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(
                  produk: widget.produk!,
                ),
              ),
            );
          },
        ),

        const SizedBox(width: 10),

        // Tombol Delete
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: _isLoading ? null : confirmHapus,
        ),
      ],
    );
  }

  // Dialog konfirmasi penghapusan
  void confirmHapus() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: const Text(
            "Yakin ingin menghapus data ini?",
          ),
          actions: [
            // Tombol Ya
            OutlinedButton(
              child: const Text("Ya"),
              onPressed: () {
                Navigator.pop(dialogContext);
                hapusProduk();
              },
            ),

            // Tombol Batal
            OutlinedButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  // Proses menghapus produk melalui REST API
  Future<void> hapusProduk() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ProdukBloc.deleteProduk(
        id: widget.produk!.id,
      );

      if (!mounted) return;

      if (result) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ProdukPage(),
          ),
          (route) => false,
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => const WarningDialog(
            description: "Hapus produk gagal, silahkan coba lagi",
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => const WarningDialog(
          description: "Terjadi kesalahan saat menghapus produk",
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
