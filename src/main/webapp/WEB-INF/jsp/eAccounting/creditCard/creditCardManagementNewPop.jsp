<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function () {
    setInputFile2();
    
    $("#holder_search_btn").click(function() {
        clickType = "newHolder";
        fn_searchUserIdPop();
    });
    $("#charge_search_btn").click(function() {
        clickType = "newCharge";
        fn_searchUserIdPop();
    });
    $("#costCenter_search_btn").click(fn_popCostCenterSearchPop);
    $("#save_btn").click(fn_saveNewMgmt);
    
    $("#crditCardNoTd").keydown(function (event) { 
        
        var code = window.event.keyCode;
        
        if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
        {
         window.event.returnValue = true;
         return;
        }
        window.event.returnValue = false;
        
   });
    
    $("#appvCrditLimit").keydown(function (event) { 
        
        var code = window.event.keyCode;
        
        if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
        {
         window.event.returnValue = true;
         return;
        }
        window.event.returnValue = false;
        
   });
   
   $("#appvCrditLimit").click(function () { 
       var str = $("#appvCrditLimit").val().replace(/,/gi, "");
       $("#appvCrditLimit").val(str);      
  });
   $("#appvCrditLimit").blur(function () { 
       var str = $("#appvCrditLimit").val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
       $("#appvCrditLimit").val(str);      
  });
   
    $("#appvCrditLimit").change(function(){
       var str =""+ Math.floor($("#appvCrditLimit").val() * 100)/100;
       
       var str2 = str.split(".");
      
       if(str2.length == 1){
           str2[1] = "00";
       }
       
       if(str2[0].length > 11){
           Common.alert("The amount can only be 13 digits, including 2 decimal point.");
           str = "";
       }else{
           str = str2[0].substr(0, 11)+"."+str2[1];
       }
       str = str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
       
       
       $("#appvCrditLimit").val(str);
   });
    
    CommonCombo.make("bankCode", "/eAccounting/creditCard/selectBankCode.do", null, "", {
        id: "code",
        name: "name",
        type:"S"
    });
});

/* 인풋 파일(멀티) */
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}

function fn_saveNewMgmt() {
    if(fn_checkEmpty()){
	console.log("Action");
        Common.popupDiv("/eAccounting/creditCard/newRegistMsgPop.do", null, null, true, "registMsgPop");
    }
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New Registration</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" enctype="multipart/form-data" id="form_newMgmt">
<input type="hidden" id="newCrditCardUserId" name="crditCardUserId">
<input type="hidden" id="newChrgUserId" name="chrgUserId">
<input type="hidden" id="newCostCenter" name="costCentr">

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
	<th scope="row">Credit cardholder name</th>
	<td><input type="text" title="" placeholder="" class="" id="newCrditCardUserName" name="crditCardUserName"/><a href="#" class="search_btn" id="holder_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">Credit card no.</th>
	<td id="crditCardNoTd"><input type="text" title="" placeholder="" class="w23_5p" maxlength="4" id="crditCardNo1" name="crditCardNo1"/> <input type="password" title="" placeholder="" class="w23_5p" maxlength="4" id="crditCardNo2" name="crditCardNo2"/> <input type="password" title="" placeholder="" class="w23_5p" maxlength="4" id="crditCardNo3" name="crditCardNo3"/> <input type="text" title="" placeholder="" class="w23_5p" maxlength="4" id="crditCardNo4" name="crditCardNo4"/></td>
</tr>
<tr>
	<th scope="row">Person-in-charge name</th>
	<td><input type="text" title="" placeholder="" class="" id="newChrgUserName" name="chrgUserName"/><a href="#" class="search_btn" id="charge_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">Person-in-charge department</th>
	<td><input type="text" title="" placeholder="" class="" id="newCostCenterText" name="costCentrName"/><a href="#" class="search_btn" id="costCenter_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row">Issue Bank</th>
	<td>
		<select class="multy_select" id="bankCode" name="bankCode"></select>
	</td>
	<th scope="row">Card Type</th>
	<td>
		<select class="multy_select" id="crditCardType" name="crditCardType">
		<option value="CC">Credit Card</option>
		<option value="DC">Debit Card</option>
		</select>
	</td>
</tr>
<tr>
	<th scope="row">Approved credit limit</th>
	<td><input type="text" title="" placeholder="" class="w100p" id="appvCrditLimit" name="appvCrditLimit"/></td>
	<th scope="row">Expiry Date</th>
	<td><input type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" id="crditCardExprDt" name="crditCardExprDt"/></td>
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
	<td colspan="3"><textarea class="w100p" rows="2" style="height:auto" id="crditCardRem" name="crditCardRem"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="save_btn">Save</a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->