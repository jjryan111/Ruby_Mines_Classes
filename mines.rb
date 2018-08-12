class Board
 # Make
  def initialize(x,y)
    @x = x + 2
    @y = y + 2
  end

  def make_board(x,y)
    board = Array.new(x) {Array.new(y,10)}
    (1...board.length-1).each do |a|
      (1...board[0].length-1).each do |b|
          board[a][b] = 0
      end
    end
    return board
  end
  # Add mines
  def add_mines(board,num_mines)
    while num_mines > 0 do
      a = rand(1...board.length)
      b = rand(1...board[0].length)
      if board [a][b] == 0
        board[a][b] = 100
        num_mines -= 1
      end
    end


 # Store original board
 #
 @@begin_board = board
end

class Transform_Board
 # Helper function for changing the board
 def change_cell(board,x,y,add_this,threshhold,zero_list)
   (-1..1).each do |i|
     (-1..1).each do |j|
       if board[x+i][y+j] < 10
         zero_list.push(x+i)
         zero_list.push(y+j)
       end
       if board[x+i][y+j] < threshhold
         board[x+i][y+j] += add_this
       end
     end
   end
   return board, zero_list
 end

 # add hints

 def add_hints (board)
   zero_list = [0]
   (1...board.length-1).each do |i|
     (1...board[0].length-1).each do |j|
       if board[i][j] == 100
         change_cell(board,i,j,1,10,zero_list)
       end
     end
   end
   return board
 end

 # zero case
 def reveal_board(board,x,y)
   zero_list = [x,y]
   if board[x][y] == 100
   else
     while x !=nil do
       if board[x][y] < 10
         if board[x][y] == 0
           board, zero_list = change_cell(board,x,y,10,0,zero_list)
         end
         board[x][y] += 10
       end
       y = zero_list.pop()
       x = zero_list.pop()
     end
   end
 end
end

class Display_Board
 # Display game Board
 def print_game_cell(board, i, j)
   case board[i][j]
      when 10
        print " \t"
      when (11..20)
        print "#{board[i][j] - 10}\t"
      when (21..99)
        print "F\t"
      when 125
        print "F\t"
      else
        print "X\t"
      end
    end

  def print_solution_cell(board,i, j)
    case board[i][j]
    when 0
      print " \t"
    when (1..9)
      print "#{board[i][j]}\t"
    when 10
      print " \t"
    when (11..19)
      print "#{board[i][j]-10}\t"
    when (20.99)
      print "#{board[i][j]-25}\t"
    else
      print "*\t"
    end
  end

  def print_board(board,solution)
    print_board_headers(board)
    (1..board.length-2).each do |i|
      print "#{i}|\t"
    (1..board[0].length-2).each do |j|
        case solution
          when 0
            print_game_cell(board,i,j)
          when 1
            print_solution_cell(board,i,j)
          else
            puts "How did we get here?"
          end
        end
      print "\n"
    end
    print "\n"
  end

  def print_header(board)
    (1...board.length-1).each do |i|
      print "\t#{(i+64).chr}"
    end
    puts ""
    (1...board.length-1).each do |i|
      print "_________"
    end
    puts ""
  end
end
 # Reveal end game
class Game
 #
 gameboard = Board.new(5,5)


class Play
 # Make a move
 def play_flag(board,x,y,flags_on_bombs)
   zerolist = Array.new
   done = false
   while !done
     print "(P)lay or (F)lag? "
     pf = $stdin.gets.chomp.upcase
     if ["P","F"].include? pf
       done = true
       if pf == "P"
         if board[x][y] > 99
           game_end(board,false)
         else
           zerolist.push(x)
           zerolist.push(y)
           board = reveal_board(board, zerolist)
           print_board(board,0)
         end
       else
         board[x][y] += 25
         if board[x][y] == 125
           flags_on_bombs += 1
         end
         print_board(board,0)
       end
     else
       puts "Please choose p or f."
     end
   end
   return board, flags_on_bombs
 end

 #
