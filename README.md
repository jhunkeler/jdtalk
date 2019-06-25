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
-c    --limit (default: 0)
-p  --pattern Limit output to a root word
-e    --exact Exact matches only (default: false)
-d --dataroot Path to dictionaries
-h     --help This help information.
```

