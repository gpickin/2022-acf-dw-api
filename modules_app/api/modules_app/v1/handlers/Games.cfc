component extends=api.handlers.BaseHandler {

    property name="questionService" inject="quickService:Question@core";
    property name="answerService" inject="quickService:Answer@core";

    function create( event, rc, prc ) {
        prc.questions = questionService
            .withCount( "answers" )
            .orderByRaw( "rand()" )
            .retrieveQuery()
            .paginate( 1, 5 );

        prc.answers = answerService
            .whereIn( "questionID", prc.questions.results.map( function( item ){ return item.questionID } ) )
            .orderByRaw( "rand()" )
            .withCount( "votes" )
            .retrieveQuery()
            .get();

        mergeWith( prc.questions.results, prc.answers, "answers", "questionID" );
        
        prc.response
            .setDataWithPagination( 
                prc.questions
            );
    }

}