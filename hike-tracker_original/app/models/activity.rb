class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :trail

  attribute :in_progress, :boolean, default: true
  attribute :start_time, default: Time.now

  validates :end_time, absence: { if: :in_progress?, message: '- It looks like this activity is still in progress. Uncheck the "In Progress" box to add your end time.' }
  validates :name, presence: true

  after_save :check_progress, :check_end_time

  def duration
    if end_time
      ActiveSupport::Duration.build(end_time - start_time)
    else
      ActiveSupport::Duration.build(Time.now - start_time)
    end
  end

  private

  def check_progress
    in_progress = false if end_time && in_progress
  end

  def check_end_time
    end_time = Time.now if !in_progress && end_time.nil?
  end
end
