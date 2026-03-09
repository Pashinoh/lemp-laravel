# Debug Guide

If app is not accessible or blank, run these checks in order.

## 1. Check container state

```bash
docker compose ps
```

## 2. Check logs

```bash
docker compose logs nginx --tail=100
docker compose logs app --tail=100
docker compose logs db --tail=100
```

## 3. Validate Nginx and PHP

```bash
docker compose exec nginx nginx -t
docker compose exec app php -v
docker compose exec app composer -V
```

## 4. Fix Laravel permissions (container side)

```bash
docker compose exec app sh -lc "chown -R www-data:www-data storage bootstrap/cache && chmod -R 775 storage bootstrap/cache"
```

## 5. Rebuild cleanly

```bash
docker compose down
docker compose up -d --build
```
