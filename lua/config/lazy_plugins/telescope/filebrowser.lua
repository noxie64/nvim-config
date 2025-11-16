local fb_actions = require "telescope".extensions.file_browser.actions

return {
  mappings = {
    ["n"] = {
      ["<A-m>"] = fb_actions.move,
      ["<A-r>"] = fb_actions.rename,
      ["<A-c>"] = fb_actions.copy,
    },
  },
}
