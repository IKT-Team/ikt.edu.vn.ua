$(document).on('change', 'input[type="file"][data-accept-names]', function () {
  this.setCustomValidity('');
  var acceptNames = JSON.parse(this.dataset.acceptNames);
  if (this.files && this.files.length == 1 && Array.isArray(acceptNames)) {
    var name = this.files[0].name;
    if (acceptNames.every(function (v) { return v != name; })) {
      var accepted = acceptNames.map(function (v) { return '"' + v + '"'; }).join(', ');
      var error = '"' + name + '" Не допустима назва файлу. Очікується ' + accepted + '.';
      this.setCustomValidity(error);
      alert(error);
    }
  }
});
