module StumpyBMP
  class BMP
    getter width : Int32, height : Int32
    getter file_data : FileData
    getter canvas : StumpyCore::Canvas

    def initialize(@width = 0, @height = 0, file_name = "")
      @file_data = FileData.new(file_name)
      @canvas = StumpyCore::Canvas.new(@width, @height)
    end

    def read
      @file_data.extract_data
      @file_data.validate!
      file_data_to_canvas
    end

    private def file_data_to_canvas
      @canvas = StumpyCore::Canvas.new(@file_data.width.to_i32, @file_data.height.to_i32)

      bytes_per_pixel = (@file_data.bits / 8)

      row_size_with_padding = ((bytes_per_pixel * @file_data.width / 4.0).ceil * 4.0).to_i32
      # row_size_with_no_padding = (bytes_per_pixel * @file_data.width).to_i32
      # padding = row_size_with_padding - row_size_with_no_padding

      byte_index = @file_data.offset.to_i32

      @file_data.height.times do |y|
        row_range = (byte_index..(byte_index + row_size_with_padding - 1))

        # TODO: Handle less than one byte per color for now, we assume (and force) bytes_per_pixel to be a whole number
        pixel_byte_sets = row_range.to_a.each_slice(bytes_per_pixel.to_i32).to_a

        @file_data.width.times do |x|
          pixel_color_data = pixel_byte_sets[x]
          pixel_data_to_canvas(pixel_color_data, x, y)
        end

        byte_index += row_size_with_padding
      end

      canvas
    end

    private def pixel_data_to_canvas(pixel_color_data, x, y)
      case
      when @file_data.bits == 32
        bi, gi, ri, ai = pixel_color_data
        a = @file_data.file_bytes[ai]
        r = @file_data.file_bytes[ri]
        g = @file_data.file_bytes[gi]
        b = @file_data.file_bytes[bi]

        canvas.safe_set(x.to_i32, y.to_i32, StumpyCore::RGBA.from_rgba(r, g, b, a))
      when @file_data.bits == 24
        bi, gi, ri = pixel_color_data
        r = @file_data.file_bytes[ri]
        g = @file_data.file_bytes[gi]
        b = @file_data.file_bytes[bi]

        canvas.safe_set(x.to_i32, y.to_i32, StumpyCore::RGBA.from_rgb8(r, g, b))
      else
        # TODO: Handle less than one byte per colorl for now, we assume (and force) bytes_per_pixel to be a whole number
      end
    end
  end
end
