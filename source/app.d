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
    long i = 0;
    long limit = 0;
    int salad = 0;
    bool exactMatch = false;
    bool rCase = false;
    bool hCase = false;
    bool haxor = false;
    string custom_format = null;
    string pattern = null;
    string dataRoot = absolutePath(getcwd());

    if (environment.get("JDTALK_DATA", null)) {
        dataRoot = environment["JDTALK_DATA"].absolutePath;
    }

    auto opt = getopt(
        args,
        "format|f", "Produce words with formatted string", &custom_format,
        "limit|c", format("(default: %d)", limit), &limit,
        "pattern|p", "Limit output to a root word", &pattern,
        "exact|e", format("Exact matches only (default: %s)", exactMatch ? "true" : "false"), &exactMatch,
        "salad|s", "Produce N random words", &salad,
        "rcase", format("Randomize case (default: %s)", rCase ? "true" : "false"), &rCase,
        "hcase", format("Change every other case (default: %s)", hCase ? "true" : "false"), &hCase,
        "leet", format("1337ify output (default: %s)", haxor ? "true" : "false"), &haxor,
        "dataroot|d", "Path to dictionaries", &dataRoot,
    );

    if (opt.helpWanted) {
        defaultGetoptPrinter("jdtalk", opt.options);
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
        string output;

        if (salad) {
            output = talkSalad(dict, salad);
        }
        else if (custom_format) {
            output = talkf(dict, custom_format);
        }
        else {
            output = talkf(dict, "%a %n %d %v");
        }

        if (pattern !is null) {
            if (exactMatch && !hasWord(pattern, output)) {
                continue;
            }
            else if (!exactMatch && !output.canFind(pattern)) {
                continue;
            }
        }

        if (rCase) {
            output = randomCase(output);
        }
        else if (hCase) {
            output = hillCase(output);
        }
        else if (haxor) {
            output = leetSpeak(output);
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
