<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
var option = {
        width : "1200px",   // 창 가로 크기
        height : "500px"    // 창 세로 크기
};


var myGridID;

function fn_searchASManagement(){
        Common.ajax("GET", "/services/compensation/selCompensation.do", $("#compensationForm").serialize(), function(result) {
            console.log("성공.");
            console.log( result);
            AUIGrid.setGridData(myGridID, result);
        });
}

$(document).ready(function() {

    // AUIGrid 그리드를 생성합니다.
    asManagementGrid();
    
    AUIGrid.setSelectionMode(myGridID, "singleRow");
    
    doGetCombo('/services/holiday/selectBranchWithNM', 43, '','cmbbranchId', 'S' ,  '');
    
    $("#cmbbranchId").change(function (){
        doGetCombo('/services/as/selectCTByDSC.do',  $("#cmbbranchId").val(), '','cmbctId', 'S' ,  '');
    });
    
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
        var asid =    AUIGrid.getCellValue(myGridID, event.rowIndex, "asId");
        var asNo =    AUIGrid.getCellValue(myGridID, event.rowIndex, "asNo");
        var asStusId     = AUIGrid.getCellValue(myGridID, event.rowIndex, "asStusId");
        var salesOrdNo  = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdNo");
        var salesOrdId  = AUIGrid.getCellValue(myGridID, event.rowIndex, "asSoId");
        
        alert('11111')
        //var param = "?ord_Id="+salesOrdId+"&ord_No="+salesOrdNo+"&as_No="+asNo+"&as_Id="+asid;
        //Common.popupDiv("/services/as/asResultViewPop.do"+param ,null, null , true , '_newASResultDiv1');
    });   
    
});

function asManagementGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "code",
        headerText : "Region",
        editable : false,
        width : 200
    }, {
        dataField : "asNo",
        headerText : "SCM",
        editable : false,
        width : 200
    }, {
        dataField : "asReqstDt",
        headerText : "CM",
        editable : false,
        width : 200 
        //, dataType : "date", formatString : "dd/mm/yyyy"
    }, {
        dataField : "code1",
        headerText : "Toal Hs",
        editable : false,
        width : 200
    }, {
        dataField : "c3",
        headerText : "Cody Pax",
        editable : false,
        style : "my-column",
        width : 200
    }, {
        dataField : "c4",
        headerText : "Overall Productivity",
        editable : false,
        width : 200
    }];
     // 그리드 속성 설정
    var gridPros = {
               showRowCheckColumn : true,
               // 페이징 사용       
               usePaging : true,
               headerHeight : 30,
               // 한 화면에 출력되는 행 개수 20(기본값:20)
               pageRowCount : 20,
               // 전체 체크박스 표시 설정
               showRowAllCheckBox : true,
               editable :  false,
               selectionMode:"multipleCells"
    };
    
    myGridID = AUIGrid.create("#grid_wrap_compensation", columnLayout, gridPros);
}

var gridPros = {
    
    // 페이징 사용       
    usePaging : true,
    
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    
    editable : true,
    
    fixedColumnCount : 1,
    
    showStateColumn : true, 
    
    displayTreeOpen : true,
    
    selectionMode : "singleRow",
    
    headerHeight : 30,
    
    // 그룹핑 패널 사용
    useGroupingPanel : true,
    
    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,
    
    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,
    
    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false,
    
};


function fn_expansionDetailPop(){
    Common.popupDiv("/organization/branchExpansionPop.do", $("#compensationForm").serializeJSON(), null , true , '');
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

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->

<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Promotion Candidate Monitoring</h2>

<!-- <form action="#" id="inHOForm">
<div   style="display:none" >

    <input type="text" id="in_asId" name="in_asId" />
    <input type="text" id="in_asNo" name="in_asNo" />
    <input type="text" id="in_ordId" name="in_ordId" />
    <input type="text" id="in_asResultId" name="in_asResultId" />
    <input type="text" id="in_asResultNo" name="in_asResultNo" />
    
</div>
</form> -->

<!-- 
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_newASPop()">ADD AS Order</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_newASResultPop()">ADD AS Result</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_asResultEditBasicPop()">EDIT AS Result</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_asResultViewPop()"> VIEW AS Result</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_assginCTTransfer()">Assign CT Transfer</a></p></li>
</ul>
<br> -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onClick="javascript:fn_searchASManagement()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#CompensationForm').clearForm();" ><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="branchExpansionForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
<th colspan="6">SGCM</th>
</tr>
<tr>
    
    <th scope="row">Pax</th>
    <td><input type="text" title="" placeholder="Order Number" class="w100p" id="orderNum" name="orderNum"/></td>
    <th scope="row">Productivity</th>
    <td><input type="text" title="" placeholder="Customer Code" class="w100p" id="customerCode" name="customerCode"/></td>
</tr>
<tr>
<th colspan="6">GCM</th>
</tr>
<tr>
    
    <th scope="row">Pax</th>
    <td><input type="text" title="" placeholder="Order Number" class="w100p" id="orderNum" name="orderNum"/></td>
    <th scope="row">Productivity</th>
    <td><input type="text" title="" placeholder="Customer Code" class="w100p" id="customerCode" name="customerCode"/></td>
</tr>
<tr>
<th colspan="6">SGCM</th>
</tr>
<tr>
    
    <th scope="row">Pax</th>
    <td><input type="text" title="" placeholder="Order Number" class="w100p" id="orderNum" name="orderNum"/></td>
    <th scope="row">Productivity</th>
    <td><input type="text" title="" placeholder="Customer Code" class="w100p" id="customerCode" name="customerCode"/></td>
</tr>

<tr>
<th colspan="6">CM</th>
</tr>
<tr>
    <th scope="row">Pax</th>
    <td><input type="text" title="" placeholder="Order Number" class="w100p" id="orderNum" name="orderNum"/></td>
    <th scope="row">Productivity</th>
    <td><input type="text" title="" placeholder="Customer Code" class="w100p" id="customerCode" name="customerCode"/></td>
</tr>
 
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" onClick="fn_expansionDetailPop()">Detail View</a></p></li>
<!--     <li><p class="btn_grid"><a href="#" onClick="fn_CompensationPop()">Edit Case</a></p></li> --> 
</ul>

<aside class="title_line"><!-- title_line start -->
<h2>Information Display</h2>
</aside><!-- title_line end -->


<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_compensation" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</form>
<form action="#" id="reportForm" method="post">  
<input type="hidden" id="V_RESULTID" name="V_RESULTID" />
</form>
</section><!-- search_table end -->

</section><!-- content end -->
