class Session {
  int userId;
  bool isAdmin;
  bool isLoggedIn;

  Session({
    required this.userId,
    required this.isAdmin,
    required this.isLoggedIn,
  });
}
