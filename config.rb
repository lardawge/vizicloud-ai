###
# Tailwind CSS v4 — external pipeline
###

# Tailwind v4 is CSS-first (no tailwind.config.js, no PostCSS config). The
# Tailwind CLI is shelled out to directly and writes compiled CSS straight
# into source/stylesheets/site.css, so Middleman's normal source watcher
# picks it up like any other source file — there is no separate staging
# directory to merge in. Middleman's external_pipeline extension requires a
# `source:` option, so it's pointed at the same source/stylesheets directory
# that's already part of the normal sitemap — it does no extra work beyond
# satisfying that requirement.
activate :external_pipeline,
  name: :tailwind,
  command: (build? ?
    "npx @tailwindcss/cli -i source/stylesheets/tailwind_input.css -o source/stylesheets/site.css --minify" :
    "npx @tailwindcss/cli -i source/stylesheets/tailwind_input.css -o source/stylesheets/site.css --watch"),
  source: "source/stylesheets"

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
