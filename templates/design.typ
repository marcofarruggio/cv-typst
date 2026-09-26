// ============================================================
// Template CV "design" — due colonne con barra laterale e foto.
// Più accattivante, meno adatto agli ATS: usalo per candidature
// consegnate a mano, non per i portali online.
// Stessi dati e stesse varianti di cv.typ (template: design).
// ============================================================

#import "lib.typ": *

// ---------- palette ----------
#let navy = rgb("#2d3a4e")
#let navy-soft = rgb("#51607a")
#let side-text = rgb("#e9edf3")
#let side-muted = rgb("#aab4c3")
#let ink = rgb("#1d2430")
#let muted = rgb("#6b7280")
#let rule-c = rgb("#d5dbe3")
#let side-w = 6.5cm

#set document(title: cv.personal.name + " — CV", author: cv.personal.name)
#set page(paper: "a4", margin: 0pt,
  background: place(left + top, rect(width: side-w, height: 100%, fill: navy)))
#set text(font: ("Inter", "Helvetica Neue", "Libertinus Serif"), size: 9.2pt, lang: lang, fill: ink)
#set par(leading: 0.55em)

// ---------- barra laterale ----------
#let side-section(title) = {
  v(12pt)
  text(size: 11pt, weight: "bold", fill: white, tracking: 0.4pt, title)
  v(-7pt)
  line(length: 100%, stroke: 0.5pt + side-muted)
  v(2pt)
}

#let sidebar = {
  set text(fill: side-text, size: 8.8pt)
  if variant.at("photo", default: true) {
    align(center, box(width: 3.5cm, height: 3.5cm, radius: 50%, clip: true,
      stroke: 2.5pt + white, image("/assets/photo.png", width: 100%)))
    v(4pt)
  }

  side-section(if lang == "it" { "Contatti" } else { "Contact" })
  let c = cv.personal
  for x in (c.at("phone", default: none), c.at("email", default: none), t(c.location)) {
    if x != none and not is-todo(x) { block(below: 5pt, x) }
  }
  for l in c.at("links", default: ()).filter(l => not is-todo(l.url)) {
    block(below: 5pt, link(l.url, underline(l.label)))
  }

  let groups = cv.skills.filter(included)
  if groups.len() > 0 {
    side-section(L.skills)
    for g in groups {
      block(below: 4pt, text(size: 7.8pt, weight: "semibold", fill: side-muted, tracking: 0.5pt, upper(t(g.group))))
      block(below: 9pt, g.items.map(i => t(i)).join("  ·  "))
    }
  }

  side-section(L.languages)
  for l in cv.languages {
    block(below: 5pt)[#text(weight: "semibold", fill: white, t(l.name)) #h(3pt) #show-t(l.level)]
  }

  let certs = cv.at("certifications", default: ()).filter(included)
  if certs.len() > 0 {
    side-section(L.certifications)
    for c in certs {
      block(below: 7pt)[
        #text(weight: "semibold", fill: white, t(c.title)) \
        #text(size: 8pt, fill: side-muted)[#show-t(c.org) · #show-t(c.year)]
      ]
    }
  }
}

// ---------- colonna principale ----------
#let main-section(title) = {
  v(10pt)
  text(size: 13pt, weight: "bold", fill: navy, title)
  v(-7pt)
  line(length: 100%, stroke: 0.8pt + navy)
  v(3pt)
}

#let dot = box(baseline: 1pt, circle(radius: 3.2pt, stroke: 1.3pt + navy, fill: white))

#let bullets(items) = {
  let bs = items.filter(included).map(b => show-t(b)).filter(x => x != none)
  if bs.len() > 0 {
    set list(indent: 12pt, body-indent: 5pt, spacing: 3.5pt, marker: text(fill: navy-soft, "•"))
    set text(size: 8.9pt)
    list(..bs)
  }
}

#let item(dates, org, title, body) = block(breakable: false, below: 10pt)[
  #if dates != none { text(size: 8pt, weight: "semibold", fill: muted, tracking: 0.3pt, dates); v(-5pt) }
  #if org != none { text(size: 8.8pt, fill: muted, org); v(-5pt) }
  #dot #h(4pt) #text(size: 10.5pt, weight: "semibold", fill: navy, title)
  #body
]

#let main = {
  text(size: 28pt, weight: "bold", fill: navy, tracking: 1pt, cv.personal.name)
  v(-14pt)
  text(size: 11pt, fill: navy-soft, tracking: 1.5pt, headline())

  let sums = cv.summary.filter(included).map(s => show-t(s)).filter(x => x != none)
  if sums.len() > 0 {
    main-section(L.summary)
    sums.join(parbreak())
  }

  let exps = experience-items()
  if exps.len() > 0 {
    main-section(L.experience)
    let prev = none
    for e in exps {
      let org = if e.org == prev { none } else { exp-org(e) + if e.at("location", default: none) != none { " · " + e.location } }
      item(date-range(e.start, e.end), org, show-t(e.role), bullets(e.at("bullets", default: ())))
      prev = e.org
    }
  }

  let edu = cv.education.filter(included)
  if edu.len() > 0 {
    main-section(L.education)
    for e in edu { item(edu-dates(e), t(e.org), show-t(e.title), bullets(e.at("bullets", default: ()))) }
  }
}

#grid(columns: (side-w, 1fr),
  pad(x: 0.75cm, top: 1.1cm, bottom: 0.8cm, sidebar),
  pad(left: 0.8cm, right: 1.2cm, top: 1.1cm, bottom: 0.8cm, main))
