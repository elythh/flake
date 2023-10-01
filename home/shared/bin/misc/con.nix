_:
''
  #!/usr/bin/env zsh
  mkdir -p converted
  find . -depth -name "* *" -execdir rename " " "_" "{}" ";"
  for file in ./*
  do
    lut "$file" "./converted/$file"
  done
''
