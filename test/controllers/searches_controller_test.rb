require 'test_helper'

class SearchesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @member = Member.create(name: 'matheus',
                          email: 'matheus@gmail.com',
                          password: '123456',
                          password_confirmation: '123456',
                          alias: 'mateusin')
    room = @member.my_rooms.create!(name: 'Humanidade e Cidadania', description: 'Professora Sônia Albuquerque')
    room2 = @member.my_rooms.create!(name: 'Fundamentos de Sistemas Distribuidos', description: 'Professor Fernando W. Cruz')
    room3 = @member.my_rooms.create!(name: 'Integração e Desempenho', description: 'Palestrante José Joaquim')
    room4 = @member.my_rooms.create!(name: 'Desenho de Software', description: 'Palestrante José Joaquim')
    room5 = @member.my_rooms.create!(name: 'Testes de Software', description: 'Palestrante José Joaquim')
    top = room.topics.create(name: "O futuro do Planeta Terra", description: "Discuta aqui sobre medidadas para ajudar o mundo!")
    top1 = room2.topics.create(name: "RPC em softwares distribuídos", description: "Palestra do professor Jão Carlos")
    top2 = room3.topics.create(name: "Linguagens de baixo nível em aplicações de software", description: "Soluções para o problema de energia do futuro!")
    top3 = room4.topics.create(name: "Padrões de projeto em softwares", description: "Soluções para o problema de energia do futuro!")
    top4 = room5.topics.create(name: "Testes de controller e de model", description: "Soluções para o problema de energia do futuro!")
    sign_in_as @member
  end

  test "should not search if not logged in" do
    sign_out_as @member
    get search_url, params: { query: "oi"}
    assert_redirected_to root_path
  end

  test "should return correct number of items in search" do
    get search_url, params: { query: "Software"}

    assert_response :success
    assert_equal 2, assigns(:rooms).count
    assert_equal 3, assigns(:topics).count
  end

  test "downcase should not make a difference in search" do
    get search_url, params: { query: "software" }

    assert_response :success
    assert_equal 2, assigns(:rooms).count
    assert_equal 3, assigns(:topics).count
  end

  test "upcase should not make a difference in search" do
    get search_url, params: { query: "SOFTWARE" }

    assert_response :success
    assert_equal 2, assigns(:rooms).count
    assert_equal 3, assigns(:topics).count
  end

end
