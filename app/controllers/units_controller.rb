class UnitsController < ApplicationController
  before_action :set_unit, only: %i[ show edit update destroy ]
  before_action :unit_pundit, only: [:show,:create,:update,:destroy]
  # GET /units or /units.json
  def index
    @units = Unit.all
  end

  # GET /units/1 or /units/1.json
  def show
    @unit = Unit.find(name: params.fetch(:id))
    format.js do
      render template: "units/unit.js.erb"
    end
    #puts "#{@unit.name}"
  end
  def show 
    @unit = Unit.find(params.fetch(:id))
  end
  # GET /units/new
  def new
    @unit = Unit.new
  end

  # GET /units/1/edit
  def edit
    @unit = Unit.where(params.fetch("id")).first
  end

  # POST /units or /units.json
  def create
    @unit = Unit.new(unit_params)

    respond_to do |format|
      if @unit.save
        format.html { redirect_to unit_url(@unit), notice: "Unit was successfully created." }
        format.json { render :show, status: :created, location: @unit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1 or /units/1.json
  def update
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to unit_url(@unit), notice: "Unit was successfully updated." }
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1 or /units/1.json
  def destroy
    @unit.destroy

    respond_to do |format|
      format.html { redirect_to units_url, notice: "Unit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def unit_params
      params.require(:unit).permit(:id, :name, :role, :cost, :faction_id, :max_size, :base_size, :picture)
    end
    def unit_pundit
      if UnitPolicy.new(current_user).show?
      elsif !UnitPolicy.new(current_user).create?
      elsif !UnitPolicy.new(current_user).destroy?
      elsif !UnitPolicy.new(current_user).update?
      end
    end
end
