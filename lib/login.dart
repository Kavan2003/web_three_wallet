import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/services.dart';
import 'package:web_three_wallet/main.dart';
import 'package:web_three_wallet/memonic.dart';
import 'package:web_three_wallet/wallet.dart';

class Login extends StatefulWidget {
  final VoidCallback toggleThemeMode;
  const Login({super.key, required this.toggleThemeMode});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController memonicController =
      TextEditingController(text: "");
  String memonic = "";
  List<KeyPairModel> keyPairs = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kavan Wallet'),
          actions: [
            IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              onPressed: widget.toggleThemeMode,
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [Colors.teal.shade900, Colors.teal.shade700]
                  : [Colors.teal.shade300, Colors.teal.shade100],
            ),
          ),
          child: Center(
            child: memonic.isNotEmpty
                ? Column(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          color: Colors.transparent,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: MnemonicDisplay(
                                      mnemonic: memonic,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        if (!loading) {
                                          setState(() {
                                            loading = true;
                                          });

                                          final newKeyPair =
                                              await solonaaddWallet(memonic);

                                          setState(() {
                                            loading = false;
                                            keyPairs.removeLast();
                                            keyPairs.add(newKeyPair);
                                          });
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'img/solana.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                          const Text('Add Solona Wallet'),
                                          loading
                                              ? const CircularProgressIndicator()
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                    // TextButton(
                                    //   onPressed: () async {},
                                    //   child: Row(
                                    //     children: [
                                    //       Image.asset(
                                    //         'img/etherum.png',
                                    //         width: 30,
                                    //         height: 30,
                                    //       ),
                                    //       const Text('Add Etherum Wallet'),
                                    //       loading
                                    //           ? const CircularProgressIndicator()
                                    //           : const SizedBox(),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                                loading
                                    ? const CircularProgressIndicator()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: keyPairs.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: keyPairs[index].privateKey ==
                                                    "privateKey"
                                                ? const CircularProgressIndicator()
                                                : Column(
                                                    children: [
                                                      ListTile(
                                                        leading: keyPairs[index]
                                                                .isSolona
                                                            ? Image.asset(
                                                                'img/solana.png',
                                                                width: 30,
                                                                height: 30)
                                                            : Image.asset(
                                                                'img/etherum.png',
                                                                width: 30,
                                                                height: 30),
                                                        title: Text(
                                                            'Public Key: ${keyPairs[index].publicKey}'),
                                                        subtitle: Text(
                                                            'Private Key: ${keyPairs[index].privateKey}'),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              Clipboard.setData(
                                                                  ClipboardData(
                                                                      text: keyPairs[
                                                                              index]
                                                                          .publicKey));
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'Public Key copied to clipboard')),
                                                              );
                                                            },
                                                            icon: const Icon(
                                                                Icons.copy),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                keyPairs
                                                                    .removeAt(
                                                                        index);
                                                              });
                                                            },
                                                            icon: const Icon(
                                                                Icons.delete),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                          );
                                        },
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      TextField(
                        controller: memonicController,
                        decoration: const InputDecoration(
                          hintText:
                              'Enter your Memonic or Leave Empty to Generate New one',
                        ),
                      ),
                      memonicController.text.isEmpty
                          ? TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  memonic = bip39.generateMnemonic();
                                  memonicController.text = memonic;
                                });
                              },
                              label: const Text('Generate New Wallet'),
                              icon:
                                  const Icon(Icons.format_color_text_outlined))
                          : TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  memonic = memonicController.text;
                                });
                              },
                              label: const Text("Add Wallet"),
                              icon: const Icon(Icons.add)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
