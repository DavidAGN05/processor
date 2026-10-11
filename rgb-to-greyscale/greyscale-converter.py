"""Convert a 128 x 128 RGB image using the fixed-point hardware formula.

The Verilog implementation can use the same arithmetic:

	gray = (54 * red + 182 * green + 18 * blue) >> 8

The coefficients are Q8 fixed-point approximations:
54 / 256 ~= 0.21, 182 / 256 ~= 0.71, and 18 / 256 ~= 0.07.
The right shift truncates the fractional part. The result is written as an
RGB image with the grayscale value copied to every channel.
"""

from __future__ import annotations

import argparse
from pathlib import Path
from typing import Iterable


IMAGE_WIDTH = 128
IMAGE_HEIGHT = 128
FRACTIONAL_BITS = 8
INPUT_WIDTH = 8
PRODUCT_WIDTH = 16
ACCUMULATOR_WIDTH = 16
OUTPUT_WIDTH = 8
COEFFICIENT_RED = 54
COEFFICIENT_GREEN = 182
COEFFICIENT_BLUE = 18
INPUT_MAX = (1 << INPUT_WIDTH) - 1
OUTPUT_MAX = (1 << OUTPUT_WIDTH) - 1
PRODUCT_MASK = (1 << PRODUCT_WIDTH) - 1
ACCUMULATOR_MASK = (1 << ACCUMULATOR_WIDTH) - 1


def rgb_to_grayscale(red: int, green: int, blue: int) -> int:
	"""Return one 8-bit grayscale value using the hardware fixed-point rule.

	Inputs are unsigned 8-bit channels. Each coefficient is an unsigned Q8
	value, products are 16-bit, and the weighted sum is an unsigned 16-bit
	accumulator. The shift is truncation (no rounding), matching the RTL.
	"""
	channels = (red, green, blue)
	if any(
		not isinstance(channel, int) or not 0 <= channel <= INPUT_MAX
		for channel in channels
	):
		raise ValueError("RGB channels must be integers from 0 through 255")

	red_product = (COEFFICIENT_RED * red) & PRODUCT_MASK
	green_product = (COEFFICIENT_GREEN * green) & PRODUCT_MASK
	blue_product = (COEFFICIENT_BLUE * blue) & PRODUCT_MASK
	weighted_sum = red_product + green_product + blue_product

	# Explicitly model the RTL accumulator width. For valid 8-bit inputs,
	# the maximum sum is 64,770, so no valid value is lost here.
	weighted_sum &= ACCUMULATOR_MASK
	grayscale = weighted_sum >> FRACTIONAL_BITS
	return min(grayscale, OUTPUT_MAX)


def convert_pixels(pixels: Iterable[tuple[int, int, int]]) -> list[tuple[int, int, int]]:
	"""Convert RGB pixels to RGB grayscale pixels."""
	converted_pixels = []
	for red, green, blue in pixels:
		grayscale = rgb_to_grayscale(red, green, blue)
		converted_pixels.append((grayscale, grayscale, grayscale))
	return converted_pixels


def convert_image(input_path: Path, output_path: Path) -> None:
	"""Read, convert, and save a 128 x 128 image."""
	try:
		from PIL import Image
	except ImportError as error:
		raise SystemExit("Pillow is required. Install it with: python -m pip install Pillow") from error

	with Image.open(input_path) as image:
		if image.size != (IMAGE_WIDTH, IMAGE_HEIGHT):
			raise ValueError(
				f"expected a {IMAGE_WIDTH} x {IMAGE_HEIGHT} image, got {image.width} x {image.height}"
			)

		rgb_image = image.convert("RGB")
		output_image = Image.new("RGB", rgb_image.size)
		output_image.putdata(convert_pixels(rgb_image.getdata()))
		output_image.save(output_path)


def parse_args() -> argparse.Namespace:
	parser = argparse.ArgumentParser(description=__doc__)
	parser.add_argument("input", type=Path, help="path to the input RGB image")
	parser.add_argument("output", type=Path, help="path for the grayscale output image")
	return parser.parse_args()


def main() -> None:
	arguments = parse_args()
	convert_image(arguments.input, arguments.output)
	print(f"Converted {arguments.input} -> {arguments.output}")


if __name__ == "__main__":
	main()
