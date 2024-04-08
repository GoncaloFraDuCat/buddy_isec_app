// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "@rails/actioncable";

function appHeight() {
  const doc = document.documentElement;
  // Multiplied by 0.01 to get a percentage value
  doc.style.setProperty("--vh", window.innerHeight * 0.01 + "px");
}

window.addEventListener("resize", appHeight);
appHeight();
