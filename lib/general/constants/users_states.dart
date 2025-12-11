enum UserInvitationState { pending, accepted }

extension RoleStatusDetail on UserInvitationState {
  String get id {
    switch (this) {
      case UserInvitationState.pending:
        return "Pending";
      case UserInvitationState.accepted:
        return "Accepted";
    }
  }
}
