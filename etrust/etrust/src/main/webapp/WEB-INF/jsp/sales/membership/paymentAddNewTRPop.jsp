
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">


$(document).ready(function(){
	
     
       //j_date
        var pickerOpts={
                changeMonth:true,
                changeYear:true,
                dateFormat: "dd/mm/yy"
        };
        
        $(".j_date").datepicker(pickerOpts);
});


function fn_goAddTR(){
	
	var item  = new Object();
	
	item.tr_type = $("#tr_type").val();
	item.tr_number = $("#tr_number").val();
	item.tr_issueddate = $("#tr_issueddate").val();
	item.tr_text = $("#tr_type option:selected").text(); 
	
	
	if($("#tr_type").val() =="" ){
		 Common.alert("* Please fill up all the required fields.");
		 return  false;
	}
	
	if($("#tr_number").val() =="" ){
        Common.alert("* Please fill up all the required fields.");
        return false ;
   }
	if($("#tr_issueddate").val() =="" ){
        Common.alert("* Please fill up all the required fields.");
        return  false;
   }
	
	fn_resultAddNewTr(item);
	$("#payadd_close").click();
	
}



</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Add New TR</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"  id="payadd_close">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">TR Type  <span class="must">*</span> </th>
	<td>
	<select id="tr_type" name="tr_type">
		<option value="1">Membership Package </option>
		<option value="2">Filter (1st BS)</option>
		<option value="3">Membership Package & Filter (1st BS)</option>
	</select>
	</td>
</tr>
<tr>
	<th scope="row">TR Number <span class="must">*</span></th>
	<td><input type="text" title=""  id="tr_number"  placeholder="" /></td>
</tr>
<tr>
	<th scope="row">Issued Date <span class="must">*</span></th>
	<td><input type="text" title="Create start Date"    id="tr_issueddate" placeholder="DD/MM/YYYY" class="j_date" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
	<li><p class="btn_blue big"><a href="#"  onclick="javascript:fn_goAddTR()">Add TR</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->