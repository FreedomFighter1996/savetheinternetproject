# Save The Internet

An independent, non-commercial advocacy site. Plain static HTML, CSS and JavaScript.
No build step, no dependencies, no package manager.

## Pages

| File | Purpose |
|---|---|
| `index.html` | Home. Hero, the diagnosis, the three commitments, log preview. |
| `pitch.html` | The full argument: what happened, five concrete asks, what this is not. |
| `contribute.html` | Four ways to help, three things to do today, signup form, note on money. |
| `about.html` | Origin, six operating rules, FAQ. |
| `daily.html` | Dated devlog, newest first. Entry template is commented inside the file. |

Shared assets:

- `assets/css/style.css` — all styling, organised in numbered sections. Design tokens live at the top under `:root`.
- `assets/js/main.js` — mobile nav toggle and scroll reveals. That is all it does.

## Running it

There is no server to start. Open `index.html` in a browser, or drag it onto a browser window.
Links between pages are relative, so it works straight from disk.

## Previewing mobile and desktop

```sh
sh tools/build-preview.sh
```

This regenerates `preview.html`, a single self-contained file that shows any page inside a
phone frame and a desktop frame side by side. It inlines the CSS and JS at build time, so
**rerun it after any change** or the preview will show the old version.

For real testing, still use your browser's device toolbar (F12, then the phone icon) on the
actual pages. The preview is for looking at both sizes at once.

## Editing

Header and footer markup is duplicated in each of the five pages. That is the deliberate cost
of having no build step. If you change a nav link, change it in all five files.

Design tokens to change first, all at the top of `style.css`:

- `--accent` — the green used for links, buttons and rules
- `--ink` / `--ink-2` — page and card backgrounds
- `--paper` — the light section background
- `--font-display` / `--font-body` — typefaces, loaded from Google Fonts in each page head

## Before this goes public

1. Replace every placeholder statistic on `index.html`. They are all `00%` with a "Source needed" label. Do not publish unsourced numbers on an advocacy site.
2. Connect the form on `contribute.html`. Instructions are in an HTML comment directly above it (Netlify Forms or Formspree, both no-backend).
3. Fill in the author name and contact email on `about.html`. Search for `TODO`.
4. Replace the `#` placeholder links in the footer (GitHub, RSS, Email).
5. Rewrite the copy in your own voice. The current text is a structured first draft, not final.

Find everything outstanding with:

```sh
grep -rn "TODO" .
```

## Deploying

Any static host works. Push to GitHub and enable Pages, or drag the folder onto Netlify.
No build command, no output directory.
