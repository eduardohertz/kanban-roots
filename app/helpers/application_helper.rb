module ApplicationHelper
  # TODO: Test it!
  def li_link_to label, path
    if request.fullpath == path
      return "<li class='active'>#{link_to(label, path)}</li>".html_safe
    else
      return "<li>#{link_to(label, path)}</li>".html_safe
    end
  end

  def markdown_note(item)
    "Note: #{item} are rendered using
     <a href='http://github.github.com/github-flavored-markdown/'>
       GitHub Flavored Markdown
     </a>"
  end

  # TODO: Test it!
  def gravatar_image_tag(user, options={})
    options.reverse_merge!(:size => 24, :class => '')
    if Rails.env.production?
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      url = "http://gravatar.com/avatar/#{gravatar_id}?d=mm&s=#{options[:size]}"
      image_tag(url,
                :class => "avatar #{options[:class]}",
                :height => options[:size],
                :width => options[:size]).html_safe
    else
      image_tag('gravatar.png',
                :class => "avatar #{options[:class]}",
                :height => options[:size],
                :width => options[:size]).html_safe
    end
  end

  # This make the haml markdown filter protected against javascript injection
  # attacks and add some other processing options to markdown.
  def markdown(text)
    options = [:filter_html, :hard_wrap, :autolink, :no_intraemphasis, :gh_blockcode, :fenced_code]
    syntax_highlighter(Redcarpet.new(text, *options).to_html).html_safe
  end

  def syntax_highlighter(html)
    doc = Nokogiri::HTML(html)
    doc.search("//pre[@lang]").each do |pre|
      pre.replace colorize(pre.text.rstrip, pre[:lang])
    end
    doc.to_s
  end

  # This is a hack for pygments work on Heroku
  def colorize(code, lang)
    if can_pygmentize?
      Albino.colorize(code, lang)
    else
      require 'net/http'
      Net::HTTP.post_form(URI.parse('http://pygments.appspot.com/'),
                          {'code'=>code, 'lang'=>lang}).body
    end
  end

  def can_pygmentize?
    system 'pygmentize -V'
  end
end

