import 'dart:convert';
import 'package:minute_matrix/widgets/meeting_detail_screen/audio_search_dialogue.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../Models/Transcription.dart';
import '../Providers/user_provider.dart';
import '../widgets/meeting_detail_screen/edit_dialogue_widget.dart';
import '../widgets/meeting_detail_screen/update_summary_dialogue.dart';

class TranscriptionScreen extends StatefulWidget {
  final _meetingName;
  final _meetingType;
  var getDialogueTime;
  final bool canEdit;

  TranscriptionScreen(
      this._meetingName, this._meetingType, this.getDialogueTime, this.canEdit);

  @override
  State<TranscriptionScreen> createState() => _TranscriptionScreenState();
}

class _TranscriptionScreenState extends State<TranscriptionScreen> {
  List<Transcription> _meetingTranscriptionDialogue = [];
  List<Transcription>? _tempMeetingTranscriptionDialogue;
  bool? doReload;
  bool? saveTemp;
  bool isSearch = false;
  final TextEditingController searchController = TextEditingController();

  getMeetingTranscriptionDialogues() async {
    _meetingTranscriptionDialogue.clear();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _meetingTranscriptionDialogue = await userProvider.getMeetingTranscription(
        widget._meetingName, widget._meetingType);
    // setState(() {});
  }

  updateMeetingTranscriptionDialogue(
      int index, int sequence, String updatedText) async {
    bool result = await Provider.of<UserProvider>(context, listen: false)
        .updateDialogueText(
            widget._meetingName, widget._meetingType, sequence, updatedText);
    if (result) {
      Navigator.of(context).pop();
      showSnackBar("dialogue updated successfully");
      setState(() {
        _meetingTranscriptionDialogue[index].Text = updatedText;
      });
    } else {
      showSnackBar("unable to update dialogue");
    }
  }

  showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  List<Transcription> findMostSimilarTranscription(String searchText) {
    // working
    // String searchText = "it should walking it's very";
    Transcription? mostSimilarTranscription;
    double highestSimilarity = 0.0;
    List<Transcription> matches = [];

    for (var transcription in _meetingTranscriptionDialogue) {
      // Calculate the similarity score
      double similarity = searchText.similarityTo(transcription.Text);

      // Update the most similar transcription if the current one has a higher similarity score
      if (similarity > highestSimilarity) {
        highestSimilarity = similarity;
        mostSimilarTranscription = transcription;
      }
    }
    print("Result of string similarity : ${mostSimilarTranscription!.Text}");
    matches.add(mostSimilarTranscription);
    return matches;
    // List<Transcription> matches = [];
    // double similarityThreshold = 0.6;
    // //String searchText = "hello are ou";
    // for (var transcription in _meetingTranscriptionDialogue) {
    //   // Calculate the similarity score
    //   double similarity = searchText.similarityTo(transcription.Text);
    //
    //   // If the similarity is above the threshold, add it to the matches list
    //   if (similarity >= similarityThreshold) {
    //     matches.add(transcription);
    //   }
    // }
    //
    // return matches;
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    //getMeetingTranscriptionDialogues();
    doReload = true;
    saveTemp = true;
  }

