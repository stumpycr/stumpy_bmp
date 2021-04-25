require "stumpy_core"
require "./stumpy_bmp/*"

module StumpyBMP
  def self.read(file_name)
    StumpyBMP::BMP.new(file_name: file_name).read
  end
end
