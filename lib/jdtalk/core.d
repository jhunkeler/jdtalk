module jdtalk.core;

import std.algorithm;
import std.array;
import std.ascii;
import std.file;
import std.path;
import std.process : environment;
import std.random;
import std.stdio;
import std.string;
import std.conv : to;


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


string randomCase(string s) {
    auto SEED = Random(unpredictableSeed);
    string[] arr = s.split("");
    ulong count = arr.length;
    for (ulong i = 0; i < count; i++) {
        ulong pos = uniform(0, arr.length, SEED);
        if (arr[pos].to!char.isWhite) {
            i--;
            continue;
        }
        arr[pos] = arr[pos].toUpper;
    }

    return arr.join("");
}


string hillCase(string s) {
    string[] arr = s.split("");
    for (ulong i = 0; i < arr.length; i++) {
        if (i % 2) {
            arr[i] = arr[i].toLower;
        }
        else {
            arr[i] = arr[i].toUpper;
        }
    }

    return arr.join("");
}


string leetSpeak(string s) {
    string[dchar] trx = [
        'a': "4",
        'A': "4",
        'b': "8",
        'B': "8",
        'c': "(",
        'C': "(",
        'd': ")",
        'D': ")",
        'e': "3",
        'E': "3",
        'f': "ƒ",
        'F': "ƒ",
        'g': "6",
        'G': "6",
        'h': "#",
        'H': "#",
        'i': "!",
        'I': "!",
        'j': "]",
        'J': "]",
        'k': "X",
        'K': "X",
        'l': "1",
        'L': "1",
        'm': "|\\/|",
        'M': "|\\/|",
        'n': "|\\|",
        'N': "|\\|",
        'o': "0",
        'O': "0",
        'p': "|*",
        'P': "|*",
        'q': "9",
        'Q': "9",
        'r': "|2",
        'R': "|2",
        's': "$",
        'S': "$",
        't': "7",
        'T': "7",
        'u': "|_|",
        'U': "|_|",
        'v': "\\/",
        'V': "\\/",
        'w': "\\/\\/",
        'W': "\\/\\/",
        'x': "><",
        'X': "><",
        'y': "¥",
        'Y': "¥",
        'z': "2",
        'Z': "2",
    ];
    return translate(s, trx);
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


bool wordStartsWith(ref string[] words, char ch) {
    foreach (word; words) {
        if (word.startsWith(ch.to!string)) {
            return true;
        }
    }
    return false;
}


bool searchDict(dict_t dict, string pattern) {
    bool has_pattern = false;
    foreach (wordList; [dict.noun, dict.verb, dict.adverb, dict.adjective]) {
        if ((has_pattern = wordList.canFind(pattern)) == true) {
            break;
        }
    }
    return has_pattern;
}

char acronymSafe(ref dict_t dict, string acronym, string pattern=null) {
    string[] words;
    char last = 0;

    words = dict.noun ~ dict.verb ~ dict.adverb ~ dict.adjective;
    for (int i = 0; i < acronym.length; i++) {
        if (!wordStartsWith(words, acronym[i])) {
            last = acronym[i];
        }
    }

    bool has_pattern = false;
    if (pattern) {
        char check = pattern[0];
        has_pattern = acronym.canFind(check.to!string);
        if (!has_pattern) {
            last = check;
        }
    }
    return last;
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


string talkSalad(ref dict_t dict, int words) {
    string[] salad;
    for (int i = 0; i < words; i++) {
        string[] wordList = [dict.noun, dict.verb, dict.adverb, dict.adjective].choice;
        salad ~= word(wordList);
    }
    return salad.join(" ");
}


string talkf(ref dict_t dict, string fmt) {
    string[] output;
    for (int i = 0; i < fmt.length; i++) {
        if (fmt[i] == '%' && (i + 1) < fmt.length) {
            switch (fmt[i + 1]) {
                case 'a':
                    output ~= word(dict.adjective);
                    break;
                case 'n':
                    output ~= word(dict.noun);
                    break;
                case 'd':
                    output ~= word(dict.adverb);
                    break;
                case 'v':
                    output ~= word(dict.verb);
                    break;
                default:
                    continue;
            }
        }
    }
    return output.join(" ");
}


string talkAcronym(ref dict_t dict, string abbrev) {
    string[] words;
    string[] output;

    words = dict.noun ~ dict.verb ~ dict.adverb ~ dict.adjective;

    for (int i = 0; i < abbrev.length; i++) {
        string word = "";
        while ((word = words.choice) !is null) {
            if (word.startsWith(abbrev[i].to!char)) {
                break;
            }
        }

        output ~= word;
    }
    return output.join(" ");
}