  void _filterTranscriptions(String query) {
    if (saveTemp!) {
      _tempMeetingTranscriptionDialogue = _meetingTranscriptionDialogue;
    }
    if (query.isEmpty) {
      setState(() {
        _meetingTranscriptionDialogue = _tempMeetingTranscriptionDialogue!;
        saveTemp = true;
      });
    } else {
      saveTemp = false;
      setState(() {
        _meetingTranscriptionDialogue = _meetingTranscriptionDialogue
            .where((transcription) =>
                transcription.Text.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _filterTranscriptionByAudio(String query) {
    if (saveTemp!) {
      _tempMeetingTranscriptionDialogue = _meetingTranscriptionDialogue;
    }
    if (query.isEmpty) {
      setState(() {
        _meetingTranscriptionDialogue = _tempMeetingTranscriptionDialogue!;
        saveTemp = true;
        isSearch = false;
      });
    } else {
      saveTemp = false;
      setState(() {
        isSearch = true;
        _meetingTranscriptionDialogue = findMostSimilarTranscription(query);
      });
    }
  }

  translateDialogue(String oldText, int index, String languageCode) async {
    final url = Uri.https('translate281.p.rapidapi.com', '/');

    final request = http.MultipartRequest('POST', url)
      ..headers['x-rapidapi-key'] =
          'd857eccab6msh842ead81c1d627ap1ce70fjsncbcb9d9a7649'
      ..headers['x-rapidapi-host'] = 'translate281.p.rapidapi.com'
      ..fields['text'] = oldText
      ..fields['from'] = 'auto'
      ..fields['to'] = languageCode;

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();
    print(responseBody);
    final responseJson = jsonDecode(responseBody);
    print(responseJson["response"]);

    _meetingTranscriptionDialogue[index].Text = responseJson["response"];
    Navigator.of(context).pop();
  }

  void _showModalBottomSheet(BuildContext context, String oldText, int ind) {
    final Map<String, String> languages = {
      'Amharic': 'am',
      'Arabic': 'ar',
      'Basque': 'eu',
      'Bengali': 'bn',
      'English (UK)': 'en-GB',
      'Portuguese (Brazil)': 'pt-BR',
      'Bulgarian': 'bg',
      'Catalan': 'ca',
      'Cherokee': 'chr',
      'Croatian': 'hr',
      'Czech': 'cs',
      "Danish": "da",
      "Dutch": "nl",
      "English (US)": "en",
      "Estonian": "et",
      "Filipino": "fil",
      "Finnish": "fi",
      "French": "fr",
      "German": "de",
      "Greek": "el",
      "Gujarati": "gu",
      "Hebrew": "iw",
      "Hindi": "hi",
      "Hungarian": "hu",
      "Icelandic": "is",
      "Indonesian": "id",
      "Italian": "it",
      "Japanese": "ja",
      "Kannada": "kn",
      "Korean": "ko",
      "Latvian": "lv",
      "Lithuanian": "lt",
      "Malay": "ms",
      "Malayalam": "ml",
      "Marathi": "mr",
      "Norwegian": "no",
      "Polish": "pl",
      "Portuguese (Portugal)": "pt-PT",
      "Romanian": "ro",
      "Russian": "ru",
      "Serbian": "sr",
      "Chinese (PRC)": "zh-CN",
      "Slovak": "sk",
      "Slovenian": "sl",
      "Spanish": "es",
      "Swahili": "sw",
      "Swedish": "sv",
      "Tamil": "ta",
      "Telugu": "te",
      "Thai": "th",
      "Chinese (Taiwan)": "zh-TW",
      "Turkish": "tr",
      "Urdu": "ur",
      "Ukrainian": "uk",
      "Vietnamese": "vi",
      "Welsh": "cy"
    };
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          //height: 300,
          child: ListView.builder(
            itemCount: languages.length,
            itemBuilder: (BuildContext context, int index) {
              String key = languages.keys.elementAt(index);
              return ListTile(
                title: Text(key),
                onTap: () {
                  print(languages[key]);
                  translateDialogue(oldText, ind, languages[key]!);
                },
              );
            },
          ),
        );
      },
    ).then((value) {
      // Handle the returned value
      if (value != null) {
        print("Selected language code: $value");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: doReload! ? getMeetingTranscriptionDialogues() : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SizedBox(child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Unable to retrieve meeting transcription"),
            );
          } else {
            return _meetingTranscriptionDialogue.isEmpty
                ? const SizedBox(
                    height: 150,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                          "No meeting transcription found against this meeting Try again later"),
                    ))
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: SearchBar(
                          onTap: () {
                            setState(() {
                              doReload = false;
                            });
                          },
                          controller: searchController,
                          hintText: "Search Dialogue by Text",
                          onChanged: (value) {
                            setState(() {
                              doReload = false;
                            });
                            _filterTranscriptions(value);
                          },
                          leading: IconButton(
                            onPressed: () {
                              setState(() {
                                doReload = false;
                              });

                              !isSearch
                                  ?
                                  // findMostSimilarTranscription("");
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AudioSearchDialogue(
                                            _filterTranscriptionByAudio);
                                      })
                                  : _filterTranscriptionByAudio("");
                            },
                            icon: !isSearch
                                ? Icon(Icons.mic)
                                : Icon(Icons.cancel),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _meetingTranscriptionDialogue.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              isThreeLine: true,
                              leading: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        doReload = true;
                                      });
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            UpdateSummaryDialogue(
                                                "Update Speaker Name",
                                                widget._meetingType,
                                                widget._meetingName,
                                                _meetingTranscriptionDialogue[
                                                        index]
                                                    .speaker,
                                                false),
                                      );
                                    },
                                    child: Text(
                                      _meetingTranscriptionDialogue[index]
                                          .speaker
                                          .substring(0, 1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _meetingTranscriptionDialogue[index]
                                        .speaker,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          widget.getDialogueTime(
                                              _meetingTranscriptionDialogue[
                                                      index]
                                                  .startPoint
                                                  .toInt());
                                        },
                                        icon: Icon(
                                          Icons.play_circle,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            doReload = false;
                                          });
                                          _showModalBottomSheet(
                                              context,
                                              _meetingTranscriptionDialogue[
                                                      index]
                                                  .Text,
                                              index);
                                        },
                                        icon: Icon(
                                          Icons.translate,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      widget.canEdit
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  doReload = true;
                                                });
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => EditDialogueWidget(
                                                      index,
                                                      _meetingTranscriptionDialogue[
                                                              index]
                                                          .id,
                                                      _meetingTranscriptionDialogue[
                                                              index]
                                                          .Text,
                                                      updateMeetingTranscriptionDialogue),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                _meetingTranscriptionDialogue[index].Text,
                              ),
                              //"This is to test the dialogue of the system to make sure it accopy the nessary space which i wanna test it out"),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 110,
                      ),
                    ],
                  );
          }
        });
  }
}
