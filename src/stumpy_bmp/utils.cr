module StumpyBMP
  class Utils
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

    # def self.rgb8_to_int(rgb8_chars)
    #   to_u32_bounded(
    #     (rgb8_chars[0]? || 0).to_u32 * (TWO_E_16) +
    #     (rgb8_chars[1]? || 0).to_u32 * (TWO_E_8) +
    #     (rgb8_chars[2]? || 0).to_u32
    #   )
    # end

    def self.bit16_to_int(bit16_chars)
      # to_u16_bounded(
      to_u32_bounded(
        (bit16_chars[1]? || 0).to_u16 * (TWO_E_8) +
        (bit16_chars[0]? || 0).to_u16
      )
    end
  end
end
