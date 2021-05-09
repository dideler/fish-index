function index --description "Shows character indexes of a string"
  argparse --name=Error 'h/help' -- $argv

  set --local parse_status $status
  test $parse_status -ne 0 && return $parse_status

  if set --query _flag_help
    echo "Usage: index [OPTION] [STRINGS]"
    echo
    echo "Description:"
    echo "    Prints the index of characters in a string."
    echo "    Sensitive strings can be given as a prompt,"
    echo "    to avoid appearing in the shell's history."
    echo
    echo "Examples:"
    echo
    echo "    \$ index ab cd"
    echo "    1: a"
    echo "    2: b"
    echo
    echo "    1: c"
    echo "    2: d"
    echo
    echo "    \$ index \"ab cd\""
    echo "    1: a"
    echo "    2: b"
    echo "    3:"
    echo "    4: c"
    echo "    5: d"
    echo
    echo "    \$ index"
    echo "    Secret ▶ ●●●●"
    echo "    Chars  ▶ 2 4"
    echo "    2: x"
    echo "    4: z"
    echo
    echo "    \$ index"
    echo "    Secret ▶ ●●●"
    echo "    Chars  ▶ "
    echo "    1: x"
    echo "    2: y"
    echo "    3: z"
    echo
    echo "Options:"
    echo "    -h, --help      Prints help and exits"
    return 0
  end

  set --local argc (count $argv)

  if test $argc -eq 0
    set --local paste_data (_clipboard_paste)

    if string match -qr . -- "$paste_data"
      set secret $paste_data
      fish_clipboard_copy
      echo "Secret fetched and erased from clipboard"
    else
      read_silent --prompt="Secret ▶ " secret
    end

    test -z "$secret" && return 1
    set --local chars (string split '' $secret)
    set --erase secret

    read --delimiter=' ' --array --prompt-str="Indexes  ▶ " --local raw_indexes

    set --local indexes
    for i in $raw_indexes
      if test -n $i
        set indexes $indexes $i
      end
    end

    if test -z "$indexes"
      for i in (seq (count $chars))
        printf '%2d: %s\n' $i $chars[$i]
      end
    else
      for i in $indexes
        printf '%2d: %s\n' $i $chars[$i]
      end
    end
  else
    set --local input $argv[1]

    for arg_i in (seq $argc)
      set --local chars (string split '' $argv[$arg_i])

      for i in (seq (count $chars))
        echo $i: $chars[$i]
      end

      test "$arg_i" -lt "$argc" && echo
    end
  end
end

function _clipboard_paste # Forked from fish_clipboard_paste
  set -l data
  if type -q pbpaste
    set data (pbpaste 2>/dev/null)
  else if set -q WAYLAND_DISPLAY; and type -q wl-paste
    set data (wl-paste 2>/dev/null)
  else if type -q xsel
    set data (xsel --clipboard 2>/dev/null)
  else if type -q xclip
    set data (xclip -selection clipboard -o 2>/dev/null)
  else if type -q powershell.exe
    set data (powershell.exe Get-Clipboard | string trim -r -c \r)
  end

  # Issue 6254: Handle zero-length clipboard content
  if not string match -qr . -- "$data"
    return 1
  end

  # Also split on \r to turn it into a newline,
  # otherwise the output looks really confusing.
  set data (string split \r -- $data)

  # If the current token has an unmatched single-quote,
  # escape all single-quotes (and backslashes) in the paste,
  # in order to turn it into a single literal token.
  #
  # This eases pasting non-code (e.g. markdown or git commitishes).
  set -l quote_state (__fish_tokenizer_state -- (commandline -ct | string collect))
  if contains -- $quote_state single single-escaped
    if status test-feature regex-easyesc
      set data (string replace -ra "(['\\\])" '\\\\$1' -- $data)
    else
      set data (string replace -ra "(['\\\])" '\\\\\\\$1' -- $data)
    end
  else if not contains -- $quote_state double double-escaped
       and set -q data[2]
    # Leading whitespace in subsequent lines is unneded, since fish
    # already indents. Also gets rid of tabs (issue #5274).
    set -l tmp
    for line in $data
      switch $quote_state
        case normal
          set -a tmp (string trim -l -- $line)
        case single single-escaped double double-escaped escaped
          set -a tmp $line
      end
      set quote_state (__fish_tokenizer_state -i $quote_state -- $line)
    end
    set data $data[1] $tmp[2..]
  end
  if not string length -q -- (commandline -c)
    # If we're at the beginning of the first line, trim whitespace from the start,
    # so we don't trigger ignoring history.
    set data[1] (string trim -l -- $data[1])
  end

  if test -n "$data"
    echo $data
  end
end
