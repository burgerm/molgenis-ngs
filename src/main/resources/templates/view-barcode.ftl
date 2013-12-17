<#include "molgenis-header.ftl">
<#include "molgenis-footer.ftl">
<#assign css=["Barcode.css"]>
<#assign js=["Barcode.js"]>
<@header css js/>

<form method="post" class="form-horizontal" enctype="multipart/form-data" action="/menu/main/barcode/calculate">
	<div class="formscreen">
		<div style="padding:10px">
			<p>The barcode selector on this page calculates the most optimal set of barcodes to analyze your samples with.</p></br>
			<div class="control-group">
			    <label class="control-label" for="type">Select barcode type:</label>
			    <div class="controls">
					<select name="type" id="combobox" class="span2">
						<#list barcodes as t>
						  <option value="${t}">${t}</option>
						</#list>
					</select>
			    </div>
			</div>
			<div class="control-group">
			    <label class="control-label" for="type">Enter samples amount:</label>
			    <div class="controls">
					<input type="text" name="number" class="span1"/>
			    </div>
			</div>
			<div class="control-group">
			    <label class="control-label" for="type">Barcodes selected?</label>
			    <div class="controls">
					<input type="checkbox" id="havebc" class="span1"/>
			    </div>
			    <!-- Dynamically show barcode table -->
			    <div name="checkedBarcodes" id="barcode-table" >
				</div>
			</div>
			<div class="control-group">
			    <div class="controls">
			    	<button type="submit" id="calculate" class="btn btn-primary has-spinner">
				        Get optimal set
				    	<span class="spinner"><i class="icon-spin icon-refresh"></i></span>
				    </button> (depending on the amount of possibilities, this may take a while)
				</div>
			</div>
			
			<!-- dirty hardcoded table, will be removed soon -->
			<#if isException>
				<TABLE CLASS="table" STYLE="border:  1px solid #ddd;">
				<THEAD>
					<TR>
						<TH>Plexity</TH>
						<TH>Solution</TH>
						<TH>Set A only</TH>
						<TH>Set B only</TH>
					</TR>
				</THEAD>
				<TR>
					<TD>2</TD><TD>1</TD><TD>RPI 06, RPI 12</TD><TD>Not recommended</TD>
				</TR>
				<TR>
					<TD> </TD><TD>2</TD><TD>RPI 05, RPI 19</TD><TD></TD>
				</TR>
				<TR>
					<TD>3</TD><TD>1</TD><TD>RPI 02, RPI 07, RPI 19</TD><TD>RPI 01, RPI 10, RPI 20</TD>
				</TR>
				<TR>
					<TD> </TD><TD>2</TD><TD>RPI 05, RPI 06, RPI 15</TD><TD>RPI 03, RPI 09, RPI 25</TD>
				</TR>
				<TR>
					<TD> </TD><TD>3</TD><TD>2-plex solution with any other adapter</TD><TD>RPI 08, RPI 11, RPI 22</TD>
				</TR>
				<TR>
					<TD>4</TD><TD>1</TD><TD>RPI 05, RPI 06, RPI 12, RPI 19</TD><TD>RPI 01, RPI 08, RPI 10, RPI 11</TD>
				</TR>
				<TR>
					<TD> </TD><TD>2</TD><TD>RPI 02, RPI 04, RPI 7, RPI 16</TD><TD>RPI 03, RPI 09, RPI 22, RPI 27</TD>
				</TR>
				<TR>
					<TD> </TD><TD>3</TD><TD>3-plex solution with any other adapter</TD><TD>3-plex solution with any other adapter</TD>
				</TR>
				</TABLE>
			<#else> 
				<!-- The resulting combinations --> 
				<#if 0 < optimalCombinations?size>
					<h3>Result</h3>
					<p>We have found ${optimalCombinations?size} optimal set(s) of ${currentNumber} barcodes. Within each set each barcode-pair differs with at least ${minimumDistance} nucleotides, and on average with ${averageDistance} nucleotides.</p>
					<#list optimalCombinations as combination>
						Solution number ${combination_index + 1}:
						<table class="table" style="width: 1%; border:  1px solid #ddd;">
							<#list combination as bc>
								<tr>
									<#list bc as b>
										<td style="font-family:monospace;">${b}</td>
									</#list>
								</tr>
							</#list>
						</table>
					</#list>
				</#if>
			</#if>				
		</div>
	</div>
</form>
<@footer/>