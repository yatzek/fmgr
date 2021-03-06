describe 'PlayerMailer' do

  describe 'notification_email' do

    TIME_29_01_2013_12_00 = Time.local(2013, 1, 29, 12, 0, 0)

    let(:szlachta)  {create(:szlachta)}
    let(:game)      {create(:game, time: TIME_29_01_2013_12_00)}
    let(:mail)      {PlayerMailer.notification_email(szlachta, game)}

    it 'renders the headers' do
      expect(mail.subject).to eq 'Want to play 7-a-side on Tuesday 29 Jan 2013 at 12:00 at the Goals?'
      expect(mail.to).to eq [szlachta.email]
      expect(mail.from).to eq %w(noreply@fmgr.heroku.com)
    end

    it 'renders the body' do
      sub_link = LinkUtils.subscribe_link(szlachta.id, game.id)
      #unsub_link = LinkUtils.unsubscribe_link(szlachta.id, game.id)

      expect(mail.body.encoded).to include "To play click this link: <a href=\"#{sub_link}\">#{sub_link}</a>"
      #expect(mail.body.encoded).to include "To unclick the click use this link: <a href=\"#{unsub_link}\">#{unsub_link}</a>"
    end

  end

end
