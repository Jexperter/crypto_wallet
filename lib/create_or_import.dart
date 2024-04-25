import 'package:flutter/material.dart';
import 'package:web3_wallet/generate_mnemonic_page.dart';
import 'package:web3_wallet/import_wallet.dart';
//import 'package:web3auth_flutter/web3auth_flutter.dart';
//import 'package:single_factor_auth_flutter/single_factor_auth_flutter.dart';

class CreateOrImportPage extends StatelessWidget {
  const CreateOrImportPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 150, 255, 1), // Set background color to RGB(0,150,255)
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              alignment: Alignment.center,
              child: const Text(
                'SMPC Wallet',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Logo
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  'pics/Jesan.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 45.0),

            // Login button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenerateMnemonicPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Change button background color to green
                foregroundColor: Colors.white, // Customize button text color
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
                'Create Wallet',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),

            const SizedBox(height: 12.0),

            // Register button
            ElevatedButton(
              onPressed: () {
                // Add your register logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ImportWallet(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.white, // Customize button background color
                foregroundColor: Colors.black, // Customize button text color
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
                'Import from Seed',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),

            const SizedBox(height: 20.0),

            // Footer
            Container(
              alignment: Alignment.center,
              child: const Text(
                'COMP390 Dissertation',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
