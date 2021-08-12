<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
</style>

<script type="text/javaScript">
var TODAY_DD      = "${toDay}";

    //AUIGrid 생성 후 반환 ID
    var custGridID;
 // 소팅 정보 보관 객체
    var sortingInfo;
    // popup 크기
    var option = {
            width : "1200px",   // 창 가로 크기
            height : "500px"    // 창 세로 크기
    };

    var basicAuth = false;


    $(document).ready(function(){

        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

   //     AUIGrid.setSelectionMode(custGridID, "singleRow");


        //Search
        $("#_listSearchBtn").click(function() {

            //Validation
            // ticketNo  _reqstStartDt _reqstEndDt ticketType ticketStatus branchCode memberCode orderNo
           if(
        		    (null == $("#_reqstStartDt").val() || '' == $("#_reqstStartDt").val())
       		   && (null == $("#_reqstEndDt").val() || '' == $("#_reqstEndDt").val())
        		   ){

                //VA number
               /*  if($("#custVaNo").val() == null || $("#custVaNo").val() == ''){
                    Common.alert('<spring:message code="sal.alert.msg.plzKeyInAtleastOneOfTheCondition" />');
                    return;
                } */
            }

            fn_selectPstRequestDOListAjax();
        });


        //Basic Auth (update Btn)
        if('${PAGE_AUTH.funcUserDefine2}' == 'Y'){
            basicAuth = true;
        }
    });

    function createAUIGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "mobTicketNo",
                headerText : '<spring:message code="pay.title.ticketNo" />',
                width : 100,
                editable : false,
                cellMerge : true // 구분1 칼럼 셀 세로 병합 실행

            }, {
                dataField : "ticketTypeId",
                visible : false
            }, {
                dataField : "ticketTypeNm",
                headerText : '<spring:message code="pay.title.ticketType" />',
                width : 170,
                editable : false,
                cellMerge : true, // 구분1 칼럼 셀 세로 병합 실행
                mergeRef : "mobTicketNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
                mergePolicy : "restrict",
                style : "aui-grid-user-custom-left"
            }, {
                dataField : "ticketStusId",
                visible : false
            }, {
                dataField : "ticketStusNm",
                width : 170,
                headerText : '<spring:message code="pay.grid.status" />',
                editable : false,
                cellMerge : true, // 구분1 칼럼 셀 세로 병합 실행
                mergeRef : "mobTicketNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
                mergePolicy : "restrict",
                style : "aui-grid-user-custom-left"
            }, {

                dataField : "salesOrdNo",
                headerText : '<spring:message code="pay.title.orderNo" />',
                width : 160,
                editable : false,
                cellMerge : true,
                mergeRef : "mobTicketNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
                mergePolicy : "restrict"
            }, {
                dataField : "crtUserBrnchCd",
                headerText : '<spring:message code="pay.grid.branchCode" />',
                width : 170,
                editable : false,
                cellMerge : true, // 구분1 칼럼 셀 세로 병합 실행
                mergeRef : "mobTicketNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
                mergePolicy : "restrict"
            },{
                dataField : "updDt",
                visible : false
            },{
                dataField : "crtUserId",
                visible : false
            }, {
                dataField : "updUserNm",
                headerText : '<spring:message code="pay.grid.memberCode" />',
                width : 170,
                editable : false,
                cellMerge : true, // 구분1 칼럼 셀 세로 병합 실행
                mergeRef : "mobTicketNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
                mergePolicy : "restrict"
            }, {
                dataField : "crtDt",
                headerText : '<spring:message code="pay.grid.requestDate" />',
                width : 170,
                editable : false,
                cellMerge : true, // 구분1 칼럼 셀 세로 병합 실행
                mergeRef : "mobTicketNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
                mergePolicy : "restrict"
            },{
                dataField : "updUserId",
                visible : false
            }
            ]
     // 그리드 속성 설정
        var gridPros = {

            // 페이징 사용
            usePaging : false,

            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,

            editable : true,

            fixedColumnCount : 1,

            showStateColumn : false,

            displayTreeOpen : true,

       //     selectionMode : "multipleCells",

            headerHeight : 30,

            // 그룹핑 패널 사용
            useGroupingPanel : false,

            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,

            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,

            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,

            // 셀 병합 실행
            enableCellMerge : true,

            selectionMode : "singleRow",

            // 셀 병합 정책
            // "default"(기본값) : null 을 셀 병합에서 제외하여 병합을 실행하지 않습니다.
            // "withNull" : null 도 하나의 값으로 간주하여 다수의 null 을 병합된 하나의 공백으로 출력 시킵니다.
            // "valueWithNull" : null 이 상단의 값과 함께 병합되어 출력 시킵니다.
            cellMergePolicy : "default",

            // 셀머지된 경우, 행 선택자(selectionMode : singleRow, multipleRows) 로 지정했을 때 병합 셀도 행 선택자에 의해 선택되도록 할지 여부
            rowSelectionWithMerge : true

        };

        //custGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        custGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);

    }

    // 리스트 조회.
    function fn_selectPstRequestDOListAjax() {
        	Common.ajax("GET", "/mobileAppTicket/selectMobileAppTicketJsonList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(custGridID, result);
        }
        );
    }

    // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
    doGetCombo('/common/selectCodeList.do', '435', '','ticketType', 'S' , '');            // Customer Type Combo Box
    doGetCombo('/mobileAppTicket/selectMobileAppTicketStatus.do', '', '','ticketStatus', 'S' , '');            //

    // 조회조건 combo box
    function f_multiCombo(){
        $(function() {
            $('#cmbTypeId').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });
            $('#cmbCorpTypeId').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });

        });
    }

    function fn_clear(){
        $("#searchForm")[0].reset();
    }


