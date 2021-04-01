# jdtalk

A silly fortune cookie generator...

## How silly?

```
unlawful meat justifiably skids
chicken-hearted sausage characteristically ad-libs
biomedical beef essentially wiggling
gristlier baloney gruesomely desire
to-and-fro felines lumpishly aromatise
moated waffle suspensively tent
```

## Compiling

`jdtalk` requires a `D` compiler and `dub`.

```bash
$ dub build -b release
```

## Running

```bash
$ export JDTALK_DATA=$HOME/path/to/data/dir
$ ./jdtalk
```

## Usage

```bash
-f   --format Produce words with formatted string
-c    --limit (default: 0)
-p  --pattern Limit output to a root word
-e    --exact Exact matches only (default: false)
-s    --salad Produce N random words
      --rcase Randomize case (default: false)
      --hcase Change every other case (default: false)
       --leet 1337ify output (default: false)
-d --dataroot Path to dictionaries
-h     --help This help information.
```

# Formatters

For use with `--format`

* `%a` - Adjective
* `%d` - Adverb
* `%n` - Noun
* `%v` - Verb

## Example

```bash
$ jdtalk --fmt "%a%a%n%d%v"
hexadecimal satiric reconnoitrer ultimately beef
[...]
```

This is not a print function, however. `--format "Are you a nice %a %n? Go %v in the mirror."` will produce `hairy mouse runs`, not `Are you a nice hairy mouse? Go run in the mirror."`.
