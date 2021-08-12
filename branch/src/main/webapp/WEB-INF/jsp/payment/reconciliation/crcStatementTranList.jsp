<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
        headerText : "<spring:message code='pay.head.id'/>",
        editable : false,
        visible : false,
        width : 120
    },
    {
        dataField : "crcTrnscDt",
        headerText : "<spring:message code='pay.head.transactionDate'/>",
        editable : false
    }, {
        dataField : "crcTrnscNo",
        headerText : "<spring:message code='pay.head.crcNo'/>",
        editable : false
    }, {
        dataField : "crcTrnscAppv",
        headerText : "<spring:message code='pay.head.approvalNo'/>",
        editable : false
    }, {
        dataField : "crcTrnscMid",
        headerText : "<spring:message code='pay.head.midNo'/>",
        editable : true
    }, {
        dataField : "crcTrnscRefNo",
        headerText : "<spring:message code='pay.head.refNo'/>",
        editable : true
    }, {
        dataField : "crcTrnscAmt",
        headerText : "<spring:message code='pay.head.grossAmount'/>",
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
    	Common.setMsg("UPDATE SUCCESS");    	
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
        Common.alert("Fail : " + jqXHR.responseJSON.message);
        
        fn_getCRCStatementListAjax();
    });
  
    
}

// 그리드 초기화.
function resetUpdatedItems() {
     AUIGrid.resetUpdatedItems(myGridID, "a");
 }
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/image/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Credit Card Statement</h2>
        <ul class="right_opt">
            <li><p class="btn_blue"><a href="javascript:fn_saveGridMap();"><spring:message code='pay.btn.save'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->
    
    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm">
	        <!-- table start -->
            <table class="type1">
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
					       <div class="date_set"><!-- date_set start -->
					       <p><input type="text"  name="updateDt1" id="updateDt1" title="Uploaded Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text"  name="updateDt2" id="updateDt2" title="Uploaded Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div><!-- date_set end -->
                        </td>
	                </tr>
                </tbody>
            </table>
            <!-- table end -->

            <ul class="right_btns">
                <li><p class="btn_gray"><a href="javascript:fn_getCRCStatementListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            </ul>
        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">
        
        <!-- link_btns_wrap start -->
        <aside class="link_btns_wrap">
            <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/image/btn_link.gif" alt="link show" /></a></p>
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
	                <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/image/btn_link_close.gif" alt="hide" /></a></p>
	            </dd>
	        </dl>
        </aside>
        <!-- link_btns_wrap end -->
        
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
        
        <!-- bottom_msg_box start -->
        <aside class="bottom_msg_box">            
        </aside>
        <!-- bottom_msg_box end -->

    </section>
    <!-- search_result end -->

</section>
<!-- content end -->