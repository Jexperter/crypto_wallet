import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/ecb.dart';


abstract class WalletAddressService {
  String generateMnemonic();
  Future<String> getPrivateKey(String mnemonic);
  Future<EthereumAddress> getPublicKey(String privateKey);
}

class WalletProvider extends ChangeNotifier implements WalletAddressService {
  String? privateKey;
  final int shares = 5; // Number of shares to split the private key into
  final int threshold = 3; // Number of shares required to reconstruct private key

  Future<void> loadPrivateKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    privateKey = prefs.getString('privateKey');
  }

  Future<void> setPrivateKey(String privateKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('privateKey', privateKey);
    this.privateKey = privateKey;
    notifyListeners();
  }

  @override
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  @override
  Future<String> getPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privateKey = HEX.encode(master.key);

    // Encrypt the private key
    final encryptedPrivateKey = _encryptPrivateKey(privateKey);

    // Split the encrypted private key into shares
    final shares = _splitPrivateKey(encryptedPrivateKey);

    // Store the shares securely (e.g., distribute between users and service)
    _storeShares(shares);

    await setPrivateKey(privateKey);

    return privateKey;
  }

  @override
  Future<EthereumAddress> getPublicKey(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.address;
    return address;
  }

  String _encryptPrivateKey(String privateKey) {
    // Generate a random 128-bit encryption key
    final random = Random.secure();
    final key = List.generate(16, (index) => random.nextInt(256));

    // Initialize AES block cipher with ECB mode
    final cipher = ECBBlockCipher(AESFastEngine())
      ..init(true, crypto.KeyParameter(Uint8List.fromList(key)));

    // Encrypt the private key using AES with ECB mode
    final paddedPrivateKey = _padWithPkcs7(privateKey.codeUnits);
    final encryptedBytes = cipher.process(paddedPrivateKey);

    // Return the encrypted private key as a base64-encoded string
    return base64.encode(encryptedBytes);
  }

  List<String> _splitPrivateKey(String encryptedPrivateKey) {
    // Split the encrypted private key into shares using a secret sharing scheme (e.g., Shamir's Secret Sharing)
    // Implementation of secret sharing scheme goes here...

    // For demonstration, split into equal parts (threshold + shares)
    final shares = List.generate(this.shares, (index) => 'Share ${index + 1}');
    return shares;
  }

  void _storeShares(List<String> shares) {
    // Store the shares securely (e.g., distribute between users and service)
    // Implementation of secure storage goes here...
  }

  Uint8List _padWithPkcs7(List<int> data) {
  final blockSize = AESFastEngine().blockSize;
  final paddingLength = blockSize - (data.length % blockSize);
  final padding = Uint8List(paddingLength);
  padding.fillRange(0, padding.length, paddingLength);
  return Uint8List.fromList([...data, ...padding]);
}


}
