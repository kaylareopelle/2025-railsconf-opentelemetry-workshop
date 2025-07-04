class CommentsController < ApplicationController
  before_action :set_trail

  def create
    @trail.comments.create! params.expect(comment: [ :content ])
    redirect_to @trail
  end

  private

  def set_trail
    @trail = Trail.find(params[:trail_id])
  end
end
