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
    var myGridID ;
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

        AUIGrid.setSelectionMode(myGridID , "singleRow");


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

            fn_selectRequestBillingGroupListAjax();
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
                editable : false
            }, {
                dataField : "crtDt",
                headerText : '<spring:message code="pay.grid.requestDate" />',
                width : 160,
                editable : false
            }, {
                dataField : "reqStusNm",
                width : 120,
                headerText : '<spring:message code="sys.status" />',
                editable : false,
                style : "aui-grid-user-custom-left"
            }, {
                dataField : "salesOrdNo",
                headerText : '<spring:message code="pay.title.orderNo" />',
                width : 120,
                editable : false
            }, {
                dataField : "custBillNmOld",
                width : 140,
                headerText : '<spring:message code="pay.head.currentGroup" />',
                editable : false
            }, {
                dataField : "custBillNmNw",
                headerText : '<spring:message code="pay.head.newGroup" />',
                width : 140,
                editable : false
            }, {
		        dataField : "salesOrdNoNm",
		        headerText : '<spring:message code="pay.head.newGroupMain" />',
		        width : 140,
		        editable : false
		    },{
                dataField : "rem",
                headerText : '<spring:message code="pay.head.remark" />',
                width : 160,
                editable : false,
                style : "aui-grid-user-custom-left"
            }, {
                dataField : "crtUserBrnchCd",
                headerText : '<spring:message code="pay.title.branchCode" />',
                width : 120,
                editable : false
            }, {
                dataField : "crtUserNm",
                headerText : '<spring:message code="pay.head.memberCode" />',
                width : 120,
                editable : false
            }, {
            	dataField : "updUserNm",
                headerText : '<spring:message code="pay.head.updateUser" />',
                width : 120,
                editable : false,
                style : "aui-grid-user-custom-left"

            }, {
            	dataField : "updDt",
                headerText : '<spring:message code="pay.text.updDt" />',
                width : 160,
                editable : false
            }, {
                dataField : "reqStusId",
                visible : false
            }, {
                dataField : "reqSeqNo",
                visible : false
            }
            ]
     // 그리드 속성 설정
        var gridPros = {

            // 페이징 사용
            usePaging : true,

            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,

            editable : true,

            /* fixedColumnCount : 1, */

            showStateColumn : false,

            displayTreeOpen : true,

            selectionMode : "singleRow",

            headerHeight : 30,

            // 그룹핑 패널 사용
            useGroupingPanel : false,

            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,

            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,

            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true

        };

        //myGridID  = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID  = AUIGrid.create("#grid_wrap", columnLayout, gridPros);

    }

    // 리스트 조회.
    function fn_selectRequestBillingGroupListAjax() {
        	Common.ajax("GET", "/payment/requestBillingGroup/selectRequestBillingGroupJsonList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID , result);
        }
        );
    }

    // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
    doGetCombo('/mobileAppTicket/selectMobileAppTicketStatus.do', '', '','reqStusId', 'S' , '');            //

    function fn_clear(){
        $("#searchForm")[0].reset();
    }

    // 엑셀다운로드
    function fn_excelDown(){
        // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
        GridCommon.exportTo("grid_wrap", "xlsx", "Request Billing Group Search");
    }

    // reject 처리
    function fn_reject(){
        var indexArr = AUIGrid.getSelectedIndex(myGridID);
        if( indexArr[0] == -1 ){
            Common.alert("<spring:message code='pay.check.noRowsSelected'/>");

        }else{
            var reqStusId = AUIGrid.getCellValue(myGridID, indexArr[0], "reqStusId");
            if( reqStusId != 1 ){
            	Common.alert("<spring:message code='pay.check.reqStusId'/>");
            }else{
                Common.prompt("<spring:message code='pay.prompt.reject'/>", "", function(){
                    if( FormUtil.isEmpty($("#promptText").val()) ){
                        Common.alert("<spring:message code='pay.check.rejectReason'/>");

                    }else{
                        var rejectData = AUIGrid.getSelectedItems(myGridID)[0].item;
                        rejectData.etc = $("#promptText").val();

                        Common.ajaxSync("POST", "/payment/requestBillingGroup/saveRequestBillingGroupReject.do", rejectData, function(result) {
                            if(result !=""  && null !=result ){
                                Common.alert("<spring:message code='pay.alert.reject'/>", function(){
                                	fn_selectRequestBillingGroupListAjax();
                                });
                            }
                        });

                    }
                });
             }
        }
    }

    // approve 처리
    function fn_approve(){
        var indexArr = AUIGrid.getSelectedIndex(myGridID);
        if( indexArr[0] == -1 ){
            Common.alert("<spring:message code='pay.check.noRowsSelected'/>");
        }else{
            var reqStusId = AUIGrid.getCellValue(myGridID, indexArr[0], "reqStusId");
            if( reqStusId != 1 ){
                Common.alert("<spring:message code='pay.check.reqStusId'/>");
            }else{
                Common.confirm("<spring:message code='pay.confirm.approve'/>", function(){

                    Common.ajaxSync("POST", "/payment/requestBillingGroup/saveRequestBillingGroupArrpove.do", AUIGrid.getSelectedItems(myGridID)[0].item , function(result) {
                        if(result !=""  && null !=result ){
                            Common.alert("<spring:message code='pay.alert.approve'/>", function(){
                            	fn_selectRequestBillingGroupListAjax();
                            });
                        }
                    });

                });
            }
        }
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
<h2><spring:message code="pay.title.text.requestBillingGroup" /></h2>

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
        <th scope="row"><spring:message code="pay.title.orderNo" /></th>
        <td>
          <input type="text" title="Order No" id="orderNo" name="orderNo" placeholder="Order No" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="pay.title.ticketStatus" /></th>
        <td>
          <select  id="reqStusId" name="reqStusId" class="w100p"></select>
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
    </tbody>
    </table><!-- table end -->

    </form>
</section><!-- search_table end -->

    <ul class="right_btns">
         <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid"><a href="#" onClick="fn_excelDown()"><spring:message code="pay.btn.exceldw" /></a></p></li>
         </c:if>
	    <li><p class="btn_grid"><a href="#" onClick="fn_approve()"><spring:message code="pay.btn.approve" /> </a></p></li>
	    <li><p class="btn_grid"><a href="#" onClick="fn_reject()"><spring:message code="pay.btn.reject" /> </a></p></li>

    </ul>

<section class="search_result"><!-- search_result start -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width:100%; margin:0 auto;" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->

</section><!-- content end -->
