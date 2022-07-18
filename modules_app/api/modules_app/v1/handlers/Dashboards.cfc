component displayname="DashboardService" extends="api.handlers.BaseHandler"{

    // DI
    property name="questionService"		inject="quickService:question@core";
    property name="answerService"		inject="quickService:answer@core";
    property name="voteService"		inject="quickService:vote@core";

    function index( event, rc, prc ){
        prc.response.setData( [ getDashboardItems() ] );
    }

    private function getDashboardItems(){

        var cardGroups = {
            "title": "Dev Feud Questions",
            "cards": []
        };

        arrayAppend( cardGroups.cards, {
            "title": 'Questions',
            "description": 'Questions in the System',
            "backgroundColor": 'bg-blue-9',
            "iconName": 'assignment',
            "total": questionService.count(),
            "link": "/questions"
        });

        arrayAppend( cardGroups.cards, {
            "title": 'Answers',
            "description": 'Answers in the System',
            "backgroundColor": 'bg-blue-9',
            "iconName": 'assignment',
            "total": answerService.count(),
            "link": "/questions"
        });

        arrayAppend( cardGroups.cards, {
            "title": 'Votes',
            "description": 'Votes in the System',
            "backgroundColor": 'bg-blue-9',
            "iconName": 'assignment',
            "total": voteService.count(),
            "link": "/questions"
        });

        return cardGroups;
    }
}