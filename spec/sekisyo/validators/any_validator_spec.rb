# frozen_string_literal: true

RSpec.describe Sekisyo::Validators::AnyValidator do
  describe '#valid?' do
    context 'no options' do
      let(:validator) { described_class.new(:key) }

      it 'receive blank string' do
        expect(validator.valid?('')).to be true
      end

      it 'receive blank hash' do
        expect(validator.valid?({})).to be true
      end

      it 'receive blank array' do
        expect(validator.valid?([])).to be true
      end

      it 'receive string' do
        expect(validator.valid?('string')).to be true
      end

      it 'receive nil' do
        expect(validator.valid?(nil)).to be true
      end

      it 'receive integer' do
        expect(validator.valid?(1)).to be true
      end

      it 'receive float' do
        expect(validator.valid?(1.0)).to be true
      end

      it 'receive array' do
        expect(validator.valid?([1])).to be true
      end

      it 'receive hash' do
        expect(validator.valid?({ key: 'value' })).to be true
      end
    end

    context 'with presence option' do
      let(:validator) { described_class.new(:key, { 'presence' => true }) }

      it 'receive string' do
        expect(validator.valid?('string')).to be true
      end

      it 'receive blank' do
        expect(validator.valid?('')).to be false
      end
    end

    context 'with max_bytesize option' do
      let(:validator) { described_class.new(:key, { 'max_bytesize' => 100 }) }

      it 'receive 100 byte string' do
        expect(validator.valid?('s' * 100)).to be true
      end

      it 'receive 101 byte string' do
        expect(validator.valid?('s' * 101)).to be false
      end
    end
  end
end
