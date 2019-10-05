# fish-index

🐟 Shows indexed chars of a hidden input string

```
Usage: index [OPTION] [STRINGS]

Description:
    Prints the index of characters in a string.
    Sensitive strings can be given as a prompt,
    to avoid appearing in the shell's history.

Examples:

    $ index ab cd
    1: a
    2: b

    1: c
    2: d

    $ index "ab cd"
    1: a
    2: b
    3:
    4: c
    5: d

    $ index
    Secret ▶ ●●●●
    Chars  ▶ 2 4
    2: x
    4: z

    $ index
    Secret ▶ ●●●
    Chars  ▶
    1: x
    2: y
    3: z

Options:
    -h, --help      Prints help and exits
```
