class ChatUser {
    ChatUser({
        required this.image,
        required this.about,
        required this.name,
        required this.createdAt,
        required this.isOnline,
        required this.lastActive,
        required this.id,
        required this.email,
        required this.pushToken,
    });

   late  String? image;
   late  String? about;
    late String? name;
   late final String? createdAt;
   late final bool? isOnline;
   late final String? lastActive;
   late final String? id;
   late final String? email;
   late final String? pushToken;

    factory ChatUser.fromJson(Map<String, dynamic> json){ 
        return ChatUser(
            image: json["image"],
            about: json["about"],
            name: json["name"],
            createdAt: json["created_at"],
            isOnline: json["is_online"],
            lastActive: json["last_active"],
            id: json["id"],
            email: json["email"],
            pushToken: json["push_token"],
        );
    }

    Map<String, dynamic> toJson() => {
        "image": image,
        "about": about,
        "name": name,
        "created_at": createdAt,
        "is_online": isOnline,
        "last_active": lastActive,
        "id": id,
        "email": email,
        "push_token": pushToken,
    };

}
