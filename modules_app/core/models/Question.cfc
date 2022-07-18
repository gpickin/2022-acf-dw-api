component extends="core.models.BaseEntity" table="questions" accessors="true" {

    property name="questionID" column="questionID" setter="false";
    property name="question";

    variables._key = "questionID";

    this.constraints = {
        "question": {
            required: true,
            size: "1..255"
        }
    }

    function answers(){
        return hasMany( "Answer@core", "questionID" );
    }
    function votes(){
        return hasManyThrough( [ "answers", "votes" ] );
    }
    function deleteVotes(){
        queryExecute(
            "DELETE FROM votes 
            WHERE EXISTS (
                SELECT 1 FROM answers 
                WHERE (answers.questionID = :questionID ) 
                AND votes.answerID = answers.answerID 
            )",
            { 
                questionID={value=this.getQuestionID(), cfsqltype="cf_sql_integer"}
            }
        );
    }
}