# 計算機科学実験演習4

[実験ページ](https://www.db.soc.i.kyoto-u.ac.jp/lec/le4db/)

## convert markdown to pdf

```sh
$ npm install
$ ./node_modules/.bin/markdown-pdf [path to markdown file]
```

## convert markdown to pdf in github

I use this script in github and save the page as pdf.

```js
var file = $('.file').css({ margin: 0 })
$('body').empty()
file.appendTo('body')
$('.meta').remove()
$('pre').css({ 'white-space': 'pre-wrap' })
$('.task-list:first li').eq(1).text(prompt('input your name'))
$('.task-list:first li').eq(2).text(prompt('input your student id'))
print()
```

## demo application

see [README](https://github.com/tyage/experiment-4/tree/master/sample-app/README.md)
