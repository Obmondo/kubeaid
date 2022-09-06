# package k8srequiredresources handles compliance of containers and initContainers
# having a predefined resource limits and requests of cpu and memory.
# Objects that do not specify the resource limits and requests show up as violators of the policy.

package k8srequiredresources

# This policy checks compliance for all containers
violation[{"msg": msg}] {
	general_violation[{"msg": msg, "field": "containers"}]
}

# This policy checks compliance for all init containers
violation[{"msg": msg}] {
	general_violation[{"msg": msg, "field": "initContainers"}]
}

general_violation[{"msg": msg, "field": field}] {
	# input.review.object is an AdmissionReview object sent by the API server to 
    # an AdmissionControl webhook.

    # var container stores the list of all containers from the AdmissionReview object 
    container := input.review.object.spec[field][_]

    # var provided stores the resource limits (cpu, memory) of each container 
	provided := {resource_type | container.resources.limits[resource_type]}

    # input.parameters is populated by the ConstraintTemplate YAML in the templates directory
    # var required stores the types of resource limits we want a compliance on
	required := {resource_type | resource_type := input.parameters.limits[_]}
	
    # deciding whether the limits provided in each container (cpu, memory)
    # are the same as the limits required by the ConstraintTemplate
    missing := required - provided
    count(missing) > 0

    # send back a message if there are not enough limits defined
	msg := sprintf("container <%v> does not have <%v> limits defined.", [container.name, missing])
}

general_violation[{"msg": msg, "field": field}] {
    # input.review.object is an AdmissionReview object sent by the API server to 
    # an AdmissionControl webhook.

    # var container stores the list of all init containers from the AdmissionReview object 
	container := input.review.object.spec[field][_]

    # var provided stores the resource requests (cpu, memory) of each init container 
	provided := {resource_type | container.resources.requests[resource_type]}

    # input.parameters is populated by the ConstraintTemplate YAML in the templates directory
    # var required stores the types of resource requests we want a compliance on
	required := {resource_type | resource_type := input.parameters.requests[_]}
	
    # deciding whether the requests provided in each init container (cpu, memory)
    # are the same as the requests required by the ConstraintTemplate
    missing := required - provided
	count(missing) > 0

    # send back a message if there are not enough requests defined
	msg := sprintf("container <%v> does not have <%v> requests defined.", [container.name, missing])
}
