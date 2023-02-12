# CMD Powerline

## Introduction

Simple and easily customisable Powerline for Windows Command Prompt.

![image](https://user-images.githubusercontent.com/13545633/214640756-e2938b6e-eea3-4185-a76e-2382a7978170.png)  
![image](https://user-images.githubusercontent.com/13545633/214641365-afc0c073-25f2-4fad-bdba-1db1fbf254a4.png)  
![image](https://user-images.githubusercontent.com/13545633/215299932-c60759d1-6123-4b6e-98e4-18e9b237867f.png)  
![image](https://user-images.githubusercontent.com/13545633/215236257-87afcebf-5b5b-4045-8c39-309bac8d0b7d.png)  
![image](https://user-images.githubusercontent.com/13545633/215237326-b653f58f-8ddd-4249-a853-cf7ee935f616.png)  
![image](https://user-images.githubusercontent.com/13545633/215236670-771fd959-da8c-481b-8935-4f03a4107966.png)  
![image](https://user-images.githubusercontent.com/13545633/215236785-8991518f-1083-42e0-8ff4-6cd52e47fbcd.png)

## Setup

> **Prerequisite**: A font supporting Powerline symbols needs to be installed.

Firstly, [clone this repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) to a desired location.
For example, under `%HOME%\.cmd\`.

> You could also manually download the repository as a .zip file and extract to the desired location.
However, you will have to repeat this process instead of a `git pull` if there are any updates to the files.

Now, all you have to do is: whenever you want to call `cmd` for an interactive window, call `cmd /k "path\to\cmd-powerline\init.cmd"` instead.
Make sure `path\to\cmd-powerline` is the location you cloned the repository into.

You can append extra arguments to select the style profiles of each instance for different occasions. See [configuring `styles.cmd`](#stylescmd).

### Example: Windows Terminal

1. Open settings, and navigate to the "Command Prompt" profile.
2. Change the "Command line" value from `...\cmd.exe` to `...\cmd.exe /k "path\to\cmd-powerline\init.cmd"`.
3. Save the changes.

### Example: VS Code

1. Open settings, and navigate to Terminal > Integrated > Profiles: Windows (`"terminal.integrated.profiles.windows"`).
2. Edit the value in `settings.json`.
3. Modify `"args"` of `"Command Prompt"` to `["/k", "path\\to\\cmd-powerline\\init.cmd"]`.

   Make sure the backslashes are escaped in the JSON file.

### _(Not Recommended)_ Using Registry

Optionally, you can add/modify the `HKLM | HKCU \Software\Microsoft\Command Processor\AutoRun` key to run `init.cmd`.
This way, any instance of a Command Prompt window will have the Powerline set up.

However, do note that modifying the AutoRun key is not recommended.
Although code contains checks to ensure that `init.cmd` will only run on an interactive window,
there may still be bugs due to the nature of the AutoRun key.

> Additionally, you should modify or clear out the content of [`header.cmd`](#headercmd),
as the original header text will be displayed as usual with this method.

## Configuration

### `header.cmd`

This file is executed once when the `init.cmd` is called.
Since calling `cmd` with the argument `/k` skips the header text that would normally be displayed upon opening a new Command Prompt window,
the default behaviour of the file is to mimic the header text.

If you prefer to have a different header text or no header at all, simply edit or delete this file.

### `styles.cmd`

This is where you can customise the styles in detail.
The configuration is done in two parts: profiles and segments.

Segments are the definitions of sections of text, and profiles are the definitions of how to arrange the segments.

When initialisation is done by calling `init.cmd` with no arguments, it loads the `p_default` profile.
Profile names passed as arguments to `init.cmd` (without the prefix "`p_`") will apply the profiles in the order.

> For example, `init.cmd default detailed newline` will apply `p_default`, `p_detailed` and `p_newline` profiles in that order.

You can add/edit individual profiles and sections, including the default profile.

#### Profiles

- `segments`: A space-separated list of `segments:color` or `"text":color`.
  - `segment`: Specify the segment name(s) without the prefix "`s_`". Multiple segments can be joined with the `-` delimiter.

  - `"text"`: Alternatively, text can be entered directly using double quotes.
  However, this direct text cannot contain any special characters or variables holding special characters.

  - `color`: A colour code pair for foreground and background.
    See [wikipedia](https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit).
    - Standard: A pair of 1-digit hexadecimal numbers &mdash; 0~7.
    - High intensity: A pair of 1-digit hexadecimal numbers &mdash; 8~F.
    - Grayscale: A pair of 2-digit octal numbers from black to white &mdash; 00~27.
    - 666 cube: A pair of 3-digit heximal (base 6) numbers of RGB &mdash; 000~555.
    - 24-bit: A pair of 6-digit hexadecimal numbers of RGB &mdash; 000000~FFFFFF

    Colour can be ommited, in which case it defaults to either the colours specified in the segment definition, or `00`.

- `separator`: A character to append at the end of each section. For example, the right-facing-triangle character `U+E0B0` (Powerline font symbol).

- `margin`: String to append to the end of the powerline. Usually a space, or a newline followed by a '>' or '$'. Use the escape characters of `PROMPT`.
See [microsoft docs](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/prompt#remarks).

#### Segments

- `text`: The text of the segment. Special characters need to be escaped using the `PROMPT` escape characters.
See [microsoft docs](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/prompt#remarks). More information below.
- `var` (Optional): Dynamic evaluation variable. More information below.
- `cmd` (Optional): Dynamic evaluation command. More information below.
- `fore` (Optional):
- `back` (Optional): The default foreground/background colours for the segment. They will be overridden by the explicit colour specifiers of profiles.

Segments can have constants, variables or dynamic evaluations.

- A constant segment has a constant text that is evaluated at the initialisation phase.

  > For example, `text=$S%USERNAME%@%COMPUTERNAME%$S`.

  The variables `%USERNAME%` and `%COMPUTERNAME%` are evaluated only once when the script is loaded.
- Segments can also have variables that are evaluated on [update](#how-it-works).
They need to have their `%`s doubled to escape evaluation on initialisation.

  > For example, `text=$S%%DATE%%$S`.
- Dynamic evaluations have three parts: variable, command and text. They are essentially evaluated by the `for /f` command.

  ```cmd
  for /f %var% in (!cmd!) do ...%text%
  ```

  Thus,
  - `var` can contain the options for `for /f`.

    >For example, `var="tokens=1,2" %%i`.

    Note that `%` needs to be doubled within the batch script.
  - `cmd` needs to be surrounded by single quotes `'...'`, or backticks `` `...` `` if the option `"usebackq"` is supplied in `var`.
  - `cmd` needs to have special characters (``%^&<>|'`,;=()!``) escaped.
  - `text` can then use the introduced variable(s).
    > For example, `text=%%i-%%j`.

## How it works

The script simply uses `DOSKEY` to hijack `"cd"` and `"git"`, so whenever they are run,
`update.cmd` gets called to update the prompt text.

Any variables introduced will have a `PL_` prefix. You can type `set PL_` to see the list.
