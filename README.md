# cv-typst

A CV as code: **one YAML file with all the content, many PDFs out of it.**

Instead of keeping several copies of a CV in a design tool (Italian/English, one per role, one per application), all the content lives in a single file and each version is just a small configuration that picks what to show.

## How it works

```
data/cv.yaml        all the content, bilingual (it/en), with tags and priorities
variants/*.yaml     one file per version: language, profile, template, what to include
templates/lib.typ   shared logic (filters, language, dates)
templates/cv.typ    single-column, ATS-friendly layout (online applications)
templates/design.typ two-column layout with sidebar and optional photo
build.sh            builds every variant into build/
```

Each entry in `data/cv.yaml` has:

- **tags** — which profiles it belongs to (e.g. `data`, `sport`); `core` means always included;
- **priority** — `1` essential, `2` useful, `3` archive. A variant with `max_priority: 1` gives a tight one-page CV, `2` a longer one;
- **bilingual text** — `{ it: "...", en: "..." }`; missing translations are flagged when building with `DRAFT=1`.

A variant is just a few lines:

```yaml
lang: en
profile: data
max_priority: 1
template: cv          # or: design
sections: [summary, experience, skills, education, certifications, languages]
```

For a specific job application, copy a variant, change the profile or the priorities, and build. The content stays in one place.

## Usage

Requires [Typst](https://typst.app) (`brew install typst` on macOS).

```sh
zsh build.sh            # all variants -> build/
zsh build.sh data-en    # a single variant
DRAFT=1 zsh build.sh    # show TODO fields in red
```

Fonts: the templates use [Inter](https://rsms.me/inter/) (put the `.otf` files in `fonts/`) and fall back to system fonts otherwise.

## Why

- **One source of truth**: update a line once, every version follows.
- **Versioned**: plain text under git, so every change is tracked.
- **ATS-friendly**: the default template produces real, extractable text in a single column.

The example data describes a fictional person.

## License

Code: MIT. Inter font: SIL Open Font License (not included).
