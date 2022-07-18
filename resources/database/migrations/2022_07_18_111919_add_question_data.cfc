component {
    
    function up( schema, qb ) {
        queryExecute( 
            "INSERT INTO questions (questionID, question, createdDate, modifiedDate) VALUES
            (1, 'What version of Adobe ColdFusion do you use?', '2022-07-16 04:23:41', '2022-07-16 04:23:41'),
            (2, 'What License of Adobe ColdFusion are you running?', '2022-07-16 04:25:28', '2022-07-16 04:25:28'),
            (3, 'What CF Server OS are you using?', '2022-07-16 04:26:46', '2022-07-16 04:26:46'),
            (4, 'What OS do you run on your laptop/PC?', '2022-07-16 05:09:21', '2022-07-16 05:09:21'),
            (5, 'What browsers/client platforms do you support in your apps?', '2022-07-16 05:14:06', '2022-07-16 05:14:06'),
            (6, 'Databases you use?', '2022-07-16 05:18:52', '2022-07-16 05:18:52'),
            (22, 'What MVC Frameworks do you use?', '2022-07-18 14:11:31', '2022-07-18 14:11:31'),
            (23, 'What ColdFusion-based CMS do you use?', '2022-07-18 14:13:29', '2022-07-18 14:13:29'),
            (24, 'What JavaScript libraries do you use?', '2022-07-18 14:14:51', '2022-07-18 14:14:51'),
            (25, 'What CSS frameworks do you use?', '2022-07-18 14:16:19', '2022-07-18 14:16:19'),
            (26, 'Who is your favorite ACFDW Speaker so far?', '2022-07-18 17:30:54', '2022-07-18 17:30:54')
            "
        );
    }

    function down( schema, qb ) {
        queryExecute( 
            "delete from questions where 1 = 1" 
        );
    }

}
