<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$("#dataForm").empty();


/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }
    });
};
/* 
function validRequiredField(){
	var valid = true;
	var message = "";
	
	if(){
		if(){
			
		}
	}
	
	if(){
        if(){
            
        }
    }
	
	if(){
        if(){
            
        }
    }
	
	if(valid == true){
		   fn_report();
	}else{
	       alert(message);
	}
	
}
 */
 
function fn_report(){
	
}

</script>



<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order Report - Rental Pay Setting Update List</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form">

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
    <th scope="row">Paymode</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbPaymode">
        <option value="133">AEON Express</option>
        <option value="131">Credit Card</option>
        <option value="132">Direct Debit</option>
        <option value="134">FPX</option>
        <option value="130">Regular (Cash/Cheque)</option>
    </select>
    </td>
    <th scope="row">Update Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpUpdateDateFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpUpdateDateTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Order No</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="" placeholder="" class="w100p" id="txtOrderNoFr"/></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="" class="w100p"id="txtOrderNoTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Order Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpOrderDateTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Key-In Branch</th>
    <td>
    <select class="w100p" id="cmbKeyBranch">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Bank</th>
    <td>
    <select class="multy_select w100p" multiple="multiple">
        <option value="1">11</option>
        <option value="2">22</option>
        <option value="3">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Order App Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple">
        <option value="1">11</option>
        <option value="2">22</option>
        <option value="3">33</option>
    </select>
    </td>
    <th scope="row">Order Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple">
        <option value="1">11</option>
        <option value="2">22</option>
        <option value="3">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Rental Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple">
        <option value="1">11</option>
        <option value="2">22</option>
        <option value="3">33</option>
    </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript: validRequiredField();">Generate</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="PDF" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />


</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->