import 'dart:io';
import 'dart:developer' as developer;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'aaima.db');

    developer.log('Database path: $path', name: 'DatabaseHelper');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    developer.log('Creating database...', name: 'DatabaseHelper');

    // Create tables
    await _createRukunImanTable(db);
    await _createContentBlocksTable(db);
    await _createVideosTable(db);
    await _createVideoLinksTable(db);

    // Insert initial data
    await _insertInitialData(db);

    developer.log('Database created and data inserted!', name: 'DatabaseHelper');
  }

  // ============ TABLE CREATION ============

  Future<void> _createRukunImanTable(Database db) async {
    await db.execute('''
      CREATE TABLE rukun_iman (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        subtitle TEXT,
        date TEXT,
        category TEXT NOT NULL,
        created_at TEXT
      )
    ''');
  }

  Future<void> _createContentBlocksTable(Database db) async {
    await db.execute('''
      CREATE TABLE content_blocks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rukun_iman_id INTEGER NOT NULL,
        text TEXT NOT NULL,
        is_bold INTEGER DEFAULT 0,
        is_arabic INTEGER DEFAULT 0,
        sort_order INTEGER DEFAULT 0,
        FOREIGN KEY (rukun_iman_id) REFERENCES rukun_iman(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _createVideosTable(Database db) async {
    await db.execute('''
      CREATE TABLE videos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        youtube_id TEXT NOT NULL,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        duration TEXT,
        sort_order INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> _createVideoLinksTable(Database db) async {
    await db.execute('''
      CREATE TABLE video_links (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        video_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        url TEXT NOT NULL,
        url_text TEXT NOT NULL,
        FOREIGN KEY (video_id) REFERENCES videos(id) ON DELETE CASCADE
      )
    ''');
  }

  // ============ INSERT ALL INITIAL DATA ============

  Future<void> _insertInitialData(Database db) async {
    await _insertRukunImanData(db);
    await _insertVideoData(db);
  }

  Future<void> _insertRukunImanData(Database db) async {
    // Insert all categorie
    final pengenalanId = await _insertPengenalan(db);
    final pertamaId = await _insertRukunPertama(db);
    final keduaId = await _insertRukunKedua(db);
    final ketigaId = await _insertRukunKetiga(db);
    final keempatId = await _insertRukunKeempat(db);
    final kelimaId = await _insertRukunKelima(db);
    final keenamId = await _insertRukunKeenam(db);
  }

  // ============ INSERT PENGENALAN ============

  Future<int> _insertPengenalan(Database db) async {
    final id = await db.insert('rukun_iman', {
      'title': 'RUKUN IMAN: PENGENALAN',
      'subtitle': 'May 24, 2019',
      'date': '2019-05-24',
      'category': 'pengenalan',
      'created_at': DateTime.now().toIso8601String(),
    });

    final content = [
      'Firman Allah Taala: "….kebajikan itu ialah beriman kepada Allah, Hari Akhirat, para malaikat, kitab-kitab dan nabi-nabi". (Surah Al-Baqarah, Ayat 177).',
      'Firman Allah Taala: "Semuanya beriman kepada Allah, malaikat-malaikat-Nya, kitab-kitab-Nya dan rasul-rasul-Nya. Mereka berkata: Kami tidak membezakan antara seorang dengan yang lain dari rasul-rasul-Nya". (Surah Al-Baqarah, Ayat 285).',
      '"Sesungguhnya Kami menciptakan setiap sesuatu menurut takdir (yang telah ditentukan)". (Surah Al-Qamar, Ayat 49).',
      'Sabda Rasulullah s.a.w:',
      'الإيمان أن تؤمن بالله، وملائكته، وكتبه، ورسله، واليوم الآخر، وتؤمن بالقدر خير وشره . [ رواه مسلم ].',
      '"Iman itu ialah: Engkau beriman dengan Allah, para malaikat-Nya, kitab-kitab-Nya, rasul-rasul-Nya dan Hari Akhirat serta Qadar (untung) baik dan yang tidak baik". (Hadith riwayat Muslim).',
      'Iman itu: Pengucapan dengan lidah, iktikad (percaya) dengan hati dan beramal dengan anggota, iman bertambah dengan melakukan ketaatan serta berkurangan dengan sebab melakukan maksiat.',
      'Firman Allah Taala: "Sesungguhnya orang-orang yang beriman itu (yang sempurna imannya) ialah mereka yang apabila disebut (nama) Allah (dan sifat-sifat-Nya) gementarlah hati mereka dan apabila dibacakan kepada mereka ayat-ayat-Nya, maka bertambah iman mereka dan kepada Tuhan mereka jualah mereka berserah. Orang-orang yang mendirikan solat dan yang mendermakan sebahagian daripada rezeki yang Kami kurniakan kepada mereka, merekalah orang-orang yang beriman dengan sebenar-benarnya. Mereka akan mendapat pangkat-pangkat yang tinggi di sisi Tuhan mereka dan keampunan serta limpah kurnia yang mulia (syurga)". (Surah Al-Anfal, Ayat 2-4).',
      'Firman Allah Taala: "Sesiapa yang kufur kepada Allah, malaikat-malaikat-Nya, kitab-kitab-Nya dan rasul-rasul-Nya juga Hari Akhirat, maka sesungguhnya ia telah sesat dengan kesesatan yang sejauh-jauhnya". (Surah An-Nisa\', Ayat 136).',
      'Iman dengan lidah adalah seperti zikir, doa, amar makruf nahi mungkar, membaca Al-Quran dan seumpamanya.',
      'Manakala iman dengan hati adalah seperti iktikad (percaya) kepada keesaan Allah dalam "Rububiyyah" (kekuasaan)-Nya, "Uluhiyyah" (ketuhanan)-Nya, nama-nama-Nya, sifat-sifat-Nya dan wajib menyembah-Nya dengan tidak ada sekutu bagi-Nya serta semua perkara yang berkaitan dengannya daripada niat dan "maqasid" (tujuan).',
      'Termasuk juga dalam takrifan iman ialah amalan-amalan hati, seperti cintakan Allah, takutkan-Nya, sentiasa kembali kepadaNya, bertawakkal kepada-Nya dan sebagainya.',
      'Juga termasuk dalam kategori iman, amalan-amalan yang dilakukan oleh anggota, antaranya: Solat, puasa, semua Rukun Islam yang lain, berjihad pada jalan Allah, menuntut ilmu dan lain-lain.',
      'Firman Allah Taala: "Dan apabila dibacakan kepada mereka ayat-ayat-Nya, maka bertambah iman mereka". (Surah Al-Anfal, Ayat 2).',
      'Firman Allah Taala: "(Dialah Tuhan yang membuka jalan kemenangan itu) Dialah yang menurunkan ketenangan ke dalam hati orang-orang yang beriman (semasa mereka meradang terhadap angkara musuh) supaya keimanan dan keyakinan mereka bertambah di samping keimanan dan keyakinan mereka yang telah sedia ada". (Surah Al-Fath, Ayat 4).',
      'Iman itu bertambah apabila bertambahnya ketaatan dan pendekatan diri seseorang kepada Allah dan iman akan berkurang apabila kurang amalan dan pendekatan diri seseorang kepada Allah, demikian juga dengan maksiat, ia akan mengurangkan kesempurnaan iman. Apabila perbuatan syirik yang besar atau perbuatan kufur yang besar dilakukan maka terungkailah asas iman menurut syarak dan terbatallah iman seseorang itu, manakala sekiranya perbuatan syirik kecil dilakukan maka ianya merosakkan kesempurnaan iman yang wajib atau mengeruhkan kemurniannya serta melemahkannya.',
      'Firman Allah Taala: "Sesungguhnya Allah tidak akan mengampunkan dosa syirik (mempersekutukan)-Nya (dengan sesuatu yang lain) dan akan mengampunkan dosa yang lain dari itu bagi sesiapa yang dikehendaki-Nya". (Surah An-Nisa\', Ayat 48).',
      'Firman Allah Taala: "Mereka bersumpah dengan nama Allah bahawa mereka tidak mengatakan (sesuatu yang buruk terhadapmu), padahal sesungguhnya mereka telah mengatakan kufur dan mereka pula menjadi kafir sesudah (melahirkan) Islam". (Surah At-Taubah, Ayat 74).',
      'Sabda Nabi s.a.w:',
      'لا يزني الزاني حين يزني وهو مؤمن، ولا يسرق السارق حين يسرق وهو مؤمن، ولا يشرب الخمر حين شربها وهو مؤمن . [ متفق عليه ].',
      '"Tidak berzina seorang penzina ketika melakukan zina dalam keadaan dia beriman, tidak mencuri seorang pencuri ketika mencuri dalam keadaan dia beriman dan tidak minum arak seseorang ketika meminumnya dalam keadaan dia beriman". (Hadith Muttafaq \'Alaih: Al-Bukhari dan Muslim)',
    ];

    final boldIndices = [3, 18];
    final arabicIndices = [4, 19];

    for (var i = 0; i < content.length; i++) {
      await db.insert('content_blocks', {
        'rukun_iman_id': id,
        'text': content[i],
        'is_bold': boldIndices.contains(i) ? 1 : 0,
        'is_arabic': arabicIndices.contains(i) ? 1 : 0,
        'sort_order': i,
      });
    }

    return id;
  }

  // ============ INSERT RUKUN PERTAMA ============

  Future<int> _insertRukunPertama(Database db) async {
    final id = await db.insert('rukun_iman', {
      'title': 'RUKUN PERTAMA: BERIMAN KEPADA ALLAH',
      'subtitle': 'May 24, 2019',
      'date': '2019-05-24',
      'category': 'pertama',
      'created_at': DateTime.now().toIso8601String(),
    });

    final content = [
      'A – TAHKIK (PERLAKSANAAN) NYA',
      'Beriman kepada Allah akan terlaksana dengan melakukan perkara-perkara berikut:',
      '1. Iktiqad (Percaya) Bahawa Alam Ini Mempunyai Pencipta Yang Satu',
      'Iktiqad (percaya) bahawa alam ini mempunyai Pencipta yang satu, Esa dalam penciptaan-Nya, kerajaan-Nya, pentadbiran-Nya, mengatur keadaannya, memberi rezeki, kuasa, melakukan sesuatu, menghidupkan, mematikan, memberi manfaat dan mudharat yang tiada tuhan selain dari-Nya.',
      'Melakukan segala perkara dengan keesaan-Nya dan menghukum dengan hukuman yang dikehendaki-Nya, memuliakan sesiapa yang dikehendaki dan menghina sesiapa yang dikehendaki-Nya. Di tangan-Nya kekuasaan langit dan bumi dan Dia berkuasa ke atas semua perkara, mengetahui semua perkara, terkaya (tidak memerlukan) dari semua makhluk, bagi-Nya segala urusan, di tangan-Nya segala kebaikan, tidak ada sekutu dalam perbuatan-Nya, tidak ada yang boleh mengatasi semua urusan-Nya bahkan semua makhluk termasuk malaikat, manusia dan jin adalah hamba-Nya, tidak ada yang mampu keluar dari kerajaan, kekuasaan dan kehendak-Nya Yang Maha Suci.',
      'Perbuatan-Nya tidak terhad, tidak terbilang banyaknya. Semua keistimewaan tersebut adalah kepunyaan Allah, tidak ada sekutu bagi-Nya, tidak berhak seorang pun selain daripada-Nya dan tidak harus menisbahkan atau mengisbatkan sesuatu darinya kepada pencipta yang lain daripada Allah \'Azza Wajalla.',
      'Firman Allah Taala: "Wahai sekalian manusia! Beribadatlah kepada Tuhan kamu yang telah menciptakan kamu dan orang-orang yang terdahulu daripada kamu, supaya kamu (menjadi orang-orang yang) bertakwa. Dialah yang menjadikan bumi ini untuk kamu sebagai hamparan dan langit (serta segala isinya) seperti bangunan (yang dibina dengan kukuhnya) dan Dialah yang menurunkan air hujan dari langit, lalu dikeluarkan-Nya dengan air itu berjenis-jenis buah-buahan yang menjadi rezeki bagi kamu". (Surah Al-Baqarah, ayat 21-22).',
      'Firman Allah Taala: "Katakanlah (wahai Muhammad), wahai Tuhan Yang Mempunyai kuasa pemerintahan, Engkaulah yang memberikan kuasa pemerintahan kepada sesiapa yang Engkau kehendaki dan Engkaulah yang mencabut kuasa pemerintahan daripada sesiapa yang Engkau kehendaki. Engkaulah juga yang memuliakan sesiapa yang Engkau kehendaki. Dan Engkaulah yang menghinakan sesiapa yang Engkau kehendaki. Dalam kekuasaan Engkaulah sahaja adanya segala kebaikan. Sesungguhnya Engkau amat berkuasa atas tiap-tiap sesuatu". (Surah Ali \'Imran, ayat 26).',
      'Firman Allah Taala: "Dan tiadalah sesuatupun daripada makhluk-makhluk yang bergerak di atas muka bumi melainkan Allah jualah yang menanggung rezekinya dan mengetahui tempat kediamannya dan tempat ia disimpan. Semuanya itu tersurat di dalam kitab ("Lauh Mahfuz") yang nyata (kepada malaikat-malaikat yang berkenaan)". (Surah Hud, ayat 6).',
      'Firman Allah Taala: "Ingatlah, bagi Allah jualah segala urusan menciptakan (sekalian makhluk) dan urusan pemerintahan. Maha Suci Allah yang menciptakan dan mentadbirkan sekalian alam". (Surah Al-A\'raf, ayat 54).',
      '2. Iktiqad Dengan Nama-Nama Yang Indah Dan Sifat-Sifat Yang Sempurna',
      'Beriktiqad (percaya) dengan keesaan Allah dengan nama-nama yang seindah-indahnya dan sesempurna sifat-sifat yang diperkenalkan kepada hamba-hamba-Nya yang sebahagiannya terdapat dalam kitab-Nya (Al-Quran) atau Sunnah Nabi Muhammad s.a.w.',
      'Firman Allah Taala: "Dan Allah mempunyai nama-nama yang baik (yang mulia) oleh itu serukanlah (dan berdoalah) kepada-Nya dengan menyebut nama-nama itu dan tinggalkanlah orang-orang yang berpaling daripada kebenaran dalam masa menggunakan nama-nama-Nya. Mereka akan mendapat balasan daripada perbuatan yang telah mereka kerjakan". (Surah Al-A\'raf, ayat 180).',
      'Sabda Nabi s.a.w:',
      'إن لله تسعة وتسعين اسماً، من أحصاها دخل الجنة، وهو وتر يحب الوتر [متفق عليه]',
      '"Sesungguhnya bagi Allah 99 nama. Sesiapa yang menghitungnya masuk syurga. Dan Allah adalah "witir" (tunggal) dan Dia suka kepada witir (bilangan ganjil)". (Muttafaq \'Alaih: Al-Bukhari dan Muslim).',
      'a) Iktiqad (kepercayaan) ini tertegak di atas dua asas yang utama:',
      'i) Sesungguhnya Allah mempunyai nama-nama yang indah dan sifat-sifat yang tinggi yang menunjukkan atas sifat-sifat yang sempurna, tidak ada sesuatu kekurangan pada-Nya dalam semua perkara, tidak menyerupai-Nya oleh sesuatu dan tidak ada yang menyengutui-Nya daripada makhluk-Nya.',
      'Sebahagian daripada nama-Nya "Al-Hayyu" (Yang Maha Hidup) dan Dia mempunyai sifat "Hayat" (hidup) yang wajib disabitkan kepada Allah dengan sesempurnanya menurut yang layak bagi-Nya. Hidup ini ialah hidup yang sempurna dan abadi, berhimpun padanya semua jenis kesempurnaan yang terdiri daripada ilmu, kudrat dan lainnya, tidak pernah didahului oleh tiada dan tidak akan diikuti oleh fana (kemusnahan).',
      'Firman Allah Taala: "Allah, tiada tuhan yang berhak disembah melainkan Dia, Yang tetap hidup, kekal mentadbir (sekalian makhluk) selama-lamanya. Yang tidak mengantuk usahkan tidur". (Surah Al-Baqarah, Ayat 255).',
      'ii) Sesungguhnya Allah Taala suci daripada semua sifat kekurangan dan semua cacat cela, seperti tidur, lemah, jahil, zalim dan lain-lain. Demikian juga Allah Taala suci daripada sebarang bentuk persamaan dengan semua makhluk. Maka wajib dinafikan semua perkara yang Allah nafikan daripada diri-Nya dan dinafikan oleh Rasulullah s.a.w daripada Tuhannya serta beriktikad bahawa Allah bersifat dengan sempurna, bercanggah dengan segala sifat yang dinafikan daripada-Nya.',
      'Apabila kita menafikan daripada Allah sifat mengantuk dan tidur bererti kita telah mengisbatkan kepada-Nya sempurna kekuasaan-Nya. Dengan menafikan sifat tidur bererti kita mengisbatkan kepada-Nya sempurna hidup. Demikianlah semua sifat yang dinafikan daripada Allah ianya mengandungi isbat sifat kesempurnaan di sebaliknya, Dialah Yang Maha Sempurna dan selain daripada-Nya adalah bersifat kurang.',
      'Firman Allah Taala: "Tiada sesuatupun yang sebanding dengan (Zat-Nya, sifat-sifat-Nya dan pentadbiran-Nya) dan Dialah Yang Maha Mendengar, lagi Maha Melihat". (Surah Asy-Syura, ayat 11).',
      'Firman Allah Taala: "Dan Tuhanmu tidak sekali-kali berlaku zalim terhadap hamba-Nya". (Surah Fussilat, ayat 46).',
      'Firman Allah Taala: "Dan (sudah tetap) bahawa kekuasaan Allah tidak dapat dilemahkan atau dihalangi oleh sesuatupun sama ada di langit atau di bumi, sesungguhnya Dia Amatlah Mengetahui lagi Amat Berkuasa". (Surah Fathir, Ayat 44).',
      'Firman Allah Taala: "Dan tiadalah Tuhanmu itu lupa". (Surah Maryam, Ayat 64).',
      'Beriman dengan nama-nama Allah, sifat-sifat-Nya dan perbuatan-Nya merupakan satu-satunya jalan untuk mengenali Allah dan beribadat kepada-Nya. Oleh kerana Allah tidak dapat dilihat oleh makhluk semasa hidup di dunia dengan penglihatan mata maka dibuka bagi mereka pintu ilmu yang membolehkan mereka mengenali Tuhan, "Ilah" yang mereka sembah. Mereka menyembah Allah berdasarkan pengetahuan yang sahih dan sempurna.',
      'b) Perkara yang perlu diambil kira dalam mengisbatkan nama-nama Allah yang indah.',
      'Dalam mengisbatkan nama-nama Allah yang indah perkara-perkara berikut perlu diambil kira:',
      'i) Beriman dengan sabitnya semua nama-nama Allah yang indah yang tersebut dalam Al-Quran dan As-Sunnah dengan tidak menambah atau mengurangkannya.',
      'Firman Allah Taala: "Dialah Allah, yang tidak ada Tuhan melainkan Dia, Yang Menguasai (sekalian alam), Yang Maha Suci, Yang Maha Selamat Sejahtera (daripada segala kekurangan), Yang Maha Melimpahkan Keamanan, Yang Maha Pengawal serta Pengawas, Yang Maha Kuasa, Yang Maha Kuat (menundukkan segala-galanya), Yang Melengkapi segala Kebesaran-Nya. Maha Suci Allah daripada segala yang mereka sekutukan dengan-Nya". (Surah Al-Hasyr, Ayat 23).',
      'Telah sabit dalam As-Sunnah bahawa Nabi s.a.w telah mendengar seorang lelaki berkata:',
      'اللهم إني أسألك بأن لك الحمد، لا إله إلا أنت، المنان، بديع السموات والأرض، يا ذا الجلال والإكرام، يا الحي يا القيوم',
      'Sabda Nabi s.a.w: "Kamu tahukah apa yang beliau doakan kepada Allah?". Jawab Sahabat: "Hanya Allah dan Rasul-Nya yang mengetahui". Sabdanya: "Demi Allah Yang diriku dikuasai tangan-Nya, sesungguhnya dia telah berdoa kepada Allah dengan nama-Nya yang agung sekiranya didoakan dengannya maka dikabulkan-Nya dan jika dipinta dengannya maka diberikan-Nya". (Hadith Riwayat Abu Daud dan Ahmad).',
      'ii) Beriman bahawa Allah Taala yang menamakan diri-Nya dan bukan dinamakan oleh seorang pun daripada makhluk-Nya. Dialah \'Azza Wajalla yang telah memuji diri-Nya dengan nama-nama ini, bukan nama yang baru dijadikan.',
      'iii) Beriman bahawa nama-nama Allah yang indah itu menunjukkan pengertian yang cukup sempurna, yang tidak ada sebarang kekurangan padanya. Maka wajib beriman dengan semua pengertian yang tersebut sepertimana wajib beriman dengan semua nama-nama-Nya.',
      'iv) Wajib menghormati pengertian yang terkandung dalam nama-nama-Nya dan jangan sekali-kali melakukan sebarang perubahan dan menafikannya.',
      'v) Beriman dengan semua tuntutan yang terkandung dalam nama-nama-Nya yang terdiri daripada hukum-hukum dan perkara yang bersangkutan dengannya daripada perbuatan dan kesan-kesannya.',
      'c) Perkara yang perlu diambilkira dalam mengisbat sifat-sifat Allah',
      'Dalam mengisbat sifat-sifat Allah, perkara-perkara berikut perlu diambil kira:',
      'i) Isbat semua sifat-sifat yang tersebut dalam Al-Quran dan As-Sunnah bagi Allah Taala secara hakiki dengan tidak melakukan sebarang perubahan atau menafikannya.',
      'ii) Iktikad yang tetap bahawa Allah Taala bersifat dengan sifat-sifat yang sempurna dan suci daripada semua sifat-sifat kekurangan atau cacat cela.',
      'iii) Tidak membuat persamaan sifat-sifat Allah dengan sifat-sifat semua makhluk, kerana Allah s.w.t. tiada sesuatupun yang sebanding dengan sifat-sifat-Nya atau perbuatan-Nya.',
      'Firman Allah Taala: "Tiada sesuatupun yang sebanding dengan (Zat-Nya, sifat-sifat-Nya dan pentadbiran-Nya) dan Dialah Yang Maha Mendengar, lagi Maha Melihat". (Surah Asy-Syura, Ayat 11).',
      'iv) Tidak ada kemungkinan langsung untuk mengetahui "kaifiat" (bagaimana) sifat-sifat Allah kerana tidak ada jalan bagi makhluk untuk mengetahuinya.',
      'v) Beriman dengan semua perkara yang terkandung dalam semua sifat-sifat Allah dari segi hukum dan semua tuntutan daripada kesan-kesan beriman dengan sifat-sifat Allah Taala tersebut, maka semua sifat mengandungi "\'Ubudiyyah" (perhambaan kepada Allah).',
      '3. Iktiqad Bahawa Allah Ialah "Ilah" (Tuhan) Yang Sebenar',
      'Iktikad bahawa Allah ialah "Ilah" (Tuhan) yang sebenar yang benar-benar berhak disembah secara zahir dan batin, Yang Esa, tiada sekutu bagi-Nya.',
      'Firman Allah Taala: "Dan sesungguhnya Kami telah mengutuskan kepada setiap umat seorang Rasul (dengan memerintahkannya supaya menyeru mereka): Hendaklah kamu menyembah Allah dan jauhilah taghut". (Surah An-Nahl, Ayat 36).',
      'Firman Allah Taala: "Padahal mereka tidak diperintahkan melainkan supaya menyembah Allah dengan mengikhlaskan ibadat kepada-Nya, dalam keadaan teguh di atas tauhid". (Surah Al-Bayyinah, Ayat 5).',
      'Sabda Nabi s.a.w kepada Mu\'az r.a.:',
      'أتدري ما حق الله على العباد، وما حق العباد على الله؟ قلت: الله ورسوله أعلم. قال حق الله على العباد أن يعبدوه ولا يشركوا به شيئاً، وحق العباد على الله ألا يعذب من لا يشرك به شيئا',
      '"Adakah kamu tahu apakah hak Allah ke atas hamba-Nya dan hak seorang hamba ke atas Allah?". Jawab Mu\'az: "Hanya Allah dan Rasul-Nya yang mengetahui". Sabdanya: "Hak Allah ke atas hamba-Nya ialah mereka mesti menyembah-Nya dan jangan sekali-kali melakukan syirik terhadap-Nya dengan sesuatupun dan hak seorang hamba ke atas Allah ialah tidak mengazab mereka yang tidak melakukan syirik terhadap-Nya dengan sesuatu".',
      '"Ilah" (Tuhan) yang sebenar: Ialah Tuhan tempat bergantung hati kepada-Nya dengan penuh kasih sayang (mahabbah) lebih daripada semua yang lain, hanya meletakkan pengharapan kepada-Nya dan cukuplah meminta kepada-Nya, memohon bantuan daripada-Nya, takut dan gerun kepada-Nya.',
      'Firman Allah Taala: "Bersifatnya Allah dengan kekuasaan dan luas ilmu pengetahuan itu kerana bahawasanya Allah, Dialah sahaja Tuhan Yang Sebenar-benarnya dan bahawa segala yang mereka sembah selain daripada Allah itulah yang nyata palsunya dan (ingatlah) sesungguhnya Allah jualah Yang Maha Tinggi keadaan-Nya, lagi Maha Besar (kekuasaan-Nya)". (Surah Al-Haj, Ayat 62).',
      '4. Kepentingan Tauhid',
      'Kepentingan tauhid dapat diperjelaskan melalui perkara-perkara berikut:',
      'a- Tauhid adalah merupakan asas pertama agama ini, matlamatnya, akhirnya, zahirnya dan batinnya dan ianya merupakan dakwah (seruan) semua rasul (ke atas mereka semua kesejahteraan).',
      'b- Kerana tauhid ini Allah menciptakan makhluk, mengutuskan rasul-rasul dan menurunkan kitab-kitab. Kerananya berselisih pendapat di kalangan makhluk dan berpecah kepada golongan mukmin dan kafir dan golongan yang bertuah dan celaka.',
      'c- Tauhid ialah perkara pertama yang wajib ke atas seorang "mukallaf" (akil baligh), juga yang pertama membawa seorang hamba memasuki pintu Islam dan yang terakhir bersamanya ketika keluar dari alam kehidupan dunia.',
      '5. Tahkik (Perlaksanaan) Tauhid',
      'Melaksanakan tauhid: Ialah membersih dan memurnikannya daripada sebarang bentuk syirik, bid\'ah (rekaan, tambahan terhadap ajaran agama) dan maksiat. Ianya terbahagi kepada dua bahagian: wajib dan sunat.',
      'a – Wajib terdiri daripada tiga perkara:',
      'i. Membersihkannya daripada perbuatan syirik yang menafikan asas tauhid.',
      'ii. Membersihkannya daripada perbuatan bid\'ah yang menafikan, a) kesempurnaan perkara yang wajib atau, b) menafikan asas tauhid jika ianya terdiri daripada bid\'ah yang membawa kepada kekufuran.',
      'iii. Membersihkannya daripada semua bentuk maksiat yang mengurangkan pahala atau memberi kesan kepadanya.',
      'b – Sunat ialah perkara-perkara yang disuruh melakukannya secara "istihbab" (tidak wajib), antara contohnya ialah seperti berikut:',
      'i) Tahkik (merealisasikan) kesempurnaan martabat ihsan (menyembah Allah seolah-olah melihat-Nya).',
      'ii) Tahkik (merealisasikan) kesempurnaan martabat yakin.',
      'iii) Tahkik (merealisasikan) kesempurnaan sifat sabar, iaitu dengan tidak membuat sebarang pengaduan kepada makhluk selain daripada Allah.',
      'iv) Tahkik (merealisasikan) kesempurnaan rasa terkaya, memadai dengan hanya memohon kepada Allah Taala, tidak meminta sebarang permohonan daripada makhluk.',
      'v) Tahkik (merealisasikan) kesempurnaan martabat tawakkal, iaitu dengan meninggalkan beberapa perkara yang harus seperti meminta supaya dijampi, hanya bertawakkal kepada Allah Taala.',
      'vi) Tahkik (merealisasikan) kesempurnaan martabat mahabbah (kasih dan cinta) kepada Allah dengan melakukan amalan-amalan sunat.',
      'Sesiapa yang telah melaksanakan tuntutan tauhid seperti yang tersebut di atas serta selamat (terjaga) daripada melakukan syirik yang besar (perbuatan kufur) juga yang kecil serta menjauhkan diri daripada dosa-dosa besar dan maksiat, maka dia akan mendapat keamanan yang sempurna di dunia dan di akhirat.',
      'Firman Allah Taala: "Sesungguhnya Allah tidak akan mengampunkan dosa syirik mempersekutukan-Nya (dengan sesuatu yang lain) dan akan mengampunkan dosa yang lain dari itu bagi sesiapa yang dikehendaki-Nya (menurut aturan Syariat-Nya)". (Surah An-Nisa\', Ayat 48).',
      'Firman Allah Taala: "Orang-orang yang beriman dan tidak mencampur-adukkan iman mereka dengan kezaliman (syirik), mereka itulah orang-orang yang mendapat keamanan dan merekalah orang-orang yang mendapat hidayat petunjuk". (Surah Al-An\'am, Ayat 82).',
      '6. Perkara Yang Bertentangan Dengan Tauhid Ialah Syirik',
      'Perkara yang bertentangan dengan tauhid ialah syirik (menyengutukan Allah dengan makhluk), ianya terbahagi kepada tiga bahagian:',
      'a) Syirik yang besar, yang menafikan asas tauhid, tidak diampunkan oleh Allah kecuali dengan bertaubat meninggalkannya (kembali kepada Islam). Sesiapa yang mati dalam keadaan syirik akan kekal di dalam neraka selama-lamanya.',
      'Firman Allah Taala: "Sesiapa yang mempersekutukan Allah dengan sesuatu yang lain, maka sesungguhnya Allah haramkan kepadanya syurga dan tempat kembalinya ialah neraka dan tiadalah seorang penolong pun bagi orang-orang yang berlaku zalim". (Surah Al-Maidah, Ayat 72).',
      'b) Syirik kecil yang menafikan kesempurnaan tauhid, iaitu setiap perkara yang boleh membawa kepada syirik besar, seperti bersumpah dengan lain daripada nama Allah dan perbuatan riya\' yang sedikit.',
      'c) Syirik tersembunyi (khafi), iaitu perbuatan yang bersangkut dengan niat dan amalan hati, kadang-kadang ianya menjadi syirik besar dan adakalanya syirik kecil.',
      'Dari Mahmud bin Labid r.a. Rasulullah s.a.w bersabda:',
      'إن أخوف ما أخاف عليكم الشرك الأصغر، قالوا وما الشرك الأصغر يا رسول الله ؟ قال: الرياء . [رواه الإمام أحمد]',
      '"Sesungguhnya perkara yang aku sangat takuti menimpa kamu ialah syirik kecil". Sahabat bertanya: "Apakah syirik kecil itu wahai Rasulullah?". Sabdanya: "Riya\'". (Hadith Riwayat Imam Ahmad).',
      'B – PENGERTIAN IBADAT',
      'Ibadat ialah satu nama yang meliputi semua perkara yang disukai oleh Allah serta diredhai-Nya iaitu dari segi \'akidah (pegangan atau iktikad), amalan hati, amalan anggota dan semua amalan yang mendekatkan diri kepada Allah daripada perbuatan-perbuatan yang wajib dilakukan dan perbuatan-perbuatan yang wajib ditinggalkan.',
      '1. Tidak Sah Sesuatu Ibadat Kecuali Dibina Di Atas Dua Landasan:',
      'a – Mengikhlaskan ibadat kepada Allah dan tidak melakukan syirik terhadapnya. Inilah makna syahadah (pengakuan) "La ilaha illallah" (Tiada tuhan yang berhak disembah melainkan Allah).',
      'Firman Allah Taala: "Padahal mereka tidak diperintahkan melainkan supaya menyembah Allah dengan mengikhlaskan ibadat kepada-Nya, dalam keadaan teguh di atas tauhid". (Surah Al-Bayyinah, Ayat 5).',
      'b – Mengikut ajaran yang dibawa oleh Rasulullah s.a.w dengan melakukannya sebagaimana yang telah dilakukan oleh Nabi s.a.w tanpa membuat sebarang penambahan atau pengurangan. Inilah makna syahadah (pengakuan) Muhammad Rasulullah.',
      'Firman Allah Taala: "Katakanlah (wahai Muhammad): Jika benar kamu mengasihi Allah maka ikutilah aku, nescaya Allah mengasihi kamu serta mengampunkan dosa-dosa kamu". (Surah Ali \'Imran, Ayat 31).',
      '2. "\'Ubudiyyah" (Perhambaan) Yang Sempurna Tidak Akan Terlaksana Kecuali Dengan Dua Perkara:',
      'a) Mahabbah atau cintakan Allah dengan sepenuhnya, iaitu dengan mendahulukan mahabbah atau cinta kepada Allah mengatasi cinta kepada semua yang lain.',
      'b) Tunduk, patuh dan menghina diri kepada Allah, iaitu dengan melaksanakan semua tuntutan dan menjauhkan diri daripada semua larangan Allah.',
      'C – DALIL-DALIL SERTA TANDA KEESAAN ALLAH',
      'Dalil atau tanda keesaan Allah Taala sangat banyak. Sesiapa yang memerhatikannya serta merenunginya maka akan teguh ilmunya serta bertambah keyakinannya terhadap keesaan Allah Taala dalam mentadbir serta "wahdaniyyah" (keesaan) Allah pada perbuatan-Nya, nama-nama-Nya, sifat-sifat-Nya dan "Uluhiyyah" (ketuhanan)-Nya.',
      '1) Agungnya kejadian alam semesta ini. Sesiapa yang memerhatikannya serta berfikir tentang kejadiannya akan berasa yakin dengan "wahdaniyyah" (keesaan) Allah kerana halus seni ciptaannya, pelbagai jenis makhluk terdapat di dalamnya dan sistem perjalanannya yang teratur.',
      'Firman Allah Taala: "Dan Kami telah jadikan di bumi gunung-ganang yang menetapnya, supaya bumi itu tidak menggegar mereka dan Kami jadikan padanya celah-celah sebagai jalan-jalan lalu-lalang, supaya mereka dapat sampai kepada mencapai keperluan rohani dan jasmani". (Surah Al-Anbiya\', Ayat 31-33).',
      'Firman Allah Taala: "Dan antara tanda-tanda yang membuktikan kekuasaan-Nya dan kebijaksanaan-Nya ialah kejadian langit dan bumi dan perbezaan bahasa kamu dan warna kulit kamu. Sesungguhnya yang demikian itu mengandungi keterangan-keterangan bagi orang-orang yang berpengetahuan". (Surah Ar-Rum, Ayat 22).',
      '2) Ajaran syariat yang telah Allah utuskan melalui rasul-rasul dan dikuatkan pula ajaran tersebut dengan tanda-tanda keterangan yang menunjukkan kepada "wahdaniyyah" serta keesaan Allah Taala untuk disembah.',
      'Firman Allah Taala: "Katakanlah (wahai Muhammad): Sesungguhnya sekiranya sekalian manusia dan jin berhimpun dengan tujuan hendak membuat dan mendatangkan sebanding dengan Al-Quran ini, mereka tidak akan dapat membuat dan mendatangkan yang sebanding dengannya, walaupun mereka bantu-membantu sesama sendiri". (Surah Al-Isra\', Ayat 88).',
      '3) Fitrah kejadian manusia yang telah Allah jadikan dalam hati hamba-hamba-Nya mengakui keesaan Tuhan, ianya merupakan suatu perkara yang telah tetap dalam diri manusia.',
      'Firman Allah Taala: "(Setelah jelas kesesatan syirik itu) maka hadapkanlah dirimu (engkau dan pengikut-pengikutmu, wahai Muhammad) ke arah agama yang jauh dari kesesatan, (turutlah terus) agama Allah, iaitu agama yang Allah menciptakan manusia (dengan keadaan bersedia dari semulajadinya) untuk menerimanya". (Surah Ar-Rum, Ayat 30-31).',
      'Sabda Nabi s.a.w:',
      'كل مولود يولد على الفطرة، فأبواه يهودانه أو ينصرانه أو يمجسانه [رواه البخاري]',
      '"Setiap anak yang dilahirkan itu dalam keadaan fitrah (suci bersih), kedua ibu bapanyalah yang mencorakkanya menjadi Yahudi atau Nasrani atau Majusi". (Hadith Riwayat Al-Bukhari).',
    ];

    final boldIndices = [
      0,    // A – TAHKIK (PERLAKSANAAN) NYA
      2,    // 1. Iktiqad (Percaya) Bahawa Alam Ini Mempunyai Pencipta Yang Satu
      10,   // 2. Iktiqad Dengan Nama-Nama Yang Indah Dan Sifat-Sifat Yang Sempurna
      13,   // Sabda Nabi s.a.w:
      16,   // a) Iktiqad (kepercayaan) ini tertegak di atas dua asas yang utama:
      27,   // b) Perkara yang perlu diambil kira dalam mengisbatkan nama-nama Allah yang indah.
      38,   // c) Perkara yang perlu diambilkira dalam mengisbat sifat-sifat Allah
      46,   // 3. Iktiqad Bahawa Allah Ialah "Ilah" (Tuhan) Yang Sebenar
      50,   // Sabda Nabi s.a.w kepada Mu'az r.a.:
      55,   // 4. Kepentingan Tauhid
      57,   // a- Tauhid adalah merupakan asas pertama agama ini...
      60,   // 5. Tahkik (Perlaksanaan) Tauhid
      62,   // a – Wajib terdiri daripada tiga perkara:
      66,   // b – Sunat ialah perkara-perkara yang disuruh melakukannya...
      76,   // 6. Perkara Yang Bertentangan Dengan Tauhid Ialah Syirik
      78,   // a) Syirik yang besar, yang menafikan asas tauhid...
      80,   // b) Syirik kecil yang menafikan kesempurnaan tauhid...
      81,   // c) Syirik tersembunyi (khafi)...
      82,   // Dari Mahmud bin Labid r.a. Rasulullah s.a.w bersabda:
      85,   // B – PENGERTIAN IBADAT
      87,   // 1. Tidak Sah Sesuatu Ibadat Kecuali Dibina Di Atas Dua Landasan:
      92,   // 2. "'Ubudiyyah" (Perhambaan) Yang Sempurna...
      95,   // C – DALIL-DALIL SERTA TANDA KEESAAN ALLAH
      97,   // 1) Agungnya kejadian alam semesta ini...
      100,  // 2) Ajaran syariat yang telah Allah utuskan...
      102,  // 3) Fitrah kejadian manusia...
      104,  // Sabda Nabi s.a.w:
    ];

    final arabicIndices = [
      14,   // إن لله تسعة وتسعين اسماً...
      32,   // اللهم إني أسألك بأن لك الحمد...
      51,   // أتدري ما حق الله على العباد...
      83,   // إن أخوف ما أخاف عليكم الشرك الأصغر...
      105,  // كل مولود يولد على الفطرة...
    ];

    for (var i = 0; i < content.length; i++) {
      await db.insert('content_blocks', {
        'rukun_iman_id': id,
        'text': content[i],
        'is_bold': boldIndices.contains(i) ? 1 : 0,
        'is_arabic': arabicIndices.contains(i) ? 1 : 0,
        'sort_order': i,
      });
    }

    return id;
  }

  // ============ INSERT RUKUN KEDUA ============

  Future<int> _insertRukunKedua(Database db) async {
    final id = await db.insert('rukun_iman', {
      'title': 'RUKUN KEDUA: BERIMAN KEPADA MALAIKAT',
      'subtitle': 'May 24, 2019',
      'date': '2019-05-24',
      'category': 'kedua',
      'created_at': DateTime.now().toIso8601String(),
    });

    final content = [
      'A – PENGERTIAN',
      'Beriman dengan Malaikat: Ialah iktikad dengan sepenuh keyakinan bahawa Allah mempunyai malaikat yang dijadikan daripada cahaya yang telah ditentukan untuk melakukan ketaatan, tidak melakukan sebarang maksiat terhadap Allah dan melaksanakan semua arahan yang diperintahkan, mereka sentiasa bertasbih kepada Allah malam dan siang dengan tidak pernah berasa jemu. Tidak diketahui bilangan mereka kecuali Allah. Allah telah menetapkan ke atas mereka tugas dan tanggungjawab yang bermacam-macam.',
      'Firman Allah Taala: "…tetapi kebajikan itu ialah beriman kepada Allah, Hari Akhirat dan para malaikat…". (Surah Al-Baqarah, Ayat 177).',
      'Firman Allah Taala: "Semuanya beriman kepada Allah, malaikat-malaikat-Nya, kitab-kitab-Nya dan rasul-rasul-Nya. Mereka berkata: Kami tidak membezakan antara seorang dengan yang lain dari rasul-rasul-Nya". (Surah Al-Baqarah, Ayat 285).',
      'Tersebut dalam hadith Jibrail yang masyhur: Sewaktu Jibrail (dengan menyerupai manusia) datang bertanya kepada Rasulullah s.a.w tentang Islam, Iman dan Ihsan. Katanya: "Beritahu kepada saya pengertian iman".',
      'Sabda Nabi s.a.w:',
      'أن تؤمن بالله، وملائكته، وكتبه، ورسله، واليوم الآخر، وأن تؤمن بالقدر خيره وشره',
      '"Hendaklah engkau beriman dengan Allah, para malaikat-Nya, kitab-kitab-Nya, rasul-rasul-Nya dan Hari Akhirat serta Qadar (untung) baik dan yang tidak baik".',
      'Para ulama\' telah berijma\' (bersepakat) tentang kewajipan beriman dengan para malaikat. Sesiapa yang mengingkari kewujudan mereka atau sebahagian daripada mereka seperti mana yang disebut oleh Allah Taala, hukumnya adalah kafir serta bercanggah dengan Al-Quran, As-Sunnah dan ijma\' ulama\'.',
      'Kedudukan Beriman Kepada Malaikat Di Sisi Agama Serta Hukumnya',
      'Beriman kepada malaikat ialah rukun kedua daripada Rukun Iman yang enam. Tidak sah dan tidak diterima iman seorang hamba itu melainkan beriman dengannya.',
      'Firman Allah Taala: "Sesiapa yang kufur kepada Allah, malaikat-malaikat-Nya, kitab-kitab-Nya dan rasul-rasul-Nya juga Hari Akhirat, maka sesungguhnya ia telah sesat dengan kesesatan yang sejauh-jauhnya". (Surah An-Nisa\', Ayat 136).',
      'B – CARA BERIMAN DENGAN MALAIKAT',
      'Beriman dengan malaikat secara umum dan terperinci.',
      '1. Beriman Dengan Malaikat Secara Umum Mengandungi Perkara Berikut:',
      'a) Mengakui kewujudan mereka',
      'Mereka adalah makhluk ciptaan Allah yang diciptakan untuk beribadat kepada-Nya. Kewujudan mereka adalah hakiki. Kita tidak dapat melihat mereka bukan bermakna mereka tidak wujud, buktinya berapa banyak makhluk lain dalam alam ini yang kita tidak nampak, sedangkan ianya memang wujud.',
      'Sesungguhnya Nabi s.a.w telah melihat rupa asli Jibrail a.s sebanyak dua kali. Para Sahabat r.hum telah melihat sebahagian daripada malaikat yang menyerupai manusia.',
      'Imam Ahmad telah meriwayatkan dalam Musnadnya daripada Abdullah bin Mas\'ud r.a. katanya:',
      'رأى رسول الله صلى الله عليه وسلم جبريل في صورته وله ستمائة جناح، وكل جناح منها قد سدّ الأفق',
      '"Rasulullah s.a.w. telah melihat Jibrail dengan rupanya yang asli, mempunyai 600 sayap, setiap helai sayapnya memenuhi ufuk".',
      'Telah sabit dalam hadith Jibrail yang masyhur yang diriwayatkan oleh Imam Muslim: Bahawa Jibrail a.s datang bertemu Rasulullah s.a.w dengan menyerupai seorang lelaki yang sangat putih pakaiannya, sangat hitam rambutnya, tidak kelihatan padanya kesan kepenatan bermusafir sedangkan tiada seorang pun daripada kalangan Sahabat yang mengenalinya.',
      'b) Meletakkan taraf kedudukannya pada tempat yang telah Allah tentukan kepada mereka',
      'Mereka adalah hamba-hamba Allah yang diberi arahan (tugas). Allah telah memuliakan mereka dengan mengangkat martabat kedudukan yang hampir dengan-Nya. Sebahagian daripada mereka menjadi utusan menyampaikan wahyu. Mereka tidak berkuasa melakukan sesuatu perkara kecuali dengan kuasa yang Allah berikan kepada mereka. Mereka tidak memiliki kuasa untuk memberi manfaat atau memudharatkan diri mereka atau orang lain selain daripada kuasa Allah. Oleh itu tidak harus melakukan sebarang ibadat kepada mereka apa lagi menjadikan mereka memiliki beberapa sifat ketuhanan ("Ar-Rububiyyah") sebagaimana iktikad orang-orang Nasrani (Kristian) dengan Ruh Al-Qudus (Jibrail) a.s.',
      'Firman Allah Taala: "Dan mereka (yang musyrik) berkata: (Allah) Ar-Rahman mempunyai anak. Maha Sucilah Dia. Bahkan (mereka yang dikatakan menjadi anak Allah itu) ialah hamba-hamba-Nya yang dimuliakan. Mereka tidak mendahului-Nya dengan perkataan dan mereka pula mengerjakan apa yang diperintahkan-Nya". (Surah Al-Anbiya\', Ayat 26-27).',
      'Firman Allah Taala: "Mereka tidak menderhaka kepada Allah dalam segala yang diperintahkan-Nya kepada mereka dan mereka pula tetap melakukan segala yang diperintahkan". (Surah At-Tahrim, Ayat 6).',
      'Inilah tahap keimanan yang wajib ke atas setiap muslim dan muslimah. Wajib ke atas mereka mempelajari dan mempercayainya serta mereka tidak dimaafkan jika jahil tentangnya.',
      '2. Huraian Mengenai Beriman Dengan Malaikat Secara Terperinci Adalah Seperti Berikut:',
      'a) Asal Kejadian Malaikat',
      'Allah s.w.t mencipta malaikat daripada cahaya sebagaimana Allah menjadikan jin daripada api dan anak Adam (manusia) daripada tanah. Malaikat telah dicipta sebelum dijadikan Adam a.s, tersebut di dalam hadith:',
      'خلقت الملائكة من نور، وخلق الجان من مارج من نار، وخلق آدم مما وصف لكم [رواه مسلم]',
      '"Dijadikan malaikat daripada cahaya dan dijadikan jin daripada api yang menjulang serta dijadikan manusia daripada benda yang disifatkan kepada kamu (tanah)". (Hadith Riwayat Muslim).',
      'b) Bilangan Malaikat',
      'Malaikat ialah sejenis makhluk yang tidak terhingga banyaknya, tidak dapat dihitung bilangannya kecuali Allah sahajalah yang mengetahuinya. Tidak ada tempat seluas empat anak jari di langit kecuali ada malaikat yang sedang sujud atau berdiri (solat). Di Baitul Ma\'mur yang terletak di langit ketujuh, 70 ribu malaikat masuk setiap hari kemudian mereka yang telah masuk ke dalamnya tidak dapat kembali lagi (untuk memasukinya) kerana bilangannya terlalu ramai. Pada Hari Kiamat nanti akan dibawa neraka yang mempunyai 70 ribu tali penarik dan setiap tali ditarik oleh 70 ribu malaikat.',
      'Firman Allah Taala: "Dan tiada yang mengetahui tentera (malaikat) Tuhanmu melainkan Dialah sahaja". (Surah Al-Muddatthir, Ayat 31).',
      'Tersebut dalam hadith, Nabi s.a.w bersabda:',
      'أطَّت السماء وحق أن تَئِطَّ، ما فيها موضع قدم إلا وفيه ملك ساجد وراكع',
      '"Langit berbunyi dan memang patut ia berbunyi, tiada tempat sebesar tapak kaki melainkan ada di situ malaikat yang sedang sujud atau rukuk".',
      'Sabda Nabi s.a.w tentang Baitul Ma\'mur:',
      'يدخله في كل يوم سبعون ألف ملك لا يعودون إليه [رواه البخاري ومسلم]',
      '"70 ribu malaikat masuk setiap hari ke dalam Baitul Ma\'mur, kemudian mereka yang telah masuk tidak akan kembali lagi ke tempat itu". (Hadith Riwayat Al-Bukhari dan Muslim).',
      'Sabda Nabi s.a.w:',
      'يؤتى بجهنم يومئذٍ لها سبعون ألف زمام، مع كل زمام سبعون ألف ملك [رواه مسلم]',
      '"Pada Hari Kiamat nanti akan dibawa Neraka Jahannam yang mempunyai 70 ribu tali penarik dan setiap tali itu ditarik oleh 70 ribu malaikat". (Hadith Riwayat Muslim).',
      'Dengan ini jelaslah kepada kita betapa banyaknya bilangan malaikat, bilangan mereka (yang menarik sebuah neraka) sahaja 4,900 juta malaikat, bagaimana dengan bilangan malaikat yang lain. Maha Suci Allah yang telah menciptakan malaikat dan mengetahui bilangannya.',
      'c) Nama-Nama Malaikat',
      'Kita wajib beriman dengan malaikat yang telah disebut nama mereka oleh Allah dalam Al-Quran atau disebut oleh Rasulullah s.a.w dalam As-Sunnah, yang teragungnya tiga:',
      'i. Jibril dan dinamakan juga dengan Jibrail. Dia ialah Ruh Al-Qudus yang menurunkan wahyu. Dan dengan wahyu inilah telah dapat menghidupkan hati-hati ke atas rasul-rasul a.s.',
      'ii. Mikail, dinamakan juga dengan Mikal. Dia telah ditugaskan menurunkan hujan yang menghidupkan bumi dengan membawanya ke tempat yang telah diarahkan oleh Allah s.w.t.',
      'iii. Israfil. Ditugaskan untuk meniup serunai sangkakala yang dengannya berakhirlah kehidupan dunia dan bermulalah kehidupan akhirat, yang akan menghidupkan semua jasad.',
      'd) Sifat-Sifat Malaikat',
      'Malaikat ialah suatu makhluk yang memang wujud, mempunyai jisim yang hakiki serta bersifat dengan sifat-sifat kejadian (bentuk luaran) dan sifat akhlak yang baik, antaranya:',
      'i) Besar kejadian serta tubuh badan mereka. Allah s.w.t. telah mencipta malaikat dengan bentuk yang besar dan kuat, sesuai dengan tugas mereka yang mulia sama ada di langit dan di bumi.',
      'ii) Mereka mempunyai sayap. Allah menciptakan bagi mereka sayap, ada yang mempunyai dua, tiga dan empat atau lebih, sebagaimana Rasulullah s.a.w. telah melihat rupa Jibrail yang sebenar mempunyai 600 sayap yang memenuhi ufuk.',
      'Firman Allah Taala: "Segala puji tertentu bagi Allah yang menciptakan langit dan bumi, yang menjadikan malaikat utusan-utusan yang bersayap dua, tiga dan empat. Dia menambah pada bentuk kejadian makhluk yang diciptakan-Nya apa jua yang dikehendaki-Nya". (Surah Fathir, Ayat 1).',
      'iii) Tidak berhajat kepada makanan dan minuman. Allah Taala mencipta malaikat yang tidak berhajat kepada makan dan minum, juga tidak berkahwin dan tidak mempunyai keturunan.',
      'iv) Malaikat suatu makhluk yang cerdik serta mempunyai pemikiran yang pintar. Mereka berbicara dengan Allah dan Allah juga berkata-kata dengan mereka. Mereka juga bercakap dengan Adam a.s dan nabi-nabi yang lain.',
      'v) Boleh bertukar rupa daripada kejadian mereka yang asal. Allah telah mengurniakan kepada mereka kebolehan untuk bertukar rupa menjadi rupa lelaki daripada kalangan manusia, ini sekaligus menolak dakwaan penyembah berhala yang menyangka bahawa malaikat ialah anak perempuan Allah. Kita tidak dapat mengetahui bagaimana cara mereka bertukar rupa, tetapi memang mereka berupaya untuk berupa menjadi manusia sehingga tidak dapat dibezakan dengan manusia sebenar.',
      'vi) Kematian malaikat. Mereka semua akan mati pada Hari Kiamat termasuk Malakul Maut (yang mencabut nyawa), kemudian mereka akan dibangkitkan semula untuk melaksanakan tugas yang telah diberikan oleh Allah kepada mereka.',
      'vii) Ibadat malaikat. Mereka melakukan ibadat kepada Allah Taala dengan berbagai-bagai jenis ibadat, antaranya: solat, doa, tasbih (memuji Allah), rukuk, sujud, "khauf" (takut), "khasyiah" (takut), mahabbah dan lain-lain.',
      'Antara sifat-sifat ibadat mereka ialah:',
      '– Berkekalan dan berterusan dengan tidak pernah berasa jemu.',
      '– Ikhlas kepada Allah Taala.',
      '– Sentiasa melakukan ketaatan dan tidak pernah melakukan maksiat kerana mereka terpelihara daripada melakukan dosa dan maksiat.',
      '– Sentiasa bersifat tawadhu\' (merendah diri) walaupun banyak beribadat. Firman Allah Taala: "Mereka beribadat malam dan siang, dengan tidak berhenti-henti". (Surah Al-Anbiya\', ayat 20).',
      'e) Tugas-tugas Malaikat',
      'Para malaikat menjalankan tugas-tugas mulia yang telah dipertanggungjawabkan oleh Allah kepada mereka, antaranya:',
      'i) Memikul Arasy.\nii) Menurunkan wahyu kepada rasul-rasul.\niii) Menjaga syurga dan neraka.\niv) Menjaga awan, hujan dan tumbuh-tumbuhan.\nv) Menjaga bukit bukau dan gunung-ganang.\nvi) Meniup serunai sangkakala.\nvii) Menulis amalan anak Adam (manusia).\nviii) Menjaga anak Adam. Apabila seseorang itu telah ditakdirkan oleh Allah akan ditimpa bencana, mereka akan meninggalkannya kemudian bala pun menimpa orang itu.\nix) Sentiasa bersama manusia dan mendoakan untuknya ke arah kebaikan.\nx) Menjaga air mani di dalam rahim, kemudian meniup roh manusia, menulis rezekinya, amalannya, baik atau celaka hidupnya.\nxi) Mengambil nyawa manusia ketika sampai ajalnya.\nxii) Menyoal manusia di dalam kubur dan mengenakan balasan ke atas mereka, nikmat atau azab.\nxiii) Menyampaikan salam yang diucapkan oleh setiap umat kepada Nabi s.a.w.',
      'Oleh yang demikian, seorang muslim tidak perlu bermusafir ke makam Nabi s.a.w untuk menyampaikan salam, memadai dengan membaca selawat dan salam kepada Nabi s.a.w di mana saja mereka berada, kerana malaikat akan membawa serta menyampaikannya kepada Nabi s.a.w. Seseorang itu boleh bermusafir ke masjid Nabi untuk menunaikan solat di dalamnya.',
      'Para malaikat mempunyai kerja dan tugas yang amat banyak, apa yang disebutkan di atas hanyalah yang masyhur.',
      'Antara dalil-dalil yang menunjukkan kepada tugas mereka ialah:',
      'Firman Allah Taala: "Malaikat yang memikul Arasy dan malaikat yang berada di sekelilingnya bertasbih memuji Tuhan-Nya dan beriman kepada-Nya serta mereka memohon ampun bagi orang-orang yang beriman". (Surah Ghafir, Ayat 7).',
      'Firman Allah Taala: "Katakanlah (wahai Muhammad): Sesiapa memusuhi Jibril maka sebabnya ialah kerana Jibril itu menurunkan Al-Quran ke dalam hatimu dengan izin Allah". (Surah Al-Baqarah, Ayat 97).',
      'Firman Allah Taala: "Dan (sungguh ngeri) sekiranya engkau melihat ketika orang-orang yang zalim itu dalam penderitaan sakaratulmaut (ketika hendak putus nyawa), sedang malaikat-malaikat pula menghulurkan tangan mereka (memukul dan menyeksa orang-orang itu) sambil berkata (dengan menengking dan mengejek): Keluarkanlah nyawa kamu (dari tubuh kamu sendiri)". (Surah Al-An\'am, Ayat 93).',
      'f) Hak-Hak Malaikat Ke Atas Manusia',
      'i) Beriman dengan mereka.\nii) Mengasihi serta memuliakan mereka serta menyebut kelebihan mereka.\niii) Haram mencerca atau mengurangkan ketinggian darjat mereka atau mempersendakan mereka.\niv) Hindarkan daripada melakukan perkara yang dibenci oleh malaikat, kerana mereka akan berasa kurang senang sebagaimana anak Adam merasainya.',
      'C – NATIJAH BERIMAN KEPADA MALAIKAT',
      '1. Merealisasikan maksud iman, kerana tidak sah iman itu melainkan dengan beriman dengan mereka.',
      '2. Mengetahui keagungan Pencipta mereka Yang Maha Tinggi dan mengetahui kekuatan serta kerajaan-Nya, kerana kehebatan makhluk ciptaan-Nya menunjukkan keagungan penciptanya.',
      '3. Bertambah keimanan di dalam hati seseorang muslim dengan mengetahui sifat-sifat malaikat, keadaan serta tugas-tugas mereka.',
      '4. Mendapat keamanan dan ketenangan bagi seseorang muslim apabila Allah menguatkan mereka dengan bantuan malaikat.',
      '5. Kasihkan para malaikat kerana mereka telah menjalankan ibadat dengan sempurna serta mereka sentiasa beristighfar (meminta ampun) bagi orang-orang mukmin.',
      '6. Membenci semua perbuatan jahat dan maksiat.',
      '7. Bersyukur kepada Allah Taala kerana sentiasa mengambil berat terhadap hamba-hamba-Nya, dengan mengutuskan malaikat yang sentiasa menjaga keselamatan, menulis semua amalan yang dilakukan dan lainnya bagi kebaikan manusia.',
    ];

    final boldIndices = [
      0,    // A – PENGERTIAN
      5,    // Sabda Nabi s.a.w:
      9,    // Kedudukan Beriman Kepada Malaikat Di Sisi Agama Serta Hukumnya
      12,   // B – CARA BERIMAN DENGAN MALAIKAT
      14,   // 1. Beriman Dengan Malaikat Secara Umum...
      15,   // a) Mengakui kewujudan mereka
      22,   // b) Meletakkan taraf kedudukannya pada tempat...
      27,   // 2. Huraian Mengenai Beriman Dengan Malaikat Secara Terperinci...
      28,   // a) Asal Kejadian Malaikat
      32,   // b) Bilangan Malaikat
      35,   // Tersebut dalam hadith, Nabi s.a.w bersabda:
      38,   // Sabda Nabi s.a.w tentang Baitul Ma'mur:
      41,   // Sabda Nabi s.a.w:
      45,   // c) Nama-Nama Malaikat
      50,   // d) Sifat-Sifat Malaikat
      60,   // Antara sifat-sifat ibadat mereka ialah:
      65,   // e) Tugas-tugas Malaikat
      74,   // f) Hak-Hak Malaikat Ke Atas Manusia
      76,   // C – NATIJAH BERIMAN KEPADA MALAIKAT
      77,   // 1. Merealisasikan maksud iman...
      78,   // 2. Mengetahui keagungan Pencipta mereka...
      79,   // 3. Bertambah keimanan di dalam hati...
      80,   // 4. Mendapat keamanan dan ketenangan...
      81,   // 5. Kasihkan para malaikat...
      82,   // 6. Membenci semua perbuatan jahat dan maksiat.
      83,   // 7. Bersyukur kepada Allah Taala...
    ];

    final arabicIndices = [
      6,    // أن تؤمن بالله، وملائكته، وكتبه، ورسله...
      19,   // رأى رسول الله صلى الله عليه وسلم جبريل...
      30,   // خلقت الملائكة من نور...
      36,   // أطَّت السماء وحق أن تَئِطَّ...
      39,   // يدخله في كل يوم سبعون ألف ملك...
      42,   // يؤتى بجهنم يومئذٍ لها سبعون ألف زمام...
    ];

    for (var i = 0; i < content.length; i++) {
      await db.insert('content_blocks', {
        'rukun_iman_id': id,
        'text': content[i],
        'is_bold': boldIndices.contains(i) ? 1 : 0,
        'is_arabic': arabicIndices.contains(i) ? 1 : 0,
        'sort_order': i,
      });
    }

    return id;
  }

  // ============ INSERT RUKUN KETIGA ============

  Future<int> _insertRukunKetiga(Database db) async {
    final id = await db.insert('rukun_iman', {
      'title': 'RUKUN KETIGA: BERIMAN KEPADA KITAB',
      'subtitle': 'May 24, 2019',
      'date': '2019-05-24',
      'category': 'ketiga',
      'created_at': DateTime.now().toIso8601String(),
    });

    final content = [
      'Beriman dengan kitab-kitab Allah yang diturunkan ke atas rasul-rasul a.s. ialah Rukun Iman yang ketiga. Allah Taala telah mengutuskan rasul-rasul-Nya dengan bukti-bukti yang jelas serta menurunkan kepada mereka kitab-kitab yang menjadi rahmat kepada alam semesta. Kitab-kitab ini menjadi petunjuk kepada mereka untuk mencapai kebahagiaan di dunia dan di akhirat, juga sebagai pedoman hidup yang akan mereka lalui dan penyelesai kepada semua perkara yang menjadi perselisihan di kalangan mereka.',
      'Firman Allah Taala: "Demi sesungguhnya! Kami telah mengutus rasul-rasul Kami dengan membawa bukti-bukti dan mukjizat yang jelas (nyata) dan Kami telah menurunkan bersama-sama mereka kitab suci dan keterangan yang menjadi neraca keadilan, supaya manusia dapat menjalankan keadilan". (Surah Al-Hadid, Ayat 25).',
      'Firman Allah Taala: "Pada mulanya manusia itu ialah umat yang satu (menurut agama Allah yang satu, tetapi setelah mereka berselisihan), maka Allah mengutuskan nabi-nabi sebagai pemberi khabar gembira (kepada orang-orang yang beriman dengan balasan syurga) dan pemberi amaran (kepada orang-orang yang ingkar dengan balasan azab neraka) dan Allah menurunkan bersama nabi-nabi itu kitab-kitab suci yang (mengandungi keterangan-keterangan yang) benar, untuk menjalankan hukum di antara manusia mengenai perkara yang mereka perselisihkan". (Surah Al-Baqarah, Ayat 213).',
      'A – HAKIKAT BERIMAN DENGAN KITAB-KITAB',
      'Beriman dengan kitab-kitab ialah mengakui dengan sepenuhnya bahawa Allah menurunkan Kitab-kitab kepada rasul-rasul a.s. Kitab-kitab itu adalah kalam Allah yang hakiki, ianya membawa cahaya dan petunjuk, semua isi kandungannya hak, benar dan adil. Kita wajib mengikutinya dan beramal dengannya, tidak diketahui bilangannya kecuali Allah.',
      'Firman Allah Taala: "Dan Allah telah berkata-kata kepada Nabi Musa dengan kata-kata (secara langsung, tidak ada perantaraan)". (Surah An-Nisa\', Ayat 164).',
      'Firman Allah Taala: "Dan jika seseorang daripada kaum musyrik meminta perlindungan kepadamu (untuk memahami Islam), maka berilah perlindungan kepadanya sehingga dia sempat mendengar keterangan-keterangan Allah (tentang hakikat Islam itu)". (Surah At-Taubah, Ayat 6).',
      'B – HUKUM BERIMAN DENGAN KITAB',
      'Wajib beriman dengan semua kitab yang diturunkan oleh Allah kepada rasul-rasul-Nya a.s. Allah Taala berkata-kata dengan secara hakiki. Sesungguhnya kitab yang diturunkan itu bukanlah makhluk, sesiapa yang mengingkari semuanya atau sebahagian daripadanya akan menjadi kafir.',
      'Firman Allah Taala: "Wahai orang-orang yang beriman! Tetapkanlah iman kamu kepada Allah dan Rasul-Nya dan kepada kitab Al-Quran yang telah diturunkan kepada Rasul-Nya (Muhammad s.a.w) dan juga kepada kitab-kitab suci yang telah diturunkan terdahulu daripada itu dan sesiapa yang kufur (ingkar) kepada Allah dan malaikat-malaikat-Nya dan kitab-kitab-Nya dan rasul-rasul-Nya dan juga Hari Akhirat, maka sesungguhnya dia telah sesat dengan kesesatan yang amat jauh". (Surah An-Nisa\', Ayat 136).',
      'Firman Allah Taala: "Dan ini sebuah kitab (Al-Quran) yang Kami turunkan, yang ada berkatnya (banyak manfaatnya). Oleh itu, hendaklah kamu mengikutinya dan bertaqwalah (kepada Allah), mudah-mudahan kamu beroleh rahmat". (Surah Al-An\'am, Ayat 155).',
      'C – KEPERLUAN MANUSIA KEPADA KITAB-KITAB (PETUNJUK) DAN HIKMAH DARIPADA PENURUNANNYA',
      '1. Supaya kitab-kitab yang diturunkan kepada rasul-rasul akan menjadi rujukan bagi umatnya. Mereka merujuk kepadanya untuk mengetahui agama mereka.',
      '2. Supaya kitab-kitab yang diturunkan kepada rasul-rasul akan menjadi sumber hukum yang adil kepada umatnya dalam semua perkara yang menjadi perselisihan.',
      '3. Supaya kitab-kitab yang diturunkan kepada rasul-rasul akan menjaga agama selepas kewafatan rasul tersebut, walaupun panjang jarak masa dan tempat, sebagaimana keadaan dakwah Nabi kita Muhammad s.a.w.',
      '4. Supaya kitab-kitab ini menjadi hujjah Allah Taala ke atas hamba-Nya, tidak mungkin mereka menyalahinya atau tidak mengikutinya.',
      'Firman Allah Taala: "Pada mulanya manusia itu ialah umat yang satu (menurut agama Allah yang satu, tetapi setelah mereka berselisihan), maka Allah mengutuskan nabi-nabi sebagai pemberi khabar gembira (kepada orang-orang yang beriman dengan balasan syurga) dan pemberi amaran (kepada orang-orang yang ingkar dengan balasan azab neraka) dan Allah menurunkan bersama nabi-nabi itu kitab-kitab suci yang (mengandungi keterangan-keterangan yang) benar, untuk menjalankan hukum di antara manusia mengenai apa yang mereka perselisihkan". (Surah Al-Baqarah, Ayat 213).',
      'D – CARA BERIMAN DENGAN KITAB-KITAB',
      'Beriman dengan kitab-kitab Allah secara umum dan secara terperinci.',
      'Beriman secara umum ialah: Beriman bahawa Allah Taala telah menurunkan kitab-kitab kepada rasul-rasul-Nya a.s.',
      'Manakala beriman secara terperinci pula ialah: Beriman dengan semua kitab yang Allah sebutkan namanya di dalam Al-Quran. Sesungguhnya kita telah mengetahui sebahagian daripadanya, iaitu: Al-Quran, Taurat, Zabur, Injil, Suhuf Ibrahim dan Suhuf Musa. Kita juga beriman bahawa sesungguhnya Allah Taala telah menurunkan kitab-kitab lain selain daripada kitab-kitab yang tersebut kepada nabi-nabi-Nya, tidak mengetahui namanya serta bilangannya kecuali yang menurunkannya (Allah Taala).',
      'Semua kitab ini diturunkan untuk meneguhkan tauhid terhadap Allah dengan mengesakan-Nya dengan ibadat dan amal soleh serta menegah daripada melakukan perbuatan syirik dan kerosakan di atas muka bumi ini. Asal dakwah para nabi adalah satu, walaupun berbeza dari segi syariat dan hukum. Beriman dengan kitab-kitab bererti mengakui turunnya kitab-kitab kepada rasul-rasul yang terdahulu dan beriman dengan Al-Quran ialah mengakui kebenarannya serta mengikut semua isi kandungannya.',
      'Firman Allah Taala: "Rasulullah telah beriman kepada apa yang diturunkan kepadanya dari Tuhannya dan juga orang-orang yang beriman semuanya beriman kepada Allah dan malaikat-malaikat-Nya dan kitab-kitab-Nya dan rasul-rasul-Nya". (Surah Al-Baqarah, Ayat 285).',
      'Firman Allah Taala: "(Katakanlah kepada mereka wahai Muhammad): Turutlah apa yang telah diturunkan kepada kamu dari Tuhan kamu dan janganlah kamu menurut pemimpin-pemimpin yang lain dari Allah". (Surah Al-A\'raf, ayat 3).',
      'Sesungguhnya Al-Quran istimewa daripada kitab-kitab terdahulu disebabkan beberapa perkara, yang terpentingnya ialah:',
      '1. Al-Quran adalah mukjizat dengan lafaz dan maknanya serta semua isi kandungannya yang mengandungi hakikat alam semesta dan sains.',
      '2. Al-Quran ialah kitab terakhir yang diturunkan dari langit, menjadi penutup kepada semua kitab-kitab terdahulu sebagaimana Nabi kita Muhammad s.a.w menjadi penutup sekalian rasul.',
      '3. Allah Taala telah menjamin untuk menjaganya daripada sebarang penyelewengan atau pengubahan, berbeza dengan kitab-kitab yang lain, telah ditukar dan diubah isi kandungannya.',
      '4. Al-Quran membenarkan semua kitab yang terdahulu daripadanya serta memelihara dan mengawasi kitab-kitab tersebut.',
      '5. Al-Quran telah membatalkan ("menasakh") semua kitab-kitab yang terdahulu.',
      'Firman Allah Taala: "(Kisah nabi-nabi yang terkandung dalam Al-Quran) bukanlah merupakan suatu cerita yang diada-adakan, tetapi ia mengisahkan apa yang tersebut di dalam kitab-kitab agama yang terdahulu daripadanya dan merupakan keterangan yang menjelaskan tiap-tiap sesuatu serta menjadi hidayat petunjuk dan rahmat bagi kaum yang (mahu) beriman". (Surah Yusuf, Ayat 111).',
      'E – MENERIMA KHABAR (BERITA) KITAB-KITAB TERDAHULU',
      'Kita mengetahui secara yakin bahawa semua cerita yang terkandung di dalam kitab-kitab terdahulu yang telah diwahyukan oleh Allah kepada rasul-rasul-Nya a.s. adalah benar dan tidak diragui akan kebenarannya.',
      'Ini tidak bermakna kita menerima semua isi kandungan kitab-kitab yang masih ada di tangan Ahli Kitab (Yahudi dan Nasrani), kerana ianya telah ditukar dan diselewengkan, tidak ada lagi naskhah sebenar sebagaimana yang diturunkan oleh Allah kepada rasul-rasul-Nya a.s. Antara yang kita yakini benar daripada isi kandungan kitab-kitab terdahulu ialah perkara yang telah diterangkan oleh Allah di dalam kitab-Nya: "Bahawa sesungguhnya seseorang itu tidak akan memikul dosa perbuatan orang lain kecuali dosa yang dilakukannya sahaja". Dan, "Bahawasanya seseorang itu tidak memperolehi sesuatu selain apa yang telah diusahakannya". Dan, "Bahawa sesungguhnya usaha itu akan ditunjukkan (kepadanya, pada Hari Kiamat kelak). Kemudian usaha itu akan dibalas dengan balasan yang amat sempurna".',
      'Firman Allah Taala: "Atau belumkah dia diberitahu akan apa yang terkandung dalam kitab-kitab Nabi Musa dan juga (dalam kitab-kitab) Nabi Ibrahim yang memenuhi dengan sempurnanya (segala yang diperintahkan kepadanya). (Dalam kitab-kitab itu ditegaskan): Bahawa sesungguhnya seseorang itu tidak akan memikul dosa perbuatan orang lain kecuali dosa yang dilakukannya sahaja dan bahawasanya seseorang itu tidak memperolehi sesuatu selain apa yang telah diusahakannya. Dan bahawa sesungguhnya usaha itu akan ditunjukkan (kepadanya, pada Hari Kiamat kelak). Kemudian usaha itu akan dibalas dengan balasan yang amat sempurna". (Surah An-Najm, Ayat 36-41).',
      'Firman Allah Taala: "Bahkan kamu utamakan kehidupan dunia. Padahal kehidupan akhirat lebih baik dan lebih kekal. Sesungguhnya (keterangan-keterangan yang dinyatakan) ini ada (disebutkan) di dalam kitab-kitab yang terdahulu, iaitu kitab-kitab Nabi Ibrahim dan Nabi Musa". (Surah Al-A\'la, Ayat 16-19).',
      'Adapun hukum-hukumnya: Semua hukum yang terkandung di dalam Al-Quran wajib ke atas kita untuk mengikutinya. Ini berbeza dengan isi kandungan kitab-kitab yang terdahulu, kita pertimbangkan dahulu, sekiranya ia bercanggah dengan syariat kita maka tidak boleh beramal dengannya, bukan ianya suatu hukum yang batil, sebaliknya ia adalah suatu yang hak pada zaman diturunkannya tetapi kita tidak wajib mengikutinya kerana ia telah termansuh (terbatal) dengan syariat kita dan sekiranya ia bertepatan dengan syariat kita maka ianya benar, syariat kita telah membuktikan kebenarannya.',
      'F – KITAB-KITAB YANG DITURUNKAN DARI LANGIT YANG DISEBUT DI DALAM AL-QURAN DAN AS-SUNNAH',
      '1. Al-Quran Al-Karim',
      'Al-Quran ialah kalam Allah yang diturunkan kepada Nabi Muhammad s.a.w, penamat sekalian rasul, ia adalah kitab terakhir yang diturunkan, Allah telah menjamin untuk menjaganya daripada sebarang penyelewengan dan pengubahan serta menjadikannya "nasikh" (pembatal) semua kitab-kitab yang lain.',
      'Firman Allah Taala: "Sesungguhnya Kamilah yang menurunkan Al-Quran dan Kamilah yang memelihara dan menjaganya". (Surah Al-Hijr, Ayat 9).',
      'Firman Allah Taala: "Dan Kami turunkan kepadamu (wahai Muhammad) kitab (Al-Quran) dengan membawa kebenaran, untuk mengesahkan kebenaran kitab-kitab suci yang telah diturunkan sebelumnya dan untuk memelihara serta mengawasinya. Maka jalankanlah hukuman di antara mereka (Ahli Kitab) itu dengan apa yang telah diturunkan oleh Allah (kepadamu)". (Surah Al-Maidah, Ayat 48).',
      '2. Taurat',
      'Taurat ialah kitab yang diturunkan oleh Allah kepada Nabi Musa a.s. dan menjadikannya petunjuk dan cahaya yang berhukum dengannya Bani Israel dan ulama\' mereka.',
      'Kitab Taurat yang kita wajib beriman dengannya ialah Taurat yang Allah turunkan kepada Nabi Musa a.s, bukan Taurat yang telah dipinda dan diubah yang berada di tangan Ahli Kitab sekarang.',
      'Firman Allah Taala: "Sesungguhnya Kami telah menurunkan Kitab Taurat, yang mengandungi petunjuk dan cahaya yang menerangi dengan kitab itu nabi-nabi yang menyerah diri (kepada Allah) menetapkan hukum bagi orang-orang Yahudi dan (dengannya juga) ulama\' mereka dan pendita-penditanya (menjalankan hukum Allah), sebab mereka diamanahkan memelihara dan menjalankan hukum-hukum dari Kitab Allah (Taurat) itu". (Surah Al-Maidah, Ayat 44).',
      '3. Injil',
      'Injil ialah Kitab yang diturunkan oleh Allah kepada Nabi \'Isa a.s., menjadi pembenar kepada kitab-kitab dari langit yang terdahulu darinya.',
      'Kitab Injil yang kita wajib beriman dengannya ialah Injil yang Allah turunkan kepada Nabi \'Isa a.s dengan asas yang sahih, bukan Injil yang telah dipinda dan diubah yang berada di tangan Ahli Kitab sekarang.',
      'Firman Allah Taala: "Dan Kami utuskan Nabi \'Isa ibni Mariam mengikuti jejak langkah mereka (nabi-nabi Bani Israil), untuk membenarkan Kitab Taurat yang diturunkan sebelumnya dan Kami telah berikan kepadanya Kitab Injil, yang mengandungi petunjuk hidayat dan cahaya yang menerangi, sambil mengesahkan benarnya apa yang telah ada di hadapannya dari Kitab Taurat, serta menjadi petunjuk dan nasihat pengajaran bagi orang-orang yang (hendak) bertaqwa". (Surah Al-Maidah, Ayat 46).',
      'Di antara isi kandungan Taurat dan Injil ialah membawa khabar risalah Nabi kita Muhammad s.a.w.',
      'Firman Allah Taala: "Iaitu orang-orang yang mengikut Rasulullah (Muhammad s.a.w.) Nabi yang Ummi, yang mereka dapati tertulis (namanya dan sifat-sifatnya) di dalam Taurat dan Injil yang ada di sisi mereka. Dia menyuruh mereka dengan perkara-perkara yang baik dan melarang mereka daripada melakukan perkara-perkara yang keji dan dia menghalalkan bagi mereka segala perkara yang baik dan mengharamkan kepada mereka segala perkara yang buruk dan dia juga menghapuskan beban-beban dan belenggu-belenggu yang ada pada mereka". (Surah Al-A\'raf, Ayat 157).',
      '4. Zabur',
      'Zabur ialah Kitab yang diturunkan oleh Allah kepada Nabi Daud a.s.',
      'Kitab Zabur yang kita wajib beriman dengannya ialah Zabur yang Allah turunkan kepada Nabi Daud a.s., bukan Zabur yang telah dipinda dan diubah oleh angkara jahat orang Yahudi.',
      'Firman Allah Taala: "Dan juga Kami telah mengurniakan kepada Nabi Daud Kitab Zabur". (Surah An-Nisa\', Ayat 163).',
      '5. Suhuf Nabi Ibrahim a.s. dan Musa a.s.',
      'Iaitu Suhuf yang telah diberi oleh Allah kepada Nabi Ibrahim dan Nabi Musa a.s. Suhuf-suhuf ini telah hilang tidak dapat diketahui sesuatu tentang isi kandungannya kecuali perkara yang telah disebut mengenainya dalam Al-Quran dan As-Sunnah.',
      'Firman Allah Taala: "Atau belumkah dia diberitahu akan apa yang terkandung dalam kitab-kitab Nabi Musa dan juga (dalam kitab-kitab) Nabi Ibrahim yang memenuhi dengan sempurnanya (segala yang diperintahkan kepadanya)? (Dalam kitab-kitab itu ditegaskan): Bahawa sesungguhnya seseorang itu tidak akan memikul dosa perbuatan orang lain kecuali dosa yang dilakukannya sahaja. Dan bahawasanya seseorang itu tidak memperolehi sesuatu selain apa yang telah diusahakannya. Dan bahawa sesungguhnya usaha itu akan ditunjukkan (kepadanya, pada Hari Kiamat kelak). Kemudian usaha itu akan dibalas dengan balasan yang amat sempurna". (Surah An-Najm, Ayat 36-41).',
      'Firman Allah Taala: "Bahkan kamu utamakan kehidupan dunia; Padahal kehidupan akhirat lebih baik dan lebih kekal. Sesungguhnya (keterangan-keterangan yang dinyatakan) ini ada (disebutkan) di dalam kitab-kitab yang terdahulu, Iaitu kitab-kitab Nabi Ibrahim dan Nabi Musa". (Surah Al-A\'la, Ayat 16-19).',
    ];

    final boldIndices = [
      3,    // A – HAKIKAT BERIMAN DENGAN KITAB-KITAB
      7,    // B – HUKUM BERIMAN DENGAN KITAB
      11,   // C – KEPERLUAN MANUSIA KEPADA KITAB-KITAB...
      12,   // 1. Supaya kitab-kitab yang diturunkan kepada rasul-rasul...
      13,   // 2. Supaya kitab-kitab yang diturunkan kepada rasul-rasul...
      14,   // 3. Supaya kitab-kitab yang diturunkan kepada rasul-rasul...
      15,   // 4. Supaya kitab-kitab ini menjadi hujjah Allah Taala...
      17,   // D – CARA BERIMAN DENGAN KITAB-KITAB
      25,   // 1. Al-Quran adalah mukjizat dengan lafaz dan maknanya...
      26,   // 2. Al-Quran ialah kitab terakhir yang diturunkan dari langit...
      27,   // 3. Allah Taala telah menjamin untuk menjaganya...
      28,   // 4. Al-Quran membenarkan semua kitab yang terdahulu...
      29,   // 5. Al-Quran telah membatalkan ("menasakh")...
      31,   // E – MENERIMA KHABAR (BERITA) KITAB-KITAB TERDAHULU
      37,   // F – KITAB-KITAB YANG DITURUNKAN DARI LANGIT...
      38,   // 1. Al-Quran Al-Karim
      42,   // 2. Taurat
      46,   // 3. Injil
      52,   // 4. Zabur
      56,   // 5. Suhuf Nabi Ibrahim a.s. dan Musa a.s.
    ];

    final arabicIndices = [];

    for (var i = 0; i < content.length; i++) {
      await db.insert('content_blocks', {
        'rukun_iman_id': id,
        'text': content[i],
        'is_bold': boldIndices.contains(i) ? 1 : 0,
        'is_arabic': arabicIndices.contains(i) ? 1 : 0,
        'sort_order': i,
      });
    }

    return id;
  }

  // ============ INSERT RUKUN KEEMPAT ============

  Future<int> _insertRukunKeempat(Database db) async {
    final id = await db.insert('rukun_iman', {
      'title': 'RUKUN KEEMPAT: BERIMAN KEPADA RASUL',
      'subtitle': 'May 24, 2019',
      'date': '2019-05-24',
      'category': 'keempat',
      'created_at': DateTime.now().toIso8601String(),
    });

    final content = [
      'A – BERIMAN DENGAN RASUL-RASUL \'Alaihimussalam.',
      'Beriman dengan rasul-rasul a.s. ialah salah satu daripada Rukun Iman dan tidak sempurna iman seseorang yang tidak beriman dengan rasul-rasul.',
      'Beriman dengan rasul-rasul: Ialah iktikad dengan yakin bahawa Allah Taala mempunyai rasul-rasul yang dipilih untuk meyampaikan risalah-Nya. Sesiapa yang mengikut rasul maka dia telah mendapat petunjuk dan sesiapa yang menderhaka kepada rasul sesungguhnya dia telah terpesong daripada jalan yang benar. Mereka telah meyampaikan semua ajaran yang diturunkan oleh Allah dengan keterangan yang nyata, mereka telah menunaikan amanah dan menasihati ummah, berjihad pada jalan Allah dengan sebenar-benar jihad, mendirikan hujjah dan tidak sekali-kali menukar, mengubah atau menyembunyikan sesuatu yang disampaikan kepada mereka. Kita beriman dengan rasul yang telah disebut nama mereka oleh Allah dan juga rasul yang tidak disebut nama mereka.',
      'Setiap rasul menyampaikan khabar gembira dengan kedatangan rasul selepasnya dan yang terakhir pula akan membenarkan rasul-rasul sebelumnya.',
      'Firman Allah Taala: "Katakanlah (wahai orang-orang yang beriman): Kami beriman kepada Allah dan kepada kitab yang diturunkan kepada kami (Al-Quran) dan kepada kitab yang diturunkan kepada Nabi Ibrahim, Nabi Ismail, Nabi Ishak, Nabi Yaakub serta anak-anaknya dan juga kepada kitab yang diberikan kepada Nabi Musa (Taurat) dan Nabi \'Isa (Injil) dan kepada kitab yang diberikan kepada nabi-nabi daripada Tuhan mereka, kami tidak membeza-bezakan seseorang pun di antara mereka (sebagaimana kamu – Yahudi dan Nasrani – membeza-bezakannya) dan kami semua tunduk dan patuh (berserah diri, tunduk taat) kepada Allah semata-mata". (Surah Al-Baqarah, Ayat 136).',
      'Sesiapa yang mendustakan rasul sesungguhnya dia telah mendustakan Tuhan yang membenarkannya dan sesiapa yang menderhaka kepada rasul sesungguhnya dia telah menderhaka kepada Tuhan yang menyuruh mentaatinya.',
      'Firman Allah Taala: "Sesungguhnya orang-orang yang kufur (ingkar) kepada Allah dan rasul-rasul-Nya dan (orang-orang yang) hendak membeza-bezakan iman mereka di antara Allah dan rasul-rasul-Nya dan (orang-orang yang) berkata: Kami beriman kepada sebahagian daripada rasul-rasul itu dan kufur (ingkar) kepada sebahagian yang lain, serta bertujuan mengambil jalan tengah di antara iman dan kufur itu. Mereka itulah orang-orang yang kafir dengan sebenar-benarnya dan Kami telah menyediakan bagi orang-orang kafir itu azab seksa yang menghinakan". (Surah An-Nisa\', Ayat 150-151).',
      'B – HAKIKAT KENABIAN (AN-NUBUWWAH)',
      'An-Nubuwwah ialah perantaraan di antara Pencipta dan makhluk dalam menyampaikan syariat. Allah telah memberikan nikmat kepada sesiapa yang dikehendaki-Nya dari kalangan hamba-hamba-Nya dan memilih sesiapa yang dikehendaki-Nya dari kalangan makhluk-Nya untuk menjalankan tugas kenabian ini dan tidak ada sesiapa yang berhak memilihnya selain daripada Allah.',
      'Firman Allah Taala: "Allah memilih utusan-utusan-Nya di kalangan para malaikat dan daripada kalangan manusia. Sesungguhnya Allah Maha Mendengar, lagi Maha Mengetahui". (Surah Al-Hajj, Ayat 75).',
      'Martabat kenabian ialah anugerah daripada Allah Taala kepada hamba-Nya, bukanlah sesuatu yang boleh diusahakan oleh seorang hamba, ia tidak dapat dicapai dengan banyak melakukan ketaatan atau ibadat, tidak juga dengan dipilih seorang nabi yang lain atas permintaannya, sesungguhnya ia adalah anugerah dan pilihan daripada Allah Taala.',
      'Firman Allah Taala: "Allah memilih serta mempermudahkan sesiapa yang dikehendaki-Nya untuk menerima agama tauhid dan memberi hidayat (kepada agama-Nya) sesiapa yang kembali kepada-Nya (dengan taat)". (Surah Asy-Syura, Ayat 13).',
      'C – HIKMAH DIUTUSKAN RASUL',
      'Hikmah diutuskan rasul-rasul a.s. dapat dilihat daripada contoh berikut:',
      '1. Mengeluarkan hamba-hamba Allah daripada menyembah sesama hamba kepada menyembah Tuhan yang memiliki hamba (Allah). Keluar daripada perhambaan kepada makhluk kepada kemerdekaan menyembah Tuhan sekalian hamba.',
      'Firman Allah Taala: "Dan tidaklah Kami utuskan engkau (wahai Muhammad), melainkan untuk menjadi rahmat bagi sekalian alam". (Surah Al-Anbiya\', Ayat 107).',
      '2. Menjelaskan tujuan sebenar Allah s.w.t. menciptakan makhluk, iaitu untuk beribadat kepada-Nya serta mentauhidkan-Nya, semua ini tidak dapat diketahui kecuali melalui ajaran yang dibawa oleh rasul-rasul a.s. yang telah dipilih oleh Allah daripada kalangan makhluk-Nya serta memberikan mereka kelebihan di atas semua alam semesta.',
      'Firman Allah Taala: "Dan sesungguhnya Kami telah mengutuskan kepada setiap umat seorang rasul (dengan memerintahkannya supaya menyeru mereka): Hendaklah kamu menyembah Allah dan jauhilah taghut". (Surah An-Nahl, Ayat 36).',
      '3. Mendirikan hujjah ke atas manusia dengan mengutuskan rasul-rasul.',
      'Firman Allah Taala: "Rasul-rasul (yang Kami telah utuskan itu semuanya) pembawa khabar gembira (kepada orang-orang yang beriman) dan pemberi amaran (kepada orang-orang yang kafir dan yang berbuat maksiat), supaya tidak ada bagi manusia itu hujjah (atau sebarang alasan untuk berdalih pada Hari Kiamat kelak) terhadap Allah sesudah Dia mengutuskan rasul-rasul. Dan (ingatlah) Allah Maha Kuasa, lagi Maha Bijaksana". (Surah An-Nisa\', Ayat 165).',
      '4. Menerangkan beberapa perkara ghaib yang tidak dapat dicapai oleh manusia dengan akal mereka seperti nama-nama Allah, sifat-sifat-Nya, mengenali para malaikat, Hari Akhirat dan lain-lain.',
      '5. Semua rasul a.s. merupakan contoh ikutan yang sempurna, Allah telah menyempurnakan mereka dengan akhlak yang baik dan juga memelihara mereka daripada "syubuhat" (keraguan) dan syahwat.',
      'Firman Allah Taala: "Mereka (nabi-nabi) itulah, orang-orang yang telah diberi petunjuk oleh Allah, maka turutilah olehmu (wahai Muhammad) akan petunjuk mereka". (Surah Al-An\'am, Ayat 90).',
      'Firman Allah Taala: "Demi sesungguhnya ada pada mereka itu (Nabi Ibrahim dan pengikut-pengikutnya) satu contoh tauladan yang baik bagimu". (Surah Al-Mumtahanah, Ayat 6).',
      '6. Memperbaiki, memurni dan membersihkan nafsu serta menjauhkannya daripada perkara-perkara yang merosakkannya.',
      'Firman Allah Taala: "Dialah (Allah) yang telah mengutuskan dari kalangan orang-orang (Arab) yang "Ummiyyin", seorang Rasul (Nabi Muhammad) daripada bangsa mereka sendiri, yang membacakan kepada mereka ayat-ayat Allah (yang membuktikan keesaan Allah dan kekuasaan-Nya) dan membersihkan mereka (dari iktikad yang sesat) serta mengajarkan mereka Kitab Allah (Al-Quran) dan Hikmah (pengetahuan yang mendalam mengenai hukum-hukum syarak)". (Surah Al-Jumu\'ah, Ayat 2).',
      'Sabda Nabi s.a.w:',
      'إنما بعثت لأتمم مكارم الأخلاق [رواه أحمد والحاكم]',
      '"Sesungguhnya aku dibangkitkan untuk menyempurnakan budi pekerti (akhlak) yang mulia". (Hadith Riwayat Ahmad dan Al-Hakim).',
      'D – TUGAS-TUGAS RASUL',
      'Rasul-rasul a.s. mempunyai tugas yang mulia, antaranya:',
      '1. Menyampaikan syariat Allah dan menyeru manusia untuk menghambakan diri kepada Allah yang Esa serta menolak semua ibadat kepada selain daripada Allah.',
      'Firman Allah Taala: "(Nabi-nabi yang terdahulu itu) ialah orang-orang yang menyampaikan syariat Allah serta mereka takut untuk melanggar perintah-Nya dan mereka pula tidak takut kepada sesiapa pun melainkan Allah dan cukuplah Allah menjadi Penghitung (segala yang dilakukan oleh makhluk-makhluk-Nya untuk membalas mereka)". (Surah Al-Ahzab, Ayat 39).',
      '2. Menjelaskan kepada manusia semua ajaran agama yang telah diturunkan kepada mereka.',
      'Firman Allah Taala: "Dan kami turunkan kepadamu (wahai Muhammad) Al-Quran yang memberi peringatan, supaya engkau menerangkan kepada umat manusia akan apa yang telah diturunkan kepada mereka dan supaya mereka memikirkannya". (Surah An-Nahl, Ayat 44).',
      '3. Membawa umat ke arah kebaikan dan menjauhkan mereka daripada melakukan kejahatan, memberi khabar gembira tentang pahala (kepada mereka yang melakukan kebaikan) serta memberi amaran kepada (mereka yang melakukan kejahatan) dengan seksaan.',
      'Firman Allah Taala: "Rasul-rasul (yang Kami telah utuskan itu semuanya) pembawa khabar gembira (kepada orang-orang yang beriman) dan pemberi amaran (kepada orang-orang yang kafir dan yang berbuat maksiat)". (Surah An-Nisa\', Ayat 165).',
      '4. Memperbaiki manusia dengan menunjukkan contoh ikutan yang baik dalam perkataan dan perbuatan.',
      '5. Menegakkan dan melaksanakan syariat Allah di kalangan manusia.',
      '6. Semua rasul akan menjadi saksi ke atas umatnya pada Hari Kiamat bahawa mereka telah menyampaikan syariat Allah kepada umat dengan jelas.',
      'Firman Allah Taala: "Maka bagaimanakah (keadaan orang-orang kafir pada Hari Akhirat kelak), apabila Kami datangkan dari tiap-tiap umat seorang saksi (iaitu rasul mereka sendiri menjadi saksi terhadap perbuatan mereka) dan Kami juga datangkan engkau (wahai Muhammad) sebagai saksi terhadap umatmu". (Surah An-Nisa\', Ayat 41).',
      'E – ISLAM IALAH AGAMA SEMUA NABI',
      'Islam ialah agama semua nabi dan rasul. Firman Allah Taala: "Sesungguhnya agama (yang benar dan diredhai) di sisi Allah ialah Islam". (Surah Ali \'Imran, Ayat 19). Semua nabi dan rasul a.s. menyeru manusia kepada menyembah Allah Yang Esa dan menolak semua ibadat yang lain, walaupun berbeza dari segi syariat (perundangan) dan hukum, tetapi sama pada asasnya iaitu Tauhid kepada Tuhan Yang Esa.',
      'Sabda Nabi s.a.w:',
      'الأنبياء إخوة لعلات [رواه البخاري]',
      '"Semua nabi adalah adik beradik tiri (sebapa tapi berlainan ibu)". (Hadith Riwayat Al-Bukhari).',
      'F – RASUL-RASUL ADALAH MANUSIA BIASA, MEREKA TIDAK MENGETAHUI PERKARA YANG GHAIB',
      'Mengetahui perkara ghaib merupakan ciri-ciri sifat "uluhiyyah" (ketuhanan) dan bukannya daripada sifat nabi, kerana mereka manusia biasa seperti manusia lain juga, mereka makan, minum, berkahwin, tidur, sakit dan merasai kepenatan.',
      'Firman Allah Taala: "Dan Kami tidak mengutus rasul-rasul sebelummu (wahai Muhammad) melainkan sesungguhnya mereka juga makan, minum dan berjalan di pasar-pasar". (Surah Al-Furqan, Ayat 20).',
      'Firman Allah Taala: "Dan demi sesungguhnya! Kami telah mengutus rasul-rasul sebelummu dan Kami jadikan bagi mereka isteri-isteri dan zuriat keturunan". (Surah Ar-Ra\'d, Ayat 38).',
      'Mereka juga mempunyai perasaan seperti manusia lain, sedih, suka, susah dan senang, tetapi mereka mempunyai kelebihan kerana dipilih oleh Allah s.w.t sebagai penyampai agama-Nya dan mereka tidak mengetahui perkara ghaib kecuali perkara-perkara yang Allah Taala tunjukkan kepada mereka.',
      'Firman Allah Taala: "Tuhanlah sahaja yang mengetahui segala yang ghaib, maka Dia tidak memberitahu perkara ghaib yang diketahui-Nya itu kepada sesiapapun melainkan kepada mana-mana rasul yang diredhai-Nya (untuk mengetahui sebahagian dari perkara ghaib yang berkaitan dengan tugasnya, apabila Tuhan hendak melakukan yang demikian) maka Dia mengadakan di hadapan dan di belakang rasul itu malaikat-malaikat yang menjaga dan mengawasinya (sehingga perkara ghaib itu selamat sampai kepada yang berkenaan)". (Surah Al-Jin, ayat 26-27).',
      'G – "\'ISMAH" (PEMELIHARAAN) RASUL',
      'Allah Taala telah memilih orang yang akan membawa dan menyampaikan risalah-Nya daripada sebaik-baik makhluk dan semulia-mulia kejadian dan akhlak. Allah juga menjaga mereka daripada melakukan sebarang dosa dan melepaskan mereka daripada sebarang cacat-cela sehingga mereka dapat menyampaikan wahyu Allah kepada umat mereka. Mereka semua "ma\'sum" (terpelihara daripada kesalahan) dalam menyampaikan semua perkara dan ajaran (risalah) yang datang daripada Allah Taala. Inilah pendapat yang disepakati ummah (ulama\').',
      'Firman Allah Taala: "Wahai Rasulullah! Sampaikanlah apa yang telah diturunkan kepadamu dari Tuhanmu dan jika engkau tidak melakukannya (dengan menyampaikan semuanya), maka bermakna tiadalah engkau menyampaikan perutusan-Nya dan Allah jualah yang memeliharamu dari (kejahatan) manusia". (Surah Al-Maidah, Ayat 67).',
      'Firman Allah Taala: "(Nabi-nabi yang terdahulu itu) ialah orang-orang yang menyampaikan syariat Allah serta mereka takut melanggar perintah-Nya dan mereka pula tidak takut kepada sesiapa pun melainkan kepada Allah". (Surah Al-Ahzab, Ayat 39).',
      'Firman Allah Taala: "(Tuhan mengadakan malaikat-malaikat itu) supaya Dia mengetahui bahawa sesungguhnya (dengan jagaan mereka) rasul-rasul itu telah menyampaikan perutusan-perutusan Tuhan mereka (dengan sempurna), padahal Dia memang mengetahui dengan meliputi segala keadaan yang ada pada mereka serta Dia menghitung tiap-tiap sesuatu, satu persatu". (Surah Al-Jin, ayat 28).',
      'Apabila salah seorang daripada mereka melakukan kesalahan kecil yang tidak bersangkut dengan penyampaian risalah Allah, maka Allah akan menegur mereka dan dengan segera mereka akan bertaubat dan kembali kepada Allah, seolah-olah mereka tidak melakukan kesalahan tersebut dan dengan demikian mereka akan mencapai martabat yang lebih tinggi daripada martabat sebelumnya. Ini kerana Allah telah menentukan semua Nabi – selawat dan salam Allah ke atas mereka – mempunyai akhlak yang mulia dan sifat yang terpuji serta membersihkan mereka daripada perkara yang menjatuhkan martabat dan kedudukan mereka.',
      'H – BILANGAN NABI DAN RASUL SERTA YANG PALING UTAMA DI KALANGAN MEREKA',
      'Telah sabit bahawa bilangan rasul-rasul \'alaihimussalam lebih dari 300 orang, kerana sabda Nabi s.a.w ketika ditanya tentang bilangan rasul-rasul:',
      'ثلاثمائة وخمس عشرة جمًّا غفيرًا [رواه الحاكم]',
      '"Tiga ratus lima belas orang ramainya". (Hadith Riwayat Al-Hakim).',
      'Bilangan nabi pula lebih ramai daripada yang tersebut, sebahagian daripada mereka, Allah telah sebutkan kisahnya kepada kita di dalam kitab-Nya, sebahagian yang lain pula tidak disebut kisahnya kepada kita. Allah telah menyebut dalam kitab-Nya seramai 25 orang Nabi dan Rasul.',
      'Firman Allah Taala: "Dan (Kami telah mengutuskan) beberapa orang rasul yang telah Kami ceritakan kepadamu dahulu (sebelum ini) dan rasul-rasul yang tidak Kami ceritakan hal mereka kepadamu". (Surah An-Nisa\', Ayat 164).',
      'Firman Allah Taala: "Dan itulah hujjah (bukti) Kami, yang Kami berikan kepada Nabi Ibrahim untuk mengalahkan kaumnya. Kami tinggikan pangkat-pangkat (kedudukan) sesiapa yang Kami kehendaki. Sesungguhnya Tuhanmu Maha Bijaksana, lagi Maha Mengetahui. Dan Kami telah kurniakan kepada Nabi Ibrahim: (anaknya) Ishak (dari isterinya Sarah) dan (cucunya) Yaakub. Tiap-tiap seorang (daripada mereka) Kami telah kurniakan petunjuk dan juga Nabi Nuh Kami telah berikan petunjuk dahulu sebelum itu dan dari keturunan Nabi Ibrahim itu (ialah Nabi-nabi): Daud, Sulaiman, Ayub, Yusuf, Musa dan Harun dan demikianlah Kami berikan balasan kepada orang-orang yang berusaha supaya baik amal perbuatannya. Dan (dari keturunannya juga ialah Nabi-nabi): Zakaria, Yahya, \'Isa dan Ilyas, semuanya dari kalangan orang-orang yang soleh. Dan (dari keturunannya juga ialah Nabi-nabi): Ismail, Ilyasa\', Yunus, Lut dan mereka itu semuanya, Kami lebihkan darjat mereka atas umat-umat (yang ada pada zamannya)". (Surah Al-An\'am, Ayat 83-87).',
      'Allah Taala telah melebihkan darjat sebahagian para nabi di atas sebahagian yang lain, firman Allah Taala: "Dan sesungguhnya Kami telah melebihkan sebahagian nabi-nabi atas sebahagian yang lain". (Surah Al-Isra\', Ayat 55).',
      'Allah Taala juga telah melebihkan darjat sebahagian rasul di atas sebahagian yang lain, firman Allah Taala: "Rasul-rasul Kami lebihkan sebahagian daripada mereka di atas sebahagian yang lain (dengan kelebihan-kelebihan yang tertentu)". (Surah Al-Baqarah, Ayat 253). Dan yang paling afdhal di kalangan mereka ialah "Ulul \'Azmi" daripada rasul-rasul. Mereka ialah: Nabi Nuh, Ibrahim, Musa, \'Isa dan Muhammad a.s.',
      'Firman Allah Taala: "(Jika demikian akibat orang-orang kafir yang menentangmu wahai Muhammad) maka bersabarlah engkau sebagaimana sabarnya rasul-rasul "Ulul \'Azmi" (yang mempunyai keazaman dan ketabahan hati) dari kalangan rasul-rasul (yang terdahulu daripadamu)". (Surah Al-Ahqaf, Ayat 35).',
      'Firman Allah Taala: "Dan (ingatlah) ketika Kami mengambil dari nabi-nabi (umumnya) perjanjian setia mereka dan (khasnya) dari engkau sendiri (wahai Muhammad) dan dari Nabi Nuh dan Nabi Ibrahim dan Nabi Musa serta Nabi \'Isa ibni Mariam dan Kami telah mengambil dari mereka perjanjian setia lagi teguh (bagi menyempurnakan apa yang ditugaskan kepada mereka)". (Surah Al-Ahzab, Ayat 7).',
      'Nabi Muhammad s.a.w ialah Rasul yang paling mulia, penutup sekalian nabi, Imam (pemimpin) orang-orang bertaqwa, penghulu sekalian anak Adam, Imam kepada semua nabi-nabi ketika berhimpun dan jurucakap mereka ketika dibangkitkan (di Padang Mahsyar), pemilik "Maqam Al-Mahmud" iaitu kedudukan tertinggi yang menjadi impian semua kaum yang terdahulu dan kemudian, pemilik "Liwa\' Al-Hamd" bendera yang terpuji, kolam yang dikunjungi (pada Hari Kiamat), pemberi syafaat pada Hari Kiamat, yang mempunyai segala keutamaan dan kelebihan.',
      'Allah Taala mengutusnya dengan membawa syariat agama yang paling mulia, menjadikan umatnya sebaik-baik umat dari kalangan umat manusia, Allah telah menghimpunkan kepada Nabi Muhammad dan umatnya segala kebaikan dan kemuliaan yang membezakannya dengan orang-orang sebelum mereka dan mereka adalah umat yang terakhir dijadikan dan yang terawal dibangkitkan (pada Hari Kiamat).',
      'Sabda Nabi s.a.w:',
      'فضلت على الأنبياء بست... [رواه مسلم]',
      '"Aku telah diberi kelebihan oleh Allah mengatasi semua nabi dengan enam perkara…". (Hadith Riwayat Muslim).',
      'Sabda Nabi s.a.w. lagi:',
      'أنا سيد ولد آدم يوم القيامة، وبيدي لواء الحمد ولا فخر، وما من نبي يومئذٍ آدم فمن سواه إلا تحت لوائي يوم القيامة [رواه أحمد والترمذي]',
      '"Aku penghulu anak Adam pada Hari Kiamat dan di tanganku bendera kepujian dan aku tidak berasa megah. Tidak terkecuali seorang nabi pun, walaupun Nabi Adam, juga orang lain pada hari itu kecuali semuanya berada di bawah panjiku pada Hari Kiamat". (Hadith Riwayat Ahmad dan At-Tirmizi).',
      'Kedudukan kedua selepas Rasulullah s.a.w dari kalangan "Ulul \'Azmi" ialah Nabi Ibrahim a.s. yang diberi gelaran "Khalil Ar-Rahman" ertinya: kekasih Allah. Rasulullah s.a.w dan Nabi Ibrahim ialah yang paling afdhal di kalangan "Ulul \'Azmi" kemudian diikuti oleh tiga orang Rasul yang seterusnya.',
      'J – MUKJIZAT/TANDA-TANDA KEBENARAN NABI-NABI A.S.',
      'Allah Taala telah menguatkan dakwah para rasul dengan tanda-tanda yang besar dan mukjizat yang nyata sebagai hujjah yang menguatkan atau keperluan yang diperlukan, seperti Al-Quran, terbelahnya bulan, tongkat menjadi ular, menjadikan burung daripada tanah dan sebagainya. Mukjizat yang berlaku dengan cara yang luar biasa itu menjadi dalil terhadap kebenaran dakwaan bahawa mereka adalah nabi yang benar. Karamah pula menjadi dalil kepada kebenaran pengikut nabi yang benar.',
      'Firman Allah Taala: "Demi sesungguhnya! Kami telah mengutuskan rasul-rasul Kami dengan membawa bukti-bukti dan mukjizat yang nyata". (Surah Al-Hadid, Ayat 25).',
      'Sabda Nabi s.a.w:',
      'ما من نبي من الأنبياء إلا وقد أوتي من الآيات ما آمن على مثله البشر، وإنما كان الذي أوتيته وحيًا أوحاه إليّ، فأرجو أن أكون أكثرهم تابعًا يوم القيامة [متفق عليه]',
      '"Tidak ada seorang pun Nabi yang diutuskan di kalangan para nabi kecuali Allah Taala memberikan kepada mereka tanda-tanda (mukjizat) yang akan menjadikan manusia mempercayainya; sesungguhnya yang diberikan kepadaku ialah wahyu yang Allah telah sampaikan kepadaku dan aku berharap akan mendapat pengikut yang paling ramai pada Hari Kiamat kelak". (Muttafaq \'Alaih: Al-Bukhari dan Muslim).',
      'K – BERIMAN DENGAN KENABIAN NABI MUHAMMAD S.A.W',
      'Beriman dengan kenabiannya s.a.w merupakan asas yang utama daripada asas-asas iman, tidak terlaksana iman kecuali dengan beriman kepadanya.',
      'Firman Allah Taala: "Dan (ingatlah bahawa) sesiapa yang tidak beriman kepada Allah dan Rasul-Nya, maka sesungguhnya Kami sediakan bagi orang-orang kafir itu api neraka yang menjulang-julang". (Surah Al-Fath, Ayat 13).',
      'Sabda Nabi s.a.w:',
      'أمرت أن أقاتل الناس حتى يشهدوا أن لا إله إلا الله وأني رسول الله [رواه مسلم]',
      '"Aku diperintahkan untuk memerangi manusia sehingga mereka mengakui bahawa tiada Tuhan yang berhak disembah selain Allah dan aku adalah Rasulullah". (Hadith Riwayat Muslim).',
      'Tidak sempurna beriman dengan Rasulullah s.a.w. kecuali dengan melakukan perkara-perkara berikut:',
      '1. Mengenali Nabi kita Muhammad s.a.w, nama Baginda ialah Muhammad bin Abdullah bin Abdul Muttalib bin Hashim. Hashim dari keturunan Quraish. Quraish dari keturunan Arab. Arab dari keturunan Nabi Ismail bin Ibrahim Al-Khalil, ke atas mereka berdua dan ke atas Nabi kita sebaik-baik selawat dan salam. Nabi s.a.w hidup selama 63 tahun, 40 tahun sebelum dibangkitkan menjadi nabi dan 23 tahun selepas menjadi nabi dan rasul.',
      '2. Membenarkan semua khabar yang dibawanya, melaksanakan semua suruhannya serta menjauhi semua perkara yang dilarang dan ditegahnya, tidak menyembah Allah kecuali dengan menurut ajaran yang disyariatkannya.',
      '3. Beriktikad bahawa Baginda s.a.w telah diutuskan oleh Allah untuk semua jin dan manusia, tidak ada seorang pun dari kalangan mereka yang dikecualikan daripada mengikutinya.',
      'Firman Allah Taala: "Katakanlah (wahai Muhammad): Wahai sekalian manusia! Sesungguhnya aku adalah Pesuruh Allah kepada kamu semua". (Surah Al-A\'raf, Ayat 158).',
      '4. Beriman dengan risalahnya dan Baginda s.a.w adalah nabi yang paling afdhal dan nabi yang terakhir.',
      'Firman Allah Taala: "Tetapi dia adalah Rasulullah dan kesudahan segala nabi-nabi". (Surah Al-Ahzab, Ayat 40).',
      'Baginda adalah "khalil" (kekasih) Tuhan Ar-Rahman, penghulu sekalian anak Adam, Nabi yang diberi kuasa syafaat yang besar (pada Hari Kiamat) yang mempunyai darjat yang tinggi di dalam syurga, Nabi yang mempunyai kolam yang didatangi oleh seluruh umat dan umatnya adalah sebaik-baik umat.',
      'Firman Allah Taala: "Kamu (wahai umat Muhammad s.a.w.) adalah sebaik-baik umat yang dilahirkan bagi (faedah) umat manusia". (Surah Ali \'Imran, Ayat 110).',
      'Penghuni syurga yang paling ramai adalah dari kalangan umatnya, risalah (ajaran)nya memansuhkan semua risalah-risalah yang terdahulu.',
      '5. Allah Taala telah menguatkan risalahnya dengan mukjizat yang besar serta tanda-tanda yang jelas iaitu Al-Quran, kalam Allah yang terpelihara daripada sebarang perubahan dan penyelewengan.',
      'Firman Allah Taala: "Katakanlah (wahai Muhammad): Sesungguhnya jika sekalian manusia dan jin berhimpun dengan tujuan hendak membuat dan mendatangkan sebanding dengan Al-Quran ini, mereka tidak akan dapat membuat dan mendatangkan yang sebanding dengannya, walaupun mereka bantu-membantu sesama sendiri". (Surah Al-Isra\', Ayat 88).',
      'Firman Allah Taala: "Sesungguhnya Kamilah yang menurunkan Al-Quran dan Kamilah yang memelihara dan menjaganya". (Surah Al-Hijr, Ayat 9).',
      '6. Beriman bahawa Rasulullah s.a.w telah menyampaikan risalah, menunaikan amanah dan menasihati ummah, tidak ada suatu kebaikan kecuali ditunjukkan kepada umatnya dan menggalakkan mereka melakukannya, tidak ada suatu kejahatan kecuali ditegah umatnya daripada melakukannya dan menjauhkan mereka daripadanya.',
      'Firman Allah Taala: "Sesungguhnya telah datang kepada kamu seorang Rasul dari golongan kamu sendiri (iaitu Nabi Muhammad s.a.w) yang menjadi sangat berat kepadanya sebarang kesusahan yang ditanggung oleh kamu, yang sangat tamak (inginkan) kebaikan bagi kamu dan dia pula menumpahkan perasaan belas kasihan serta kasih sayangnya kepada orang-orang yang beriman". (Surah At-Taubah, Ayat 128).',
      'Sabda Nabi s.a.w:',
      'ما من نبي بعثه الله في أمة قبلي إلا كان حقًّا عليه أن يدل أمته على خير ما يعلمه لهم، ويحذر أمته من شر ما يعلمه لهم [رواه مسلم]',
      '"Tidak ada seorang Nabi yang diutuskan oleh Allah kepada umat yang terdahulu melainkan menjadi tanggungjawab ke atasnya untuk menunjukkan umatnya ke arah kebaikan yang diberitahu kepada mereka dan memberi amaran kepada umatnya daripada melakukan kejahatan yang telah diberitahu kepada mereka". (Hadith Riwayat Muslim).',
      '7. Cintakan Nabi s.a.w: Mendahulukan mahabbah (cinta dan kasihnya) kepada Rasulullah s.a.w lebih daripada kasihkan dirinya sendiri dan semua makhluk, memuliakannya, menghormati dan mentaatinya, kerana semua ini adalah merupakan hak Nabi ke atas umatnya yang telah diwajibkan oleh Allah di dalam kitab-Nya, kerana cinta dan kasih kepada Nabi s.a.w merupakan cinta dan kasih kepada Allah dan mentaatinya merupakan ketaatan kepada Allah.',
      'Firman Allah Taala: "Katakanlah (wahai Muhammad): Jika benar kamu mengasihi Allah maka ikutilah daku, nescaya Allah mengasihi kamu serta mengampunkan dosa-dosa kamu dan (ingatlah), Allah Maha Pengampun, lagi Maha Mengasihani". (Surah Ali \'Imran, Ayat 31).',
      'Sabda Nabi s.a.w:',
      'لا يؤمن أحدكم حتى أكون أحب إليه من ولده ووالده والناس أجمعين [متفق عليه]',
      '"Tidak sempurna iman seseorang daripada kamu sehingga dia mengasihi diriku lebih daripada dia mengasihi anaknya, bapanya dan manusia seluruhnya". (Muttafaq \'Alaih: Al-Bukhari dan Muslim).',
      '8. Mengucapkan selawat dan salam ke atas Nabi s.a.w serta memperbanyakkannya kerana orang bakhil ialah mereka yang apabila disebut nama Nabi s.a.w dia tidak mengucap salam ke atasnya.',
      'Firman Allah Taala: "Sesungguhnya Allah dan malaikat-Nya berselawat (memberi segala penghormatan dan kebaikan) kepada Nabi (Muhammad s.a.w), wahai orang-orang yang beriman berselawatlah kamu kepadanya serta ucapkanlah salam sejahtera dengan penghormatan yang sepenuhnya". (Surah Al-Ahzab, Ayat 56).',
      'Sabda Nabi s.a.w:',
      'من صلّى عليّ واحدة، صلّى الله عليه بها عشرًا [رواه مسلم]',
      '"Sesiapa yang berselawat ke atasku sekali Allah akan berselawat ke atasnya sepuluh kali". (Hadith Riwayat Muslim).',
      'Selawat sangat dituntut (setengahnya wajib) pada beberapa tempat, antaranya: Dalam tasyahhud ketika solat, qunut, solat jenazah, khutbah Jumaat, selepas azan, ketika memasuki masjid dan ketika keluar daripadanya, ketika berdoa, ketika disebut nama Nabi s.a.w. dan beberapa tempat yang lain.',
      '9. Nabi s.a.w dan semua para nabi a.s. hidup di sisi Tuhan mereka sebagai kehidupan di alam barzakh, lebih sempurna dan lebih tinggi daripada kehidupan para syuhada (orang yang mati syahid), namun kehidupan mereka bukan seperti kehidupan di dunia, ia merupakan suatu kehidupan yang kita tidak mengetahui kaifiat (bentuk)nya, oleh itu perkataan mati (wafat) tetap disandarkan kepada mereka.',
      'Sabda Nabi s.a.w:',
      'إن الله حرم على الأرض أن تأكل أجساد الأنبياء [رواه أبو داود والنسائي]',
      '"Allah Taala mengharamkan ke atas bumi daripada memakan jasad para nabi a.s." (Hadith Riwayat Abu Daud dan An-Nasa\'i).',
      'Sabda Nabi s.a.w. lagi:',
      'ما من مسلم يسلم عليّ إلا رد الله عليّ روحي كي أرد عليه السلام [رواه أبو داود]',
      '"Tidak ada seorang muslim yang mengucap salam ke atasku kecuali Allah Taala mengembalikan roh kepadaku supaya aku menjawab salam". (Hadith Riwayat Abu Daud).',
      '10. Antara tanda menghormati Nabi s.a.w ialah tidak mengangkat suara ketika bersamanya semasa hayatnya, demikian juga ketika memberi salam kepadanya di kuburnya.',
      'Firman Allah Taala: "Wahai orang-orang yang beriman! Janganlah kamu mengangkat suara kamu melebihi suara Nabi dan janganlah kamu menyaringkan suara (dengan lantang) semasa bercakap dengannya sebagaimana sebahagian kamu menyaringkan suaranya semasa bercakap dengan sebahagian yang lain. (Larangan yang demikian) supaya amal-amal kamu tidak terhapus pahalanya, sedang kamu tidak menyedarinya". (Surah Al-Ahzab, Ayat 2).',
      'Kehormatan Baginda s.a.w. selepas wafat sama seperti kehormatan semasa hidupnya, maka kita wajib menghormati Baginda sebagaimana generasi pertama (Sahabat) telah melakukannya – semoga Allah meredhai mereka semua – kerana mereka benar-benar mengikuti semua ajaran Rasulullah s.a.w dan amat jauh daripada menyalahi ajarannya atau mereka-reka ajaran yang tidak ada dalam agama Allah.',
      '11. Mencintai Sahabat-sahabat Nabi r.hum, ahli keluarganya dan isteri-isteri Baginda. Menyokong (mempertahankan) mereka semuanya, berhati-hati daripada memperkecilkan kedudukan mereka, mencela atau membuat tuduhan jahat terhadap mereka, kerana Allah Taala telah meredhai mereka semua dan memilih mereka menjadi Sahabat Nabi s.a.w. dan mewajibkan ke atas umat ini menyokong dan membela mereka.',
      'Firman Allah Taala: "Dan orang-orang yang terdahulu yang mula-mula (berhijrah dan memberi bantuan) dari kalangan orang-orang "Muhajirin" dan "Ansar" dan orang-orang yang menurut (jejak langkah) mereka dengan kebaikan (iman dan taat), Allah redha terhadap mereka dan mereka pula redha terhadap-Nya". (Surah At-Taubah, Ayat 100).',
      'Sabda Nabi s.a.w:',
      'لا تسبوا أصحابي، فوالذي نفسي بيده لو أنفق أحدكم مثل أحد ذهبًا ما بلغ مد أحدهم ولا نصيفه [رواه البخاري]',
      '"Jangan sekali-kali kamu mencela Sahabat-sahabatku, demi Tuhan yang diriku berada di tangan-Nya, walaupun kamu memberi nafkah emas sebesar Bukit Uhud nescaya tidak sama dengan nafkah yang mereka berikan secupak atau setengahnya". (Hadith Riwayat Al-Bukhari).',
      'Allah Taala telah menggalakkan orang-orang yang datang selepas mereka agar beristighfar (meminta ampun) untuk mereka dan memohon daripada Allah agar tidak menjadikan dalam hati mereka perasaan yang tidak baik terhadap orang-orang beriman.',
      'Firman Allah Taala: "Dan orang-orang (Islam) yang datang kemudian daripada mereka (berdoa dengan) berkata: Wahai Tuhan Kami! Ampunkanlah dosa kami dan dosa saudara-saudara kami yang mendahului kami dalam iman dan janganlah Engkau jadikan dalam hati kami perasaan hasad dengki dan dendam terhadap orang-orang yang beriman. Wahai Tuhan kami! Sesungguhnya Engkau Amat Melimpah belas kasihan dan rahmat-Mu". (Surah Al-Hasyr, Ayat 10).',
      '12. Jauhi daripada bersikap melampau ("ghuluw") terhadap Nabi s.a.w, sikap yang sedemikian boleh menyakiti Baginda s.a.w kerana Baginda telah memberi amaran kepada umatnya daripada bersikap melampau terhadapnya dan berlebih-lebihan dalam memuji dan memujanya dengan meletakkan martabatnya lebih tinggi daripada martabat yang Allah Taala berikan kepadanya, martabat yang hanya layak bagi Tuhan Pencipta Azzajawalla.',
      'Sabda Nabi s.a.w:',
      'إنما أنا عبد فقولوا عبد الله ورسوله، لا أحب أن ترفعوني فوق منزلتي',
      '"Sesungguhnya aku adalah seorang hamba, maka ucaplah: Hamba Allah dan rasul-Nya. Aku tidak suka kamu mengangkatku lebih daripada darjat yang Allah berikan kepadaku".',
      'Sabda Nabi s.a.w. lagi:',
      'لا تطروني كما أطرت النصارى ابن مريم [رواه البخاري]',
      '"Jangan kamu bersikap melampaui (memujiku) sebagaimana orang-orang Nasrani melakukannya terhadap \'Isa ibni Maryam". (Hadith Riwayat Al-Bukhari).',
      'Tidak boleh berdoa meminta sesuatu daripada Nabi s.a.w atau memohon bantuan dengannya (selepas Nabi wafat). Tidak boleh melakukan tawaf mengelilingi kuburnya, bernazar atau mengorbankan haiwan untuknya kerana semua perbuatan tersebut membawa kepada syirik (menyengutukan) Allah, sedangkan Allah Taala telah menegah daripada melakukan sebarang ibadat kepada selain daripada-Nya.',
      'Firman Allah Taala: "Katakanlah: Patutkah dengan nama Allah dan ayat-ayat-Nya serta Rasul-Nya kamu memperolok-olok dan mengejeknya? Janganlah kamu berdalih (dengan alasan-alasan yang dusta), kerana sesungguhnya kamu telah kufur sesudah kamu (melahirkan) iman". (Surah At-Taubah, Ayat 66).',
      'Cinta sebenar kepada Rasulullah s.a.w ialah dengan mengikut petunjuk yang dibawanya dan melaksanakan Sunnahnya serta meninggalkan semua perkara yang menyalahi ajarannya s.a.w.',
      'Firman Allah Taala: "Katakanlah (wahai Muhammad): Jika benar kamu mengasihi Allah maka ikutilah daku, nescaya Allah mengasihi kamu serta mengampunkan dosa-dosa kamu dan (ingatlah), Allah Maha Pengampun, lagi Maha Mengasihani". (Surah Ali \'Imran, Ayat 31).',
      'Kita wajib bersifat sederhana dalam menghormati dan memuliakan Rasulullah s.a.w, tidak melampaui batas dan tidak pula merendahkan martabatnya, jangan sekali-kali menjadikannya bersifat dengan sifat-sifat ketuhanan ("uluhiyyah") dan jangan pula mengurangkan haknya dan pangkat ketinggian yang Allah berikan kepadanya, kita wajib mencintai dan mengasihinya dengan mengikuti syariat yang dibawanya dan beramal di atas landasan petunjuknya dan menuruti jejak langkahnya s.a.w.',
      '13. Beriman dengan Nabi s.a.w tidak terlaksana kecuali dengan membenarkannya dan beramal dengan semua ajaran yang dibawanya. Inilah makna taat kepadanya s.a.w, kerana taat kepada perintahnya bererti taat kepada Allah dan menderhakainya bermakna menderhakai Allah Taala. Oleh itu dengan terlaksananya kebenaran dan ketaatan kepadanya maka terlaksanalah iman kepada Baginda s.a.w.',
    ];

    final boldIndices = [
      0,    // A – BERIMAN DENGAN RASUL-RASUL 'Alaihimussalam.
      7,    // B – HAKIKAT KENABIAN (AN-NUBUWWAH)
      12,   // C – HIKMAH DIUTUSKAN RASUL
      14,   // 1. Mengeluarkan hamba-hamba Allah daripada menyembah sesama hamba...
      16,   // 2. Menjelaskan tujuan sebenar Allah s.w.t. menciptakan makhluk...
      18,   // 3. Mendirikan hujjah ke atas manusia dengan mengutuskan rasul-rasul.
      20,   // 4. Menerangkan beberapa perkara ghaib...
      21,   // 5. Semua rasul a.s. merupakan contoh ikutan yang sempurna...
      24,   // 6. Memperbaiki, memurni dan membersihkan nafsu...
      26,   // Sabda Nabi s.a.w:
      29,   // D – TUGAS-TUGAS RASUL
      31,   // 1. Menyampaikan syariat Allah dan menyeru manusia...
      33,   // 2. Menjelaskan kepada manusia semua ajaran agama...
      35,   // 3. Membawa umat ke arah kebaikan dan menjauhkan mereka...
      37,   // 4. Memperbaiki manusia dengan menunjukkan contoh ikutan yang baik...
      38,   // 5. Menegakkan dan melaksanakan syariat Allah di kalangan manusia.
      39,   // 6. Semua rasul akan menjadi saksi ke atas umatnya...
      41,   // E – ISLAM IALAH AGAMA SEMUA NABI
      43,   // Sabda Nabi s.a.w:
      46,   // F – RASUL-RASUL ADALAH MANUSIA BIASA, MEREKA TIDAK MENGETAHUI PERKARA YANG GHAIB
      52,   // G – "'ISMAH" (PEMELIHARAAN) RASUL
      58,   // H – BILANGAN NABI DAN RASUL SERTA YANG PALING UTAMA DI KALANGAN MEREKA
      71,   // Sabda Nabi s.a.w:
      74,   // Sabda Nabi s.a.w. lagi:
      78,   // J – MUKJIZAT/TANDA-TANDA KEBENARAN NABI-NABI A.S.
      81,   // Sabda Nabi s.a.w:
      84,   // K – BERIMAN DENGAN KENABIAN NABI MUHAMMAD S.A.W
      87,   // Sabda Nabi s.a.w:
      91,   // 1. Mengenali Nabi kita Muhammad s.a.w...
      92,   // 2. Membenarkan semua khabar yang dibawanya...
      93,   // 3. Beriktikad bahawa Baginda s.a.w telah diutuskan oleh Allah...
      95,   // 4. Beriman dengan risalahnya dan Baginda s.a.w adalah nabi yang paling afdhal...
      100,  // 5. Allah Taala telah menguatkan risalahnya dengan mukjizat yang besar...
      103,  // 6. Beriman bahawa Rasulullah s.a.w telah menyampaikan risalah...
      105,  // Sabda Nabi s.a.w:
      108,  // 7. Cintakan Nabi s.a.w...
      110,  // Sabda Nabi s.a.w:
      113,  // 8. Mengucapkan selawat dan salam ke atas Nabi s.a.w...
      115,  // Sabda Nabi s.a.w:
      119,  // 9. Nabi s.a.w dan semua para nabi a.s. hidup di sisi Tuhan mereka...
      120,  // Sabda Nabi s.a.w:
      123,  // Sabda Nabi s.a.w. lagi:
      126,  // 10. Antara tanda menghormati Nabi s.a.w...
      129,  // 11. Mencintai Sahabat-sahabat Nabi r.hum...
      131,  // Sabda Nabi s.a.w:
      136,  // 12. Jauhi daripada bersikap melampau ("ghuluw")...
      137,  // Sabda Nabi s.a.w:
      140,  // Sabda Nabi s.a.w. lagi:
      148,  // 13. Beriman dengan Nabi s.a.w tidak terlaksana...
    ];

    final arabicIndices = [
      27,   // إنما بعثت لأتمم مكارم الأخلاق [رواه أحمد والحاكم]
      44,   // الأنبياء إخوة لعلات [رواه البخاري]
      60,   // ثلاثمائة وخمس عشرة جمًّا غفيرًا [رواه الحاكم]
      72,   // فضلت على الأنبياء بست... [رواه مسلم]
      75,   // أنا سيد ولد آدم يوم القيامة، وبيدي لواء الحمد...
      82,   // ما من نبي من الأنبياء إلا وقد أوتي من الآيات...
      88,   // أمرت أن أقاتل الناس حتى يشهدوا أن لا إله إلا الله...
      106,  // ما من نبي بعثه الله في أمة قبلي...
      111,  // لا يؤمن أحدكم حتى أكون أحب إليه من ولده ووالده...
      116,  // من صلّى عليّ واحدة، صلّى الله عليه بها عشرًا [رواه مسلم]
      121,  // إن الله حرم على الأرض أن تأكل أجساد الأنبياء [رواه أبو داود والنسائي]
      124,  // ما من مسلم يسلم عليّ إلا رد الله عليّ روحي...
      132,  // لا تسبوا أصحابي، فوالذي نفسي بيده...
      138,  // إنما أنا عبد فقولوا عبد الله ورسوله...
      141,  // لا تطروني كما أطرت النصارى ابن مريم [رواه البخاري]
    ];

    for (var i = 0; i < content.length; i++) {
      await db.insert('content_blocks', {
        'rukun_iman_id': id,
        'text': content[i],
        'is_bold': boldIndices.contains(i) ? 1 : 0,
        'is_arabic': arabicIndices.contains(i) ? 1 : 0,
        'sort_order': i,
      });
    }

    return id;
  }

  // ============ INSERT RUKUN KELIMA ============

  Future<int> _insertRukunKelima(Database db) async {
    final id = await db.insert('rukun_iman', {
      'title': 'RUKUN KELIMA: BERIMAN KEPADA HARI AKHIRAT',
      'subtitle': 'May 24, 2019',
      'date': '2019-05-24',
      'category': 'kelima',
      'created_at': DateTime.now().toIso8601String(),
    });

    final content = [
      'A – BERIMAN DENGAN HARI AKHIRAT',
      'Iaitu iktikad (percaya) akan berakhirnya kehidupan dunia dan memasuki kehidupan akhirat selepasnya, ianya bermula dengan kematian dan kehidupan di alam barzakh (kubur), diikuti dengan berlakunya kiamat kemudian dibangkitkan semula (seluruh manusia) dan dihimpunkan di Padang Mahsyar, selepas itu mereka akan menerima balasan sama ada ke syurga atau neraka.',
      'Beriman dengan Hari Akhirat merupakan salah satu daripada Rukun Iman. Tidak sempurna iman seseorang kecuali beriman dengannya, sesiapa yang mengingkarinya adalah kafir.',
      'Firman Allah Taala: "Tetapi kebajikan itu ialah berimannya seseorang kepada Allah dan Hari Akhirat". (Surah Al-Baqarah, Ayat 177).',
      'Sabda Nabi s.a.w sebagaimana yang tersebut di dalam hadith Jibrail: Sewaktu Jibrail bertanya kepada Rasulullah s.a.w. tentang iman. Katanya: "Beritahu kepada saya pengertian iman". Sabda Nabi s.a.w.:',
      'أن تؤمن بالله، وملائكته، وكتبه، ورسله، واليوم الآخر، وأن تؤمن بالقدر خيره وشره [رواه مسلم]',
      '"Hendaklah engkau beriman dengan Allah, para malaikat-Nya, kitab-kitab-Nya, rasul-rasul-Nya dan Hari Akhirat serta Qadar (ketetapan) yang baik dan buruk". (Hadith Riwayat Muslim).',
      'Antara perkara yang wajib kita beriman dengannya ialah permulaan (mukaddimah) Hari Akhirat yang telah diberitahu oleh Rasulullah s.a.w iaitu perkara-perkara yang akan berlaku sebagai tanda hampirnya kiamat.',
      'Para ulama\' telah membahagikan tanda-tanda kiamat kepada dua bahagian:',
      '1. Tanda-Tanda Kiamat Yang Kecil',
      'Iaitu tanda yang menunjukkan hampirnya kiamat, tanda-tanda ini sangat banyak, kebanyakannya telah berlaku walaupun tidak kesemuanya, antaranya:',
      'Kebangkitan Nabi Muhammad s.a.w, amanah telah disia-siakan, menghiasi masjid dan berbangga-bangga dengannya, pengembala kambing (orang-orang kampung) mendirikan bangunan yang tinggi, peperangan dengan Yahudi dan orang Islam akan membunuh mereka, masa menjadi singkat, manusia kurang melakukan amal kebajikan, banyak timbulnya fitnah, banyak berlaku pembunuhan, berleluasanya penzinaan dan kefasikan.',
      'Firman Allah Taala: "Telah hampir saat (kedatangan Hari Kiamat) dan terbelahlah bulan". (Surah Al-Qamar, Ayat 1).',
      '2. Tanda-Tanda Kiamat Yang Besar',
      'Iaitu tanda-tanda atau alamat yang akan berlaku apabila hampir kiamat dan peringatan kepada permulaan akan terjadinya kiamat, tanda-tanda tersebut terdapat sebanyak 10 perkara dan belum ada yang terjadi lagi sehingga sekarang. Antara tanda-tanda tersebut ialah:',
      'a) Keluarnya Imam Mahdi.\nb) Munculnya Dajjal.\nc) Turunnya Nabi \'Isa a.s. dari langit dan melaksanakan pemerintahan yang adil, mematahkan salib, membunuh Dajjal dan khinzir, menghapuskan "jizyah" dan melaksanakan syariat Islam.\nd) Keluarnya Ya\'juj dan Ma\'juj dan kemudiannya Nabi \'Isa a.s. berdoa supaya mereka dimatikan.\ne) Berlaku tiga "khusuf" (manusia ditelan bumi): di timur, di barat dan di Semenanjung Tanah Arab.\nf) Keluarnya asap tebal dari langit yang menyelubungi dan menutupi manusia.\ng) Diangkatkan Al-Quran dari bumi ke langit.\nh) Terbitnya matahari dari sebelah barat.\ni) Keluarnya "Dabbah" (binatang besar yang keluar dari Bukit Safa).\nj) Keluarnya api besar dari sebelah \'Adan (Yaman) menghalau manusia menuju ke arah Syam (Syria dan Jordan), inilah alamat besar yang terakhir.',
      'Imam Muslim telah meriwayatkan daripada Huzaifah bin Usaid Al-Ghifari r.a. katanya: Nabi s.a.w datang sedang kami duduk berbincang, maka sabdanya: "Apa yang kamu bincangkan?". Kami menjawab: "Kami berbincang tentang kiamat". Sabda Baginda:',
      'إنها لن تقوم حتى تروا قبلها عشر آيات. فذكر: الدخان، والدجال، والدابة، وطلوع الشمس من مغربها، ونزول عيسى بن مريم، ويأجوج، وثلاثة خسوف: خسف بالمشرق، وخسف بالمغرب، وخسف بجزيرة العرب، وآخر ذلك نار تخرج من اليمن تطرد الناس إلى محشرهم [رواه مسلم]',
      '"Tidak akan berlaku kiamat sehingga kamu melihat sepuluh tanda ini. Maka disebutnya (tanda-tanda itu ialah): Asap, Dajjal, Dabbah (binatang besar), terbit matahari dari sebelah barat, turun Nabi \'Isa a.s., keluar Ya\'juj, berlaku tiga "khusuf" (manusia ditelan bumi): di timur, di barat dan di Semenanjung Tanah Arab dan yang terakhirnya keluar api dari arah Yaman menghalau manusia menuju ke tempat perhimpunan mereka (mahsyar)". (Hadith Riwayat Muslim).',
      'Sabda Nabi s.a.w:',
      'يخرج في آخر أمتي المهدي، يسقيه الله الغيث، وتخرج الأرض نباتها، ويعطي المال صحاحًا، وتكثر الماشية، وتعظم الأمة، يعيش سبعًا أو ثمانيًا يعني حججًا [رواه الحاكم في المستدرك]',
      '"Akan keluar di akhir zaman umatku Al-Mahdi, (di waktu itu) Allah Taala akan menurunkan hujan, maka bumi akan mengeluarkan tanaman, harta menjadi banyak, binatang ternakan membiak, dimuliakan umat ini, beliau hidup selama tujuh atau lapan tahun". (Hadith Riwayat Al-Hakim dalam Al-Mustadrak).',
      'Terdapat riwayat yang menyebut bahawa tanda-tanda ini akan terjadi mengikut turutan satu demi satu, seperti permata yang di cucuk dengan tali, apabila berlaku tanda yang pertama akan diikuti dengan yang kedua dan seterusnya dan apabila semuanya terjadi maka berlakulah kiamat dengan izin Allah Taala.',
      'Maksud Hari Kiamat ialah: Hari yang dikeluarkan manusia dari kubur mereka dengan perintah Allah untuk pembalasan, maka sesiapa yang baik akan mendapat nikmat dan sesiapa yang jahat akan diazab.',
      'Firman Allah Taala: "Pada hari mereka segera keluar dari kubur masing-masing menuju (ke Padang Mahsyar) dengan keadaan seolah-olah mereka berkejaran ke (tempat) berhala-berhala (yang mereka sembah dahulu)". (Surah Al-Ma\'arij, Ayat 43).',
      'Hari Kiamat disebut dengan pelbagai nama dalam Al-Quran, antaranya: Hari Kiamat, Al-Qari\'ah (hari yang menggemparkan), Hari Perhitungan, Hari Pembalasan, At-Tommah (hari bencana), Al-Waqi\'ah (kiamat), Al-Haqqah (saat yang tetap berlaku), As-Sokkhah (suara jeritan yang dahsyat), Al-Ghasyiah (huru-hara yang meliputi) dan lainnya.',
      'Dalil daripada Al-Quran berkenaan dengan nama-nama tersebut:',
      'a) Hari Kiamat. Firman Allah Taala: "Aku bersumpah dengan Hari Kiamat". (Surah Al-Qiyamah, Ayat 1).',
      'b) Al-Qari\'ah (hari yang menggemparkan). Firman Allah Taala: "Hari yang menggemparkan, Apa dia hari yang menggemparkan itu?". (Surah Al-Qari\'ah, Ayat 1-2).',
      'c) Hari Perhitungan. Firman Allah Taala: "Sesungguhnya orang-orang yang sesat dari jalan Allah, akan beroleh azab yang berat pada hari hitungan amal, disebabkan mereka melupakan (jalan Allah) itu". (Surah Sad, Ayat 26).',
      'd) Pembalasan. Firman Allah Taala: "Dan sesungguhnya orang-orang yang bersalah, ditempatkan di dalam neraka yang menjulang-julang. Mereka menderita dengan bakaran neraka itu pada hari pembalasan". (Surah Al-Infitar, Ayat 14-15).',
      'e) At-Tommah (Hari Bencana). Firman Allah Taala: "Maka apabila datang hari yang bencananya amat besar". (Surah An-Nazi\'at, Ayat 34).',
      'f) Al-Waqi\'ah (Kiamat). Firman Allah Taala: "Apabila berlaku Hari Kiamat itu". (Surah Al-Waqi\'ah, Ayat 1).',
      'g) Al-Haqqah (Saat yang tetap berlaku). Firman Allah Taala: "Saat yang tetap berlaku itu. Apakah ia sifat dan keadaan saat yang tetap berlaku itu?". (Surah Al-Haqqah, Ayat 1-2).',
      'h) As-Sokkhah (suara jeritan yang dahsyat). Firman Allah Taala: "Kemudian (ingatlah keadaan yang berlaku) apabila datang suara jeritan yang dahsyat". (Surah \'Abasa, Ayat 33).',
      'j) Al-Ghasyiah (huru-hara yang meliputi). Firman Allah Taala: "Sudahkah sampai kepadamu (wahai Muhammad) perihal Hari Kiamat yang huru-haranya meliputi?". (Surah Al-Ghasyiah, Ayat 1).',
      'B – SIFAT BERIMAN DENGAN HARI KIAMAT',
      'Beriman dengan Hari Akhirat secara umum dan terperinci.',
      'Secara umum: Iaitu kita beriman bahawa di sana ada hari yang Allah himpunkan pada hari tersebut orang-orang yang terdahulu dan orang-orang yang terkemudian, lalu Allah membalas setiap orang mengikut amalan yang dilakukannya, sebahagiannya ke syurga dan sebahagian lagi ke neraka.',
      'Firman Allah Taala: "Katakanlah (kepada mereka): Sesungguhnya orang-orang yang telah lalu dan orang-orang yang terkemudian tetap akan dihimpunkan pada masa yang ditentukan pada Hari Kiamat yang termaklum". (Surah Al-Waqi\'ah, Ayat 49-50).',
      'Secara terperinci: iaitu beriman dengan semua perkara yang berlaku selepas mati, ia merangkumi beberapa perkara, antaranya:',
      '1. Fitnah Kubur',
      'Iaitu mayat akan disoal selepas dikebumikan tentang Tuhannya, agamanya dan Nabinya Muhammad s.a.w. Maka Allah Taala menetapkan orang-orang yang beriman dengan jawapan yang teguh, sebagaimana yang telah disebutkan di dalam hadith, ketika orang yang beriman disoal mereka akan menjawab:',
      'ربي الله، وديني الإسلام، ونبي محمد صلى الله عليه وسلم [متفق عليه]',
      '"Tuhanku ialah Allah, agamaku Islam dan nabiku Muhammad s.a.w". (Hadith Muttafaq \'Alaih).',
      'Maka kita wajib beriman dengan semua perkara yang telah disebut di dalam hadith, antaranya soalan dari Munkar dan Nakir, cara-cara mereka menyoal dan jawapan daripada orang-orang mukmin serta jawapan daripada orang-orang munafik dan kafir.',
      '2. Azab Kubur Dan Nikmatnya',
      'Wajib beriman dengan azab kubur dan nikmatnya, sama ada kubur itu merupakan satu lubang dari lubang-lubang neraka atau satu taman dari taman-taman syurga. Kubur merupakan perhentian pertama daripada beberapa perhentian akhirat, sesiapa yang selamat daripada azab kubur maka perhentian yang berikutnya akan menjadi lebih mudah baginya dan sesiapa yang tidak terselamat daripada azabnya maka yang seterusnya lebih dahsyat lagi. Sesiapa yang mati bererti bermulalah kiamatnya.',
      'Nikmat dan azab akan menimpa roh dan jasad di dalam kubur, adakalanya akan menimpa roh sahaja. Azabnya akan menimpa ke atas orang-orang yang zalim dan nikmatnya untuk orang-orang yang beriman lagi benar.',
      'Mayat akan tetap diazab atau dikurniakan nikmat di alam barzakh, tidak kira sama ada ianya dikebumikan di dalam kubur atau pun tidak, sekalipun dibakar, tenggelam dalam air, dimakan binatang buas atau burung pasti ia akan mendapat balasan seksa atau nikmat.',
      'Firman Allah Taala berkenaan dengan azab kubur: "Mereka didedahkan kepada bahang api neraka pada waktu pagi dan petang (semasa mereka berada dalam alam barzakh) dan pada hari berlakunya kiamat (diperintahkan kepada malaikat): Masukkanlah Firaun dan pengikut-pengikutnya ke dalam azab seksa api neraka yang seberat-beratnya". (Surah Ghafir, Ayat 46).',
      'Sabda Nabi s.a.w:',
      'فلو لا أن لا تدافنوا لدعوت الله أن يسمعكم من عذاب القبر [رواه مسلم]',
      '"Kalau sekiranya aku tidak takut kamu tidak dapat mengebumikan mayat ke dalam kubur, nescaya aku berdoa agar Allah memperdengarkan kepada kamu seksaan yang berlaku di dalam kubur". (Hadith Riwayat Muslim).',
      '3. Tiupan Sangkakala',
      'Sangkakala iaitu serunai daripada tanduk yang ditiup oleh Israfil a.s., tiupan yang pertama akan mematikan semua makhluk kecuali mereka yang dikehendaki oleh Allah, kemudian ditiup tiupan kedua maka dibangkitkan semua makhluk yang wujud semenjak Allah jadikan dunia ini sehingga berlakunya kiamat.',
      'Firman Allah Taala: "Dan sudah tentu akan ditiup sangkakala, maka pada waktu itu matilah makhluk-makhluk yang ada di langit dan yang ada di bumi, kecuali sesiapa yang dikehendaki Allah (terkemudian matinya), kemudian ditiup sangkakala sekali lagi, maka dengan serta-merta mereka bangun berdiri menunggu (kesudahan masing-masing)". (Surah Az-Zumar, Ayat 68).',
      'Sabda Nabi s.a.w:',
      'ثم ينفخ في الصور فلا يسمعه أحد إلا أصغى ليتًا ورفع ليتًا، ثم لا يبقى أحد إلا صعق، ثم ينزل الله مطرًا كأنه الطل، فتنبت منه أجساد الناس، ثم ينفخ فيه أخرى فإذا هم قيام ينظرون [رواه مسلم]',
      '"Kemudian ditiupkan sangkakala, tidak ada seorang pun yang mendengarnya kecuali mengangkat leher (untuk mendengarnya), kemudian tidak tinggal seorang pun kecuali semuanya mati, selepas itu Allah menurunkan hujan renyai-renyai yang menumbuhkan jasad manusia, kemudian ditiupkan sangkakala kali kedua. Apabila ditiup sangkakala kali kedua semua mereka bangkit menunggu kesudahan masing-masing". (Hadith Riwayat Muslim).',
      '4. Kebangkitan',
      'Iaitu Allah Taala menghidupkan orang-orang yang telah mati ketika ditiupkan sangkakala kali kedua, maka bangkitlah semua manusia menemui Tuhan sekalian alam.',
      'Apabila Allah Taala mengizinkan Israfil a.s. meniup sangkakala dan semua roh kembali kepada jasad masing-masing ketika itu bangkitlah manusia dari kubur mereka, dengan cepat berjalan menuju ke "mauqif" (tempat berhimpun untuk perhitungan) dalam keadaan berkaki ayam (tidak berkasut), telanjang bulat (tidak berpakaian), tidak berkhatan, tiada apa pun bersama mereka. Begitu panjang masa mereka berada di "mauqif" (tempat berhimpun), pada waktu itu matahari sangat hampir dengan mereka yang menyebabkan kepanasan yang amat sangat, mereka pula dibasahi dengan peluh kerana terlalu susah keadaannya, ada yang peluhnya sampai ke buku lali, ada yang sampai ke lutut, pinggang, dada, bahu dan ada yang tenggelam di dalam peluh, semuanya mengikut kadar amalan masing-masing.',
      'Kebangkitan semula selepas mati adalah suatu perkara yang sabit sebagaimana yang telah dijelaskan oleh syara\', realiti keadaan dan akal pemikiran.',
      'i- Penjelasan daripada syara\'.',
      'Banyak sekali ayat-ayat Al-Quran dan nas-nas yang sahih daripada hadith Rasulullah s.a.w. yang menjelaskannya.',
      'Firman Allah Taala: "Katakanlah: Bahkan, demi Tuhanku, kamu akan dibangkitkan". (Surah At-Taghabun, Ayat 7).',
      'Firman Allah Taala: "Sebagaimana Kami mulakan wujudnya sesuatu kejadian, Kami ulangi kewujudannya lagi". (Surah Al-Anbiya\', Ayat 104).',
      'Sabda Nabi s.a.w:',
      'ثم ينفخ في الصور فلا يسمعه أحد إلا أصغى ليتًا ورفع ليتًا، ثم لا يبقى أحد إلا صعق، ثم ينزل الله مطرًا كأنه الطل، فتنبت أجساد الناس، ثم ينفخ فيه أخرى فإذا هم قيام ينظرون [رواه مسلم]',
      '"Kemudian ditiupkan sangkakala, tidak ada seorang pun yang mendengarnya kecuali mengangkat leher (untuk mendengarnya), kemudian tidak tinggal seorang pun kecuali semuanya mati, selepas itu Allah menurunkan hujan renyai-renyai yang menumbuhkan jasad manusia, kemudian ditiupkan sangkakala kali kedua. Apabila ditiup sangkakala kali kedua semua mereka bangkit menunggu kesudahan masing-masing". (Hadith Riwayat Muslim).',
      'Firman Allah Taala: "(Kami menciptakannya) sambil dia bertanya: \'Siapakah yang dapat menghidupkan tulang-tulang yang telah hancur seperti debu?\'. Katakanlah: \'Tulang-tulang yang hancur itu akan dihidupkan oleh Tuhan yang telah menciptakannya pada awal mula wujudnya dan Dia Maha Mengetahui akan segala keadaan makhluk-makhluk (yang diciptakan-Nya)\'". (Surah Yasin, Ayat 78-79).',
      'ii- Realiti keadaan yang telah berlaku.',
      'Allah Taala telah memperlihatkan kepada hambanya peristiwa menghidupkan semula orang yang mati semasa di dunia. Di dalam Surah Al-Baqarah terdapat lima contoh tersebut, iaitu: Kaum Nabi Musa a.s., Allah menghidupkan mereka selepas mematikannya [ayat: 56] dan orang yang dibunuh oleh Bani Israel (dihidupkan semula untuk memberitahu siapa pembunuhnya) [ayat: 73] juga kaum yang keluar dari kampung mereka kerana takutkan mati (Allah matikan mereka semua kemudian menghidupkannya semula) [ayat: 243] dan orang yang melalui sebuah kampung yang telah binasa (beliau berkata: "Bagaimana Allah akan membina semula negeri ini?" lalu Allah mematikannya selama 100 tahun, kemudian Allah menghidupkannya semula, sebagai bukti kepada dirinya bahawa Allah berkuasa menghidup dan mematikan) [ayat: 259] dan kisah empat ekor burung yang dicincang oleh Nabi Ibrahim a.s. kemudian dihidupkan semula [ayat: 260].',
      'iii- Dalil akal',
      'Dalil akal boleh diambil dari dua aspek berikut:\n– Bahawa Allah Taala telah menciptakan langit, bumi dan semua isi kandungan keduanya dengan tidak ada contoh. Allah yang berkuasa menciptanya buat pertama kali tentu tidak lemah untuk mengulanginya sekali lagi.\n– Bumi yang telah mati (kering) tidak ada tumbuh-tumbuhan, Allah Taala menurunkan ke atasnya hujan, maka ia bergerak menumbuhkan tumbuhan yang indah. Maka Allah yang berkuasa menghidupkannya selepas mati, berkuasa pula menghidupkan manusia yang telah mati.',
      '5. Perhimpunan, Perhitungan Dan Pembalasan',
      'Kita beriman bahawa semua jasad akan dihimpunkan, disoal dan akan diadili di antara mereka lalu semuanya akan dibalas dengan amalan yang telah mereka lakukan.',
      'Firman Allah Taala: "Dan Kami himpunkan mereka (di Padang Mahsyar) sehingga Kami tidak akan tinggalkan seorang pun daripada mereka". (Surah Al-Kahf, Ayat 47).',
      'Firman Allah Taala: "Maka sesiapa yang diberikan kitab amalnya dan menerima dengan tangan kanannya, maka dia akan berkata (dengan sukacitanya kepada sesiapa yang ada di sisinya): Nah! Bacalah kamu kitab amalanku ini! Sesungguhnya aku telah mengetahui dengan yakin, bahawa aku akan menghadapi hitungan amalanku (pada hari yang ditentukan)! Maka (dengan itu) tinggallah dia dalam kehidupan yang senang-lenang lagi memuaskan". (Surah Al-Haqqah, Ayat 19-21).',
      'Firman Allah Taala: "Adapun orang yang diberikan Kitab amalnya dan menerima dengan tangan kirinya, maka dia akan berkata (dengan sesalnya): Alangkah baiknya kalau aku tidak diberikan kitab amalku dan aku tidak mengetahui hitungan amalku". (Surah Al-Haqqah, Ayat 25-26).',
      '"Hasyru": Perhimpunan, dihalau manusia dan dihimpunkannya di suatu tempat perhentian untuk dijalankan hisab amalan mereka. Perbezaan antara kebangkitan dan perhimpunan ialah "Al-Ba\'thu" kebangkitan iaitu dikembalikan roh ke dalam jasad manakala "Al-Hasyru" dihimpunkan manusia yang telah dibangkitkan di suatu tempat.',
      'Hisab dan pembalasan: Iaitu Allah Taala menghimpunkan hamba-hamba-Nya di hadapan-Nya dan memperlihatkan kepada mereka semua amalan yang telah mereka kerjakan.',
      'Orang-orang mukmin yang bertaqwa, kiraan amalan mereka dilakukan dengan cara dibentangkan ke atas mereka amalan yang mereka kerjakan sehingga mereka mengetahui nikmat kurniaan Allah ke atas mereka yang telah menutupi kesalahan mereka di dunia dan mengurniakan keampunan-Nya di akhirat. Mereka akan dihimpunkan mengikut peringkat keimanan mereka. Para malaikat menyambut mereka dengan menyampaikan khabar gembira tentang balasan syurga dan memberitahu bahawa mereka berada dalam keadaan aman daripada segala ketakutan dan kesusahan hari yang penuh dengan huru-hara. Maka ketika itu bercahayalah wajah-wajah mereka. Muka orang-orang yang beriman pada hari itu berseri-seri. Mereka bergelak ketawa lagi bersukaria.',
      'Sebaliknya orang-orang yang mendustakan Hari Akhirat akan dihisab dengan perhitungan yang sangat susah lagi penuh teliti tentang setiap kerja yang mereka lakukan sama ada kecil ataupun besar, mereka ditarik dengan keadaan muka mereka tersembam ke bumi dan dengan penuh penghinaan sebagai balasan kepada dosa yang telah mereka lakukan dan pendustaan yang mereka timbulkan.',
      'Golongan yang paling awal dihisab pada Hari Kiamat ialah umat Nabi Muhammad s.a.w, dari kalangan mereka 70 ribu orang yang dapat masuk syurga tanpa dihisab dan tidak merasai azab kerana kesempurnaan tauhid mereka, mereka ialah golongan yang telah disifatkan oleh Rasulullah s.a.w dengan sabdanya:',
      'لا يسترقون، ولا يكتوون، ولا يتطيرون، وعلى ربهم يتوكلون',
      '"Mereka tidak minta dijampi, tidak minta diubati dengan api, tidak menjadikan sesuatu sebagai sialan dan kepada Tuhan mereka bertawakkal".',
      'Antara mereka itu ialah Sahabat Nabi yang mulia \'Ukasyah atau \'Ukkasyah bin Mihsan r.a.',
      'Perkara pertama yang dihisab ke atas seorang hamba terhadap hak-hak Allah Taala ialah solat dan terhadap hak sesama manusia ialah darah (pembunuhan).',
      '6. Beriman Dengan Kolam Nabi s.a.w',
      'Iaitu sebuah kolam yang besar dan tempat minum yang mulia, mengalir daripada minuman syurga dan dari sungai Kauthar pada Hari Kiamat, ianya didatangi oleh orang-orang mukmin daripada umat Nabi Muhammad s.a.w.',
      'Antara sifatnya: Lebih putih daripada susu, lebih sejuk daripada salji, lebih manis daripada madu, lebih harum daripada kasturi, sangat luas ukurannya, lebar dan panjangnya sama, jarak di antara dua penjurunya sebulan perjalanan, mempunyai dua saluran air yang mengalir dari syurga, bekas minumnya (gelas) lebih banyak daripada bintang di langit, sesiapa yang meminumnya sekali tidak akan terasa dahaga selamanya.',
      'Sabda Nabi s.a.w:',
      'حوضي مسيرة شهر، ماؤه أبيض من اللبن، وريحه أطيب من المسك، وكيزانه كنجوم السماء، من شرب منه فلا يظمأ أبدًا [رواه البخاري]',
      '"Kolamku luasnya sebulan perjalanan, airnya lebih putih daripada susu, baunya lebih harum daripada kasturi, bekas minumnya seperti bintang di langit, sesiapa yang meminumnya tidak akan terasa dahaga selama-lamanya". (Hadith Riwayat Al-Bukhari).',
      '7. Syafaat',
      'Ketika manusia berada dalam keadaan bala dan ujian yang semakin perit di perhentian yang besar pada Hari Kiamat serta begitu panjang pula masanya, mereka mula berusaha mencari orang yang dapat memberikan syafaat dan pertolongan supaya memohon agar Allah melepaskan mereka daripada kesusahan padang mahsyar.',
      '"Ulul \'Azmi" dari kalangan rasul menguzurkan diri tidak dapat membantu menyelesaikan masalah mereka sehinggalah sampai kepada penutup sekalian rasul, Nabi kita Muhammad s.a.w yang telah diampunkan oleh Allah segala kesalahan yang terdahulu dan yang terkemudian, maka Nabi s.a.w pun bangun mengambil tempat yang dipuji oleh semua umat yang terdahulu dan yang terkemudian, maka zahirlah kedudukannya yang mulia dan darjatnya yang tinggi dengan peranannya itu, Rasulullah s.a.w pun sujud di bawah Arasy, Allah Taala telah mengilhamkan kepadanya dengan pujian, Rasulullah s.a.w pun memuji dan memuja-Nya dan memohon keizinan daripada Tuhannya agar membenarkannya memberi syafaat (pertolongan) kepada semua makhluk untuk menyelesaikan masalah mereka setelah mereka ditimpa kesusahan dan bencana yang besar yang mereka tidak mampu menanggungnya.',
      'Sabda Nabi s.a.w:',
      'إن الشمس تدنو يوم القيامة حتى يبلغ العرق نصف الأذن، فبينما هم كذلك، استغاثوا بآدم ثم بإبراهيم ثم بموسى ثم بعيسى ثم بمحمد، فيشفع ليقضى بين الخلق، فيمشي حتى يأخذ بحلقة الباب، فيومئذ يبعثه الله مقامًا محمودًا يحمده أهل الجمع كلهم [رواه البخاري]',
      '"Sesungguhnya matahari begitu hampir dengan manusia pada Hari Kiamat sehinggakan peluh mereka sampai ke pertengahan telinga, sedang mereka berada dalam keadaan tersebut lantas mereka memohon bantuan dengan Adam a.s kemudian Ibrahim a.s kemudian Musa a.s kemudian \'Isa a.s kemudian Muhammad s.a.w. Apabila sampai kepada Nabi Muhammad s.a.w, Baginda meminta kuasa syafaat untuk menyelesaikan masalah umat manusia, Baginda berjalan sehingga kepada pemegang pintu syurga, pada hari itu Allah Taala telah memberikannya kuasa syafaat yang agung yang dipuji oleh semua orang yang berada di Padang Mahsyar". (Hadith Riwayat Al-Bukhari).',
      'Kuasa syafaat yang agung ini Allah Taala khususkan kepada Rasulullah s.a.w dan telah sabit juga Rasulullah s.a.w mempunyai syafaat yang lain, iaitu:',
      'i- Syafaat Rasulullah s.a.w untuk ahli syurga agar dapat memasuki syurga. Dalilnya, sabda Nabi s.a.w:',
      'آتي باب الجنة يوم القيامة فأستفتح، فيقول الخازن من أنت؟ قال فأقول محمد، يقول بك أمرت لا أفتح لأحد قبلك [رواه مسلم]',
      '"Pada Hari Kiamat aku pergi ke pintu syurga dan aku meminta supaya ianya dibuka. Kata Khazin (penjaga syurga): \'Siapakah kamu?\'. Sabda Nabi s.a.w: \'Aku menjawab: Muhammad\'. Kata penjaga syurga: \'Aku diarahkan agar membuka pintu syurga dengan permintaan engkau dan tidak membukanya kepada orang lain sebelum engkau\'". (Hadith Riwayat Muslim).',
      'ii- Syafaatnya untuk kaum yang sama timbangan amalan baik dan jahat, maka diberi syafaat agar mereka dapat masuk syurga. Pendapat ini dibawa oleh setengah ulama\' namun tidak ada hadith yang sahih atau selain daripadanya yang boleh dibuat dalil.',
      'iii- Syafaatnya untuk kaum yang telah ditentukan neraka agar selamat daripadanya. Berdasarkan dalilnya yang umum, sabda Nabi s.a.w:',
      'شفاعتي لأهل الكبائر من أمتي [رواه أبو داود]',
      '"Syafaatku untuk orang-orang yang melakukan dosa besar daripada umatku". (Hadith Riwayat Abu Daud).',
      'iv- Syafaatnya untuk mengangkat darjat ahli syurga di dalam syurga. Dalilnya, sabda Nabi s.a.w:',
      'اللهم اغفر لأبي سلمة وارفع درجته في المهديين [رواه مسلم]',
      '"Ya Allah, ampunilah Abi Salamah (Abdullah bin Abdul Asad) dan angkatlah darjatnya di kalangan orang-orang yang diberi hidayat". (Hadith Riwayat Muslim).',
      'v- Syafaatnya kepada beberapa kaum yang dapat memasuki syurga tanpa dihisab dan tidak merasai azab. Dalilnya, hadith \'Ukasyah atau \'Ukkasyah bin Mihsan yang menyebut 70 ribu orang memasuki syurga dengan tidak melalui hisab dan tidak diazab, maka Rasulullah s.a.w berdoa untuknya dengan sabdanya:',
      'اللهم اجعله منهم [متفق عليه]',
      '"Ya Allah, jadikanlah dia (\'Ukasyah) daripada golongan mereka itu". (Hadith Muttafaq \'Alaih).',
      'vi- Syafaatnya kepada orang yang melakukan dosa besar daripada umatnya yang telah berada di dalam neraka agar keluar daripadanya. Dalilnya, sabda Nabi s.a.w:',
      'شفاعتي لأهل الكبائر من أمتي [رواه أبو داود]',
      '"Syafaatku untuk orang-orang yang melakukan dosa besar daripada umatku". (Hadith Riwayat Abu Daud).',
      'Sabda Nabi s.a.w. lagi:',
      'يخرج قوم من النار بشفاعة محمد فيدخلون الجنة يسمون الجهنميين [رواه البخاري]',
      '"Akan keluar satu kaum daripada api neraka dengan syafaat Muhammad s.a.w kemudian memasuki syurga, mereka dinamakan "Jahannamiyyin" (bekas ahli neraka)". (Hadith Riwayat Al-Bukhari).',
      'vii- Syafaatnya untuk meringankan azab daripada mereka yang dikenakan azab, seperti syafaatnya kepada bapa saudaranya Abu Talib. Dalilnya, sabda Nabi s.a.w:',
      'لعله تنفعه شفاعتي يوم القيامة فيجعل في ضحضاح من النار يبلغ كعبيه يغلي منه دماغه [متفق عليه]',
      '"Mudah-mudahan syafaatku akan memberi manfaat kepadanya pada Hari Kiamat, dia berada di dalam air neraka yang cetek, mencecah dua buku lalinya yang menggelegakkan otaknya". (Hadith Muttafaq \'Alaih).',
      'Tidak sah syafaat di sisi Allah Taala kecuali dengan memenuhi dua syarat:\n– Allah meredhai orang yang memberi syafaat dan orang yang menerimanya.\n– Allah Taala memberi keizinan kepada pemberi syafaat agar melakukannya.',
      'Firman Allah Taala: "Dan mereka tidak memohon syafaat melainkan bagi sesiapa yang diredhai Allah". (Surah Al-Anbiya\', Ayat 28).',
      'Firman Allah Taala: "Tiada sesiapa yang dapat memberi syafaat (pertolongan) di sisi-Nya melainkan dengan izin-Nya". (Surah Al-Baqarah, Ayat 255).',
      '8. Neraca Timbangan Amalan',
      'Neraca timbangan adalah suatu yang hak, wajib beriman dengannya. Iaitu suatu neraca yang Allah Taala dirikan pada Hari Kiamat untuk menimbang amalan hamba-hamba-Nya dan membalasnya menurut amalan mereka. Neraca yang didirikan itu mempunyai dua daun neraca dan jarum, bagi menimbang amalan atau surat catatan amalan atau orang yang melakukan amalan itu sendiri, maka semuanya akan ditimbang tetapi yang diambil kira ialah berat atau ringan amalan bukan tuannya atau surat catatan amalan.',
      'Firman Allah Taala: "Dan (ingatlah) Kami akan mengadakan neraca timbangan yang adil untuk (menimbang amal makhluk-makhluk pada) Hari Kiamat, maka tidak ada diri sesiapa akan teraniaya sedikitpun dan jika (amalnya) itu seberat biji sawi (sekalipun), nescaya Kami akan mendatangkannya (untuk ditimbang dan dihitung) dan cukuplah Kami sebagai Penghitung". (Surah Al-Anbiya\', Ayat 47).',
      'Firman Allah Taala: "Dan timbangan amal pada hari itu adalah benar, maka sesiapa yang berat timbangan amalnya (yang baik), maka mereka itulah orang-orang yang berjaya. Dan sesiapa yang ringan timbangan amalnya (yang baik), maka mereka itulah orang-orang yang merugikan dirinya sendiri, dengan sebab mereka berlaku zalim terhadap ayat-ayat Kami (dengan meletakkannya pada bukan tempatnya)". (Surah Al-A\'raf, Ayat 8-9).',
      'Sabda Nabi s.a.w:',
      'الطهور شطر الإيمان، والحمد لله تملأ الميزان [رواه مسلم]',
      '"Suci daripada hadath itu sebahagian daripada iman dan "Alhamdulillah" itu memenuhi neraca timbangan". (Hadith Riwayat Muslim).',
      'Sabda Nabi s.a.w. lagi:',
      'يوضع الميزان يوم القيامة فلو وزن فيه السماوات والأرض لوسعت [رواه الحاكم]',
      '"Didirikan neraca timbangan pada Hari Kiamat, kalau ditimbang langit dan bumi di dalamnya, lebih daripada mencukupi". (Hadith Riwayat Al-Hakim).',
      '9. Titian Sirat Al-Mustaqim',
      'Kita beriman dengan "Sirat Al-Mustaqim" iaitu titian yang dibentangkan di atas Neraka Jahannam, suatu laluan yang sungguh menggerunkan dan menakutkan, manusia melaluinya untuk sampai ke syurga, ada di antara mereka yang melintasinya dengan sekelip mata, ada yang melaluinya seperti kilat, ada yang melaluinya seperti angin, ada yang melaluinya seperti burung terbang, ada yang melaluinya seperti kuda yang berlari pantas, ada yang melaluinya seperti orang berlari anak, ada yang melaluinya dengan berjalan, ada yang melaluinya dengan merangkak, semuanya mengikut kadar amalan yang dilakukan, sehinggakan dapat melaluinya orang yang mempunyai cahaya di atas ibu jari kakinya, ada yang jatuh ditarik ke dalam neraka dan orang yang melepasinya akan masuk ke syurga.',
      'Orang pertama yang akan melintasinya ialah Nabi kita Muhammad s.a.w kemudian diikuti pula oleh umatnya, tidak ada orang yang bercakap pada hari itu kecuali para rasul a.s., doa para rasul pada hari itu ialah: "اللهم سلِّم سلِّم" - "Ya Allah, selamatkan kami! Selamatkan kami!". Dalam Neraka Jahannam ada pencakuk yang terletak di tepi neraka yang tidak diketahui bilangannya kecuali Allah Taala, ia akan mencakuk sesiapa sahaja yang Allah kehendaki daripada makhluk-Nya.',
      'Antara sifat Titian Sirat Al-Mustaqim: Lebih tajam daripada pedang, lebih halus daripada rambut, sangat licin, tidak ada kaki yang boleh tetap di atasnya kecuali orang yang ditetapkan kakinya oleh Allah, dibentangkannya di atas neraka di dalam suasana kegelapan, dihantar "amanah" dan "rahim" lalu berdiri keduanya di tepi Titian Sirat untuk menjadi saksi kepada mereka yang menjaga amanah dan hubungan silaturrahim atau kepada mereka yang mensia-siakan kedua-duanya.',
      'Firman Allah Taala: "Dan tiada seorangpun di antara kamu melainkan akan sampai kepadanya, (yang demikian) adalah satu perkara yang mesti (berlaku) yang telah ditetapkan oleh Tuhanmu. Kemudian Kami akan selamatkan orang-orang yang bertaqwa dan kami akan biarkan orang-orang yang zalim (dengan kekufurannya dan maksiatnya) tinggal berlutut di dalam neraka itu". (Surah Maryam, Ayat 71-72).',
      'Sabda Nabi s.a.w:',
      'ويضرب الصراط بين ظهراني جهنم فأكون أنا وأمتي أول من يجيزه [رواه مسلم]',
      '"Diletakkan Sirat di atas dua tebing Neraka Jahannam, aku dan umatku ialah golongan yang pertama melintasinya". (Hadith Riwayat Muslim).',
      'Sabda Nabi s.a.w. lagi:',
      'ويضرب جسر جهنم فأكون أول من يجيز، ودعاء الرسل يومئذ: اللهم سلِّم سلِّم [متفق عليه]',
      '"Diletakkan titian atas Neraka Jahannam, aku adalah orang pertama yang melintasinya. Doa para rasul pada hari itu ialah: Ya Allah, selamatkan kami! Selamatkan kami!". (Hadith Riwayat Al-Bukhari dan Muslim).',
      'Kata Abu Sa\'id Al-Khudri r.a.:',
      'بلغني أن الجسر أدق من الشعر وأحد من السيف [رواه مسلم]',
      '"Telah disampaikan kepadaku bahawa Titian Sirat itu lebih halus daripada rambut dan lebih tajam daripada pedang". (Hadith Riwayat Muslim).',
      'Sabda Nabi s.a.w:',
      'وترسل الأمانة والرحم، فتقومان على جنبي الصراط يمينًا وشمالًا، فيمر أولكم كالبرق... ثم كمر الريح، ثم كمر الطير وشد الرجال، تجري بهم أعمالهم، ونبيكم قائم على الصراط يقول: رب سلم سلم، حتى تعجز أعمال العباد، حتى يجيء الرجل فلا يستطيع السير إلا زحفًا. وعلى حافتي الصراط كلاليب معلقة مأمورة بأخذ من أمرت به، فمخدوش ناجٍ، ومكدوس في النار [رواه مسلم]',
      '"Dihantar "amanah" dan "rahim", kedua-duanya berdiri di tepi titian kiri dan kanan. Orang yang pertama melaluinya seperti kilat…kemudian seperti angin, kemudian seperti burung dan seperti orang yang berjalan dengan cepat. Setiap orang akan melaluinya mengikut amalannya, sedangkan pada waktu itu Nabi kamu s.a.w berdiri di atas titian dan berdoa: \'Ya Allah, selamatkan! Selamatkan!\'. Apabila lemah amalan seseorang hamba itu sehingga tidak mampu untuk berjalan mereka akan merangkak. Di kedua-dua tepi titian digantung pengait dan pencakuk yang telah diarahkan agar menarik sesiapa yang dikehendaki-Nya. Ada orang yang luka terkena pencakuk tetapi terselamat dari terjatuh ke dalamnya. Dan ada pula orang yang dikait dan dicangkuk serta dihumban terus ke dalam neraka". (Hadith Riwayat Muslim).',
      '10. "Qantarah" Perhentian Di Antara Syurga Dan Neraka',
      'Kita beriman bahawa orang-orang mukmin apabila telah selamat melintasi Sirat dan terlepas dari neraka akan berhenti di Qantarah, iaitu suatu tempat di antara syurga dan neraka, mereka berhenti untuk menyelesaikan pembalasan bagi setiap perkara yang berlaku sesama mereka sebelum memasuki syurga, apabila telah selesai membalas dan membersihkannya mereka diizinkan memasuki syurga.',
      'Sabda Nabi s.a.w:',
      'يخلص المؤمنون من النار، فيحبسون على قنطرة بين الجنة والنار، فيقتص لبعضهم من بعض مظالم كانت بينهم في الدنيا، حتى إذا هذبوا ونقوا أذن لهم في دخول الجنة، فوالذي نفس محمد بيده لأحدهم أهدى بمنزله في الجنة منه بمنزله كان في الدنيا [رواه البخاري]',
      '"Orang mukmin yang telah terselamat daripada api neraka akan ditahan di Qantarah, (satu tempat) di antara syurga dan neraka, setiap daripada mereka akan dibalas bagi setiap kezaliman yang berlaku sesama mereka di dunia, apabila telah selesai membersihkan semua kesalahan, mereka diberi keizinan untuk memasuki syurga. Demi Allah yang diri Muhammad di tangan-Nya sesungguhnya setiap mereka lebih kenal tempat duduknya di dalam syurga daripada tempat duduknya di dunia". (Hadith Riwayat Al-Bukhari).',
      '11. "Al-Jannah" Syurga Dan "An-Nar" Neraka',
      'Kita beriman bahawa syurga adalah benar dan neraka juga benar. Kedua-duanya telah wujud, tidak akan rosak binasa selama-lamanya. Nikmat syurga untuk ahli syurga tidak akan musnah dan hilang, demikian juga azab neraka kepada orang yang telah dihukum kekal di dalamnya tidak akan musnah dan berakhir. Adapun orang-orang yang mempunyai iman dalam dirinya akan keluar daripada neraka dengan syafaat daripada Pemberi Syafaat dan dengan rahmat Tuhan Yang Maha Mengasihani.',
      'Syurga: ialah suatu tempat yang sangat mulia yang disediakan oleh Allah Taala bagi orang-orang yang bertaqwa pada Hari Kiamat. Di dalamnya ada sungai-sungai yang mengalir, bilik-bilik yang indah dan isteri-isteri yang cantik jelita. Terdapat di dalamnya semua yang diingini oleh nafsu, indah mata memandang pada perkara-perkara yang tidak pernah dipandang oleh mata, yang tidak pernah didengar oleh telinga juga yang tidak pernah terlintas di hati manusia. Nikmatnya tidak akan musnah dan berakhir bahkan tetap berterusan tidak putus selama-lamanya. Tempat letak tongkat di dalamnya lebih baik daripada dunia dan isinya.',
      'Keharumannya dapat dicium dari jarak perjalanan 40 tahun dan nikmat yang paling besar ialah apabila orang-orang mukmin dapat memandang Tuhan mereka dengan pandangan mata kepala mereka sendiri.',
      'Adapun orang kafir pada Hari Kiamat tidak dapat memandang Allah Taala kerana pandangan mereka telah disekat (hijab). Sesiapa yang menafikan orang mukmin dapat memandang Tuhan mereka, maka mereka telah menyamakan bahawa orang mukmin dengan orang kafir yang telah disekat (hijab) daripada memandang Allah Taala.',
      'Di dalam syurga itu terdapat seratus tingkat (darjat). Jarak di antara setiap tingkat (darjat) adalah di antara langit dan bumi dan yang tertingginya ialah Syurga Firdaus. Manakala atapnya ialah Arasy Tuhan Ar-Rahman, terdapat padanya lapan pintu. Lebar setiap pintu seluas jarak antara Makkah dan Hajar dan sesungguhnya akan tiba suatu hari pintu tersebut akan penuh sesak. Serendah-rendah kedudukan penghuni syurga dianugerahkan kepadanya nikmat seumpama dunia dan sepuluh kali ganda sepertinya.',
      'Firman Allah Taala tentang syurga: "(Syurga yang bidangnya seluas segala langit dan bumi), yang disediakan bagi orang-orang yang bertaqwa". (Surah Ali \'Imran, Ayat 133).',
      'Firman Allah Taala tentang orang mukmin akan kekal di dalam syurga, tidak akan fana selama-lamanya: "Balasan mereka di sisi Tuhannya ialah Syurga \'Adn (tempat tinggal yang tetap), yang mengalir di bawahnya beberapa sungai, kekallah mereka di dalamnya selama-lamanya. Allah redha akan mereka dan mereka pun redha (serta bersyukur) akan nikmat pemberian-Nya. Balasan yang demikian itu adalah untuk orang-orang yang takut (melanggar perintah) Tuhannya". (Surah Al-Bayyinah, Ayat 8).',
      'Neraka: Ialah suatu tempat yang Allah sediakan untuk orang-orang kafir dan orang-orang yang melakukan maksiat. Di dalamnya terdapat azab seksaan yang amat dahsyat dan pelbagai jenis siksaan. Penjaganya ialah malaikat yang sangat keras sifatnya dan bengis. Orang-orang kafir akan kekal di dalamnya. Makanan mereka pula ialah "Zaqqum" (suatu pokok yang tumbuh di dalam neraka, buahnya sangat pahit lagi busuk baunya) dan minuman mereka air yang sangat panas.',
      'Firman Allah Taala tentang neraka: "Api neraka, yang disediakan bagi orang-orang kafir". (Surah Ali \'Imran, Ayat 131).',
      'Firman Allah Taala tentang ahli neraka akan kekal di dalamnya selama-lamanya dan tidak akan fana (musnah): "Sesungguhnya Allah telah melaknat orang-orang kafir dan menyediakan bagi mereka api neraka yang marak menjulang, kekallah mereka di dalamnya selama-lamanya". (Surah Al-Ahzab, Ayat 64-65).',
      'C – NATIJAH BERIMAN DENGAN HARI KIAMAT',
      'Beriman dengan Hari Akhirat mengandungi natijah yang sangat besar, antaranya:',
      '1- Memberi galakan dan dorongan kepada seseorang hamba untuk melakukan ketaatan dan amalan yang baik serta melaksanakannya kerana mengharapkan pahala daripada Allah Taala.',
      '2- Takut dan gerun untuk melakukan maksiat atau meredhai perbuatan maksiat kerana takutkan siksaan pada hari tersebut.',
      '3- Menjadikan orang-orang mukmin sabar dan redha walaupun terlepas banyak nikmat dunia kerana mengharapkan nikmat dan balasan akhirat.',
      '4- Beriman dengan kebangkitan semula merupakan asas kebahagiaan individu dan masyarakat, serta membawa kelebihan, kebaikan dan kedamaian kepada masyarakat kerana ia dapat menyekat manusia daripada melakukan perbuatan jahat.',
    ];

    final boldIndices = [
      0,    // A – BERIMAN DENGAN HARI AKHIRAT
      9,    // 1. Tanda-Tanda Kiamat Yang Kecil
      13,   // 2. Tanda-Tanda Kiamat Yang Besar
      19,   // Sabda Nabi s.a.w:
      36,   // B – SIFAT BERIMAN DENGAN HARI KIAMAT
      41,   // 1. Fitnah Kubur
      46,   // 2. Azab Kubur Dan Nikmatnya
      51,   // Sabda Nabi s.a.w:
      54,   // 3. Tiupan Sangkakala
      57,   // Sabda Nabi s.a.w:
      60,   // 4. Kebangkitan
      64,   // i- Penjelasan daripada syara'.
      68,   // Sabda Nabi s.a.w:
      72,   // ii- Realiti keadaan yang telah berlaku.
      74,   // iii- Dalil akal
      76,   // 5. Perhimpunan, Perhitungan Dan Pembalasan
      90,   // 6. Beriman Dengan Kolam Nabi s.a.w
      93,   // Sabda Nabi s.a.w:
      96,   // 7. Syafaat
      99,   // Sabda Nabi s.a.w:
      103,  // i- Syafaat Rasulullah s.a.w untuk ahli syurga...
      106,  // ii- Syafaatnya untuk kaum yang sama timbangan amalan...
      107,  // iii- Syafaatnya untuk kaum yang telah ditentukan neraka...
      110,  // iv- Syafaatnya untuk mengangkat darjat ahli syurga...
      113,  // v- Syafaatnya kepada beberapa kaum yang dapat memasuki syurga...
      116,  // vi- Syafaatnya kepada orang yang melakukan dosa besar...
      119,  // Sabda Nabi s.a.w. lagi:
      122,  // vii- Syafaatnya untuk meringankan azab...
      128,  // 8. Neraca Timbangan Amalan
      132,  // Sabda Nabi s.a.w:
      135,  // Sabda Nabi s.a.w. lagi:
      138,  // 9. Titian Sirat Al-Mustaqim
      143,  // Sabda Nabi s.a.w:
      146,  // Sabda Nabi s.a.w. lagi:
      152,  // Sabda Nabi s.a.w:
      155,  // 10. "Qantarah" Perhentian Di Antara Syurga Dan Neraka
      157,  // Sabda Nabi s.a.w:
      160,  // 11. "Al-Jannah" Syurga Dan "An-Nar" Neraka
      171,  // C – NATIJAH BERIMAN DENGAN HARI KIAMAT
      173,  // 1- Memberi galakan dan dorongan...
      174,  // 2- Takut dan gerun untuk melakukan maksiat...
      175,  // 3- Menjadikan orang-orang mukmin sabar dan redha...
      176,  // 4- Beriman dengan kebangkitan semula merupakan asas...
    ];

    final arabicIndices = [
      5,    // أن تؤمن بالله، وملائكته، وكتبه، ورسله...
      18,   // إنها لن تقوم حتى تروا قبلها عشر آيات...
      20,   // يخرج في آخر أمتي المهدي...
      43,   // ربي الله، وديني الإسلام، ونبي محمد صلى الله عليه وسلم
      52,   // فلو لا أن لا تدافنوا لدعوت الله أن يسمعكم من عذاب القبر
      58,   // ثم ينفخ في الصور فلا يسمعه أحد...
      69,   // ثم ينفخ في الصور فلا يسمعه أحد... (repeat)
      86,   // لا يسترقون، ولا يكتوون، ولا يتطيرون...
      94,   // حوضي مسيرة شهر، ماؤه أبيض من اللبن...
      100,  // إن الشمس تدنو يوم القيامة حتى يبلغ العرق نصف الأذن...
      104,  // آتي باب الجنة يوم القيامة فأستفتح...
      108,  // شفاعتي لأهل الكبائر من أمتي [رواه أبو داود]
      111,  // اللهم اغفر لأبي سلمة وارفع درجته في المهديين
      114,  // اللهم اجعله منهم [متفق عليه]
      117,  // شفاعتي لأهل الكبائر من أمتي [رواه أبو داود]
      120,  // يخرج قوم من النار بشفاعة محمد...
      123,  // لعله تنفعه شفاعتي يوم القيامة...
      133,  // الطهور شطر الإيمان، والحمد لله تملأ الميزان
      136,  // يوضع الميزان يوم القيامة...
      144,  // ويضرب الصراط بين ظهراني جهنم...
      147,  // ويضرب جسر جهنم فأكون أول من يجيز...
      150,  // بلغني أن الجسر أدق من الشعر وأحد من السيف
      153,  // وترسل الأمانة والرحم، فتقومان على جنبي الصراط...
      158,  // يخلص المؤمنون من النار، فيحبسون على قنطرة...
    ];

    for (var i = 0; i < content.length; i++) {
      await db.insert('content_blocks', {
        'rukun_iman_id': id,
        'text': content[i],
        'is_bold': boldIndices.contains(i) ? 1 : 0,
        'is_arabic': arabicIndices.contains(i) ? 1 : 0,
        'sort_order': i,
      });
    }

    return id;
  }

  // ============ INSERT RUKUN KEENAM ============

  Future<int> _insertRukunKeenam(Database db) async {
    final id = await db.insert('rukun_iman', {
      'title': 'RUKUN KEENAM: BERIMAN DENGAN QADAR',
      'subtitle': 'May 24, 2019',
      'date': '2019-05-24',
      'category': 'keenam',
      'created_at': DateTime.now().toIso8601String(),
    });

    final content = [
      // ============ A – PENGERTIAN QADAR ============
      'A – PENGERTIAN QADAR DAN KEPENTINGAN BERIMAN DENGANNYA',
      'Beriman dengan Qadar termasuk dalam beriman dengan "Rububiyyah" (kuasa mencipta dan mentadbir) Allah Taala. Ia merupakan salah satu daripada Rukun Iman dan tidak sempurna iman seseorang kecuali dengan beriman kepadanya.',
      'Al-Qadr: Ialah ketentuan Allah Taala ke atas seluruh alam semesta mengikut ilmu-Nya yang azali dan kebijaksanaan-Nya. Ianya kembali kepada kekuasaan Allah Taala. Sesungguhnya Dia berkuasa ke atas setiap sesuatu dan berkuasa melakukan perkara yang dikehendaki-Nya.',
      'Firman Allah Taala: "Sesungguhnya Kami menciptakan setiap sesuatu menurut takdir (yang telah ditentukan)". (Surah Al-Qamar, Ayat 49).',
      'Sabda Nabi s.a.w:',
      'كل شيء بقدر حتى العجز والكيس، أو الكيس والعجز [ رواه مسلم ]',
      '"Setiap sesuatu telah ditentukan termasuklah lemah dan rajin atau rajin dan lemah". (Hadith Riwayat Muslim).',

      // ============ B – MARTABAT QADAR ============
      'B – MARTABAT QADAR',
      'Tidak sempurna beriman dengan Qadar kecuali dengan menyempurnakan empat martabat, iaitu:',
      '1) Beriman dengan ilmu Allah yang azali yang meliputi setiap sesuatu.',
      'Firman Allah Taala: "Bukankah engkau telah mengetahui bahawasanya Allah mengetahui segala yang ada di langit dan di bumi? Sesungguhnya yang demikian itu ada tertulis di dalam Kitab (Lauh Mahfuz). Sesungguhnya hal itu amatlah mudah bagi Allah". (Surah Al-Haj, Ayat 70).',
      '2) Beriman dengan segala perkara yang telah ditulis di "Lauh Mahfuz" dan beriman bahawa Allah mengetahui semua perkara yang telah ditentukan itu.',
      'Firman Allah Taala: "Tiada Kami tinggalkan sesuatu pun di dalam kitab Al-Quran ini". (Surah Al-An\'am, Ayat 38). Sabda Nabi s.a.w:',
      'كتب الله مقادير الخلائق قبل أن يخلق السموات والأرض بخمسين ألف سنة [ رواه مسلم ]',
      '"Allah telah menulis semua ketentuan yang akan berlaku kepada makhluk 50 ribu tahun sebelum dijadikan langit dan bumi". (Hadith Riwayat Muslim).',
      '3) Beriman dengan kehendak Allah yang pasti terjadi dan kuasa-Nya Yang Maha Sempurna.',
      'Firman Allah Taala: "Dan kamu tidak dapat menentukan kemahuan kamu (mengenai sesuatupun), kecuali dengan cara yang diatur oleh Allah, Tuhan yang memelihara dan mentadbir seluruh alam". (Surah At-Takwir, Ayat 29).',
      'Sabda Nabi s.a.w kepada orang yang berkata kepadanya: "Ini semua dengan kehendak Allah dan kehendak Tuan (Nabi)".',
      'أجعلتني لله نداً ، بل ما شاء الله وحده [ رواه أحمد ]',
      '"Apakah engkau mahu menjadikan aku sekutu bagi Allah? Tetapi katakanlah: Bahkan dengan kehendak yang diinginkan oleh Allah Yang Maha Esa". (Hadith Riwayat Ahmad).',
      '4) Beriman bahawa Allah adalah pencipta semua makhluk.',
      'Firman Allah Taala: "Allah yang mencipta tiap-tiap sesuatu dan Dialah yang mentadbir serta menguasai segala-galanya". (Surah Az-Zumar, Ayat 62).',
      'Firman Allah Taala: "Padahal Allah yang mencipta kamu dan perbuatan yang kamu lakukan itu". (Surah As-Saffat, Ayat 96).',
      'Sabda Nabi s.a.w:',
      'إن الله يصنع كل صانع وصنعته [ رواه البخاري ]',
      '"Sesungguhnya Allah Taala mencipta setiap orang yang mencipta dan hasil ciptaannya". (Hadith Riwayat Al-Bukhari).',

      // ============ C – BAHAGIAN-BAHAGIAN TAKDIR ============
      'C – BAHAGIAN-BAHAGIAN TAKDIR (KETENTUAN)',
      '1) Takdir umum untuk semua makhluk, iaitu suratan yang ditulis di "Lauh Mahfuz" sebelum dijadikan langit dan bumi 50 ribu tahun. Firman Allah Taala: "(Kami menurunkan Al-Quran pada malam Lailatul Qadar, kerana) pada malam yang berkat itu, dijelaskan (kepada malaikat) tiap-tiap perkara yang mengandungi hikmah serta yang tetap berlaku, (tidak berubah atau bertukar)". (Surah Ad-Dukhan, ayat 4).',
      '2) Takdir mengikut umur, iaitu takdir yang berlaku ke atas diri seorang hamba bermula daripada peniupan roh kepadanya sehingga sampai ajalnya.',
      '3) Takdir tahunan, iaitu takdir yang akan berlaku setiap tahun, ia ditentukan pada malam Lailatul Qadar setiap tahun.',
      '4) Takdir harian, iaitu takdir ke atas setiap perkara yang berlaku pada setiap hari, antaranya kemuliaan, kehinaan, pemberian, sekatan, menghidup, mematikan dan lain-lainnya. Firman Allah Taala: "Sekalian makhluk yang ada di langit dan di bumi sentiasa berhajat dan memohon kepada-Nya. setiap masa Dia di dalam urusan (mencipta dan mentadbir makhluk-makhluk-Nya)". (Surah Ar-Rahman, Ayat 29).',

      // ============ D – AQIDAH SALAF ============
      'D – AQIDAH SALAF DALAM MASALAH QADAR',
      'Bahawa Allah Taala mencipta tiap-tiap sesuatu, mentadbir dan memilikinya. Allah telah menentukan perkara yang akan terjadi sebelum menjadikannya. Dia telah menentukan ajal, rezeki dan kerja yang mereka lakukan. Dia telah menulis kesudahan mereka sama ada menjadi bertuah atau celaka. Semuanya telah ditulis dalam catatan yang jelas dan nyata. Setiap perkara yang Allah kehendaki akan berlaku dan setiap perkara yang tidak dikehendaki tidak akan berlaku. Allah mengetahui perkara yang telah lepas, sedang berlaku, akan datang, waktu dan cara ia berlaku. Allah berkuasa ke atas setiap sesuatu, memberi petunjuk kepada sesiapa yang dikehendaki dan menyesatkan orang-orang yang dikehendaki. Setiap hamba memiliki kehendak dan kuasa untuk melakukan semua perkara yang ditentukan oleh Allah ke atas mereka dengan keyakinan bahawa setiap hamba tidak boleh melakukan sesuatu kecuali dengan kehendak Allah.',
      'Firman Allah Taala: "Dan orang-orang yang berusaha dengan bersungguh-sungguh kerana memenuhi kehendak agama Kami, sesungguhnya Kami akan memimpin mereka ke jalan-jalan Kami (yang menjadikan mereka bergembira serta beroleh keredhaan)". (Surah Al-Ankabut, Ayat 69).',
      'Sesungguhnya Allah Taala mencipta hamba-hamba-Nya serta perbuatan mereka dan mereka sendiri pula yang melakukan semua perbuatan yang mereka lakukan. Maka tidak ada hujjah bagi seorang hamba ke atas Allah sekiranya dia mahu meninggalkan perkara yang wajib atau melakukan perkara yang haram (bahawa ini adalah ketentuan Allah), bahkan Allah Taala mempunyai hujjah yang kuat ke atas hamba-hamba-Nya.',
      'Berhujjah dengan Qadar dibolehkan di atas musibah yang telah menimpa tetapi tidak boleh dijadikan hujjah di atas keaiban dan dosa, seperti sabda Nabi s.a.w ketika menceritakan perdebatan yang berlaku di antara Nabi Musa dan Adam a.s:',
      'تحاج آدم وموسى، فقال موسى: أنت آدم الذي أخرجتك خطيئتك من الجنة؟ فقال له آدم: أنت موسى الذي اصطفاك الله برسالاته وبكلامه، ثم تلومني على أمر قد قُدّر عليّ قبل أن أخلق، فحج آدمُ موسى [ رواه مسلم ]',
      '"Telah berhujjah Nabi Musa dan Adam a.s. Kata Musa: Tuankah Adam yang kesalahan tuan lakukan telah mengeluarkan tuan daripada syurga? Jawab Adam: Tuankah Musa yang Allah pilih untuk menerima risalah-Nya dan berkata-kata dengan-Nya, kemudian tuan mencela saya di atas pekerjaan yang telah ditentukan (ditakdirkan) ke atas saya sebelum saya dijadikan! Maka Nabi Adam telah mematahkah hujjah Nabi Musa a.s." (Hadith Riwayat Muslim).',

      // ============ E – PERBUATAN HAMBA ============
      'E – PERBUATAN HAMBA',
      'Perbuatan yang Allah Taala ciptakan di alam semesta ini terbahagi kepada dua bahagian:',
      '1. Perkara yang Allah Taala tentukan daripada perbuatan-Nya kepada makhluk-Nya, maka tidak ada seorang pun boleh membuat pilihan atau mengikut kehendak sendiri. Semuanya berlaku mengikut kehendak Allah, seperti hidup, mati, sakit dan sihat.',
      'Firman Allah Taala: "Padahal Allah yang mencipta kamu dan perbuatan yang kamu lakukan itu". (Surah As-Saffat, Ayat 96).',
      'Firman Allah Taala: "Dialah yang telah mentakdirkan adanya mati dan hidup (kamu) untuk menguji dan menzahirkan keadaan kamu. Siapakah di antara kamu yang lebih baik amalnya". (Surah Al-Mulk, Ayat 2).',
      '2. Perbuatan yang dilakukan oleh makhluk yang mempunyai kehendak, maka ia terjadi dengan kehendak dan pilihan orang yang melakukannya kerana Allah telah meletakkan kehendak dan pilihan tersebut kepada mereka.',
      'Firman Allah Taala: "Iaitu untuk sesiapa daripada kamu yang mahu tetap teguh di atas jalan (Islam) yang betul". (Surah At-Takwir, Ayat 28).',
      'Firman Allah Taala: "Maka sesiapa yang mahu beriman, hendaklah dia beriman dan sesiapa yang mahu ingkar, biarlah dia mengingkarinya". (Surah Al-Kahf, Ayat 29).',
      'Mereka akan dipuji dengan sebab melakukan perkara yang terpuji dan akan dicerca dengan sebab melakukan perkara yang tercela. Allah tidak menyeksa mereka kecuali dengan perkara yang menjadi pilihan hamba untuk melakukannya.',
      'Firman Allah Taala: "Dan Aku tidak sekali-kali berlaku zalim kepada hamba-Ku". (Surah Qaf, Ayat 29).',
      'Manusia mengetahui perbezaan di antara pilihan dan paksaan, sebagai contoh seseorang yang turun dari atas bumbung rumah melalui tangga adalah dengan pilihannya sendiri atau mungkin juga ia dicampak oleh orang lain dari atas bumbung ke bawah. Maka yang pertama adalah pilihan dan yang kedua adalah paksaan.',

      // ============ F – PENYATUAN MAKNA ============
      'F – PENYATUAN MAKNA DI ANTARA CIPTAAN ALLAH DAN PERBUATAN HAMBA',
      'Allah mencipta hamba dan perbuatannya serta menjadikan baginya kehendak dan kuasa. Oleh itu setiap hamba melakukan sendiri setiap perbuatannya kerana dia mempunyai kehendak dan kuasa. Apabila dia beriman maka itu adalah dengan kemahuan dan kehendaknya. Sekiranya dia kafir maka itu adalah dengan kemahuan dan kehendaknya yang sempurna. Sebagai contoh, apabila kita berkata: Buah ini dari pokok ini dan pokok ini berasal dari bumi ini, bermakna ia terjadi darinya dan daripada Allah. Ertinya Allah Taala jualah yang menjadikannya dari pokok atau tanah. Oleh itu tidak ada percanggahan di antara dua kejadian ini. Dengan ini, bertepatanlah syariat Allah dengan Qadar (ketentuan-Nya).',
      'Firman Allah Taala: "Padahal Allah yang mencipta kamu dan perbuatan yang kamu lakukan itu". (Surah As-Saffat, Ayat 96).',
      'Firman Allah Taala: "Adapun orang yang memberikan apa-apa yang ada padanya ke jalan kebaikan dan bertaqwa. Dan dia membenarkan dengan yakin akan perkara yang baik. Maka Kami akan memberikannya kemudahan untuk mendapat kesenangan (syurga). Sebaliknya orang yang bakhil (daripada berbuat kebajikan) dan berasa cukup dengan kekayaan dan kemewahannya serta dia mendustakan perkara yang baik. Maka sesungguhnya Kami akan memberikannya kemudahan untuk mendapat kesusahan dan kesengsaraan". (Surah Al-Lail, Ayat 5-10).',

      // ============ G – KEWAJIPAN HAMBA TERHADAP QADAR ============
      'G – KEWAJIPAN HAMBA TERHADAP QADAR',
      'Seorang hamba wajib melaksanakan dua perkara dalam beriman dengan Qadar:',
      '1. Hendaklah memohon pertolongan daripada Allah untuk melaksanakan perkara yang diperintahkan-Nya dan menjauhi larangan-Nya. Hendaklah berdoa agar Allah mempermudahkan baginya untuk mendapat kesenangan dan menjauhkannya daripada kesusahan di samping bertawakkal kepada Allah dan meminta perlindungan daripada-Nya, maka jadilah ia sentiasa bergantung dengan Allah untuk mendapatkan perkara yang baik dan meninggalkan kejahatan. Sabda Nabi s.a.w:',
      'احرص على ما ينفعك، واستعن بالله ولا تعجز، وإن أصابك شيء فلا تقل: لو أني فعلت كذا لكان كذا، ولكن قل: قدر الله وما شاء فعل، فإن لو تفتح عمل الشيطان',
      '"Hendaklah kamu banyak melakukan perkara yang mendatangkan manfaat kepada kamu, mintalah pertolongan dengan Allah dan jangan mudah berasa lemah. Sekiranya bala menimpa kamu maka janganlah kamu berkata: \'Kalaulah aku lakukan begini tentu ia akan jadi begini\', tetapi katakanlah: \'Allah telah menentukannya dan setiap yang dikehendaki-Nya akan dilakukan-Nya\'. Lantaran kerana perkataan \'kalau\' akan membuka peluang kepada syaitan".',
      '2. Hendaklah dia bersabar di atas perkara yang telah ditentukan ke atasnya dan tidak meratap atau menyesal, setelah dia mengetahui bahawa semua yang terjadi adalah dengan kehendak Allah maka dia redha dan berserah diri. Dia seharusnya mengetahui bahawa dia tidak mungkin terlepas daripada perkara yang ditetapkan untuk menimpanya dan perkara yang tidak ditetapkan ke atasnya tidak akan menimpanya.',
      'Sabda Nabi s.a.w:',
      'وأعلم أن ما أصابك لم يكن ليخطئك، وأن ما أخطأك لم يكن ليصيبك',
      '"Ketahuilah bahawa semua perkara yang menimpa kamu tidak mungkin akan terlepas daripada menimpa kamu dan perkara yang tidak ditentukan kepada kamu tidak mungkin akan menimpa kamu".',

      // ============ H – REDHA DENGAN QADHA' DAN QADAR ============
      'H – REDHA DENGAN QADHA\' DAN QADAR',
      'Adalah menjadi satu kewajipan untuk meredhai semua ketentuan (qadar) kerana ia merupakan tanda kesempurnaan redha dengan "Rububiyyah" Allah. Setiap mukmin wajib meredhai Qada\' Allah kerana semua perbuatan Allah dan ketentuan-Nya adalah baik, adil dan mempunyai hikmah.',
      'Sesiapa yang yakin bahawa semua perkara yang ditetapkan untuk menimpanya tidak mungkin terlepas daripadanya dan perkara yang tidak ditentukan ke atasnya tidak akan menimpanya, dia akan terlepas daripada perasaan keluh kesah dan huru-hara. Hidupnya tenang, tidak goyah atau ragu-ragu, tidak berasa dukacita di atas perkara yang hilang dan tidak menganggap masa depannya gelap. Maka dengan itu, dia akan menjadi orang yang paling bahagia, baik keadaannya dan tenang hatinya.',
      'Sesiapa yang mengetahui bahawa ajal dan rezekinya sudah ditetapkan, dia tidak akan berasa takut kerana sifat penakut tidak dapat memanjangkan umurnya. Dia tidak bakhil kerana sifat bakhil tidak dapat menambahkan rezekinya. Dia sedar bahawa semuanya telah tertulis. Dia akan menjadi sabar menghadapi semua bencana yang menimpanya dan meminta ampun ke atas semua dosa dan kesalahan yang telah dilakukannya. Dia redha dengan ketentuan yang telah ditentukan oleh Allah. Dengan itu dia telah mengumpulkan di antara ketaatan terhadap perintah dan sabar terhadap ujian dalam menerima bencana yang menimpa.',
      'Firman Allah Taala: "Tidak ada kesusahan (atau bala bencana) yang menimpa (seseorang) melainkan dengan izin Allah dan sesiapa yang beriman kepada Allah, Allah akan memimpin hatinya (untuk menerima setiap perkara yang telah berlaku itu dengan tenang dan sabar) dan (ingatlah), Allah Maha Mengetahui akan tiap-tiap sesuatu". (Surah At-Taghabun, Ayat 11).',
      'Firman Allah Taala: "(Setelah engkau mengetahui perihal Nabi Musa dan umatnya) maka bersabarlah (wahai Muhammad, dalam perjuangan menegakkan Islam), sesungguhnya janji Allah (untuk memberi kejayaan kepadamu) adalah benar dan pohonlah ampun bagi kesalahanmu". (Surah Ghafir, Ayat 55).',

      // ============ I – HIDAYAT ============
      'I – HIDAYAT TERBAHAGI KEPADA DUA JENIS',
      '1. Hidayat memimpin manusia kepada kebenaran.',
      'Ia diberikan kepada semua makhluk dan hidayat inilah yang mampu diberi oleh rasul serta para pengikutnya.',
      'Firman Allah Taala: "Dan sesungguhnya engkau (wahai Muhammad) memberi petunjuk dengan Al-Quran itu ke jalan yang lurus". (Surah Asy-Syura, Ayat 52).',
      '2. Hidayat memberi taufik, meneguh dan menguatkan pegangan.',
      'Ini adalah anugerah Allah dan limpah kurnia-Nya kepada hamba-hamba-Nya yang bertaqwa. Hidayat ini tidak ada yang berkuasa mengurniakannya selain daripada Allah.',
      'Firman Allah Taala: "Sesungguhnya engkau (wahai Muhammad) tidak berkuasa untuk memberikan hidayat (petunjuk) kepada sesiapa yang engkau kasihi (supaya dia menerima Islam), tetapi Allah jualah yang berkuasa memberi hidayat (petunjuk) kepada sesiapa yang dikehendaki-Nya (menurut undang-undang peraturan-Nya)". (Surah Al-Qasas, Ayat 56).',

      // ============ J – IRADAH ============
      'J – "IRADAH" – KEHENDAK MENURUT KITAB ALLAH TERBAHAGI KEPADA DUA JENIS',
      '1. "Iradah Kauniyyah Qadariah". Kehendak mengadakan semua makhluk dan alam semesta (universal).',
      'Iaitu kemahuan yang umum merangkumi semua makhluk yang wujud, setiap perkara yang Allah kehendaki akan berlaku dan semua yang tidak dikehendaki-Nya tidak akan berlaku. Ia pasti terjadi tetapi tidak semestinya perkara yang berlaku itu disukai atau diredhai oleh Allah kecuali apabila bergantung dengan kehendak syara\' ("Iradah Ad-Diniyyah Asy-Syar\'iyyah").',
      'Firman Allah Taala: "Maka sesiapa yang Allah kehendaki untuk memberikan hidayat (petunjuk) kepadanya nescaya Dia melapangkan dadanya (membuka hatinya) untuk menerima Islam". (Surah Al-An\'am, Ayat 125).',
      '2. "Iradah Ad-Diniyyah Asy-Syar\'iyyah". Kehendak agama yang disyariatkan.',
      'Iaitu mahabbah (kasih) kepada perkara yang dijadikan (menurut kehendak Allah) dan kasih kepada orang yang menerimanya serta meredhai mereka. Iradah (kehendak) ini tidak mungkin terjadi kecuali apabila bergantung dengan kehendak umum kejadian makhluk.',
      'Firman Allah Taala: "(Dengan ketetapan yang demikian itu) Allah menghendaki kamu beroleh kemudahan dan Dia tidak menghendaki kamu menanggung kesukaran". (Surah Al-Baqarah, Ayat 185).',
      '"Iradah Kauniyyah" (iaitu kehendak menjadikan semua makhluk) lebih umum secara mutlak kerana semua kehendak syara\' yang terjadi adalah mengikut kehendak "menjadikan" (kauni) dan bukan semua kehendak "menjadikan" ("kauni") terjadi mengikut kehendak syara\'.',
      'Contohnya seperti iman Saidina Abu Bakar r.a. yang ada padanya kedua-dua kehendak di atas. Manakala contoh berlakunya kehendak "menjadikan" ("kauni") sahaja (tanpa kehendak syara\') ialah kafirnya Abu Jahal dan tidak berlakunya kehendak "menjadikan" walaupun apa yang dikehendaki mengikut syara\' ialah iman Abu Jahal.',
      'Allah Taala walaupun telah menentukan terjadinya maksiat dan berlakunya menurut kehendak "menjadikan" ("kauni") tetapi tidak meredhainya menurut kehendak agama. Dia tidak menyukainya dan tidak menyuruhnya bahkan memurkainya, membencinya, menegah daripada melakukannya dan menjanjikan seksaan kepada orang yang melakukannya. Semua itu adalah daripada ketentuan-Nya.',
      'Adapun ketaatan dan keimanan, Allah Taala menyukainya dan menyuruh melakukannya serta menjanjikan orang yang melakukannya dengan pahala dan balasan yang baik. Setiap penderhakaan kepada Allah Taala tidak akan berlaku tanpa kehendak-Nya dan tidak akan berlaku sesuatu perkara kecuali mengikut kehendak-Nya.',
      'Firman Allah Taala: "Dan Dia tidak meredhai hamba-hamba-Nya berkeadaan kufur". (Surah Az-Zumar, Ayat 7).',
      'Firman Allah Taala: "Allah tidak suka kepada bencana kerosakan". (Surah Al-Baqarah, Ayat 205).',

      // ============ K – SEBAB-SEBAB MENOLAK QADAR ============
      'K – SEBAB-SEBAB YANG BOLEH MENOLAK QADAR (KETENTUAN)',
      'Allah Taala telah menjadikan kepada ketentuan ini beberapa sebab yang boleh menolak dan mengangkatnya. Seperti doa, sedekah, ubat-ubatan, berhati-hati dan bertindak secara bijaksana kerana semuanya daripada Qada\' dan Qadar Allah termasuklah lemah dan rajin.',

      // ============ L – RAHSIA ALLAH ============
      'L – MASALAH QADAR MERUPAKAN RAHSIA ALLAH TERHADAP MAKHLUKNYA',
      'Pendapat yang mengatakan bahawa Qadar adalah rahsia Allah pada makhluk kejadian-Nya terhad kepada satu aspek yang tersembunyi daripada Qadar. Hakikat terjadinya sesuatu perkara tiada yang mengetahuinya melainkan Allah dan tidak dapat diketahui oleh manusia.',
      'Contohnya seperti Allah Taala menyesatkan, memberi hidayat, mematikan, menghidupkan, menegah atau memberi kurniaan, sebagaimana sabda Nabi s.a.w:',
      'إذا ذكر القدر فأمسكوا [ رواه مسلم ]',
      '"Apabila disebut tentang Qadar (ketentuan Allah) maka tahanlah diri kalian daripada bercakap (mengenainya)". (Hadith Riwayat Muslim).',
      'Manakala perbincangan masalah Qadar dari sudut lain, iaitu dari segi penjelasan hikmahnya yang sangat besar, martabatnya, darjatnya dan kesan-kesannya adalah diharuskan untuk menjelaskannya kepada manusia dan mengetahuinya kerana Qadar adalah salah satu daripada Rukun Iman yang mesti dipelajari dan diketahui tentangnya sebagaimana yang telah dijelaskan oleh Rasulullah s.a.w ketika menjelaskan Rukun Iman kepada Jibrail a.s. Sabdanya:',
      'هذا جبريل أتاكم يعلمكم دينكم [ رواه مسلم ].',
      '"Inilah Jibrail yang datang untuk mengajar kepada kamu agama kamu". (Hadith Riwayat Muslim).',

      // ============ M – HUKUM BERHUJJAH DENGAN QADAR ============
      'M – HUKUM BERHUJJAH DENGAN QADAR',
      'Allah Taala mengetahui semua yang akan berlaku. Ia adalah perkara ghaib yang tidak sesiapa mengetahuinya kecuali Allah. Semua manusia jahil mengenainya. Oleh itu Qadar tidak boleh dijadikan hujjah oleh sesiapa. Tidak harus bagi seseorang untuk meninggalkan amalan dengan alasan bergantung kepada ketentuan yang telah ditentukan.',
      'Qadar tidak boleh dijadikan hujjah oleh sesiapa sama ada ke atas Allah atau kepada sesama makhluk. Sekiranya seseorang boleh menjadikan Qadar sebagai hujjah bagi perbuatan jahatnya, maka tidak ada orang zalim yang boleh dikenakan hukuman, tidak ada orang kafir yang boleh diperangi, tidak boleh dijalankan hukuman dan tidak boleh menahan seseorang daripada melakukan kezaliman. Ini adalah satu kesesatan yang jelas memudharatkan agama dan dunia.',
      'Katakanlah kepada mereka yang berhujjah dengan Qadar: "Kamu tidak mengetahui dengan yakin sama ada kamu ini ahli syurga atau neraka. Kalau kamu mengetahuinya dengan yakin nescaya kami tidak akan menyuruh atau menegah kamu melakukan apa-apa saja, tetapi beramallah semoga Allah Taala memberi taufik kepada kamu agar menjadi ahli syurga".',
      'Kata sesetengah Sahabat sewaktu mendengar perbincangan tentang Qadar: "Kamu bukanlah orang yang lebih baik dalam berijtihad daripada saya".',
      'Sabda Nabi s.a.w ketika ditanya tentang Qadar:',
      'اعملوا فكل ميسر لما خلق له، فمن كان من أهل السعادة فسييسر لعمل أهل السعادة، ومن كان من أهل الشقاوة فسييسر لعمل أهل الشقاوة',
      '"Beramallah! Sesungguhnya setiap orang akan dipermudahkan baginya melakukan perkara yang dijadikan untuknya. Sekiranya dia ahli syurga, dimudahkan baginya melakukan amalan orang-orang yang bertuah dan sekiranya dia ahli neraka maka dipermudahkan baginya melakukan amalan orang-orang yang celaka".',
      'Kemudian Baginda membaca ayat: "Adapun orang yang memberikan apa-apa yang ada padanya ke jalan kebaikan dan bertaqwa. Dan dia membenarkan dengan yakin akan perkara yang baik. Maka Kami akan memberikannya kemudahan untuk mendapat kesenangan (syurga). Sebaliknya orang yang bakhil (daripada berbuat kebajikan) dan merasa cukup dengan kekayaan dan kemewahannya serta dia mendustakan perkara yang baik. Maka sesungguhnya Kami akan memberikannya kemudahan untuk mendapat kesusahan dan kesengsaraan". (Surah Al-Lail, Ayat 5-10). (Hadith Riwayat Al-Bukhari dan Muslim).',

      // ============ N – MENGAMBIL SEBAB ============
      'N – MENGAMBIL SEBAB (YANG MENYELAMATKAN)',
      'Perkara yang menimpa seorang hamba ada dua keadaan, perkara yang ia mempunyai jalan untuk melepaskannya maka janganlah lemah daripada berusaha untuk mengelak darinya dan perkara yang tidak ada cara untuk melepaskannya maka janganlah keluh kesah menghadapinya.',
      'Allah Taala mengetahui setiap bala bencana sebelum kejadiannya. Ilmu Allah tentangnya bukan bermakna Allah yang menimpakan bencana ke atasnya tetapi bencana itu terjadi menurut sebab-sebab yang menyebabkan terjadinya bencana. Sekiranya bencana terjadi dengan sebab kecuaian seseorang mengambil alat atau cara yang boleh menyelamatkannya daripada terkena bencana sedangkan agama menyuruhnya menggunakannya, maka kecelaan itu terletak ke atas dirinya sendiri kerana tidak menjaga dirinya dan tidak mencari usaha-usaha yang boleh menyelamatkannya. Sebaliknya apabila dia tidak mempunyai kemampuan untuk menolak bencana tersebut maka dia diberi keuzuran.',
      'Mengambil sebab tidak menafikan Qadar dan tawakkal bahkan ia adalah sebahagian daripadanya. Namun apabila sesuatu ketentuan telah terjadi, maka wajiblah redha dan menyerah kepada ketentuan tersebut serta kembali kepada pesanan Rasulullah s.a.w, "Ketentuan Allah dan setiap yang ditentukan pasti akan terjadi".',
      'Adapun sebelum berlakunya sesuatu ketentuan, maka setiap "mukallaf" hendaklah mengambil langkah-langkah yang diizinkan dan menolak Qadar dengan Qadar. Semua nabi a.s. telah mengambil kira sebab-sebab dan cara-cara yang boleh menyelamatkan mereka daripada gangguan musuh mereka sedangkan mereka telah dibantu dengan wahyu dan dipelihara oleh Allah. Rasulullah s.a.w, penghulu orang-orang bertawakkal, telah mengambil kira sebab yang boleh menyelamatkannya sedangkan Baginda adalah orang yang paling berwakkal kepada Tuhannya.',
      'Firman Allah Taala: "Dan sediakanlah untuk menentang mereka (musuh yang menceroboh) segala jenis kekuatan yang dapat kamu sediakan dan dari pasukan-pasukan berkuda yang lengkap sedia, untuk menggerunkan dengan persediaan itu musuh Allah dan musuh kamu". (Surah Al-Anfal, Ayat 60).',
      'Firman Allah Taala: "Dialah yang menjadikan bumi bagi kamu, mudah digunakan, maka berjalanlah di merata-rata ceruk rantaunya, serta makanlah daripada rezeki yang telah dikurniakan oleh Allah dan (ingatlah), kepada Allah jualah (tempat kembali kamu sesudah) dibangkitkan hidup semula, (maka hargailah nikmat-Nya dan takutilah kemurkaan-Nya)". (Surah Al-Mulk, Ayat 15).',
      'Sabda Nabi s.a.w:',
      'المؤمن القوي خير وأحب إلى الله من المؤمن الضعيف، وفي كل خير، احرص على ما ينفعك، واستعن بالله ولا تعجز، وإن أصابك شيء فلا تقل: لو أني فعلت كذا لكان كذا وكذا، ولكن قل: قدّر الله ما شاء فعل، فإن لو تفتح عمل الشيطان [ رواه مسلم ]',
      '"Orang mukmin yang kuat adalah lebih baik dan disukai oleh Allah daripada mukmin yang lemah dan semua orang mukmin baik. Hendaklah kamu banyak melakukan perkara yang mendatangkan manfaat kepadamu. Mintalah pertolongan dengan Allah dan jangan mudah berasa lemah. Sekiranya bala menimpa kamu maka jangan kamu berkata: \'Kalaulah aku lakukan begini tentu ia akan jadi begini\', tetapi katakanlah: \'Allah telah menentukannya dan setiap yang dikehendaki-Nya akan dilakukan-Nya kerana perkataan \'kalau\' akan membuka peluang kepada syaitan\'". (Hadith Riwayat Muslim).',

      // ============ O – HUKUM MENGINGKARI QADAR ============
      'O – HUKUM MENGINGKARI QADAR',
      'Sesiapa yang mengingkari Qadar sesungguhnya dia telah mengingkari satu asas daripada asas syariat dan akan menjadi kafir.',
      'Kata sebahagian ulama\' salaf rahimahumullah:',
      '"Berdebatlah dengan golongan Qadariah (orang yang menafikan qadar) dengan ilmu. Sekiranya mereka mengingkarinya, maka mereka telah kafir. Jika mereka menerimanya, mereka akan berbantah".',

      // ============ P – NATIJAH BERIMAN DENGAN QADAR ============
      'P – NATIJAH BERIMAN DENGAN QADAR',
      'Beriman dengan Qada\' dan Qadar mempunyai natijah dan kesan yang baik yang mengembalikan kebaikan kepada ummah dan individu. Antaranya ialah:',
      '1. Ia akan menghasilkan pelbagai jenis ibadat yang soleh dan sifat-sifat yang terpuji seperti ikhlas kepada Allah, bertawakkal kepada-Nya, takutkan seksaan-Nya, mengharap dan berbaik sangka dengan Allah, sabar dan kuat semangat, menentang perasaan putus asa, redha dengan ketentuan Allah, mengesakan Allah dengan bersyukur kepada-Nya, gembira dengan limpah kurnia dan rahmat-Nya, tawadhu\' kepada-Nya, meninggalkan sifat takbur dan bongkak, banyak memberi nafkah pada jalan Allah kerana yakin dengan Allah, berani, merasa cukup dengan segala yang ada serta mempunyai kemuliaan diri, mempunyai semangat yang tinggi, teguh, tekun melakukan kerja, sederhana ketika susah dan senang, membersihkan diri daripada sifat hasad, murni pemikiran daripada perkara khurafat dan karut dan mempunyai jiwa yang aman serta pemikiran yang tenang.',
      '2. Orang yang beriman dengan Qadar, hidup di atas landasan yang betul. Nikmat tidak menjadikannya seorang yang sombong. Dia tidak berputus asa dengan musibah yang menimpa. Dia yakin bahawa musibah yang menimpanya adalah dengan ketentuan daripada Allah untuk mengujinya dan tidak mudah melenting bahkan bersabar dan mengharapkan pahala daripada Allah Taala.',
      '3. Beriman dengan Qadar boleh menjaganya daripada anasir kesesatan dan kesudahan yang tidak baik "Su\' al-khatimah", kerana dia sentiasa berusaha untuk terus beristiqamah dan memperbanyakkan amalan yang soleh serta menjauhi perbuatan maksiat dan perkara-perkara yang membinasakan.',
      '4. Beriman dengan Qadar menjadikan seorang mukmin mampu menghadapi bencana dan kesusahan dengan hati yang teguh serta keyakinan yang penuh dan terus melakukan sebab-sebab yang boleh menyelamatkannya. Sabda Nabi s.a.w:',
      'عجباً لأمر المؤمن إن أمره كله له خير، وليس ذلك إلا للمؤمن، إن أصابته سراء شكر فكان خيراً له، وإن أصابته ضراء صبر فكان خيراً له [ رواه مسلم ]',
      '"Sungguh pelik keadaan orang mukmin. Semua perkara adalah baik baginya. Tidak terjadi perkara yang demikian kecuali untuk orang mukmin. Sekiranya dia mendapat perkara yang baik, dia bersyukur, maka syukur itu lebih baik baginya. Sekiranya ditimpa kesusahan, dia bersabar, maka sabar itu lebih baik baginya". (Hadith Riwayat Muslim).',

      // ============ CLOSING ============
      '* * * * * * * * * * * * * * * * * * * * *',
      'وصلى الله على نبينا محمد وعلى آله وصحبه أجمعين',
      'وآخر دعوانا أن الحمد لله رب العالمين',
      'Ekstraks dari buku "Rukun Iman" terbitan Jabatan Kajian Ilmiah, Universiti Islam Madinah, alih bahasa oleh Dr Abdul Basit Bin Abdul Rahman dengan sedikit suntingan dan saringan oleh Kumpulan Web Darulkautsar - https://darulkautsar.wordpress.com',
    ];

    // ============ BOLD INDICES ============
    // Section headings (A –, B –, etc.) and major numbered points
    final boldIndices = [
      0,   // A – PENGERTIAN QADAR
      4,   // Sabda Nabi s.a.w:
      7,   // B – MARTABAT QADAR
      9,   // 1) Beriman dengan ilmu Allah
      11,  // 2) Beriman dengan Lauh Mahfuz
      15,  // 3) Beriman dengan kehendak Allah
      20,  // 4) Beriman bahawa Allah pencipta
      23,  // Sabda Nabi s.a.w:
      26,  // C – BAHAGIAN-BAHAGIAN TAKDIR
      31,  // D – AQIDAH SALAF
      38,  // E – PERBUATAN HAMBA
      49,  // F – PENYATUAN MAKNA
      53,  // G – KEWAJIPAN HAMBA
      55,  // Sabda Nabi s.a.w:
      59,  // Sabda Nabi s.a.w:
      62,  // H – REDHA
      68,  // I – HIDAYAT
      69,  // 1. Hidayat memimpin
      7,  // 2. Hidayat memberi taufik
      75,  // J – IRADAH
      76,  // 1. Iradah Kauniyyah
      79,  // 2. Iradah Ad-Diniyyah
      88,  // K – SEBAB-SEBAB
      90,  // L – MASALAH QADAR
      98,  // M – HUKUM BERHUJJAH
      103, // Sabda Nabi s.a.w ketika ditanya tentang Qadar:
      107, // N – MENGAMBIL SEBAB
      114, // Sabda Nabi s.a.w:
      117, // O – HUKUM MENGINGKARI
      121, // P – NATIJAH BERIMAN
    ];

    // ============ ARABIC INDICES (will render in RED) ============
    final arabicIndices = [
      5,   // كل شيء بقدر
      13,  // كتب الله مقادير الخلائق
      18,  // أجعلتني لله نداً
      24,  // إن الله يصنع كل صانع
      36,  // تحاج آدم وموسى
      56,  // احرص على ما ينفعك
      60,  // وأعلم أن ما أصابك
      93,  // إذا ذكر القدر فأمسكوا
      96,  // هذا جبريل أتاكم
      104, // اعملوا فكل ميسر
      115, // المؤمن القوي خير
      127, // عجباً لأمر المؤمن
      130, // وصلى الله
      131, // وآخر دعوانا
    ];

    for (var i = 0; i < content.length; i++) {
      await db.insert('content_blocks', {
        'rukun_iman_id': id,
        'text': content[i],
        'is_bold': boldIndices.contains(i) ? 1 : 0,
        'is_arabic': arabicIndices.contains(i) ? 1 : 0,
        'sort_order': i,
      });
    }

    return id;
  }

  // ============ INSERT VIDEO DATA ============

  Future<void> _insertVideoData(Database db) async {
    // Rukun Pertama Videos
    final video1 = await db.insert('videos', {
      'youtube_id': 'cd5ijT5t5lY',
      'title': 'VIDEO – [Durasi 1m 13s] – RUKUN IMAN PERTAMA – Percaya Kepada Allah (Secara Ringkas) – Maulana Asri Yusoff',
      'category': 'pertama',
      'duration': '1m 13s',
      'sort_order': 0,
    });

    final video2 = await db.insert('videos', {
      'youtube_id': '7tFVZXbYkOA',
      'title': 'VIDEO – [Durasi 1j 17m 55s] -Rukun Iman Pertama BERIMAN DENGAN ALLAH – Dr Abd Basit Abdul Rahman',
      'category': 'pertama',
      'duration': '1j 17m 55s',
      'sort_order': 1,
    });

    await db.insert('video_links', {
      'video_id': video1,
      'title': 'Tonton video "Percaya Kepada Allah (Secara Ringkas) – Maulana Asri Yusoff" melalui saluran YouTube – ',
      'url': 'https://youtu.be/cd5ijT5t5lY',
      'url_text': 'https://youtu.be/cd5ijT5t5lY',
    });

    await db.insert('video_links', {
      'video_id': video2,
      'title': 'Tonton video "Rukun Iman Pertama BERIMAN DENGAN ALLAH – Dr Abd Basit Abdul Rahman" melalui saluran YouTube – ',
      'url': 'https://youtu.be/7tFVZXbYkOA',
      'url_text': 'https://youtu.be/7tFVZXbYkOA',
    });

    // Rukun Kedua Videos
    final video3 = await db.insert('videos', {
      'youtube_id': 'gIithWfRpD0',
      'title': 'VIDEO -[Durasi 8m 27s] – RUKUN IMAN KEDUA- Percaya Kepada Malaikat – Maulana Muhammad Asri Yusoff',
      'category': 'kedua',
      'duration': '8m 27s',
      'sort_order': 0,
    });

    final video4 = await db.insert('videos', {
      'youtube_id': 'JSFrKLPCFvo',
      'title': 'VIDEO -[Durasi 1j 23m 38s]- Rukun Iman Kedua BERIMAN DENGAN MALAIKAT – Dr Abdul Basit Abdul Rahman',
      'category': 'kedua',
      'duration': '1j 23m 38s',
      'sort_order': 1,
    });

    await db.insert('video_links', {
      'video_id': video3,
      'title': 'Tonton video "RUKUN IMAN KEDUA- Percaya Kepada Malaikat – Maulana Muhammad Asri Yusoff" melalui saluran YouTube – ',
      'url': 'https://youtu.be/gIithWfRpD0',
      'url_text': 'https://youtu.be/gIithWfRpD0',
    });

    await db.insert('video_links', {
      'video_id': video4,
      'title': 'Tonton video "Rukun Iman Kedua BERIMAN DENGAN MALAIKAT – Dr Abdul Basit Abdul Rahman" melalui saluran YouTube – ',
      'url': 'https://youtu.be/JSFrKLPCFvo',
      'url_text': 'https://youtu.be/JSFrKLPCFvo',
    });

    // Rukun Ketiga Videos
    final video5 = await db.insert('videos', {
      'youtube_id': 'RokUV4IKsTM',
      'title': 'VIDEO -[Durasi 7m 16s]- RUKUN IMAN KETIGA – Percaya Kepada Kitab – Maulana Muhammad Asri Yusoff',
      'category': 'ketiga',
      'duration': '7m 16s',
      'sort_order': 0,
    });

    final video6 = await db.insert('videos', {
      'youtube_id': 'EAqL_dSfSM0',
      'title': 'VIDEO -[Durasi 1j 12m 16s] – Rukun Iman Ketiga & Keempat – BERIMAN DENGAN KITAB & RASUL – Dr Abd Basit Abdul Rahman',
      'category': 'ketiga',
      'duration': '1j 12m 16s',
      'sort_order': 1,
    });

    await db.insert('video_links', {
      'video_id': video5,
      'title': 'Tonton video "RUKUN IMAN KETIGA – Percaya Kepada Kitab – Maulana Muhammad Asri Yusoff" melalui saluran YouTube – ',
      'url': 'https://youtu.be/RokUV4IKsTM',
      'url_text': 'https://youtu.be/RokUV4IKsTM',
    });

    await db.insert('video_links', {
      'video_id': video6,
      'title': 'Tonton video "Rukun Iman Ketiga & Keempat – BERIMAN DENGAN KITAB & RASUL – Dr Abd Basit Abdul Rahman" melalui saluran YouTube – ',
      'url': 'https://youtu.be/EAqL_dSfSM0',
      'url_text': 'https://youtu.be/EAqL_dSfSM0',
    });

    // Rukun Keempat Videos
    final video7 = await db.insert('videos', {
      'youtube_id': 'j-AqhQ7sCkw',
      'title': 'VIDEO -[Durasi 10m 5s]- RUKUN IMAN KEEMPAT – Percaya Kepada Rasul – Maulana Muhammad Asri Yusoff',
      'category': 'keempat',
      'duration': '10m 5s',
      'sort_order': 0,
    });

    final video8 = await db.insert('videos', {
      'youtube_id': 'EAqL_dSfSM0',
      'title': 'VIDEO -[Durasi 1j 12m 16s] – Rukun Iman Ketiga & Keempat – BERIMAN DENGAN KITAB & RASUL – Dr Abd Basit Abdul Rahman',
      'category': 'keempat',
      'duration': '1j 12m 16s',
      'sort_order': 1,
    });

    await db.insert('video_links', {
      'video_id': video7,
      'title': 'Tonton video "RUKUN IMAN KEEMPAT – Percaya Kepada Rasul – Maulana Muhammad Asri Yusoff" melalui saluran YouTube – ',
      'url': 'https://youtu.be/j-AqhQ7sCkw',
      'url_text': 'https://youtu.be/j-AqhQ7sCkw',
    });

    await db.insert('video_links', {
      'video_id': video8,
      'title': 'Tonton video "Rukun Iman Ketiga & Keempat – BERIMAN DENGAN KITAB & RASUL – Dr Abd Basit Abdul Rahman" melalui saluran YouTube – ',
      'url': 'https://youtu.be/EAqL_dSfSM0',
      'url_text': 'https://youtu.be/EAqL_dSfSM0',
    });

    // Rukun Kelima Videos
    final video9 = await db.insert('videos', {
      'youtube_id': 'riAL1PIZfek',
      'title': 'VIDEO -[Durasi 6m 49s]-RUKUN IMAN KELIMA – Percaya Kepada Hari Kemudian – Maulana Muhammad Asri Yusoff',
      'category': 'kelima',
      'duration': '6m 49s',
      'sort_order': 0,
    });

    final video10 = await db.insert('videos', {
      'youtube_id': 'XzLthkDyTYw',
      'title': 'VIDEO -[Durasi 1j 9m 4s]- Rukun Iman Kelima – BERIMAN DENGAN HARI AKHIRAT – Dr Abdul Basit Abdul Rahman',
      'category': 'kelima',
      'duration': '1j 9m 4s',
      'sort_order': 1,
    });

    await db.insert('video_links', {
      'video_id': video9,
      'title': 'Tonton video "RUKUN IMAN KELIMA – Percaya Kepada Hari Kemudian – Maulana Muhammad Asri Yusoff" melalui saluran YouTube – ',
      'url': 'https://youtu.be/riAL1PIZfek',
      'url_text': 'https://youtu.be/riAL1PIZfek',
    });

    await db.insert('video_links', {
      'video_id': video10,
      'title': 'Tonton video "Rukun Iman Kelima – BERIMAN DENGAN HARI AKHIRAT – Dr Abdul Basit Abdul Rahman" melalui saluran YouTube – ',
      'url': 'https://youtu.be/XzLthkDyTYw',
      'url_text': 'https://youtu.be/XzLthkDyTYw',
    });

    // Rukun Keenam Videos
    final video11 = await db.insert('videos', {
      'youtube_id': '64lxVc_uQe4',
      'title': 'VIDEO -[Durasi 40m 25s]-RUKUN IMAN KEENAM – Percaya Kepada Takdir – Maulana Muhammad Asri Yusoff',
      'category': 'keenam',
      'duration': '40m 25s',
      'sort_order': 0,
    });

    final video12 = await db.insert('videos', {
      'youtube_id': 'VaBmAqcrwMo',
      'title': 'VIDEO – [Durasi 1j 12m 41s]-Rukun Iman Keenam – BERIMAN DENGAN QADA\' & QADAR – Dr Abd Basit Abdul Rahman',
      'category': 'keenam',
      'duration': '1j 12m 41s',
      'sort_order': 1,
    });

    await db.insert('video_links', {
      'video_id': video11,
      'title': 'Tonton video "RUKUN IMAN KEENAM – Percaya Kepada Takdir – Maulana Muhammad Asri Yusoff" melalui saluran YouTube – ',
      'url': 'https://youtu.be/64lxVc_uQe4',
      'url_text': 'https://youtu.be/64lxVc_uQe4',
    });

    await db.insert('video_links', {
      'video_id': video12,
      'title': 'Tonton video "Rukun Iman Keenam – BERIMAN DENGAN QADA\' & QADAR – Dr Abd Basit Abdul Rahman" melalui saluran YouTube – ',
      'url': 'https://youtu.be/VaBmAqcrwMo',
      'url_text': 'https://youtu.be/VaBmAqcrwMo',
    });
  }

  // ============ QUERY METHODS ============

  Future<List<Map<String, dynamic>>> getRukunImanByCategory(String category) async {
    final db = await database;
    developer.log('Querying category: $category', name: 'DatabaseHelper');

    final result = await db.query(
      'rukun_iman',
      where: 'category = ?',
      whereArgs: [category],
    );

    developer.log('Found ${result.length} items for category: $category', name: 'DatabaseHelper');
    return result;
  }

  Future<List<Map<String, dynamic>>> getContentBlocks(int rukunImanId) async {
    final db = await database;
    return await db.query(
      'content_blocks',
      where: 'rukun_iman_id = ?',
      whereArgs: [rukunImanId],
      orderBy: 'sort_order ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getVideosByCategory(String category) async {
    final db = await database;
    return await db.query(
      'videos',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'sort_order ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getVideoLinks(int videoId) async {
    final db = await database;
    return await db.query(
      'video_links',
      where: 'video_id = ?',
      whereArgs: [videoId],
    );
  }

  Future<Map<String, dynamic>?> getRukunIman(int id) async {
    final db = await database;
    final result = await db.query(
      'rukun_iman',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final db = await database;
    return await db.query(
      'rukun_iman',
      distinct: true,
      columns: ['category', 'title'],
    );
  }

  Future<int> getContentCount(String category) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM rukun_iman WHERE category = ?',
      [category],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema upgrades
    if (oldVersion < 2) {
      // Add new columns or tables
    }
  }
}