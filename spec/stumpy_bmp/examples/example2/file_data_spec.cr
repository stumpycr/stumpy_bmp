require "./../../../spec_helper"

Spectator.describe StumpyBMP::FileData do
  context "when file_name given (and it is a valid bmp file)" do
    # when given a valid bmp file...
    let(file_name) { "spec/stumpy_bmp/examples/example2/image.bmp" }
    let(file_data) { StumpyBMP::FileData.new(file_name) }

    # we expect...
    let(file_size_expected) { 222 }
    let(file_bytes_expected) {
      [
        66, 77, 222, 0, 0,
        0, 0, 0, 0, 0,
        138, 0, 0, 0, 124,
        0, 0, 0, 3, 0,
        0, 0, 7, 0, 0,
        0, 1, 0, 32, 0,
        3, 0, 0, 0, 84,
        0, 0, 0, 19, 11,
        0, 0, 19, 11, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 255, 0, 0, 255,
        0, 0, 255, 0, 0,
        0, 0, 0, 0, 255,
        66, 71, 82, 115, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 2, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        255, 255, 51, 0, 51,
        255, 255, 0, 0, 255,
        0, 51, 51, 255, 0,
        0, 119, 255, 119, 0,
        0, 255, 0, 255, 0,
        255, 0, 119, 0, 255,
        0, 0, 0, 255, 51,
        51, 51, 123, 119, 119,
        119, 123, 187, 187, 187,
        11, 0, 255, 0, 255,
        119, 255, 119, 255, 255,
        255, 255, 255, 0, 119,
        119, 255, 119, 119, 255,
        255, 255, 119, 119, 255,
        0, 0, 255, 255, 119,
        0, 119, 255, 255, 0,
        0, 255,
      ]
    }

    # TODO: verify!
    let(file_ident_header_ords_expected) { [66, 77] }
    let(rs1_expected) { 0 }
    let(rs2_expected) { 0 }
    let(offset_expected) { 138 }
    let(header_size_expected) { 124 }
    let(width_expected) { 3 }
    let(height_expected) { 7 }
    let(color_planes_expected) { 1 }
    let(bits_expected) { 32 }
    let(compression_expected) { 3 }
    let(image_size_expected) { 84 }
    let(res_x_expected) { 2835 }
    let(res_y_expected) { 2835 }
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
          expect(file_data.errors.keys.to_a).not_to contain(:file_name)
        end
      end

      context "errors do include" do
        # because at initialization, we have not *yet* read the file data
        it "file_ident_header_ords" do
          expect(file_data.errors.keys.to_a).to contain(:file_ident_header_ords)
          expect(file_data.errors[:file_ident_header_ords]).to eq("Not a BMP file")
        end
      end
    end

    describe "#extract_data" do
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
      before_each do
        file_data.extract_bytes
      end

      context "when file_name IS given (and not empty and is for a valid bmp file)" do
        before_each do
          file_data.extract_header_data
        end

        context "does set expected value for instance variable" do
          context "@file_ident_header_ords re" do
            let(variable_set) { file_data.file_ident_header_ords }
            let(value_expected) { file_ident_header_ords_expected }

            it "class" do
              expect(variable_set.class).to eq(Array(UInt8))
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@file_size re" do
            let(variable_set) { file_data.file_size }
            let(value_expected) { file_size_expected }

            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@rs1 re" do
            let(variable_set) { file_data.rs1 }
            let(value_expected) { rs1_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@rs2 re" do
            let(variable_set) { file_data.rs2 }
            let(value_expected) { rs2_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@offset re" do
            let(variable_set) { file_data.offset }
            let(value_expected) { offset_expected }
            it "class" do
              expect(file_data.offset.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@header_size re" do
            let(variable_set) { file_data.header_size }
            let(value_expected) { header_size_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@width re" do
            let(variable_set) { file_data.width }
            let(value_expected) { width_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@height re" do
            let(variable_set) { file_data.height }
            let(value_expected) { height_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@color_planes re" do
            let(variable_set) { file_data.color_planes }
            let(value_expected) { color_planes_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@bits re" do
            let(variable_set) { file_data.bits }
            let(value_expected) { bits_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@compression re" do
            let(variable_set) { file_data.compression }
            let(value_expected) { compression_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@image_size re" do
            let(variable_set) { file_data.image_size }
            let(value_expected) { image_size_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@res_x re" do
            let(variable_set) { file_data.res_x }
            let(value_expected) { res_x_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@res_y re" do
            let(variable_set) { file_data.res_y }
            let(value_expected) { res_y_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@color_numbers re" do
            let(variable_set) { file_data.color_numbers }
            let(value_expected) { color_numbers_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end
        end
      end
    end
  end
end
