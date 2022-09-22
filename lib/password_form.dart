import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class PasswordForm extends StatefulWidget {
  const PasswordForm(
      {required this.login, required this.email, required this.selectPage});
  final String email;
  final void Function(String email, String password) login;
  final void Function(int page) selectPage;
  @override
  PasswordFormState createState() => PasswordFormState();
}

class PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PasswordFormState');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static const lsMargin = 15.0;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    print(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GlassContainer(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            blur: 4,
            color: Colors.white.withOpacity(0.7),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.blue.withOpacity(0.3),
              ],
            ),
            //--code to remove border
            border: const Border.fromBorderSide(BorderSide.none),
            shadowStrength: 5,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            shadowColor: Colors.white.withOpacity(0.24),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                GlassContainer(
                  height: 120,
                  width: 120,
                  blur: 4,
                  color: Colors.white.withOpacity(0.7),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.blue.withOpacity(0.3),
                    ],
                  ),
                  //--code to remove border
                  border: const Border.fromBorderSide(BorderSide.none),
                  shadowStrength: 5,
                  shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(16),
                  shadowColor: Colors.white.withOpacity(0.24),
                  child: const Padding(
                      padding: EdgeInsets.only(top: 35, left: 15),
                      child: Header('Sign in')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            controller: _emailController,
                            decoration: const InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(color: Colors.white)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter your email address to continue';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            controller: _passwordController,
                            decoration: const InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.white)),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // const SizedBox(width: 3),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(left: lsMargin),
                                    //   child: StyledButton(
                                    //     onPressed: () {},
                                    //     child: const Text('Register'),
                                    //   ),
                                    // ),
                                    // const SizedBox(width: 16),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: lsMargin, left: lsMargin),
                                      child: StyledButton(
                                        onPressed: () {
                                          widget.selectPage(4);
                                        },
                                        child: const Text(
                                          'REGISTER',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: lsMargin),
                                      child: StyledButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            widget.login(
                                              _emailController.text,
                                              _passwordController.text,
                                            );
                                          }
                                        },
                                        child: const Text(
                                          'SIGN IN',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )

                                    // const SizedBox(width: 3),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextButton(
                                      onPressed: () {
                                        widget.selectPage(5);
                                      },
                                      child: const Text("Forgot password"),
                                    )),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}

class Header extends StatelessWidget {
  const Header(this.heading);
  final String heading;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          heading,
          style: const TextStyle(
              fontSize: 24, color: Colors.white, fontFamily: 'roboto'),
        ),
      );
}

class StyledButton extends StatelessWidget {
  const StyledButton({required this.child, required this.onPressed});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.deepPurple)),
        onPressed: onPressed,
        child: child,
      );
}
