<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() { 
	ComplianceListGrid();

	AUIGrid.bind(myGridID_compliance, "cellDoubleClick", function(event) {
		var complianceId = AUIGrid.getCellValue(myGridID_compliance, event.rowIndex, "cmplncId");
		 Common.popupDiv("/organization/compliance/complianceViewPop.do?complianceId="+complianceId,"");
     });
	
	AUIGrid.bind(myGridID_compliance, "cellClick", function(event) {
       complianceIdValue = AUIGrid.getCellValue(myGridID_compliance, event.rowIndex, "cmplncId");
       memberId = AUIGrid.getCellValue(myGridID_compliance, event.rowIndex, "memId");
       statusId = AUIGrid.getCellValue(myGridID_compliance, event.rowIndex, "cmplncStusId");
        console.log("memberId " + memberId);
     });
	
});
var myGridID_compliance;
function ComplianceListGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "cmplncNo",
        headerText : "Case No",
        editable : false,
        width : 200
    }, {
        dataField : "memCode",
        headerText : "Member Code",
        editable : false,
        width : 200
    }, {
        dataField : "codeName",
        headerText : "Member Type",
        editable : false,
        width : 200
    }, {
        dataField : "name",
        headerText : "Case Status",
        editable : false,
        width : 200
    }, {
        dataField : "cmplncId",
        headerText : "cmplncId",
        editable : false,
        width : 0
    }, {
        dataField : "c1",
        headerText : "Received Date",
        editable : false,
        width : 200,
        dataType : "date", 
        formatString : "dd/mm/yyyy"
    }, {
        dataField : "userName",
        headerText : "Person In Charge",
        editable : false,
        width : 200
    }, {
        dataField : "memId",
        headerText : "",
        editable : false,
        width : 0
    }, {
        dataField : "cmplncStusId",
        headerText : "",
        editable : false,
        width : 0
    }];



    // 그리드 속성 설정
   var gridPros = {

	        // 페이징 사용
	        usePaging : true,

	        // 한 화면에 출력되는 행 개수 20(기본값:20)
	        pageRowCount : 20,

	        editable : true,

	        displayTreeOpen : true,

	        selectionMode : "singleRow",

	        headerHeight : 30,

	        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	        skipReadonlyColumns : true,

	        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	        wrapSelectionMove : true,

	        // 줄번호 칼럼 렌더러 출력
	        showRowNumColumn : true
	        
   };


    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID_compliance = AUIGrid.create("#grid_wrap_complianceList", columnLayout, gridPros);
}

function fn_complianceSearch(){
	Common.ajax("GET", "/organization/compliance/complianceCallLog.do", $("#complianceSearch").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID_compliance, result);
    });
}

function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap_complianceList", "xlsx", "Compliance Call Log");
}

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
            this.selectedIndex = -1;
        }
        AUIGrid.clearGridData(myGridID_compliance); 
    });
};

function fn_complianceNew(){
	Common.popupDiv("/organization/compliance/complianceCallLogNewPop.do"  , null, null , true , '');
}

function fn_maintance(){
	if(statusId == "60" || statusId == "1" ){
		   Common.popupDiv("/organization/compliance/complianceLogMaintencePop.do?complianceId="+complianceIdValue  , null, null , true , '');
	}else{
		 Common.alert("Compliance call log unable to maintance. <br /> Current log already close/cancel.");
	}
}
function fn_reOpenPop(){
	if(statusId == "36" || statusId == "10" ){
	    Common.popupDiv("/organization/compliance/complianceCallReOpenPop.do?complianceId="+complianceIdValue+"&memberId="+memberId  , null, null , true , '');
	}else{
		 Common.alert("Only close or cancel compilance call log can reopen");
	}
}
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Compliance Call Log</li>d
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Compliance Call Log</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_reOpenPop()"><span class="reOpen"></span>Re-Open</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_maintance()"><span class="Maintence"></span>Maintence</a></p></li> 
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_complianceNew()"><span class="new"></span>New</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_complianceSearch()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#complianceSearch').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="complianceSearch">

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
    <th scope="row">Case No</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" id="caseNo" name="caseNo"/>
    </td>
    <th scope="row">Case Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="caseStatus" name="caseStatus">
        <option value="1" selected>Active</option>
        <option value="60" selected>In Progress</option>
        <option value="36">Closed</option>
        <option value="10">Cancel</option>
    </select>
    </td>
    <th scope="row">Received Date</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="recevDt" name="recevDt"/>
    </td>
</tr>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select class="w100p" id="memType" name="memType" >
        <option value=""></option>
        <option value="1">Health Planner</option>
        <option value="2">Coway Lady</option>
        <option value="3">Coway Technician</option>
    </select>
    </td>
    <th scope="row">Member Code</th>
    <td>
    <input type="text" title="" placeholder="" class="" id="memCode" name="memCode"/>
    </td>
    <th scope="row">Person In Charge</th>
    <td>
    <select class="w100p"  id="userId" name="userId">
        <option value="">Person In Charge</option>
        <option value="18522">NICKY</option>
        <option value="32807">EUGENE</option>
        <option value="34026">OOI BENG EAN</option>
        <option value="56056">WONG WENG KIT</option>
        <option value="57202">KATE</option>
        <option value="59697">PAVITRA</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<%-- <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end --> --%>

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_excelDown()">EXCEL DW</a></p></li>
    <!-- <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li> -->
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_complianceList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

