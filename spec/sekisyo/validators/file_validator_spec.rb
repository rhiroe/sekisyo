# frozen_string_literal: true

RSpec.describe Sekisyo::Validators::FileValidator do
  describe '#valid?' do
    let(:text_file) { Rack::Test::UploadedFile.new('spec/files/sample.txt', 'text/plain') }
    let(:js_file) { Rack::Test::UploadedFile.new('spec/files/sample.js', 'text/javascript') }

    def value(rack_test_file)
      { filename: rack_test_file.original_filename,
        type: rack_test_file.content_type,
        name: 'key',
        tempfile: rack_test_file.tempfile,
        head: "Content-Disposition: form-data; name=\"key\"; filename=\"#{rack_test_file.original_filename}\"\r\n"\
          "Content-Type: #{rack_test_file.content_type}\r\n" }
    end

    context 'no options' do
      let(:validator) { described_class.new(:key) }

      it 'receive blank string' do
        expect(validator.valid?('')).to be false
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

      it 'receive file params' do
        expect(validator.valid?(value(text_file))).to be true
      end
    end

    context 'with allow_file_types option' do
      let(:validator) { described_class.new(:key, { 'allow_file_types' => ['text/plain'] }) }

      it 'receive text file params' do
        expect(validator.valid?(value(text_file))).to be true
      end

      it 'receive js file params' do
        expect(validator.valid?(value(js_file))).to be false
      end
    end

    context 'with presence option' do
      let(:blank_file) { Rack::Test::UploadedFile.new('spec/files/blank.txt', 'text/plain') }
      let(:validator) { described_class.new(:key, { 'presence' => true }) }

      it 'receive text file params' do
        expect(validator.valid?(value(text_file))).to be true
      end

      it 'receive blank file params' do
        expect(validator.valid?(value(blank_file))).to be false
      end
    end

    context 'with max_bytesize option' do
      let(:text_file_5bytes) { Rack::Test::UploadedFile.new('spec/files/5bytes.txt', 'text/plain') }
      let(:text_file_6bytes) { Rack::Test::UploadedFile.new('spec/files/6bytes.txt', 'text/plain') }
      let(:validator) { described_class.new(:key, { 'max_bytesize' => 5 }) }

      it 'receive 5bytes text file params' do
        expect(validator.valid?(value(text_file_5bytes))).to be true
      end

      it 'receive 6bytes text file params' do
        expect(validator.valid?(value(text_file_6bytes))).to be false
      end
    end
  end
end
