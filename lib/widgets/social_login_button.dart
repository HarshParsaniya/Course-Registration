import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback onPressed;
  final bool isLoading;
  
  const SocialLoginButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Use a placeholder icon since we don't have the actual assets
          Icon(
            icon.contains('google') ? Icons.g_mobiledata : Icons.facebook,
            size: 24,
            color: icon.contains('google') ? Colors.red : Colors.blue,
          ),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

