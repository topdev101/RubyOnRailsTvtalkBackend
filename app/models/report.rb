# == Schema Information
#
# Table name: reports
#
#  id              :bigint           not null, primary key
#  message         :string
#  reportable_type :string           not null
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  reportable_id   :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_reports_on_reportable_type_and_reportable_id  (reportable_type,reportable_id)
#  index_reports_on_user_id                            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Report < ApplicationRecord
  belongs_to :user
  belongs_to :reportable, polymorphic: true
  before_validation :normalize_reportable_type
  after_create :notify_admin

  def notify_admin
    ReportMailer.with(report: self).report_content.deliver_now
  rescue => e
    puts "There was an email sending the report content email"
    puts e.backtrace
  end

  private

  # In case the API doens't send properly capitalized params
  def normalize_reportable_type
    self.reportable_type = self.reportable_type.camelize
  end
end
