module Markdown
  def self.html(text)
    Downr::Markdown.render(text).html_safe
  end

  def self.text(text)
    html = self.html(text)
    Nokogiri::HTML(html).text
  end
end
