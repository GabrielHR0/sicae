class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_escola_slug, only: [:new, :create]

  def create
    build_resource(sign_up_params)
    resource.escola = Current.escola if Current.escola.present?
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def set_escola_slug
    @escola_slug = Current.escola&.slug
  end

  def sign_up_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :username,
      :escola_id,
      perfil_attributes: [
        :nome,
        :cpf,
        :telefone,
        :data_nascimento
      ]
    )
  end
end