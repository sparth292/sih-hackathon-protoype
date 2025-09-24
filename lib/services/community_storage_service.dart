import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_india_hackathon/models/community_post.dart';
import 'dart:convert';

class CommunityStorageService {
  static const String _postsKey = 'community_posts';
  static final CommunityStorageService _instance = CommunityStorageService._internal();
  late SharedPreferences _prefs;

  factory CommunityStorageService() {
    return _instance;
  }

  CommunityStorageService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Clear existing data to ensure we start fresh with correct paths
    await _prefs.remove('posts');
    await _prefs.remove('isInitialized');
    
    // Always reinitialize with sample data to ensure correct paths
    await _initializeSampleData();
  }

  Future<void> _initializeSampleData() async {
    final now = DateTime.now();
    final samplePosts = [
      CommunityPost(
        id: '1',
        userName: 'Lalbaugcha Raja',
        userAvatar: 'assets/images/lalbaugcha.jpg',
        location: 'Lalbaug, Mumbai',
        imageUrl: 'assets/images/lalbaugcha.jpg',
        caption: 'Ganpati Bappa Morya! 🐘🙏 Celebrating with full devotion at Lalbaugcha Raja this year. #GanpatiFestival #Mumbai',
        likes: 1243,
        comments: [
          'Amazing decoration!',
          'Jai Ganesh!',
          'Visited yesterday, beautiful pandal!'
        ],
        timestamp: now.subtract(const Duration(hours: 2)),
        isLiked: false,
        isLoved: false,
      ),
      CommunityPost(
        id: '2',
        userName: 'Dagdusheth Temple',
        userAvatar: 'assets/images/dagdusheth.jpg',
        location: 'Dagdusheth Temple, Pune',
        imageUrl: 'assets/images/dagdusheth.jpg',
        caption: 'The divine presence of Shree Dagdusheth Ganpati is truly mesmerizing. Blessed to have darshan today! 🙏 #DagdushethGanpati #Pune',
        likes: 892,
        comments: [
          'Beautiful!',
          'Visiting tomorrow!',
          'Jai Ganesh!'
        ],
        timestamp: now.subtract(const Duration(days: 1)),
        isLiked: true,
        isLoved: false,
      ),
      CommunityPost(
        id: '3',
        userName: 'Chinchpokli Chintamani',
        userAvatar: 'assets/images/chinchpokli_chintamani.jpg',
        location: 'Chinchpokli, Mumbai',
        imageUrl: 'assets/images/chinchpokli_chintamani.jpg',
        caption: 'The divine Chintamani Ganpati of Chinchpokli is known for fulfilling wishes. The peaceful ambiance here is truly special. #ChinchpokliChintamani #Mumbai',
        likes: 1567,
        comments: [
          'Stunning!',
          'Must visit place',
          'Visiting tomorrow!'
        ],
        timestamp: now.subtract(const Duration(days: 2)),
        isLiked: false,
        isLoved: false,
      ),
      CommunityPost(
        id: '4',
        userName: 'Keshavji Naik Temple',
        userAvatar: 'assets/images/keshavji.png',
        location: 'Girgaon, Mumbai',
        imageUrl: 'assets/images/keshavji.png',
        caption: 'The historic Keshavji Naik Chhatrapati Shivaji Maharaj Marg temple is a must-visit during Ganesh Chaturthi. The decorations are breathtaking!',
        likes: 987,
        comments: [
          'Beautiful temple!',
          'Love the decorations',
          'Visiting soon!'
        ],
        timestamp: now.subtract(const Duration(days: 3)),
        isLiked: false,
        isLoved: false,
      ),
      CommunityPost(
        id: '5',
        userName: 'GSB Seva Mandal',
        userAvatar: 'assets/images/gsb.jpg',
        location: 'King\'s Circle, Mumbai',
        imageUrl: 'assets/images/gsb.jpg',
        caption: 'The GSB Seva Mandal is known for its eco-friendly celebrations and beautiful decorations. This year\'s theme is amazing!',
        likes: 1123,
        comments: [
          'Eco-friendly Ganesha!',
          'Beautiful decorations',
          'Must visit this year'
        ],
        timestamp: now.subtract(const Duration(days: 4)),
        isLiked: true,
        isLoved: true,
      ),
    ];
    
    await savePosts(samplePosts);
  }

  Future<List<CommunityPost>> getPosts() async {
    final postsJson = _prefs.getStringList(_postsKey) ?? [];
    return postsJson
        .map((postJson) => CommunityPost.fromMap(json.decode(postJson)))
        .toList();
  }

  Future<void> savePosts(List<CommunityPost> posts) async {
    final postsJson = posts.map((post) => json.encode(post.toMap())).toList();
    await _prefs.setStringList(_postsKey, postsJson);
  }

  Future<CommunityPost?> getPost(String id) async {
    final posts = await getPosts();
    try {
      return posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addPost(CommunityPost post) async {
    final posts = await getPosts();
    posts.insert(0, post); // Add to beginning of list
    await savePosts(posts);
  }

  Future<void> updatePost(CommunityPost updatedPost) async {
    final posts = await getPosts();
    final index = posts.indexWhere((post) => post.id == updatedPost.id);
    if (index != -1) {
      posts[index] = updatedPost;
      await savePosts(posts);
    }
  }

  Future<void> deletePost(String id) async {
    final posts = await getPosts();
    posts.removeWhere((post) => post.id == id);
    await savePosts(posts);
  }

  Future<void> toggleLike(String postId, String userId) async {
    final post = await getPost(postId);
    if (post != null) {
      final updatedPost = post.copyWith(
        isLiked: !post.isLiked,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
      );
      await updatePost(updatedPost);
    }
  }

  Future<void> addComment(String postId, String comment) async {
    final post = await getPost(postId);
    if (post != null) {
      final updatedComments = List<String>.from(post.comments)..add(comment);
      final updatedPost = post.copyWith(comments: updatedComments);
      await updatePost(updatedPost);
    }
  }
}
