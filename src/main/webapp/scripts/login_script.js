const errorContainer = document.getElementById('err-msg');

const inputs = document.querySelectorAll("input");

inputs.forEach(input => {
    input.addEventListener("input", function() {
			console.log(input)
        if (errorContainer) {
          errorContainer.innerHTML = "";
        }
    });
});