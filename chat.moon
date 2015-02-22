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

MARKOV_PREFIX = '[Markov]'
MARKOV_PATTERN = '^%[Markov%]'

T.chat =
    lastreply: 0

import random from math
import markov, chat from T

REPLY_TIME_LOW = 300
REPLY_TIME_HIGH = 1800

chat.send = (msg, channel = 'GUILD', target) =>
    SendChatMessage('%s %s'\format(MARKOV_PREFIX, msg), channel, nil, target)

chat.receive = (channel, msg, sender) =>
    return if msg\match MARKOV_PATTERN
    if channel == 'GUILD'
        @.lastreply = time() if @.lastreply == 0
        if msg\match '^!markov'
            markov\reply msg\match('^!markov (.+)'), 'GUILD'
        else if time! - @.lastreply > random(REPLY_TIME_LOW, REPLY_TIME_HIGH)
            success = markov\reply msg, 'GUILD', true
            @.lastreply = time! if success
    
    markov\save msg unless msg\match '^!markov' or msg\match MARKOV_PATTERN
