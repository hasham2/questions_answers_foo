class QaController < ActionController::Base
  
  #before_filter :qa_authenticate  
  
  # for this controller, the views are located in a different directory from
  # the application's views.
  view_path = File.join(File.dirname(__FILE__), '..', 'views')
  
  if public_methods.include? 'append_view_path' # rails 2.1+
    self.append_view_path view_path
  elsif public_methods.include? "view_paths"   # rails 2.0+
    self.view_paths << view_path
  else                                      # rails <2.0
    self.template_root = view_path
  end
  
  layout "qa"
  
  def css
    forward_to_file '/qa/stylesheets/', 'text/css'
  end
    
  #list most recent questions that other users have asked
  def index
    @questions = Question.find(:all, :conditions => ["is_closed = ? AND is_public = ? AND user_id <> ?", false, false, session[:user_id] ], :order => "questions.created_at DESC", :limit => 5, :include => :user)
  end
  
  #Displays a form where you can ask a question
  #including choose a category for questions
  def ask_a_question
    @question = Question.new
    @intrests = Intrest.find(:all)
  end
  
  def create    
    @question = Question.new(params[:question])
    @question.user_id = session[:user_id]
    @question.is_public = (params[:question][:is_public])? false : true 
    @question.is_closed = false
    if @question.save
      no_of_intrests = params[:total_cats].to_i
      i = 1
      while i < no_of_intrests + 1
        key = "hidden_" + i.to_s
        intrest = Intrest.find(params[key])
        @question.intrests << intrest
        i += 1
      end
      flash[:notice] = "The question was successfully saved"
      redirect_to :action => "show", :id => @question.id and return
    else
      flash[:error] = "There was error in creating a question"
      render :action => :ask_a_question
    end
  end
  
  #Displays two lists one my questions and other is
  #my answers
  def my_questions_answers
    #user = User.find(session[:user_id])
    if params[:tab] == "q"
      @questions = Question.paginate(:all, :conditions => ["questions.user_id = ?", session[:user_id]], :page => params[:page])
    else
      @answers = Answer.paginate(:all, :conditions => ["answers.user_id = ?", session[:user_id]], :page => params[:page], :include => :question)
    end
  end
  
  #display a single question with responses 
  #this is where you can answer a question as well
  #via answer button and answer form
  def show
    @rec_not_saved = false
    @question = Question.find(params[:id])
    @answers = @question.answers.find(:all, :order => "answers.created_at ASC", :include => :user)
    @answer = @question.answers.new
    @answer.user_id = session[:user_id]
  end
  
  #list of all questions that user can answer with diffrent 
  #sort options
  def answer_questions
    if params[:cat] && !params[:cat].blank? 
      selected_intrest = Intrest.find(params[:cat])
      @questions = selected_intrest.questions.paginate(:all, :conditions => ["is_closed = ? AND is_public = ? AND user_id <> ? ", false, false, session[:user_id]], :order => "questions.created_at DESC", :page => params[:page], :include => :user)
    else  
      @questions = Question.paginate(:all, :conditions => ["is_closed = ? AND is_public = ? AND user_id <> ? ", false, false, session[:user_id]], :order => "questions.created_at DESC", :page => params[:page], :include => :user)
    end    
  end
  
  #answer a question
  def answer
    @answer = Answer.new(params[:answer])
    if @answer.save      
      redirect_to :action => "show", :id => @answer.question_id and return
    else
      @rec_not_saved =true
      @question = Question.find(@answer.question_id)
      @answers = @question.answers.find(:all, :order => "answers.created_at ASC", :include => :user)
      render :action => "show", :id => @question.id
    end  
  end
  
  def close
    question = Question.find(params[:qid])
    question.is_closed = true
    question.save
    redirect_to :action =>"show", :id => question.id and return
  end
  
  def get_all_intrests
    intrests = Intrest.find(:all)
    render :json => intrests.to_json  
  end
  
  private
  
  # root path is relative to plugin questions_answers/ui/views directory.
  def forward_to_file(root_path, content_type)
    render :file => File.expand_path(File.join(__FILE__,"../../views", root_path, params[:file])),
           :content_type => content_type
  end
  
  def qa_authenticate
    if session[:user_id].blank?
      flash[:notice] = "Please login to view this page"
      redirect_to '/' and return
    end  
  end
  
end
