require 'date'
class GenerateCalendar
  def initialize
    # Проверка количества аргументов
    if ARGV.length < 4
      puts "Ошибка: Недостаточно аргументов!"
      puts "Использование: ruby program.rb <файл_с_командами> <дата_начала> <дата_окончания> <выходной_файл>"
      puts "Пример: ruby program.rb teams.txt 01.08.2026 01.06.2027 calendar.txt"
      exit(1)
    end

    @teamsFile = ARGV[0]
    @date1 = Date.strptime(ARGV[1], "%d.%m.%Y")
    @date2 = Date.strptime(ARGV[2], "%d.%m.%Y")
    @outFile = ARGV[3]

    # Валидация файла с командами
    unless File.exist?(@teamsFile)
      puts "Ошибка: Файл '#{@teamsFile}' не найден!"
      exit(1)
    end

    # Проверка логики дат
    if @date1 > @date2
      puts "Ошибка: Дата начала (#{@date1}) не может быть позже даты окончания (#{@date2})!"
      exit(1)
    end

    # Проверка выходного файла
    @outFile = ARGV[3]

    # Проверка, можно ли создать/записать в выходной файл
    begin
      # Проверяем, можно ли писать в файл
      if File.exist?(@outFile) && !File.writable?(@outFile)
        puts "Ошибка: Нет прав на запись в файл '#{@outFile}'!"
        exit(1)
      end
    rescue => e
      puts "Ошибка при проверке выходного файла: #{e.message}"
      exit(1)
    end

    @teams = []
    @surface = Hash.new
    parseTeames
  end

  #Парсим данные команд с файла
  def parseTeames
    File.foreach(@teamsFile) do |line|
      lines = line.split(" — ")
      line1 = lines[0].gsub(/^\s?[0-9]{1,2}\./, "").strip
      line2 = lines[1].strip
      @teams.push(line1)
      @surface[line1] = line2
    end
  end

  #Функция для нахождения дней для проведения игр
  def good_days
    dateT = @date1
    gd_res = []
    while dateT <= @date2
      if dateT.friday? || dateT.sunday? || dateT.saturday?
        gd_res << dateT
      end
      dateT += 1
    end
    return gd_res
  end

  #Функция для генерации всех матчей со стадионами
  def allMetches
    all_mathes = []
    0.upto(@teams.length - 2) do |i|
      (i+1).upto(@teams.length - 1) do |j|
        all_mathes.push("team_home: #{@teams[i]}, team_guest: #{@teams[j]}, surface: #{@surface[@teams[i]]}")
      end
    end

    (@teams.length-1).downto(1) do |i|
      (i-1).downto(0) do |j|
        all_mathes.push("team_home: #{@teams[i]}, team_guest: #{@teams[j]}, surface: #{@surface[@teams[i]]}")
      end
    end

    return all_mathes
  end
  def generate_matches
    calendar = []
    games_inds = []
    all_games = allMetches
    times_for_games = ["12:00", "15:00", "18:00"]
    flag_break = false
    cnt_propusk = 1

    for day in good_days
      # Пропускаем каждый 27-й день
      if cnt_propusk % 27 == 0
        cnt_propusk += 1
        next
      end

      # Команды, которые уже играют в этот день
      weekend_teams = []

      # Планируем до 3 игр в день
      (0).upto(2) do |i|
        # Проверяем, все ли игры использованы
        if games_inds.length >= all_games.length
          flag_break = true
          break
        end

        # Ищем доступную игру
        available_games = []
        all_games.each_with_index do |game, index|
          # Игра еще не использована И команды не заняты в этот день
          if !games_inds.include?(index) && !weekend_teams.any? { |team| game.include?(team) }
            available_games << index
          end
        end

        if available_games.empty?
          # Нет доступных игр для этого слота
          next
        end

        # Выбираем случайную доступную игру
        ind_game_1 = available_games.sample
        games_inds.push(ind_game_1)

        # Добавляем команды в список занятых на этот день
        game = all_games[ind_game_1]
        @teams.each do |team|
          if game.include?(team)
            weekend_teams.push(team)
          end
        end

        # Формируем запись об игре
        game1 = "date: #{day}, time: #{times_for_games[i]}, #{game}"
        calendar.push(game1)
      end

      break if flag_break
      cnt_propusk += 1
    end
    return calendar
  end

  #Функция для записи календаря в файл
  def createCalendar
    File.open(@outFile, "w") do |outFile|
      for game in generate_matches
        outFile.puts game + "\n"
      end
    end
  end
end

calendar = GenerateCalendar.new
calendar.createCalendar
