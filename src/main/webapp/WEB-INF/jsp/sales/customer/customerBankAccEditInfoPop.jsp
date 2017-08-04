<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

    $(document).ready(function() {
		
    	var selCodeAccType = $("#selCodeAccType").val();
    	var selCodeAccBankId = $("#selCodeAccBankId").val();
    	
    	doGetCombo('/common/selectCodeList.do', '20', selCodeAccType, 'cmbAccTypeId', 'S', '');
    	/* 은행 */
    	//doGetCombo('/common/selectCodeList.do', '20', selCodeAccBankId, 'cmbAccTypeId', 'S', '');
    	           
    	
	});
</script>
<input type="hidden" value="${detailbank.custAccTypeId}" id="selCodeAccType"> 
<input type="hidden" value="${detailbank.custAccBankId}" id="selCodeAccBankId"> 
<section class="pop_body"><!-- pop_body start -->
<!-- detailbank  -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Type<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Issue Bank<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Account No<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="Account Number" class="w100p" /></td>
    <th scope="row">Bank Branch</th>
    <td><input type="text" title="" placeholder="Bank Branch" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Account Owner<span class="must">*</span></th>
    <td colspan="3"><input type="text" title="" placeholder="Account Owner" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Remarks</th>
    <td colspan="3">
    <textarea cols="20" rows="5"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">Update</a></p></li>
</ul>

</section><!-- pop_body end -->