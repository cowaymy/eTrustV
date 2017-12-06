<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
$(document).ready(function(){      
	
	CommonCombo.make("branch", "/sales/trBook/selectBranch", "", "", {
        id: "code",
        name: "name"
    });
	
	CommonCombo.make("courier", "/sales/trBook/selectCourier", "", "", {
        id: "curierCode",
        name: "curierName"
    });
});


function fn_tranSingleSave(){
	
     if ($("#branch").val() == "" || $("#courier").val() == "")
     {
    	 $("#msg").html("* Some required fields are empty.");
    	 $("#msg").attr("style", "color:red");
    	 return false;
     }
     
     Common.ajax("POST", "/sales/trBook/saveTranSingle", $("#saveForm").serializeJSON(), function(result) {
         
         console.log("성공.");
         console.log( result);        

         if(result.saveYn == "N"){

             $("#msg").attr("style", "color:red");
         }else{

             $("#msg").attr("style", "color:green");
         }
         $("#msg").html("* This book has successfully transfer out to courier.");
         $("#btnSave").hide();
         
    },
    function(jqXHR, textStatus, errorThrown){
         try {
             console.log("Fail Status : " + jqXHR.status);
             console.log("code : "        + jqXHR.responseJSON.code);
             console.log("message : "     + jqXHR.responseJSON.message);
             console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
             }
         catch (e)
         {
           console.log(e);
         }
         alert("Fail : " + jqXHR.responseJSON.message);

         $("#msg").attr("style", "color:red");
         $("#msg").html("* Failed to save. Please try again later.");
     });
          
}

</script>
<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>TRANSFER TR BOOK</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post" id="saveForm" name="saveForm">
<input type="hidden" id="tranTrBookId" name="tranTrBookId" value="${trBookId}">
<input type="hidden" id="tranHolder" name="tranHolder" value="${detailInfo.trHolder}">
<span id="msg"> </span>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">TR Book No</th>
	<td>${detailInfo.trBookNo}</td>
</tr>
<tr>
	<th scope="row">TR Prefix No</th>
	<td>${detailInfo.trBookPrefix}</td>
</tr>
<tr>
	<th scope="row">No of Page(s)</th>
	<td>${detailInfo.trBookPge}</td>
</tr>
<tr>
	<th scope="row">TR No</th>
	<td>${detailInfo.trBookNoStart} To ${detailInfo.trBookNoEnd}</td>
</tr>
<tr>
	<th scope="row">TR Book Holder</th>
	<td> ${detailInfo.trHolder}</td>
</tr>
<tr>
	<th scope="row"><span class="must">*</span>Transfer To</th>
    <td>
        <select class=" w100p"  id="branch" name="branch">
        </select>
    </td>
</tr>
<tr>
	<th scope="row"><span class="must">*</span>Courier</th>
    <td>
        <select class=" w100p"  id="courier" name="courier">
        </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" id="btnSave" onclick="javascript:fn_tranSingleSave();">SAVE</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->