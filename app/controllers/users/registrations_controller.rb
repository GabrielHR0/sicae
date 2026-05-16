class Users::RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :username,
      perfil_attributes: [
        :nome,
        :cpf,
        :telefone,
        :data_nascimento
      ]
      )
  end
end
