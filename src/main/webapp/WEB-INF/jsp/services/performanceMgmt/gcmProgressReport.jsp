<!--=================================================================================================
* Task  : Service
* File Name : gcmProgressReport.jsp
* Description : GCM_ProgressReport(HQ)
* Author : KR-OHK
* Date : 2019-10-29
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-10-29  KR-OHK        Init
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javascript">

    var scmGridID;

    var rescolumnLayout1 = [
                     {dataField: "memCode",headerText :"<spring:message code='service.grid.gcmCode'/>", width: 100, height:20 },
                     {dataField: "memName",headerText :"<spring:message code='service.grid.gcmName'/>",width: 230, height:20, style: "aui-grid-user-custom-left"},
                     {dataField: "janVal",headerText :"<spring:message code='service.grid.january'/>", width: 80, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "febVal",headerText :"<spring:message code='service.grid.february'/>", width: 80, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "marVal",headerText :"<spring:message code='service.grid.march'/>", width: 80, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "aprVal",headerText :"<spring:message code='service.grid.april'/>", width: 80, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "mayVal",headerText :"<spring:message code='service.grid.may'/>", width: 80, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "junVal",headerText :"<spring:message code='service.grid.june'/>", width: 80, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "julVal",headerText :"<spring:message code='service.grid.july'/>", width: 80, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "augVal",headerText :"<spring:message code='service.grid.august'/>", width: 90, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "sepVal",headerText :"<spring:message code='service.grid.september'/>", width: 90, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "octVal",headerText :"<spring:message code='service.grid.october'/>", width: 90, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "novVal",headerText :"<spring:message code='service.grid.november'/>", width: 90, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"},
                     {dataField: "decVal",headerText :"<spring:message code='service.grid.december'/>", width: 90, height:20, dataType:"numeric",  formatString:"#,##0", style: "aui-grid-user-custom-right"}
             ];

    var rescolumnLayout2 = [
                            {dataField: "batchMonth",headerText :"<spring:message code='service.grid.batchMonth'/>", width: 100, height:20 },
                            {dataField: "gcmCode",headerText :"<spring:message code='service.grid.gcmCode'/>",width: 100, height:20},
                            {dataField: "gcmName",headerText :"<spring:message code='service.grid.gcmName'/>",width: 210, height:20, style: "aui-grid-user-custom-left"},
                            {dataField: "scmCode",headerText :"<spring:message code='service.grid.scmName'/>",width: 100, height:20},
                            {dataField: "scmName",headerText :"<spring:message code='service.grid.scmName'/>",width: 210, height:20, style: "aui-grid-user-custom-left"},
                            {dataField: "cmCode",headerText :"<spring:message code='service.grid.cmName'/>",width: 100, height:20},
                            {dataField: "cmName",headerText :"<spring:message code='service.grid.cmName'/>",width: 210, height:20, style: "aui-grid-user-custom-left"},
                            {dataField: "codyCode",headerText :"<spring:message code='service.grid.CodyCode'/>",width: 100, height:20},
                            {dataField: "codyName",headerText :"<spring:message code='sal.title.text.codyNm'/>",width: 210, height:20, style: "aui-grid-user-custom-left"},
                            {dataField: "workingMonth",headerText :"<spring:message code='service.grid.workPeriod'/>", width: 100, height:20 },
                            {dataField: "joinDt",headerText :"<spring:message code='commission.text.grid.joinDate'/>", width: 100, height:20, dataType: "date", formatString: "dd/mm/yyyy" }

                    ];

    var rescolumnLayout3 = [
                            {dataField: "memCode",headerText :"<spring:message code='service.grid.gcmCode'/>", width: 100, height:20 },
                            {dataField: "memName",headerText :"<spring:message code='service.grid.gcmName'/>",width: 230, height:20, style: "aui-grid-user-custom-left"},
                            {dataField: "janVal",headerText :"<spring:message code='service.grid.january'/>", width: 80, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "febVal",headerText :"<spring:message code='service.grid.february'/>", width: 80, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "marVal",headerText :"<spring:message code='service.grid.march'/>", width: 80, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "aprVal",headerText :"<spring:message code='service.grid.april'/>", width: 80, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "mayVal",headerText :"<spring:message code='service.grid.may'/>", width: 80, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "junVal",headerText :"<spring:message code='service.grid.june'/>", width: 80, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "julVal",headerText :"<spring:message code='service.grid.july'/>", width: 80, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "augVal",headerText :"<spring:message code='service.grid.august'/>", width: 90, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "sepVal",headerText :"<spring:message code='service.grid.september'/>", width: 90, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "octVal",headerText :"<spring:message code='service.grid.october'/>", width: 90, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "novVal",headerText :"<spring:message code='service.grid.november'/>", width: 90, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"},
                            {dataField: "decVal",headerText :"<spring:message code='service.grid.december'/>", width: 90, height:20, dataType:"numeric",  formatString:"#,##0.00", style: "aui-grid-user-custom-right"}
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

    	CommonCombo.make('gcmList', '/services/performanceMgmt/selectMemList.do', {emplyLev : '1'} , '', {type: 'S'});

    	// Cody/CM/SCM_Status
    	scmGridID = GridCommon.createAUIGrid("grid_scm_list", rescolumnLayout1,'',gridPros);
    	cmGridID = GridCommon.createAUIGrid("grid_cm_list", rescolumnLayout1,'',gridPros);
    	codyGridID = GridCommon.createAUIGrid("grid_cody_list", rescolumnLayout1,'',gridPros);
    	codyLowGridID = GridCommon.createAUIGrid("grid_codyRow_list", rescolumnLayout2,'',gridPros);
    	// Heart Service
    	hsGridID = GridCommon.createAUIGrid("grid_hs_list", rescolumnLayout3,'',gridPros);
        // Rental Collection
    	rcGridID = GridCommon.createAUIGrid("grid_rc_list", rescolumnLayout3,'',gridPros);
    	// Sales Net
    	snGridID = GridCommon.createAUIGrid("grid_sn_list", rescolumnLayout3,'',gridPros);
    	// Sales Productivity
    	spGridID = GridCommon.createAUIGrid("grid_sp_list", rescolumnLayout3,'',gridPros);
        // Rejoin
    	rjGridID = GridCommon.createAUIGrid("grid_rj_list", rescolumnLayout3,'',gridPros);
        // MBO
    	salesGridID = GridCommon.createAUIGrid("grid_sales_list", rescolumnLayout3,'',gridPros);
    	svmGridID = GridCommon.createAUIGrid("grid_svm_list", rescolumnLayout3,'',gridPros);
        // Retention
    	rtGridID = GridCommon.createAUIGrid("grid_rt_list", rescolumnLayout3,'',gridPros);
    	//CFF
    	cffGridID = GridCommon.createAUIGrid("grid_cff_list", rescolumnLayout3,'',gridPros);
        // PE
    	gcmpeGridID = GridCommon.createAUIGrid("grid_gcmpe_list", rescolumnLayout3,'',gridPros);
    	scmpeGridID = GridCommon.createAUIGrid("grid_scmpe_list", rescolumnLayout3,'',gridPros);
        cmpeGridID = GridCommon.createAUIGrid("grid_cmpe_list", rescolumnLayout3,'',gridPros);
        codypeGridID = GridCommon.createAUIGrid("grid_codype_list", rescolumnLayout3,'',gridPros);

        var month = "";
        var year = "";

        $('#mmyyyy').change(function() {
        	var mmyyyy = $("#mmyyyy").val();

        	month = mmyyyy.substr(0,2);
            year = mmyyyy.substr(3);

        	doGetComboCodeId('/services/performanceMgmt/selectMemList.do', {emplyLev : '1', year:year, month:month},  '', 'gcmList', 'S','');
        });

        $('#gcmList').change(function() {
            var mangrCode = $("#gcmList option:selected").val();
            if(FormUtil.isEmpty(mangrCode)) {
            	doGetComboCodeId('/services/performanceMgmt/selectMemList.do', {emplyLev : '3', mangrCode : mangrCode, year:year, month:month},  '', 'cmList', 'S','');
            }
            doGetComboCodeId('/services/performanceMgmt/selectMemList.do', {emplyLev : '2', mangrCode : mangrCode, year:year, month:month},  '', 'scmList', 'S','');
        });

        $('#scmList').change(function() {
            var mangrCode = $("#scmList option:selected").val();
            doGetComboCodeId('/services/performanceMgmt/selectMemList.do', {emplyLev : '3', mangrCode : mangrCode, year:year, month:month},  '', 'cmList', 'S','');
        });

        //excel Download
        $('#excelDownScm').click(function() {
           GridCommon.exportTo("grid_scm_list", 'xlsx', "SCM GCM Progress Report");
        });
        $('#excelDownCm').click(function() {
            GridCommon.exportTo("grid_cm_list", 'xlsx', "CM GCM Progress Report");
         });
        $('#excelDownCody').click(function() {
            GridCommon.exportTo("grid_cody_list", 'xlsx', "Cody GCM Progress Report");
         });
        $('#excelDownCodyRow').click(function() {
            GridCommon.exportTo("grid_codyRow_list", 'xlsx', "Cody Row Data GCM Progress Report");
         });
        $('#excelDownHs').click(function() {
            GridCommon.exportTo("grid_hs_list", 'xlsx', "Heart Service GCM Progress Report");
         });
        $('#excelDownRc').click(function() {
            GridCommon.exportTo("grid_rc_list", 'xlsx', "Rental Collection GCM Progress Report");
         });
        $('#excelDownSn').click(function() {
            GridCommon.exportTo("grid_sn_list", 'xlsx', "Sales Net GCM Progress Report");
         });
        $('#excelDownSp').click(function() {
            GridCommon.exportTo("grid_sp_list", 'xlsx', "Sales Productivity GCM Progress Report");
         });
        $('#excelDownRj').click(function() {
            GridCommon.exportTo("grid_rj_list", 'xlsx', "Rejoin GCM Progress Report");
         });
        $('#excelDownSales').click(function() {
            GridCommon.exportTo("grid_sales_list", 'xlsx', "MBO_Sales GCM Progress Report");
         });
        $('#excelDownSvm').click(function() {
            GridCommon.exportTo("grid_svm_list", 'xlsx', "MBO_SVM GCM Progress Report");
         });
        $('#excelDownRt').click(function() {
            GridCommon.exportTo("grid_rt_list", 'xlsx', "Retention GCM Progress Report");
         });
        $('#excelDownCff').click(function() {
            GridCommon.exportTo("grid_cff_list", 'xlsx', "CFF_Overall GCM Progress Report");
         });
        $('#excelDownGcmPe').click(function() {
            GridCommon.exportTo("grid_gcmpe_list", 'xlsx', "Performance Evaluation(GCM) GCM Progress Report");
         });
        $('#excelDownScmPe').click(function() {
            GridCommon.exportTo("grid_scmpe_list", 'xlsx', "Performance Evaluation Average(SCM) GCM Progress Report");
         });
        $('#excelDownCmPe').click(function() {
            GridCommon.exportTo("grid_cmpe_list", 'xlsx', "Performance Evaluation Average(CM) GCM Progress Report");
         });
        $('#excelDownCodyPe').click(function() {
            GridCommon.exportTo("grid_codype_list", 'xlsx', "Performance Evaluation Average(Cody) GCM Progress Report");
        });
    });

    function fn_selectGcmReportSearch() {
        var tab;

        if(FormUtil.isEmpty($("#tabId").val())) {
            tab = 'STS';
        } else {
            tab = $("#tabId").val()
        }

        fn_selectGcmReport(tab);
    }

    // Tab
    function fn_selectGcmReport(tab) {

    	$("#tabId").val(tab);
        var tabId = $("#tabId").val();

    	var obj = $("#insertForm").serializeJSON();
    	obj.tabId = tabId;
    	obj.allYn = $("#allYn option:selected").val();

    	if(tabId == 'CRD') {
    		if(FormUtil.checkReqValue($("#mmyyyy"))){
                var arg = "<spring:message code='service.grid.Year' />";
                Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
                return false;
            }

    		var mmyyyy = $("#mmyyyy").val();

    		obj.month = mmyyyy.substr(0,2);
    		obj.year = mmyyyy.substr(3);


    		obj.gcmCode = $("#gcmList option:selected").val()
    		obj.scmCode = $("#scmList option:selected").val()
    		obj.cmCode = $("#cmList option:selected").val()

    	} else {
    		obj.year = $("#year").val();
    		obj.gcmCode = $("#gcmCode").val();

	    	if(FormUtil.checkReqValue($("#year"))){
	            var arg = "<spring:message code='service.grid.Year' />";
	            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
	            return false;
	        }
    	}

        Common.ajax("GET", "/services/performanceMgmt/selectGcmProgressReportList", obj, function (result) {
        	if(tabId == 'STS') {
	            AUIGrid.setGridData(scmGridID, result.scmList);
	            AUIGrid.setGridData(cmGridID, result.cmList);
	            AUIGrid.setGridData(codyGridID, result.codyList);
	        } else if(tabId == 'CRD') {
                AUIGrid.setGridData(codyLowGridID, result.codyLowList);
            } else if(tabId == 'HS') {
                AUIGrid.setGridData(hsGridID, result.hsList);
            } else if(tabId == 'RC') {
	        	AUIGrid.setGridData(rcGridID, result.rcList);
            } else if(tabId == 'SN') {
            	 AUIGrid.setGridData(snGridID, result.snList);
            } else if(tabId == 'SP') {
            	AUIGrid.setGridData(spGridID, result.spList);
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
            	AUIGrid.setGridData(gcmpeGridID, result.gcmpeList);
            	AUIGrid.setGridData(scmpeGridID, result.scmpeList);
            	AUIGrid.setGridData(cmpeGridID, result.cmpeList);
            	AUIGrid.setGridData(codypeGridID, result.codypeList);
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
        <h2>GCM_ProgressReport(HQ)</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectGcmReportSearch();"><spanclass="search"></span>Search</a></p></li>
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
                <col style="width: 190px">
                <col style="width: *">
            </colgroup>
            <tbody>
            <tr>
                <th scope="row"><spring:message code='service.grid.Year' /><span class="must">*</span></th>
                <td>
                    <input type="text" id="year" name="year" maxlength="4" value="${year}"  title="Year" onkeydown="return FormUtil.onlyNumber(event)">
                </td>
                <th scope="row"><spring:message code='service.grid.gcmCode'/></th>
                <td>
                    <input type="text" id="gcmCode" name="gcmCode" title="GCM Code" style="width: 80%">
                </td>
                <th scope="row">GCM/SCM/CM/CODY <spring:message code='status'/></th>
                <td>
                    <select class="w50p" id="allYn" name="allYn">
                        <option value="N" selected>Active</option>
                        <option value="Y">Include Inactive</option>
                    </select>
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
	                <li><a href="#" class="on" onClick="javascript:fn_selectGcmReport('STS');">Cody/CM/SCM_Status</a></li>
	                <li><a href="#" onClick="javascript:fn_selectGcmReport('HS');">Heart Service</a></li>
	                <li><a href="#" onClick="javascript:fn_selectGcmReport('RC');">Rental Collection</a></li>
	                <li><a href="#" onClick="javascript:fn_selectGcmReport('SN');">Sales Net</a></li>
	                <li><a href="#" onClick="javascript:fn_selectGcmReport('SP');">Sales Productivity</a></li>
	                <li><a href="#" onClick="javascript:fn_selectGcmReport('RJ');">Rejoin</a></li>
	                <li><a href="#" onClick="javascript:fn_selectGcmReport('MBO');">MBO</a></li>
	                <li><a href="#" onClick="javascript:fn_selectGcmReport('RT');">Retention</a></li>
	                <li><a href="#" onClick="javascript:fn_selectGcmReport('CFF');">CFF</a></li>
	                <li><a href="#" onClick="javascript:fn_selectGcmReport('PE');">PE</a></li>
	            </ul>
            </c:if>
            <article class="tap_area">
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
				    <div id="grid_scm_list" style="width:100%; height:450px; margin:0 auto;" ></div>
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
                    <div id="grid_cm_list" style="width:100%; height:450px; margin:0 auto;" ></div>
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
                    <div id="grid_cody_list" style="width:100%; height:450px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                 <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Cody Row Data</h3>
                    <ul class="right_btns">
                        <li><input type="text" title="" id="mmyyyy" name="mmyyyy" value="${mmyyyy}" placeholder="MM/YYYY" class="j_date2 w100p" /></li>
                        <li><select class="w100p" id="gcmList" name="gcmList"></select></li>
                        <li><select class="w100p" id="scmList" name="scmList">
                                <option value="" selected>Choose One</option>
                            </select>
                        </li>
                        <li>
                            <select class="w100p" id="cmList" name="cmList">
                                <option value="" selected>Choose One</option>
                            </select>
                        </li>
                        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                            <li><p class="btn_grid"><a href="#" onclick="javascript:fn_selectGcmReport('CRD');"><spring:message code='sys.btn.search'/></a></p></li>
                        </c:if>
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="exceDownCodyRow"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_codyRow_list" style="width:100%; height:550px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Heart Service %</h3>
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
                    <h3 class="pt0">* Rental Collection %</h3>
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
                    <h3 class="pt0">* Sales Net</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownSn"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
				    <!-- 그리드 영역 -->
				    <div id="grid_sn_list" style="width:100%; height:450px; margin:0 auto;"></div>
				</article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Sales Productivity</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownSp"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
				    <!-- 그리드 영역 -->
				    <div id="grid_sp_list" style="width:100%; height:450px; margin:0 auto;"></div>
				</article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Rejoin %</h3>
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
				    <div id="grid_sales_list" style="width:100%; height:450px; margin:0 auto;"></div>
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
                    <div id="grid_svm_list" style="width:100%; height:450px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->
            </article><!-- tap_area end -->

            <article class="tap_area">
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Retention %</h3>
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
                    <h3 class="pt0">* Performance Evaluation(GCM)</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownGcmPe"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_gcmpe_list" style="width:100%; height:450px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Performance Evaluation Average(SCM)</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownScmPe"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_scmpe_list" style="width:100%; height:450px; margin:0 auto;"></div>
                </article>
                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Performance Evaluation Average(CM)</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownCmPe"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_cmpe_list" style="width:100%; height:450px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <aside class="title_line mt0"><!-- title_line start -->
                    <h3 class="pt0">* Performance Evaluation Average(Cody)</h3>
                    <ul class="right_btns">
                        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <li><p class="btn_grid"><a href="#" id="excelDownCodyPe"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                        </c:if>
                    </ul>
                </aside>
                <!-- grid_wrap start -->
                <article class="grid_wrap">
                    <!-- 그리드 영역 -->
                    <div id="grid_codype_list" style="width:100%; height:450px; margin:0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

            </article><!-- tap_area end -->

        </section><!-- tap_wrap end -->
    </section><!-- content end -->

</section>
<!-- content end -->
