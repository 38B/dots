{ lib, config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = ''
      local opt = vim.opt

      opt.expandtab = true
      opt.shiftwidth = 2
      opt.smartindent = true
      opt.tabstop = 2
      opt.softtabstop = 2

      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not vim.loop.fs_stat(lazypath) then
          vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
          })
        end
      vim.opt.rtp:prepend(lazypath)

      require("lazy").setup({
        { "folke/which-key.nvim", 
           config = function()
             vim.o.timeout = true
             vim.o.timeoutlen = 300
             require("which-key").setup({
               -- your configuration comes here
               -- or leave it empty to use the default settings
               -- refer to the configuration section below
             })
           end,
        },
        { "akinsho/toggleterm.nvim",
          version = "*",
          config = function()
            require("toggleterm").setup({
              open_mapping = [[<c-\>]],
            })
          end,
        },
        { "nvim-neo-tree/neo-tree.nvim",
          branch = "v2.x",
          requires = { 
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
          },
          config = function()
            vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
            require("neo-tree").setup({
              close_if_last_window = false,
              vim.api.nvim_set_keymap( "n", "<leader>n", "<cmd> NeoTreeFocusToggle <CR>", {}),
              vim.api.nvim_set_keymap( "n", "<leader>e", "<cmd> NeoTreeFocus <CR>", {}),
              filesystem = {
                hijack_netrw_behavior = "open_current",
              },
            })
          end,
	      },
        { "jackMort/ChatGPT.nvim",
           event = "VeryLazy",
           config = function()
             require("chatgpt").setup({
               api_key_cmd = "cat /persist/keystore/chatgpt/apikey",
               yank_register = "+",
               edit_with_instructions = {
                 diff = false,
                 keymaps = {
                   accept = "<C-y>",
                   toggle_diff = "<C-d>",
                   toggle_settings = "<C-o>",
                   cycle_windows = "<Tab>",
                   use_output_as_input = "<C-i>",
                 },
               },
               chat = {
                 welcome_message = WELCOME_MESSAGE,
                 loading_text = "Loading, please wait ...",
                 question_sign = "", -- 🙂
                 answer_sign = "ﮧ", -- 🤖
                 max_line_length = 120,
                 sessions_window = {
                   border = {
                     style = "rounded",
                     text = {
                       top = " Sessions ",
                     },
                   },
                   win_options = {
                     winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                   },
                 },
                 keymaps = {
                   close = { "<C-c>" },
                   yank_last = "<C-y>",
                   yank_last_code = "<C-k>",
                   scroll_up = "<C-u>",
                   scroll_down = "<C-d>",
                   toggle_settings = "<C-o>",
                   new_session = "<C-s>",
                   cycle_windows = "<Tab>",
                   select_session = "<Space>",
                   rename_session = "r",
                   delete_session = "d",
                 },
               },
               popup_layout = {
                 relative = "editor",
                 position = "50%",
                 size = {
                   height = "80%",
                   width = "80%",
                 },
               },
               popup_window = {
                 filetype = "chatgpt",
                 border = {
                   highlight = "FloatBorder",
                   style = "rounded",
                   text = {
                     top = " ChatGPT ",
                   },
                 },
                 win_options = {
                   winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                 },
               },
               popup_input = {
                 prompt = "  ",
                 border = {
                   highlight = "FloatBorder",
                   style = "rounded",
                   text = {
                     top_align = "center",
                     top = " Prompt ",
                   },
                 },
                 win_options = {
                   winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                 },
                 submit = "<C-m>",
               },
               settings_window = {
                 border = {
                   style = "rounded",
                   text = {
                     top = " Settings ",
                   },
                 },
                 win_options = {
                   winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                 },
               },
               openai_params = {
                 model = "gpt-3.5-turbo",
                 frequency_penalty = 0,
                 presence_penalty = 0,
                 max_tokens = 300,
                 temperature = 0,
                 top_p = 1,
                 n = 1,
               },
               openai_edit_params = {
                 model = "code-davinci-edit-001",
                 temperature = 0,
                 top_p = 1,
                 n = 1,
               },
               actions_paths = {},
               predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
             })
           end,
           dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
           },
        },
        { "nvim-telescope/telescope.nvim",
          tag = "0.1.1",
          dependencies = { "nvim-lua/plenary.nvim" }
        },
      })
    '';
    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      lazy-nvim
      toggleterm-nvim
      which-key-nvim
      neo-tree-nvim
      nvim-web-devicons
      nui-nvim
      ChatGPT-nvim
    ];
  };
}
