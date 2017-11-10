require "rails_helper"

RSpec.describe CampaignMailer, type: :mailer do
  describe "raffle" do
    before do
      @campaign = create(:campaign)
      @member   = create(:member, campaign: @campaign)
      @mail = CampaignMailer.raffle(@campaign, @member, @friend)
    end

    it "Renders the headers" do
      expect(@mail.subject).to eq("Secret Santa: #{@campaign.title}")
      expect(@mail.to).to eq([@member.email])
    end

    it "Body has the member name" do
      expect(@mail.body.encoded).to match(@member.name)
    end

    it "Body has the campaign creator name" do
      expect(@mail.body.encoded).to match(@campaign.user.name)
    end

    it "Body has the friend name" do
      expect(@mail.body.encoded).to match(@friend.name)
    end

    it "Body has member link to set open" do
      expect(@mail.body.encoded).to match("/members/#{@member.token}/opened")
    end
  end
end
