module ApplicationHelper
  include Chartkick::Helper if defined?(Chartkick::Helper)

  def format_ai_text(text)
    formatted_text = text.to_s.gsub(/\*\*(.*?)\*\*/, '<strong>\1</strong>')
    simple_format(formatted_text, {}, sanitize: false)
  end
end
