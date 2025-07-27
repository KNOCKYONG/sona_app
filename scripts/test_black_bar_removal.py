#!/usr/bin/env python3
"""
Test script to verify black bar removal functionality
"""

import os
import sys
from PIL import Image
from pathlib import Path
import numpy as np

def remove_black_bars(img):
    """Remove black letterbox bars from top and bottom of image"""
    # Convert to numpy array
    img_array = np.array(img)
    
    # For RGB images
    if len(img_array.shape) == 3:
        # Calculate mean brightness for each row
        row_means = np.mean(img_array, axis=(1, 2))
    else:
        # For grayscale
        row_means = np.mean(img_array, axis=1)
    
    # Find non-black rows (threshold of 10 to account for very dark but not pure black)
    non_black_rows = np.where(row_means > 10)[0]
    
    if len(non_black_rows) == 0:
        return img
    
    # Get the bounds of non-black content
    top = non_black_rows[0]
    bottom = non_black_rows[-1] + 1
    
    # Check if we found black bars (more than 5% of image height)
    height = img_array.shape[0]
    if top > height * 0.05 or (height - bottom) > height * 0.05:
        print(f"Detected black bars: top={top}px, bottom={height-bottom}px")
        print(f"Original size: {img.size}")
        # Crop the image
        if len(img_array.shape) == 3:
            cropped_array = img_array[top:bottom, :, :]
        else:
            cropped_array = img_array[top:bottom, :]
        cropped_img = Image.fromarray(cropped_array)
        print(f"New size after removing black bars: {cropped_img.size}")
        return cropped_img
    else:
        print(f"No significant black bars detected (top={top}px, bottom={height-bottom}px)")
    
    return img

def test_single_image(image_path):
    """Test black bar removal on a single image"""
    print(f"\nTesting: {image_path}")
    
    try:
        with Image.open(image_path) as img:
            print(f"Original size: {img.size}")
            
            # Convert to RGB if necessary
            if img.mode in ('RGBA', 'LA'):
                background = Image.new('RGB', img.size, (255, 255, 255))
                background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                img = background
            elif img.mode != 'RGB':
                img = img.convert('RGB')
            
            # Remove black bars
            processed = remove_black_bars(img)
            
            # Save test output
            output_path = f"test_output_{Path(image_path).stem}.jpg"
            processed.save(output_path, 'JPEG', quality=95)
            print(f"Saved test output to: {output_path}")
            
    except Exception as e:
        print(f"Error processing {image_path}: {e}")

def main():
    if len(sys.argv) > 1:
        # Test specific image
        image_path = sys.argv[1]
        if os.path.exists(image_path):
            test_single_image(image_path)
        else:
            print(f"Image not found: {image_path}")
    else:
        # Test all images in a sample persona folder
        test_dir = r"C:\Users\yong\Documents\personas"
        
        # Find first persona with images
        for folder in Path(test_dir).iterdir():
            if folder.is_dir():
                images = list(folder.glob("*.jpg")) + list(folder.glob("*.png")) + list(folder.glob("*.jpeg"))
                if images:
                    print(f"Testing images from: {folder.name}")
                    test_single_image(str(images[0]))
                    break
        else:
            print("No test images found")

if __name__ == "__main__":
    main()