<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
$(document).ready(function(){
	createHSReportListAUIGrid();
	
	 AUIGrid.bind(myGridID, "cellClick", function(event) {
	        BSNo =  AUIGrid.getCellValue(myGridID, event.rowIndex, "no");
	    });
});

var myGridID;
function createHSReportListAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "no",
        headerText : "HS No",
        editable : false,
        width : 130
    }, {
        dataField : "month",
        headerText : "BS Month",
        editable : false,
        width : 180
    }, {
        dataField : "year",
        headerText : "HS Year",
        editable : false,
        width : 180
    }, {
        dataField : "code",
        headerText : "BS Status",
        editable : false,
        width : 100
    }, {
        dataField : "c3",
        headerText : "Result No",
        editable : false,
        style : "my-column",
        width : 180
    }, {
        dataField : "salesOrdNo",
        headerText : "Order No",
        editable : false,
        width : 250
    }, {
        dataField : "code1",
        headerText : "App Type",
        editable : false,
        width : 150
        
    }, {
        dataField : "c8",
        headerText : "Inchange Member",
        editable : false,
        width : 100
    }];
  
    

    // 그리드 속성 설정
   var gridPros = {
		   usePaging           : true,         //페이징 사용
           pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
           editable            : false,
           showStateColumn     : false,
           displayTreeOpen     : false,
           selectionMode       : "singleRow",  //"multipleCells",
           headerHeight        : 30,
           useGroupingPanel    : false,        //그룹핑 패널 사용
           skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
           wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
           showRowNumColumn    : true       //줄번호 칼럼 렌더러 출력
   };
    
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#grid_wrap_HSReportList", columnLayout, gridPros);
}

function fn_HSReportList(){
	Common.ajax("GET", "/services/bs/report/selectHSReportSingle.do", $("#searchHsReport").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_Generate(){
	var date = new Date();
    var month = date.getMonth()+1;
	$("#searchHsReport #V_CODYDEPTCODE").val(BSNo);
	$("#searchHsReport #reportFileName").val('/services/BSReport_ByBSNo.rpt');
    $("#searchHsReport #viewType").val("PDF");
    $("#searchHsReport #reportDownFileName").val(BSNo + "_"+date.getDate()+month+date.getFullYear());
    
    var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
    };
    
    Common.report("searchHsReport", option);
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
        
    });
};
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>HS Management - HS REPORT(SINGLE)</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="searchHsReport">
<input type="hidden" id="V_CODYDEPTCODE" name="V_CODYDEPTCODE" />
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_HSReportList()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchHsReport').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">HS Number</th>
    <td><input type="text" title="HS Number" placeholder="HS Number" class="w100p" id="hsNumber" name="hsNumber"/></td>
    <th scope="row">HS Month</th>
    <td><input type="text" title="HS Month" placeholder="MM/YYYY" class="j_date2 w100p" id="hsMonth" name="hsMonth"/></td>
</tr>
<tr>
    <th scope="row">Order Number</th>
    <td><input type="text" title="Order Number" placeholder="Order Number" class="w100p" id="orderNumber" name="orderNumber"/></td>
    <th scope="row">Member Code</th>
    <td><input type="text" title="Member Code" placeholder="Member Code" class="w100p" id="memberCode" name="memberCode"/></td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_HSReportList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</form>
</section><!-- search_table end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_Generate()">Generate</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
