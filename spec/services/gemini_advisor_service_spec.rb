require "rails_helper"

RSpec.describe GeminiAdvisorService, type: :service do
  let(:service) { described_class.new }
  let(:stock_data) do
    {
      total_inventory_value: 2540.75,
      low_stock_count: 4,
      out_of_stock_count: 2,
      category_distribution: { "Alimentos" => 1200.0, "Bebidas" => 1340.75 }
    }
  end

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("GEMINI_API_KEY").and_return("fake-api-key")
  end

  describe "#generate_insight" do
    it "returns parsed text when Gemini responds with success" do
      success_response = Net::HTTPSuccess.new("1.1", "200", "OK")
      success_response.instance_variable_set(
        :@read,
        true
      )
      success_response.instance_variable_set(
        :@body,
        {
          candidates: [
            {
              content: {
                parts: [{ text: "**Diagnóstico:** reduza itens parados e priorize giro semanal." }]
              }
            }
          ]
        }.to_json
      )

      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(success_response)

      result = service.generate_insight(stock_data)

      expect(result).to include("Diagnóstico")
    end

    it "returns nil when Gemini responds with failure status" do
      failed_response = Net::HTTPInternalServerError.new("1.1", "500", "Internal Server Error")
      failed_response.instance_variable_set(:@read, true)
      failed_response.instance_variable_set(:@body, { error: { message: "falha" } }.to_json)

      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(failed_response)

      result = service.generate_insight(stock_data)

      expect(result).to be_nil
    end

    it "returns fallback message when api key is missing" do
      allow(ENV).to receive(:[]).with("GEMINI_API_KEY").and_return(nil)

      result = service.generate_insight(stock_data)

      expect(result).to eq("Defina a variável GEMINI_API_KEY para habilitar o conselheiro financeiro com IA.")
    end

    it "returns nil when response body is malformed json" do
      success_response = Net::HTTPSuccess.new("1.1", "200", "OK")
      success_response.instance_variable_set(:@read, true)
      success_response.instance_variable_set(:@body, "{ json-invalido")

      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(success_response)
      allow(Rails.logger).to receive(:error)

      result = service.generate_insight(stock_data)

      expect(result).to be_nil
      expect(Rails.logger).to have_received(:error).with(/GeminiAdvisorService falhou/)
    end
  end
end
