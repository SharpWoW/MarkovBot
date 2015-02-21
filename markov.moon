-- Copyright (c) 2015 by Adam Hellberg.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

NAME, T = ...

T.markov = {}

import random from math
import db, log, markov from T

-- Blacklist contains words that will not be added or processed
blacklist = {'^[%s%c%p]+$', '\124%w'}

parenpairs =
    '(': ')'
    '[': ']'
    '{': '}'

markov.save = (str) =>
    -- Make it lowercase for less duplicates
    str = str\lower!
    -- Strip links
    str = str\gsub '\124%w.-\124r', ''
    -- Phrases inside parens, brackets, and braces are extracted to be processed separately
    --subphrases = {}
    --for left, right in pairs parenpairs
    --    str = str\gsub '%' .. left .. '(.-)%' .. right, (p) ->
    --        subphrases[#subphrases + 1] = p
    --        ''
    -- For now, just strip all parens and puncuation, makes for a little more comedic phrases too
    str = str\gsub '%p', ' '
    -- Begin by getting a table of all the words
    words = {}
    str\gsub '[^%s]+', (w) ->
        for pattern in *blacklist
            return if w\match pattern
        words[#words + 1] = w
    if #words < 3
        log\debug 'Markov can\'t process lines shorter than 3 words, aborting.'
        return
    for i = 1, #words
        break if #words - i < 2
        key = '%s %s'\format words[i], words[i + 1]
        value = words[i + 2]
        db.main.words[key] = {} unless db.main.words[key]
        found = false
        for entry in *db.main.words[key]
            if entry.word == value
                entry.count += 1
                found = true
                break
        db.main.words[key][#db.main.words[key] + 1] = {word: value, count: 1} unless found
    --for phrase in *subphrases
    --    @save phrase

markov.create = (seed, maxwords = random(5, 50)) =>
    -- We build the result string in a table for easier processing
    result = {}
    seed\gsub '[^%s]+', (w) -> result[#result + 1] = w
    count = #result
    while count < maxwords
        key = '%s %s'\format result[#result - 1], result[#result]
        list = db.main.words[key]
        unless list
            log\debug 'No entries found for %s.', key
            break
        result[#result + 1] = list[random(1, #list)].word
        count += 1
    table.concat result, ' '

markov.reply = (msg, channel, silent) =>
    @save msg
    if msg\len! < 1
        chat\send channel, 'Not enough data to process.' unless silent
        return false
    words = {}
    msg = msg\lower!
    msg\gsub '[^%s]+', (w) -> words[#words + 1] = w
    if #words < 2
        chat\send channel, 'Not enough words to process.' unless silent
        return false
    index = random 1, #words
    secondindex = random 1, #words
    while secondindex == index
        secondindex = random 1, #words
    seed = '%s %s'\format words[index], words[secondindex]
    T.chat\send @create(seed), channel
    true
