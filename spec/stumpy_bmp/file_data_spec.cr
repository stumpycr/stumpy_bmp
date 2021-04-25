require "./../spec_helper"

Spectator.describe StumpyBMP::FileData do
  # context "no matter what file_name given" do
  #   # describe "#initialize" do
  #   #   # it "calls #validate" do
  #   #   #   # expect_any_instance_of(StumpyBMP::FileData).to receive(:validate)
  #   #   #   file_data = StumpyBMP::FileData.new
  #   #   #   # expect(file_data).to have_received(:validate)
  #   #   # end
  #   # end

  #   describe "#extract_data" do
  #     let(file_data) { StumpyBMP::FileData.new }

  #     before_each do
  #       allow(file_data).to receive(:extract_bytes).and_return(nil)
  #       allow(file_data).to receive(:extract_header_data).and_return(nil)
  #     end

  #     context "calls" do
  #       pending "extract_bytes" do
  #         # allow(file_data).to receive(:extract_bytes).and_return(nil)
  #         # allow(file_data).to receive(:extract_header_data).and_return(nil)

  #         expect(file_data).to receive(:extract_bytes).and_return(nil)
  #         file_data.extract_data
  #       end

  #       pending "extract_header_data" do
  #         # allow(file_data).to receive(:extract_bytes).and_return(nil)
  #         # allow(file_data).to receive(:extract_header_data).and_return(nil)

  #         expect(file_data).to receive(:extract_header_data)
  #         file_data.extract_data
  #       end
  #     end
  #   end
  # end

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
          puts; p! file_data.valid
          puts; p! file_data.errors
          expect(file_data.errors.keys.to_a).to contain(:file_name)
          expect(file_data.errors[:file_name]).to eq("Param file_name is missing!")
        end

        it "file_ident_header_ords" do
          puts; p! file_data.valid
          puts; p! file_data.errors
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

  context "when file_name given (and it is a valid bmp file)" do
    # when given a valid bmp file...
    let(file_name) { "spec/stumpy_bmp/examples/example0/image.bmp" }
    let(file_data) { StumpyBMP::FileData.new(file_name) }

    # we expect...
    let(file_size_expected) { 138 }
    let(file_bytes_expected) {
      [
        66, 77, 138, 0, 0,
        0, 0, 0, 0, 0,
        122, 0, 0, 0, 108,
        0, 0, 0, 2, 0,
        0, 0, 2, 0, 0,
        0, 1, 0, 24, 0,
        0, 0, 0, 0, 16,
        0, 0, 0, 202, 153,
        0, 0, 202, 153, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 66,
        71, 82, 115, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 2, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 255,
        255, 255, 255, 0, 0,
        255, 0, 0, 0, 255,
        0, 0, 0,
      ]
    }

    let(file_ident_header_ords_expected) { [66, 77] }
    let(rs1_expected) { 0 }
    let(rs2_expected) { 0 }
    let(offset_expected) { 122 }
    let(header_size_expected) { 108 }
    let(width_expected) { 2 }
    let(height_expected) { 2 }
    let(color_planes_expected) { 1 }
    let(bits_expected) { 24 }
    let(compression_expected) { 0 }
    let(image_size_expected) { 16 }
    let(res_x_expected) { 39370 }
    let(res_y_expected) { 39370 }
    let(color_numbers_expected) { 0 }

    describe "#initialize" do
      it "does not raise" do
        expect { StumpyBMP::FileData.new(file_name) }.not_to raise_error
      end

      it "is valid" do
        # because at initialization, we have not *yet* read the file data
        expect(file_data.valid?).to be_false
      end

      context "sets expected values for instance variable" do
        it "file_name" do
          expect(file_data.file_name.empty?).to be_false
        end

        it "file_bytes" do
          # because at initialization, we have not *yet* read the file data
          expect(file_data.file_bytes.empty?).to be_true
        end
      end

      context "errors do NOT include" do
        it "file_name" do
          puts; p! file_data.valid
          puts; p! file_data.errors
          expect(file_data.errors.keys.to_a).not_to contain(:file_name)
        end
      end

      context "errors do include" do
        # because at initialization, we have not *yet* read the file data
        it "file_ident_header_ords" do
          puts; p! file_data.valid
          puts; p! file_data.errors
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
      # let(file_data) { StumpyBMP::FileData.new(file_name) }
      context "does call" do
        pending "File.open" do
          expect(file_data.file_name.empty?).to be_false
          expect(File).to receive(:open).with(file_name)
          file_data.extract_bytes
        end
      end

      it "sets @file_bytes with expected (mock) data" do
        expect(file_data.file_bytes).to eq(Array(UInt8).new)
        file_data.extract_bytes
        expect(file_data.file_bytes).to eq(file_bytes_expected)
      end

      it "returns expected (mock) data" do
        expect(file_data.extract_bytes).to eq(file_bytes_expected)
      end
    end

    describe "#extract_header_data" do
      # let(file_data) { StumpyBMP::FileData.new }

      before_each do
        file_data.extract_bytes
      end

      context "when file_name IS given (and not empty and is for a valid bmp file)" do
        before_each do
          file_data.extract_header_data
        end

        # let(file_data) { StumpyBMP::FileData.new(file_name) }
        # let(file_bytes_expected) {
        #   [
        #     66, 77, 138, 0, 0,
        #     0, 0, 0, 0, 0,
        #     122, 0, 0, 0, 108,
        #     0, 0, 0, 2, 0,
        #     0, 0, 2, 0, 0,
        #     0, 1, 0, 24, 0,
        #     0, 0, 0, 0, 16,
        #     0, 0, 0, 202, 153,
        #     0, 0, 202, 153, 0,
        #     0, 0, 0, 0, 0,
        #     0, 0, 0, 0, 66,
        #     71, 82, 115, 0, 0,
        #     0, 0, 0, 0, 0,
        #     0, 0, 0, 0, 0,
        #     0, 0, 0, 0, 0,
        #     0, 0, 0, 0, 0,
        #     0, 0, 0, 0, 0,
        #     0, 0, 0, 0, 0,
        #     0, 0, 0, 0, 0,
        #     0, 0, 0, 0, 0,
        #     0, 0, 0, 0, 0,
        #     0, 2, 0, 0, 0,
        #     0, 0, 0, 0, 0,
        #     0, 0, 0, 0, 0,
        #     0, 0, 0, 0, 255,
        #     255, 255, 255, 0, 0,
        #     255, 0, 0, 0, 255,
        #     0, 0, 0
        #   ]
        # }

        context "does set expected value for instance variable" do
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
            let(value_expected) { file_ident_header_ords_expected }

            it "class" do
              puts; p! file_data.file_ident_header_ords.class
              expect(variable_set.class).to eq(Array(UInt8))
            end

            it "value" do
              puts; p! file_data.file_ident_header_ords
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@file_size re" do
            let(variable_set) { file_data.file_size }
            let(value_expected) { file_size_expected }

            it "class" do
              puts; p! file_data.file_size.class
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              puts; p! file_data.file_size
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@rs1 re" do
            let(variable_set) { file_data.rs1 }
            let(value_expected) { rs1_expected } # TODO: verify!
            it "class" do
              puts; p! file_data.rs1.class
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              puts; p! file_data.rs1
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@rs2 re" do
            let(variable_set) { file_data.rs2 }
            let(value_expected) { rs2_expected } # TODO: verify!
            it "class" do
              puts; p! file_data.rs2.class
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              puts; p! file_data.rs2
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@offset re" do
            let(variable_set) { file_data.offset }
            let(value_expected) { offset_expected } # TODO: verify!
            it "class" do
              puts; p! file_data.offset.class
              expect(file_data.offset.class).to eq(UInt32)
            end

            it "value" do
              puts; p! variable_set
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@header_size re" do
            let(variable_set) { file_data.header_size }
            let(value_expected) { header_size_expected } # TODO: verify!
            it "class" do
              puts; p! file_data.header_size.class
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              puts; p! file_data.header_size
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@width re" do
            let(variable_set) { file_data.width }
            let(value_expected) { width_expected }
            it "class" do
              puts; p! file_data.width.class
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              puts; p! file_data.width
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@height re" do
            let(variable_set) { file_data.height }
            let(value_expected) { height_expected }
            it "class" do
              puts; p! file_data.height.class
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              puts; p! file_data.height
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@color_planes re" do
            let(variable_set) { file_data.color_planes }
            let(value_expected) { color_planes_expected } # TODO: verify!
            it "class" do
              puts; p! file_data.color_planes.class
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              puts; p! file_data.color_planes
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@bits re" do
            let(variable_set) { file_data.bits }
            let(value_expected) { bits_expected } # TODO: verify!
            it "class" do
              puts; p! file_data.bits.class
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              puts; p! file_data.bits
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@compression re" do
            let(variable_set) { file_data.compression }
            let(value_expected) { compression_expected } # TODO: verify!
            it "class" do
              puts; p! file_data.compression.class
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              puts; p! file_data.compression
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@image_size re" do
            let(variable_set) { file_data.image_size }
            let(value_expected) { image_size_expected } # TODO: verify!
            it "class" do
              puts; p! file_data.image_size.class
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              puts; p! file_data.image_size
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@res_x re" do
            let(variable_set) { file_data.res_x }
            let(value_expected) { res_x_expected } # TODO: verify!
            it "class" do
              puts; p! file_data.res_x.class
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              puts; p! file_data.res_x
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@res_y re" do
            let(variable_set) { file_data.res_y }
            let(value_expected) { res_y_expected } # TODO: verify!
            it "class" do
              puts; p! file_data.res_y.class
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              puts; p! file_data.res_y
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@color_numbers re" do
            let(variable_set) { file_data.color_numbers }
            let(value_expected) { color_numbers_expected } # TODO: verify!
            it "class" do
              puts; p! file_data.color_numbers.class
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              puts; p! file_data.color_numbers
              expect(variable_set).to eq(value_expected)
            end
          end
        end
      end
    end
  end
end
