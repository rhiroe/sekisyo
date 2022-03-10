# frozen_string_literal: true

RSpec.describe Sekisyo::Validators::StringValidator do
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
        expect(validator.valid?('string')).to be true
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

      it 'receive string' do
        expect(validator.valid?('string')).to be true
      end

      it 'receive blank' do
        expect(validator.valid?('')).to be false
      end
    end

    context 'with max_bytesize option' do
      let(:validator) { described_class.new(:key, { 'max_bytesize' => 100 }) }

      it 'receive 100bytes string' do
        expect(validator.valid?('s' * 100)).to be true
      end

      it 'receive 101bytes string' do
        expect(validator.valid?('s' * 101)).to be false
      end
    end

    context 'with enum option' do
      let(:validator) { described_class.new(:key, { 'enum' => ['apple'] }) }

      it 'receive apple' do
        expect(validator.valid?('apple')).to be true
      end

      it 'receive banana' do
        expect(validator.valid?('banana')).to be false
      end
    end

    context 'with match option' do
      let(:validator) do
        email_regexp = %r{^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$}
        described_class.new(:key, { 'match' => email_regexp.to_s })
      end

      it 'receive match string' do
        expect(validator.valid?('sample@example.com')).to be true
      end

      it 'receive not match string' do
        expect(validator.valid?('evil@sample@example.com')).to be false
      end
    end
  end
end
