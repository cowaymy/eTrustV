<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">
    /* 커스텀 칼럼 스타일 정의 */
    .aui-grid-user-custom-left {
        text-align:left;
    }
    /* 커스컴 disable 스타일*/
    .mycustom-disable-color {
        color : #cccccc;
    }
    /* 그리드 오버 시 행 선택자 만들기 */
    .aui-grid-body-panel table tr:hover {
        background:#D9E5FF;
        color:#000;
    }
    .aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
        background:#D9E5FF;
        color:#000;
    }
    .aui-grid-column-right {
         text-align: right;
     }

    .aui-grid-link-renderer1 {
         text-decoration:underline;
         color: #4374D9 !important;
         cursor: pointer;
         text-align: right;
     }
</style>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
    var listGrid;
    var paramdata;
    var amdata = [{"codeId": "A","codeName": "Auto"}, {"codeId": "M","codeName": "Manaual"}];
    var uomlist = f_getTtype('42' , '');
    var paramdata;
    var toDay = '${toDay}';
    var nextDate = '${nextDate}';

    var rescolumnLayout = [
        {dataField: "rnum",            headerText :"<spring:message code='log.head.rownum'/>",                    width:120,    height:30,   visible:false},
        {dataField: "delyno",          headerText :"<spring:message code='log.head.deliveryno'/>",                 width:160,    height:30},
        {dataField: "rcvloc",           headerText :"<spring:message code='log.head.fromlocation'/>",              width:120,    height:30,    visible:false},
        {dataField: "rcvlocnm",       headerText :"<spring:message code='log.head.fromlocation'/>",              width:120,    height:30,    visible:false},
        {dataField: "rcvlocdesc",     headerText :"<spring:message code='log.head.fromlocation'/>",              width:120,    height:30},
        {dataField: "reqloc",           headerText :"<spring:message code='log.head.tolocation'/>",                  width:120,    height:30,    visible:false},
        {dataField: "reqlocnm",       headerText :"<spring:message code='log.head.tolocation'/>",                  width:120,    height:30,    visible:false},
        {dataField: "reqlocdesc",     headerText :"<spring:message code='log.head.tolocation'/>",                  width:120,    height:30},
        {dataField: "delydt",           headerText :"<spring:message code='log.head.deliverydate'/>",                width:120,    height:30},
        {dataField: "gidt",              headerText :"<spring:message code='log.head.gidate'/>",                        width:120,    height:30},
        {dataField: "grdt",              headerText :"<spring:message code='log.head.grdate'/>",                       width:120,     height:30},
        {dataField: "itmcd",            headerText :"<spring:message code='log.head.matcode'/>",                    width:100,     height:30},
        {dataField: "itmname",        headerText :"Mat. Name",                                                                   width:280,     height:30, style:"aui-grid-user-custom-left"},
        {dataField: "delyqty",          headerText :"<spring:message code='log.head.deliveredqty'/>",               width:120,     height:30
            , style:"aui-grid-user-custom-right"
            , dataType:"numeric"
            , formatString:"#,##0"
            , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField){
                if(item.serialchk == "Y" && item.serialReqYn == "Y") {
                    return "aui-grid-link-renderer1";
                }
                return "aui-grid-column-right";
            }
        },
        {dataField: "rciptqty",          headerText :"<spring:message code='log.head.grqty'/>",                        width:120,     height:30
            , style:"aui-grid-user-custom-right"
            , dataType:"numeric"
            , formatString:"#,##0"
        },
        {dataField: "docno",            headerText :"<spring:message code='log.head.refdocno'/>",                   width:120,     height:30},
        {dataField: "uom",               headerText :"<spring:message code='log.head.unitofmeasure'/>",            width:120,     height:30,    visible:false},
        {dataField: "uomnm",           headerText :"UOM",                                                                          width:120,     height:30},
        {dataField: "reqstno",           headerText :"STO No.",                                                                      width:120,     height:30},
        {dataField: "ttype",              headerText :"<spring:message code='log.head.transactiontype'/>",           width:120,     height:30,    visible:false},
        {dataField: "ttext",               headerText :"Trans. Type",                                                                  width:120,     height:30},
        {dataField: "mtype",             headerText :"<spring:message code='log.head.movementtype'/>",          width:120,      height:30,    visible:false},
        {dataField: "mtext",              headerText :"Movement Type",                                                           width:120,      height:30},
        {dataField: "grcmplt",           headerText :"<spring:message code='log.head.grcomplet'/>",                  width:120,      height:30,    visible:false},
        {dataField: "serialReqYn",      headerText :"Serial Chk",                                                                     width:100},
        {dataField: "serialchk",          headerText:"serialchk",                                                                        width:0},
        {dataField: "delvryNoItm",          headerText:"delvry_no_itm",                                                                        width:0,visible:false},
        {dataField: "whLocBrnchId",          headerText:"whLocBrnchId",                                                                        width:0,visible:false}
    ];

    var resop = {
        rowIdField : "rnum",
        editable : false,
        //groupingFields : ["delyno"],
        displayTreeOpen : false,
        showRowCheckColumn : true ,
        showStateColumn : false,
        showBranchOnGrouping : false
    };

    $(document).ready(function() {

        /**********************************
        * Header Setting
        **********************************/
        paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , Codeval:'US'};
       // doGetComboData('/common/selectCodeList.do', paramdata, '','sttype', 'S' , 'f_change');
        doGetComboData('/common/selectCodeList.do', paramdata, ('${searchVal.sttype}'==''?'US':'${searchVal.sttype}'),'sttype', 'S' , 'f_change');
        doGetCombo('/logistics/stocktransfer/selectStockTransferNo.do', '{groupCode:delivery}' , '','seldelno', 'S' , '');
    //     doGetCombo('/common/selectStockLocationList.do', '', '','tlocation', 'S' , '');
    //     doGetCombo('/common/selectStockLocationList.do', '', '','flocation', 'S' , 'SearchListAjax');
        //doDefCombo(amdata, '' ,'sam', 'S', '');

        /**********************************
         * Header Setting End
         ***********************************/
        listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);

        AUIGrid.bind(listGrid, "rowCheckClick", function( event ) {
            var delno = AUIGrid.getCellValue(listGrid, event.rowIndex, "delyno");
            var serialchk = AUIGrid.getCellValue(listGrid, event.rowIndex, "serialReqYn");
            var isSerialChkY = false;

            if (AUIGrid.isCheckedRowById(listGrid, event.item.rnum)) {
                // 현제 선택되어있는 것이 serialchk == Y 인 경우.
                var checkedItems = AUIGrid.getCheckedRowItems(listGrid);

                if(checkedItems.length > 0) {
                    for(var i=0, len = checkedItems.length; i<len; i++) {
                        var rowItem = checkedItems[i];
                        if(rowItem.item.serialchk == 'Y') {
                            isSerialChkY = true;
                            break;
                        }
                    }
                }

                // serialchk == Y 인 경우.
                if(serialchk == 'Y' || isSerialChkY) {
                    AUIGrid.setCheckedRowsByValue(listGrid, "delyno", delno);
                } else {
                    AUIGrid.addCheckedRowsByValue(listGrid, "delyno" , delno);
                }
            } else {
                // 행아이템의 delyno 필드 중 delyno가 같은 row는 모두 체크 해제함
                AUIGrid.addUncheckedRowsByValue(listGrid, "delyno" , delno);
            }
        });

        AUIGrid.bind(listGrid, "cellClick", function( event ) {
            var dataField = AUIGrid.getDataFieldByColumnIndex(listGrid, event.columnIndex);

            if(dataField == "delyqty"){
                var rowIndex = event.rowIndex;
                var serialchk = AUIGrid.getCellValue(listGrid, rowIndex, "serialchk");
                var serialReqYn = AUIGrid.getCellValue(listGrid, rowIndex, "serialReqYn");

                if(serialchk == "Y" && serialReqYn == "Y") {
                    $("#pDeliveryNo").val(AUIGrid.getCellValue(listGrid, rowIndex, "delyno"));
                    $("#pDeliveryItem").val(AUIGrid.getCellValue(listGrid, rowIndex, "delvryNoItm"));
                    $("#pStatus").val("O");

                    fn_scanSearchPop();
                }
            }
        });

        $("#crtsdt").val(toDay);
        $("#crtedt").val(nextDate);
    });

    function f_change() {
        paramdata = { groupCode : '308' , orderValue : 'CODE_ID' , likeValue:$("#sttype").val() , codeIn:'US03,US93'};
        doGetComboData('/common/selectCodeList.do', paramdata, '','smtype', 'S' , '');
    }

    function fn_isSurveyRequired() {
        Common.ajax("GET", "/logistics/survey/isSurveyRequired.do", '', function(result) {
            if(result.data.verifySurveyStus == 0 && result.data.surveyTypeId > 0) {
                fn_goSurveyForm(result.data.surveyTypeId);//Put survey ID here.
            }
        });
    }

    function fn_goSurveyForm(surveyTypeId) {
        Common.popupDiv("/logistics/survey/surveyForm.do", {"surveyTypeId":surveyTypeId,"inWeb":"1"}, null, false, '_surveyPop');
    }

    //btn clickevent
    $(function() {
        $('#search').click(function() {
            if(validation()) {
                SearchListAjax();
            }
        });
        $('#clear').click(function() {
            $('#seldelno').val('');
            $('#tlocationnm').val('');
            $('#flocationnm').val('');
            $('#crtsdt').val('');
            $('#crtedt').val('');
            $('#reqsdt').val('');
            $('#reqedt').val('');
            $('#sstatus').val('');
            $('#sam').val('');
            $('#refdocno').val('');

            paramdata = {groupCode : '308' , orderValue : 'CODE_ID' , likeValue:$("#sttype").val() , codeIn:'US03,US93'};
            doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}','smtype', 'S' , '');
        });

        $("#sttype").change(function() {
            paramdata = {groupCode : '308' , orderValue : 'CODE_ID' , likeValue:$("#sttype").val() , codeIn:'US03,US93'};
            doGetComboData('/common/selectCodeList.do', paramdata, '','smtype', 'S' , '');
        });

        $("#download").click(function() {
            GridCommon.exportTo("main_grid_wrap", "xlsx", "Transfer In");
        });

        $("#gissue").click(function() {
            var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
            console.log(checkedItems);

            // 현제 선택되어있는 것이 serialchk == Y 인 경우.

            if(checkedItems.length > 0) {
            var serialchk = checkedItems[0].serialReqYn
            }

           //console.log("userroleId : " + "${SESSION_INFO.roleId}");
           //console.log("userBranchId : " + "${SESSION_INFO.userBranchId}");
           //console.log("whBranchId : " + checkedItems[0].whLocBrnchId);
           //console.log("adminCheck : " + checkedItems[0].admincheck);

            var arrDelyNo = new Array();
            var arrDelyNoIdx = 0;
            if(checkedItems.length < 1 || checkedItems == undefined) {
                Common.alert('No data selected.');
                return false;
            } else if(("${SESSION_INFO.roleId}" == "256" && ("${SESSION_INFO.userBranchId}" != checkedItems[0].whLocBrnchId)) ||(checkedItems[0].admincheck  == "N" && "${SESSION_INFO.roleId}" == "256")) {
            	Common.alert('GR location under Cody.' +"<br>"+' Not allow to proceed.');
                return false;
                } else {
		                for (var i = 0 ; i < checkedItems.length ; i++) {
		                    if(checkedItems[i].grcmplt == 'Y') {
		                        Common.alert('Already processed.');
		                        return false;
		                        break;
		                    }
		                    if(arrDelyNo.indexOf(checkedItems[i].delyno) == -1) {
		                        arrDelyNo[arrDelyNoIdx] = checkedItems[i].delyno;
		                        ++arrDelyNoIdx;
		                    }
		                }
		            }

            if(serialchk == 'N') {   // 시리얼 N인 경우 - 기존logic 호출
                doSysdate(0 , 'giptdate');
                doSysdate(0 , 'gipfdate');
                $("#gropenwindow").show();

            } else { // 신규logic 호출
                $("#zDelyno").val(arrDelyNo);
                $("#zReqloc").val(checkedItems[0].reqloc);
                $("#zRcvloc").val(checkedItems[0].rcvloc);

                if(Common.checkPlatformType() == "mobile") {
                    popupObj = Common.popupWin("frmNew", "/logistics/stocktransfer/goodReceiptPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
                } else{
                    Common.popupDiv("/logistics/stocktransfer/goodReceiptPop.do", null, null, true, '_divStoIssuePop');
                }
            }
        });
        /*
        $("#receiptcancel").click(function(){
            var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);

            if(checkedItems.length <= 0) {
                Common.alert('No data selected.');
                return false;
            }else{
                for (var i = 0 ; i < checkedItems.length ; i++){

                    if(checkedItems[i].grcmplt == 'N'){
                        Common.alert('Can not cancel before wearing.');
                        return false;
                        break;
                    }
                }
                document.grForm.gtype.value="RC";
                doSysdate(0 , 'giptdate');
                doSysdate(0 , 'gipfdate');
                $("#dataTitle").text("Receipt Cancel Posting Data");
                $("#gropenwindow").show();
            }
        });
        */
        $("#tlocationnm").keypress(function(event) {
            $('#tlocation').val('');
            if (event.which == '13') {
                $("#stype").val('tlocation');
                $("#svalue").val($('#tlocationnm').val());
                $("#sUrl").val("/logistics/organization/locationCdSearch.do");

                Common.searchpopupWin("searchForm", "/common/searchPopList.do","location");
            }
        });
        $("#flocationnm").keypress(function(event) {
            $('#flocation').val('');
            if (event.which == '13') {
                $("#stype").val('flocation');
                $("#svalue").val($('#flocationnm').val());
                $("#sUrl").val("/logistics/organization/locationCdSearch.do");

                Common.searchpopupWin("searchForm", "/common/searchPopList.do","location");
            }
        });
        $("#print").click(function() {
            var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);

            if(checkedItems.length <= 0) {
                Common.alert('No data selected.');
                return false;
    //         }else if(checkedItems.length > 1) {
    //             Common.alert('Please One data selected.');
    //             return false;
            } else if(checkedItems.length == 1 ) {
                var itm = checkedItems[0];
                $("#V_DELVRYNO").val(itm.delyno);
                Common.report("printForm");
            } else {
                var tmpno = checkedItems[0].delyno;
                var delbool = true;
                for (var i = 0 ; i < checkedItems.length ; i++ ) {
                    var itm = checkedItems[i];
                    if (tmpno != itm.delyno) {
                        delbool = false;
                        break;
                    }
                }

                if (delbool) {
                    $("#V_DELVRYNO").val(tmpno);
                    Common.report("printForm");
                } else {
                    Common.alert('Only the same [Delivery No] is possible.');
                    return false;
                }
             }
         });
    });

    function fn_PopStoIssueClose(){
        if(popupObj!=null) popupObj.close();
    }

    function fn_itempopList(data){
        var rtnVal = data[0].item;

        if ($("#stype").val() == "flocation" ) {
            $("#flocation").val(rtnVal.locid);
            $("#flocationnm").val(rtnVal.locdesc);
        } else {
            $("#tlocation").val(rtnVal.locid);
            $("#tlocationnm").val(rtnVal.locdesc);
        }
        $("#svalue").val();
    }

    function validation() {
        if($("#crtsdt").val() == "" || ($("#crtedt").val() == "")) {
            Common.alert('Please enter Dlvd.Req.Date');
            return false;
        } else {
            return true;
        }
    }

    function SearchListAjax() {
        if ($("#flocationnm").val() == "") {
            $("#flocation").val('');
        }
        if ($("#tlocationnm").val() == "") {
            $("#tlocation").val('');
        }
        if ($("#flocation").val() == "") {
            $("#flocation").val($("#flocationnm").val());
        }
        if ($("#tlocation").val() == ""){
            $("#tlocation").val($("#tlocationnm").val());
        }

        // 초기화
        AUIGrid.setGridData(listGrid, []);

        Common.ajax("POST", "/logistics/stocktransfer/StocktransferSearchDeliveryList.do", $('#searchForm').serializeJSON(), function(data){
            AUIGrid.setGridData(listGrid, data.data);
        });
    }

    function f_getTtype(g , v) {
        var rData = new Array();
        $.ajax({
            type : "GET",
            url : "/common/selectCodeList.do",
            data : {groupCode : g, orderValue : 'CRT_DT', likeValue:v},
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            async : false,
            success : function(data) {
                $.each(data, function(index, value) {
                      var list = new Object();

                      list.code = data[index].code;
                      list.codeId = data[index].codeId;
                      list.codeName = data[index].codeName;
                      rData.push(list);
                });
            },
            error: function(jqXHR, textStatus, errorThrown){
                Common.alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
            },
                complete: function(){
            }
        });
        return rData;
    }

    // 유효성 체크
    function fn_saveVaild() {
        if ($("#sGiptdate").val() == "") {
            Common.alert("Please select the GI Posting Date.");
            return false;
        }
        if ($("#sGiptdate").val() < toDay) {
            Common.alert("Cannot select back date.");
            return false;
        }
        if ($("#sGiptdate").val() > toDay) {
            Common.alert("Cannot select future date.");
            return false;
        }

        if ($("#sGipfdate").val() == "") {
          Common.alert("Please select the GI Doc Date.");
          return false;
        }
        if ($("#sGipfdate").val() < toDay) {
            Common.alert("Cannot select back date.");
            return false;
        }
        if ($("#sGipfdate").val() > toDay) {
            Common.alert("Cannot select future date.");
            return false;
        }

        return true;
    }

    function grFunc() {
        if(!fn_saveVaild()) return;

        var data = {};
        var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
        var check = AUIGrid.getCheckedRowItems(listGrid);

        for (var i = 0 ; i < checkdata.length ; i++) {
            if (checkdata[i].delydt == "" || checkdata[i].delydt == null){
                Common.alert("Please check the Delivery Date.")
                return false;
            }
        }
        data.check = check;
        data.checked = check;
        data.form = $("#grForm").serializeJSON();

        Common.ajax("POST", "/logistics/stocktransfer/StocktransferGRGoodIssue.do", data, function(result) {
            var message =result.message;

            if("Already processed."== message) {
                Common.alert(result.message);
            } else {
                Common.alert(result.message + "<br/>MDN NO : " + result.data );
                //fn_isSurveyRequired();
            }
            $("#giptdate").val("");
            $("#gipfdate").val("");
            $("#doctext" ).val("");
            $("#gropenwindow").hide();

            $('#search').click();

        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });
    }

    // Serial Search Pop
    function fn_scanSearchPop(){
        if(Common.checkPlatformType() == "mobile") {
            popupObj = Common.popupWin("frmNew", "/logistics/SerialMgmt/scanSearchPop.do", {width : "1000px", height : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        } else{
            Common.popupDiv("/logistics/SerialMgmt/scanSearchPop.do", $("#frmNew").serializeJSON(), null, true, '_scanSearchPop');
        }
    }

</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>logistics</li>
        <li>Transfer-In</li>
    </ul>
    <!-- title_line start -->
    <aside class="title_line">
    <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
    <h2>Transfer-In</h2>
    </aside>
    <!-- title_line end -->
    <!-- title_line start -->
    <aside class="title_line">
        <h3>Header Info</h3>
        <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
        </c:if>
            <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->
    <!-- search_table start -->
    <section class="search_table">
        <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
            <input type="hidden" name="gtype"   id="gtype"  value="receipt" />
            <input type="hidden" name="rStcode" id="rStcode" />
            <input type="hidden" id="svalue" name="svalue"/>
            <input type="hidden" id="sUrl"   name="sUrl"  />
            <input type="hidden" id="stype"  name="stype" />
            <table summary="search table" class="type1"><!-- table start -->
                <caption>search table</caption>
                <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:160px" />
                    <col style="width:*" />
                    <col style="width:160px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Delivery Number</th>
                        <td>
                            <!-- <select class="w100p" id="seldelno" name="seldelno"></select> -->
                             <input type="text" class="w100p" id="seldelno" name="seldelno">
                        </td>
                        <th scope="row">Transfer Type</th>
                        <td>
                            <select class="w100p" id="sttype" name="sttype"></select>
                        </td>
                        <th scope="row">Movement Type</th>
                        <td>
                            <select class="w100p" id="smtype" name="smtype"><option value=''>Choose One</option></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Status</th>
                        <td>
                            <select  id="instatus" name="instatus" class="w100p" >
                                <option value ="" selected>All</option>
                                <option value = "Y">Complete</option>
                                <option value="N"> Open</option>
                            </select>
                        </td>
                        <th scope="row">Ref Doc.No </th>
                        <td>
                            <input type="text" class="w100p" id="refdocno" name="refdocno">
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Dlvd.Req.Date</th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                            <p><input id="crtsdt" name="crtsdt" type="text" title="Create Start Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                            <span> To </span>
                            <p><input id="crtedt" name="crtedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
                            </div><!-- date_set end -->
                        </td>
                        <th scope="row">GI Date</th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                            <p><input id="reqsdt" name="reqsdt" type="text" title="GI Start Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                            <span> To </span>
                            <p><input id="reqedt" name="reqedt" type="text" title="GI End Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                            </div><!-- date_set end -->
                        </td>
                        <th scope="row">GR Date</th>
                        <td >
                            <div class="date_set w100p"><!-- date_set start -->
                            <p><input id="rcivsdt" name="rcivsdt" type="text" title="GR Start Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                            <span> To </span>
                            <p><input id="rcivedt" name="rcivedt" type="text" title="GR End Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                            </div><!-- date_set end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">From Location</th>
                        <td colspan="2">
                            <input type="hidden"  id="tlocation" name="tlocation">
                            <input type="text" class="w100p" id="tlocationnm" name="tlocationnm">
                        </td>
                        <th scope="row">To Location</th>
                        <td colspan="2">
                            <input type="hidden"  id="flocation" name="flocation">
                            <input type="text" class="w100p" id="flocationnm" name="flocationnm">
                        </td>
                   </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    </section>
    <!-- search_table end -->
    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
        </c:if >
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
            <li><p class="btn_grid"><a id="gissue">Good Receipt</a></p></li>
        </c:if >
<!--             <li><p class="btn_grid"><a id="receiptcancel">Receipt Cancel</a></p></li> -->
            <li><p class="btn_grid"><a id="print"><spring:message code='sys.progmanagement.grid1.PRINT' /></a></p></li>
        </ul>
        <!--  Grid -->
        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="main_grid_wrap" style="width:100%; height:480px; margin:0 auto;" class="autoGridHeight"></div>
        </article><!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
    <form id="frmNew" name="frmNew" action="#" method="post">
        <input type="hidden" name="zDelyno" id="zDelyno" />
        <input type="hidden" name="zReqloc" id="zReqloc" />
        <input type="hidden" name="zRcvloc" id="zRcvloc" />
        <input type="hidden" name="pDeliveryNo" id="pDeliveryNo" />
        <input type="hidden" name="pDeliveryItem" id="pDeliveryItem" />
        <input type="hidden" name="pStatus" id="pStatus" />
        <input type="hidden" name="searchId" id="searchId" value="search" />
    </form>
    <div class="popup_wrap" id="gropenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1 id="dataTitle">Good Receipt Posting Data</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->

        <section class="pop_body"><!-- pop_body start -->
            <form id="grForm" name="grForm" method="POST">
                <input type="hidden" name="gtype" id="gtype" value="GR">
                <input type="hidden" name="prgnm"  id="prgnm" value="${param.CURRENT_MENU_CODE}"/>
                <table class="type1">
                    <caption>search table</caption>
                    <colgroup>
                        <col style="width:150px" />
                        <col style="width:*" />
                        <col style="width:150px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">GR Posting Date</th>
                            <td ><input id="giptdate" name="giptdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
                            <th scope="row">GR Doc Date</th>
                            <td ><input id="gipfdate" name="gipfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>
                        </tr>
                        <tr>
                            <th scope="row">Header Text</th>
                            <td colspan='3'><input type="text" name="doctext" id="doctext" class="w100p" maxlength="50"/></td>
                        </tr>
                    </tbody>
                </table>
                <ul class="center_btns">
                    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
                      <li><p class="btn_blue2 big"><a onclick="javascript:grFunc();">SAVE</a></p></li>
                    </c:if>
                </ul>
            </form>

        </section>
    </div>
    <form id="printForm" name="printForm">
       <input type="hidden" id="viewType" name="viewType" value="PDF" />
       <input type="hidden" id="V_DELVRYNO" name="V_DELVRYNO" value="" />
       <input type="hidden" id="reportFileName" name="reportFileName" value="/logistics/Delivery_Note_for_GR.rpt" /><br />
    </form>

</section>

