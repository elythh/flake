_:
''
#!/usr/bin/env bash

vol="$(eww get volume)"

if [[ -z $(eww windows | grep '*volume') ]]; then
  eww open volume
fi

while true; do
  sleep 2.5

  new_vol=$(eww get volume)

  if [ "$vol" != "$new_vol" ]; then
    vol="$new_vol"
  else
    newest_vol=$(eww get volume)
    if [ "$vol" == "$newest_vol" ]; then
      if [[ -n $(eww windows | grep '*volume') ]];then
        eww close volume;
        exit
      fi
    fi
  fi
done
''
