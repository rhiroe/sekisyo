# frozen_string_literal: true

RSpec.describe Sekisyo::Validators::ObjectValidator do
  describe '#valid?' do
    context 'no options' do
      let(:validator) { described_class.new(:key) }

      it 'receive blank string' do
        expect(validator.valid?('')).to be false
      end

      it 'receive blank hash' do
        expect(validator.valid?({})).to be true
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
        expect(validator.valid?(1)).to be false
      end

      it 'receive float' do
        expect(validator.valid?(1.0)).to be false
      end

      it 'receive array' do
        expect(validator.valid?([1])).to be false
      end

      it 'receive not permitted hash' do
        expect(validator.valid?({ key: 'value' })).to be false
      end
    end

    context 'with child properties' do
      let(:validator) do
        described_class.new(:key,
                            {
                              'child_property' => {}
                            })
      end

      it 'receive same property' do
        expect(validator.valid?({ 'child_property' => 'string' })).to be true
      end

      it 'receive blank hash' do
        expect(validator.valid?({})).to be true
      end
    end

    context 'with child properties and child type' do
      let(:validator) do
        described_class.new(:key,
                            {
                              'child_property' => {
                                'type' => 'string'
                              }
                            })
      end

      it 'receive same property' do
        expect(validator.valid?({ 'child_property' => 'string' })).to be true
      end

      it 'receive different type property' do
        expect(validator.valid?({ 'child_property' => ['string'] })).to be false
      end
    end

    context 'with child properties and child type and child options' do
      let(:validator) do
        described_class.new(:key,
                            {
                              'child_property' => {
                                'type' => 'string',
                                'max_bytesize' => 100
                              }
                            })
      end

      it 'receive 100bytes child property' do
        expect(validator.valid?({ 'child_property' => 's' * 100 })).to be true
      end

      it 'receive 101bytes child property' do
        expect(validator.valid?({ 'child_property' => 's' * 101 })).to be false
      end
    end
  end
end
