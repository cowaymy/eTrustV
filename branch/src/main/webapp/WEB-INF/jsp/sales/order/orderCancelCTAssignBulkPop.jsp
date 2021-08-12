<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

	//AUIGrid 생성 후 반환 ID
	var myBulkdGridID;
    var selectCTBulkList = null;
    
    $(document).ready(function(){
    	$.ajax({
            type: 'get',
            url : getContextPath() + '/sales/order/selectCTBulkJsonList.do',
            //data : {groupCode : grpCode},
            dataType : 'json',
            async : false,
            //beforeSend: function (request) {
                 // loading start....
              //   Common.showLoader();
            // },
             //complete: function (data) {
                 // loading end....
               //  Common.removeLoader();
             //},
             success: function(result) {
                 var tempArr = new Array();
                 
                 for (var idx = 0; idx < result.length; idx++) {
                     tempArr.push(result[idx]); 
                 }
                 selectCTBulkList = tempArr; 
                 
            },error: function () {
                Common.alert("Fail to Get Code List....");
            }
            
        });

        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        
//        AUIGrid.setSelectionMode(myBulkdGridID, "singleRow");
        
        // 에디팅 시작 이벤트 바인딩
        AUIGrid.bind(myBulkdGridID, "cellEditBegin", auiCellEditignHandler);
        
    });
    
    
  //AUIGrid 메소드
    function auiCellEditignHandler(event)
    {
        if(event.type == "cellEditBegin")
        {
            console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
            //var menuSeq = AUIGrid.getCellValue(myGridID, event.rowIndex, 9);
            
            if(event.dataField == "salesmanId")
            {
                // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
                if(AUIGrid.getCellValue(myBulkdGridID,event.rowIndex ,"checkConfim")=='1'){  //추가된 Row
                    return true; 
                } else {
                    return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
                }
            }
        }
    }

	
