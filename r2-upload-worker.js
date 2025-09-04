// Cloudflare Workers script for R2 upload proxy
// This allows the Flutter app to upload images to R2 securely

export default {
  async fetch(request, env) {
    // CORS headers for the Flutter app
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    };

    // Handle CORS preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    // Only allow POST requests
    if (request.method !== 'POST') {
      return new Response('Method not allowed', { 
        status: 405,
        headers: corsHeaders 
      });
    }

    try {
      // Check authorization
      const authHeader = request.headers.get('Authorization');
      const apiKey = env.UPLOAD_API_KEY || 'your-secure-api-key';
      
      if (authHeader !== `Bearer ${apiKey}`) {
        return new Response('Unauthorized', { 
          status: 401,
          headers: corsHeaders 
        });
      }

      // Parse the multipart form data
      const formData = await request.formData();
      const file = formData.get('file');
      const path = formData.get('path');
      const bucket = formData.get('bucket') || 'sona-personas';

      if (!file || !path) {
        return new Response('Missing file or path', { 
          status: 400,
          headers: corsHeaders 
        });
      }

      // Upload to R2
      const r2Bucket = env.R2_BUCKET || env.sona_personas;
      
      if (!r2Bucket) {
        return new Response('R2 bucket not configured', { 
          status: 500,
          headers: corsHeaders 
        });
      }

      // Upload the file to R2
      const arrayBuffer = await file.arrayBuffer();
      await r2Bucket.put(path, arrayBuffer, {
        httpMetadata: {
          contentType: file.type || 'image/jpeg',
        },
        customMetadata: {
          uploadedAt: new Date().toISOString(),
          originalName: file.name,
        }
      });

      // Generate public URL
      const publicUrl = `https://pub-${env.ACCOUNT_HASH}.r2.dev/${bucket}/${path}`;

      return new Response(JSON.stringify({ 
        success: true, 
        url: publicUrl,
        path: path 
      }), {
        status: 200,
        headers: {
          'Content-Type': 'application/json',
          ...corsHeaders
        }
      });

    } catch (error) {
      console.error('Upload error:', error);
      return new Response(JSON.stringify({ 
        error: 'Upload failed',
        details: error.message 
      }), {
        status: 500,
        headers: {
          'Content-Type': 'application/json',
          ...corsHeaders
        }
      });
    }
  }
};