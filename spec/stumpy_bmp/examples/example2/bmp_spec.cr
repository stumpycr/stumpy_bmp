require "./../../../spec_helper"

Spectator.describe StumpyBMP::BMP do
  context "#read" do
    context "spec/stumpy_bmp/examples/example2/image.bmp" do
      let(bmp) { StumpyBMP::BMP.new(file_name: "spec/stumpy_bmp/examples/example2/image.bmp") }
      before_each { bmp.read }

      # NOTE: The rows are encoded bottom to top and left to right
      context "row 6" do
        it "col 0" { expect(bmp.canvas.get(0, 6)).to eq(StumpyCore::RGBA.from_rgba(255, 0, 0, 255)) }
        it "col 1" { expect(bmp.canvas.get(1, 6)).to eq(StumpyCore::RGBA.from_rgba(119, 0, 119, 255)) }
        it "col 2" { expect(bmp.canvas.get(2, 6)).to eq(StumpyCore::RGBA.from_rgba(0, 0, 255, 255)) }
      end

      context "row 5" do
        it "col 0" { expect(bmp.canvas.get(0, 5)).to eq(StumpyCore::RGBA.from_rgba(119, 119, 0, 255)) }
        it "col 1" { expect(bmp.canvas.get(1, 5)).to eq(StumpyCore::RGBA.from_rgba(255, 119, 119, 255)) }
        it "col 2" { expect(bmp.canvas.get(2, 5)).to eq(StumpyCore::RGBA.from_rgba(119, 119, 255, 255)) }
      end

      context "row 4" do
        it "col 0" { expect(bmp.canvas.get(0, 4)).to eq(StumpyCore::RGBA.from_rgba(0, 255, 0, 255)) }
        it "col 1" { expect(bmp.canvas.get(1, 4)).to eq(StumpyCore::RGBA.from_rgba(119, 255, 119, 255)) }
        it "col 2" { expect(bmp.canvas.get(2, 4)).to eq(StumpyCore::RGBA.from_rgba(255, 255, 255, 255)) }
      end

      context "row 3" do
        it "col 0" { expect(bmp.canvas.get(0, 3)).to eq(StumpyCore::RGBA.from_rgba(51, 51, 51, 123)) }
        it "col 1" { expect(bmp.canvas.get(1, 3)).to eq(StumpyCore::RGBA.from_rgba(119, 119, 119, 123)) }
        it "col 2" { expect(bmp.canvas.get(2, 3)).to eq(StumpyCore::RGBA.from_rgba(187, 187, 187, 11)) }
        # TODO: Verify transparency
      end

      context "row 2" do
        it "col 0" { expect(bmp.canvas.get(0, 2)).to eq(StumpyCore::RGBA.from_rgba(0, 255, 0, 255)) }
        it "col 1" { expect(bmp.canvas.get(1, 2)).to eq(StumpyCore::RGBA.from_rgba(0, 119, 0, 255)) }
        it "col 2" { expect(bmp.canvas.get(2, 2)).to eq(StumpyCore::RGBA.from_rgba(0, 0, 0, 255)) }
      end

      context "row 1" do
        it "col 0" { expect(bmp.canvas.get(0, 1)).to eq(StumpyCore::RGBA.from_rgba(51, 51, 0, 255)) }
        it "col 1" { expect(bmp.canvas.get(1, 1)).to eq(StumpyCore::RGBA.from_rgba(119, 0, 0, 255)) }
        it "col 2" { expect(bmp.canvas.get(2, 1)).to eq(StumpyCore::RGBA.from_rgba(0, 0, 119, 255)) }
      end

      context "row 0" do
        it "col 0" { expect(bmp.canvas.get(0, 0)).to eq(StumpyCore::RGBA.from_rgba(255, 0, 0, 255)) }
        it "col 1" { expect(bmp.canvas.get(1, 0)).to eq(StumpyCore::RGBA.from_rgba(51, 0, 51, 255)) }
        it "col 2" { expect(bmp.canvas.get(2, 0)).to eq(StumpyCore::RGBA.from_rgba(0, 0, 255, 255)) }
      end
    end
  end
end
