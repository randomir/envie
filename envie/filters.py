#!/usr/bin/env python
from __future__ import print_function
import re
import sys
from operator import itemgetter
from difflib import SequenceMatcher


# detect `re` module unicode support
# flags param is supported only in Python 2.7+
try:
    re.split('x', 'y', flags=re.UNICODE)
    split_flags = dict(flags=re.UNICODE)
except TypeError:
    split_flags = dict()


def tokenize(phrase, sep='\W+', minlen=1, unique=False):
    """Split string ``phrase`` according to ``sep``, expunge all tokens longer
    than ``minlen`` and return a list of tokens (unique tokens if ``unique`` is 
    set).
    """
    tokens = [s.lower() for s in re.split(sep, phrase, **split_flags) if len(s) >= minlen]
    if unique:
        tokens = list(set(tokens))
    return tokens


def similarity(w, word):
    """Modified SequenceMatcher similarity: strongly prefer full word matches
    and prefix matches.
    """
    if word.startswith(w):
        return 0.5 + 0.5 * len(w) / len(word)
    else:
        return SequenceMatcher(None, w, word).ratio() / 2.0


def matching(path_tokens, words):
    """Calculates a matching between ``words`` and ``path_tokens``, 
    according to ``similarity``. We look for words, word by word in path 
    components. When a match between a word and component is found, that 
    component is not considered for remaining words.
    """
    path_score = 0
    for word in words:
        sims = list(map(lambda p: similarity(word, p), path_tokens))
        score = sims and max(sims) or 0
        if score > 0:
            del path_tokens[sims.index(score)]
        path_score += score
    return path_score


def fuzzy_filter(*args):
    """Try to find a best match between (virtualenv) paths given on stdin
    and the list of tokens the user gave in ``phrase``.
    Prefer full word (phrase token) to path-component match, then prefix match
    and then a difflib-based match.
    """
    phrase = ' '.join(list(args))
    words = tokenize(phrase)
    results = []
    while True:
        # one environment path per line; break on EOF
        line = sys.stdin.readline()
        if not line:
            break
        env = line.strip()
        # score each env path according to `words` correspondence
        path_tokens = tokenize(env, unique=True)
        score = matching(path_tokens, words)
        results.append((score, env))

    if results:
        results.sort()
        best_score = max(results, key=itemgetter(0))[0]

    for r in results:
        if r[0] >= best_score:
            print(r[1])


if __name__ == '__main__':
    fuzzy_filter(sys.argv[1:])
