
class FourInARow
  def initialize(rows, columns)
    if (rows - columns).abs > 2
      raise "Number of rows and columns must not differ by more than 2"
    end

    @board = Array.new(rows) { Array.new(columns, ' ') }
    @current_player = :red
    @moves = { red: [], yellow: [] }
  end

  def play
    loop do
      print_board
      puts "Player #{@current_player}, enter a column number (1-#{@board[0].size}):"
      column = gets.to_i - 1
      @moves[@current_player] << column

      row = drop_piece(column)
      if check_win(row, column)
        print_board
        puts "Player #{@current_player} wins!"
        print "Do you want to save the game? (y/n):"
        answer = gets.strip
        save_moves if answer == 'y'
        break
      elsif @board.flatten.none?(' ')
        print_board
        puts "It's a tie!"
        break
      end

def save_moves
    File.open("moves.txt", "w") { |f| f.puts @moves }
  end

  def load_moves
    print "Do you want to load the game? (y/n): "
    answer = gets.strip
    if answer == 'y'
      @moves = eval(File.read("moves.txt"))
      @current_player = :red
    end
  end



      @current_player = @current_player == :red ? :yellow : :red
    end

    puts "Moves: Red - #{@moves[:red].join(', ')}, Yellow - #{@moves[:yellow].join(', ')}"
  end

  private

  def print_board
    @board.each do |row|
      puts row.map { |cell| cell == ' ' ? '-' : cell }.join(' | ')
      puts '-' * (@board[0].size * 4 - 1)
    end
  end

  def drop_piece(column)
    (0...@board.size).reverse_each do |i|
      if @board[i][column] == ' '
        @board[i][column] = @current_player
        return i
      end
    end

    raise "Column is full"
  end

  def check_win(row, column)
    # Check horizontal win
    @board[row].each_cons(4).any? { |a, b, c, d| a == b && b == c && c == d && a != ' ' } ||
      # Check vertical win
      @board.transpose[column].each_cons(4).any? { |a, b, c, d| a == b && b == c && c == d && a != ' ' } ||
      # Check diagonal win
      (0...@board.size).each_cons(4).any? { |a, b, c, d| @board[a][b] == @board[b][c] && @board[b][c] == @board[c][d] && @board[c][d] == @board[d][a] && @board[a][b] != ' ' }
  end
end


print "Enter number of rows: "
rows = gets.to_i
print "Enter number of columns: "
columns = gets.to_i

FourInARow.new(rows, columns).play
