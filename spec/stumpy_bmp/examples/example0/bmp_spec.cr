require "./../../../spec_helper"

Spectator.describe StumpyBMP::BMP do
  context "#read" do
    context "spec/stumpy_bmp/examples/example0/image.bmp" do
      let(file_name) { "spec/stumpy_bmp/examples/example0/image.bmp" }
      let(bmp) { StumpyBMP::BMP.new(file_name: file_name) }
      before_each { bmp.read }

      # NOTE: The rows are encoded bottom to top and left to right
      context "row 1" do
        it "col 0" { expect(bmp.canvas.get(0, 1)).to eq(StumpyCore::RGBA.from_rgba(0, 0, 255, 255)) } # blue
        it "col 1" { expect(bmp.canvas.get(1, 1)).to eq(StumpyCore::RGBA.from_rgba(0, 255, 0, 255)) } # green
      end

      context "row 0" do
        it "col 0" { expect(bmp.canvas.get(0, 0)).to eq(StumpyCore::RGBA.from_rgba(255, 0, 0, 255)) }     # red
        it "col 1" { expect(bmp.canvas.get(1, 0)).to eq(StumpyCore::RGBA.from_rgba(255, 255, 255, 255)) } # white
      end
    end
  end
end
