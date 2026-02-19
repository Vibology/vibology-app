#!/usr/bin/env python3
"""
Generate landscape natal chart for Joe Lewis using Kerykeion.
This produces the landscape.svg that portrait_builder.py expects as input.
"""

import sys
sys.path.insert(0, '/Users/joe/VibologyOS/System/Cartographer/src')

from kerykeion import AstrologicalSubject, KerykeionChartSVG
from cartographer.services.astro_renderer import (
    _fix_viewbox_clipping,
    _enhance_colors,
    _inject_font_family,
    _improve_typography,
    _fix_cusp_alignment,
    _adjust_planet_grid_spacing,
    _combine_location_line
)

# Birth data: Sept 18, 1978, 5:34pm, South Williamson, KY
subject = AstrologicalSubject(
    name="Joe Lewis",
    year=1978,
    month=9,
    day=18,
    hour=17,
    minute=34,
    lat=37.6706,
    lng=-82.2807,
    tz_str="America/New_York",
    city="South Williamson, KY",  # Nation parameter handles country
    nation="US"
)

# Generate SVG chart
print("Generating natal chart...")
chart = KerykeionChartSVG(subject, chart_type="Natal")
svg_content = chart.makeTemplate()

# Apply visual enhancements (but NOT portrait conversion)
svg_content = _fix_viewbox_clipping(svg_content)
svg_content = _enhance_colors(svg_content)
svg_content = _inject_font_family(svg_content)
svg_content = _improve_typography(svg_content)
svg_content = _fix_cusp_alignment(svg_content)
svg_content = _adjust_planet_grid_spacing(svg_content)
svg_content = _combine_location_line(svg_content)

# Write landscape SVG
output_path = "/Users/joe/VibologyOS/System/Cartographer/landscape.svg"
with open(output_path, 'w') as f:
    f.write(svg_content)

print(f"✓ Landscape chart written to: {output_path}")
print(f"  Ascendant: {subject.first_house['position']:.2f}° {subject.first_house['sign']}")
print(f"  MC: {subject.tenth_house['position']:.2f}° {subject.tenth_house['sign']}")
