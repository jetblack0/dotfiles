-- System
---------
-- Highlight a selection on yank
vim.cmd[[au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false, timeout=250}]]

-- Disables automatic commenting on newline:
vim.cmd[[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]]

-- Save and load view automatically
vim.cmd[[
augroup remember_folds
	autocmd!
	autocmd BufWinLeave *.* mkview
	autocmd BufWinEnter *.* silent! loadview
augroup END]]


-- System-specific
------------------
-- Change fcitx5 input to english when press escape.
-- vim.cmd[[let fcitx5state=system("fcitx5-remote")]]
-- vim.cmd[[autocmd InsertLeave * :silent let fcitx5state=system("fcitx5-remote")[0] | silent !fcitx5-remote -c]]
-- vim.cmd[[autocmd InsertEnter * :silent if fcitx5state == 2 | call system("fcitx5-remote -o") | endif]]


-- Programming languages
------------------------
-- Change filetypes for template language.
-- Ansible
vim.cmd[[au BufRead,BufNewFile */playbooks/*.yml setlocal ft=yaml.ansible]]
vim.cmd[[au BufRead,BufNewFile */playbooks/*.yaml setlocal ft=yaml.ansible]]
vim.cmd[[au BufRead,BufNewFile */roles/*/tasks/*.yml setlocal ft=yaml.ansible]]
vim.cmd[[au BufRead,BufNewFile */roles/*/tasks/*.yaml setlocal ft=yaml.ansible]]
vim.cmd[[au BufRead,BufNewFile */roles/*/handlers/*.yml setlocal ft=yaml.ansible]]
vim.cmd[[au BufRead,BufNewFile */roles/*/handlers/*.yaml setlocal ft=yaml.ansible]]
vim.cmd[[au BufRead,BufNewFile *.j2 setlocal ft=jinja]]
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.yml,*.yaml",
  callback = function(args)
    local fname = args.file
    local dir = vim.fn.fnamemodify(fname, ":p:h")
    while dir ~= "/" do
      if vim.fn.filereadable(dir .. "/ansible.cfg") == 1 then
        vim.bo[args.buf].filetype = "yaml.ansible"
        return
      end
      dir = vim.fn.fnamemodify(dir, ":h")
    end
  end,
})

-- Terraform
vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[au BufRead,BufNewFile *.hcl setlocal filetype=hcl]])
vim.cmd([[au BufRead,BufNewFile .terraformrc,terraform.rc setlocal filetype=hcl]])
vim.cmd([[au BufRead,BufNewFile *.tf,*.tfvars setlocal filetype=terraform]])
vim.cmd([[au BufRead,BufNewFile *.tfstate,*.tfstate.backup setlocal filetype=json]])

-- Jenkins
vim.cmd([[au BufRead,BufNewFile *Jenkinsfile*,*jenkinsfile* setlocal filetype=groovy]])

-- Docker and Docker compose
vim.cmd([[au BufRead,BufNewFile compose.yaml,compose.yml,docker-compose.yaml,docker-compose.yml setlocal filetype=yaml.docker-compose]])
vim.cmd([[au BufRead,BufNewFile Dockerfile setlocal filetype=dockerfile]])

-- go template
vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
  },
  pattern = {
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
  },
})


-- Change indentation width based on their file types.
vim.cmd[[autocmd FileType sh,html,htmldjango,text,yuck,json,javascript,javascriptreact,lua,xml,ruby,jinja,yaml.ansible setlocal expandtab shiftwidth=2 tabstop=2]]
vim.cmd[[autocmd FileType markdown,java setlocal expandtab shiftwidth=4 tabstop=4]]


-- Treat ejs as html
vim.cmd[[au BufNewFile,BufRead *.ejs set filetype=html]]

-- Seems neovim doesn't automatically recognize different asm syntax
-- vim.cmd[[au BufNewFile,BufRead *.asm set filetype=nasm]]