</script>


<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Customer</li>
    <li>Customer</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="pay.title.text.mobileAppTicke" /></h2>

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="_listSearchBtn"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" action="#" method="post">
	    <table class="type1"><!-- table start -->
	    <caption>table</caption>
	    <colgroup>
	        <col style="width:140px" />
	        <col style="width:*" />
	        <col style="width:130px" />
	        <col style="width:*" />
	        <col style="width:170px" />
	        <col style="width:*" />
	    </colgroup>
	    <tbody>
	    <tr>
	        <th scope="row"><spring:message code="pay.title.ticketNo" /></th>
	        <td>
		        <input type="text" title="Ticket No" id="ticketNo" name="ticketNo" placeholder="Ticket No" class="w100p" />
	        </td>
	        <th scope="row"><spring:message code="pay.grid.requestDate" /></th>
	        <td>
	            <div class="date_set w100p"><!-- date_set start -->
	            <p><input id="_reqstStartDt" name="_reqstStartDt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" value="${bfDay}"/></p>
	            <span>To</span>
	            <p><input id="_reqstEndDt" name="_reqstEndDt" type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" value="${toDay}" /></p>
	            </div><!-- date_set end -->
	        </td>
	        <th scope="row"><spring:message code="pay.title.ticketType" /></th>
	        <td>
	            <select  id="ticketType" name="ticketType" class="w100p"></select>
	        </td>
	    </tr>
	    <tr>
	        <th scope="row"><spring:message code="pay.title.ticketStatus" /></th>
	        <td>
	          <select  id="ticketStatus" name="ticketStatus" class="w100p"></select>
	        </td>
	        <th scope="row"><spring:message code="pay.title.branchCode" /></th>
	        <td>
	          <input type="text" title="Branch Code" id="branchCode" name="branchCode" placeholder="Branch Code" class="w100p" />
	        </td>
	        <th scope="row"><spring:message code="pay.title.memberCode" /></th>
	        <td>
	            <input type="text" title="Member Code" id="memberCode" name="memberCode" placeholder="Member Code" class="w100p" />
	        </td>
	    </tr>
	    <tr>
	        <th scope="row"><spring:message code="pay.title.orderNo" /></th>
	        <td>
	          <input type="text" title="Order No" id="orderNo" name="orderNo" placeholder="Order No" class="w100p" />
	        </td>
	         <th scope="row"></th>
	        <td>
	        </select>
	        </td>
	        <th scope="row"></th>
	        <td></td>
	    </tr>
	    </tbody>
	    </table><!-- table end -->

    </form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width:100%; margin:0 auto;" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->
</section><!-- content end -->
