component extends="quick.models.BaseEntity"  accessors="true" {

    /**
     * Helper function to retrieve Constraints 
     *
     * @constraintsKeyName The name of the variable to pull the constraints out of
     * 
     * @return struct of Constraints
     */
    struct function getConstraints( constraintsKeyName="constraints" ){
        if( len( arguments.constraintsKeyName ) != 0 && structKeyExists( this, constraintsKeyName ) ){
            return this[ constraintsKeyName ];
        } else {
            return {};
        }        
    }

    /**
	 * Helper to add a structure of Constraints into the existing entity constraints and return the combined struct
	 *
	 * @newConstraints The new struct full of constraints to add
	 * @constraintsKeyName The name of the variable with the entity constraints inside of the entity. Defaults to the convention of `constraints`
	 *
	 * @return a CBValidation compliant struct of Entity Constraints
	 */
	function addConstraints( newConstraints = {}, constraintsKeyName = "constraints" ) {
		var constraints = getConstraints( arguments.constraintsKeyName );
		constraints.append( arguments.newConstraints );
		return constraints;
	}

    /**
	 * Validate an object or structure according to the constraints rules.
	 * @fields The fields to validate on the target. By default, it validates on all fields
	 * @constraints A structure of constraint rules or the name of the shared constraint rules to use for validation
	 * @locale The i18n locale to use for validation messages
	 * @excludeFields The fields to exclude from the validation
	 * @includeFields The fields to include in the validation
	 *
	 * @return cbvalidation.model.result.IValidationResult
	 * @throws ValidationException error
	 */
	public struct function validateOrFail(
		any constraints = this.getConstraints(),
		string fields = "*",
		string locale = "",
		string excludeFields = "",
		string includeFields = ""
	) {
		var result = _wirebox
			.getInstance( "ValidationManager@cbvalidation" )
			.validateOrFail(
				target = this,
				fields = arguments.fields,
				constraints = arguments.constraints,
				locale = arguments.locale,
				excludeFields = arguments.excludeFields,
				includeFields = arguments.includeFields
			);
		return this;
	}

    function vof(){
        return validateOrFail( argumentCollection=arguments );
    }

}