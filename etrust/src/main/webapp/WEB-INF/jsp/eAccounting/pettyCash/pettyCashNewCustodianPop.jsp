<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
	setInputFile2();
	
	$("#supplier_search_btn").click(fn_supplierSearchPop);
    $("#costCenter_search_btn").click(fn_costCenterSearchPop);
	$("#save_btn").click(fn_saveNewCustodian);
    $("#clear_btn").click(fn_clearData);
    
    $("#appvCashAmt").keydown(function (event) { 
        
        var code = window.event.keyCode;
        
        if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
        {
         window.event.returnValue = true;
         return;
        }
        window.event.returnValue = false;
        
   });
   
   $("#appvCashAmt").click(function () { 
       var str = $("#appvCashAmt").val().replace(/,/gi, "");
       $("#appvCashAmt").val(str);      
  });
   $("#appvCashAmt").blur(function () { 
       var str = $("#appvCashAmt").val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
       $("#appvCashAmt").val(str);      
  });
   
    $("#appvCashAmt").change(function(){
       var str =""+ Math.floor($("#appvCashAmt").val() * 100)/100;
       
       var str2 = str.split(".");
      
       if(str2.length == 1){
           str2[1] = "00";
       }
       
       if(str2[0].length > 20){
    	   Common.alert("The amount can only be 20 digits, including 2 decimal point.");
           str = "";
       }else{
           str = str2[0].substr(0, 11)+"."+str2[1];
       }
       str = str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
       
       
       $("#appvCashAmt").val(str);
   }); 
});

/* 인풋 파일(멀티) */
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}

function fn_setCostCenter() {
    $("#newCostCenter").val($("#search_costCentr").val());
    $("#newCostCenterText").val($("#search_costCentrName").val());
}

function fn_setSupplier() {
    $("#newMemAccId").val($("#search_memAccId").val());
    $("#newMemAccName").val($("#search_memAccName").val());
    $("#bankCode").val($("#search_bankCode").val());
    $("#bankName").val($("#search_bankName").val());
    $("#bankAccNo").val($("#search_bankAccNo").val());
    
    // USER_NRIC GET
    Common.ajax("POST", "/eAccounting/pettyCash/selectUserNric.do", {memAccId:$("#search_memAccId").val()}, function(result) {
        console.log(result);
        $("#custdnNric").val(result.data.userNric);
    });
}

function fn_saveNewCustodian() {
	if(fn_checkEmpty()){
		Common.popupDiv("/eAccounting/pettyCash/newRegistMsgPop.do", null, null, true, "registMsgPop");
	}
}

function fn_clearData() {
	$("#form_newCustdn").each(function() {
		this.reset();
	});
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New Custodian</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" enctype="multipart/form-data" id="form_newCustdn">
<input type="hidden" id="newCostCenter" name="costCentr">
<input type="hidden" id="newMemAccId" name="memAccId">
<input type="hidden" id="bankCode" name="bankCode">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Cost Center</th>
	<td><input type="text" title="" placeholder="" class="" style="width:150px" id="newCostCenterText" name="costCentrName"/><a href="#" class="search_btn" id="costCenter_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a><label><input type="checkbox" id="headDeptFlag" name="headDeptFlag" value="Y"/><span>HQ Depart.</span></label></td>
	<th scope="row">Creator</th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="newCrtUserId" name="crtUserId" value="${userId}"/></td>
</tr>
<tr>
	<th scope="row">Custodian</th>
	<td><input type="text" title="" placeholder="" class="" id="newMemAccName" name="memAccName" /><a href="#" class="search_btn" id="supplier_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">IC No / Passport No</th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="custdnNric" name="custdnNric"/></td>
</tr>
<tr>
	<th scope="row">Bank</th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankName" name="bankName"/></td>
	<th scope="row">Bank Account</th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="bankAccNo" name="bankAccNo"/></td>
</tr>
<tr>
	<th scope="row">Approved cash amount (RM)</th>
	<td colspan="3"><input type="text" title="" placeholder="" class="" id="appvCashAmt" name="appvCashAmt"/></td>
</tr>
<tr>
	<th scope="row">Attachment</th>
	<td colspan="3">
	<div class="auto_file2"><!-- auto_file start -->
	<input type="file" title="file add" />
	</div><!-- auto_file end -->
	</td>
</tr>
<tr>
	<th scope="row">Remark</th>
	<td colspan="3"><textarea cols="20" rows="5" id="custdnRem" name="custdnRem"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
 	<li><p class="btn_blue2"><a href="#" id="save_btn">Save</a></p></li>
	<li><p class="btn_blue2"><a href="#" id="clear_btn">Clear</a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->