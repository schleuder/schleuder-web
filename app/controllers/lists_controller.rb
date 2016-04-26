class ListsController < ApplicationController
  skip_load_and_authorize_resource only: :create

  def new
    @list = List.build
  end

  def index
    redirect_to root_path
  end

  def edit
    @keywords = %w[subscribe unsubscribe list-subscriptions set-fingerprint resend resend-encrypted-only sign-this add-key delete-key list-keys get-key fetch-key]
  end

  def show
    @subscription = current_account.subscription(@list)
  end

  def edit_subscriptions
    # Neccessary for the shared form.
    @subscription = Subscription.build
    # ActiveResource doesn't actually merge attributes given to build() (it's a
    # bug fixed for versions requiring rails5), so we assign the list manually.
    @subscription.list_id = @list.id
  end

  def create
    @list = List.new(new_list_params)
    authorize! :create, @list
    if @list.save
      redirect_to @list, notice: "✓ List created."
    else
      render 'new'
    end
  end

  def update
    logger.info list_params.inspect
    if @list.update_attributes(list_params)
      redirect_to edit_list_path(@list), notice: "✓ Options saved."
    else
      render 'edit'
    end
  end

  def destroy
    if list = @list.destroy
      redirect_to current_account, notice: "✓ List #{@list.email} deleted."
    else
      redirect_to list, error: "Deleting list failed!"
    end
  end

  private 

  def new_list_params
    params.require(:list).permit(:email, :fingerprint)
  end

  def list_params
    # TODO: refine
    p = params.require(:list).permit!
    if p['headers_to_meta'].is_a?(String)
      p['headers_to_meta'] = p['headers_to_meta'].split("\n").map { |h| h.strip }
    end
    # TODO: find out where the empty values in these two values come from (some
    # hidden-fields without a name?).
    p['keywords_admin_only'] = p['keywords_admin_only'].map {|v| v.presence || nil }.compact
    p['keywords_admin_notify'] = p['keywords_admin_notify'].map {|v| v.presence || nil }.compact
    # Convert these into a hash.
    p['bounces_drop_on_headers'] = p['bounces_drop_on_headers'].to_s.strip.split("\n").inject({}) do |memo, line|
      name, value = line.split(':').map(&:strip)
      if name.present? && value.present?
        memo[name] = value
      end
      memo
    end
    p
  end
end
