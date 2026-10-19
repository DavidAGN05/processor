"""Convert a 128 x 128 RGB image using the hardware shift-and-add formula.

The Verilog implementation uses:

	gray = (red >> 2) + (green >> 1) + (green >> 3)
	       + (green >> 4) + (blue >> 4)

This approximates 0.25R + 0.6875G + 0.0625B. The coefficients sum to 1.0,
and each right shift truncates fractional bits. The result is written as an
RGB image with the grayscale value copied to every channel.
"""

from __future__ import annotations

import argparse
from pathlib import Path
from typing import Iterable


IMAGE_WIDTH = 128
IMAGE_HEIGHT = 128
INPUT_WIDTH = 8
OUTPUT_WIDTH = 8
INPUT_MAX = (1 << INPUT_WIDTH) - 1
OUTPUT_MAX = (1 << OUTPUT_WIDTH) - 1


def rgb_to_grayscale(red: int, green: int, blue: int) -> int:
	"""Return one 8-bit grayscale value using the hardware shift-and-add rule."""
	channels = (red, green, blue)
	if any(
		not isinstance(channel, int) or not 0 <= channel <= INPUT_MAX
		for channel in channels
	):
		raise ValueError("RGB channels must be integers from 0 through 255")

	grayscale = (red >> 2) + (green >> 1) + (green >> 3) + (green >> 4) + (blue >> 4)
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
