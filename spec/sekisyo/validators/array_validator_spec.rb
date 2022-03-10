# frozen_string_literal: true

RSpec.describe Sekisyo::Validators::ArrayValidator do
  describe '#valid?' do
    context 'no options' do
      let(:validator) { described_class.new(:key) }

      it 'receive blank string' do
        expect(validator.valid?('')).to be false
      end

      it 'receive blank hash' do
        expect(validator.valid?({})).to be false
      end

      it 'receive blank array' do
        expect(validator.valid?([])).to be true
      end

      it 'receive string' do
        expect(validator.valid?('string')).to be false
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
        expect(validator.valid?([1])).to be true
      end

      it 'receive hash' do
        expect(validator.valid?({ key: 'value' })).to be false
      end
    end

    context 'with presence option' do
      let(:validator) { described_class.new(:key, { 'presence' => true }) }

      it 'receive array' do
        expect(validator.valid?([1])).to be true
      end

      it 'receive blank' do
        expect(validator.valid?([])).to be false
      end
    end

    context 'with max_bytesize option' do
      let(:validator) { described_class.new(:key, { 'max_bytesize' => 100 }) }

      it 'receive 100 byte (to_s) array' do
        expect(validator.valid?(['s' * 96])).to be true
      end

      it 'receive 101 byte (to_s) array' do
        expect(validator.valid?(['s' * 97])).to be false
      end
    end

    context 'with min_size option' do
      let(:validator) { described_class.new(:key, { 'min_size' => 3 }) }

      it 'receive 3 items' do
        expect(validator.valid?(['s'] * 3)).to be true
      end

      it 'receive 2 items' do
        expect(validator.valid?(['s'] * 2)).to be false
      end
    end

    context 'with max_size option' do
      let(:validator) { described_class.new(:key, { 'max_size' => 3 }) }

      it 'receive 3 items' do
        expect(validator.valid?(['s'] * 3)).to be true
      end

      it 'receive 4 items' do
        expect(validator.valid?(['s'] * 4)).to be false
      end
    end

    context 'with items type option' do
      let(:validator) { described_class.new(:key, { 'items' => { 'type' => 'string' } }) }

      it 'receive string items' do
        expect(validator.valid?(['s'])).to be true
        expect(validator.instance_variable_get('@items_validator').class).to eq Sekisyo::Validators::StringValidator
      end

      it 'receive integer items' do
        expect(validator.valid?([1])).to be false
      end
    end

    context 'with items type option and items max_bytesize option' do
      let(:validator) { described_class.new(:key, { 'items' => { 'type' => 'string', 'max_bytesize' => 1 } }) }

      it 'receive 1 byte string items' do
        expect(validator.valid?(['s'])).to be true
      end

      it 'receive 2 byte string items' do
        expect(validator.valid?(['st'])).to be false
      end
    end
  end
end
