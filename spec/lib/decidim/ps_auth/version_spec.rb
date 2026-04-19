# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe PsAuth do
    subject { described_class }

    it "has version" do
      expect(subject.version).to eq("0.29.7")
    end
  end
end
