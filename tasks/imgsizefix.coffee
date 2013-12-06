module.exports = (grunt)->
  fs = require 'fs'
  path = require 'path'
  async = grunt.util.async
  Parser = require('imagesize').Parser
  
  force = grunt.option('force') is true

  REG =
    tag:/<\s*img[^>]*\s+(width|height)(\s*)=(\s*)["']\$["'][^>]*>/im
    src:/\s+src\s*=\s*["']([^"']+)["']/im
    lazy:/\s+data-lazy\s*=\s*["']([^"']+)["']/im
    width:/(\s+)width\s*=\s*(["'])\$["']/im
    height:/(\s+)height\s*=\s*(["'])\$["']/im
    abspath:/^(https?:\/)?\//im

  imgsizefix = (filepath,options,next)->
    if not grunt.file.exists filepath then return next false
    if not html = grunt.file.read filepath then return next false
    dirname = path.dirname filepath
    
    # normalize paths ================================
    paths = []
    for to,from of options.paths
      if typeof from is 'string' then from = [from]
      paths.push
        to:path.normalize "#{to}/"
        from:from.map (value)->
          # value = path.normalize value + '/'
          value = value.replace /(\/|\.|\-|\?|\&|\#)/g,'\\$1'
          return new RegExp "^#{value}"

    # do embed ================================
    while tagMatch = html.match REG.tag
      tag = tagMatch[0]
      index = tagMatch.index
      length = tag.length
      srcMatch = tag.match REG.lazy || tag.match REG.src
      width = ''
      height = ''
      if srcMatch
        src = srcMatch[1]
        imgPath = null
        if src.match REG.abspath
          for {from:from,to:to} in paths
            for fromReg in from when fromReg.exec src
              imgPath = path.resolve src.replace fromReg,to
              break
            if imgPath then break
        else
          imgPath = path.resolve dirname,src

        found = fs.existsSync imgPath
        image = if found then fs.readFileSync imgPath else console.log 'not found:',imgPath
        parser = do Parser
        if image then switch parser.parse image
          when Parser.EOF or Parser.INVALID 
            return
          when Parser.DONE then {width:width,height:height} = do parser.getResult

      if found
        width = options.filter("width", width)
        height = options.filter("height", height)

      embedded = tag
      embedded = embedded.replace REG.width,"$1width=$2#{width}$2"
      embedded = embedded.replace REG.height,"$1height=$2#{height}$2"
      html = html.replace tag,embedded
    fs.writeFileSync filepath,html
    next()

  grunt.registerMultiTask 'imgsizefix',"Embed the IMG tag's size-attributes from real image size.",->
    done = do @async
    options = @options
      force:force
      paths:null
      filter: (property, size) -> size
    async.forEach @filesSrc,
      (filepath,next)-> imgsizefix filepath,options,next
      (error)-> done not error
