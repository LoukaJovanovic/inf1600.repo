#pragma once

#include "image.h"

extern "C" {
void applyScanline(Pixel& p, int percent);
void applyPhosphor(Pixel& p, int subpixel);
void crtFilter(Image& img, int scanlineSpacing);
void sierpinskiImage(uint32_t x, uint32_t y, uint32_t size, Image& img, Pixel color);
}