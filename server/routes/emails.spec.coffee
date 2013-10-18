sinon = require 'sinon'
chai = require 'chai'
chai.use require 'sinon-chai'
request = require 'supertest'
express = require 'express'
nock = require 'nock'

chai.Should()

emails = require './emails'


describe "emails route", ->

  env = {}
  beforeEach ->
    env = {}
    env.app = express()
    env.app.use express.bodyParser()

  describe "setting up the route", ->

    beforeEach ->
      sinon.stub env.app, 'post'

    it "registers the POST handler on the namespace root", ->
      emails.setup env.app
      env.app.post.should.have.been.calledWith '/', sinon.match.func

  describe "Wufoo integration", ->

    beforeEach ->
      emails.setup env.app
      env.wufoo = nock('https://salsita.wufoo.com:443')
        .post('/api/v3/forms/z7x3p3/entries.json')

    it "forwards the (correct) form data to wufoo", (done) ->
      env.wufoo = env.wufoo.reply 200
      request(env.app)
        .post('/')
        .send({
          name: 'Scooby Doo'
          email: 'scooby@doo.com'
        })
        .expect(200)
        .end (err) ->
          if err then throw err
          env.wufoo.done()
          done()

    it "sends HTTP 500 if the form data does not have the email field", (done) ->
      env.wufoo = env.wufoo.reply 200
      request(env.app)
        .post('/')
        .send([])
        .expect(500)
        .end (err) ->
          if err then throw err
          env.wufoo.isDone().should.be.false
          done()

    it "sends HTTP 500 if Wufoo responds with an error", (done) ->
      env.wufoo = env.wufoo.reply 500
      request(env.app)
        .post('/')
        .send([])
        .expect(500)
        .end (err) ->
          if err then throw err
          env.wufoo.isDone().should.be.false
          done()

