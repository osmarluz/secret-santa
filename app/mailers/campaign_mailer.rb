class CampaignMailer < ApplicationMailer
  
    def raffle(campaign, member, friend)
      @campaign = campaign
      @member = member
      @friend = friend
      mail to: @member.email, subject: "Secret Santa: #{@campaign.title}"
    end
  end
