# Configuration Web - URLs sans Hash (#)

Cette application utilise le mode **path-based URLs** (sans `#`) pour une meilleure SEO et des URLs plus propres.

## Configuration effectuée

1. **Code Flutter** : `usePathUrlStrategy()` est appelé dans `lib/main.dart`
2. **HTML** : La balise `<base href="/">` est configurée dans `index.html`

## Configuration serveur requise

Pour que les URLs sans `#` fonctionnent correctement, le serveur web doit rediriger toutes les requêtes vers `index.html`.

### Apache (.htaccess)
Un fichier `.htaccess` est fourni dans le dossier `web/`. Assurez-vous qu'il est déployé avec votre application.

### Firebase Hosting
Ajoutez dans `firebase.json` :
```json
{
  "hosting": {
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

### Nginx
Ajoutez dans votre configuration :
```nginx
location / {
  try_files $uri $uri/ /index.html;
}
```

### Vercel
Créez un fichier `vercel.json` :
```json
{
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

### Netlify
Créez un fichier `_redirects` dans `web/` :
```
/*    /index.html   200
```

## Vérification

Après déploiement, vérifiez que :
- Les URLs sont de la forme `https://example.com/home` (sans `#`)
- Le rafraîchissement de page fonctionne sur toutes les routes
- Les liens directs vers les routes fonctionnent


