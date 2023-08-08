# frozen_string_literal: true

require "spec_helper"
require "roseflow/stabilityai"

module Roseflow
  module StabilityAI
    RSpec.describe Provider do
      let(:provider) { described_class.new }

      describe "Models" do
        it "returns a list of models" do
          VCR.use_cassette("stabilityai/models") do
            expect(provider.models).to be_a(ModelRepository)
            expect(provider.models.each).to all(be_a(Model))
          end
        end
      end

      describe "API calls" do
        describe "text-to-image" do
          let(:repository) { provider.models }
          let(:model) { repository.find("stable-diffusion-xl-1024-v1-0") }
          let(:prompt) {
            [
              {
                text: "A highly photorealistic image of a off road race track, complete with precise replicas of the world’s most iconic heavy noun, captured at the moment of a sharp turn, with smoke and sparks flying from under the wheels and the noun drifting around the bend. The image captures the excitement of the moment, with happy and noisy fans cheering and waving in the background.",
                weight: 1.0,
              },
            ]
          }

          it "returns a response" do
            VCR.use_cassette("stabilityai/text-to-image") do
              response = provider.call(:text_to_image, engine_id: model.name, text_prompts: prompt, height: 1024, width: 1024)
              # body = JSON.parse(response.body)
              # puts body["artifacts"].keys
              # image = body["artifacts"].first
              # File.open("result.png", "wb") do |f|
              #   f.write(Base64.decode64(image["base64"]))
              # end
              expect(response).to be_a(Responses::TextToImageResponse)
              expect(response).to be_success
            end
          end
        end
      end
    end
  end
end
