# frozen_string_literal: true

RSpec.describe Sekisyo::Validators::BooleanValidator do
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

      it 'receive "true" string' do
        expect(validator.valid?('true')).to be true
      end

      it 'receive "false" string' do
        expect(validator.valid?('false')).to be true
      end

      it 'receive nil' do
        expect(validator.valid?(nil)).to be false
      end

      it 'receive integer' do
        expect(validator.valid?(1)).to be false
      end

      it 'receive float' do
        expect(validator.valid?(1.0)).to be false
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

      it 'receive blank' do
        expect(validator.valid?('')).to be false
      end

      it 'receive "true" string' do
        expect(validator.valid?('true')).to be true
      end

      it 'receive "false" string' do
        expect(validator.valid?('false')).to be true
      end
    end
  end
end
