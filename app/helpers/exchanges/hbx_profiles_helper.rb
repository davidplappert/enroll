module Exchanges
  module HbxProfilesHelper
    def get_person_roles(person, person_roles = [])
      person_roles << "Employee Role" if person.active_employee_roles.present?
      person_roles << "Consumer Role" if person.consumer_role.present?
      person_roles << "Hbx Staff Role" if person.hbx_staff_role.present?
      person_roles << "Assister Role" if person.assister_role.present?
      person_roles << "CSR Role" if person.csr_role.present?
      person_roles << "POC" if person.employer_staff_roles.present?
      person_roles << "Broker Agency Staff Role" if person.broker_agency_staff_roles.present?
      person_roles << "General Agency Staff Role" if person.general_agency_staff_roles.present?
      person_roles
    end

    def can_cancel_employer_plan_year?(employer_profile)
      ['published', 'enrolling', 'enrolled'].include?(employer_profile.active_plan_year.aasm_state)
    end

    def employee_eligibility_status(enrollment)
      if enrollment.is_shop? && enrollment.benefit_group_assignment.present?
        if enrollment.benefit_group_assignment.census_employee.can_be_reinstated?
          enrollment.benefit_group_assignment.census_employee.aasm_state.camelcase
        end
      end
    end
  end
end
