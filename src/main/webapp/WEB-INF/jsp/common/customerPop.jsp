<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

	//AUIGrid 생성 후 반환 ID
	var myGridID;

	$(document).ready(function(){
	    //AUIGrid 그리드를 생성합니다.
	    createAUIGrid();
	    
        doGetCombo('/common/selectCodeList.do', '8', '964', 'cmbTypeId', 'S', ''); //Common Code
        doGetCombo('/common/selectCodeList.do', '2', '',    'cmbRaceId',    'S', ''); //Common Code
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            fn_setData(AUIGrid.getCellValue(myGridID , event.rowIndex , "custId") , event.item );    //edit by hgham 2017-09-21    event.item 추가 
        });
	});
	
    $(function(){
        $('#_custId').keydown(function (event) {  
            if (event.which === 13) {    //enter
                console.log('xxx');
                fn_selectPstRequestDOListAjax();
                return false;
            }  
        });
        $('#_nric').keydown(function (event) {  
            if (event.which === 13) {    //enter  
                fn_selectPstRequestDOListAjax();
                return false;
            }  
        });
        $('#_name').keydown(function (event) {  
            if (event.which === 13) {    //enter  
                fn_selectPstRequestDOListAjax();
                return false;
            }  
        });
    });
	
	function fn_setData(custId , item) { //edit by hgham 2017-09-21    event.item 추가 
	    if($('#callPrgm').val() == 'ORD_REGISTER_CUST_CUST') {
	        fn_loadCustomer(custId);
	    }
	    else if ($('#callPrgm').val() == 'ORD_REGISTER_PAY_3RD_PARTY' || $('#callPrgm').val() == 'ORD_REQUEST_PAY') {
	        fn_loadThirdParty(custId, 1);
	    }
	    else if ($('#callPrgm').val() == 'ORD_MODIFY_PAY_3RD_PARTY') {
	        fn_loadThirdPartyPop(custId);
	    }
	    else{   //edit by hgham 2017-09-21    callback function (item) 추가  
	    	eval(${callPrgm}(item));
	    }
	    $('#custPopCloseBtn').click();
	}
	
    function fn_validSearchCustomer() {
        var isValid = true, msg = "";

        if($("#cmbTypeId option:selected").index() <= 0) {
            isValid = false;
            msg += "* Please select a customer type.<br>";
        }

        if(!isValid) Common.alert("Search Customer" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }
	
    function createAUIGrid() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "ID",              dataField : "custId",    width : 100 }
          , { headerText : "Type",            dataField : "codeName1", width : 100 }
          , { headerText : "Corp Type",       dataField : "codeName"   }
          , { headerText : "Name",            dataField : "name"       }
          , { headerText : "NRIC/Company No", dataField : "nric",      width : 170 }
          , { headerText : "custAddId",       dataField : "custAddId", visible : false }
          ];

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
        if(!fn_validSearchCustomer()) return false;
        Common.ajax("GET", "/sales/customer/selectCustomerJsonList", $("#custSearchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }    
</script>
</head>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Search Customer</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="custPopCloseBtn" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form id="custSearchForm" name="searchForm" action="#" method="post">
<input id="callPrgm" name="callPrgm" value="${callPrgm}" type="hidden" />
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
	<th scope="row">Customer Type<span class="must">*</span></th>
	<td>
	<select id="cmbTypeId" name="cmbTypeId" class="w100p"></select>
	</td>
	<th scope="row">Customer ID</th>
	<td><input id="_custId" name="custId" type="text" title="" placeholder="Customer ID (Numerci)" class="w100p" /></td>
</tr>
<tr>
	<th scope="row">Race</th>
	<td>
	<select id="cmbRaceId" name="raceId" class="w100p"></select>
	</td>
	<th scope="row">NRIC/Company Number</th>
	<td><input id="_nric" name="nric" type="text" title="" placeholder="NRIC/Company No." class="w100p" /></td>
</tr>
<tr>
	<th scope="row">Customer Name</th>
	<td colspan="3"><input id="_name" name="name" type="text" title="" placeholder="Customer Name" class="w100p" /></td>
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