class StringConstants {
  static const String mainVideosApiUrl =
      'https://api.wemotions.app/feed?page=1&page_size=10';
  static String repliesApiUrl(int id) =>
      'https://api.wemotions.app/posts/$id/replies';
}
