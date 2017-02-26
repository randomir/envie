#!/usr/bin/env python
from __future__ import print_function
import re
import sys
from functools import partial
from operator import itemgetter, ge
from difflib import SequenceMatcher
import subprocess


def tokenize(phrase, sep='\W+', minlen=1, unique=False):
    """Split string ``phrase`` according to ``sep``, expunge all tokens longer
    than ``minlen`` and return a list of tokens (unique tokens if ``unique`` is 
    set).
    """
    tokens = [s.lower() for s in re.split(sep, phrase, flags=re.U) if len(s) >= minlen]
    if unique:
        tokens = list(set(tokens))
    return tokens


def similarity(w, word):
    """Modified SequenceMatcher similarity: strongly prefer full word matches
    and prefix matches.
    """
    if w == word:
        return 1
    elif word.startswith(w):
        return 0.5
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
        score = max(sims)
        if score > 0:
            del path_tokens[sims.index(score)]
        path_score += score
    return path_score


def guesstimate(cwd, phrase):
    """Try to find a best match around ``cwd`` between the closest environments
    and the list of tokens the user gave in ``phrase``.
    Prefer full word (phrase token) to path-component match, then prefix match
    and then a difflib-based match.
    """
    try:
        output = subprocess.check_output(
            'envie find -q "%s"' % cwd, shell=True).decode('ascii').strip('\n')
        envs = output.split('\n')
    except subprocess.CalledProcessError as exc:
        sys.exit(1)

    words = tokenize(phrase)
    results = []
    for env in envs:
        path_tokens = tokenize(env, unique=True)
        score = matching(path_tokens, words)
        results.append((score, env))

    results.sort()
    best_score = max(results, key=itemgetter(0))[0]
    for r in results:
        if r[0] >= best_score:
            print(r[1])


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(255)

    cwd=sys.argv[1]
    tokens = sys.argv[2:]

    phrase = ' '.join(tokens)
    guesstimate(cwd, phrase)
