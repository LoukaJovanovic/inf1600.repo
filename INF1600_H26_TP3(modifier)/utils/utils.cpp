/*
    NE PAS MODIFIER CE FICHIER
*/
#include "image.h"

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

#include <algorithm>
#include <filesystem>
#include <iostream>
#include <string>

Image createImage(unsigned width, unsigned height) {
    Image img;
    img.largeur = width;
    img.hauteur = height;
    img.pixels  = new Pixel*[height];
    for (unsigned y = 0; y < height; y++) {
        img.pixels[y] = new Pixel[width];
        for (unsigned x = 0; x < width; x++) {
            img.pixels[y][x] = {0, 0, 0, 255};
        }
    }
    return img;
}

void freeImage(Image& img) {
    if (img.pixels) {
        for (unsigned y = 0; y < img.hauteur; y++) {
            delete[] img.pixels[y];
        }
        delete[] img.pixels;
        img.pixels  = nullptr;
        img.largeur = 0;
        img.hauteur = 0;
    }
}

bool loadImage(const char* filename, Image& img) {
    int width, height, channels;

    unsigned char* data = stbi_load(filename, &width, &height, &channels, 4);
    if (!data) {
        std::cerr << "Failed to load image: " << filename << "\n";
        std::cerr << "Reason: " << stbi_failure_reason() << "\n";
        return false;
    }

    img.largeur = width;
    img.hauteur = height;

    img.pixels = new Pixel*[height];
    for (int y = 0; y < height; y++) {
        img.pixels[y] = new Pixel[width];
    }

    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int index          = (y * width + x) * 4;
            img.pixels[y][x].r = data[index + 0];
            img.pixels[y][x].g = data[index + 1];
            img.pixels[y][x].b = data[index + 2];
            img.pixels[y][x].a = data[index + 3];
        }
    }

    stbi_image_free(data);

    std::cout << "Loaded image: " << filename << " (" << width << "x" << height << ")\n";
    return true;
}

bool saveImage(const char* filename, const Image& img) {
    if (!img.pixels || img.largeur == 0 || img.hauteur == 0) {
        std::cerr << "Invalid image data\n";
        return false;
    }

    unsigned char* data = new unsigned char[img.largeur * img.hauteur * 4];

    for (unsigned y = 0; y < img.hauteur; y++) {
        for (unsigned x = 0; x < img.largeur; x++) {
            int index       = (y * img.largeur + x) * 4;
            data[index + 0] = img.pixels[y][x].r;
            data[index + 1] = img.pixels[y][x].g;
            data[index + 2] = img.pixels[y][x].b;
            data[index + 3] = img.pixels[y][x].a;
        }
    }

    std::filesystem::path filepath(filename);
    std::string ext = filepath.extension().string();

    if (!ext.empty() && ext[0] == '.') {
        ext = ext.substr(1);
    }
    std::transform(ext.begin(), ext.end(), ext.begin(), ::tolower);

    std::string actualFilename = filename;
    if (ext.empty()) {
        ext = "png";
        actualFilename += ".png";
        std::cout << "No extension found, defaulting to PNG: " << actualFilename << "\n";
    }

    bool success = false;

    if (ext == "png") {
        success = stbi_write_png(actualFilename.c_str(), img.largeur, img.hauteur, 4, data, img.largeur * 4);
    } else if (ext == "jpg" || ext == "jpeg") {
        success = stbi_write_jpg(actualFilename.c_str(), img.largeur, img.hauteur, 4, data, 90);  // 90% quality
    } else if (ext == "bmp") {
        success = stbi_write_bmp(actualFilename.c_str(), img.largeur, img.hauteur, 4, data);
    } else if (ext == "tga") {
        success = stbi_write_tga(actualFilename.c_str(), img.largeur, img.hauteur, 4, data);
    } else {
        std::cerr << "Unknown extension '." << ext << "', defaulting to PNG\n";
        success = stbi_write_png(actualFilename.c_str(), img.largeur, img.hauteur, 4, data, img.largeur * 4);
    }

    delete[] data;

    if (success) {
        std::cout << "Saved image: " << actualFilename << "\n";
    } else {
        std::cerr << "Error saving image: " << actualFilename << "\n";
    }

    return success;
}