## About Aliases  
aliases are a way to create shortcuts for a given command. While their scope is limited they are useful for saving time on tedious typing. For example, using the bash command `less` there is the useful flag `-S` that prevents text from wrapping on the display. This is quite useful for readability but it can be tedious to write `less -S` every time. Instead what you can do is use `alias` to create a shortcut for that specific command.
```
alias less='less -S'
```
Now whenever you ype `less` it instead performs `less -S` by default. However this alias will go away once you leave the session. If you want the alias to be permanent then we will need to work with two hidden files

## Making a permanent alias
first lets create a hidden file that will contain all the aliases you want. hidden files follow the syntax `.file_name`. To create a hidden file do 
```
mkdir .bash_aliases
chmod a+x .bash_aliases #make it executable
```
If you want to find this file again you use `ls -a` to find hidden files. Now we can fill this file with all the aliases we think will be useful. And this is not limited to just aliases. Useful functions can also be placed within the file. I've attached an example file here containing all the aliases and functions I use.

Next, your home directory should contain a hidden file called `.bashrc`. This file is actually executed every time you start up a session on the lab machine. Open it with `nano .bashrc` and take a look at it. You may notice that this already contains several aliases you may already use. Chances are you may find a snippet of code that says the following:
```
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```
If not found then you can simply add this snippet to this file. This will execute the bash aliases file at startup every time. These aliases will not take effect until you log back in for the first time, so log out and log in if you want to use them immediately

## Undoing Aliases
to undo an alias in the long term you can simply delete it from the bash_aliases file. However this will not remove the alias until you restart your session. To remove an alias immediately use `unalias`

That's all, have fun with aliases!
