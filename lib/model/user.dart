class UserResponse {
  final int totalCount;
  final bool incompleteResults;
  final List<ItemsItem> items;

  UserResponse({
    required this.totalCount,
    required this.incompleteResults,
    required this.items,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      totalCount: json['total_count'],
      incompleteResults: json['incomplete_results'],
      items: List<ItemsItem>.from(
        json['items'].map((item) => ItemsItem.fromJson(item)),
      ),
    );
  }
}

class ItemsItem {
  final int id;
  final String login;
  final String avatarUrl;

  ItemsItem({
    required this.id,
    required this.login,
    required this.avatarUrl,
  });

  factory ItemsItem.fromJson(Map<String, dynamic> json) {
    return ItemsItem(
      id: json['id'],
      login: json['login'],
      avatarUrl: json['avatar_url'],
    );
  }
}