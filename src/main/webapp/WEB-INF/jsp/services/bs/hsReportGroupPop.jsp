<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
$(document).ready(function(){
    createHSGroupListAUIGrid();
    
    var today = new Date();
    var month1 = today.getMonth()+1;
    $("#dayMonth").val(month1);
    $("#dayYear").val(today.getFullYear());
    
});

var myGridID_Hsgroup;
function createHSGroupListAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "",
        headerText : "",
        editable : false,
        width : 200,
        renderer : {
            type : "ButtonRenderer",
            labelText : "Download",
            onclick : function(rowIndex, columnIndex, value, item) {
                var deptCode = AUIGrid.getCellValue(myGridID_Hsgroup, rowIndex, "c3");
                var fileName = AUIGrid.getCellValue(myGridID_Hsgroup, rowIndex, "c2");
                
                $("#searchHsGroupReport #V_CODYDEPTCODE").val(deptCode);
                $("#searchHsGroupReport #reportFileName").val('/services/BSReport_ByBSNo.rpt');
                $("#searchHsGroupReport #viewType").val("PDF");
                $("#searchHsGroupReport #reportDownFileName").val(fileName);
                
                var option = {
                        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                };
                
                Common.report("searchHsGroupReport", option);
                
          }
      }
    }, {
        dataField : "c3",
        headerText : "Department Cdoe",
        editable : false,
        width : 200
    }, {
        dataField : "c2",
        headerText : "File Name",
        editable : false,
        width : 200
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
    myGridID_Hsgroup = AUIGrid.create("#grid_wrap_HSReportGroup", columnLayout, gridPros);
}

function fn_HSReportGroup(){
	
    Common.ajax("GET", "/services/bs/report/selectHSReportGroup.do", $("#searchHsGroupReport").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID_Hsgroup, result);
    });
}

function fn_Generate(){
    var date = new Date();
    var month = date.getMonth()+1;
    var day = date.getDate();
    if(date.getDate() < 10){
        day = "0"+date.getDate();
    }
    $("#searchHsReport #V_HSNO").val(BSNo);
    $("#searchHsReport #reportFileName").val('/services/BSReport_ByBSNo_Single.rpt');
    $("#searchHsReport #viewType").val("PDF");
    $("#searchHsReport #reportDownFileName").val(BSNo + "_"+day+month+date.getFullYear());
    
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
<h1>HS Management - HS REPORT(Group)</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="searchHsGroupReport">
<input type="hidden" id="dayMonth" name="dayMonth" />
<input type="hidden" id="dayYear" name="dayYear" />
<input type="hidden" id="V_CODYDEPTCODE" name="V_CODYDEPTCODE" />
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_HSReportGroup()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchHsGroupReport').clearForm();"><span class="clear"></span>Clear</a></p></li>
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
    <th scope="row">Organization Code</th>
    <td><input type="text" title="" placeholder="Organization Code" class="w100p" id="orgCode" name="orgCode"/></td>
    <th scope="row">Group Code</th>
    <td><input type="text" title="" placeholder="Group Code" class="w100p" id="grpCode" name="grpCode"/></td>
    <th scope="row">Department Code</th>
    <td><input type="text" title="" placeholder="Department Coder" class="w100p" id="deptCode" name="deptCode"/></td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_HSReportGroup" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</form>
</section><!-- search_table end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_Generate()">Generate</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
