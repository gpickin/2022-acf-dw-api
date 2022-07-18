component extends=api.handlers.BaseHandler {

    property name="questionService" inject="quickService:Question@core";
    property name="answerService" inject="quickService:Answer@core";
    property name="voteService" inject="quickService:Vote@core";

    function index( event, rc, prc ) {
        param rc.voter = "";

        if( len( rc.voter ) ){
            prc.votes = questionService.whereHas( 
                "answers.votes", 
                function( q ){
                    q.where( "voterSignature", rc.voter );
                })
                .retrieveQuery()
                .select( "questionID" )
                .get();
            // writeDump( prc.votes );abort;  

            prc.questions = questionService
                .whereNotIn( "questionID", prc.votes.map( function( item ){ return item.questionID } ) )
                .orderByRaw( "rand()" )
                .retrieveQuery()
                .paginate( 1, 2 );

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
        } else {
            prc.response
                .setErrorMessage( "Unknown Identity" )
                .setStatusCode( 400 );
        }
        
    }

    function create( event, rc, prc ) {
        param rc.voter = "";
        if( !len( rc.voter ) ){
            prc.response
                .setErrorMessage( "Unknown Identity" )
                .setStatusCode( 400 );
            return;
        }
        questionService.existsOrFail( rc.questionID );
        answerService.existsOrFail( rc.answerID );
        prc.voteCount = voteService
                        .where( "answerID", rc.answerID )
                        .where( "voterSignature", rc.voter )
                        .count();
        
        if( prc.voteCount == 0 ){
            voteService.create( {
                voterSignature: rc.voter,
                answerID: rc.answerID
            } );
        } else {
            prc.response
                .setErrorMessage( "Already Voted" )
                .setStatusCode( 400 );
            return;
        }
    }

}