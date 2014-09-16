"use strict";

var resolve = require('path').resolve,
    fs = require('fs'),
    readFileSync = fs.readFileSync,
    writeFileSync = fs.writeFileSync,
    imgsizefix = require('imgsizefix'),
    async = require('async');

module.exports = function (grunt) {
    grunt.registerMultiTask(
        'imgsizefix',
        "Embed the IMG tag's size-attributes from real image size.",
        function () {
            var options = this.options();
            async.forEach(
                this.filesSrc,
                function(path, callback){
                    path = resolve(path);
                    writeFileSync(
                        path,
                        imgsizefix.sync(path, options)
                    );
                    callback();
                },
                this.async()
            );
        }
    );
}