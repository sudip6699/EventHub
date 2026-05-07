<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>EventHub</title>
    
    <!-- Tailwind CSS CDN — MUST BE HERE -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    
    <!-- Material Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    
    <!-- Tailwind Config -->
    <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            "primary": "#ae271d",
            "primary-container": "#ff7766",
            "on-primary": "#ffefed",
            "secondary": "#a03648",
            "secondary-container": "#ffc2c7",
            "on-secondary": "#ffefef",
            "tertiary": "#7a41a3",
            "tertiary-container": "#d498ff",
            "on-tertiary": "#fceeff",
            "surface": "#fff4f4",
            "surface-container-low": "#ffeced",
            "surface-container": "#ffe1e3",
            "surface-container-high": "#ffdadc",
            "surface-container-lowest": "#ffffff",
            "on-surface": "#4d2127",
            "on-surface-variant": "#824c52",
            "outline-variant": "#de9ca1",
            "background": "#fff4f4"
          },
          borderRadius: {
            "DEFAULT": "1rem",
            "lg": "2rem",
            "full": "9999px"
          },
          fontFamily: {
            "headline": ["Plus Jakarta Sans"],
            "body": ["Be Vietnam Pro"]
          }
        }
      }
    }
    </script>
    
    <style>
    body { font-family: 'Be Vietnam Pro', sans-serif; background-color: #fff4f4; color: #4d2127; }
    h1,h2,h3,h4 { font-family: 'Plus Jakarta Sans', sans-serif; }
    .material-symbols-outlined { font-variation-settings: 'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24; }
    .glass-nav { background: rgba(255,255,255,0.7); backdrop-filter: blur(20px); }
    .primary-gradient { background: linear-gradient(135deg, #ae271d 0%, #ff7766 100%); }
    </style>
</head>