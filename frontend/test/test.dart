import 'dart:convert';
import 'package:http/http.dart' as http;


main() async {
  AuthService authService = AuthService();

  final logoutUrl = Uri.parse("http://localhost:8000/account/logout/");
var response = await http.get(logoutUrl, headers: {
    "Authorization": "Token 2ae42acdacf578e3f914ae7f19ad7e62a3252df0"
  });
}
//   var response = await http.get(Uri.parse("http://localhost:8000/account/user/"),
//     headers: {
//       "Authorization": "Token 2ae42acdacf578e3f914ae7f19ad7e62a3252df0"
//     });
//   print(response.body);
// }
// 2ae42acdacf578e3f914ae7f19ad7e62a3252df0

//   LoginResponse? loginResponse = await authService.login(
//     "raiqasvl@gmail.com",
//     "Fylfnhf738",
//   );
//   if (loginResponse != null) {
//     if (loginResponse.key != null) print(loginResponse.key);
//     if (loginResponse.non_field_errors != null)
//       loginResponse.non_field_errors!.forEach((element) {
//         print(element);
//       });
//   }
// }

  // RegistrationResponse? registrationResponse = await authService.registration(
  //     "jeanlao",
  //     "Fylfnhf738", 
  //     "Fylfnhf738", 
  //     "goldwoodkiddo@gmail.com");

  // if (registrationResponse != null) {

  //   if (registrationResponse.username != null) {
  //     registrationResponse.username!.forEach((element) {
  //       print(element);
  //     });
  //   }

  //   if (registrationResponse.email != null) {
  //     registrationResponse.email!.forEach((element) {
  //       print(element);
  //     });
  //   }
  //   if (registrationResponse.password1 != null) {
  //     registrationResponse.password1!.forEach((element) {
  //       print(element);
  //     });
  //   }  
  //   if (registrationResponse.non_field_errors != null) {
  //     registrationResponse.non_field_errors!.forEach((element) {
  //       print(element);
  //     });
  //   }
  //   if (registrationResponse.key != null) {
  //     print(registrationResponse.key!);
  //   }
  // }


class AuthService{
  final registrationUri = Uri.parse("http://localhost:8000/registration/");
  final loginUri = Uri.parse("http://localhost:8000/account/login/");

  Future<RegistrationResponse?>registration(
      String username, String password1, String password2, String email) async {
    var response = await http.post(registrationUri, body: {
      "username": username,
      "password1": password1,
      "password2": password2,
      "email": email,
    });
    /// print(response.body);
    return RegistrationResponse.fromJson(jsonDecode(response.body));
  } 

  Future<LoginResponse?> login(
      String usernameOremail, String password) async {
    var response = await http.post(loginUri, body: {
      "username": usernameOremail,
      "password": password,
    });
    return LoginResponse.fromJson(jsonDecode(response.body));
    print(response.body);
  }
}




/// Our right registration response {"key":"e8055c1b4a34f3faea879167a381e65c11a13267"}
/// response for error {"username":["User with this username already exists."]}
/// response for error {"email":["A user is already registered with this e-mail address."]}
/// response for error {"password1":["This password is too short. It must contain at least 8 characters.","This password is too common.","This password is entirely numeric."]}
/// response for error {"non_field_errors":["The two password fields didn't match."]}


class RegistrationResponse {
  List<dynamic>? non_field_errors;
  List<dynamic>? password1;
  List<dynamic>? username;
  List<dynamic>? email;
  dynamic? key;

  RegistrationResponse({
    this.non_field_errors,
    this.password1,
    this.username,
    this.email,
    this.key,
  });

  factory RegistrationResponse.fromJson(mapOfBody){
    return RegistrationResponse(
      non_field_errors: mapOfBody["non_field_errors"],
      password1: mapOfBody["password1"],
      username: mapOfBody["username"],
      email: mapOfBody["email"],
      key: mapOfBody["key"],
    );
  }
}

class LoginResponse {
  dynamic? key;
  List<dynamic>? non_field_errors;
  LoginResponse({this.key, this.non_field_errors});

  factory LoginResponse.fromJson(mapOfBody) {
    return LoginResponse(
      key: mapOfBody['key'],
      non_field_errors: mapOfBody['non_field_errors'],
    );
  }
}