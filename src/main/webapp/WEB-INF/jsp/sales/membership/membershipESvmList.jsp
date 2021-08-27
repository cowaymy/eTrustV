<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
console.log("preOrderList");
    var listGridID;
    var excelListGridID;
    var keyValueList = [];
    var MEM_TYPE = '${SESSION_INFO.userTypeId}';
    var CATE_ID  = "14";
    var appTypeData = [{"codeId": "66","codeName": "Rental"},{"codeId": "67","codeName": "Outright"},{"codeId": "68","codeName": "Instalment"}];
    var actData= [{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancel"}];
    var memTypeData = [{"codeId": "1","codeName": "HP"},{"codeId": "2","codeName": "Cody"},{"codeId": "4","codeName": "Staff"},{"codeId": "7","codeName": "HT"}];
    var myFileCaches = {};
    var recentGridItem = null;
    var selectRowIdx;
    var popupObj;

/*     if(MEM_TYPE == '1') { //HP
        CATE_ID = "29";
    }
    else if(MEM_TYPE == '2') { //CODY
        CATE_ID = "28";
    } */


    $(document).ready(function(){

        fn_statusCodeSearch();
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        createExcelAUIGrid();

        if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7" ){

            if("${SESSION_INFO.memberLevel}" =="1"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="2"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="3"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="4"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");

                $("#_memCode").val("${SESSION_INFO.userName}");
                $("#_memCode").attr("class", "w100p readonly");
                $("#_memCode").attr("readonly", "readonly");
                $("#_memBtn").hide();

            }
        }

        AUIGrid.bind(listGridID , "cellClick", function( event ){
            console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
            selectRowIdx = event.rowIndex;
        });

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(listGridID, "cellDoubleClick", function(event) {
            fn_setDetail(listGridID, selectRowIdx);

        });

        doGetComboData('/status/selectStatusCategoryCdList.do', {selCategoryId : CATE_ID, parmDisab : 0}, '', '_stusId', 'M', 'fn_multiCombo');
        doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', '_brnchId', 'M', 'fn_multiCombo'); //Branch Code
        doGetComboOrder('/common/selectCodeList.do', '8', 'CODE_ID', '', '_typeId', 'M', 'fn_multiCombo'); //Common Code
        doDefCombo(memTypeData, '', 'memType', 'S', '');


        //excel Download
        $('#excelDown').click(function() {
            var excelProps = {
                fileName     : "eSVM",
               exceptColumnFields : AUIGrid.getHiddenColumnDataFields(excelListGridID)
            };
            AUIGrid.exportToXlsx(excelListGridID, excelProps);
        });

        fn_setToDay();

    });

    function fn_setToDay() {
        var today = new Date();

        var dd = today.getDate();
        var mm = today.getMonth() + 1;
        var yyyy = today.getFullYear();

        if(dd < 10) {
            dd = "0" + dd;
        }
        if(mm < 10){
            mm = "0" + mm
        }

        today = dd + "/" + mm + "/" + yyyy;
        $("#_reqstEndDt").val(today);

        var today_s = "01/" + mm + "/" + yyyy;
        $("#_reqstStartDt").val(today_s);
    }

    function fn_statusCodeSearch(){
        Common.ajaxSync("GET", "/status/selectStatusCategoryCdList.do", {selCategoryId : CATE_ID, parmDisab : 0}, function(result) {
            keyValueList = result;
        });
    }

    function fn_setDetail(gridID, rowIdx){
    	console.log("gridID"+ gridID);
    	console.log("rowIdx"+ rowIdx);
        //(_url, _jsonObj, _callback, _isManualClose, _divId, _initFunc)
        Common.popupDiv("/sales/membership/membershipESvmDetailPop.do", { psmId : AUIGrid.getCellValue(gridID, rowIdx, "psmId") }, null, true, "_divESvmSavePop");
    }

    function fn_setOptGrpClass() {
        $("optgroup").attr("class" , "optgroup_text")
    }

    function createAUIGrid() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            {dataField : "psmNo", headerText : '<spring:message code="sal.title.text.preSalesNo" />', width : "7%" , editable : false, style : "aui-grid-link-renderer"},
           {dataField : "saRefNo", headerText : '<spring:message code="sal.title.text.saRefNo" />', width : "10%" , editable : false},
           {dataField : "salesOrdNo", headerText : '<spring:message code="sales.OrderNo" />', width : "7%" , editable : false},
           {dataField : "crtDt", headerText :'<spring:message code="sal.title.text.eSvmKeyInDt" />', width : "10%" , editable : false},
           {dataField : "crtTm", headerText : '<spring:message code="sal.title.text.eSvmKeyInTm" />', width : "10%" , editable : false},
           {dataField : "status", headerText : '<spring:message code="sal.title.text.preSalSts" />', width : "9%" , editable : false},
           {dataField : "psmSrvMemNo", headerText : '<spring:message code="sales.MembershipNo" />', width : "9%" , editable : false},
           {dataField : "custName", headerText : '<spring:message code="sal.text.custName" />', width : "15%" , editable : false},
           {dataField : "crtUser", headerText : '<spring:message code="sales.Creator" />', width : "7%" , editable : false},
           {dataField : "updDt", headerText : '<spring:message code="sal.text.lastUpdate" />', width : "10%" , editable : false},
           {dataField : "stusRem", headerText : '<spring:message code="sal.title.text.specialInstruction" />', width : "15%" , editable : false},
           {dataField : "psmId",headerText : "psmId", visible  : false },
           {dataField : "atchFileGrpId",headerText : "atchFileGrpId", visible  : false }
          , { headerText : "StatusId",          dataField : "stusId",     editable : false, visible  : false,  width : 100 }
          , { headerText : "preOrdId",        dataField : "preOrdId",   visible  : false}
            , { headerText : "updDt",      dataField : "updDt",   visible  : false}

            ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : true,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
          //selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       : "No order found.",
            wordWrap : true,
            groupingMessage     : "Here groupping"
        };

        listGridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPros);
    }

    function createExcelAUIGrid() {

        //AUIGrid 칼럼 설정
        var excelColumnLayout = [
		{dataField : "psmNo", headerText : '<spring:message code="sal.title.text.preSalesNo" />', width : 100 , editable : false},
		{dataField : "saRefNo", headerText : '<spring:message code="sal.title.text.saRefNo" />', width : 100 , editable : false},
		{dataField : "salesOrdNo", headerText : '<spring:message code="sales.OrderNo" />', width : 100 , editable : false},
		{dataField : "crtDt", headerText :'<spring:message code="sal.title.text.eSvmKeyInDt" />', width : 100 , editable : false},
		{dataField : "crtTm", headerText : '<spring:message code="sal.title.text.eSvmKeyInTm" />', width : 100 , editable : false},
		{dataField : "status", headerText : '<spring:message code="sal.title.text.preSalSts" />', width : 100 , editable : false},
		{dataField : "psmSrvMemNo", headerText : '<spring:message code="sales.MembershipNo" />', width : 100 , editable : false},
		{dataField : "custName", headerText : '<spring:message code="sal.text.custName" />', width : 250 , editable : false},
		{dataField : "crtUser", headerText : '<spring:message code="sales.Creator" />', width : 100 , editable : false},
		{dataField : "updDt", headerText : '<spring:message code="sal.text.lastUpdate" />', width : 150 , editable : false},
		{dataField : "stusRem", headerText : '<spring:message code="sal.title.text.specialInstruction" />', width : 300 , editable : false}
            ];

        //그리드 속성 설정
        var excelGridPros = {
             enterKeyColumnBase : true,
             useContextMenu : true,
             enableFilter : true,
             showStateColumn : true,
             displayTreeOpen : true,
             headerHeight        : 40,
             wordWrap : true,
             noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
             groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
             exportURL : "/common/exportGrid.do"
         };

        excelListGridID = GridCommon.createAUIGrid("excel_list_grid_wrap", excelColumnLayout, "", excelGridPros);
    }

    $(function(){
        $('#_btnClear').click(function() {
            $('#_frmESvmSrch').clearForm();
        });
        $('#_btnSearch').click(function() {
            if(fn_validSearchList())
            	fn_getESvmList();
        });
        $('#_memBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
            Common.popupDiv("/common/memberPop.do", $("#_frmESvmSrch").serializeJSON(), null, true);
        });
        $('#_memCode').change(function(event) {
            var memCd = $('#_memCode').val().trim();

            if(FormUtil.isNotEmpty(memCd)) {
                fn_loadOrderSalesman('',memCd);
            }
        });
        $('#_memCode').keydown(function (event) {
            if (event.which === 13) {    //enter
                var memCd = $('#_memCode').val().trim();

                if(FormUtil.isNotEmpty(memCd)) {
                    fn_loadOrderSalesman('',memCd);
                }
                return false;
            }
        });
    });

    function fn_validSearchList() {
        var isValid = true, msg = "";

        if('${userRoleId}' == 51) { // BLOCK CARE LINE AGENT WHEN CLICK SEARCH BUTTON - TPY 20200812
              isValid = false;
              msg += '* Unable to search due to no access right.<br/>';
        }

        if(FormUtil.isEmpty($('#_memCode').val())
                && FormUtil.isEmpty($('#_stusId').val())
                && FormUtil.isEmpty($('#_brnchId').val())
                && FormUtil.isEmpty($('#custName').val())
                && FormUtil.isEmpty($('#_nric').val())
                && (FormUtil.isEmpty($('#_reqstStartDt').val()) || FormUtil.isEmpty($('#_reqstEndDt').val()))
        ){
             if((!FormUtil.isEmpty($('#_reqstStartDt').val()) && FormUtil.isEmpty($('#_reqstEndDt').val()))
              || (FormUtil.isEmpty($('#_reqstStartDt').val()) && !FormUtil.isEmpty($('#_reqstEndDt').val())))
             {
                    isValid = false;
                    msg += '<spring:message code="sal.alert.msg.selectDate" /><br/>';
             }

            /* if(FormUtil.isEmpty($('#_sofNo').val())){
                isValid = false;
                msg += '<spring:message code="sal.alert.msg.selSofNo" /><br/>';
            } */
         }

        if(!FormUtil.isEmpty($('#_reqstStartTime').val()) || !FormUtil.isEmpty($('#_reqstEndTime').val())) {
            if(FormUtil.isEmpty($('#_reqstStartDt').val()) || FormUtil.isEmpty($('#_reqstEndDt').val())) {
                isValid = false;
                msg += '* Please select Pre-Sales Date first<br/>';
            }
        }

        /* f(FormUtil.isEmpty($('#_memCode').val())
                && FormUtil.isEmpty($('#_sofNo').val())
                && FormUtil.isEmpty($('#_ordNo').val())
                && FormUtil.isEmpty($('#_reqstStartDt').val())
                && FormUtil.isEmpty($('#_reqstEndDt').val())
                ) {
            isValid = false;
            msg += '<spring:message code="sal.alert.msg.selectOrdDate" /><br/>';
        } else {
            if(!FormUtil.isEmpty($('#_reqstStartDt').val()) && !FormUtil.isEmpty($('#_reqstEndDt').val()) ) {
                var sDate = $('#_reqstStartDt').val();
                var eDate = $('#_reqstEndDt').val();

                var dd = "";
                var mm = "";
                var yyyy = "";

                var dateArr;
                dateArr = sDate.split("/");
                var sDt = new Date(Number(dateArr[2]), Number(dateArr[1])-1, Number(dateArr[0]));

                dateArr = eDate.split("/");
                var eDt = new Date(Number(dateArr[2]), Number(dateArr[1])-1, Number(dateArr[0]));

                var dtDiff = new Date(eDt - sDt);
                var days = dtDiff/1000/60/60/24;
                console.log("dayDiff :: " + days);

                if(days > 30) {
                    Common.alert("Pre-Order date range cannot be greater than 30 days.");
                    return false;
                }
            }
        } */

        if(!isValid) Common.alert("eSVM" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

         return isValid;

    }

  //Layer close
    hideViewPopup=function(val){
        $(val).hide();
    }

    function fn_loadOrderSalesman(memId,memCode) {

        Common.ajax("GET", "/sales/membership/selectMemberByMemberID.do", {memId:memId,memCode : memCode}, function(memInfo) {

            if(memInfo == null) {
                Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
            }
            else {
                $('#_memCode').val(memInfo.memCode);
                $('#_memName').val(memInfo.name);            }
        });
    }

    function fn_getESvmList() {
        Common.ajax("GET", "/sales/membership/selectESvmListAjax.do", $("#_frmESvmSrch").serialize(), function(result) {
            AUIGrid.setGridData(listGridID, result);
            AUIGrid.setGridData(excelListGridID, result);
        });
    }

    function fn_PopClose() {
        if(popupObj!=null) popupObj.close();
    }

    function fn_multiCombo(){
        $('#_stusId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#_stusId').multipleSelect("checkAll");
        $('#_brnchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#_brnchId').multipleSelect("checkAll");
        $('#_typeId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#_typeId').multipleSelect("checkAll");

    }

    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
                this.value = '';
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;
            }else if (tag === 'select'){
                this.selectedIndex = 0;
            }
        });
    };

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Membership</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>eSVM</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
       <li><p class="btn_blue"><a id="_btnSearch" href="#"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
       <li><p class="btn_blue"><a id="_btnClear" href="#"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->
