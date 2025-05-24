$(document).ready(function() {
  $('.star').raty({
    path: '/assets',
    scoreName: 'score',
    score: function() {
      return $(this).attr('data-score');
    }
  });
}); 