import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:moneyger/common/app_theme_data.dart';
import 'package:moneyger/common/color_value.dart';
import 'package:moneyger/common/navigate.dart';
import 'package:moneyger/common/shared_code.dart';
import 'package:moneyger/service/firebase_service.dart';
import 'package:moneyger/ui/auth/login/login.dart';
import 'package:moneyger/ui/widget/custom_text_form_field.dart';
import 'package:moneyger/ui/widget/loading/loading_animation.dart';
import 'package:provider/provider.dart';

class ResetPasswordProfilePage extends StatefulWidget {
  const ResetPasswordProfilePage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordProfilePage> createState() =>
      _ResetPasswordProfilePageState();
}

class _ResetPasswordProfilePageState extends State<ResetPasswordProfilePage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _document =
      FirebaseFirestore.instance.collection('users').doc(SharedCode().uid);
  Map<String, dynamic> _userData = {};

  final ValueNotifier<bool> _isLoad = ValueNotifier<bool>(false);

  Future _getUserData() async {
    var document =
        FirebaseFirestore.instance.collection('users').doc(SharedCode().uid);

    var value = await document.get();
    _userData = value.data() ?? {};
    _emailController.text = _userData['email'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final provider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Kata Sandi',
          style: TextStyle(
            color: provider.isDarkMode
                ? Colors.white
                : ColorValueDark.backgroundColor,
          ),
        ),
        backgroundColor:
            provider.isDarkMode ? ColorValueDark.backgroundColor : Colors.white,
        iconTheme: IconThemeData(
          color: provider.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/verification.png',
                            width: size.width * 0.7,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Lupa Kata Sandi?',
                            style: textTheme.headline2!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Masukkan email yang terkait dengan akun anda dan kami akan mengirimkan email dengan instruksi untuk mengatur ulang kata sandi.',
                            style: textTheme.bodyText1,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          CustomTextFormField(
                            label: 'Masukkan email',
                            controller: _emailController,
                            textInputType: TextInputType.emailAddress,
                            validator: (value) =>
                                SharedCode().emailValidator(value),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _isLoad.value = true;
                                if (mounted) {
                                  await FirebaseService()
                                      .resetPassword(context,
                                          email: _emailController.text.trim())
                                      .then(
                                        (value) => value
                                            ? Navigator.pop(context)
                                            : null,
                                      );
                                }
                                _isLoad.value = false;
                              }
                            },
                            child: const Text('Reset Kata Sandi'),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Kembali ke ',
                              style: textTheme.bodyText1,
                              children: [
                                TextSpan(
                                  text: 'Profil',
                                  style: textTheme.bodyText1!.copyWith(
                                    color: provider.isDarkMode
                                        ? ColorValueDark.secondaryColor
                                        : ColorValue.secondaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _isLoad,
              builder: (context, value, _) => Visibility(
                visible: value,
                child: const LoadingAnimation(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
