# Python & Machine Learning Neovim IDE

A polished, modular, lightweight Neovim development environment engineered for Python, Machine Learning, Deep Learning, and Mathematical / Scientific Writing. Built on top of NvChad v2.5 with `lazy.nvim`.

---

## Table of Contents
- [1. Overview & Highlights](#1-overview--highlights)
- [2. Configuration Architecture](#2-configuration-architecture)
- [3. Installed Plugins & Ecosystem](#3-installed-plugins--ecosystem)
- [4. Dependencies & Prerequisites](#4-dependencies--prerequisites)
- [5. Automatic Virtual Environment Detection](#5-automatic-virtual-environment-detection)
- [6. Jupyter Notebook & Interactive ML Workflow](#6-jupyter-notebook--interactive-ml-workflow)
- [7. Debugging (DAP) & Testing (Pytest)](#7-debugging-dap--testing-pytest)
- [8. Markdown & Mathematical Writing](#8-markdown--mathematical-writing)
- [9. Complete Keybinding Reference](#9-complete-keybinding-reference)
- [10. Troubleshooting Guide](#10-troubleshooting-guide)

---

## 1. Overview & Highlights

- **Python LSP**: `Pyright` for deep type inference and code intelligence, dynamically configured to use the project's virtual environment.
- **Ruff Integration**: Fast linting, code formatting on save, and automatic import management (organize imports, remove unused imports).
- **Zero-Config VirtualEnv Detection**: Automatically detects `.venv/`, `venv/`, `env/`, `.env/`, uv, Poetry, and Conda environments upon opening projects or files. Automatically propagates the interpreter to LSP, DAP, and integrated terminals.
- **Dedicated Neovim Python Provider**: An isolated Python environment (`~/.virtualenvs/neovim`) provides `pynvim` and `jupyter_client` without polluting project virtual environments.
- **Native Jupyter Notebooks (`.ipynb`)**: Transparently opens `.ipynb` files as paired script buffers using `jupytext.nvim`. Run notebook cells with `molten-nvim` and `NotebookNavigator.nvim`.
- **Plot & Image Rendering**: Native inline plot and image rendering using `image.nvim` (Ghostty / Kitty graphics protocol support).
- **Interactive REPL**: Rapid code experimentation with `iron.nvim` (sends lines, blocks, or files to IPython/Python).
- **Integrated Debugging**: Full-featured `nvim-dap` with `nvim-dap-ui`, `nvim-dap-virtual-text`, and `nvim-dap-python` using Mason's `debugpy`.
- **Pytest Testing Suite**: `neotest` with `neotest-python` for running individual tests, test files, and test suites with interactive output and DAP debug strategy.
- **Mathematical Notes**: `render-markdown.nvim` with LaTeX formula conversion, styled callouts (`[!NOTE]`, `[!TIP]`, `[!IMPORTANT]`), tables, and checkboxes; paired with `vimtex` for full LaTeX support.
- **Modern UI & Navigation**: TokyoDark theme, `lualine.nvim` statusline displaying the active virtual environment, LSP, and DAP status, `nvim-ufo` code folding with fold count virtual text, and `which-key.nvim` keymap discovery.

---

## 2. Configuration Architecture

```
~/.config/nvim/ (symlinked to ~/.dotfiles/nvim/)
├── init.lua                      # Core bootstrap, leader key, Neovim Python host prog
├── lazy-lock.json                # Plugin lockfile
├── lua/
│   ├── chadrc.lua                # Theme ("tokyodark") & NvChad UI overrides
│   ├── options.lua               # Editor options, folding, auto-commands, venv setup
│   ├── mappings.lua              # Global keybindings & which-key group definitions
│   │
│   ├── configs/                  # Granular configurations
│   │   ├── venv-autodetect.lua   # Automatic virtual environment detection engine
│   │   ├── lspconfig.lua         # LSP server setups (Pyright, Ruff, Clangd, etc.)
│   │   ├── conform.lua           # Formatter rules (Ruff organize + format on save)
│   │   ├── dap.lua               # Debugger UI, signs, virtual text, debugpy
│   │   ├── neotest.lua           # Pytest test runner configuration
│   │   ├── molten.lua            # Molten interactive kernel & window settings
│   │   ├── repl.lua              # Iron.nvim interactive REPL configuration
│   │   ├── lualine.lua           # Statusline with active venv, LSP, DAP badges
│   │   ├── render-markdown.lua   # Markdown tables, callouts, and LaTeX rendering
│   │   ├── ufo.lua               # High-performance code folding with fold counter
│   │   ├── nvim-cmp.lua          # Autocomplete engine configuration
│   │   ├── treesitter.lua        # Treesitter parsers (python, latex, markdown, etc.)
│   │   ├── telescope.lua         # Fuzzy finder settings
│   │   └── terminal.lua          # FTerm floating terminal configuration
│   │
│   ├── plugins/                  # Modular Lazy plugin specifications
│   │   ├── init.lua              # General editor plugins (treesitter, snacks, fterm)
│   │   ├── python.lua            # venv-selector.nvim
│   │   ├── dap.lua               # nvim-dap, dap-ui, dap-python, neotest
│   │   ├── jupyter.lua           # molten-nvim, jupytext.nvim, NotebookNavigator, iron.nvim
│   │   └── ui.lua                # lualine.nvim, render-markdown, nvim-ufo, diffview, vimtex
│   │
│   └── snippets/
│       └── python.lua            # Algorithms + PyTorch / Data Science / ML snippets
```

---

## 3. Installed Plugins & Ecosystem

| Plugin | Purpose |
|:-------|:--------|
| `neovim/nvim-lspconfig` | Language server configuration (Pyright, Ruff, Lua, Clangd, etc.) |
| `williamboman/mason.nvim` | Package manager for language servers, linters, debuggers |
| `stevearc/conform.nvim` | Fast code formatting on save via `ruff_organize_imports` and `ruff_format` |
| `linux-cultist/venv-selector.nvim` | Manual virtual environment selection via Telescope |
| `benlubas/molten-nvim` | Jupyter kernel code evaluation and output display in Neovim |
| `GCBallesteros/jupytext.nvim` | Seamless two-way conversion of `.ipynb` files to Python percent scripts |
| `GCBallesteros/NotebookNavigator.nvim` | Fast notebook cell navigation (`]h`/`[h`) and cell execution |
| `Vigemus/iron.nvim` | Interactive Python/IPython REPL |
| `3rd/image.nvim` | Terminal graphics protocol image/plot rendering |
| `mfussenegger/nvim-dap` | Debug Adapter Protocol core engine |
| `rcarriga/nvim-dap-ui` | Rich debugger UI (breakpoints, scopes, stacks, watches, console) |
| `theHamsta/nvim-dap-virtual-text` | Inline variable evaluation display during debugging |
| `mfussenegger/nvim-dap-python` | Python debugger integration via `debugpy` |
| `nvim-neotest/neotest` | Modern test runner framework |
| `nvim-neotest/neotest-python` | Pytest adapter with DAP debugging support |
| `nvim-lualine/lualine.nvim` | Statusline displaying active virtualenv, git, diagnostics, DAP status |
| `MeanderingProgrammer/render-markdown.nvim` | In-buffer markdown rendering for math LaTeX, tables, callouts |
| `lervag/vimtex` | Full LaTeX document editing and compilation |
| `kevinhwang91/nvim-ufo` | Smooth, high-performance code folding |
| `sindrets/diffview.nvim` | Git visual diff and commit history browser |
| `folke/which-key.nvim` | Interactive keybinding popup helper |

---

## 4. Dependencies & Prerequisites

All required system and global dependencies are managed via package managers:

1. **System & CLI Tools**:
   - `ripgrep` (`rg`), `fd-find` (`fd`), `git`, `gcc`, `clang`, `fzf`
2. **Global Python Tools** (managed via `pipx` or `uv`):
   - `uv` (`~/.local/bin/uv`): Ultra-fast virtualenv manager
   - `jupytext` (`~/.local/bin/jupytext`): Notebook text synchronization
3. **Neovim Python Provider** (isolated):
   - Located at `~/.virtualenvs/neovim/bin/python3`
   - Contains: `pynvim`, `jupyter_client`, `cairosvg`, `plotly`, `kaleido`, `pnglatex`, `pyperclip`
4. **Mason Packages** (managed inside Neovim):
   - `pyright`: Python type checker & LSP
   - `ruff`: Python linter and formatter
   - `debugpy`: Python DAP debugger

---

## 5. Automatic Virtual Environment Detection

### How It Works
The custom autodetector (`lua/configs/venv-autodetect.lua`) operates autonomously:
1. **Detection Hierarchy**:
   - Checks project cache (`~/.local/share/nvim/venv_cache.json`) for previously selected environments.
   - Searches current buffer directory and walks up parent directories (up to git root) looking for `.venv/bin/python`, `venv/bin/python`, `env/bin/python`, `.env/bin/python`.
   - Detects Poetry environments (`poetry env info -p`) when `pyproject.toml` is present.
   - Recognizes active Conda environments (`$CONDA_PREFIX`).
2. **Environment Synchronization**:
   - **Environment Variables**: Sets `vim.env.VIRTUAL_ENV` and prepends the virtualenv's `bin/` directory to `vim.env.PATH`.
   - **Terminals**: Integrated terminals (`FTerm`, `:terminal`) automatically inherit this `PATH`, executing commands with the project's Python.
   - **Pyright**: Dynamic `before_init` hook configures `settings.python.pythonPath` to point directly to the project's Python binary.
   - **Debugger (DAP)**: `dap-python.resolve_python` updates to use the project's interpreter.
   - **Testing (Neotest)**: Uses the active virtual environment's Python to discover and run `pytest`.
   - **Statusline**: Displays the project name and virtualenv directory in green (e.g., `󰌠 my_project (.venv)`).
3. **Project Switching**:
   - Listening to `DirChanged` and `BufEnter` events, Neovim automatically switches environments when switching between project buffers.

### Manual Selection Fallback
- Press `<leader>vs` to open the Telescope virtual environment picker.
- Press `<leader>vc` to pick from previously cached virtual environments.
- Press `<leader>va` to trigger auto-detection manually.
- Press `<leader>vi` to view complete diagnostic information about the active interpreter, LSP clients, and provider.

---

## 6. Jupyter Notebook & Interactive ML Workflow

### Working with `.ipynb` Notebooks
1. **Open Any Notebook**: `nvim notebook.ipynb`. `jupytext.nvim` automatically presents it as a Python file formatted with `# %%` cell markers.
2. **Initialize Kernel**: Press `<leader>mi` to launch `:MoltenInit` and select the kernel for your project environment.
3. **Navigate Cells**: Use `]h` to jump to the next cell and `[h` to jump to the previous cell.
4. **Execute Cells**:
   - `<leader>jr` or `<leader>mr`: Execute current cell.
   - `<leader>ja`: Execute current cell and advance to the next cell.
   - `<leader>ml`: Execute current line.
   - Visual mode `<leader>mv`: Execute selected lines.
5. **View Outputs & Plots**:
   - Output appears as virtual text or in a floating window.
   - Press `<leader>mo` to inspect the floating output window (scrollable).
   - Press `<leader>mh` to hide the output float.
   - In Ghostty or Kitty terminals, Matplotlib and Seaborn plots render directly inline.
6. **Save**: Simply save the file with `:w`. Jupytext automatically syncs all code changes back to the `.ipynb` file on disk.

### Interactive REPL (`iron.nvim`)
For rapid script development without Jupyter kernels:
- Press `<leader>rr` to toggle the Python / IPython REPL split.
- Press `<leader>rf` to send the entire file to the REPL.
- Press `<leader>rl` to send the current line.
- Select code in visual mode and press `<leader>rs` to send the selection.
- Press `<leader>rc` to clear the REPL screen; `<leader>rq` to exit the REPL.

---

## 7. Debugging (DAP) & Testing (Pytest)

### Debugging with `nvim-dap`
1. Set a breakpoint on the current line with `<leader>db` (or `<leader>dB` for a conditional breakpoint).
2. Start debugging with `<F5>` or `<leader>dc`.
3. The debugger automatically launches `debugpy` inside your project's virtual environment and opens the `dap-ui` split containing scopes, call stack, breakpoints, and watches.
4. Step through code:
   - `<F10>` or `<leader>do`: Step over
   - `<F11>` or `<leader>di`: Step into
   - `<F12>` or `<leader>dO`: Step out
5. Inline values are displayed via `nvim-dap-virtual-text`.
6. Press `<leader>du` to toggle the DAP UI, or `<leader>dt` to terminate debugging.

### Testing with `neotest`
- `<leader>tn`: Run the nearest test function under the cursor.
- `<leader>tf`: Run all tests in the current file.
- `<leader>ts`: Run the entire test suite.
- `<leader>to`: Open the floating test output panel.
- `<leader>tS`: Toggle the test suite summary tree.
- `<leader>td`: Run the nearest test with the DAP debugger attached.

---

## 8. Markdown & Mathematical Writing

- **`render-markdown.nvim`**: Renders formatted headings, pipe tables, callout blocks (`[!NOTE]`, `[!TIP]`, `[!WARNING]`, `[!IMPORTANT]`), checkboxes, and LaTeX mathematics inline.
- **LaTeX Math Support**: Mathematical equations formatted as `$ ... $` or `$$ ... $$` are rendered cleanly with LaTeX character mapping.
- **Browser Preview**: Press `<leader>mp` to toggle `markdown-preview.nvim` in your browser.
- **LaTeX Editing (`vimtex`)**: Full LaTeX syntax support for writing ML research papers (`.tex` files).

---

## 9. Complete Keybinding Reference

### Virtual Environment (`<leader>v`)
| Keymap | Command / Action | Description |
|:-------|:-----------------|:------------|
| `<leader>vs` | `:VenvSelect` | Open Telescope picker to select a virtual environment |
| `<leader>vc` | `:VenvSelectCached` | Pick from previously cached environments |
| `<leader>va` | `:VenvAutoDetect` | Force re-run auto-detection for current project |
| `<leader>vi` | `:VenvInfo` | Display Python environment & LSP info popup |

### Python Execution (`<leader>p`)
| Keymap | Action | Description |
|:-------|:-------|:------------|
| `<leader>pr` | Run file | Run current Python file in floating terminal using project venv |
| `<leader>pi` | Interactive term | Open interactive IPython / Python session in floating terminal |

### Jupyter & Molten (`<leader>m`, `<leader>j`)
| Keymap | Action | Description |
|:-------|:-------|:------------|
| `<leader>mi` | `:MoltenInit` | Initialize Molten kernel for current buffer |
| `<leader>mr` | `:MoltenReevaluateCell` | Re-evaluate current notebook cell |
| `<leader>ml` | `:MoltenEvaluateLine` | Evaluate current line |
| `v` `<leader>mv` | `:MoltenEvaluateVisual` | Evaluate selected code |
| `<leader>mo` | `:MoltenShowOutput` | Open floating output window |
| `<leader>mh` | `:MoltenHideOutput` | Hide floating output window |
| `<leader>md` | `:MoltenDelete` | Delete current cell output |
| `<leader>mx` | `:MoltenInterrupt` | Interrupt active kernel |
| `<leader>mR` | `:MoltenRestart` | Restart active kernel |
| `]h` | `move_cell("d")` | Move cursor to next notebook cell |
| `[h` | `move_cell("u")` | Move cursor to previous notebook cell |
| `<leader>jr` | `run_cell()` | Run current cell (NotebookNavigator) |
| `<leader>ja` | `run_and_move()` | Run current cell and move to next cell |

### Interactive REPL (`<leader>r`)
| Keymap | Action | Description |
|:-------|:-------|:------------|
| `<leader>rr` | Toggle REPL | Open or hide vertical Python/IPython REPL split |
| `<leader>rf` | Send file | Send entire current buffer to REPL |
| `<leader>rl` | Send line | Send current line to REPL |
| `v` `<leader>rs` | Send visual | Send highlighted code to REPL |
| `<leader>rp` | Send paragraph | Send current paragraph to REPL |
| `<leader>rc` | Clear REPL | Clear REPL terminal buffer |
| `<leader>rq` | Close REPL | Exit and close REPL process |

### Debugging (`<leader>d`)
| Keymap | Action | Description |
|:-------|:-------|:------------|
| `<leader>db` | `toggle_breakpoint` | Toggle breakpoint on current line |
| `<leader>dB` | `set_breakpoint` | Add conditional breakpoint (prompt for condition) |
| `<leader>dc` / `<F5>` | `continue` | Start or continue execution |
| `<leader>do` / `<F10>` | `step_over` | Step over function call |
| `<leader>di` / `<F11>` | `step_into` | Step into function |
| `<leader>dO` / `<F12>` | `step_out` | Step out of function |
| `<leader>du` | `dapui.toggle` | Toggle debugger UI panels |
| `<leader>dr` | `dap.repl.open` | Open debugger interactive REPL |
| `<leader>dt` | `dap.terminate` | Terminate active debugging session |

### Testing (`<leader>t`)
| Keymap | Action | Description |
|:-------|:-------|:------------|
| `<leader>tn` | Run nearest | Run nearest pytest test case |
| `<leader>tf` | Run file | Run all tests in the current file |
| `<leader>ts` | Run suite | Run complete test suite across project |
| `<leader>to` | Test output | Open floating test output log |
| `<leader>tS` | Test summary | Toggle test summary sidebar |
| `<leader>td` | Debug test | Run test under cursor using DAP debugger |

### LSP & Code Intelligence
| Keymap | Action | Description |
|:-------|:-------|:------------|
| `gd` / `df` | `buf.definition` | Go to definition |
| `gD` / `dc` | `buf.declaration` | Go to declaration |
| `gi` / `im` | `buf.implementation` | Go to implementation |
| `gr` | `buf.references` | Find all references |
| `K` / `do` | Hover doc | Sticky hover documentation popup |
| `<leader>ra` | `buf.rename` | Rename symbol across workspace |
| `<leader>ca` | `buf.code_action` | Trigger code actions (e.g. fix issue, organize imports) |
| `<leader>fm` | `conform.format` | Format buffer manually (Ruff format + organize imports) |
| `[d` / `]d` | Diagnostic nav | Jump to previous / next diagnostic |
| `<leader>dg` | `diagnostic.open_float` | Show floating diagnostic details |

### Code Folding & UI
| Keymap | Action | Description |
|:-------|:-------|:------------|
| `zR` | `openAllFolds` | Unfold all code blocks |
| `zM` | `closeAllFolds` | Fold all code blocks |
| `<leader>mp` | Markdown Preview | Toggle browser live markdown preview |
| `<leader>gdo` | Diffview Open | Open full Git diffview |
| `<leader>gdc` | Diffview Close | Close Git diffview |
| `<leader>gdh` | File History | View Git history of current file |

---

## 10. Troubleshooting Guide

### 1. `jupyter_client` or `pynvim` not found by Molten
- The dedicated Neovim Python environment is configured at `~/.virtualenvs/neovim`.
- Verify with `:checkhealth provider`. The Python 3 provider should report OK with `~/.virtualenvs/neovim/bin/python3`.
- If packages are missing, re-run:
  ```bash
  uv pip install pynvim jupyter_client cairosvg plotly kaleido pnglatex pyperclip -p ~/.virtualenvs/neovim/bin/python
  ```
- Re-register remote plugins inside Neovim:
  ```vim
  :UpdateRemotePlugins
  ```

### 2. Pyright not seeing installed project packages
- Check the active environment with `<leader>vi` (`:VenvInfo`).
- If you just created a virtual environment, force auto-detection with `<leader>va` or select it manually with `<leader>vs`.
- Restart Pyright if needed: `:LspRestart pyright`.

### 3. Notebooks (`.ipynb`) not opening as Python files
- Ensure `jupytext` CLI is installed and in your `$PATH`:
  ```bash
  which jupytext
  ```
  If missing, install via `pipx install jupytext` or `uv tool install jupytext`.

### 4. Plot images not displaying in terminal
- Image display requires a terminal supporting the Kitty graphics protocol (e.g., Ghostty, Kitty, or WezTerm).
- In tmux, ensure `allow-passthrough on` is enabled in `~/.tmux.conf`.
