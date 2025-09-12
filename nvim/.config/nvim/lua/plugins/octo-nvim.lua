return {
  {
    'pwntester/octo.nvim',
    cmd = {'Octo'},
    config = function()
      require"octo".setup({
        -- Add here additional configuration, if needed
        default_remote = {"upstream", "origin"}; -- order to try remotes
        reaction_viewer_hint_icon = "";         -- marker for user reactions
        user_icon = " ";                         -- user icon
        timeline_marker = "";                   -- timeline marker
        right_bubble_delimiter = "";            -- bubble delimiter for the right
        left_bubble_delimiter = "";             -- bubble delimiter for the left
        github_hostname = "";	                   -- GitHub Enterprise Hostname
        snippet_context_lines = 4;               -- number or lines around commented lines
        gh_env = {},                             -- extra environment variables to pass
        timeout = 5000,                          -- timeout for requests
      })

    end,
  },
}
