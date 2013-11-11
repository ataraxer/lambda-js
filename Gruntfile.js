module.exports = function(grunt) {

	// Project configuration.
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		uglify: {
			options: {
				banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n',
				beautify: true,
			},
			build: {
				//src: 'src/<%= pkg.name %>.js',
				//dest: 'build/<%= pkg.name %>.min.js'
				src: 'out/lambda.js',
				dest: 'out/lambda.min.js'
			},
		},
		coffee: {
			compile: {
				files: {
					'out/lambda.js': 'src/lambda.coffee',
				},
			},
		},
	});

	// Load the plugin that provides the "uglify" task.
	grunt.loadNpmTasks('grunt-contrib-uglify');

	// Load the plugin that provides the "coffee" task
	grunt.loadNpmTasks('grunt-contrib-coffee');

	// Default task(s).
	//grunt.registerTask('default', ['uglify']);
	grunt.registerTask('default', ['coffee', 'uglify']);

};
