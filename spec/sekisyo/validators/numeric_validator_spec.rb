# frozen_string_literal: true

RSpec.describe Sekisyo::Validators::NumericValidator do
  describe '#valid?' do
    context 'no options' do
      let(:validator) { described_class.new(:key) }

      it 'receive blank string' do
        expect(validator.valid?('')).to be true
      end

      it 'receive blank hash' do
        expect(validator.valid?({})).to be false
      end

      it 'receive blank array' do
        expect(validator.valid?([])).to be false
      end

      it 'receive string' do
        expect(validator.valid?('string')).to be false
      end

      it 'receive nil' do
        expect(validator.valid?(nil)).to be false
      end

      it 'receive integer' do
        expect(validator.valid?(1)).to be true
      end

      it 'receive integer string' do
        expect(validator.valid?('1')).to be true
      end

      it 'receive float' do
        expect(validator.valid?(1.0)).to be true
      end

      it 'receive float string' do
        expect(validator.valid?('1.0')).to be true
      end

      it 'receive array' do
        expect(validator.valid?([1])).to be false
      end

      it 'receive hash' do
        expect(validator.valid?({ key: 'value' })).to be false
      end
    end

    context 'with presence option' do
      let(:validator) { described_class.new(:key, { 'presence' => true }) }

      it 'receive integer' do
        expect(validator.valid?(0)).to be true
      end

      it 'receive integer string' do
        expect(validator.valid?('0')).to be true
      end

      it 'receive blank' do
        expect(validator.valid?('')).to be false
      end
    end

    context 'with enum option' do
      let(:validator) { described_class.new(:key, { 'enum' => [1, 0.1] }) }

      it 'receive 1' do
        expect(validator.valid?('1')).to be true
      end

      it 'receive 0.1' do
        expect(validator.valid?('0.1')).to be true
      end

      it 'receive 1.0' do
        expect(validator.valid?('1.0')).to be false
      end
    end
  end
end
