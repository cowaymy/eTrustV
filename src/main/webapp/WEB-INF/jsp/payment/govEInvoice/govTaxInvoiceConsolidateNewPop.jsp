<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$(document).ready(function() {
    $('.sInvBillTypeDisp').show();
    $("#sInvType").change(function() {
    	if($("#sInvType").val() == '02'){
    		$('.sInvBillTypeDisp').show();
    	}
    	else{
    		$('.sInvBillTypeDisp').hide();
    		$('#sInvBillType').val('');
    	}
    })

});

function validRequiredField(){
	var valid = true;
    var message = "";

    if($("#sInvType").val() == '' || $("#sRqtStartDt").val() == '' || $("#sRqtendDt").val() == '' || $("#sInvBillType").val() == ''){
         valid = false;
         message += 'Please select value of the selection(s)';
    }

    if($('#sRqtStartDt').val() != ''){
    	var selectedDate = $('#sRqtStartDt').val();
      	var today = new Date();
      	var thisYear = today.getFullYear();
      	var thisMonth =  today.getMonth();
      	var todayDate =  today.getDate();

      	var selectedMonth = selectedDate.split("/")[0];
      	var selectedYear = selectedDate.split("/")[1];

      	if(thisYear == selectedYear){
          	if(selectedMonth >= thisMonth) //current allowed past month, when live, only allow previous month
          	{
          		valid = false;
            	message += 'Only Past Month is allowed';
          	}
      	}
      	else{
      		if(thisMonth == 1){
      			if(selectedMonth == 12 && selectedYear == (thisYear-1)){
      			}
      			else{
              		valid = false;
                	message += 'No past or future year is allowed';
      			}
      		}else{
          		valid = false;
            	message += 'No past or future year is allowed';
      		}
      	}

//       	if(todayDate >=2 && todayDate <=7){
//       		//allow to create consolidate tax invoice
//       	}
//       	else{
//       		valid = false;
//         		message += 'Consolidate Tax Invoice can only being generate in between 2nd to 7th of each month';
//       	}
    }

    if(valid == false){
        Common.alert('<spring:message code="sal.alert.title.reportGenSummary" />' + DEFAULT_DELIMITER + message);
    }

    return valid;
}

function btnGenerate_Click(){
	if(validRequiredField() == true){
		var data = {};
	    var formList = $("#newForm").serializeArray(); //폼 데이터

	    if (formList.length > 0)
	      data.form = formList;
	    else
	      data.form = [];


	    Common.ajax("POST","/payment/einv/generateNewTaxInvConsolidateClaim.do",data,function(result) {
              var message = "";

              if (result.code == "IS_BATCH") {
                message += "<spring:message code='pay.alert.claimIsBatch' arguments='"+result.data.batchId+" ; "+
               result.data.crtUserName+" ; "+result.data.crtDt+"' htmlEscape='false' argumentSeparator=';' />";

              } else if (result.code == "FILE_OK") {
                message += "<spring:message code='pay.alert.claimFileOk' arguments='"+result.data.ctrlId+" ; "+result.data.ctrlBillAmt+" ; "+result.data.ctrlTotItm+" ; "+
                     result.data.crtUserId+" ; "+result.data.crtDt+"' htmlEscape='false' argumentSeparator=';' />";

              } else if (result.code == "FILE_FAIL") {
                message += "<spring:message code='pay.alert.claimFileFail' arguments='"+result.data.ctrlId+" ; "+result.data.ctrlBillAmt+" ; "+result.data.ctrlTotItm+" ; "+
                     result.data.crtUserId+" ; "+result.data.crtDt+"' htmlEscape='false' argumentSeparator=';' />";

              } else {
                message += "<spring:message code='pay.alert.generateFailClaimBatch'/>";
              }

              Common.alert("<b>" + message + "</b>");
              fn_getEInvListAjax();
            },function(result) {
              Common.alert("<spring:message code='pay.alert.generateFailClaimBatch'/>");
            });

	}else{
        return false;
    }
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New Consolidate E-invoice </h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="newForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
	<p style="color:red">Currently connected to STAGING url</p>
</tr>
<tr>
    <th scope="row">Invoice Type</th>
    <td>
    <select class=" w100p" id="sInvType" name="sInvType">
        <option value="">Choose one</option>
<!--         <option value="01">E-invoice</option> -->
        <option value="02">Consolidated E-invoice</option>
    </select>
    </td>
</tr>
<tr class="sInvBillTypeDisp">
    <th scope="row">Type</th>
    <td>
    <select class=" w100p" id="sInvBillType" name="sInvBillType">
        <option value="">Choose one</option>
        <option value="01">Other Invoice</option>
        <option value="02">CN/DN</option>
    </select>
    </td>
</tr>
<tr>
   <th scope="row">Invoice Date</th>
   <td>
      <div class="date_set w100p">
       <!-- date_set start -->
       <p>
        <input id="sRqtStartDt" name="sRqtStartDt" type="text"
         title="Create start Date" placeholder="MM/YYYY"
         class="j_date2" />
       </p>
      </div>
    <!-- date_set end -->
  </td>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGenerate_Click()">Generate</a></p></li>
</ul>
</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->