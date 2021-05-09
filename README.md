# fish-index

Shows indexed characters for hidden or visible input strings.

## Demo

![Demo usage of fish-index](https://user-images.githubusercontent.com/497458/66255972-61da3a80-e781-11e9-9656-e4f0db3eb70e.gif)

## Installation

Install with your favourite fish package manager, such as [fisherman][] or [oh-my-fish][]
```fish
# Install with fisher v4
fisher install dideler/fish-index

# Install with fisher v3
fisher add dideler/fish-index

# Install with fisher v2
fisher install dideler/fish-index

# Install with oh-my-fish
omf install https://github.com/dideler/fish-index
```

## Usage

```
Usage: index [OPTION] [STRINGS]

Description:
    Prints the index of characters in a string.
    Sensitive strings can be given as a prompt
    or fetched and cleared from the clipboard,
    to avoid appearing in the shell's history.

    When no indexes given, prints all indexes.

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
    Secret  ▶ ●●●●
    Indexes ▶ 2 4
    2: x
    4: z

    $ index
    Secret  ▶ ●●●
    Indexes ▶
    1: x
    2: y
    3: z

    $ index
    Secret  ▶ popped from clipboard
    Indexes ▶ 1 2 3
    1: x
    2: y
    3: z

Options:
    -h, --help      Prints help and exits
```

[fisherman]: https://github.com/fisherman/fisherman
[oh-my-fish]: https://github.com/oh-my-fish/oh-my-fish
