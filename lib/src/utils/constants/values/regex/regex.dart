abstract class Regexs {
  static const String _regx =
      r'^(?!mailto:)(?:(?:http|https|ftp)://)(?:\\S+(?::\\S*)?@)?(?:(?:(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[0-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,})))|localhost)(?::\\d{2,5})?(?:(/|\\?|#)[^\\s]*)?$';

  //copied
  static final RegExp _urlRegex = RegExp(
    r"^(?:http|https):\/\/[\w\-_]+(?:\.[\w\-_]+)+[\w\-.,@?^=%&:/~\\+#]*$",
  );

  //copied
  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  //copied
  //matches for 8 characters 1 lowercase and 1 special character (\$%&@!_-+)
  static final RegExp _passwordRegex = RegExp(
    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[@$!%*?&])[A-Za-z\d_$%&@!_+]{8,}$",
// r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",
  );
  static final RegExp urlRegex = _urlRegex;
  static final RegExp passwordRegex = _passwordRegex;
}
