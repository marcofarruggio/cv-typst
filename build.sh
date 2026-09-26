#!/bin/zsh
# Build all variants (or the ones passed as arguments) into build/.
#   ./build.sh               -> all variants
#   ./build.sh data-it       -> a single variant
#   DRAFT=1 ./build.sh       -> highlight TODO fields in red
# The template is chosen in the variant with "template: design" (default: cv).
cd "$(dirname "$0")"
mkdir -p build
variants=("$@")
[[ ${#variants} -eq 0 ]] && variants=(variants/*.yaml(:t:r))
for v in $variants; do
  tpl=$(sed -n 's/^template: *\([a-z-]*\).*/\1/p' variants/$v.yaml)
  tpl=${tpl:-cv}
  typst compile --root . --font-path fonts \
    --input variant=$v --input draft=${DRAFT:-0} \
    templates/$tpl.typ "build/cv-$v.pdf" && echo "ok  $v ($tpl)"
done