<form id="frmNew" name="frmNew" action="#" method="post">
</form>
<section class="search_table"><!-- search_table start -->
<form id="_frmESvmSrch" name="_frmESvmSrch" action="#" method="post">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />


</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.salManCode" /></th>
        <td>
            <p><input id="_memCode" name="_memCode" type="text" title="" placeholder="" style="width:80px;" class="" /></p>
            <p><a id="_memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
            <p><input id="_memName" name="_memName" type="text" title="" placeholder="" style="width:90px;" class="readonly" readonly/></p>
        </td>
    <th scope="row"><spring:message code="sal.title.text.postBrnch" /></th>
        <td>
            <select id="_brnchId" name="_brnchId" class="multy_select w100p" multiple="multiple"></select>
        </td>
    <th scope="row"><spring:message code="sal.title.text.preSalDt" /></th>
    <td>
       <div class="date_set w100p"><!-- date_set start -->
           <p><input id="_reqstStartDt" name="_reqstStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
           <span>To</span>
           <p><input id="_reqstEndDt" name="_reqstEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
       </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.preSalSts" /></th>
       <td>
            <select class="multy_select w100p" multiple="multiple" name="_stusId">
                <option value="1" selected="selected"><spring:message code="sal.btn.active" /></option>
                <option value="5" selected="selected"><spring:message code="sal.combo.text.approv" /></option>
                <option value="6" selected="selected"><spring:message code="sal.combo.text.rej" /></option>
            </select>
        </td>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td>
           <select class="multy_select w100p" multiple="multiple" name="_typeId">
                <option value="965"><spring:message code="sal.text.company" /></option>
                <option value="964"><spring:message code="sal.text.individual" /></option>
            </select>
        </td>
    <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
    <td>
       <input id="_nric" name="_nric" type="text" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.saRefNo" /></th>
        <td>
            <input type="text" title="" placeholder="" class="w100p"  name=saRefNo/>
        </td>
    <th scope="row">Time</th>
    <td>
       <div class="date_set w100p">
        <p><input id="_reqstStartTime" name="_reqstStartTime" type="text" value="" title="" placeholder="" class="w100p" maxlength = "4" min = "0000" max = "2300" pattern="\d{4}"  /></p>
        <span>To</span>
        <p><input id="_reqstEndTime" name="_reqstEndTime" type="text" value="" title="" placeholder="" class="w100p" maxlength = "4" min = "0000" max = "2300" pattern="\d{4}" /></p>
        </div>
    </td>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
        <td>
            <input type="text" title="" placeholder="" class="w100p"  name="custName" id="custName"/>
        </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
        <td>
           <input type="text" title="" placeholder="" class="w100p"  name="ordNo"/>
        </td>
    <th scope="row"><spring:message code="sal.text.grpCode" /></th>
    <td>
        <input type="text" title="grpCode" id="grpCode" name="grpCode"  placeholder="Grp Code" class="w100p"/>
    </td>
    <th scope="row"><spring:message code="sal.title.text.preSalesNopsm" /></th>
        <td>
           <input type="text" title="" placeholder="" class="w100p"  name="preSalesNopsm"/>
        </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.orgCode" /></th>
        <td>
        <input type="text" title="orgCode" id="orgCode" name="orgCode" placeholder="Org Code" class="w100p" />
        </td>
    <th scope="row"><spring:message code="sal.text.detpCode" /></th>
        <td>
        <input type="text" title="deptCode" id="deptCode" name="deptCode"  placeholder="Dept Code" class="w100p"/>
        </td>
    <th scope="row"><spring:message code="sal.text.quotationNo" /></th>
        <td>
           <input type="text" title="" placeholder="" class="w100p"  name="quotationNo"  placeholder="SMQ No"/>
        </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.memtype" /></th>
        <td>
           <select id="memType" name="memType" class="w100p" ></select>
        </td>
    <th scope="row"><spring:message code="sal.text.membershipNo" /></th>
        <td>
            <input type="text" title="" placeholder="" class="w100p"  name="membershipNo"  placeholder="SM No"/>
        </td>
</tr>
<%-- <tr>
    <th scope="row" colspan="6" ><span class="must"><spring:message code='sales.msg.ordlist.keyinsof'/></span></th>
</tr> --%>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="excelDown">GENERATE</a></p></li>
</ul>
</c:if>
</section><!-- search_result end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
    <div id="excel_list_grid_wrap" style="display: none;"></div>
</article><!-- grid_wrap end -->

</section><!-- content end -->
