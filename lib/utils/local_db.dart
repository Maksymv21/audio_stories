class LocalDB {
  LocalDB._();

  static String? uid;
  static String? phoneNumber;

  static String profileNumber = phoneNumber!.substring(0, 3) +
      ' (' +
      phoneNumber!.substring(3, 6) +
      ') ' +
      phoneNumber!.substring(6, 9) +
      ' ' +
      phoneNumber!.substring(9, 11) +
      ' ' +
      phoneNumber!.substring(11, 13);
}
