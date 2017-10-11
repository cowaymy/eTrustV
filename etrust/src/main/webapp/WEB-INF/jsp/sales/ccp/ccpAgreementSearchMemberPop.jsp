<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//생성 후 반환 ID
var memGridID;

$(document).ready(function() {
	
	createAUIGrid();
	
	//j_date
    var pickerOpts={
            changeMonth:true,
            changeYear:true,
            dateFormat: "dd/mm/yy"
    };
    
    $(".j_date").datepicker(pickerOpts);

    var monthOptions = {
         pattern: 'mm/yyyy',
         selectedYear: 2017,
         startYear: 2007,
         finalYear: 2027
    };
    
    $(".j_date2").monthpicker(monthOptions);
    
    //Member Search
    $("#_memSearchBtn").click(function() {
    	
    	 fn_getSearchResultJsonListAjax();
	});
});


//search Ajax
function fn_getSearchResultJsonListAjax(){
    
    Common.ajax("GET", "/sales/ccp/selectSearchMemberCode",$("#_searchMemForm").serialize(), function(result) {
        AUIGrid.setGridData(memGridID, result);
    });
}

function createAUIGrid(){
    
    var memberColumnLayout = [
                                  {dataField : "codeName",headerText : "Type", width : '15%'},
                                  {dataField : "memCode", headerText : "Code", width : '15%'},
                                  {dataField : "name", headerText : "Name", width : '30%'},
                                  {dataField : "nric", headerText : "NRIC", width : '20%'},
                                  {dataField : "joinDt", headerText : "Join Date", width : '10%'},
                                  {dataField : "memId" , visible : false},
                                  {
                                      dataField : "undefined", 
                                      headerText : " ", 
                                      width : '10%',
                                      renderer : {
                                               type : "ButtonRenderer", 
                                               labelText : "Select", 
                                               onclick : function(rowIndex, columnIndex, value, item) {
                                                   //pupupWin
                                                  
                                                   $("#_inputMemCode").val(item.memCode);
                                                   $("#_hiddenInputMemCode").val(item.memCode);
                                                   $("#_govAgMemId").val(item.memId);
                                                   fn_selected();
                                                   
                                             }
                                      }
                                  }];
    
    var gridPros = {
            
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 1,            
            showStateColumn     : true,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
    
    memGridID = GridCommon.createAUIGrid("#member_grid_wrap", memberColumnLayout,'',gridPros);//Order Search List
}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Sales Person Search</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_closeMemPop">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns mb10">
    <li><p class="btn_blue"><a href="#" id="_memSearchBtn"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="Claer"></span>Clear</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->
<form action="#" method="get" id="_searchMemForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select class="w100p" name="searchMemType">
        <option selected="selected" value="">Choose One</option>
        <option value="1">Health Planner (HP)</option>
        <option value="2">Coway Lady (CODY)</option>
        <option value="3">Coway Technician (CT)</option>
        <option value="4">Staff</option>
    </select>
    </td>
    <th scope="row">Member Code</th>
    <td><input type="text" title="" placeholder="Member Code" class="w100p" name="searchMemCode" /></td>
    <th scope="row">Join Date</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  name="searchDate"/></td>
</tr>
<tr>
    <th scope="row">Member Name</th>
    <td colspan="3"><input type="text" title="" placeholder="Member Name" class="w100p" name="searchCustName"/></td>
    <th scope="row">NRIC</th>
    <td><input type="text" title="" placeholder="Member NRIC" class="w100p" name="searchCustNric" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="member_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>