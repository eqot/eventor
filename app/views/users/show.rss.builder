xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Eventor RSS"
    xml.description "Eventor RSS"
    xml.link user_notifications_url(current_user)

    for notification in @notifications
      xml.item do
        xml.title notification.description
        xml.pubDate notification.created_at.to_s(:rfc822)
        xml.link root_url.chop + notification.url
        xml.guid root_url.chop + notification.url
      end
    end
  end
end
