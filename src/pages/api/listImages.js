


export default async function handler(req, res) {

  if (req.method !== 'POST' && req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }


  // Support folderId from body (POST) or query (GET)
  const folderId = req.method === 'POST' ? req.body.folderId : req.query.folderId;
  if (!folderId) {
    return res.status(400).json({ error: 'Missing folderId' });
  }

  // For Wearing of the Green 2026, serve from public JSON and R2 (now using 'wearingofthegreen2026')
  if (folderId === 'wearingofthegreen2026') {
    try {
      // Fetch the JSON file via HTTP for serverless compatibility
      const jsonUrl = `${req.headers['x-forwarded-proto'] || 'https'}://${req.headers.host}/data/wearingofthegreen2026-images.json`;
      const response = await fetch(jsonUrl);
      if (!response.ok) throw new Error(`Failed to fetch JSON: ${response.status}`);
      const filenames = await response.json();
      const baseUrl = 'https://pub-c89ef5607c4f4bb4b07455ddc8021fd0.r2.dev/';
      // Remove duplicates just in case
      const uniqueFilenames = Array.from(new Set(filenames));
      const images = uniqueFilenames.map(name => ({
        name,
        url: baseUrl + encodeURIComponent(name),
        thumbnailUrl: baseUrl + encodeURIComponent(name)
      }));
      return res.status(200).json({ images });
    } catch (error) {
      console.error('R2 images API error:', error);
      return res.status(500).json({ error: 'Failed to fetch R2 images', details: error.message });
    }
  }
  // ...existing code for other folders (Google Drive, etc.)
  return res.status(404).json({ error: 'Gallery not found' });
}
