require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = create(:user)
    sign_in @current_user
  end

  describe "GET #index" do
    it "Returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    context "Campaign exists" do
      context "User is the campaing owner" do
        it "Returns success" do
          campaign = create(:campaign, user: @current_user)
          get :show, params: { id: campaign.id }
          expect(response).to have_http_status(:success)
        end
      end

      context "User isn't the campaign owner" do
        it "Redirects to root" do
          campaign = create(:campaign)
          get :show, params: { id: campaign.id }
          expect(response).to redirect_to('/')
        end
      end
    end

    context "Campaign doesn't exist" do
      it "Redirects to root" do
        get :show, params: { id: 0 }
        expect(response).to redirect_to('/')
      end
    end
  end

  describe "POST #create" do
    before(:each) do
      @campaign_attributes = attributes_for(:campaign, user: @current_user)
      post :create, params: { campaign: @campaign_attributes }
    end

    it "Redirects to new campaign" do
      expect(response).to have_http_status(302)
      expect(response).to redirect_to("/campaigns/#{Campaign.last.id}")
    end

    it "Creates campaign with correct attributes" do
      expect(Campaign.last.user).to eql(@current_user)
      expect(Campaign.last.title).to eql(@campaign_attributes[:title])
      expect(Campaign.last.description).to eql(@campaign_attributes[:description])
      expect(Campaign.last.status).to eql('pending')
    end

    it "Creates campaign with owner defined as a member" do
      expect(Campaign.last.members.last.name).to eql(@current_user.name)
      expect(Campaign.last.members.last.email).to eql(@current_user.email)
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context "User is the campaign owner" do
      it "Returns http success" do
        campaign = create(:campaign, user: @current_user)
        delete :destroy, params: { id: campaign.id }
        expect(response).to have_http_status(:success)
      end
    end

    context "User isn't the campaign owner" do
      it "Returns http forbidden" do
        campaign = create(:campaign)
        delete :destroy, params: { id: campaign.id }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PUT #update" do
    before(:each) do
      @new_campaign_attributes = attributes_for(:campaign)
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context "User is the campaign owner" do
      before(:each) do
        campaign = create(:campaign, user: @current_user)
        put :update, params: { id: campaign.id, campaign: @new_campaign_attributes }
      end

      it "Returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "Campaign has the new attributes" do
        expect(Campaign.last.title).to eq(@new_campaign_attributes[:title])
        expect(Campaign.last.description).to eq(@new_campaign_attributes[:description])
      end
    end

    context "User isn't the campaign owner" do
      it "Returns http forbidden" do
        campaign = create(:campaign)
        put :update, params: { id: campaign.id, campaign: @new_campaign_attributes }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET #raffle" do
    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context "User is the Campaign Owner" do
      before(:each) do
        @campaign = create(:campaign, user: @current_user)
      end

      context "Has more than two members" do
        before(:each) do
          create(:member, campaign: @campaign)
          create(:member, campaign: @campaign)
          create(:member, campaign: @campaign)
          post :raffle, params: {id: @campaign.id}
        end

        it "Returns http success" do
          expect(response).to have_http_status(:success)
        end
      end

      context "No more than two members" do
        before(:each) do
          create(:member, campaign: @campaign)
          post :raffle, params: { id: @campaign.id }
        end

        it "Returns unprocessable entity http status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "User isn't the campaign owner" do
      before(:each) do
        @campaign = create(:campaign)
        post :raffle, params: { id: @campaign.id }
      end

      it "Returns http forbidden" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
