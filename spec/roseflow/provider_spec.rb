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
              expect(response).to be_a(Responses::TextToImageResponse)
              expect(response).to be_success
              response.images.each do |image|
                File.open("spec/tmp/text-to-image/#{ULID.generate}.png", "wb") do |file|
                  file.write(Base64.decode64(image.base64))
                end
              end
            end
          end
        end

        describe "image-to-image" do
          let(:repository) { provider.models }
          let(:model) { repository.find("stable-diffusion-xl-1024-v1-0") }
          let(:prompt) {
            [
              {
                text: "A highly photorealistic image of a dirt bike, jumping off of a box jump, on the off road track",
                weight: 1.0,
              },
            ]
          }
          let(:image) { File.open("spec/fixtures/images/init-2.png", "rb") { |file| file.read } }

          it "returns a response" do
            VCR.use_cassette("stabilityai/image-to-image") do
              response = provider.call(:image_to_image, engine_id: model.name, text_prompts: prompt, init_image: image, image_strength: 0.1, height: 1024, width: 1024)
              expect(response).to be_a(Responses::ImageToImageResponse)
              expect(response).to be_success
              response.images.each do |image|
                File.open("spec/tmp/image-to-image/#{ULID.generate}.png", "wb") do |file|
                  file.write(Base64.decode64(image.base64))
                end
              end
            end
          end
        end

        describe "upscale" do
          context "sdx4" do
            let(:repository) { provider.models }
            let(:model) { repository.find("stable-diffusion-x4-latent-upscaler") }
            let(:image) { File.open("spec/fixtures/images/init-512.png", "rb") { |file| file.read } }

            it "returns a response" do
              VCR.use_cassette("stabilityai/upscale") do
                response = provider.call(:upscale, engine_id: model.name, upscale_type: "sdx4", sdx4: { image: image, width: 2048, text_prompts: [{ text: "A highly photorealistic image of off road vehicle", weight: 1.0 }], seed: 0, steps: 50, cfg_scale: 7 })
                expect(response).to be_a(Responses::UpscaleResponse)
                expect(response).to be_success
                response.artifacts.each do |artifact|
                  File.open("spec/tmp/upscale/#{ULID.generate}.png", "wb") do |file|
                    file.write(Base64.decode64(artifact.base64))
                  end
                end
              end
            end
          end
        end

        describe "masking" do
          let(:repository) { provider.models }
          let(:model) { repository.find("stable-diffusion-xl-1024-v1-0") }
          let(:prompt) {
            [
              {
                text: "A highly photorealistic image of a white horse",
                weight: 1.0,
              },
            ]
          }
          let(:image) { File.open("spec/fixtures/images/init-2.png", "rb") { |file| file.read } }
          let(:mask) { File.open("spec/fixtures/images/mask.png", "rb") { |file| file.read } }

          it "returns a response" do
            VCR.use_cassette("stabilityai/masking") do
              response = provider.call(:masking, engine_id: model.name, text_prompts: prompt, init_image: image, mask_image: mask, height: 1024, width: 1024)
              expect(response).to be_a(Responses::MaskingResponse)
              expect(response).to be_success
              response.images.each do |image|
                File.open("spec/tmp/masking/#{ULID.generate}.png", "wb") do |file|
                  file.write(Base64.decode64(image.base64))
                end
              end
            end
          end
        end
      end
    end
  end
end
