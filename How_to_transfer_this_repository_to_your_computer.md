# How to Transfer This Repository to Your Computer

## Who this is for

This guide is for complete beginners who need to get the repository files onto
their own computer before starting the main DevOps tutorial. You do not need
coding, Git, terminal, or DevOps experience to follow this guide.

The goal is simple: put the project files into one folder on your computer, then
open that folder in Visual Studio Code.

You can open this Markdown file in any text editor or in VS Code. For complete
beginners, it is often easiest to read on the GitHub website in a browser because
GitHub displays the headings, lists, links, images, and command boxes in a clean
format. If you open this `.md` file directly in a text editor or VS Code, you may
see the raw Markdown formatting.

If you are reading this file in VS Code, you may see lines such as
````text
```sh
cd Documents
```
````

Those backtick lines are Markdown formatting. They create a command box when the
file is previewed. Do not type the backticks or the word `sh`. Type only the
command inside the box, such as `cd Documents`.

## What you will do

In plain English, you will:

1. Open a terminal.
2. Move to the Documents folder.
3. Create a folder called `devops_portfolio`.
4. Move into that folder.
5. Install or check Git.
6. Copy or place the repository files there.
7. Open the folder in VS Code.
8. Confirm the expected folders and files are visible.

## Before you start

You need:

- A computer running macOS or Windows.
- The repository files, either from a ZIP download, GitHub, or a folder provided
  by someone else.
- VS Code installed, if you want to follow the tutorial visually.

This guide does not assume you know Git yet. If you use the ZIP option, Git is
not needed to copy the files. However, Git is used later in the main tutorial, so
this guide includes a simple install/check step.

## Step 1: Open a terminal

A terminal is the text-based place where you run commands. On macOS, the terminal
app is usually called Terminal. On Windows, the beginner-friendly terminal is
usually PowerShell.

### macOS

1. Press `Command + Space`.
2. Type `Terminal`.
3. Press `Enter`.

![Example macOS Terminal window](docs/screenshots/macos-terminal-basics.svg)

### Windows

1. Open the Start menu.
2. Type `PowerShell`.
3. Press `Enter`.

![Example Windows PowerShell window](docs/screenshots/windows-powershell-basics.svg)

## Step 2: Go to your Documents folder

Run this command:

```sh
cd Documents
```

`cd` means "change directory." A directory is a folder. This command moves your
terminal into the Documents folder, where you will create the project folder.

If that command fails, try one of these:

- macOS:

  ```sh
  cd ~/Documents
  ```

- Windows PowerShell:

  ```powershell
  cd $HOME\Documents
  ```

## Step 3: Create the project folder

Run this command:

```sh
mkdir devops_portfolio
```

`mkdir` means "make directory," which means "create a folder." This creates a
folder named `devops_portfolio` inside your Documents folder.

## Step 4: Move into the project folder

Run this command:

```sh
cd devops_portfolio
```

Your terminal is now inside the `devops_portfolio` folder. The files you copy or
download next should go into this folder.

## Step 5: Install or check Git

Git is a version control tool. It saves snapshots of project files, including
documents, configuration files, scripts, and application files. You do not need
to understand Git deeply yet. For now, just install it and confirm your terminal
can find it.

### Windows

Beginner path:

1. Go to [git-scm.com/install/windows](https://git-scm.com/install/windows).
2. Download Git for Windows.
3. Run the installer.
4. Accept the default choices.
5. Close and reopen PowerShell.

If you are using `winget`, you can install Git from PowerShell with:

```powershell
winget install --id Git.Git -e
```

### macOS

On macOS, open Terminal and run:

```sh
xcode-select --install
```

This installs Apple's command line tools, including Git. If macOS says the tools
are already installed, that is fine.

### Check that Git works

Run:

```sh
git --version
```

You should see something like:

```text
git version 2.40.0
```

The exact version number does not need to match. If your terminal prints a Git
version, Git is installed.

## Step 6: Put the repository files into this folder

Use one of the options below.

### Option A: If you downloaded a ZIP file

1. Download the repository ZIP file.
2. Unzip it.
3. Open the unzipped folder.
4. Select all files and folders inside it.
5. Copy them into the `devops_portfolio` folder you created.

Do not accidentally create a nested folder like this:

```text
Documents/devops_portfolio/devops-portfolio-main/app
```

The goal is for the main project folders to be directly inside
`devops_portfolio`, like this:

```text
Documents/devops_portfolio/app
Documents/devops_portfolio/docker
Documents/devops_portfolio/docs
```

### Option B: If you are using Git

This is optional. Use this path only if Git is already installed and you have the
repository URL.

```sh
git clone <repository-url> .
```

What this means:

- `git clone` downloads the repository.
- `<repository-url>` should be replaced with the real GitHub URL.
- The final `.` means "put the files into the current folder."

Example shape:

```sh
git clone https://github.com/YOUR_USER/YOUR_REPOSITORY.git .
```

Do not make Git your default transfer path if you are not ready for it yet. The
ZIP option is fine for beginners.

## Step 7: Check that the files are there

On macOS or Linux-style terminals, run:

```sh
ls
```

On Windows PowerShell, you can also run:

```powershell
dir
```

You should see folders and files such as:

```text
app
docker
docs
infrastructure
monitoring
.github
README.md
docs/tutorial.html
```

Exact folder names may vary depending on the repository version. The important
thing is that folders like `app`, `docker`, and `docs` are directly inside
`devops_portfolio`.

## Step 8: Open the folder in VS Code

Run this command from inside the `devops_portfolio` folder:

```sh
code .
```

What this means:

- `code` opens Visual Studio Code.
- `.` means "this current folder."

If `code .` does not work, use the manual fallback:

1. Open VS Code.
2. Click File -> Open Folder.
3. Choose `Documents/devops_portfolio`.

![VS Code showing the project folder](docs/screenshots/vscode-project-explorer.png)

In VS Code, open the entire project folder, not just one file. The Explorer
sidebar should show folders such as `app`, `docker`, `docs`, and `.github`.

## Step 9: Confirm you are ready for the main tutorial

Use this checklist:

- [ ] I can open Terminal or PowerShell.
- [ ] I created the `devops_portfolio` folder.
- [ ] I installed Git or confirmed `git --version` works.
- [ ] I placed the repository files inside that folder.
- [ ] I can see folders like `app`, `docker`, and `docs`.
- [ ] I opened the project folder in VS Code.
- [ ] I am ready to continue with the main tutorial.

## Common beginner mistakes

- Creating the project folder in the wrong location.
- Copying the outer ZIP folder instead of the files inside it.
- Ending up with a nested folder like
  `Documents/devops_portfolio/devops-portfolio-main/app`.
- Running commands from the wrong folder.
- Copying the terminal prompt symbol, such as `$`, `%`, or
  `PS C:\Users\...>`.
- Opening one file in VS Code instead of the whole project folder.

## Quick mental model

Your final setup should look like this:

```text
Documents/
  devops_portfolio/
    app/
    docker/
    docs/
    infrastructure/
    monitoring/
    README.md
```

When you open `devops_portfolio` in VS Code, you are ready to start the main
tutorial.
