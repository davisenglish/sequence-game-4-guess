# Hosting 5-guess at `stringlish.com/5-guess/`

## Why two repos aren’t two paths on one domain

GitHub Pages gives **one** published site per repository that has the custom domain.  
Your domain **`stringlish.com`** is attached to **`my-app-compilation`**, so **everything** at that hostname is whatever that repo’s deployment outputs—usually the **`gh-pages`** branch (or **Actions** → **Pages**).

There is **no** GitHub setting like “also mount `sequence-game-5-guess` at `/5-guess/`.”  
To get **`stringlish.com/5-guess/`**, the **homepage** site must **include** the 5-guess app as **static files under that folder** in the same deployment.

## Pattern (standard approach)

1. **Build** this app (`my-app-ver2`) with  
   `homepage` = `https://stringlish.com/5-guess`  
   so asset URLs (`/5-guess/static/...`) are correct.
2. **Copy** the contents of `build/` into  
   **`my-app-compilation/public/5-guess/`**  
   (Create React App copies `public/` into the root of `build/` when you build the homepage, so you get `build/5-guess/...` on `stringlish.com`).
3. **Build and deploy** `my-app-compilation` as you already do for `stringlish.com`.

## Automated copy from this repo

From **`my-app-ver2`**:

```bash
chmod +x scripts/embed-in-compilation.sh
./scripts/embed-in-compilation.sh /path/to/my-app-compilation
```

Default first argument (if omitted) is **`../my-app-compilation`** (sibling folder).

Or use npm:

```bash
npm run embed:stringlish
```

Then in **`my-app-compilation`**:

```bash
git add public/5-guess
git commit -m "Update embedded 5-guess build"
git push
CI=false npm run deploy   # or your usual deploy
```

## Links from the homepage

In **`my-app-compilation`**, point buttons/links to:

- **`/5-guess/`** (same origin, works on `stringlish.com`)

Keep **`https://davisenglish.github.io/sequence-game-5-guess/`** if you still want a standalone GitHub Pages URL; that build keeps using the **`homepage`** in this repo’s `package.json` (`npm run deploy` here).

## Optional: don’t commit `public/5-guess/` in git

You can instead run **`embed-in-compilation.sh`** only in **CI** before building the homepage, and add `public/5-guess/` to **`.gitignore`** in `my-app-compilation`. That keeps a single source of truth but requires a workflow that clones/builds this repo.
