/*
    NE PAS MODIFIER CE FICHIER
*/
#include <cmath>
#include <iomanip>
#include <iostream>
#include "filters.h"
#include "image.h"

#define RESET "\033[0m"
#define RED "\033[31m"
#define GREEN "\033[32m"
#define YELLOW "\033[33m"

int totalTests  = 0;
int passedTests = 0;

bool pixelEquals(const Pixel& p1, const Pixel& p2) {
    return p1.r == p2.r && p1.g == p2.g && p1.b == p2.b && p1.a == p2.a;
}

void printPixel(const Pixel& p) {
    std::cout << "RGBA(" << (int)p.r << ", " << (int)p.g << ", " << (int)p.b << ", " << (int)p.a << ")";
}

void assertPixelEqual(const char* testName, const Pixel& expected, const Pixel& got) {
    totalTests++;
    bool pass = pixelEquals(expected, got);

    if (pass) {
        passedTests++;
        std::cout << GREEN << "[PASS] " << RESET << testName << std::endl;
    } else {
        std::cout << RED << "[FAIL] " << RESET << testName << std::endl;
        std::cout << "  Expected: ";
        printPixel(expected);
        std::cout << std::endl;
        std::cout << "  Got:      ";
        printPixel(got);
        std::cout << std::endl;
    }
}

void assertImagePixel(const char* testName, const Image& img, unsigned x, unsigned y, const Pixel& expected) {
    totalTests++;
    const Pixel& got = img.pixels[y][x];
    bool pass        = pixelEquals(expected, got);

    if (pass) {
        passedTests++;
        std::cout << GREEN << "[PASS] " << RESET << testName << std::endl;
    } else {
        std::cout << RED << "[FAIL] " << RESET << testName << " at position (" << x << ", " << y << ")" << std::endl;
        std::cout << "  Expected: ";
        printPixel(expected);
        std::cout << std::endl;
        std::cout << "  Got:      ";
        printPixel(got);
        std::cout << std::endl;
    }
}

void testApplyScanline() {
    std::cout << "\n=== Testing applyScanline ===" << std::endl;

    Pixel p1 = {100, 150, 200, 255};
    applyScanline(p1, 60);
    assertPixelEqual("applyScanline with 60%", {60, 90, 120, 255}, p1);

    Pixel p2 = {100, 150, 200, 255};
    applyScanline(p2, 100);
    assertPixelEqual("applyScanline with 100%", {100, 150, 200, 255}, p2);

    Pixel p3 = {100, 150, 200, 255};
    applyScanline(p3, 0);
    assertPixelEqual("applyScanline with 0%", {0, 0, 0, 255}, p3);

    Pixel p4 = {200, 100, 50, 255};
    applyScanline(p4, 50);
    assertPixelEqual("applyScanline with 50%", {100, 50, 25, 255}, p4);
}

void testApplyPhosphor() {
    std::cout << "\n=== Testing applyPhosphor ===" << std::endl;

    Pixel p1 = {100, 100, 100, 255};
    applyPhosphor(p1, 0);
    assertPixelEqual("applyPhosphor red subpixel", {100, 70, 70, 255}, p1);

    Pixel p2 = {100, 100, 100, 255};
    applyPhosphor(p2, 1);
    assertPixelEqual("applyPhosphor green subpixel", {70, 100, 70, 255}, p2);

    Pixel p3 = {100, 100, 100, 255};
    applyPhosphor(p3, 2);
    assertPixelEqual("applyPhosphor blue subpixel", {70, 70, 100, 255}, p3);
}

void testCrtFilter() {
    std::cout << "\n=== Testing crtFilter ===" << std::endl;

    Image img = createImage(6, 4);

    for (unsigned y = 0; y < img.hauteur; y++) {
        for (unsigned x = 0; x < img.largeur; x++) {
            img.pixels[y][x] = {100, 100, 100, 255};
        }
    }

    crtFilter(img, 2);

    assertImagePixel("crtFilter scanline dark, red phosphor", img, 0, 0, {60, 42, 42, 255});

    assertImagePixel("crtFilter non-scanline, green phosphor", img, 1, 1, {70, 100, 70, 255});

    assertImagePixel("crtFilter scanline dark, blue phosphor", img, 2, 2, {42, 42, 60, 255});

    freeImage(img);
}

void testSierpinskiImage() {
    std::cout << "\n=== Testing sierpinskiImage ===" << std::endl;

    Image img   = createImage(8, 8);
    Pixel white = {255, 255, 255, 255};

    sierpinskiImage(0, 0, 4, img, white);

    assertImagePixel("sierpinskiImage top point", img, 1, 0, {255, 255, 255, 255});
    assertImagePixel("sierpinskiImage center filled", img, 1, 1, {255, 255, 255, 255});
    assertImagePixel("sierpinskiImage bottom-left", img, 0, 2, {255, 255, 255, 255});
    assertImagePixel("sierpinskiImage left empty", img, 0, 1, {0, 0, 0, 255});
    freeImage(img);
}

int main() {
    std::cout << YELLOW << "Running Test Suite" << RESET << std::endl;

    testApplyScanline();
    testApplyPhosphor();
    testCrtFilter();
    testSierpinskiImage();

    std::cout << "\n" << YELLOW << "=== Test Summary ===" << RESET << std::endl;
    std::cout << "Total tests: " << totalTests << std::endl;
    std::cout << GREEN << "Passed: " << passedTests << RESET << std::endl;
    if (totalTests - passedTests == 0) {
        std::cout << GREEN << "Failed: " << (totalTests - passedTests) << RESET << std::endl;
    } else {
        std::cout << RED << "Failed: " << (totalTests - passedTests) << RESET << std::endl;
    }

    if (passedTests == totalTests) {
        std::cout << GREEN << "\nAll tests passed! ✓" << RESET << std::endl;
    } else {
        std::cout << RED << "\nSome tests failed! ✗" << RESET << std::endl;
    }
    return 0;
}