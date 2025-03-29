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
     String? pushToken;

    factory ChatUser.fromJson(Map<String, dynamic> json){ 
        return ChatUser(
            image: json["image"],
            about: json["about"],
            name: json["name"],
            createdAt: json["createdAt"],
            isOnline: json["isOnline"],
            lastActive: json["lastActive"],
            id: json["id"],
            email: json["email"],
            pushToken: json["pushToken"],
        );
    }

    Map<String, dynamic> toJson() => {
        "image": image,
        "about": about,
        "name": name,
        "createdAt": createdAt,
        "isOnline": isOnline,
        "lastActive": lastActive,
        "id": id,
        "email": email,
        "pushToken": pushToken,
    };

}
