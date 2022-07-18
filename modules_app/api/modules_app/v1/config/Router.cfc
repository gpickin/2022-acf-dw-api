component {

	function configure() {
		// API Echo
		get( "/", "Echo.index" );

		// API Authentication Routes
		post( "/login", "Auth.login" );
		post( "/logout", "Auth.logout" );
		post( "/register", "Auth.register" );

		// API Secured Routes
		get( "/whoami", "Echo.whoami" );

		get( "/dashboards", "Dashboards.index" );

		route( "/questions/:questionID/answers/:answerID" )
			.withHandler( "Answers" )
			.toAction( { GET: "show", PUT: "update", DELETE: "delete" } );
		route( "/questions/:questionID/answers" )
			.withHandler( "Answers" )
			.toAction( { GET: "index", POST: "create" } );

		route( "/games" )
			.withHandler( "Games" )
			.toAction( { POST: "create" } );

		route( "/votable-questions" )
			.withHandler( "VotableQuestions" )
			.toAction( { GET: "index", POST: "create" } );


		apiResources( 
			resource="questions", 
			handler="Questions", 
			parameterName="questionID",
			only="index,create,delete,show,update"
		);
		
		// route( "/questions" )
		// 	.withHandler( "Questions" )
		// 	.toAction( { GET: "index", POST: "create" } );

		// route( "/questions/:questionID" )
		// 	.withHandler( "Questions" )
		// 	.toAction( { GET: "show", PUT: "update", DELETE: "delete" } );
		route( "/:anything" )
			.withHandler( "Echo" )
			.toAction( "on404" );
		
	}

}
