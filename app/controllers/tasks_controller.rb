class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.xml
  def index
    @tasks = Task.all(:order => '`order`')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    tasks = Task.count + 1
    @task = Task.new(params[:task])
    @task.order = tasks
    respond_to do |format|
      if @task.save
        format.html { redirect_to_index('Task was successfully created', 1) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])
    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to_index('Task was successfully updated.', 1)}
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def move_up
    begin
      @task = Task.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid task #{params[:id]}")
      redirect_to_index("Could not find that task")
    else
      if(@task.order > 1)
        prev = Task.find_by_order(@task.order - 1)
        prevOrder = prev.order
        prev.order = @task.order
        @task.order = prevOrder
        respond_to do |format|
          if @task.save && prev.save
            format.js if request.xhr?
            format.html { redirect_to_index('Task moved up successfully!', 1) }
          else
            format.js if request.xhr
            format.html { redirect_to_index('Sorry, but the task could not be moved up.', 2) }
          end
        end
      else
        respond_to do |format|
          format.js if request.xhr?
          format.html { redirect_to_index('That task cannot be moved up, as it\'s at the top.', 2) }
        end
      end
    end
  end

  def move_down
    @task = Task.find(params[:id])
    if(@task.order < Task.count)
      nextTask = Task.find_by_order(@task.order + 1)
      nextOrder = nextTask.order
      nextTask.order = @task.order
      @task.order = nextOrder
      respond_to do |format|
        if @task.save && nextTask.save
          format.js if request.xhr?
          format.html { redirect_to_index('Task moved down successfully!', 1) }
        else
          format.js if request.xhr?
          format.html { redirect_to_index('Sorry, but the task could not be moved down', 2) }
        end
      end
    else
      respond_to do |format|
        format.js if request.xhr?
        format.html { redirect_to_index('That task cannot be moved down, it\'s already at the bottom.', 1) }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end

  private

  def redirect_to_index(msg = nil, type = nil)
    if type == 1
      flash[:notice] = msg if msg
    elsif type == 2
      flash[:error] = msg if msg
    end
    redirect_to tasks_path
  end
end

