<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
.my_left_style {
    text-align:left;
}
</style>

<script type="text/javaScript">
    var option = {
        width : "1200px", // 창 가로 크기
        height : "500px" // 창 세로 크기
    };

    var myGridID;

    function fn_searchASManagement() {
        Common.ajax("GET", "/services/compensation/selCompensation.do", $(
                "#compensationForm").serialize(), function(result) {
            console.log("성공.");
            console.log(JSON.stringify(result));
            AUIGrid.setGridData(myGridID, result);
        });
    }

    $(document).ready(
            function() {

                // AUIGrid 그리드를 생성합니다.
                asManagementGrid();

                AUIGrid.setSelectionMode(myGridID, "singleRow");

                 // 171110 :: 선한이
                // 셀 더블클릭 이벤트 바인딩
                AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {

                    Common.popupDiv(
                            "/services/compensation/compensationViewPop.do?compNo="
                                    + compNo, null, null, true,
                            '_compensationViewPop');

                });

                AUIGrid.bind(myGridID, "cellClick", function(event) {
                    compNo = AUIGrid.getCellValue(myGridID, event.rowIndex,
                            "compNo");
                });

            });
    //[{"compNo":5,"custId":105482,"salesOrdNo":"0029781","asNo":"AS285943","asReqsterTypeId":1,"stusCodeId":1,"compDt":1513263600000,"compTotAmt":2000,"toChar(issueDt,'dd/mm/yyyy')/*issueddate*/":"23/12/2017","asDefectTypeId":1104,"asMalfuncResnId":1862,"stkDesc":"CP-01CL (LYON)","installDt":1254841200000,"serialNo":"10402CW90722700033"},
    //{"compNo":4,"custId":105482,"salesOrdNo":"0545982","asNo":"AS285943","asReqsterTypeId":1,"stusCodeId":1,"compDt":1513263600000,"compTotAmt":2000,"toChar(issueDt,'dd/mm/yyyy')/*issueddate*/":"15/12/2017","asDefectTypeId":1104,"asMalfuncResnId":1862}] 

    function asManagementGrid() {
        //AUIGrid 칼럼 설정
        var columnLayout = [ {
            dataField : "issueDt",
            headerText : "Application<br>Date",
            editable : false,
            width : 120
        }, {
            dataField : "custId",
            headerText : "Customer ID",
            editable : false,
            width : 100
        }, {
            dataField : "salesOrdNo",
            headerText : "Order<br>Number",
            editable : false,
            width : 100
        }, {
            dataField : "code",
            headerText : "DSC Branch",
            editable : false,
            width : 120,
            style : "my_left_style"
        }
        /* , {
            dataField : "asReqstDt",
            headerText : "Event<br>Date",
            editable : false,
            width : 120
        }, {
            dataField : "asDefectTypeId",
            headerText : "Event<br>Type",
            editable : false,
            width : 100
        } */
        , {
            dataField : "c3",
            headerText : "Cause",
            editable : false,
            style : "my-column",
            width : 100
        }, {
            dataField : "stkDesc",
            headerText : "Product",
            editable : false,
            width : 150
        }
        /* , {
            dataField : "salesOrdNo",
            headerText : "Person to<br>bear",
            editable : false,
            width : 100
        } */
        , {
            dataField : "compDt",
            headerText : "Complete<br>Date",
            width : 120
        }, {
            dataField : "compTotAmt",
            headerText : "RM",
            dataType : "numeric",
            width : 100
        }, {
            dataField : "stusCodeId",
            headerText : "Status",
            width : 100
        }, {
            dataField : "compNo",
            headerText : "compNo",
            width : 100,
            visible : false
        } ];
        // 그리드 속성 설정
        var gridPros = {
            //showRowCheckColumn : true,
            // 페이징 사용       
            usePaging : true,
            headerHeight : 30,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            // 전체 체크박스 표시 설정
            //showRowAllCheckBox : false,
            editable : false,
            selectionMode : "multipleCells"
        };

        myGridID = AUIGrid.create("#grid_wrap_compensation", columnLayout,
                gridPros);
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
        
        noDataMessage       :  gridMsg["sys.info.grid.noDataMessage"]

    };

    function fn_addCompPop() {
        Common.popupDiv("/services/compensation/compensationAddPop.do", null,
                null, true, '');
    }

    function fn_editCompPop() {
        var selectedItems = AUIGrid.getSelectedItems(myGridID);
        if (selectedItems.length <= 0) {
            Common.alert("<spring:message code='expense.msg.NoData'/> ");
            return;
        }

        Common.popupDiv("/services/compensation/compensationEditPop.do?compNo="
                + compNo, null, null, true, '_compensationEditPop');

    }

    $.fn.clearForm = function() {

        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form') {
                return $(':input', this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden'
                    || tag === 'textarea') {
                this.value = '';
            } else if (type === 'checkbox' || type === 'radio') {
                this.checked = false;
            } else if (tag === 'select') {
                this.selectedIndex = -1;
            }

        });
    };
