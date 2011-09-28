module UsersHelper
  def user_protected_profile?(user, attrubute)
    User::PROTECTED_PROFILE_ATTRBUTES.include? attrubute.to_s
  end
  
  def greek_affiliation
     @user.male? ? "#{@user.fraternity}" : "#{@user.sorority}"
  end
  
  def sybling_type
    @user.male? ? "brother" : "sister"
  end
end
