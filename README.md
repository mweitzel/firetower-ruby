# firetower ruby

Run and re-run a ruby script without restarting the process. Plays well with [firetower](https://github.com/mweitzel/firetower) and [firetower editor hooks](https://github.com/mweitzel/firetower#editor-hooks).

Especially useful when the REPL isn't enough, but the config or initialization overhead is high.

## Instalation

Clone the repository, add a symlink you'll remember.

```bash
git clone https://github.com/mweitzel/firetower-ruby ~/projects/firetower-ruby
ln -s ~/projects/firetower-ruby/firetower.rb ~/bin/firetower.rb
```

## Usage

Preface your script with the path to `firetower.rb`

```bash
ruby ~/bin/firetower.rb my-script.rb
```

Re-load the script with `^R` (control-r), or with [firetower editor hooks](https://github.com/mweitzel/firetower#editor-hooks)

Exit with `^C` (control-c)

### Example Usage in Rails

```bash
rails runner ~/bin/firetower.rb my-script.rb
```

_Note that continually reloading a file in Ruby does not clear variables and functions which were previous defined in the file_
