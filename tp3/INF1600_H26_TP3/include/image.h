#pragma once
#include <cstdint>

struct Pixel {
    uint8_t r;
    uint8_t g;
    uint8_t b;
    uint8_t a;
};

struct Image {
    uint32_t largeur;
    uint32_t hauteur;
    Pixel** pixels;
};

extern "C" {
Image createImage(unsigned width, unsigned height);
void freeImage(Image& img);
bool loadImage(const char* filename, Image& img);
bool saveImage(const char* filename, const Image& img);
}