###
# Tailwind CSS v4 — external pipeline
###

# Tailwind v4 is CSS-first (no tailwind.config.js, no PostCSS config). The
# Tailwind CLI writes compiled CSS into .tmp/dist/stylesheets/site.css — a
# gitignored staging directory (see .gitignore) — rather than into source/
# directly, so `middleman build` never overwrites a tracked source file with
# minified output. `source:` tells Middleman to merge .tmp/dist into the
# sitemap, and because the file is nested under stylesheets/ there, it's
# served at the same /stylesheets/site.css path that `css_dir` below expects.
activate :external_pipeline,
  name: :tailwind,
  command: (build? ?
    "npx @tailwindcss/cli -i source/stylesheets/tailwind_input.css -o .tmp/dist/stylesheets/site.css --minify" :
    "npx @tailwindcss/cli -i source/stylesheets/tailwind_input.css -o .tmp/dist/stylesheets/site.css --watch"),
  source: ".tmp/dist"

activate :meta_tags
activate :asset_hash

set :css_dir, 'stylesheets'

set :turnstile_site_key, '1x00000000000000000000AA' # CF test key, always passes

configure :development do
  # Local dev / middleman server
  set :turnstile_site_key, '1x00000000000000000000AA' # Turnstile test key (always passes)
end

configure :build do
  # Production build
  set :turnstile_site_key, ENV.fetch('TURNSTILE_SITE_KEY', '0x4AAAAAAD16j1cFmO0nn3ql')
end

# source/CNAME is a plain static file — Middleman copies it into build/
# automatically like any other source asset, no reference needed here.

configure :build do
  activate :minify_html
  # CSS is intentionally NOT minified here — Tailwind's own --minify flag
  # (invoked above for `middleman build`) already handles that.
end
