<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
CommonCombo.make('branch', "/sales/pos/selectWhSOBrnchList", '' ,'', {type: 'M'});

var date = new Date().getDate();
var month = new Date().getMonth() + 1;

date  = date.toString().length  == 1 ? "0"  + date : date;
month = month.toString().length == 1 ? "0" + month : month;

$("#transactionDate").val(date+"/"+month+"/"+new Date().getFullYear());

$('.multy_select').change(function() {
})
.multipleSelect({
   width: '100%',
}).multipleSelect("checkAll");

function btnGenerate_Excel_Click(){
	fn_report();
}

function fn_report(){
	var runNo = 0;

	if($("#branch").val() == null){
        Common.alert("* Please select branch.");
        return;
    } else {
        let branchList = "";
        $('#branch :selected').each(function(i, mul){
            if(runNo > 0){
                branchList += ",'"+$(mul).val()+"'";
            }else{
                branchList += "'"+$(mul).val()+"'";
            }
            runNo += 1;
        });

        $("#V_BRANCHLIST").val(branchList);
    }
    runNo = 0;

	if(FormUtil.isEmpty($("#transactionDate").val())){
		Common.alert("* Please select transaction date.");
        return;
	}else{
		let dateParts = $("#transactionDate").val().split("/");
		$("#V_DATE").val(dateParts[2] + "/" + dateParts[1] + "/" + dateParts[0]);
	}

	if($("#category").val() == null){
		Common.alert("* Please select category.");
		return;
    } else {
    	let categoryList = "";
		$('#category :selected').each(function(i, mul){
			if(runNo > 0){
				categoryList += ",'"+$(mul).val()+"'";
			}else{
				categoryList += "'"+$(mul).val()+"'";
			}
			runNo += 1;
		});

		$("#V_STKCTGRYLIST").val(categoryList);
	}
	runNo = 0;

	var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    $("#reportDownFileName").val("POS_StockCardRaw_"+date+month+new Date().getFullYear());

    var option = {
            isProcedure : true
    };

    console.log($("#form").serialize());
    Common.report("form", option);

}

</script>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1> Stock Card</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="gridform" name="gridform">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:250px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Branch/Warehouse</th>
        <td>
            <select class="multy_select w100p" id="branch" name="branch"  ></select>
        </td>
</tr>
<tr>
<th scope="row">Transaction Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="transactionDate"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
<th scope="row">Category</th>
    <td >
            <select class=" multy_select w100p" id="category" name="category" multiple>
                <option value="1346">Merchandise Item</option>
                <option value="1348">Misc Item</option>
                <option value="1347">Uniform</option>
            </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:btnGenerate_Excel_Click();"><spring:message code="sal.btn.genExcel" /></a></p></li>
</ul>
</form>

<form action="#" method="post" id="form" name="form">
<input type="hidden" id="reportFileName" name="reportFileName" value="/sales/POSStockCardRaw.rpt" />
<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_DATE" name="V_DATE" value="" />
<input type="hidden" id="V_BRANCHLIST" name="V_BRANCHLIST" value="" />
<input type="hidden" id="V_STKCTGRYLIST" name="V_STKCTGRYLIST" value="" />
</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->