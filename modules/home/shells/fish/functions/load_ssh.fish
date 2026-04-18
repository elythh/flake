function load_ssh
    if status is-login
        and status is-interactive
        set -l key ~/.ssh/id_default
        if test -f $key
            ssh-add $key >/dev/null 2>&1 </dev/null
        end
    end
end
