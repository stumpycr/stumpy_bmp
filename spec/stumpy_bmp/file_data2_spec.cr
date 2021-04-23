require "./../spec_helper"

Spectator.describe StumpyBMP::FileData do
  let(file_data) { StumpyBMP::FileData.new(filename: "spec/images/solution2.bmp") }
  let(file_size_expected) { 222 }

  describe "#initialize" do
    context "when no params specified" do
      it "does not raise" do
        expect{ StumpyBMP::FileData.new }.not_to raise_error
      end

      it "is NOT valid" do
        file_data = StumpyBMP::FileData.new
        expect(file_data.valid?).to be_false
      end

      it "errors is as expected" do
        file_data = StumpyBMP::FileData.new
        valid = file_data.valid?
        # puts ; p! valid
        # puts ; p! file_data.errors
        expect(file_data.errors.keys).to contain(:file_ident_header_ords)
        expect(file_data.errors[:file_ident_header_ords]).to eq("Not a BMP file")
      end
    end

    context "when filename param specified" do
      it "does not raise" do
        expect{ StumpyBMP::FileData.new(filename: "spec/images/solution.bmp") }.not_to raise_error
      end

      it "is NOT valid" do
        file_data = StumpyBMP::FileData.new(filename: "spec/images/solution.bmp")
        expect(file_data.valid?).to be_false
      end

      it "errors is as expected" do
        file_data = StumpyBMP::FileData.new(filename: "spec/images/solution.bmp")
        valid = file_data.valid?
        # puts ; p! valid
        # puts ; p! file_data.errors
        expect(file_data.errors.keys).to contain(:file_ident_header_ords)
        expect(file_data.errors[:file_ident_header_ords]).to eq("Not a BMP file")
      end
    end
  end

  describe "#extract_bytes" do
    let(extracted_bytes) { file_data.file_bytes }
    before_each { file_data.extract_bytes }
    
    context "populates as expected for instance variable" do
      context "@file_bytes re" do
        it "class aka Array(UInt8)" do
          puts ; p! extracted_bytes
          expect(extracted_bytes.class).to eq(Array(UInt8))
        end
  
        it "file size" do
          puts ; p! extracted_bytes.size
          expect(extracted_bytes.size).to eq(file_size_expected)
        end
      end
    end
  end

  describe "#extract_header_data" do
    before_each do
      file_data.extract_bytes
      file_data.extract_header_data
    end
    
    context "populates as expected for instance variable" do
      # context "@file_size re" do
      #   it "class" do
      #     puts ; p! file_data.file_size.class
      #     expect(file_data.file_size.class).to eq(UInt32)
      #   end
  
      #   it "value" do
      #     puts ; p! file_data.file_size
      #     expect(file_data.file_size).to eq(file_size_expected)
      #   end
      # end

      context "@file_ident_header_ords re" do
        let(variable_set) { file_data.file_ident_header_ords }
        let(value_expected) { [66, 77] }
        it "class" do
          puts ; p! file_data.file_ident_header_ords.class
          expect(variable_set.class).to eq(Array(UInt8))
        end
  
        it "value" do
          puts ; p! file_data.file_ident_header_ords
          expect(variable_set).to eq(value_expected)
        end
      end

      context "@file_size re" do
        let(variable_set) { file_data.file_size }
        let(value_expected) { file_size_expected }
        it "class" do
          puts ; p! file_data.file_size.class
          expect(variable_set.class).to eq(UInt32)
        end
  
        it "value" do
          puts ; p! file_data.file_size
          expect(variable_set).to eq(value_expected)
        end
      end

      context "@rs1 re" do
        let(variable_set) { file_data.rs1 }
        let(value_expected) { 0 } # TODO: verify!
        it "class" do
          puts ; p! file_data.rs1.class
          expect(variable_set.class).to eq(UInt32)
        end
  
        it "value" do
          puts ; p! file_data.rs1
          expect(variable_set).to eq(value_expected)
        end
      end

      context "@rs2 re" do
        let(variable_set) { file_data.rs2 }
        let(value_expected) { 0 } # TODO: verify!
        it "class" do
          puts ; p! file_data.rs2.class
          expect(variable_set.class).to eq(UInt32)
        end
  
        it "value" do
          puts ; p! file_data.rs2
          expect(variable_set).to eq(value_expected)
        end
      end

      context "@offset re" do
        let(variable_set) { file_data.offset }
        let(value_expected) { 138 } # TODO: verify!
        it "class" do
          puts ; p! file_data.offset.class
          expect(file_data.offset.class).to eq(UInt32)
        end
  
        it "value" do
          puts ; p! variable_set
          expect(variable_set).to eq(value_expected)
        end
      end

      context "@header_size re" do
        let(variable_set) { file_data.header_size }
        let(value_expected) { 124 } # TODO: verify!
        it "class" do
          puts ; p! file_data.header_size.class
          expect(variable_set.class).to eq(UInt32)
        end
  
        it "value" do
          puts ; p! file_data.header_size
          expect(variable_set).to eq(value_expected)
        end
      end

      context "@width re" do
        let(variable_set) { file_data.width }
        let(value_expected) { 3 }
        it "class" do
          puts ; p! file_data.width.class
          expect(variable_set.class).to eq(UInt32)
        end
  
        it "value" do
          puts ; p! file_data.width
          expect(variable_set).to eq(value_expected)
        end
      end

      context "@height re" do
        let(variable_set) { file_data.height }
        let(value_expected) { 7 }
        it "class" do
          puts ; p! file_data.height.class
          expect(variable_set.class).to eq(UInt32)
        end
  
        it "value" do
          puts ; p! file_data.height
          expect(variable_set).to eq(value_expected)
        end
      end

      context "@color_planes re" do
        let(variable_set) { file_data.color_planes }
        let(value_expected) { 1 } # TODO: verify!
        it "class" do
          puts ; p! file_data.color_planes.class
          expect(variable_set.class).to eq(UInt32)
        end
  
        it "value" do
          puts ; p! file_data.color_planes
          expect(variable_set).to eq(value_expected)
        end
      end

      context "@bits re" do
        let(variable_set) { file_data.bits }
        let(value_expected) { 32 } # TODO: verify!
        it "class" do
          puts ; p! file_data.bits.class
          expect(variable_set.class).to eq(UInt32)
        end
  
        it "value" do
          puts ; p! file_data.bits
          expect(variable_set).to eq(value_expected)
        end
      end

      context "@compression re" do
        let(variable_set) { file_data.compression }
        let(value_expected)  { 3 } # TODO: verify!
        it "class" do
          puts ; p! file_data.compression.class
          expect(variable_set.class).to eq(UInt32)
        end
  
        it "value" do
          puts ; p! file_data.compression
          expect(variable_set).to eq(value_expected)
        end
      end

      context "@image_size re" do
        let(variable_set) { file_data.image_size }
        let(value_expected)  { 84 } # TODO: verify!
        it "class" do
          puts ; p! file_data.image_size.class
          expect(variable_set.class).to eq(UInt32)
        end
  
        it "value" do
          puts ; p! file_data.image_size
          expect(variable_set).to eq(value_expected)
        end
      end

      context "@res_x re" do
        let(variable_set) { file_data.res_x }
        let(value_expected)  { 2835 } # TODO: verify!
        it "class" do
          puts ; p! file_data.res_x.class
          expect(variable_set.class).to eq(UInt32)
        end
  
        it "value" do
          puts ; p! file_data.res_x
          expect(variable_set).to eq(value_expected)
        end
      end

      context "@res_y re" do
        let(variable_set) { file_data.res_y }
        let(value_expected)  { 2835 } # TODO: verify!
        it "class" do
          puts ; p! file_data.res_y.class
          expect(variable_set.class).to eq(UInt32)
        end
  
        it "value" do
          puts ; p! file_data.res_y
          expect(variable_set).to eq(value_expected)
        end
      end

      context "@color_numbers re" do
        let(variable_set) { file_data.color_numbers }
        let(value_expected)  { 0 } # TODO: verify!
        it "class" do
          puts ; p! file_data.color_numbers.class
          expect(variable_set.class).to eq(UInt32)
        end
  
        it "value" do
          puts ; p! file_data.color_numbers
          expect(variable_set).to eq(value_expected)
        end
      end
    end
  end
end
