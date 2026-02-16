import 'package:get/get.dart';

class CommunityFeedController extends GetxController {
  final count = 0.obs;

  final List<String> filters = ["Recent", "Jobs", "Question", "Rentals", "Sell", "Info"];
  final selectedFilter = "Recent".obs;

  final posts = <Map<String, dynamic>>[
    {
      "name": "Mohammad Rahim",
      "time": "2 hours ago",
      "content": "The bKash rate is really good today. If anyone wants to send dollars, feel free to contact me.",
      "avatar": "https://placehold.co/40x40",
      "likes": 24,
      "comments": 2,
      "isLiked": true,
      "hasSave": true,
      "category": "Question",
      "images": ["https://placehold.co/600x400/png", "https://placehold.co/600x400/png"],
      "commentsList": [
        {"name": "Ali Khan", "text": "What is the rate?", "avatar": "https://placehold.co/30x30", "time": "1h ago"},
        {"name": "Sara Ahmed", "text": "Please DM me.", "avatar": "https://placehold.co/30x30", "time": "30m ago"}
      ]
    },
    {
      "name": "Fatema Khanam",
      "time": "4 hours ago",
      "content": "I want to sell my car.My car color is black and toyta chr brand if anyone intersted please call me.",
      "avatar": "https://placehold.co/40x40",
      "likes": 15,
      "comments": 1,
      "isLiked": true,
      "hasSave": true,
      "category": "Sell",
      "images": ["https://placehold.co/600x400/png"],
      "commentsList": [
        {"name": "John Doe", "text": "Price details?", "avatar": "https://placehold.co/30x30", "time": "2h ago"}
      ]
    },
    {
      "name": "Mohammad Rahim",
      "time": "2 hours ago",
      "content": "The bKash rate is really good today. If anyone wants to send dollars, feel free to contact me.",
      "avatar": "https://placehold.co/40x40",
      "likes": 24,
      "comments": 0,
      "isLiked": false,
      "hasSave": false,
      "category": "Info",
      "images": [],
      "commentsList": []
    },
     {
      "name": "Nadia Hassan",
      "time": "6 hours ago",
      "content": "Has anyone visited the new museum downtown? Is it worth the ticket price?",
      "avatar": "https://placehold.co/40x40",
      "likes": 45,
      "comments": 0,
      "isLiked": false,
      "hasSave": true,
      "category": "Question",
      "images": [
       "https://placehold.co/600x400/png",
       "https://placehold.co/600x400/png",
       "https://placehold.co/600x400/png",
       "https://placehold.co/600x400/png",
       "https://placehold.co/600x400/png"
      ],
      "commentsList": []
    },
  ].obs;

  void addComment(int index, String comment) {
    if (comment.trim().isEmpty) return;
    
    var post = posts[index];
    // Create new comment
    Map<String, dynamic> newComment = {
      "name": "You",
      "text": comment,
      "avatar": "https://placehold.co/30x30",
      "time": "Just now"
    };

    // Safely add to commentsList
    List<dynamic> currentComments = post["commentsList"] ?? [];
    currentComments.add(newComment);
    
    // Update the post map
    post["commentsList"] = currentComments;
    post["comments"] = (post["comments"] ?? 0) + 1;
    
    // Refresh the specific item in the list to trigger UI update
    posts[index] = post;
  }

  void toggleLike(int index) {
    var post = posts[index];
    bool isLiked = post['isLiked'] ?? false;
    
    if (isLiked) {
      post['likes'] = (post['likes'] ?? 1) - 1;
      post['isLiked'] = false;
    } else {
      post['likes'] = (post['likes'] ?? 0) + 1;
      post['isLiked'] = true;
    }
    
    posts[index] = post;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
