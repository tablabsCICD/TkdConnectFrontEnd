import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseLanguagePage extends StatelessWidget {
  final List<Language> languages = [
    Language('E', 'English', Colors.green),
    Language('ह', 'हिंदी', Colors.amber),
    Language('తె', 'తెలుగు', Colors.orange),
    Language('म', 'मराठी', Colors.purple),
    Language('த', 'தமிழ்', Colors.blue),
    Language('ગુ', 'ગુજરાતી', Colors.red),
    Language('ಕ', 'ಕನ್ನಡ', Colors.cyan),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Select a language',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.8,
                ),
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  return _buildLanguageCard(context, lang);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, Language lang) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: ${lang.name}')),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: lang.color, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              lang.symbol,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            lang.name,
            style: TextStyle(fontSize: 14, color: Colors.black87,fontFamily: GoogleFonts.poppins().fontFamily),
          ),
        ],
      ),
    );
  }
}

class Language {
  final String symbol;
  final String name;
  final Color color;

  Language(this.symbol, this.name, this.color);
}
