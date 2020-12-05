def binary_space_partitioning code
  def inner_loop str, row_acc, col_acc, i
    if i == str.length
      [row_acc.first, col_acc.first]
    else
      bin = str[i]
      row_mid = (row_acc[0] + row_acc[1]) / 2
      col_mid = (col_acc[0] + col_acc[1]) / 2
      case bin
      when 'F'
        new_row_acc = [row_acc[0], row_mid]
        puts "F #{new_row_acc.inspect}" if LOGGING
        inner_loop str, new_row_acc, col_acc, i+1
      when 'B'
        new_row_acc = [row_mid+1, row_acc[1]]
        puts "B #{new_row_acc.inspect}" if LOGGING
        inner_loop str, new_row_acc, col_acc, i+1
      when 'L'
        new_col_acc = [col_acc[0], col_mid]
        puts "L #{new_col_acc.inspect}" if LOGGING
        inner_loop str, row_acc, new_col_acc, i+1
      when 'R'
        new_col_acc = [col_mid+1, col_acc[1]]
        puts "R #{new_col_acc.inspect}" if LOGGING
        inner_loop str, row_acc, new_col_acc, i+1
      end
    end
  end

  inner_loop code, [0, 127], [0, 7], 0
end

def seat_id row, col
  row * 8 + col
end