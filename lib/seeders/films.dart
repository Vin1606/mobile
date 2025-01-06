import 'package:sqflite/sqflite.dart';

Future<void> seedFilms(Batch batch) async {
  batch.insert('films', {
    'title': 'Venom: The Last Dance',
    'description':
        'Eddie dan Venom kini sedang diburu. Dengan semakin dekatnya mereka, keduanya bersatu dan terpaksa mengambil keputusan berat. Apakah kali ini Eddie dan Venom akan berpisah?',
    'director': 'Kelly Marcel',
    'rating': 'R13+',
    'language': 'English',
    'subtitle': 'Indonesia',
    'trailer': 'https://www.youtube.com/embed/__2bjWbetsA?si=XiZb1kQ31RIvpX_S',
    'poster':
        'https://m.media-amazon.com/images/M/MV5BZDMyYWU4NzItZDY0MC00ODE2LTkyYTMtMzNkNDdmYmFhZDg0XkEyXkFqcGc@._V1_FMjpg_UX1080_.jpg',
    'genre': 'Action',
    'duration': 109,
    'created_at': DateTime.now().toString(),
    'updated_at': DateTime.now().toString(),
  });
  batch.insert('films', {
    'title': 'Kuasa Gelap',
    'description':
        'Setelah kematian ibu dan adiknya dalam kecelakaan tragis, Thomas (Jerome Kurnia) bermaksud mengundurkan diri sebagai Romo. Namun dirinya justru diberi tugas terakhir untuk membantu Romo eksorsis, Rendra (Lukman Sardi), yang kesehatannya kian menurun, untuk mengusir iblis yang merasuki Kayla (Lea Ciarachel), sahabat mendiang adiknya. Thomas dan Rendra berusaha sekuat tenaga untuk mengusir iblis yang bersemayam dalam tubuh Kayla. Ternyata sosok iblis itu sangat kuat. Bukan saja mengancam nyawa Kayla tetapi juga Maya (Astrid Tiar), ibu Kayla yang menyimpan masa lalu gelap hingga membuatnya dikejar rasa bersalah. Kuasa Gelap adalah film horor pertama di Indonesia yg mengangkat ritual Gereja Katolik berdasarkan kasus nyata Eksorsisme.',
    'director': 'Bobby Prasetyo',
    'rating': 'D17+',
    'language': 'Indonesia',
    'subtitle': 'Indonesia',
    'trailer': 'https://www.youtube.com/embed/sMkUS1wqr8Q',
    'poster':
        'https://m.media-amazon.com/images/M/MV5BMmVhMTUzZjQtZTY0My00MDE2LWFkN2ItMDk4OTI1MWVkYmYyXkEyXkFqcGc@._V1_FMjpg_UX1080_.jpg',
    'genre': 'Horror',
    'duration': 96,
    'created_at': DateTime.now().toString(),
    'updated_at': DateTime.now().toString(),
  });
}
