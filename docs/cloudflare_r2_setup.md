# Cloudflare R2 Setup Guide for Sona App

## Prerequisites
- Cloudflare account
- R2 enabled on your account
- API tokens with R2 permissions

## Step 1: Create R2 Bucket
1. Log in to Cloudflare Dashboard
2. Navigate to R2 > Overview
3. Click "Create bucket"
4. Name: `sona-personas`
5. Location: Choose nearest to your users

## Step 2: Configure Public Access
1. Go to bucket settings
2. Under "Public Access", enable public access
3. Set up a custom domain or use the default R2 domain

## Step 3: Create API Token
1. Go to My Profile > API Tokens
2. Create Custom Token with these permissions:
   - Account > Cloudflare R2 > Edit
   - Zone > Zone > Read (if using custom domain)

## Step 4: Install Cloudflare R2 MCP
```bash
# Install the Cloudflare R2 MCP server
claude mcp add --scope user cloudflare-r2 \
  -e CLOUDFLARE_ACCOUNT_ID=your_account_id \
  -e CLOUDFLARE_ACCESS_KEY_ID=your_access_key \
  -e CLOUDFLARE_SECRET_ACCESS_KEY=your_secret_key \
  -e R2_BUCKET_NAME=sona-personas \
  -- npx -y @cloudflare/mcp-server-cloudflare-r2
```

## Step 5: Configure MCP (if manual setup needed)
Edit `C:\Users\yong\.claude\mcp_settings.json`:

```json
{
  "mcpServers": {
    "cloudflare-r2": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@cloudflare/mcp-server-cloudflare-r2"],
      "env": {
        "CLOUDFLARE_ACCOUNT_ID": "your_account_id",
        "CLOUDFLARE_ACCESS_KEY_ID": "your_access_key",
        "CLOUDFLARE_SECRET_ACCESS_KEY": "your_secret_key",
        "R2_BUCKET_NAME": "sona-personas"
      }
    }
  }
}
```

## Step 6: Test the Connection
```bash
# Test MCP connection
echo "/mcp" | claude --debug
```

## Upload Script Using Cloudflare R2 API

If MCP doesn't work, you can use the Cloudflare R2 API directly:

```python
import boto3
from pathlib import Path

# Configure S3 client for R2
s3 = boto3.client(
    's3',
    endpoint_url='https://<account_id>.r2.cloudflarestorage.com',
    aws_access_key_id='<access_key_id>',
    aws_secret_access_key='<secret_access_key>',
    region_name='auto'
)

def upload_to_r2(local_path, r2_key, content_type='image/webp'):
    """Upload file to R2"""
    try:
        s3.upload_file(
            local_path,
            'sona-personas',
            r2_key,
            ExtraArgs={
                'ContentType': content_type,
                'CacheControl': 'public, max-age=31536000'
            }
        )
        # Return public URL
        return f"https://sona-personas.<account_id>.r2.cloudflarestorage.com/{r2_key}"
    except Exception as e:
        print(f"Upload error: {e}")
        return None
```

## Public URL Structure
After upload, your images will be available at:
- `https://sona-personas.<account_id>.r2.cloudflarestorage.com/personas/윤미/main_thumb.webp`
- `https://sona-personas.<account_id>.r2.cloudflarestorage.com/personas/윤미/main_small.webp`
- `https://sona-personas.<account_id>.r2.cloudflarestorage.com/personas/윤미/main_medium.webp`
- `https://sona-personas.<account_id>.r2.cloudflarestorage.com/personas/윤미/main_large.webp`