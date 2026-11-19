/// Sementara masih kosong. Suara soal (text-to-speech) dan efek
/// benar/salah kita isi di tahap berikutnya. Layar kuis sudah
/// memanggil fungsi-fungsi ini, jadi nanti cukup isi di sini.
class SoundService {
  SoundService._();

  static Future<void> speak(String text) async {}

  static Future<void> playCorrect() async {}

  static Future<void> playWrong() async {}
}
