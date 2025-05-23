import 'package:flutter/material.dart';

class InputFieldAuth extends StatelessWidget {
  const InputFieldAuth(
      {super.key,
      required this.hintText,
      required this.prefixIcon,
      this.suffixIconl,
      this.textController,
      this.enale,
      this.obscureText});
  final TextEditingController? textController;
  final String hintText;
  final Widget prefixIcon;
  final Widget? suffixIconl;
  final bool? enale;
  final bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        // color: AppColors.secondBackground,
        // height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 15))
            ]),
        child: TextField(
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          obscureText: obscureText ?? false,
          obscuringCharacter: '*',
          enabled: enale,
          controller: textController,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              // border: OutlineInputBorder(
              //     borderSide: BorderSide(
              //         color: const Color.fromARGB(255, 0, 0, 0), width: 2)),
              filled: true,
              suffixIcon: suffixIconl,
              prefixIcon: prefixIcon,
              hintText: hintText,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 15)),
        ),
      ),
    );
  }
}
