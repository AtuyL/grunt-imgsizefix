# grunt-imgsizefix v1.0.0

> Fix the IMG tag size from Local image file.

## Getting Started
This plugin requires Grunt `~0.4.0`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-imgsizefix --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-imgsizefix');
```

## imgsizefix task
_Run this task with the `grunt imgsizefix` command._

Task targets, files and options may be specified according to the grunt [Configuring tasks](http://gruntjs.com/configuring-tasks) guide.
### Options

#### paths
Type: `Array`

Concatenated files will be joined on this string.

#### force
Type: `boolean`
Default: `true`

Compile the JavaScript without the top-level function safety wrapper.

#### filter
Type: `Function`

When compiling multiple .coffee files into a single .js file, concatenate first.

```js
function(property, size){
  return size
}
```

### Usage Examples

```js
coffee: {
  compile: {
    files: {
      'path/to/result.js': 'path/to/source.coffee', // 1:1 compile
      'path/to/another.js': ['path/to/sources/*.coffee', 'path/to/more/*.coffee'] // compile and concat into single file
    }
  },

  compileBare: {
    options: {
      bare: true
    },
    files: {
      'path/to/result.js': 'path/to/source.coffee', // 1:1 compile
      'path/to/another.js': ['path/to/sources/*.coffee', 'path/to/more/*.coffee'] // compile and concat into single file
    }
  },

  compileJoined: {
    options: {
      join: true
    },
    files: {
      'path/to/result.js': 'path/to/source.coffee', // 1:1 compile, identical output to join = false
      'path/to/another.js': ['path/to/sources/*.coffee', 'path/to/more/*.coffee'] // concat then compile into single file
    }
  },

  compileWithMaps: {
    options: {
      sourceMap: true
    },
    files: {
      'path/to/result.js': 'path/to/source.coffee', // 1:1 compile
      'path/to/another.js': ['path/to/sources/*.coffee', 'path/to/more/*.coffee'] // concat then compile into single file
    }
  },

  compileWithMapsDir: {
    options: {
      sourceMap: true,
      sourceMapDir: 'path/to/maps/' // source map files will be created here
    },
    files: {
      'path/to/result.js': 'path/to/source.coffee'
    }
  }

  glob_to_multiple: {
    expand: true,
    flatten: true,
    cwd: 'path/to',
    src: ['*.coffee'],
    dest: 'path/to/dest/',
    ext: '.js'
  },

}
```

For more examples on how to use the `expand` API to manipulate the default dynamic path construction in the `glob_to_multiple` examples, see "[Building the files object dynamically](http://gruntjs.com/configuring-tasks#building-the-files-object-dynamically)" in the grunt wiki entry [Configuring Tasks](http://gruntjs.com/configuring-tasks).


## Release History

 * 2014-02-07â€ƒâ€ƒâ€ƒv0.10.0â€ƒâ€ƒâ€ƒSourceMappingURL calculated correctly
 * 2014-01-29â€ƒâ€ƒâ€ƒv0.9.0â€ƒâ€ƒâ€ƒSource mapping fixes. Update coffee-script to 1.7.0 Use lodash directly instead of deprecated grunt.util._
 * 2014-01-17â€ƒâ€ƒâ€ƒv0.8.2â€ƒâ€ƒâ€ƒForce coffeescript 1.6.3 Use new sourceMappingUrl syntax.
 * 2014-01-17â€ƒâ€ƒâ€ƒv0.8.1â€ƒâ€ƒâ€ƒFix sourcemap regression.
 * 2013-12-24â€ƒâ€ƒâ€ƒv0.8.0â€ƒâ€ƒâ€ƒSupport sourceMapDir
 * 2013-04-19â€ƒâ€ƒâ€ƒv0.7.0â€ƒâ€ƒâ€ƒPlace Sourcemaps at bottom of file Change extension for Sourcemaps from .maps to .js.map
 * 2013-04-18â€ƒâ€ƒâ€ƒv0.6.7â€ƒâ€ƒâ€ƒImproved error reporting
 * 2013-04-08â€ƒâ€ƒâ€ƒv0.6.6â€ƒâ€ƒâ€ƒFix regression with single-file compilation.
 * 2013-04-05â€ƒâ€ƒâ€ƒv0.6.5â€ƒâ€ƒâ€ƒImproved error reporting
 * 2013-03-22â€ƒâ€ƒâ€ƒv0.6.4â€ƒâ€ƒâ€ƒSourcemap support
 * 2013-03-19â€ƒâ€ƒâ€ƒv0.6.3â€ƒâ€ƒâ€ƒIncrease error logging verbosity.
 * 2013-03-18â€ƒâ€ƒâ€ƒv0.6.2â€ƒâ€ƒâ€ƒBump to CoffeeScript 1.6.2
 * 2013-03-18â€ƒâ€ƒâ€ƒv0.6.1â€ƒâ€ƒâ€ƒSupport `join` option
 * 2013-03-06â€ƒâ€ƒâ€ƒv0.6.0â€ƒâ€ƒâ€ƒBump to CoffeeScript 1.6 Support literate CoffeeScript extension coffee.md
 * 2013-02-25â€ƒâ€ƒâ€ƒv0.5.0â€ƒâ€ƒâ€ƒBump to CoffeeScript 1.5 Support literate CoffeeScript (.litcoffee)
 * 2013-02-15â€ƒâ€ƒâ€ƒv0.4.0â€ƒâ€ƒâ€ƒFirst official release for Grunt 0.4.0.
 * 2013-01-23â€ƒâ€ƒâ€ƒv0.4.0rc7â€ƒâ€ƒâ€ƒUpdating grunt/gruntplugin dependencies to rc7. Changing in-development grunt/gruntplugin dependency versions from tilde version ranges to specific versions. Bump coffeescript dependency to 1.4.
 * 2013-01-09â€ƒâ€ƒâ€ƒv0.4.0rc5â€ƒâ€ƒâ€ƒUpdating to work with grunt v0.4.0rc5. Switching to this.filesSrc api.
 * 2012-12-15â€ƒâ€ƒâ€ƒv0.4.0aâ€ƒâ€ƒâ€ƒConversion to grunt v0.4 conventions. Remove experimental destination wildcards.
 * 2012-10-12â€ƒâ€ƒâ€ƒv0.3.2â€ƒâ€ƒâ€ƒRename grunt-contrib-lib dep to grunt-lib-contrib.
 * 2012-09-25â€ƒâ€ƒâ€ƒv0.3.1â€ƒâ€ƒâ€ƒDon't fail when there are no files.
 * 2012-09-24â€ƒâ€ƒâ€ƒv0.3.0â€ƒâ€ƒâ€ƒGlobal options depreciated.
 * 2012-09-10â€ƒâ€ƒâ€ƒv0.2.0â€ƒâ€ƒâ€ƒRefactored from grunt-contrib into individual repo.

---

Task submitted by [AtuyL](http://twitter.com/AtuyL)

*This document is extended from **grunt-contrib-coffee** document.*