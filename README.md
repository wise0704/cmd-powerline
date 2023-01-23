# CMD Powerline

## Introduction
Simple and easily customisable Powerline for Windows Command Prompt.

![default](https://user-images.githubusercontent.com/13545633/214132836-0bfe0be8-77ac-45ea-86b3-382cc31cc179.png)  
![compact](https://user-images.githubusercontent.com/13545633/214176152-e115b2b1-9bad-4b4c-b9b0-d29259f3497d.png)  
![color_1 new_line](https://user-images.githubusercontent.com/13545633/214133005-1fd7ecb8-7dba-4c06-8e5e-4e768ac85eab.png)  
![color_2 bash](https://user-images.githubusercontent.com/13545633/214133105-09c96a5a-05b3-4bc2-b587-c8bf226f1a2b.png)

## Setup

**Prerequisite**: A font supporting Powerline needs to be installed.

Firstly, [clone this repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) to a desired location.
For example, under `%HOME%\.cmd\`.

> You could also manually download the repository as a .zip file and extract to the desired location.
However, you will have to repeat this process instead of a `git pull` if there are any updates to the files.

Now, all you have to do is: whenever you want to call `cmd` for an interactive window, call `cmd /k "path\to\repo\cmd-powerline\init.cmd"` instead.
Make sure `path\to\repo` is the location you cloned the repository into.

You can append extra arguments to customise the styles of each instance for different occasions. See [configuring `styles.cmd`](#stylescmd).

### Example: Windows Terminal
1. Open settings, and navigate to the "Command Prompt" profile.
2. Change the "Command line" value from `...\cmd.exe` to `...\cmd.exe /k "path\to\repo\cmd-powerline\init.cmd"`.
3. Save the changes.

![image](https://user-images.githubusercontent.com/13545633/214117106-f94b7e81-9951-42f4-ab4a-55fd69564790.png)

### Example: VS Code
1. Open settings, and navigate to Terminal > Integrated > Profiles: Windows (`"terminal.integrated.profiles.windows"`).
2. Edit the value in `settings.json`.
3. Modify `"args"` of `"Command Prompt"`
to `["/k", "path\\to\\repo\\cmd-powerline\\init.cmd"]`.
Make sure the backslashes are escaped in the JSON file.

![image](https://user-images.githubusercontent.com/13545633/214119298-71e537d7-d581-4afe-acb9-42b4f25dc1a6.png)

### (Not Recommended) Using Registry
Optionally, you can add/modify the `HKLM | HKCU \Software\Microsoft\Command Processor\AutoRun` key to run `init.cmd`.
This way, any instance of a Command Prompt window will have the Powerline set up.

However, do note that modifying the AutoRun key is not recommended.
Although code contains checks to ensure that `init.cmd` is not called recursively and will only run on an interactive window,
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
This is where you can customise the styles in detail, such as colours and leading/trailing characters.

The default configuration is set under the `:default` label.

 - The prefix `cd` means the directory part of the prompt text, and `git` means the git branch indicator.
 - Colors can be chosen from the range 0-7. See [wikipedia](https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit).
 - Leading and trailing characters and margin can use the special characters for `PROMPT`. See [microsoft docs](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/prompt#remarks).
 - Bright background uses the brigher version of the 3-bit colour pallet for the background (4-bit colours).

The labels are the arguments that you can pass to `init.cmd`, in which case the labels will be visited in the order they were entered.

For example, entering `/k init.cmd compact color_1 new_line` applies `:default`, `:compact`, `:color_1` and `:new_line` in that order.

## How it works
The script simply uses `DOSKEY` to hijack `"cd"` and `"git"`, so whenever they are run,
`update.cmd` gets called to get the current git branch information. Limitations of `DOSKEY` thus apply here.
For example, typing `cd..` instead of `cd ..` will not cause an update to the git branch information.

Any extra variables introduced will have a `PL_` prefix. You can type `set PL_` to see the list.
