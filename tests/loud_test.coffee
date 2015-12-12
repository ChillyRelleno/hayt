Helper = require('hubot-test-helper')

helper = new Helper('../scripts/loud.coffee')
expect = require('chai').expect

describe 'being loud', ->
  room = null

  beforeEach ->
    room = helper.createRoom()

  context 'loud database', ->
    it 'should have 3 louds after some user chatter', ->
      room.user.say 'alice',   'WHO THE HECK ARE YOU'
      room.user.say 'bob',     'WHAT IS GOING ON HERE'
      room.user.say 'charlie', 'HELP I AM TRAPPED IN A UNIT TEST'
      expect(room.robot.brain.get('louds').length).to.eql 3
      expect(room.robot.brain.get('louds')).to.eql ['WHO THE HECK ARE YOU', 'WHAT IS GOING ON HERE', 'HELP I AM TRAPPED IN A UNIT TEST']

    it 'should support funny characters', ->
      room.user.say 'alice',   '"FOO"'
      room.user.say 'bob',     'FOO+'
      room.user.say 'charlie', 'FOO-'
      room.user.say 'alice',   'FOO!'
      room.user.say 'bob',     'FOO@BAR'
      room.user.say 'charlie', 'FOO #BAR'
      room.user.say 'alice',   'FOO$'
      room.user.say 'bob',     'FOO%'
      room.user.say 'charlie', 'FOO?'
      room.user.say 'alice',   'FOO & BAR'
      room.user.say 'charlie', 'FOO"BAR"'
      expect(room.robot.brain.get('louds').length).to.eql 11
      
    it 'should only have 1 loud stored after deleting the second', ->
      room.user.say 'alice', 'FOO'
      room.user.say 'bob',   'BAR'
      room.user.say 'alice', '@hubot loud delete BAR'
      expect(room.robot.brain.get('louds')).to.eql ['FOO']

  context 'louds in chat', ->
    it 'should be produced whenever someone louds anew', ->
      room.user.say 'alice', 'FOO'
      room.user.say 'bob',   'BAR'
      expect(room.messages[2]).to.eql ['hubot', 'FOO']
