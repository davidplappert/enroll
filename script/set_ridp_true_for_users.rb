# we still need this commented out code.

# def curam_user?(family)
#   family.e_case_id.present? && !(family.e_case_id.include? "curam_landing") if family.present?
# end

def user_having_enrollments?(person)
  if person.primary_family.present? && person.primary_family.active_household.present?
    person.primary_family.active_household.hbx_enrollments.where(kind: 'individual').present?
  end
end

# def consumer_role_boomarked?(person)
#   person.consumer_role.bookmark_url == "/families/home"
# end


# Person.all_consumer_roles.each do |person|
#   begin
#     if person.user && !person.user.identity_verified? && person.primary_family.present?
#       if curam_user?(person) || user_prior_to_enroll?(person) || consumer_role_boomarked?(person)
#         person.user.update_attributes(:identity_final_decision_code => USER::INTERACTIVE_IDENTITY_VERIFICATION_SUCCESS_CODE)
#       end
#     end
#   rescue
#     puts "Bad person record #{person.id}"
#   end
# end

# Addressing the records imported from curam & having enrollments on 10/11/2015(All these records )
start_date = Date.new(2015,10,10)
end_date = Date.new(2015,10,12)
count = 0
Person.all_consumer_roles.where(:"created_at" => { "$gt" => start_date, "$lt" => end_date}, :user => {:$exists => true}).each do |person|
  begin
    if !person.user.identity_verified?
      if user_having_enrollments?(person)
        person.user.update_attributes(:identity_final_decision_code => User::INTERACTIVE_IDENTITY_VERIFICATION_SUCCESS_CODE, :identity_response_description_text => 'curam_data_migration')
        count +=1
      end
    end
  rescue
    puts "Bad person record #{person.id}"
  end
end
puts "Total effected users created on 10/11/2015 are #{count}"

