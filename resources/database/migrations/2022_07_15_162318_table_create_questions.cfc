component {
    
    function up( schema, qb ) {
        schema.create( "questions", function( table ) {
            table.increments( "questionID" );
            table.string( "question" );
            table.timestamp( "createdDate" );
            table.timestamp( "modifiedDate" );
        } );
    }

    function down( schema, qb ) {
        schema.drop( "questions" );
    }

}
