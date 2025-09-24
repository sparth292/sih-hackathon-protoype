class CommunityPost {
  final String id;
  final String userName;
  final String userAvatar;
  final String location;
  final String imageUrl;
  final String caption;
  final int likes;
  final List<String> comments;
  final DateTime timestamp;
  final bool isLiked;

  CommunityPost({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.location,
    required this.imageUrl,
    required this.caption,
    this.likes = 0,
    List<String>? comments,
    DateTime? timestamp,
    this.isLiked = false, required bool isLoved,
  })  : comments = comments ?? [],
        timestamp = timestamp ?? DateTime.now();

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'userAvatar': userAvatar,
      'location': location,
      'imageUrl': imageUrl,
      'caption': caption,
      'likes': likes,
      'comments': comments,
      'timestamp': timestamp.toIso8601String(),
      'isLiked': isLiked ? 1 : 0,
    };
  }

  // Create from Map
  factory CommunityPost.fromMap(Map<String, dynamic> map) {
    return CommunityPost(
      id: map['id'],
      userName: map['userName'],
      userAvatar: map['userAvatar'],
      location: map['location'],
      imageUrl: map['imageUrl'],
      caption: map['caption'],
      likes: map['likes'] ?? 0,
      comments: List<String>.from(map['comments'] ?? []),
      timestamp: DateTime.parse(map['timestamp']),
      isLiked: (map['isLiked'] ?? 0) == 1, isLoved: false,
    );
  }

  // Create a copy with updated values
  CommunityPost copyWith({
    String? id,
    String? userName,
    String? userAvatar,
    String? location,
    String? imageUrl,
    String? caption,
    int? likes,
    List<String>? comments,
    DateTime? timestamp,
    bool? isLiked,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      timestamp: timestamp ?? this.timestamp,
      isLiked: isLiked ?? this.isLiked, isLoved: false,
    );
  }
}