function createAUIGrid() {
    // AUIGrid 칼럼 설정
    
    // 데이터 형태는 다음과 같은 형태임,
    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
    var columnLayout = [ {
            dataField : "code1",
            headerText : "<spring:message code='sal.text.type' />",
            width : 70,
            editable : false
        }, {
            dataField : "name1",
            headerText : "<spring:message code='sal.text.custName' />",
            width : 130,
            editable : false
        }, {
            dataField : "salesOrdNo",
            headerText : "<spring:message code='sal.title.text.ordNop' />",
            width : 90,
            editable : false
        }, {
            dataField : "retnNo",
            headerText : "<spring:message code='sal.title.text.returnNo' />",
            width : 100,
            editable : false
        }, {
            dataField : "stkDesc",
            headerText : "<spring:message code='sal.text.model' />",
            width : 100,
            editable : false
        }, {
            dataField : "memCodeName",
            headerText : "<spring:message code='sal.text.currentCt' />",
            editable : false
        }, {
            dataField : "salesmanId",
            headerText : "<spring:message code='sal.text.newAssignCt' />",
            width : 130,
            labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
                var retStr = "";
                for(var i=0,len=selectCTBulkList.length; i<len; i++) {
                    if(selectCTBulkList[i]["memId"] == value) {
                        retStr = selectCTBulkList[i]["memCodeNameCombo"];
                        break;
                    }
                }
                            return retStr == "" ? value : retStr;
            },
            editRenderer : { // 셀 자체에 드랍다운리스트 출력하고자 할 때
                type : "DropDownListRenderer",
                list : selectCTBulkList,
                keyField   : "memId",           // key 에 해당되는 필드명
                valueField : "memCodeNameCombo"           // value 에 해당되는 필드명
               }
        }, {
            dataField : "checkConfim",
            headerText : "<spring:message code='sal.text.confirm' />",
            width : 70,
            renderer : { 
                type : "CheckBoxEditRenderer", 
                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue : "1", // true, false 인 경우가 기본
                unCheckValue : "0"
            }
        },{
            dataField : "stkRetnId" , 
            visible : false 
          },{
              dataField : "stockId" , 
              visible : false 
          },{
              dataField : "ctGrp" , 
              visible : false 
          }];
    
 // 그리드 속성 설정
    var gridPros = {
        
        // 페이징 사용       
        usePaging : true,
        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 10,
        editable : true,
        fixedColumnCount : 1,
        showStateColumn : false, 
        displayTreeOpen : true,
        selectionMode : "multipleCells",
        headerHeight : 30,
        // 그룹핑 패널 사용
        useGroupingPanel : false,
        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,
        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,
        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true,
        groupingMessage : "Here groupping"
    };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myBulkdGridID = AUIGrid.create("#bulk_grid_wrap", columnLayout, gridPros);
}

    doGetCombo('/common/selectCodeList.do', '10', '','cmbAppTypeBulk', 'M' , 'f_multiCombo');            // Application Type Combo Box

	//조회조건 combo box
	function f_multiCombo(){
	    $(function() {
	        $('#cmbAppTypeBulk').change(function() {
	        
	        }).multipleSelect({
	            selectAll: true, // 전체선택 
	            width: '80%'
	        });
	        $('#cmbAppTypeBulk').multipleSelect("checkAll");
	    });
	}
	
	/* 멀티셀렉트 플러그인 start */
	$('.multy_select').change(function() {
	   //console.log($(this).val());
	})
	.multipleSelect({
	   width: '100%'
	});
	$('#cmbPRType').multipleSelect("checkAll");
	
	// 리스트 조회.
    function fn_orderCancelBulkAjax() {
		
		if(searchBulkForm.dpAppointmentDate.value == ""){
			Common.alert("<spring:message code='sal.pleaseSelectInstallationDate' />");
			return false;
		}

		if(searchBulkForm.cmbDscBranchBulk.value == ""){
            if(searchBulkForm.cmbCtCodeBulk.value == ""){
            	Common.alert("<spring:message code='sal.pleaseSelectTheCtCodeOrDSCBranch' />");
            	return false;
            }else{
            	return;
            }
        }
        Common.ajax("GET", "/sales/order/orderCancelJsonBulk.do", $("#searchBulkForm").serialize(), function(result) {
            AUIGrid.setGridData(myBulkdGridID, result);
        });
    }
	
	function fn_bulkSave(){
//		var checkedItems = AUIGrid.getCheckedRowItems(myBulkdGridID);
//		alert(AUIGrid.getCheckedRowItems(myBulkdGridID));
//        if(checkedItems.length <= 0 ) {
//            alert("You must change at least one CT.");
//            return false;
//        }
        
        var updateList = AUIGrid.getEditedRowItems(myBulkdGridID);
        
        if(updateList == null || updateList.length <= 0 ){
            Common.alert("<spring:message code='sal.alert.msg.noDataChange' />");
            return;
        }
        
        var bulkDataSetList = GridCommon.getEditData(myBulkdGridID);
        var saveList = bulkDataSetList.update;
//        var OrderCancelCtBulkVO = {bulkDataSetList : GridCommon.getEditData(myBulkdGridID)};
        
		Common.ajax("POST", "/sales/order/saveCancelBulk.do", {saveList : saveList}, function(result){
            //result alert and reload
            Common.alert("Success", fn_success);
        }, function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
    
                //Common.alert("Failed to order invest reject.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                Common.alert("Unable to retrieve exchange request in system.");
                }
            catch (e) {
                console.log(e);
                alert("Saving data prepration failed.");
            }
            alert("Fail : " + jqXHR.responseJSON.message);
            });
	}
	
	function fn_success(){
		fn_orderCancelListAjax();
        
        $("#bulkClose").click();
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.changeAssignCTBulk" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="bulkClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="fn_orderCancelBulkAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchBulkForm" name="searchBulkForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.productReturnType" /></th>
    <td>
	    <select class="multy_select w100p" multiple="multiple" id="cmbPRType" name="cmbPRType">
	        <option value="296"><spring:message code="sal.combo.orderCancelProductReturn" /></option>
	        <option value="297"><spring:message code="sal.combo.productExchangeProductReturn" /></option>
	    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.appointmentDate" /></th>
    <td><input type="text" id="dpAppointmentDate" name="dpAppointmentDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.dscBrnch" /></th>
    <td>
        <select id="cmbDscBranchBulk" name="cmbDscBranchBulk" class="w100p">
            <option value=""><spring:message code="sal.title.text.dscBrnch" /></option>
            <c:forEach var="list" items="${dscBranchList }">
                <option value="${list.brnchId }">${list.brnchName }</option>
            </c:forEach>
        </select>
    </td>
    <th scope="row"><spring:message code="sal.text.application" /></th>
    <td>
	    <select id="cmbAppTypeBulk" name="cmbAppTypeBulk" class="multy_select w100p" multiple="multiple">
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ctGroup" /></th>
    <td>
    <select class="w100p" id="cmbCTGrpBulk" name="cmbCTGrpBulk">
        <option value="A">A</option>
        <option value="B">B</option>
        <option value="C">C</option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.ctCode" /></th>
    <td>
	    <select id="cmbCtCodeBulk" name="cmbCtCodeBulk" class="w100p">
	        <option value=""><spring:message code="sal.text.ctCode" /></option>
	        <c:forEach var="list" items="${selectAssignCTList }">
	            <option value="${list.memId}">${list.memCode} - ${list.memCodeName}</option>
	        </c:forEach>
	    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.sortBy" /></th>
    <td colspan="3">
    <select class="w100p" id="sortBy" name="sortBy">
        <option value="0"><spring:message code="sal.combo.noSorting" /></option>
        <option value="1"><spring:message code="sal.combo.retNumber" /></option>
        <option value="2"><spring:message code="sal.text.ordNum" /></option>
        <option value="3"><spring:message code="sal.text.ctCode" /></option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="bulk_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="fn_bulkSave()" ><spring:message code="sal.btn.save" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->