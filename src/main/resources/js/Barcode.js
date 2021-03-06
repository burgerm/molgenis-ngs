(function($, molgenis, w) {

	var restApi = new molgenis.RestClient();
	
	function hrefToId (href){
		return href.substring(href.lastIndexOf('/') + 1); 
	}
	
	function createSampleBarCodeTable(listOfSampleBarCodes, visibleColumns){
		var tableContainer = $('<table class="table table-striped"></table>');
		if(listOfSampleBarCodes.length > 0){
			var firstBarCode = listOfSampleBarCodes[0];
			//Collect column headers from the first object
			var columnHeaders =[];
			$.each(firstBarCode, function(key, value){
				columnHeaders.push(key);
			});
			
			if(visibleColumns === undefined || visibleColumns === null || visibleColumns.length === 0){
				visibleColumns = columnHeaders;
			}
			visibleColumns.splice(0, 0, 'selected');
			var tableHeader = $('<tr />');
			$.each(visibleColumns, function(index, value){
				tableHeader.append('<th>' + value + '</th>');
			});
			tableContainer.append(tableHeader);
			//fill table
			$.each(listOfSampleBarCodes, function(i, sampleBarCode){
				var newRow = $('<tr />');
				var value = hrefToId(sampleBarCode.href);
				var checkBox = $('<input name="barcodes" type="checkbox" value="' + value + '" />');
				$('<td />').append(checkBox).appendTo(newRow);
				$.each(visibleColumns, function(j, field){
					if(sampleBarCode[field]){
						newRow.append('<td>' + sampleBarCode[field] + '</td>');
					}else if(field !== 'selected'){
						newRow.append('<td></td>');
					}
				});
				tableContainer.append(newRow);
			});
			//show table
			$('#barcode-table').append(tableContainer).show();
		}
	}
	
	function showBarcodes(){
		var checkBox = $('#havebc');
		if (checkBox.attr('checked')) // show barcode table
		{
			var myNode = $('#barcode-table');
			myNode.empty();
			//example for searching the restApi on id
			//restApi.get('/api/v1/samplebarcode/3602');
			var results = restApi.get('/api/v1/samplebarcodetype', null, { // the use of this hardcoded uri seems wrong
				q : [{
					field : 'SampleBarcodeTypeName',
					operator : 'EQUALS',
					value : $('#combobox').val()
				}],
			});
			if(results.items.length > 0){
				var sampleBarCodeName = results.items[0];
				var sampleCodeNameId = hrefToId(sampleBarCodeName.href);
				var testSampleCodes = restApi.get('/api/v1/samplebarcode', ['sampleBarcodeType'], {
					q : [{
						field : 'sampleBarcodeType',
						operator : 'EQUALS',
						value : sampleCodeNameId
					}]
				});
				createSampleBarCodeTable(testSampleCodes.items, ['sampleBarcodeNr', 'sampleBarcodeSequence']);
			}
		}
		else //clear table
		{
			$('#barcode-table').hide();
		}
	}
	
	$(document).ready(function() {
		//show barcode table when checkbox is checked
		$('#havebc').click(function() {
			showBarcodes();
		});
		
		//turn on the spinner when pushing the button and turn it off when the result returns 
	    $('a, button').click(function() {
	        $(this).toggleClass('active');
	    });
	});
}($, window.top.molgenis = window.top.molgenis || {}, window.top));