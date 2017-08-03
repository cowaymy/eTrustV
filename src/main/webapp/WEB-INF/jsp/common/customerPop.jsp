<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

	//AUIGrid 생성 후 반환 ID
	var myGridID;

	$(document).ready(function(){
	    //AUIGrid 그리드를 생성합니다.
	    createAUIGrid();
	    
        doGetCombo('/common/selectCodeList.do', '8', '', 'cmbTypeId', 'S', ''); //Common Code
        doGetCombo('/common/selectCodeList.do', '2', '', 'raceId',    'S', ''); //Common Code
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            opener.fn_loadCustomer(AUIGrid.getCellValue(myGridID , event.rowIndex , "custId"));
            self.close();
        });
	});
	
    function createAUIGrid() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
	            dataField : "custId",
	            headerText : "ID",
	            width : 100,
	            editable : false
	        }, {
	            dataField : "codeName1",
	            headerText : "Type",
	            width : 100,
	            editable : false
	        }, {
	            dataField : "codeName",
	            headerText : "Corp Type",
	            visible : false
	        }, {
	            dataField : "name",
	            headerText : "Name",
	            editable : false
	        }, {
	            dataField : "nric",
	            headerText : "NRIC/Company No",
	            width : 170,
	            editable : false
	        },{
	            dataField : "custAddId",
	            visible : false
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
            showStateColumn     : false,             
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
        
        myGridID = GridCommon.createAUIGrid("grid_cust_wrap", columnLayout, "", gridPros);
    }

    // 리스트 조회.
    function fn_selectPstRequestDOListAjax() {        
        Common.ajax("GET", "/sales/customer/selectCustomerJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        }
        );
    }
    
    
</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Search Customer</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:210px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Customer Type</th>
	<td>
	<select id="cmbTypeId" name="cmbTypeId" class="w100p"></select>
	</td>
	<th scope="row">Customer ID</th>
	<td><input id="custId" name="custId" type="text" title="" placeholder="Customer ID (Numerci)" class="w100p" /></td>
</tr>
<tr>
	<th scope="row">Race</th>
	<td>
	<select id="raceId" name="raceId" class="w100p"></select>
	</td>
	<th scope="row">NRIC/Company Number</th>
	<td><input id="nric" name="nric" type="text" title="" placeholder="NRIC/Company No." class="w100p" /></td>
</tr>
<tr>
	<th scope="row">Customer Name</th>
	<td colspan="3"><input id="name" name="name" type="text" title="" placeholder="Customer Name" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" onClick="fn_selectPstRequestDOListAjax();">SEARCH</a></p></li>
	<li><p class="btn_grid"><a href="#">CLEAR</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_cust_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</body>
</html>