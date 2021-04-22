require "./spec_helper"

describe StumpyBMP do
  context "reads a BMP file" do
    canvas = StumpyBMP.read("spec/images/solution.bmp")

    context "row 0" do
      it "col 0" { canvas.get(0, 0).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      it "col 1" { canvas.get(1, 0).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      it "col 2" { canvas.get(2, 0).should eq(StumpyCore::RGBA.from_rgb8(0, 0, 0)) }
      it "col 3" { canvas.get(3, 0).should eq(StumpyCore::RGBA.from_rgb8(146, 80, 0)) }
      it "col 4" { canvas.get(4, 0).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 3)) }
      it "col 5" { canvas.get(5, 0).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
    end

    context "row 1" do
      it "col 0" { canvas.get(0, 1).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
      it "col 1" { canvas.get(1, 1).should eq(StumpyCore::RGBA.from_rgb8(156, 64, 0)) }
      it "col 2" { canvas.get(2, 1).should eq(StumpyCore::RGBA.from_rgb8(28, 0, 0)) }
      it "col 3" { canvas.get(3, 1).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
      it "col 4" { canvas.get(4, 1).should eq(StumpyCore::RGBA.from_rgb8(112, 153, 160)) }
      it "col 5" { canvas.get(5, 1).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
    end

    context "row 2" do
      it "col 0" { canvas.get(0, 2).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
      it "col 1" { canvas.get(1, 2).should eq(StumpyCore::RGBA.from_rgb8(164, 2, 0)) }
      it "col 2" { canvas.get(2, 2).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
      it "col 3" { canvas.get(3, 2).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 0)) }
      it "col 4" { canvas.get(4, 2).should eq(StumpyCore::RGBA.from_rgb8(166, 2, 24)) }
      it "col 5" { canvas.get(5, 2).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
    end

    context "row 3" do
      it "col 0" { canvas.get(0, 3).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
      it "col 1" { canvas.get(1, 3).should eq(StumpyCore::RGBA.from_rgb8(168, 24, 24)) }
      it "col 2" { canvas.get(2, 3).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 3)) }
      it "col 3" { canvas.get(3, 3).should eq(StumpyCore::RGBA.from_rgb8(112, 137, 12)) }
      it "col 4" { canvas.get(4, 3).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 3)) }
      it "col 5" { canvas.get(5, 3).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 3)) }
    end

    context "row 4" do
      it "col 0" { canvas.get(0, 4).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
      it "col 1" { canvas.get(1, 4).should eq(StumpyCore::RGBA.from_rgb8(144, 16, 0)) }
      it "col 2" { canvas.get(2, 4).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
      it "col 3" { canvas.get(3, 4).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
      it "col 4" { canvas.get(4, 4).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      it "col 5" { canvas.get(5, 4).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 0)) }
    end

    context "row 5" do
      it "col 0" { canvas.get(0, 5).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
      it "col 1" { canvas.get(1, 5).should eq(StumpyCore::RGBA.from_rgb8(162, 2, 8)) }
      it "col 2" { canvas.get(2, 5).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
      it "col 3" { canvas.get(3, 5).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
      it "col 4" { canvas.get(4, 5).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      it "col 5" { canvas.get(5, 5).should eq(StumpyCore::RGBA.from_rgb8(156, 16, 0)) }
    end

    context "row 6" do
      it "col 0" { canvas.get(0, 6).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 0)) }
      it "col 1" { canvas.get(1, 6).should eq(StumpyCore::RGBA.from_rgb8(64, 0, 1)) }
      it "col 2" { canvas.get(2, 6).should eq(StumpyCore::RGBA.from_rgb8(112, 73, 76)) }
      it "col 3" { canvas.get(3, 6).should eq(StumpyCore::RGBA.from_rgb8(0, 0, 0)) }
      it "col 4" { canvas.get(4, 6).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      it "col 5" { canvas.get(5, 6).should eq(StumpyCore::RGBA.from_rgb8(156, 0, 0)) }
    end

    context "row 7" do
      it "col 0" { canvas.get(0, 7).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      it "col 1" { canvas.get(1, 7).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
      it "col 2" { canvas.get(2, 7).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      it "col 3" { canvas.get(3, 7).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
      it "col 4" { canvas.get(4, 7).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 2)) }
      it "col 5" { canvas.get(5, 7).should eq(StumpyCore::RGBA.from_rgb8(162, 24, 48)) }
    end

    context "row 8" do
      it "col 0" { canvas.get(0, 8).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      it "col 1" { canvas.get(1, 8).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
      it "col 2" { canvas.get(2, 8).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
      it "col 3" { canvas.get(3, 8).should eq(StumpyCore::RGBA.from_rgb8(112, 33, 4)) }
      it "col 4" { canvas.get(4, 8).should eq(StumpyCore::RGBA.from_rgb8(144, 48, 0)) }
      it "col 5" { canvas.get(5, 8).should eq(StumpyCore::RGBA.from_rgb8(146, 96, 0)) }
    end

    context "row 9" do
      it "col 0" { canvas.get(0, 9).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      it "col 1" { canvas.get(1, 9).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      it "col 2" { canvas.get(2, 9).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      it "col 3" { canvas.get(3, 9).should eq(StumpyCore::RGBA.from_rgb8(0, 0, 0)) }
      it "col 4" { canvas.get(4, 9).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 1)) }
      it "col 5" { canvas.get(5, 9).should eq(StumpyCore::RGBA.from_rgb8(48, 0, 0)) }
    end
  end
end
