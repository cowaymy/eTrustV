<!--=================================================================================================
* Task  : Service
* File Name : codyPerformanceReport.jsp
* Description :6Mth Performance Report(Cody)
* Author : KR-OHK
* Date : 2019-11-06
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-11-06  KR-OHK        Init
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javascript">

    var scmGridID;

    var rescolumnLayout = [
                     {dataField: "stusNm",headerText :" ",width: 220, height:20},
                     {dataField: "past6monVal",headerText :"<spring:message code='service.grid.past6Month'/>", width: 120, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                     {dataField: "past5monVal",headerText :"<spring:message code='service.grid.past5Month'/>", width: 120, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                     {dataField: "past4monVal",headerText :"<spring:message code='service.grid.past4Month'/>", width: 120, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                     {dataField: "past3monVal",headerText :"<spring:message code='service.grid.past3Month'/>", width: 120, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                     {dataField: "past2monVal",headerText :"<spring:message code='service.grid.past2Month'/>", width: 120, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                     {dataField: "past1monVal",headerText :"<spring:message code='service.grid.past1Month'/>", width: 120, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                     {dataField: "avgVal",headerText :"<spring:message code='service.grid.average'/>", width: 120, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                     {dataField: "currmonVal",headerText :"<spring:message code='service.grid.selectMonth'/>", width: 120, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},

             ];
    var rescolumnLayout2 = [
                           {dataField: "stusNm",headerText :" ",width: 220, height:20},
                           {dataField: "past6monVal",headerText :"<spring:message code='service.grid.past6Month'/>", width: 120, height:20},
                           {dataField: "past5monVal",headerText :"<spring:message code='service.grid.past5Month'/>", width: 120, height:20},
                           {dataField: "past4monVal",headerText :"<spring:message code='service.grid.past4Month'/>", width: 120, height:20},
                           {dataField: "past3monVal",headerText :"<spring:message code='service.grid.past3Month'/>", width: 120, height:20},
                           {dataField: "past2monVal",headerText :"<spring:message code='service.grid.past2Month'/>", width: 120, height:20},
                           {dataField: "past1monVal",headerText :"<spring:message code='service.grid.past1Month'/>", width: 120, height:20},
                           {dataField: "avgVal",headerText :"<spring:message code='service.grid.average'/>", width: 120, height:20},
                           {dataField: "currmonVal",headerText :"<spring:message code='service.grid.selectMonth'/>", width: 120, height:20}

                   ];

    // 그리드 속성 설정
    var gridPros = {
        // 페이징 사용
        usePaging: false,
        editable: false,
        showStateColumn: false,
        selectionMode: "multipleCells",
        headerHeight: 30
    };

    $(document).ready(function () {

        // Happy Call
        hcGridID = GridCommon.createAUIGrid("grid_hc_list", rescolumnLayout,'',gridPros);

        // Heart Service
        hsOaGridID = GridCommon.createAUIGrid("grid_hsoa_list", rescolumnLayout,'',gridPros);
        hsInGridID = GridCommon.createAUIGrid("grid_hsin_list", rescolumnLayout,'',gridPros);
        hsCoGridID = GridCommon.createAUIGrid("grid_hsco_list", rescolumnLayout,'',gridPros);
        hsCoRtGridID = GridCommon.createAUIGrid("grid_hscort_list", rescolumnLayout,'',gridPros);

        // Rental Collection
        rcOaGridID = GridCommon.createAUIGrid("grid_rcoa_list", rescolumnLayout,'',gridPros);
        rcInGridID = GridCommon.createAUIGrid("grid_rcin_list", rescolumnLayout,'',gridPros);
        rcCoGridID = GridCommon.createAUIGrid("grid_rcco_list", rescolumnLayout,'',gridPros);

        // Sales
        salesOaGridID = GridCommon.createAUIGrid("grid_salesoa_list", rescolumnLayout,'',gridPros);
        salesInGridID = GridCommon.createAUIGrid("grid_salesin_list", rescolumnLayout,'',gridPros);
        salesCoGridID = GridCommon.createAUIGrid("grid_salesco_list", rescolumnLayout,'',gridPros);

        // Outlight SVM
        svmOaGridID = GridCommon.createAUIGrid("grid_svmoa_list", rescolumnLayout,'',gridPros);
        svmInGridID = GridCommon.createAUIGrid("grid_svmin_list", rescolumnLayout,'',gridPros);
        svmCoGridID = GridCommon.createAUIGrid("grid_svmco_list", rescolumnLayout,'',gridPros);

        // Retention
        rtOaGridID = GridCommon.createAUIGrid("grid_rtoa_list", rescolumnLayout,'',gridPros);
        rtInGridID = GridCommon.createAUIGrid("grid_rtin_list", rescolumnLayout,'',gridPros);
        rtCoGridID = GridCommon.createAUIGrid("grid_rtco_list", rescolumnLayout,'',gridPros);

        //CFF
        cffGridID = GridCommon.createAUIGrid("grid_cff_list", rescolumnLayout,'',gridPros);
        // PE
        peGridID = GridCommon.createAUIGrid("grid_pe_list", rescolumnLayout2,'',gridPros);


        $('#_memBtn').click(function() {
            Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
        });
        $('#codyCode').change(function(event) {
            var memCd = $('#codyCode').val().trim();

            if(FormUtil.isNotEmpty(memCd)) {
                fn_loadOrderSalesman('', memCd);
            }
        });
        $('#codyCode').keydown(function (event) {
            if (event.which === 13) {    //enter
                var memCd = $('#codyCode').val().trim();

                if(FormUtil.isNotEmpty(memCd)) {
                    fn_loadOrderSalesman('', memCd);
                }
                return false;
            }
        });

        //excel Download
        $('#excelDownHc').click(function() {
           GridCommon.exportTo("grid_hc_list", 'xlsx', "Happy Call 6Mth Performance Report(Cody)");
        });

        $('#excelDownHsOa').click(function() {
           GridCommon.exportTo("grid_hsoa_list", 'xlsx', "Heart Service Overall 6Mth Performance Report(Cody)");
        });
        $('#excelDownHsIn').click(function() {
            GridCommon.exportTo("grid_hsin_list", 'xlsx', "Heart Service Individual 6Mth Performance Report(Cody)");
        });
        $('#excelDownHsCo').click(function() {
            GridCommon.exportTo("grid_hsco_list", 'xlsx', "Heart Service Corporate 6Mth Performance Report(Cody)");
        });
        $('#excelDownHsCoRt').click(function() {
            GridCommon.exportTo("grid_hscort_list", 'xlsx', "Heart Service Corporate Ratio 6Mth Performance Report(Cody)");
        });

        $('#excelDownRcOa').click(function() {
            GridCommon.exportTo("grid_rcoa_list", 'xlsx', "Rental Collection Overall 6Mth Performance Report(Cody)");
        });
        $('#excelDownRcIn').click(function() {
            GridCommon.exportTo("grid_rcin_list", 'xlsx', "Rental Collection Individual 6Mth Performance Report(Cody)");
        });
        $('#excelDownRcCo').click(function() {
            GridCommon.exportTo("grid_rcco_list", 'xlsx', "Rental Collection Corporate 6Mth Performance Report(Cody)");
        });

        $('#excelDownSalesOa').click(function() {
            GridCommon.exportTo("grid_salesoa_list", 'xlsx', "Sales Collection Overall 6Mth Performance Report(Cody)");
        });
        $('#excelDownSalesIn').click(function() {
            GridCommon.exportTo("grid_salesin_list", 'xlsx', "Sales Collection Individual 6Mth Performance Report(Cody)");
        });
        $('#excelDownSalesCo').click(function() {
            GridCommon.exportTo("grid_salesco_list", 'xlsx', "Sales Collection Corporate 6Mth Performance Report(Cody)");
        });

        $('#excelDownSvmOa').click(function() {
            GridCommon.exportTo("grid_svmoa_list", 'xlsx', "Outright SVM Overall 6Mth Performance Report(Cody)");
        });
        $('#excelDownSvmIn').click(function() {
            GridCommon.exportTo("grid_svmin_list", 'xlsx', "Outright SVM Individual 6Mth Performance Report(Cody)");
        });
        $('#excelDownSvmCo').click(function() {
            GridCommon.exportTo("grid_svmco_list", 'xlsx', "Outright SVM Corporate 6Mth Performance Report(Cody)");
        });

        $('#excelDownRtOa').click(function() {
            GridCommon.exportTo("grid_rtoa_list", 'xlsx', "Retention Overall 6Mth Performance Report(Cody)");
        });
        $('#excelDownRtIn').click(function() {
            GridCommon.exportTo("grid_rtin_list", 'xlsx', "Retention Individual 6Mth Performance Report(Cody)");
        });
        $('#excelDownRtCo').click(function() {
            GridCommon.exportTo("grid_rtco_list", 'xlsx', "Retention Corporate 6Mth Performance Report(Cody)");
        });

        $('#excelDownCff').click(function() {
            GridCommon.exportTo("grid_cff_list", 'xlsx', "CFF Overall 6Mth Performance Report(Cody)");
         });

        $('#excelDownPe').click(function() {
            GridCommon.exportTo("grid_pe_list", 'xlsx', "Performance Evaluation 6Mth Performance Report(Cody)");
         });
    });

    function fn_loadOrderSalesman(memId, memCode) {

        Common.ajax("GET", "/services/performanceMgmt/selectMemberInfo.do", {codyCode : memCode}, function(memInfo) {

            if(memInfo == null) {
                Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
                $('#codyCode').val('');
                $('#codyName').val('');
                $('#joinDt').val('');
                $('#workingMonth').val('');
                $('#cmCode').val('');
                $('#cmName').val('');
                $('#scmCode').val('');
                $('#scmName').val('');
                $('#gcmCode').val('');
                $('#gcmName').val('');
            }
            else {
                $('#codyCode').val(memInfo.codyCode);
                $('#codyName').val(memInfo.codyName);
                $('#joinDt').val(memInfo.joinDt);
                $('#workingMonth').val(memInfo.workingMonth);
                $('#cmCode').val(memInfo.cmCode);
                $('#cmName').val(memInfo.cmName);
                $('#scmCode').val(memInfo.scmCode);
                $('#scmName').val(memInfo.scmName);
                $('#gcmCode').val(memInfo.gcmCode);
                $('#gcmName').val(memInfo.gcmName);
            }
        });
    }

    function fn_selectCodyReportSearch() {
    	var tab;

    	if(FormUtil.isEmpty($("#tabId").val())) {
    		tab = 'HC';
    	} else {
    		tab = $("#tabId").val()
    	}

    	fn_selectCodyReport(tab);
    }

    // Tab
    function fn_selectCodyReport(tab) {

    	$("#tabId").val(tab);
        var tabId = $("#tabId").val();

    	var obj = $("#insertForm").serializeJSON();
        obj.tabId = tabId;

        var mmyyyy = $("#mmyyyy").val();
        obj.mmyyyy = mmyyyy;
        obj.year = mmyyyy.substr(3);
        obj.month = mmyyyy.substr(0,2);
        obj.codyCode = $("#codyCode").val();

        if(FormUtil.checkReqValue($("#mmyyyy"))){
            var arg = "<spring:message code='service.grid.Month' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            return false;
        }

        if(FormUtil.checkReqValue($("#codyCode"))){
            var arg = "<spring:message code='service.grid.CodyCode' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            return false;
        }

        Common.ajax("GET", "/services/performanceMgmt/selectCodyPerformanceReportList", obj, function (result) {
            if(tabId == 'HC') {
            	AUIGrid.setGridData(hcGridID, result.hcList);
            } else if(tabId == 'HS') {
                AUIGrid.setGridData(hsOaGridID, result.hsOaList);
                AUIGrid.setGridData(hsInGridID, result.hsInList);
                AUIGrid.setGridData(hsCoGridID, result.hsCoList);
                AUIGrid.setGridData(hsCoRtGridID, result.hsCoRtList);
            } else if(tabId == 'RC') {
            	AUIGrid.setGridData(rcOaGridID, result.rcOaList);
                AUIGrid.setGridData(rcInGridID, result.rcInList);
                AUIGrid.setGridData(rcCoGridID, result.rcCoList);
            } else if(tabId == 'SALES') {
            	AUIGrid.setGridData(salesOaGridID, result.salesOaList);
                AUIGrid.setGridData(salesInGridID, result.salesInList);
                AUIGrid.setGridData(salesCoGridID, result.salesCoList);
            } else if(tabId == 'SVM') {
            	AUIGrid.setGridData(svmOaGridID, result.svmOaList);
                AUIGrid.setGridData(svmInGridID, result.svmInList);
                AUIGrid.setGridData(svmCoGridID, result.svmCoList);
            } else if(tabId == 'RT') {
            	AUIGrid.setGridData(rtOaGridID, result.rtOaList);
                AUIGrid.setGridData(rtInGridID, result.rtInList);
                AUIGrid.setGridData(rtCoGridID, result.rtCoList);
            } else if(tabId == 'CFF') {
                AUIGrid.setGridData(cffGridID, result.cffList);
            } else if(tabId == 'PE') {
                AUIGrid.setGridData(peGridID, result.peList);
            }
        });
    }
</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home"/></li>
        <li>Sales</li>
        <li>Order list</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>6Mth Performance Report(Cody)</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectCodyReportSearch();"><spanclass="search"></span>Search</a></p></li>
            </c:if>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table">
        <form id="searchForm" name="searchForm">
        <ipput type="hidden" name="tabId" id="tabId">
        <table class="type1">
            <!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width: 160px">
                <col style="width: *">
                <col style="width: 160px">
                <col style="width: *">
                <col style="width: 160px">
                <col style="width: *">
            </colgroup>
            <tbody>
            <tr>
                <th scope="row"><spring:message code='service.grid.Month' /><span class="must">*</span></th>
                <td>
                    <input type="text" title="" id="mmyyyy" name="mmyyyy" value="${mmyyyy}" placeholder="MM/YYYY" class="j_date2" />
                </td>
                <th scope="row"><spring:message code='service.grid.CodyCode'/><span class="must">*</span></th>
                <td>
                    <p><input id="codyCode" name="codyCode" type="text" title="" placeholder="" style="width:100px;" class="" /></p>
			        <p><a id="_memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
			        <p><input id="codyName" name="codyName" type="text" title="" placeholder="" style="width:200px;" class="readonly" readonly/></p>
                </td>
                <th scope="row"></th>
                <td></td>
            </tr>
            <tr>
                <th scope="row"><spring:message code='service.title.joinMonth' /></th>
                <td>
                    <input type="text" id="joinDt" name="joinDt" class="j_date2" disabled/>
                </td>
                <th scope="row"><spring:message code='service.grid.workPeriod'/></th>
                <td>
                    <input type="text" id="workingMonth" name="workingMonth" style="width:100px;" disabled/>
                </td>
                <th scope="row"></th>
                <td></td>
            </tr>
            <tr>
                <th scope="row"><spring:message code='service.title.CodyManager'/></th>
                <td>
                    <input type="text"  id="cmCode" name="cmCode" style="width:100px" disabled/>
                    <input type="text"  id="cmName" name="cmName"  style="width:220px" disabled/>
                </td>
                <th scope="row"><spring:message code='service.title.seniorCodyManager'/></th>
                <td>
                    <input type="text"  id="scmCode" name="scmCode" style="width:100px" disabled/>
                    <input type="text"  id="scmName" name="scmName" style="width:220px" disabled/>
                </td>
                <th scope="row"><spring:message code='service.title.generalCodyManager'/></th>
                <td>
                    <input type="text"  id="gcmCode" name="gmCode" style="width:100px" disabled/>
                    <input type="text"  id="gcmName" name="gcmName" style="width:220px" disabled/>
                </td>
            </tr>
            </tbody>
        </table>
        <!-- table end -->
        </form>
    </section>

    <section class="search_result"><!-- search_result start -->
        <section class="tap_wrap"><!-- tap_wrap start -->
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	            <ul class="tap_type1">
	                <li><a href="#" class="on" onClick="javascript:fn_selectCodyReport('HC');">Happy Call</a></li>
	                <li><a href="#" onClick="javascript:fn_selectCodyReport('HS');">Heart Service</a></li>
	                <li><a href="#" onClick="javascript:fn_selectCodyReport('RC');">Rental Collection</a></li>
	                <li><a href="#" onClick="javascript:fn_selectCodyReport('SALES');">Sales</a></li>
	                <li><a href="#" onClick="javascript:fn_selectCodyReport('SVM');">Outright SVM</a></li>
	                <li><a href="#" onClick="javascript:fn_selectCodyReport('RT');">Retention</a></li>
	                <li><a href="#" onClick="javascript:fn_selectCodyReport('CFF');">CFF</a></li>
	                <li><a href="#" onClick="javascript:fn_selectCodyReport('PE');">PE</a></li>
	            </ul>
            </c:if>
            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Happy Call</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownHc"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap" >
                    <!-- 그리드 영역 -->
                    <div id="grid_hc_list" style="width:100%; height:120px; margin:0 auto;" ></div>
                </article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Heart Service_Overall</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownHsOa"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_hsoa_list" style="width:100%; height:220px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Individual</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownHsIn"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_hsin_list" style="width:100%; height:190px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Corporate</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownHsCo"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_hsco_list" style="width:100%; height:190px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Corporate Ratio</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownHsCoRt"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_hscort_list" style="width:100%; height:120px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Rental Collection_Overall</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownRcOa"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_rcoa_list" style="width:100%; height:180px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Individual</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownRcIn"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_rcin_list" style="width:100%; height:140px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Corporate</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownRcCo"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_rcco_list" style="width:100%; height:140px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Sales_Overall</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownSalesOa"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_salesoa_list" style="width:100%; height:150px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Individual</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownSalesIn"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_salesin_list" style="width:100%; height:120px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Corporate</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownSalesCo"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_salesco_list" style="width:100%; height:120px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Outright SVM_Overall</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownSvmOa"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_svmoa_list" style="width:100%; height:120px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Individual</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownSvmIn"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_svmin_list" style="width:100%; height:100px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Corporate</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownSvmCo"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_svmco_list" style="width:100%; height:100px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Retention_Overall</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownRtOa"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_rtoa_list" style="width:100%; height:180px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Individual</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownRtIn"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_rtin_list" style="width:100%; height:150px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Corporate</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownRtCo"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_rtco_list" style="width:100%; height:150px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* CFF_Overall</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownCff"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_cff_list" style="width:100%; height:120px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Performance Evaluation</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownPe"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_pe_list" style="width:100%; height:120px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

            </article><!-- tap_area end -->

        </section><!-- tap_wrap end -->
    </section><!-- content end -->

</section>
<!-- content end -->
