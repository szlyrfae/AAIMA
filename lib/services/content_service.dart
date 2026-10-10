import 'dart:developer' as developer;
import '../database/database_helper.dart';

class ContentService {
  final DatabaseHelper _db = DatabaseHelper();

  // Get content blocks for a specific rukun
  Future<List<Map<String, dynamic>>> getRukunContent(String category) async {
    try {
      developer.log('Fetching content for category: $category', name: 'ContentService');

      final rukun = await _db.getRukunImanByCategory(category);
      developer.log('Found ${rukun.length} rukun entries', name: 'ContentService');

      if (rukun.isEmpty) {
        developer.log('No rukun found for category: $category', name: 'ContentService');
        return [];
      }

      final content = await _db.getContentBlocks(rukun.first['id']);
      developer.log('Found ${content.length} content blocks', name: 'ContentService');

      return content.map((block) => {
        'text': block['text'],
        'isBold': block['is_bold'] == 1,
        'isArabic': block['is_arabic'] == 1,
      }).toList();
    } catch (e) {
      developer.log('Error in getRukunContent: $e', name: 'ContentService', error: e);
      return [];
    }
  }

  // Get videos for a specific rukun
  Future<List<Map<String, dynamic>>> getRukunVideos(String category) async {
    try {
      final videos = await _db.getVideosByCategory(category);

      final List<Map<String, dynamic>> result = [];
      for (var video in videos) {
        final links = await _db.getVideoLinks(video['id']);
        result.add({
          'id': video['youtube_id'],
          'title': video['title'],
          'duration': video['duration'] ?? '',
          'links': links,
        });
      }
      return result;
    } catch (e) {
      print('Error getting videos for $category: $e');
      return [];
    }
  }

  // Get video links with YouTube URLs
  Future<List<Map<String, dynamic>>> getVideoLinks(String category) async {
    try {
      final videos = await _db.getVideosByCategory(category);

      final List<Map<String, dynamic>> result = [];
      for (var video in videos) {
        final links = await _db.getVideoLinks(video['id']);
        if (links.isNotEmpty) {
          result.add({
            'id': video['youtube_id'],
            'title': links.first['title'],
            'url': links.first['url'],
            'urlText': links.first['url_text'],
          });
        }
      }
      return result;
    } catch (e) {
      print('Error getting video links for $category: $e');
      return [];
    }
  }

  // Get Rukun Iman Pengenalan
  Future<List<Map<String, dynamic>>> getRukunImanPengenalan() async {
    return getRukunContent('pengenalan');
  }

  // Get Rukun Iman Pertama
  Future<List<Map<String, dynamic>>> getRukunImanPertama() async {
    return getRukunContent('pertama');
  }

  // Get Rukun Iman Kedua
  Future<List<Map<String, dynamic>>> getRukunImanKedua() async {
    return getRukunContent('kedua');
  }

  // Get Rukun Iman Ketiga
  Future<List<Map<String, dynamic>>> getRukunImanKetiga() async {
    return getRukunContent('ketiga');
  }

  // Get Rukun Iman Keempat
  Future<List<Map<String, dynamic>>> getRukunImanKeempat() async {
    return getRukunContent('keempat');
  }

  // Get Rukun Iman Kelima
  Future<List<Map<String, dynamic>>> getRukunImanKelima() async {
    return getRukunContent('kelima');
  }

  // Get Rukun Iman Keenam
  Future<List<Map<String, dynamic>>> getRukunImanKeenam() async {
    return getRukunContent('keenam');
  }

  // Get all categories
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    return await _db.getAllCategories();
  }

  // Get content count
  Future<int> getContentCount(String category) async {
    return await _db.getContentCount(category);
  }

  // lib/database/database_helper.dart
  Future<void> checkDatabaseContent() async {
    final db = await _db.database;

    // Count total records
    final count = await db.rawQuery('SELECT COUNT(*) as count FROM rukun_iman');
    developer.log('Total rukun_iman records: ${count.first['count']}', name: 'DatabaseHelper');

    // List all categories
    final categories = await db.rawQuery('SELECT DISTINCT category FROM rukun_iman');
    developer.log('Categories in database: ${categories.map((c) => c['category']).toList()}', name: 'DatabaseHelper');

    // Check each category
    final allCategories = ['pengenalan', 'pertama', 'kedua', 'ketiga', 'keempat', 'kelima', 'keenam'];
    for (var category in allCategories) {
      final result = await db.query(
        'rukun_iman',
        where: 'category = ?',
        whereArgs: [category],
      );
      developer.log('Category "$category": ${result.length} entries', name: 'DatabaseHelper');

      if (result.isNotEmpty) {
        // Check content blocks
        final blocks = await db.query(
          'content_blocks',
          where: 'rukun_iman_id = ?',
          whereArgs: [result.first['id']],
        );
        developer.log('  Content blocks: ${blocks.length}', name: 'DatabaseHelper');
      }
    }
  }
}