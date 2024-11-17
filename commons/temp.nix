{ config, pkgs, ... }:
{

    environment.systemPackages = with pkgs; [
       tesseract4
       poppler #pdfimages
       poppler_utils
       imagemagick
    ];

    
}