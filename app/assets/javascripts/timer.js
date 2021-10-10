var datetime = {
  element: undefined,
  gmt: 3,
  offset: 0,
  width: function (val) {
    var str = new String(val);
    return str.length == 2 ? str : '0' + str;
  },
  update: function () {
    var time = Math.round(((new Date()).valueOf() + this.offset) / 1000);
    var si = time % 60;
    var mi = parseInt(time / 60) % 60;
    var hi = parseInt(time / 3600 + this.gmt) % 24;
    this.element.innerHTML = this.width(hi) + ':' + this.width(mi) + ':' + this.width(si);
  },
  synchronize: function () {
    var self = this;
    var t0 = (new Date()).valueOf();
    $.ajax({
      url: '/timer',
      success: function (data) {
        var t1 = parseFloat(data) * 1000;
        var t3 = (new Date()).valueOf();
        self.offset = ((t1 - t0) + (t1 - t3)) / 2;
      }
    });
  }
};

$(document).ready(function () {
  datetime.element = document.getElementById('time');
  datetime.synchronize();
  setInterval(function () { datetime.update(); }, 1000);
  setInterval(function () { datetime.synchronize(); }, 60000);
});
