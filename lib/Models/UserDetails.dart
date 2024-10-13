class UserDetails {
  String _name;
  String _id;
  String _email;
  String _url;
  String _subscription_plan;
  int _total_meeting_credit;
  double _meeting_credit_consumed;
  int _total_meeting_hours;
  double _meeting_hours_consumed;
  int _no_offline_total;
  int _no_upload_total;
  int _no_offline_consumed;
  int _no_upload_consumed;

  UserDetails(
      this._name,
      this._id,
      this._email,
      this._url,
      this._subscription_plan,
      this._total_meeting_credit,
      this._meeting_credit_consumed,
      this._total_meeting_hours,
      this._meeting_hours_consumed,
      this._no_offline_total,
      this._no_offline_consumed,
      this._no_upload_total,
      this._no_upload_consumed);

  String getName() {
    return _name;
  }

  String getId() {
    return _id;
  }

  String getEmail() {
    print("inside get email $_email");
    return _email;
  }

  String getUrl() {
    return _url;
  }

  String getSubscription_plan() {
    return _subscription_plan;
  }

  setName(String value) {
    _name = value;
  }

  setSubscription_plan(String value) {
    _subscription_plan = value;
  }

  double getMeeting_credit_consumed() {
    return _meeting_credit_consumed;
  }

  double getMeeting_hours_consumed() {
    return _meeting_hours_consumed;
  }

  void setMeeting_credit_consumed(double consumed) {
    this._meeting_credit_consumed = consumed;
  }

  void setMeeting_hours_consumed(double consumed) {
    this._meeting_hours_consumed = consumed;
  }
  int getTotal_meeting_credit() {
    return _total_meeting_credit;
  }

  int getTotal_meeting_hours() {
    return _total_meeting_hours;
  }

  void setTotalMeeting_credit(int consumed) {
    this._total_meeting_credit = consumed;
  }

  void setTotal_meeting_hours(int total) {
    this._total_meeting_hours = total;
  }

  int getNo_offline_total() {
    return _no_offline_total;
  }
  void setNo_offline_total(int total){
    this._no_offline_total = total;
  }
  void setNo_upload_total(int total){
    this._no_upload_total = total;
  }
  void setNo_offline_consumed(int consumed){
    this._no_offline_consumed = consumed;
  }
  void setNo_upload_consumed(int consumed){
    this._no_upload_consumed = consumed;
  }

  int getNo_upload_total() {
    return _no_upload_total;
  }
  int getNo_offline_consumed() {
    return _no_offline_consumed;
  }

  int getNo_upload_consumed() {
    return _no_upload_consumed;
  }
}
