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

import chat from T

frame = CreateFrame 'Frame'

events = {}

receive = (channel, msg, sender) ->
    chat\receive channel, msg, sender

events.ADDON_LOADED = (name) ->
    return unless name == NAME
    T\init!

events.CHAT_MSG_GUILD = (msg, sender) ->
    receive 'GUILD', msg, sender

events.CHAT_MSG_INSTANCE = (msg, sender) ->
    receive 'INSTANCE', msg, sender

events.CHAT_MSG_PARTY = (msg, sender) ->
    receive 'PARTY', msg, sender

events.CHAT_MSG_RAID = (msg, sender) ->
    receive 'RAID', msg, sender

events.CHAT_MSG_WHISPER = (msg, sender) ->
    receive 'WHISPER', msg, sender

events.CHAT_MSG_SAY = (msg, sender) ->
    receive 'SAY', msg, sender

events.CHAT_MSG_YELL = (msg, sender) ->
    receive 'YELL', msg, sender

events.CHAT_MSG_CHANNEL = (msg, sender, _, channel, _, _, _, index) ->
    receive channel, msg, sender if index == 1 or index == 2

frame\SetScript 'OnEvent', (event, ...) =>
    events[event](...) if events[event]

for event in pairs events
    frame\RegisterEvent event
