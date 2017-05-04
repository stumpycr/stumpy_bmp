require "stumpy_core"

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
  
  def self.read(filename)
    file = File.open(filename)
    file_bytes = [] of UInt8
    file_header = {} of Symbol => UInt32
    
    #file must be read as UInt8 bytes
    while(c = file.read_byte)
      file_bytes << c
    end

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


    puts "FILE HEADER:"
    puts "  -BM: #{file_bytes[FILE_IDENT_HEADER_RANGE].map(&.chr).join}"
    puts "  -FS: #{file_header[:file_size]} C#: #{file_bytes.size}"
    puts "  -RS1: #{file_header[:rs1]}"
    puts "  -RS2: #{file_header[:rs2]}"
    puts "  -OS: #{file_header[:offset]}"
    puts
    puts "IMAGE HEADER:"
    puts "  -HS: #{file_header[:header_size]}"
    puts "  -IW: #{file_header[:width]}"
    puts "  -IH: #{file_header[:height]}"
    puts "  -CP: #{file_header[:color_planes]}"    
    puts "  -BP: #{file_header[:bits]}"    
    puts "  -CB: #{file_header[:compression]}"    
    puts "  -IS: #{file_header[:size]}"    
    puts "  -IX: #{file_header[:res_x]}"    
    puts "  -IY: #{file_header[:res_y]}"    
    puts "  -NC: #{file_header[:color_numbers]}"    
    puts "  -IC: #{file_header[:important_colors]}"    
    puts
    puts "IMAGE_DATA"

    colors = StumpyCore::Canvas.new(file_header[:width].to_i32, file_header[:height].to_i32)    
    
    image_data_range = (file_header[:offset]...(file_header[:offset] + file_header[:width] * file_header[:height] * 3))
    puts "IDR: #{image_data_range.size}"
    # Get 3 bytes at a time
    (image_data_range.size/3).times do |p|
      x = p % file_header[:width]
      # "invert" y because for some reason it stores the height backwards.
      y = (file_header[:height] - 1 - (p / file_header[:width])).to_i32
      # extra spaces to skip because rows are seperated by two 00 bytes
      pos = (p / file_header[:width]) * 2
      cr = ((image_data_range.begin + (p * 3) + pos)..(image_data_range.begin + (p * 3) + 2 + pos))
      color_bytes = bit24_to_int file_bytes[cr]
      
      r = (color_bytes >> 16).to_u16
      #r = UInt16::MAX * (r / UInt8::MAX)

      g = (color_bytes >> 8).to_u16 & 0xFF
      #g = UInt16::MAX * (g / UInt8::MAX)

      b = (color_bytes).to_u16 & 0xFF
      #b = UInt16::MAX * (b / UInt8::MAX)

      puts "#{r.to_s(16).rjust(2,'0')}#{g.to_s(16).rjust(2,'0')}#{b.to_s(16).rjust(2,'0')} @ #{x} #{y} #{p} #{pos}"
      colors.safe_set(x, y, StumpyCore::RGBA.from_rgb8(r, g, b))
    end

    file_header[:height].times do |y|
      file_header[:width].times do |x|
        print "| #{x.to_s(16).rjust(3)} #{y.to_s(16).rjust(3)} > #{rgb8_to_int(colors[x, y].to_rgb8).to_s(16).rjust(6, '0')} | "
      end
      puts
    end

    colors
  end

  def self.long_to_int(long_chars) : UInt32
    ((long_chars[3]? || 0).to_u32 * (2**24)) + ((long_chars[2]? || 0).to_u32 * (2**16)) + ((long_chars[1]? || 0).to_u32 * (2**8)) + (long_chars[0]? || 0).to_u32
  end

  def self.bit24_to_int(bit24_chars)
    bit24_chars[2].to_u32 * (2**16) + bit24_chars[1].to_u32 * (2**8) + bit24_chars[0].to_u32
  end

  def self.rgb8_to_int(rgb8_chars)
    rgb8_chars[0].to_u32 * (2**16) + rgb8_chars[1].to_u32 * (2**8) + rgb8_chars[2].to_u32
  end

  def self.bit16_to_int(bit16_chars)
    bit16_chars[1].to_u16 * (2**8) + bit16_chars[0].to_u16
  end
end