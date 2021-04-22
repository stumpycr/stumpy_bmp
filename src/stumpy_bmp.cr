require "stumpy_core"
require "./stumpy_bmp/*"

module StumpyBMP
  FILE_HEADER_RANGE = (0..13)
  FILE_IDENT_HEADER = "BM"
  FILE_IDENT_HEADER_RANGE = (0..1)

  FILE_SIZE_RANGE = (2..5)
  FILE_RS1_RANGE = (6..7)
  FILE_RS2_RANGE = (8..9)

  FILE_OFFSET_RANGE = (10..13)

  IMAGE_HEADER_SIZE = 40
  IMAGE_HEADER_RANGE = (14..53)
  IMAGE_HEADER_SIZE_RANGE = (14..17)
  IMAGE_WIDTH_RANGE = (18..21)
  IMAGE_HEIGHT_RANGE = (22..25)
  IMAGE_COLOR_PLANES_RANGE = (26..27)
  IMAGE_BITS_RANGE = (28..29)
  IMAGE_COMPRESSION = 0
  IMAGE_COMPRESSION_RANGE = (30..33)
  IMAGE_SIZE_RANGE = (34..37)
  IMAGE_RESOLUTION_X_RANGE = (38..41)
  IMAGE_RESOLUTION_Y_RANGE = (42..45)
  IMAGE_COLOR_NUMBERS_RANGE = (46..49)
  IMAGE_IMPORTANT_COLORS_RANGE = (50..53)
      
  def self.to_u8_bounded(x)
    case
    when x < 0
      0
    when x > UInt8::MAX
      255
    else
      x.round
    end.to_u8
  end

  def self.to_u16_bounded(x)
    case
    when x < 0
      0
    when x > UInt16::MAX
      255
    else
      x.round
    end.to_u16
  end

  def self.to_u32_bounded(x)
    case
    when x < 0
      0
    when x > UInt32::MAX
      255
    else
      x.round
    end.to_u32
  end


  def self.read(filename)
    file = File.open(filename)
    file_bytes = [] of UInt8
    file_header = {} of Symbol => UInt32

    #file must be read as UInt8 bytes
    while(c = file.read_byte)
      file_bytes << c
    end

    raise "Not a BMP file" if file_bytes[FILE_IDENT_HEADER_RANGE].map(&.chr).join != FILE_IDENT_HEADER

    file_header[:file_size] = long_to_int file_bytes[FILE_SIZE_RANGE]
    file_header[:rs1] = bit16_to_int(file_bytes[FILE_RS1_RANGE]).to_u32
    file_header[:rs2] = bit16_to_int(file_bytes[FILE_RS2_RANGE]).to_u32
    file_header[:offset] = long_to_int file_bytes[FILE_OFFSET_RANGE]
    file_header[:header_size] = long_to_int file_bytes[IMAGE_HEADER_SIZE_RANGE]
    file_header[:width] = long_to_int file_bytes[IMAGE_WIDTH_RANGE]
    file_header[:height] = long_to_int file_bytes[IMAGE_HEIGHT_RANGE]
    file_header[:color_planes] = bit16_to_int(file_bytes[IMAGE_COLOR_PLANES_RANGE]).to_u32
    file_header[:bits] = bit16_to_int(file_bytes[IMAGE_BITS_RANGE]).to_u32
    file_header[:compression] = long_to_int file_bytes[IMAGE_COMPRESSION_RANGE]
    file_header[:size] = long_to_int file_bytes[IMAGE_SIZE_RANGE]
    file_header[:res_x] = long_to_int file_bytes[IMAGE_RESOLUTION_X_RANGE]
    file_header[:res_y] = long_to_int file_bytes[IMAGE_RESOLUTION_Y_RANGE]
    file_header[:color_numbers] = long_to_int file_bytes[IMAGE_COLOR_NUMBERS_RANGE]
    file_header[:important_colors] = long_to_int file_bytes[IMAGE_IMPORTANT_COLORS_RANGE]

    colors = StumpyCore::Canvas.new(file_header[:width].to_i32, file_header[:height].to_i32)

    image_data_range = (file_header[:offset]...(file_header[:offset] + file_header[:width] * file_header[:height] * 3))
    # Get 3 bytes at a time
    (image_data_range.size // 3).times do |p|
      x = (p % file_header[:width]).to_i32
      # "invert" y because for some reason it stores the height backwards.
      y = (file_header[:height] - 1 - (p / file_header[:width])).to_i32
      # extra spaces to skip because rows are seperated by two 00 bytes
      pos = (p / file_header[:width]) * 2
      # cr = ((image_data_range.begin + (p * 3) + pos)..(image_data_range.begin + (p * 3) + 2 + pos))
      # cr_from = (image_data_range.begin + (p * 3) + pos).round.to_u8
      # cr_to = (image_data_range.begin + (p * 3) + 2 + pos).round.to_u8
      cr_from = to_u8_bounded(image_data_range.begin + (p * 3) + pos) # .floor.to_u8

      cr_to = to_u8_bounded(image_data_range.begin + (p * 3) + 2 + pos)
      # cr_to = (image_data_range.begin + (p * 3) + 2 + pos).floor.to_u8
      # cr_to = begin
      #   tmp_cr_to = (image_data_range.begin + (p * 3) + 2 + pos) # .floor.to_u8
      #   case
      #   when tmp_cr_to < 0.0
      #     0.0
      #   when tmp_cr_to > 255.0
      #     255
      #   else
      #     tmp_cr_to
      #   end.floor.to_u8
      # rescue exception
      #   # raise "image_data_range.class: #{image_data_range.class}; p.class: #{p.class}; pos.class: #{pos.class}"
      #   # raise "image_data_range: #{image_data_range}; p: #{p}; pos: #{pos}"
      #   puts "cr_to = #{122 + (40*3) + 2 + (13  + 1.0 / 3)}"
      #   raise "image_data_range.class: #{image_data_range.class}; p.class: #{p.class}; pos.class: #{pos.class} \n image_data_range: #{image_data_range}; p: #{p}; pos: #{pos}"
      # end


      # cr = (cr_from..cr_to)

      # raise "file_bytes.class: #{file_bytes.class}" # "; cr.class: #{cr.class}"
      # color_bytes = bit24_to_int file_bytes[cr]
      color_bytes = bit24_to_int file_bytes[cr_from..cr_to]
      # raise "file_bytes.class: #{file_bytes.class}; color_bytes.class: #{color_bytes.class}; color_bytes.inspect: #{color_bytes.inspect}; UInt8::MAX: #{UInt8::MAX}; UInt32::MAX: #{UInt32::MAX}; Int32::MAX: #{Int32::MAX}"
      # color_bytes = 1

      r = (color_bytes >> 16).to_u16
      # r = UInt16::MAX * (r / UInt8::MAX)

      g = (color_bytes >> 8).to_u16 & 0xFF
      g = (color_bytes >> 8 & 0xFF).to_u16
      # g = UInt16::MAX * (g / UInt8::MAX)

      # b = (color_bytes).to_u16 & 0xFF
      b = (color_bytes & 0xFF).to_u16
      # b = UInt16::MAX * (b / UInt8::MAX)

      colors.safe_set(x, y, StumpyCore::RGBA.from_rgb8(r, g, b))
    end

    colors
  end

  def self.long_to_int(long_chars) : UInt32
    # ((long_chars[3]? || 0).to_u32 * (2**24)) + ((long_chars[2]? || 0).to_u32 * (2**16)) + ((long_chars[1]? || 0).to_u32 * (2**8)) + (long_chars[0]? || 0).to_u32
    begin
      to_u32_bounded(
        ((long_chars[3]? || 0) * (2.0**24)) +
        ((long_chars[2]? || 0) * (2.0**16)) + 
        ((long_chars[1]? || 0) * (2.0**8)) + 
        (long_chars[0]? || 0)
      )
    rescue ex
      raise "ex: #{ex}; long_chars.class: #{long_chars.class}; long_chars: #{long_chars}; 2**24 === #{2**24}; 2**16 === #{2**16}; 2**8 === #{2**8}"
    end
  end

  def self.bit24_to_int(bit24_chars)
    # bit24_chars[2].to_u32 * (2**16) + bit24_chars[1].to_u32 * (2**8) + bit24_chars[0].to_u32
    begin
      v = 1.0 * bit24_chars[0]
      if bit24_chars.size > 1
        v += bit24_chars[1] * (2.0**8)
      end
      if bit24_chars.size > 2
        v += bit24_chars[2] * (2.0**16)
      end
      # to_u32_bounded(bit24_chars[2] * (2.0**16) + bit24_chars[1] * (2.0**8) + bit24_chars[0])
      to_u32_bounded(v)
    rescue ex
      raise "ex: #{ex}; v: #{v}; bit24_chars.size: #{bit24_chars.size}; bit24_chars.class: #{bit24_chars.class}; bit24_chars: #{bit24_chars}; 2**16 === #{2**16}; 2**8 === #{2**8}"
    end
  end

  def self.rgb8_to_int(rgb8_chars)
    # rgb8_chars[0].to_u32 * (2**16) + rgb8_chars[1].to_u32 * (2**8) + rgb8_chars[2].to_u32
    begin
      to_u32_bounded(rgb8_chars[0] * (2**16) + rgb8_chars[1] * (2**8) + rgb8_chars[2])
    rescue ex
      raise "ex: #{ex}; rgb8_chars.class: #{rgb8_chars.class}; rgb8_chars: #{rgb8_chars}; 2**16 === #{2**16}; 2**8 === #{2**8}"
    end
  end

  def self.bit16_to_int(bit16_chars)
    bit16_chars[1].to_u16 * (2**8) + bit16_chars[0].to_u16
  end
end
