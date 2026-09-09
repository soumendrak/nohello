port := "8080"
mocks_port := "4499"

# List available recipes
default:
    @just --list

# Serve the site locally and open it
dev:
    @echo "http://127.0.0.1:{{port}}"
    @# open only once the port is actually accepting connections
    @(until curl -sf -o /dev/null http://127.0.0.1:{{port}}/; do sleep 0.2; done; open http://127.0.0.1:{{port}}/) &
    python3 -m http.server {{port}} --bind 127.0.0.1

# Serve the site the way Cloudflare will
preview:
    npx wrangler dev

# Deploy to Cloudflare
deploy:
    npx wrangler deploy

# Serve the landing-page mocks
mocks:
    @echo "http://127.0.0.1:{{mocks_port}}/mock-a-two-windows.html"
    cd .lavish/landing-mocks && python3 -m http.server {{mocks_port}} --bind 127.0.0.1

# Open the A/B/C mock review surface in Lavish
review:
    lavish-axi .lavish/landing-mocks/index.html

# Delete scratch screenshots and tool logs
clean:
    rm -f shot-*.png live-*.png
    rm -rf .playwright-mcp
