  module ApplicationHelper
  def body_class(body_class)
    if body_class.present?
      "#{body_class}"
    end
  end

  def embedded_svg filename, options={}
    file = File.read(Rails.root.join("frontend", "assets", "svg", filename))
    doc  = Nokogiri::HTML::DocumentFragment.parse file
    svg  = doc.at_css "svg"

    if options[:class].present?
      svg["class"] = options[:class]
    end
    doc.to_html.html_safe
  end

  def show_newsletter_subscribe_modal
    if AppConfig.email_marketing.present?
      !(cookies["_#{Rails.configuration.application_name.parameterize}_subscribed_to_newsletter"] ||
        cookies["_#{Rails.configuration.application_name.parameterize}_dismissed_newsletter_modal"])
    end
  end
end

