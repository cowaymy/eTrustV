<!--=================================================================================================
* Task  : Service
* File Name : clProgressReport.jsp
* Description : CL_ProgressReport(HQ)
* Author : KR-OHK
* Date : 2019-10-31
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-10-31  KR-OHK        Init
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javascript">

    var scmGridID;

    var rescolumnLayout1 = [
                     {dataField: "stusNm",headerText :"<spring:message code='service.grid.Status'/>",width: 150, height:20},
                     {dataField: "janVal",headerText :"<spring:message code='service.grid.january'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "febVal",headerText :"<spring:message code='service.grid.february'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "marVal",headerText :"<spring:message code='service.grid.march'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "aprVal",headerText :"<spring:message code='service.grid.april'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "mayVal",headerText :"<spring:message code='service.grid.may'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "junVal",headerText :"<spring:message code='service.grid.june'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "julVal",headerText :"<spring:message code='service.grid.july'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "augVal",headerText :"<spring:message code='service.grid.august'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "sepVal",headerText :"<spring:message code='service.grid.september'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "octVal",headerText :"<spring:message code='service.grid.october'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "novVal",headerText :"<spring:message code='service.grid.november'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "decVal",headerText :"<spring:message code='service.grid.december'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"}
             ];

    var rescolumnLayout2 = [
                            {dataField: "stusNm",headerText :" ",width: 150, height:20},
                            {dataField: "janVal",headerText :"<spring:message code='service.grid.january'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "febVal",headerText :"<spring:message code='service.grid.february'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "marVal",headerText :"<spring:message code='service.grid.march'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "aprVal",headerText :"<spring:message code='service.grid.april'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "mayVal",headerText :"<spring:message code='service.grid.may'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "junVal",headerText :"<spring:message code='service.grid.june'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "julVal",headerText :"<spring:message code='service.grid.july'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "augVal",headerText :"<spring:message code='service.grid.august'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "sepVal",headerText :"<spring:message code='service.grid.september'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "octVal",headerText :"<spring:message code='service.grid.october'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "novVal",headerText :"<spring:message code='service.grid.november'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "decVal",headerText :"<spring:message code='service.grid.december'/>", width: 110, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"}
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

        // Cody/CM/SCM_Status
        gcmGridID = GridCommon.createAUIGrid("grid_gcm_list", rescolumnLayout1,'',gridPros);
        scmGridID = GridCommon.createAUIGrid("grid_scm_list", rescolumnLayout1,'',gridPros);
        cmGridID = GridCommon.createAUIGrid("grid_cm_list", rescolumnLayout1,'',gridPros);
        codyGridID = GridCommon.createAUIGrid("grid_cody_list", rescolumnLayout1,'',gridPros);
        // Heart Service
        hsGridID = GridCommon.createAUIGrid("grid_hs_list", rescolumnLayout1,'',gridPros);
        // Rental Collection
        rcGridID = GridCommon.createAUIGrid("grid_rc_list", rescolumnLayout1,'',gridPros);
        // Sales Net
        appGridID = GridCommon.createAUIGrid("grid_app_list", rescolumnLayout2,'',gridPros);
        catGridID = GridCommon.createAUIGrid("grid_cat_list", rescolumnLayout2,'',gridPros);
        // Rejoin
        rjGridID = GridCommon.createAUIGrid("grid_rj_list", rescolumnLayout1,'',gridPros);
        // MBO
        salesGridID = GridCommon.createAUIGrid("grid_sales_list", rescolumnLayout2,'',gridPros);
        svmGridID = GridCommon.createAUIGrid("grid_svm_list", rescolumnLayout2,'',gridPros);
        // Retention
        rtGridID = GridCommon.createAUIGrid("grid_rt_list", rescolumnLayout2,'',gridPros);
        //CFF
        cffGridID = GridCommon.createAUIGrid("grid_cff_list", rescolumnLayout2,'',gridPros);
        // PE
        peGridID = GridCommon.createAUIGrid("grid_pe_list", rescolumnLayout2,'',gridPros);

        //excel Download
        $('#excelDownGcm').click(function() {
           GridCommon.exportTo("grid_gcm_list", 'xlsx', "GCM CL Progress Report");
        });
        $('#excelDownScm').click(function() {
           GridCommon.exportTo("grid_scm_list", 'xlsx', "SCM CL Progress Report");
        });
        $('#excelDownCm').click(function() {
            GridCommon.exportTo("grid_cm_list", 'xlsx', "CM CL Progress Report");
         });
        $('#excelDownCody').click(function() {
            GridCommon.exportTo("grid_cody_list", 'xlsx', "Cody CL Progress Report");
         });
        $('#excelDownHs').click(function() {
            GridCommon.exportTo("grid_hs_list", 'xlsx', "Heart Service CL Progress Report");
         });
        $('#excelDownRc').click(function() {
            GridCommon.exportTo("grid_rc_list", 'xlsx', "Rental Collection CL Progress Report");
         });
        $('#excelDownApp').click(function() {
            GridCommon.exportTo("grid_app_list", 'xlsx', "Sales Net(Application Type) CL Progress Report");
         });
        $('#excelDownCat').click(function() {
            GridCommon.exportTo("grid_cat_list", 'xlsx', "Sales Net(Category) CL Progress Report");
         });
        $('#excelDownRj').click(function() {
            GridCommon.exportTo("grid_rj_list", 'xlsx', "Rejoin CL Progress Report");
         });
        $('#excelDownSales').click(function() {
            GridCommon.exportTo("grid_sales_list", 'xlsx', "MBO_Sales CL Progress Report");
         });
        $('#excelDownSvm').click(function() {
            GridCommon.exportTo("grid_svm_list", 'xlsx', "MBO_SVM CL Progress Report");
         });
        $('#excelDownRt').click(function() {
            GridCommon.exportTo("grid_rt_list", 'xlsx', "Retention CL Progress Report");
         });
        $('#excelDownCff').click(function() {
            GridCommon.exportTo("grid_cff_list", 'xlsx', "CFF_Overall CL Progress Report");
         });
        $('#excelDownPe').click(function() {
            GridCommon.exportTo("grid_pe_list", 'xlsx', "Performance Evaluation CL Progress Report");
         });
    });


    function fn_selectClReportSearch() {
        var tab;

        if(FormUtil.isEmpty($("#tabId").val())) {
            tab = 'STS';
        } else {
            tab = $("#tabId").val()
        }

        fn_selectClReport(tab);
    }

    // Tab
    function fn_selectClReport(tab) {

    	$("#tabId").val(tab);
        var tabId = $("#tabId").val();

    	var obj = $("#insertForm").serializeJSON();
        obj.tabId = tabId;
        obj.year = $("#year").val();
        obj.gcmCode = $("#gcmCode").val();

        if(FormUtil.checkReqValue($("#year"))){
            var arg = "<spring:message code='service.grid.Year' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            return false;
        }

        Common.ajax("GET", "/services/performanceMgmt/selectClProgressReportList", obj, function (result) {
            if(tabId == 'STS') {
            	AUIGrid.setGridData(gcmGridID, result.gcmList);
                AUIGrid.setGridData(scmGridID, result.scmList);
                AUIGrid.setGridData(cmGridID, result.cmList);
                AUIGrid.setGridData(codyGridID, result.codyList);
            } else if(tabId == 'HS') {
                AUIGrid.setGridData(hsGridID, result.hsList);
            } else if(tabId == 'RC') {
                AUIGrid.setGridData(rcGridID, result.rcList);
            } else if(tabId == 'SN') {
                 AUIGrid.setGridData(appGridID, result.appList);
                 AUIGrid.setGridData(catGridID, result.catList);
            } else if(tabId == 'RJ') {
                AUIGrid.setGridData(rjGridID, result.rjList);
            } else if(tabId == 'MBO') {
                AUIGrid.setGridData(salesGridID, result.salesList);
                AUIGrid.setGridData(svmGridID, result.svmList);
            } else if(tabId == 'RT') {
                AUIGrid.setGridData(rtGridID, result.rtList);
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
        <h2>CL_ProgressReport(HQ)</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectClReportSearch();"><spanclass="search"></span>Search</a></p></li>
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
            </colgroup>
            <tbody>
            <tr>
                <th scope="row"><spring:message code='service.grid.Year' /><span class="must">*</span></th>
                <td>
                    <input type="text" id="year" name="year" maxlength="4" value="${year}" title="Year" onkeydown="return FormUtil.onlyNumber(event)">
                </td>
                <th scope="row"><spring:message code='service.grid.gcmCode'/></th>
                <td>
                    <input type="text" id="gcmCode" name="gcmCode" title="GCM Code" style="width: 80%">
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
	                <li><a href="#" class="on" onClick="javascript:fn_selectClReport('STS');">Cody/CM/SCM_Status</a></li>
	                <li><a href="#" onClick="javascript:fn_selectClReport('HS');">Heart Service</a></li>
	                <li><a href="#" onClick="javascript:fn_selectClReport('RC');">Rental Collection</a></li>
	                <li><a href="#" onClick="javascript:fn_selectClReport('SN');">Sales Net</a></li>
	                <li><a href="#" onClick="javascript:fn_selectClReport('RJ');">Rejoin</a></li>
	                <li><a href="#" onClick="javascript:fn_selectClReport('MBO');">MBO</a></li>
	                <li><a href="#" onClick="javascript:fn_selectClReport('RT');">Retention</a></li>
	                <li><a href="#" onClick="javascript:fn_selectClReport('CFF');">CFF</a></li>
	                <li><a href="#" onClick="javascript:fn_selectClReport('PE');">PE</a></li>
	            </ul>
            </c:if>
            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* GCM</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownGcm"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap" >
                    <!-- 그리드 영역 -->
                    <div id="grid_gcm_list" style="width:100%; height:120px; margin:0 auto;" ></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* SCM</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownScm"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap" >
                    <!-- 그리드 영역 -->
                    <div id="grid_scm_list" style="width:100%; height:120px; margin:0 auto;" ></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* CM</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownCm"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>

                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_cm_list" style="width:100%; height:120px; margin:0 auto;" ></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Cody</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownCody"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_cody_list" style="width:100%; height:120px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Heart Service_Overall</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownHs"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_hs_list" style="width:100%; height:450px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Rental Collection_Overall</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownRc"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_rc_list" style="width:100%; height:450px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Application Type</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownApp"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_app_list" style="width:100%; height:350px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Category</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownCat"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_cat_list" style="width:100%; height:350px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Rejoin_Overall</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownRj"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_rj_list" style="width:100%; height:450px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* MBO_Sales</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownSales"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_sales_list" style="width:100%; height:250px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* MBO_SVM</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownSvm"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_svm_list" style="width:100%; height:250px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Retention_Overall</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownRt"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_rt_list" style="width:100%; height:450px; margin:0 auto;"></div>
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
                    <div id="grid_cff_list" style="width:100%; height:450px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Performance Evaluation</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownGcmPe"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_pe_list" style="width:100%; height:450px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

            </article><!-- tap_area end -->

        </section><!-- tap_wrap end -->
    </section><!-- content end -->

</section>
<!-- content end -->
