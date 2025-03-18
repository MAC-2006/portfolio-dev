let wins = 0, losses = 0, ties = 0;
const choices = ['pedra', 'papel', 'tesoura'];

function playGame(userChoice) {
    let computerChoice = choices[Math.floor(Math.random() * choices.length)];
    let result = '';
    
    if (userChoice === computerChoice) {
        result = 'Empate!';
        ties++;
    } else if (
        (userChoice === 'pedra' && computerChoice === 'tesoura') ||
        (userChoice === 'papel' && computerChoice === 'pedra') ||
        (userChoice === 'tesoura' && computerChoice === 'papel')
    ) {
        result = 'Você venceu!';
        wins++;
    } else {
        result = 'Você perdeu!';
        losses++;
    }
    
    document.getElementById('result').textContent = `Você escolheu ${userChoice}. O computador escolheu ${computerChoice}. ${result}`;
    document.getElementById('wins').textContent = wins;
    document.getElementById('losses').textContent = losses;
    document.getElementById('ties').textContent = ties;
}
