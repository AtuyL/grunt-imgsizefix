module.exports = (grunt)->
	grunt.initConfig
		jade:
			rel_brother:
				options:data:img:'./'
				files:['test/www/rel_brother.html':'test/index.jade']
			rel_child:
				options:data:img:'../'
				files:['test/www/child/rel_child.html':'test/index.jade']
			abs_root:
				options:data:img:'/'
				files:['test/www/abs/abs_root.html':'test/index.jade']
			abs_rootchild:
				options:data:img:'/child/'
				files:['test/www/abs/abs_rootchild.html':'test/index.jade']
		imgsizefix:
			options:
				paths:
					'test/www':['/','http://www.example.com']
					'test/www/child/':'/child/'
			short: ['test/**/*.html']
			long: src: ['test/**/*.html']
	grunt.loadNpmTasks 'grunt-contrib-jade'
	grunt.loadTasks 'tasks'
	grunt.registerTask 'default',['jade','imgsizefix']