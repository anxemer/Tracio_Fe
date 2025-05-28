import 'package:flutter/material.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:flutter/services.dart';

class InputTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final bool isSecureField;
  final bool autoCorrect;
  final String? hint;
  final EdgeInsets? contentPadding;
  final String? Function(String?)? validation;
  final double hintTextSize;
  final bool enable;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final String labelText;
  final Widget? prefixIcon;
  final Function? ontap;
  final TextInputType? keyBoardType;
  final int? maxLine;
  const InputTextFormField({
    super.key,
    required this.controller,
    this.isSecureField = false,
    this.autoCorrect = false,
    this.enable = true,
    this.hint,
    this.validation,
    this.contentPadding,
    this.textInputAction,
    this.hintTextSize = 14,
    this.onFieldSubmitted,
    required this.labelText,
    this.prefixIcon,
    this.ontap,
    this.keyBoardType,
    this.maxLine,
  });

  @override
  State<InputTextFormField> createState() => _InputTextFormFieldState();
}

class _InputTextFormFieldState extends State<InputTextFormField> {
  bool _passwordVisible = false;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-ZÀ-ỹà-ỹ0-9\s\.\,\!\?\-@#\$%&\*\(\)]'),
          ),
        ],
        maxLines: widget.maxLine,
        keyboardType: widget.keyBoardType,
        onTap: widget.ontap != null ? () => widget.ontap!() : null,
        focusNode: _focusNode,
        controller: widget.controller,
        obscureText: widget.isSecureField && !_passwordVisible,
        enableSuggestions: !widget.isSecureField,
        autocorrect: widget.autoCorrect,
        validator: widget.validation,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        enabled: widget.enable,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        onTapOutside: (_) {
          _focusNode.unfocus();
        },
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          labelText: _isFocused ? widget.labelText : null,
          labelStyle: TextStyle(
            color: Colors.orange,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          hintText: _isFocused ? null : widget.hint,
          hintStyle: TextStyle(
            fontSize: widget.hintTextSize,
          ),
          contentPadding: widget.contentPadding,
          suffixIcon: widget.isSecureField
              ? IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
