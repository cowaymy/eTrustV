<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.my-right-style {
    text-align:right;
}
.my-left-style {
    text-align:left;
}

/* 커스텀 행 스타일 */
.my-row-style { 
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<script  type="text/javascript">
$(document).ready(function(){
	
    CommonCombo.make("reason", "/sales/membership/selectReasonList", "", "", {
        id: "resnId",
        name: "resnName",
        type: "M"
    });
	
    CommonCombo.make("orgCode", "/sales/membership/selectCodeList", {memType:$("#memType").val(), memLvl:"1", memUpId :"31983"}, "", {
        id: "memId",
        name: "deptCodeName"
    });
    
    $('#orgCode').on("change", function () {

    	
        var $this = $(this);
       CommonCombo.initById("grpCode");

       if (FormUtil.isNotEmpty($this.val())) {
    	   
    	   alert($this.val());

    	   CommonCombo.make("grpCode", "/sales/membership/selectCodeList", {memType:$("#memType").val(), memLvl:"2", memUpId : $this.val()}, "", {
               id: "memId",
               name: "deptCodeName"
           });

       } 
   });
    
    $('#grpCode').on("change", function () {

        var $this = $(this);
       CommonCombo.initById("deptCode");

       if (FormUtil.isNotEmpty($this.val())) {

    	   CommonCombo.make("deptCode", "/sales/membership/selectCodeList", {memType:$("#memType").val(), memLvl:"3", memUpId : $("#grpCode").val()}, "", {
               id: "memId",
               name: "deptCodeName"
           });

       } 
   });
    
});
</script>
<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Member Applicant Listing</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#">Generate Excel</a></p></li>
	<li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

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
	<th scope="row">Cancellation No.</th>
	<td><input type="text" title="" placeholder="" class="w100p" /></td>
	<th scope="row">Member Type</th>
	<td>
	<select class="w100p disabled" id="memType" name="memType">
        <option value="1">Health Planner</option>
        <option value="2" selected="selected">Coway Lady</option>
        <option value="3">Coway Technician</option>
	</select>
	</td>
</tr>
<tr>
	<th scope="row">Requested Date</th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	<span>To</span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	</div><!-- date_set end -->
	</td>
	<th scope="row">Org Code</th>
	<td>
	<select class="w100p" id="orgCode" name="orgCode">
	</select>
	</td>
</tr>
<tr>
	<th scope="row">Order No.</th>
	<td><input type="text" title="" placeholder="" class="w100p" /></td>
	<th scope="row">Grp Code</th>
	<td>
	<select class="w100p" id="grpCode" name="grpCode">
	</select>
	</td>
</tr>
<tr>
	<th scope="row">Membership No.</th>
	<td><input type="text" title="" placeholder="" class="w100p" /></td>
	<th scope="row">Dept Code</th>
	<td>
	<select class="w100p" id="deptCode" name ="deptCode">
	</select>
	</td>
</tr>
<tr>
	<th scope="row">Cancellation Reason</th>
	<td>
	<select class="multy_select w100p" multiple="multiple" id="reason" name="reason">
	</select>
	</td>
	<th scope="row">Customer Type</th>
	<td>
	<select class="w100p"  >
		
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

</section><!-- content end -->
