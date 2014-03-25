class TopicsController < ApplicationController

  def index
    @topics = Topic.order(:name).where(:parent_topic_id=>nil).paginate(:page=>params[:page], :per_page=> 3*5 )
    session[:return_to] = topics_path
  end

  def show
    @topic = Topic.friendly.find(params[:id])
    session[:return_to] = topic_path(@topic)
  end

  def new
    @topic = Topic.new
    @topic.parent_topic_id = Topic.find_by_id(params[:parent_topic_id]).id if params[:parent_topic_id].present?
  end

  def edit
    @topic = Topic.friendly.find(params[:id])
    session[:return_to] ||= request.referer
  end

  def create
    @topic = Topic.new(topic_params)
    respond_to do |format|
      if @topic.save
        format.html { redirect_to topics_url, notice: 'Topic was successfully created.' }
        format.json { render action: 'show', status: :created, location: @topic }
      else
        format.html { render action: 'new' }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @topic = Topic.friendly.find(params[:id])
    redir_to = session.delete(:return_to) || topics_path

    @topic.tags = params[:topic][:tags].reject{|tag| tag.blank? }
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to redir_to, notice: 'Topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @topic = Topic.friendly.find(params[:id])

    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def topic_params
    params[:topic][:tags] = Tag.add_new_tags(params[:topic][:tags].split(',').flatten)
    params[:topic].permit(:name, :description, :content, :parent_topic_id, :tags => [] )
  end
end
