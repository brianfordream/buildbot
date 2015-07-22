class BuildInfo extends Directive

    constructor: ->
        return {
            restrict: 'E'
            templateUrl: 'views/buildinfo.html'
            controller: '_BuildInfoController'
            controllerAs: 'buildinfo'
            bindToController: true
            scope:
                build: '='
        }

class _BuildInfo extends Controller
    changesLimit: 5
    properties: {}
    raw_properties: {}
    changes: []

    constructor: ->
        @build.loadProperties().then (data) => @processProperties(data[0])
        @changes = @build.loadChanges().getArray()

    processOwners: (owners) ->
        emailRegex = /[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*/
        return (
            for owner in owners
                email = emailRegex.exec(owner) || ['']
                name = owner.replace emailRegex, ''
                name: name
                email: email[0]
            )

    processProperties: (data) ->
        raw = {}
        for k, v of data
            raw[k] = {value: v[0], source: v[1]} if v and v.length == 2

        @raw_properties = raw

        display = {}
        display.owners = @processOwners(raw.owners?.value || [])
        display.revision = (raw.got_revision?.value || raw.revision?.value || '')[0..10]
        display.slave = raw.slavename?.value
        display.scheduler = raw.scheduler?.value
        display.dir = (raw.builddir?.value || raw.worddir?.value)

        @properties = display


