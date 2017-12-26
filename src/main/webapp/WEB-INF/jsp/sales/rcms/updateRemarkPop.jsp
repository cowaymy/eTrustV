<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">


var packageInfo={};

$(document).ready(function(){
    $("#sensitiveFg").val("0");

    fn_selectAjax();
   
});

//리스트 조회.
function fn_selectAjax() {       
	
	Common.ajax("GET", "/sales/rcms/selectRcmsInfo", {orderNo: $("#orderNo").val() }, function(result) {
		
	     console.log(result);
	     
	     $("#remark").val(result.data.rem);  
	     $("#popOrderNo").val(result.data.salesOrdNo);  
	     $("#popOrdId").val(result.data.salesOrdId);
	     
	     if(result.data.sensitiveFg == "1"){
             $("#sensitiveFg").val(result.data.sensitiveFg);
             $("#sensitiveFg").attr("checked","checked");
         }

	});
}


function fn_chk(){
	if($("input:checkbox[id='sensitiveFg']").is(":checked")){
		$("#sensitiveFg").val("1");
	}else{
        $("#sensitiveFg").val("0");
	}
}

function fn_save(){
		
    Common.ajax("POST", "/sales/rcms/updateRemark", $("#saveForm").serializeJSON(), function(result) {
        
           Common.alert("Success To Saved "+DEFAULT_DELIMITER + "RCMS item successfully saved.");

           $("#updateRemarkPop").remove();
           
           fn_selectListAjax();
           
       }, function(jqXHR, textStatus, errorThrown) {
    	   
           console.log("실패하였습니다.");
           console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
           
           Common.alert("Failed To Save "+DEFAULT_DELIMITER + "Failed to save. Please try again later.");

           console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
           
       }); 
	
}

</script>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>EDIT RCMS Remark</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="saveForm" name="saveForm">
    <input type="hidden" id="popOrdId" name="salesOrdId" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:100px" />
	<col style="width:*" />
	<col style="width:100px" />
	<col style="width:*" />
</colgroup>
<tbody>         
<tr>
	<th scope="row">Order No.</span></th>
	<td><input type="text" title="" class="readonly" readonly="readonly" style="width: 100%" id="popOrderNo"  name="popOrderNo"/></td>
	<th scope="row">Sensitive<span class="must"></span></th>
	<td><input type="checkbox"  id="sensitiveFg"  name="sensitiveFg" onclick="fn_chk()"/></td>
</tr>
<tr>
    <th scope="row">Remark </th>
    <td colspan="3"> <textarea cols="20" rows="5" id='remark'  name='remark' placeholder="Remark" name='remark'></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" id='savebt'   onclick="javascript:fn_save()">Save</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->