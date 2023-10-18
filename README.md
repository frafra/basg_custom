Here are some bash scripts that you can reuse and modify as you wish.

I added these lines to `.bashrc`:

```bash
if [ -d "$HOME/bash_custom" ]
then
    for file in "$HOME/bash_custom"/*.sh
    do
        . "$file"
    done
fi
```
