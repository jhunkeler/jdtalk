module jdtalk.core;

import std.algorithm;
import std.array;
import std.file;
import std.path;
import std.process : environment;
import std.random;
import std.stdio;
import std.string;


struct dict_t {
    string[] noun;
    string[] verb;
    string[] adverb;
    string[] adjective;
}


string[] readDict(string filename) {
    string[] result;
    foreach (line; readText(filename).split) {
        line = line.strip;
        if (line.empty || line.startsWith("#"))
            continue;
        result ~= line;
    }
    return result;
}


string word(string[] arr) {
    return arr.choice;
}


bool hasWord(string match, string str) {
    if (str is null)
        return false;

    foreach(word; str.split()) {
        if (match == word)
            return true;
    }
    return false;
}


bool searchDict(dict_t dict, string pattern) {
    bool has_pattern = false;
    foreach (wordList; [dict.noun, dict.verb, dict.adverb, dict.adjective]) {
        foreach (word; wordList) {
            has_pattern = wordList.canFind(pattern);
            break;
        }
        if (has_pattern) break;
    }
    return has_pattern;
}


dict_t getData(string root) {
    // override data root with environment variable
    if (environment.get("JDTALK_DATA", null)) {
        root = environment["JDTALK_DATA"].absolutePath;
    }
    return dict_t(
            readDict(buildPath(root, "nouns.txt")),
            readDict(buildPath(root, "verbs.txt")),
            readDict(buildPath(root, "adverbs.txt")),
            readDict(buildPath(root, "adjectives.txt")),
           );
}


string talk(ref dict_t dict) {
    string output;
    output = join([
                word(dict.adjective),
                word(dict.noun),
                word(dict.adverb),
                word(dict.verb)],
                " ");
    return output;
}
