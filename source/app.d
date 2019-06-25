module app;

import std.stdio;
import std.file;
import std.array;
import std.string;
import std.range;
import std.conv;
import std.random;
import std.datetime;
import std.algorithm;
import std.path;
import std.process : environment;

import jdtalk.core;


int main(string[] args)
{
    import std.getopt;
    long i = 0,
         limit = 0;
    bool exactMatch = false;
    string pattern = null;
    string dataRoot = absolutePath(getcwd());

    if (environment.get("JDTALK_DATA", null)) {
        dataRoot = environment["JDTALK_DATA"].absolutePath;
    }

    auto opt = getopt(
        args,
        "limit|c", format("(default: %d)", limit), &limit,
        "pattern|p", "Limit output to a root word", &pattern,
        "exact|e", format("Exact matches only (default: %s)", exactMatch ? "true" : "false"), &exactMatch,
        "dataroot|d", "Path to dictionaries", &dataRoot,
    );

    if (opt.helpWanted) {
        defaultGetoptPrinter("jdtalk",
                opt.options);
        return 0;
    }

    if (exactMatch && pattern is null) {
        stderr.writeln("Argument -e requires -p");
        return 1;
    }

    dict_t dict = getData(dataRoot);

    if (pattern !is null && !searchDict(dict, pattern)) {
        stderr.writefln("Word not available in dictionary: %s", pattern);
        return 1;
    }

    while(true) {
        string output = talk(dict);

        if (pattern !is null) {
            if (exactMatch && !hasWord(pattern, output)) {
                continue;
            }
            else if (!exactMatch && !output.canFind(pattern)) {
                continue;
            }
        }

        writeln(output);

        if (limit > 0) {
            i++;
            if (i == limit)
                break;
        }
    }

    return 0;
}
