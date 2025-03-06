// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

document.addEventListener("turbo:load", function() {
    const menu = document.getElementById("menu");
    const button = document.getElementById("hamburger-button");
  
    button.addEventListener("click", function() {
      menu.classList.toggle("hidden"); // hidden クラスを切り替え
    });
});