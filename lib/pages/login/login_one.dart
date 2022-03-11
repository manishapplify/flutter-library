// import 'package:components/base/base_screen.dart';
// import 'package:components/routes/navigation.dart';
// import 'package:flutter/material.dart';

// class LoginScreen extends BaseScreen {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _LoginState();
// }

// class _LoginState extends BaseScreenState<LoginScreen> {
//   late final FocusNode emailFocusNode;
//   late final FocusNode passwordFocusNode;
//   late final TextEditingController emailTextEditingController;
//   late final TextEditingController passwordTextEditingController;

//   @override
//   void initState() {
//     emailFocusNode = FocusNode();
//     passwordFocusNode = FocusNode();
//     emailTextEditingController = TextEditingController();
//     passwordTextEditingController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     emailTextEditingController.dispose();
//     passwordTextEditingController.dispose();
//     emailFocusNode.dispose();
//     passwordFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   PreferredSizeWidget appBar(BuildContext context) => AppBar(
//         title: const Text('Login'),
//       );

//   void onFormSubmitted() async {}

//   @override
//   Widget body(BuildContext context) {
//     return Form(
//       child: Center(
//         child: SingleChildScrollView(
//           child: Stack(
//             alignment: Alignment.center,
//             children: <Widget>[
//               Column(
//                 children: <Widget>[
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   TextFormField(
//                     controller: emailTextEditingController,
//                     focusNode: emailFocusNode,
//                     autofocus: true,
//                     textAlignVertical: TextAlignVertical.top,
//                     decoration: const InputDecoration(
//                       hintText: 'Enter your email',
//                       labelText: 'Email',
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                     onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     controller: passwordTextEditingController,
//                     focusNode: passwordFocusNode,
//                     textAlignVertical: TextAlignVertical.top,
//                     decoration: const InputDecoration(
//                       hintText: 'Enter your password',
//                       labelText: 'Password',
//                     ),
//                     obscureText: true,
//                     onFieldSubmitted: (_) => onFormSubmitted(),
//                   ),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () {
//                         Future<void>.microtask(
//                           () => navigator.pushNamed(
//                             Routes.forgotPasswordOne,
//                           ),
//                         );
//                       },
//                       child: Text(
//                         'Forgot Password?',
//                         style: textTheme.headline4,
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: onFormSubmitted,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0,
//                         vertical: 8.0,
//                       ),
//                       child: Text(
//                         'Submit',
//                         style: textTheme.headline2,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Future<void>.microtask(
//                         () => navigator.pushNamed(
//                           Routes.signupOne,
//                         ),
//                       );
//                     },
//                     child: RichText(
//                       text: TextSpan(
//                         text: "Don't have an account? ",
//                         style: textTheme.headline2,
//                         children: const <TextSpan>[
//                           TextSpan(
//                             text: 'Sign up',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
