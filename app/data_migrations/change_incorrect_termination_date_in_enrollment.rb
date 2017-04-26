require File.join(Rails.root, "lib/mongoid_migration_task")

class ChangeIncorrectTerminationDateInEnrollment < MongoidMigrationTask

  def migrate
    begin
      enrollment = HbxEnrollment.by_hbx_id(ENV['hbx_id'].to_s).first
      new_termination_date = ENV['termination_date']

      if enrollment.nil?
        puts "No enrollment with given hbx_id was found" unless Rails.env.test?
      elsif enrollment.aasm_state != "coverage_terminated"
        puts "The enrollment is not in terminated state" unless Rails.env.test?
      else
        enrollment.update_attributes(terminated_on: new_termination_date)
        puts "Changed Enrollment termination date to #{new_termination_date}" unless Rails.env.test?
      end

    rescue Exception => e
      puts e.message
    end
  end

end