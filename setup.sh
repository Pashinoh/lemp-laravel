#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-menu}"

print_cmd() {
  echo
  echo "> docker compose $*"
}

run_compose() {
  print_cmd "$@"
  docker compose "$@"
}

ensure_src_directory() {
  if [ ! -d "src" ]; then
    mkdir -p src
    echo "Created ./src directory."
  fi
}

ensure_laravel_project() {
  ensure_src_directory
  if [ ! -f "src/artisan" ]; then
    echo "Laravel source not found. Creating project..."
    run_compose run --rm app composer create-project laravel/laravel .
  else
    echo "Laravel source already exists. Skipping create-project."
  fi
}

configure_laravel_runtime() {
  echo "Configuring Laravel runtime..."
  docker compose exec -T app sh -lc "if [ ! -f .env ]; then cp .env.example .env; fi"
  docker compose exec -T app php artisan key:generate
  docker compose exec -T app sh -lc "sed -i 's/^SESSION_DRIVER=.*/SESSION_DRIVER=file/' .env; sed -i 's/^CACHE_STORE=.*/CACHE_STORE=file/' .env; sed -i 's/^QUEUE_CONNECTION=.*/QUEUE_CONNECTION=sync/' .env; php artisan config:clear"
}

run_demo_checks() {
  local check_pma="${1:-false}"

  echo
  echo "Running demo checks..."
  run_compose ps
  docker compose exec -T app php artisan route:list
  docker compose exec -T app php artisan migrate:status

  local app_code
  app_code="$(curl -s -o /dev/null -w "%{http_code}" http://localhost || true)"
  if [ "$app_code" != "200" ]; then
    echo "Laravel endpoint check failed (HTTP $app_code)."
    exit 1
  fi
  echo "Laravel endpoint: HTTP $app_code"

  if [ "$check_pma" = "true" ]; then
    local pma_code
    pma_code="$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 || true)"
    if [ "$pma_code" != "200" ]; then
      echo "phpMyAdmin endpoint check failed (HTTP $pma_code)."
      exit 1
    fi
    echo "phpMyAdmin endpoint: HTTP $pma_code"
  fi
}

start_stack() {
  local include_pma="${1:-false}"

  if [ "$include_pma" = "true" ]; then
    run_compose --profile tools up -d --build
  else
    run_compose up -d --build app db nginx
  fi
}

run_install_flow() {
  local include_pma="${1:-false}"

  ensure_laravel_project
  start_stack "$include_pma"
  configure_laravel_runtime
  run_demo_checks "$include_pma"

  echo "App: http://localhost"
  if [ "$include_pma" = "true" ]; then
    echo "phpMyAdmin: http://localhost:8080"
  else
    echo "phpMyAdmin not enabled. Enable later with: ./setup.sh tools-on"
  fi
}

show_menu() {
  echo
  echo "LEMP Laravel Installer/CLI"
  echo "1. Install (choose phpMyAdmin yes/no)"
  echo "2. Demo check"
  echo "3. Enable phpMyAdmin"
  echo "4. Disable phpMyAdmin"
  echo "5. Status"
  echo "6. Down"
  echo "0. Exit"
  read -r -p "Select: " choice

  case "$choice" in
    1) MODE="install" ;;
    2) MODE="demo" ;;
    3) MODE="tools-on" ;;
    4) MODE="tools-off" ;;
    5) MODE="status" ;;
    6) MODE="down" ;;
    *) MODE="exit" ;;
  esac
}

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker CLI not found. Install/start Docker first."
  exit 1
fi

if [ "$MODE" = "menu" ]; then
  show_menu
fi

case "$MODE" in
  install)
    read -r -p "Install phpMyAdmin now? (y/n): " pick
    if [ "$pick" = "y" ]; then
      run_install_flow true
    else
      run_install_flow false
    fi
    ;;
  demo)
    read -r -p "Check phpMyAdmin endpoint too? (y/n): " want_pma
    if [ "$want_pma" = "y" ]; then
      run_demo_checks true
    else
      run_demo_checks false
    fi
    ;;
  tools-on)
    echo "Enabling phpMyAdmin..."
    run_compose --profile tools up -d phpmyadmin
    run_compose ps
    echo "phpMyAdmin: http://localhost:8080"
    ;;
  tools-off)
    echo "Disabling phpMyAdmin..."
    docker compose stop phpmyadmin
    run_compose ps
    ;;
  status)
    run_compose ps
    ;;
  down)
    run_compose down
    ;;
  exit)
    echo "Exit."
    ;;
  *)
    echo "Unknown mode. Use: menu | install | demo | tools-on | tools-off | status | down"
    exit 1
    ;;
esac
