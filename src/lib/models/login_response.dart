class LoginResponse {
  String? username;
  String? emailAddress;
  RefreshToken? refreshToken;
  String? accessToken;

  LoginResponse({this.username, this.emailAddress, this.refreshToken, this.accessToken});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    emailAddress = json['emailAddress'];
    refreshToken = json['refreshToken'] != null
        ? new RefreshToken.fromJson(json['refreshToken'])
        : null;
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['emailAddress'] = this.emailAddress;
    if (this.refreshToken != null) {
      data['refreshToken'] = this.refreshToken?.toJson();
    }
    data['accessToken'] = this.accessToken;
    return data;
  }
}

class RefreshToken {
  String? token;
  String? expires;
  bool? isExpired;
  String? created;
  String? createdByIp;
  bool? revoked;
  String? revokedByIp;
  String? replacedByToken;
  bool? isActive;

  RefreshToken(
      {this.token,
        this.expires,
        this.isExpired,
        this.created,
        this.createdByIp,
        this.revoked,
        this.revokedByIp,
        this.replacedByToken,
        this.isActive});

  RefreshToken.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expires = json['expires'];
    isExpired = json['isExpired'];
    created = json['created'];
    createdByIp = json['createdByIp'];
    revoked = json['revoked'];
    revokedByIp = json['revokedByIp'];
    replacedByToken = json['replacedByToken'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expires'] = this.expires;
    data['isExpired'] = this.isExpired;
    data['created'] = this.created;
    data['createdByIp'] = this.createdByIp;
    data['revoked'] = this.revoked;
    data['revokedByIp'] = this.revokedByIp;
    data['replacedByToken'] = this.replacedByToken;
    data['isActive'] = this.isActive;
    return data;
  }
}
