module KeyUpload
  extend ActiveSupport::Concern

  def select_key_material
    if params[:ascii].present?
      key_material = params[:ascii]
    elsif params[:keyfile].present?
      key_material = params[:keyfile].read
    else
      return nil
    end
    if ! key_material.match('BEGIN PGP')
      # Input appears to be binary
      key_material = Base64.encode64(key_material)
    end
    key_material
  end

end
