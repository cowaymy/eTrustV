<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

function fn_addNewItem(){
	
	if(fn_addValidation() == true){
		Common.ajax("POST", "/sales/rcms/addNewOrdNo", $("#_newForm").serializeJSON(), function(result){
			if(result != null){
				Common.alert("New item added.", fn_closePop);	
			}
		});
	}
}

function fn_closePop(){
	$("#_AddPopclose").click();
	$("#_confirmCloseBtn").click();
	$("#_confirmUpload").click();
}

function fn_addValidation(){
	
	var isRtn = true;
	
	//null
	if( null == $("#_addOrdNo").val() || '' == $("#_addOrdNo").val()){
		Common.alert("Please key in the Order No. <br />");
		return false;
	}
	
	//Already In Batch
	Common.ajax("GET", "/sales/rcms/alreadyExistOrdNo", {ordNo : $("#_addOrdNo").val() , batchId : '${batchId}'}, function(result){
        if(result != null){
        	Common.alert("* This order no. is existing in the upload batch.<br />");
            isRtn = false;
        }
    },null,{async : false});
    if(isRtn == false){
        return false;
    }    
    
    //Invalid Ord No
    Common.ajax("GET", "/sales/rcms/searchExistOrdNo", {ordNo : $("#_addOrdNo").val()}, function(result){
        if(result == null){
            Common.alert("* Invalid order no.<br />");
            isRtn = false;
            $("#_ordId").val("");
        }else{
            $("#_ordId").val(result.salesOrdId);  
        }
    },null,{async : false});
    if(isRtn == false){
        return false;
    }
    //Validation Pass
    return true;
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>ORDER REMARK UPLOAD - VIEW UPLOAD BATCH</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_AddPopclose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<aside class="title_line"><!-- title_line start -->
<h3>Add Order Remark Batch</h3>
</aside><!-- title_line end -->

<form  id="_newForm">
<input type="hidden" value="${batchId}" name="batchId">
<input type="hidden" name="ordId" id="_ordId"> 
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
    <tr>
        <th scope="row">Order No.</th>
        <td>
            <input type="text" title="" placeholder="" class="w100p"  id="_addOrdNo" name="addOrdNo"/>
            <input type="text" style="display: none;">
        </td>
    </tr>
   <tr>
        <th scope="row">Remark<span class="must">*</span></th>
        <td>
            <textarea id="_addRem" name="addRem"></textarea>
        </td>
    </tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript: fn_addNewItem()">Add Item</a></p></li>
</ul>

</section><!-- pop_body end -->
</div><!-- popup_wrap end-->