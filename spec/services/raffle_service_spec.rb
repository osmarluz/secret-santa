require 'rails_helper'

describe RaffleService do
  before :each do
    @campaign = create(:campaign, status: :pending)
  end

  describe '#call' do
    context "Campaign has more than two members" do
      before(:each) do
        create(:member, campaign: @campaign)
        create(:member, campaign: @campaign)
        create(:member, campaign: @campaign)
        @campaign.reload
        @results = RaffleService.new(@campaign).call
      end

      it "Results is a hash" do
        expect(@results.class).to eq(Hash)
      end

      it "All members are in results as a member" do
        result_members = @results.map { |r| r.first }
        expect(result_members.sort).to eq(@campaign.members.sort)
      end

      it "All members are in results as a friend" do
        result_friends = @results.map { |r| r.last }
        expect(result_friends.sort).to eq(@campaign.members.sort)
      end

      it "A member doesn't get himself as a friend" do
        @results.each do |r|
          expect(r.first).not_to eq(r.last)
        end
      end

      it "Two members don't get each other as friends" do
        
      end

    end

    context "Campaign doesn't have more than two members" do
      before(:each) do
        create(:member, campaign: @campaign)
        @campaign.reload
        @response = RaffleService.new(@campaign).call
      end

      it "Raise error" do
        expect(@response).to eql(false)
      end
    end
  end
end
