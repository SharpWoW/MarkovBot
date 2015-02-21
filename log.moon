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

T.log =
    levels:
        DEBUG: 0
        INFO: 1
        WARN: 2
        ERROR: 3
        FATAL: 4

import log from T

log.prefixes =
    [log.levels.DEBUG]: 'DEBUG'
    [log.levels.INFO]: 'INFO'
    [log.levels.WARN]: 'WARN'
    [log.levels.ERROR]: 'ERROR'
    [log.levels.FATAL]: 'FATAL'

msgtemplate = '[%s] [%%s]: %%s'\format NAME

log.log = (level, text, ...) =>
    msg = msgtemplate\format (@.prefixes[level] or 'UNKNOWN'), text\format ...
    DEFAULT_CHAT_FRAME\AddMessage msg
    msg\len!

for level, value in pairs log.levels
    log[level\lower!] = (text, ...) => @log value, text, ...
