<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javascript">

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});


function ddlHolderType_SelectedIndexChanged(){
	
}


CommonCombo.make('cmbBranch', '/sales/ccp/getBranchCodeList', '' , '');
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>TR Book Management Summary Listing</h1>
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
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Book No</th>
    <td><input type="text" title="" placeholder="Book No" class="w100p" id="txtTRBookNo"/></td>
    <th scope="row">Return To Branch</th>
    <td>
        <select class="w100p" id="cmbBranch"></select>
    </td>
    <th scope="row">Update Date</th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpUpdateFromDate"/></p>
        <span>To</span>
        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpUpdateToDate"/></p>
        </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Create By</th>
    <td><input type="text" title="" placeholder="Create By" class="w100p" id="txtCreator"/></td>
    <th scope="row">Book Holder</th>
    <td><input type="text" title="" placeholder="Book Holder" class="w100p" id="txtTRBookHolder"/></td>
    <th scope="row">Holder Type</th>
    <td>
        <select class="w100p" id="ddlHolderType" onchange="ddlHolderType_SelectedIndexChanged()" data-placeholder="Holder Type">
            <option value="Branch">Branch</option>
            <option value="Member">Member</option>
        </select>
    </td>
</tr>
<tr>
    <th scope="row">Status</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="ddlBookStatus" data-placeholder="Status">
            <option value="ACT" selected>Active</option>
            <option value="CLO" selected>Close</option>
            <option value="LOST" selected>Lost</option>
        </select>
    </td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Member Type</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cboMember">
            <option value="1">Health Planner</option>
            <option value="2">Coway Lady</option>
            <option value="3">Coway Technician</option>
            <option value="4">Staff</option>
        </select>
    </td>
    <th scope="row">Organization Code</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cboOrganization" data-placeholder="Organization Code"></select>
    </td>
    <th scope="row">Group Code</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cboGroup" data-placeholder="Group Code"></select>
    </td>
</tr>
<tr>
    <th scope="row">Department Code</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cboDepartment" data-placeholder="Department Code"></select>
    </td>
    <td colspan="4"></td>
</tr>
</tbody>
</table><!-- table end -->


<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">Generate To PDF</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">Generate To Excel</a></p></li>
</ul>


<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />


</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->