</script>

<section id="content">
    <!-- content start -->
    <ul class="path">
        <li><img
            src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
            alt="Home" /></li>
        <li>Sales</li>
        <li>Order list</li>
    </ul>

    <aside class="title_line">
        <!-- title_line start -->

        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>
        </p>
        <!-- <h2>Compensation Log Search</h2> -->
        <h2><spring:message code="expense.title" /></h2>

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
            <!-- 171110 :: 선한이  -->
            <li><p class="btn_blue">
                    <a href="#" onClick="javascript:fn_searchASManagement()"><span class="search"></span><spring:message code="expense.btn.Search" /></a>
                </p></li>
            <li><p class="btn_blue">
                    <a href="#" onclick="javascript:$('#CompensationForm').clearForm();"><spanclass="clear"></span>Clear</a>
                </p></li>
        </ul>
    </aside>
    <!-- title_line end -->


    <section class="search_table">
        <!-- search_table start -->
        <form action="#" method="post" id="compensationForm">

            <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width: 150px" />
                    <col style="width: *" />
                    <col style="width: 140px" />
                    <col style="width: *" />
                    <col style="width: 170px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Order Number</th>
                        <td><input type="text" title="" placeholder="Order Number" class="w100p" id="orderNum" name="orderNum" /></td>
                        <th scope="row">Customer Code</th>
                        <td><input type="text" title="" placeholder="Customer Code" class="w100p" id="customerCode" name="customerCode" /></td>
                        <th scope="row">Application Date</th>
                        <td>
                            <div class="date_set w100p">
                                <!-- date_set start -->
                                <p>
                                    <input type="text" title="Create start Date"
                                        placeholder="DD/MM/YYYY" class="j_date"
                                        id="applicationStrDate" name="applicationStrDate" />
                                </p>
                                <span>To</span>
                                <p>
                                    <input type="text" title="Create end Date"
                                        placeholder="DD/MM/YYYY" class="j_date"
                                        id="applicationEndDate" name="applicationEndDate" />
                                </p>
                            </div>
                            <!-- date_set end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">DSC Branch</th>
                        <td>
                            <!-- <input type="text" title="" placeholder="DSC Branch" class="w100p" id="dscBranch" name="dscBranch" /> -->
                            <select id="code" name="code" class="w100p" placeholder="DSC Branch">
                                      <option value="">DSC Branch</option>
                               <c:forEach var="list" items="${branchWithNMList}" varStatus="status">
						             <option value="${list.codeId}">${list.codeName } </option>
						        </c:forEach>
						    </select>    
                        </td>
                        <th scope="row">Status</th>
                        <td>
                                 <select  class="w100p" id="status" name="status">
                                         <option value="1">Active</option>
                                        <option value="44">Pending</option>
                                        <option value="34">Solved</option>
                                        <option value="35">Unsolved</option>
                                        <option value="36">Closed</option>
                                        <option value="10">Cancelled</option>
                                </select> 
                        <!-- <input type="text" title="" placeholder="Status" class="w100p" id="status" name="status" /> -->
                        </td>
                       <th scope="row"></th>
                       <td></td>
                    </tr>
                    <!-- 171115 :: 선한이  -->
                   <!--  <tr>
                        <th scope="row">Cause of Compensation</th>
                        <td><input type="text" title=""
                            placeholder="Cause of Compensation" class="w100p"
                            id="causeOfCompensation" name="causeOfCompensation" /></td>
                        
                        <th scope="row">Event Type</th>
                        <td><input type="text" title="" placeholder="Event Type" class="w100p" id="eventType" name="eventType" /></td>
                         <th scope="row">Compensation Type</th>
                        <td><input type="text" title="" placeholder="Compensation Type" class="w100p"
                            id="compensationType" name="compensationType" /></td>
                        <th scope="row">Responsibility Type</th>
                        <td><input type="text" title=""
                            placeholder="Responsibility Type" class="w100p"
                            id="ResponsibilityType" name="ResponsibilityType" /></td>
                    </tr> -->

                </tbody>
            </table>
            <!-- table end -->

            <ul class="right_btns">
                <li><p class="btn_grid">
                        <a href="#" onClick="fn_addCompPop()">Add Case</a>
                    </p></li>
                <li><p class="btn_grid">
                        <a href="#" onClick="fn_editCompPop()">Edit Case</a>
                    </p></li>
            </ul>

            <article class="grid_wrap">
                <!-- grid_wrap start -->
                <div id="grid_wrap_compensation"
                    style="width: 100%; height: 500px; margin: 0 auto;"></div>
            </article>
            <!-- grid_wrap end -->

        </form>
        <form action="#" id="reportForm" method="post">
            <input type="hidden" id="V_RESULTID" name="V_RESULTID" />
        </form>
    </section>
    <!-- search_table end -->

</section>
<!-- content end -->
