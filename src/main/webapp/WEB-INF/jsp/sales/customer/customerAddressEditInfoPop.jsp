<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
    
    $(document).ready(function() {
    	
    	var selCodeNation = $("#selCodeNation").val();
        var selCodeState = $("#selCodeState").val();
        var selCodeArea = $("#selCodeArea").val();
        var selCodePostCode = $("#selCodePostCode").val();
        
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , selCodeNation,'cmdNationTypeId', 'S', '');        // Nationality Combo Box
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'state' , selCodeNation , selCodeState,'cmdStateTypeId', 'S', '');        // State Combo Box
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'area' , selCodeState , selCodeArea,'cmdAreaTypeId', 'S', '');        // State Combo Box
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'post' , selCodeArea , selCodePostCode, 'cmdPostTypeId', 'S', '');        // State Combo Box
        
	});
    
</script>
<!-- getParams  -->
<input type="hidden" value="${detailaddr.cntyId}" id="selCodeNation">
<input type="hidden" value="${detailaddr.stateId}" id="selCodeState">
<input type="hidden" value="${detailaddr.areaId }" id="selCodeArea">
<input type="hidden" value="${detailaddr.postCodeId }" id="selCodePostCode">
<section class="pop_body"><!-- pop_body start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Status</th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p"  value="${detailaddr.name}" readonly="readonly"/>
    </td>
</tr>
<tr>
    <th rowspan="3" scope="row">Address<span class="must">*</span></th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p"  value="${detailaddr.add1}"/>
    </td>
</tr>
<tr>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p" value="${detailaddr.add2}"/>
    </td>
</tr>
<tr>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p" value="${detailaddr.add3}"/>
    </td>
</tr>
<tr>
    <th scope="row">Country<span class="must">*</span></th>
    <td>
    <select class="w100p" id="cmdNationTypeId"></select>
    </td>
    <th scope="row">State<span class="must">*</span></th>
    <td>
    <select class="w100p" id="cmdStateTypeId"></select>
    </td>
</tr>
<tr>
    <th scope="row">Area<span class="must">*</span></th>
    <td>
    <select class="w100p" id="cmdAreaTypeId"></select>
    </td>
    <th scope="row">Postcode<span class="must">*</span></th>
    <td>
    <select class="w100p" id="cmdPostTypeId"></select>
    </td>
</tr>
<tr>
    <th scope="row">Reamrk</th>
    <td colspan="3">
    <textarea cols="20" rows="5" placeholder="Address Reamrk"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">Update</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">Delete</a></p></li>
</ul>

</section><!-- pop_body end -->