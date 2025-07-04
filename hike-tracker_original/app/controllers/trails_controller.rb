class TrailsController < ApplicationController
  before_action :set_trail, only: %i[ show edit update destroy ]

  # GET /trails or /trails.json
  def index
    @trails = Trail.all
  end

  # GET /trails/1 or /trails/1.json
  def show
  end

  # GET /trails/new
  def new
    @trail = Trail.new
  end

  # GET /trails/1/edit
  def edit
  end

  # POST /trails or /trails.json
  def create
    @trail = Trail.new(trail_params)

    respond_to do |format|
      if @trail.save
        format.html { redirect_to @trail, notice: "Trail was successfully created." }
        format.json { render :show, status: :created, location: @trail }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trails/1 or /trails/1.json
  def update
    respond_to do |format|
      if @trail.update(trail_params)
        format.html { redirect_to @trail, notice: "Trail was successfully updated." }
        format.json { render :show, status: :ok, location: @trail }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @trail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trails/1 or /trails/1.json
  def destroy
    @trail.destroy!

    respond_to do |format|
      format.html { redirect_to trails_path, status: :see_other, notice: "Trail was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trail
      @trail = Trail.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def trail_params
      params.expect(trail: [ :name, :location, :length, :elevation, :description ])
    end
end
