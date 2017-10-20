<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
	$(document).ready(function() {
		if($("#uploadTypeId").val() == "1062"){
			document.addForm.itemLvl.readOnly  = false;
		}
	});
	
	//incentive Item Save button
	function fn_incenItemSavs(){
		if(fn_ValidIncenItem()){
			 Common.ajaxSync("GET", "/commission/calculation/incentiveItemInsert", $("#addForm").serializeJSON(), function(result) {
				fn_itemDetailSearch('0');
				$("#totalCntTxt").text(result.data.totalCnt);
				$("#totalValidTxt").text(result.data.totalValid);
				$("#totalInvalidTxt").text(result.data.totalInvalid);
				$("#cntValid").val(result.data.totalValid);
				document.addForm.reset();
				Common.alert("success");
			}); 
		}
	}
	
	//validation
	function fn_ValidIncenItem(){
		var val= true;
		 $("#itemRCd").val($("#itemRCd").val().replace(/[^0-9]/g,""));
		$("#itemLvl").val($("#itemLvl").val().replace(/[^0-9]/g,""));
		$("#itemTAmt").val($("#itemTAmt").val().replace(/[^-\.0-9]/g,'')  );  //소수점입력가능 
		
		if($("#itemMemCd").val() == null || $("#itemMemCd").val() ==""){
			Common.alert("Invalid member");
			$("#itemMemCd").focus();
			return false;
		}else{
			Common.ajaxSync("GET", "/commission/calculation/incntivMemCheck", $("#addForm").serializeJSON(), function(result) {
				alert("1. incentiveItemAddMem");
	            if(result == null){
	                Common.alert("Invalid member.");
	                $("#itemMemCd").val("");
	                $("#itemMemCd").focus();
	                val= false;
	            }else{
	                if(result.MEM_TYPE != "1" && result.MEM_TYPE != "2"){
	                    Common.alert("Invalid member type.");
	                    $("#itemMemCd").val("");
	                    $("#itemMemCd").focus();
	                    val= false;
	                }else{
	                    if(result.STUS != "1"){
	                        Common.alert("This member is not active.");
	                        $("#itemMemCd").val("");
	                        $("#itemMemCd").focus();
	                        val= false;
	                    }
	                    var valTemp = {"uploadId" : $("#uploadUserId").val(), "vStusId": 4 , "memId" : result.MEM_ID};
	                    Common.ajaxSync("GET", "/commission/calculation/cntIncntivMemCheck", valTemp, function(count) {
	                    	var cnt = count;
	                    	if(Number(cnt) > 0){
	                            Common.alert("This member is existing in the upload batch");
	                            $("#itemMemCd").val("");
	                            $("#itemMemCd").focus();
	                            val= false;
	                        }else{
	                            $("#hiddenMemberID").val(result.MEM_ID);
	                            $("#hiddenMemberTypeID").val(result.MEM_TYPE);
	                        }
	                    });
	                    
	                }
	            }
	        });
		} 
		if($("#itemTAmt").val() == null || $("#itemTAmt").val() == ""){
			Common.alert("lease key in the target amount.");
			$("#itemTAmt").focus();
			return false;
		}else{
			var amt = $("#itemTAmt").val();
			if(Number(amt) <= 0){
				Common.alert("Target amount must greater than 0.");
				$("#itemTAmt").focus();
				return false;
			}
		}
		
		if($("#itemRCd").val() == null || $("#itemRCd").val() == ""){
			Common.alert("Please key in the ref code.");
			$("#itemRCd").focus();
			return false;
		}
		if($("#uploadTypeId").val() == "1062"){
			if($("#itemLvl").val() == null || $("#itemLvl").val() == ""){
	            Common.alert("Please key in the level.");
	            $("#itemLvl").focus();
	            return false;
	        }
		}
		return val;  
	}
	
	function floatCh(obj){
       $(obj).change(function(){
           $(this).val($(this).val().replace(/[^-\.0-9]/g,'')  );  //소수점입력가능
      }); 
    }
    function numberCh(obj){
       $(obj).change(function(){
          $(this).val($(this).val().replace(/[^0-9]/g,"")); //정수만
      }); 
    }
</script>

<div id="popup_wrap" class="popup_wrap size_mid" ><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>INCENTIVE/TARGET UPLOAD BATCH - NEW ITEM</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height:150px;"><!-- pop_body start -->
	<form name="addForm" id="addForm">
		<table class="type1"><!-- table start -->
			<caption>table</caption>
			<colgroup>
				<col style="width:210px" />
				<col style="width:*" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">Member Code</th>
					<td><input type="text" id="itemMemCd" name="itemMemCd" maxlength="20"></td>
				</tr>
				<tr>
					<th scope="row">Target Amount</th>
					<td><input type="text" id="itemTAmt" name="itemTAmt" maxlength="20" onkeydown="floatCh(this);"></td>
				</tr>
				<tr>
					<th scope="row">Ref Code</th>
					<td><input type="text" id="itemRCd" name="itemRCd" maxlength="20" onkeydown="numberCh(this);"></td>
				</tr>
				<tr>
					<th scope="row">Level</th>
					<td><input type="text" id="itemLvl" name="itemLvl" readonly="readonly" maxlength="20" onkeydown="numberCh(this);"></td>
				</tr>
			</tbody>
		</table><!-- table end -->
		
		<input type="hidden" name="uploadId" id="uploadUserId" value="${uploadId }">
		<input type="hidden" name="uploadTypeId" id="uploadTypeId" value="${uploadTypeId }">
		<input type="hidden" name="hiddenMemberID" id="hiddenMemberID" >
		<input type="hidden" name="hiddenMemberTypeID" id="hiddenMemberTypeID" >
	</form>
	
	<ul class="center_btns">
		<li><p class="btn_blue"><a href="javascript:fn_incenItemSavs();">save</a></p></li>
	</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->