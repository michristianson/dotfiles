# Dotfiles for zsh, tmux, neovim, and LaTeX

These are the dotfiles I use for my standard workflow, which involves
editing LaTeX files in neovim using zsh + tmux. I've been using these
dotfiles for years, but I recently decided to work on using them more
effectively. In doing this, I've come up with three main principles that I
think make for good dotfiles.

1. Intentionality: everything in my dotfiles should be something that I both
   understand and intend to use.
2. Completeness: ideally, I should be able to deploy this repo on any machine
   and then have everything set up just the way I like it. This means that my
   dotfiles should cover all settings that I care about (including sometimes
   confirming default settings just in case), and they should be as portable
   and broad in scope as possible.
3. Documentation: dotfiles are easy enough to understand, but when I look at
   them 6 months or 6 years from now, I will probably forget what the settings 
   mean, how different settings work together, why I started using this or
   that workaround, etc. Everything I'm doing or thinking about doing should
   be documented so I can easily come back to it later.

At this point, I think my dotfiles meet these criteria pretty well.
I've combed through all of them and removed everything I didn't understand or
didn't want. I've also left extensive comments, and I've put some files
containing thoughts/future ideas in the doc folder of this repo. In the future,
I'd like to take completeness even further by

1. adding more dotfiles (for things like my windows manager), and
2. writing a shell script to automate installation/setup of everything in
   this repo.

If you're reading this and you're not me, welcome! I mainly just did all this
for my own personal satisfaction, but I'd be delighted if it helped out a
fellow human as well, so feel free to look around :)
