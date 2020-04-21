module DeviseHelper
  def devise_error_messages!(resource:)
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg, class: "flash") }.join
    html = <<-HTML
    <ul class="flash-wrapper animate flashAnimation">
      #{messages}
    </ul>
    HTML

    html.html_safe
  end
end

