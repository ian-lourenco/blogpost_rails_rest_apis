class RareGemsController < ApplicationController
  before_action :set_rare_gem, only: %i[ show update destroy ]

  # GET /rare_gems
  def index
    @rare_gems = RareGem.all

    render json: @rare_gems
  end

  # GET /rare_gems/1
  def show
    render json: @rare_gem
  end

  # POST /rare_gems
  def create
    @rare_gem = RareGem.new(rare_gem_params)

    if @rare_gem.save
      render json: @rare_gem, status: :created, location: @rare_gem
    else
      render json: @rare_gem.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rare_gems/1
  def update
    if @rare_gem.update(rare_gem_params)
      render json: @rare_gem
    else
      render json: @rare_gem.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rare_gems/1
  def destroy
    @rare_gem.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rare_gem
      @rare_gem = RareGem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def rare_gem_params
      params.expect(rare_gem: [ :name, :color, :miner_id ])
    end
end
