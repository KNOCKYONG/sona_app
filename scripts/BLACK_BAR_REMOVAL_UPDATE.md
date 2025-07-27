# Black Bar Removal Update

## Changes Made

### 1. Updated `local_image_optimizer_english.py`
- Added `remove_black_bars()` function to detect and remove letterbox black bars
- Added `smart_crop_square()` function for intelligent square cropping 
- Modified image processing to:
  - Remove black bars before any resizing
  - Use smart square crop for thumbnail and small sizes (150x150, 300x300)
  - Maintain original aspect ratio for medium and large sizes
- Import numpy for black bar detection

### 2. Updated `auto_persona_image_processor_clean.py`
- Added same `remove_black_bars()` and `smart_crop_square()` functions
- Modified image processing with identical logic as local optimizer
- Ensures consistency across all processing scripts

### 3. Black Bar Detection Logic
- Detects rows with mean brightness < 10 (to catch very dark but not pure black)
- Only removes bars if they're > 5% of image height (avoids false positives)
- Preserves original image if no significant bars detected

### 4. Smart Square Crop for Cards
- Thumbnail (150x150) and small (300x300) sizes now use square aspect ratio
- Portrait images: Crops from top 10% to focus on face area
- Landscape images: Center crops to square
- Ensures persona cards display full-frame images without letterboxing

### 5. Test Script Created
- `test_black_bar_removal.py` for testing the functionality
- Can test individual images or scan persona folders

## Usage

To process all personas with black bar removal:

```bash
# Local optimization with English names
python scripts/local_image_optimizer_english.py

# Full automated processing (requires MCP)
python scripts/auto_persona_image_processor_clean.py
```

To test on a single image:

```bash
python scripts/test_black_bar_removal.py "C:\path\to\image.jpg"
```

## Results
- Black bars will be automatically detected and removed
- Persona cards will show square cropped images that fill the entire card
- Medium and large images maintain original aspect ratio (minus black bars)
- No manual intervention required