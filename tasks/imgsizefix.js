// Generated by CoffeeScript 1.6.3
module.exports = function(grunt) {
  var Parser, REG, async, force, fs, imgsizefix, path;
  fs = require('fs');
  path = require('path');
  async = grunt.util.async;
  Parser = require('imagesize').Parser;
  force = grunt.option('force') === true;
  REG = {
    tag: /<\s*img[^>]*\s+(width|height)(\s*)=(\s*)["']\$["'][^>]*>/im,
    src: /\s+src\s*=\s*["']([^"']+)["']/im,
    width: /(\s+)width\s*=\s*(["'])\$["']/im,
    height: /(\s+)height\s*=\s*(["'])\$["']/im,
    abspath: /^(https?:\/)?\//im
  };
  imgsizefix = function(filepath, options, next) {
    var dirname, embedded, found, from, height, html, image, imgPath, index, length, pair, parser, paths, src, srcMatch, tag, tagMatch, to, width, _i, _len, _ref, _ref1;
    if (!grunt.file.exists(filepath)) {
      return next(false);
    }
    if (!(html = grunt.file.read(filepath))) {
      return next(false);
    }
    dirname = path.dirname(filepath);
    paths = [];
    _ref = options.paths;
    for (to in _ref) {
      from = _ref[to];
      to = path.normalize(to + '/');
      from = path.normalize(from + '/');
      from = from.replace(/(\/|\.|\-|\?|\&|\#)/g, '\\$1');
      paths.push({
        from: new RegExp("^" + from),
        to: path.normalize(to)
      });
    }
    while (tagMatch = html.match(REG.tag)) {
      tag = tagMatch[0];
      index = tagMatch.index;
      length = tag.length;
      srcMatch = tag.match(REG.src);
      width = '';
      height = '';
      if (srcMatch) {
        src = srcMatch[1];
        imgPath = null;
        if (src.match(REG.abspath)) {
          for (_i = 0, _len = paths.length; _i < _len; _i++) {
            pair = paths[_i];
            from = pair.from, to = pair.to;
            imgPath = path.resolve(src.replace(from, to));
            break;
          }
        } else {
          imgPath = path.resolve(dirname, src);
        }
        parser = Parser();
        found = fs.existsSync(imgPath);
        image = found ? fs.readFileSync(imgPath) : console.log('not found:', imgPath);
        if (image) {
          switch (parser.parse(image)) {
            case Parser.EOF || Parser.INVALID:
              console.log('invalid:', imgPath);
              return;
            case Parser.DONE:
              _ref1 = parser.getResult(), width = _ref1.width, height = _ref1.height;
          }
        }
      }
      if (found) {
        width = options.filter("width", width);
        height = options.filter("height", height);
      }
      embedded = tag;
      embedded = embedded.replace(REG.width, "$1width=$2" + width + "$2");
      embedded = embedded.replace(REG.height, "$1height=$2" + height + "$2");
      html = html.replace(tag, embedded);
    }
    fs.writeFileSync(filepath, html);
    return next();
  };
  return grunt.registerMultiTask('imgsizefix', "Embed the IMG tag's size-attributes from real image size.", function() {
    var done, options;
    done = this.async();
    options = this.options({
      force: force,
      enableHTTP: false,
      paths: null,
      filter: function(property, size) {
        return size;
      }
    });
    return async.forEach(this.filesSrc, function(filepath, next) {
      return imgsizefix(filepath, options, next);
    }, function(error) {
      return done(!error);
    });
  });
};
