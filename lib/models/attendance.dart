class Attendance {
  final int userId;
  final String timestamp;
  final List<int> imageData; // Assuming you'll use bytes for the image

  Attendance({
    required this.userId,
    required this.timestamp,
    required this.imageData,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'timestamp': timestamp,
      'image_data': imageData,
    };
  }
}
