import 'package:equatable/equatable.dart';

class Member extends Equatable {
  static final String _codeKey = 'MemberCode',
      _statusKey = 'Status',
      _nameKey = 'Name',
      _yearKey = 'Year',
      _spouse = 'Spouse';

  final int memberId;
  final String memberCode, memberType, memberStatus, memberName;
  final String memberElectDate, memberBirthDate;
  final bool withSpouse;

  const Member(
      {this.memberId,
      this.memberCode,
      this.memberType,
      this.memberStatus,
      this.memberName,
      this.memberElectDate,
      this.memberBirthDate,
      this.withSpouse});

  factory Member.fromJson(Map<String, dynamic> map) => Member(
      memberCode: map[_codeKey],
      memberName: map[_nameKey],
      memberStatus: map[_statusKey],
      memberElectDate: map[_yearKey].toString());

  Map<String, dynamic> toMap() => {
        _codeKey: memberCode,
        _nameKey: memberName,
        _statusKey: memberStatus,
        _yearKey: memberElectDate,
        _spouse: withSpouse ?? false,
      };

  @override
  String toString() {
    return 'Member{memberId: $memberId, memberNo: $memberCode, memberType: $memberType, memberStatus: $memberStatus, memberName: $memberName, memberElectDate: $memberElectDate, memberBirthDate: $memberBirthDate}';
  }

  @override
  List<Object> get props => [
        memberId,
        memberCode,
        memberType,
        memberStatus,
        memberName,
        memberElectDate,
        memberBirthDate
      ];
}
