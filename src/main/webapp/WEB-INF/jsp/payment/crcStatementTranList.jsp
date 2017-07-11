<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
    
<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID;

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
    // AUIGrid 그리드를 생성합니다.
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout);
    
    var auiGridProps = {
            selectionMode : "multipleCells",
            enableSorting : true,               // 정렬 사용            
            editable : true,                       // 편집 가능 여부 (기본값 : false)
            enableMovingColumn : true,      // 칼럼 이동 가능 설정
            wrapSelectionMove : true         // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부            
    };

    // 그리드 생성
    myGridID = AUIGrid.create("#grid_wrap", columnLayout, auiGridProps);
});

// AUIGrid 칼럼 설정
var columnLayout = [ 
    {         
        dataField : "crcTrnscId",
        headerText : "ID",
        editable : false,
        visible : false,
        width : 120
    },
    {
        dataField : "crcTrnscDt",
        headerText : "Transaction Date",
        editable : false
    }, {
        dataField : "crcTrnscNo",
        headerText : "CRC No.",
        editable : false
    }, {
        dataField : "crcTrnscAppv",
        headerText : "Approval No.",
        editable : false
    }, {
        dataField : "crcTrnscMid",
        headerText : "MID No.",
        editable : true
    }, {
        dataField : "crcTrnscRefNo",
        headerText : "Ref No.",
        editable : true
    }, {
        dataField : "crcTrnscAmt",
        headerText : "Gross Amount",
        dataType : "numeric",
        editable : true
    }];


// 리스트 조회.
function fn_getCRCStatementListAjax() {        
    Common.ajax("GET", "/payment/selectCRCStatementTranList", $("#searchForm").serialize(), function(result) {
    	AUIGrid.setGridData(myGridID, result);
    });
}

// 수정모드로 변환 : 현재 호출 버튼 없음
function fn_setEditProp (){ 
     AUIGrid.setColumnProp( myGridID, 4, {  editable : true } );
     AUIGrid.setColumnProp( myGridID, 5, {  editable : true } );
     AUIGrid.setColumnProp( myGridID, 6, {  editable : true } );
}
 
// 수정 처리
function fn_saveGridMap(){
    Common.ajax("POST", "/payment/updateCRCStatementTranList.do", GridCommon.getEditData(myGridID), function(result) {
    	alert("UPDATE SUCCESS");
        resetUpdatedItems(); // 초기화
        
        fn_getCRCStatementListAjax();
        
    },  function(jqXHR, textStatus, errorThrown) {
        try {
            console.log("status : " + jqXHR.status);
            console.log("code : " + jqXHR.responseJSON.code);
            console.log("message : " + jqXHR.responseJSON.message);
            console.log("detailMessage : "
                    + jqXHR.responseJSON.detailMessage);
        } catch (e) {
            console.log(e);
        }
        alert("Fail : " + jqXHR.responseJSON.message);
        
        fn_getCRCStatementListAjax();
    });
  
    
}

// 그리드 초기화.
function resetUpdatedItems() {
     AUIGrid.resetUpdatedItems(myGridID, "a");
 }
</script>
<!-- content start -->
<div id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/image/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Reconciliation</li>
        <li>Credit Card Statement</li>
    </ul>

    <!-- title_line start -->
    <div class="title_line">
        <p class="fav"><img src="${pageContext.request.contextPath}/resources/image/icon_star.gif" alt="즐겨찾기" /></p>
        <h2>Credit Card Statement</h2>
        <ul class="right_opt">
            <li><p class="btn_blue"><a href="javascript:fn_saveGridMap();">Save</a></p></li>
        </ul>
    </div>
    <!-- title_line end -->

    <!-- search_table start -->
    <div class="search_table">
        <form name="searchForm" id="searchForm">
            <!-- table start -->
            <table summary="search table" class="type1">
                <caption>search table</caption>
                    <colgroup>
					    <col style="width:144px" />
					    <col style="width:*" />
					    <col style="width:144px" />
					    <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
						    <th scope="row">Reference No.</th>
						    <td><input type="text" title="Reference No." id="refNo" name="refNo" /></td>						    
						    <th scope="row"></th>
						    <td></td>
                        </tr>
                        <tr>
                            <th scope="row">Card Account</th>
                            <td>
                                <select id="cardAccount" name="cardAccount">
                                    <option value="" selected>Select CRC Account</option>
                                    <c:forEach var="crcList" items="${ cardComboList}" varStatus="status">
                                        <option value="${crcList.accId}">${crcList.accDesc2}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <th scope="row">Status</th>
						    <td>
						          <select id="status" name="status">
						              <option value="" selected>Select Status</option>
						              <option value="ALL">ALL</option>
						              <option value="1">Active</option>
						              <option value="36">InActive</option>
						          </select>
						    </td>
                        </tr>
						<tr>
						  <th scope="row">Account No</th>
						  <td>
						        <select id="account" name="account">
                                <option value="" selected>Select Account</option>
                                <c:forEach var="bankList" items="${ bankComboList}" varStatus="status">
                                    <option value="${bankList.accId}">${bankList.accDesc2}</option>
                                </c:forEach>                                
                            </select>
						</td>
						<th scope="row">Uploaded Dated</th>
						<td>
							<input type="text" name="updateDt1" id="updateDt1" title="Uploaded Dated" placeholder="DD/MM/YYYY" class="j_date" />
							To
							<input type="text" name="updateDt2" id="updateDt2" title="Uploaded Dated" placeholder="DD/MM/YYYY" class="j_date" />
						</td>
						</tr>
                    </tbody>
            </table>
            <!-- table end -->

            <ul class="right_btns">
                <li><p class="btn_gray"><a href="javascript:fn_getCRCStatementListAjax();"><span class="search"></span>Search</a></p></li>
            </ul>
        </form>
    </div>
    <!-- search_table end -->

    <!-- search_result start -->
    <div class="search_result">
        <!-- grid_wrap start -->
        <div id="grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
        <!-- grid_wrap end -->
    </div>
    <!-- search_result end -->
</div>
<!-- content end -->
        
