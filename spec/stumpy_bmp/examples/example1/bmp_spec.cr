require "./../../../spec_helper"

Spectator.describe StumpyBMP::BMP do
  context "#read" do
    context "spec/stumpy_bmp/examples/example1/image.bmp" do
      let(bmp) { StumpyBMP::BMP.new(file_name: "spec/stumpy_bmp/examples/example1/image.bmp") }
      before_each { bmp.read }

      # NOTE: The rows are encoded bottom to top and left to right
      context "row 9" do
        it "col 0" { expect(bmp.canvas.get(0, 9)).to eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
        it "col 1" { expect(bmp.canvas.get(1, 9)).to eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
        it "col 2" { expect(bmp.canvas.get(2, 9)).to eq(StumpyCore::RGBA.from_rgb8(0, 0, 0)) }
        it "col 3" { expect(bmp.canvas.get(3, 9)).to eq(StumpyCore::RGBA.from_rgb8(146, 80, 0)) }
        it "col 4" { expect(bmp.canvas.get(4, 9)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 3)) }
        it "col 5" { expect(bmp.canvas.get(5, 9)).to eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      end

      context "row 8" do
        it "col 0" { expect(bmp.canvas.get(0, 8)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
        it "col 1" { expect(bmp.canvas.get(1, 8)).to eq(StumpyCore::RGBA.from_rgb8(156, 64, 0)) }
        it "col 2" { expect(bmp.canvas.get(2, 8)).to eq(StumpyCore::RGBA.from_rgb8(28, 0, 0)) }
        it "col 3" { expect(bmp.canvas.get(3, 8)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
        it "col 4" { expect(bmp.canvas.get(4, 8)).to eq(StumpyCore::RGBA.from_rgb8(112, 153, 160)) }
        it "col 5" { expect(bmp.canvas.get(5, 8)).to eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      end

      context "row 7" do
        it "col 0" { expect(bmp.canvas.get(0, 7)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
        it "col 1" { expect(bmp.canvas.get(1, 7)).to eq(StumpyCore::RGBA.from_rgb8(164, 2, 0)) }
        it "col 2" { expect(bmp.canvas.get(2, 7)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
        it "col 3" { expect(bmp.canvas.get(3, 7)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 0)) }
        it "col 4" { expect(bmp.canvas.get(4, 7)).to eq(StumpyCore::RGBA.from_rgb8(166, 2, 24)) }
        it "col 5" { expect(bmp.canvas.get(5, 7)).to eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      end

      context "row 6" do
        it "col 0" { expect(bmp.canvas.get(0, 6)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
        it "col 1" { expect(bmp.canvas.get(1, 6)).to eq(StumpyCore::RGBA.from_rgb8(168, 24, 24)) }
        it "col 2" { expect(bmp.canvas.get(2, 6)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 3)) }
        it "col 3" { expect(bmp.canvas.get(3, 6)).to eq(StumpyCore::RGBA.from_rgb8(112, 137, 12)) }
        it "col 4" { expect(bmp.canvas.get(4, 6)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 3)) }
        it "col 5" { expect(bmp.canvas.get(5, 6)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 3)) }
      end

      context "row 5" do
        it "col 0" { expect(bmp.canvas.get(0, 5)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
        it "col 1" { expect(bmp.canvas.get(1, 5)).to eq(StumpyCore::RGBA.from_rgb8(144, 16, 0)) }
        it "col 2" { expect(bmp.canvas.get(2, 5)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
        it "col 3" { expect(bmp.canvas.get(3, 5)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
        it "col 4" { expect(bmp.canvas.get(4, 5)).to eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
        it "col 5" { expect(bmp.canvas.get(5, 5)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 0)) }
      end

      context "row 4" do
        it "col 0" { expect(bmp.canvas.get(0, 4)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
        it "col 1" { expect(bmp.canvas.get(1, 4)).to eq(StumpyCore::RGBA.from_rgb8(162, 2, 8)) }
        it "col 2" { expect(bmp.canvas.get(2, 4)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
        it "col 3" { expect(bmp.canvas.get(3, 4)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
        it "col 4" { expect(bmp.canvas.get(4, 4)).to eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
        it "col 5" { expect(bmp.canvas.get(5, 4)).to eq(StumpyCore::RGBA.from_rgb8(156, 16, 0)) }
      end

      context "row 3" do
        it "col 0" { expect(bmp.canvas.get(0, 3)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 0)) }
        it "col 1" { expect(bmp.canvas.get(1, 3)).to eq(StumpyCore::RGBA.from_rgb8(64, 0, 1)) }
        it "col 2" { expect(bmp.canvas.get(2, 3)).to eq(StumpyCore::RGBA.from_rgb8(112, 73, 76)) }
        it "col 3" { expect(bmp.canvas.get(3, 3)).to eq(StumpyCore::RGBA.from_rgb8(0, 0, 0)) }
        it "col 4" { expect(bmp.canvas.get(4, 3)).to eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
        it "col 5" { expect(bmp.canvas.get(5, 3)).to eq(StumpyCore::RGBA.from_rgb8(156, 0, 0)) }
      end

      context "row 6" do
        it "col 0" { expect(bmp.canvas.get(0, 2)).to eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
        it "col 1" { expect(bmp.canvas.get(1, 2)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
        it "col 2" { expect(bmp.canvas.get(2, 2)).to eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
        it "col 3" { expect(bmp.canvas.get(3, 2)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
        it "col 4" { expect(bmp.canvas.get(4, 2)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
        it "col 5" { expect(bmp.canvas.get(5, 2)).to eq(StumpyCore::RGBA.from_rgb8(162, 24, 48)) }
      end

      context "row 1" do
        it "col 0" { expect(bmp.canvas.get(0, 1)).to eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
        it "col 1" { expect(bmp.canvas.get(1, 1)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
        it "col 2" { expect(bmp.canvas.get(2, 1)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
        it "col 3" { expect(bmp.canvas.get(3, 1)).to eq(StumpyCore::RGBA.from_rgb8(112, 33, 4)) }
        it "col 4" { expect(bmp.canvas.get(4, 1)).to eq(StumpyCore::RGBA.from_rgb8(144, 48, 0)) }
        it "col 5" { expect(bmp.canvas.get(5, 1)).to eq(StumpyCore::RGBA.from_rgb8(146, 96, 0)) }
      end

      context "row 0" do
        it "col 0" { expect(bmp.canvas.get(0, 0)).to eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
        it "col 1" { expect(bmp.canvas.get(1, 0)).to eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
        it "col 2" { expect(bmp.canvas.get(2, 0)).to eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
        it "col 3" { expect(bmp.canvas.get(3, 0)).to eq(StumpyCore::RGBA.from_rgb8(0, 0, 0)) }
        it "col 4" { expect(bmp.canvas.get(4, 0)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
        it "col 5" { expect(bmp.canvas.get(5, 0)).to eq(StumpyCore::RGBA.from_rgb8(48, 0, 0)) }
      end
    end
  end
end
