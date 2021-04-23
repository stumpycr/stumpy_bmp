
module StumpyBMP
  class FileData
    property filename : String
    property file_bytes = [] of UInt8
    getter errors = Hash(Symbol, String).new
    getter valid = false
    
    property file_ident_header_ords = Array(UInt8).new(2,0) # = [0.to_u8,0.to_u8]
    property file_size : UInt32 = 0
    property rs1 : UInt32 = 0
    property rs2 : UInt32 = 0
    property offset : UInt32 = 0
    property header_size : UInt32 = 0
    property width : UInt32 = 0
    property height : UInt32 = 0
    property color_planes : UInt32 = 0
    property bits : UInt32 = 0
    property compression : UInt32 = 0
    property image_size : UInt32 = 0
    property res_x : UInt32 = 0
    property res_y : UInt32 = 0
    property color_numbers : UInt32 = 0
    property important_colors : UInt32 = 0

    # FILE_HEADER_RANGE       = (0..13)
    FILE_IDENT_HEADER       = "BM"
    FILE_IDENT_HEADER_RANGE = (0..1)
  
    FILE_SIZE_RANGE = (2..5)
    FILE_RS1_RANGE  = (6..7)
    FILE_RS2_RANGE  = (8..9)
  
    FILE_OFFSET_RANGE = (10..13)
  
    # IMAGE_HEADER_SIZE            = 40
    # IMAGE_HEADER_RANGE           = (14..53)
    IMAGE_HEADER_SIZE_RANGE      = (14..17)
    IMAGE_WIDTH_RANGE            = (18..21)
    IMAGE_HEIGHT_RANGE           = (22..25)
    IMAGE_COLOR_PLANES_RANGE     = (26..27)
    IMAGE_BITS_RANGE             = (28..29)
    # IMAGE_COMPRESSION            = 0
    IMAGE_COMPRESSION_RANGE      = (30..33)
    IMAGE_SIZE_RANGE             = (34..37)
    IMAGE_RESOLUTION_X_RANGE     = (38..41)
    IMAGE_RESOLUTION_Y_RANGE     = (42..45)
    IMAGE_COLOR_NUMBERS_RANGE    = (46..49)
    IMAGE_IMPORTANT_COLORS_RANGE = (50..53)


    def initialize(@filename = "")
      # validate
    end

    def extract_data
      extract_bytes
      extract_header_data
    end

    def extract_bytes
      file = File.open(filename)
      @file_bytes = [] of UInt8
  
      # file must be read as UInt8 bytes
      while (c = file.read_byte)
        @file_bytes << c
      end
  
      @file_bytes

      # validate # !
    end

    def file_ident_header_range_text
      @file_ident_header_ords.map(&.chr).join
    end

    def validate # (file_bytes)
      # raise "Not a BMP file" if file_bytes[FILE_IDENT_HEADER_RANGE].map(&.chr).join != FILE_IDENT_HEADER
      @errors[:file_ident_header_ords] = "Not a BMP file" if file_ident_header_range_text != FILE_IDENT_HEADER

      # TODO: more validations

      valid = @errors.keys.empty?
    end

    def valid?
      validate

      @errors.keys.empty? # valid
    end

    def validate!
      validate

      raise @errors.to_json unless @errors.keys.empty? # valid
    end

    def valid?
      @valid
    end

    def extract_header_data # (filename)
      # file_header = {} of Symbol => UInt32
      # @file_ident_header_ords = Utils.bit16_to_int(file_bytes[FILE_IDENT_HEADER_RANGE])
      @file_ident_header_ords = file_bytes[FILE_IDENT_HEADER_RANGE]
      @file_size = Utils.long_to_int(file_bytes[FILE_SIZE_RANGE])
      @rs1 = Utils.bit16_to_int(file_bytes[FILE_RS1_RANGE]) #.to_u32
      @rs2 = Utils.bit16_to_int(file_bytes[FILE_RS2_RANGE]) #.to_u32
      @offset = Utils.long_to_int(file_bytes[FILE_OFFSET_RANGE])
      @header_size = Utils.long_to_int(file_bytes[IMAGE_HEADER_SIZE_RANGE])
      @width = Utils.long_to_int(file_bytes[IMAGE_WIDTH_RANGE])
      @height = Utils.long_to_int(file_bytes[IMAGE_HEIGHT_RANGE])
      @color_planes = Utils.bit16_to_int(file_bytes[IMAGE_COLOR_PLANES_RANGE]) #.to_u32
      @bits = Utils.bit16_to_int(file_bytes[IMAGE_BITS_RANGE]) #.to_u32
      @compression = Utils.long_to_int(file_bytes[IMAGE_COMPRESSION_RANGE])
      @image_size = Utils.long_to_int(file_bytes[IMAGE_SIZE_RANGE])
      @res_x = Utils.long_to_int(file_bytes[IMAGE_RESOLUTION_X_RANGE])
      @res_y = Utils.long_to_int(file_bytes[IMAGE_RESOLUTION_Y_RANGE])
      @color_numbers = Utils.long_to_int(file_bytes[IMAGE_COLOR_NUMBERS_RANGE])
      @important_colors = Utils.long_to_int(file_bytes[IMAGE_IMPORTANT_COLORS_RANGE])

      # file_header
    end
  end
end
