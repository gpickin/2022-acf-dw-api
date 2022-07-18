component extends=api.handlers.BaseHandler secured{

    property name="questionService" inject="quickService:Question@core";
    property name="answerService" inject="quickService:Answer@core";


    function create( event, rc, prc ) {
        param rc.questionID = "";
        param rc.bulkVotes = 0;
        prc.oQuestion = questionService.findOrFail( rc.questionID );
        prc.oAnswer = answerService
            .fill( this.vof( target=rc, constraints=answerService.getConstraints() ) )
            .vof()
            .save()
            .refresh();
        
        if( rc.bulkVotes ){
            prc.aVotes = [];
            for (i=1; i <= rc.bulkVotes; i++) { 
                prc.aVotes = prc.aVotes.append( 
                    { "voterSignature": "", "answerID": prc.oAnswer.getAnswerID() } 
                );
            }
            getInstance( "QueryBuilder@qb" )
                .from( "votes" )
                .insert( prc.aVotes );
        }

        prc.response
            .addMessage( "Answer Added to Question" );
    }

    function update( event, rc, prc ) {
        param rc.questionID = "";
        param rc.answerID = "";
        prc.oQuestion = questionService.findOrFail( rc.questionID );
        prc.oAnswer = answerService
            .where( "questionID", rc.questionID )
            .findOrFail( rc.answerID )
            .fill( this.vof( target=rc, constraints=answerService.getConstraints() ) )
            .vof()
            .save();

        prc.response
            .addMessage( "Answer Updated" );
    }

    function delete( event, rc, prc ) {
        prc.oQuestion = questionService.findOrFail( rc.questionID );
        prc.oAnswer = answerService
            .where( "questionID", rc.questionID )
            .findOrFail( rc.answerID );
        prc.oAnswer.votes().deleteAll();
        prc.oAnswer.delete();

        prc.response
            .addMessage( "Answer and all Votes Deleted" );
    }

}