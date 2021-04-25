require "stumpy_core"
require "./stumpy_bmp/*"

module StumpyBMP
  include StumpyCore

  FILE_HEADER_RANGE       = (0..13)
  FILE_IDENT_HEADER       = "BM"
  FILE_IDENT_HEADER_RANGE = (0..1)

  FILE_SIZE_RANGE = (2..5)
  FILE_RS1_RANGE  = (6..7)
  FILE_RS2_RANGE  = (8..9)

  FILE_OFFSET_RANGE = (10..13)

  IMAGE_HEADER_SIZE            = 40
  IMAGE_HEADER_RANGE           = (14..53)
  IMAGE_HEADER_SIZE_RANGE      = (14..17)
  IMAGE_WIDTH_RANGE            = (18..21)
  IMAGE_HEIGHT_RANGE           = (22..25)
  IMAGE_COLOR_PLANES_RANGE     = (26..27)
  IMAGE_BITS_RANGE             = (28..29)
  IMAGE_COMPRESSION            = 0
  IMAGE_COMPRESSION_RANGE      = (30..33)
  IMAGE_SIZE_RANGE             = (34..37)
  IMAGE_RESOLUTION_X_RANGE     = (38..41)
  IMAGE_RESOLUTION_Y_RANGE     = (42..45)
  IMAGE_COLOR_NUMBERS_RANGE    = (46..49)
  IMAGE_IMPORTANT_COLORS_RANGE = (50..53)

  TWO_E_24 = 1.to_u32 << 24
  TWO_E_16 = 1.to_u32 << 16
  TWO_E_8  = 1.to_u32 << 8

  def self.to_u8_bounded(x)
    to_bounded(x, UInt8::MAX).to_u8
  end

  def self.to_u16_bounded(x)
    to_bounded(x, UInt16::MAX).to_u16
  end

  def self.to_u32_bounded(x)
    to_bounded(x, UInt32::MAX).to_u32
  end

  def self.to_bounded(x, max)
    x = x.floor # round
    case
    when x < 0
      0
    when x > max
      max
    else
      x
    end
  end

  def self.read(filename)
    file_bytes = read_file_bytes(filename)

    # raise "Not a BMP file" if file_bytes[FILE_IDENT_HEADER_RANGE].map(&.chr).join != FILE_IDENT_HEADER
    validate!(file_bytes)

    file_header = extract_header_data(file_bytes)

    populate_canvas(file_header, file_bytes)
  end

  def self.read_file_bytes(filename)
    file = File.open(filename)
    file_bytes = [] of UInt8

    # file must be read as UInt8 bytes
    while (c = file.read_byte)
      file_bytes << c
    end

    file_bytes
  end

  def self.extract_header_data(file_bytes)
    file_header = {} of Symbol => UInt32

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

    file_header
  end

  def self.validate!(file_bytes)
    raise "Not a BMP file" if file_bytes[FILE_IDENT_HEADER_RANGE].map(&.chr).join != FILE_IDENT_HEADER
  end

  def self.populate_canvas(file_header, file_bytes)
    # Get 3 bytes at a time
    image_data_range = (file_header[:offset]...(file_header[:offset] + file_header[:width] * file_header[:height] * 3))

    canvas = StumpyCore::Canvas.new(file_header[:width].to_i32, file_header[:height].to_i32)

    (image_data_range.size // 3).times do |p|
      populate_pixel(file_header, file_bytes, image_data_range, canvas, p)
    end

    canvas
  end

  def self.populate_pixel(file_header, file_bytes, image_data_range, canvas, p)
    x = (p % file_header[:width]).to_i32
    # "invert" y because for some reason it stores the height backwards.
    y = (file_header[:height] - 1 - (p / file_header[:width])).to_i32
    # extra spaces to skip because rows are seperated by two 00 bytes
    pos = (p / file_header[:width]) * 2

    cr_from = to_u8_bounded(image_data_range.begin + (p * 3) + pos)

    cr_to = to_u8_bounded(image_data_range.begin + (p * 3) + 2 + pos)

    color_bytes = bit24_to_int file_bytes[cr_from..cr_to]

    # r = (color_bytes >> 16).to_u16
    # r = to_u8_bounded(color_bytes >> 16)
    r = to_u8_bounded(color_bytes.bits(16..23))
    # r = UInt16::MAX * (r / UInt8::MAX)

    # g = (color_bytes >> 8).to_u16 & 0xFF
    # g = to_u8_bounded((color_bytes >> 8) & 0xFF)
    g = to_u8_bounded(color_bytes.bits(8..15))
    # g = UInt16::MAX * (g / UInt8::MAX)

    # b = (color_bytes).to_u16 & 0xFF
    # b = to_u8_bounded(color_bytes & 0xFF)
    b = to_u8_bounded(color_bytes.bits(0..7))
    # b = UInt16::MAX * (b / UInt8::MAX)

    canvas.safe_set(x, y, StumpyCore::RGBA.from_rgb8(r, g, b))
  end

  def self.long_to_int(long_chars) : UInt32
    to_u32_bounded(
      ((long_chars[3]? || 0).to_u32 * (TWO_E_24)) +
      ((long_chars[2]? || 0).to_u32 * (TWO_E_16)) +
      ((long_chars[1]? || 0).to_u32 * (TWO_E_8)) +
      (long_chars[0]? || 0).to_u32
    )
  end

  def self.bit24_to_int(bit24_chars)
    to_u32_bounded(
      (bit24_chars[2]? || 0).to_u32 * (TWO_E_16) +
      (bit24_chars[1]? || 0).to_u32 * (TWO_E_8) +
      (bit24_chars[0]? || 0).to_u32
    )
  end

  def self.rgb8_to_int(rgb8_chars)
    to_u32_bounded(
      (rgb8_chars[0]? || 0).to_u32 * (TWO_E_16) +
      (rgb8_chars[1]? || 0).to_u32 * (TWO_E_8) +
      (rgb8_chars[2]? || 0).to_u32
    )
  end

  def self.bit16_to_int(bit16_chars)
    # to_u16_bounded(
    to_u32_bounded(
      (bit16_chars[1]? || 0).to_u16 * (TWO_E_8) +
      (bit16_chars[0]? || 0).to_u16
    )
  end
end
