module ApplicationHelper

  def validated_form_class(resource,attribute)
    if resource.errors[attribute].any?
      "form-control is-invalid"
    elsif resource.errors.any?
      "form-control is-valid"
    else
      "form-control"
    end
  end

  def error_for(resource, attribute, help_text=nil)
    if resource.errors[attribute]
      render partial: "form_error_message", locals: { resource: resource, attribute: attribute, help_text: help_text }
    end
  end
end
