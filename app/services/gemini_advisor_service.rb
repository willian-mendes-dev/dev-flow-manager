require "net/http"
require "json"

class GeminiAdvisorService
  def generate_insight(stock_data)
    Rails.logger.info("Chave da API: #{ENV['GEMINI_API_KEY'].present? ? 'Carregada' : 'FALTANDO'}")
    api_key = ENV["GEMINI_API_KEY"].to_s
    return "Defina a variável GEMINI_API_KEY para habilitar o conselheiro financeiro com IA." if api_key.blank?

    uri = URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=#{api_key}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri, { "Content-Type" => "application/json" })
    request.body = build_payload(stock_data).to_json

    response = http.request(request)
    parse_response(response)
  rescue StandardError => e
    Rails.logger.error("GeminiAdvisorService falhou: #{e.message}")
    nil
  end

  private

  def build_payload(stock_data)
    prompt = <<~PROMPT
      Você é um consultor financeiro extremamente rígido e sarcástico.
      Analise estes dados de estoque atuais do MarketFlow: #{stock_data.to_json}.
      Dê um diagnóstico direto, estratégico e curto (máximo 4 linhas) sobre o que o lojista deve fazer para melhorar o giro e não perder dinheiro.
    PROMPT

    { "contents" => [{ "parts" => [{ "text" => prompt }] }] }
  end

  def parse_response(response)
    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error("GeminiAdvisorService HTTP #{response.code} - Body: #{response.body}")
      return nil
    end

    parsed = JSON.parse(response.body)
    parsed.dig("candidates", 0, "content", "parts", 0, "text")
  end
end
