# require "json"

module StumpyBMP
  class BMP
    getter width : Int32, height : Int32
    getter file_data : FileData
    getter canvas : Canvas

    BYTES_PER_PIXEL = 3 # 4 # 3

    def initialize(@width = 0, @height = 0, filename = "")
      @file_data = FileData.new(filename)
      @canvas = Canvas.new(@width, @height)
    end

    # def self.read(filename)
    def read
      @file_data.extract_data
      # file_data_to_canvas(file_header, file_bytes) if @file_data.valid?
      # file_data_to_canvas if @file_data.valid?
      @file_data.validate!
      file_data_to_canvas
    end

    def file_data_to_canvas

      puts ; puts ; p! @file_data.file_bytes
      # def self.file_data_to_canvas(file_header, file_bytes)
      # Get 3 bytes at a time
      # image_data_range = (@file_data.offset...@file_data.offset + @file_data.width * @file_data.height * 3

      # canvas = StumpyCore::Canvas.new(file_header[:width].to_i32, file_header[:height].to_i32)
      @canvas = Canvas.new(@file_data.width.to_i32, @file_data.height.to_i32)

      # (image_data_range.size // 3).times do |p|
      #   # pixel_to_canvas(file_header, file_bytes, image_data_range, canvas, p)
      #   pixel_to_canvas(image_data_range,  p)
      # end
      # pixel_data_sets.with_index do |pixel_color_data,i|
      # row_size = @file_data.width

      bytes_per_pixel = (@file_data.bits / 8) # .to_i32
      row_size_with_padding = ((bytes_per_pixel * @file_data.width / 4.0).ceil * 4.0).to_i32
      row_size_with_no_padding = (bytes_per_pixel * @file_data.width).to_i32
      padding = row_size_with_padding - row_size_with_no_padding
      p! @file_data.width
      p! row_size_with_padding
      p! row_size_with_no_padding
      p! padding

      byte_index = @file_data.offset.to_i32
      # row_range = (byte_index..(byte_index + row_size_with_padding))

      @file_data.height.times do |y|
        row_range = (byte_index..(byte_index + row_size_with_padding - 1))
        puts
        p! y
        # p! byte_index.to_s.to_i(base: 16)
        # p! row_range.to_s.to_i(base: 16)
        p! byte_index
        p! row_range.begin
        p! row_range.end
        p! byte_index.digits(base: 16)
        p! row_range.begin.digits(base: 16)
        p! row_range.end.digits(base: 16)
        puts

        # pixel_bytes = 
        # row_range.to_a.each_slice(bytes_per_pixel) { |pixel_bytes_slice| p! pixel_bytes_slice }

        # TODO: Handle less than one byte per colorl for now, we assume (and force) bytes_per_pixel to be a whole number
        pixel_byte_sets = row_range.to_a.each_slice(bytes_per_pixel.to_i32).to_a # .map{|pixel_bytes_slice| pixel_bytes_slice}

        p! pixel_byte_sets

        @file_data.width.times do |x|
          pixel_color_data = pixel_byte_sets[x]
          p! [x, pixel_color_data]
          # ri,gi,bi = pixel_color_data
          bi,gi,ri,ai = pixel_color_data
          a = @file_data.file_bytes[ai]
          r = @file_data.file_bytes[ri]
          g = @file_data.file_bytes[gi]
          b = @file_data.file_bytes[bi]

          puts ; p! [pixel_color_data, [x, y], [ai, ri, gi, bi], {"arbg order" => [a, r, g, b]}, 
        {"encoded order" => [b, g, r, a]}]
          
          pixel_to_canvas(x.to_i32, y.to_i32, a,r,g,b)
        end

      #   row_range.each_slice(BYTES_PER_PIXEL).with_index do |pixel_color_data,x|

      #     # ri,gi,bi = pixel_color_data
      #     bi,gi,ri = pixel_color_data
      #     r = @file_data.file_bytes[ri]
      #     g = @file_data.file_bytes[gi]
      #     b = @file_data.file_bytes[bi]

      #     puts ; p! [pixel_color_data, [x, y], [ri, gi, bi], [r, g, b]]
          
      #     pixel_to_canvas(x, y.to_i32, r.to_i8, g.to_i8, b.to_i8)
      #   end
        byte_index += row_size_with_padding
      end

      

      # # image_data_range.each_slice(3).with_index do |pixel_color_data,i|
      # image_data_range.each_slice(3).with_index do |pixel_color_data,i|
      #   # p! [i, pixel_color_data]

      #   # pos = (i // @file_data.width) * 2

      #   # cr_from = Utils.to_u8_bounded(image_data_range.begin + (i * 3) + pos)

      #   # cr_to = Utils.to_u8_bounded(image_data_range.begin + (i * 3) + 2 + pos)

      #   # color_bytes = Utils.bit24_to_int @file_data.file_bytes[cr_from..cr_to]
      #   x,y = i_to_xy(i)
      #   ri,gi,bi = pixel_color_data
      #   # bi,gi,ri = pixel_color_data
      #   r = @file_data.file_bytes[ri]
      #   g = @file_data.file_bytes[gi]
      #   b = @file_data.file_bytes[bi]
      #   # b,g,r = pixel_color_data
      #   puts ; p! [i, pixel_color_data, [x, y], [ri, gi, bi], [r, g, b]]
        
      #   pixel_to_canvas(x, y, r,g,b)
      # end

      canvas
    end

    def image_data_range
      # Get 3 bytes at a time
      (@file_data.offset...@file_data.offset + @file_data.width * @file_data.height * BYTES_PER_PIXEL)
    end

    # def pixel_data_sets(&block)
    #   image_data_range.each_slice(3)
    # end

    def i_to_xy(i)
      x = (i % @file_data.width).to_i32
      # "invert" y because for some reason it stores the height backwards.
      y = (@file_data.height - 1 - (i // @file_data.width)).to_i32
      # extra spaces to skip because rows are seperated by two 00 bytes

      [x,y]
    end

    # def pixel_to_canvas(file_header, file_bytes, image_data_range, canvas, p)
    # def pixel_to_canvas(image_data_range, p)
    def pixel_to_canvas(x, y, a,r,g,b)
      begin
        # # r = (color_bytes >> 16).to_u16
        # # r = to_u8_bounded(color_bytes >> 16)
        # r = Utils.to_u8_bounded(color_bytes.bits(16..23))
        # # r = UInt16::MAX * (r / UInt8::MAX)

        # # g = (color_bytes >> 8).to_u16 & 0xFF
        # # g = to_u8_bounded((color_bytes >> 8) & 0xFF)
        # g = Utils.to_u8_bounded(color_bytes.bits(8..15))
        # # g = UInt16::MAX * (g / UInt8::MAX)

        # # b = (color_bytes).to_u16 & 0xFF
        # # b = to_u8_bounded(color_bytes & 0xFF)
        # b = Utils.to_u8_bounded(color_bytes.bits(0..7))
        # # b = UInt16::MAX * (b / UInt8::MAX)

        # r,g,b = pixel_color_data

        # canvas.safe_set(x, y, StumpyCore::RGBA.from_rgb8(r, g, b, a))
        canvas.safe_set(x, y, StumpyCore::RGBA.from_rgba(r, g, b, a))
      rescue ex
        msg = {
          params: {
            x: x,
            y: y,
            r: r,
            g: g,
            b: b
          },

          file_data: {
            width: @file_data.width,
            height: @file_data.height
          },

          ex: {
            klass: ex.class.name,
            message: ex.message,
            backtrace: ex.backtrace,
          }
        }
        # p! msg
        raise msg.to_json
      end
    end

  end
end
