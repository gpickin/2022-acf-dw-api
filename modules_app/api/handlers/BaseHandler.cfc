component extends=coldbox.system.RestHandler {

    function vof(){
        return validateOrFail( argumentCollection=arguments );
    }

    private function mergeWith( required parent, required children, required mergeKey, required parentField, childField="" ){
        if( !len( arguments.childField ) ){
            arguments.childField = parentField;
        }
        return parent.map( (parentItem) => {
            parentItem[ mergeKey ] = children.filter( ( childItem ) => {
                return ( childItem[ childField ] == parentItem[ parentField ] );
            });
            return parentItem;
        });
    }

    private function getPaginationConstraints(){
        return {
            "page": {
                required: true,
                type: "numeric",
                min: "1",
                max: 1000
            },
            "maxrows": {
                required: true,
                type: "integer",
                min: 1,
                max: 999999
            }
        };
    }

}