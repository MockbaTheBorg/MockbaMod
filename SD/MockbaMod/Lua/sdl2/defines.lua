-- Function definitions which were not output by
-- the C preprocessor

local SDL

local function registerdefines(SDL)

   -- audio

   function SDL.AUDIO_BITSIZE(x)
      return bit.band(x, SDL.AUDIO_MASK_BITSIZE)
   end

   function SDL.AUDIO_ISFLOAT(x)
      return bit.band(x, SDL.AUDIO_MASK_DATATYPE) ~= 0
   end

   function SDL.AUDIO_ISBIGENDIAN(x)
      return bit.band(x, SDL.AUDIO_MASK_ENDIAN) ~= 0
   end

   function SDL.AUDIO_ISSIGNED(x)
      return bit.band(x, SDL.AUDIO_MASK_SIGNED) ~= 0
   end

   function SDL.AUDIO_ISINT(x)
      return not SDL.AUDIO_ISFLOAT(x)
   end

   function SDL.AUDIO_ISLITTLEENDIAN(x)
      return not SDL.AUDIO_ISBIGENDIAN(x)
   end

   function SDL.AUDIO_ISUNSIGNED(x)
      return not SDL.AUDIO_ISSIGNED(x)
   end

   function SDL.LoadWAV(file, spec, audio_buf, audio_len)
      return SDL.LoadWAV_RW(SDL.RWFromFile(file, "rb"), 1, spec, audio_buf, audio_len)
   end

   -- surface
   SDL.BlitSurface = SDL.UpperBlit

   function SDL.MUSTLOCK(S)
      return bit.band(S.flags, SDL.RLEACCEL)
   end

   function SDL.LoadBMP(file)
      return SDL.LoadBMP_RW(SDL.RWFromFile(file, 'rb'), 1)
   end

   function SDL.SaveBMP(surface, file)
      return SDL.SaveBMP_RW(surface, SDL.RWFromFile(file, 'wb'), 1)
   end
end

return registerdefines
