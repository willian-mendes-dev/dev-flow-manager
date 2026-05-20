require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#format_ai_text" do
    it "converts markdown bold to strong tags and preserves paragraph formatting" do
      result = helper.format_ai_text("Diagnóstico: **teste**\nSegunda linha")

      expect(result).to include("<strong>teste</strong>")
      expect(result).to include("<p>")
      expect(result).to include("Segunda linha")
    end
  end
end
