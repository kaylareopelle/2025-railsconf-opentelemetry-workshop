json.extract! activity, :id, :start_time, :end_time, :user_id, :trail_id, :in_progress, :name, :created_at, :updated_at
json.url activity_url(activity, format: :json)
