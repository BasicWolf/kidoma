module('QUnit')

test('Smoketest', ->
    equals(1, 1))


module('extractNode')

test('extract text', ->
    n = kidomi.extractNode('some text')
    ok(n instanceof Text))

test('extract number as text', ->
    n = kidomi.extractNode(123)
    equals('123', n.textContent)

    n = kidomi.extractNode(123.1099)
    equals('123.1099', n.textContent)

    n = kidomi.extractNode(-123.1099)
    equals('-123.1099', n.textContent))

test('extract node', ->
    n2 = document.createElement('div')
    n = kidomi.extractNode(n2)
    ok(n instanceof Node))


module('makeElementFromTagData')

test('node is HTMLElement', ->
    tagData = kidomi.parseTagToken('div')
    n = kidomi.makeElementFromTagData(tagData)
    ok(n instanceof HTMLElement))

test('node with no-id no-classes name', ->
    tagData = kidomi.parseTagToken('div')
    n = kidomi.makeElementFromTagData(tagData)
    equals("DIV", n.tagName))

test('node with id, no-classes name', ->
    tagData = kidomi.parseTagToken('div#content')
    n = kidomi.makeElementFromTagData(tagData)
    equals("content", n.id)
    equals(n.className, ''))

test('node with no id, two classes', ->
    tagData = kidomi.parseTagToken('div.class1.class2')
    n = kidomi.makeElementFromTagData(tagData)
    equals('class1 class2', n.className))


module('addAttributes')

test('add attributes to form', ->
    attr =
        'class': ['class1', 'class2']
        'style':
            'color': '#aaa'
            'text-decoration': 'line-through'
        'action': 'getform.php'
        'method': 'get'
    n = document.createElement('form')
    kidomi.addAttributes(n, attr)
    equals('getform.php', n.getAttribute('action')))

test('class only; class as a list', ->
    n = kidomi(['div'])
    kidomi.addAttributes(n, {'class': ['class1', 'class2']})
    equals('class1 class2', n.className))

test('class only; class as a string', ->
    n = kidomi('div')
    kidomi.addAttributes(n, {'class': 'class1 class2'})
    equals('class1 class2', n.className))

test('class only; class as an empty array', ->
    n = kidomi('div')
    kidomi.addAttributes(n, {'class': []})
    equals('', n.className))

test('style only; style as a map', ->
    attr =
        'style':
            'color': '#aaa'
            'text-decoration': 'line-through'

    n = kidomi(['div'])
    kidomi.addAttributes(n, attr)
    equals('color: rgb(170, 170, 170); text-decoration: line-through;',
           n.style.cssText.trim()))

test('style only; style as a string', ->
    n = kidomi(['div'])
    kidomi.addAttributes(n, {'style': 'color: #aaa;'})
    equals('color: rgb(170, 170, 170);', n.style.cssText.trim()))

test('style only; style as an empty object', ->
    n = kidomi(['div'])
    kidomi.addAttributes(n, {'style': {}})
    equals('', n.style.cssText.trim()))

test('various attributes, no class or style', ->
    n = kidomi(['div'])
    kidomi.addAttributes(n, {'action': 'getform.php', 'method': 'get'})
    equals('getform.php', n.getAttribute('action'))
    equals('get', n.getAttribute('method')))

test('various attributes, with class and style', ->
    attr =
        'class': ['class1', 'class2']
        'style':
            'color': '#aaa'
            'text-decoration': 'line-through'
        'action': 'getform.php'
        'method': 'get'

    n = kidomi(['div'])
    kidomi.addAttributes(n, attr)
    equals('class1 class2', n.className)
    equals('color: rgb(170, 170, 170); text-decoration: line-through;',
           n.style.cssText.trim())
    equals('getform.php', n.getAttribute('action'))
    equals('get', n.getAttribute('method')))


module('parseTagToken')

test('id without classes', ->
    tagData = kidomi.parseTagToken('div#content')
    equals('content', tagData.id)
    equals('div', tagData.name)
    deepEquals([], tagData.classes))

test('one class only', ->
    tagData = kidomi.parseTagToken('div.class1')
    equals('div', tagData.name)
    deepEquals(['class1'], tagData.classes)
    equals('', tagData.id))

test('many classes', ->
    tagData = kidomi.parseTagToken('div.class1.class2')
    equals('div', tagData.name)
    deepEquals(['class1', 'class2'], tagData.classes)
    equals('', tagData.id))

test('id and one class', ->
    tagData = kidomi.parseTagToken('div#content.class1')
    equals('div', tagData.name)
    deepEquals(['class1'], tagData.classes)
    equals('content', tagData.id))

test('id and many classes', ->
    tagData = kidomi.parseTagToken('div#content.class1.class2')
    equals('div', tagData.name)
    deepEquals(['class1', 'class2'], tagData.classes)
    equals('content', tagData.id))

test('blank tag name, id only', ->
    tagData = kidomi.parseTagToken('#content')
    equals('', tagData.name)
    equals('content', tagData.id))

test('blank tag name, classes only', ->
    tagData = kidomi.parseTagToken('.class1.class2')
    equals('', tagData.name)
    deepEquals(['class1', 'class2'], tagData.classes))

test('blang tag name, id and classes', ->
    tagData = kidomi.parseTagToken('')
    equals('', tagData.name)
    equals('', tagData.id)
    deepEquals([], tagData.classes))

module('appendChildren')

test('appendSingleChild', ->
    parent = document.createElement('tr')
    child = document.createElement('td')
    kidomi.appendChildren(parent, child)
    equals(child, parent.childNodes[0]))

test('appendChildren', ->
    parent = document.createElement('tr')
    child0 = document.createElement('td')
    child1 = document.createElement('td')
    kidomi.appendChildren(parent, [child0, child1])
    equals(child0, parent.childNodes[0])
    equals(child1, parent.childNodes[1]))


module('util')


test('isNode', ->
    ok(kidomi.isNode(document.createElement('div'))
    ok(not kidomi.isNode([]))
    ok(not kidomi.isNode({}))
    ok(not kidomi.isNode(''))
    ok(not kidomi.isNode(10))))

test('isArray', ->
    ok(kidomi.isArray([]))
    ok(not kidomi.isArray({}))
    ok(not kidomi.isArray(''))
    ok(not kidomi.isArray(10)))

test('isString', ->
    ok(kidomi.isString(''))
    ok(not kidomi.isString({}))
    ok(not kidomi.isString([]))
    ok(not kidomi.isString(10)))

test('isObject', ->
    ok(kidomi.isObject({}))
    ok(not kidomi.isObject(''))
    ok(not kidomi.isObject([]))
    ok(not kidomi.isObject(10)))

test('isJquery', ->
    ok(kidomi.isJquery($('<div>')))
    ok(not kidomi.isJquery(document.createElement('div')))
    ok(not kidomi.isJquery([]))
    ok(not kidomi.isJquery({}))
    ok(not kidomi.isJquery(''))
    ok(not kidomi.isJquery(10)))
