component {
    
    function up( schema, qb ) {
        schema.create( "answers", function( table ) {
            table.increments( "answerID" );
            table.string( "answer" );
            table.unsignedInteger( "questionID" ).references( "questionID" ).onTable( "questions" );
            table.timestamp( "createdDate" );
            table.timestamp( "modifiedDate" );
        } );
    }

    function down( schema, qb ) {
        schema.drop( "answers" );
    }

}
