import 'dart:io';

void main() {
  // رسالة ترحيبية عند بدء البرنامج
  print('🎮 Welcome to Tic-Tac-Toe!');

  // حلقة اللعبة الرئيسية (تسمح بإعادة اللعب)
  while (true) {
    playGame(); // بدء جولة جديدة

    // السؤال عن إعادة اللعب
    print('\nWould you like to play again? (y/n)');
    final playAgain = stdin.readLineSync()?.trim().toLowerCase();
    if (playAgain != 'y') {
      print('Thanks for playing! Goodbye 👋');
      break; // إنهاء البرنامج إذا كانت الإجابة غير 'y'
    }
  }
}

void playGame() {
  // تهيئة لوحة اللعب (خلايا من 1 إلى 9)
  List<String> board = List.generate(9, (index) => (index + 1).toString());
  String currentPlayer = 'X'; // اللاعب الحالي (يبدأ بـ X)
  bool gameWon = false; // حالة الفوز
  int moveCount = 0; // عدد الحركات المتبقية

  print('\nNew game started!');
  print('Player 1: X | Player 2: O');
  print('Enter a number (1-9) to place your mark.\n');

  // حلقة الجولة الواحدة (تستمر حتى فوز أو تعادل)
  while (!gameWon && moveCount < 9) {
    displayBoard(board); // عرض اللوحة الحالية

    // الحصول على حركة صالحة من اللاعب
    int move = getValidMove(board, currentPlayer);
    board[move - 1] = currentPlayer; // تحديث اللوحة
    moveCount++; // زيادة عدد الحركات

    // التحقق من الفوز
    if (checkWin(board, currentPlayer)) {
      displayBoard(board);
      print('🎉 Player $currentPlayer wins!');
      gameWon = true;
    }
    // التحقق من التعادل
    else if (moveCount == 9) {
      displayBoard(board);
      print('🤝 It\'s a draw!');
    }

    // تبديل اللاعب
    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
  }
}

/**
 * دالة للحصول على حركة صالحة من اللاعب
 * تأكد من أن الإدخال رقم بين 1-9 وأن الخلية غير محجوزة
 */
int getValidMove(List<String> board, String player) {
  while (true) {
    stdout.write('Player $player, enter your move (1-9): ');
    final input = stdin.readLineSync()?.trim();

    // حالة الإدخال الفارغ
    if (input == null || input.isEmpty) {
      print('❌ Empty input. Please enter a number.');
      continue;
    }

    // محاولة تحويل الإدخال إلى رقم
    final move = int.tryParse(input);

    // حالة الإدخال غير الرقمي
    if (move == null) {
      print('❌ "$input" is not a valid number.');
      continue;
    }

    // حالة الرقم خارج النطاق (1-9)
    if (move < 1 || move > 9) {
      print('❌ Number must be between 1 and 9.');
      continue;
    }

    // حالة الخلية المحجوزة مسبقاً
    if (board[move - 1] != move.toString()) {
      print('❌ Cell $move is already taken.');
      continue;
    }

    // إذا مرت جميع الشروط، إرجاع الحركة الصالحة
    return move;
  }
}

/**
 * دالة لعرض لوحة اللعب بشكل منظم
 */
void displayBoard(List<String> board) {
  print('\n ${board[0]} │ ${board[1]} │ ${board[2]} ');
  print('───┼───┼───');
  print(' ${board[3]} │ ${board[4]} │ ${board[5]} ');
  print('───┼───┼───');
  print(' ${board[6]} │ ${board[7]} │ ${board[8]} \n');
}

/**
 * دالة للتحقق من وجود فائز
 * تتحقق من جميع أنماط الفوز الممكنة (8 أنماط)
 */
bool checkWin(List<String> board, String player) {
  const winPatterns = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // خطوط أفقية
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // خطوط عمودية
    [0, 4, 8], [2, 4, 6], // خطوط قطرية
  ];

  // التحقق إذا كان أي نمط من أنماط الفوز متحققاً
  return winPatterns.any(
    (pattern) =>
        board[pattern[0]] == player &&
        board[pattern[1]] == player &&
        board[pattern[2]] == player,
  );
}
