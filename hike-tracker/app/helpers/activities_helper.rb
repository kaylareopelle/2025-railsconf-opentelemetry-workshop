module ActivitiesHelper
  def in_progress_text(activity)
    activity.in_progress ? "In Progress" : "Complete"
  end
end
