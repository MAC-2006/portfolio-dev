let display = document.getElementById("display");
let historyList = document.getElementById("history");

function appendToDisplay(value) {
    display.value += value;
}

function clearDisplay() {
    display.value = "";
}

function calculate() {
    try {
        let result = eval(display.value);
        addToHistory(display.value + " = " + result);
        display.value = result;
    } catch {
        display.value = "Erro";
    }
}

function addToHistory(operation) {
    let li = document.createElement("li");
    li.textContent = operation;
    historyList.appendChild(li);
}
