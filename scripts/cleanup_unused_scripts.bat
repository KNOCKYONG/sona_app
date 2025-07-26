@echo off
echo Cleaning up unused scripts...

REM Delete unused scripts
del /f scripts\actual_upload_processor.py
del /f scripts\auto_persona_image_processor.py
del /f scripts\auto_persona_image_processor_clean.py
del /f scripts\batch_upload_to_r2.py
del /f scripts\bulk_delete_small_images.py
del /f scripts\check_firebase_data.py
del /f scripts\check_imageUrls_structure.py
del /f scripts\check_persona_images.py
del /f scripts\clean_firebase_imageUrls.py
del /f scripts\cleanup_firebase_personas.py
del /f scripts\clear_photourls.py
del /f scripts\complete_image_processor.py
del /f scripts\create_medium_image.py
del /f scripts\create_thumb_image.py
del /f scripts\delete_all_r2_personas.py
del /f scripts\delete_korean_r2_folders.py
del /f scripts\direct_upload.py
del /f scripts\execute_uploads.py
del /f scripts\final_image_processor.py
del /f scripts\firebase_image_updater.py
del /f scripts\firebase_image_updater_real.py
del /f scripts\fix_firebase_imageUrls_structure.py
del /f scripts\fix_image_upload.py
del /f scripts\fix_photourls_string.py
del /f scripts\fix_webp_encoding.py
del /f scripts\local_image_optimizer.py
del /f scripts\manual_image_upload.py
del /f scripts\optimized_image_processor.py
del /f scripts\persona_mcp_uploader.py
del /f scripts\process_and_upload_personas.py
del /f scripts\process_persona.bat
del /f scripts\process_persona_image.py
del /f scripts\production_image_optimizer.py
del /f scripts\r2_config.json
del /f scripts\reprocess_problematic_personas.py
del /f scripts\test_single_upload.py
del /f scripts\update_firebase_imageUrls.py
del /f scripts\upload_persona_images_to_r2.py
del /f scripts\upload_persona_to_r2.py
del /f scripts\upload_single_image.py
del /f scripts\upload_to_r2_mcp.py

REM Delete output folder
rmdir /s /q scripts\output

echo Cleanup complete!