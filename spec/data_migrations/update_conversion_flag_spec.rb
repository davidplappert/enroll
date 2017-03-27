require "rails_helper"
require File.join(Rails.root, "app", "data_migrations", "update_conversion_flag")

describe UpdateConversionFlag do

  let(:given_task_name) { "update_conversion_flag" }
  subject { UpdateConversionFlag.new(given_task_name, double(:current_scope => nil)) }

  describe "given a task name" do
    it "has the given task name" do
      expect(subject.name).to eql given_task_name
    end
  end

  describe "updating conversion flag of employer" do
    
    let(:organization) { FactoryGirl.create(:organization, employer_profile: employer_profile)}
    let(:employer_profile) { FactoryGirl.create(:employer_profile, profile_source: "conversion")}

    before(:each) do
      allow(ENV).to receive(:[]).with("fein").and_return(organization.fein)
      allow(ENV).to receive(:[]).with("profile_source").and_return("self_serve")
    end

    it "should update conversion flag" do
      subject.migrate
      organization.reload
      expect(organization.employer_profile.profile_source).to eq ("self_serve")
    end
  end
end
