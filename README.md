# Garu Belajar - Tahap 1 (setup + tema + menu utama)

## Cara pasang
1. Kalau belum ada project: `flutter create garu_app`, lalu `cd garu_app`
2. Tambah package font: `flutter pub add google_fonts`
3. Salin folder `lib/` dan `assets/` dari zip ini ke dalam project
   (timpa `lib/main.dart` bawaan)
4. Hapus file `test/widget_test.dart` (bawaan Flutter, merujuk ke kode lama)
5. Buka `pubspec.yaml`, di bagian `flutter:` tambahkan:

       flutter:
         uses-material-design: true
         assets:
           - assets/mascot/

   (indentasi spasi harus rapi, jangan pakai tab)
6. `flutter pub get`, lalu `flutter run`

## Catatan
- google_fonts mengunduh font lewat internet saat pertama dijalankan. Sebelum
  rilis, font sebaiknya disimpan di dalam aplikasi supaya jalan offline.
- Gambar Garu masih resolusi kecil, jadi di layar besar bisa agak buram.
  Ganti dengan versi upscale dengan nama file yang sama.
