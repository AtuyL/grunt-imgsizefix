module.exports = (grunt)->
  fs = require 'fs'
  path = require 'path'
  async = grunt.util.async
  Parser = require('imagesize').Parser
  
  force = grunt.option('force') is true

  REG =
    tag:/<\s*img[^>]*\s+(width|height)(\s*)=(\s*)["']\$["'][^>]*>/im
    src:/\s+src\s*=\s*["']([^"']+)["']/im
    width:/(\s+)width\s*=\s*(["'])\$["']/im
    height:/(\s+)height\s*=\s*(["'])\$["']/im
    abspath:/^(https?:\/)?\//im

  imgsizefix = (filepath,options,next)->
    # console.log '========',filepath,'========'
    if not grunt.file.exists filepath then return next false
    if not html = grunt.file.read filepath then return next false
    dirname = path.dirname filepath
    
    # normalize paths ================================
    paths = []
    for to,from of options.paths
      to = path.normalize to + '/'
      from = path.normalize from + '/'
      # console.log 'from:',from,'to:',to
      from = from.replace /(\/|\.|\-|\?|\&|\#)/g,'\\$1'
      paths.push
        from:new RegExp "^#{from}"
        to:path.normalize to

    # do embed ================================
    while tagMatch = html.match REG.tag
      tag = tagMatch[0]
      # console.log 'tag:',tag
      index = tagMatch.index
      length = tag.length
      srcMatch = tag.match REG.src
      width = ''
      height = ''
      if srcMatch
        src = srcMatch[1]
        imgPath = null
        # console.log 'src:',src
        if src.match REG.abspath
          for pair in paths
            {from:from,to:to} = pair
            imgPath = path.resolve src.replace from,to
            break
        else
          imgPath = path.resolve dirname,src

        parser = do Parser

        found = fs.existsSync imgPath

        image = if found then fs.readFileSync imgPath else console.log 'not found:',imgPath
        if image then switch parser.parse image
          when Parser.EOF or Parser.INVALID 
            console.log 'invalid:',imgPath
            return
          when Parser.DONE then {width:width,height:height} = do parser.getResult

      if found
        width = options.filter("width", width)
        height = options.filter("height", height)

      embedded = tag
      embedded = embedded.replace REG.width,"$1width=$2#{width}$2"
      embedded = embedded.replace REG.height,"$1height=$2#{height}$2"
      # console.log tag,'-------->',embedded
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