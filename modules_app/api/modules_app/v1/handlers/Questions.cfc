component extends=api.handlers.BaseHandler secured{

    property name="questionService" inject="quickService:Question@core";
    property name="answerService" inject="quickService:Answer@core";


    /**
     * Display a paginated list of Questions
     *
     * @x-route (GET) /api/v1/questions
     * @tags Questions
     * @x-parameters /resources/apidocs/api/v1/questions/index/parameters.json##parameters
     * @response-default /resources/apidocs/api/v1/questions/index/responses.json##200
     * 
     */
    function index( event, rc, prc ){
        param rc.page = "1";
        param rc.maxrows = "25";
        param rc.includeAnswers = false;
        param rc.sortBy = "question";
        param rc.descending = false;
        param rc.question = "";

        rc.sortDirection = rc.descending == false ? "asc" : "desc";
		if( rc.sortBy == 'null' || rc.sortBy == 'undefined'){
			rc.sortBy = "question";
            rc.sortDirection = "asc";
		}

        prc.cleanedRC = vof( 
            target=rc, 
            constraints=getPaginationConstraints()
                .append( 
                    {
                        "includeAnswers": {
                            required: true,
                            type: "boolean"
                        }
                    }
                )
            );

        prc.questions = questionService
            .when( 
                len( rc.question ), 
                function( q ){
                    q.whereLike( "question", "%#rc.question#%" );
                }
            )
            .withCount( "answers" )
            .orderBy( rc.sortBy, rc.sortDirection )
            .retrieveQuery()
            .paginate( prc.cleanedRC.page, prc.cleanedRC.maxrows );

        if( rc.includeAnswers ){
            prc.answers = answerService
                .whereIn( "questionID", prc.questions.results.map( function( item ){ return item.questionID } ) )
                .withCount( "votes" )
                .retrieveQuery()
                .get();

            mergeWith( prc.questions.results, prc.answers, "answers", "questionID" );
        }

        prc.response
            .setDataWithPagination( 
                prc.questions
            );
    }


    /**
     * 
     * Creating a new Question
     * 
     * @x-route (POST) /api/v1/questions
     * @tags Questions
     * @requestBody /resources/apidocs/api/v1/questions/create/requestBody.json
     * @response-200 /resources/apidocs/api/v1/questions/create/responses.json##200 
     * @response-401 /resources/apidocs/api/v1/_responses/responses.401.json##401
     * @response-403 /resources/apidocs/api/v1/_responses/responses.403.json##403
     */
    function create( event, rc, prc ) {

        prc.oQuestion = questionService
            .fill( this.vof( target=rc, constraints=questionService.getConstraints() ) )
            .vof()
            .save();
        
        prc.response
            .addMessage( "Question Created" )
            .setData( prc.oQuestion.getMemento() );
    }


    function show( event, rc, prc ) {
        param rc.includeAnswers = false;

        prc.oQuestion = questionService.findOrFail( rc.questionID );
        prc.question = prc.oQuestion.getMemento();

        if( rc.includeAnswers ){
            prc.question[ "answers" ] = prc.oQuestion
                .answers()
                .withCount( "votes" )
                .retrieveQuery()
                .get();
        }

        prc.response
            .setData( 
                prc.question
            );
    }


    function update( event, rc, prc ) {

        prc.oQuestion = questionService
            .findOrFail( rc.questionID )
            .update( this.vof( target=rc, constraints=questionService.getConstraints() ) );
        
        prc.response
            .addMessage( "Question Updated" );
    }


    function delete( event, rc, prc ) {
        prc.oQuestion = questionService.findOrFail( rc.questionID );
        prc.oQuestion.deleteVotes();
        prc.oQuestion.answers().deleteAll();
        prc.oQuestion.delete();

        prc.response
            .addMessage( "Question Deleted" );
    }

}