echo "load tmux functions..."
# http://robinwinslow.co.uk/2012/07/20/tmux-and-ssh-auto-login-with-ssh-agent-finally/
function tmux_ssh() {
    if [ -z "$TMUX" ]; then
        # we're not in a tmux session

        if [ ! -z "$SSH_TTY" ]; then
            # We logged in via SSH

            # if ssh auth variable is missing
            if [ -z "$SSH_AUTH_SOCK" ]; then
                export SSH_AUTH_SOCK="$HOME/.ssh/.auth_socket"
            fi

            # if socket is available create the new auth session
            if [ ! -S "$SSH_AUTH_SOCK" ]; then
                `ssh-agent -a $SSH_AUTH_SOCK` &> /dev/null
                echo $SSH_AGENT_PID > $HOME/.ssh/.auth_pid
            fi

            # if agent isn't defined, recreate it from pid file
            if [ -z $SSH_AGENT_PID ]; then
                export SSH_AGENT_PID=`cat $HOME/.ssh/.auth_pid`
            fi

            # Add all default keys to ssh auth
            ssh-add 2>/dev/null

            # start tmux
            #tmux attach
        fi
    fi
}

function attach_tmux() {
    # Attach tmux
    if ( ! test $TMUX ) && ( ! expr $TERM : "^screen-256color" > /dev/null ) && which tmux > /dev/null; then
        if ( tmux has-session ); then
            session=`tmux list-sessions | grep -e '^[0-9].*]$' | head -n 1 | sed -e 's/^\([0-9]\+\).*$/\1/'`
            if [ -n "$session" ]; then
                echo "attach_tmux(): Attache tmux session $session."
                tmux attach-session -t $session
                #tmux attach-session
            else
                echo "attach_tmux(): Session has been already attached."
                tmux list-sessions
            fi
        else
            echo "attach_tmux(): Create new tmux session."
            tmux
        fi
    fi
}
