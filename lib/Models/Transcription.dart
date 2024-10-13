class Transcription {
  int _id;
  double _startPoint;
  double _endPoint;
  String _fileName;
  String Text;
  String _speaker;

  Transcription(this._id, this._startPoint, this._endPoint, this._fileName,
      this.Text, this._speaker);

  String get fileName => _fileName;

  String get speaker => _speaker;

  double get endPoint => _endPoint;

  double get startPoint => _startPoint;

  int get id => _id;
}
