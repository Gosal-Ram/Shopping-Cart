$(document).ready(function () {
	$('#orderItemsSearch').on('input', function () {
		var searchText = $(this).val().toLowerCase();
		$('.orderContainer').each(function () {
			var orderText = $(this).text().toLowerCase();
			$(this).toggle(orderText.includes(searchText));  
		});
	});
});