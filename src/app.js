const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Hello World endpoint
app.get('/', (req, res) => {
  const htmlContent = `
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Self-Healing Pipeline Demo</title>
      <style>
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }
        
        body {
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          min-height: 100vh;
          display: flex;
          justify-content: center;
          align-items: center;
          padding: 20px;
        }
        
        .container {
          background: white;
          border-radius: 10px;
          box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
          padding: 40px;
          max-width: 600px;
          text-align: center;
        }
        
        h1 {
          color: #333;
          margin-bottom: 10px;
          font-size: 2.5em;
        }
        
        .emoji {
          font-size: 1.2em;
          margin-left: 10px;
        }
        
        p.subtitle {
          color: #666;
          font-size: 1.1em;
          margin-bottom: 30px;
          font-weight: 300;
        }
        
        .version {
          display: inline-block;
          background: #667eea;
          color: white;
          padding: 5px 15px;
          border-radius: 20px;
          font-size: 0.9em;
          margin-bottom: 30px;
        }
        
        .features {
          text-align: left;
          background: #f8f9fa;
          padding: 25px;
          border-radius: 8px;
          margin-bottom: 30px;
        }
        
        .features h2 {
          color: #333;
          font-size: 1.2em;
          margin-bottom: 15px;
          text-align: center;
        }
        
        .features ul {
          list-style: none;
        }
        
        .features li {
          padding: 10px 0;
          color: #555;
          border-bottom: 1px solid #e0e0e0;
          display: flex;
          align-items: center;
        }
        
        .features li:last-child {
          border-bottom: none;
        }
        
        .features li:before {
          content: "✓";
          color: #667eea;
          font-weight: bold;
          margin-right: 10px;
          font-size: 1.2em;
        }
        
        .info {
          background: #e8f4f8;
          padding: 15px;
          border-radius: 8px;
          color: #333;
          font-size: 0.95em;
          margin-bottom: 20px;
        }
        
        .links {
          margin-top: 30px;
          display: flex;
          gap: 10px;
          justify-content: center;
          flex-wrap: wrap;
        }
        
        .link-btn {
          display: inline-block;
          padding: 10px 20px;
          background: #667eea;
          color: white;
          text-decoration: none;
          border-radius: 5px;
          transition: background 0.3s ease;
          font-size: 0.9em;
        }
        
        .link-btn:hover {
          background: #764ba2;
        }
        
        .link-btn.secondary {
          background: #666;
        }
        
        .link-btn.secondary:hover {
          background: #444;
        }
        
        .status {
          font-size: 0.85em;
          color: #999;
          margin-top: 20px;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>Hello, World! <span class="emoji">🚀</span></h1>
        <p class="subtitle">Welcome to the Self-Healing Pipeline Demo</p>
        
        <div class="version">v1.0.0</div>
        
        <div class="info">
          ✅ Application is running and healthy
        </div>
        
        <div class="features">
          <h2>Features</h2>
          <ul>
            <li>GitHub Actions CI/CD Pipeline</li>
            <li>Azure Container Apps Deployment</li>
            <li>Automated Error Detection</li>
            <li>Self-Healing with GitHub Copilot</li>
          </ul>
        </div>
        
        <div class="links">
          <a href="/health" class="link-btn">Health Check</a>
          <a href="/status" class="link-btn secondary">Status</a>
        </div>
        
        <div class="status">
          <p>Running on Node.js ${process.version}</p>
          <p>Started at ${new Date().toLocaleString()}</p>
        </div>
      </div>
    </body>
    </html>
  `;
  
  res.status(200).set('Content-Type', 'text/html').send(htmlContent);
});

// Status endpoint
app.get('/status', (req, res) => {
  res.status(200).json({
    status: 'running',
    application: 'Self-Healing Pipeline Demo',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
    nodeVersion: process.version
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: 'The requested endpoint does not exist',
    path: req.path
  });
});

// Start server
app.listen(port, () => {
  console.log(`🚀 Server is running on http://localhost:${port}`);
  console.log(`📍 Health check: http://localhost:${port}/health`);
  console.log(`📋 Status: http://localhost:${port}/status`);
  console.log(`🌍 Hello World: http://localhost:${port}/`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM signal received: closing HTTP server');
  process.exit(0);
});

module.exports = app;
