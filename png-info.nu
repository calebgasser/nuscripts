#!/usr/bin/env nu
# Script for reading png image info

def get_interlace_method [$method] {
  if $method == 0 { 
    "No Interlace" 
  } else { 
    "Adam7 Interlace"
  }
}

def get_color_type [$color_type] {
  match $color_type {
    0 => { "grayscale" },
    2 => { "red, green, and blue"},
    3 => { "indexed: channel containing indicies into a palette of colors"},
    4 => { "grayscale and alpha: level of opacity for each pixel"},
    6 => { "red, green, blue and alpha"},
    _ => { "unrecognized" },
  }
}

def get_png_info [$fname] {
  let file_contents = (open $fname | into binary)
  let width = ($file_contents | skip 16 | take 4 | into int)  
  let height = ($file_contents | skip 20 | take 4 | into int)  
  let bit_depth = ($file_contents | skip 24 | take 1 | into int)
  let color_type = ($file_contents | skip 25 | take 1 | into int)
  let compression_method = ($file_contents | skip 26 | take 1 | into int)
  let filter_method = ($file_contents | skip 27 | take 1 | into int)
  let interlace_method = ($file_contents | skip 28 | take 1 | into int) 

  [["field", "value", "description", "info"];
    ["width", $width, "4 bytes", ""]
    ["height", $height, "4 bytes", ""]
    ["bit_depth", $bit_depth, "1 byte, values 1, 2, 4, 8, 16", ""]
    ["color_type", $color_type, "1 byte, values 0, 2, 3, 4, 16", (get_color_type $color_type)]
    ["compression_method", $compression_method, "1 byte, value 0", ""]
    ["filter_method", $filter_method, "1 byte, value 0", ""]
    ["interlace_method", $interlace_method, "1 byte, values 0 for 'no interlace' or 1 for 'Adam7 interlace'", (get_interlace_method $interlace_method)]
  ]
}

def main [$fname] {
  print $"(ansi purple_bold)File:(ansi reset) ($fname)"
  get_png_info $fname
}
