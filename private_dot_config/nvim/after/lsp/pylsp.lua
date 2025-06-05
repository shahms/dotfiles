return {
  settings = {
    pylsp = {
      plugins = {
        ruff = {
          enabled = true,
          formatEnabled = true,
          -- From ci/file_validators/ruff_validator.py
          extendIgnore = {
            "D413",    -- Missing blank line after last section
            "E501",    -- Line length. Use black.
            "E203",    -- Whitespace before ':'
            "PLC0206", -- Extracting value from dictionary without calling `.items()
          },

          select = {
            "F",   -- pyflakes - check for errors
            "E",   -- pycodestyle - style errors
            "W",   -- pycodestyle - style warnings
            "ANN", -- Require annotations
          },
        },
        black = {
          enabled = true,
        },
        pylsp_mypy = {
          enabled = false, -- Use pyright for type checking.
          overrides = { "--disallow-untyped-defs", true },
        },
      }
    }
  }
}
