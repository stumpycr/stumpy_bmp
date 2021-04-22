require "./../spec_helper"

describe StumpyBMP do
  context "reads BMP file" do
    context "spec/images/solution2.bmp" do
      canvas = StumpyBMP.read("spec/images/solution2.bmp")
  
      context "row 0" do
        it "col 0" { canvas.get(0, 0).should eq(StumpyCore::RGBA.from_rgb8(255, 0, 0)) }
        it "col 1" { canvas.get(1, 0).should eq(StumpyCore::RGBA.from_rgb8(119, 0, 119)) }
        it "col 2" { canvas.get(2, 0).should eq(StumpyCore::RGBA.from_rgb8(0, 0, 255)) }
      end
  
      context "row 1" do
        it "col 0" { canvas.get(0, 1).should eq(StumpyCore::RGBA.from_rgb8(119, 119, 0)) }
        it "col 1" { canvas.get(1, 1).should eq(StumpyCore::RGBA.from_rgb8(255, 119, 119)) }
        it "col 2" { canvas.get(2, 1).should eq(StumpyCore::RGBA.from_rgb8(119, 119, 255)) }
      end
  
      context "row 2" do
        it "col 0" { canvas.get(0, 2).should eq(StumpyCore::RGBA.from_rgb8(255, 0, 0)) }
        it "col 1" { canvas.get(1, 2).should eq(StumpyCore::RGBA.from_rgb8(119, 255, 119)) }
        it "col 2" { canvas.get(2, 2).should eq(StumpyCore::RGBA.from_rgb8(255, 255, 255)) }
      end
  
      context "row 3" do
        it "col 0" { canvas.get(0, 3).should eq(StumpyCore::RGBA.from_rgb8(51, 51, 51)) }
        it "col 1" { canvas.get(1, 3).should eq(StumpyCore::RGBA.from_rgb8(119, 119, 119)) }
        it "col 2" { canvas.get(2, 3).should eq(StumpyCore::RGBA.from_rgb8(187, 187, 187)) }
        # TODO: Verify transparency
      end
  
      context "row 4" do
        it "col 0" { canvas.get(0, 4).should eq(StumpyCore::RGBA.from_rgb8(0, 255, 0)) }
        it "col 1" { canvas.get(1, 4).should eq(StumpyCore::RGBA.from_rgb8(0, 119, 0)) }
        it "col 2" { canvas.get(2, 4).should eq(StumpyCore::RGBA.from_rgb8(0, 0, 0)) }
      end
  
      context "row 5" do
        it "col 0" { canvas.get(0, 5).should eq(StumpyCore::RGBA.from_rgb8(51, 51, 0)) }
        it "col 1" { canvas.get(1, 5).should eq(StumpyCore::RGBA.from_rgb8(119, 0, 0)) }
        it "col 2" { canvas.get(2, 5).should eq(StumpyCore::RGBA.from_rgb8(0, 0, 119)) }
      end
  
      context "row 6" do
        it "col 0" { canvas.get(0, 6).should eq(StumpyCore::RGBA.from_rgb8(255, 0, 0)) }
        it "col 1" { canvas.get(1, 6).should eq(StumpyCore::RGBA.from_rgb8(51, 0, 51)) }
        it "col 2" { canvas.get(2, 6).should eq(StumpyCore::RGBA.from_rgb8(0, 0, 255)) }
      end
    end
  end
end
