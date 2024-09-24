import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:cryptography/cryptography.dart';

import 'package:solana/solana.dart';

class KeyPairModel {
  final bool isSolona;
  final String publicKey;
  final String privateKey;

  KeyPairModel(
      {required this.isSolona,
      required this.publicKey,
      required this.privateKey});
}

int currentIndex = 0;

Future<KeyPairModel> solonaaddWallet(String mnemonic) async {
  if (mnemonic.isEmpty) {
    return KeyPairModel(publicKey: "", privateKey: "", isSolona: true);
  }
  if (!bip39.validateMnemonic(mnemonic)) {
    return KeyPairModel(publicKey: "", privateKey: "", isSolona: true);
  }
  final seed = bip39.mnemonicToSeed(mnemonic);
  final path = "m/44'/501'/$currentIndex'/0'";
  // Generate the master key from the seed
  final masterKey = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);

  // Derive the key from the master key using the specified path
  final derivedKey = await ED25519_HD_KEY.derivePath(path, masterKey.key);

  // Generate the key pair from the derived seed
  final algorithm = Ed25519();
  final keyPair = await algorithm.newKeyPairFromSeed(derivedKey.key);

// Extract public and private keys
  final publicKey = await keyPair.extractPublicKey();
  final privateKey = await keyPair.extractPrivateKeyBytes();

  // Encode the public and private keys to hex strings
  final publicKeyHex = HEX.encode(publicKey.bytes);
  final privateKeyHex = HEX.encode(privateKey);

  // Increment the current index for the next wallet
  currentIndex++;

  // Return the key pair
  return KeyPairModel(
      publicKey: publicKeyHex, privateKey: privateKeyHex, isSolona: true);
}
