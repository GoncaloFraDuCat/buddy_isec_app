class PagesController < ApplicationController
  before_action :authenticate_user!

  def search
    # Start with all mentors
    mentors = User.where(mentor: true)


    case params[:tipo_ajuda]
    when 'Ajuda Social'
      mentors = mentors.where(ajuda_social: true)
    when 'Apoio Estudo'
      mentors = mentors.where(apoio_estudo: true)
    when 'Apoio Bolsas'
      mentors = mentors.where(apoio_bolsas: true)
    end

    # Filter mentors by area_of_study if a parameter is provided and not "All Areas of Study"
    mentors = mentors.by_area_of_study(params[:area_of_study]) unless params[:area_of_study] == 'Todas as Areas'


  # Select 8 random mentors from the filtered list
    @pagy, @mentors = pagy(mentors, items: 8)

    @areas_of_study = ['Ciências Aeronáuticas e do Espaço', 'Comunicação Global', 'CTeSP em Apoio à Infância', 'CTeSP em Comunicação e Marketing', 
	'CTeSP em Desenvolvimento de Produtos Multimédia', 'CTeSP em Gestão Financeira e Contabilidade', 'CTeSP em Gestão Hoteleira', 'CTeSP em Marketing Digital', 
	'CTeSP em Produção Gráfica e Digital', 'CTeSP em Reparação e Manutenção de Aeronaves', 'CTeSP em Turismo e Transporte Aéreo', 'Design e Produção Gráfica', 
	'Educação Básica', 'Energias Renováveis e Ambiente', 'Engenharia da Construção e da Reabilitação', 'Engenharia de Proteção Civil', 'Gestão Aeronáutica', 
	'Gestão Autárquica', 'Ótica e Optometria', 'Unidades Curriculares Isoladas (ISEC)', 'Staff']


    @selected_area_of_study = params[:area_of_study]
    @selected_tipo_ajuda = params[:tipo_ajuda]

    session[:filter_type] = params[:tipo_ajuda]
    session[:filter_area] = params[:area_of_study]
  end

  def profile
    @user = current_user
  end

  def matches
    @requests = if current_user.mentor?
                  MentorshipRequest.where(mentor_id: current_user.id)
                else
                  MentorshipRequest.where(mentee_id: current_user.id) # .where(status: ['pending', 'accepted'])

                end
  end
end
