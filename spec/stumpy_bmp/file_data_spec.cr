require "./../spec_helper"

Spectator.describe StumpyBMP::FileData do
  context "when no file_name given" do
    let(file_data) { StumpyBMP::FileData.new }

    describe "#initialize" do
      it "does not raise" do
        expect { StumpyBMP::FileData.new }.not_to raise_error
      end

      it "is NOT valid" do
        expect(file_data.valid?).to be_false
      end

      context "sets expected values for instance variable" do
        it "file_name" do
          expect(file_data.file_name.empty?).to be_true
        end

        it "file_bytes" do
          expect(file_data.file_bytes.empty?).to be_true
        end
      end

      context "errors include" do
        it "file_name" do
          expect(file_data.errors.keys.to_a).to contain(:file_name)
          expect(file_data.errors[:file_name]).to eq("Param file_name is missing!")
        end

        it "file_ident_header_ords" do
          expect(file_data.errors.keys.to_a).to contain(:file_ident_header_ords)
          expect(file_data.errors[:file_ident_header_ords]).to eq("Not a BMP file")
        end
      end
    end

    describe "#extract_data" do
      # let(file_data) { StumpyBMP::FileData.new }

      before_each do
        allow(file_data).to receive(:extract_bytes).and_return(nil)
        allow(file_data).to receive(:extract_header_data).and_return(nil)
      end

      context "calls" do
        pending "extract_bytes" do
          # allow(file_data).to receive(:extract_bytes).and_return(nil)
          # allow(file_data).to receive(:extract_header_data).and_return(nil)

          expect(file_data).to receive(:extract_bytes).and_return(nil)
          file_data.extract_data
        end

        pending "extract_header_data" do
          # allow(file_data).to receive(:extract_bytes).and_return(nil)
          # allow(file_data).to receive(:extract_header_data).and_return(nil)

          expect(file_data).to receive(:extract_header_data)
          file_data.extract_data
        end
      end
    end

    describe "#extract_bytes" do
      context "does NOT call" do
        it "File.open" do
          expect(File).not_to receive(:open)
          file_data.extract_bytes
        end
      end
    end

    describe "#extract_header_data" do
      # let(file_data) { StumpyBMP::FileData.new }

      before_each do
        file_data.extract_bytes
      end

      context "does NOT set" do
        # let(file_ident_header_ords_inited) { [0,0] }
        let(file_ident_header_ords_inited) { Array(UInt8).new }
        it "file_ident_header_ords" do
          expect(file_data.file_ident_header_ords).to eq(file_ident_header_ords_inited)
          file_data.extract_header_data
          expect(file_data.file_ident_header_ords).to eq(file_ident_header_ords_inited)
        end
      end
    end
  end
end
