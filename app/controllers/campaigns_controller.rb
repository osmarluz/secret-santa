class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [:show, :update, :destroy, :raffle]
  before_action :is_owner?, only: [:show, :update, :destroy, :raffle]

  def show
  end

  def index
    @campaigns = current_user.campaigns
  end

  def create
    @campaign = Campaign.new(user: current_user, title: "New Secret Santa", description: "Add a description...")

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to "/campaigns/#{@campaign.id}" }
      else
        format.html { redirect_to main_app.root_url, notice: @campaign.errors }
      end
    end
  end

  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.json { render json: true }
      else
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @campaign.destroy

    respond_to do |format|
      format.json { render json: true }
    end
  end

  def raffle
    respond_to do |format|
      if @campaign.status != "pending"
        format.json { render json: 'Your secret santa has already been raffled', status: :unprocessable_entity }
      elsif @campaign.members.count < 3
        format.json { render json: 'Your secret santa needs at least three people', status: :unprocessable_entity }
      else
        CampaignRaffleJob.perform_later @campaign
        format.json { render json: true }
      end
    end
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  def campaign_params
    params.require(:campaign).permit(:title, :description, :event_hour, :location).merge(user: current_user)
  end

  def is_owner?
    unless current_user == @campaign.user
      respond_to do |format|
        format.json { render json: false, status: :forbidden }
        format.html { redirect_to main_app.root_url }
      end
    end
  end
end
