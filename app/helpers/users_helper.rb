module UsersHelper
  def user_protected_profile?(user, attrubute)
    User::PROTECTED_PROFILE_ATTRBUTES.include? attrubute.to_s
  end
end
