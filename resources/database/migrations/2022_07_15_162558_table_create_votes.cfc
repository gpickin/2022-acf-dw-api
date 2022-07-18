component {
    
    function up( schema, qb ) {
        schema.create( "votes", function( table ) {
            table.increments( "voteID" );
            table.string( "voterSignature" );
            table.unsignedInteger( "answerID" ).references( "answerID" ).onTable( "answers" );
            table.timestamp( "createdDate" );
            table.timestamp( "modifiedDate" );
        } );
    }

    function down( schema, qb ) {
        schema.drop( "votes" );
    }

}
